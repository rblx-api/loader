--==================================================================
-- leaked by 32e4 and egg at https://discord.gg/GJdkrM3hnD
--==================================================================
local Players           = game:GetService("Players")
local TeleportService   = game:GetService("TeleportService")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local HttpService       = game:GetService("HttpService")
local Stats             = game:GetService("Stats")
local Lighting          = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer     = game:GetService("StarterPlayer")
local CoreGui           = game:GetService("CoreGui")
local LocalPlayer       = Players.LocalPlayer

local GAME_PLACE_ID = 96342491571673
local CONFIG_FILE   = "SkibidiTPHub.json"
local HUD_BRAND     = "32e4 and egg owns me"
local HUD_LINK      = "discord.gg/skibiditp"

--------------------------------------------------------------------
-- Geraet erkennen (vor Config, damit Default-Positionen passen)
--------------------------------------------------------------------
local function detectDevice()
	local touch = UserInputService.TouchEnabled
	local kbd, mouse = UserInputService.KeyboardEnabled, UserInputService.MouseEnabled
	local cam = workspace.CurrentCamera
	local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
	if touch and not kbd and not mouse then
		return math.min(vp.X, vp.Y) <= 500 and "iphone" or "ipad"
	end
	return "desktop"
end
local DEVICE = detectDevice()

local DEFAULT_POSITIONS = {
	desktop = { GearSafety = { X = 20, Y = 120 }, JobId = { X = 20, Y = 380 }, BindsWindow = { X = 800, Y = 200 } },
	iphone  = { GearSafety = { X = 8, Y = 40 },   JobId = { X = 8, Y = 140 },  BindsWindow = { X = 20, Y = 320 } },
	ipad    = { GearSafety = { X = 200, Y = 80 }, JobId = { X = 40, Y = 320 }, BindsWindow = { X = 300, Y = 200 } },
}

--------------------------------------------------------------------
-- Config
--------------------------------------------------------------------
local CONFIG = {
	-- Features (Schluessel = Feature-Name)
	NextBase = false, AntiRagdoll = false, CarpetSpeed = false, InfiniteJump = true, XRay = true,
	AutoEquipOnSlot = false, Aimbot = false, SlotsESP = true, BrainrotESP = false, AutoKick = false, StealBoost = true,
	ShowJobId = false,
	-- Binds
	Bind_CarpetSpeed = "Q", Bind_InstantReset = "R", Bind_Drop = "G", Bind_Aimbot = "C", Bind_AutoKick = "K", Bind_StealBoost = "V",
	-- UI
	GuiScale = 0, -- 0 = automatisch
	Positions = {},
}
for name, p in pairs(DEFAULT_POSITIONS[DEVICE]) do CONFIG.Positions[name] = { X = p.X, Y = p.Y } end

local function SaveConfig()
	if not writefile then return end
	pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(CONFIG)) end)
end

local function LoadConfig()
	if not (readfile and isfile) then return end
	pcall(function()
		if not isfile(CONFIG_FILE) then return end
		local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
		for k, v in pairs(data) do
			if k == "Positions" and type(v) == "table" then
				for name, pos in pairs(v) do
					local cur = CONFIG.Positions[name]
					if cur and type(pos) == "table" then
						cur.X = tonumber(pos.X) or cur.X
						cur.Y = tonumber(pos.Y) or cur.Y
					end
				end
			elseif CONFIG[k] ~= nil and type(v) == type(CONFIG[k]) then
				CONFIG[k] = v
			end
		end
	end)
end
LoadConfig() -- VOR dem Bau der UI, damit Toggles den gespeicherten Zustand zeigen

--------------------------------------------------------------------
-- Theme
--------------------------------------------------------------------
local THEME = {
	Accent = Color3.fromRGB(80, 160, 255), AccentBright = Color3.fromRGB(150, 210, 255), AccentDark = Color3.fromRGB(40, 90, 200),
	TrackOn = Color3.fromRGB(60, 140, 240), TrackOff = Color3.fromRGB(36, 32, 52),
	Bg = Color3.fromRGB(10, 12, 24), BgCard = Color3.fromRGB(12, 20, 40), BgRow = Color3.fromRGB(18, 30, 58), BgRowHover = Color3.fromRGB(26, 36, 80),
	BtnBg = Color3.fromRGB(18, 36, 84), BtnBgHover = Color3.fromRGB(28, 54, 90),
	ResetAccent = Color3.fromRGB(255, 100, 100), ResetBg = Color3.fromRGB(55, 22, 38), ResetBgHover = Color3.fromRGB(75, 30, 52),
	DropAccent = Color3.fromRGB(255, 200, 80), DropBg = Color3.fromRGB(52, 44, 24), DropBgHover = Color3.fromRGB(72, 62, 18),
	Text = Color3.fromRGB(245, 242, 255), TextDim = Color3.fromRGB(160, 160, 185), TextMuted = Color3.fromRGB(110, 106, 150),
	StrokeSoft = Color3.fromRGB(40, 90, 200),
}

--------------------------------------------------------------------
-- Helper
--------------------------------------------------------------------
local function corner(parent, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 8)
	c.Parent = parent
	return c
end
local function stroke(parent, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color, s.Thickness, s.Transparency = color, thickness or 1, transparency or 0.3
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = parent
	return s
end
local function tween(obj, duration, props, style, direction)
	local t = TweenService:Create(obj, TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out), props)
	t:Play()
	return t
end
local function new(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props or {}) do o[k] = v end
	o.Parent = parent
	return o
end
local function getRoot() local c = LocalPlayer.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function getHumanoid() local c = LocalPlayer.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function guiRoot()
	local ok, h = pcall(function() return gethui and gethui() or CoreGui end)
	return (ok and h) or LocalPlayer:WaitForChild("PlayerGui")
end
local function destroyOld(name)
	for _, root in ipairs({ guiRoot(), CoreGui, LocalPlayer:FindFirstChild("PlayerGui") }) do
		pcall(function() local o = root:FindFirstChild(name) if o then o:Destroy() end end)
	end
end

-- Sammelt Connections/Threads/Instanzen zum sauberen Aufraeumen
local function newBin()
	local items, bin = {}, {}
	function bin.add(x) items[#items + 1] = x return x end
	function bin.clean()
		for _, x in ipairs(items) do
			pcall(function()
				local t = typeof(x)
				if t == "RBXScriptConnection" then x:Disconnect()
				elseif t == "thread" then task.cancel(x)
				elseif t == "Instance" then x:Destroy()
				elseif t == "function" then x() end
			end)
		end
		items = {}
	end
	return bin
end

local CARPET_TOOLS = { "Santa's Sleigh", "Cupid's Wings", "Flying Carpet", "Witch's Broom", "Waverider", "Flying Bee" }
local function findCarpetTool()
	local char, bag = LocalPlayer.Character, LocalPlayer:FindFirstChild("Backpack")
	for _, container in ipairs({ char, bag }) do
		if container then
			for _, name in ipairs(CARPET_TOOLS) do
				local t = container:FindFirstChild(name)
				if t and t:IsA("Tool") then return t end
			end
		end
	end
end

--------------------------------------------------------------------
-- FEATURE: Drop (kurz hochschleudern, dann auf den Boden setzen)
--------------------------------------------------------------------
local Drop = { active = false }
function Drop.Run()
	if Drop.active then return end
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	Drop.active = true
	local t0 = tick()
	local conn
	conn = RunService.Heartbeat:Connect(function()
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then conn:Disconnect() Drop.active = false return end
		if tick() - t0 >= 0.2 then
			conn:Disconnect()
			local params = RaycastParams.new()
			params.FilterDescendantsInstances = { char }
			params.FilterType = Enum.RaycastFilterType.Exclude
			local hit = workspace:Raycast(root.Position, Vector3.new(0, -2000, 0), params)
			if hit then
				local hum = char:FindFirstChildOfClass("Humanoid")
				root.CFrame = CFrame.new(root.Position.X, hit.Position.Y + (hum and hum.HipHeight or 2) + root.Size.Y / 2, root.Position.Z)
				root.AssemblyLinearVelocity = Vector3.zero
			end
			task.delay(0.25, function() Drop.active = false end)
			return
		end
		root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 150, root.AssemblyLinearVelocity.Z)
	end)
end

--------------------------------------------------------------------
-- FEATURE: Instant Reset (HipHeight-Trick)
--------------------------------------------------------------------
local HipReset = { busy = false, thread = nil, stop = false }
local HIP_FRAMES, HIP_STEP = 40, 0.05

local function setCollide(char, on)
	local root = char:FindFirstChild("HumanoidRootPart")
	if root then root.CanCollide = on end
	for _, c in ipairs(char:GetChildren()) do
		if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then c.CanCollide = on end
	end
end

function HipReset.Stop()
	HipReset.stop = true
	if HipReset.thread then pcall(task.cancel, HipReset.thread) HipReset.thread = nil end
	HipReset.busy = false
	local char, hum = LocalPlayer.Character, getHumanoid()
	if char and hum then pcall(function() hum.HipHeight = 2 setCollide(char, true) end) end
end

function HipReset.Run()
	if HipReset.busy then return end
	local char, hum = LocalPlayer.Character, getHumanoid()
	if not char or not hum then return end
	HipReset.busy, HipReset.stop = true, false
	local original = hum.HipHeight
	local function alive()
		return char.Parent and hum.Health > 0 and LocalPlayer.Character == char and not HipReset.stop
	end
	HipReset.thread = task.spawn(function()
		local completed = true
		for _ = 1, HIP_FRAMES do
			if not alive() then completed = false break end
			pcall(function() hum.HipHeight = 1e30 hum.AutoRotate = true setCollide(char, false) end)
			task.wait(HIP_STEP)
		end
		if completed and alive() then
			pcall(function() hum.Health = 0 end)
			task.wait(0.1)
		end
		if char.Parent then pcall(function() hum.HipHeight = original setCollide(char, true) end) end
		HipReset.busy, HipReset.thread, HipReset.stop = false, nil, false
	end)
