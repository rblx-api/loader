local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("NoxaSpeedBypass") then
	PlayerGui.NoxaSpeedBypass:Destroy()
end

-- ==========================================
-- LOGIC V1 / V2 / V3
-- ==========================================
local Versions = {
	V1 = { depth = 297, mainValue = 97200, waitTime = 0.1320 },
	V2 = { depth = 187, mainValue = 97333, waitTime = 0.1569 },
	V3 = { depth = 297, mainValue = 97175, waitTime = 0.1316 }
}

local TARGET_REMOTE_NAME = "SetPlayerBlockList"
local cachedRemote = nil
local isRunning = false
local loopThread = nil

local function findRemote()
	for _, obj in ipairs(game:GetDescendants()) do
		if (obj:IsA("RemoteEvent") or obj:IsA("UnreliableRemoteEvent")) and obj.Name == TARGET_REMOTE_NAME then
			return obj
		end
	end
	return nil
end

local function createBomb(depth, mainValue)
	local bomb = {}
	local current = bomb
	for i = 1, depth do
		local nextT = {}
		current[1] = nextT
		current = nextT
	end
	local outer = {}
	local count = math.floor(mainValue / (depth + 2))
	for i = 1, count do
		outer[i] = bomb
	end
	return outer
end

-- ==========================================
-- STATES
-- ==========================================
local states = {
	enabled = false,
	locked = false,
	minimized = false,
	version = 2,
	keybind = Enum.KeyCode.Z,
	autoBrainrot = false,
	waitingForKey = false
}

-- Auto Brainrot (logique Space Ping / Galaxy)
local brainrotMode = false
local lastBrainrotState = false
local manualOverride = false

local function tween(obj, props, time, style)
	local t = TweenService:Create(obj, TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
	t:Play()
	return t
end

-- ==========================================
-- GUI
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NoxaSpeedBypass"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Main Frame (exact style vidéo)
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 280, 0, 340)
Main.Position = UDim2.new(0.5, -140, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Main.BackgroundTransparency = 0.15
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 18)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(40, 40, 50)
MainStroke.Thickness = 1.2
MainStroke.Transparency = 0.4
MainStroke.Parent = Main

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, 36)
Title.Position = UDim2.new(0, 16, 0, 6)
Title.BackgroundTransparency = 1
Title.Text = "Noxa Bypass"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

-- Lock Button
local LockBtn = Instance.new("TextButton")
LockBtn.Name = "Lock"
LockBtn.Size = UDim2.new(0, 28, 0, 28)
LockBtn.Position = UDim2.new(1, -62, 0, 10)
LockBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
LockBtn.BackgroundTransparency = 0.3
LockBtn.Text = "🔓"
LockBtn.TextSize = 13
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
LockBtn.AutoButtonColor = false
LockBtn.Parent = Main
Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(1, 0)

-- Minimize
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -30, 0, 10)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "−"
MinBtn.TextSize = 20
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
MinBtn.Parent = Main

-- ========== KEYBIND ROW ==========
local KeyRow = Instance.new("Frame")
KeyRow.Size = UDim2.new(1, -24, 0, 42)
KeyRow.Position = UDim2.new(0, 12, 0, 48)
KeyRow.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
KeyRow.BackgroundTransparency = 0.25
KeyRow.BorderSizePixel = 0
KeyRow.Parent = Main
Instance.new("UICorner", KeyRow).CornerRadius = UDim.new(0, 12)

local KeyLabel = Instance.new("TextLabel")
KeyLabel.Size = UDim2.new(0.45, 0, 1, 0)
KeyLabel.Position = UDim2.new(0, 14, 0, 0)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "Keybind"
KeyLabel.Font = Enum.Font.Gotham
KeyLabel.TextSize = 14
KeyLabel.TextColor3 = Color3.fromRGB(210, 210, 220)
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
KeyLabel.Parent = KeyRow

local KeyBtn = Instance.new("TextButton")
KeyBtn.Size = UDim2.new(0, 48, 0, 28)
KeyBtn.Position = UDim2.new(1, -58, 0.5, -14)
KeyBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
KeyBtn.BackgroundTransparency = 0.2
KeyBtn.Text = "Z"
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.TextSize = 14
KeyBtn.TextColor3 = Color3.fromRGB(240, 240, 250)
KeyBtn.AutoButtonColor = false
KeyBtn.Parent = KeyRow
Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 8)

