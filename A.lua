repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
	LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
end

local UI = {
	BG = Color3.fromRGB(14, 12, 26),
	CARD = Color3.fromRGB(24, 20, 44),
	BTN = Color3.fromRGB(38, 34, 68),
	BTN_ACTIVE = Color3.fromRGB(34, 175, 110),
	ACCENT = Color3.fromRGB(215, 45, 85),
	BEST_BTN = Color3.fromRGB(142, 66, 255),
	BLOCK_BTN = Color3.fromRGB(175, 45, 115),
	ESP_COLOR = Color3.fromRGB(64, 215, 255),
	BAR_FILL = Color3.fromRGB(168, 72, 255),
	BAR_DONE = Color3.fromRGB(48, 224, 135),
	SELF_TAG = Color3.fromRGB(255, 220, 115),
	TEXT = Color3.fromRGB(248, 248, 255),
	MUTED = Color3.fromRGB(190, 184, 232),
	STROKE = Color3.fromRGB(130, 88, 255),
	GRAD_A = Color3.fromRGB(24, 16, 48),
	GRAD_B = Color3.fromRGB(12, 24, 46),
}

-- Explicitly excludes "control"
local ADMIN_COMMANDS = {
	"rocket",
	"balloon",
	"nightvision",
	"jumpscare",
	"ragdoll",
	"inverse",
	"jail",
	"tiny",
	"morph",
}

local AP_STEP_DELAY = 0.09

-- Ultra-fast Auto Steal default (0.08s hold) with settings presets available
local autoGrabConfig = {
	AutoStealEnabled = true,
	Mode = "normal",
	StealRadius = 32,
	StealDuration = 0.08,
	Data = {},
}

local FLY_SPEED = 72
local ARRIVAL_DISTANCE = 4.5

local selectedTarget = LocalPlayer
local dragLockEnabled = false
local playerEspEnabled = false
local bestFlyActive = false
local bestFlyTargetPos: Vector3? = nil
local isStealBusy = false
local isApRunning = false
local activeHeldPrompt: ProximityPrompt? = nil
local lastEspRefreshClock = 0
local lastRemoteFireClock = 0

_G.StealProgress = 0
_G.AutoSteal = autoGrabConfig

local avatarCache: { [number]: string } = {}
local playerEspObjects: { [Player]: { highlight: Highlight?, tag: BillboardGui? } } = {}

local function addCoolBackgroundGradient(gui: GuiObject, c1: Color3?, c2: Color3?, angle: number?)
	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, c1 or UI.GRAD_A),
		ColorSequenceKeypoint.new(1, c2 or UI.GRAD_B),
	})
	grad.Rotation = angle or 135
	grad.Parent = gui
	return grad
end

local function makeReadableText(lbl: TextLabel | TextButton, minSz: number, maxSz: number)
	lbl.TextScaled = true
	lbl.TextWrapped = false
	local c = Instance.new("UITextSizeConstraint")
	c.MinTextSize = minSz
	c.MaxTextSize = maxSz
	c.Parent = lbl
end

local function getMountParent()
	if type(gethui) == "function" then
		local ok, hui = pcall(gethui)
		if ok and typeof(hui) == "Instance" then
			return hui
		end
	end
	local okCore, core = pcall(function()
		return CoreGui
	end)
	if okCore and typeof(core) == "Instance" then
		return core
	end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local MountParent = getMountParent()

pcall(function()
	for _, name in ipairs({ "SAB_Compact_UI", "SAB_Grab_Standalone" }) do
		local existing = MountParent:FindFirstChild(name)
		if existing then
			existing:Destroy()
		end
	end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SAB_Compact_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not pcall(function()
	ScreenGui.Parent = MountParent
end) then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local GrabGui = Instance.new("ScreenGui")
GrabGui.Name = "SAB_Grab_Standalone"
GrabGui.ResetOnSpawn = false
GrabGui.IgnoreGuiInset = true
GrabGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not pcall(function()
	GrabGui.Parent = MountParent
end) then
	GrabGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local Toast = Instance.new("TextLabel")
Toast.Size = UDim2.new(0, 210, 0, 18)
Toast.AnchorPoint = Vector2.new(0.5, 0)
Toast.Position = UDim2.new(0.5, 0, 0.12, 0)
Toast.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Toast.TextColor3 = Color3.fromRGB(150, 255, 195)
Toast.Text = "Ready"
Toast.Font = Enum.Font.GothamBold
Toast.Visible = false
Toast.ZIndex = 95
Toast.Parent = ScreenGui
Instance.new("UICorner", Toast).CornerRadius = UDim.new(0, 5)
addCoolBackgroundGradient(Toast, Color3.fromRGB(32, 18, 68), Color3.fromRGB(14, 34, 62), 90)
makeReadableText(Toast, 7, 10)
local toastStroke = Instance.new("UIStroke")
toastStroke.Color = UI.STROKE
toastStroke.Thickness = 1
toastStroke.Parent = Toast

local toastId = 0
local function notify(text: string, okStatus: boolean?)
	toastId += 1
	local current = toastId
	Toast.Text = text
	Toast.TextColor3 = if okStatus == false then Color3.fromRGB(255, 130, 145) else Color3.fromRGB(150, 255, 195)
	Toast.Visible = true
	task.delay(1.1, function()
		if toastId == current and Toast.Parent then
			Toast.Visible = false
		end
	end)
end

local function applyAvatarThumbnail(imgLabel: ImageLabel, userId: number)
	if avatarCache[userId] then
		imgLabel.Image = avatarCache[userId]
		return
	end
	task.spawn(function()
		local ok, content = pcall(function()
			return Players:GetUserThumbnailAsync(
				userId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size48x48
			)
		end)
		if ok and type(content) == "string" and #content > 0 then
			avatarCache[userId] = content
			if imgLabel and imgLabel.Parent then
				imgLabel.Image = content
			end
		end
	end)
end

local function isSafeRemote(inst: Instance): boolean
	if not (inst:IsA("RemoteEvent") or inst:IsA("UnreliableRemoteEvent")) then
		return false
	end
	local low = string.lower(inst.Name)
	if string.find(low, "teleport", 1, true)
		or string.find(low, "plaza", 1, true)
		or string.find(low, "trade", 1, true)
		or string.find(low, "lobby", 1, true)
		or string.find(low, "join", 1, true)
		or string.find(low, "menu", 1, true)
		or string.find(low, "server", 1, true)
		or string.find(low, "kick", 1, true)
		or string.find(low, "ban", 1, true)
	then
		return false
	end
	return true
end

local function getActionRemotes(): { Instance }
	local list = {}
	local count = 0
	for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
		count += 1
		if count > 900 then
			break
		end
		if isSafeRemote(obj) then
			table.insert(list, obj)
		end
	end
	return list
end

local sayMessageRemote: RemoteEvent? = nil
local function getLegacySayRemote(): RemoteEvent?
	if sayMessageRemote and sayMessageRemote.Parent then
		return sayMessageRemote
	end
	pcall(function()
		local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
		local say = chatEvents and chatEvents:FindFirstChild("SayMessageRequest")
		if say and say:IsA("RemoteEvent") then
			sayMessageRemote = say
		end
	end)
	return sayMessageRemote
end

local function sendFastChat(msg: string)
	pcall(function()
		local channels = TextChatService:FindFirstChild("TextChannels")
		local general = channels and channels:FindFirstChild("RBXGeneral")
		if general and general:IsA("TextChannel") then
			general:SendAsync(msg)
		end
	end)
	local legacySay = getLegacySayRemote()
	if legacySay then
		pcall(function()
			legacySay:FireServer(msg, "All")
		end)
	end
end

local function applyLocalCommandFeedback(cmd: string)
	if cmd == "control" then
		return
	end
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not char or not hum or hum.Health <= 0 then
		return
	end

	pcall(function()
		if cmd == "rocket" and root and root:IsA("BasePart") then
			root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 65, root.AssemblyLinearVelocity.Z)
		elseif cmd == "balloon" then
			local head = char:FindFirstChild("Head")
			if head and head:IsA("BasePart") then
				head.Size = Vector3.new(
					math.min(head.Size.X * 1.25, 4),
					math.min(head.Size.Y * 1.25, 4),
					math.min(head.Size.Z * 1.25, 4)
				)
			end
		elseif cmd == "nightvision" then
			Lighting.ClockTime = 14
			Lighting.Brightness = 2
		end
	end)
