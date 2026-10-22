-- DANuniverse VIP | Prison Life
if shared.DANuniverse then
	shared.DANuniverse.destroy()
end

-- Services.
local playersService = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local virtualUser = game:GetService("VirtualUser")
local lightingService = game:GetService("Lighting")

local localPlayer = playersService.LocalPlayer
local currentCamera = workspace.CurrentCamera

-- Constants.
local BRAND = "DANuniverse"
local VERSION = "v3.0 VIP"
local ACCENT = Color3.fromRGB(255, 190, 40)
local BACKGROUND = Color3.fromRGB(18, 18, 24)
local PANEL = Color3.fromRGB(28, 28, 38)
local TOGGLE_KEY = Enum.KeyCode.RightShift

local DANuniverse = { connections = {}, state = {}, flags = {}, running = true }
local state = DANuniverse.state

state.speed = 16
state.jump = 50
state.flySpeed = 60
state.fov = 150
state.smoothness = 0.25

-- Helpers.
local function connect(signal, callback)
	local connection = signal:Connect(callback)
	table.insert(DANuniverse.connections, connection)
	return connection
end

local function getCharacter()
	local character = localPlayer.Character
	if not character then return end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")
	if not (humanoid and root) then return end
	return character, humanoid, root
end

local function notify(text)
	local gui = DANuniverse.gui
	if not gui then return end
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 260, 0, 34)
	label.Position = UDim2.new(1, 280, 1, -50)
	label.BackgroundColor3 = PANEL
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 13
	label.Text = BRAND .. " | " .. text
	label.Parent = gui
	Instance.new("UICorner", label).CornerRadius = UDim.new(0, 8)
	Instance.new("UIStroke", label).Color = ACCENT
	tweenService:Create(label, TweenInfo.new(0.4), { Position = UDim2.new(1, -280, 1, -50) }):Play()
	task.delay(3, function()
		tweenService:Create(label, TweenInfo.new(0.4), { Position = UDim2.new(1, 280, 1, -50) }):Play()
		task.wait(0.5)
		label:Destroy()
	end)
end

local function isEnemy(player)
	if player == localPlayer then return false end
	if state.teamCheck and player.Team == localPlayer.Team then return false end
	return true
end

---Aim origin: screen center on mobile, cursor on PC.
local function getAimOrigin()
	if userInputService.TouchEnabled and not userInputService.MouseEnabled then
		return currentCamera.ViewportSize / 2
	end
	return userInputService:GetMouseLocation()
end

---Closest enemy head to the aim origin inside the FOV.
local function getClosestTarget()
	local closest, closestDist = nil, state.fov
	local mousePos = getAimOrigin()
	for _, player in ipairs(playersService:GetPlayers()) do
		if not isEnemy(player) then continue end
		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local head = character and character:FindFirstChild("Head")
		if not (humanoid and head and humanoid.Health > 0) then continue end
		local screenPos, onScreen = currentCamera:WorldToViewportPoint(head.Position)
		if not onScreen then continue end
		local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
		if dist < closestDist then
			closest, closestDist = head, dist
		end
	end
	return closest
end

-- GUI.
local gui = Instance.new("ScreenGui")
gui.Name = BRAND
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
DANuniverse.gui = gui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 520, 0, 340)
main.Position = UDim2.new(0.5, -260, 0.5, -170)
main.BackgroundColor3 = BACKGROUND
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = ACCENT
mainStroke.Thickness = 1.5

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 36)
title.Position = UDim2.new(0, 14, 0, 0)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBlack
title.TextSize = 17
title.TextColor3 = ACCENT
title.Text = BRAND .. "  |  Prison Life  |  " .. VERSION
title.Parent = main

local vipBadge = Instance.new("TextLabel")
vipBadge.Size = UDim2.new(0, 60, 0, 20)
vipBadge.Position = UDim2.new(1, -72, 0, 8)
vipBadge.BackgroundColor3 = ACCENT
vipBadge.Font = Enum.Font.GothamBlack
vipBadge.TextSize = 12
vipBadge.TextColor3 = Color3.new(0, 0, 0)
vipBadge.Text = "VIP"
vipBadge.Parent = main
Instance.new("UICorner", vipBadge).CornerRadius = UDim.new(0, 6)

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(0, 110, 1, -46)
tabBar.Position = UDim2.new(0, 8, 0, 38)
tabBar.BackgroundColor3 = PANEL
tabBar.Parent = main
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 10)
local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.Padding = UDim.new(0, 4)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", tabBar).PaddingTop = UDim.new(0, 6)