-- ========== POWER ROW ==========
local PowerRow = Instance.new("Frame")
PowerRow.Size = UDim2.new(1, -24, 0, 42)
PowerRow.Position = UDim2.new(0, 12, 0, 98)
PowerRow.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
PowerRow.BackgroundTransparency = 0.25
PowerRow.BorderSizePixel = 0
PowerRow.Parent = Main
Instance.new("UICorner", PowerRow).CornerRadius = UDim.new(0, 12)

local PowerLabel = Instance.new("TextLabel")
PowerLabel.Size = UDim2.new(0.45, 0, 1, 0)
PowerLabel.Position = UDim2.new(0, 14, 0, 0)
PowerLabel.BackgroundTransparency = 1
PowerLabel.Text = "Power"
PowerLabel.Font = Enum.Font.Gotham
PowerLabel.TextSize = 14
PowerLabel.TextColor3 = Color3.fromRGB(210, 210, 220)
PowerLabel.TextXAlignment = Enum.TextXAlignment.Left
PowerLabel.Parent = PowerRow

local PowerBox = Instance.new("Frame")
PowerBox.Size = UDim2.new(0, 80, 0, 28)
PowerBox.Position = UDim2.new(1, -90, 0.5, -14)
PowerBox.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
PowerBox.BackgroundTransparency = 0.2
PowerBox.BorderSizePixel = 0
PowerBox.Parent = PowerRow
Instance.new("UICorner", PowerBox).CornerRadius = UDim.new(0, 8)

local PowerInput = Instance.new("TextBox")
PowerInput.Size = UDim2.new(1, -8, 1, 0)
PowerInput.Position = UDim2.new(0, 4, 0, 0)
PowerInput.BackgroundTransparency = 1
PowerInput.Text = "100000"
PowerInput.Font = Enum.Font.GothamBold
PowerInput.TextSize = 13
PowerInput.TextColor3 = Color3.fromRGB(240, 240, 250)
PowerInput.ClearTextOnFocus = false
PowerInput.Parent = PowerBox

-- ========== VERSION ROW ==========
local VerRow = Instance.new("Frame")
VerRow.Size = UDim2.new(1, -24, 0, 42)
VerRow.Position = UDim2.new(0, 12, 0, 148)
VerRow.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
VerRow.BackgroundTransparency = 0.25
VerRow.BorderSizePixel = 0
VerRow.Parent = Main
Instance.new("UICorner", VerRow).CornerRadius = UDim.new(0, 12)

local VerLabel = Instance.new("TextLabel")
VerLabel.Size = UDim2.new(0.45, 0, 1, 0)
VerLabel.Position = UDim2.new(0, 14, 0, 0)
VerLabel.BackgroundTransparency = 1
VerLabel.Text = "Version"
VerLabel.Font = Enum.Font.Gotham
VerLabel.TextSize = 14
VerLabel.TextColor3 = Color3.fromRGB(210, 210, 220)
VerLabel.TextXAlignment = Enum.TextXAlignment.Left
VerLabel.Parent = VerRow

local PrevBtn = Instance.new("TextButton")
PrevBtn.Size = UDim2.new(0, 26, 0, 28)
PrevBtn.Position = UDim2.new(1, -90, 0.5, -14)
PrevBtn.BackgroundTransparency = 1
PrevBtn.Text = "<"
PrevBtn.Font = Enum.Font.GothamBold
PrevBtn.TextSize = 15
PrevBtn.TextColor3 = Color3.fromRGB(180, 180, 195)
PrevBtn.Parent = VerRow

local VerText = Instance.new("TextLabel")
VerText.Size = UDim2.new(0, 36, 0, 28)
VerText.Position = UDim2.new(1, -64, 0.5, -14)
VerText.BackgroundTransparency = 1
VerText.Text = "V2"
VerText.Font = Enum.Font.GothamBold
VerText.TextSize = 14
VerText.TextColor3 = Color3.fromRGB(240, 240, 250)
VerText.Parent = VerRow

local NextBtn = Instance.new("TextButton")
NextBtn.Size = UDim2.new(0, 26, 0, 28)
NextBtn.Position = UDim2.new(1, -30, 0.5, -14)
NextBtn.BackgroundTransparency = 1
NextBtn.Text = ">"
NextBtn.Font = Enum.Font.GothamBold
NextBtn.TextSize = 15
NextBtn.TextColor3 = Color3.fromRGB(180, 180, 195)
NextBtn.Parent = VerRow