end

LocalPlayer.CharacterAdded:Connect(function()
	HipReset.Stop()
	HipReset.stop = false
end)

--------------------------------------------------------------------
-- FEATURE: Anti-Ragdoll
--------------------------------------------------------------------
local AntiRagdoll = { enabled = false, bin = newBin() }
function AntiRagdoll.Enable()
	if AntiRagdoll.enabled then return end
	AntiRagdoll.enabled = true
	AntiRagdoll.bin.add(RunService.Heartbeat:Connect(function()
		local hum = getHumanoid()
		if not hum then return end
		pcall(function()
			hum.BreakJointsOnDeath = false
			hum.RequiresNeck = false
			hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			local st = hum:GetState()
			if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
				hum:ChangeState(Enum.HumanoidStateType.Running)
			end
		end)
	end))
end
function AntiRagdoll.Disable()
	AntiRagdoll.enabled = false
	AntiRagdoll.bin.clean()
end

--------------------------------------------------------------------
-- FEATURE: Infinite Jump
--------------------------------------------------------------------
local InfiniteJump = { enabled = false, bin = newBin() }
function InfiniteJump.Enable()
	if InfiniteJump.enabled then return end
	InfiniteJump.enabled = true
	local function boost(root)
		root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 55, root.AssemblyLinearVelocity.Z)
	end
	InfiniteJump.bin.add(UserInputService.JumpRequest:Connect(function()
		local root = getRoot()
		if root then boost(root) end
	end))
	InfiniteJump.bin.add(RunService.Heartbeat:Connect(function()
		local root, hum = getRoot(), getHumanoid()
		if not root then return end
		if (UserInputService:IsKeyDown(Enum.KeyCode.Space) or (hum and hum.Jump)) and root.AssemblyLinearVelocity.Y < 30 then
			boost(root)
		end
	end))
end
function InfiniteJump.Disable()
	InfiniteJump.enabled = false
	InfiniteJump.bin.clean()
end

--------------------------------------------------------------------
-- FEATURE: X-Ray (Plots ausblenden)
--------------------------------------------------------------------
local XRay = {
	active = false, alpha = 0.85, loopId = 0, bin = newBin(),
	originals = setmetatable({}, { __mode = "k" }),
	folders = { "Base", "PlotSign", "FriendPanel", "Cash", "Brainrots", "Decorations", "Skin", "Unlock", "Purchases" },
	lighting = nil,
}

local function fadePart(part, loopId)
	if loopId ~= XRay.loopId or not part:IsA("BasePart") then return end
	if XRay.originals[part] == nil then XRay.originals[part] = part.Transparency end
	local base = XRay.originals[part]
	if base < 1 then
		local target = base + (1 - base) * XRay.alpha
		if math.abs(part.Transparency - target) > 0.01 then part.Transparency = target end
	end
end

local function fadeFolder(folder, loopId)
	for i, d in ipairs(folder:GetDescendants()) do
		fadePart(d, loopId)
		if i % 400 == 0 then
			if loopId ~= XRay.loopId then return end
			RunService.Heartbeat:Wait()
		end
	end
	fadePart(folder, loopId)
	XRay.bin.add(folder.DescendantAdded:Connect(function(d) fadePart(d, loopId) end))
end

local function fadePlot(plot, loopId)
	for _, name in ipairs(XRay.folders) do
		local folder = plot:FindFirstChild(name)
		if folder then task.spawn(fadeFolder, folder, loopId) end
	end
end

function XRay.Enable()
	XRay.bin.clean()
	XRay.loopId += 1
	local loopId = XRay.loopId
	XRay.active = true
	local plots = workspace:FindFirstChild("Plots")
	if not plots then return end
	for _, plot in ipairs(plots:GetChildren()) do fadePlot(plot, loopId) end
	XRay.bin.add(plots.ChildAdded:Connect(function(plot)
		task.wait(0.5)
		if loopId == XRay.loopId then fadePlot(plot, loopId) end
	end))
	if not XRay.lighting then -- nur einmal sichern, sonst wuerde "Disable" falsche Werte herstellen
		XRay.lighting = {
			GlobalShadows = Lighting.GlobalShadows, FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart,
			EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale, EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
		}
	end
	Lighting.GlobalShadows = false
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	Lighting.FogStart, Lighting.FogEnd = 0, 100000
end

function XRay.Disable()
	XRay.active = false
	XRay.loopId += 1
	XRay.bin.clean()
	local originals = XRay.originals
	XRay.originals = setmetatable({}, { __mode = "k" })
	for part, orig in pairs(originals) do
		pcall(function() if part.Parent then part.Transparency = orig end end)
	end
	if XRay.lighting then
		for k, v in pairs(XRay.lighting) do Lighting[k] = v end
		XRay.lighting = nil
	end
end

--------------------------------------------------------------------
-- FEATURE: Slots ESP
--------------------------------------------------------------------
local SlotsESP = { running = false, bin = newBin(), folder = nil, currentPlot = nil, lastScan = 0, queued = false }

local TOP_ROW_SLOTS    = { 11, 12, 13, 14, 15, false, false, 16, 17, 18 }
local BOTTOM_ROW_SLOTS = { 19, 20, 21, 22, 23, 28, 27, 26, 25, 24 }
local ROW_HEIGHT, GROUND_THICKNESS = 8, 0.5

local function getBox(inst)
	inst = inst:FindFirstChild("Base", true) or inst
	if inst:IsA("Model") then
		local ok, cf, size = pcall(function() return inst:GetBoundingBox() end)
		if ok then return cf, size end
	elseif inst:IsA("BasePart") then
		return inst.CFrame, inst.Size
	end
end

local function clusterRows(parent)
	local rows = {}
	for _, child in ipairs(parent:GetChildren()) do
		local cf = getBox(child)
		if cf then
			local y, placed = cf.Position.Y, false
			for _, row in ipairs(rows) do
				if math.abs(row.y - y) <= ROW_HEIGHT then
					row.count += 1
					row.y += (y - row.y) / row.count
					placed = true
					break
				end
			end
			if not placed then table.insert(rows, { y = y, count = 1 }) end
		end
	end
	table.sort(rows, function(a, b) return a.y < b.y end)
	return rows
end

local function slotFree(pos, existing)
	for _, e in ipairs(existing) do
		if Vector2.new(pos.X - e.X, pos.Z - e.Z).Magnitude <= 1.5 and math.abs(pos.Y - e.Y) <= 2 then return false end
	end
	return true
end

local function spawnSlotBox(cframe, size, label)
	local folder = SlotsESP.folder
	if not SlotsESP.running or not folder or not folder.Parent then return end
	local s = size * 0.82
	local marker = new("Part", { Name = "SlotMarker", Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false,
		CastShadow = false, Transparency = 1, Size = s, CFrame = cframe }, folder)
	new("SelectionBox", { Adornee = marker, Color3 = THEME.AccentDark, SurfaceColor3 = THEME.AccentBright, LineThickness = 0.05,
		Transparency = 0.2, SurfaceTransparency = 0.85 }, marker)
	new("Part", { Name = "SlotBase", Anchored = true, CanCollide = true, CanQuery = true, CanTouch = false, CastShadow = false,
		Transparency = 1, Size = Vector3.new(s.X, GROUND_THICKNESS, s.Z),
		CFrame = cframe * CFrame.new(0, -(s.Y - GROUND_THICKNESS) / 2, 0) }, folder)
	if label then
		local bb = new("BillboardGui", { Name = "SlotNum", Adornee = marker, AlwaysOnTop = true, Size = UDim2.fromOffset(46, 24),
			StudsOffset = Vector3.new(0, s.Y / 2 + 1.4, 0), MaxDistance = 140, LightInfluence = 0 }, marker)
		local bg = new("Frame", { BackgroundColor3 = THEME.BgCard, BackgroundTransparency = 0.12, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1) }, bb)
		corner(bg, 6); stroke(bg, THEME.Accent, 1, 0.4)
		new("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "#" .. tostring(label),
			Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = THEME.AccentBright }, bg)
	end
end