local pages = {}
local tabButtons = {}

local function createTab(name)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -12, 0, 30)
	button.BackgroundColor3 = BACKGROUND
	button.Font = Enum.Font.GothamBold
	button.TextSize = 13
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Text = name
	button.Parent = tabBar
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, -134, 1, -46)
	page.Position = UDim2.new(0, 126, 0, 38)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 3
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.Visible = false
	page.Parent = main
	local layout = Instance.new("UIListLayout", page)
	layout.Padding = UDim.new(0, 6)

	button.MouseButton1Click:Connect(function()
		for _, otherPage in pairs(pages) do otherPage.Visible = false end
		for _, otherButton in pairs(tabButtons) do otherButton.BackgroundColor3 = BACKGROUND end
		page.Visible = true
		button.BackgroundColor3 = ACCENT
	end)

	pages[name] = page
	tabButtons[name] = button
	return page
end

local function createToggle(page, text, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -8, 0, 32)
	button.BackgroundColor3 = PANEL
	button.Font = Enum.Font.Gotham
	button.TextSize = 13
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Text = "   " .. text
	button.Parent = page
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

	local indicator = Instance.new("Frame")
	indicator.Size = UDim2.new(0, 34, 0, 16)
	indicator.Position = UDim2.new(1, -44, 0.5, -8)
	indicator.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
	indicator.Parent = button
	Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 12, 0, 12)
	knob.Position = UDim2.new(0, 2, 0.5, -6)
	knob.BackgroundColor3 = Color3.new(1, 1, 1)
	knob.Parent = indicator
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local enabled = false
	button.MouseButton1Click:Connect(function()
		enabled = not enabled
		indicator.BackgroundColor3 = enabled and ACCENT or Color3.fromRGB(70, 70, 80)
		tweenService:Create(knob, TweenInfo.new(0.15), {
			Position = enabled and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
		}):Play()
		task.spawn(callback, enabled)
	end)
end

local function createButton(page, text, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -8, 0, 32)
	button.BackgroundColor3 = PANEL
	button.Font = Enum.Font.GothamBold
	button.TextSize = 13
	button.TextColor3 = ACCENT
	button.Text = text
	button.Parent = page
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
	button.MouseButton1Click:Connect(function()
		task.spawn(callback)
	end)
end

local function createInput(page, text, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -8, 0, 32)
	frame.BackgroundColor3 = PANEL
	frame.Parent = page
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -90, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = text
	label.Parent = frame

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0, 70, 0, 22)
	box.Position = UDim2.new(1, -78, 0.5, -11)
	box.BackgroundColor3 = BACKGROUND
	box.Font = Enum.Font.GothamBold
	box.TextSize = 12
	box.TextColor3 = ACCENT
	box.Text = tostring(default)
	box.Parent = frame
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
	box.FocusLost:Connect(function()
		local value = tonumber(box.Text)
		if value then callback(value) end
	end)
end

-- Mobile scaling and floating open button.
local viewportScale = Instance.new("UIScale", main)
viewportScale.Scale = math.clamp(currentCamera.ViewportSize.X / 600, 0.55, 1)

local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 46, 0, 46)
openButton.Position = UDim2.new(0, 10, 0.5, -23)
openButton.BackgroundColor3 = BACKGROUND
openButton.Font = Enum.Font.GothamBlack
openButton.TextSize = 14
openButton.TextColor3 = ACCENT
openButton.Text = "DAN"
openButton.ZIndex = 10
openButton.Parent = gui
Instance.new("UICorner", openButton).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", openButton).Color = ACCENT
openButton.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- Tabs.
local playerPage = createTab("Player")
local combatPage = createTab("Combat")
local visualsPage = createTab("Visuals")
local prisonPage = createTab("Prison")
local teleportPage = createTab("Teleport")
local miscPage = createTab("Misc")

-- Player tab.
createInput(playerPage, "WalkSpeed", state.speed, function(value) state.speed = value end)
createToggle(playerPage, "Speed Hack", function(value) state.speedOn = value end)
createInput(playerPage, "JumpPower", state.jump, function(value) state.jump = value end)
createToggle(playerPage, "Jump Hack", function(value) state.jumpOn = value end)
createToggle(playerPage, "Infinite Jump", function(value) state.infJump = value end)
createToggle(playerPage, "Noclip", function(value) state.noclip = value end)
createInput(playerPage, "Fly Speed", state.flySpeed, function(value) state.flySpeed = value end)
createToggle(playerPage, "Fly (WASD / Space / Ctrl)", function(value)
	state.fly = value
	local _, humanoid = getCharacter()
	if humanoid and not value then humanoid.PlatformStand = false end
end)
createToggle(playerPage, "God Mode (Auto Heal)", function(value) state.godMode = value end)