end

local function runApPaced(targetPlr: Player?)
	if isApRunning then
		return
	end
	if not targetPlr or not targetPlr.Parent then
		notify("Select a target player first", false)
		return
	end

	isApRunning = true
	task.spawn(function()
		if targetPlr == LocalPlayer then
			for _, cmd in ipairs(ADMIN_COMMANDS) do
				if cmd ~= "control" then
					applyLocalCommandFeedback(cmd)
				end
			end
		end

		for _, cmd in ipairs(ADMIN_COMMANDS) do
			if cmd ~= "control" then
				sendFastChat(";" .. cmd .. " " .. targetPlr.Name)
				task.wait(AP_STEP_DELAY)
			end
		end

		local tag = if targetPlr == LocalPlayer then (targetPlr.Name .. " (ME)") else targetPlr.Name
		notify(string.format("AP -> %s", tag), true)
		isApRunning = false
	end)
end

local function promptBlockPlayer(targetPlr: Player?)
	if not targetPlr or not targetPlr.Parent or targetPlr == LocalPlayer then
		notify("Pick another player to block", false)
		return
	end
	local ok = pcall(function()
		StarterGui:SetCore("PromptBlockPlayer", targetPlr)
	end)
	notify(if ok then ("Block prompt: " .. targetPlr.Name) else "Block unavailable", ok)
end

local function isYourBasePlot(plotName: string): boolean
	local plots = workspace:FindFirstChild("Plots")
	if not plots then
		return false
	end
	local plot = plots:FindFirstChild(plotName)
	if not plot then
		return false
	end
	local plotSign = plot:FindFirstChild("PlotSign")
	if plotSign then
		local yourBase = plotSign:FindFirstChild("YourBase")
		if yourBase and yourBase:IsA("BillboardGui") then
			return yourBase.Enabled == true
		end
	end
	return false
end

local function getInstanceWorldPos(obj: Instance?): Vector3?
	if not obj then
		return nil
	end
	if obj:IsA("BasePart") then
		return obj.Position
	elseif obj:IsA("Model") then
		return obj:GetPivot().Position
	elseif obj:IsA("Attachment") then
		return obj.WorldPosition
	elseif obj.Parent then
		if obj.Parent:IsA("BasePart") then
			return obj.Parent.Position
		elseif obj.Parent:IsA("Model") then
			return obj.Parent:GetPivot().Position
		elseif obj.Parent:IsA("Attachment") then
			return obj.Parent.WorldPosition
		end
	end
	return nil
end

local function parseNumberValue(rawText: string): number
	local cleaned = string.lower(rawText)
	local mult = 1
	if string.find(cleaned, "/s", 1, true) then
		cleaned = string.gsub(cleaned, "/s", "")
	end
	if string.find(cleaned, "dc", 1, true) then
		mult = 1e33
	elseif string.find(cleaned, "oc", 1, true) then
		mult = 1e27
	elseif string.find(cleaned, "sp", 1, true) then
		mult = 1e24
	elseif string.find(cleaned, "sx", 1, true) then
		mult = 1e21
	elseif string.find(cleaned, "qi", 1, true) then
		mult = 1e18
	elseif string.find(cleaned, "qa", 1, true) then
		mult = 1e15
	elseif string.find(cleaned, "t", 1, true) then
		mult = 1e12
	elseif string.find(cleaned, "b", 1, true) then
		mult = 1e9
	elseif string.find(cleaned, "m", 1, true) then
		mult = 1e6
	elseif string.find(cleaned, "k", 1, true) then
		mult = 1e3
	end
	local numStr = string.match(cleaned, "[%d%.]+")
	local n = tonumber(numStr)
	if not n then
		return 0
	end
	return n * mult
end

local function scoreCandidate(container: Instance): number
	local score = 0
	for _, attrName in ipairs({ "Value", "Price", "Cost", "Income", "Rate", "Money", "Cash", "Rarity", "Tier", "Level" }) do
		local attrVal = container:GetAttribute(attrName)
		if type(attrVal) == "number" and attrVal > score then
			score = attrVal
		elseif type(attrVal) == "string" then
			local parsed = parseNumberValue(attrVal)
			if parsed > score then
				score = parsed
			end
		end
	end
	for _, desc in ipairs(container:GetDescendants()) do
		if desc:IsA("TextLabel") or desc:IsA("TextButton") then
			local parsed = parseNumberValue(desc.Text)
			if parsed > score then
				score = parsed
			end
		elseif desc:IsA("NumberValue") or desc:IsA("IntValue") then
			if desc.Value > score then
				score = desc.Value
			end
		end
	end
	return score
