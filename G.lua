--[[
	LUNAR ANTI TP BAT
	Anti Bat = chaos pour les autres / toi normal (restore fort)
]]

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local environment = (type(getgenv) == "function" and getgenv()) or _G

pcall(function()
	local old = PlayerGui:FindFirstChild("Lunar Anti Tp Bat")
	if old then old:Destroy() end
end)
pcall(function()
	local prev = environment.__LUNAR_RUNTIME
	if type(prev) == "table" and type(prev.destroy) == "function" then
		pcall(prev.destroy)
	end
end)

local CONFIG_FILE = "LunarAntiTpBat_Config.json"
local AntiBatEnabled = false
local HookAntiEnabled = false
local InfJumpHoldEnabled = false
local HitSpamEnabled = false
local KeyAntiBat = "B"
local KeyAntiTp = "N"
local KeyInfJump = "J"
local KeyHitSpam = "H"
local AntiBatConn = nil
local currentBg = "rbxassetid://102877336629662"

local JUMP_POWER = 30
local spacePressed = false
local infJumpConns = {}

local runtime = {
	alive = true,
	enabled = false,
	character = nil,
	rootPart = nil,
	fakeRoot = nil,
	stepConnection = nil,
}
environment.__LUNAR_RUNTIME = runtime

local HitBurstRunning = false
local syncAntiBatVisual = nil
local hitHealthConn = nil
local hitTouchedConn = nil
local lastHitTrigger = 0

-- S2 velocity hook (anti drop / anti detect lecture)
local velChecked = {}
local hookedVelParts = {}

local function setupVelChecked(char)
	velChecked = {}
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 3)
	if hrp then velChecked[hrp] = true end
	return hrp
end

local function hookVelHRP(hrp)
	if not hrp or hookedVelParts[hrp] then return end
	if type(getrawmetatable) ~= "function" or type(newcclosure) ~= "function" then return end
	hookedVelParts[hrp] = true
	local ok, mt = pcall(getrawmetatable, hrp)
	if not ok or not mt then return end
	pcall(function()
		setreadonly(mt, false)
		local originalVelIndex = rawget(mt, "__index")
		mt.__index = newcclosure(function(self, key)
			local isVel = (key == "AssemblyLinearVelocity" or key == "Velocity")
			if isVel and velChecked[self] then
				local fromUs = false
				pcall(function()
					if checkcaller and checkcaller() then fromUs = true end
				end)
				if not fromUs then
					local real
					if type(originalVelIndex) == "function" then
						real = originalVelIndex(self, key)
					elseif type(originalVelIndex) == "table" then
						real = originalVelIndex[key]
					end
					if typeof(real) == "Vector3" and real.Magnitude > 20 then
						return real.Unit * 20
					end
					return real
				end
			end
			if type(originalVelIndex) == "function" then
				return originalVelIndex(self, key)
			elseif type(originalVelIndex) == "table" then
				return originalVelIndex[key]
			end
		end)
		setreadonly(mt, true)
	end)
end

local function applyS2Hook(char)
	hookedVelParts = {}
	local hrp = setupVelChecked(char)
	if hrp then hookVelHRP(hrp) end
end