local function drawPlotSlots(plot, rowHeight)
	local podium = plot:FindFirstChild("AnimalPodiums")
	if not podium then return end
	local rows = clusterRows(podium)
	if #rows == 0 then return end
	if #rows >= 2 then
		local gap = rows[2].y - rows[1].y
		if gap > ROW_HEIGHT then rowHeight = gap end
	end
	local children = podium:GetChildren()
	table.sort(children, function(a, b) return (tonumber(a.Name) or 0) < (tonumber(b.Name) or 0) end)

	local firstY, primary, positions = rows[1].y, {}, {}
	for _, child in ipairs(children) do
		local cf, size = getBox(child)
		if cf and size and math.abs(cf.Position.Y - firstY) <= ROW_HEIGHT then
			table.insert(primary, { cf = cf, sz = size })
			table.insert(positions, cf.Position)
		end
	end
	local count = math.min(10, #primary)
	for i = 1, count do spawnSlotBox(primary[i].cf, primary[i].sz, i) end

	local function drawRow(slots, rowNum)
		for i = 1, count do
			local slot = slots[i]
			if slot then
				local n = rowHeight * (rowNum - 1)
				if rowNum == 2 then n -= 0.85 end
				local shifted = primary[i].cf + Vector3.new(0, n, 0)
				if slotFree(shifted.Position, positions) then
					spawnSlotBox(shifted, primary[i].sz, slot)
					table.insert(positions, shifted.Position)
				end
			end
		end
	end
	drawRow(TOP_ROW_SLOTS, 2)
	drawRow(BOTTOM_ROW_SLOTS, 3)
end

local function findClosestPlot()
	local root, plots = getRoot(), workspace:FindFirstChild("Plots")
	if not root or not plots then return nil end
	local best, bestDist = nil, math.huge
	for _, plot in ipairs(plots:GetChildren()) do
		local sign = plot:FindFirstChild("PlotSign")
		local model = sign and sign:FindFirstChild("Model")
		if model and model:IsA("Model") then
			local ok, bbox = pcall(function() return model:GetBoundingBox() end)
			if ok then
				local d = Vector2.new(bbox.Position.X - root.Position.X, bbox.Position.Z - root.Position.Z).Magnitude
				if d < bestDist then bestDist, best = d, plot end
			end
		end
	end
	return best
end

local function redrawSlots(plot)
	SlotsESP.currentPlot = plot
	SlotsESP.folder:ClearAllChildren()
	drawPlotSlots(plot, 18)
end

local function queueSlotsRefresh()
	if SlotsESP.queued then return end
	SlotsESP.queued = true
	task.delay(0.4, function()
		SlotsESP.queued = false
		if not SlotsESP.running or not SlotsESP.folder then return end
		local plot = findClosestPlot()
		if not plot then return end
		if plot == SlotsESP.currentPlot and SlotsESP.folder:GetChildren()[1] then return end
		redrawSlots(plot)
	end)
end

function SlotsESP.Start()
	if SlotsESP.running then return end
	SlotsESP.running = true
	SlotsESP.folder = new("Folder", { Name = "SkibidiSlotESP" }, workspace)
	local bin = SlotsESP.bin
	local plots = workspace:FindFirstChild("Plots")
	if plots then
		for _, plot in ipairs(plots:GetChildren()) do
			local podium = plot:FindFirstChild("AnimalPodiums")
			if podium then
				bin.add(podium.ChildAdded:Connect(queueSlotsRefresh))
				bin.add(podium.ChildRemoved:Connect(queueSlotsRefresh))
				bin.add(podium.DescendantAdded:Connect(queueSlotsRefresh))
				bin.add(podium.DescendantRemoving:Connect(queueSlotsRefresh))
			end
		end
		bin.add(plots.DescendantAdded:Connect(queueSlotsRefresh))
		bin.add(plots.DescendantRemoving:Connect(queueSlotsRefresh))
	end
	bin.add(RunService.Heartbeat:Connect(function()
		local now = os.clock()
		if not SlotsESP.running or now - SlotsESP.lastScan < 0.4 then return end
		SlotsESP.lastScan = now
		local plot = findClosestPlot()
		if plot and plot ~= SlotsESP.currentPlot then redrawSlots(plot) end
	end))
	queueSlotsRefresh()
end

function SlotsESP.Stop()
	SlotsESP.running = false
	SlotsESP.bin.clean()
	if SlotsESP.folder then SlotsESP.folder:Destroy() SlotsESP.folder = nil end
	SlotsESP.currentPlot = nil
end

--------------------------------------------------------------------
-- FEATURE: Brainrot ESP
--------------------------------------------------------------------
local BrainrotESP = { running = false, bin = newBin(), cards = {}, screen = nil }

local function brainrotScreen()
	if BrainrotESP.screen and BrainrotESP.screen.Parent then return BrainrotESP.screen end
	local s = new("ScreenGui", { Name = "SkibidiBrainrotESP", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 95 })
	s.Parent = guiRoot()
	BrainrotESP.screen = s
	return s
end

local function createBrainrotCard(adornee, name, gen, key)
	local bb = new("BillboardGui", { Name = "BrainrotESP_" .. key, Adornee = adornee, AlwaysOnTop = true, Size = UDim2.fromOffset(115, 33),
		StudsOffset = Vector3.new(0, 2.6, 0), LightInfluence = 0, MaxDistance = 3000 }, brainrotScreen())
	local card = new("Frame", { Name = "Card", Size = UDim2.fromScale(1, 1), BackgroundColor3 = THEME.BgCard, BackgroundTransparency = 0.12, BorderSizePixel = 0 }, bb)
	corner(card, 7); stroke(card, THEME.Accent, 1, 0.35)
	local function line(y, h, txt, color)
		return new("TextLabel", { Size = UDim2.new(1, -12, 0, h), Position = UDim2.fromOffset(6, y), BackgroundTransparency = 1, Text = txt,
			TextColor3 = color, Font = Enum.Font.GothamBold, TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left,
			TextStrokeTransparency = 0, TextStrokeColor3 = Color3.new(0, 0, 0) }, card)
	end
	BrainrotESP.cards[key] = { billboard = bb, nameLbl = line(4, 18, name, THEME.Text), genLbl = line(22, 16, gen, THEME.AccentBright) }
end

local function updateBrainrotCard(key, name, gen, adornee)
	local c = BrainrotESP.cards[key]
	if not c then return end
	if c.nameLbl.Text ~= name then c.nameLbl.Text = name end
	if c.genLbl.Text ~= gen then c.genLbl.Text = gen end
	if c.billboard.Adornee ~= adornee then c.billboard.Adornee = adornee end
end

local function destroyBrainrotCard(key)
	local c = BrainrotESP.cards[key]
	if c then pcall(function() c.billboard:Destroy() end) BrainrotESP.cards[key] = nil end
end

local function trim(s) return (s:match("^%s*(.-)%s*$")) end

local function refreshBrainrotPlot(plot)
	local podium = plot:FindFirstChild("AnimalPodiums")
	if not podium then return end
	for _, slot in ipairs(podium:GetChildren()) do
		local spawnPart = child_ and nil
		local base = slot:FindFirstChild("Base")
		spawnPart = base and base:FindFirstChild("Spawn")
		local attach = spawnPart and spawnPart:FindFirstChild("PromptAttachment")
		local key = plot.Name .. "_" .. slot.Name
		local objectText = ""
		if attach then
			for _, c in ipairs(attach:GetChildren()) do
				if c:IsA("ProximityPrompt") and c.Enabled and (c.ObjectText or "") ~= "" then objectText = c.ObjectText end
			end
		end
		local host = attach and attach.Parent
		if objectText ~= "" and host and host:IsA("BasePart") then
			local head, tail = objectText:match("^(.-)%s*|%s*(.-)$")
			local displayName = head and trim(head) or objectText
			tail = tail and trim(tail) or ""
			if displayName == "" then displayName = slot.Name end
			if BrainrotESP.cards[key] then updateBrainrotCard(key, displayName, tail, host)
			else createBrainrotCard(host, displayName, tail, key) end
		elseif BrainrotESP.cards[key] then
			destroyBrainrotCard(key)
		end
	end
end

local function fullBrainrotScan()
	local plots = workspace:FindFirstChild("Plots")
	if not plots then return end
	local alive = {}
	for _, plot in ipairs(plots:GetChildren()) do
		local podium = plot:FindFirstChild("AnimalPodiums")
		if podium then for _, slot in ipairs(podium:GetChildren()) do alive[plot.Name .. "_" .. slot.Name] = true end end
		refreshBrainrotPlot(plot)
	end
	for key in pairs(BrainrotESP.cards) do if not alive[key] then destroyBrainrotCard(key) end end
end

function BrainrotESP.Start()
	if BrainrotESP.running then return end
	BrainrotESP.running = true
	local bin = BrainrotESP.bin
	local plots = workspace:FindFirstChild("Plots")
	if plots then
		fullBrainrotScan()
		bin.add(plots.DescendantAdded:Connect(function(d)
			if BrainrotESP.running and d:IsA("ProximityPrompt") then
				task.defer(function()
					local plot = d:FindFirstAncestorWhichIsA("Model")
					if plot then refreshBrainrotPlot(plot) end
				end)
			end
		end))
		bin.add(plots.DescendantRemoving:Connect(function(d)
			if BrainrotESP.running and d:IsA("ProximityPrompt") then task.defer(fullBrainrotScan) end
		end))
		bin.add(plots.ChildAdded:Connect(function() if BrainrotESP.running then task.defer(fullBrainrotScan) end end))
	end
	bin.add(task.spawn(function()
		while BrainrotESP.running do
			task.wait(1.5)
			if BrainrotESP.running then fullBrainrotScan() end
		end
	end))
end

function BrainrotESP.Stop()
	BrainrotESP.running = false
	BrainrotESP.bin.clean()
	for k in pairs(BrainrotESP.cards) do destroyBrainrotCard(k) end
end

--------------------------------------------------------------------
-- FEATURE: Auto Kick
--------------------------------------------------------------------
local AutoKick = { running = false, bin = newBin(), watched = {},
	patterns = { "you stole", "you have stolen", "stole from", "you were kicked" } }

local function kickSelf(reason)
	if pcall(game.Shutdown, game) then return end
	pcall(function() LocalPlayer:Kick("AutoKick: " .. tostring(reason or "steal detected")) end)
end

local function watchLabel(lbl)
	if AutoKick.watched[lbl] then return end
	AutoKick.watched[lbl] = true
	local function check()
		if not AutoKick.running then return end
		local lower = tostring(lbl.Text):lower()
		for _, p in ipairs(AutoKick.patterns) do
			if lower:find(p, 1, true) then kickSelf(p) return end
		end
	end
	check()
	AutoKick.bin.add(lbl:GetPropertyChangedSignal("Text"):Connect(check))
	AutoKick.bin.add(lbl.AncestryChanged:Connect(function()
		if not lbl:IsDescendantOf(game) then AutoKick.watched[lbl] = nil end
	end))
end

function AutoKick.Start()
	if AutoKick.running then return end
	AutoKick.running = true
	local pg = LocalPlayer:FindFirstChild("PlayerGui")
	if not pg then return end
	local function isText(o) return o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") end
	local function attach(root)
		for _, d in ipairs(root:GetDescendants()) do if isText(d) then watchLabel(d) end end
		AutoKick.bin.add(root.DescendantAdded:Connect(function(d) if isText(d) then watchLabel(d) end end))
	end
	for _, c in ipairs(pg:GetChildren()) do if c:IsA("LayerCollector") then attach(c) end end
	AutoKick.bin.add(pg.ChildAdded:Connect(function(c) if c:IsA("LayerCollector") then attach(c) end end))
end

function AutoKick.Stop()
	AutoKick.running = false
	AutoKick.bin.clean()
	AutoKick.watched = {}
end

--------------------------------------------------------------------
-- FEATURE: Steal Boost
--------------------------------------------------------------------
local StealBoost = { enabled = false, bin = newBin(), carryTarget = 28.8, crawlRatio = 0.55, staleTime = 90,
	flag = false, lastToggle = 0, walkSpeed = nil, baseCache = nil, baseline = nil, crawlStart = nil }

function StealBoost:baseSpeed()
	if self.baseCache then return self.baseCache end
	local ok, v = pcall(function() return StarterPlayer.CharacterWalkSpeed end)
	self.baseCache = (ok and type(v) == "number" and v > 0) and v or 34
	return self.baseCache
end

function StealBoost:trackBaseline(speed, now)
	if type(speed) ~= "number" or speed <= 0 then return end
	if self.baseline == nil or speed > self.baseline then
		self.baseline, self.crawlStart = speed, nil
	elseif speed <= self.baseline * self.crawlRatio then
		self.crawlStart = self.crawlStart or now
		if now - self.crawlStart > self.staleTime then self.baseline, self.crawlStart = speed, nil end
	else
		self.crawlStart = nil
		self.baseline += (speed - self.baseline) * 0.05
	end
end

function StealBoost:ceiling()
	local base = self:baseSpeed()
	return (self.baseline and math.min(self.baseline, base) or base) * 0.6 * 1.1
end

function StealBoost:isCarrying()
	return self.walkSpeed ~= nil and self.baseline ~= nil and self.walkSpeed <= self.baseline * self.crawlRatio
end

function StealBoost:reset() self.flag, self.lastToggle = false, 0 end

function StealBoost:tick()
	local hum, root = getHumanoid(), getRoot()
	if not hum or not root then return end
	local st = hum:GetState()
	if hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll
		or st == Enum.HumanoidStateType.FallingDown then return end
	self.walkSpeed = hum.WalkSpeed
	self:trackBaseline(self.walkSpeed, os.clock())
	if not self:isCarrying() then self:reset() return end
	local md = hum.MoveDirection
	if md.Magnitude <= 0 then return end
	local target, useBoost = self.carryTarget, false
	if target <= self:ceiling() then
		self:reset()
	else
		local now = os.clock()
		if self.lastToggle == 0 then self.lastToggle, self.flag = now, true end
		if now - self.lastToggle >= (self.flag and 1.1 or 0.9) then self.flag, self.lastToggle = not self.flag, now end
		useBoost = self.flag
	end
	if useBoost then
		root.AssemblyLinearVelocity = Vector3.new(md.X * target, root.AssemblyLinearVelocity.Y, md.Z * target)
	end
end

function StealBoost.Start()
	if StealBoost.enabled then return true end
	StealBoost.enabled = true
	StealBoost.bin.add(RunService.Heartbeat:Connect(function() pcall(StealBoost.tick, StealBoost) end))
	return true
end
function StealBoost.Stop()
	StealBoost.enabled = false
	StealBoost.bin.clean()
	StealBoost:reset()
end

--------------------------------------------------------------------
-- FEATURE: Carpet Speed
--------------------------------------------------------------------
local CarpetSpeed = { enabled = false, bin = newBin() }

function CarpetSpeed.Start()
	if CarpetSpeed.enabled then return true end
	if not findCarpetTool() then return false end
	CarpetSpeed.enabled = true
	CarpetSpeed.bin.add(RunService.Heartbeat:Connect(function()
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not (hum and root) then return end
		local tool = findCarpetTool()
		if tool and tool.Parent == LocalPlayer:FindFirstChild("Backpack") then hum:EquipTool(tool) end
		local md, y = hum.MoveDirection, root.AssemblyLinearVelocity.Y
		root.AssemblyLinearVelocity = md.Magnitude > 0 and Vector3.new(md.X * 165, y, md.Z * 165) or Vector3.new(0, y, 0)
	end))
	return true
end
function CarpetSpeed.Stop()
	CarpetSpeed.enabled = false
	CarpetSpeed.bin.clean()
	local root = getRoot()
	if root then root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0) end
