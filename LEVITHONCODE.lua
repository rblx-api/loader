local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local Theme = {
	bg = Color3.fromRGB(10, 10, 10),
	bgDark = Color3.fromRGB(5, 5, 5),
	bgCard = Color3.fromRGB(18, 18, 18),
	stroke = Color3.fromRGB(40, 40, 40),
	accent = Color3.fromRGB(255, 255, 255),
	accentHover = Color3.fromRGB(220, 220, 220),
	accentDim = Color3.fromRGB(60, 60, 60),
	text = Color3.fromRGB(245, 245, 245),
	textMuted = Color3.fromRGB(140, 140, 140),
	white = Color3.fromRGB(255, 255, 255),
	toggleOff = Color3.fromRGB(35, 35, 35),
	toggleOn = Color3.fromRGB(255, 255, 255),
}

local COL_WHITE = Color3.fromRGB(245, 245, 245)
local COL_ON = Color3.fromRGB(120, 255, 160)

local TweenFast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TweenMed = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local state = {
	guiSize = 100,
	minimized = false,
	currentTab = "Main",
	antiDieToggled = false,
	antiLagToggled = false,
	antiCheatBypassToggled = false,
	antiRagdollToggled = false,
	codeSniperToggled = false,
	riddleSolverToggled = false,
	autoSubmitToggled = false,
	retypeInvalidToggled = false,
	locked = false,
	autoBuyToggled = false,
	imageIdEnabled = true,
}

local savedConfig = {
	codeSniper = true,
	autoSubmit = true,
	submitAfter = 3,
	retypeInvalid = false,
	riddleSolver = false,
	antiRagdoll = false,
	imageIdEnabled = true,
}

local _autoAccept = savedConfig.autoSubmit
local _submitAfter = savedConfig.submitAfter
local _capturedParts = {}
local _lastWatchedBox = nil
local _lastBox = nil

local _retypeInvalid        = savedConfig.retypeInvalid
local _lastNonBlankBoxText  = ""
local _pendingRejectedText  = nil
local _pendingRejectedBox   = nil
local _pendingRejectedUntil = 0
local _pendingRejectedToken = 0
local _focused              = nil
local _enabled              = true
local _boxTextConn          = nil
local _boxAncestryConn      = nil

local function corner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 10)
	c.Parent = parent
	return c
end

local function stroke(parent, color, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color or Theme.stroke
	s.Thickness = thickness or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = parent
	return s
end

local function padding(parent, l, r, t, b)
	local p = Instance.new("UIPadding")
	p.PaddingLeft = UDim.new(0, l or 0)
	p.PaddingRight = UDim.new(0, r or 0)
	p.PaddingTop = UDim.new(0, t or 0)
	p.PaddingBottom = UDim.new(0, b or 0)
	p.Parent = parent
	return p
end

local function hover(btn, normal, hoverCol)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenFast, { BackgroundColor3 = hoverCol }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenFast, { BackgroundColor3 = normal }):Play()
	end)
end

for _, g in ipairs(PlayerGui:GetChildren()) do
	if g.Name == "LevithonHubLaggerGui" then
		g:Destroy()
	end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LevithonHubLaggerGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = PlayerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Size = UDim2.new(0, 320, 0, 380)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.BackgroundColor3 = Theme.bg
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Parent = screenGui
corner(main, 14)
stroke(main, Theme.stroke, 1.5)

local ORIGINAL_BG_IMAGE = "rbxassetid://87364879162642"
local ORIGINAL_LOGO_IMAGE = "rbxassetid://87364879162642"
local ORIGINAL_BG_TRANSPARENCY = 0.5

local bgImage = Instance.new("ImageLabel")
bgImage.Name = "BackgroundImage"
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = savedConfig.imageIdEnabled and ORIGINAL_BG_IMAGE or ""
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ImageTransparency = savedConfig.imageIdEnabled and ORIGINAL_BG_TRANSPARENCY or 1
bgImage.ZIndex = 0
bgImage.Parent = main
corner(bgImage, 14)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Theme.bgDark
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 2
titleBar.Parent = main
corner(titleBar, 14)

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 14)
titleFix.Position = UDim2.new(0, 0, 1, -14)
titleFix.BackgroundColor3 = Theme.bgDark
titleFix.BackgroundTransparency = 0.3
titleFix.BorderSizePixel = 0
titleFix.ZIndex = 2
titleFix.Parent = titleBar

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 24, 0, 24)
logo.Position = UDim2.new(0, 12, 0.5, -12)
logo.BackgroundTransparency = 1
logo.Image = savedConfig.imageIdEnabled and ORIGINAL_LOGO_IMAGE or ""
logo.ScaleType = Enum.ScaleType.Fit
logo.ZIndex = 3
logo.Parent = titleBar
corner(logo, 6)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 160, 0, 20)
titleLabel.Position = UDim2.new(0, 42, 0.5, -10)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextColor3 = Theme.text
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Text = "LEVITHONHUB"
titleLabel.ZIndex = 3
titleLabel.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -84, 0.5, -12)
minBtn.BackgroundColor3 = Theme.bgCard
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.TextColor3 = Theme.text
minBtn.Text = "–"
minBtn.AutoButtonColor = false
minBtn.ZIndex = 3
minBtn.Parent = titleBar
corner(minBtn, 6)
hover(minBtn, Theme.bgCard, Theme.accentDim)

local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.new(0, 24, 0, 24)
lockBtn.Position = UDim2.new(1, -56, 0.5, -12)
lockBtn.BackgroundColor3 = Theme.bgCard
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextSize = 12
lockBtn.TextColor3 = Theme.text
lockBtn.Text = "🔓"
lockBtn.AutoButtonColor = false
lockBtn.ZIndex = 3
lockBtn.Parent = titleBar
corner(lockBtn, 6)
hover(lockBtn, Theme.bgCard, Theme.accentDim)

lockBtn.MouseButton1Click:Connect(function()
	state.locked = not state.locked
	if state.locked then
		lockBtn.Text = "🔒"
		lockBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
		lockBtn.TextColor3 = Theme.bg
	else
		lockBtn.Text = "🔓"
		lockBtn.BackgroundColor3 = Theme.bgCard
		lockBtn.TextColor3 = Theme.text
	end
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0.5, -12)
closeBtn.BackgroundColor3 = Theme.bgCard
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.TextColor3 = Theme.text
closeBtn.Text = "✕"
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 3
closeBtn.Parent = titleBar
corner(closeBtn, 6)
hover(closeBtn, Theme.bgCard, Color3.fromRGB(180, 50, 70))

closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -24, 0, 32)
tabBar.Position = UDim2.new(0, 12, 0, 50)
tabBar.BackgroundColor3 = Theme.bgDark
tabBar.BackgroundTransparency = 0.2
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 2
tabBar.Parent = main
corner(tabBar, 8)

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.Padding = UDim.new(0, 4)
tabLayout.Parent = tabBar
padding(tabBar, 4, 4, 4, 4)

local tabs = {}
local pages = {}

local function makeTab(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.33, -4, 1, 0)
	btn.BackgroundColor3 = Theme.bgDark
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	btn.TextColor3 = Theme.textMuted
	btn.Text = name
	btn.AutoButtonColor = false
	btn.ZIndex = 3
	btn.Parent = tabBar
	corner(btn, 6)
	tabs[name] = btn
	return btn
end

local tabMain = makeTab("Main")
local tabUtilis = makeTab("Utilis")
local tabSettings = makeTab("Settings")

local function setTab(name)
	state.currentTab = name
	for n, btn in pairs(tabs) do
		if n == name then
			TweenService:Create(btn, TweenFast, { BackgroundColor3 = Theme.accent, TextColor3 = Theme.bg }):Play()
		else
			TweenService:Create(btn, TweenFast, { BackgroundColor3 = Theme.bgDark, TextColor3 = Theme.textMuted }):Play()
		end
	end
	for n, page in pairs(pages) do
		page.Visible = (n == name)
	end
end

tabMain.MouseButton1Click:Connect(function() setTab("Main") end)
tabUtilis.MouseButton1Click:Connect(function() setTab("Utilis") end)
tabSettings.MouseButton1Click:Connect(function() setTab("Settings") end)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -24, 1, -140)
content.Position = UDim2.new(0, 12, 0, 90)
content.BackgroundTransparency = 1
content.ZIndex = 2
content.Parent = main

-- ======================== MAIN PAGE ========================
local pageMain = Instance.new("ScrollingFrame")
pageMain.Size = UDim2.new(1, 0, 1, 0)
pageMain.BackgroundTransparency = 1
pageMain.BorderSizePixel = 0
pageMain.ScrollBarThickness = 4
pageMain.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
pageMain.ScrollBarImageTransparency = 0.3
pageMain.CanvasSize = UDim2.new(0, 0, 0, 0)
pageMain.AutomaticCanvasSize = Enum.AutomaticSize.Y
pageMain.ScrollingDirection = Enum.ScrollingDirection.Y
pageMain.ZIndex = 2
pageMain.Parent = content
pages["Main"] = pageMain

local mainLayout = Instance.new("UIListLayout")
mainLayout.Padding = UDim.new(0, 10)
mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainLayout.Parent = pageMain

local mainPad = Instance.new("UIPadding")
mainPad.PaddingBottom = UDim.new(0, 12)
mainPad.PaddingRight = UDim.new(0, 4)
mainPad.Parent = pageMain

local function makeMainRow(order)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -4, 0, 40)
	row.BackgroundColor3 = Theme.bgCard
	row.BackgroundTransparency = 0.15
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.ZIndex = 3
	row.Parent = pageMain
	corner(row, 10)
	stroke(row, Theme.stroke, 1)
	return row
end

-- ======================== LOG SYSTEM ========================
local logLines = {}
local MAX_LOG_LINES = 6
local LogLabel

local function pushLog(text, color)
	if not LogLabel then return end
	table.insert(logLines, { text = text, color = color or Color3.fromRGB(140, 140, 150) })
	while #logLines > MAX_LOG_LINES do
		table.remove(logLines, 1)
	end
	local out = {}
	for _, entry in ipairs(logLines) do
		table.insert(out, entry.text)
	end
	LogLabel.Text = table.concat(out, "\n")
