-- AMBITIOS PUB METHOD
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local hui = (gethui and gethui()) or game:GetService("CoreGui")

-- Eliminare GUI vechi dacă există
for _, v in ipairs(hui:GetChildren()) do
	if v.Name == "AmbitiosPubMethodUI" then
		v:Destroy()
	end
end

-- Creare ScreenGui principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AmbitiosPubMethodUI"
ScreenGui.Parent = hui
ScreenGui.ResetOnSpawn = false

-- Fereastra Principală (cu poza de fundal)
local MainFrame = Instance.new("ImageLabel")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 440) -- Mărit pentru 3 butoane
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Image = "rbxassetid://136954244949739"
MainFrame.ScaleType = Enum.ScaleType.Slice
MainFrame.SliceCenter = Rect.new(100, 100, 100, 100)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Un strat semi-transparent negru peste poză ca să se vadă butoanele clar
local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 0.4
Overlay.BorderSizePixel = 0
Overlay.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local OverlayCorner = Instance.new("UICorner")
OverlayCorner.CornerRadius = UDim.new(0, 12)
OverlayCorner.Parent = Overlay

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 105, 180) -- Roz aprins
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Titlu / Header
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.Text = "AMBITIOS PUB METHOD"
TitleLabel.TextColor3 = Color3.fromRGB(255, 105, 180) -- Roz
TitleLabel.TextSize = 18
TitleLabel.ZIndex = 2
TitleLabel.Parent = MainFrame

-- Container pentru Butoane
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, -40, 0, 340)
ButtonContainer.Position = UDim2.new(0, 20, 0, 70)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.ZIndex = 2
ButtonContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 15)
UIListLayout.Parent = ButtonContainer

-- Buton 1: SLOTS ESP (Roz)
local SlotsButton = Instance.new("TextButton")
SlotsButton.Size = UDim2.new(1, 0, 0, 50)
SlotsButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180) -- Roz
SlotsButton.Font = Enum.Font.GothamBold
SlotsButton.Text = "SLOTS ESP: OFF"
SlotsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SlotsButton.TextSize = 16
SlotsButton.ZIndex = 2
SlotsButton.LayoutOrder = 1
SlotsButton.Parent = ButtonContainer

local SlotsCorner = Instance.new("UICorner")
SlotsCorner.CornerRadius = UDim.new(0, 8)
SlotsCorner.Parent = SlotsButton

-- Buton 2: INF JUMP (Roz)
local InfJumpButton = Instance.new("TextButton")
InfJumpButton.Size = UDim2.new(1, 0, 0, 50)
InfJumpButton.BackgroundColor3 = Color3.fromRGB(200, 50, 140)
InfJumpButton.Font = Enum.Font.GothamBold
InfJumpButton.Text = "INF JUMP: OFF"
InfJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InfJumpButton.TextSize = 16
InfJumpButton.ZIndex = 2
InfJumpButton.LayoutOrder = 2
InfJumpButton.Parent = ButtonContainer

local InfJumpCorner = Instance.new("UICorner")
InfJumpCorner.CornerRadius = UDim.new(0, 8)
InfJumpCorner.Parent = InfJumpButton

-- Buton 3: NEXT BASE (Nou)
local NextBaseButton = Instance.new("TextButton")
NextBaseButton.Size = UDim2.new(1, 0, 0, 50)
NextBaseButton.BackgroundColor3 = Color3.fromRGB(220, 75, 160)
NextBaseButton.Font = Enum.Font.GothamBold
NextBaseButton.Text = "NEXT BASE: OFF"
NextBaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NextBaseButton.TextSize = 16
NextBaseButton.ZIndex = 2
NextBaseButton.LayoutOrder = 3
NextBaseButton.Parent = ButtonContainer

local NextBaseCorner = Instance.new("UICorner")
NextBaseCorner.CornerRadius = UDim.new(0, 8)
NextBaseCorner.Parent = NextBaseButton