end

--------------------------------------------------------------------
-- FEATURE: Aimbot
--------------------------------------------------------------------
local Aimbot = { running = false, bin = newBin(), remoteIndex = {}, remoteObjects = {}, useItemRemote = nil, lastShot = 0, cooldown = 0.05 }
local AIM_TOOLS = { ["Web Slinger"] = true, ["Laser Cape"] = true, ["Paintball Gun"] = true }
local AIM_PARTS = { "HumanoidRootPart", "UpperTorso", "Torso", "Head" }

local function refreshAimbotRemotes()
	Aimbot.remoteIndex, Aimbot.remoteObjects = {}, {}
	local ok, list = pcall(function() return ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):GetChildren() end)
	if not ok or not list then return end
	for i, child in ipairs(list) do
		if child:IsA("RemoteEvent") and list[i + 1] then
			Aimbot.remoteIndex[child.Name] = i + 1
			Aimbot.remoteObjects[i + 1] = list[i + 1]
		end
	end
end

local function findUseItemRemote()
	if Aimbot.useItemRemote and Aimbot.useItemRemote.Parent then return Aimbot.useItemRemote end
	local getconstants_ = (debug and debug.getconstants) or getconstants
	if type(getconnections) ~= "function" or type(getconstants_) ~= "function" then return nil end
	local ok, net = pcall(function() return ReplicatedStorage:WaitForChild("Packages", 10):WaitForChild("Net", 10) end)
	if not ok or not net then return nil end
	for _, child in ipairs(net:GetChildren()) do
		if child:IsA("RemoteEvent") then
			local ok2, conns = pcall(getconnections, child.OnClientEvent)
			if ok2 and conns then
				for _, c in ipairs(conns) do
					if type(c.Function) == "function" then
						local ok3, consts = pcall(getconstants_, c.Function)
						if ok3 and consts and table.find(consts, "UseItem") then
							Aimbot.useItemRemote = child
							return child
						end
					end
				end
			end
		end
	end
end

local function fireRemote(name, ...)
	if name == "RE/UseItem" or name == "UseItem" then
		local r = findUseItemRemote()
		if r then r:FireServer(...) return true end
	end
	local idx = Aimbot.remoteIndex[name]
	if idx and Aimbot.remoteObjects[idx] then Aimbot.remoteObjects[idx]:FireServer(...) return true end
	return false
end

local function hasAimTool()
	local char = LocalPlayer.Character
	local tool = char and char:FindFirstChildOfClass("Tool")
	return tool ~= nil and AIM_TOOLS[tool.Name] == true
end

local function nearestTarget(maxDist)
	local root = getRoot()
	if not root then return nil end
	local best, bestDist = nil, maxDist or 800
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			local hum = p.Character:FindFirstChildOfClass("Humanoid")
			local hrp = p.Character:FindFirstChild("HumanoidRootPart")
			if hum and hum.Health > 0 and hrp then
				local d = (hrp.Position - root.Position).Magnitude
				if d < bestDist then bestDist, best = d, p end
			end
		end
	end
	return best
end

local function fireAimbotShot()
	if not hasAimTool() then return end
	local target = nearestTarget()
	local char = target and target.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return end
	local part
	for _, n in ipairs(AIM_PARTS) do part = char:FindFirstChild(n) if part then break end end
	if not part then return end
	local vel = Vector3.zero
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then vel = hrp.AssemblyLinearVelocity end
	local aimPos = part.Position + Vector3.new(0, 0.5, 0) + vel * 0.18
	if not fireRemote("RE/UseItem", aimPos, part) then
		refreshAimbotRemotes()
		fireRemote("RE/UseItem", aimPos, part)
	end
end

local function autoFire()
	local now = os.clock()
	if now - Aimbot.lastShot < Aimbot.cooldown then return end
	Aimbot.lastShot = now
	fireAimbotShot()
end

local function bindCharacter(char)
	local function bindTool(tool) Aimbot.bin.add(tool.Activated:Connect(autoFire)) end
	local tool = char:FindFirstChildOfClass("Tool")
	if tool then bindTool(tool) end
	Aimbot.bin.add(char.ChildAdded:Connect(function(c) if c:IsA("Tool") then bindTool(c) end end))
end

function Aimbot.Start()
	if Aimbot.running then return end
	Aimbot.running = true
	refreshAimbotRemotes()
	Aimbot.bin.add(UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then autoFire() end
	end))
	if LocalPlayer.Character then bindCharacter(LocalPlayer.Character) end
	Aimbot.bin.add(LocalPlayer.CharacterAdded:Connect(bindCharacter))
end
function Aimbot.Stop()
	Aimbot.running = false
	Aimbot.bin.clean()
end

--------------------------------------------------------------------
-- FEATURE: Auto Equip On Slot
--------------------------------------------------------------------
local AutoEquip = { enabled = false, bin = newBin(), humBin = newBin(), onSlot = false, locked = nil }
local TOOL_PRIORITY = { "Santa's Sleigh", "Cupid's Wings", "Flying Carpet", "Witch's Broom", "Waverider", "Flying Bee",
	"Bat", "Iron Slap", "Gold Slap", "Diamond Slap" }

