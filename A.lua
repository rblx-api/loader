--[[
	Script Name: SAB UI // Delta Compact (Lock Everything + AP No Control + ESP/Nugget Arrow + AutoBuy)
	Safety & Scope:
	  - Zero forced character resets or teleport/plaza logic.
	  - Excludes 'control' completely; no fast-block fling/spam.
	  - Lock toggle locks world lockables/gates/doors when permitted, activates lock remotes/tools,
	    and locks UI drag while keeping close/toggle accessible.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
	LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
end

--------------------------------------------------------------------------------
-- 1. DELTA-COMPATIBLE UI MOUNTING
--------------------------------------------------------------------------------
local UI = {
	BG = Color3.fromRGB(16, 18, 25),
	CARD = Color3.fromRGB(26, 30, 42),
	BTN = Color3.fromRGB(40, 46, 64),
	BTN_ACTIVE = Color3.fromRGB(36, 150, 92),
	ACCENT = Color3.fromRGB(195, 42, 52),
	ESP_COLOR = Color3.fromRGB(64, 196, 255),
	SELF_TAG = Color3.fromRGB(255, 215, 110),
	TEXT = Color3.fromRGB(246, 248, 255),
	MUTED = Color3.fromRGB(175, 184, 206),
	STROKE = Color3.fromRGB(68, 76, 102),
}

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
	local existing = MountParent:FindFirstChild("SAB_Delta_Verified_UI")
	if existing then
		existing:Destroy()
	end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SAB_Delta_Verified_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not pcall(function()
	ScreenGui.Parent = MountParent
end) then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

--------------------------------------------------------------------------------
-- 2. STATE, COMMANDS (NO CONTROL), LOCK ALL, ESP/NUGGET ARCHER & AUTOBUY
--------------------------------------------------------------------------------
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

local selectedTarget = LocalPlayer
local lockEverythingEnabled = false
local espArcherEnabled = false
local autoBuyEnabled = false
local triedAutoBotPurchase = false

local lastAutoBuyClock = 0
local lastEspRefreshClock = 0
local avatarCache: { [number]: string } = {}
local playerEspObjects: { [Player]: { highlight: Highlight?, tag: BillboardGui? } } = {}
local savedPartAnchors: { [BasePart]: boolean } = {}

local Toast = Instance.new("TextLabel")
Toast.Size = UDim2.new(0, 225, 0, 20)
Toast.AnchorPoint = Vector2.new(0.5, 0)
Toast.Position = UDim2.new(0.5, 0, 0.11, 0)
Toast.BackgroundColor3 = UI.BG
Toast.TextColor3 = Color3.fromRGB(135, 255, 170)
Toast.Text = "Delta AP Ready"
Toast.TextSize = 9
Toast.Font = Enum.Font.GothamBold
Toast.Visible = false
Toast.ZIndex = 95
Toast.Parent = ScreenGui
Instance.new("UICorner", Toast).CornerRadius = UDim.new(0, 5)

local toastId = 0
local function notify(text, okStatus)
	toastId = toastId + 1
	local current = toastId
	Toast.Text = text
	if okStatus == false then
		Toast.TextColor3 = Color3.fromRGB(255, 125, 135)
	else
		Toast.TextColor3 = Color3.fromRGB(135, 255, 170)
	end
	Toast.Visible = true
	task.delay(2.0, function()
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

local cachedRemotes = nil
local lastScanClock = 0

local function isSafeRemoteName(lowName)
	if string.find(lowName, "teleport", 1, true)
		or string.find(lowName, "plaza", 1, true)
		or string.find(lowName, "trade", 1, true)
		or string.find(lowName, "lobby", 1, true)
		or string.find(lowName, "server", 1, true)
		or string.find(lowName, "join", 1, true)
	then
		return false
	end
	return true
end

local function getMatchingRemotes(keywords)
	local now = os.clock()
	if not cachedRemotes or (now - lastScanClock) > 8 then
		lastScanClock = now
		local found = {}
		local count = 0
		for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
			count = count + 1
			if count > 900 then
				break
			end
			if obj:IsA("RemoteEvent") or obj:IsA("UnreliableRemoteEvent") then
				if isSafeRemoteName(string.lower(obj.Name)) then
					table.insert(found, obj)
					if #found >= 32 then
						break
					end
				end
			end
		end
		cachedRemotes = found
	end

	local matched = {}
	for _, rem in ipairs(cachedRemotes) do
		local low = string.lower(rem.Name)
		for _, kw in ipairs(keywords) do
			if string.find(low, kw, 1, true) then
				table.insert(matched, rem)
				break
			end
		end
	end
	return matched
end

local function sendChatCommand(rawCmdText)
	pcall(function()
		local channels = TextChatService:FindFirstChild("TextChannels")
		local general = channels and channels:FindFirstChild("RBXGeneral")
		if general and general:IsA("TextChannel") then
			general:SendAsync(rawCmdText)
		end
	end)
end

local function applySafeSelfFeedback(cmd)
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
		if cmd == "balloon" then
			local head = char:FindFirstChild("Head")
			if head and head:IsA("BasePart") then
				head.Size = Vector3.new(
					math.min(head.Size.X * 1.25, 4),
					math.min(head.Size.Y * 1.25, 4),
					math.min(head.Size.Z * 1.25, 4)
				)
			end
		elseif cmd == "rocket" and root and root:IsA("BasePart") then
			root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 65, root.AssemblyLinearVelocity.Z)
		elseif cmd == "nightvision" then
			Lighting.ClockTime = 14
			Lighting.Brightness = 2
		end
	end)
end

local function runApForTarget(targetPlr)
	if not targetPlr or not targetPlr.Parent then
		notify("Select a target player first", false)
		return
	end

	if targetPlr == LocalPlayer then
		for _, cmd in ipairs(ADMIN_COMMANDS) do
			if cmd ~= "control" then
				applySafeSelfFeedback(cmd)
			end
		end
	end

	local adminRemotes = getMatchingRemotes({ "admin", "cmd", "command", "ap", "panel", "action" })
	local dispatched = 0

	for _, cmd in ipairs(ADMIN_COMMANDS) do
		if cmd ~= "control" then
			local formatted = ";" .. cmd .. " " .. targetPlr.Name
			for _, rem in ipairs(adminRemotes) do
				pcall(function()
					rem:FireServer(targetPlr, cmd)
				end)
				pcall(function()
					rem:FireServer(formatted)
				end)
				dispatched = dispatched + 1
			end
			if targetPlr ~= LocalPlayer then
				sendChatCommand(formatted)
			end
		end
	end

	local tag = if targetPlr == LocalPlayer then (targetPlr.Name .. " (ME)") else targetPlr.Name
	notify(string.format("AP (%d cmds, no control) -> %s", #ADMIN_COMMANDS, tag), true)
end

local function isCharacterPart(inst: Instance): boolean
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character and inst:IsDescendantOf(plr.Character) then
			return true
		end
	end
	return false
end

local function applyLockEverythingState(shouldLock: boolean)
	local lockRemotes = getMatchingRemotes({ "lock", "guard", "shield", "base", "door", "gate" })
	for _, rem in ipairs(lockRemotes) do
		pcall(function()
			rem:FireServer(shouldLock)
			rem:FireServer("LockAll", shouldLock)
			if selectedTarget and selectedTarget.Parent then
				rem:FireServer(selectedTarget, shouldLock)
			end
		end)
	end

	local char = LocalPlayer.Character
	if char then
		for _, item in ipairs(char:GetChildren()) do
			if item:IsA("Tool") then
				pcall(function()
					item:Activate()
				end)
			end
		end
	end

	-- Lock/unlock non-character lockables (doors, gates, base lock parts) when allowed
	local scanned = 0
	for _, desc in ipairs(workspace:GetDescendants()) do
		scanned = scanned + 1
		if scanned > 1400 then
			break
		end
		if not isCharacterPart(desc) then
			local low = string.lower(desc.Name)
			local isLockable = string.find(low, "lock", 1, true)
				or string.find(low, "door", 1, true)
				or string.find(low, "gate", 1, true)
				or string.find(low, "shield", 1, true)
			if isLockable and desc:IsA("BasePart") then
				pcall(function()
					if shouldLock then
						if savedPartAnchors[desc] == nil then
							savedPartAnchors[desc] = desc.Anchored
						end
						desc.Anchored = true
					elseif savedPartAnchors[desc] ~= nil then
						desc.Anchored = savedPartAnchors[desc]
						savedPartAnchors[desc] = nil
					end
				end)
			end
		end
	end
end

local function runLockEverythingButton()
	lockEverythingEnabled = not lockEverythingEnabled
	applyLockEverythingState(lockEverythingEnabled)
	notify("LOCK EVERYTHING: " .. (if lockEverythingEnabled then "ON" else "OFF"), true)
end

--------------------------------------------------------------------------------
-- 3. PLAYER ESP + CHARACTER ARCHER (NUGGET POINTER)
--------------------------------------------------------------------------------
local ArcherHud = Instance.new("TextLabel")
ArcherHud.Size = UDim2.new(0, 148, 0, 18)
ArcherHud.AnchorPoint = Vector2.new(0.5, 0)
ArcherHud.Position = UDim2.new(0.5, 0, 0.15, 0)
ArcherHud.BackgroundColor3 = UI.BG
ArcherHud.TextColor3 = UI.ESP_COLOR
ArcherHud.Text = "Nugget Arrow: --"
ArcherHud.TextSize = 8
ArcherHud.Font = Enum.Font.GothamBlack
ArcherHud.Visible = false
ArcherHud.ZIndex = 92
ArcherHud.Parent = ScreenGui
Instance.new("UICorner", ArcherHud).CornerRadius = UDim.new(0, 5)
local ahStroke = Instance.new("UIStroke")
ahStroke.Color = UI.ESP_COLOR
ahStroke.Thickness = 1
ahStroke.Parent = ArcherHud

local function getInstanceWorldPos(obj: Instance): Vector3?
	if obj:IsA("BasePart") then
		return obj.Position
	elseif obj:IsA("Model") then
		local piv = obj:GetPivot()
		return piv.Position
	elseif obj.Parent then
		if obj.Parent:IsA("BasePart") then
			return obj.Parent.Position
		elseif obj.Parent:IsA("Model") then
			return obj.Parent:GetPivot().Position
		end
	end
	return nil
end

local function findNearestNuggetPos(originPos: Vector3): (Vector3?, number)
	local bestPos: Vector3? = nil
	local bestDist = math.huge
	local scanned = 0

	for _, desc in ipairs(workspace:GetDescendants()) do
		scanned = scanned + 1
		if scanned > 1400 then
			break
		end
		if desc:IsA("BasePart") or desc:IsA("Model") then
			if string.find(string.lower(desc.Name), "nugget", 1, true) then
				local p = getInstanceWorldPos(desc)
				if p then
					local d = (p - originPos).Magnitude
					if d < bestDist then
						bestDist = d
						bestPos = p
					end
				end
			end
		end
	end

	return bestPos, bestDist
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
	ArcherHud.Visible = false
end

local function updatePlayerEspAndArcher()
	if not espArcherEnabled then
		ArcherHud.Visible = false
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
				local entry = playerEspObjects[plr]
				if not entry then
					entry = {}
					playerEspObjects[plr] = entry
				end

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
					lbl.BackgroundTransparency = 0.4
					lbl.BackgroundColor3 = UI.BG
					lbl.TextColor3 = UI.ESP_COLOR
					lbl.TextSize = 8
					lbl.Font = Enum.Font.GothamBold
					lbl.Parent = bg
					Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 4)

					entry.tag = bg
				else
					entry.tag.Adornee = adorneePart
				end

				local lbl = entry.tag and entry.tag:FindFirstChild("Label")
				if lbl and lbl:IsA("TextLabel") then
					if myPos then
						local dist = math.floor((pRoot.Position - myPos).Magnitude)
						lbl.Text = string.format("%s [%dm]", plr.Name, dist)
					else
						lbl.Text = plr.Name
					end
				end
			else
				clearPlayerEspFor(plr)
			end
		end
	end

	if myPos and root and root:IsA("BasePart") then
		local nugPos, dist = findNearestNuggetPos(myPos)
		if nugPos then
			ArcherHud.Visible = true
			local flatDir = Vector3.new(nugPos.X - myPos.X, 0, nugPos.Z - myPos.Z)
			local lookFlat = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
			local arrow = "^"
			if flatDir.Magnitude > 0.25 and lookFlat.Magnitude > 0.05 then
				local unitTarget = flatDir.Unit
				local unitLook = lookFlat.Unit
				local crossY = unitLook:Cross(unitTarget).Y
				local dot = math.clamp(unitLook:Dot(unitTarget), -1, 1)
				local angleDeg = math.deg(math.atan2(crossY, dot))
				if math.abs(angleDeg) <= 28 then
					arrow = "^"
				elseif angleDeg > 28 and angleDeg <= 135 then
					arrow = "->"
				elseif angleDeg < -28 and angleDeg >= -135 then
					arrow = "<-"
				else
					arrow = "v"
				end
			end
			ArcherHud.Text = string.format("%s NUGGET [%dm]", arrow, math.floor(dist))
		else
			ArcherHud.Visible = true
			ArcherHud.Text = "Nugget: None nearby"
		end
	else
		ArcherHud.Visible = false
	end
end

--------------------------------------------------------------------------------
-- 4. AUTOBUY NEAREST ITEM + GET AUTO BOT IF NEEDED
--------------------------------------------------------------------------------
local function tryBuyAutoBotIfNeeded()
	if triedAutoBotPurchase then
		return
	end
	triedAutoBotPurchase = true

	local botRemotes = getMatchingRemotes({ "bot", "autobuy", "auto", "buy", "shop", "purchase" })
	for _, rem in ipairs(botRemotes) do
		pcall(function()
			rem:FireServer("AutoBot")
		end)
		pcall(function()
			rem:FireServer("autobot")
		end)
		pcall(function()
			rem:FireServer("AutoBot", true)
		end)
	end

	local scanned = 0
	for _, desc in ipairs(workspace:GetDescendants()) do
		scanned = scanned + 1
		if scanned > 1200 then
			break
		end
		local fullLow = string.lower(desc:GetFullName())
		if string.find(fullLow, "autobot", 1, true) or string.find(fullLow, "auto_bot", 1, true) then
			if desc:IsA("ProximityPrompt") then
				pcall(function()
					fireproximityprompt(desc)
				end)
			elseif desc:IsA("ClickDetector") then
				pcall(function()
					fireclickdetector(desc)
				end)
			end
		end
	end
end

local function runAutoBuyStep()
	if not autoBuyEnabled then
		return
	end

	tryBuyAutoBotIfNeeded()

	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not char or not root or not root:IsA("BasePart") then
		return
	end

	local myPos = root.Position
	local nearestPrompt: ProximityPrompt? = nil
	local nearestClick: ClickDetector? = nil
	local bestDist = 45
	local scanned = 0

	for _, desc in ipairs(workspace:GetDescendants()) do
		scanned = scanned + 1
		if scanned > 1200 then
			break
		end
		if desc:IsA("ProximityPrompt") and desc.Enabled then
			local p = getInstanceWorldPos(desc)
			if p then
				local d = (p - myPos).Magnitude
				if d < bestDist then
					bestDist = d
					nearestPrompt = desc
					nearestClick = nil
				end
			end
		elseif desc:IsA("ClickDetector") then
			local p = getInstanceWorldPos(desc)
			if p then
				local d = (p - myPos).Magnitude
				if d < bestDist then
					bestDist = d
					nearestClick = desc
					nearestPrompt = nil
				end
			end
		end
	end

	if nearestPrompt then
		pcall(function()
			if type(fireproximityprompt) == "function" then
				fireproximityprompt(nearestPrompt)
			else
				nearestPrompt:InputHoldBegin()
				task.delay(0.05, function()
					pcall(function()
						nearestPrompt:InputHoldEnd()
					end)
				end)
			end
		end)
	elseif nearestClick then
		pcall(function()
			if type(fireclickdetector) == "function" then
				fireclickdetector(nearestClick)
			end
		end)
	end

	local buyRemotes = getMatchingRemotes({ "buy", "purchase", "shop", "autobuy" })
	for _, rem in ipairs(buyRemotes) do
		pcall(function()
			rem:FireServer("Nearest")
		end)
		pcall(function()
			rem:FireServer()
		end)
	end
end

--------------------------------------------------------------------------------
-- 5. COMPACT DRAGGABLE GUI (LOCKS DRAG WHEN LOCK EVERYTHING IS ON)
--------------------------------------------------------------------------------
local function makeDraggable(frame)
	local dragging = false
	local dragStart = nil
	local startPos = nil

	frame.InputBegan:Connect(function(input)
		if lockEverythingEnabled then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if lockEverythingEnabled then
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

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 54, 0, 20)
OpenBtn.Position = UDim2.new(0.02, 0, 0.20, 0)
OpenBtn.BackgroundColor3 = UI.BG
OpenBtn.TextColor3 = UI.TEXT
OpenBtn.Text = "AP"
OpenBtn.TextSize = 8
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.ZIndex = 70
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 5)
makeDraggable(OpenBtn)

local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0, 198, 0, 196)
Panel.Position = UDim2.new(0.02, 0, 0.25, 0)
Panel.BackgroundColor3 = UI.BG
Panel.BorderSizePixel = 0
Panel.ZIndex = 72
Panel.Parent = ScreenGui
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 7)
local stroke = Instance.new("UIStroke")
stroke.Color = UI.STROKE
stroke.Thickness = 1
stroke.Parent = Panel
makeDraggable(Panel)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 20)
TitleBar.BackgroundColor3 = UI.CARD
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 73
TitleBar.Parent = Panel
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 7)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -24, 1, 0)
TitleLabel.Position = UDim2.new(0, 6, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "AP (NO CTRL)"
TitleLabel.TextColor3 = UI.TEXT
TitleLabel.TextSize = 8
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 74
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 16, 0, 15)
CloseBtn.Position = UDim2.new(1, -18, 0.5, -7)
CloseBtn.BackgroundColor3 = UI.ACCENT
CloseBtn.TextColor3 = UI.TEXT
CloseBtn.Text = "X"
CloseBtn.TextSize = 8
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 74
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

