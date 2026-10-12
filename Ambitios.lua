-- This source was made and leaked by VaLe discord.gg/ambitiouss
-- This source was made and leaked by VaLe discord.gg/ambitiouss
-- This source was made and leaked by VaLe discord.gg/ambitiouss
-- This source was made and leaked by VaLe discord.gg/ambitiouss
-- This source was made and leaked by VaLe discord.gg/ambitiouss
-- This source was made and leaked by VaLe discord.gg/ambitiouss
-- This source was made and leaked by VaLe discord.gg/ambitiouss
-- This source was made and leaked by VaLe discord.gg/ambitiouss
-- This source was made and leaked by VaLe discord.gg/ambitiouss
-- This source was made and leaked by VaLe discord.gg/ambitiouss
-- Deleting the comments above will result in copyright and legal issues
-- Deleting the comments above will result in copyright and legal issues

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local RunService       = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
	task.wait()
	LocalPlayer = Players.LocalPlayer
end

local CONFIG = {
	guiName       = "LiveControllerOverlay",
	saveFile      = "live_controlleroverlay.json",
	attributeName = "LiveControllerOverlayState",

	uiScale       = 1.5,

	toggleKey       = Enum.KeyCode.F8,
	hideWhileTyping = true,

	stickDeadzone   = 0.08,
	stickSmoothing  = 0.55,
	triggerSmooth   = 0.65,
	triggerDeadzone = 0.02,

	fadeIn        = 0.03,
	fadeOut       = 0.11,

	defaultPos    = Vector2.new(0.025, 0.62),
}

local THEME = {
	panelFill    = Color3.fromRGB(0, 0, 0),
	panelIdle    = 0.45,

	keyFill      = Color3.fromRGB(0, 0, 0),
	keyIdle      = 0.28,

	pressFill    = Color3.fromRGB(255, 255, 255),
	pressIdle    = 0.04,
	stickPress   = 0.72,

	line         = Color3.fromRGB(255, 255, 255),
	lineIdle     = 0.30,
	lineActive   = 0.00,

	textIdle     = Color3.fromRGB(245, 245, 245),
	textActive   = Color3.fromRGB(10, 10, 10),
	textStroke   = 0.55,

	headerIdle   = 0.35,
	headerLocked = 1.00,

	font         = Enum.Font.GothamBold,
	fontCaption  = Enum.Font.Gotham,
}

local BODY_WIDTH  = 296
local BODY_HEIGHT = 146

local LAYOUT = {
	{ id = "ButtonL2", label = "L2", x = 0,   y = 0,  w = 86, h = 22, analog = true },
	{ id = "ButtonR2", label = "R2", x = 210, y = 0,  w = 86, h = 22, analog = true, fillFrom = "right" },

	{ id = "ButtonL1", label = "L1", x = 0,   y = 26, w = 86, h = 20 },
	{ id = "ButtonR1", label = "R1", x = 210, y = 26, w = 86, h = 20 },

	{ id = "DPadUp",    label = "↑", x = 31, y = 61,  w = 26, h = 26 },
	{ id = "DPadLeft",  label = "←", x = 4,  y = 88,  w = 26, h = 26 },
	{ id = "DPadRight", label = "→", x = 58, y = 88,  w = 26, h = 26 },
	{ id = "DPadDown",  label = "↓", x = 31, y = 115, w = 26, h = 26 },

	{ id = "ButtonY", label = "Y", x = 239, y = 61,  w = 26, h = 26, circle = true },
	{ id = "ButtonX", label = "X", x = 212, y = 88,  w = 26, h = 26, circle = true },
	{ id = "ButtonB", label = "B", x = 266, y = 88,  w = 26, h = 26, circle = true },
	{ id = "ButtonA", label = "A", x = 239, y = 115, w = 26, h = 26, circle = true },

	{ id = "ButtonSelect", label = "SELECT", x = 96,  y = 52, w = 48, h = 15 },
	{ id = "ButtonStart",  label = "START",  x = 152, y = 52, w = 48, h = 15 },
}

local STICKS = {
	{ id = "Thumbstick1", click = "ButtonL3", cx = 120, cy = 106, radius = 24, caption = "L3" },
	{ id = "Thumbstick2", click = "ButtonR3", cx = 176, cy = 106, radius = 24, caption = "R3" },
}