if LocalPlayer.Character then applyS2Hook(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(function(char)
	task.defer(function() applyS2Hook(char) end)
end)

local function saveConfig()
	pcall(function()
		if writefile then
			writefile(CONFIG_FILE, HttpService:JSONEncode({
				AntiBat = AntiBatEnabled,
				HookAnti = HookAntiEnabled,
				InfJump = InfJumpHoldEnabled,
				HitSpam = HitSpamEnabled,
				KeyAntiBat = KeyAntiBat,
				KeyAntiTp = KeyAntiTp,
				KeyInfJump = KeyInfJump,
				KeyHitSpam = KeyHitSpam,
				Background = currentBg,
				JumpPower = JUMP_POWER,
			}))
		end
	end)
end

local function loadConfig()
	pcall(function()
		if isfile and isfile(CONFIG_FILE) then
			local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
			if type(data) == "table" then
				if data.AntiBat ~= nil then AntiBatEnabled = data.AntiBat == true end
				if data.HookAnti ~= nil then HookAntiEnabled = data.HookAnti == true end
				if data.InfJump ~= nil then InfJumpHoldEnabled = data.InfJump == true end
				if data.HitSpam ~= nil then HitSpamEnabled = data.HitSpam == true end
				if type(data.KeyAntiBat) == "string" then KeyAntiBat = data.KeyAntiBat end
				if type(data.KeyAntiTp) == "string" then KeyAntiTp = data.KeyAntiTp end
				if type(data.KeyInfJump) == "string" then KeyInfJump = data.KeyInfJump end
				if type(data.KeyHitSpam) == "string" then KeyHitSpam = data.KeyHitSpam end
				if type(data.Background) == "string" then currentBg = data.Background end
				if data.JumpPower then JUMP_POWER = math.clamp(tonumber(data.JumpPower) or 30, 5, 200) end
			end
		end
	end)
end
loadConfig()

local function getCurrentRoot(character)
	character = character or LocalPlayer.Character
	if not character then return nil end
	local ok, root = pcall(function() return character:FindFirstChild("HumanoidRootPart") end)
	if ok and root then return root end
	return nil
end

local function getHumanoid(character)
	character = character or LocalPlayer.Character
	if not character then return nil end
	return character:FindFirstChildOfClass("Humanoid")
end

local function SetYVel(root, newY)
	if not root or not root.Parent then return end
	local cv = root.AssemblyLinearVelocity
	root.AssemblyLinearVelocity = Vector3.new(cv.X, newY, cv.Z)
end

-- ===================== ANTI BAT (toi normal / autres chaos) =====================
local savedCF = nil
local savedVel = Vector3.zero
local chaosFrame = 0

local function stopAntiBat()
	if AntiBatConn then
		AntiBatConn:Disconnect()
		AntiBatConn = nil
	end
	pcall(function()
		RunService:UnbindFromRenderStep("LunarAntiBatRestore")
	end)
	pcall(function()
		local r = getCurrentRoot()
		if r then r.AssemblyAngularVelocity = Vector3.zero end
	end)
	savedCF = nil
end

local function startAntiBat()
	stopAntiBat()
	local root = getCurrentRoot()
	if not root then return end

	pcall(function()
		setupVelChecked(LocalPlayer.Character)
		hookVelHRP(root)
	end)

	-- 1) Chaos envoyé (réplication)
	AntiBatConn = RunService.Heartbeat:Connect(function()
		if not AntiBatEnabled then return end
		root = getCurrentRoot()
		if not root then return end

		-- sauvegarde AVANT le chaos
		savedCF = root.CFrame
		savedVel = root.AssemblyLinearVelocity

		chaosFrame = chaosFrame + 1

		-- chaos toutes les frames pour que les autres voient bien
		local chaos = Vector3.new(
			(math.random() - 0.5) * 12000,
			savedVel.Y,
			(math.random() - 0.5) * 12000
		)
		root.AssemblyLinearVelocity = chaos
		pcall(function()
			root.AssemblyAngularVelocity = Vector3.new(
				(math.random() - 0.5) * 5000,
				(math.random() - 0.5) * 5000,
				(math.random() - 0.5) * 5000
			)
		end)
	end)

	-- 2) Restore AVANT le rendu caméra → toi tu ne vois pas le chaos
	RunService:BindToRenderStep("LunarAntiBatRestore", Enum.RenderPriority.Camera.Value - 10, function()
		if not AntiBatEnabled then return end
		root = getCurrentRoot()
		if not root or not savedCF then return end

		-- force position + rotation locale propres
		root.CFrame = savedCF
		root.AssemblyLinearVelocity = Vector3.new(savedVel.X, root.AssemblyLinearVelocity.Y, savedVel.Z)
		root.AssemblyAngularVelocity = Vector3.zero
	end)
end