local TargetAvatar = Instance.new("ImageLabel")
TargetAvatar.Size = UDim2.new(0, 14, 0, 14)
TargetAvatar.Position = UDim2.new(0, 5, 0, 23)
TargetAvatar.BackgroundColor3 = UI.CARD
TargetAvatar.BorderSizePixel = 0
TargetAvatar.ZIndex = 74
TargetAvatar.Parent = Panel
Instance.new("UICorner", TargetAvatar).CornerRadius = UDim.new(1, 0)
applyAvatarThumbnail(TargetAvatar, LocalPlayer.UserId)

local TargetLbl = Instance.new("TextLabel")
TargetLbl.Size = UDim2.new(1, -24, 0, 14)
TargetLbl.Position = UDim2.new(0, 22, 0, 23)
TargetLbl.BackgroundTransparency = 1
TargetLbl.Text = "Target: " .. LocalPlayer.Name .. " (ME)"
TargetLbl.TextColor3 = UI.MUTED
TargetLbl.TextSize = 7
TargetLbl.Font = Enum.Font.GothamBold
TargetLbl.TextXAlignment = Enum.TextXAlignment.Left
TargetLbl.TextTruncate = Enum.TextTruncate.AtEnd
TargetLbl.ZIndex = 74
TargetLbl.Parent = Panel

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(0.56, -6, 1, -43)
PlayerList.Position = UDim2.new(0, 5, 0, 39)
PlayerList.BackgroundColor3 = UI.CARD
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 2
PlayerList.ZIndex = 73
PlayerList.Parent = Panel
Instance.new("UICorner", PlayerList).CornerRadius = UDim.new(0, 5)