end

local function findBestBrainrotTarget(): (Vector3?, string?)
	local bestPos: Vector3? = nil
	local bestName: string? = nil
	local bestScore = -1

	local plots = workspace:FindFirstChild("Plots")
	if plots then
		for _, plot in ipairs(plots:GetChildren()) do
			if plot:IsA("Model") and not isYourBasePlot(plot.Name) then
				local podiums = plot:FindFirstChild("AnimalPodiums")
				if podiums then
					for _, podium in ipairs(podiums:GetChildren()) do
						local pos = getInstanceWorldPos(podium)
						if pos then
							local s = scoreCandidate(podium)
							if s > bestScore then
								bestScore = s
								bestPos = pos
								bestName = podium.Name
							end
						end
					end
				end
			end
		end
	end

	return bestPos, bestName
end

local function stopBestFlight(restoreCharacter: boolean)
	bestFlyActive = false
	bestFlyTargetPos = nil

	if restoreCharacter then
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local root = char and char:FindFirstChild("HumanoidRootPart")
		pcall(function()
			if hum and hum.Health > 0 then
				hum.PlatformStand = false
				hum.AutoRotate = true
				if hum:GetState() == Enum.HumanoidStateType.Physics then
					hum:ChangeState(Enum.HumanoidStateType.GettingUp)
				end
			end
			if root and root:IsA("BasePart") then
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
			end
		end)
	end
end

local function stepBestFlight(dt: number)
	if not bestFlyActive then
		return
	end

	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not char or not hum or not root or not root:IsA("BasePart") or hum.Health <= 0 then
		return
	end

	local refreshedPos = findBestBrainrotTarget()
	if refreshedPos then
		bestFlyTargetPos = refreshedPos
	end

	if not bestFlyTargetPos then
		stopBestFlight(true)
		notify("No brainrot found", false)
		return
	end

	local goalPos = bestFlyTargetPos + Vector3.new(0, 2.2, 0)
	local toGoal = goalPos - root.Position
	local dist = toGoal.Magnitude

	if dist <= ARRIVAL_DISTANCE then
		stopBestFlight(true)
		notify("Arrived!", true)
		return
	end

	local clampedDt = math.clamp(dt, 0.001, 0.05)
	local dir = toGoal.Unit
	local desiredVel = dir * FLY_SPEED
	local yawAngle = math.atan2(-dir.X, -dir.Z)
	local uprightCFrame = CFrame.new(root.Position) * CFrame.Angles(0, yawAngle, 0)

	pcall(function()
		hum.PlatformStand = false
		hum.AutoRotate = false
		root.AssemblyLinearVelocity = desiredVel
		root.AssemblyAngularVelocity = Vector3.zero
		root.CFrame = root.CFrame:Lerp(uprightCFrame, math.min(1, clampedDt * 14))
	end)
end

local GrabBarFill: Frame
local GrabPercentLbl: TextLabel

local function setGrabProgress01(val01: number)
	local clamped = math.clamp(val01, 0, 1)
	_G.StealProgress = clamped
	local pct = math.floor(clamped * 100)
	if GrabBarFill then
		GrabBarFill.Size = UDim2.new(clamped, 0, 1, 0)
		GrabBarFill.BackgroundColor3 = if pct >= 100 then UI.BAR_DONE else UI.BAR_FILL
	end
	if GrabPercentLbl then
		GrabPercentLbl.Text = string.format("%d%%", pct)
	end
end

local function isStealPrompt(prompt: ProximityPrompt): boolean
	if not prompt.Enabled then
		return false
	end
	local parentName = if prompt.Parent then prompt.Parent.Name else ""
	local grandParentName = if prompt.Parent and prompt.Parent.Parent then prompt.Parent.Parent.Name else ""
	local blob = string.lower(
		prompt.Name .. " " .. prompt.ActionText .. " " .. prompt.ObjectText .. " " .. parentName .. " " .. grandParentName
	)
	if string.find(blob, "lock", 1, true)
		or string.find(blob, "unlock", 1, true)
		or string.find(blob, "buy", 1, true)
		or string.find(blob, "shop", 1, true)
		or string.find(blob, "door", 1, true)
	then
		return false
	end
	return string.find(blob, "steal", 1, true) ~= nil
end

local function findNearestStealPrompt(originPos: Vector3): ProximityPrompt?
	local maxRadius = autoGrabConfig.StealRadius
	local bestPrompt: ProximityPrompt? = nil
	local bestDist = maxRadius

	local plots = workspace:FindFirstChild("Plots")
	if plots then
		for _, plot in ipairs(plots:GetChildren()) do
			if plot:IsA("Model") and not isYourBasePlot(plot.Name) then
				local podiums = plot:FindFirstChild("AnimalPodiums")
				if podiums then
					for _, podium in ipairs(podiums:GetChildren()) do
						local base = podium:FindFirstChild("Base")
						local spawnPart = base and base:FindFirstChild("Spawn")
						if spawnPart and spawnPart:IsA("BasePart") then
							local dist = (spawnPart.Position - originPos).Magnitude
							if dist <= bestDist then
								local promptAttachment = spawnPart:FindFirstChild("PromptAttachment")
								local found: ProximityPrompt? = nil
								if promptAttachment then
									for _, child in ipairs(promptAttachment:GetChildren()) do
										if child:IsA("ProximityPrompt") and isStealPrompt(child) then
											found = child
										end
									end
								end
								if not found then
									for _, desc in ipairs(spawnPart:GetDescendants()) do
										if desc:IsA("ProximityPrompt") and isStealPrompt(desc) then
											found = desc
										end
									end
								end
								if found then
									bestDist = dist
									bestPrompt = found
								end
							end
						end
					end
				end
			end
		end
	end

	if not bestPrompt then
		local scanned = 0
		for _, desc in ipairs(workspace:GetDescendants()) do
			scanned += 1
			if scanned > 900 then
				break
			end
			if desc:IsA("ProximityPrompt") and isStealPrompt(desc) then
				local p = getInstanceWorldPos(desc)
				if p then
					local d = (p - originPos).Magnitude
					if d <= bestDist then
						bestDist = d
						bestPrompt = desc
					end
				end
			end
		end
	end

	return bestPrompt