local function isOnSlot()
	local root, plots = getRoot(), workspace:FindFirstChild("Plots")
	if not root or not plots then return false end
	local flat = Vector3.new(root.Position.X, 0, root.Position.Z)
	for _, plot in ipairs(plots:GetChildren()) do
		local podium = plot:FindFirstChild("AnimalPodiums")
		if podium then
			for _, slot in ipairs(podium:GetChildren()) do
				local base = slot:FindFirstChild("Base")
				local sp = base and base:FindFirstChild("Spawn")
				if sp and (flat - Vector3.new(sp.Position.X, 0, sp.Position.Z)).Magnitude <= 4 then return true end
			end
		end
	end
	return false
end

local function pickTool()
	local char, bag = LocalPlayer.Character, LocalPlayer:FindFirstChild("Backpack")
	for _, name in ipairs(TOOL_PRIORITY) do
		for _, container in ipairs({ char, bag }) do
			local t = container and container:FindFirstChild(name)
			if t and t:IsA("Tool") then return t end
		end
	end
	for _, container in ipairs({ char, bag }) do
		if container then
			for _, c in ipairs(container:GetChildren()) do
				if c:IsA("Tool") and c.Name:lower():find("bat") then return c end
			end
		end
	end
end

local function reEquip()
	local hum, locked = getHumanoid(), AutoEquip.locked
	if not hum or not locked or not locked.Parent then return end
	if LocalPlayer.Character:FindFirstChildOfClass("Tool") ~= locked then pcall(function() hum:EquipTool(locked) end) end
end

local function rebindHumanoid(hum)
	AutoEquip.humBin.clean()
	if not hum then return end
	AutoEquip.humBin.add(hum.ChildAdded:Connect(function(c)
		if AutoEquip.enabled and AutoEquip.onSlot and c:IsA("Tool") and AutoEquip.locked and c ~= AutoEquip.locked then
			task.delay(0.03, reEquip)
		end
	end))
	AutoEquip.humBin.add(hum.ChildRemoved:Connect(function(c)
		if AutoEquip.enabled and AutoEquip.onSlot and c == AutoEquip.locked then task.delay(0.05, reEquip) end
	end))
end

function AutoEquip.Start()
	if AutoEquip.enabled then return end
	AutoEquip.enabled = true
	AutoEquip.bin.add(RunService.Heartbeat:Connect(function()
		if not getHumanoid() then return end
		if isOnSlot() then
			if not AutoEquip.locked or not AutoEquip.locked.Parent then AutoEquip.locked = pickTool() end
			if AutoEquip.locked then reEquip() end
			AutoEquip.onSlot = true
		elseif AutoEquip.onSlot then
			AutoEquip.onSlot, AutoEquip.locked = false, nil
		end
	end))
	AutoEquip.bin.add(LocalPlayer.CharacterAdded:Connect(function(char)
		task.wait(0.2)
		rebindHumanoid(char:FindFirstChildOfClass("Humanoid"))
	end))
	rebindHumanoid(getHumanoid())
end
function AutoEquip.Stop()
	AutoEquip.enabled, AutoEquip.onSlot, AutoEquip.locked = false, false, nil
	AutoEquip.bin.clean()
	AutoEquip.humBin.clean()
end

--------------------------------------------------------------------
-- FEATURE: Next Base (Pfeil ueber der naechsten leeren Base)
--------------------------------------------------------------------
local NextBase = { cleanup = nil }
local NEXT_BASE_SLOTS = {
	Vector3.new(-342.439, 10.399, 113.107), Vector3.new(-342.439, 10.465, 7.107),
	Vector3.new(-476.752, 10.465, 114.107), Vector3.new(-476.752, 10.465, 7.107),
	Vector3.new(-342.44, 10.464, 220.107), Vector3.new(-476.752, 10.465, 221.107),
	Vector3.new(-342.439, 10.465, -107.893), Vector3.new(-476.752, 10.465, -107.893),
}

function NextBase.Stop()
	if NextBase.cleanup then pcall(NextBase.cleanup) NextBase.cleanup = nil end
end

function NextBase.Start()
	NextBase.Stop()
	local plots = workspace:WaitForChild("Plots")
	local bin = newBin()
	local slotData, bound = {}, {}
	local accent, outline = Color3.fromRGB(140, 140, 255), Color3.fromRGB(40, 80, 200)

	local function nearestSlot(model)
		local ok, box = pcall(function() return model:GetBoundingBox() end)
		if not ok then return nil end
		local best, bestIdx = math.huge, nil
		for i, sp in ipairs(NEXT_BASE_SLOTS) do
			local d = Vector2.new(box.Position.X - sp.X, box.Position.Z - sp.Z).Magnitude
			if d < best then best, bestIdx = d, i end
		end
		return best <= 6 and bestIdx or nil
	end

	local anchor = bin.add(new("Part", { Name = "NextBaseMarker", Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false,
		Transparency = 1, Size = Vector3.one }, guiRoot()))
	local bb = new("BillboardGui", { Name = "NextBaseLabel", Adornee = anchor, Size = UDim2.fromScale(34, 15), StudsOffset = Vector3.new(0, 11, 0),
		MaxDistance = math.huge, AlwaysOnTop = true, LightInfluence = 0, Enabled = false }, anchor)
	local function line(y, h, txt)
		return new("TextLabel", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, y),
			Size = UDim2.fromScale(1, h), Font = Enum.Font.GothamBlack, Text = txt, TextScaled = true,
			TextColor3 = y < 0.5 and accent or Color3.new(1, 1, 1), TextStrokeColor3 = outline, TextStrokeTransparency = 0 }, bb)
	end
	line(0.3, 0.5, "⬆  NEXT  ⬆")
	line(0.72, 0.42, "EMPTY BASE")

	local function updateArrow()
		for i = 1, #NEXT_BASE_SLOTS do
			local s = slotData[i]
			if s and s.label.Text:match("^%s*(.-)%s*$") == "Empty Base" then
				anchor.CFrame = s.cf
				bb.Enabled = true
				return
			end
		end
		bb.Enabled = false
	end

	local function scan()
		for _, plot in ipairs(plots:GetChildren()) do
			local sign = plot:FindFirstChild("PlotSign")
			local model = sign and sign:FindFirstChild("Model")
			local label = sign and sign:FindFirstChild("SurfaceGui")
			label = label and label:FindFirstChild("Frame")
			label = label and label:FindFirstChild("TextLabel")
			if model and label then
				local idx = nearestSlot(model)
				if idx then
					slotData[idx] = { label = label, cf = (model:GetBoundingBox()) }
					if not bound[label] then
						bound[label] = true
						bin.add(label:GetPropertyChangedSignal("Text"):Connect(updateArrow))
					end
				end
			end
		end
		updateArrow()
	end

	scan()
	bin.add(plots.DescendantAdded:Connect(function(d) if d:IsA("TextLabel") then task.defer(scan) end end))
	bin.add(plots.ChildAdded:Connect(function() task.defer(scan) end))
	NextBase.cleanup = bin.clean
end

--------------------------------------------------------------------
-- Job-ID / Empty-Server-Finder
--------------------------------------------------------------------
local function getJobId()
	local id = tostring(game.JobId)
	return id ~= "" and id or "Reserved Server"
end

local function copyJobId()
	local id, ok = getJobId(), false
	local fn = setclipboard or toclipboard
	if typeof(fn) == "function" then ok = pcall(fn, id) end
	return id, ok
end

local function fetchServerPage(cursor)
	local url = "https://games.roblox.com/v1/games/" .. GAME_PLACE_ID .. "/servers/Public?sortOrder=Asc&limit=100"
	if cursor and cursor ~= "" then url ..= "&cursor=" .. cursor end
	local ok, data = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
	return ok and data or nil
end

-- Waehlt unter Servern mit 1-2 Spielern den mit dem niedrigsten Ping (Feld "ping" der Roblox-API)
local function findEmptyServer()
	local candidates, cursor = {}, ""
	for _ = 1, 10 do
		local page = fetchServerPage(cursor)
		if not page or not page.data then break end
		for _, s in ipairs(page.data) do
			if s.id ~= game.JobId and type(s.playing) == "number" and s.playing > 0 and s.playing <= 2 then
				table.insert(candidates, s)
			end
		end
		cursor = page.nextPageCursor or ""
		if cursor == "" or #candidates >= 45 then break end
		task.wait(0.15)
	end
	if #candidates == 0 then return nil end
	table.sort(candidates, function(a, b)
		local pa, pb = a.ping or math.huge, b.ping or math.huge
		if pa ~= pb then return pa < pb end
		return a.playing < b.playing
	end)
	return candidates[1]
end

--------------------------------------------------------------------
-- Feature-Registry (eine Stelle fuer Toggles, Binds und Autostart)
--------------------------------------------------------------------
local Features = {
	NextBase        = { start = NextBase.Start,        stop = NextBase.Stop },
	AntiRagdoll     = { start = AntiRagdoll.Enable,    stop = AntiRagdoll.Disable },
	CarpetSpeed     = { start = CarpetSpeed.Start,     stop = CarpetSpeed.Stop },
	InfiniteJump    = { start = InfiniteJump.Enable,   stop = InfiniteJump.Disable },
	XRay            = { start = XRay.Enable,           stop = XRay.Disable },
	AutoEquipOnSlot = { start = AutoEquip.Start,       stop = AutoEquip.Stop },
	Aimbot          = { start = Aimbot.Start,          stop = Aimbot.Stop },
	SlotsESP        = { start = SlotsESP.Start,        stop = SlotsESP.Stop },
	BrainrotESP     = { start = BrainrotESP.Start,     stop = BrainrotESP.Stop },
	AutoKick        = { start = AutoKick.Start,        stop = AutoKick.Stop },
	StealBoost      = { start = StealBoost.Start,      stop = StealBoost.Stop },
}
local toggleHandles = {} -- Name -> UI-Toggle (damit Keybinds die UI mitziehen)

