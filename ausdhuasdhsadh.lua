-- Haz Redeemer (Blue) · Potassium
-- UI + Traced logic ported

local cloneref = cloneref or function(x) return x end

local Players           = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local UserInputService  = cloneref(game:GetService("UserInputService"))
local TweenService      = cloneref(game:GetService("TweenService"))
local RunService        = cloneref(game:GetService("RunService"))

local localPlayer = Players.LocalPlayer
local PlayerGui   = localPlayer:WaitForChild("PlayerGui")
local Net         = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")

local getupvalues_    = debug and debug.getupvalues or getupvalues
local getconnections_ = getconnections or (debug and debug.getconnections)
local setupvalue_     = debug and debug.setupvalue or setupvalue
local writeClipboard  = setclipboard or toclipboard or (syn and syn.write_clipboard)

-- ====================== SETTINGS ======================
local autoRedeem   = true
local autoType     = true
local autoListen   = true
local autoSpam     = false
local wordsToCollect = 1
local isListening  = false
local isSpamming   = false
local spamThread   = nil
local spamCount    = 0
local listenedWords = {}
local lastAutoTyped = nil
local notifyRemote = nil
local remoteFallbackUsed = false
local listenKey = Enum.KeyCode.F

-- ====================== HELPERS ======================
local function stripTags(s)
	if type(s) ~= "string" then return tostring(s) end
	return (s:gsub("<[^>]->", ""))
end