end

local function releasePromptHold()
	if activeHeldPrompt then
		local prev = activeHeldPrompt
		activeHeldPrompt = nil
		pcall(function()
			prev:InputHoldEnd()
		end)
	end
end

local function holdStealPrompt(prompt: ProximityPrompt)
	if activeHeldPrompt and activeHeldPrompt ~= prompt then
		local oldP = activeHeldPrompt
		pcall(function()
			oldP:InputHoldEnd()
		end)
	end
	activeHeldPrompt = prompt
	pcall(function()
		prompt:InputHoldBegin()
	end)
end

local function runUltraFastGrabSequence(prompt: ProximityPrompt)
	if isStealBusy then
		return
	end
	if not autoGrabConfig.Data[prompt] then
		autoGrabConfig.Data[prompt] = { hold = {}, trigger = {}, ready = true }
		if type(getconnections) == "function" then
			for _, conn in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
				if conn.Function then
					table.insert(autoGrabConfig.Data[prompt].hold, conn.Function)
				end
			end
			for _, conn in ipairs(getconnections(prompt.Triggered)) do
				if conn.Function then
					table.insert(autoGrabConfig.Data[prompt].trigger, conn.Function)
				end
			end
		end
	end

	local entry = autoGrabConfig.Data[prompt]
	if not entry.ready then
		return
	end

	entry.ready = false
	isStealBusy = true
	local startTick = tick()
	local duration = math.max(autoGrabConfig.StealDuration, 0.02)
	setGrabProgress01(0.15)

	task.spawn(function()
		holdStealPrompt(prompt)
		for _, fnHold in ipairs(entry.hold) do
			task.spawn(fnHold)
		end

		while autoGrabConfig.AutoStealEnabled and prompt.Parent do
			local elapsed = tick() - startTick
			setGrabProgress01(math.clamp(0.15 + (elapsed / duration) * 0.85, 0, 1))
			if elapsed >= duration then
				break
			end
			task.wait()
		end

		if autoGrabConfig.AutoStealEnabled and prompt.Parent then
			setGrabProgress01(1)
			for _, fnTrig in ipairs(entry.trigger) do
				task.spawn(fnTrig)
			end
			pcall(function()
				if type(fireproximityprompt) == "function" then
					fireproximityprompt(prompt)
				end
				prompt:InputHoldEnd()
			end)
			activeHeldPrompt = nil

			local now = os.clock()
			if (now - lastRemoteFireClock) >= 0.08 then
				lastRemoteFireClock = now
				for _, rem in ipairs(getActionRemotes()) do
					local low = string.lower(rem.Name)
					if string.find(low, "steal", 1, true) or string.find(low, "grab", 1, true) then
						pcall(function()
							rem:FireServer()
						end)
					end
				end
			end
			task.wait(0.02)
		end

		releasePromptHold()
		setGrabProgress01(0)
		entry.ready = true
		isStealBusy = false
	end)
end

local function clearPlayerEspFor(plr: Player)
	local entry = playerEspObjects[plr]
	if entry then
		pcall(function()
			if entry.highlight then
				entry.highlight:Destroy()
			end
			if entry.tag then
				entry.tag:Destroy()
			end
		end)
		playerEspObjects[plr] = nil
	end
end

local function clearAllEsp()
	for plr in pairs(playerEspObjects) do
		clearPlayerEspFor(plr)
	end
end

local function updatePlayerEsp()
	if not playerEspEnabled then
		return
	end
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local myPos = if root and root:IsA("BasePart") then root.Position else nil

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local pChar = plr.Character
			local pRoot = pChar and pChar:FindFirstChild("HumanoidRootPart")
			local pHead = pChar and pChar:FindFirstChild("Head")

			if pChar and pRoot and pRoot:IsA("BasePart") then
				local entry = playerEspObjects[plr] or {}
				playerEspObjects[plr] = entry

				if not entry.highlight or not entry.highlight.Parent then
					local hl = Instance.new("Highlight")
					hl.Name = "SAB_Player_ESP"
					hl.FillColor = UI.ESP_COLOR
					hl.OutlineColor = UI.TEXT
					hl.FillTransparency = 0.65
					hl.OutlineTransparency = 0
					hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					hl.Adornee = pChar
					hl.Parent = MountParent
					entry.highlight = hl
				else
					entry.highlight.Adornee = pChar
				end

				local adorneePart = if pHead and pHead:IsA("BasePart") then pHead else pRoot
				if not entry.tag or not entry.tag.Parent then
					local bg = Instance.new("BillboardGui")
					bg.Name = "SAB_Player_Tag"
					bg.Size = UDim2.new(0, 96, 0, 16)
					bg.StudsOffset = Vector3.new(0, 2.2, 0)
					bg.AlwaysOnTop = true
					bg.Adornee = adorneePart
					bg.Parent = MountParent

					local lbl = Instance.new("TextLabel")
					lbl.Name = "Label"
					lbl.Size = UDim2.new(1, 0, 1, 0)
					lbl.BackgroundTransparency = 0.25
					lbl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					lbl.TextColor3 = UI.ESP_COLOR
					lbl.Font = Enum.Font.GothamBold
					lbl.Parent = bg
					Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 4)
					addCoolBackgroundGradient(lbl, Color3.fromRGB(24, 16, 48), Color3.fromRGB(14, 34, 62), 90)
					makeReadableText(lbl, 7, 10)

					entry.tag = bg
				else
					entry.tag.Adornee = adorneePart
				end

				local lbl = entry.tag and entry.tag:FindFirstChild("Label")
				if lbl and lbl:IsA("TextLabel") then
					lbl.Text = if myPos
						then string.format("%s [%dm]", plr.Name, math.floor((pRoot.Position - myPos).Magnitude))
						else plr.Name
				end
			else
				clearPlayerEspFor(plr)
			end
		end
	end
end

local function makeDraggable(frame: GuiObject)
	local dragging = false
	local dragStart: Vector3? = nil
	local startPos: UDim2? = nil

	frame.InputBegan:Connect(function(input)
		if dragLockEnabled then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragLockEnabled then
			dragging = false
			return
		end
		if dragging and dragStart and startPos then
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				local delta = input.Position - dragStart
				frame.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false
		end
	end)
end