----------------------------------------------------
-- LOGICĂ SLOTS ESP (Setat pe culoarea roz)
----------------------------------------------------
local slotsEspActive = false

SlotsButton.MouseButton1Click:Connect(function()
	slotsEspActive = not slotsEspActive
	if slotsEspActive then
		SlotsButton.Text = "SLOTS ESP: ON"
		SlotsButton.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
		
		if _G.__PodiumESPCleanup then pcall(_G.__PodiumESPCleanup) end

		local Plots = workspace:WaitForChild("Plots")
		local Camera = workspace.CurrentCamera

		local PALETTE = {
			PINK  = Color3.fromRGB(255, 95, 190),
			WHITE = Color3.fromRGB(255, 255, 255),
		}

		local CFG = {
			FLOOR_COLOR   = { PALETTE.PINK, PALETTE.PINK, PALETTE.PINK },
			COLLIDE       = true,
			SHOW_NUMBERS  = true,
		}

		local FILL_T, INNER_T, THICK = 0.55, 0.42, 0.05
		local PULSE_SPEED, PULSE_AMOUNT = 2, 0.12

		local TEMPLATE = {
			{ 18.500,  1.531, -14.476,  90}, { 18.500,  1.531,  -6.976,  90}, { 18.500,  1.531,   0.524,  90},
			{ 18.500,  1.531,   8.024,  90}, { 18.500,  1.531,  15.524,  90},
			{-18.536,  1.531,  15.524, -90}, {-18.536,  1.531,   8.024, -90}, {-18.536,  1.531,   0.524, -90},
			{-18.536,  1.531,  -6.976, -90}, {-18.536,  1.531, -14.476, -90},
			{ 18.500, 19.531, -14.476,  90}, { 18.500, 19.531,  -6.976,  90}, { 18.500, 19.531,   0.524,  90},
			{ 18.500, 19.531,   8.024,  90}, { 18.500, 19.531,  15.524,  90},
			{-18.380, 19.531, -14.452, -90}, {-18.380, 19.531,  -6.952, -90}, {-18.380, 19.531,   0.548, -90},
			{ 18.500, 36.531, -12.476,  90}, { 18.500, 36.531,  -4.976,  90}, { 18.500, 36.531,   2.524,  90},
			{ 18.500, 36.531,  10.024,  90}, { 18.500, 36.531,  17.524,  90},
			{-18.472, 36.531, -12.501, -90}, {-18.471, 36.531,  -5.001, -90}, {-18.471, 36.531,   2.499, -90},
			{-18.471, 36.531,   9.999, -90}, {-18.471, 36.531,  17.499, -90},
		}

		local OUTER, INNER_SZ, INNER_UP = Vector3.new(6, 0.25, 6), Vector3.new(4, 0.25, 4), 0.25

		local function floorOf(i)
			if i <= 10 then return 1 elseif i <= 18 then return 2 end
			return 3
		end

		local _rng = Random.new(os.clock() * 1e6)
		local _NAME_POOL = { "Part", "Mesh", "MeshPart", "Union", "Wedge", "Cylinder", "Model", "Frame", "Handle", "Body", "Root" }
		local function _fakeName()
			return _NAME_POOL[_rng:NextInteger(1, #_NAME_POOL)]
		end

		local markers, fills, conns = {}, {}, {}
		local collideParts, labelAnchors = {}, {}
		local labelsByPlot = {}
		local currentPlot = nil
		local alive = true

		local function keep(x) markers[#markers + 1] = x x.Parent = hui return x end

		local function clear()
			for _, m in ipairs(markers) do pcall(function() m:Destroy() end) end
			table.clear(markers)
			table.clear(fills)
			for _, p in ipairs(collideParts) do pcall(function() p:Destroy() end) end
			table.clear(collideParts)
			for _, p in ipairs(labelAnchors) do pcall(function() p:Destroy() end) end
			table.clear(labelAnchors)
			table.clear(labelsByPlot)
			currentPlot = nil
		end

		local function box(adornee, cf, size, color, trans, isFill)
			local a = Instance.new("BoxHandleAdornment")
			a.Adornee = adornee
			a.Size = size
			a.CFrame = cf
			a.Color3 = color
			a.Transparency = trans
			a.AlwaysOnTop = false
			a.ZIndex = 0
			keep(a)
			if isFill then fills[#fills + 1] = { a = a, base = trans } end
			return a
		end

		local function edges(root, cf, size, color)
			local t = THICK * 1.6
			local hx, hz, y = size.X * 0.5, size.Z * 0.5, size.Y * 0.5
			box(root, cf * CFrame.new(0, y,  hz), Vector3.new(size.X, t, t), color, 0)
			box(root, cf * CFrame.new(0, y, -hz), Vector3.new(size.X, t, t), color, 0)
			box(root, cf * CFrame.new( hx, y, 0), Vector3.new(t, t, size.Z), color, 0)
			box(root, cf * CFrame.new(-hx, y, 0), Vector3.new(t, t, size.Z), color, 0)
		end

		local function solid(worldCF)
			if not CFG.COLLIDE then return end
			local p = Instance.new("Part")
			p.Name = _fakeName()
			p.Anchored = true
			p.CanCollide = true
			p.CanQuery = false
			p.CanTouch = false
			p.CastShadow = false
			p.Transparency = 1
			p.Massless = true
			p.Size = OUTER
			p.CFrame = worldCF
			p.Parent = Camera
			collideParts[#collideParts + 1] = p
		end

		local function makeInvisibleAnchor(worldCF)
			local a = Instance.new("Part")
			a.Name = _fakeName()
			a.Anchored = true
			a.CanCollide = false
			a.CanQuery = false
			a.CanTouch = false
			a.CastShadow = false
			a.Transparency = 1
			a.Size = Vector3.new(0.1, 0.1, 0.1)
			a.CFrame = worldCF
			a.Parent = Camera
			labelAnchors[#labelAnchors + 1] = a
			return a
		end

		local function labelFor(plot, adornee, slotNum, color)
			if not CFG.SHOW_NUMBERS then return end

			local bg = Instance.new("BillboardGui")
			bg.Adornee = adornee
			bg.Size = UDim2.new(2.2, 20, 1.35, 12)
			bg.StudsOffset = Vector3.new(0, 3.2, 0)
			bg.AlwaysOnTop = true
			bg.LightInfluence = 0
			bg.MaxDistance = 400
			bg.ClipsDescendants = false
			bg.Enabled = false

			local panel = Instance.new("Frame")
			panel.Size = UDim2.new(1, 0, 1, 0)
			panel.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
			panel.BackgroundTransparency = 0.55
			panel.BorderSizePixel = 0
			panel.Parent = bg

			local panelCorner = Instance.new("UICorner")
			panelCorner.CornerRadius = UDim.new(0.3, 0)
			panelCorner.Parent = panel

			local glow = Instance.new("UIStroke")
			glow.Color = color
			glow.Thickness = 4
			glow.Transparency = 0.7
			glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			glow.Parent = panel

			local border = Instance.new("Frame")
			border.Size = UDim2.new(1, 0, 1, 0)
			border.BackgroundTransparency = 1
			border.Parent = panel

			local borderCorner = Instance.new("UICorner")
			borderCorner.CornerRadius = UDim.new(0.3, 0)
			borderCorner.Parent = border

			local borderStroke = Instance.new("UIStroke")
			borderStroke.Color = color
			borderStroke.Thickness = 1.5
			borderStroke.Transparency = 0
			borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			borderStroke.Parent = border

			local num = Instance.new("TextLabel")
			num.Size = UDim2.new(1, 0, 1, 0)
			num.BackgroundTransparency = 1
			num.Text = tostring(slotNum)
			num.Font = Enum.Font.GothamBlack
			num.TextScaled = true
			num.TextColor3 = PALETTE.WHITE
			num.TextXAlignment = Enum.TextXAlignment.Center
			num.TextYAlignment = Enum.TextYAlignment.Center
			num.Parent = panel

			local pad = Instance.new("UIPadding")
			pad.PaddingLeft = UDim.new(0.1, 0)
			pad.PaddingRight = UDim.new(0.1, 0)
			pad.PaddingTop = UDim.new(0.08, 0)
			pad.PaddingBottom = UDim.new(0.08, 0)
			pad.Parent = num

			local sizeConstraint = Instance.new("UITextSizeConstraint")
			sizeConstraint.MaxTextSize = 500
			sizeConstraint.MinTextSize = 6
			sizeConstraint.Parent = num

			local numStroke = Instance.new("UIStroke")
			numStroke.Color = color
			numStroke.Thickness = 2
			numStroke.Transparency = 0
			numStroke.LineJoinMode = Enum.LineJoinMode.Round
			numStroke.Parent = num

			keep(bg)
			if not labelsByPlot[plot] then labelsByPlot[plot] = {} end
			labelsByPlot[plot][#labelsByPlot[plot] + 1] = bg
		end

		local function colorFor(i)
			local f = floorOf(i)
			return CFG.FLOOR_COLOR[f] or PALETTE.PINK
		end

		local function drawSlot(plot, root, e, color, slotNum)
			local cf = CFrame.new(e[1], e[2], e[3]) * CFrame.Angles(0, math.rad(e[4]), 0)
			local worldCF = root.CFrame * cf
			local anchor = makeInvisibleAnchor(worldCF)
			box(anchor, CFrame.new(), OUTER, color, FILL_T, true)
			box(anchor, CFrame.new(0, INNER_UP, 0), INNER_SZ, color, INNER_T, true)
			edges(anchor, CFrame.new(), OUTER, color)
			solid(worldCF)
			labelFor(plot, anchor, slotNum, color)
		end

		local function build()
			if not alive then return end
			clear()
			for _, plot in ipairs(Plots:GetChildren()) do
				local root = plot:FindFirstChild("MainRoot")
				if root then
					for i = 1, #TEMPLATE do
						drawSlot(plot, root, TEMPLATE[i], colorFor(i), i)
					end
				end
			end
		end

		build()

		local function findCurrentPlot()
			local char = LP.Character
			if not char then return nil end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then return nil end
			local pos = hrp.Position
			local best, bestDist = nil, math.huge
			for _, plot in ipairs(Plots:GetChildren()) do
				local root = plot:FindFirstChild("MainRoot")
				if root then
					local d = (root.Position - pos).Magnitude
					if d < bestDist then
						best = plot
						bestDist = d
					end
				end
			end
			if bestDist > 100 then return nil end
			return best
		end

		local function updateVisibility()
			local newPlot = findCurrentPlot()
			if newPlot == currentPlot then return end
			currentPlot = newPlot
			for plot, list in pairs(labelsByPlot) do
				local show = (plot == currentPlot)
				for _, bg in ipairs(list) do
					if bg and bg.Parent then bg.Enabled = show end
				end
			end
		end

		local pending = false
		local function rebuild()
			if pending or not alive then return end
			pending = true
			task.delay(0.4, function()
				pending = false
				build()
				updateVisibility()
			end)
		end

		local function watch(plot)
			if not plot:FindFirstChild("MainRoot") then
				local root = plot:WaitForChild("MainRoot", 30)
				if root and alive then rebuild() end
			end
		end
		for _, plot in ipairs(Plots:GetChildren()) do task.spawn(watch, plot) end
		conns[#conns + 1] = Plots.ChildAdded:Connect(function(plot)
			task.spawn(watch, plot)
			rebuild()
		end)

		conns[#conns + 1] = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			Camera = workspace.CurrentCamera
			if alive then rebuild() end
		end)

		do
			local acc = 0
			local visAcc = 0
			conns[#conns + 1] = RunService.Heartbeat:Connect(function(dt)
				acc = acc + dt
				visAcc = visAcc + dt
				if acc >= 0.05 then
					acc = 0
					local w = math.sin(os.clock() * PULSE_SPEED) * PULSE_AMOUNT
					for _, f in ipairs(fills) do
						if f.a.Parent then f.a.Transparency = math.clamp(f.base + w, 0, 1) end
					end
				end
				if visAcc >= 0.5 then
					visAcc = 0
					updateVisibility()
				end
			end)
		end

		updateVisibility()

		_G.__PodiumESPCleanup = function()
			alive = false
			for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
			table.clear(conns)
			clear()
			_G.__PodiumESPCleanup = nil
		end
	else
		SlotsButton.Text = "SLOTS ESP: OFF"
		SlotsButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
		if _G.__PodiumESPCleanup then pcall(_G.__PodiumESPCleanup) end
	end
end)


----------------------------------------------------
-- LOGICĂ INF JUMP (Controlat prin buton)
----------------------------------------------------
local infJumpActive = false
local jumpForce = 50
local clampFallSpeed = 80

RunService.Heartbeat:Connect(function()
	if not infJumpActive then return end
	local char = LP.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp and hrp.Velocity.Y < -clampFallSpeed then
		hrp.Velocity = Vector3.new(hrp.Velocity.X, -clampFallSpeed, hrp.Velocity.Z)
	end
end)

UserInputService.JumpRequest:Connect(function()
	if not infJumpActive then return end
	local char = LP.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpForce, hrp.Velocity.Z)
	end
end)

InfJumpButton.MouseButton1Click:Connect(function()
	infJumpActive = not infJumpActive
	if infJumpActive then
		InfJumpButton.Text = "INF JUMP: ON"
		InfJumpButton.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
	else
		InfJumpButton.Text = "INF JUMP: OFF"
		InfJumpButton.BackgroundColor3 = Color3.fromRGB(200, 50, 140)
	end
end)


----------------------------------------------------
-- LOGICĂ NEXT BASE (Integrat din sursă)[span_1](start_span)[span_1](end_span)
----------------------------------------------------
local nextBaseActive = false

NextBaseButton.MouseButton1Click:Connect(function()
	nextBaseActive = not nextBaseActive
	if nextBaseActive then
		NextBaseButton.Text = "NEXT BASE: ON"
		NextBaseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 150)

		if _G.__NextBaseCleanup then pcall(_G.__NextBaseCleanup) end
		local Plots = workspace:WaitForChild("Plots")
		local BASE_POSITIONS = {
			Vector3.new(-342.439, 10.399, 113.107),
			Vector3.new(-342.439, 10.465,   6.107),
			Vector3.new(-476.752, 10.465, 114.107),
			Vector3.new(-476.752, 10.465,   7.107),
			Vector3.new(-342.440, 10.464, 220.107),
			Vector3.new(-476.752, 10.465, 221.107),
			Vector3.new(-342.439, 10.465,-100.893),
			Vector3.new(-476.752, 10.465, -99.893),
		}
		local MATCH_TOL = 6
		local EMPTY_TEXT = "Empty Base"
		local ARROW = utf8.char(0x2B07)
		local function baseIndexFor(model)
			local ok, cf = pcall(function() return (model:GetBoundingBox()) end)
			if not ok then return nil end
			local p, bestI, bestD = cf.Position
			for i, bp in ipairs(BASE_POSITIONS) do
				local dx, dz = p.X - bp.X, p.Z - bp.Z
				local d = math.sqrt(dx * dx + dz * dz)
				if not bestD or d < bestD then bestI, bestD = i, d end
			end
			return (bestD and bestD <= MATCH_TOL) and bestI or nil
		end
		local bases = {}
		local connected = {}
		local conns = {}
		local anchor = Instance.new("Part")
		anchor.Name = "__NextBaseAnchor"
		anchor.Anchored, anchor.CanCollide, anchor.CanQuery, anchor.CanTouch = true, false, false, false
		anchor.Transparency = 1
		anchor.Size = Vector3.new(1, 1, 1)
		anchor.Parent = workspace
		local bb = Instance.new("BillboardGui")
		bb.Name = "NextBaseBillboard"
		bb.Adornee = anchor
		bb.Size = UDim2.fromScale(32, 13)
		bb.StudsOffset = Vector3.new(0, 10, 0)
		bb.MaxDistance = math.huge
		bb.AlwaysOnTop = true
		bb.LightInfluence = 0
		bb.Enabled = false
		bb.Parent = anchor
		local top = Instance.new("TextLabel", bb)
		top.BackgroundTransparency = 1
		top.AnchorPoint = Vector2.new(0.5, 0.5)
		top.Position = UDim2.fromScale(0.5, 0.30)
		top.Size = UDim2.fromScale(0.95, 0.50)
		top.Font = Enum.Font.GothamBlack
		top.Text = ARROW .. "  NEXT  " .. ARROW
		top.TextScaled = true
		top.TextColor3 = Color3.fromRGB(46, 230, 92)
		top.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		top.TextStrokeTransparency = 0
		local bottom = Instance.new("TextLabel", bb)
		bottom.BackgroundTransparency = 1
		bottom.AnchorPoint = Vector2.new(0.5, 0.5)
		bottom.Position = UDim2.fromScale(0.5, 0.72)
		bottom.Size = UDim2.fromScale(0.95, 0.42)
		bottom.Font = Enum.Font.GothamBlack
		bottom.Text = "EMPTY BASE"
		bottom.TextScaled = true
		bottom.TextColor3 = Color3.fromRGB(255, 255, 255)
		bottom.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		bottom.TextStrokeTransparency = 0
		local function isEmpty(label)
			return (label.Text:gsub("^%s+", ""):gsub("%s+$", "")) == EMPTY_TEXT
		end
		local function recompute()
			local targetIdx
			for i = 1, #BASE_POSITIONS do
				local b = bases[i]
				if b and b.label and isEmpty(b.label) then targetIdx = i break end
			end
			if targetIdx then
				anchor.CFrame = bases[targetIdx].cf
				bb.Enabled = true
			else
				bb.Enabled = false
			end
		end
		local function connectLabel(label)
			if connected[label] then return end
			connected[label] = true
			table.insert(conns, label:GetPropertyChangedSignal("Text"):Connect(recompute))
		end
		local function scan()
			for _, plot in ipairs(Plots:GetChildren()) do
				local sign  = plot:FindFirstChild("PlotSign")
				local model = sign and sign:FindFirstChild("Model")
				local gui   = sign and sign:FindFirstChild("SurfaceGui")
				local fr    = gui and gui:FindFirstChild("Frame")
				local label = fr and fr:FindFirstChild("TextLabel")
				if model and label then
					local idx = baseIndexFor(model)
					if idx then
						bases[idx] = { label = label, cf = (select(1, model:GetBoundingBox())) }
						connectLabel(label)
					end
				end
			end
			recompute()
		end
		scan()
		table.insert(conns, Plots.DescendantAdded:Connect(function(d)
			if d:IsA("TextLabel") then task.defer(scan) end
		end))
		table.insert(conns, Plots.ChildAdded:Connect(function() task.defer(scan) end))
		_G.__NextBaseCleanup = function()
			for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
			if anchor then anchor:Destroy() end
			_G.__NextBaseCleanup = nil
		end
	else
		NextBaseButton.Text = "NEXT BASE: OFF"
		NextBaseButton.BackgroundColor3 = Color3.fromRGB(220, 75, 160)
		if _G.__NextBaseCleanup then pcall(_G.__NextBaseCleanup) end
	end
end)