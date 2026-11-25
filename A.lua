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

-- Clean up any prior run when re-injecting from Delta Executor
if type(_G.SAB_Duel_Script_Cleanup) == "function" then
	pcall(_G.SAB_Duel_Script_Cleanup)
end

local connections: { RBXScriptConnection } = {}
local function trackConn(conn: RBXScriptConnection)
	table.insert(connections, conn)
	return conn
end

local BLACK_TEXT = Color3.fromRGB(0, 0, 0)

local UI = {
	BG = Color3.fromRGB(48, 8, 14),
	CARD = Color3.fromRGB(95, 16, 26),
	BTN = Color3.fromRGB(175, 24, 42),
	BTN_ACTIVE = Color3.fromRGB(225, 48, 68),
	ACCENT = Color3.fromRGB(145, 14, 28),
	BLOCK_BTN = Color3.fromRGB(165, 20, 38),
	LEFT_BTN = Color3.fromRGB(210, 38, 58),
	ESP_COLOR = Color3.fromRGB(235, 55, 75),
	BAR_FILL = Color3.fromRGB(225, 42, 62),
	BAR_DONE = Color3.fromRGB(245, 75, 90),
	SELF_TAG = BLACK_TEXT,
	TEXT = BLACK_TEXT,
	MUTED = BLACK_TEXT,
	STROKE = Color3.fromRGB(235, 45, 65),
	GRAD_A = Color3.fromRGB(155, 20, 36),
	GRAD_B = Color3.fromRGB(72, 8, 18),
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

local AP_STEP_DELAY = 0.06
local AUTO_LEFT_SPEED = 58
local AUTO_LEFT_PHASE_DURATION = 0.65
local AUTO_LEFT_FORWARD_SPEED = 60
local BASE_ARRIVAL_DISTANCE = 5.0

local AUTO_GRAB_RADIUS = 5.0
local AUTO_GRAB_DEFAULT_HOLD = 0.15
local AUTO_GRAB_COOLDOWN = 0.18

local autoGrabEnabled = true
local autoGrabHoldDuration = AUTO_GRAB_DEFAULT_HOLD
local isGrabRunning = false
local activeHeldPrompt: ProximityPrompt? = nil
local promptCooldowns: { [ProximityPrompt]: number } = {}

local selectedTarget = LocalPlayer
local dragLockEnabled = false
local playerEspEnabled = false

local autoLeftEnabled = false
local autoLeftPhaseStart = 0
local autoLeftBasePos: Vector3? = nil

local isApRunning = false
local lastEspRefreshClock = 0
local scriptActive = true

local avatarCache: { [number]: string } = {}
local playerEspObjects: { [Player]: { highlight: Highlight?, tag: BillboardGui? } } = {}

local function safeGetHui(): Instance?
	local fn = rawget(_G, "gethui") or (type(gethui) == "function" and gethui or nil)
	if type(fn) == "function" then
		local ok, hui = pcall(fn)
		if ok and typeof(hui) == "Instance" then
			return hui
		end
	end
	return nil
end

local function triggerPromptCompletion(prompt: ProximityPrompt)
	pcall(function()
		prompt:InputHoldEnd()
	end)
	local fireFn = rawget(_G, "fireproximityprompt") or (type(fireproximityprompt) == "function" and fireproximityprompt or nil)
	if type(fireFn) == "function" then
		pcall(fireFn, prompt)
	end
	pcall(function()
		if type(firesignal) == "function" then
			firesignal(prompt.PromptButtonHoldEnded, LocalPlayer)
			firesignal(prompt.Triggered, LocalPlayer)
		end
	end)
end

local function getMountParent(): Instance
	local hui = safeGetHui()
	if hui then
		local test = Instance.new("Folder")
		test.Name = "SAB_Mount_Probe"
		if pcall(function()
			test.Parent = hui
		end) then
			test:Destroy()
			return hui
		end
		test:Destroy()
	end

	local coreTest = Instance.new("Folder")
	coreTest.Name = "SAB_Core_Probe"
	if pcall(function()
		coreTest.Parent = CoreGui
	end) then
		coreTest:Destroy()
		return CoreGui
	end
	coreTest:Destroy()

	return LocalPlayer:WaitForChild("PlayerGui")
end

local MountParent = getMountParent()

local function cleanupExistingGuis(parent: Instance)
	pcall(function()
		for _, name in ipairs({ "SAB_Compact_UI", "SAB_Grab_Standalone" }) do
			local existing = parent:FindFirstChild(name)
			if existing then
				existing:Destroy()
			end
		end
	end)
end

cleanupExistingGuis(MountParent)
pcall(function()
	cleanupExistingGuis(CoreGui)
end)
pcall(function()
	local pg = LocalPlayer:FindFirstChild("PlayerGui")
	if pg then
		cleanupExistingGuis(pg)
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
	lbl.TextColor3 = BLACK_TEXT
	lbl.TextScaled = true
	lbl.TextWrapped = false
	local c = Instance.new("UITextSizeConstraint")
	c.MinTextSize = minSz
	c.MaxTextSize = maxSz
	c.Parent = lbl
end

local Toast = Instance.new("TextLabel")
Toast.Size = UDim2.new(0, 150, 0, 14)
Toast.AnchorPoint = Vector2.new(0.5, 0)
Toast.Position = UDim2.new(0.5, 0, 0.11, 0)
Toast.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Toast.TextColor3 = BLACK_TEXT
Toast.Text = "Ready"
Toast.Font = Enum.Font.GothamBold
Toast.Visible = false
Toast.ZIndex = 95
Toast.Parent = ScreenGui
Instance.new("UICorner", Toast).CornerRadius = UDim.new(0, 4)
addCoolBackgroundGradient(Toast, Color3.fromRGB(220, 42, 62), Color3.fromRGB(130, 16, 30), 90)
makeReadableText(Toast, 6, 8)
local toastStroke = Instance.new("UIStroke")
toastStroke.Color = UI.STROKE
toastStroke.Thickness = 1
toastStroke.Parent = Toast

local toastId = 0
local function notify(text: string, _okStatus: boolean?)
	if not scriptActive then
		return
	end
	toastId += 1
	local current = toastId
	Toast.Text = text
	Toast.TextColor3 = BLACK_TEXT
	Toast.Visible = true
	task.delay(1.0, function()
		if scriptActive and toastId == current and Toast.Parent then
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
		if scriptActive and ok and type(content) == "string" and #content > 0 then
			avatarCache[userId] = content
			if imgLabel and imgLabel.Parent then
				imgLabel.Image = content
			end
		end
	end)
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

-- Single-button AP: runs every command in ADMIN_COMMANDS except "control"
local function runApAllExceptControl(targetPlr: Player?)
	if isApRunning or not scriptActive then
		return
	end
	if not targetPlr or not targetPlr.Parent then
		notify("Select target", false)
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
			if not scriptActive then
				break
			end
			if cmd ~= "control" then
				sendFastChat(";" .. cmd .. " " .. targetPlr.Name)
				task.wait(AP_STEP_DELAY)
			end
		end

		local tag = if targetPlr == LocalPlayer then (targetPlr.Name .. " (ME)") else targetPlr.Name
		notify("AP -> " .. tag, true)
		isApRunning = false
	end)
end

local function promptBlockPlayer(targetPlr: Player?)
	if not targetPlr or not targetPlr.Parent or targetPlr == LocalPlayer then
		notify("Pick other player", false)
		return
	end
	local ok = pcall(function()
		StarterGui:SetCore("PromptBlockPlayer", targetPlr)
	end)
	notify(if ok then ("Block: " .. targetPlr.Name) else "Block off", ok)
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

local function findYourBasePosition(): Vector3?
	local plots = workspace:FindFirstChild("Plots")
	if not plots then
		return nil
	end
	for _, plot in ipairs(plots:GetChildren()) do
		if plot:IsA("Model") and isYourBasePlot(plot.Name) then
			local signPos = getInstanceWorldPos(plot:FindFirstChild("PlotSign"))
			if signPos then
				return signPos
			end
			local basePart = plot:FindFirstChild("Base") or plot:FindFirstChild("Spawn") or plot:FindFirstChild("Delivery")
			local bPos = getInstanceWorldPos(basePart)
			if bPos then
				return bPos
			end
			return plot:GetPivot().Position
		end
	end
	return nil
end

local syncFeatureVisuals: () -> ()

local function stopAutoLeftToBase(arrived: boolean)
	autoLeftEnabled = false
	autoLeftBasePos = nil
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	pcall(function()
		if hum then
			hum:Move(Vector3.zero, false)
		end
		if root and root:IsA("BasePart") then
			root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
		end
	end)
	if syncFeatureVisuals then
		syncFeatureVisuals()
	end
	if arrived then
		notify("At base!", true)
	end
end

local function stepAutoLeft()
	if not autoLeftEnabled then
		return
	end
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not char or not hum or not root or not root:IsA("BasePart") or hum.Health <= 0 then
		return
	end

	local elapsed = os.clock() - autoLeftPhaseStart
	local cam = workspace.CurrentCamera
	local moveDir: Vector3
	local speed: number

	if elapsed < AUTO_LEFT_PHASE_DURATION then
		if cam then
			local rightFlat = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
			moveDir = if rightFlat.Magnitude > 0.001 then -rightFlat.Unit else -root.CFrame.RightVector
		else
			moveDir = -root.CFrame.RightVector
		end
		speed = AUTO_LEFT_SPEED
	else
		local targetBase = autoLeftBasePos or findYourBasePosition()
		if targetBase then
			autoLeftBasePos = targetBase
			local flatOffset = Vector3.new(targetBase.X - root.Position.X, 0, targetBase.Z - root.Position.Z)
			if flatOffset.Magnitude <= BASE_ARRIVAL_DISTANCE then
				stopAutoLeftToBase(true)
				return
			end
			moveDir = flatOffset.Unit
		else
			if cam then
				local fwdFlat = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
				moveDir = if fwdFlat.Magnitude > 0.001 then fwdFlat.Unit else root.CFrame.LookVector
			else
				moveDir = root.CFrame.LookVector
			end
		end
		speed = AUTO_LEFT_FORWARD_SPEED
	end

	pcall(function()
		hum:Move(moveDir, false)
		root.AssemblyLinearVelocity = Vector3.new(
			moveDir.X * speed,
			root.AssemblyLinearVelocity.Y,
			moveDir.Z * speed
		)
	end)
end

-- =========================================================================
-- 5-STUD AUTO GRAB (NO SCREEN HOLD • PERCENTAGE 0 -> 50 -> 100 • FASTER)
-- =========================================================================
local GrabBarFill: Frame
local GrabPercentLbl: TextLabel
local GrabStatusLbl: TextLabel
local GrabToggleBtn: TextButton
local GrabSpeedBtn: TextButton

local function setGrabProgress01(val01: number)
	local clamped = math.clamp(val01, 0, 1)
	local pct = math.floor(clamped * 100 + 0.001)
	if GrabBarFill then
		GrabBarFill.Size = UDim2.new(clamped, 0, 1, 0)
		GrabBarFill.BackgroundColor3 = if pct >= 100 then UI.BAR_DONE else UI.BAR_FILL
	end
	if GrabPercentLbl then
		GrabPercentLbl.Text = string.format("%d%%", pct)
	end
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

local function isExcludedPrompt(prompt: ProximityPrompt): boolean
	local parentName = if prompt.Parent then prompt.Parent.Name else ""
	local grandParentName = if prompt.Parent and prompt.Parent.Parent then prompt.Parent.Parent.Name else ""
	local blob = string.lower(
		prompt.Name .. " " .. prompt.ActionText .. " " .. prompt.ObjectText .. " " .. parentName .. " " .. grandParentName
	)
	if string.find(blob, "unlock", 1, true)
		or string.find(blob, "lock base", 1, true)
		or string.find(blob, "buy", 1, true)
		or string.find(blob, "shop", 1, true)
		or string.find(blob, "sell", 1, true)
	then
		return true
	end
	return false
end

local function isValidGrabPrompt(prompt: ProximityPrompt, originPos: Vector3): (boolean, number)
	if not prompt or not prompt.Parent or not prompt.Enabled then
		return false, math.huge
	end
	if isExcludedPrompt(prompt) then
		return false, math.huge
	end
	local cdEnd = promptCooldowns[prompt]
	if cdEnd and os.clock() < cdEnd then
		return false, math.huge
	end
	local pPos = getInstanceWorldPos(prompt)
	if not pPos then
		return false, math.huge
	end
	local dist = (pPos - originPos).Magnitude
	if dist <= AUTO_GRAB_RADIUS then
		return true, dist
	end
	return false, math.huge
end

local function findPromptWithinFiveStuds(originPos: Vector3): ProximityPrompt?
	local bestPrompt: ProximityPrompt? = nil
	local bestDist = AUTO_GRAB_RADIUS

	local plots = workspace:FindFirstChild("Plots")
	if plots then
		for _, plot in ipairs(plots:GetChildren()) do
			if plot:IsA("Model") and not isYourBasePlot(plot.Name) then
				for _, desc in ipairs(plot:GetDescendants()) do
					if desc:IsA("ProximityPrompt") then
						local ok, dist = isValidGrabPrompt(desc, originPos)
						if ok and dist <= bestDist then
							bestDist = dist
							bestPrompt = desc
						end
					end
				end
			end
		end
	end

	if not bestPrompt then
		for _, desc in ipairs(workspace:GetDescendants()) do
			if desc:IsA("ProximityPrompt") then
				local ok, dist = isValidGrabPrompt(desc, originPos)
				if ok and dist <= bestDist then
					bestDist = dist
					bestPrompt = desc
				end
			end
		end
	end

	return bestPrompt
end

local function equipNewestToolIfAny()
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
	if not char or not hum or not backpack then
		return
	end
	pcall(function()
		if char:FindFirstChildOfClass("Tool") then
			return
		end
		local tools = backpack:GetChildren()
		for i = #tools, 1, -1 do
			if tools[i]:IsA("Tool") then
				hum:EquipTool(tools[i])
				break
			end
		end
	end)
end

-- Advances 0% -> 50% -> 100% on the bar without holding the screen, then completes the prompt
local function runFullHundredGrab(prompt: ProximityPrompt)
	if isGrabRunning or not scriptActive or not autoGrabEnabled then
		return
	end

	isGrabRunning = true
	activeHeldPrompt = nil
	local effectiveDuration = math.max(0.08, autoGrabHoldDuration)
	local halfDuration = effectiveDuration * 0.5
	local startClock = os.clock()
	setGrabProgress01(0)
	if GrabStatusLbl then
		GrabStatusLbl.Text = "0% -> 50%"
	end

	task.spawn(function()
		local passedHalf = false
		local reachedHundred = false

		while scriptActive and autoGrabEnabled and prompt.Parent and prompt.Enabled do
			local char = LocalPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local pPos = getInstanceWorldPos(prompt)
			if not root or not root:IsA("BasePart") or not pPos or (pPos - root.Position).Magnitude > AUTO_GRAB_RADIUS then
				break
			end

			local elapsed = os.clock() - startClock
			if not passedHalf and elapsed >= halfDuration then
				passedHalf = true
				setGrabProgress01(0.5)
				if GrabStatusLbl then
					GrabStatusLbl.Text = "50% -> 100%"
				end
			end

			local progress = math.clamp(elapsed / effectiveDuration, 0, 1)
			setGrabProgress01(progress)
			if progress >= 1 then
				setGrabProgress01(1)
				reachedHundred = true
				break
			end
			RunService.Heartbeat:Wait()
		end

		if reachedHundred and scriptActive and autoGrabEnabled and prompt.Parent then
			setGrabProgress01(1)
			if GrabStatusLbl then
				GrabStatusLbl.Text = "100% Grab!"
			end
			triggerPromptCompletion(prompt)
			task.wait(0.03)
			equipNewestToolIfAny()
			promptCooldowns[prompt] = os.clock() + AUTO_GRAB_COOLDOWN
			notify("100% Grabbed!", true)
		else
			setGrabProgress01(0)
			if prompt and prompt.Parent then
				promptCooldowns[prompt] = os.clock() + 0.06
			end
		end

		if scriptActive then
			task.delay(0.14, function()
				if scriptActive and not isGrabRunning then
					setGrabProgress01(0)
				end
			end)
			if GrabStatusLbl then
				GrabStatusLbl.Text = string.format("0-50-100 • %.2fs", autoGrabHoldDuration)
			end
		end

		isGrabRunning = false
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
	if not playerEspEnabled or not scriptActive then
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
					hl.OutlineColor = BLACK_TEXT
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
					bg.Size = UDim2.new(0, 82, 0, 13)
					bg.StudsOffset = Vector3.new(0, 2.2, 0)
					bg.AlwaysOnTop = true
					bg.Adornee = adorneePart
					bg.Parent = MountParent

					local lbl = Instance.new("TextLabel")
					lbl.Name = "Label"
					lbl.Size = UDim2.new(1, 0, 1, 0)
					lbl.BackgroundTransparency = 0.2
					lbl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					lbl.TextColor3 = BLACK_TEXT
					lbl.Font = Enum.Font.GothamBold
					lbl.Parent = bg
					Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 3)
					addCoolBackgroundGradient(lbl, Color3.fromRGB(220, 42, 62), Color3.fromRGB(140, 18, 32), 90)
					makeReadableText(lbl, 6, 8)

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

	trackConn(frame.InputBegan:Connect(function(input)
		if dragLockEnabled then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end))

	trackConn(UserInputService.InputChanged:Connect(function(input)
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
	end))

	trackConn(UserInputService.InputEnded:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false
		end
	end))