-- =========================================================================
-- DISCONNECTED AUTO GRAB & SETTINGS WINDOW (FULL WORDS VISIBLE)
-- =========================================================================
local GrabWindow = Instance.new("Frame")
GrabWindow.Name = "StandaloneGrabWindow"
GrabWindow.Size = UDim2.new(0, 162, 0, 46)
GrabWindow.Position = UDim2.new(0.16, 0, 0.03, 0)
GrabWindow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GrabWindow.BorderSizePixel = 0
GrabWindow.ZIndex = 76
GrabWindow.Parent = GrabGui
Instance.new("UICorner", GrabWindow).CornerRadius = UDim.new(0, 6)
addCoolBackgroundGradient(GrabWindow, Color3.fromRGB(36, 16, 72), Color3.fromRGB(16, 28, 56), 120)
local grabStroke = Instance.new("UIStroke")
grabStroke.Color = UI.BAR_FILL
grabStroke.Thickness = 1.2
grabStroke.Parent = GrabWindow
makeDraggable(GrabWindow)

local GrabTitle = Instance.new("TextLabel")
GrabTitle.Size = UDim2.new(0, 74, 0, 14)
GrabTitle.Position = UDim2.new(0, 5, 0, 2)
GrabTitle.BackgroundTransparency = 1
GrabTitle.Text = "AUTO GRAB"
GrabTitle.TextColor3 = UI.TEXT
GrabTitle.Font = Enum.Font.GothamBlack
GrabTitle.TextXAlignment = Enum.TextXAlignment.Left
GrabTitle.ZIndex = 77
GrabTitle.Parent = GrabWindow
makeReadableText(GrabTitle, 7, 10)

local GrabToggleBtn = Instance.new("TextButton")
GrabToggleBtn.Size = UDim2.new(0, 30, 0, 13)
GrabToggleBtn.Position = UDim2.new(1, -52, 0, 2)
GrabToggleBtn.BackgroundColor3 = UI.BTN_ACTIVE
GrabToggleBtn.TextColor3 = UI.TEXT
GrabToggleBtn.Text = "ON"
GrabToggleBtn.Font = Enum.Font.GothamBlack
GrabToggleBtn.ZIndex = 77
GrabToggleBtn.Parent = GrabWindow
Instance.new("UICorner", GrabToggleBtn).CornerRadius = UDim.new(0, 4)
makeReadableText(GrabToggleBtn, 7, 9)

local GrabGearBtn = Instance.new("TextButton")
GrabGearBtn.Size = UDim2.new(0, 17, 0, 13)
GrabGearBtn.Position = UDim2.new(1, -19, 0, 2)
GrabGearBtn.BackgroundColor3 = UI.BTN
GrabGearBtn.TextColor3 = UI.TEXT
GrabGearBtn.Text = "⚙"
GrabGearBtn.Font = Enum.Font.GothamBold
GrabGearBtn.ZIndex = 77
GrabGearBtn.Parent = GrabWindow
Instance.new("UICorner", GrabGearBtn).CornerRadius = UDim.new(0, 4)
makeReadableText(GrabGearBtn, 8, 10)

local GrabBarTrack = Instance.new("Frame")
GrabBarTrack.Size = UDim2.new(1, -10, 0, 11)
GrabBarTrack.Position = UDim2.new(0, 5, 0, 18)
GrabBarTrack.BackgroundColor3 = UI.CARD
GrabBarTrack.BorderSizePixel = 0
GrabBarTrack.ZIndex = 77
GrabBarTrack.Parent = GrabWindow
Instance.new("UICorner", GrabBarTrack).CornerRadius = UDim.new(0, 4)

GrabBarFill = Instance.new("Frame")
GrabBarFill.Size = UDim2.new(0, 0, 1, 0)
GrabBarFill.BackgroundColor3 = UI.BAR_FILL
GrabBarFill.BorderSizePixel = 0
GrabBarFill.ZIndex = 78
GrabBarFill.Parent = GrabBarTrack
Instance.new("UICorner", GrabBarFill).CornerRadius = UDim.new(0, 4)
addCoolBackgroundGradient(GrabBarFill, Color3.fromRGB(190, 75, 255), Color3.fromRGB(65, 210, 255), 0)

GrabPercentLbl = Instance.new("TextLabel")
GrabPercentLbl.Size = UDim2.new(1, 0, 1, 0)
GrabPercentLbl.BackgroundTransparency = 1
GrabPercentLbl.Text = "0%"
GrabPercentLbl.TextColor3 = UI.TEXT
GrabPercentLbl.Font = Enum.Font.GothamBlack
GrabPercentLbl.ZIndex = 79
GrabPercentLbl.Parent = GrabBarTrack
makeReadableText(GrabPercentLbl, 7, 9)

local GrabStatusLbl = Instance.new("TextLabel")
GrabStatusLbl.Size = UDim2.new(1, -10, 0, 13)
GrabStatusLbl.Position = UDim2.new(0, 5, 0, 31)
GrabStatusLbl.BackgroundTransparency = 1
GrabStatusLbl.Text = "Fast Grab: 0.08s"
GrabStatusLbl.TextColor3 = UI.MUTED
GrabStatusLbl.Font = Enum.Font.GothamBold
GrabStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
GrabStatusLbl.ZIndex = 77
GrabStatusLbl.Parent = GrabWindow
makeReadableText(GrabStatusLbl, 7, 9)

local GrabSettingsBox = Instance.new("Frame")
GrabSettingsBox.Name = "DisconnectedGrabSettings"
GrabSettingsBox.Size = UDim2.new(0, 162, 0, 62)
GrabSettingsBox.Position = UDim2.new(0.16, 0, 0.03, 50)
GrabSettingsBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GrabSettingsBox.BorderSizePixel = 0
GrabSettingsBox.Visible = false
GrabSettingsBox.ZIndex = 76
GrabSettingsBox.Parent = GrabGui
Instance.new("UICorner", GrabSettingsBox).CornerRadius = UDim.new(0, 6)
addCoolBackgroundGradient(GrabSettingsBox, Color3.fromRGB(32, 18, 68), Color3.fromRGB(16, 28, 56), 135)
local gsStroke = Instance.new("UIStroke")
gsStroke.Color = UI.STROKE
gsStroke.Thickness = 1
gsStroke.Parent = GrabSettingsBox
makeDraggable(GrabSettingsBox)