-- Combat tab.
createToggle(combatPage, "Aimbot (Hold Right Click)", function(value) state.aimbot = value end)
state.alwaysAim = userInputService.TouchEnabled and not userInputService.MouseEnabled
createToggle(combatPage, "Always Aim (no hold, mobile)", function(value) state.alwaysAim = value end)
createToggle(combatPage, "Team Check", function(value) state.teamCheck = value end)
createInput(combatPage, "Aimbot FOV", state.fov, function(value) state.fov = value end)
createInput(combatPage, "Smoothness (0-1)", state.smoothness, function(value) state.smoothness = math.clamp(value, 0.01, 1) end)
createToggle(combatPage, "Show FOV Circle", function(value) state.showFov = value end)
createToggle(combatPage, "Reach Hitbox Expander", function(value) state.hitbox = value end)

-- Visuals tab.
createToggle(visualsPage, "Player ESP (Highlight)", function(value) state.esp = value end)
createToggle(visualsPage, "Name Tags", function(value) state.nameTags = value end)
createToggle(visualsPage, "Fullbright", function(value)
	if value then
		DANuniverse.oldAmbient = lightingService.Ambient
		DANuniverse.oldBrightness = lightingService.Brightness
		lightingService.Ambient = Color3.new(1, 1, 1)
		lightingService.Brightness = 2
	elseif DANuniverse.oldAmbient then
		lightingService.Ambient = DANuniverse.oldAmbient
		lightingService.Brightness = DANuniverse.oldBrightness
	end
end)

-- Prison features.
state.escapePoint = Vector3.new(-920, 95, 2138)

local function isGuard()
	return localPlayer.Team ~= nil and localPlayer.Team.Name == "Guards"
end

local function escapePrison()
	local _, _, root = getCharacter()
	if root then
		root.CFrame = CFrame.new(state.escapePoint)
	end
end

local function arrestPlayer(player)
	local _, _, root = getCharacter()
	local targetRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not (root and targetRoot) then return end
	root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 2.5)
	task.wait(0.15)
	pcall(function()
		workspace.Remote.arrest:InvokeServer(targetRoot)
	end)
end

task.spawn(function()
	while DANuniverse.running do
		task.wait(0.5)
		if not (state.autoArrest and isGuard()) then continue end
		local _, humanoid, root = getCharacter()
		if not (humanoid and humanoid.Health > 0) then continue end
		local originalCFrame = root.CFrame
		local arrested = false
		for _, player in ipairs(playersService:GetPlayers()) do
			if not state.autoArrest then break end
			if player == localPlayer or not player.Team or player.Team.Name ~= "Criminals" then continue end
			local targetHumanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
			if not (targetHumanoid and targetHumanoid.Health > 0) then continue end
			arrestPlayer(player)
			arrested = true
			task.wait(0.4)
		end
		if arrested then
			local _, _, newRoot = getCharacter()
			if newRoot then newRoot.CFrame = originalCFrame end
		end
	end
end)

connect(localPlayer.CharacterAdded, function()
	if not state.autoEscape then return end
	task.wait(1)
	escapePrison()
end)

-- Prison tab.
local function pickupItem(itemName)
	pcall(function()
		local item = workspace.Prison_ITEMS.giver:FindFirstChild(itemName)
		workspace.Remote.ItemHandler:InvokeServer(item.ITEMPICKUP)
	end)
end

