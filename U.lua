--[[
  Moon Duels V3 – Pure GUI (Tabs Only)
  No mobile buttons, no combo bar, no lock/lagger UI.
  Just the main window with tabbed panels.
  All toggles update state and print; no actual cheats.
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

-- UI State
local State = {
	guiVisible = true,
	menuScale = 0.8,
	mbBtnSize = 64, -- kept but not used in this stripped version
	normalSpeed = 60,
	carrySpeed = 30,
	laggerSpeed = 13,
	laggerCarrySpeed = 13,
	speedType = "normal",
	laggerActive = false,
	autoBatToggled = false,
	autoSwingEnabled = true,
	aimbotSpeed = 56.5,
	autoPlayEnabled = false,
	autoPlaySide = "right",
	infJumpEnabled = false,
	infJumpMode = "manual",
	antiRagdollEnabled = false,
	fpsBoostEnabled = false,
	medusaCounterEnabled = false,
	animEnabled = false,
	unwalkEnabled = false,
	hitboxEnabled = false,
	autoTPDownEnabled = false,
	jumpThreshold = 2,
	hardHitEnabled = false,
	hardHitRadius = 10,
	batRadius = 20,
	antiLagEnabled = false,
	ultraModeEnabled = false,
	espEnabled = false,
	tracerEnabled = false,
	noCamCollisionEnabled = false,
	removeAccEnabled = false,
	darkModeEnabled = false,
}

-- Keybinds (for display only)
local Keys = {
	autoBat = Enum.KeyCode.E,
	speed = Enum.KeyCode.Q,
	lagger = Enum.KeyCode.C,
	guiHide = Enum.KeyCode.LeftControl,
	autoPlay = Enum.KeyCode.L,
	dropBrainrot = Enum.KeyCode.H,
	tpDown = Enum.KeyCode.T,
}

-- Placeholder for auto-steal (only progress bar UI removed)
local AutoSteal = { Enabled = false, Radius = 20, Duration = 1.3 }

-- User scripts for executor tab
local UserPanels = {}

-- Colors
local C_BG = Color3.fromRGB(8,8,8)
local C_PANEL = Color3.fromRGB(14,14,14)
local C_CARD = Color3.fromRGB(20,20,20)
local C_CARD_HOV = Color3.fromRGB(30,30,30)
local C_BORDER = Color3.fromRGB(48,48,48)
local C_BORDER2 = Color3.fromRGB(34,34,34)
local C_TEXT = Color3.fromRGB(235,235,235)
local C_TEXT_SUB = Color3.fromRGB(160,160,160)
local C_TEXT_DIM = Color3.fromRGB(80,80,80)
local C_HEADER = Color3.fromRGB(5,5,5)
local C_OFF_BG = Color3.fromRGB(20,20,20)
local C_KB_BG = Color3.fromRGB(14,14,14)
local C_INPUT_BG = Color3.fromRGB(14,14,14)
local C_TOGGLE_ON = Color3.fromRGB(50,200,80)
local C_SIDEBAR = Color3.fromRGB(10,10,10)
local C_TAB_ACT = Color3.fromRGB(55,55,55)
local C_TAB_IDL = Color3.fromRGB(17,17,17)
local C_WHITE = Color3.fromRGB(235,235,235)
local C_BTN_ON = Color3.fromRGB(235,235,235)
local C_BTN_ON_TEXT = Color3.fromRGB(8,8,8)

-- Config save (positions only)
local SAVE_FILE = "MoonDuelsV3_GUI.json"
local function u2t(u) return {xs=u.X.Scale, xo=u.X.Offset, ys=u.Y.Scale, yo=u.Y.Offset} end
local function t2u(t) return t and UDim2.new(t.xs or 0, t.xo or 0, t.ys or 0, t.yo or 0) end

local saveDebounce = false
local function autoSaveConfig()
	if saveDebounce then return end
	saveDebounce = true
	task.delay(0.5, function()
		local pos = {}
		if _mainFrame then pos.main = u2t(_mainFrame.Position) end
		if _miniFrame then pos.mini = u2t(_miniFrame.Position) end
		local panelsSave = {}
		for _,p in ipairs(UserPanels) do table.insert(panelsSave, {name=p.name, code=p.code}) end
		local cfg = {
			normalSpeed = State.normalSpeed, carrySpeed = State.carrySpeed,
			laggerSpeed = State.laggerSpeed, laggerCarrySpeed = State.laggerCarrySpeed,
			speedType = State.speedType, laggerActive = State.laggerActive,
			autoBatKey = Keys.autoBat.Name, speedKey = Keys.speed.Name, laggerKey = Keys.lagger.Name,
			autoStealEnabled = AutoSteal.Enabled, grabRadius = AutoSteal.Radius, stealDuration = AutoSteal.Duration,
			infJump = State.infJumpEnabled, infJumpMode = State.infJumpMode,
			antiRagdoll = State.antiRagdollEnabled, fpsBoost = State.fpsBoostEnabled,
			medusaCounter = State.medusaCounterEnabled,
			autoPlayKey = Keys.autoPlay.Name, guiHideKey = Keys.guiHide.Name,
			animEnabled = State.animEnabled, unwalkEnabled = State.unwalkEnabled, tpDownKey = Keys.tpDown.Name,
			hitboxEnabled = State.hitboxEnabled, darkModeEnabled = State.darkModeEnabled,
			removeAccEnabled = State.removeAccEnabled,
			menuScale = State.menuScale,
			autoPlaySide = State.autoPlaySide,
			aimbotSpeed = State.aimbotSpeed, autoSwingEnabled = State.autoSwingEnabled,
			panels = panelsSave, positions = pos,
			autoTPDownEnabled = State.autoTPDownEnabled, jumpThreshold = State.jumpThreshold,
			hardHitEnabled = State.hardHitEnabled, hardHitRadius = State.hardHitRadius,
			batRadius = State.batRadius,
			antiLagEnabled = State.antiLagEnabled, ultraModeEnabled = State.ultraModeEnabled,
			espEnabled = State.espEnabled, tracerEnabled = State.tracerEnabled,
			noCamCollisionEnabled = State.noCamCollisionEnabled,
			mbBtnSize = State.mbBtnSize,
		}
		pcall(function() if writefile then writefile(SAVE_FILE, HttpService:JSONEncode(cfg)) end end)
		saveDebounce = false
	end)
end

local _loadedConfig
pcall(function() _loadedConfig = (isfile and isfile(SAVE_FILE)) and HttpService:JSONDecode(readfile(SAVE_FILE)) or nil end)

-- Placeholder callbacks (print only)
local function toggleSpeedType() State.speedType = (State.speedType=="normal") and "carry" or "normal"; print("Speed mode:", State.speedType); autoSaveConfig() end
local function toggleLagger() State.laggerActive = not State.laggerActive; print("Lagger:", State.laggerActive); autoSaveConfig() end
local function tpToGround() print("TP Down") end
local function runDropBrainrot() print("Drop Brainrot") end

-- Build main GUI
local function buildGUI()
	local gui = Instance.new("ScreenGui")
	gui.Name = "MoonDuelsV3GUI"
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 200
	gui.IgnoreGuiInset = true
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
		gui.Parent = LP:WaitForChild("PlayerGui")
	end

	local W, H, SW, CORNER = 280, 460, 82, 12

	-- Draggable function
	local function makeDraggable(frame, handle)
		local src = handle or frame
		local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
		src.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = inp.Position
				startPos = frame.Position
				inp.Changed:Connect(function()
					if inp.UserInputState == Enum.UserInputState.End then dragging = false end
				end)
			end
		end)
		src.InputChanged:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
				dragInput = inp
			end
		end)
		UIS.InputChanged:Connect(function(inp)
			if inp == dragInput and dragging then
				local d = inp.Position - dragStart
				frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end)
		UIS.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end

	-- Main frame
	local main = Instance.new("Frame", gui)
	main.Name = "Main"
	main.Size = UDim2.new(0,W,0,H)
	main.Position = UDim2.new(0,12,0,12)
	main.BackgroundColor3 = C_BG
	main.BorderSizePixel = 0
	main.Active = true
	Instance.new("UICorner", main).CornerRadius = UDim.new(0,CORNER)
	local mainStroke = Instance.new("UIStroke", main)
	mainStroke.Color = C_BORDER
	mainStroke.Thickness = 1
	mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	_mainFrame = main
	makeDraggable(main)

	-- Mini frame (shown when minimized)
	local mini = Instance.new("TextButton", gui)
	mini.Name = "MoonMini"
	mini.Size = UDim2.new(0,150,0,32)
	mini.Position = UDim2.new(0,12,0,12)
	mini.BackgroundColor3 = C_PANEL
	mini.BorderSizePixel = 0
	mini.Text = "MOON DUELS V3"
	mini.TextColor3 = C_TEXT
	mini.Font = Enum.Font.GothamBlack
	mini.TextSize = 12
	mini.ZIndex = 20
	mini.Visible = false
	mini.AutoButtonColor = false
	Instance.new("UICorner", mini).CornerRadius = UDim.new(0,10)
	Instance.new("UIStroke", mini).Color = C_BORDER
	_miniFrame = mini
	makeDraggable(mini)

	local HEADER_H = 80
	local headerFrame = Instance.new("Frame", main)
	headerFrame.Size = UDim2.new(1,0,0,HEADER_H)
	headerFrame.BackgroundColor3 = C_HEADER
	headerFrame.BorderSizePixel = 0
	headerFrame.ZIndex = 3
	headerFrame.ClipsDescendants = true
	Instance.new("UICorner", headerFrame).CornerRadius = UDim.new(0,CORNER)
	local hPatch = Instance.new("Frame", headerFrame)
	hPatch.Size = UDim2.new(1,0,0,CORNER)
	hPatch.Position = UDim2.new(0,0,1,-CORNER)
	hPatch.BackgroundColor3 = C_HEADER
	hPatch.BorderSizePixel = 0
	hPatch.ZIndex = 2

	-- Avatar
	local avatarBg = Instance.new("Frame", headerFrame)
	avatarBg.Size = UDim2.new(0,46,0,46)
	avatarBg.Position = UDim2.new(0,20,0.5,-23)
	avatarBg.BackgroundColor3 = C_CARD
	avatarBg.BorderSizePixel = 0
	avatarBg.ZIndex = 4
	Instance.new("UICorner", avatarBg).CornerRadius = UDim.new(0,23)
	local avStroke = Instance.new("UIStroke", avatarBg)
	avStroke.Color = C_BORDER
	avStroke.Thickness = 1
	local avatarImg = Instance.new("ImageLabel", avatarBg)
	avatarImg.Size = UDim2.new(1,-4,1,-4)
	avatarImg.Position = UDim2.new(0,2,0,2)
	avatarImg.BackgroundTransparency = 1
	avatarImg.Image = ""
	avatarImg.ZIndex = 5
	Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(0,22)
	task.spawn(function()
		pcall(function()
			avatarImg.Image = Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		end)
	end)

	local usernameLbl = Instance.new("TextLabel", headerFrame)
	usernameLbl.Size = UDim2.new(1,-120,0,22)
	usernameLbl.Position = UDim2.new(0,76,0,12)
	usernameLbl.BackgroundTransparency = 1
	usernameLbl.Text = LP.DisplayName
	usernameLbl.TextColor3 = C_TEXT
	usernameLbl.Font = Enum.Font.GothamBlack
	usernameLbl.TextSize = 15
	usernameLbl.TextXAlignment = Enum.TextXAlignment.Left
	usernameLbl.ZIndex = 4

	local handleLbl = Instance.new("TextLabel", headerFrame)
	handleLbl.Size = UDim2.new(1,-120,0,14)
	handleLbl.Position = UDim2.new(0,76,0,36)
	handleLbl.BackgroundTransparency = 1
	handleLbl.Text = "@"..LP.Name
	handleLbl.TextColor3 = C_TEXT_DIM
	handleLbl.Font = Enum.Font.Gotham
	handleLbl.TextSize = 10
	handleLbl.TextXAlignment = Enum.TextXAlignment.Left
	handleLbl.ZIndex = 4

	-- Minimize button
	local minBtn = Instance.new("TextButton", headerFrame)
	minBtn.Size = UDim2.new(0,26,0,26)
	minBtn.Position = UDim2.new(1,-38,0,10)
	minBtn.BackgroundColor3 = C_CARD
	minBtn.BorderSizePixel = 0
	minBtn.Text = "--"
	minBtn.TextColor3 = C_TEXT_SUB
	minBtn.Font = Enum.Font.GothamBold
	minBtn.TextSize = 13
	minBtn.ZIndex = 5
	Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,6)
	Instance.new("UIStroke", minBtn).Color = C_BORDER

	local headerDiv = Instance.new("Frame", main)
	headerDiv.Size = UDim2.new(1,0,0,1)
	headerDiv.Position = UDim2.new(0,0,0,HEADER_H)
	headerDiv.BackgroundColor3 = C_BORDER
	headerDiv.BorderSizePixel = 0
	headerDiv.ZIndex = 3

	-- Sidebar
	local SIDEBAR_Y = HEADER_H + 1
	local sidebar = Instance.new("Frame", main)
	sidebar.Size = UDim2.new(0,SW,1,-SIDEBAR_Y-CORNER)
	sidebar.Position = UDim2.new(0,0,0,SIDEBAR_Y)
	sidebar.BackgroundColor3 = C_SIDEBAR
	sidebar.BorderSizePixel = 0
	sidebar.ZIndex = 5
	local sideBottomPatch = Instance.new("Frame", main)
	sideBottomPatch.Size = UDim2.new(0,SW,0,CORNER)
	sideBottomPatch.Position = UDim2.new(0,0,1,-CORNER)
	sideBottomPatch.BackgroundColor3 = C_SIDEBAR
	sideBottomPatch.BorderSizePixel = 0
	sideBottomPatch.ZIndex = 4
	local sideDiv = Instance.new("Frame", sidebar)
	sideDiv.Size = UDim2.new(0,1,1,0)
	sideDiv.Position = UDim2.new(1,-1,0,0)
	sideDiv.BackgroundColor3 = C_BORDER
	sideDiv.BorderSizePixel = 0
	sideDiv.ZIndex = 6

	local content = Instance.new("Frame", main)
	content.Name = "ContentArea"
	content.Size = UDim2.new(1,-SW-1,1,-SIDEBAR_Y-CORNER)
	content.Position = UDim2.new(0,SW+1,0,SIDEBAR_Y)
	content.BackgroundColor3 = C_BG
	content.BorderSizePixel = 0
	content.ClipsDescendants = true
	content.ZIndex = 2

	local guiVisible = true
	local function showGui() main.Visible = true mini.Visible = false guiVisible = true end
	local function hideGui() main.Visible = false mini.Visible = true guiVisible = false end
	minBtn.MouseButton1Click:Connect(hideGui)
	mini.MouseButton1Click:Connect(showGui)

	-- Tabs
	local tabDefs = {
		{name="Speed"}, {name="Aimbot"}, {name="Mechanics"},
		{name="Movement"}, {name="Visual"}, {name="Songs"},
		{name="Keybinds"}, {name="Settings"}, {name="Executor"}
	}
	local tabs, tabPages, activeTabName = {}, {}, nil
	local pageLOs = {}

	local tabListFrame = Instance.new("Frame", sidebar)
	tabListFrame.Size = UDim2.new(1,0,1,0)
	tabListFrame.BackgroundTransparency = 1
	tabListFrame.BorderSizePixel = 0
	tabListFrame.ZIndex = 6
	local tabLL = Instance.new("UIListLayout", tabListFrame)
	tabLL.SortOrder = Enum.SortOrder.LayoutOrder
	tabLL.Padding = UDim.new(0,2)
	local tabPad = Instance.new("UIPadding", tabListFrame)
	tabPad.PaddingTop = UDim.new(0,8)
	tabPad.PaddingLeft = UDim.new(0,5)
	tabPad.PaddingRight = UDim.new(0,5)

	local function switchTab(name)
		activeTabName = name
		for _, td in ipairs(tabDefs) do
			local t = tabs[td.name]
			local isA = td.name == name
			TweenService:Create(t.frame, TweenInfo.new(0.14), {BackgroundColor3 = isA and C_TAB_ACT or C_TAB_IDL}):Play()
			TweenService:Create(t.lbl, TweenInfo.new(0.14), {TextColor3 = isA and C_TEXT or C_TEXT_DIM}):Play()
			TweenService:Create(t.pip, TweenInfo.new(0.14), {BackgroundTransparency = isA and 0 or 1}):Play()
			tabPages[td.name].Visible = isA
		end
	end

	for i, td in ipairs(tabDefs) do
		local btn = Instance.new("TextButton", tabListFrame)
		btn.Size = UDim2.new(1,0,0,27)
		btn.BackgroundColor3 = C_TAB_IDL
		btn.BorderSizePixel = 0
		btn.Text = ""
		btn.LayoutOrder = i
		btn.ZIndex = 7
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)
		local pip = Instance.new("Frame", btn)
		pip.Size = UDim2.new(0,2,0,14)
		pip.Position = UDim2.new(0,2,0.5,-7)
		pip.BackgroundColor3 = Color3.fromRGB(180,200,255)
		pip.BorderSizePixel = 0
		pip.BackgroundTransparency = 1
		pip.ZIndex = 10
		Instance.new("UICorner", pip).CornerRadius = UDim.new(1,0)
		local lbl = Instance.new("TextLabel", btn)
		lbl.Size = UDim2.new(1,0,1,0)
		lbl.BackgroundTransparency = 1
		lbl.TextColor3 = C_TEXT_DIM
		lbl.Font = Enum.Font.GothamBold
		lbl.TextSize = 7
		lbl.TextXAlignment = Enum.TextXAlignment.Center
		lbl.TextWrapped = true
		lbl.ZIndex = 9
		lbl.Text = td.name
		tabs[td.name] = {frame = btn, lbl = lbl, pip = pip}

		local page = Instance.new("ScrollingFrame", content)
		page.Size = UDim2.new(1,0,1,0)
		page.BackgroundColor3 = C_BG
		page.BackgroundTransparency = 0
		page.BorderSizePixel = 0
		page.ScrollBarThickness = 2
		page.ScrollBarImageColor3 = C_BORDER
		page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		page.CanvasSize = UDim2.new(0,0,0,0)
		page.ScrollingEnabled = true
		page.ScrollingDirection = Enum.ScrollingDirection.Y
		page.Visible = false
		page.ZIndex = 3
		local pll = Instance.new("UIListLayout", page)
		pll.SortOrder = Enum.SortOrder.LayoutOrder
		pll.Padding = UDim.new(0,3)
		local pp = Instance.new("UIPadding", page)
		pp.PaddingLeft = UDim.new(0,6)
		pp.PaddingRight = UDim.new(0,6)
		pp.PaddingTop = UDim.new(0,8)
		pp.PaddingBottom = UDim.new(0,8)
		tabPages[td.name] = page
		pageLOs[td.name] = 0

		btn.MouseButton1Click:Connect(function() switchTab(td.name) end)
		btn.MouseEnter:Connect(function()
			if activeTabName ~= td.name then
				TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = C_CARD_HOV}):Play()
			end
		end)
		btn.MouseLeave:Connect(function()
			if activeTabName ~= td.name then
				TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = C_TAB_IDL}):Play()
			end
		end)
	end

	local function lo(t) pageLOs[t] = pageLOs[t] + 1 return pageLOs[t] end
	local function pg(t) return tabPages[t] end

	local function makeSecHeader(tabName, text)
		local f = Instance.new("Frame", pg(tabName))
		f.Size = UDim2.new(1,0,0,18)
		f.BackgroundTransparency = 1
		f.BorderSizePixel = 0
		f.LayoutOrder = lo(tabName)
		f.ZIndex = 4
		local lbl = Instance.new("TextLabel", f)
		lbl.Size = UDim2.new(1,0,1,0)
		lbl.BackgroundTransparency = 1
		lbl.TextColor3 = C_TEXT_DIM
		lbl.Font = Enum.Font.GothamBold
		lbl.TextSize = 8
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.ZIndex = 5
		lbl.Text = text:upper()
		local secBar = Instance.new("Frame", f)
		secBar.Size = UDim2.new(0,2,0,12)
		secBar.Position = UDim2.new(0,2,0.5,-6)
		secBar.BackgroundColor3 = Color3.fromRGB(150,160,220)
		secBar.BorderSizePixel = 0
		secBar.ZIndex = 6
		Instance.new("UICorner", secBar).CornerRadius = UDim.new(1,0)
	end

	local function baseCard(tabName, h2)
		local c = Instance.new("Frame", pg(tabName))
		c.Size = UDim2.new(1,0,0,h2 or 34)
		c.BackgroundColor3 = C_CARD
		c.BorderSizePixel = 0
		c.LayoutOrder = lo(tabName)
		c.ZIndex = 4
		Instance.new("UICorner", c).CornerRadius = UDim.new(0,7)
		local s = Instance.new("UIStroke", c)
		s.Color = C_BORDER2
		s.Thickness = 1
		c.MouseEnter:Connect(function()
			TweenService:Create(c, TweenInfo.new(0.1), {BackgroundColor3 = C_CARD_HOV}):Play()
			TweenService:Create(s, TweenInfo.new(0.1), {Color = Color3.fromRGB(60,60,90)}):Play()
		end)
		c.MouseLeave:Connect(function()
			TweenService:Create(c, TweenInfo.new(0.1), {BackgroundColor3 = C_CARD}):Play()
			TweenService:Create(s, TweenInfo.new(0.1), {Color = C_BORDER2}):Play()
		end)
		return c
	end

	local function cLabel(p, text, x, w, sz, col, font, xa)
		local l = Instance.new("TextLabel", p)
		l.Size = UDim2.new(0, w or 140, 1, 0)
		l.Position = UDim2.new(0, x or 10, 0, 0)
		l.BackgroundTransparency = 1
		l.TextColor3 = col or C_TEXT
		l.Font = font or Enum.Font.GothamBold
		l.TextSize = sz or 10
		l.TextXAlignment = xa or Enum.TextXAlignment.Left
		l.ZIndex = 10
		l.Text = text
		return l
	end

	local function makePillToggle(parent, defOn, onToggle)
		local PW, PH = 38, 20
		local pbg = Instance.new("Frame", parent)
		pbg.Size = UDim2.new(0,PW,0,PH)
		pbg.Position = UDim2.new(1,-(PW+8),0.5,-PH/2)
		pbg.BackgroundColor3 = defOn and C_TOGGLE_ON or C_OFF_BG
		pbg.BorderSizePixel = 0
		pbg.ZIndex = 8
		Instance.new("UICorner", pbg).CornerRadius = UDim.new(0,10)
		local ps = Instance.new("UIStroke", pbg)
		ps.Color = defOn and C_TOGGLE_ON or C_BORDER
		ps.Thickness = 1.5
		ps.Transparency = defOn and 0 or 1
		local dot = Instance.new("Frame", pbg)
		dot.Size = UDim2.new(0,14,0,14)
		dot.Position = defOn and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
		dot.BackgroundColor3 = defOn and C_WHITE or C_TEXT_DIM
		dot.BorderSizePixel = 0
		dot.ZIndex = 9
		Instance.new("UICorner", dot).CornerRadius = UDim.new(0,4)
		local isOn = defOn or false
		local function setV(on)
			isOn = on
			TweenService:Create(pbg, TweenInfo.new(0.18), {BackgroundColor3 = on and C_TOGGLE_ON or C_OFF_BG}):Play()
			TweenService:Create(ps, TweenInfo.new(0.18), {Color = on and C_TOGGLE_ON or C_BORDER, Transparency = on and 0 or 1}):Play()
			TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {Position = on and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7), BackgroundColor3 = on and C_WHITE or C_TEXT_DIM}):Play()
		end
		local clk = Instance.new("TextButton", parent)
		clk.Size = UDim2.new(1,0,1,0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 6
		clk.MouseButton1Click:Connect(function()
			if _anyKeyListening then return end
			isOn = not isOn
			setV(isOn)
			if onToggle then pcall(onToggle, isOn) end
		end)
		return setV
	end

	local _anyKeyListening = false
	local function makeKeyBtn(parent, getKey, onChanged)
		local b = Instance.new("TextButton", parent)
		b.Size = UDim2.new(0,40,0,18)
		b.BackgroundColor3 = C_KB_BG
		b.BorderSizePixel = 0
		b.Text = getKey().Name
		b.TextColor3 = C_TEXT_SUB
		b.Font = Enum.Font.GothamBold
		b.TextSize = 7
		b.ZIndex = 11
		Instance.new("UICorner", b).CornerRadius = UDim.new(0,5)
		local bs = Instance.new("UIStroke", b)
		bs.Color = C_BORDER
		bs.Thickness = 1
		local li, lc, pv = false, nil, b.Text
		b.MouseButton1Click:Connect(function()
			if li then
				li = false; _anyKeyListening = false
				if lc then lc:Disconnect() lc = nil end
				b.Text = pv; b.TextColor3 = C_TEXT_SUB
				TweenService:Create(bs, TweenInfo.new(0.1), {Color = C_BORDER}):Play()
				return
			end
			pv = b.Text; li = true; _anyKeyListening = true
			b.Text = "---"; b.TextColor3 = C_TEXT_DIM
			TweenService:Create(bs, TweenInfo.new(0.1), {Color = C_BORDER2}):Play()
			lc = UIS.InputBegan:Connect(function(inp)
				if not li then return end
				if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
				if inp.KeyCode == Enum.KeyCode.Escape then
					li = false; _anyKeyListening = false
					if lc then lc:Disconnect() lc = nil end
					b.Text = pv; b.TextColor3 = C_TEXT_SUB
					TweenService:Create(bs, TweenInfo.new(0.1), {Color = C_BORDER}):Play()
					return
				end
				if onChanged then onChanged(inp.KeyCode) end
				b.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name
				b.TextColor3 = C_TEXT_SUB
				li = false; _anyKeyListening = false
				if lc then lc:Disconnect() lc = nil end
				TweenService:Create(bs, TweenInfo.new(0.1), {Color = C_BORDER}):Play()
			end)
		end)
		return b
	end

	local function rowToggle(tabName, labelKey, defOn, onToggle)
		local c = baseCard(tabName, 34)
		cLabel(c, labelKey, 8, 150, 10, C_TEXT, Enum.Font.GothamBold)
		return makePillToggle(c, defOn, onToggle)
	end

	local function rowKBOnly(tabName, labelKey, getKey, onKeyChange)
		local c = baseCard(tabName, 34)
		cLabel(c, labelKey, 8, 150, 10, C_TEXT, Enum.Font.GothamBold)
		local kb = makeKeyBtn(c, getKey, function(k) if onKeyChange then onKeyChange(k) end end)
		kb.Position = UDim2.new(1,-(40+8),0.5,-9)
		return kb
	end

	local function rowInput(tabName, labelKey, default, onChange)
		local c = baseCard(tabName, 34)
		cLabel(c, labelKey, 8, 120, 10, C_TEXT, Enum.Font.GothamBold)
		local box = Instance.new("TextBox", c)
		box.Size = UDim2.new(0,58,0,22)
		box.Position = UDim2.new(1,-66,0.5,-11)
		box.BackgroundColor3 = C_INPUT_BG
		box.BorderSizePixel = 0
		box.Text = tostring(default)
		box.TextColor3 = C_TEXT
		box.Font = Enum.Font.GothamBold
		box.TextSize = 10
		box.ClearTextOnFocus = false
		box.ZIndex = 11
		Instance.new("UICorner", box).CornerRadius = UDim.new(0,5)
		local bs = Instance.new("UIStroke", box)
		bs.Color = C_BORDER
		bs.Thickness = 1
		box.Focused:Connect(function()
			TweenService:Create(bs, TweenInfo.new(0.1), {Color = Color3.fromRGB(100,110,180), Thickness = 1.5}):Play()
		end)
		box.FocusLost:Connect(function()
			TweenService:Create(bs, TweenInfo.new(0.1), {Color = C_BORDER, Thickness = 1}):Play()
			if onChange then
				local n = tonumber(box.Text)
				if n then onChange(n) else box.Text = tostring(default) end
			end
		end)
		return box
	end

	local function rowActionBtn(tabName, labelKey, onClick)
		local b = Instance.new("TextButton", pg(tabName))
		b.Size = UDim2.new(1,0,0,38)
		b.BackgroundColor3 = C_PANEL
		b.BorderSizePixel = 0
		b.TextColor3 = C_TEXT
		b.Font = Enum.Font.GothamBlack
		b.TextSize = 11
		b.LayoutOrder = lo(tabName)
		b.ZIndex = 5
		b.Text = labelKey
		Instance.new("UICorner", b).CornerRadius = UDim.new(0,9)
		local bs = Instance.new("UIStroke", b)
		bs.Color = C_BORDER
		bs.Thickness = 1
		b.MouseButton1Click:Connect(function()
			TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3 = C_CARD_HOV}):Play()
			task.delay(0.15, function()
				TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = C_PANEL}):Play()
			end)
			if onClick then pcall(onClick) end
		end)
		b.MouseEnter:Connect(function()
			TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = C_CARD}):Play()
		end)
		b.MouseLeave:Connect(function()
			TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = C_PANEL}):Play()
		end)
		return b
	end

	-- Speed Tab
	makeSecHeader("Speed", "Speed Config")
	local normalBox = rowInput("Speed", "Normal", State.normalSpeed, function(v) if v>0 and v<=500 then State.normalSpeed=v end; autoSaveConfig() end)
	local carryBox = rowInput("Speed", "Carry Speed", State.carrySpeed, function(v) if v>0 and v<=500 then State.carrySpeed=v end; autoSaveConfig() end)
	local laggerBox = rowInput("Speed", "Lagger Normal", State.laggerSpeed, function(v) if v>0 and v<=500 then State.laggerSpeed=v end; autoSaveConfig() end)
	local carryLaggerBox = rowInput("Speed", "Lagger Carry", State.laggerCarrySpeed, function(v) if v>0 and v<=500 then State.laggerCarrySpeed=v end; autoSaveConfig() end)

	-- Mode selector
	do
		local c = baseCard("Speed", 34)
		cLabel(c, "Mode", 8, 70, 10, C_TEXT, Enum.Font.GothamBold)
		local modeValLbl = Instance.new("TextLabel", c)
		modeValLbl.Size = UDim2.new(0,80,1,0)
		modeValLbl.Position = UDim2.new(0,80,0,0)
		modeValLbl.BackgroundTransparency = 1
		modeValLbl.Text = "Normal"
		modeValLbl.TextColor3 = C_DIM
		modeValLbl.Font = Enum.Font.GothamBold
		modeValLbl.TextSize = 9
		modeValLbl.TextXAlignment = Enum.TextXAlignment.Left
		modeValLbl.ZIndex = 10
		local clk = Instance.new("TextButton", c)
		clk.Size = UDim2.new(0.7,0,1,0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 6
		clk.MouseButton1Click:Connect(function()
			if _anyKeyListening then return end
			toggleSpeedType()
			modeValLbl.Text = (State.speedType=="normal") and "Normal" or "Carry"
		end)
	end

	rowToggle("Speed", "Speed Toggle", false, function() toggleSpeedType() end)
	rowToggle("Speed", "Lagger Mode", false, function() toggleLagger() end)

	-- Aimbot Tab
	makeSecHeader("Aimbot", "Face Tracking")
	rowToggle("Aimbot", "Auto Bat", false, function(on) State.autoBatToggled = on; print("Auto Bat:", on); autoSaveConfig() end)
	rowToggle("Aimbot", "Auto Swing", State.autoSwingEnabled, function(on) State.autoSwingEnabled = on; autoSaveConfig() end)
	rowInput("Aimbot", "Bat Speed", State.aimbotSpeed, function(v) if v>0 and v<=500 then State.aimbotSpeed=v end; autoSaveConfig() end)
	rowInput("Aimbot", "Engage Range", 5, function(v) if v>=1 and v<=50 then end; autoSaveConfig() end)
	makeSecHeader("Aimbot", "Aim Bypass")
	rowToggle("Aimbot", "Aim Bat Bypass", false, function(on) print("Aim Bypass:", on); autoSaveConfig() end)
	rowKBOnly("Aimbot", "Keybind", function() return Keys.autoBat end, function(k) Keys.autoBat=k; autoSaveConfig() end)

	-- Mechanics Tab
	makeSecHeader("Mechanics", "Auto Steal")
	rowToggle("Mechanics", "Auto Grab", false, function(on) AutoSteal.Enabled = on; print("Auto Steal:", on); autoSaveConfig() end)
	rowInput("Mechanics", "Duration", AutoSteal.Duration, function(v) if v>0 and v<=60 then AutoSteal.Duration=v end; autoSaveConfig() end)
	rowInput("Mechanics", "Radius", AutoSteal.Radius, function(v) if v>=1 and v<=300 then AutoSteal.Radius=math.floor(v) end; autoSaveConfig() end)
	makeSecHeader("Mechanics", "Toggles")
	rowToggle("Mechanics", "Inf Jump", false, function(on) State.infJumpEnabled = on; print("Inf Jump:", on); autoSaveConfig() end)
	-- Inf Jump Mode selector
	do
		local c = baseCard("Mechanics", 34)
		cLabel(c, "Inf Jump Mode", 8, 90, 10, C_TEXT, Enum.Font.GothamBold)
		local BW, BH, GAP = 50, 20, 4
		local manBtn = Instance.new("TextButton", c)
		manBtn.Size = UDim2.new(0,BW,0,BH)
		manBtn.Position = UDim2.new(1,-(BW*2+GAP+8),0.5,-BH/2)
		manBtn.BackgroundColor3 = State.infJumpMode=="manual" and C_BTN_ON or C_OFF_BG
		manBtn.BorderSizePixel = 0
		manBtn.Text = "Manual"
		manBtn.TextColor3 = State.infJumpMode=="manual" and C_BTN_ON_TEXT or C_TEXT_DIM
		manBtn.Font = Enum.Font.GothamBold
		manBtn.TextSize = 8
		manBtn.ZIndex = 11
		manBtn.AutoButtonColor = false
		Instance.new("UICorner", manBtn).CornerRadius = UDim.new(0,5)
		Instance.new("UIStroke", manBtn).Color = C_BORDER
		local holdBtn = Instance.new("TextButton", c)
		holdBtn.Size = UDim2.new(0,BW,0,BH)
		holdBtn.Position = UDim2.new(1,-(BW+8),0.5,-BH/2)
		holdBtn.BackgroundColor3 = State.infJumpMode=="hold" and C_BTN_ON or C_OFF_BG
		holdBtn.BorderSizePixel = 0
		holdBtn.Text = "Hold"
		holdBtn.TextColor3 = State.infJumpMode=="hold" and C_BTN_ON_TEXT or C_TEXT_DIM
		holdBtn.Font = Enum.Font.GothamBold
		holdBtn.TextSize = 8
		holdBtn.ZIndex = 11
		holdBtn.AutoButtonColor = false
		Instance.new("UICorner", holdBtn).CornerRadius = UDim.new(0,5)
		Instance.new("UIStroke", holdBtn).Color = C_BORDER
		local function updateInfJumpModeUI()
			TweenService:Create(manBtn, TweenInfo.new(0.15), {BackgroundColor3 = State.infJumpMode=="manual" and C_BTN_ON or C_OFF_BG, TextColor3 = State.infJumpMode=="manual" and C_BTN_ON_TEXT or C_TEXT_DIM}):Play()
			TweenService:Create(holdBtn, TweenInfo.new(0.15), {BackgroundColor3 = State.infJumpMode=="hold" and C_BTN_ON or C_OFF_BG, TextColor3 = State.infJumpMode=="hold" and C_BTN_ON_TEXT or C_TEXT_DIM}):Play()
		end
		manBtn.MouseButton1Click:Connect(function() State.infJumpMode = "manual"; updateInfJumpModeUI(); autoSaveConfig() end)
		holdBtn.MouseButton1Click:Connect(function() State.infJumpMode = "hold"; updateInfJumpModeUI(); autoSaveConfig() end)
	end
	rowToggle("Mechanics", "Anti Ragdoll", false, function(on) State.antiRagdollEnabled = on; print("Anti Ragdoll:", on); autoSaveConfig() end)
	rowToggle("Mechanics", "FPS Boost", false, function(on) State.fpsBoostEnabled = on; print("FPS Boost:", on); autoSaveConfig() end)
	rowToggle("Mechanics", "Medusa", false, function(on) State.medusaCounterEnabled = on; print("Medusa:", on); autoSaveConfig() end)
	rowToggle("Mechanics", "T-Hard Anim", false, function(on) State.animEnabled = on; print("Anim Toggle:", on); autoSaveConfig() end)
	rowToggle("Mechanics", "Unwalk", false, function(on) State.unwalkEnabled = on; print("Unwalk:", on); autoSaveConfig() end)
	rowToggle("Mechanics", "Hitbox ESP", false, function(on) State.hitboxEnabled = on; print("Hitbox ESP:", on); autoSaveConfig() end)
	makeSecHeader("Mechanics", "Hard Hit")
	rowToggle("Mechanics", "Hard Hit", false, function(on) State.hardHitEnabled = on; print("Hard Hit:", on); autoSaveConfig() end)
	rowInput("Mechanics", "Hard Hit Radius", State.hardHitRadius, function(v) if v>=1 and v<=100 then State.hardHitRadius=v end; autoSaveConfig() end)
	rowInput("Mechanics", "Bat Radius", State.batRadius, function(v) if v>=1 and v<=200 then State.batRadius=v end; autoSaveConfig() end)

	-- Movement Tab
	makeSecHeader("Movement", "Auto Play")
	rowToggle("Movement", "Auto Play", false, function(on) State.autoPlayEnabled = on; print("Auto Play:", on); autoSaveConfig() end)
	do
		local c = baseCard("Movement", 34)
		cLabel(c, "Side", 8, 70, 10, C_TEXT, Enum.Font.GothamBold)
		local sideValLbl = cLabel(c, State.autoPlaySide=="right" and "Right" or "Left", 80, 70, 9, C_DIM, Enum.Font.GothamBold, Enum.TextXAlignment.Left)
		local clk = Instance.new("TextButton", c)
		clk.Size = UDim2.new(0.7,0,1,0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 6
		clk.MouseButton1Click:Connect(function()
			if _anyKeyListening then return end
			State.autoPlaySide = State.autoPlaySide=="right" and "left" or "right"
			sideValLbl.Text = State.autoPlaySide=="right" and "Right" or "Left"
			autoSaveConfig()
		end)
	end
	rowKBOnly("Movement", "Keybind", function() return Keys.autoPlay end, function(k) Keys.autoPlay=k; autoSaveConfig() end)
	makeSecHeader("Movement", "TP Down")
	local tpDownCard = baseCard("Movement", 34)
	cLabel(tpDownCard, "TP Down", 8, 150, 10, C_TEXT, Enum.Font.GothamBold)
	local kb = makeKeyBtn(tpDownCard, function() return Keys.tpDown end, function(k) Keys.tpDown=k; autoSaveConfig() end)
	kb.Position = UDim2.new(1,-(40+8),0.5,-9)
	makeSecHeader("Movement", "Auto TP Down")
	rowToggle("Movement", "Auto TP Down", false, function(on)
		State.autoTPDownEnabled = on
		print("Auto TP Down:", on)
		if on then tpDownCard.Visible = false else tpDownCard.Visible = true end
		autoSaveConfig()
	end)
	rowInput("Movement", "Jumps before TP", State.jumpThreshold, function(v) if v>=1 and v<=20 then State.jumpThreshold=math.floor(v) end; autoSaveConfig() end)
	rowKBOnly("Movement", "Drop Brainrot", function() return Keys.dropBrainrot end, function(k) Keys.dropBrainrot=k; autoSaveConfig() end)

	-- Visual Tab
	makeSecHeader("Visual", "Visual")
	rowToggle("Visual", "Hitbox + Distance", false, function(on) State.hitboxEnabled = on; print("Hitbox Dist:", on); autoSaveConfig() end)
	rowToggle("Visual", "Dark Mode", false, function(on) State.darkModeEnabled = on; print("Dark Mode:", on); autoSaveConfig() end)
	rowToggle("Visual", "Rm. Accessories", false, function(on) State.removeAccEnabled = on; print("Remove Accs:", on); autoSaveConfig() end)
	makeSecHeader("Visual", "ESP")
	rowToggle("Visual", "ESP (B&W)", false, function(on) State.espEnabled = on; print("ESP:", on); autoSaveConfig() end)
	rowToggle("Visual", "Tracer Lines", false, function(on) State.tracerEnabled = on; print("Tracer:", on); autoSaveConfig() end)
	makeSecHeader("Visual", "No Cam Collision")
	rowToggle("Visual", "No Cam Collision", false, function(on) State.noCamCollisionEnabled = on; print("No Cam:", on); autoSaveConfig() end)
	makeSecHeader("Visual", "Anti Lag")
	rowToggle("Visual", "Anti Lag", false, function(on) State.antiLagEnabled = on; print("Anti Lag:", on); autoSaveConfig() end)
	rowToggle("Visual", "Ultra Mode", false, function(on) State.ultraModeEnabled = on; print("Ultra Mode:", on); autoSaveConfig() end)

	-- Songs Tab (placeholder)
	makeSecHeader("Songs", "Now Playing")
	rowToggle("Songs", "Song 1", false, function(on) print("Song 1:", on) end)
	rowToggle("Songs", "Song 2", false, function(on) print("Song 2:", on) end)
	rowActionBtn("Songs", "STOP MUSIC", function() print("Stop music") end)

	-- Keybinds Tab
	makeSecHeader("Keybinds", "Edit Binds")
	rowKBOnly("Keybinds", "Auto Bat", function() return Keys.autoBat end, function(k) Keys.autoBat=k; autoSaveConfig() end)
	rowKBOnly("Keybinds", "Speed Toggle", function() return Keys.speed end, function(k) Keys.speed=k; autoSaveConfig() end)
	rowKBOnly("Keybinds", "Lagger Mode", function() return Keys.lagger end, function(k) Keys.lagger=k; autoSaveConfig() end)
	rowKBOnly("Keybinds", "Auto Play", function() return Keys.autoPlay end, function(k) Keys.autoPlay=k; autoSaveConfig() end)
	rowKBOnly("Keybinds", "Drop Brainrot", function() return Keys.dropBrainrot end, function(k) Keys.dropBrainrot=k; autoSaveConfig() end)
	rowKBOnly("Keybinds", "TP Down", function() return Keys.tpDown end, function(k) Keys.tpDown=k; autoSaveConfig() end)
	rowKBOnly("Keybinds", "Hide GUI", function() return Keys.guiHide end, function(k) Keys.guiHide=k; autoSaveConfig() end)

	-- Settings Tab
	makeSecHeader("Settings", "Interface")
	rowKBOnly("Settings", "Hide GUI", function() return Keys.guiHide end, function(k) Keys.guiHide=k; autoSaveConfig() end)
	makeSecHeader("Settings", "Menu Size")
	do
		local scaleCard = baseCard("Settings", 50)
		cLabel(scaleCard, "Scale", 8, 60, 10, C_TEXT, Enum.Font.GothamBold)
		local scaleValLbl = Instance.new("TextLabel", scaleCard)
		scaleValLbl.Size = UDim2.new(0,36,0,16)
		scaleValLbl.Position = UDim2.new(1,-42,0,6)
		scaleValLbl.BackgroundTransparency = 1
		scaleValLbl.Text = string.format("%.1f", State.menuScale)
		scaleValLbl.TextColor3 = C_TEXT_SUB
		scaleValLbl.Font = Enum.Font.GothamBold
		scaleValLbl.TextSize = 10
		scaleValLbl.TextXAlignment = Enum.TextXAlignment.Right
		scaleValLbl.ZIndex = 10
		local slTrack = Instance.new("Frame", scaleCard)
		slTrack.Size = UDim2.new(1,-16,0,5)
		slTrack.Position = UDim2.new(0,8,1,-14)
		slTrack.BackgroundColor3 = C_CARD_HOV
		slTrack.BorderSizePixel = 0
		Instance.new("UICorner", slTrack).CornerRadius = UDim.new(1,0)
		local slFill = Instance.new("Frame", slTrack)
		slFill.BackgroundColor3 = C_TEXT
		slFill.BorderSizePixel = 0
		Instance.new("UICorner", slFill).CornerRadius = UDim.new(1,0)
		local slKnob = Instance.new("TextButton", slTrack)
		slKnob.Size = UDim2.new(0,12,0,12)
		slKnob.BackgroundColor3 = C_WHITE
		slKnob.Text = ""
		slKnob.AutoButtonColor = false
		slKnob.BorderSizePixel = 0
		slKnob.ZIndex = 6
		Instance.new("UICorner", slKnob).CornerRadius = UDim.new(1,0)
		local MIN_S, MAX_S = 0.8, 1.8
		local function applyScale(rel)
			rel = math.clamp(rel,0,1)
			local s = MIN_S + rel * (MAX_S - MIN_S)
			s = math.floor(s*10+0.5)/10
			slFill.Size = UDim2.new(rel,0,1,0)
			slKnob.Position = UDim2.new(rel,-6,0.5,-6)
			scaleValLbl.Text = string.format("%.1f", s)
			State.menuScale = s
			main.Size = UDim2.new(0, math.floor(W*s), 0, math.floor(H*s))
			autoSaveConfig()
		end
		local initRel = math.clamp((State.menuScale-MIN_S)/(MAX_S-MIN_S),0,1)
		slFill.Size = UDim2.new(initRel,0,1,0)
		slKnob.Position = UDim2.new(initRel,-6,0.5,-6)
		main.Size = UDim2.new(0, math.floor(W*State.menuScale), 0, math.floor(H*State.menuScale))
		local slDragging = false
		slKnob.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				slDragging = true
			end
		end)
		UIS.InputChanged:Connect(function(i)
			if slDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				local ap = slTrack.AbsolutePosition
				local as = slTrack.AbsoluteSize
				applyScale((i.Position.X - ap.X) / as.X)
			end
		end)
		UIS.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				slDragging = false
			end
		end)
		slTrack.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				local ap = slTrack.AbsolutePosition
				local as = slTrack.AbsoluteSize
				applyScale((i.Position.X - ap.X) / as.X)
			end
		end)
	end

	local sb; sb = rowActionBtn("Settings", "Save Config", function() autoSaveConfig(); if sb then sb.Text = "✓"; task.delay(1.5, function() if sb then sb.Text = "Save Config" end end) end end)
	rowActionBtn("Settings", "Reset Pos", function()
		main.Position = UDim2.new(0,12,0,12)
		mini.Position = UDim2.new(0,12,0,12)
		autoSaveConfig()
	end)

	-- Executor Tab
	makeSecHeader("Executor", "My Scripts")
	local function createPanelBtn(panelData, idx)
		local card = Instance.new("Frame", pg("Executor"))
		card.Size = UDim2.new(1,0,0,76)
		card.BackgroundColor3 = C_CARD
		card.BorderSizePixel = 0
		card.LayoutOrder = lo("Executor")
		card.ZIndex = 4
		Instance.new("UICorner", card).CornerRadius = UDim.new(0,7)
		Instance.new("UIStroke", card).Color = C_BORDER2
		local nameLbl = Instance.new("TextLabel", card)
		nameLbl.Size = UDim2.new(1,-16,0,22)
		nameLbl.Position = UDim2.new(0,8,0,6)
		nameLbl.BackgroundTransparency = 1
		nameLbl.Text = panelData.name~="" and panelData.name or "Script #"..idx
		nameLbl.TextColor3 = C_TEXT
		nameLbl.Font = Enum.Font.GothamBlack
		nameLbl.TextSize = 10
		nameLbl.TextXAlignment = Enum.TextXAlignment.Left
		nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
		nameLbl.ZIndex = 10
		local execBtn = Instance.new("TextButton", card)
		execBtn.Size = UDim2.new(0.56,0,0,26)
		execBtn.Position = UDim2.new(0,8,0,34)
		execBtn.BackgroundColor3 = C_BTN_ON
		execBtn.BorderSizePixel = 0
		execBtn.TextColor3 = C_BTN_ON_TEXT
		execBtn.Font = Enum.Font.GothamBlack
		execBtn.TextSize = 10
		execBtn.ZIndex = 11
		execBtn.Text = "RUN"
		Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0,7)
		execBtn.MouseButton1Click:Connect(function()
			TweenService:Create(execBtn, TweenInfo.new(0.08), {BackgroundColor3 = C_TEXT_SUB}):Play()
			task.delay(0.18, function()
				TweenService:Create(execBtn, TweenInfo.new(0.1), {BackgroundColor3 = C_BTN_ON}):Play()
			end)
			pcall(function()
				local fn, err = loadstring(panelData.code)
				if fn then task.spawn(fn) else warn("[Executor] "..tostring(err)) end
			end)
		end)
		execBtn.MouseEnter:Connect(function() TweenService:Create(execBtn, TweenInfo.new(0.1), {BackgroundColor3 = C_TEXT_SUB}):Play() end)
		execBtn.MouseLeave:Connect(function() TweenService:Create(execBtn, TweenInfo.new(0.1), {BackgroundColor3 = C_BTN_ON}):Play() end)
		local delBtn = Instance.new("TextButton", card)
		delBtn.Size = UDim2.new(0.36,0,0,26)
		delBtn.Position = UDim2.new(0.62,0,0,34)
		delBtn.BackgroundColor3 = C_OFF_BG
		delBtn.BorderSizePixel = 0
		delBtn.TextColor3 = C_TEXT_DIM
		delBtn.Font = Enum.Font.GothamBold
		delBtn.TextSize = 9
		delBtn.ZIndex = 11
		delBtn.Text = "DEL"
		Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0,7)
		Instance.new("UIStroke", delBtn).Color = C_BORDER
		delBtn.MouseButton1Click:Connect(function()
			table.remove(UserPanels, idx)
			card:Destroy()
			autoSaveConfig()
		end)
		delBtn.MouseEnter:Connect(function() TweenService:Create(delBtn, TweenInfo.new(0.1), {BackgroundColor3 = C_CARD_HOV}):Play() end)
		delBtn.MouseLeave:Connect(function() TweenService:Create(delBtn, TweenInfo.new(0.1), {BackgroundColor3 = C_OFF_BG}):Play() end)
		panelData.btn = card
		return card
	end

	makeSecHeader("Executor", "Add Script")
	local nameBox
	do
		local c = baseCard("Executor", 34)
		cLabel(c, "Name", 8, 60, 10, C_TEXT, Enum.Font.GothamBold)
		nameBox = Instance.new("TextBox", c)
		nameBox.Size = UDim2.new(0,110,0,22)
		nameBox.Position = UDim2.new(1,-118,0.5,-11)
		nameBox.BackgroundColor3 = C_INPUT_BG
		nameBox.BorderSizePixel = 0
		nameBox.Text = "My Script"
		nameBox.TextColor3 = C_TEXT
		nameBox.Font = Enum.Font.GothamBold
		nameBox.TextSize = 9
		nameBox.ClearTextOnFocus = false
		nameBox.ZIndex = 11
		nameBox.PlaceholderText = "Name..."
		Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0,5)
		local bs = Instance.new("UIStroke", nameBox)
		bs.Color = C_BORDER
		bs.Thickness = 1
		nameBox.Focused:Connect(function() TweenService:Create(bs, TweenInfo.new(0.1), {Color = C_BORDER2}):Play() end)
		nameBox.FocusLost:Connect(function() TweenService:Create(bs, TweenInfo.new(0.1), {Color = C_BORDER}):Play() end)
	end
	local codeBox
	do
		local codeFrame = Instance.new("Frame", pg("Executor"))
		codeFrame.Size = UDim2.new(1,0,0,120)
		codeFrame.BackgroundColor3 = C_CARD
		codeFrame.BorderSizePixel = 0
		codeFrame.LayoutOrder = lo("Executor")
		codeFrame.ZIndex = 4
		Instance.new("UICorner", codeFrame).CornerRadius = UDim.new(0,7)
		Instance.new("UIStroke", codeFrame).Color = C_BORDER2
		local codeLabel = Instance.new("TextLabel", codeFrame)
		codeLabel.Size = UDim2.new(1,0,0,18)
		codeLabel.Position = UDim2.new(0,8,0,4)
		codeLabel.BackgroundTransparency = 1
		codeLabel.Text = "SCRIPT CODE"
		codeLabel.TextColor3 = C_TEXT_DIM
		codeLabel.Font = Enum.Font.GothamBold
		codeLabel.TextSize = 8
		codeLabel.TextXAlignment = Enum.TextXAlignment.Left
		codeLabel.ZIndex = 10
		local codeBg = Instance.new("Frame", codeFrame)
		codeBg.Size = UDim2.new(1,-16,0,88)
		codeBg.Position = UDim2.new(0,8,0,24)
		codeBg.BackgroundColor3 = C_BG
		codeBg.BorderSizePixel = 0
		codeBg.ZIndex = 9
		Instance.new("UICorner", codeBg).CornerRadius = UDim.new(0,5)
		Instance.new("UIStroke", codeBg).Color = C_BORDER
		codeBox = Instance.new("TextBox", codeBg)
		codeBox.Size = UDim2.new(1,-4,1,-4)
		codeBox.Position = UDim2.new(0,2,0,2)
		codeBox.BackgroundTransparency = 1
		codeBox.Text = ""
		codeBox.TextColor3 = C_TEXT
		codeBox.Font = Enum.Font.Code
		codeBox.TextSize = 9
		codeBox.ClearTextOnFocus = false
		codeBox.MultiLine = true
		codeBox.TextWrapped = true
		codeBox.TextXAlignment = Enum.TextXAlignment.Left
		codeBox.TextYAlignment = Enum.TextYAlignment.Top
		codeBox.ZIndex = 11
		codeBox.PlaceholderText = "loadstring(game:HttpGet('...'))()"
	end
	do
		local addBtn = Instance.new("TextButton", pg("Executor"))
		addBtn.Size = UDim2.new(1,0,0,38)
		addBtn.BackgroundColor3 = C_BTN_ON
		addBtn.BorderSizePixel = 0
		addBtn.TextColor3 = C_BTN_ON_TEXT
		addBtn.Font = Enum.Font.GothamBlack
		addBtn.TextSize = 11
		addBtn.LayoutOrder = lo("Executor")
		addBtn.ZIndex = 5
		addBtn.Text = "+ Add Script"
		Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0,9)
		addBtn.MouseButton1Click:Connect(function()
			local nameVal = nameBox and nameBox.Text or "Script"
			local codeVal = codeBox and codeBox.Text or ""
			if codeVal == "" then return end
			local panelData = {name = nameVal ~= "" and nameVal or "Script #"..tostring(#UserPanels+1), code = codeVal, btn = nil}
			table.insert(UserPanels, panelData)
			createPanelBtn(panelData, #UserPanels)
			if nameBox then nameBox.Text = "My Script" end
			if codeBox then codeBox.Text = "" end
			autoSaveConfig()
			TweenService:Create(addBtn, TweenInfo.new(0.08), {BackgroundColor3 = C_TOGGLE_ON}):Play()
			task.delay(0.3, function() TweenService:Create(addBtn, TweenInfo.new(0.15), {BackgroundColor3 = C_BTN_ON}):Play() end)
		end)
		addBtn.MouseEnter:Connect(function() TweenService:Create(addBtn, TweenInfo.new(0.1), {BackgroundColor3 = C_TEXT_SUB}):Play() end)
		addBtn.MouseLeave:Connect(function() TweenService:Create(addBtn, TweenInfo.new(0.1), {BackgroundColor3 = C_BTN_ON}):Play() end)
	end

	-- Load config
	local function loadConfig()
		local cfg = _loadedConfig
		if not cfg then return end
		if cfg.normalSpeed then State.normalSpeed = cfg.normalSpeed; if normalBox then normalBox.Text = tostring(cfg.normalSpeed) end end
		if cfg.carrySpeed then State.carrySpeed = cfg.carrySpeed; if carryBox then carryBox.Text = tostring(cfg.carrySpeed) end end
		if cfg.laggerSpeed then State.laggerSpeed = cfg.laggerSpeed; if laggerBox then laggerBox.Text = tostring(cfg.laggerSpeed) end end
		if cfg.laggerCarrySpeed then State.laggerCarrySpeed = cfg.laggerCarrySpeed; if carryLaggerBox then carryLaggerBox.Text = tostring(cfg.laggerCarrySpeed) end end
		if cfg.speedType == "normal" or cfg.speedType == "carry" then State.speedType = cfg.speedType end
		if type(cfg.laggerActive) == "boolean" then State.laggerActive = cfg.laggerActive end
		if cfg.autoBatKey and Enum.KeyCode[cfg.autoBatKey] then Keys.autoBat = Enum.KeyCode[cfg.autoBatKey] end
		if cfg.speedKey and Enum.KeyCode[cfg.speedKey] then Keys.speed = Enum.KeyCode[cfg.speedKey] end
		if cfg.laggerKey and Enum.KeyCode[cfg.laggerKey] then Keys.lagger = Enum.KeyCode[cfg.laggerKey] end
		if cfg.autoPlayKey and Enum.KeyCode[cfg.autoPlayKey] then Keys.autoPlay = Enum.KeyCode[cfg.autoPlayKey] end
		if cfg.tpDownKey and Enum.KeyCode[cfg.tpDownKey] then Keys.tpDown = Enum.KeyCode[cfg.tpDownKey] end
		if cfg.dropBrainrotKey and Enum.KeyCode[cfg.dropBrainrotKey] then Keys.dropBrainrot = Enum.KeyCode[cfg.dropBrainrotKey] end
		if cfg.guiHideKey and Enum.KeyCode[cfg.guiHideKey] then Keys.guiHide = Enum.KeyCode[cfg.guiHideKey] end
		if cfg.grabRadius then AutoSteal.Radius = cfg.grabRadius end
		if cfg.stealDuration then AutoSteal.Duration = cfg.stealDuration end
		if cfg.autoPlaySide and (cfg.autoPlaySide=="right" or cfg.autoPlaySide=="left") then State.autoPlaySide = cfg.autoPlaySide end
		if cfg.aimbotSpeed then State.aimbotSpeed = cfg.aimbotSpeed end
		if type(cfg.autoSwingEnabled) == "boolean" then State.autoSwingEnabled = cfg.autoSwingEnabled end
		if cfg.infJump then State.infJumpEnabled = true end
		if cfg.infJumpMode and (cfg.infJumpMode=="manual" or cfg.infJumpMode=="hold") then State.infJumpMode = cfg.infJumpMode end
		if cfg.antiRagdoll then State.antiRagdollEnabled = true end
		if cfg.fpsBoost then State.fpsBoostEnabled = true end
		if cfg.medusaCounter then State.medusaCounterEnabled = true end
		if cfg.animEnabled then State.animEnabled = true end
		if cfg.unwalkEnabled then State.unwalkEnabled = true end
		if cfg.hitboxEnabled then State.hitboxEnabled = true end
		if cfg.darkModeEnabled then State.darkModeEnabled = true end
		if cfg.removeAccEnabled then State.removeAccEnabled = true end
		if cfg.menuScale then State.menuScale = math.clamp(cfg.menuScale, 0.8, 1.8) end
		if cfg.autoTPDownEnabled then State.autoTPDownEnabled = true end
		if cfg.jumpThreshold then State.jumpThreshold = math.clamp(math.floor(cfg.jumpThreshold), 1, 20) end
		if cfg.hardHitEnabled then State.hardHitEnabled = true end
		if cfg.hardHitRadius then State.hardHitRadius = cfg.hardHitRadius end
		if cfg.batRadius then State.batRadius = cfg.batRadius end
		if cfg.antiLagEnabled then State.antiLagEnabled = true end
		if cfg.ultraModeEnabled then State.ultraModeEnabled = true end
		if cfg.espEnabled then State.espEnabled = true end
		if cfg.tracerEnabled then State.tracerEnabled = true end
		if cfg.noCamCollisionEnabled then State.noCamCollisionEnabled = true end
		if cfg.panels then
			for i, pd in ipairs(cfg.panels) do
				if pd.name and pd.code then
					local panelData = {name=pd.name, code=pd.code, btn=nil}
					table.insert(UserPanels, panelData)
					createPanelBtn(panelData, i)
				end
			end
		end
		if cfg.positions then
			local pos = cfg.positions
			task.defer(function()
				if pos.main then local u=t2u(pos.main); if u then main.Position = u end end
				if pos.mini then local u=t2u(pos.mini); if u then mini.Position = u end end
			end)
		end
		-- Apply scale
		main.Size = UDim2.new(0, math.floor(W*State.menuScale), 0, math.floor(H*State.menuScale))
	end

	-- Start on Speed tab
	switchTab("Speed")
	loadConfig()

	-- Global keybinds (simple)
	UIS.InputBegan:Connect(function(inp, gp)
		if gp or _anyKeyListening then return end
		local kc = inp.KeyCode
		if inp.UserInputType == Enum.UserInputType.Keyboard then
			if kc == Keys.speed then toggleSpeedType()
			elseif kc == Keys.lagger then toggleLagger()
			elseif kc == Keys.autoBat then State.autoBatToggled = not State.autoBatToggled; print("Auto Bat:", State.autoBatToggled); autoSaveConfig()
			elseif kc == Keys.autoPlay then State.autoPlayEnabled = not State.autoPlayEnabled; print("Auto Play:", State.autoPlayEnabled); autoSaveConfig()
			elseif kc == Keys.dropBrainrot then runDropBrainrot()
			elseif kc == Keys.tpDown then tpToGround()
			elseif kc == Keys.guiHide then if guiVisible then hideGui() else showGui() end
			end
		end
	end)

end

-- Start the GUI
buildGUI()
print("Moon Duels V3 GUI loaded.")