local HoldTimeBtn = Instance.new("TextButton")
HoldTimeBtn.Size = UDim2.new(1, -10, 0, 17)
HoldTimeBtn.Position = UDim2.new(0, 5, 0, 5)
HoldTimeBtn.BackgroundColor3 = UI.BTN_ACTIVE
HoldTimeBtn.TextColor3 = UI.TEXT
HoldTimeBtn.Text = "Hold: 0.08s"
HoldTimeBtn.Font = Enum.Font.GothamBlack
HoldTimeBtn.ZIndex = 77
HoldTimeBtn.Parent = GrabSettingsBox
Instance.new("UICorner", HoldTimeBtn).CornerRadius = UDim.new(0, 4)
makeReadableText(HoldTimeBtn, 7, 9)

local RangeCycleBtn = Instance.new("TextButton")
RangeCycleBtn.Size = UDim2.new(1, -10, 0, 17)
RangeCycleBtn.Position = UDim2.new(0, 5, 0, 24)
RangeCycleBtn.BackgroundColor3 = UI.BTN
RangeCycleBtn.TextColor3 = UI.TEXT
RangeCycleBtn.Text = "Range: 32"
RangeCycleBtn.Font = Enum.Font.GothamBold
RangeCycleBtn.ZIndex = 77
RangeCycleBtn.Parent = GrabSettingsBox
Instance.new("UICorner", RangeCycleBtn).CornerRadius = UDim.new(0, 4)
makeReadableText(RangeCycleBtn, 7, 9)

local NormalModeLbl = Instance.new("TextLabel")
NormalModeLbl.Size = UDim2.new(1, -10, 0, 15)
NormalModeLbl.Position = UDim2.new(0, 5, 0, 43)
NormalModeLbl.BackgroundColor3 = UI.CARD
NormalModeLbl.TextColor3 = UI.MUTED
NormalModeLbl.Text = "Normal Grab • No Click"
NormalModeLbl.Font = Enum.Font.GothamBold
NormalModeLbl.ZIndex = 77
NormalModeLbl.Parent = GrabSettingsBox
Instance.new("UICorner", NormalModeLbl).CornerRadius = UDim.new(0, 4)
makeReadableText(NormalModeLbl, 7, 9)

-- =========================================================================
-- COMPACT MAIN PANEL (NO SERVER HOP • ALL WORDS VISIBLE)
-- =========================================================================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 48, 0, 18)
OpenBtn.Position = UDim2.new(0.02, 0, 0.20, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.TextColor3 = UI.TEXT
OpenBtn.Text = "AP"
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.ZIndex = 70
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 5)
addCoolBackgroundGradient(OpenBtn, Color3.fromRGB(45, 20, 86), Color3.fromRGB(20, 36, 72), 90)
makeReadableText(OpenBtn, 7, 10)
local openStroke = Instance.new("UIStroke")
openStroke.Color = UI.STROKE
openStroke.Thickness = 1
openStroke.Parent = OpenBtn
makeDraggable(OpenBtn)

local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0, 194, 0, 182)
Panel.Position = UDim2.new(0.02, 0, 0.25, 0)
Panel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Panel.BorderSizePixel = 0
Panel.ZIndex = 72
Panel.Parent = ScreenGui
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 6)
addCoolBackgroundGradient(Panel, Color3.fromRGB(26, 15, 56), Color3.fromRGB(12, 22, 44), 135)
local stroke = Instance.new("UIStroke")
stroke.Color = UI.STROKE
stroke.Thickness = 1.2
stroke.Parent = Panel
makeDraggable(Panel)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 18)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 73
TitleBar.Parent = Panel
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 6)
addCoolBackgroundGradient(TitleBar, Color3.fromRGB(58, 26, 108), Color3.fromRGB(24, 42, 84), 0)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -22, 1, 0)
TitleLabel.Position = UDim2.new(0, 6, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "SAB PANEL"
TitleLabel.TextColor3 = UI.TEXT
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 74
TitleLabel.Parent = TitleBar
makeReadableText(TitleLabel, 7, 10)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 15, 0, 14)
CloseBtn.Position = UDim2.new(1, -17, 0.5, -7)
CloseBtn.BackgroundColor3 = UI.ACCENT
CloseBtn.TextColor3 = UI.TEXT
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 74
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
makeReadableText(CloseBtn, 7, 9)

local TargetAvatar = Instance.new("ImageLabel")
TargetAvatar.Size = UDim2.new(0, 13, 0, 13)
TargetAvatar.Position = UDim2.new(0, 5, 0, 20)
TargetAvatar.BackgroundColor3 = UI.CARD
TargetAvatar.BorderSizePixel = 0
TargetAvatar.ZIndex = 74
TargetAvatar.Parent = Panel
Instance.new("UICorner", TargetAvatar).CornerRadius = UDim.new(1, 0)
applyAvatarThumbnail(TargetAvatar, LocalPlayer.UserId)

local TargetLbl = Instance.new("TextLabel")
TargetLbl.Size = UDim2.new(1, -22, 0, 13)
TargetLbl.Position = UDim2.new(0, 20, 0, 20)
TargetLbl.BackgroundTransparency = 1
TargetLbl.Text = "Target: " .. LocalPlayer.Name .. " (ME)"
TargetLbl.TextColor3 = UI.MUTED
TargetLbl.Font = Enum.Font.GothamBold
TargetLbl.TextXAlignment = Enum.TextXAlignment.Left
TargetLbl.ZIndex = 74
TargetLbl.Parent = Panel
makeReadableText(TargetLbl, 7, 9)

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0.45, -5, 1, -38)
PlayerList.Position = UDim2.new(0, 5, 0, 35)
PlayerList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 2
PlayerList.ZIndex = 73
PlayerList.Parent = Panel
Instance.new("UICorner", PlayerList).CornerRadius = UDim.new(0, 5)
addCoolBackgroundGradient(PlayerList, Color3.fromRGB(30, 18, 62), Color3.fromRGB(16, 26, 52), 180)

local pListLayout = Instance.new("UIListLayout")
pListLayout.Padding = UDim.new(0, 2)
pListLayout.SortOrder = Enum.SortOrder.LayoutOrder
pListLayout.Parent = PlayerList

local ActionBox = Instance.new("Frame")
ActionBox.Size = UDim2.new(0.55, -5, 1, -38)
ActionBox.Position = UDim2.new(0.45, 1, 0, 35)
ActionBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ActionBox.BorderSizePixel = 0
ActionBox.ZIndex = 73
ActionBox.Parent = Panel
Instance.new("UICorner", ActionBox).CornerRadius = UDim.new(0, 5)
addCoolBackgroundGradient(ActionBox, Color3.fromRGB(30, 18, 62), Color3.fromRGB(16, 26, 52), 180)