end

-- =========================================================================
-- SMALL AUTO GRAB BAR (RED • BLACK TEXT)
-- =========================================================================
local GrabWindow = Instance.new("Frame")
GrabWindow.Name = "StandaloneGrabWindow"
GrabWindow.Size = UDim2.new(0, 126, 0, 34)
GrabWindow.Position = UDim2.new(0.16, 0, 0.03, 0)
GrabWindow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GrabWindow.BorderSizePixel = 0
GrabWindow.ZIndex = 76
GrabWindow.Parent = ScreenGui
Instance.new("UICorner", GrabWindow).CornerRadius = UDim.new(0, 5)
addCoolBackgroundGradient(GrabWindow, Color3.fromRGB(215, 38, 58), Color3.fromRGB(115, 14, 26), 120)
local grabStroke = Instance.new("UIStroke")
grabStroke.Color = UI.STROKE
grabStroke.Thickness = 1
grabStroke.Parent = GrabWindow
makeDraggable(GrabWindow)

local GrabTitle = Instance.new("TextLabel")
GrabTitle.Size = UDim2.new(0, 48, 0, 10)
GrabTitle.Position = UDim2.new(0, 4, 0, 2)
GrabTitle.BackgroundTransparency = 1
GrabTitle.Text = "GRAB"
GrabTitle.TextColor3 = BLACK_TEXT
GrabTitle.Font = Enum.Font.GothamBlack
GrabTitle.TextXAlignment = Enum.TextXAlignment.Left
GrabTitle.ZIndex = 77
GrabTitle.Parent = GrabWindow
makeReadableText(GrabTitle, 6, 7)