local function trim(s)
	return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function extractWords(s)
	local out = {}
	for word in s:gmatch("[%w_]+") do out[#out + 1] = word end
	return out
end

local function pickCodeCandidate(s)
	local candidate
	for word in s:gmatch("[%w_]+") do
		if #word >= 4 and word:match("%a") and (word:match("%u") or word:match("%d")) then
			candidate = word
		end
	end
	if candidate then return candidate end
	for word in s:gmatch("[%w_]+") do
		if #word >= 4 then return word end
	end
end

-- ====================== CODE EXTRACTION ======================
local extractCodeAfterTrigger
do
	local patterns = {
		leads = {"use", "using", "redeem", "type", "enter", "claim", "with", "grab", "got", "here is", "heres", "here's", "there is", "theres", "there's"},
		articles = {"", "the%s+", "a%s+", "an%s+", "this%s+", "your%s+", "new%s+"},
		patterns = {
			"code%s+is", "codes?%s+are", "code%s+for", "code%s+to%s+use",
			"code%s*[:%-]", "new%s+code", "free%s+code", "secret%s+code", "working%s+code", "another%s+code",
		},
	}

	for _, lead in ipairs(patterns.leads) do
		local esc = lead:gsub("%s+", "%%s+")
		for _, article in ipairs(patterns.articles) do
			patterns.patterns[#patterns.patterns + 1] = esc .. "%s+" .. article .. "code"
		end
	end

	local function firstCodeWordTail(s)
		for pos, word in s:gmatch("()([%w_]+)") do
			if #word >= 4 and word:match("%a") and (word:match("%u") or word:match("%d")) then
				return s:sub(pos)
			end
		end
	end

	extractCodeAfterTrigger = function(raw)
		local lower = raw:lower()
		local bestEnd
		for _, pat in ipairs(patterns.patterns) do
			local i = 1
			while true do
				local s, e = string.find(lower, pat, i)
				if not s then break end
				if not bestEnd or e > bestEnd then bestEnd = e end
				i = e + 1
			end
		end
		if not bestEnd then return nil end
		local tail = raw:sub(bestEnd + 1)
		return firstCodeWordTail(tail) or ""
	end
end

-- ====================== FIND NOTIFY REMOTE ======================
local function findNotificationRemote()
	local ok, mod = pcall(function()
		return require(ReplicatedStorage.Controllers:FindFirstChild("NotificationController", true))
	end)
	if ok and type(mod) == "table" and type(mod.Start) == "function" and getupvalues_ then
		local ups = getupvalues_(mod.Start)
		if ups then
			for _, v in pairs(ups) do
				if typeof(v) == "Instance" and (v:IsA("RemoteEvent") or v:IsA("UnreliableRemoteEvent")) and v.Parent == Net then
					return v
				end
			end
		end
	end
end

-- ====================== SUBMIT CODE ======================
local setCodeBoxText, submitCode
do
	local function findCodeBox()
		local codes = PlayerGui:FindFirstChild("Codes")
		if not codes then return nil end
		local main = (codes:FindFirstChild("Codes") or codes):FindFirstChild("Main")
		local box = main and main:FindFirstChild("TextBox")
		if box and box:IsA("TextBox") then return box end
		for _, d in ipairs(codes:GetDescendants()) do
			if d:IsA("TextBox") then return d end
		end
	end

	local function findConfirmButton()
		local codes = PlayerGui:FindFirstChild("Codes")
		if not codes then return nil end
		local codes2 = codes:FindFirstChild("Codes") or codes
		local confirm = (codes2:FindFirstChild("Main") or codes2):FindFirstChild("Confirm")
		if confirm and (confirm:IsA("ImageButton") or confirm:IsA("TextButton")) then return confirm end
		for _, d in ipairs(codes:GetDescendants()) do
			if d:IsA("ImageButton") or d:IsA("TextButton") then
				local n = d.Name:lower()
				if n:find("confirm") or n:find("submit") or n:find("redeem") or n:find("enter") then
					return d
				end
			end
		end
	end

	local function fireConnections(signal, ...)
		if not getconnections_ then return false end
		local ok, conns = pcall(getconnections_, signal)
		if not ok or type(conns) ~= "table" then return false end
		local args = table.pack(...)
		local any = false
		for _, c in ipairs(conns) do
			if c.Enabled ~= false then
				local cb
				pcall(function() cb = c.Function end)
				if cb then
					any = pcall(task.spawn, cb, table.unpack(args, 1, args.n)) or any
				else
					any = pcall(function() c:Fire(table.unpack(args, 1, args.n)) end) or any
				end
			end
		end
		return any
	end

	setCodeBoxText = function(text)
		if type(text) ~= "string" or text == "" then return end
		local box = findCodeBox()
		if box then pcall(function() box.Text = text end) end
	end

	submitCode = function(text)
		local box = findCodeBox()
		if not box then return false, "no code box" end
		pcall(function()
			box.Text = text
			box.Active = true
		end)

		local confirm = findConfirmButton()
		if confirm then
			local a = fireConnections(confirm.MouseButton1Click)
			local b = fireConnections(confirm.Activated)
			if a or b then return true, "submitted" end
		end

		-- fallback focus
		pcall(function()
			box:CaptureFocus()
			task.wait(0.08)
			box:ReleaseFocus(true)
		end)
		return true, "focus submit"
	end
end

-- ====================== UI ======================
local gui = Instance.new("ScreenGui")
gui.Name = "HazRedeemer"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(340, 620)
main.Position = UDim2.new(0.5, -170, 0.5, -310)
main.BackgroundColor3 = Color3.fromRGB(12, 20, 38)
main.BorderSizePixel = 0
main.Parent = gui

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(28, 55, 95)
stroke.Thickness = 1
stroke.Parent = main

-- header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 52)
header.BackgroundColor3 = Color3.fromRGB(10, 17, 32)
header.BorderSizePixel = 0
header.Parent = main

local pfp = Instance.new("ImageLabel")
pfp.Size = UDim2.fromOffset(28, 28)
pfp.Position = UDim2.new(0, 12, 0.5, -14)
pfp.BackgroundColor3 = Color3.fromRGB(30, 64, 175)
pfp.BorderSizePixel = 0
pfp.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. localPlayer.UserId .. "&width=150&height=150&format=png"
pfp.Parent = header

local pfpStroke = Instance.new("UIStroke")
pfpStroke.Color = Color3.fromRGB(59, 130, 246)
pfpStroke.Thickness = 1.5
pfpStroke.Parent = pfp

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 0, 18)
title.Position = UDim2.new(0, 48, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Haz Redeemer"
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = Color3.fromRGB(240, 245, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(0, 200, 0, 14)
sub.Position = UDim2.new(0, 48, 0, 28)
sub.BackgroundTransparency = 1
sub.Text = "Potassium  ·  .gg/hazhub"
sub.Font = Enum.Font.Gotham
sub.TextSize = 11
sub.TextColor3 = Color3.fromRGB(100, 140, 210)
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.Parent = header

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30, 30)
close.Position = UDim2.new(1, -38, 0.5, -15)
close.BackgroundTransparency = 1
close.Text = "×"
close.TextSize = 22
close.TextColor3 = Color3.fromRGB(80, 110, 160)
close.Font = Enum.Font.Gotham
close.Parent = header
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -24, 0, 22)
statusLabel.Position = UDim2.new(0, 14, 0, 56)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "●  Haz ready  ·  Potassium"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextColor3 = Color3.fromRGB(110, 200, 255)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = main