local pListLayout = Instance.new("UIListLayout")
pListLayout.Padding = UDim.new(0, 2)
pListLayout.SortOrder = Enum.SortOrder.LayoutOrder
pListLayout.Parent = PlayerList

local ActionBox = Instance.new("Frame")
ActionBox.Size = UDim2.new(0.44, -5, 1, -43)
ActionBox.Position = UDim2.new(0.56, 1, 0, 39)
ActionBox.BackgroundColor3 = UI.CARD
ActionBox.BorderSizePixel = 0
ActionBox.ZIndex = 73
ActionBox.Parent = Panel
Instance.new("UICorner", ActionBox).CornerRadius = UDim.new(0, 5)

local MainApBtn = Instance.new("TextButton")
MainApBtn.Size = UDim2.new(1, -8, 0, 24)
MainApBtn.Position = UDim2.new(0, 4, 0, 4)
MainApBtn.BackgroundColor3 = UI.ACCENT
MainApBtn.TextColor3 = UI.TEXT
MainApBtn.Text = "AP"
MainApBtn.TextSize = 9
MainApBtn.Font = Enum.Font.GothamBlack
MainApBtn.ZIndex = 74
MainApBtn.Parent = ActionBox
Instance.new("UICorner", MainApBtn).CornerRadius = UDim.new(0, 4)