local Connections = {}

local function track(conn)
	table.insert(Connections, conn)
	return conn
end

local function new(class, props, children)
	local inst = Instance.new(class)
	for key, value in pairs(props or {}) do
		if key ~= "Parent" then
			inst[key] = value
		end
	end
	for _, child in ipairs(children or {}) do
		child.Parent = inst
	end
	if props and props.Parent then
		inst.Parent = props.Parent
	end
	return inst
end

local function tween(inst, duration, props)
	TweenService:Create(
		inst,
		TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		props
	):Play()
end

local Store = {}
Store.hasFileSystem = (typeof(writefile) == "function")
	and (typeof(readfile) == "function")
	and (typeof(isfile) == "function")

function Store.read()
	local raw
	if Store.hasFileSystem then
		local ok, result = pcall(function()
			return isfile(CONFIG.saveFile) and readfile(CONFIG.saveFile) or nil
		end)
		raw = ok and result or nil
	else
		local ok, result = pcall(function()
			return LocalPlayer:GetAttribute(CONFIG.attributeName)
		end)
		raw = ok and result or nil
	end
	if type(raw) ~= "string" then
		return {}
	end
	local ok, decoded = pcall(HttpService.JSONDecode, HttpService, raw)
	return (ok and type(decoded) == "table") and decoded or {}
end

function Store.write(data)
	local ok, raw = pcall(HttpService.JSONEncode, HttpService, data)
	if not ok then
		return
	end
	if Store.hasFileSystem then
		pcall(writefile, CONFIG.saveFile, raw)
	else
		pcall(function()
			LocalPlayer:SetAttribute(CONFIG.attributeName, raw)
		end)
	end
end

local SavedState = Store.read()

local savePending = false
local function requestSave()
	if savePending then
		return
	end
	savePending = true
	task.delay(0.25, function()
		savePending = false
		Store.write(SavedState)
	end)
end

local ENV = (typeof(getgenv) == "function" and getgenv()) or _G
if type(ENV.__LiveControllerOverlay) == "table" and type(ENV.__LiveControllerOverlay.destroy) == "function" then
	pcall(ENV.__LiveControllerOverlay.destroy)
end

local function resolveParent()
	if typeof(gethui) == "function" then
		local ok, hidden = pcall(gethui)
		if ok and hidden then
			return hidden
		end
	end
	local ok, coreGui = pcall(function()
		return game:GetService("CoreGui")
	end)
	if ok and coreGui then
		local probe = Instance.new("Folder")
		local parented = pcall(function()
			probe.Parent = coreGui
		end)
		probe:Destroy()
		if parented then
			return coreGui
		end
	end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local guiParent = resolveParent()

local previous = guiParent:FindFirstChild(CONFIG.guiName)
if previous then
	previous:Destroy()
end

local screen = new("ScreenGui", {
	Name = CONFIG.guiName,
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = 9999,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = guiParent,
})

local Cell = {}
Cell.__index = Cell

function Cell.new(fill, stroke, label)
	return setmetatable({
		fill = fill,
		stroke = stroke,
		label = label,
		active = false,
	}, Cell)
end

function Cell:setActive(on)
	if self.active == on then
		return
	end
	self.active = on

	local duration = on and CONFIG.fadeIn or CONFIG.fadeOut
	local pressed = self.pressTransparency or THEME.pressIdle

	if self.fill and not self.analog then
		tween(self.fill, duration, {
			BackgroundTransparency = on and pressed or 1,
		})
	end
	if self.stroke then
		tween(self.stroke, duration, {
			Transparency = on and THEME.lineActive or THEME.lineIdle,
		})
	end
	if self.label and not self.analog then
		tween(self.label, duration, {
			TextColor3 = on and THEME.textActive or THEME.textIdle,
			TextStrokeTransparency = on and 1 or THEME.textStroke,
		})
	end
	if self.dot then
		self.dot.BackgroundTransparency = on and 0 or 0.15
	end
end