local function setFeature(name, on)
	local f = Features[name]
	if not f then return end
	if on then
		local ok, res = pcall(f.start)
		if not ok or res == false then on = false end
	else
		pcall(f.stop)
	end
	CONFIG[name] = on
	if toggleHandles[name] then toggleHandles[name].Set(on) end
	SaveConfig()
end

--------------------------------------------------------------------
-- UI
--------------------------------------------------------------------
local UI = { device = DEVICE }

local function autoScale()
	if DEVICE == "iphone" then return 0.65 end
	if DEVICE == "ipad" then return 0.9 end
	local cam = workspace.CurrentCamera
	local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
	return math.clamp(vp.X / 1920, 0.85, 1.1)
end

function UI.Init()
	destroyOld("SkibidiUnifiedMenu")
	UI.screen = new("ScreenGui", { Name = "SkibidiUnifiedMenu", ResetOnSpawn = false, IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100 })
	UI.screen.Parent = guiRoot()

	local click = new("Sound", { SoundId = "rbxassetid://12221967", Volume = 0.35, PlaybackSpeed = 1.08 }, UI.screen)
	local hooked = setmetatable({}, { __mode = "k" })
	local function hook(o)
		if o:IsA("GuiButton") and not hooked[o] then
			hooked[o] = true
			o.Activated:Connect(function() click.TimePosition = 0 click:Play() end)
		end
	end
	for _, d in ipairs(UI.screen:GetDescendants()) do hook(d) end
	UI.screen.DescendantAdded:Connect(hook)

	UI.manualScale = CONFIG.GuiScale > 0
	UI.scale = new("UIScale", { Scale = UI.manualScale and CONFIG.GuiScale or autoScale() }, UI.screen)
	if workspace.CurrentCamera then
		workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			if not UI.manualScale then UI.scale.Scale = autoScale() end
		end)
	end
end

local function makeDraggable(handle, target, posKey)
	local dragging, startInput, startPos
	handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging, startInput, startPos = true, i.Position, target.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if not dragging then return end
		if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
		local d, s = i.Position - startInput, UI.scale.Scale
		target.Position = UDim2.fromOffset(startPos.X.Offset + d.X / s, startPos.Y.Offset + d.Y / s)
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
		if dragging and posKey then
			CONFIG.Positions[posKey] = { X = target.Position.X.Offset, Y = target.Position.Y.Offset }
			SaveConfig()
		end
		dragging = false
	end)
end

-- Gemeinsamer Fenster-Kopf (Titel, Akzent, Trennlinie)
local function buildWindowChrome(win, title, headerH, withDot)
	local header = new("Frame", { Size = UDim2.new(1, 0, 0, headerH), BackgroundColor3 = THEME.BgCard, BorderSizePixel = 0 }, win)
	corner(header, 13)
	new("Frame", { Position = UDim2.fromOffset(0, headerH - 20), Size = UDim2.new(1, 0, 0, 20), BackgroundColor3 = THEME.BgCard,
		BorderSizePixel = 0, ZIndex = 2 }, win)
	local bar = new("Frame", { Position = UDim2.fromOffset(0, 10), Size = UDim2.fromOffset(3, 26), BackgroundColor3 = THEME.Accent, BorderSizePixel = 0, ZIndex = 3 }, win)
	corner(bar, 3)
	if withDot then
		local dot = new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromOffset(16, 24), Size = UDim2.fromOffset(8, 8),
			BackgroundColor3 = THEME.Accent, BorderSizePixel = 0, ZIndex = 4 }, win)
		corner(dot, 4)
	end
	new("TextLabel", { Position = UDim2.fromOffset(withDot and 32 or 16, 12), Size = UDim2.new(1, -60, 0, 24), BackgroundTransparency = 1,
		Font = Enum.Font.GothamBlack, TextSize = 15, TextColor3 = THEME.Text, TextXAlignment = Enum.TextXAlignment.Left,
		Text = title:upper(), ZIndex = 4 }, win)
	new("Frame", { Position = UDim2.fromOffset(0, headerH), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = THEME.Accent,
		BackgroundTransparency = 0.7, BorderSizePixel = 0, ZIndex = 3 }, win)
	return header
end

function UI.CreateWindow(title, posKey, width)
	local pos = CONFIG.Positions[posKey]
	local win = new("Frame", { Name = (title:gsub("%s+", "")), Position = UDim2.fromOffset(pos.X, pos.Y), Size = UDim2.fromOffset(width, 0),
		AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = THEME.Bg, BorderSizePixel = 0 }, UI.screen)
	corner(win, 13); stroke(win, THEME.Accent, 1.2, 0.4)
	local header = buildWindowChrome(win, title, 48, true)

	local holder = new("Frame", { Name = "Holder", Position = UDim2.fromOffset(8, 56), Size = UDim2.new(1, -20, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 }, win)
	new("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }, holder)
	new("UIPadding", { PaddingBottom = UDim.new(0, 10) }, holder)

	-- Skalier-Griff
	local grip = new("TextButton", { Name = "ResizeGrip", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -4, 0, 4),
		Size = UDim2.fromOffset(20, 24), BackgroundColor3 = THEME.BgCard, BackgroundTransparency = 0.1, Text = "⤡", Font = Enum.Font.GothamBold,
		TextSize = 12, TextColor3 = THEME.AccentBright, AutoButtonColor = false, ZIndex = 6 }, win)
	corner(grip, 6); stroke(grip, THEME.Accent, 1, 0.5)
	grip.MouseEnter:Connect(function() tween(grip, 0.12, { BackgroundColor3 = THEME.BtnBgHover }) end)
	grip.MouseLeave:Connect(function() tween(grip, 0.12, { BackgroundColor3 = THEME.BgCard }) end)

	makeDraggable(header, win, posKey)

	local scaling, startPos, startVal = false, nil, nil
	grip.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			scaling, startPos, startVal = true, i.Position, UI.scale.Scale
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if not scaling then return end
		if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
		local d = i.Position - startPos
		UI.scale.Scale = math.clamp(startVal + (d.X + d.Y) * 0.0016, 0.4, 1.6)
		CONFIG.GuiScale, UI.manualScale = UI.scale.Scale, true
	end)
	UserInputService.InputEnded:Connect(function(i)
		if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) and scaling then
			scaling = false
			SaveConfig()
		end
	end)
	return win, holder
end

function UI.AddToggle(parent, label, initial, callback)
	local row = new("Frame", { Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = THEME.BgRow, BorderSizePixel = 0 }, parent)
	corner(row, 9)
	local rowStroke = stroke(row, THEME.StrokeSoft, 1, 0.72)
	local indicator = new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 12, 0.5, 0), Size = UDim2.fromOffset(6, 6), BorderSizePixel = 0 }, row)
	corner(indicator, 3)
	local text = new("TextLabel", { Position = UDim2.fromOffset(24, 0), Size = UDim2.new(1, -80, 1, 0), BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Text = label }, row)
	local track = new("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(44, 22), BorderSizePixel = 0 }, row)
	corner(track, 11)
	local knob = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(16, 16), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0 }, track)
	corner(knob, 8); stroke(knob, Color3.new(0, 0, 0), 1, 0.85)
	local hit = new("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(60, 34),
		ZIndex = 10, BackgroundTransparency = 1, Text = "", AutoButtonColor = false }, row)

	local state = initial
	local function render(s, instant)
		local t = instant and 0 or 0.18
		tween(track, t, { BackgroundColor3 = s and THEME.TrackOn or THEME.TrackOff })
		tween(knob, instant and 0 or 0.2, { Position = s and UDim2.new(1, -11, 0.5, 0) or UDim2.new(0, 11, 0.5, 0) }, Enum.EasingStyle.Back)
		tween(indicator, t, { BackgroundColor3 = s and THEME.Accent or Color3.fromRGB(55, 50, 75) })
		tween(text, t, { TextColor3 = s and THEME.Text or THEME.TextDim })
	end
	render(state, true)

	hit.MouseButton1Click:Connect(function()
		state = not state
		render(state)
		callback(state)
	end)
	row.MouseEnter:Connect(function()
		tween(row, 0.12, { BackgroundColor3 = THEME.BgRowHover })
		tween(rowStroke, 0.12, { Color = THEME.Accent, Transparency = 0.5 })
	end)
	row.MouseLeave:Connect(function()
		tween(row, 0.12, { BackgroundColor3 = THEME.BgRow })
		tween(rowStroke, 0.12, { Color = THEME.StrokeSoft, Transparency = 0.72 })
	end)
	return { Set = function(s) state = s render(s) end, Get = function() return state end }
end

function UI.AddButton(parent, label, textColor, bg, hover, callback)
	local btn = new("TextButton", { Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = bg, Text = label, AutoButtonColor = false,
		Font = Enum.Font.GothamBlack, TextSize = 13, TextColor3 = textColor }, parent)
	corner(btn, 9)
	local st = stroke(btn, textColor, 1, 0.6)
	local scale = new("UIScale", { Scale = 1 }, btn)
	btn.MouseEnter:Connect(function() tween(btn, 0.12, { BackgroundColor3 = hover }) tween(st, 0.12, { Transparency = 0.2, Thickness = 1.3 }) end)
	btn.MouseLeave:Connect(function() tween(btn, 0.12, { BackgroundColor3 = bg }) tween(st, 0.12, { Transparency = 0.6, Thickness = 1 }) end)
	btn.MouseButton1Down:Connect(function()
		tween(scale, 0.07, { Scale = 0.96 })
		tween(btn, 0.07, { BackgroundColor3 = textColor, TextColor3 = bg })
	end)
	btn.MouseButton1Up:Connect(function()
		tween(scale, 0.14, { Scale = 1 }, Enum.EasingStyle.Back)
		tween(btn, 0.1, { BackgroundColor3 = hover })
		tween(btn, 0.2, { TextColor3 = textColor })
	end)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