GrabToggleBtn = Instance.new("TextButton")
GrabToggleBtn.Size = UDim2.new(0, 26, 0, 10)
GrabToggleBtn.Position = UDim2.new(1, -64, 0, 2)
GrabToggleBtn.BackgroundColor3 = Color3.fromRGB(235, 52, 72)
GrabToggleBtn.TextColor3 = BLACK_TEXT
GrabToggleBtn.Text = "ON"
GrabToggleBtn.Font = Enum.Font.GothamBlack
GrabToggleBtn.ZIndex = 77
GrabToggleBtn.Parent = GrabWindow
Instance.new("UICorner", GrabToggleBtn).CornerRadius = UDim.new(0, 3)
makeReadableText(GrabToggleBtn, 6, 7)

GrabSpeedBtn = Instance.new("TextButton")
GrabSpeedBtn.Size = UDim2.new(0, 34, 0, 10)
GrabSpeedBtn.Position = UDim2.new(1, -36, 0, 2)
GrabSpeedBtn.BackgroundColor3 = Color3.fromRGB(195, 28, 46)
GrabSpeedBtn.TextColor3 = BLACK_TEXT
GrabSpeedBtn.Text = "0.15s"
GrabSpeedBtn.Font = Enum.Font.GothamBlack
GrabSpeedBtn.ZIndex = 77
GrabSpeedBtn.Parent = GrabWindow
Instance.new("UICorner", GrabSpeedBtn).CornerRadius = UDim.new(0, 3)
makeReadableText(GrabSpeedBtn, 6, 7)