local function setStatus(txt, kind)
	statusLabel.Text = "●  " .. txt
	if kind == "ok" then
		statusLabel.TextColor3 = Color3.fromRGB(80, 220, 120)
	elseif kind == "err" then
		statusLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
	elseif kind == "busy" then
		statusLabel.TextColor3 = Color3.fromRGB(255, 180, 60)
	else
		statusLabel.TextColor3 = Color3.fromRGB(110, 200, 255)
	end
end

-- code box
local codeBox = Instance.new("TextBox")
codeBox.Size = UDim2.new(1, -28, 0, 46)
codeBox.Position = UDim2.new(0, 14, 0, 82)
codeBox.BackgroundColor3 = Color3.fromRGB(7, 13, 26)
codeBox.BorderSizePixel = 0
codeBox.Text = ""
codeBox.PlaceholderText = "code appears here..."
codeBox.PlaceholderColor3 = Color3.fromRGB(55, 85, 140)
codeBox.Font = Enum.Font.GothamBold
codeBox.TextSize = 14
codeBox.TextColor3 = Color3.fromRGB(200, 220, 255)
codeBox.ClearTextOnFocus = false
codeBox.TextXAlignment = Enum.TextXAlignment.Center
codeBox.Parent = main

local cbStroke = Instance.new("UIStroke")
cbStroke.Color = Color3.fromRGB(25, 45, 80)
cbStroke.Thickness = 1
cbStroke.Parent = codeBox

-- buttons
local function makeBtn(text, x, bg, tc)
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromOffset(100, 32)
	b.Position = UDim2.new(0, x, 0, 138)
	b.BackgroundColor3 = bg
	b.BorderSizePixel = 0
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 12
	b.TextColor3 = tc
	b.Parent = main
	return b
end

local redeemBtn = makeBtn("REDEEM", 14, Color3.fromRGB(37, 99, 235), Color3.fromRGB(255,255,255))
local clearBtn  = makeBtn("CLEAR", 122, Color3.fromRGB(18, 32, 58), Color3.fromRGB(140, 185, 255))
local listenBtn = makeBtn("LISTEN", 230, Color3.fromRGB(29, 60, 160), Color3.fromRGB(210, 230, 255))

-- words
local wordsTitle = Instance.new("TextLabel")
wordsTitle.Size = UDim2.new(1, -28, 0, 14)
wordsTitle.Position = UDim2.new(0, 14, 0, 182)
wordsTitle.BackgroundTransparency = 1
wordsTitle.Text = "WORDS TILL SUBMIT"
wordsTitle.Font = Enum.Font.GothamBold
wordsTitle.TextSize = 10
wordsTitle.TextColor3 = Color3.fromRGB(85, 115, 175)
wordsTitle.TextXAlignment = Enum.TextXAlignment.Left
wordsTitle.Parent = main

local wordBtns = {}
for i = 1, 5 do
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromOffset(36, 28)
	b.Position = UDim2.new(0, 14 + (i-1)*42, 0, 200)
	b.BackgroundColor3 = i == 1 and Color3.fromRGB(29, 78, 216) or Color3.fromRGB(14, 25, 48)
	b.BorderSizePixel = 0
	b.Text = tostring(i)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 12
	b.TextColor3 = i == 1 and Color3.fromRGB(255,255,255) or Color3.fromRGB(140, 185, 255)
	b.Parent = main

	local s = Instance.new("UIStroke")
	s.Color = i == 1 and Color3.fromRGB(59, 130, 246) or Color3.fromRGB(28, 55, 95)
	s.Thickness = 1
	s.Parent = b
	wordBtns[i] = b

	b.MouseButton1Click:Connect(function()
		wordsToCollect = i
		listenedWords = {}
		for j, btn in ipairs(wordBtns) do
			if j == i then
				btn.BackgroundColor3 = Color3.fromRGB(29, 78, 216)
				btn.TextColor3 = Color3.fromRGB(255,255,255)
				btn.UIStroke.Color = Color3.fromRGB(59, 130, 246)
			else
				btn.BackgroundColor3 = Color3.fromRGB(14, 25, 48)
				btn.TextColor3 = Color3.fromRGB(140, 185, 255)
				btn.UIStroke.Color = Color3.fromRGB(28, 55, 95)
			end
		end
		if isListening then
			setStatus(("listening... 0/%d"):format(wordsToCollect), "wait")
		end
	end)