local function setAntiBat(on)
	AntiBatEnabled = on == true
	if AntiBatEnabled then
		startAntiBat()
	else
		stopAntiBat()
	end
	saveConfig()
end

-- ===================== HIT x3 =====================
local HIT_OFF_TIME = 0.12
local HIT_ON_TIME = 0.25
local HIT_DEBOUNCE = 1.0

local function hitBurst3()
	if HitBurstRunning then return end
	if not HitSpamEnabled or not AntiBatEnabled or not runtime.alive then return end
	HitBurstRunning = true
	task.spawn(function()
		for _ = 1, 3 do
			if not HitSpamEnabled or not AntiBatEnabled or not runtime.alive then break end
			stopAntiBat()
			pcall(function() if syncAntiBatVisual then syncAntiBatVisual(false) end end)
			task.wait(HIT_OFF_TIME)
			if not HitSpamEnabled or not AntiBatEnabled or not runtime.alive then break end
			startAntiBat()
			pcall(function() if syncAntiBatVisual then syncAntiBatVisual(true) end end)
			task.wait(HIT_ON_TIME)
		end
		HitBurstRunning = false
		pcall(function() if syncAntiBatVisual then syncAntiBatVisual(AntiBatEnabled) end end)
	end)
end

local function tryHitTrigger()
	if not HitSpamEnabled or not AntiBatEnabled or not runtime.alive then return end
	local now = os.clock()
	if now - lastHitTrigger < HIT_DEBOUNCE then return end
	lastHitTrigger = now
	hitBurst3()
end

local function hookHitHumanoid(h)
	if hitHealthConn then pcall(function() hitHealthConn:Disconnect() end) hitHealthConn = nil end
	if not h then return end
	local lastHP = h.Health
	hitHealthConn = h.HealthChanged:Connect(function(hp)
		if not HitSpamEnabled or not AntiBatEnabled then lastHP = hp return end
		if hp < lastHP then tryHitTrigger() end
		lastHP = hp
	end)
end

local function hookHitTouched(rootPart)
	if hitTouchedConn then pcall(function() hitTouchedConn:Disconnect() end) hitTouchedConn = nil end
	if not rootPart then return end
	hitTouchedConn = rootPart.Touched:Connect(function(hit)
		if not HitSpamEnabled or not AntiBatEnabled then return end
		pcall(function()
			local tool = hit:FindFirstAncestorOfClass("Tool")
			if not tool then return end
			if not string.find(string.lower(tool.Name), "bat", 1, true) then return end
			local holder = tool.Parent
			if not holder or holder == LocalPlayer.Character then return end
			local plr = Players:GetPlayerFromCharacter(holder)
			if plr and plr ~= LocalPlayer then tryHitTrigger() end
		end)
	end)
end

local function setHitSpam(on)
	HitSpamEnabled = on == true
	saveConfig()
end

-- ===================== ANTI TP BAT =====================
local FAKE_ROOT_Y = 1e8

local function findGlobalFunction(...)
	for i = 1, select("#", ...) do
		local name = select(i, ...)
		local v = rawget(environment, name) or rawget(_G, name)
		if type(v) == "function" then return v end
	end
	return nil
end

local function setHidden(instance, property, value)
	if not instance then return false end
	local setter = findGlobalFunction("sethiddenproperty", "set_hidden_property", "sethiddenprop")
	if setter then
		local ok = pcall(setter, instance, property, value)
		if ok then return true end
	end
	return pcall(function() instance[property] = value end)
end

local function getHidden(instance, property)
	if not instance then return false, nil end
	local getter = findGlobalFunction("gethiddenproperty", "get_hidden_property", "gethiddenprop")
	if getter then
		local ok, value = pcall(getter, instance, property)
		if ok then return true, value end
	end
	local ok, value = pcall(function() return instance[property] end)
	return ok, value
end

local function isBasePart(inst)
	if not inst then return false end
	local ok, r = pcall(function() return inst:IsA("BasePart") end)
	return ok and r == true