-- ========== AUTO BRAINROT ==========
local AutoRow = Instance.new("Frame")
AutoRow.Size = UDim2.new(1, -24, 0, 42)
AutoRow.Position = UDim2.new(0, 12, 0, 198)
AutoRow.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
AutoRow.BackgroundTransparency = 0.25
AutoRow.BorderSizePixel = 0
AutoRow.Parent = Main
Instance.new("UICorner", AutoRow).CornerRadius = UDim.new(0, 12)

local AutoLabel = Instance.new("TextLabel")
AutoLabel.Size = UDim2.new(0.6, 0, 1, 0)
AutoLabel.Position = UDim2.new(0, 14, 0, 0)
AutoLabel.BackgroundTransparency = 1
AutoLabel.Text = "Auto Brainrot"
AutoLabel.Font = Enum.Font.Gotham
AutoLabel.TextSize = 14
AutoLabel.TextColor3 = Color3.fromRGB(210, 210, 220)
AutoLabel.TextXAlignment = Enum.TextXAlignment.Left
AutoLabel.Parent = AutoRow

local ToggleBg = Instance.new("Frame")
ToggleBg.Size = UDim2.new(0, 44, 0, 24)
ToggleBg.Position = UDim2.new(1, -56, 0.5, -12)
ToggleBg.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
ToggleBg.BorderSizePixel = 0
ToggleBg.Parent = AutoRow
Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

local ToggleKnob = Instance.new("Frame")
ToggleKnob.Size = UDim2.new(0, 20, 0, 20)
ToggleKnob.Position = UDim2.new(0, 2, 0.5, -10)
ToggleKnob.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
ToggleKnob.BorderSizePixel = 0
ToggleKnob.Parent = ToggleBg
Instance.new("UICorner", ToggleKnob).CornerRadius = UDim.new(1, 0)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Text = ""
ToggleBtn.Parent = ToggleBg

-- ========== MAIN BUTTON ==========
local MainBtn = Instance.new("TextButton")
MainBtn.Size = UDim2.new(1, -24, 0, 48)
MainBtn.Position = UDim2.new(0, 12, 1, -62)
MainBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
MainBtn.BackgroundTransparency = 0.15
MainBtn.Text = "DISABLED"
MainBtn.Font = Enum.Font.GothamBold
MainBtn.TextSize = 15
MainBtn.TextColor3 = Color3.fromRGB(160, 160, 170)
MainBtn.AutoButtonColor = false
MainBtn.Parent = Main
Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(0, 12)

local MainBtnStroke = Instance.new("UIStroke")
MainBtnStroke.Color = Color3.fromRGB(50, 50, 60)
MainBtnStroke.Thickness = 1
MainBtnStroke.Transparency = 0.5
MainBtnStroke.Parent = MainBtn

-- ========== MINIMIZED FRAME ==========
local Mini = Instance.new("Frame")
Mini.Name = "Mini"
Mini.Size = UDim2.new(0, 280, 0, 90)
Mini.Position = UDim2.new(0.5, -140, 0.5, -45)
Mini.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Mini.BackgroundTransparency = 0.12
Mini.BorderSizePixel = 0
Mini.Visible = false
Mini.Active = true
Mini.Parent = ScreenGui
Instance.new("UICorner", Mini).CornerRadius = UDim.new(0, 16)

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(40, 40, 50)
MiniStroke.Thickness = 1.2
MiniStroke.Transparency = 0.4
MiniStroke.Parent = Mini

local MiniTitle = Instance.new("TextLabel")
MiniTitle.Size = UDim2.new(1, -70, 0, 32)
MiniTitle.Position = UDim2.new(0, 14, 0, 4)
MiniTitle.BackgroundTransparency = 1
MiniTitle.Text = "Noxa Bypass"
MiniTitle.Font = Enum.Font.GothamBold
MiniTitle.TextSize = 15
MiniTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
MiniTitle.TextXAlignment = Enum.TextXAlignment.Left
MiniTitle.Parent = Mini

local MiniLock = Instance.new("TextButton")
MiniLock.Size = UDim2.new(0, 28, 0, 28)
MiniLock.Position = UDim2.new(1, -62, 0, 6)
MiniLock.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
MiniLock.BackgroundTransparency = 0.3
MiniLock.Text = "🔓"
MiniLock.TextSize = 13
MiniLock.Font = Enum.Font.GothamBold
MiniLock.TextColor3 = Color3.fromRGB(180, 180, 190)
MiniLock.AutoButtonColor = false
MiniLock.Parent = Mini
Instance.new("UICorner", MiniLock).CornerRadius = UDim.new(1, 0)