local function styleActionButton(btn: TextButton, c1: Color3, c2: Color3)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	addCoolBackgroundGradient(btn, c1, c2, 90)
	makeReadableText(btn, 7, 9)
	local st = Instance.new("UIStroke")
	st.Color = Color3.fromRGB(255, 255, 255)
	st.Transparency = 0.75
	st.Thickness = 0.8
	st.Parent = btn
end

local MainApBtn = Instance.new("TextButton")
MainApBtn.Size = UDim2.new(1, -6, 0, 22)
MainApBtn.Position = UDim2.new(0, 3, 0, 3)
MainApBtn.TextColor3 = UI.TEXT
MainApBtn.Text = "AP"
MainApBtn.Font = Enum.Font.GothamBlack
MainApBtn.ZIndex = 74
MainApBtn.Parent = ActionBox
Instance.new("UICorner", MainApBtn).CornerRadius = UDim.new(0, 4)
styleActionButton(MainApBtn, Color3.fromRGB(220, 45, 95), Color3.fromRGB(130, 25, 70))

local BlockBtn = Instance.new("TextButton")
BlockBtn.Size = UDim2.new(1, -6, 0, 22)
BlockBtn.Position = UDim2.new(0, 3, 0, 28)
BlockBtn.TextColor3 = UI.TEXT
BlockBtn.Text = "BLOCK"
BlockBtn.Font = Enum.Font.GothamBlack
BlockBtn.ZIndex = 74
BlockBtn.Parent = ActionBox
Instance.new("UICorner", BlockBtn).CornerRadius = UDim.new(0, 4)
styleActionButton(BlockBtn, Color3.fromRGB(190, 48, 125), Color3.fromRGB(108, 25, 85))

local BestBrainRotBtn = Instance.new("TextButton")
BestBrainRotBtn.Size = UDim2.new(1, -6, 0, 22)
BestBrainRotBtn.Position = UDim2.new(0, 3, 0, 53)
BestBrainRotBtn.TextColor3 = UI.TEXT
BestBrainRotBtn.Text = "BEST BRAIN ROT"
BestBrainRotBtn.Font = Enum.Font.GothamBlack
BestBrainRotBtn.ZIndex = 74
BestBrainRotBtn.Parent = ActionBox
Instance.new("UICorner", BestBrainRotBtn).CornerRadius = UDim.new(0, 4)
styleActionButton(BestBrainRotBtn, Color3.fromRGB(158, 72, 255), Color3.fromRGB(82, 42, 195))

local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(1, -6, 0, 22)
LockBtn.Position = UDim2.new(0, 3, 0, 78)
LockBtn.TextColor3 = UI.TEXT
LockBtn.Text = "LOCK: OFF"
LockBtn.Font = Enum.Font.GothamBlack
LockBtn.ZIndex = 74
LockBtn.Parent = ActionBox
Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0, 4)
styleActionButton(LockBtn, Color3.fromRGB(54, 48, 92), Color3.fromRGB(32, 28, 62))

local PlayerEspBtn = Instance.new("TextButton")
PlayerEspBtn.Size = UDim2.new(1, -6, 0, 22)
PlayerEspBtn.Position = UDim2.new(0, 3, 0, 103)
PlayerEspBtn.TextColor3 = UI.TEXT
PlayerEspBtn.Text = "ESP: OFF"
PlayerEspBtn.Font = Enum.Font.GothamBlack
PlayerEspBtn.ZIndex = 74
PlayerEspBtn.Parent = ActionBox
Instance.new("UICorner", PlayerEspBtn).CornerRadius = UDim.new(0, 4)
styleActionButton(PlayerEspBtn, Color3.fromRGB(54, 48, 92), Color3.fromRGB(32, 28, 62))

local function formatPlayerTag(plr: Player?): string
	if not plr or not plr.Parent then
		return "None"
	end
	if plr == LocalPlayer then
		return plr.Name .. " (ME)"
	end
	return plr.Name
end

local function refreshTargetLabel()
	if selectedTarget and selectedTarget.Parent then
		TargetLbl.Text = "Target: " .. formatPlayerTag(selectedTarget)
		applyAvatarThumbnail(TargetAvatar, selectedTarget.UserId)
	else
		TargetLbl.Text = "Target: None"
		TargetAvatar.Image = ""
	end
end