end

local function destroyFakeRoot()
	if runtime.fakeRoot then
		pcall(function() runtime.fakeRoot:Destroy() end)
		runtime.fakeRoot = nil
	end
end

local function restoreReplicationRoot()
	local root = runtime.rootPart
	if isBasePart(root) then setHidden(root, "PhysicsRepRootPart", root) end
end

local function createFakeRoot(rootPart)
	destroyFakeRoot()
	if not isBasePart(rootPart) then return nil end
	local fake = Instance.new("Part")
	fake.Name = "LunarFakeRepRoot"
	fake.Size = Vector3.new(2, 2, 1)
	fake.Transparency = 1
	fake.Anchored = true
	fake.CanCollide = false
	fake.CanQuery = false
	fake.CanTouch = false
	fake.Massless = true
	fake.CFrame = CFrame.new(rootPart.Position.X, FAKE_ROOT_Y, rootPart.Position.Z)
	fake.Parent = workspace
	runtime.fakeRoot = fake
	return fake
end

local function assignFakeReplicationRoot(rootPart, fake)
	if not isBasePart(rootPart) or not isBasePart(fake) then return end
	setHidden(rootPart, "PhysicsRepRootPart", fake)
end

local function stopStepConnection()
	if runtime.stepConnection then
		pcall(function() runtime.stepConnection:Disconnect() end)
		runtime.stepConnection = nil
	end
end

local function stepDesync()
	if not runtime.enabled or not runtime.alive then return end
	local root = runtime.rootPart
	if not isBasePart(root) or not root.Parent then
		root = getCurrentRoot(runtime.character)
		runtime.rootPart = root
		if not root then return end
	end
	if not isBasePart(runtime.fakeRoot) or not runtime.fakeRoot.Parent then
		local fake = createFakeRoot(root)
		if fake then assignFakeReplicationRoot(root, fake) end
		return
	end
	local fake = runtime.fakeRoot
	local ok, rootPos = pcall(function() return root.Position end)
	if ok then
		pcall(function() fake.CFrame = CFrame.new(rootPos.X, FAKE_ROOT_Y, rootPos.Z) end)
	end
	pcall(function()
		fake.Anchored = true
		fake.AssemblyLinearVelocity = Vector3.zero
	end)
	local got, current = getHidden(root, "PhysicsRepRootPart")
	if not got or current ~= fake then
		setHidden(root, "PhysicsRepRootPart", fake)
	end
end

local function startStepConnection()
	stopStepConnection()
	runtime.stepConnection = RunService.Stepped:Connect(stepDesync)
end

local function setHookAnti(on)
	on = on == true
	HookAntiEnabled = on
	runtime.enabled = on
	if on then
		local root = getCurrentRoot(LocalPlayer.Character)
		runtime.character = LocalPlayer.Character
		runtime.rootPart = root
		if not root then
			HookAntiEnabled = false
			runtime.enabled = false
			saveConfig()
			return false
		end
		local fake = createFakeRoot(root)
		assignFakeReplicationRoot(root, fake)
		startStepConnection()
	else
		stopStepConnection()
		restoreReplicationRoot()
		destroyFakeRoot()
	end
	saveConfig()
	return HookAntiEnabled
end

-- ===================== INF JUMP =====================
local function stopInfiniteJump()
	for _, c in ipairs(infJumpConns) do pcall(function() c:Disconnect() end) end
	infJumpConns = {}
	spacePressed = false
end