local ExpandBtn = Instance.new("TextButton")
ExpandBtn.Size = UDim2.new(0, 28, 0, 28)
ExpandBtn.Position = UDim2.new(1, -30, 0, 6)
ExpandBtn.BackgroundTransparency = 1
ExpandBtn.Text = "+"
ExpandBtn.TextSize = 18
ExpandBtn.Font = Enum.Font.GothamBold
ExpandBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
ExpandBtn.Parent = Mini

local MiniMainBtn = Instance.new("TextButton")
MiniMainBtn.Size = UDim2.new(1, -24, 0, 40)
MiniMainBtn.Position = UDim2.new(0, 12, 0, 40)
MiniMainBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
MiniMainBtn.BackgroundTransparency = 0.15
MiniMainBtn.Text = "DISABLED"
MiniMainBtn.Font = Enum.Font.GothamBold
MiniMainBtn.TextSize = 14
MiniMainBtn.TextColor3 = Color3.fromRGB(160, 160, 170)
MiniMainBtn.AutoButtonColor = false
MiniMainBtn.Parent = Mini
Instance.new("UICorner", MiniMainBtn).CornerRadius = UDim.new(0, 10)

-- ========== DRAGGING ==========
local dragging, dragStart, startPos, currentFrame

local function makeDraggable(frame)
	frame.InputBegan:Connect(function(input)
		if states.locked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			currentFrame = frame
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					currentFrame = nil
				end
			end)
		end
	end)
end

UserInputService.InputChanged:Connect(function(input)
	if dragging and currentFrame and not states.locked then
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - dragStart
			currentFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end
end)

makeDraggable(Main)
makeDraggable(Mini)

-- ==========================================
-- FUNCTIONS
-- ==========================================
local function getSettings()
	return Versions["V" .. states.version]
end

local function updateVersion()
	VerText.Text = "V" .. states.version
end

local function startBypass()
	if isRunning then return true end
	if not cachedRemote then
		cachedRemote = findRemote()
		if not cachedRemote then
			print("[Noxa] Remote introuvable")
			return false
		end
	end

	isRunning = true
	local settings = getSettings()
	local bomb = createBomb(settings.depth, settings.mainValue)

	loopThread = task.spawn(function()
		while isRunning do
			pcall(function()
				cachedRemote:FireServer(bomb)
			end)
			task.wait(settings.waitTime)
		end
	end)
	return true
end

local function stopBypass()
	isRunning = false
	if loopThread then
		task.cancel(loopThread)
		loopThread = nil
	end
end

-- Lock
local function setLocked(locked)
	states.locked = locked
	local icon = locked and "🔒" or "🔓"
	LockBtn.Text = icon
	MiniLock.Text = icon

	local dim = locked and 0.55 or 0
	local col = locked and Color3.fromRGB(130, 130, 140) or Color3.fromRGB(240, 240, 250)

	tween(KeyBtn, {TextTransparency = dim, TextColor3 = col}, 0.25)
	tween(PowerInput, {TextTransparency = dim, TextColor3 = col}, 0.25)
	tween(PrevBtn, {TextTransparency = dim}, 0.25)
	tween(NextBtn, {TextTransparency = dim}, 0.25)
	tween(VerText, {TextTransparency = dim}, 0.25)

	if locked then
		dragging = false
		currentFrame = nil
		LockBtn.BackgroundColor3 = Color3.fromRGB(60, 35, 40)
		MiniLock.BackgroundColor3 = Color3.fromRGB(60, 35, 40)
	else
		LockBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
		MiniLock.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
	end
end