local GrabBarTrack = Instance.new("Frame")
GrabBarTrack.Size = UDim2.new(1, -8, 0, 8)
GrabBarTrack.Position = UDim2.new(0, 4, 0, 13)
GrabBarTrack.BackgroundColor3 = Color3.fromRGB(115, 14, 26)
GrabBarTrack.BorderSizePixel = 0
GrabBarTrack.ZIndex = 77
GrabBarTrack.Parent = GrabWindow
Instance.new("UICorner", GrabBarTrack).CornerRadius = UDim.new(0, 3)

GrabBarFill = Instance.new("Frame")
GrabBarFill.Size = UDim2.new(0, 0, 1, 0)
GrabBarFill.BackgroundColor3 = UI.BAR_FILL
GrabBarFill.BorderSizePixel = 0
GrabBarFill.ZIndex = 78
GrabBarFill.Parent = GrabBarTrack
Instance.new("UICorner", GrabBarFill).CornerRadius = UDim.new(0, 3)
addCoolBackgroundGradient(GrabBarFill, Color3.fromRGB(240, 62, 82), Color3.fromRGB(175, 24, 42), 0)

GrabPercentLbl = Instance.new("TextLabel")
GrabPercentLbl.Size = UDim2.new(1, 0, 1, 0)
GrabPercentLbl.BackgroundTransparency = 1
GrabPercentLbl.Text = "0%"
GrabPercentLbl.TextColor3 = BLACK_TEXT
GrabPercentLbl.Font = Enum.Font.GothamBlack
GrabPercentLbl.ZIndex = 79
GrabPercentLbl.Parent = GrabBarTrack
makeReadableText(GrabPercentLbl, 6, 7)