function Cell:flash(duration)
	self.flashToken = (self.flashToken or 0) + 1
	local token = self.flashToken
	self:setActive(true)
	task.delay(duration, function()
		if self.flashToken == token then
			self:setActive(false)
		end
	end)
end

function Cell:setAnalog(value)
	if not self.fill then
		return
	end
	value = math.clamp(value, 0, 1)
	self.fill.Size = UDim2.fromScale(value, 1)
	self.fill.BackgroundTransparency = value > CONFIG.triggerDeadzone and THEME.pressIdle or 1
	if self.label then
		local covered = value > 0.55
		self.label.TextColor3 = covered and THEME.textActive or THEME.textIdle
		self.label.TextStrokeTransparency = covered and 1 or THEME.textStroke
	end
	if self.stroke then
		self.stroke.Transparency = value > CONFIG.triggerDeadzone
			and (THEME.lineIdle - value * (THEME.lineIdle - THEME.lineActive))
			or THEME.lineIdle
	end
end

function Cell:setStick(x, y)
	if not self.dot then
		return
	end
	local vec = Vector2.new(x, y)
	if vec.Magnitude < CONFIG.stickDeadzone then
		vec = Vector2.zero
	elseif vec.Magnitude > 1 then
		vec = vec.Unit
	end
	self.dot.Position = UDim2.new(0.5, vec.X * self.stickRadius, 0.5, -vec.Y * self.stickRadius)
	if not self.active then
		self.dot.BackgroundTransparency = 0.2 - math.min(vec.Magnitude, 1) * 0.2
	end
end

local function makeKey(parent, def)
	local corner = def.circle and UDim.new(1, 0) or UDim.new(0, 5)

	local frame = new("Frame", {
		Name = def.id or "Key",
		BackgroundColor3 = THEME.keyFill,
		BackgroundTransparency = THEME.keyIdle,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromOffset(def.x, def.y),
		Size = UDim2.fromOffset(def.w, def.h),
		Parent = parent,
	}, {
		new("UICorner", { CornerRadius = corner }),
	})

	local stroke = new("UIStroke", {
		Color = THEME.line,
		Thickness = 1.4,
		Transparency = THEME.lineIdle,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = frame,
	})

	local fromRight = def.fillFrom == "right"

	local fill = new("Frame", {
		Name = "Fill",
		BackgroundColor3 = THEME.pressFill,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = fromRight and Vector2.new(1, 0) or Vector2.new(0, 0),
		Position = fromRight and UDim2.fromScale(1, 0) or UDim2.fromScale(0, 0),
		Size = def.analog and UDim2.fromScale(0, 1) or UDim2.fromScale(1, 1),
		ZIndex = 2,
		Parent = frame,
	}, {
		new("UICorner", { CornerRadius = corner }),
	})

	local label
	if def.label then
		label = new("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Font = THEME.font,
			Text = def.label,
			TextColor3 = THEME.textIdle,
			TextScaled = true,
			TextStrokeColor3 = Color3.new(0, 0, 0),
			TextStrokeTransparency = THEME.textStroke,
			ZIndex = 3,
			Parent = frame,
		}, {
			new("UIPadding", {
				PaddingLeft = UDim.new(0, 3),
				PaddingRight = UDim.new(0, 3),
				PaddingTop = UDim.new(0, 2),
				PaddingBottom = UDim.new(0, 2),
			}),
			new("UITextSizeConstraint", {
				MaxTextSize = math.max(9, math.floor(def.h * 0.55)),
			}),
		})
	end

	local cell = Cell.new(fill, stroke, label)
	cell.frame = frame
	cell.analog = def.analog == true
	return cell
end

