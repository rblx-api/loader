--[[ Vexa Packet Lagger ]]
print("[Vexa] Packet Lagger loading")

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- cleanup
pcall(function()
	local function wipe(parent)
		if not parent then return end
		local o = parent:FindFirstChild("VexaPacketLagger")
		if o then o:Destroy() end
	end
	wipe(PlayerGui)
	if gethui then wipe(gethui()) end
end)

-- ============================================================
-- INTRO (black screen)
-- ============================================================
do
	local introGui = Instance.new("ScreenGui")
	introGui.Name = "VexaIntro"
	introGui.IgnoreGuiInset = true
	introGui.DisplayOrder = 10000
	introGui.ResetOnSpawn = false
	introGui.Parent = (gethui and gethui()) or PlayerGui

	local black = Instance.new("Frame")
	black.Size = UDim2.fromScale(1, 1)
	black.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	black.BorderSizePixel = 0
	black.Parent = introGui

	local msg = Instance.new("TextLabel")
	msg.AnchorPoint = Vector2.new(0.5, 0.5)
	msg.Position = UDim2.fromScale(0.5, 0.5)
	msg.Size = UDim2.new(0.85, 0, 0, 80)
	msg.BackgroundTransparency = 1
	msg.Font = Enum.Font.GothamBlack
	msg.TextSize = 28
	msg.TextColor3 = Color3.fromRGB(255, 255, 255)
	msg.TextWrapped = true
	msg.Text = "تبي السورس؟\nاجل ks omk"
	msg.Parent = black

	task.delay(2.2, function()
		pcall(function()
			TS:Create(black, TweenInfo.new(0.45), {BackgroundTransparency = 1}):Play()
			TS:Create(msg, TweenInfo.new(0.45), {TextTransparency = 1}):Play()
		end)
		task.delay(0.5, function()
			pcall(function() introGui:Destroy() end)
		end)
	end)
end

-- ============================================================
-- PACKET LOGIC (Op Packet style)
-- ============================================================
local Event = nil
local lagging = false
local lagThread = nil
local powerVal = 12000

local function resolveEvent()
	pcall(function()
		local ok, net = pcall(function()
			local pkgs = RS:WaitForChild("Packages", 5)
			return pkgs and pkgs:WaitForChild("Net", 5)
		end)
		if ok and net then
			local kids = net:GetChildren()
			Event = kids[6]
			if not Event or not (Event:IsA("RemoteEvent") or Event:IsA("RemoteFunction")) then
				for _, c in ipairs(kids) do
					if c:IsA("RemoteEvent") then
						Event = c
						break
					end
				end
			end
		end
	end)
	return Event
end
resolveEvent()

local function setPower(v)
	local n = tonumber(v)
	if not n then return powerVal end
	powerVal = math.clamp(math.floor(n), 1000, 800000)
	return powerVal
end

local function startLag()
	if lagging then return end
	lagging = true
	if not Event then resolveEvent() end
	local payload = table.create(math.max(powerVal, 100), function() end)
	lagThread = task.spawn(function()
		while lagging do
			for _ = 1, 3 do
				if Event then
					pcall(function() Event:FireServer(payload) end)
				end
			end
			task.wait(0.01)
		end
	end)
end

local function stopLag()
	if not lagging then return end
	lagging = false
	if lagThread then
		pcall(task.cancel, lagThread)
		lagThread = nil
	end
end

-- ============================================================
-- CFRAME MODE (simple)
-- ============================================================
local mode = "normal" -- normal | cframe
local cfConn = nil
local cfStuds = 1.2

local function stopCFrame()
	if cfConn then cfConn:Disconnect() cfConn = nil end
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then pcall(function() hum.WalkSpeed = 16 end) end
end

local function startCFrame()
	stopCFrame()
	cfConn = RunService.Heartbeat:Connect(function()
		if mode ~= "cframe" or not lagging then return end
		local char = LP.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not root or not hum then return end
		local move = hum.MoveDirection
		if move.Magnitude > 0.05 then
			root.CFrame = root.CFrame + move.Unit * cfStuds
		end
	end)
end

-- ============================================================
-- UI
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "VexaPacketLagger"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Parent = (gethui and gethui()) or PlayerGui

local MAIN_W, MAIN_H = 220, 52
local SET_H = 168

local root = Instance.new("Frame")
root.Name = "Root"
root.Size = UDim2.fromOffset(MAIN_W, MAIN_H)
root.Position = UDim2.new(0.5, -MAIN_W / 2, 0.72, 0)
root.BackgroundTransparency = 1
root.Parent = gui