local function startInfiniteJump()
	stopInfiniteJump()
	local inputConn = UserInputService.InputBegan:Connect(function(inp, gpe)
		if gpe or not InfJumpHoldEnabled then return end
		if inp.KeyCode == Enum.KeyCode.Space then spacePressed = true end
	end)
	local inputEndConn = UserInputService.InputEnded:Connect(function(inp)
		if inp.KeyCode == Enum.KeyCode.Space then spacePressed = false end
	end)
	local jumpReqConn = UserInputService.JumpRequest:Connect(function()
		if not InfJumpHoldEnabled then return end
		local hrp, hum = getCurrentRoot(), getHumanoid()
		if hrp and hum then SetYVel(hrp, math.clamp(JUMP_POWER, 5, 200)) end
	end)
	local heartConn = RunService.Heartbeat:Connect(function()
		if not InfJumpHoldEnabled then return end
		local hrp, hum = getCurrentRoot(), getHumanoid()
		if not hrp or not hum then return end
		if spacePressed and hum:GetState() == Enum.HumanoidStateType.Freefall then
			SetYVel(hrp, math.clamp(JUMP_POWER, 5, 200))
		end
	end)
	infJumpConns = {inputConn, inputEndConn, jumpReqConn, heartConn}
end

local function setInfJump(on)
	InfJumpHoldEnabled = on == true
	if InfJumpHoldEnabled then startInfiniteJump() else stopInfiniteJump() end
	saveConfig()
end

local function bindCharacter(character)
	runtime.character = character
	runtime.rootPart = getCurrentRoot(character)
	applyS2Hook(character)
	pcall(function()
		hookHitHumanoid(character:FindFirstChildOfClass("Humanoid"))
		hookHitTouched(getCurrentRoot(character))
	end)
	if AntiBatEnabled then
		task.delay(0.3, function() if AntiBatEnabled then startAntiBat() end end)
	end
	if HookAntiEnabled then
		task.delay(0.3, function() if HookAntiEnabled then setHookAnti(true) end end)
	end
	if InfJumpHoldEnabled then
		task.delay(0.3, function() if InfJumpHoldEnabled then startInfiniteJump() end end)
	end
end

LocalPlayer.CharacterAdded:Connect(function(char)
	task.defer(bindCharacter, char)
end)
if LocalPlayer.Character then bindCharacter(LocalPlayer.Character) end

-- ===================== GUI =====================
local RED = Color3.fromRGB(220, 40, 60)
local GREEN = Color3.fromRGB(80, 200, 120)
local CARD = Color3.fromRGB(22, 22, 28)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Lunar Anti Tp Bat"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 10
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Active = true
Main.ClipsDescendants = true
Main.Position = UDim2.new(0.5, -165, 0.5, -152)
Main.Size = UDim2.new(0, 330, 0, 305)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local BgImage = Instance.new("ImageLabel", Main)
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = currentBg
BgImage.ImageTransparency = 0.25
BgImage.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner", BgImage).CornerRadius = UDim.new(0, 14)

local Overlay = Instance.new("Frame", Main)
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 0.55
Overlay.BorderSizePixel = 0
Instance.new("UICorner", Overlay).CornerRadius = UDim.new(0, 14)

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 46)
Header.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Header.BackgroundTransparency = 0.35
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel", Header)
Title.Position = UDim2.new(0, 16, 0, 6)
Title.Size = UDim2.new(1, -100, 0, 20)
Title.BackgroundTransparency = 1
Title.Text = "LUNAR ANTI TP BAT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left

local Sub = Instance.new("TextLabel", Header)
Sub.Position = UDim2.new(0, 16, 0, 26)
Sub.Size = UDim2.new(1, -100, 0, 14)
Sub.BackgroundTransparency = 1
Sub.Text = "toi normal / autres chaos"
Sub.TextColor3 = Color3.fromRGB(160, 160, 170)
Sub.TextSize = 11
Sub.Font = Enum.Font.Gotham
Sub.TextXAlignment = Enum.TextXAlignment.Left

local ChangeBgBtn = Instance.new("TextButton", Header)
ChangeBgBtn.Position = UDim2.new(1, -90, 0.5, -12)
ChangeBgBtn.Size = UDim2.new(0, 74, 0, 24)
ChangeBgBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ChangeBgBtn.BackgroundTransparency = 0.5
ChangeBgBtn.Text = "Change BG"
ChangeBgBtn.TextColor3 = Color3.fromRGB(230, 230, 240)
ChangeBgBtn.TextSize = 11
ChangeBgBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ChangeBgBtn).CornerRadius = UDim.new(0, 6)