local function splitRow(parent, leftBtn, rightBtn)
	leftBtn.Parent, rightBtn.Parent = parent, parent
	leftBtn.Size, rightBtn.Size = UDim2.new(0.5, -3, 1, 0), UDim2.new(0.5, -3, 1, 0)
	leftBtn.Position, rightBtn.Position = UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 3, 0, 0)
end

--------------------------------------------------------------------
-- Public HUD (FPS / Ping)
--------------------------------------------------------------------
local function createHUD()
	destroyOld("SkibidiPublicHUD")
	local screen = new("ScreenGui", { Name = "SkibidiPublicHUD", ResetOnSpawn = false, IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100 })
	screen.Parent = guiRoot()

	local bottom = (DEVICE == "iphone" and -150) or (DEVICE == "ipad" and -110) or -86
	local strip = new("Frame", { AnchorPoint = Vector2.new(0.5, 1), Size = UDim2.fromOffset(540, 44), Position = UDim2.new(0.5, 0, 1, bottom),
		BackgroundColor3 = THEME.Bg, BorderSizePixel = 0 }, screen)
	corner(strip, 22)
	local edge = stroke(strip, THEME.Accent, 1.3, 0.3)
	local function dot(x)
		local d = new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, x, 0.5, 0), Size = UDim2.fromOffset(9, 9),
			BackgroundColor3 = THEME.Accent, BorderSizePixel = 0 }, strip)
		corner(d, 8)
	end
	dot(18)
	local function label(x, y, w, h, txt, size, color, font)
		return new("TextLabel", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, x, 0.5, y), Size = UDim2.fromOffset(w, h),
			BackgroundTransparency = 1, Font = font or Enum.Font.GothamBold, TextSize = size, TextColor3 = color,
			TextXAlignment = Enum.TextXAlignment.Left, Text = txt }, strip)
	end
	local function divider(x)
		new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, x, 0.5, 0), Size = UDim2.fromOffset(1, 22),
			BackgroundColor3 = THEME.AccentDark, BackgroundTransparency = 0.3, BorderSizePixel = 0 }, strip)
	end
	label(34, 0, 160, 24, HUD_BRAND, 15, THEME.Text, Enum.Font.GothamBlack)
	divider(205)
	label(220, 0, 200, 24, HUD_LINK, 13, THEME.AccentBright)
	divider(415)
	label(430, -8, 50, 12, "FPS", 10, THEME.TextMuted)
	local fpsValue = label(430, 8, 50, 18, "0", 15, Color3.fromRGB(70, 220, 110), Enum.Font.GothamBlack)
	label(485, -8, 60, 12, "PING", 10, THEME.TextMuted)
	local pingValue = label(485, 8, 70, 18, "0ms", 15, Color3.fromRGB(70, 220, 110), Enum.Font.GothamBlack)

	local frames, windowStart, fps = 0, os.clock(), 0
	local hb = RunService.Heartbeat:Connect(function()
		frames += 1
		local now = os.clock()
		if now - windowStart >= 0.5 then
			fps = math.floor(frames / (now - windowStart) + 0.5)
			frames, windowStart = 0, now
		end
	end)
	screen.Destroying:Connect(function() hb:Disconnect() end)

	local function readPing()
		local ok, v = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
		if ok and v and v > 0 then return math.floor(v) end
		local ok2, v2 = pcall(function() return LocalPlayer:GetNetworkPing() * 1000 end)
		return (ok2 and v2) and math.floor(v2) or 0
	end
	local green, amber, red = Color3.fromRGB(70, 220, 110), Color3.fromRGB(255, 190, 70), Color3.fromRGB(255, 90, 110)
	task.spawn(function()
		while screen.Parent do
			fpsValue.Text = tostring(fps)
			fpsValue.TextColor3 = fps >= 60 and green or (fps >= 30 and amber or red)
			local ms = readPing()
			pingValue.Text = ms .. "ms"
			pingValue.TextColor3 = ms < 80 and green or (ms < 150 and amber or red)
			task.wait(0.5)
		end
	end)
	task.spawn(function()
		while screen.Parent do
			tween(edge, 1.4, { Transparency = 0.65 }, Enum.EasingStyle.Sine)
			task.wait(1.4)
			tween(edge, 1.4, { Transparency = 0.2 }, Enum.EasingStyle.Sine)
			task.wait(1.4)
		end
	end)
	return screen
end

--------------------------------------------------------------------
-- Fenster aufbauen
--------------------------------------------------------------------
UI.Init()
local hud = createHUD()
task.spawn(function()
	while true do
		task.wait(1)
		if not hud or not hud.Parent then hud = createHUD() else hud.Enabled = true end
	end
end)

local gearWindow, gearHolder = UI.CreateWindow("Skibidi Gear & Safety", "GearSafety", 270)
local jobWindow, jobHolder = UI.CreateWindow("Skibidi Job ID", "JobId", 270)

-- Gear & Safety
local TOGGLE_LIST = {
	{ "InfiniteJump", "Infinite Jump" }, { "AntiRagdoll", "Anti Ragdoll" }, { "XRay", "X-Ray" }, { "SlotsESP", "Slots ESP" },
	{ "BrainrotESP", "Brainrot ESP" }, { "NextBase", "Next Base" }, { "AutoEquipOnSlot", "Auto Equip Slot" },
	{ "Aimbot", "Aimbot" }, { "AutoKick", "Auto Kick" }, { "StealBoost", "Steal Boost" },
}
for _, entry in ipairs(TOGGLE_LIST) do
	local name = entry[1]
	toggleHandles[name] = UI.AddToggle(gearHolder, entry[2], CONFIG[name], function(on) setFeature(name, on) end)
end