end

-- toggles
local toggleData = {
	{"Auto Redeem", true, function(v) autoRedeem = v end},
	{"Auto Type", true, function(v) autoType = v end},
	{"Auto Listen", true, function(v) autoListen = v end},
	{"Auto Spam", false, function(v) autoSpam = v end},
}

for i, data in ipairs(toggleData) do
	local y = 242 + (i-1)*30
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 180, 0, 22)
	label.Position = UDim2.new(0, 14, 0, y)
	label.BackgroundTransparency = 1
	label.Text = data[1]
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextColor3 = Color3.fromRGB(190, 210, 245)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = main

	local track = Instance.new("Frame")
	track.Size = UDim2.fromOffset(38, 20)
	track.Position = UDim2.new(1, -52, 0, y + 1)
	track.BackgroundColor3 = data[2] and Color3.fromRGB(37, 99, 235) or Color3.fromRGB(28, 55, 95)
	track.BorderSizePixel = 0
	track.Parent = main

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(16, 16)
	knob.Position = data[2] and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.Parent = track

	local hit = Instance.new("TextButton")
	hit.Size = UDim2.new(1, 0, 1, 0)
	hit.BackgroundTransparency = 1
	hit.Text = ""
	hit.Parent = track

	local on = data[2]
	hit.MouseButton1Click:Connect(function()
		on = not on
		data[3](on)
		local goal = on and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2)
		local col = on and Color3.fromRGB(37, 99, 235) or Color3.fromRGB(28, 55, 95)
		TweenService:Create(knob, TweenInfo.new(0.14), {Position = goal}):Play()
		TweenService:Create(track, TweenInfo.new(0.14), {BackgroundColor3 = col}):Play()
	end)
end

-- test code
local testTitle = Instance.new("TextLabel")
testTitle.Size = UDim2.new(1, -28, 0, 14)
testTitle.Position = UDim2.new(0, 14, 0, 370)
testTitle.BackgroundTransparency = 1
testTitle.Text = "TEST CODE"
testTitle.Font = Enum.Font.GothamBold
testTitle.TextSize = 10
testTitle.TextColor3 = Color3.fromRGB(85, 115, 175)
testTitle.TextXAlignment = Enum.TextXAlignment.Left
testTitle.Parent = main

local testBox = Instance.new("TextBox")
testBox.Size = UDim2.new(1, -100, 0, 32)
testBox.Position = UDim2.new(0, 14, 0, 388)
testBox.BackgroundColor3 = Color3.fromRGB(7, 13, 26)
testBox.BorderSizePixel = 0
testBox.Text = ""
testBox.PlaceholderText = "fake word / code..."
testBox.PlaceholderColor3 = Color3.fromRGB(90, 110, 150)
testBox.Font = Enum.Font.Gotham
testBox.TextSize = 12
testBox.TextColor3 = Color3.fromRGB(200, 220, 255)
testBox.ClearTextOnFocus = false
testBox.Parent = main

local tbStroke = Instance.new("UIStroke")
tbStroke.Color = Color3.fromRGB(25, 45, 80)
tbStroke.Thickness = 1
tbStroke.Parent = testBox

local testBtn = Instance.new("TextButton")
testBtn.Size = UDim2.fromOffset(70, 32)
testBtn.Position = UDim2.new(1, -84, 0, 388)
testBtn.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
testBtn.BorderSizePixel = 0
testBtn.Text = "TEST"
testBtn.Font = Enum.Font.GothamBold
testBtn.TextSize = 12
testBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
testBtn.Parent = main

-- logs
local logsFrame = Instance.new("Frame")
logsFrame.Size = UDim2.new(1, -28, 0, 160)
logsFrame.Position = UDim2.new(0, 14, 0, 430)
logsFrame.BackgroundColor3 = Color3.fromRGB(7, 13, 26)
logsFrame.BorderSizePixel = 0
logsFrame.Parent = main

local lfStroke = Instance.new("UIStroke")
lfStroke.Color = Color3.fromRGB(25, 45, 80)
lfStroke.Thickness = 1
lfStroke.Parent = logsFrame