local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(1, -8, 0, 24)
LockBtn.Position = UDim2.new(0, 4, 0, 31)
LockBtn.BackgroundColor3 = UI.BTN
LockBtn.TextColor3 = UI.TEXT
LockBtn.Text = "LOCK ALL: OFF"
LockBtn.TextSize = 7
LockBtn.Font = Enum.Font.GothamBlack
LockBtn.ZIndex = 74
LockBtn.Parent = ActionBox
Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0, 4)

local EspArcherBtn = Instance.new("TextButton")
EspArcherBtn.Size = UDim2.new(1, -8, 0, 28)
EspArcherBtn.Position = UDim2.new(0, 4, 0, 58)
EspArcherBtn.BackgroundColor3 = UI.BTN
EspArcherBtn.TextColor3 = UI.TEXT
EspArcherBtn.Text = "ESP / ARCHER: OFF"
EspArcherBtn.TextSize = 7
EspArcherBtn.TextWrapped = true
EspArcherBtn.Font = Enum.Font.GothamBlack
EspArcherBtn.ZIndex = 74
EspArcherBtn.Parent = ActionBox
Instance.new("UICorner", EspArcherBtn).CornerRadius = UDim.new(0, 4)

local AutoBuyBtn = Instance.new("TextButton")
AutoBuyBtn.Size = UDim2.new(1, -8, 0, 28)
AutoBuyBtn.Position = UDim2.new(0, 4, 0, 89)
AutoBuyBtn.BackgroundColor3 = UI.BTN
AutoBuyBtn.TextColor3 = UI.TEXT
AutoBuyBtn.Text = "AUTOBUY: OFF"
AutoBuyBtn.TextSize = 7
AutoBuyBtn.TextWrapped = true
AutoBuyBtn.Font = Enum.Font.GothamBlack
AutoBuyBtn.ZIndex = 74
AutoBuyBtn.Parent = ActionBox
Instance.new("UICorner", AutoBuyBtn).CornerRadius = UDim.new(0, 4)