local actionRow = new("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1 }, gearHolder)
splitRow(actionRow,
	UI.AddButton(gearHolder, "Instant Reset", THEME.ResetAccent, THEME.ResetBg, THEME.ResetBgHover, HipReset.Run),
	UI.AddButton(gearHolder, "Drop", THEME.DropAccent, THEME.DropBg, THEME.DropBgHover, Drop.Run))

local bindsWindow -- forward
UI.AddButton(gearHolder, "Binds", THEME.AccentBright, THEME.BtnBg, THEME.BtnBgHover, function()
	if bindsWindow then bindsWindow.Visible = not bindsWindow.Visible end
end)

-- Job ID
local jobCard = new("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = THEME.BgCard, BorderSizePixel = 0 }, jobHolder)
corner(jobCard, 9); stroke(jobCard, THEME.StrokeSoft, 1, 0.55)
local HIDDEN_ID = string.rep("•", 36)
local jobLabel = new("TextLabel", { Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(8, 0), BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = THEME.Text, TextTruncate = Enum.TextTruncate.AtEnd,
	Text = CONFIG.ShowJobId and getJobId() or HIDDEN_ID }, jobCard)

local jobBtnRow = new("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1 }, jobHolder)
local copyBtn, showBtn
copyBtn = UI.AddButton(jobHolder, "Copy", THEME.AccentBright, THEME.BtnBg, THEME.BtnBgHover, function()
	local id, ok = copyJobId()
	copyBtn.Text = ok and "Copied!" or "Failed"
	jobLabel.Text = id
	task.delay(1.2, function() if copyBtn.Parent then copyBtn.Text = "Copy" end end)
end)
showBtn = UI.AddButton(jobHolder, CONFIG.ShowJobId and "Hide" or "Show", THEME.AccentBright, THEME.BtnBg, THEME.BtnBgHover, function()
	CONFIG.ShowJobId = not CONFIG.ShowJobId
	jobLabel.Text = CONFIG.ShowJobId and getJobId() or HIDDEN_ID
	showBtn.Text = CONFIG.ShowJobId and "Hide" or "Show"
	SaveConfig()
end)
splitRow(jobBtnRow, copyBtn, showBtn)

-- Empty Server Finder (aufklappbares Panel)
local EmptyFinder = { state = "closed", busy = false, found = nil }
local panel, efTitle, efSub, efYes, efNo

local function efUpdate(title, sub, yesText, noText)
	efTitle.Text, efSub.Text, efYes.Text, efNo.Text = title, sub, yesText, noText or "NO"
	local searching = yesText == "SEARCHING..." or yesText == "TELEPORTING..."
	efNo.Visible = not searching
	efYes.Active = not searching
	efYes.Position = UDim2.fromOffset(10, 58)
	efYes.Size = searching and UDim2.new(1, -20, 0, 32) or UDim2.new(0.5, -15, 0, 32)
end

function EmptyFinder.show(state)
	EmptyFinder.state, EmptyFinder.found, EmptyFinder.busy = state, nil, false
	if state == "rebirth" then efUpdate("ARE YOU SURE?", "YOU HAVE TO BE 0 REBIRTH", "YES", "NO")
	elseif state == "warning" then efUpdate("ARE YOU SURE?", "YOU MIGHT BE OVER 100 PING OR HIGHER", "TELEPORT ME", "NO")
	elseif state == "searching" then efUpdate("SEARCHING...", "FINDING A LOW-POPULATION SERVER", "SEARCHING...", "CANCEL") end
	tween(panel, 0.18, { Size = UDim2.new(1, 0, 0, 100) }, Enum.EasingStyle.Quad)
end
function EmptyFinder.hide()
	EmptyFinder.state, EmptyFinder.found, EmptyFinder.busy = "closed", nil, false
	tween(panel, 0.16, { Size = UDim2.new(1, 0, 0, 1) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
end

UI.AddButton(jobHolder, "Empty Server Finder", THEME.AccentBright, THEME.BtnBg, THEME.BtnBgHover, function()
	if EmptyFinder.state == "closed" then EmptyFinder.show("rebirth") else EmptyFinder.hide() end
end)

panel = new("Frame", { Name = "EmptyServerFinderInline", Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = THEME.BgCard, BorderSizePixel = 0,
	ClipsDescendants = true, ZIndex = 10 }, jobHolder)
corner(panel, 8); stroke(panel, THEME.StrokeSoft, 1, 0.5)
efTitle = new("TextLabel", { Position = UDim2.fromOffset(8, 9), Size = UDim2.new(1, -16, 0, 20), BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack, TextSize = 12, TextColor3 = THEME.Text, ZIndex = 11 }, panel)
efSub = new("TextLabel", { Position = UDim2.fromOffset(10, 30), Size = UDim2.new(1, -20, 0, 24), BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = THEME.TextDim, TextWrapped = true, ZIndex = 11 }, panel)
efYes = new("TextButton", { Position = UDim2.fromOffset(10, 58), Size = UDim2.new(0.5, -15, 0, 32), BackgroundColor3 = THEME.TrackOn,
	TextColor3 = THEME.Text, Font = Enum.Font.GothamBlack, TextSize = 11, AutoButtonColor = false, ZIndex = 11 }, panel)
corner(efYes, 9)
efNo = new("TextButton", { Position = UDim2.new(0.5, 5, 0, 58), Size = UDim2.new(0.5, -15, 0, 32), BackgroundColor3 = THEME.BgRow,
	TextColor3 = THEME.TextDim, Font = Enum.Font.GothamBlack, TextSize = 11, AutoButtonColor = false, ZIndex = 11 }, panel)
corner(efNo, 9)

efNo.Activated:Connect(EmptyFinder.hide)
efYes.Activated:Connect(function()
	if EmptyFinder.busy then return end
	if EmptyFinder.state == "rebirth" then
		EmptyFinder.show("warning")
		return
	end
	if EmptyFinder.state ~= "warning" then return end
	EmptyFinder.show("searching")
	EmptyFinder.busy = true
	task.spawn(function()
		local srv = findEmptyServer()
		if not panel.Parent or EmptyFinder.state ~= "searching" then return end
		if srv then
			EmptyFinder.found = srv
			local ping = srv.ping and ("PING " .. math.floor(srv.ping) .. "MS") or "PING N/A"
			efUpdate("SERVER FOUND", string.format("%d PLAYER(S) • %s", srv.playing, ping), "TELEPORTING...", "CANCEL")
			task.wait(0.25)
			if EmptyFinder.found and EmptyFinder.state == "searching" then
				TeleportService:TeleportToPlaceInstance(GAME_PLACE_ID, EmptyFinder.found.id, LocalPlayer)
			end
		else
			EmptyFinder.show("warning")
			efUpdate("NO SUITABLE SERVER", "TRY AGAIN?", "TELEPORT ME", "NO")
		end
	end)
end)

--------------------------------------------------------------------
-- Binds-Fenster
--------------------------------------------------------------------
local bindCapture = false -- true, solange eine Taste neu belegt wird (Hotkeys pausieren)

bindsWindow = new("Frame", { Name = "BindsWindow", Position = UDim2.fromOffset(CONFIG.Positions.BindsWindow.X, CONFIG.Positions.BindsWindow.Y),
	Size = UDim2.fromOffset(320, 360), BackgroundColor3 = THEME.Bg, BorderSizePixel = 0, Visible = false, ZIndex = 200 }, UI.screen)
corner(bindsWindow, 14); stroke(bindsWindow, THEME.Accent, 1.2, 0.4)
local bindsHeader = buildWindowChrome(bindsWindow, "Binds", 46, false)
makeDraggable(bindsHeader, bindsWindow, "BindsWindow")

local closeBtn = new("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0, 23), Size = UDim2.fromOffset(24, 24),
	BackgroundColor3 = THEME.BgRow, Text = "×", Font = Enum.Font.GothamBold, TextSize = 18, TextColor3 = THEME.TextDim,
	AutoButtonColor = false, ZIndex = 5 }, bindsWindow)
corner(closeBtn, 7); stroke(closeBtn, THEME.StrokeSoft, 1, 0.65)
closeBtn.MouseEnter:Connect(function() tween(closeBtn, 0.12, { BackgroundColor3 = THEME.ResetBg, TextColor3 = THEME.ResetAccent }) end)
closeBtn.MouseLeave:Connect(function() tween(closeBtn, 0.12, { BackgroundColor3 = THEME.BgRow, TextColor3 = THEME.TextDim }) end)
closeBtn.MouseButton1Click:Connect(function() bindsWindow.Visible = false end)

local bindsScroll = new("ScrollingFrame", { Position = UDim2.fromOffset(10, 54), Size = UDim2.new(1, -20, 1, -66), BackgroundTransparency = 1,
	BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = THEME.Accent, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
	Active = true }, bindsWindow)
new("UIListLayout", { Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder }, bindsScroll)

local function addBindRow(label, configKey)
	local row = new("Frame", { Size = UDim2.new(1, -4, 0, 42), BackgroundColor3 = THEME.BgRow, BorderSizePixel = 0 }, bindsScroll)
	corner(row, 9); stroke(row, THEME.StrokeSoft, 1, 0.72)
	new("TextLabel", { Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -100, 1, 0), BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
		TextSize = 14, TextColor3 = THEME.Text, TextXAlignment = Enum.TextXAlignment.Left, Text = label }, row)
	local keyBtn = new("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(66, 26),
		BackgroundColor3 = THEME.BtnBg, Text = CONFIG[configKey], AutoButtonColor = false, Font = Enum.Font.GothamBlack, TextSize = 13,
		TextColor3 = THEME.AccentBright }, row)
	corner(keyBtn, 8)
	local keyStroke = stroke(keyBtn, THEME.AccentBright, 1, 0.55)

	local listening = false
	keyBtn.MouseButton1Click:Connect(function()
		if listening then return end
		listening, bindCapture = true, true
		keyBtn.Text, keyBtn.TextColor3 = "...", THEME.ResetAccent
		tween(keyStroke, 0.15, { Color = THEME.ResetAccent, Transparency = 0.15 })
		local conn
		conn = UserInputService.InputBegan:Connect(function(input, gp)
			if gp or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
			conn:Disconnect()
			listening = false
			task.defer(function() bindCapture = false end) -- erst nach diesem Tastendruck wieder Hotkeys erlauben
			if input.KeyCode ~= Enum.KeyCode.Escape then CONFIG[configKey] = input.KeyCode.Name SaveConfig() end
			keyBtn.Text, keyBtn.TextColor3 = CONFIG[configKey], THEME.AccentBright
			tween(keyStroke, 0.15, { Color = THEME.AccentBright, Transparency = 0.55 })
		end)
	end)
	keyBtn.MouseEnter:Connect(function() tween(keyBtn, 0.12, { BackgroundColor3 = THEME.BtnBgHover }) end)
	keyBtn.MouseLeave:Connect(function() tween(keyBtn, 0.12, { BackgroundColor3 = THEME.BtnBg }) end)
	row.MouseEnter:Connect(function() tween(row, 0.12, { BackgroundColor3 = THEME.BgRowHover }) end)
	row.MouseLeave:Connect(function() tween(row, 0.12, { BackgroundColor3 = THEME.BgRow }) end)
end

-- Hotkey-Aktionen: Bind-Schluessel -> Aktion
local HOTKEYS = {
	{ "Bind_CarpetSpeed", "Carpet Speed", function() setFeature("CarpetSpeed", not CONFIG.CarpetSpeed) end },
	{ "Bind_InstantReset", "Instant Reset", HipReset.Run },
	{ "Bind_Drop", "Drop", Drop.Run },
	{ "Bind_Aimbot", "Aimbot", function() setFeature("Aimbot", not CONFIG.Aimbot) end },
	{ "Bind_AutoKick", "Auto Kick", function() setFeature("AutoKick", not CONFIG.AutoKick) end },
	{ "Bind_StealBoost", "Steal Boost", function() setFeature("StealBoost", not CONFIG.StealBoost) end },
}
for _, h in ipairs(HOTKEYS) do addBindRow(h[2], h[1]) end

UserInputService.InputBegan:Connect(function(input, gp)
	if gp or bindCapture or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	local key = input.KeyCode.Name
	for _, h in ipairs(HOTKEYS) do
		if key == CONFIG[h[1]] then h[3]() return end
	end
end)

--------------------------------------------------------------------
-- Autostart gespeicherter Features
--------------------------------------------------------------------
task.spawn(function()
	repeat task.wait(0.2) until game:IsLoaded()
	if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end
	task.wait(1)
	for name, f in pairs(Features) do
		if CONFIG[name] then
			if name == "CarpetSpeed" then task.wait(0.5) end
			local ok, res = pcall(f.start)
			if name == "CarpetSpeed" and (not ok or res == false) then
				CONFIG.CarpetSpeed = false
				SaveConfig()
			end
		end
	end
end)

-- Nach Respawn: Carpet Speed wieder starten, falls aktiviert
LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1.5)
	if CONFIG.CarpetSpeed and not CarpetSpeed.enabled then setFeature("CarpetSpeed", true) end
end)

print("[skibidi] loaded - device:", DEVICE, "scale:", string.format("%.2f", UI.scale.Scale))