local logsHeader = Instance.new("TextLabel")
logsHeader.Size = UDim2.new(0, 80, 0, 16)
logsHeader.Position = UDim2.new(0, 10, 0, 6)
logsHeader.BackgroundTransparency = 1
logsHeader.Text = "LOGS"
logsHeader.Font = Enum.Font.GothamBold
logsHeader.TextSize = 10
logsHeader.TextColor3 = Color3.fromRGB(85, 115, 175)
logsHeader.TextXAlignment = Enum.TextXAlignment.Left
logsHeader.Parent = logsFrame

local clearLogsBtn = Instance.new("TextButton")
clearLogsBtn.Size = UDim2.fromOffset(40, 16)
clearLogsBtn.Position = UDim2.new(1, -50, 0, 6)
clearLogsBtn.BackgroundTransparency = 1
clearLogsBtn.Text = "Clear"
clearLogsBtn.Font = Enum.Font.Gotham
clearLogsBtn.TextSize = 11
clearLogsBtn.TextColor3 = Color3.fromRGB(85, 115, 175)
clearLogsBtn.Parent = logsFrame

local logs = Instance.new("ScrollingFrame")
logs.Size = UDim2.new(1, -12, 1, -28)
logs.Position = UDim2.new(0, 6, 0, 24)
logs.BackgroundTransparency = 1
logs.BorderSizePixel = 0
logs.ScrollBarThickness = 4
logs.ScrollBarImageColor3 = Color3.fromRGB(37, 99, 235)
logs.CanvasSize = UDim2.new(0, 0, 0, 0)
logs.AutomaticCanvasSize = Enum.AutomaticSize.Y
logs.Parent = logsFrame

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 2)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = logs

local function addLog(txt)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, -6, 0, 14)
	l.BackgroundTransparency = 1
	l.Text = txt
	l.Font = Enum.Font.Code
	l.TextSize = 11
	l.TextColor3 = Color3.fromRGB(120, 190, 255)
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.TextWrapped = true
	l.Parent = logs
end

clearLogsBtn.MouseButton1Click:Connect(function()
	for _, v in ipairs(logs:GetChildren()) do
		if v:IsA("TextLabel") then v:Destroy() end
	end
end)

-- footer
local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, 0, 0, 26)
footer.Position = UDim2.new(0, 0, 1, -26)
footer.BackgroundColor3 = Color3.fromRGB(10, 17, 32)
footer.BorderSizePixel = 0
footer.Parent = main

local fLeft = Instance.new("TextLabel")
fLeft.Size = UDim2.new(0.5, 0, 1, 0)
fLeft.Position = UDim2.new(0, 14, 0, 0)
fLeft.BackgroundTransparency = 1
fLeft.Text = "Haz  ·  .gg/hazhub"
fLeft.Font = Enum.Font.Gotham
fLeft.TextSize = 11
fLeft.TextColor3 = Color3.fromRGB(70, 100, 150)
fLeft.TextXAlignment = Enum.TextXAlignment.Left
fLeft.Parent = footer

local fRight = Instance.new("TextLabel")
fRight.Size = UDim2.new(0.5, -14, 1, 0)
fRight.Position = UDim2.new(0.5, 0, 0, 0)
fRight.BackgroundTransparency = 1
fRight.Text = "F = listen"
fRight.Font = Enum.Font.Gotham
fRight.TextSize = 11
fRight.TextColor3 = Color3.fromRGB(70, 100, 150)
fRight.TextXAlignment = Enum.TextXAlignment.Right
fRight.Parent = footer

-- drag
local dragging, startPos, dragStart
main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
	end
end)
main.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- ====================== CORE LOGIC ======================
local function doRedeem(code, prefix)
	local clean = trim(code)
	if clean == "" then
		setStatus("nothing to redeem", "err")
		addLog("[err] empty code")
		return false
	end
	prefix = prefix and (prefix .. " ") or ""
	setStatus(prefix .. "redeeming: " .. clean, "busy")
	addLog("[" .. os.date("%H:%M:%S") .. "] redeeming " .. clean)

	local ok = submitCode(clean)
	if ok then
		setStatus(prefix .. "sent: " .. clean, "ok")
		addLog("[" .. os.date("%H:%M:%S") .. "] sent " .. clean)
	else
		setStatus(prefix .. "failed: " .. clean, "err")
		addLog("[" .. os.date("%H:%M:%S") .. "] failed " .. clean)
	end
	return ok