local function makeStick(parent, def)
	local size = def.radius * 2

	local ring = new("Frame", {
		Name = def.id,
		BackgroundColor3 = THEME.keyFill,
		BackgroundTransparency = THEME.keyIdle,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromOffset(def.cx, def.cy),
		Size = UDim2.fromOffset(size, size),
		Parent = parent,
	}, {
		new("UICorner", { CornerRadius = UDim.new(1, 0) }),
	})

	local stroke = new("UIStroke", {
		Color = THEME.line,
		Thickness = 1.4,
		Transparency = THEME.lineIdle,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = ring,
	})

	local glow = new("Frame", {
		Name = "Glow",
		BackgroundColor3 = THEME.pressFill,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 2,
		Parent = ring,
	}, {
		new("UICorner", { CornerRadius = UDim.new(1, 0) }),
	})

	new("Frame", {
		Name = "Center",
		BackgroundColor3 = THEME.line,
		BackgroundTransparency = 0.6,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(3, 3),
		ZIndex = 3,
		Parent = ring,
	}, {
		new("UICorner", { CornerRadius = UDim.new(1, 0) }),
	})

	local dot = new("Frame", {
		Name = "Dot",
		BackgroundColor3 = THEME.pressFill,
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(9, 9),
		ZIndex = 4,
		Parent = ring,
	}, {
		new("UICorner", { CornerRadius = UDim.new(1, 0) }),
	})

	if def.caption then
		new("TextLabel", {
			Name = def.caption,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromOffset(def.cx, def.cy + def.radius + 2),
			Size = UDim2.fromOffset(30, 10),
			Font = THEME.fontCaption,
			Text = def.caption,
			TextSize = 9,
			TextColor3 = THEME.textIdle,
			TextTransparency = 0.35,
			TextStrokeColor3 = Color3.new(0, 0, 0),
			TextStrokeTransparency = 0.6,
			ZIndex = 3,
			Parent = parent,
		})
	end

	local cell = Cell.new(glow, stroke, nil)
	cell.frame = ring
	cell.dot = dot
	cell.stickRadius = def.radius - 7
	cell.pressTransparency = THEME.stickPress
	return cell
end

local HEADER_HEIGHT = 18
local PADDING = 8

local Panel = {}
Panel.__index = Panel

function Panel.create(title, bodySize, defaultPos)
	local self = setmetatable({}, Panel)

	self.locked = SavedState.locked == true

	self.root = new("Frame", {
		Name = "Panel",
		Active = false,
		BackgroundColor3 = THEME.panelFill,
		BackgroundTransparency = THEME.panelIdle,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(
			bodySize.X + PADDING * 2,
			bodySize.Y + PADDING * 2 + HEADER_HEIGHT
		),
		Position = UDim2.fromScale(
			tonumber(SavedState.x) or defaultPos.X,
			tonumber(SavedState.y) or defaultPos.Y
		),
		Parent = screen,
	}, {
		new("UIScale", { Scale = CONFIG.uiScale }),
		new("UICorner", { CornerRadius = UDim.new(0, 10) }),
	})

	self.rootStroke = new("UIStroke", {
		Color = THEME.line,
		Thickness = 1,
		Transparency = 0.85,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = self.root,
	})

	self.header = new("Frame", {
		Name = "Handle",
		Active = not self.locked,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = self.locked and THEME.headerLocked or THEME.headerIdle,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
		Parent = self.root,
	}, {
		new("UICorner", { CornerRadius = UDim.new(0, 8) }),
		new("UIPadding", {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 5),
		}),
	})

	self.titleLabel = new("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -22, 1, 0),
		Font = THEME.fontCaption,
		Text = title,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = THEME.textIdle,
		TextTransparency = 0.25,
		Parent = self.header,
	})

	self.lockButton = new("TextButton", {
		Name = "LockToggle",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(16, 16),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.9,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = THEME.fontCaption,
		Text = "🔓",
		TextSize = 11,
		TextColor3 = THEME.textIdle,
		Parent = self.header,
	}, {
		new("UICorner", { CornerRadius = UDim.new(0, 4) }),
	})

	self.body = new("Frame", {
		Name = "Body",
		Active = false,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(PADDING, HEADER_HEIGHT + PADDING),
		Size = UDim2.fromOffset(bodySize.X, bodySize.Y),
		Parent = self.root,
	})

	self:applyLockVisuals()
	self:setupDrag()

	track(self.lockButton.MouseButton1Click:Connect(function()
		self:setLocked(not self.locked)
	end))

	return self
end