local function rebuildPlayerList()
	for _, child in ipairs(PlayerList:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local plrs = Players:GetPlayers()
	for i, plr in ipairs(plrs) do
		local isSelf = (plr == LocalPlayer)
		local isSelected = (selectedTarget == plr)

		local row = Instance.new("Frame")
		row.LayoutOrder = if isSelf then 0 else i
		row.Size = UDim2.new(1, -2, 0, 18)
		row.BackgroundColor3 = if isSelected then UI.BTN_ACTIVE else UI.BTN
		row.BorderSizePixel = 0
		row.ZIndex = 74
		row.Parent = PlayerList
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)

		local avatar = Instance.new("ImageLabel")
		avatar.Size = UDim2.new(0, 12, 0, 12)
		avatar.Position = UDim2.new(0, 3, 0.5, -6)
		avatar.BackgroundColor3 = UI.BG
		avatar.BorderSizePixel = 0
		avatar.ZIndex = 75
		avatar.Parent = row
		Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
		applyAvatarThumbnail(avatar, plr.UserId)

		local pickBtn = Instance.new("TextButton")
		pickBtn.Size = UDim2.new(1, -17, 1, 0)
		pickBtn.Position = UDim2.new(0, 16, 0, 0)
		pickBtn.BackgroundTransparency = 1
		pickBtn.Text = formatPlayerTag(plr)
		pickBtn.TextColor3 = if isSelf and not isSelected then UI.SELF_TAG else UI.TEXT
		pickBtn.Font = Enum.Font.GothamBold
		pickBtn.TextXAlignment = Enum.TextXAlignment.Left
		pickBtn.ZIndex = 75
		pickBtn.Parent = row
		makeReadableText(pickBtn, 7, 9)

		pickBtn.MouseButton1Click:Connect(function()
			selectedTarget = plr
			refreshTargetLabel()
			rebuildPlayerList()
		end)
	end

	PlayerList.CanvasSize = UDim2.new(0, 0, 0, math.max(#plrs * 20, 20))
end

local function syncFeatureVisuals()
	TitleLabel.Text = if dragLockEnabled then "DRAG LOCKED" else "SAB PANEL"
	stroke.Color = if dragLockEnabled then UI.BTN_ACTIVE else UI.STROKE

	GrabToggleBtn.BackgroundColor3 = if autoGrabConfig.AutoStealEnabled then UI.BTN_ACTIVE else UI.BTN
	GrabToggleBtn.Text = if autoGrabConfig.AutoStealEnabled then "ON" else "OFF"

	local holdText = string.format("Hold: %.2fs", autoGrabConfig.StealDuration)
	if math.abs(autoGrabConfig.StealDuration - 3.0) < 0.02 then
		holdText = "Hold for 3sec"
	end
	HoldTimeBtn.Text = holdText
	GrabStatusLbl.Text = string.format("Fast Grab: %.2fs", autoGrabConfig.StealDuration)

	RangeCycleBtn.Text = string.format("Range: %d", autoGrabConfig.StealRadius)

	BestBrainRotBtn.BackgroundColor3 = if bestFlyActive then UI.BTN_ACTIVE else UI.BEST_BTN
	BestBrainRotBtn.Text = if bestFlyActive then "FLYING BEST..." else "BEST BRAIN ROT"

	LockBtn.BackgroundColor3 = if dragLockEnabled then UI.BTN_ACTIVE else UI.BTN
	LockBtn.Text = if dragLockEnabled then "LOCK: ON" else "LOCK: OFF"

	PlayerEspBtn.BackgroundColor3 = if playerEspEnabled then UI.BTN_ACTIVE else UI.BTN
	PlayerEspBtn.Text = if playerEspEnabled then "ESP: ON" else "ESP: OFF"
end

GrabToggleBtn.MouseButton1Click:Connect(function()
	autoGrabConfig.AutoStealEnabled = not autoGrabConfig.AutoStealEnabled
	if not autoGrabConfig.AutoStealEnabled then
		releasePromptHold()
		setGrabProgress01(0)
	end
	syncFeatureVisuals()
	notify("AUTO GRAB: " .. (if autoGrabConfig.AutoStealEnabled then "ON" else "OFF"), true)
end)

GrabGearBtn.MouseButton1Click:Connect(function()
	GrabSettingsBox.Visible = not GrabSettingsBox.Visible
end)

HoldTimeBtn.MouseButton1Click:Connect(function()
	local presets = { 0.08, 0.20, 0.50, 3.0 }
	local idx = 1
	for i, v in ipairs(presets) do
		if math.abs(v - autoGrabConfig.StealDuration) < 0.01 then
			idx = (i % #presets) + 1
			break
		end
	end
	autoGrabConfig.StealDuration = presets[idx]
	syncFeatureVisuals()
	notify(string.format("Hold time: %.2fs", autoGrabConfig.StealDuration), true)
end)

RangeCycleBtn.MouseButton1Click:Connect(function()
	local ranges = { 24, 32, 45, 60 }
	local idx = 1
	for i, v in ipairs(ranges) do
		if v == autoGrabConfig.StealRadius then
			idx = (i % #ranges) + 1
			break
		end
	end
	autoGrabConfig.StealRadius = ranges[idx]
	syncFeatureVisuals()
	notify("Grab Range: " .. autoGrabConfig.StealRadius, true)
end)

MainApBtn.MouseButton1Click:Connect(function()
	runApPaced(selectedTarget)
end)

BlockBtn.MouseButton1Click:Connect(function()
	promptBlockPlayer(selectedTarget)
end)

BestBrainRotBtn.MouseButton1Click:Connect(function()
	if bestFlyActive then
		stopBestFlight(true)
		syncFeatureVisuals()
		notify("Flight stopped", true)
		return
	end

	local pos, name = findBestBrainrotTarget()
	if not pos then
		notify("No best brainrot found", false)
		return
	end

	bestFlyTargetPos = pos
	bestFlyActive = true
	syncFeatureVisuals()
	notify("Flying to: " .. (name or "Best Brain Rot"), true)
end)

LockBtn.MouseButton1Click:Connect(function()
	dragLockEnabled = not dragLockEnabled
	syncFeatureVisuals()
	notify("DRAG LOCK: " .. (if dragLockEnabled then "ON" else "OFF"), true)
end)

PlayerEspBtn.MouseButton1Click:Connect(function()
	playerEspEnabled = not playerEspEnabled
	syncFeatureVisuals()
	if not playerEspEnabled then
		clearAllEsp()
	else
		updatePlayerEsp()
	end
	notify("ESP: " .. (if playerEspEnabled then "ON" else "OFF"), true)
end)

CloseBtn.MouseButton1Click:Connect(function()
	Panel.Visible = false
end)

OpenBtn.MouseButton1Click:Connect(function()
	Panel.Visible = not Panel.Visible
	if Panel.Visible then
		rebuildPlayerList()
	end
end)

LocalPlayer.CharacterAdded:Connect(function()
	stopBestFlight(false)
	syncFeatureVisuals()
end)

RunService.Heartbeat:Connect(function(dt)
	if bestFlyActive then
		stepBestFlight(dt)
		syncFeatureVisuals()
	end

	if not autoGrabConfig.AutoStealEnabled then
		if not isStealBusy then
			releasePromptHold()
			setGrabProgress01(0)
		end
	elseif not isStealBusy then
		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if char and root and root:IsA("BasePart") then
			local targetPrompt = findNearestStealPrompt(root.Position)
			if targetPrompt then
				runUltraFastGrabSequence(targetPrompt)
			else
				releasePromptHold()
				setGrabProgress01(0)
			end
		end
	end

	local now = os.clock()
	if playerEspEnabled and (now - lastEspRefreshClock) >= 0.12 then
		lastEspRefreshClock = now
		pcall(updatePlayerEsp)
	end
end)

Players.PlayerAdded:Connect(function()
	if Panel.Visible then
		rebuildPlayerList()
	end
end)

Players.PlayerRemoving:Connect(function(plr)
	avatarCache[plr.UserId] = nil
	clearPlayerEspFor(plr)
	if selectedTarget == plr then
		selectedTarget = LocalPlayer
		refreshTargetLabel()
	end
	if Panel.Visible then
		rebuildPlayerList()
	end
end)

rebuildPlayerList()
refreshTargetLabel()
setGrabProgress01(0)
syncFeatureVisuals()