end

-- ======================== CODE SNIPER LOGIC ========================
local function isOurGui(instance)
	local p = instance
	for _ = 1, 10 do
		if not p then break end
		if p.Name == "CardACECodeSniper" or p.Name == "ACECodeSniperUI" or p.Name == "SourcesHubRedeemerGui" or p.Name == "LevithonHubLaggerGui" then return true end
		p = p.Parent
	end
	return false
end

local function isVisibleChain(inst)
	local current = inst
	while current do
		if current:IsA("GuiObject") and not current.Visible then return false end
		if current:IsA("ScreenGui") then return current.Enabled end
		current = current.Parent
	end
	return true
end

local function findAllTextBoxes(pg)
	local boxes = {}
	for _, gui in ipairs(pg:GetChildren()) do
		if gui:IsA("ScreenGui") and gui.Enabled and not isOurGui(gui) then
			for _, d in ipairs(gui:GetDescendants()) do
				if d:IsA("TextBox") and not isOurGui(d) then
					boxes[#boxes+1] = d
				end
			end
		end
	end
	return boxes
end

local function findCodeButtons(pg)
	local btns = {}
	for _, gui in ipairs(pg:GetChildren()) do
		if gui:IsA("ScreenGui") and gui.Enabled and not isOurGui(gui) then
			for _, d in ipairs(gui:GetDescendants()) do
				if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
					local n  = d.Name:lower()
					local pn = (d.Parent and d.Parent.Name or ""):lower()
					if (n:find("code") or n:find("redeem") or pn:find("code") or pn:find("redeem"))
						and isVisibleChain(d) then
						btns[#btns+1] = d
					end
				end
			end
		end
	end
	return btns
end

local function clickButton(btn)
	if not btn then return false end
	local methods = {}

	methods[#methods+1] = function() btn.MouseButton1Click:Fire() end
	methods[#methods+1] = function() btn.Activated:Fire() end

	if typeof(firesignal) == "function" then
		methods[#methods+1] = function() firesignal(btn.MouseButton1Click) end
		methods[#methods+1] = function() firesignal(btn.Activated) end
	end

	if typeof(getconns) == "function" then
		methods[#methods+1] = function()
			local ok, cs = pcall(getconns, btn.MouseButton1Click)
			if ok and type(cs) == "table" then
				for _, c in ipairs(cs) do pcall(function() c:Fire() end) end
			end
			local ok2, cs2 = pcall(getconns, btn.Activated)
			if ok2 and type(cs2) == "table" then
				for _, c in ipairs(cs2) do pcall(function() c:Fire() end) end
			end
		end
	end

	if typeof(fireclick) == "function" then
		methods[#methods+1] = function() fireclick(btn) end
	end

	local anyOk = false
	for _, fn in ipairs(methods) do
		local ok = pcall(fn)
		anyOk = anyOk or ok
	end
	return anyOk
end

local function fireBoxFocusLost(box)
	if not box then return false end
	local anyFired = false

	if typeof(firesignal) == "function" then
		local ok = pcall(firesignal, box.FocusLost, true)
		anyFired = anyFired or ok
	end

	if typeof(getconns) == "function" then
		local ok, cs = pcall(getconns, box.FocusLost)
		if ok and type(cs) == "table" then
			for _, c in ipairs(cs) do
				local fn
				pcall(function() fn = c.Function end)
				if fn and typeof(getupvalues) == "function" and typeof(setupv) == "function" then
					local uOk, ups = pcall(getupvalues, fn)
					if uOk and type(ups) == "table" then
						for i, v in pairs(ups) do
							if type(v) == "boolean" and v == true then
								pcall(setupv, fn, i, false)
							end
						end
					end
				end
				local fOk = pcall(function()
					if c.Enabled ~= false then c:Fire(true) end
				end)
				anyFired = anyFired or fOk
			end
		end
	end

	return anyFired
end

local function typeAndSubmitCode(code)
	local pg = PlayerGui
	if not pg then return false, "no PlayerGui" end

	local codesGui = pg:FindFirstChild("Codes")
	if codesGui then
		if codesGui:IsA("ScreenGui") then codesGui.Enabled = true end
		local codesFrame = codesGui:FindFirstChild("Codes") or codesGui
		if codesFrame then
			if codesFrame:IsA("GuiObject") then codesFrame.Visible = true end
			local cur = codesFrame
			while cur and cur ~= codesGui do
				if cur:IsA("GuiObject") then cur.Visible = true end
				cur = cur.Parent
			end

			local box = nil
			for _, d in ipairs(codesFrame:GetDescendants()) do
				if d:IsA("TextBox") and not isOurGui(d) then
					box = d
					break
				end
			end

			local submitBtn = nil
			for _, d in ipairs(codesFrame:GetDescendants()) do
				if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
					local n = d.Name:lower()
					local txt = ""
					pcall(function() txt = d.Text:lower() end)
					if n:find("submit") or txt:find("submit") or n:find("redeem") or txt:find("redeem") or n:find("claim") or txt:find("confirm") or n:find("enter") then
						submitBtn = d
						break
					end
				end
			end
			if not submitBtn then
				for _, d in ipairs(codesFrame:GetDescendants()) do
					if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
						local n = d.Name:lower()
						if not n:find("close") and not n:find("x") and not n:find("toggle") then
							submitBtn = d
							break
						end
					end
				end
			end

			if box then
				pcall(function() box.Text = code end)
				task.wait(0.05)
				if submitBtn then clickButton(submitBtn) end
				fireBoxFocusLost(box)
				return true, "submitted via PlayerGui.Codes"
			end
		end
	end

	local btns = findCodeButtons(pg)
	for _, btn in ipairs(btns) do
		clickButton(btn)
		task.wait(0.05)
	end

	task.wait(0.2)

	local box = nil
	local deadline = tick() + 2
	while tick() < deadline do
		local allBoxes = findAllTextBoxes(pg)
		for _, d in ipairs(allBoxes) do
			if isVisibleChain(d) then
				local n  = d.Name:lower()
				local pn = (d.Parent and d.Parent.Name or ""):lower()
				if n:find("code") or pn:find("code") or n:find("redeem") or pn:find("redeem") or n:find("input") or pn:find("textbox") or n:find("enter") then
					box = d
					break
				end
			end
		end
		if not box then
			for _, d in ipairs(allBoxes) do
				if isVisibleChain(d) then box = d; break end
			end
		end
		if box then break end
		task.wait(0.1)
	end

	if not box then return false, "no codebox visible" end

	pcall(function() box.Text = code end)
	task.wait(0.05)

	local redeemBtn = nil
	local searchNames = {"submit","redeem","claim","confirm","enter","send","apply","ok","use","go","check"}
	local p = box.Parent
	for _ = 1, 8 do
		if not p then break end
		for _, d in ipairs(p:GetDescendants()) do
			if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) and d ~= box then
				local n = d.Name:lower()
				local txt = ""
				pcall(function() txt = d.Text:lower() end)
				for _, sn in ipairs(searchNames) do
					if n:find(sn) or txt:find(sn) then
						if isVisibleChain(d) then
							redeemBtn = d
							break
						end
					end
				end
				if redeemBtn then break end
			end
		end
		if redeemBtn then break end
		p = p.Parent
	end

	if redeemBtn then clickButton(redeemBtn) end
	fireBoxFocusLost(box)

	return true, "submitted via dynamic search"
end

local function aceCodeBox()
	local pg = PlayerGui
	local allBoxes = findAllTextBoxes(pg)
	for _, box in ipairs(allBoxes) do
		if isVisibleChain(box) then return box end
	end
	return nil
end

-- ======================== RETYPE INVALID HELPERS ========================
local function clearPendingSubmission()
	_pendingRejectedToken += 1
	_pendingRejectedText = nil
	_pendingRejectedBox = nil
	_pendingRejectedUntil = 0
end

local function rememberPendingSubmission(box, text, replaceExisting)
	if not _retypeInvalid or not text or text == "" then return end
	if not replaceExisting and _pendingRejectedText and os.clock() <= _pendingRejectedUntil then return end
	_pendingRejectedToken += 1
	local token = _pendingRejectedToken
	_pendingRejectedText = text
	_pendingRejectedBox = box
	_pendingRejectedUntil = os.clock() + 8
	task.delay(8, function()
		if token == _pendingRejectedToken then clearPendingSubmission() end
	end)
end

local function restoreRejectedText(box, previousText)
	if not _retypeInvalid or not previousText or previousText == "" then return false end
	RunService.Heartbeat:Wait()
	local repasteBox = aceCodeBox() or box
	if not repasteBox or not isVisibleChain(repasteBox) then return false end
	local restored = pcall(function() repasteBox.Text = previousText end)
	if restored then
		_lastBox = repasteBox
		watchBoxForBlankReset(repasteBox)
	end
	return restored
end

local function handleRedemptionFeedback(text, feedbackObject)
	if not _retypeInvalid or not _pendingRejectedText then return end
	if os.clock() > _pendingRejectedUntil then clearPendingSubmission(); return end
	if feedbackObject and feedbackObject:IsDescendantOf(screenGui) then return end
	local lower = tostring(text or ""):lower()
	local rejected = lower:find("invalid code", 1, true)
		or lower:find("code is invalid", 1, true)
		or lower:find("expired", 1, true)
		or lower:find("already redeemed", 1, true)
		or lower:find("already used", 1, true)
		or lower:find("doesn't exist", 1, true)
		or lower:find("does not exist", 1, true)
		or lower:find("not found", 1, true)
		or lower:find("rejected", 1, true)
	if not rejected then return end
	local previousText = _pendingRejectedText
	local previousBox = _pendingRejectedBox
	local restored = restoreRejectedText(previousBox, previousText)
	clearPendingSubmission()
	if restored then
		pushLog("> retype: " .. previousText, Color3.fromRGB(200, 180, 100))
	end
end

-- ======================== AUTO SUBMIT HELPERS ========================
local function resetPasteCounter()
	_capturedParts = {}
end

local function clearBoxWatchers()
	_lastWatchedBox = nil
	if _boxTextConn then pcall(function() _boxTextConn:Disconnect() end); _boxTextConn = nil end
	if _boxAncestryConn then pcall(function() _boxAncestryConn:Disconnect() end); _boxAncestryConn = nil end
end

local function watchBoxForBlankReset(box)
	if not box or _lastWatchedBox == box then return end
	clearBoxWatchers()
	_lastWatchedBox = box
	if box.Text ~= "" then _lastNonBlankBoxText = box.Text end
	_boxTextConn = box:GetPropertyChangedSignal("Text"):Connect(function()
		if box.Text == "" then resetPasteCounter()
		else _lastNonBlankBoxText = box.Text end
	end)
	_boxAncestryConn = box.AncestryChanged:Connect(function(_, parent)
		if not parent then resetPasteCounter(); clearBoxWatchers() end
	end)
end

local function appendToBox(text)
	if not text or text == "" then return end
	if _lastWatchedBox and not isVisibleChain(_lastWatchedBox) then
		resetPasteCounter()
		clearBoxWatchers()
	end
	local box = aceCodeBox()
	_capturedParts[#_capturedParts + 1] = text
	local combinedCode = table.concat(_capturedParts)
	local capturedCount = #_capturedParts

	if box then
		_lastBox = box
		watchBoxForBlankReset(box)
		local boxWasFocused = UserInputService:GetFocusedTextBox() == box
		box.Text = combinedCode
		if boxWasFocused then
			pcall(function()
				local caretEnd = #combinedCode + 1
				box.CursorPosition = caretEnd
				box.SelectionStart = caretEnd
			end)
		end
	else
		pushLog("> auto: captured; searching UI...", Color3.fromRGB(200, 180, 100))
	end

	pushLog("> auto: " .. tostring(capturedCount) .. "/" .. tostring(_submitAfter), COL_ON)

	if capturedCount >= _submitAfter then
		_capturedParts = {}
		if _autoAccept then
			rememberPendingSubmission(box, combinedCode, true)

			local ok, statusMsg = typeAndSubmitCode(combinedCode)

			if ok then
				pushLog("> redeemed: " .. combinedCode, COL_ON)
			else
				local restored = restoreRejectedText(box, combinedCode)
				clearPendingSubmission()
				if restored then
					pushLog("> invalid - repasted: " .. combinedCode, Color3.fromRGB(200, 180, 100))
				else
					pushLog("> failed: " .. tostring(statusMsg), Color3.fromRGB(255, 90, 90))
				end
			end
		end
	end
end

-- ======================== FEEDBACK LISTENER SETUP ========================
local function watchRedemptionFeedbackObject(obj)
	if not (obj:IsA("TextLabel") or obj:IsA("TextButton")) then return end
	handleRedemptionFeedback(obj.Text or "", obj)
	obj:GetPropertyChangedSignal("Text"):Connect(function()
		handleRedemptionFeedback(obj.Text or "", obj)
	end)
end

for _, obj in ipairs(PlayerGui:GetDescendants()) do watchRedemptionFeedbackObject(obj) end
PlayerGui.DescendantAdded:Connect(function(obj)
	task.wait(0.04)
	watchRedemptionFeedbackObject(obj)
end)

UserInputService.TextBoxFocused:Connect(function(box)
	if box:IsDescendantOf(screenGui) then return end
	_focused = box
end)

UserInputService.TextBoxFocusReleased:Connect(function(box)
	if box:IsDescendantOf(screenGui) then return end
	local codeBox = aceCodeBox()
	if box ~= codeBox and box ~= _lastBox then return end
	if _retypeInvalid and rememberPendingSubmission and (box == codeBox or box == _lastBox) then
		local submittedText = box.Text ~= "" and box.Text or _lastNonBlankBoxText
		rememberPendingSubmission(box, submittedText, false)
	end
	if _focused == box then
		_focused = nil
	end
end)

-- ======================== CODE SNIPER (TOGGLE) ========================
local codeSniperRow = makeMainRow(1)
local codeSniperLabel = Instance.new("TextLabel")
codeSniperLabel.Size = UDim2.new(0.7, 0, 1, 0)
codeSniperLabel.Position = UDim2.new(0, 14, 0, 0)
codeSniperLabel.BackgroundTransparency = 1
codeSniperLabel.Font = Enum.Font.GothamMedium
codeSniperLabel.TextSize = 12
codeSniperLabel.TextColor3 = Theme.text
codeSniperLabel.TextXAlignment = Enum.TextXAlignment.Left
codeSniperLabel.Text = "Code Sniper"
codeSniperLabel.ZIndex = 4
codeSniperLabel.Parent = codeSniperRow

local codeSniperTrack = Instance.new("Frame")
codeSniperTrack.Size = UDim2.new(0, 42, 0, 22)
codeSniperTrack.Position = UDim2.new(1, -56, 0.5, -11)
codeSniperTrack.BackgroundColor3 = Theme.toggleOff
codeSniperTrack.ZIndex = 4
codeSniperTrack.Parent = codeSniperRow
corner(codeSniperTrack, 11)

local codeSniperKnob = Instance.new("Frame")
codeSniperKnob.Size = UDim2.new(0, 16, 0, 16)
codeSniperKnob.Position = UDim2.new(0, 3, 0.5, -8)
codeSniperKnob.BackgroundColor3 = Theme.white
codeSniperKnob.ZIndex = 5
codeSniperKnob.Parent = codeSniperTrack
corner(codeSniperKnob, 8)

local codeSniperBtn = Instance.new("TextButton")
codeSniperBtn.Size = UDim2.new(1, 0, 1, 0)
codeSniperBtn.BackgroundTransparency = 1
codeSniperBtn.Text = ""
codeSniperBtn.ZIndex = 5
codeSniperBtn.Parent = codeSniperRow

codeSniperBtn.MouseButton1Click:Connect(function()
	state.codeSniperToggled = not state.codeSniperToggled
	if state.codeSniperToggled then
		TweenService:Create(codeSniperTrack, TweenFast, { BackgroundColor3 = Theme.toggleOn }):Play()
		TweenService:Create(codeSniperKnob, TweenFast, { Position = UDim2.new(0, 23, 0.5, -8) }):Play()
		pushLog("> code sniper: ON", COL_ON)
		task.spawn(function()
			local box = aceCodeBox()
			if not box then
				pushLog("> code sniper: no box", Color3.fromRGB(200, 180, 100))
				return
			end
			local code = box.Text
			if not code or code == "" then
				pushLog("> code sniper: empty box", Color3.fromRGB(200, 180, 100))
				return
			end
			local ok, msg = typeAndSubmitCode(code)
			if ok then
				pushLog("> code sniper: " .. msg, COL_ON)
			else
				pushLog("> code sniper: " .. tostring(msg), Color3.fromRGB(255, 90, 90))
			end
		end)
	else
		TweenService:Create(codeSniperTrack, TweenFast, { BackgroundColor3 = Theme.toggleOff }):Play()
		TweenService:Create(codeSniperKnob, TweenFast, { Position = UDim2.new(0, 3, 0.5, -8) }):Play()
		pushLog("> code sniper: OFF", Color3.fromRGB(140, 140, 150))
	end
end)

-- ======================== AUTO SUBMIT (TOGGLE) ========================
local autoSubmitRow = makeMainRow(2)
local autoSubmitLabel = Instance.new("TextLabel")
autoSubmitLabel.Size = UDim2.new(0.7, 0, 1, 0)
autoSubmitLabel.Position = UDim2.new(0, 14, 0, 0)
autoSubmitLabel.BackgroundTransparency = 1
autoSubmitLabel.Font = Enum.Font.GothamMedium
autoSubmitLabel.TextSize = 12
autoSubmitLabel.TextColor3 = Theme.text
autoSubmitLabel.TextXAlignment = Enum.TextXAlignment.Left
autoSubmitLabel.Text = "Auto Submit"
autoSubmitLabel.ZIndex = 4
autoSubmitLabel.Parent = autoSubmitRow

local autoSubmitTrack = Instance.new("Frame")
autoSubmitTrack.Size = UDim2.new(0, 42, 0, 22)
autoSubmitTrack.Position = UDim2.new(1, -56, 0.5, -11)
autoSubmitTrack.BackgroundColor3 = savedConfig.autoSubmit and Theme.toggleOn or Theme.toggleOff
autoSubmitTrack.ZIndex = 4
autoSubmitTrack.Parent = autoSubmitRow
corner(autoSubmitTrack, 11)

local autoSubmitKnob = Instance.new("Frame")
autoSubmitKnob.Size = UDim2.new(0, 16, 0, 16)
autoSubmitKnob.Position = savedConfig.autoSubmit and UDim2.new(0, 23, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
autoSubmitKnob.BackgroundColor3 = Theme.white
autoSubmitKnob.ZIndex = 5
autoSubmitKnob.Parent = autoSubmitTrack
corner(autoSubmitKnob, 8)

local autoSubmitBtn = Instance.new("TextButton")
autoSubmitBtn.Size = UDim2.new(1, 0, 1, 0)
autoSubmitBtn.BackgroundTransparency = 1
autoSubmitBtn.Text = ""
autoSubmitBtn.ZIndex = 5
autoSubmitBtn.Parent = autoSubmitRow

state.autoSubmitToggled = savedConfig.autoSubmit

autoSubmitBtn.MouseButton1Click:Connect(function()
	state.autoSubmitToggled = not state.autoSubmitToggled
	_autoAccept = state.autoSubmitToggled
	savedConfig.autoSubmit = state.autoSubmitToggled
	if state.autoSubmitToggled then
		TweenService:Create(autoSubmitTrack, TweenFast, { BackgroundColor3 = Theme.toggleOn }):Play()
		TweenService:Create(autoSubmitKnob, TweenFast, { Position = UDim2.new(0, 23, 0.5, -8) }):Play()
		pushLog("> auto submit: ON", COL_ON)
	else
		TweenService:Create(autoSubmitTrack, TweenFast, { BackgroundColor3 = Theme.toggleOff }):Play()
		TweenService:Create(autoSubmitKnob, TweenFast, { Position = UDim2.new(0, 3, 0.5, -8) }):Play()
		pushLog("> auto submit: OFF", Color3.fromRGB(140, 140, 150))
	end
end)

-- ======================== RETYPE INVALID (TOGGLE) ========================
local retypeRow = makeMainRow(3)
local retypeLabel = Instance.new("TextLabel")
retypeLabel.Size = UDim2.new(0.7, 0, 1, 0)
retypeLabel.Position = UDim2.new(0, 14, 0, 0)
retypeLabel.BackgroundTransparency = 1
retypeLabel.Font = Enum.Font.GothamMedium
retypeLabel.TextSize = 12
retypeLabel.TextColor3 = Theme.text
retypeLabel.TextXAlignment = Enum.TextXAlignment.Left
retypeLabel.Text = "Retype Invalid"
retypeLabel.ZIndex = 4
retypeLabel.Parent = retypeRow

local retypeTrack = Instance.new("Frame")
retypeTrack.Size = UDim2.new(0, 42, 0, 22)
retypeTrack.Position = UDim2.new(1, -56, 0.5, -11)
retypeTrack.BackgroundColor3 = savedConfig.retypeInvalid and Theme.toggleOn or Theme.toggleOff
retypeTrack.ZIndex = 4
retypeTrack.Parent = retypeRow
corner(retypeTrack, 11)

local retypeKnob = Instance.new("Frame")
retypeKnob.Size = UDim2.new(0, 16, 0, 16)
retypeKnob.Position = savedConfig.retypeInvalid and UDim2.new(0, 23, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
retypeKnob.BackgroundColor3 = Theme.white
retypeKnob.ZIndex = 5
retypeKnob.Parent = retypeTrack
corner(retypeKnob, 8)

local retypeBtn = Instance.new("TextButton")
retypeBtn.Size = UDim2.new(1, 0, 1, 0)
retypeBtn.BackgroundTransparency = 1
retypeBtn.Text = ""
retypeBtn.ZIndex = 5
retypeBtn.Parent = retypeRow

state.retypeInvalidToggled = savedConfig.retypeInvalid

retypeBtn.MouseButton1Click:Connect(function()
	state.retypeInvalidToggled = not state.retypeInvalidToggled
	_retypeInvalid = state.retypeInvalidToggled
	savedConfig.retypeInvalid = state.retypeInvalidToggled
	if state.retypeInvalidToggled then
		TweenService:Create(retypeTrack, TweenFast, { BackgroundColor3 = Theme.toggleOn }):Play()
		TweenService:Create(retypeKnob, TweenFast, { Position = UDim2.new(0, 23, 0.5, -8) }):Play()
		pushLog("> retype invalid: ON", COL_ON)
	else
		TweenService:Create(retypeTrack, TweenFast, { BackgroundColor3 = Theme.toggleOff }):Play()
		TweenService:Create(retypeKnob, TweenFast, { Position = UDim2.new(0, 3, 0.5, -8) }):Play()
		clearPendingSubmission()
		pushLog("> retype invalid: OFF", Color3.fromRGB(140, 140, 150))
	end
end)

-- ======================== RIDDLE SOLVER LOGIC ========================
local CONFIG = {
	PrimaryModel = "qwen",
	BackupModel = "qwen",
	RiddleURL = "https://sab-riddle-solver.xyrcheatz.workers.dev",
	RiddleToken = "0facce8d7ac3a4b6fc4b6ae068b3b219883009780cb2ca31",
	RaceModels = false,
	Enabled = true,
	AIRiddles = true,
}

local _riddleSolver = savedConfig.riddleSolver
local _lastStatusMsg = nil
local solving = 0
local lastTypedSeq = 0
local solvedCount = 0

local function httpRequest(options)
	return HttpService:RequestAsync(options)
end

local function normalizeCode(str)
	if not str or type(str) ~= "string" then return nil end
	return str:match("^%s*(.-)%s*$"):upper()
end

local function aiPost(path, body)
	if not httpRequest then return nil end
	local ok, res = pcall(httpRequest, {
		Url = CONFIG.RiddleURL .. path,
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
			["Authorization"] = "Bearer " .. CONFIG.RiddleToken,
		},
		Body = HttpService:JSONEncode(body),
	})
	if not ok or type(res) ~= "table" then return nil end
	local raw = res.Body or res.body
	if type(raw) ~= "string" then return nil end
	local okd, data = pcall(function() return HttpService:JSONDecode(raw) end)
	if okd and type(data) == "table" then return data end
	return nil
end

local function submitRiddleAnswer(answer)
	pushLog("> riddle answer: " .. tostring(answer), COL_ON)
end

local function logFeed(message, result, answer)
	local icon = result == "solved" and "[OK]" or result == "skip" and "[SKIP]" or "[?]"
	local line = "> riddle " .. icon .. " " .. message
	if answer then line = line .. " -> " .. answer end
	local col = result == "solved" and COL_ON or Color3.fromRGB(140, 140, 150)
	pushLog(line, col)
end

local function solveMessage(message, seq, hist)
	if not _riddleSolver then return end
	solving = solving + 1
	task.spawn(function()
		local model = CONFIG.RaceModels and CONFIG.BackupModel or CONFIG.PrimaryModel
		local data = aiPost("/solve", { message = message, model = model, history = hist })
		solving = math.max(0, solving - 1)
		if not _riddleSolver then return end
		local top = (data and data.riddle == true and type(data.answers) == "table" and data.answers[1]) and normalizeCode(data.answers[1]) or nil
		if top and #top > 0 and CONFIG.Enabled and CONFIG.AIRiddles and seq >= lastTypedSeq then
			lastTypedSeq = seq
			solvedCount = solvedCount + 1
			submitRiddleAnswer(top)
			logFeed(message, "solved", top)
		elseif not top or #top == 0 then
			logFeed(message, "skip")
		end
	end)
end

local function detectRiddle(message)
	if message and message:lower():find("riddle") then
		solveMessage(message, os.time(), {})
	end
end

-- ======================== RIDDLE SOLVER (TOGGLE) ========================
local riddleRow = makeMainRow(4)
local riddleLabel = Instance.new("TextLabel")
riddleLabel.Size = UDim2.new(0.7, 0, 1, 0)
riddleLabel.Position = UDim2.new(0, 14, 0, 0)
riddleLabel.BackgroundTransparency = 1
riddleLabel.Font = Enum.Font.GothamMedium
riddleLabel.TextSize = 12
riddleLabel.TextColor3 = Theme.text
riddleLabel.TextXAlignment = Enum.TextXAlignment.Left
riddleLabel.Text = "Riddle Solver"
riddleLabel.ZIndex = 4
riddleLabel.Parent = riddleRow

local riddleTrack = Instance.new("Frame")
riddleTrack.Size = UDim2.new(0, 42, 0, 22)
riddleTrack.Position = UDim2.new(1, -56, 0.5, -11)
riddleTrack.BackgroundColor3 = savedConfig.riddleSolver and Theme.toggleOn or Theme.toggleOff
riddleTrack.ZIndex = 4
riddleTrack.Parent = riddleRow
corner(riddleTrack, 11)

local riddleKnob = Instance.new("Frame")
riddleKnob.Size = UDim2.new(0, 16, 0, 16)
riddleKnob.Position = savedConfig.riddleSolver and UDim2.new(0, 23, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
riddleKnob.BackgroundColor3 = Theme.white
riddleKnob.ZIndex = 5
riddleKnob.Parent = riddleTrack
corner(riddleKnob, 8)

local riddleBtn = Instance.new("TextButton")
riddleBtn.Size = UDim2.new(1, 0, 1, 0)
riddleBtn.BackgroundTransparency = 1
riddleBtn.Text = ""
riddleBtn.ZIndex = 5
riddleBtn.Parent = riddleRow

local riddleConnections = {}

local function riddleHookChat()
	local function scanMessage(msg)
		if not state.riddleSolverToggled then return end
		if not msg or type(msg) ~= "string" then return end
		detectRiddle(msg)
	end

	local tcs = game:GetService("TextChatService")
	if tcs and tcs:FindFirstChild("TextChannels") then
		for _, channel in ipairs(tcs.TextChannels:GetChildren()) do
			if channel:IsA("TextChannel") then
				local conn = channel.MessageReceived:Connect(function(msg)
					pcall(function() scanMessage(msg.Text) end)
				end)
				table.insert(riddleConnections, conn)
			end
		end
	end

	local chatEvents = LocalPlayer:FindFirstChild("PlayerScripts")
	if chatEvents then
		local chat = chatEvents:FindFirstChild("ChatScript")
		if chat then
			local defaultChat = LocalPlayer.PlayerGui:FindFirstChild("Chat")
			if defaultChat and defaultChat:FindFirstChild("Frame") then
				local conn = defaultChat.Frame.ChildAdded:Connect(function(child)
					pcall(function()
						if child:IsA("TextLabel") then
							scanMessage(child.Text)
						end
					end)
				end)
				table.insert(riddleConnections, conn)
			end
		end
	end
end

local function riddleUnhook()
	for _, c in ipairs(riddleConnections) do
		pcall(function() c:Disconnect() end)
	end
	riddleConnections = {}
end

riddleBtn.MouseButton1Click:Connect(function()
	state.riddleSolverToggled = not state.riddleSolverToggled
	if state.riddleSolverToggled then
		_riddleSolver = true
		TweenService:Create(riddleTrack, TweenFast, { BackgroundColor3 = Theme.toggleOn }):Play()
		TweenService:Create(riddleKnob, TweenFast, { Position = UDim2.new(0, 23, 0.5, -8) }):Play()
		task.spawn(riddleHookChat)
		pushLog("> riddle solver: ON", COL_ON)
	else
		_riddleSolver = false
		TweenService:Create(riddleTrack, TweenFast, { BackgroundColor3 = Theme.toggleOff }):Play()
		TweenService:Create(riddleKnob, TweenFast, { Position = UDim2.new(0, 3, 0.5, -8) }):Play()
		riddleUnhook()
		pushLog("> riddle solver: OFF", Color3.fromRGB(140, 140, 150))
	end
end)

-- ======================== LOGS PANEL (MAIN TAB) ========================
local logRow = Instance.new("Frame")
logRow.Size = UDim2.new(1, -4, 0, 90)
logRow.BackgroundColor3 = COL_WHITE
logRow.BorderSizePixel = 0
logRow.LayoutOrder = 5
logRow.ZIndex = 3
logRow.Parent = pageMain
corner(logRow, 6)

local LogGrad = Instance.new("UIGradient")
LogGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.3, Color3.fromRGB(15, 15, 20)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.8, Color3.fromRGB(15, 15, 20)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
})
LogGrad.Parent = logRow

local logGradConn
local spinT = 0
logGradConn = RunService.RenderStepped:Connect(function(dt)
	spinT = (spinT + dt * 0.35) % 1
	LogGrad.Offset = Vector2.new(spinT, 0)
end)

local LogInner = Instance.new("Frame")
LogInner.Size = UDim2.new(1, -2, 1, -2)
LogInner.Position = UDim2.new(0, 1, 0, 1)
LogInner.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
LogInner.BorderSizePixel = 0
LogInner.ClipsDescendants = true
LogInner.ZIndex = 4
LogInner.Parent = logRow
corner(LogInner, 5)

LogLabel = Instance.new("TextLabel")
LogLabel.Size = UDim2.new(1, -8, 1, -6)
LogLabel.Position = UDim2.new(0, 4, 0, 3)
LogLabel.BackgroundTransparency = 1
LogLabel.Text = "> scanning for codes..."
LogLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
LogLabel.Font = Enum.Font.Code
LogLabel.TextSize = 11
LogLabel.TextXAlignment = Enum.TextXAlignment.Left
LogLabel.TextYAlignment = Enum.TextYAlignment.Top
LogLabel.TextWrapped = true
LogLabel.ZIndex = 5
LogLabel.Parent = LogInner

local clearLogsBtn = Instance.new("TextButton")
clearLogsBtn.Size = UDim2.new(0, 46, 0, 18)
clearLogsBtn.Position = UDim2.new(1, -50, 0, 4)
clearLogsBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
clearLogsBtn.BackgroundTransparency = 0.15
clearLogsBtn.Font = Enum.Font.GothamBold
clearLogsBtn.TextSize = 10
clearLogsBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
clearLogsBtn.Text = "CLEAR"
clearLogsBtn.AutoButtonColor = false
clearLogsBtn.ZIndex = 10
clearLogsBtn.Parent = LogInner
corner(clearLogsBtn, 4)
stroke(clearLogsBtn, Color3.fromRGB(70, 70, 75), 1)
hover(clearLogsBtn, Color3.fromRGB(40, 40, 45), Color3.fromRGB(180, 50, 70))

clearLogsBtn.MouseButton1Click:Connect(function()
	logLines = {}
	if LogLabel then
		LogLabel.Text = ""
	end
end)

-- ======================== UTILIS PAGE (SCROLLABLE) ========================
local pageUtilis = Instance.new("Frame")
pageUtilis.Size = UDim2.new(1, 0, 1, 0)
pageUtilis.BackgroundTransparency = 1
pageUtilis.Visible = false
pageUtilis.ZIndex = 2
pageUtilis.Parent = content
pageUtilis.ClipsDescendants = true
pages["Utilis"] = pageUtilis

local utilisScroll = Instance.new("ScrollingFrame")
utilisScroll.Size = UDim2.new(1, 0, 1, 0)
utilisScroll.BackgroundTransparency = 1
utilisScroll.BorderSizePixel = 0
utilisScroll.ScrollBarThickness = 4
utilisScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
utilisScroll.ScrollBarImageTransparency = 0.3
utilisScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
utilisScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
utilisScroll.ScrollingDirection = Enum.ScrollingDirection.Y
utilisScroll.ZIndex = 2
utilisScroll.Parent = pageUtilis

local utilisLayout = Instance.new("UIListLayout")
utilisLayout.Padding = UDim.new(0, 10)
utilisLayout.SortOrder = Enum.SortOrder.LayoutOrder
utilisLayout.Parent = utilisScroll

local utilisPad = Instance.new("UIPadding")
utilisPad.PaddingBottom = UDim.new(0, 12)
utilisPad.PaddingRight = UDim.new(0, 4)
utilisPad.Parent = utilisScroll

local function makeUtilisRow(order)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -4, 0, 40)
	row.BackgroundColor3 = Theme.bgCard
	row.BackgroundTransparency = 0.15
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.ZIndex = 3
	row.Parent = utilisScroll
	corner(row, 10)
	stroke(row, Theme.stroke, 1)
	return row
end

-- ======================== ANTI LAG (TOGGLE) ========================
local antiLagRow = makeUtilisRow(1)
local antiLagLabel = Instance.new("TextLabel")
antiLagLabel.Size = UDim2.new(0.7, 0, 1, 0)
antiLagLabel.Position = UDim2.new(0, 14, 0, 0)
antiLagLabel.BackgroundTransparency = 1
antiLagLabel.Font = Enum.Font.GothamMedium
antiLagLabel.TextSize = 12
antiLagLabel.TextColor3 = Theme.text
antiLagLabel.TextXAlignment = Enum.TextXAlignment.Left
antiLagLabel.Text = "Anti Lag"
antiLagLabel.ZIndex = 4
antiLagLabel.Parent = antiLagRow

local antiLagTrack = Instance.new("Frame")
antiLagTrack.Size = UDim2.new(0, 42, 0, 22)
antiLagTrack.Position = UDim2.new(1, -56, 0.5, -11)
antiLagTrack.BackgroundColor3 = Theme.toggleOff
antiLagTrack.ZIndex = 4
antiLagTrack.Parent = antiLagRow
corner(antiLagTrack, 11)

local antiLagKnob = Instance.new("Frame")
antiLagKnob.Size = UDim2.new(0, 16, 0, 16)
antiLagKnob.Position = UDim2.new(0, 3, 0.5, -8)
antiLagKnob.BackgroundColor3 = Theme.white
antiLagKnob.ZIndex = 5
antiLagKnob.Parent = antiLagTrack
corner(antiLagKnob, 8)

local antiLagBtn = Instance.new("TextButton")
antiLagBtn.Size = UDim2.new(1, 0, 1, 0)
antiLagBtn.BackgroundTransparency = 1
antiLagBtn.Text = ""
antiLagBtn.ZIndex = 5
antiLagBtn.Parent = antiLagRow

local function DestroyAllEffects()
	for _, obj in ipairs(workspace:GetDescendants()) do
		pcall(function()
			if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
				obj.Enabled = false
				obj:Destroy()
			end
		end)
	end
end

local function DestroyAnimations()
	for _, obj in ipairs(workspace:GetDescendants()) do
		pcall(function()
			if obj:IsA("Animation") or obj:IsA("Animator") or obj:IsA("AnimationController") then
				obj:Destroy()
			end
		end)
	end
	if LocalPlayer.Character then
		for _, obj in ipairs(LocalPlayer.Character:GetDescendants()) do
			pcall(function()
				if obj:IsA("Animation") or obj:IsA("Animator") or obj:IsA("AnimationController") then
					obj:Destroy()
				end
			end)
		end
	end
end

local function OptimizeLighting()
	Lighting.Brightness = 2
	Lighting.ClockTime = 12
	Lighting.FogEnd = 1000
	Lighting.GlobalShadows = false
	Lighting.Outlines = false
end

local function enableAntiLag()
	DestroyAllEffects()
	DestroyAnimations()
	OptimizeLighting()
	pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
	pcall(function() settings().Rendering.Shadows = false end)
	Camera.FieldOfView = 90
	for _, effect in ipairs(Camera:GetChildren()) do
		if effect:IsA("BloomEffect") or effect:IsA("DepthOfField") or effect:IsA("ColorCorrectionEffect") then
			effect.Enabled = false
		end
	end
end

antiLagBtn.MouseButton1Click:Connect(function()
	state.antiLagToggled = not state.antiLagToggled
	if state.antiLagToggled then
		TweenService:Create(antiLagTrack, TweenFast, { BackgroundColor3 = Theme.toggleOn }):Play()
		TweenService:Create(antiLagKnob, TweenFast, { Position = UDim2.new(0, 23, 0.5, -8) }):Play()
		task.spawn(enableAntiLag)
	else
		TweenService:Create(antiLagTrack, TweenFast, { BackgroundColor3 = Theme.toggleOff }):Play()
		TweenService:Create(antiLagKnob, TweenFast, { Position = UDim2.new(0, 3, 0.5, -8) }):Play()
	end
end)

-- ======================== ANTI DIE (TOGGLE) ========================
local antiDieRow = makeUtilisRow(2)
local antiDieLabel = Instance.new("TextLabel")
antiDieLabel.Size = UDim2.new(0.7, 0, 1, 0)
antiDieLabel.Position = UDim2.new(0, 14, 0, 0)
antiDieLabel.BackgroundTransparency = 1
antiDieLabel.Font = Enum.Font.GothamMedium
antiDieLabel.TextSize = 12
antiDieLabel.TextColor3 = Theme.text
antiDieLabel.TextXAlignment = Enum.TextXAlignment.Left
antiDieLabel.Text = "Anti Die"
antiDieLabel.ZIndex = 4
antiDieLabel.Parent = antiDieRow

local antiDieTrack = Instance.new("Frame")
antiDieTrack.Size = UDim2.new(0, 42, 0, 22)
antiDieTrack.Position = UDim2.new(1, -56, 0.5, -11)
antiDieTrack.BackgroundColor3 = Theme.toggleOff
antiDieTrack.ZIndex = 4
antiDieTrack.Parent = antiDieRow
corner(antiDieTrack, 11)

local antiDieKnob = Instance.new("Frame")
antiDieKnob.Size = UDim2.new(0, 16, 0, 16)
antiDieKnob.Position = UDim2.new(0, 3, 0.5, -8)
antiDieKnob.BackgroundColor3 = Theme.white
antiDieKnob.ZIndex = 5
antiDieKnob.Parent = antiDieTrack
corner(antiDieKnob, 8)

local antiDieBtn = Instance.new("TextButton")
antiDieBtn.Size = UDim2.new(1, 0, 1, 0)
antiDieBtn.BackgroundTransparency = 1
antiDieBtn.Text = ""
antiDieBtn.ZIndex = 5
antiDieBtn.Parent = antiDieRow

local heartConn = nil
local deathConns = {}
local charAddedConn = nil

local function protectChar(char)
	if not char then return end
	local hum = char:WaitForChild("Humanoid", 5)
	if not hum then return end

	hum.MaxHealth = math.huge
	hum.Health = math.huge

	local sc = hum.StateChanged:Connect(function(_, new)
		if not state.antiDieToggled then return end
		if new == Enum.HumanoidStateType.Dead then
			hum.Health = math.huge
			hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
		end
	end)
	table.insert(deathConns, sc)

	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

	local hc = hum:GetPropertyChangedSignal("Health"):Connect(function()
		if not state.antiDieToggled then return end
		if hum.Health < hum.MaxHealth then
			hum.Health = math.huge
		end
	end)
	table.insert(deathConns, hc)

	if heartConn then heartConn:Disconnect() end
	heartConn = RunService.Heartbeat:Connect(function()
		if not state.antiDieToggled then return end
		if hum and hum.Parent and hum.Health < hum.MaxHealth then
			hum.Health = math.huge
		end
	end)
end

local function startProtect()
	for _, c in ipairs(deathConns) do pcall(function() c:Disconnect() end) end
	deathConns = {}
	if heartConn then heartConn:Disconnect(); heartConn = nil end
	if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end

	protectChar(LocalPlayer.Character)

	charAddedConn = LocalPlayer.CharacterAdded:Connect(function(c)
		if not state.antiDieToggled then return end
		task.wait(0.1)
		for _, c2 in ipairs(deathConns) do pcall(function() c2:Disconnect() end) end
		deathConns = {}
		protectChar(c)
	end)
end

local function stopProtect()
	for _, c in ipairs(deathConns) do pcall(function() c:Disconnect() end) end
	deathConns = {}
	if heartConn then heartConn:Disconnect(); heartConn = nil end
	if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end

	local char = LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
			hum.MaxHealth = 100
			hum.Health = 100
		end
	end
end

local function toggleAntiDie()
	state.antiDieToggled = not state.antiDieToggled
	if state.antiDieToggled then startProtect() else stopProtect() end
end

antiDieBtn.MouseButton1Click:Connect(function()
	toggleAntiDie()
	if state.antiDieToggled then
		TweenService:Create(antiDieTrack, TweenFast, { BackgroundColor3 = Theme.toggleOn }):Play()
		TweenService:Create(antiDieKnob, TweenFast, { Position = UDim2.new(0, 23, 0.5, -8) }):Play()
	else
		TweenService:Create(antiDieTrack, TweenFast, { BackgroundColor3 = Theme.toggleOff }):Play()
		TweenService:Create(antiDieKnob, TweenFast, { Position = UDim2.new(0, 3, 0.5, -8) }):Play()
	end
end)

-- ======================== ANTI RAGDOLL (TOGGLE) ========================
local antiRagdollRow = makeUtilisRow(3)
local antiRagdollLabel = Instance.new("TextLabel")
antiRagdollLabel.Size = UDim2.new(0.7, 0, 1, 0)
antiRagdollLabel.Position = UDim2.new(0, 14, 0, 0)
antiRagdollLabel.BackgroundTransparency = 1
antiRagdollLabel.Font = Enum.Font.GothamMedium
antiRagdollLabel.TextSize = 12
antiRagdollLabel.TextColor3 = Theme.text
antiRagdollLabel.TextXAlignment = Enum.TextXAlignment.Left
antiRagdollLabel.Text = "Anti Ragdoll"
antiRagdollLabel.ZIndex = 4
antiRagdollLabel.Parent = antiRagdollRow

local antiRagdollTrack = Instance.new("Frame")
antiRagdollTrack.Size = UDim2.new(0, 42, 0, 22)
antiRagdollTrack.Position = UDim2.new(1, -56, 0.5, -11)
antiRagdollTrack.BackgroundColor3 = savedConfig.antiRagdoll and Theme.toggleOn or Theme.toggleOff
antiRagdollTrack.ZIndex = 4
antiRagdollTrack.Parent = antiRagdollRow
corner(antiRagdollTrack, 11)

local antiRagdollKnob = Instance.new("Frame")
antiRagdollKnob.Size = UDim2.new(0, 16, 0, 16)
antiRagdollKnob.Position = savedConfig.antiRagdoll and UDim2.new(0, 23, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
antiRagdollKnob.BackgroundColor3 = Theme.white
antiRagdollKnob.ZIndex = 5
antiRagdollKnob.Parent = antiRagdollTrack
corner(antiRagdollKnob, 8)

local antiRagdollBtn = Instance.new("TextButton")
antiRagdollBtn.Size = UDim2.new(1, 0, 1, 0)
antiRagdollBtn.BackgroundTransparency = 1
antiRagdollBtn.Text = ""
antiRagdollBtn.ZIndex = 5
antiRagdollBtn.Parent = antiRagdollRow

local _antiRagdollEnabled = savedConfig.antiRagdoll
local _ragdollConnection = nil
local _ragdollCooldown = 0

local function forceReset()
	local char = LocalPlayer.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not hum or not root or hum.Health <= 0 then return end

	pcall(function()
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		root.Velocity = Vector3.zero
		root.RotVelocity = Vector3.zero
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero

		for _, obj in ipairs(char:GetDescendants()) do
			if obj:IsA("Motor6D") then obj.Enabled = true end
			if obj:IsA("Constraint") then obj.Enabled = true end
		end

		workspace.CurrentCamera.CameraSubject = hum

		local PM = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
		if PM then
			local CM = require(PM:FindFirstChild("ControlModule"))
			if CM then CM:Enable() end
		end

		hum.AutoRotate = true
		hum.PlatformStand = false
		hum.Sit = false
	end)
end

local function startAntiRagdoll()
	if _ragdollConnection then return end
	_antiRagdollEnabled = true
	_ragdollConnection = RunService.Heartbeat:Connect(function()
		if not _antiRagdollEnabled then return end
		local char = LocalPlayer.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then return end

		local humState = hum:GetState()
		local isRagdolled = (humState == Enum.HumanoidStateType.Physics or
							 humState == Enum.HumanoidStateType.Ragdoll or
							 humState == Enum.HumanoidStateType.FallingDown)

		if isRagdolled then
			local now = tick()
			if now - _ragdollCooldown > 0.15 then
				_ragdollCooldown = now
				forceReset()
			end
		end
	end)
end

local function stopAntiRagdoll()
	_antiRagdollEnabled = false
	if _ragdollConnection then
		_ragdollConnection:Disconnect()
		_ragdollConnection = nil
	end
end

antiRagdollBtn.MouseButton1Click:Connect(function()
	state.antiRagdollToggled = not state.antiRagdollToggled
	savedConfig.antiRagdoll = state.antiRagdollToggled
	if state.antiRagdollToggled then
		TweenService:Create(antiRagdollTrack, TweenFast, { BackgroundColor3 = Theme.toggleOn }):Play()
		TweenService:Create(antiRagdollKnob, TweenFast, { Position = UDim2.new(0, 23, 0.5, -8) }):Play()
		startAntiRagdoll()
	else
		TweenService:Create(antiRagdollTrack, TweenFast, { BackgroundColor3 = Theme.toggleOff }):Play()
		TweenService:Create(antiRagdollKnob, TweenFast, { Position = UDim2.new(0, 3, 0.5, -8) }):Play()
		stopAntiRagdoll()
	end
end)

-- ======================== ANTI CHEAT BYPASS (TOGGLE - NO LOGIC) ========================
local antiCheatRow = makeUtilisRow(4)
local antiCheatLabel = Instance.new("TextLabel")
antiCheatLabel.Size = UDim2.new(0.7, 0, 1, 0)
antiCheatLabel.Position = UDim2.new(0, 14, 0, 0)
antiCheatLabel.BackgroundTransparency = 1
antiCheatLabel.Font = Enum.Font.GothamMedium
antiCheatLabel.TextSize = 12
antiCheatLabel.TextColor3 = Theme.text
antiCheatLabel.TextXAlignment = Enum.TextXAlignment.Left
antiCheatLabel.Text = "Anti Cheat Bypass"
antiCheatLabel.ZIndex = 4
antiCheatLabel.Parent = antiCheatRow

local antiCheatTrack = Instance.new("Frame")
antiCheatTrack.Size = UDim2.new(0, 42, 0, 22)
antiCheatTrack.Position = UDim2.new(1, -56, 0.5, -11)
antiCheatTrack.BackgroundColor3 = Theme.toggleOff
antiCheatTrack.ZIndex = 4
antiCheatTrack.Parent = antiCheatRow
corner(antiCheatTrack, 11)

local antiCheatKnob = Instance.new("Frame")
antiCheatKnob.Size = UDim2.new(0, 16, 0, 16)
antiCheatKnob.Position = UDim2.new(0, 3, 0.5, -8)
antiCheatKnob.BackgroundColor3 = Theme.white
antiCheatKnob.ZIndex = 5
antiCheatKnob.Parent = antiCheatTrack
corner(antiCheatKnob, 8)

local antiCheatBtn = Instance.new("TextButton")
antiCheatBtn.Size = UDim2.new(1, 0, 1, 0)
antiCheatBtn.BackgroundTransparency = 1
antiCheatBtn.Text = ""
antiCheatBtn.ZIndex = 5
antiCheatBtn.Parent = antiCheatRow

antiCheatBtn.MouseButton1Click:Connect(function()
	state.antiCheatBypassToggled = not state.antiCheatBypassToggled
	if state.antiCheatBypassToggled then
		TweenService:Create(antiCheatTrack, TweenFast, { BackgroundColor3 = Theme.toggleOn }):Play()
		TweenService:Create(antiCheatKnob, TweenFast, { Position = UDim2.new(0, 23, 0.5, -8) }):Play()
	else
		TweenService:Create(antiCheatTrack, TweenFast, { BackgroundColor3 = Theme.toggleOff }):Play()
		TweenService:Create(antiCheatKnob, TweenFast, { Position = UDim2.new(0, 3, 0.5, -8) }):Play()
	end
end)

-- ======================== ANCHORED (TOGGLE - NO LOG) ========================
local anchoredRow = makeUtilisRow(5)
local anchoredLabel = Instance.new("TextLabel")
anchoredLabel.Size = UDim2.new(0.7, 0, 1, 0)
anchoredLabel.Position = UDim2.new(0, 14, 0, 0)
anchoredLabel.BackgroundTransparency = 1
anchoredLabel.Font = Enum.Font.GothamMedium
anchoredLabel.TextSize = 12
anchoredLabel.TextColor3 = Theme.text
anchoredLabel.TextXAlignment = Enum.TextXAlignment.Left
anchoredLabel.Text = "Anchored"
anchoredLabel.ZIndex = 4
anchoredLabel.Parent = anchoredRow

local anchoredTrack = Instance.new("Frame")
anchoredTrack.Size = UDim2.new(0, 42, 0, 22)
anchoredTrack.Position = UDim2.new(1, -56, 0.5, -11)
anchoredTrack.BackgroundColor3 = Theme.toggleOff
anchoredTrack.ZIndex = 4
anchoredTrack.Parent = anchoredRow
corner(anchoredTrack, 11)

local anchoredKnob = Instance.new("Frame")
anchoredKnob.Size = UDim2.new(0, 16, 0, 16)
anchoredKnob.Position = UDim2.new(0, 3, 0.5, -8)
anchoredKnob.BackgroundColor3 = Theme.white
anchoredKnob.ZIndex = 5
anchoredKnob.Parent = anchoredTrack
corner(anchoredKnob, 8)

local anchoredBtn = Instance.new("TextButton")
anchoredBtn.Size = UDim2.new(1, 0, 1, 0)
anchoredBtn.BackgroundTransparency = 1
anchoredBtn.Text = ""
anchoredBtn.ZIndex = 5
anchoredBtn.Parent = anchoredRow

local anchored = false

anchoredBtn.MouseButton1Click:Connect(function()
	anchored = not anchored
	if anchored then
		TweenService:Create(anchoredTrack, TweenFast, { BackgroundColor3 = Theme.toggleOn }):Play()
		TweenService:Create(anchoredKnob, TweenFast, { Position = UDim2.new(0, 23, 0.5, -8) }):Play()
	else
		TweenService:Create(anchoredTrack, TweenFast, { BackgroundColor3 = Theme.toggleOff }):Play()
		TweenService:Create(anchoredKnob, TweenFast, { Position = UDim2.new(0, 3, 0.5, -8) }):Play()
	end

	local char = LocalPlayer.Character
	if char then
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.Anchored = anchored
			end
		end
	end
end)

-- ======================== AUTO BUY (TOGGLE - NO LOG) ========================
local autoBuyRow = makeUtilisRow(6)
local autoBuyLabel = Instance.new("TextLabel")
autoBuyLabel.Size = UDim2.new(0.7, 0, 1, 0)
autoBuyLabel.Position = UDim2.new(0, 14, 0, 0)
autoBuyLabel.BackgroundTransparency = 1
autoBuyLabel.Font = Enum.Font.GothamMedium
autoBuyLabel.TextSize = 12
autoBuyLabel.TextColor3 = Theme.text
autoBuyLabel.TextXAlignment = Enum.TextXAlignment.Left
autoBuyLabel.Text = "Auto Buy"
autoBuyLabel.ZIndex = 4
autoBuyLabel.Parent = autoBuyRow

local autoBuyTrack = Instance.new("Frame")
autoBuyTrack.Size = UDim2.new(0, 42, 0, 22)
autoBuyTrack.Position = UDim2.new(1, -56, 0.5, -11)
autoBuyTrack.BackgroundColor3 = Theme.toggleOff
autoBuyTrack.ZIndex = 4
autoBuyTrack.Parent = autoBuyRow
corner(autoBuyTrack, 11)

local autoBuyKnob = Instance.new("Frame")
autoBuyKnob.Size = UDim2.new(0, 16, 0, 16)
autoBuyKnob.Position = UDim2.new(0, 3, 0.5, -8)
autoBuyKnob.BackgroundColor3 = Theme.white
autoBuyKnob.ZIndex = 5
autoBuyKnob.Parent = autoBuyTrack
corner(autoBuyKnob, 8)

local autoBuyBtn = Instance.new("TextButton")
autoBuyBtn.Size = UDim2.new(1, 0, 1, 0)
autoBuyBtn.BackgroundTransparency = 1
autoBuyBtn.Text = ""
autoBuyBtn.ZIndex = 5
autoBuyBtn.Parent = autoBuyRow

local autoBuyActive = false

autoBuyBtn.MouseButton1Click:Connect(function()
	autoBuyActive = not autoBuyActive
	state.autoBuyToggled = autoBuyActive
	if autoBuyActive then
		TweenService:Create(autoBuyTrack, TweenFast, { BackgroundColor3 = Theme.toggleOn }):Play()
		TweenService:Create(autoBuyKnob, TweenFast, { Position = UDim2.new(0, 23, 0.5, -8) }):Play()
	else
		TweenService:Create(autoBuyTrack, TweenFast, { BackgroundColor3 = Theme.toggleOff }):Play()
		TweenService:Create(autoBuyKnob, TweenFast, { Position = UDim2.new(0, 3, 0.5, -8) }):Play()
	end
end)

local autoBuyAccum = 0
RunService.Stepped:Connect(function(_, dt)
	if not autoBuyActive then return end
	autoBuyAccum += dt
	if autoBuyAccum < 0.1 then return end
	autoBuyAccum = 0
	for _, prompt in pairs(workspace:GetDescendants()) do
		if prompt:IsA("ProximityPrompt") then
			pcall(function()
				prompt.HoldDuration = 0
				prompt:InputHoldBegin()
				prompt:InputHoldEnd()
			end)
		end
	end
end)

-- ======================== SETTINGS PAGE ========================
local pageSettings = Instance.new("Frame")
pageSettings.Size = UDim2.new(1, 0, 1, 0)
pageSettings.BackgroundTransparency = 1
pageSettings.Visible = false
pageSettings.ZIndex = 2
pageSettings.Parent = content
pages["Settings"] = pageSettings

local settingsLayout = Instance.new("UIListLayout")
settingsLayout.Padding = UDim.new(0, 10)
settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
settingsLayout.Parent = pageSettings

local function makeSettingsRow(order)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 40)
	row.BackgroundColor3 = Theme.bgCard
	row.BackgroundTransparency = 0.15
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.ZIndex = 3
	row.Parent = pageSettings
	corner(row, 10)
	stroke(row, Theme.stroke, 1)
	return row
end

local sizeRow = makeSettingsRow(1)
local sizeLabel = Instance.new("TextLabel")
sizeLabel.Size = UDim2.new(0.4, 0, 1, 0)
sizeLabel.Position = UDim2.new(0, 14, 0, 0)
sizeLabel.BackgroundTransparency = 1
sizeLabel.Font = Enum.Font.GothamMedium
sizeLabel.TextSize = 12
sizeLabel.TextColor3 = Theme.text
sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
sizeLabel.Text = "GUI Size"
sizeLabel.ZIndex = 4
sizeLabel.Parent = sizeRow

local sizeMinus = Instance.new("TextButton")
sizeMinus.Size = UDim2.new(0, 28, 0, 26)
sizeMinus.Position = UDim2.new(1, -118, 0.5, -13)
sizeMinus.BackgroundColor3 = Theme.bgDark
sizeMinus.Font = Enum.Font.GothamBold
sizeMinus.TextSize = 14
sizeMinus.TextColor3 = Theme.text
sizeMinus.Text = "–"
sizeMinus.AutoButtonColor = false
sizeMinus.ZIndex = 4
sizeMinus.Parent = sizeRow
corner(sizeMinus, 6)

local sizeValue = Instance.new("TextLabel")
sizeValue.Size = UDim2.new(0, 50, 0, 26)
sizeValue.Position = UDim2.new(1, -86, 0.5, -13)
sizeValue.BackgroundTransparency = 1
sizeValue.Font = Enum.Font.GothamBold
sizeValue.TextSize = 12
sizeValue.TextColor3 = Theme.text
sizeValue.Text = "100%"
sizeValue.ZIndex = 4
sizeValue.Parent = sizeRow

local sizePlus = Instance.new("TextButton")
sizePlus.Size = UDim2.new(0, 28, 0, 26)
sizePlus.Position = UDim2.new(1, -34, 0.5, -13)
sizePlus.BackgroundColor3 = Theme.bgDark
sizePlus.Font = Enum.Font.GothamBold
sizePlus.TextSize = 14
sizePlus.TextColor3 = Theme.text
sizePlus.Text = "+"
sizePlus.AutoButtonColor = false
sizePlus.ZIndex = 4
sizePlus.Parent = sizeRow
corner(sizePlus, 6)

local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = main

local function updateSize(delta)
	state.guiSize = math.clamp(state.guiSize + delta, 60, 140)
	sizeValue.Text = state.guiSize .. "%"
	uiScale.Scale = state.guiSize / 100
end
sizeMinus.MouseButton1Click:Connect(function() updateSize(-10) end)
sizePlus.MouseButton1Click:Connect(function() updateSize(10) end)

local resetRow = makeSettingsRow(2)
local resetLabel = Instance.new("TextLabel")
resetLabel.Size = UDim2.new(0.55, 0, 1, 0)
resetLabel.Position = UDim2.new(0, 14, 0, 0)
resetLabel.BackgroundTransparency = 1
resetLabel.Font = Enum.Font.GothamMedium
resetLabel.TextSize = 12
resetLabel.TextColor3 = Theme.text
resetLabel.TextXAlignment = Enum.TextXAlignment.Left
resetLabel.Text = "Reset Position"
resetLabel.ZIndex = 4
resetLabel.Parent = resetRow

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0, 70, 0, 26)
resetBtn.Position = UDim2.new(1, -84, 0.5, -13)
resetBtn.BackgroundColor3 = Theme.accent
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 11
resetBtn.TextColor3 = Theme.bg
resetBtn.Text = "RESET"
resetBtn.AutoButtonColor = false
resetBtn.ZIndex = 4
resetBtn.Parent = resetRow
corner(resetBtn, 6)
hover(resetBtn, Theme.accent, Theme.accentHover)

resetBtn.MouseButton1Click:Connect(function()
	main.Position = UDim2.new(0.5, 0, 0.5, 0)
end)

-- ======================== BACKGROUND IMAGE (TOGGLE - like Anti Lag) ========================
local imgToggleRow = makeSettingsRow(3)
local imgToggleLabel = Instance.new("TextLabel")
imgToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
imgToggleLabel.Position = UDim2.new(0, 14, 0, 0)
imgToggleLabel.BackgroundTransparency = 1
imgToggleLabel.Font = Enum.Font.GothamMedium
imgToggleLabel.TextSize = 12
imgToggleLabel.TextColor3 = Theme.text
imgToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
imgToggleLabel.Text = "Background Image"
imgToggleLabel.ZIndex = 4
imgToggleLabel.Parent = imgToggleRow

local imgToggleTrack = Instance.new("Frame")
imgToggleTrack.Size = UDim2.new(0, 42, 0, 22)
imgToggleTrack.Position = UDim2.new(1, -56, 0.5, -11)
imgToggleTrack.BackgroundColor3 = savedConfig.imageIdEnabled and Theme.toggleOn or Theme.toggleOff
imgToggleTrack.ZIndex = 4
imgToggleTrack.Parent = imgToggleRow
corner(imgToggleTrack, 11)

local imgToggleKnob = Instance.new("Frame")
imgToggleKnob.Size = UDim2.new(0, 16, 0, 16)
imgToggleKnob.Position = savedConfig.imageIdEnabled and UDim2.new(0, 23, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
imgToggleKnob.BackgroundColor3 = Theme.white
imgToggleKnob.ZIndex = 5
imgToggleKnob.Parent = imgToggleTrack
corner(imgToggleKnob, 8)

local imgToggleBtn = Instance.new("TextButton")
imgToggleBtn.Size = UDim2.new(1, 0, 1, 0)
imgToggleBtn.BackgroundTransparency = 1
imgToggleBtn.Text = ""
imgToggleBtn.ZIndex = 5
imgToggleBtn.Parent = imgToggleRow

local function applyImageState(enabled)
	if enabled then
		if bgImage then
			bgImage.Image = ORIGINAL_BG_IMAGE
			bgImage.ImageTransparency = ORIGINAL_BG_TRANSPARENCY
		end
		if logo then
			logo.Image = ORIGINAL_LOGO_IMAGE
		end
	else
		if bgImage then
			bgImage.Image = ""
			bgImage.ImageTransparency = 1
		end
		if logo then
			logo.Image = ""
		end
	end
end

imgToggleBtn.MouseButton1Click:Connect(function()
	state.imageIdEnabled = not state.imageIdEnabled
	savedConfig.imageIdEnabled = state.imageIdEnabled
	if state.imageIdEnabled then
		TweenService:Create(imgToggleTrack, TweenFast, { BackgroundColor3 = Theme.toggleOn }):Play()
		TweenService:Create(imgToggleKnob, TweenFast, { Position = UDim2.new(0, 23, 0.5, -8) }):Play()
		applyImageState(true)
		pushLog("> background image: ON", COL_ON)
	else
		TweenService:Create(imgToggleTrack, TweenFast, { BackgroundColor3 = Theme.toggleOff }):Play()
		TweenService:Create(imgToggleKnob, TweenFast, { Position = UDim2.new(0, 3, 0.5, -8) }):Play()
		applyImageState(false)
		pushLog("> background image: OFF", Color3.fromRGB(140, 140, 150))
	end
end)

local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, 0, 0, 36)
footer.Position = UDim2.new(0, 0, 1, -36)
footer.BackgroundColor3 = Theme.bgDark
footer.BackgroundTransparency = 0.3
footer.BorderSizePixel = 0
footer.ZIndex = 2
footer.Parent = main

-- ======================== WHOLE-SCRIPT DRAG ========================
local dragging = false
local dragStart = nil
local startPos = nil

main.InputBegan:Connect(function(input)
	if state.locked then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if state.locked then
		dragging = false
		return
	end
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

local fullSize = UDim2.new(0, 320, 0, 380)
local minSize = UDim2.new(0, 320, 0, 42)

minBtn.MouseButton1Click:Connect(function()
	state.minimized = not state.minimized
	if state.minimized then
		content.Visible = false
		tabBar.Visible = false
		footer.Visible = false
		TweenService:Create(main, TweenMed, { Size = minSize }):Play()
		minBtn.Text = "+"
	else
		TweenService:Create(main, TweenMed, { Size = fullSize }):Play()
		task.delay(0.2, function()
			content.Visible = true
			tabBar.Visible = true
			footer.Visible = true
		end)
		minBtn.Text = "–"
	end
end)

setTab("Main")
pushLog("> LevithonHub loaded", COL_ON)
print("LevithonHub Lagger Panel loaded")

-- ============================================================
-- FAKE NOTIFY ( Traced,    ":")
-- ============================================================
local function __fakeNotifyBuild()
    local existing = ScreenGui:FindFirstChild("Test")
    if existing then existing:Destroy() end

    local sliced109, sliced111
    sliced109, sliced111 = slicedfn47("Test", 300, 178, "FAKE NOTIFY")
    sliced109.Visible = false
    sliced109.Parent = ScreenGui

    local sliced112 = slicedfn48("X", sliced111)
    sliced112.Size = UDim2.fromOffset(22, 22)
    sliced112.Position = UDim2.new(1, -28, 0.5, -11)
    sliced112.TextSize = 12
    sliced112.MouseButton1Click:Connect(function()
        sliced109.Visible = false
    end)

    local sliced110 = slicedfn42("Frame", {
        Size = UDim2.new(1, -24, 1, -58),
        Position = UDim2.fromOffset(12, 50),
        BackgroundTransparency = 1,
    }, sliced109)
    slicedfn42("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, sliced110)

    local Frame5 = slicedfn42("Frame", {
        Size = UDim2.new(1, 0, 0, 54),
        BackgroundColor3 = tbl21.panel,
        BorderSizePixel = 0,
        LayoutOrder = 1,
    }, sliced110)
    slicedfn43(Frame5, 9)
    slicedfn44(Frame5, tbl21.line, 1, 0.3)

    local message = slicedfn46("MESSAGE", 9, tbl21.acc, gothamBlack, Enum.TextXAlignment.Left, Frame5)
    message.Size = UDim2.new(1, -16, 0, 12)
    message.Position = UDim2.fromOffset(11, 6)

    local TextBox2 = slicedfn42("TextBox", {
        Size = UDim2.new(1, -18, 0, 26),
        Position = UDim2.fromOffset(9, 20),
        BackgroundColor3 = tbl21.input,
        Text = "",
        PlaceholderText = "type a fake announcement...",
        PlaceholderColor3 = tbl21.sub,
        Font = gothamBlack,
        TextSize = 12,
        TextColor3 = tbl21.txt,
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Frame5)

    slicedfn43(TextBox2, 7)
    do
        local stroke2 = slicedfn44(TextBox2, tbl21.line, 1.2, 0.25)
        slicedfn42("UIPadding", {
            PaddingLeft = UDim.new(0, 9),
            PaddingRight = UDim.new(0, 9),
        }, TextBox2)
        TextBox2.Focused:Connect(function()
            slicedfn45(stroke2, 0.12, { Color = tbl21.acc, Transparency = 0 })
        end)
        TextBox2.FocusLost:Connect(function()
            slicedfn45(stroke2, 0.12, { Color = tbl21.line, Transparency = 0.25 })
        end)
    end

    local testCode, send
    do
        local row = slicedfn42("Frame", {
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundTransparency = 1,
            LayoutOrder = 2,
        }, sliced110)
        testCode = slicedfn48("TEST CODE", row)
        testCode.Size = UDim2.new(0.4, -4, 1, 0)
        send = slicedfn49("SEND", row)
    end
    send.Size = UDim2.new(0.6, -4, 1, 0)
    send.Position = UDim2.new(0.4, 4, 0, 0)

    local status = slicedfn46("", 10, tbl21.sub, gothamMedium, Enum.TextXAlignment.Left, sliced110)
    status.Size = UDim2.new(1, -4, 0, 14)
    status.LayoutOrder = 3

    --     ":" �    
    local function doSend(rawArg)
        local text = slicedfn34(rawArg or "")
        if text == "" then
            status.Text = "nothing to send"
            status.TextColor3 = tbl21.err
            return
        end

        local payload = text

        if not (sliced94 and not flag22 and typeof(firesignal) == "function") then
            local ok = pcall(slicedfn30, payload, nil, nil, "Top", 2678001507)
            status.Text = ok and ("local test: " .. payload) or "handler error"
            status.TextColor3 = ok and tbl21.ok or tbl21.err
            return
        end

        local ok = pcall(firesignal, sliced94.OnClientEvent, payload, nil, nil, "Top", 2678001507)
        status.Text = ok and ("fired: " .. payload) or "firesignal failed"
        status.TextColor3 = ok and tbl21.ok or tbl21.err
    end

    send.MouseButton1Click:Connect(function()
        doSend(TextBox2.Text)
        TextBox2.Text = ""
        TextBox2:CaptureFocus()
    end)

    TextBox2.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            doSend(TextBox2.Text)
            TextBox2.Text = ""
            TextBox2:CaptureFocus()
        end
    end)

    testCode.MouseButton1Click:Connect(function()
        doSend("TESTCODE" .. tostring(math.random(1000, 9999)))
    end)

    --    Test   
    sliced97.MouseButton1Click:Connect(function()
        if sliced109.Visible then
            sliced109.Visible = false
            return
        end