createButton(prisonPage, "Get AK-47", function() pickupItem("AK-47") end)
createButton(prisonPage, "Get Remington 870", function() pickupItem("Remington 870") end)
createButton(prisonPage, "Get M9", function() pickupItem("M9") end)
createButton(prisonPage, "Get Keycard", function() pickupItem("Key card") end)
createButton(prisonPage, "Get All Guns", function()
	for _, itemName in ipairs({ "AK-47", "Remington 870", "M9", "Key card" }) do
		pickupItem(itemName)
		task.wait(0.3)
	end
	notify("Items collected")
end)
createButton(prisonPage, "Team: Inmate", function()
	pcall(function() workspace.Remote.TeamEvent:FireServer("Bright orange") end)
end)
createButton(prisonPage, "Team: Guard", function()
	pcall(function() workspace.Remote.TeamEvent:FireServer("Bright blue") end)
end)
createButton(prisonPage, "Team: Neutral", function()
	pcall(function() workspace.Remote.TeamEvent:FireServer("Medium stone grey") end)
end)
createToggle(prisonPage, "Auto Arrest (Guards only)", function(value)
	if value and not isGuard() then
		notify("You must be a Guard")
	end
	state.autoArrest = value
end)
createToggle(prisonPage, "Auto Escape (on spawn)", function(value)
	state.autoEscape = value
	if value then escapePrison() end
end)
createButton(prisonPage, "Escape Now", escapePrison)
createButton(prisonPage, "Set Escape Point (here)", function()
	local _, _, root = getCharacter()
	if root then
		state.escapePoint = root.Position
		notify("Escape point saved")
	end
end)
createToggle(prisonPage, "Anti Stun / Anti Taze", function(value) state.antiStun = value end)