-- main bar
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(MAIN_W, MAIN_H)
main.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = root
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(70, 70, 90)
mainStroke.Thickness = 1.2

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(12, 0)
title.Size = UDim2.new(0, 90, 1, 0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(240, 240, 250)
title.Text = "Vexa Packet"
title.Parent = main

-- lock
local locked = false
local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.fromOffset(30, 30)
lockBtn.Position = UDim2.fromOffset(108, 11)
lockBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
lockBtn.BorderSizePixel = 0
lockBtn.Text = "🔓"
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextSize = 13
lockBtn.TextColor3 = Color3.fromRGB(230, 230, 240)
lockBtn.AutoButtonColor = true
lockBtn.Parent = main
Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 8)

-- start / stop
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.fromOffset(58, 30)
startBtn.Position = UDim2.fromOffset(142, 11)
startBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 80)
startBtn.BorderSizePixel = 0
startBtn.Text = "start"
startBtn.Font = Enum.Font.GothamBlack
startBtn.TextSize = 12
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.AutoButtonColor = true
startBtn.Parent = main
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

-- settings toggle (+)
local open = false
local setBtn = Instance.new("TextButton")
setBtn.Size = UDim2.fromOffset(28, 30)
setBtn.Position = UDim2.fromOffset(MAIN_W - 34, 11)
setBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
setBtn.BorderSizePixel = 0
setBtn.Text = "+"
setBtn.Font = Enum.Font.GothamBlack
setBtn.TextSize = 16
setBtn.TextColor3 = Color3.fromRGB(230, 230, 240)
setBtn.AutoButtonColor = true
setBtn.Parent = main
Instance.new("UICorner", setBtn).CornerRadius = UDim.new(0, 8)

-- settings panel
local settings = Instance.new("Frame")
settings.Name = "Settings"
settings.Size = UDim2.fromOffset(MAIN_W, 0)
settings.Position = UDim2.fromOffset(0, MAIN_H + 6)
settings.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
settings.BorderSizePixel = 0
settings.ClipsDescendants = true
settings.Parent = root
Instance.new("UICorner", settings).CornerRadius = UDim.new(0, 12)
local setStroke = Instance.new("UIStroke", settings)
setStroke.Color = Color3.fromRGB(70, 70, 90)
setStroke.Thickness = 1.2

local setInner = Instance.new("Frame")
setInner.Size = UDim2.fromOffset(MAIN_W, SET_H)
setInner.BackgroundTransparency = 1
setInner.Parent = settings

-- mode row: normal | cframe
local modeRow = Instance.new("Frame")
modeRow.Size = UDim2.new(1, -16, 0, 30)
modeRow.Position = UDim2.fromOffset(8, 10)
modeRow.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
modeRow.BorderSizePixel = 0
modeRow.Parent = setInner
Instance.new("UICorner", modeRow).CornerRadius = UDim.new(0, 8)

local normalBtn = Instance.new("TextButton")
normalBtn.Size = UDim2.new(0.5, -1, 1, 0)
normalBtn.Position = UDim2.fromOffset(0, 0)
normalBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
normalBtn.BorderSizePixel = 0
normalBtn.Text = "normal"
normalBtn.Font = Enum.Font.GothamBold
normalBtn.TextSize = 12
normalBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
normalBtn.AutoButtonColor = false
normalBtn.Parent = modeRow
Instance.new("UICorner", normalBtn).CornerRadius = UDim.new(0, 8)

local cframeBtn = Instance.new("TextButton")
cframeBtn.Size = UDim2.new(0.5, -1, 1, 0)
cframeBtn.Position = UDim2.new(0.5, 1, 0, 0)
cframeBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
cframeBtn.BorderSizePixel = 0
cframeBtn.Text = "cframe"
cframeBtn.Font = Enum.Font.GothamBold
cframeBtn.TextSize = 12
cframeBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
cframeBtn.AutoButtonColor = false
cframeBtn.Parent = modeRow
Instance.new("UICorner", cframeBtn).CornerRadius = UDim.new(0, 8)

-- keybind
local kbLabel = Instance.new("TextLabel")
kbLabel.BackgroundTransparency = 1
kbLabel.Position = UDim2.fromOffset(10, 48)
kbLabel.Size = UDim2.new(1, -20, 0, 14)
kbLabel.Font = Enum.Font.GothamBold
kbLabel.TextSize = 11
kbLabel.TextXAlignment = Enum.TextXAlignment.Left
kbLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
kbLabel.Text = "keybind"
kbLabel.Parent = setInner

local kbBtn = Instance.new("TextButton")
kbBtn.Size = UDim2.new(1, -16, 0, 28)
kbBtn.Position = UDim2.fromOffset(8, 64)
kbBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
kbBtn.BorderSizePixel = 0
kbBtn.Text = "KEY · F"
kbBtn.Font = Enum.Font.GothamBold
kbBtn.TextSize = 12
kbBtn.TextColor3 = Color3.fromRGB(220, 220, 235)
kbBtn.AutoButtonColor = true
kbBtn.Parent = setInner
Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0, 8)