end

local function setListening(on)
	isListening = on
	if on then
		listenedWords = {}
		listenBtn.Text = "STOP"
		listenBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
		setStatus(("listening... 0/%d"):format(wordsToCollect), "wait")
		addLog("[" .. os.date("%H:%M:%S") .. "] listen started")
		if autoSpam and not isSpamming then
			isSpamming = true
			addLog("[" .. os.date("%H:%M:%S") .. "] auto spam on")
		end
	else
		listenBtn.Text = "LISTEN"
		listenBtn.BackgroundColor3 = Color3.fromRGB(29, 60, 160)
		setStatus("Haz ready · Potassium", "idle")
		addLog("[" .. os.date("%H:%M:%S") .. "] listen stopped")
		isSpamming = false
	end
end

local function handleCaptured(code)
	if autoType then
		codeBox.Text = code
		lastAutoTyped = code
	end
	if autoRedeem then
		doRedeem(code, "[AUTO]")
	else
		setStatus("captured: " .. code, "ok")
		addLog("[" .. os.date("%H:%M:%S") .. "] captured " .. code)
	end
end

local function onAnnouncement(...)
	local args = table.pack(...)
	local text = stripTags(tostring(args[1] or ""))
	if text == "" then return end

	addLog("[" .. os.date("%H:%M:%S") .. "] " .. text:sub(1, 60))

	local code
	if autoListen and not isListening then
		code = extractCodeAfterTrigger(text)
		if code then
			setListening(true)
			if code == "" then
				setStatus("trigger heard - waiting...", "busy")
				return
			end
		else
			code = text
		end
	else
		code = text
	end

	if isListening then
		for _, word in ipairs(extractWords(code)) do
			listenedWords[#listenedWords + 1] = word
		end

		local take = {}
		for i = 1, math.min(#listenedWords, wordsToCollect) do
			take[i] = listenedWords[i]
		end
		local joined = table.concat(take)

		if autoType then
			codeBox.Text = joined
			setCodeBoxText(joined)
		end

		if wordsToCollect <= #listenedWords then
			listenedWords = {}
			setListening(false)
			handleCaptured(joined)
		else
			setStatus(("listening... %d/%d"):format(#listenedWords, wordsToCollect), "wait")
		end
	end
end

-- wire buttons
redeemBtn.MouseButton1Click:Connect(function()
	doRedeem(codeBox.Text)
end)

clearBtn.MouseButton1Click:Connect(function()
	codeBox.Text = ""
	lastAutoTyped = nil
	listenedWords = {}
	setStatus(isListening and "listening... (cleared)" or "cleared", "idle")
	addLog("[" .. os.date("%H:%M:%S") .. "] cleared")
end)

listenBtn.MouseButton1Click:Connect(function()
	setListening(not isListening)
end)

testBtn.MouseButton1Click:Connect(function()
	local t = trim(testBox.Text)
	if t == "" then return end
	codeBox.Text = t
	doRedeem(t, "[TEST]")
end)

codeBox.FocusLost:Connect(function(enter)
	if enter then doRedeem(codeBox.Text) end
end)

-- keybind
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == listenKey then
		setListening(not isListening)
	end
end)

-- connect remotes
notifyRemote = findNotificationRemote()
if notifyRemote then
	notifyRemote.OnClientEvent:Connect(onAnnouncement)
	addLog("[" .. os.date("%H:%M:%S") .. "] notify mapped · ready")
	addLog("remote: " .. notifyRemote:GetFullName())
	setStatus("Haz ready · Potassium", "ok")
else
	local count = 0
	for _, child in ipairs(Net:GetChildren()) do
		if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
			count += 1
			child.OnClientEvent:Connect(onAnnouncement)
			if count >= 300 then break end
		end
	end
	remoteFallbackUsed = count > 0
	addLog("[" .. os.date("%H:%M:%S") .. "] fallback remotes: " .. count)
	setStatus(count > 0 and "Haz ready (fallback)" or "no notify remote", count > 0 and "ok" or "err")
end

addLog("[" .. os.date("%H:%M:%S") .. "] Haz Redeemer loaded")
addLog("[" .. os.date("%H:%M:%S") .. "] executor: Potassium")