function Panel:applyLockVisuals()
	self.lockButton.Text = self.locked and "🔒" or "🔓"
	self.lockButton.TextTransparency = self.locked and 0 or 0.35
	self.lockButton.BackgroundTransparency = self.locked and 0.8 or 0.92
	self.header.Active = not self.locked
	tween(self.header, 0.15, {
		BackgroundTransparency = self.locked and THEME.headerLocked or THEME.headerIdle,
	})
	tween(self.titleLabel, 0.15, {
		TextTransparency = self.locked and 0.7 or 0.25,
	})
end

function Panel:setLocked(locked)
	self.locked = locked
	self:applyLockVisuals()
	self:save()
end

function Panel:save()
	SavedState.x = self.root.Position.X.Scale
	SavedState.y = self.root.Position.Y.Scale
	SavedState.locked = self.locked
	requestSave()
end

function Panel:clampToScreen()
	local view = screen.AbsoluteSize
	if view.X <= 0 or view.Y <= 0 then
		return
	end
	local size = self.root.AbsoluteSize
	local margin = 30
	local px = math.clamp(self.root.Position.X.Scale * view.X, -size.X + margin, view.X - margin)
	local py = math.clamp(self.root.Position.Y.Scale * view.Y, 0, view.Y - margin)
	self.root.Position = UDim2.fromScale(px / view.X, py / view.Y)
end

function Panel:setupDrag()
	local dragInput, startMouse, startOffset

	local function stopDrag()
		if not dragInput then
			return
		end
		dragInput = nil
		self:clampToScreen()
		self:save()
	end

	track(self.header.InputBegan:Connect(function(input)
		if self.locked then
			return
		end
		local kind = input.UserInputType
		if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then
			return
		end

		local view = screen.AbsoluteSize
		dragInput = input
		startMouse = Vector2.new(input.Position.X, input.Position.Y)
		startOffset = Vector2.new(
			self.root.Position.X.Scale * view.X,
			self.root.Position.Y.Scale * view.Y
		)
	end))

	track(UserInputService.InputChanged:Connect(function(input)
		if not dragInput or self.locked then
			return
		end

		local moving
		if dragInput.UserInputType == Enum.UserInputType.Touch then
			moving = (input == dragInput)
		else
			moving = (input.UserInputType == Enum.UserInputType.MouseMovement)
		end
		if not moving then
			return
		end

		local view = screen.AbsoluteSize
		local target = startOffset + (Vector2.new(input.Position.X, input.Position.Y) - startMouse)
		self.root.Position = UDim2.fromScale(target.X / view.X, target.Y / view.Y)
	end))

	track(UserInputService.InputEnded:Connect(function(input)
		if dragInput and input == dragInput then
			stopDrag()
		end
	end))
end

local bodySize = Vector2.new(BODY_WIDTH, BODY_HEIGHT)
local panel = Panel.create("CONTROLLER | discord.gg/ambitiouss", bodySize, CONFIG.defaultPos)

local Buttons = {}
local Sticks  = {}

for _, def in ipairs(LAYOUT) do
	Buttons[def.id] = makeKey(panel.body, def)
end

for _, def in ipairs(STICKS) do
	local cell = makeStick(panel.body, def)
	Sticks[def.id] = cell
	Buttons[def.click] = cell
end

local GAMEPAD_TYPES = {}
for _, item in ipairs(Enum.UserInputType:GetEnumItems()) do
	if item.Name:sub(1, 7) == "Gamepad" then
		GAMEPAD_TYPES[item] = true
	end
end

local function isTyping()
	return CONFIG.hideWhileTyping and UserInputService:GetFocusedTextBox() ~= nil
end

local stickTarget = {
	Thumbstick1 = Vector2.zero,
	Thumbstick2 = Vector2.zero,
}
local stickCurrent = {
	Thumbstick1 = Vector2.zero,
	Thumbstick2 = Vector2.zero,
}

local triggerTarget  = { ButtonL2 = 0, ButtonR2 = 0 }
local triggerCurrent = { ButtonL2 = 0, ButtonR2 = 0 }

local function releaseAll()
	for _, cell in pairs(Buttons) do
		cell:setActive(false)
	end
	for id in pairs(stickTarget) do
		stickTarget[id] = Vector2.zero
		stickCurrent[id] = Vector2.zero
		Sticks[id]:setStick(0, 0)
	end
	for id in pairs(triggerTarget) do
		triggerTarget[id] = 0
		triggerCurrent[id] = 0
		Buttons[id]:setAnalog(0)
	end