-- power
local powerLabel = Instance.new("TextLabel")
powerLabel.BackgroundTransparency = 1
powerLabel.Position = UDim2.fromOffset(10, 100)
powerLabel.Size = UDim2.new(1, -20, 0, 14)
powerLabel.Font = Enum.Font.GothamBold
powerLabel.TextSize = 11
powerLabel.TextXAlignment = Enum.TextXAlignment.Left
powerLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
powerLabel.Text = "power"
powerLabel.Parent = setInner

local powerBox = Instance.new("TextBox")
powerBox.Size = UDim2.new(1, -16, 0, 30)
powerBox.Position = UDim2.fromOffset(8, 118)
powerBox.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
powerBox.BorderSizePixel = 0
powerBox.Text = "12k"
powerBox.PlaceholderText = "power"
powerBox.Font = Enum.Font.GothamBlack
powerBox.TextSize = 14
powerBox.TextColor3 = Color3.fromRGB(120, 200, 255)
powerBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
powerBox.ClearTextOnFocus = false
powerBox.Parent = setInner
Instance.new("UICorner", powerBox).CornerRadius = UDim.new(0, 8)

-- ============================================================
-- STATE + HANDLERS
-- ============================================================
local keybindKb = Enum.KeyCode.F
local keybindGp = Enum.KeyCode.ButtonR2
local listening = false

local function paintMode()
	if mode == "normal" then
		normalBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
		normalBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		cframeBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
		cframeBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
	else
		cframeBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
		cframeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		normalBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
		normalBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
	end
end

local function setOpen(v)
	open = v == true
	local goal = open and SET_H or 0
	TS:Create(settings, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.fromOffset(MAIN_W, goal),
	}):Play()
	setBtn.Text = open and "−" or "+"
end

local function setRunning(on)
	if on then
		startBtn.Text = "stop"
		startBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 55)
		startLag()
		if mode == "cframe" then startCFrame() end
	else
		startBtn.Text = "start"
		startBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 80)
		stopLag()
		stopCFrame()
	end
end

local function parsePowerText(t)
	t = tostring(t or ""):lower():gsub("%s", "")
	if t:sub(-1) == "k" then
		local n = tonumber(t:sub(1, -2))
		if n then return math.floor(n * 1000) end
	end
	return tonumber(t)
end

local function formatPower(n)
	if n >= 1000 then
		local k = n / 1000
		if k == math.floor(k) then
			return tostring(math.floor(k)) .. "k"
		end
		return string.format("%.1fk", k)
	end
	return tostring(n)
end

startBtn.MouseButton1Click:Connect(function()
	setRunning(not lagging)
end)

lockBtn.MouseButton1Click:Connect(function()
	locked = not locked
	lockBtn.Text = locked and "🔒" or "🔓"
end)

setBtn.MouseButton1Click:Connect(function()
	setOpen(not open)
end)

normalBtn.MouseButton1Click:Connect(function()
	mode = "normal"
	paintMode()
	if lagging then
		stopCFrame()
	end
end)

cframeBtn.MouseButton1Click:Connect(function()
	mode = "cframe"
	paintMode()
	if lagging then
		startCFrame()
	end
end)

powerBox.FocusLost:Connect(function()
	local n = parsePowerText(powerBox.Text)
	if n then
		setPower(n)
		powerBox.Text = formatPower(powerVal)
		-- if running, restart with new power
		if lagging then
			stopLag()
			startLag()
		end
	else
		powerBox.Text = formatPower(powerVal)
	end
end)

kbBtn.MouseButton1Click:Connect(function()
	listening = true
	kbBtn.Text = "PRESS..."
end)

local function applyKey(input)
	if not input.KeyCode or input.KeyCode == Enum.KeyCode.Unknown then return end
	local name = input.KeyCode.Name
	if name:find("Button") == 1 or name:find("DPad") == 1 then
		keybindGp = input.KeyCode
		kbBtn.Text = "PAD · " .. name
	else
		keybindKb = input.KeyCode
		kbBtn.Text = "KEY · " .. name
	end
	listening = false
end

UIS.InputBegan:Connect(function(input, gpe)
	if listening then
		if input.UserInputType == Enum.UserInputType.Keyboard
			or input.UserInputType == Enum.UserInputType.Gamepad1
			or input.UserInputType == Enum.UserInputType.Gamepad2 then
			applyKey(input)
		end
		return
	end
	if UIS:GetFocusedTextBox() then return end
	local kc = input.KeyCode
	if not kc or kc == Enum.KeyCode.Unknown then return end
	if kc == keybindKb or kc == keybindGp then
		setRunning(not lagging)
	end
end)

-- drag
local dragging, dragStart, startPos = false, nil, nil
main.InputBegan:Connect(function(input)
	if locked then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = root.Position
	end
end)
UIS.InputChanged:Connect(function(input)
	if not dragging or locked then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
		local d = input.Position - dragStart
		root.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + d.X,
			startPos.Y.Scale, startPos.Y.Offset + d.Y
		)
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

paintMode()
setOpen(false)
print("[Vexa] Packet Lagger ready")