-- Enable / Disable
local function setEnabled(on, isManual)
	if isManual then
		if brainrotMode then
			manualOverride = not on
		else
			manualOverride = false
		end
	end

	states.enabled = on
	if on then
		if not startBypass() then
			states.enabled = false
			return
		end
		MainBtn.Text = "ENABLED"
		MiniMainBtn.Text = "ENABLED"
		-- Exactement comme la vidéo : fond identique + texte un peu plus clair + contour blanc
		MainBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
		MiniMainBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
		MainBtn.TextColor3 = Color3.fromRGB(230, 230, 235)
		MiniMainBtn.TextColor3 = Color3.fromRGB(230, 230, 235)
		tween(MainBtnStroke, {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.25}, 0.2)
		tween(MainStroke, {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.45}, 0.2)
		tween(MiniStroke, {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.45}, 0.2)
	else
		stopBypass()
		MainBtn.Text = "DISABLED"
		MiniMainBtn.Text = "DISABLED"
		MainBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
		MiniMainBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
		MainBtn.TextColor3 = Color3.fromRGB(160, 160, 170)
		MiniMainBtn.TextColor3 = Color3.fromRGB(160, 160, 170)
		tween(MainBtnStroke, {Color = Color3.fromRGB(50, 50, 60), Transparency = 0.5}, 0.2)
		tween(MainStroke, {Color = Color3.fromRGB(40, 40, 50), Transparency = 0.4}, 0.2)
		tween(MiniStroke, {Color = Color3.fromRGB(40, 40, 50), Transparency = 0.4}, 0.2)
	end
end

-- Auto Brainrot
local function setAuto(on)
	states.autoBrainrot = on
	if on then
		tween(ToggleBg, {BackgroundColor3 = Color3.fromRGB(70, 200, 120)}, 0.25)
		tween(ToggleKnob, {Position = UDim2.new(1, -22, 0.5, -10)}, 0.25, Enum.EasingStyle.Back)
	else
		tween(ToggleBg, {BackgroundColor3 = Color3.fromRGB(70, 70, 80)}, 0.25)
		tween(ToggleKnob, {Position = UDim2.new(0, 2, 0.5, -10)}, 0.25, Enum.EasingStyle.Back)
		if brainrotMode then
			brainrotMode = false
			lastBrainrotState = false
			manualOverride = false
		end
	end
end

-- Connections
LockBtn.MouseButton1Click:Connect(function() setLocked(not states.locked) end)
MiniLock.MouseButton1Click:Connect(function() setLocked(not states.locked) end)

PrevBtn.MouseButton1Click:Connect(function()
	if states.locked then return end
	states.version = states.version <= 1 and 3 or states.version - 1
	updateVersion()
	if isRunning then stopBypass() startBypass() end
end)

NextBtn.MouseButton1Click:Connect(function()
	if states.locked then return end
	states.version = states.version >= 3 and 1 or states.version + 1
	updateVersion()
	if isRunning then stopBypass() startBypass() end
end)

KeyBtn.MouseButton1Click:Connect(function()
	if states.locked or states.waitingForKey then return end
	states.waitingForKey = true
	KeyBtn.Text = "..."
	local conn
	conn = UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			states.keybind = input.KeyCode
			KeyBtn.Text = input.KeyCode.Name:upper():sub(1, 3)
			states.waitingForKey = false
			conn:Disconnect()
		end
	end)
end)

ToggleBtn.MouseButton1Click:Connect(function()
	if states.locked then return end
	setAuto(not states.autoBrainrot)
end)

MainBtn.MouseButton1Click:Connect(function() setEnabled(not states.enabled, true) end)
MiniMainBtn.MouseButton1Click:Connect(function() setEnabled(not states.enabled, true) end)

MinBtn.MouseButton1Click:Connect(function()
	Main.Visible = false
	Mini.Visible = true
end)

ExpandBtn.MouseButton1Click:Connect(function()
	Mini.Visible = false
	Main.Visible = true
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe or states.waitingForKey then return end
	if input.KeyCode == states.keybind then
		setEnabled(not states.enabled, true)
	end
end)

-- ==========================================
-- AUTO BRAINROT (logique Space Ping / Galaxy)
-- Détecte WalkSpeed < 25 → active le lag automatiquement
-- ==========================================
RunService.Heartbeat:Connect(function()
	if not states.autoBrainrot then
		if brainrotMode then
			brainrotMode = false
			lastBrainrotState = false
		end
		return
	end

	local char = LocalPlayer.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	local hasBrainrot = hum.WalkSpeed < 25

	if hasBrainrot and not lastBrainrotState then
		brainrotMode = true
		lastBrainrotState = true
		manualOverride = false
		setEnabled(true, false)
	elseif not hasBrainrot and lastBrainrotState then
		brainrotMode = false
		lastBrainrotState = false
		manualOverride = false
		setEnabled(false, false)
	end
end)

-- Init
task.spawn(function()
	cachedRemote = findRemote()
	if cachedRemote then
		print("[Noxa] Remote trouvé")
	else
		print("[Noxa] Remote introuvable")
	end
end)

updateVersion()