GrabStatusLbl = Instance.new("TextLabel")
GrabStatusLbl.Size = UDim2.new(1, -8, 0, 10)
GrabStatusLbl.Position = UDim2.new(0, 4, 0, 22)
GrabStatusLbl.BackgroundTransparency = 1
GrabStatusLbl.Text = "0-50-100 • 0.15s"
GrabStatusLbl.TextColor3 = BLACK_TEXT
GrabStatusLbl.Font = Enum.Font.GothamBold
GrabStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
GrabStatusLbl.ZIndex = 77
GrabStatusLbl.Parent = GrabWindow
makeReadableText(GrabStatusLbl, 6, 7)

-- =========================================================================
-- SMALL RED MAIN PANEL WITH BLACK TEXT
-- =========================================================================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 44, 0, 15)
OpenBtn.Position = UDim2.new(0.02, 0, 0.20, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.TextColor3 = BLACK_TEXT
OpenBtn.Text = "PANEL"
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.ZIndex = 70
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 4)
addCoolBackgroundGradient(OpenBtn, Color3.fromRGB(215, 38, 58), Color3.fromRGB(125, 14, 28), 90)
makeReadableText(OpenBtn, 6, 8)
local openStroke = Instance.new("UIStroke")
openStroke.Color = UI.STROKE
openStroke.Thickness = 1
openStroke.Parent = OpenBtn
makeDraggable(OpenBtn)

local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0, 152, 0, 146)
Panel.Position = UDim2.new(0.02, 0, 0.25, 0)
Panel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Panel.BorderSizePixel = 0
Panel.ZIndex = 72
Panel.Parent = ScreenGui
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 5)
addCoolBackgroundGradient(Panel, Color3.fromRGB(165, 22, 38), Color3.fromRGB(76, 8, 18), 135)
local stroke = Instance.new("UIStroke")
stroke.Color = UI.STROKE
stroke.Thickness = 1
stroke.Parent = Panel
makeDraggable(Panel)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 14)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 73
TitleBar.Parent = Panel
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 5)
addCoolBackgroundGradient(TitleBar, Color3.fromRGB(225, 42, 62), Color3.fromRGB(135, 16, 30), 0)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -18, 1, 0)
TitleLabel.Position = UDim2.new(0, 4, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "SAB PANEL"
TitleLabel.TextColor3 = BLACK_TEXT
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 74
TitleLabel.Parent = TitleBar
makeReadableText(TitleLabel, 6, 8)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 12, 0, 11)
CloseBtn.Position = UDim2.new(1, -14, 0.5, -5.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(235, 52, 72)
CloseBtn.TextColor3 = BLACK_TEXT
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 74
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 3)
makeReadableText(CloseBtn, 6, 7)