end

track(UserInputService.InputBegan:Connect(function(input)
	if isTyping() or not GAMEPAD_TYPES[input.UserInputType] then
		return
	end
	local cell = Buttons[input.KeyCode.Name]
	if cell and not cell.analog then
		cell:setActive(true)
	end
end))

track(UserInputService.InputEnded:Connect(function(input)
	if not GAMEPAD_TYPES[input.UserInputType] then
		return
	end
	local name = input.KeyCode.Name
	local cell = Buttons[name]
	if cell and not cell.analog then
		cell:setActive(false)
	end
	if triggerTarget[name] then
		triggerTarget[name] = 0
	end
	if stickTarget[name] then
		stickTarget[name] = Vector2.zero
	end
end))

track(UserInputService.InputChanged:Connect(function(input)
	if not GAMEPAD_TYPES[input.UserInputType] then
		return
	end
	local name = input.KeyCode.Name

	if stickTarget[name] then
		stickTarget[name] = Vector2.new(input.Position.X, input.Position.Y)
	elseif triggerTarget[name] then
		triggerTarget[name] = math.clamp(input.Position.Z, 0, 1)
	end
end))

track(RunService.RenderStepped:Connect(function(step)
	local frame = math.clamp(step, 1 / 240, 1 / 15)

	local stickRate   = math.clamp(CONFIG.stickSmoothing * frame * 60, 0, 1)
	local triggerRate = math.clamp(CONFIG.triggerSmooth * frame * 60, 0, 1)

	for id, cell in pairs(Sticks) do
		local current = stickCurrent[id] + (stickTarget[id] - stickCurrent[id]) * stickRate
		if current.Magnitude < 0.002 then
			current = Vector2.zero
		end
		stickCurrent[id] = current
		cell:setStick(current.X, current.Y)
	end

	for id, target in pairs(triggerTarget) do
		local current = triggerCurrent[id] + (target - triggerCurrent[id]) * triggerRate
		if current < 0.002 then
			current = 0
		end
		triggerCurrent[id] = current
		Buttons[id]:setAnalog(current)
	end
end))

local function refreshStatus()
	local connected = #UserInputService:GetConnectedGamepads() > 0
	tween(panel.rootStroke, 0.2, {
		Transparency = connected and 0.85 or 0.96,
	})
	if not connected then
		releaseAll()
	end
end

track(UserInputService.GamepadConnected:Connect(refreshStatus))
track(UserInputService.GamepadDisconnected:Connect(refreshStatus))
refreshStatus()

panel:clampToScreen()

track(screen:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	panel:clampToScreen()
end))

track(UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode ~= CONFIG.toggleKey or isTyping() then
		return
	end
	screen.Enabled = not screen.Enabled
	SavedState.hidden = not screen.Enabled
	requestSave()
	if not screen.Enabled then
		releaseAll()
	end
end))

track(UserInputService.WindowFocusReleased:Connect(releaseAll))

screen.Enabled = SavedState.hidden ~= true

local function destroy()
	for _, conn in ipairs(Connections) do
		pcall(function()
			conn:Disconnect()
		end)
	end
	table.clear(Connections)
	if screen then
		screen:Destroy()
	end
	ENV.__LiveControllerOverlay = nil
end

ENV.__LiveControllerOverlay = {
	destroy = destroy,
	screen = screen,
	panel = panel,
	config = CONFIG,
	buttons = Buttons,
	sticks = Sticks,
}

print("discord.gg/ambitiouss")

track(UserInputService.WindowFocusReleased:Connect(releaseAll))

screen.Enabled = SavedState.hidden ~= true

local function destroy()
	for _, conn in ipairs(Connections) do
		pcall(function()
			conn:Disconnect()
		end)
	end
	table.clear(Connections)
	if screen then
		screen:Destroy()
	end
	ENV.__LiveControllerOverlay = nil
end

ENV.__LiveControllerOverlay = {
	destroy = destroy,
	screen = screen,
	panel = panel,
	config = CONFIG,
	buttons = Buttons,
	sticks = Sticks,
}