-- Teleport tab.
local function refreshTeleports()
	for _, child in ipairs(teleportPage:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	for _, player in ipairs(playersService:GetPlayers()) do
		if player == localPlayer then continue end
		createButton(teleportPage, "TP > " .. player.Name, function()
			local _, _, root = getCharacter()
			local targetRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if root and targetRoot then
				root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
			end
		end)
	end
end
createButton(teleportPage, "Refresh Player List", refreshTeleports)
refreshTeleports()

-- Misc tab.
createToggle(miscPage, "Anti AFK", function(value) state.antiAfk = value end)
createButton(miscPage, "Rejoin Server", function()
	game:GetService("TeleportService"):Teleport(game.PlaceId, localPlayer)
end)
createButton(miscPage, "Copy Discord", function()
	if setclipboard then setclipboard("https://discord.gg/xbyte") end
	notify("Discord copied")
end)
createButton(miscPage, "Unload " .. BRAND, function()
	DANuniverse.destroy()
end)

-- Show first tab.
pages["Player"].Visible = true
tabButtons["Player"].BackgroundColor3 = ACCENT

-- FOV circle (GUI based, works on mobile and PC).
local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.ZIndex = 5
fovCircle.Parent = gui
Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
local fovStroke = Instance.new("UIStroke", fovCircle)
fovStroke.Color = ACCENT
fovStroke.Thickness = 1.5

-- ESP.
local espObjects = {}

local function clearEsp(player)
	local object = espObjects[player]
	if not object then return end
	if object.highlight then object.highlight:Destroy() end
	if object.tag then object.tag:Destroy() end
	espObjects[player] = nil
end

local function updateEsp(player)
	local character = player.Character
	if not (state.esp or state.nameTags) or not character or not isEnemy(player) then
		return clearEsp(player)
	end

	local object = espObjects[player] or {}
	espObjects[player] = object

	if state.esp then
		if not object.highlight or object.highlight.Parent ~= character then
			if object.highlight then object.highlight:Destroy() end
			object.highlight = Instance.new("Highlight")
			object.highlight.FillTransparency = 0.6
			object.highlight.OutlineColor = Color3.new(1, 1, 1)
			object.highlight.Parent = character
		end
		object.highlight.FillColor = player.TeamColor.Color
	elseif object.highlight then
		object.highlight:Destroy()
		object.highlight = nil
	end

	local head = character:FindFirstChild("Head")
	if state.nameTags and head then
		if not object.tag or object.tag.Parent ~= head then
			if object.tag then object.tag:Destroy() end
			local tag = Instance.new("BillboardGui")
			tag.Size = UDim2.new(0, 120, 0, 20)
			tag.StudsOffset = Vector3.new(0, 2.5, 0)
			tag.AlwaysOnTop = true
			tag.Parent = head
			local label = Instance.new("TextLabel", tag)
			label.Size = UDim2.new(1, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.GothamBold
			label.TextSize = 13
			label.TextStrokeTransparency = 0
			label.TextColor3 = ACCENT
			object.tag = tag
			object.label = label
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		object.label.Text = player.Name .. " [" .. math.floor(humanoid and humanoid.Health or 0) .. "]"
	elseif object.tag then
		object.tag:Destroy()
		object.tag = nil
	end
end

-- Main loops.
-- Runs after the default camera so our aim is not overwritten.
runService:BindToRenderStep("DANuniverseAim", Enum.RenderPriority.Camera.Value + 1, function()
	currentCamera = workspace.CurrentCamera

	local origin = getAimOrigin()
	fovCircle.Visible = state.showFov == true
	fovCircle.Size = UDim2.fromOffset(state.fov * 2, state.fov * 2)
	fovCircle.Position = UDim2.fromOffset(origin.X, origin.Y)

	if not state.aimbot then return end
	local holding = state.alwaysAim or userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
	if not holding then return end

	local target = getClosestTarget()
	if target then
		local goal = CFrame.new(currentCamera.CFrame.Position, target.Position)
		currentCamera.CFrame = currentCamera.CFrame:Lerp(goal, state.smoothness)
	end
end)

connect(runService.Heartbeat, function()
	local character, humanoid, root = getCharacter()
	if not character then return end

	if state.speedOn then humanoid.WalkSpeed = state.speed end
	if state.jumpOn then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = state.jump
	end
	if state.antiStun then
		if humanoid.PlatformStand and not state.fly then humanoid.PlatformStand = false end
		if humanoid.Sit then humanoid.Sit = false end
		if root.Anchored then root.Anchored = false end
		if not state.speedOn and humanoid.WalkSpeed < 16 then humanoid.WalkSpeed = 16 end
		if not state.jumpOn and humanoid.JumpPower < 50 then
			humanoid.UseJumpPower = true
			humanoid.JumpPower = 50
		end
		for _, descendant in ipairs(character:GetChildren()) do
			local name = descendant.Name:lower()
			if (name == "tased" or name == "stun" or name == "stunned") and not descendant:IsA("Humanoid") then
				descendant:Destroy()
			end
		end
	end
	if state.godMode and humanoid.Health < humanoid.MaxHealth then
		humanoid.Health = humanoid.MaxHealth
	end

	if state.fly then
		humanoid.PlatformStand = true
		local direction = Vector3.zero
		local camCFrame = currentCamera.CFrame
		if userInputService:IsKeyDown(Enum.KeyCode.W) then direction += camCFrame.LookVector end
		if userInputService:IsKeyDown(Enum.KeyCode.S) then direction -= camCFrame.LookVector end
		if userInputService:IsKeyDown(Enum.KeyCode.D) then direction += camCFrame.RightVector end
		if userInputService:IsKeyDown(Enum.KeyCode.A) then direction -= camCFrame.RightVector end
		if userInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.yAxis end
		if userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction -= Vector3.yAxis end
		root.AssemblyLinearVelocity = direction.Magnitude > 0 and direction.Unit * state.flySpeed or Vector3.zero
	end
end)

connect(runService.Stepped, function()
	local character = localPlayer.Character
	if not character then return end
	if state.noclip then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end
	if state.hitbox then
		for _, player in ipairs(playersService:GetPlayers()) do
			if not isEnemy(player) then continue end
			local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if root then
				root.Size = Vector3.new(8, 8, 8)
				root.Transparency = 0.8
				root.CanCollide = false
			end
		end
	end
end)

connect(userInputService.JumpRequest, function()
	if not state.infJump then return end
	local _, humanoid = getCharacter()
	if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

connect(localPlayer.Idled, function()
	if not state.antiAfk then return end
	virtualUser:CaptureController()
	virtualUser:ClickButton2(Vector2.new())
end)

connect(userInputService.InputBegan, function(input, processed)
	if processed then return end
	if input.KeyCode == TOGGLE_KEY then
		main.Visible = not main.Visible
	end
end)

task.spawn(function()
	while DANuniverse.running do
		for _, player in ipairs(playersService:GetPlayers()) do
			if player ~= localPlayer then updateEsp(player) end
		end
		task.wait(0.25)
	end
end)

connect(playersService.PlayerRemoving, clearEsp)

---Clean up everything.
function DANuniverse.destroy()
	DANuniverse.running = false
	for _, connection in ipairs(DANuniverse.connections) do connection:Disconnect() end
	for player in pairs(espObjects) do clearEsp(player) end
	pcall(function() runService:UnbindFromRenderStep("DANuniverseAim") end)
	if DANuniverse.oldAmbient then
		lightingService.Ambient = DANuniverse.oldAmbient
		lightingService.Brightness = DANuniverse.oldBrightness
	end
	local _, humanoid = getCharacter()
	if humanoid then humanoid.PlatformStand = false end
	gui:Destroy()
	shared.DANuniverse = nil
end

DANuniverse.running = true
shared.DANuniverse = DANuniverse
notify("Loaded | RightShift to hide")