local TargetAvatar = Instance.new("ImageLabel")
TargetAvatar.Size = UDim2.new(0, 10, 0, 10)
TargetAvatar.Position = UDim2.new(0, 4, 0, 16)
TargetAvatar.BackgroundColor3 = UI.CARD
TargetAvatar.BorderSizePixel = 0
TargetAvatar.ZIndex = 74
TargetAvatar.Parent = Panel
Instance.new("UICorner", TargetAvatar).CornerRadius = UDim.new(1, 0)
applyAvatarThumbnail(TargetAvatar, LocalPlayer.UserId)

local TargetLbl = Instance.new("TextLabel")
TargetLbl.Size = UDim2.new(1, -18, 0, 10)
TargetLbl.Position = UDim2.new(0, 16, 0, 16)
TargetLbl.BackgroundTransparency = 1
TargetLbl.Text = "Target: " .. LocalPlayer.Name .. " (ME)"
TargetLbl.TextColor3 = BLACK_TEXT
TargetLbl.Font = Enum.Font.GothamBold
TargetLbl.TextXAlignment = Enum.TextXAlignment.Left
TargetLbl.ZIndex = 74
TargetLbl.Parent = Panel
makeReadableText(TargetLbl, 6, 7)

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0.41, -4, 1, -30)
PlayerList.Position = UDim2.new(0, 4, 0, 27)
PlayerList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 2
PlayerList.ZIndex = 73
PlayerList.Parent = Panel
Instance.new("UICorner", PlayerList).CornerRadius = UDim.new(0, 4)
addCoolBackgroundGradient(PlayerList, Color3.fromRGB(185, 26, 44), Color3.fromRGB(95, 10, 22), 180)

local pListLayout = Instance.new("UIListLayout")
pListLayout.Padding = UDim.new(0, 2)
pListLayout.SortOrder = Enum.SortOrder.LayoutOrder
pListLayout.Parent = PlayerList

local ActionBox = Instance.new("Frame")
ActionBox.Size = UDim2.new(0.59, -4, 1, -30)
ActionBox.Position = UDim2.new(0.41, 1, 0, 27)
ActionBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ActionBox.BorderSizePixel = 0
ActionBox.ZIndex = 73
ActionBox.Parent = Panel
Instance.new("UICorner", ActionBox).CornerRadius = UDim.new(0, 4)
addCoolBackgroundGradient(ActionBox, Color3.fromRGB(185, 26, 44), Color3.fromRGB(95, 10, 22), 180)

local function styleActionButton(btn: TextButton, c1: Color3, c2: Color3)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextColor3 = BLACK_TEXT
	addCoolBackgroundGradient(btn, c1, c2, 90)
	makeReadableText(btn, 6, 8)
	local st = Instance.new("UIStroke")
	st.Color = BLACK_TEXT
	st.Transparency = 0.65
	st.Thickness = 0.7
	st.Parent = btn
end

local ApBtn = Instance.new("TextButton")
ApBtn.Size = UDim2.new(1, -4, 0, 18)
ApBtn.Position = UDim2.new(0, 2, 0, 2)
ApBtn.TextColor3 = BLACK_TEXT
ApBtn.Text = "AP"
ApBtn.Font = Enum.Font.GothamBlack
ApBtn.ZIndex = 74
ApBtn.Parent = ActionBox
Instance.new("UICorner", ApBtn).CornerRadius = UDim.new(0, 3)
styleActionButton(ApBtn, Color3.fromRGB(225, 42, 62), Color3.fromRGB(145, 16, 30))

local AutoLeftBtn = Instance.new("TextButton")
AutoLeftBtn.Size = UDim2.new(1, -4, 0, 18)
AutoLeftBtn.Position = UDim2.new(0, 2, 0, 22)
AutoLeftBtn.TextColor3 = BLACK_TEXT
AutoLeftBtn.Text = "AUTO LEFT: OFF"
AutoLeftBtn.Font = Enum.Font.GothamBlack
AutoLeftBtn.ZIndex = 74
AutoLeftBtn.Parent = ActionBox
Instance.new("UICorner", AutoLeftBtn).CornerRadius = UDim.new(0, 3)
styleActionButton(AutoLeftBtn, Color3.fromRGB(215, 36, 56), Color3.fromRGB(130, 14, 26))

local BlockBtn = Instance.new("TextButton")
BlockBtn.Size = UDim2.new(1, -4, 0, 18)
BlockBtn.Position = UDim2.new(0, 2, 0, 42)
BlockBtn.TextColor3 = BLACK_TEXT
BlockBtn.Text = "BLOCK"
BlockBtn.Font = Enum.Font.GothamBlack
BlockBtn.ZIndex = 74
BlockBtn.Parent = ActionBox
Instance.new("UICorner", BlockBtn).CornerRadius = UDim.new(0, 3)
styleActionButton(BlockBtn, Color3.fromRGB(205, 32, 52), Color3.fromRGB(120, 12, 24))