local StatusCard = Instance.new("Frame", Main)
StatusCard.Position = UDim2.new(0, 12, 0, 54)
StatusCard.Size = UDim2.new(1, -24, 0, 32)
StatusCard.BackgroundColor3 = CARD
StatusCard.BackgroundTransparency = 0.8
Instance.new("UICorner", StatusCard).CornerRadius = UDim.new(0, 8)

local StatusDot = Instance.new("Frame", StatusCard)
StatusDot.Position = UDim2.new(0, 12, 0.5, -5)
StatusDot.Size = UDim2.new(0, 10, 0, 10)
StatusDot.BackgroundColor3 = RED
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

local StatusText = Instance.new("TextLabel", StatusCard)
StatusText.Position = UDim2.new(0, 30, 0, 0)
StatusText.Size = UDim2.new(1, -40, 1, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "INACTIVE"
StatusText.TextColor3 = RED
StatusText.TextSize = 13
StatusText.Font = Enum.Font.GothamBold
StatusText.TextXAlignment = Enum.TextXAlignment.Left

local function makeRow(y, labelText, initialKey)
	local row = Instance.new("Frame", Main)
	row.Position = UDim2.new(0, 12, 0, y)
	row.Size = UDim2.new(1, -24, 0, 40)
	row.BackgroundColor3 = CARD
	row.BackgroundTransparency = 0.8
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
	local lbl = Instance.new("TextLabel", row)
	lbl.Position = UDim2.new(0, 12, 0, 0)
	lbl.Size = UDim2.new(0, 110, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText
	lbl.TextColor3 = Color3.fromRGB(230, 230, 240)
	lbl.TextSize = 13
	lbl.Font = Enum.Font.GothamBold
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	local keyBtn = Instance.new("TextButton", row)
	keyBtn.ZIndex = 2
	keyBtn.Position = UDim2.new(1, -106, 0.5, -11)
	keyBtn.Size = UDim2.new(0, 44, 0, 22)
	keyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
	keyBtn.BackgroundTransparency = 0.5
	keyBtn.Text = "[" .. tostring(initialKey) .. "]"
	keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	keyBtn.TextSize = 12
	keyBtn.Font = Enum.Font.GothamBlack
	Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)
	local bg = Instance.new("Frame", row)
	bg.Position = UDim2.new(1, -54, 0.5, -11)
	bg.Size = UDim2.new(0, 42, 0, 22)
	bg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	bg.BackgroundTransparency = 0.5
	Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
	local kn = Instance.new("Frame", bg)
	kn.Position = UDim2.new(0, 3, 0.5, -8)
	kn.Size = UDim2.new(0, 16, 0, 16)
	kn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", kn).CornerRadius = UDim.new(1, 0)
	local btn = Instance.new("TextButton", row)
	btn.ZIndex = 1
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	return bg, kn, btn, keyBtn
end

local AntiBatBg, AntiBatKn, AntiBatBtn, AntiBatKey = makeRow(94, "Anti Bat", KeyAntiBat)
local AntiTpBg, AntiTpKn, AntiTpBtn, AntiTpKey = makeRow(140, "Anti TP Bat", KeyAntiTp)
local InfBg, InfKn, InfBtn, InfJumpKey = makeRow(186, "Hold Inf Jump", KeyInfJump)
local HitBg, HitKn, HitBtn, HitKey = makeRow(232, "Hit x3", KeyHitSpam)

local Footer = Instance.new("TextLabel", Main)
Footer.Position = UDim2.new(0, 12, 0, 278)
Footer.Size = UDim2.new(1, -24, 0, 18)
Footer.BackgroundTransparency = 1
Footer.Text = "Restore local fort (toi stable)"
Footer.TextColor3 = Color3.fromRGB(160, 160, 170)
Footer.TextSize = 11
Footer.Font = Enum.Font.GothamBold

local BgPopup = Instance.new("Frame", ScreenGui)
BgPopup.Visible = false
BgPopup.ZIndex = 30
BgPopup.AnchorPoint = Vector2.new(0.5, 0.5)
BgPopup.Position = UDim2.new(0.5, 0, 0.5, 0)
BgPopup.Size = UDim2.new(0, 280, 0, 180)
BgPopup.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
BgPopup.BorderSizePixel = 0
Instance.new("UICorner", BgPopup).CornerRadius = UDim.new(0, 12)

local ClosePopup = Instance.new("TextButton", BgPopup)
ClosePopup.ZIndex = 31
ClosePopup.Position = UDim2.new(1, -70, 0, 10)
ClosePopup.Size = UDim2.new(0, 56, 0, 24)
ClosePopup.BackgroundColor3 = RED
ClosePopup.Text = "Close"
ClosePopup.TextColor3 = Color3.fromRGB(255, 255, 255)
ClosePopup.TextSize = 12
ClosePopup.Font = Enum.Font.GothamBold
Instance.new("UICorner", ClosePopup).CornerRadius = UDim.new(0, 6)

local Grid = Instance.new("ScrollingFrame", BgPopup)
Grid.ZIndex = 31
Grid.Position = UDim2.new(0, 12, 0, 44)
Grid.Size = UDim2.new(1, -24, 1, -56)
Grid.BackgroundTransparency = 1
Grid.ScrollBarThickness = 4
Grid.CanvasSize = UDim2.new(0, 0, 0, 180)

local bgList = {
	"rbxassetid://102877336629662",
	"rbxassetid://14640607134",
	"rbxassetid://139546609567893",
	"rbxassetid://14430330747",
	"rbxassetid://17256388271",
	"rbxassetid://132372803152269",
}
for i, id in ipairs(bgList) do
	local col = (i - 1) % 3
	local row = math.floor((i - 1) / 3)
	local btn = Instance.new("ImageButton", Grid)
	btn.ZIndex = 32
	btn.Position = UDim2.new(0, col * 84, 0, row * 84)
	btn.Size = UDim2.new(0, 76, 0, 76)
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	btn.Image = id
	btn.ScaleType = Enum.ScaleType.Crop
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	btn.MouseButton1Click:Connect(function()
		currentBg = id
		BgImage.Image = id
		BgPopup.Visible = false
		saveConfig()
	end)
end
ChangeBgBtn.MouseButton1Click:Connect(function() BgPopup.Visible = not BgPopup.Visible end)
ClosePopup.MouseButton1Click:Connect(function() BgPopup.Visible = false end)

local listeningFor = nil
local function refreshKeyTexts()
	AntiBatKey.Text = listeningFor == "AntiBat" and "[...]" or "[" .. KeyAntiBat .. "]"
	AntiTpKey.Text = listeningFor == "AntiTp" and "[...]" or "[" .. KeyAntiTp .. "]"
	InfJumpKey.Text = listeningFor == "InfJump" and "[...]" or "[" .. KeyInfJump .. "]"
	HitKey.Text = listeningFor == "HitSpam" and "[...]" or "[" .. KeyHitSpam .. "]"
end
AntiBatKey.MouseButton1Click:Connect(function() listeningFor = "AntiBat" refreshKeyTexts() end)
AntiTpKey.MouseButton1Click:Connect(function() listeningFor = "AntiTp" refreshKeyTexts() end)
InfJumpKey.MouseButton1Click:Connect(function() listeningFor = "InfJump" refreshKeyTexts() end)
HitKey.MouseButton1Click:Connect(function() listeningFor = "HitSpam" refreshKeyTexts() end)

local function setToggleVisual(bg, kn, on)
	TweenService:Create(bg, TweenInfo.new(0.15), {BackgroundColor3 = on and GREEN or Color3.fromRGB(40, 40, 50)}):Play()
	TweenService:Create(kn, TweenInfo.new(0.15), {Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
end

local function refreshStatus()
	local any = AntiBatEnabled or HookAntiEnabled
	StatusText.Text = any and "ACTIVE" or "INACTIVE"
	if HitBurstRunning then StatusText.Text = "HIT x3..." end
	StatusText.TextColor3 = any and GREEN or RED
	StatusDot.BackgroundColor3 = any and GREEN or RED
end

syncAntiBatVisual = function(phaseOn)
	setToggleVisual(AntiBatBg, AntiBatKn, phaseOn == true)
	refreshStatus()
end

AntiBatBtn.MouseButton1Click:Connect(function()
	if listeningFor then return end
	setAntiBat(not AntiBatEnabled)
	setToggleVisual(AntiBatBg, AntiBatKn, AntiBatEnabled)
	refreshStatus()
end)
AntiTpBtn.MouseButton1Click:Connect(function()
	if listeningFor then return end
	setHookAnti(not HookAntiEnabled)
	setToggleVisual(AntiTpBg, AntiTpKn, HookAntiEnabled)
	refreshStatus()
end)
InfBtn.MouseButton1Click:Connect(function()
	if listeningFor then return end
	setInfJump(not InfJumpHoldEnabled)
	setToggleVisual(InfBg, InfKn, InfJumpHoldEnabled)
end)
HitBtn.MouseButton1Click:Connect(function()
	if listeningFor then return end
	setHitSpam(not HitSpamEnabled)
	setToggleVisual(HitBg, HitKn, HitSpamEnabled)
	refreshStatus()
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	if listeningFor then
		local name = input.KeyCode.Name
		if name == "Escape" or gp then listeningFor = nil refreshKeyTexts() return end
		if name ~= "Unknown" and name ~= "" then
			if listeningFor == "AntiBat" then KeyAntiBat = name
			elseif listeningFor == "AntiTp" then KeyAntiTp = name
			elseif listeningFor == "InfJump" then KeyInfJump = name
			elseif listeningFor == "HitSpam" then KeyHitSpam = name end
			saveConfig()
		end
		listeningFor = nil
		refreshKeyTexts()
		return
	end
	if gp then return end
	local name = input.KeyCode.Name
	if name == KeyAntiBat then
		setAntiBat(not AntiBatEnabled)
		setToggleVisual(AntiBatBg, AntiBatKn, AntiBatEnabled)
		refreshStatus()
	elseif name == KeyAntiTp then
		setHookAnti(not HookAntiEnabled)
		setToggleVisual(AntiTpBg, AntiTpKn, HookAntiEnabled)
		refreshStatus()
	elseif name == KeyInfJump then
		setInfJump(not InfJumpHoldEnabled)
		setToggleVisual(InfBg, InfKn, InfJumpHoldEnabled)
	elseif name == KeyHitSpam then
		setHitSpam(not HitSpamEnabled)
		setToggleVisual(HitBg, HitKn, HitSpamEnabled)
		refreshStatus()
	end
end)

local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local d = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)

setToggleVisual(AntiBatBg, AntiBatKn, AntiBatEnabled)
setToggleVisual(AntiTpBg, AntiTpKn, HookAntiEnabled)
setToggleVisual(InfBg, InfKn, InfJumpHoldEnabled)
setToggleVisual(HitBg, HitKn, HitSpamEnabled)
refreshStatus()
refreshKeyTexts()
if AntiBatEnabled then startAntiBat() end
if HookAntiEnabled then setHookAnti(true) end
if InfJumpHoldEnabled then startInfiniteJump() end

runtime.destroy = function()
	runtime.alive = false
	if hitHealthConn then pcall(function() hitHealthConn:Disconnect() end) end
	if hitTouchedConn then pcall(function() hitTouchedConn:Disconnect() end) end
	stopAntiBat()
	stopInfiniteJump()
	stopStepConnection()
	restoreReplicationRoot()
	destroyFakeRoot()
	pcall(function() ScreenGui:Destroy() end)
	environment.__LUNAR_RUNTIME = nil
end

print("[LUNAR] Anti Bat = toi normal / autres chaos (restore fort)")