local function formatPlayerTag(plr)
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
		row.Size = UDim2.new(1, -3, 0, 20)
		row.BackgroundColor3 = if isSelected then UI.BTN_ACTIVE else UI.BTN
		row.BorderSizePixel = 0
		row.ZIndex = 74
		row.Parent = PlayerList
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)

		local avatar = Instance.new("ImageLabel")
		avatar.Size = UDim2.new(0, 14, 0, 14)
		avatar.Position = UDim2.new(0, 3, 0.5, -7)
		avatar.BackgroundColor3 = UI.BG
		avatar.BorderSizePixel = 0
		avatar.ZIndex = 75
		avatar.Parent = row
		Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
		applyAvatarThumbnail(avatar, plr.UserId)

		local pickBtn = Instance.new("TextButton")
		pickBtn.Size = UDim2.new(1, -20, 1, 0)
		pickBtn.Position = UDim2.new(0, 19, 0, 0)
		pickBtn.BackgroundTransparency = 1
		pickBtn.Text = formatPlayerTag(plr)
		if isSelf and not isSelected then
			pickBtn.TextColor3 = UI.SELF_TAG
		else
			pickBtn.TextColor3 = UI.TEXT
		end
		pickBtn.TextSize = 7
		pickBtn.Font = Enum.Font.GothamBold
		pickBtn.TextXAlignment = Enum.TextXAlignment.Left
		pickBtn.TextTruncate = Enum.TextTruncate.AtEnd
		pickBtn.ZIndex = 75
		pickBtn.Parent = row

		pickBtn.MouseButton1Click:Connect(function()
			selectedTarget = plr
			refreshTargetLabel()
			rebuildPlayerList()
		end)
	end

	PlayerList.CanvasSize = UDim2.new(0, 0, 0, math.max(#plrs * 22, 22))
end

local function syncFeatureVisuals()
	LockBtn.BackgroundColor3 = if lockEverythingEnabled then UI.BTN_ACTIVE else UI.BTN
	LockBtn.Text = if lockEverythingEnabled then "LOCK ALL: ON" else "LOCK ALL: OFF"
	stroke.Color = if lockEverythingEnabled then UI.BTN_ACTIVE else UI.STROKE

	EspArcherBtn.BackgroundColor3 = if espArcherEnabled then UI.BTN_ACTIVE else UI.BTN
	EspArcherBtn.Text = if espArcherEnabled then "ESP / ARCHER: ON" else "ESP / ARCHER: OFF"

	AutoBuyBtn.BackgroundColor3 = if autoBuyEnabled then UI.BTN_ACTIVE else UI.BTN
	AutoBuyBtn.Text = if autoBuyEnabled then "AUTOBUY: ON" else "AUTOBUY: OFF"
end

MainApBtn.MouseButton1Click:Connect(function()
	runApForTarget(selectedTarget)
end)

LockBtn.MouseButton1Click:Connect(function()
	runLockEverythingButton()
	syncFeatureVisuals()
end)

EspArcherBtn.MouseButton1Click:Connect(function()
	espArcherEnabled = not espArcherEnabled
	syncFeatureVisuals()
	if not espArcherEnabled then
		clearAllEsp()
	else
		updatePlayerEspAndArcher()
	end
	notify("ESP / ARCHER: " .. (if espArcherEnabled then "ON" else "OFF"), true)
end)

AutoBuyBtn.MouseButton1Click:Connect(function()
	autoBuyEnabled = not autoBuyEnabled
	if autoBuyEnabled then
		triedAutoBotPurchase = false
		runAutoBuyStep()
	end
	syncFeatureVisuals()
	notify("AUTOBUY: " .. (if autoBuyEnabled then "ON" else "OFF"), true)
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

RunService.Heartbeat:Connect(function()
	local now = os.clock()
	if espArcherEnabled and (now - lastEspRefreshClock) >= 0.12 then
		lastEspRefreshClock = now
		pcall(updatePlayerEspAndArcher)
	end
	if autoBuyEnabled and (now - lastAutoBuyClock) >= 0.45 then
		lastAutoBuyClock = now
		pcall(runAutoBuyStep)
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
syncFeatureVisuals()