local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(1, -4, 0, 18)
LockBtn.Position = UDim2.new(0, 2, 0, 62)
LockBtn.TextColor3 = BLACK_TEXT
LockBtn.Text = "LOCK: OFF"
LockBtn.Font = Enum.Font.GothamBlack
LockBtn.ZIndex = 74
LockBtn.Parent = ActionBox
Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0, 3)
styleActionButton(LockBtn, Color3.fromRGB(195, 28, 46), Color3.fromRGB(115, 12, 24))

local PlayerEspBtn = Instance.new("TextButton")
PlayerEspBtn.Size = UDim2.new(1, -4, 0, 18)
PlayerEspBtn.Position = UDim2.new(0, 2, 0, 82)
PlayerEspBtn.TextColor3 = BLACK_TEXT
PlayerEspBtn.Text = "ESP: OFF"
PlayerEspBtn.Font = Enum.Font.GothamBlack
PlayerEspBtn.ZIndex = 74
PlayerEspBtn.Parent = ActionBox
Instance.new("UICorner", PlayerEspBtn).CornerRadius = UDim.new(0, 3)
styleActionButton(PlayerEspBtn, Color3.fromRGB(195, 28, 46), Color3.fromRGB(115, 12, 24))

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
		TargetLbl.TextColor3 = BLACK_TEXT
		applyAvatarThumbnail(TargetAvatar, selectedTarget.UserId)
	else
		TargetLbl.Text = "Target: None"
		TargetLbl.TextColor3 = BLACK_TEXT
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
		row.Size = UDim2.new(1, -2, 0, 15)
		row.BackgroundColor3 = if isSelected then Color3.fromRGB(240, 62, 82) else Color3.fromRGB(185, 28, 46)
		row.BorderSizePixel = 0
		row.ZIndex = 74
		row.Parent = PlayerList
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 3)

		local avatar = Instance.new("ImageLabel")
		avatar.Size = UDim2.new(0, 10, 0, 10)
		avatar.Position = UDim2.new(0, 2, 0.5, -5)
		avatar.BackgroundColor3 = UI.BG
		avatar.BorderSizePixel = 0
		avatar.ZIndex = 75
		avatar.Parent = row
		Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
		applyAvatarThumbnail(avatar, plr.UserId)

		local pickBtn = Instance.new("TextButton")
		pickBtn.Size = UDim2.new(1, -14, 1, 0)
		pickBtn.Position = UDim2.new(0, 13, 0, 0)
		pickBtn.BackgroundTransparency = 1
		pickBtn.Text = formatPlayerTag(plr)
		pickBtn.TextColor3 = BLACK_TEXT
		pickBtn.Font = Enum.Font.GothamBold
		pickBtn.TextXAlignment = Enum.TextXAlignment.Left
		pickBtn.ZIndex = 75
		pickBtn.Parent = row
		makeReadableText(pickBtn, 6, 7)

		trackConn(pickBtn.MouseButton1Click:Connect(function()
			selectedTarget = plr
			refreshTargetLabel()
			rebuildPlayerList()
		end))
	end

	PlayerList.CanvasSize = UDim2.new(0, 0, 0, math.max(#plrs * 17, 17))
end

syncFeatureVisuals = function()
	TitleLabel.Text = if dragLockEnabled then "LOCKED" else "SAB PANEL"
	TitleLabel.TextColor3 = BLACK_TEXT
	stroke.Color = if dragLockEnabled then Color3.fromRGB(255, 80, 95) else UI.STROKE

	GrabToggleBtn.BackgroundColor3 = if autoGrabEnabled then Color3.fromRGB(240, 62, 82) else Color3.fromRGB(165, 20, 38)
	GrabToggleBtn.Text = if autoGrabEnabled then "ON" else "OFF"
	GrabToggleBtn.TextColor3 = BLACK_TEXT

	GrabSpeedBtn.Text = string.format("%.2fs", autoGrabHoldDuration)
	GrabSpeedBtn.TextColor3 = BLACK_TEXT

	if not isGrabRunning then
		GrabStatusLbl.Text = string.format("0-50-100 • %.2fs", autoGrabHoldDuration)
	end
	GrabStatusLbl.TextColor3 = BLACK_TEXT

	ApBtn.Text = if isApRunning then "AP..." else "AP"
	ApBtn.TextColor3 = BLACK_TEXT

	AutoLeftBtn.BackgroundColor3 = if autoLeftEnabled then Color3.fromRGB(240, 62, 82) else Color3.fromRGB(190, 28, 46)
	AutoLeftBtn.Text = if autoLeftEnabled then "AUTO LEFT: ON" else "AUTO LEFT: OFF"
	AutoLeftBtn.TextColor3 = BLACK_TEXT

	LockBtn.BackgroundColor3 = if dragLockEnabled then Color3.fromRGB(240, 62, 82) else Color3.fromRGB(190, 28, 46)
	LockBtn.Text = if dragLockEnabled then "LOCK: ON" else "LOCK: OFF"
	LockBtn.TextColor3 = BLACK_TEXT

	PlayerEspBtn.BackgroundColor3 = if playerEspEnabled then Color3.fromRGB(240, 62, 82) else Color3.fromRGB(190, 28, 46)
	PlayerEspBtn.Text = if playerEspEnabled then "ESP: ON" else "ESP: OFF"
	PlayerEspBtn.TextColor3 = BLACK_TEXT
end

trackConn(GrabToggleBtn.MouseButton1Click:Connect(function()
	autoGrabEnabled = not autoGrabEnabled
	if not autoGrabEnabled then
		releasePromptHold()
		setGrabProgress01(0)
	end
	syncFeatureVisuals()
	notify("GRAB: " .. (if autoGrabEnabled then "ON" else "OFF"), true)
end))

trackConn(GrabSpeedBtn.MouseButton1Click:Connect(function()
	local speeds = { 0.15, 0.28, 0.45 }
	local nextIdx = 1
	for i, v in ipairs(speeds) do
		if math.abs(v - autoGrabHoldDuration) < 0.01 then
			nextIdx = (i % #speeds) + 1
			break
		end
	end
	autoGrabHoldDuration = speeds[nextIdx]
	syncFeatureVisuals()
	notify(string.format("Hold: %.2fs", autoGrabHoldDuration), true)
end))

trackConn(ApBtn.MouseButton1Click:Connect(function()
	runApAllExceptControl(selectedTarget)
	syncFeatureVisuals()
	task.delay(0.15, function()
		if scriptActive then
			syncFeatureVisuals()
		end
	end)
end))

trackConn(AutoLeftBtn.MouseButton1Click:Connect(function()
	if autoLeftEnabled then
		stopAutoLeftToBase(false)
		notify("AUTO LEFT: OFF", true)
	else
		autoLeftEnabled = true
		autoLeftPhaseStart = os.clock()
		autoLeftBasePos = findYourBasePosition()
		syncFeatureVisuals()
		notify("Left -> Base", true)
	end
end))

trackConn(BlockBtn.MouseButton1Click:Connect(function()
	promptBlockPlayer(selectedTarget)
end))

trackConn(LockBtn.MouseButton1Click:Connect(function()
	dragLockEnabled = not dragLockEnabled
	syncFeatureVisuals()
	notify("LOCK: " .. (if dragLockEnabled then "ON" else "OFF"), true)
end))

trackConn(PlayerEspBtn.MouseButton1Click:Connect(function()
	playerEspEnabled = not playerEspEnabled
	syncFeatureVisuals()
	if not playerEspEnabled then
		clearAllEsp()
	else
		updatePlayerEsp()
	end
	notify("ESP: " .. (if playerEspEnabled then "ON" else "OFF"), true)
end))

trackConn(CloseBtn.MouseButton1Click:Connect(function()
	Panel.Visible = false
end))

trackConn(OpenBtn.MouseButton1Click:Connect(function()
	Panel.Visible = not Panel.Visible
	if Panel.Visible then
		rebuildPlayerList()
	end
end))

trackConn(LocalPlayer.CharacterAdded:Connect(function()
	autoLeftEnabled = false
	autoLeftBasePos = nil
	releasePromptHold()
	setGrabProgress01(0)
	syncFeatureVisuals()
end))

trackConn(RunService.Heartbeat:Connect(function(_dt)
	if not scriptActive then
		return
	end
	if autoLeftEnabled then
		stepAutoLeft()
	end

	if autoGrabEnabled and not isGrabRunning then
		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if char and root and root:IsA("BasePart") then
			local targetPrompt = findPromptWithinFiveStuds(root.Position)
			if targetPrompt then
				runFullHundredGrab(targetPrompt)
			end
		end
	elseif not autoGrabEnabled and not isGrabRunning then
		releasePromptHold()
		setGrabProgress01(0)
	end

	local now = os.clock()
	if playerEspEnabled and (now - lastEspRefreshClock) >= 0.12 then
		lastEspRefreshClock = now
		pcall(updatePlayerEsp)
	end
end))

trackConn(Players.PlayerAdded:Connect(function()
	if Panel.Visible then
		rebuildPlayerList()
	end
end))

trackConn(Players.PlayerRemoving:Connect(function(plr)
	avatarCache[plr.UserId] = nil
	clearPlayerEspFor(plr)
	if selectedTarget == plr then
		selectedTarget = LocalPlayer
		refreshTargetLabel()
	end
	if Panel.Visible then
		rebuildPlayerList()
	end
end))

_G.SAB_Duel_Script_Cleanup = function()
	scriptActive = false
	autoLeftEnabled = false
	autoGrabEnabled = false
	playerEspEnabled = false
	releasePromptHold()
	clearAllEsp()
	for _, conn in ipairs(connections) do
		pcall(function()
			conn:Disconnect()
		end)
	end
	table.clear(connections)
	pcall(function()
		ScreenGui:Destroy()
	end)
end

rebuildPlayerList()
refreshTargetLabel()
setGrabProgress01(0)
syncFeatureVisuals()