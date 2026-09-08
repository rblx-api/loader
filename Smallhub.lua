-- leak by FS│https://discord.gg/TBBAUZu8cW

-- [[
    NOX - UI REDESIGN
    - Abas na esquerda (Brainrots / Settings)
    - Linha divisória vertical
    - Botões Flash, Block, Reset na parte inferior
    - Tudo arredondado
    - Bordas com efeito vermelho/preto
    - Cores vermelho e preto
    - Sem emojis
    - Nome: NOX
    - F12 = gethui() + Dex Explorer
]]
if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ActiveConnections = {}
local thisScriptStopped = false

-- ==========================================
-- F12: gethui() + DEX EXPLORER
-- ==========================================
local function loadDexExplorer()
	pcall(function()
		-- Fecha Dex se já estiver aberto
		for _, gui in ipairs(gethui():GetChildren()) do
			if gui.Name == "DexExplorer" or gui.Name == "Dark Dex" or string.find(gui.Name, "Dex") then
				gui:Destroy()
			end
		end
	end)

	-- Carrega o Dex Explorer
	local dexLoaded = false
	local dexScripts = {
		"https://raw.githubusercontent.com/infinite1337/dex/main/Dex%20V2.lua",
		"https://raw.githubusercontent.com/CrystallizeS/Roblox-Exploits/main/Dex",
		"https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/Modules/Dex.lua",
	}

	for _, url in ipairs(dexScripts) do
		if not dexLoaded then
			pcall(function()
				local dex = loadstring(game:HttpGet(url))()
				if dex then
					dexLoaded = true
				end
			end)
		end
	end

	-- Se não carregou, tenta com o Infinite Yield Dex
	if not dexLoaded then
		pcall(function()
			local dex = loadstring(
				game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/Modules/Dex.lua")
			)()
		end)
	end
end

-- Mostra o gethui() no console e carrega Dex
local function openDex()
	print("=== GETHUI() ===")
	local guiList = gethui():GetChildren()
	for i, gui in ipairs(guiList) do
		print(string.format("[%d] %s (%s)", i, gui.Name, gui.ClassName))
	end
	print("=================")

	-- Carrega Dex
	loadDexExplorer()

	-- Mensagem no chat
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "NOX",
			Text = "Dex Explorer aberto!",
			Duration = 3,
		})
	end)
end

-- Bind F12
local f12Conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.F12 then
		task.spawn(openDex)
	end
end)
table.insert(ActiveConnections, f12Conn)

-- ==========================================
-- RESET SYSTEM (ResetLite - no permanent Flash break)
-- ==========================================
local RESET_MAX_DURATION = 0.05
local resetCooldown = false
local resetThread = nil
local currentCharacter = nil
local resetSuccessful = false
local stopResetSequence = false
local cameraLocked = false
local lockedCameraCFrame = nil
local resetLockId = 0

local function forceUnlockEverything()
	cameraLocked = false
	lockedCameraCFrame = nil
	stopResetSequence = true
	resetCooldown = false
	currentCharacter = nil
	pcall(function()
		if resetThread then
			task.cancel(resetThread)
		end
	end)
	resetThread = nil
	pcall(function()
		local cam = workspace.CurrentCamera
		if cam then
			cam.CameraType = Enum.CameraType.Custom
			local char = LocalPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then
				cam.CameraSubject = hum
			end
		end
	end)
	local char = LocalPlayer.Character
	if char then
		pcall(function()
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				if hum.HipHeight > 10 or hum.HipHeight < 0 then
					hum.HipHeight = 2
				end
				hum.PlatformStand = false
				hum.Sit = false
				hum.AutoRotate = true
			end
			local root = char:FindFirstChild("HumanoidRootPart")
			if root then
				root.CanCollide = true
			end
			for _, p in ipairs(char:GetChildren()) do
				if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
					p.CanCollide = true
				end
			end
		end)
	end
end

_G.HugoForceUnlock = forceUnlockEverything

local function ResetPlayer()
	if resetCooldown then
		return
	end
	resetCooldown = true
	resetSuccessful = false
	stopResetSequence = false

	local character = LocalPlayer.Character
	if not character then
		resetCooldown = false
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		resetCooldown = false
		return
	end

	resetLockId = resetLockId + 1
	local myLockId = resetLockId

	local camera = workspace.CurrentCamera
	if camera then
		lockedCameraCFrame = camera.CFrame
		cameraLocked = true
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = lockedCameraCFrame
	end

	currentCharacter = character
	local originalHipHeight = humanoid.HipHeight
	if type(originalHipHeight) ~= "number" or originalHipHeight > 10 or originalHipHeight < 0 then
		originalHipHeight = 2
	end
	local isRespawning = false

	resetThread = task.spawn(function()
		local attempts = 0
		local maxAttempts = 25

		while
			character
			and character.Parent
			and humanoid
			and humanoid.Health > 0
			and not isRespawning
			and not stopResetSequence
			and myLockId == resetLockId
		do
			if LocalPlayer.Character ~= character then
				isRespawning = true
				break
			end

			pcall(function()
				humanoid.HipHeight = 1e30
				humanoid.AutoRotate = true
				local root = character:FindFirstChild("HumanoidRootPart")
				if root then
					root.CanCollide = false
				end
				for _, part in ipairs(character:GetChildren()) do
					if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
						part.CanCollide = false
					end
				end
			end)

			if not character.Parent or humanoid.Health <= 0 or LocalPlayer.Character ~= character then
				resetSuccessful = true
				break
			end

			attempts = attempts + 1
			if attempts >= maxAttempts then
				break
			end
			task.wait(RESET_MAX_DURATION)
		end

		if character and character.Parent and humanoid then
			pcall(function()
				humanoid.HipHeight = originalHipHeight
			end)
		end

		if not resetSuccessful and not isRespawning and myLockId == resetLockId and not stopResetSequence then
			if character and character.Parent and humanoid and humanoid.Health > 0 then
				pcall(function()
					humanoid.Health = 0
				end)
				task.wait(0.1)
				if not character.Parent or humanoid.Health <= 0 then
					resetSuccessful = true
				end
			end
		end

		if not resetSuccessful and character and character.Parent and myLockId == resetLockId then
			pcall(function()
				humanoid.HipHeight = originalHipHeight
				humanoid.PlatformStand = false
				humanoid.AutoRotate = true
				local root = character:FindFirstChild("HumanoidRootPart")
				if root then
					root.CanCollide = true
				end
				for _, part in ipairs(character:GetChildren()) do
					if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
						part.CanCollide = true
					end
				end
			end)
		end

		if myLockId == resetLockId then
			cameraLocked = false
			lockedCameraCFrame = nil
			resetCooldown = false
			resetThread = nil
			currentCharacter = nil
			stopResetSequence = false
			pcall(function()
				local cam = workspace.CurrentCamera
				if cam then
					cam.CameraType = Enum.CameraType.Custom
					local newChar = LocalPlayer.Character
					local newHum = newChar and newChar:FindFirstChildOfClass("Humanoid")
					if newHum then
						cam.CameraSubject = newHum
					end
				end
			end)
		end
	end)
end

local function StopResetSequence()
	forceUnlockEverything()
end

table.insert(
	ActiveConnections,
	LocalPlayer.CharacterAdded:Connect(function(newChar)
		resetLockId = resetLockId + 1
		forceUnlockEverything()
		resetSuccessful = false

		task.defer(function()
			task.wait(0.2)
			forceUnlockEverything()
			if newChar and newChar.Parent then
				pcall(function()
					local hum = newChar:FindFirstChildOfClass("Humanoid")
					if hum then
						hum.HipHeight = 2
						hum.PlatformStand = false
						hum.AutoRotate = true
					end
					local cam = workspace.CurrentCamera
					if cam then
						cam.CameraType = Enum.CameraType.Custom
						cam.CameraSubject = hum
					end
				end)
			end
		end)
	end)
)

task.spawn(function()
	while true do
		task.wait(0.016)
		if cameraLocked and lockedCameraCFrame then
			local camera = workspace.CurrentCamera
			if camera then
				camera.CameraType = Enum.CameraType.Scriptable
				camera.CFrame = lockedCameraCFrame
			end
		end
	end
end)

-- ==========================================
-- AUTO RESET (Balloon / Tiny / Jail)
-- ==========================================
do
	local cooldown = false
	local function tryReset()
		if cooldown or resetCooldown or thisScriptStopped then
			return
		end
		cooldown = true
		pcall(ResetPlayer)
		task.delay(1.2, function()
			cooldown = false
		end)
	end

	local function isBallooned(char)
		if not char then
			return false
		end
		if char:FindFirstChild("Balloon") or char:FindFirstChild("BalloonConstraint") then
			return true
		end
		for _, d in ipairs(char:GetDescendants()) do
			local n = string.lower(d.Name)
			if n:find("balloon") then
				return true
			end
		end
		if LocalPlayer:GetAttribute("jump higher") or LocalPlayer:GetAttribute("JumpHigher") then
			return true
		end
		if char:GetAttribute("jump higher") or char:GetAttribute("JumpHigher") then
			return true
		end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			if hum:GetAttribute("jump higher") or hum:GetAttribute("JumpHigher") then
				return true
			end
			if hum.JumpHeight and hum.JumpHeight > 15 then
				return true
			end
		end
		return false
	end

	local function isTiny(char)
		if not char then
			return false
		end
		if char:FindFirstChild("Tiny") then
			return true
		end
		local scale = char:GetAttribute("Scale") or char:GetAttribute("Tiny") or char:GetAttribute("IsTiny")
		if type(scale) == "boolean" and scale then
			return true
		end
		if type(scale) == "number" and scale < 0.7 then
			return true
		end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			local hs = hum:FindFirstChild("BodyHeightScale")
			if hs and hs:IsA("NumberValue") and hs.Value < 0.7 then
				return true
			end
			if hum:GetAttribute("Tiny") or hum:GetAttribute("IsTiny") then
				return true
			end
		end
		for _, d in ipairs(char:GetChildren()) do
			if string.lower(d.Name):find("tiny") then
				return true
			end
		end
		return false
	end

	local function isJailed(char)
		if not char then
			return false
		end
		if
			LocalPlayer:GetAttribute("Jailed")
			or LocalPlayer:GetAttribute("Jail")
			or LocalPlayer:GetAttribute("InJail")
		then
			return true
		end
		if char:GetAttribute("Jailed") or char:GetAttribute("Jail") or char:GetAttribute("InJail") then
			return true
		end
		if char:FindFirstChild("Jail") or char:FindFirstChild("Jailed") then
			return true
		end
		for _, d in ipairs(char:GetChildren()) do
			if string.lower(d.Name):find("jail") then
				return true
			end
		end
		return false
	end

	local function hook(char)
		if not char then
			return
		end
		table.insert(
			ActiveConnections,
			char.DescendantAdded:Connect(function(obj)
				if thisScriptStopped then
					return
				end
				local n = string.lower(obj.Name or "")
				if _G.AutoResetOnBalloon and n:find("balloon") then
					tryReset()
				elseif _G.AutoResetOnTiny and n:find("tiny") then
					tryReset()
				elseif _G.AutoResetOnJail and n:find("jail") then
					tryReset()
				end
			end)
		)
		local function watch(inst, attr, flag)
			pcall(function()
				table.insert(
					ActiveConnections,
					inst:GetAttributeChangedSignal(attr):Connect(function()
						if thisScriptStopped or not _G[flag] then
							return
						end
						if inst:GetAttribute(attr) then
							tryReset()
						end
					end)
				)
			end)
		end
		for _, a in ipairs({ "jump higher", "JumpHigher", "Balloon", "Ballooned" }) do
			watch(LocalPlayer, a, "AutoResetOnBalloon")
			watch(char, a, "AutoResetOnBalloon")
		end
		for _, a in ipairs({ "Tiny", "IsTiny", "Scale" }) do
			watch(LocalPlayer, a, "AutoResetOnTiny")
			watch(char, a, "AutoResetOnTiny")
		end
		for _, a in ipairs({ "Jailed", "Jail", "InJail" }) do
			watch(LocalPlayer, a, "AutoResetOnJail")
			watch(char, a, "AutoResetOnJail")
		end
	end

	task.spawn(function()
		while not thisScriptStopped do
			task.wait(0.2)
			local char = LocalPlayer.Character
			if char then
				if _G.AutoResetOnBalloon and isBallooned(char) then
					tryReset()
				elseif _G.AutoResetOnTiny and isTiny(char) then
					tryReset()
				elseif _G.AutoResetOnJail and isJailed(char) then
					tryReset()
				end
			end
		end
	end)

	table.insert(
		ActiveConnections,
		LocalPlayer.CharacterAdded:Connect(function(c)
			task.defer(function()
				task.wait(0.15)
				hook(c)
			end)
		end)
	)
	if LocalPlayer.Character then
		task.defer(function()
			hook(LocalPlayer.Character)
		end)
	end
end

-- ==========================================
-- GLOBAL SETTINGS DEFAULTS
-- ==========================================
_G.AutoResetOnBalloon = _G.AutoResetOnBalloon ~= false and true or false
_G.AutoResetOnTiny = _G.AutoResetOnTiny or false
_G.AutoResetOnJail = _G.AutoResetOnJail or false
_G.AutoGiant = _G.AutoGiant or false
_G.AutoBlock = _G.AutoBlock or false
_G.BlockDelay = _G.BlockDelay or "fast"
_G.RagdollBypass = _G.RagdollBypass or false
_G.AntiSwap = _G.AntiSwap or false
_G.AutoFlashTP = _G.AutoFlashTP or false
_G.APESP = _G.APESP or false
_G.SlotESP = _G.SlotESP ~= false and true or false
_G.ESPTimer = _G.ESPTimer or false
_G.SelectedCarpet = _G.SelectedCarpet or "carpet"
_G.AutoBalloon = _G.AutoBalloon or false
_G.AutoReturnBase = _G.AutoReturnBase or false
_G.BrainrotHighlight = _G.BrainrotHighlight ~= false and true or false
_G.TpPathVisual = false
_G.QuickPickup = false
_G.LaggerOnFlash = _G.LaggerOnFlash or false
_G.LaggerPower = _G.LaggerPower or 50
_G.QuickAP = _G.QuickAP or false
_G.AntiRagdoll = _G.AntiRagdoll or false
_G.AutoSelectBest = _G.AutoSelectBest or false
_G.WalkItem = _G.WalkItem or "Flying Carpet"

-- ==========================================
-- SAVE / LOAD SETTINGS
-- ==========================================
local SETTINGS_FILE = "nox_merged_settings.json"

local function loadSettings()
	local ok, data = pcall(function()
		return HttpService:JSONDecode(readfile(SETTINGS_FILE))
	end)
	if ok and type(data) == "table" then
		return data
	end
	return {}
end

local function saveSettings()
	pcall(function()
		writefile(
			SETTINGS_FILE,
			HttpService:JSONEncode({
				AutoResetOnBalloon = _G.AutoResetOnBalloon,
				AutoResetOnTiny = _G.AutoResetOnTiny,
				AutoResetOnJail = _G.AutoResetOnJail,
				AutoGiant = _G.AutoGiant,
				AutoBlock = _G.AutoBlock,
				BlockDelay = _G.BlockDelay,
				RagdollBypass = _G.RagdollBypass,
				AntiSwap = _G.AntiSwap,
				AutoFlashTP = _G.AutoFlashTP,
				APESP = _G.APESP,
				SlotESP = _G.SlotESP,
				ESPTimer = _G.ESPTimer,
				SelectedCarpet = _G.SelectedCarpet,
				AutoBalloon = _G.AutoBalloon,
				AutoReturnBase = _G.AutoReturnBase,
				BrainrotHighlight = _G.BrainrotHighlight,
				TpPathVisual = _G.TpPathVisual,
				QuickPickup = _G.QuickPickup,
				LaggerOnFlash = _G.LaggerOnFlash,
				LaggerPower = _G.LaggerPower,
				QuickAP = _G.QuickAP,
				AntiRagdoll = _G.AntiRagdoll,
				AutoSelectBest = _G.AutoSelectBest,
				WalkItem = _G.WalkItem,
			})
		)
	end)
end

local savedSettings = loadSettings()
for k, secondaryK in pairs(savedSettings) do
	if _G[k] ~= nil then
		_G[k] = secondaryK
	end
end

-- ==========================================
-- PING LAGGER
-- ==========================================
local laggerConn = nil
local function startFlashLagger()
	if not _G.LaggerOnFlash then
		return
	end
	local strength = math.clamp((_G.LaggerPower or 50) / 40, 0.3, 3.0)
	pcall(function()
		settings().Network.IncomingReplicationLag = strength
	end)
	if laggerConn then
		laggerConn:Disconnect()
		laggerConn = nil
	end
	laggerConn = task.delay(2.5, function()
		pcall(function()
			settings().Network.IncomingReplicationLag = 0
		end)
		laggerConn = nil
	end)
end

local function stopFlashLagger()
	if laggerConn then
		pcall(function()
			laggerConn:Disconnect()
		end)
		laggerConn = nil
	end
	pcall(function()
		settings().Network.IncomingReplicationLag = 0
	end)
end

-- ==========================================
-- MULTI ZONES
-- ==========================================
local MultiZones = {
	{ Shape = "Line", Center = Vector3.new(-345.35, -6.55, 39.19), Size = 5, Rotation = 0 },
	{ Shape = "Line", Center = Vector3.new(-350.53, -6.55, 38.67), Size = 20, Rotation = 0 },
	{ Shape = "Line", Center = Vector3.new(-364.01, -6.55, 38.94), Size = 20, Rotation = 0 },
	{ Shape = "Line", Center = Vector3.new(-337.34, -6.55, 39.18), Size = 20, Rotation = 0 },
	{ Shape = "Square", Center = Vector3.new(-365.29, -6.95, -10.40), Size = 20, Rotation = 0 },
	{ Shape = "Square", Center = Vector3.new(-354.68, -6.95, 6.22), Size = 20, Rotation = 0 },
	{ Shape = "Square", Center = Vector3.new(-343.15, -6.53, -13.20), Size = 20, Rotation = 0 },
	{ Shape = "Square", Center = Vector3.new(-344.93, -6.95, 25.73), Size = 20, Rotation = 0 },
	{ Shape = "Square", Center = Vector3.new(-343.76, -6.95, -10.27), Size = 20, Rotation = 0 },
	{ Shape = "Square", Center = Vector3.new(-354.42, -6.95, 6.51), Size = 20, Rotation = 0 },
	{ Shape = "Square", Center = Vector3.new(-340.48, -5.32, 28.10), Size = 20, Rotation = 0 },
	{ Shape = "Square", Center = Vector3.new(-361.10, -6.95, 29.42), Size = 20, Rotation = 0 },
	{ Shape = "Line", Center = Vector3.new(-354.83, 27.19, 31.22), Size = 20, Rotation = 0 },
}

local function isInAnyZone(position)
	for _, zone in ipairs(MultiZones) do
		local half = zone.Size / 2
		local dx = math.abs(position.X - zone.Center.X)
		local dz = math.abs(position.Z - zone.Center.Z)
		if zone.Shape == "Line" then
			if dx <= half and dz <= 1.5 then
				return true
			end
		elseif zone.Shape == "Square" then
			if dx <= half and dz <= half then
				return true
			end
		end
	end
	return false
end

local function hasBrainrot(targetPlayer)
	if not targetPlayer.Character then
		return false
	end
	local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root then
		return false
	end
	local playerNames = {}
	for _, p in pairs(Players:GetPlayers()) do
		playerNames[p.Name] = true
	end
	for _, rootPartContainer in pairs(Workspace:GetDescendants()) do
		if
			rootPartContainer:IsA("Model")
			and not playerNames[rootPartContainer.Name]
			and not rootPartContainer:IsDescendantOf(targetPlayer.Character)
		then
			local rp = rootPartContainer:FindFirstChild("RootPart") or rootPartContainer:FindFirstChild("FakeRootPart")
			if rp and (rp.Position - root.Position).Magnitude < 8 then
				return true
			end
		end
	end
	return false
end

-- ==========================================
-- ADMIN COMMAND HELPERS
-- ==========================================
local function findAdminPanel()
	return PlayerGui:FindFirstChild("AdminPanel")
end

local function findPlayerButton(targetPlayer)
	local adminPanel = findAdminPanel()
	if not adminPanel then
		return nil
	end
	for _, desc in pairs(adminPanel:GetDescendants()) do
		if desc:IsA("TextButton") or desc:IsA("ImageButton") then
			local t = ""
			if desc:IsA("TextButton") then
				t = desc.Text
			else
				local lbl = desc:FindFirstChildWhichIsA("TextLabel", true)
				if lbl then
					t = lbl.Text
				end
			end
			if
				t == targetPlayer.DisplayName
				or string.find(t, targetPlayer.DisplayName)
				or t == targetPlayer.Name
				or string.find(t, targetPlayer.Name)
			then
				return desc
			end
		end
	end
	return nil
end

local function getCommandButtons()
	local btns = {}
	local adminPanel = findAdminPanel()
	if not adminPanel then
		return btns
	end
	for _, desc in pairs(adminPanel:GetDescendants()) do
		if desc:IsA("TextButton") or desc:IsA("ImageButton") then
			local t = ""
			if desc:IsA("TextButton") then
				t = desc.Text
			else
				local lbl = desc:FindFirstChildWhichIsA("TextLabel", true)
				if lbl then
					t = lbl.Text
				end
			end
			if t and t ~= "" and (t:match("^:") or t:match("^;")) then
				table.insert(btns, { button = desc, name = t })
			end
		end
	end
	return btns
end

local function clickButton(button)
	pcall(function()
		button.MouseButton1Click:Fire()
	end)
	pcall(function()
		button.Activated:Fire()
	end)
	pcall(function()
		if getconnections then
			for _, cx in pairs(getconnections(button.MouseButton1Click)) do
				cx:Fire()
			end
			for _, cx in pairs(getconnections(button.Activated)) do
				cx:Fire()
			end
		end
	end)
end

local function isExactCommand(buttonName, expectedCmdName)
	local bName = string.lower(string.match(buttonName, "^%s*(.-)%s*$") or buttonName)
	local cmdName = string.lower(expectedCmdName)
	if bName == cmdName or bName == ":" .. cmdName or bName == ";" .. cmdName then
		return true
	end
	if string.match(bName, "^[:;]?" .. cmdName .. "$") or string.match(bName, "^[:;]?" .. cmdName .. "%s") then
		return true
	end
	return false
end

local function triggerBalloonOnTarget(targetPlayer)
	if not targetPlayer or not targetPlayer.Parent then
		return
	end
	if not findAdminPanel() then
		return
	end
	for _, cBtn in ipairs(getCommandButtons()) do
		if isExactCommand(cBtn.name, "balloon") then
			clickButton(cBtn.button)
			task.wait(0.02)
			local pBtn = findPlayerButton(targetPlayer)
			if pBtn then
				clickButton(pBtn)
			end
			break
		end
	end
end

-- ==========================================
-- AUTO BALLOON
-- ==========================================
local BalloonState = { Active = {} }

local lastBalloonCheck = 0
RunService.Heartbeat:Connect(function()
	if not _G.AutoBalloon then
		return
	end
	local now = tick()
	if now - lastBalloonCheck < 0.1 then
		return
	end
	lastBalloonCheck = now

	for _, p in pairs(Players:GetPlayers()) do
		if p == LocalPlayer then
			continue
		end
		local character = p.Character
		if not character then
			continue
		end
		local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
		if not rootPart then
			continue
		end

		local targetKey = p.UserId
		local inZone = isInAnyZone(rootPart.Position)
		local withBrainrot = hasBrainrot(p)

		if inZone and withBrainrot and not BalloonState.Active[targetKey] then
			BalloonState.Active[targetKey] = true
			triggerBalloonOnTarget(p)
		elseif (not inZone or not withBrainrot) and BalloonState.Active[targetKey] then
			BalloonState.Active[targetKey] = nil
		end
	end
end)

Players.PlayerRemoving:Connect(function(p)
	BalloonState.Active[p.UserId] = nil
end)

-- ==========================================
-- QUICK PICKUP
-- ==========================================
local QuickPickup = (function()
	local enabled = false
	local orig = {}
	local hooked = false

	local function isMyPlot(plot)
		if not plot or not plot:IsA("Model") then
			return false
		end
		local sign = plot:FindFirstChild("PlotSign")
		return sign and sign:FindFirstChild("YourBase") and sign.YourBase.Enabled
	end

	local function inMyPlot(inst)
		if not inst or not inst.Parent then
			return false
		end
		local node = inst.Parent
		for _ = 1, 10 do
			if not node then
				return false
			end
			if node:IsA("Model") and node.Parent and node.Parent.Name == "Plots" then
				return isMyPlot(node)
			end
			node = node.Parent
		end
		return false
	end

	local function installHook()
		if hooked then
			return
		end
		local ok, mt = pcall(getrawmetatable, game)
		if not ok or not mt then
			return
		end
		local sok = pcall(setreadonly, mt, false)
		if not sok then
			return
		end
		local oldNewIndex = mt.__newindex
		local nc = newcclosure or function(f)
			return f
		end
		mt.__newindex = nc(function(self, key, value)
			if
				not thisScriptStopped
				and key == "HoldDuration"
				and enabled
				and typeof(self) == "Instance"
				and self:IsA("ProximityPrompt")
				and inMyPlot(self)
			then
				value = 0.1
			end
			return oldNewIndex(self, key, value)
		end)
		pcall(setreadonly, mt, true)
		hooked = true
	end

	local M = {}
	function M.set(v)
		enabled = v
		if v then
			installHook()
			task.spawn(function()
				local root = Workspace:FindFirstChild("Plots") or Workspace
				local stack, si = { root }, 1
				local visited = 0
				while si > 0 do
					if not enabled then
						return
					end
					local cur = stack[si]
					stack[si] = nil
					si = si - 1
					local ch = cur:GetChildren()
					for i = 1, #ch do
						local d = ch[i]
						if d:IsA("ProximityPrompt") and inMyPlot(d) then
							if orig[d] == nil then
								orig[d] = d.HoldDuration
							end
							pcall(function()
								d.HoldDuration = 0.1
							end)
						end
						si = si + 1
						stack[si] = d
					end
					visited = visited + 1
					if visited % 40 == 0 then
						task.wait()
					end
				end
			end)
		else
			for p, o in pairs(orig) do
				if p and p.Parent then
					pcall(function()
						p.HoldDuration = o
					end)
				end
			end
			orig = {}
		end
	end
	return M
end)()

if _G.QuickPickup then
	QuickPickup.set(true)
end

-- ==========================================
-- KEYBINDS SYSTEM
-- ==========================================
local keybinds = {
	flash = Enum.KeyCode.F,
	block = Enum.KeyCode.B,
	reset = Enum.KeyCode.R,
}
local keyNames = { flash = "F", block = "B", reset = "R" }

local KB_FILE = "nox_keybinds.json"

local function saveKeybinds()
	pcall(function()
		writefile(
			KB_FILE,
			HttpService:JSONEncode({
				flash = keyNames.flash,
				block = keyNames.block,
				reset = keyNames.reset,
			})
		)
	end)
end

local function loadKeybinds()
	local ok, data = pcall(function()
		return HttpService:JSONDecode(readfile(KB_FILE))
	end)
	if ok and type(data) == "table" then
		for _, action in ipairs({ "flash", "block", "reset" }) do
			if data[action] then
				local success, kc = pcall(function()
					return Enum.KeyCode[data[action]]
				end)
				if success and kc then
					keybinds[action] = kc
					keyNames[action] = data[action]
				end
			end
		end
	end
end

loadKeybinds()

-- ==========================================
-- CHARACTER
-- ==========================================
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")
local Camera = Workspace.CurrentCamera

local autoStealEnabled = false
local stealDelay = 1.30
local isStealing = false
local currentMovement = nil
local selectedPrompt = nil
local selectedSlotNumber = nil

-- ==========================================
-- ANTI RAGDOLL
-- ==========================================
local AntiRagdollConns = {}
local antiRagdollEnabled = _G.AntiRagdoll or false

local function removeRagdollConstraints(char)
	for _, d in ipairs(char:GetDescendants()) do
		if
			d:IsA("BallSocketConstraint")
			or d:IsA("HingeConstraint")
			or d:IsA("NoCollisionConstraint")
			or (d:IsA("Attachment") and d.Name:find("RagdollAttachment"))
		then
			pcall(function()
				d:Destroy()
			end)
		end
	end
end

local function connectAntiRagdollToChar(c)
	local humanoid = c:WaitForChild("Humanoid")
	local root = c:WaitForChild("HumanoidRootPart")
	local animator = humanoid:WaitForChild("Animator")
	local lastVelocity = Vector3.new(0, 0, 0)
	local lastClean = 0
	local isRag = false

	local function IsRagdollState()
		local state = humanoid:GetState()
		return state == Enum.HumanoidStateType.Physics
			or state == Enum.HumanoidStateType.Ragdoll
			or state == Enum.HumanoidStateType.FallingDown
			or state == Enum.HumanoidStateType.GettingUp
	end

	local function CleanRagdollEffects()
		local now = tick()
		if now - lastClean < 0.15 then
			return
		end
		lastClean = now
		for _, obj in pairs(c:GetDescendants()) do
			if
				obj:IsA("BallSocketConstraint")
				or obj:IsA("NoCollisionConstraint")
				or obj:IsA("HingeConstraint")
				or (obj:IsA("Attachment") and (obj.Name == "A" or obj.Name == "B"))
			then
				pcall(function()
					obj:Destroy()
				end)
			elseif obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
				pcall(function()
					obj:Destroy()
				end)
			elseif obj:IsA("Motor6D") then
				obj.Enabled = true
			end
		end
		removeRagdollConstraints(c)
		for _, track in pairs(animator:GetPlayingAnimationTracks()) do
			local animName = track.Animation and track.Animation.Name:lower() or ""
			if animName:find("rag") or animName:find("fall") or animName:find("hurt") or animName:find("down") then
				pcall(function()
					track:Stop(0)
				end)
			end
		end
	end

	local function ReEnableControls()
		pcall(function()
			require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls():Enable()
		end)
	end

	local function AdvancedReset()
		root.Anchored = false
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		for _, obj in ipairs(c:GetDescendants()) do
			if obj:IsA("Motor6D") then
				obj.Enabled = true
			end
		end
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
		humanoid.PlatformStand = false
		humanoid.Sit = false
		if humanoid.Health > 0 then
			humanoid:ChangeState(Enum.HumanoidStateType.Running)
		end
		workspace.CurrentCamera.CameraSubject = humanoid
	end

	table.insert(
		AntiRagdollConns,
		humanoid.StateChanged:Connect(function(_, newState)
			if not antiRagdollEnabled then
				return
			end
			if IsRagdollState() then
				isRag = true
				humanoid:ChangeState(Enum.HumanoidStateType.Running)
				CleanRagdollEffects()
				workspace.CurrentCamera.CameraSubject = humanoid
				ReEnableControls()
			else
				isRag = false
			end
		end)
	)

	table.insert(
		AntiRagdollConns,
		humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
			if not antiRagdollEnabled then
				return
			end
			if humanoid.PlatformStand then
				task.defer(function()
					if not antiRagdollEnabled then
						return
					end
					AdvancedReset()
					removeRagdollConstraints(c)
				end)
			end
		end)
	)

	table.insert(
		AntiRagdollConns,
		RunService.Heartbeat:Connect(function()
			if not antiRagdollEnabled then
				return
			end
			local endTime = LocalPlayer:GetAttribute("RagdollEndTime")
			if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
				isRag = true
			end
			if isRag then
				CleanRagdollEffects()
				local vel = root.AssemblyLinearVelocity
				if (vel - lastVelocity).Magnitude > 40 and vel.Magnitude > 25 then
					root.AssemblyLinearVelocity = vel.Unit * math.min(vel.Magnitude, 15)
				end
				lastVelocity = vel
				if humanoid.PlatformStand then
					AdvancedReset()
				end
			end
		end)
	)

	table.insert(
		AntiRagdollConns,
		c.DescendantAdded:Connect(function(obj)
			if not antiRagdollEnabled then
				return
			end
			if isRag then
				CleanRagdollEffects()
			end
			if
				obj:IsA("BallSocketConstraint")
				or obj:IsA("HingeConstraint")
				or obj:IsA("NoCollisionConstraint")
				or (obj:IsA("Attachment") and obj.Name:find("RagdollAttachment"))
			then
				task.defer(function()
					if not antiRagdollEnabled then
						return
					end
					if obj.Parent then
						pcall(function()
							obj:Destroy()
						end)
					end
				end)
			end
		end)
	)

	ReEnableControls()
	CleanRagdollEffects()
end

local function startAntiRagdoll()
	for _, conn in pairs(AntiRagdollConns) do
		pcall(function()
			conn:Disconnect()
		end)
	end
	AntiRagdollConns = {}
	local c = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	connectAntiRagdollToChar(c)
end

local function stopAntiRagdoll()
	for _, conn in pairs(AntiRagdollConns) do
		pcall(function()
			conn:Disconnect()
		end)
	end
	AntiRagdollConns = {}
	pcall(function()
		local c = LocalPlayer.Character
		local hum = c and c:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
			hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
			hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
		end
	end)
end

table.insert(
	ActiveConnections,
	LocalPlayer.CharacterAdded:Connect(function(newChar)
		if not antiRagdollEnabled then
			return
		end
		for _, conn in pairs(AntiRagdollConns) do
			pcall(function()
				conn:Disconnect()
			end)
		end
		AntiRagdollConns = {}
		task.spawn(function()
			connectAntiRagdollToChar(newChar)
		end)
	end)
)

if antiRagdollEnabled then
	task.spawn(startAntiRagdoll)
end

-- ==========================================
-- ADMIN COMMAND FIRE
-- ==========================================
local selfCommandCache = {}
local selfProfileCache = {}

local function selfCacheActivated(guiObject)
	local cached = {}
	local ok, conns = pcall(getconnections, guiObject.Activated)
	if ok and type(conns) == "table" then
		for _, c in ipairs(conns) do
			if type(c.Function) == "function" then
				table.insert(cached, c.Function)
			end
		end
	end
	return cached
end

local function selfFireActivated(cached)
	for _, fn in ipairs(cached) do
		task.spawn(fn)
	end
end

local function selfGetAdminFrames()
	local adminPanel = LocalPlayer.PlayerGui:FindFirstChild("AdminPanel")
	if not adminPanel then
		return nil, nil
	end
	local panel = adminPanel:FindFirstChild("AdminPanel")
	if not panel then
		return nil, nil
	end
	local content = panel:FindFirstChild("Content")
	local profiles = panel:FindFirstChild("Profiles")
	if not content or not profiles then
		return nil, nil
	end
	return content:FindFirstChild("ScrollingFrame"), profiles:FindFirstChild("ScrollingFrame")
end

local function fireCommandOnPlayer(cmdName, targetPlayer)
	local commandFrame, profileFrame = selfGetAdminFrames()
	if not commandFrame or not profileFrame then
		return false
	end
	local profileButton = profileFrame:FindFirstChild(targetPlayer.Name)
	local cmdButton = commandFrame:FindFirstChild(cmdName)
	if not profileButton or not cmdButton then
		return false
	end

	if not selfProfileCache[targetPlayer.Name] then
		selfProfileCache[targetPlayer.Name] = selfCacheActivated(profileButton)
	end
	if not selfCommandCache[cmdName] then
		selfCommandCache[cmdName] = selfCacheActivated(cmdButton)
	end

	selfFireActivated(selfProfileCache[targetPlayer.Name])
	task.wait(0.05)
	selfFireActivated(selfCommandCache[cmdName])
	return true
end

local function getClosestPlayer()
	local myChar = Character
	if not myChar then
		return nil
	end
	local myHrp = myChar:FindFirstChild("HumanoidRootPart")
	if not myHrp then
		return nil
	end

	local closestPlayer = nil
	local shortestDistance = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local targetHrp = player.Character.HumanoidRootPart
			local distance = (myHrp.Position - targetHrp.Position).Magnitude
			if distance < shortestDistance then
				shortestDistance = distance
				closestPlayer = player
			end
		end
	end
	return closestPlayer
end

local function executeTinyAndRocket()
	local target = getClosestPlayer()
	if not target then
		return false
	end
	fireCommandOnPlayer("tiny", target)
	task.wait(0.1)
	fireCommandOnPlayer("rocket", target)
	return true
end

local function ragdollBypassSelf()
	local character = LocalPlayer.Character
	if not character then
		return false
	end
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then
		return false
	end

	local giant = nil
	for _, tool in ipairs(character:GetChildren()) do
		if tool:IsA("Tool") and tool.Name:lower():find("giant") then
			giant = tool
			break
		end
	end
	if not giant then
		for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
			if tool:IsA("Tool") and tool.Name:lower():find("giant") then
				giant = tool
				break
			end
		end
	end

	if giant then
		humanoid:EquipTool(giant)
		task.wait(0.08)
		pcall(function()
			giant:Activate()
		end)
		task.spawn(function()
			fireCommandOnPlayer("ragdoll", LocalPlayer)
		end)
		task.wait(0.05)
		humanoid:UnequipTools()
	else
		fireCommandOnPlayer("ragdoll", LocalPlayer)
	end
	return true
end

-- ==========================================
-- BLOCK SYSTEM
-- ==========================================
local function getBlockDelay()
	if _G.BlockDelay == "normal" then
		return 0.50
	elseif _G.BlockDelay == "slow" then
		return 1.00
	else
		return 0
	end
end

local function PromptClick()
	local viewportSize = workspace.CurrentCamera.ViewportSize
	local centerX = viewportSize.X / 2
	local centerY = (viewportSize.Y / 2) + 30
	for _ = 1, 4 do
		VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 0)
		VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 0)
		task.wait(0.001)
	end
end

local function blockPlayer(plr)
	if not plr or plr == LocalPlayer then
		return
	end
	pcall(function()
		StarterGui:SetCore("PromptBlockPlayer", plr)
		PromptClick()
	end)
end

local function blockAllPlayers()
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			blockPlayer(p)
			task.wait(0.5)
		end
	end
end

local function getNearestPlayer()
	local hrp = Character and Character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return nil
	end
	local closest, dist = nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local d = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
			if d < dist then
				dist = d
				closest = plr
			end
		end
	end
	return closest
end

-- ==========================================
-- CHARACTER ADDED
-- ==========================================
local charAddedConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
	if currentMovement then
		pcall(function()
			currentMovement:Disconnect()
		end)
		currentMovement = nil
	end
	Character = newChar
	Humanoid = newChar:WaitForChild("Humanoid")
	Root = newChar:WaitForChild("HumanoidRootPart")
	Camera = Workspace.CurrentCamera
	autoStealEnabled = false
	isStealing = false
	task.wait()
	if Root then
		local oldVelocity = Root:FindFirstChild("LinearVelocity")
		if oldVelocity then
			oldVelocity:Destroy()
		end
		local oldAttachment = Root:FindFirstChild("Attachment")
		if oldAttachment then
			oldAttachment:Destroy()
		end
	end
end)
table.insert(ActiveConnections, charAddedConn)

-- ==========================================
-- SLOTS CONFIG
-- ==========================================
local SlotsConfig = {
	[1] = {
		Positions = { Vector3.new(-345.4766, -6.0291, 1.5014) },
		CamOffset = Vector3.new(-354.1492, 4.0350, 9.3823) - Vector3.new(-345.4766, -6.0291, 1.5014),
		CamAngles = { -0.827500, -0.640100, -0.576243 },
	},
	[2] = {
		Positions = { Vector3.new(-349.9259, -6.2791, -1.5767) },
		CamOffset = Vector3.new(-363.2081, 2.9403, 3.3074) - Vector3.new(-349.9259, -6.2791, -1.5767),
		CamAngles = { -1.007271, -0.967909, -0.916433 },
	},
	[3] = {
		Positions = { Vector3.new(-349.9259, -6.2791, -1.5758) },
		CamOffset = Vector3.new(-367.7556, 4.3232, 3.4983) - Vector3.new(-349.9259, -6.2791, -1.5758),
		CamAngles = { -1.062718, -1.041500, -0.997864 },
	},
	[4] = {
		Positions = { Vector3.new(-343.4199, -5.9197, 10.5505) },
		CamOffset = Vector3.new(-359.0885, 4.0544, 21.0001) - Vector3.new(-343.4199, -5.9197, 10.5505),
		CamAngles = { -0.681953, -0.861073, -0.551998 },
	},
	[5] = {
		Positions = { Vector3.new(-343.7608, -6.3272, -9.7994) },
		CamOffset = Vector3.new(-363.9226, -0.3924, -9.1459) - Vector3.new(-343.7608, -6.3272, -9.7994),
		CamAngles = { -1.424811, -1.351549, -1.421283 },
	},
	[6] = {
		Positions = { Vector3.new(-353.820709, -7.3017997, 56.7122993), Vector3.new(
			-300.422119,
			-7.30179977,
			34.2573051
		) },
		CamOffset = Vector3.new(-298.584991, 3.38974237, 49.2246361)
			- Vector3.new(-300.422119, -7.30179977, 34.2573051),
		CamAngles = { 0, 0.06, 0 },
		FixedCFrame = CFrame.new(
			-301.68,
			-10.02,
			39.60,
			1.000,
			-0.020,
			-0.020,
			0.000,
			0.714,
			-0.700,
			0.028,
			0.700,
			0.714
		),
	},
	[7] = {
		Positions = { Vector3.new(-344.4383, -6.4281, 41.8672) },
		CamOffset = Vector3.new(-362.8094, -3.2299, 51.1552) - Vector3.new(-344.4383, -6.4281, 41.8672),
		CamAngles = { -0.181885, -1.095968, -0.162135 },
	},
	[8] = {
		Positions = { Vector3.new(-348.5228, -6.4281, 48.1022) },
		CamOffset = Vector3.new(-369.4075, -0.1123, 63.3763) - Vector3.new(-348.5228, -6.4281, 48.1022),
		CamAngles = { -0.306020, -0.916511, -0.245634 },
	},
	[9] = {
		Positions = { Vector3.new(-339.6349, -6.4281, 60.4164) },
		CamOffset = Vector3.new(-349.9293, -1.6218, 84.4119) - Vector3.new(-339.6349, -6.4281, 60.4164),
		CamAngles = { -0.137335, -0.401849, -0.054002 },
	},
	[10] = {
		Positions = { Vector3.new(-348.2407, -7.5033, 74.3719), Vector3.new(-332.8, -6.6, 67.8) },
		CamOffset = Vector3.new(-377.7117, 8.9106, 25.7208) - Vector3.new(-332.8, -6.6, 67.8),
		CamAngles = { -0.3277, -0.0150, 0 },
	},
	[11] = {
		Positions = { Vector3.new(-354.9932, -6.4281, -47.3879), Vector3.new(-331.5262, -6.4281, -47.3607) },
		CamOffset = Vector3.new(-333.2372, -9.9613, -64.2099) - Vector3.new(-331.5262, -6.4281, -47.3607),
		CamAngles = { 2.851853, -0.097011, 3.112724 },
	},
	[12] = {
		Positions = { Vector3.new(-354.9584, -6.4208, -42.6520), Vector3.new(-338.7290, -6.4281, -43.4713) },
		CamOffset = Vector3.new(-346.9807, -9.9578, -60.5865) - Vector3.new(-338.7290, -6.4281, -43.4713),
		CamAngles = { 2.856299, -0.433315, 3.019061 },
	},
	[13] = {
		Positions = { Vector3.new(-354.8862, -6.2793, -37.9787), Vector3.new(-334.5183, -6.4281, -41.6819) },
		CamOffset = Vector3.new(-343.9747, -9.9590, -57.3332) - Vector3.new(-334.5183, -6.4281, -41.6819),
		CamAngles = { 2.831168, -0.522070, 2.982964 },
	},
	[14] = {
		Positions = { Vector3.new(-351.8463, -6.5022, -37.0529), Vector3.new(-319.8298, -6.4281, -45.1476) },
		CamOffset = Vector3.new(-325.1408, -9.9618, -60.9837) - Vector3.new(-319.8298, -6.4281, -45.1476),
		CamAngles = { 2.834406, -0.309406, 3.045298 },
	},
	[15] = {
		Positions = { Vector3.new(-351.0894, -6.2833, -32.7751), Vector3.new(-317.9170, -6.4281, -41.9999) },
		CamOffset = Vector3.new(-327.9996, -9.9581, -57.8876) - Vector3.new(-317.9170, -6.4281, -41.9999),
		CamAngles = { 2.835549, -0.544183, 2.979445 },
	},
	[16] = {
		Positions = { Vector3.new(-338.2857, -6.4281, 57.2060) },
		CamOffset = Vector3.new(-341.5551, -9.9642, 72.3530) - Vector3.new(-338.2857, -6.4281, 57.2060),
		CamAngles = { 0.320392, -0.202067, 0.066497 },
	},
	[17] = {
		Positions = { Vector3.new(-337.9285, -6.4281, 55.1757) },
		CamOffset = Vector3.new(-344.4950, -9.9637, 69.4787) - Vector3.new(-337.9285, -6.4281, 55.1757),
		CamAngles = { 0.337895, -0.408747, 0.138758 },
	},
	[18] = {
		Positions = { Vector3.new(-332.1088, -6.4281, 53.1675) },
		CamOffset = Vector3.new(-338.8290, -9.9674, 65.6692) - Vector3.new(-332.1088, -6.4281, 53.1675),
		CamAngles = { 0.382481, -0.462609, 0.177644 },
	},
	[19] = {
		Positions = { Vector3.new(-347.9923, -6.2933, -34.0232), Vector3.new(-328.5790, -6.4281, -35.0857) },
		CamOffset = Vector3.new(-328.6130, -10.0174, -40.4923) - Vector3.new(-328.5790, -6.4281, -35.0857),
		CamAngles = { 2.387391, -0.004579, 3.137291 },
	},
	[20] = {
		Positions = { Vector3.new(-355.0801, -6.4404, -33.2302), Vector3.new(-321.5783, -6.4281, -33.5778) },
		CamOffset = Vector3.new(-321.6123, -10.0174, -38.9844) - Vector3.new(-321.5783, -6.4281, -33.5778),
		CamAngles = { 2.387391, -0.004579, 3.137291 },
	},
	[21] = {
		Positions = { Vector3.new(-351.5396, -7.5033, -41.797), Vector3.new(-314.088, -7.5033, -32.1806) },
		CamOffset = Vector3.new(-314.1147, -10.0174, -36.4214) - Vector3.new(-314.088, -7.5033, -32.1806),
		CamAngles = { 2.387391, -0.004579, 3.137291 },
		NeedJump = true,
	},
	[22] = {
		Positions = { Vector3.new(-351.5396, -7.5033, -41.797), Vector3.new(-306.8919, -7.5033, -33.9124) },
		CamOffset = Vector3.new(-306.923, -10.008, -38.86) - Vector3.new(-306.8919, -7.5033, -33.9124),
		CamAngles = { 2.4648, -0.004898, 3.137657 },
		NeedJump = true,
	},
	[23] = {
		Positions = { Vector3.new(-351.5396, -7.5033, -41.797), Vector3.new(-300.2759, -7.5033, -32.7047) },
		CamOffset = Vector3.new(-300.4669, -10.016, -37.044) - Vector3.new(-300.2759, -7.5033, -32.7047),
		CamAngles = { 2.399014, -0.032413, 3.111857 },
		NeedJump = true,
	},
	[24] = {
		Positions = { Vector3.new(-348.2407, -7.5033, 74.3719), Vector3.new(-330.0484, -7.5033, 48.183) },
		CamOffset = Vector3.new(-330.1124, -10.0063, 53.2779) - Vector3.new(-330.0484, -7.5033, 48.183),
		CamAngles = { 0.662308, -0.00991, 0.007727 },
		NeedJump = true,
	},
	[25] = {
		Positions = { Vector3.new(-348.2407, -7.5033, 74.3719), Vector3.new(-325.4576, -7.5033, 46.8182) },
		CamOffset = Vector3.new(-326.0541, -10.0104, 51.5397) - Vector3.new(-325.4576, -7.5033, 46.8182),
		CamAngles = { 0.700033, -0.09632, 0.080833 },
		NeedJump = true,
	},
	[26] = {
		Positions = { Vector3.new(-348.2407, -7.5033, 74.3719), Vector3.new(-324.6721, -7.5033, 47.2033) },
		CamOffset = Vector3.new(-326.6859, -10.0057, 51.9385) - Vector3.new(-324.6721, -7.5033, 47.2033),
		CamAngles = { 0.698024, -0.314979, 0.254268 },
		NeedJump = true,
	},
	[27] = {
		Positions = { Vector3.new(-348.2407, -7.5033, 74.3719), Vector3.new(-320.4196, -7.5033, 44.1) },
		CamOffset = Vector3.new(-322.9213, -10.0122, 49.5157) - Vector3.new(-320.4196, -7.5033, 44.1),
		CamAngles = { 0.876985, -0.422603, 0.397417 },
	},
}

-- ==========================================
-- SLOT MARKER + BRAINROT HIGHLIGHT
-- ==========================================
local currentSlotMarker = nil
local currentBrainrotHL = nil
local tpPathMarkers = {}
local tpTargetHighlight = nil

local function clearSlotMarker()
	if currentSlotMarker then
		pcall(function()
			currentSlotMarker:Destroy()
		end)
		currentSlotMarker = nil
	end
	if currentBrainrotHL then
		pcall(function()
			currentBrainrotHL:Destroy()
		end)
		currentBrainrotHL = nil
	end
end

local function clearTpPathVisual()
	for _, m in ipairs(tpPathMarkers) do
		pcall(function()
			m:Destroy()
		end)
	end
	tpPathMarkers = {}
	if tpTargetHighlight then
		pcall(function()
			tpTargetHighlight:Destroy()
		end)
		tpTargetHighlight = nil
	end
end

local function findBrainrotModel(prompt)
	if not prompt then
		return nil
	end
	local playerNames = {}
	for _, p in pairs(Players:GetPlayers()) do
		playerNames[p.Name] = true
	end
	local petName = prompt.ObjectText
	local spawnPoint = prompt:FindFirstAncestor("Spawn")
	if not spawnPoint then
		return nil
	end
	local refPos = spawnPoint.Position
	local basePart = spawnPoint.Parent
	if basePart then
		if basePart:IsA("BasePart") then
			refPos = basePart.Position
		elseif basePart:IsA("Model") then
			local bp = basePart.PrimaryPart or basePart:FindFirstChildWhichIsA("BasePart")
			if bp then
				refPos = bp.Position
			end
		end
	end

	local function getModelPos(v)
		local rp = v.PrimaryPart
			or v:FindFirstChild("RootPart")
			or v:FindFirstChild("FakeRootPart")
			or v:FindFirstChild("HumanoidRootPart")
			or v:FindFirstChildWhichIsA("BasePart")
		return rp and rp.Position or nil
	end

	local plotsFolder = Workspace:FindFirstChild("Plots") or Workspace
	local bestModel, bestScore = nil, math.huge
	for _, secondaryBestModel in ipairs(plotsFolder:GetDescendants()) do
		if
			secondaryBestModel:IsA("Model")
			and not playerNames[secondaryBestModel.Name]
			and secondaryBestModel.Name ~= "Base"
			and secondaryBestModel.Name ~= "Podium"
		then
			local pos = getModelPos(secondaryBestModel)
			if pos then
				local d = (pos - refPos).Magnitude
				if d < 15 then
					local score = d
					if petName and petName ~= "" and secondaryBestModel.Name == petName then
						score = d - 0.5
					end
					if score < bestScore then
						bestScore = score
						bestModel = secondaryBestModel
					end
				end
			end
		end
	end
	return bestModel
end

local function createSlotMarker(prompt)
	clearSlotMarker()
	if not prompt or not _G.SlotESP then
		return
	end

	local folder = Instance.new("Folder")
	folder.Name = "NoxSlotMarker"
	folder.Parent = Workspace

	local brainrotModel = findBrainrotModel(prompt)
	if brainrotModel then
		local existing = brainrotModel:FindFirstChild("_BrainrotHL")
		if existing then
			existing:Destroy()
		end
		local hl = Instance.new("Highlight")
		hl.Name = "_BrainrotHL"
		hl.Adornee = brainrotModel
		hl.FillColor = Color3.fromRGB(255, 0, 0)
		hl.OutlineColor = Color3.fromRGB(200, 0, 0)
		hl.FillTransparency = 0.5
		hl.OutlineTransparency = 0
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		hl.Parent = brainrotModel
		currentBrainrotHL = hl
	end

	local basePart = nil
	local spawnPart = prompt:FindFirstAncestor("Spawn")
	if spawnPart then
		basePart = spawnPart.Parent
		if basePart and not basePart:IsA("BasePart") and not basePart:IsA("Model") then
			basePart = spawnPart:FindFirstAncestorWhichIsA("BasePart") or spawnPart
		end
	end
	if not basePart then
		basePart = prompt:FindFirstAncestorWhichIsA("BasePart")
	end
	if basePart then
		local hlPodium = Instance.new("Highlight")
		hlPodium.Name = "PodiumESP"
		hlPodium.FillColor = Color3.fromRGB(200, 0, 0)
		hlPodium.OutlineColor = Color3.fromRGB(255, 0, 0)
		hlPodium.FillTransparency = 0.45
		hlPodium.OutlineTransparency = 0
		hlPodium.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		hlPodium.Adornee = basePart
		hlPodium.Parent = folder
	end
	currentSlotMarker = folder
end

local function createArrowMarker(position, index)
	local part = Instance.new("Part")
	part.Name = "_TPPathMarker"
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.Transparency = 1
	part.Size = Vector3.new(0.2, 0.2, 0.2)
	part.Position = position + Vector3.new(0, 5, 0)
	part.Parent = Workspace

	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 60, 0, 80)
	billboard.AlwaysOnTop = true
	billboard.Parent = part

	local arrowLabel = Instance.new("TextLabel")
	arrowLabel.Size = UDim2.new(1, 0, 0, 40)
	arrowLabel.BackgroundTransparency = 1
	arrowLabel.Text = "▼"
	arrowLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	arrowLabel.TextScaled = true
	arrowLabel.Font = Enum.Font.GothamBold
	arrowLabel.Parent = billboard

	local numberLabel = Instance.new("TextLabel")
	numberLabel.Size = UDim2.new(1, 0, 0, 30)
	numberLabel.Position = UDim2.new(0, 0, 0, 38)
	numberLabel.BackgroundTransparency = 1
	numberLabel.Text = tostring(index)
	numberLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	numberLabel.TextStrokeTransparency = 0
	numberLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	numberLabel.TextScaled = true
	numberLabel.Font = Enum.Font.GothamBold
	numberLabel.Parent = billboard

	task.spawn(function()
		local t = 0
		while part.Parent do
			t += task.wait(0.05)
			if not part.Parent then
				break
			end
			part.Position = position + Vector3.new(0, 5 + math.sin(t * 3) * 0.4, 0)
		end
	end)
	return part
end

local function showTpPathVisual(prompt, slotNumber)
	clearTpPathVisual()
end

local function findTool(name)
	if not Character then
		return nil
	end
	for _, tool in ipairs(Character:GetChildren()) do
		if tool:IsA("Tool") and tool.Name:lower():find(name:lower()) then
			return tool
		end
	end
	for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
		if tool:IsA("Tool") and tool.Name:lower():find(name:lower()) then
			return tool
		end
	end
	return nil
end

local function getSelectedCarpetTool()
	local choice = (_G.SelectedCarpet or "carpet"):lower()
	local searchOrder = {}
	if choice == "broom" then
		searchOrder = { "broom", "witch" }
	elseif choice == "sleigh" then
		searchOrder = { "sleigh", "santa" }
	elseif choice == "wings" then
		searchOrder = { "wings", "cupid" }
	elseif choice == "waverider" then
		searchOrder = { "waverider", "wave rider", "wave" }
	elseif choice == "auto" then
		searchOrder = {
			"waverider",
			"wave rider",
			"wings",
			"cupid",
			"sleigh",
			"santa",
			"broom",
			"witch",
			"carpet",
			"magic carpet",
			"flying carpet",
			"rainbow",
		}
	else
		searchOrder = { "flying carpet", "magic carpet", "rainbow carpet", "carpet" }
	end

	for _, keyword in ipairs(searchOrder) do
		local tool = findTool(keyword)
		if tool then
			return tool
		end
	end
	return nil
end

local function isMyPlot(plot)
	if not plot then
		return false
	end
	local sign = plot:FindFirstChild("PlotSign")
	if sign then
		local yourBase = sign:FindFirstChild("YourBase")
		if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled then
			return true
		end
	end
	return false
end

local function isValidStealPrompt(prompt)
	if not prompt or not prompt.Parent or not prompt.Enabled then
		return false
	end
	local state = prompt:GetAttribute("State")
	local actionText = prompt.ActionText
	if state == "Steal" or state == "Grab" or actionText == "Steal" or actionText == "Grab" then
		return true
	end
	return false
end

local function firePromptConnections(prompt, signalName)
	if not getconnections then
		return
	end
	local connections = getconnections(prompt[signalName])
	for _, conn in ipairs(connections) do
		if conn.Function then
			task.spawn(conn.Function)
		end
	end
end

local function executeSteal(prompt)
	if isStealing or not prompt or not prompt.Parent then
		return
	end
	isStealing = true
	firePromptConnections(prompt, "PromptButtonHoldBegan")
	task.wait(stealDelay)
	if prompt and prompt.Parent and prompt.Enabled and not thisScriptStopped then
		firePromptConnections(prompt, "Triggered")
	end
	isStealing = false
end

-- ==========================================
-- AUTO RETURN TO BASE
-- ==========================================
local BASE_TARGET = Vector3.new(-350.8919, -6.6011, 108.6947)
local BASE_SPEED = 25
local BASE_STOP_DIST = 3
local BASE_SLOW_DIST = 15
local returnMovement = nil

local function stopReturnToBase()
	if returnMovement then
		pcall(function()
			returnMovement:Disconnect()
		end)
		returnMovement = nil
	end
end

local function startReturnToBase()
	if not Root or not Humanoid then
		return
	end
	stopReturnToBase()

	local savedWalkSpeed = Humanoid.WalkSpeed
	local savedJumpPower = Humanoid.JumpPower
	Humanoid.WalkSpeed = 0
	Humanoid.JumpPower = 0
	Humanoid.AutoRotate = false

	local carpet = getSelectedCarpetTool() or findTool(_G.WalkItem or "Flying Carpet")
	if carpet then
		pcall(function()
			Humanoid:UnequipTools()
		end)
		task.wait(0.03)
		pcall(function()
			Humanoid:EquipTool(carpet)
		end)
	end

	if Root:FindFirstChild("ReturnVelocity") then
		Root:FindFirstChild("ReturnVelocity"):Destroy()
	end
	if Root:FindFirstChild("ReturnAttachment") then
		Root:FindFirstChild("ReturnAttachment"):Destroy()
	end

	local Attachment = Instance.new("Attachment")
	Attachment.Name = "ReturnAttachment"
	Attachment.Parent = Root

	local Velocity = Instance.new("LinearVelocity")
	Velocity.Name = "ReturnVelocity"
	Velocity.Attachment0 = Attachment
	Velocity.RelativeTo = Enum.ActuatorRelativeTo.World
	Velocity.MaxForce = math.huge
	Velocity.VectorVelocity = Vector3.zero
	Velocity.Parent = Root

	local floatStartTime = os.clock()
	local floatAmplitude = 4
	local floatSpeed = 3

	local function restore()
		Humanoid.WalkSpeed = savedWalkSpeed
		Humanoid.JumpPower = savedJumpPower
		Humanoid.AutoRotate = true
		pcall(function()
			Velocity:Destroy()
		end)
		pcall(function()
			Attachment:Destroy()
		end)
	end

	local WAYPOINT = Vector3.new(-348.2184, -6.6011, 7.1711)
	local useWaypoint = selectedSlotNumber and selectedSlotNumber >= 1 and selectedSlotNumber <= 10
	local waypointReached = not useWaypoint

	returnMovement = RunService.Heartbeat:Connect(function()
		if thisScriptStopped or not Root or not Root.Parent or not Humanoid or Humanoid.Health <= 0 then
			restore()
			stopReturnToBase()
			return
		end
		local rootPos = Root.Position

		if not waypointReached then
			local wpDir = Vector3.new(WAYPOINT.X - rootPos.X, 0, WAYPOINT.Z - rootPos.Z)
			local wpDist = wpDir.Magnitude
			if wpDist <= BASE_STOP_DIST then
				waypointReached = true
			else
				local floatY = math.sin((os.clock() - floatStartTime) * floatSpeed) * floatAmplitude
				local targetY = WAYPOINT.Y + floatAmplitude + floatY + 4
				local vertErr = targetY - rootPos.Y
				local vertVel = math.clamp(vertErr * 5, -15, 15)
				local speedMult = 1
				if wpDist < BASE_SLOW_DIST then
					speedMult = math.max(0.15, wpDist / BASE_SLOW_DIST)
				end
				local moveDir = wpDir.Unit
				Velocity.VectorVelocity =
					Vector3.new(moveDir.X * BASE_SPEED * speedMult, vertVel, moveDir.Z * BASE_SPEED * speedMult)
				return
			end
		end

		local vector = Vector3.new(BASE_TARGET.X - rootPos.X, 0, BASE_TARGET.Z - rootPos.Z)
		local dist = vector.Magnitude
		if dist <= BASE_STOP_DIST then
			Velocity.VectorVelocity = Vector3.zero
			pcall(function()
				Root.AssemblyLinearVelocity = Vector3.zero
			end)
			Root.CFrame = CFrame.new(BASE_TARGET)
			restore()
			stopReturnToBase()
			return
		end

		local floatY = math.sin((os.clock() - floatStartTime) * floatSpeed) * floatAmplitude
		local targetY = BASE_TARGET.Y + floatAmplitude + floatY + 4
		local vertErr = targetY - rootPos.Y
		local vertVel = math.clamp(vertErr * 5, -15, 15)
		local speedMult = 1
		if dist < BASE_SLOW_DIST then
			speedMult = math.max(0.15, dist / BASE_SLOW_DIST)
		end
		local moveDir = vector.Unit
		Velocity.VectorVelocity =
			Vector3.new(moveDir.X * BASE_SPEED * speedMult, vertVel, moveDir.Z * BASE_SPEED * speedMult)
	end)
end

-- ==========================================
-- FLASH SAFE ZONE
-- ==========================================
local FLASH_SAFE_ZONE = {
	minX = -337.34,
	maxX = -294.05,
	minZ = 91.94,
	maxZ = 135.06,
}
local FLASH_SAFE_POS = Vector3.new(-356.39, -6.10, 100.21)

local function isInFlashSafeZone(pos)
	return pos.X >= FLASH_SAFE_ZONE.minX
		and pos.X <= FLASH_SAFE_ZONE.maxX
		and pos.Z >= FLASH_SAFE_ZONE.minZ
		and pos.Z <= FLASH_SAFE_ZONE.maxZ
end

-- ==========================================
-- START TRIP TO PET SLOT (FLASH TP)
-- ==========================================
local STOP_DIST = 5
local SLOW_DIST = 20

local function startTripToPetSlot(prompt, slotNumber)
	local config = SlotsConfig[slotNumber] or SlotsConfig[1]
	local targetPositions = config.Positions or { config.Position }
	local needJump = config.NeedJump == true
	if slotNumber >= 19 and slotNumber <= 27 then
		needJump = true
	end

	local rootNow = Root and Root.Position
	if rootNow and isInFlashSafeZone(rootNow) then
		local positions = { FLASH_SAFE_POS }
		for _, p in ipairs(targetPositions) do
			table.insert(positions, p)
		end
		targetPositions = positions
	end

	if currentMovement then
		pcall(function()
			currentMovement:Disconnect()
		end)
		currentMovement = nil
	end
	if not Root or not Humanoid then
		return
	end

	if type(_G.HugoForceUnlock) == "function" then
		_G.HugoForceUnlock()
	else
		cameraLocked = false
		lockedCameraCFrame = nil
	end

	autoStealEnabled = true
	startFlashLagger()
	clearTpPathVisual()

	local Speed = 190
	local grabStartDistance = 57
	local grabStarted = false

	if _G.AutoReturnBase then
		task.spawn(function()
			while autoStealEnabled and not thisScriptStopped do
				if LocalPlayer:GetAttribute("Stealing") then
					startReturnToBase()
					return
				end
				task.wait(0.05)
			end
		end)
	end

	local carpet = getSelectedCarpetTool() or findTool(_G.WalkItem or "Flying Carpet")
	if carpet then
		Humanoid:UnequipTools()
		task.wait(0.03)
		Humanoid:EquipTool(carpet)
	end

	local savedWalkSpeed = Humanoid.WalkSpeed
	local savedJumpPower = Humanoid.JumpPower
	Humanoid.WalkSpeed = 0
	Humanoid.JumpPower = 0
	Humanoid.AutoRotate = false

	local animPlayConn = nil
	local animator = Humanoid:FindFirstChildOfClass("Animator")
	if animator then
		for _, track in pairs(animator:GetPlayingAnimationTracks()) do
			pcall(function()
				track:Stop(0)
			end)
		end
		animPlayConn = animator.AnimationPlayed:Connect(function(track)
			pcall(function()
				track:Stop(0)
			end)
		end)
		table.insert(ActiveConnections, animPlayConn)
	end

	if Root:FindFirstChild("LinearVelocity") then
		Root.LinearVelocity:Destroy()
	end
	if Root:FindFirstChild("Attachment") then
		Root.Attachment:Destroy()
	end

	local Attachment = Instance.new("Attachment")
	Attachment.Parent = Root
	local Velocity = Instance.new("LinearVelocity")
	Velocity.Attachment0 = Attachment
	Velocity.RelativeTo = Enum.ActuatorRelativeTo.World
	Velocity.MaxForce = math.huge
	Velocity.Parent = Root

	local currentPosIndex = 1
	local intermediatePauseActive = false

	local function restoreWalk()
		pcall(function()
			if animPlayConn then
				animPlayConn:Disconnect()
				animPlayConn = nil
			end
			if Humanoid and Humanoid.Parent then
				Humanoid.WalkSpeed = savedWalkSpeed
				Humanoid.JumpPower = savedJumpPower
				Humanoid.AutoRotate = true
			end
		end)
	end

	currentMovement = RunService.Heartbeat:Connect(function()
		if thisScriptStopped then
			restoreWalk()
			if currentMovement then
				pcall(function()
					currentMovement:Disconnect()
				end)
				currentMovement = nil
			end
			return
		end
		if not Root or not Humanoid or not Root.Parent or Humanoid.Health <= 0 then
			restoreWalk()
			if currentMovement then
				pcall(function()
					currentMovement:Disconnect()
				end)
				currentMovement = nil
			end
			return
		end
		if intermediatePauseActive then
			Velocity.VectorVelocity = Vector3.zero
			return
		end

		local TargetPosition = targetPositions[currentPosIndex]
		if not TargetPosition then
			return
		end

		local rootPos = Root.Position
		local dir = Vector3.new(TargetPosition.X - rootPos.X, 0, TargetPosition.Z - rootPos.Z)
		local dist = dir.Magnitude

		local finalPosition = targetPositions[#targetPositions]
		local finalDist = Vector3.new(finalPosition.X - rootPos.X, 0, finalPosition.Z - rootPos.Z).Magnitude
		if finalDist <= grabStartDistance and not grabStarted then
			grabStarted = true
			task.spawn(function()
				executeSteal(prompt)
			end)
		end

		local speedMult = 1
		if dist < SLOW_DIST then
			speedMult = math.max(0.15, dist / SLOW_DIST)
		end

		if dist <= STOP_DIST then
			if currentPosIndex < #targetPositions then
				intermediatePauseActive = true
				Velocity.VectorVelocity = Vector3.zero
				Root.AssemblyLinearVelocity = Vector3.zero
				task.spawn(function()
					currentPosIndex = currentPosIndex + 1
					intermediatePauseActive = false
				end)
				return
			end

			Velocity.VectorVelocity = Vector3.zero
			Root.AssemblyLinearVelocity = Vector3.zero
			Velocity:Destroy()
			Attachment:Destroy()
			Root.CFrame = CFrame.new(TargetPosition)
			if currentMovement then
				pcall(function()
					currentMovement:Disconnect()
				end)
				currentMovement = nil
			end

			task.wait(0.12)
			Camera.CameraType = Enum.CameraType.Scriptable
			if config.FixedCFrame then
				Camera.CFrame = config.FixedCFrame
			elseif config.CamOffset then
				Camera.CFrame = CFrame.new(Root.Position + config.CamOffset) * CFrame.Angles(unpack(config.CamAngles))
			else
				Camera.CFrame = CFrame.new(Root.Position + Vector3.new(0, 5, 0))
					* CFrame.Angles(unpack(config.CamAngles))
			end

			if _G.AutoBlock then
				task.spawn(function()
					task.wait(getBlockDelay())
					blockAllPlayers()
				end)
			end

			Humanoid:UnequipTools()
			task.wait(0.06)

			if needJump then
				Root.AssemblyLinearVelocity = Vector3.new(0, 55, 0)
				task.wait(0.08)
			end

			if type(_G.HugoForceUnlock) == "function" then
				_G.HugoForceUnlock()
			else
				cameraLocked = false
				lockedCameraCFrame = nil
			end

			Camera.CameraType = Enum.CameraType.Scriptable
			if config.FixedCFrame then
				Camera.CFrame = config.FixedCFrame
			elseif config.CamOffset then
				Camera.CFrame = CFrame.new(Root.Position + config.CamOffset) * CFrame.Angles(unpack(config.CamAngles))
			end
			task.wait(0.05)

			local flash = findTool("flash") or findTool("Flash Teleport")
			if flash then
				pcall(function()
					Humanoid:UnequipTools()
				end)
				task.wait(0.03)
				Humanoid:EquipTool(flash)
				task.wait(0.08)
				pcall(function()
					flash:Activate()
				end)
				pcall(function()
					if getconnections then
						for _, cx in pairs(getconnections(flash.Activated)) do
							pcall(function()
								cx:Fire()
							end)
						end
					end
				end)
				pcall(function()
					local vp = workspace.CurrentCamera.ViewportSize
					local x, y = vp.X / 2, vp.Y / 2
					for _ = 1, 3 do
						VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
						VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
						task.wait(0.02)
					end
				end)

				if slotNumber == 6 then
					Camera.CameraType = Enum.CameraType.Scriptable
					Camera.CFrame = CFrame.new(
						-301.68,
						-10.02,
						39.60,
						1.000,
						-0.020,
						-0.020,
						0.000,
						0.714,
						-0.700,
						0.028,
						0.700,
						0.714
					)
				end
			end

			if _G.AutoGiant or _G.RagdollBypass then
				local giant = findTool("giant potion") or findTool("giant")
				if giant then
					Humanoid:EquipTool(giant)
					task.wait(0.08)
					pcall(function()
						giant:Activate()
					end)
					if _G.RagdollBypass then
						task.spawn(function()
							fireCommandOnPlayer("ragdoll", LocalPlayer)
						end)
					end
					task.wait(0.05)
					Humanoid:UnequipTools()
				elseif _G.RagdollBypass then
					task.spawn(function()
						fireCommandOnPlayer("ragdoll", LocalPlayer)
					end)
				end
			end

			restoreWalk()

			Camera.CameraType = Enum.CameraType.Custom
			task.spawn(function()
				task.wait(1.0)
				autoStealEnabled = false
			end)
			return
		end

		Velocity.VectorVelocity = Vector3.new(dir.Unit.X * Speed * speedMult, 0, dir.Unit.Z * Speed * speedMult)
	end)
	table.insert(ActiveConnections, currentMovement)
end

table.insert(
	ActiveConnections,
	LocalPlayer.CharacterAdded:Connect(function()
		if not _G.AutoFlashTP then
			return
		end
		if not selectedPrompt or not selectedSlotNumber then
			return
		end
		task.delay(0.25, function()
			if thisScriptStopped then
				return
			end
			if isStealing or autoStealEnabled then
				return
			end
			if selectedPrompt and selectedSlotNumber then
				startTripToPetSlot(selectedPrompt, selectedSlotNumber)
			end
		end)
	end)
)

-- ==========================================
-- UPDATE PET LIST
-- ==========================================
local scrollListRef = nil
local lastPetsSignature = ""

local function updatePetList()
	if isStealing or autoStealEnabled or thisScriptStopped then
		return
	end
	if not scrollListRef then
		return
	end

	local plotsFolder = Workspace:FindFirstChild("Plots")
	if not plotsFolder then
		return
	end

	local tempPets = {}
	for _, plot in ipairs(plotsFolder:GetChildren()) do
		if not isMyPlot(plot) then
			local podiums = plot:FindFirstChild("AnimalPodiums")
			if podiums then
				for _, podium in ipairs(podiums:GetChildren()) do
					local slotNumber = tonumber(podium.Name:match("%d+")) or 1
					local base = podium:FindFirstChild("Base") or podium
					local spawnPoint = base:FindFirstChild("Spawn")
					local attachment = spawnPoint and spawnPoint:FindFirstChild("PromptAttachment")
					if attachment then
						for _, child in ipairs(attachment:GetChildren()) do
							if child:IsA("ProximityPrompt") and isValidStealPrompt(child) then
								local petName = child.ObjectText or "Pet"
								table.insert(
									tempPets,
									{ prompt = child, slot = slotNumber, name = petName, spawn = spawnPoint }
								)
							end
						end
					end
				end
			end
		end
	end

	table.sort(tempPets, function(a, b)
		return a.slot < b.slot
	end)

	if _G.AutoSelectBest and #tempPets > 0 and not selectedPrompt then
		selectedPrompt = tempPets[1].prompt
		selectedSlotNumber = tempPets[1].slot
		createSlotMarker(selectedPrompt)
		showTpPathVisual(selectedPrompt, selectedSlotNumber)
	end

	local sigParts = {}
	for _, petData in ipairs(tempPets) do
		table.insert(sigParts, (petData.name or "?") .. "_" .. tostring(petData.slot))
	end
	table.sort(sigParts)
	local currentSignature = table.concat(sigParts, "|")

	if currentSignature == lastPetsSignature and scrollListRef then
		for _, child in ipairs(scrollListRef:GetChildren()) do
			if child:IsA("Frame") then
				local key = child:GetAttribute("PetKey")
				if key then
					local isSelected = false
					if selectedPrompt and selectedSlotNumber then
						local wantKey = (selectedPrompt.ObjectText or "?") .. "_" .. tostring(selectedSlotNumber)
						isSelected = (key == wantKey)
					end
					child.BackgroundColor3 = isSelected and Color3.fromRGB(60, 0, 0) or Color3.fromRGB(18, 18, 18)
					local stroke = child:FindFirstChildOfClass("UIStroke")
					if stroke then
						stroke.Color = isSelected and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(45, 45, 45)
						stroke.Thickness = isSelected and 1.5 or 1
					end
				end
			end
		end
		return
	end
	lastPetsSignature = currentSignature

	for _, child in ipairs(scrollListRef:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local C_list = {
		card = Color3.fromRGB(18, 18, 18),
		accent = Color3.fromRGB(255, 0, 0),
		stroke = Color3.fromRGB(45, 45, 45),
		bright = Color3.fromRGB(240, 240, 240),
		mute = Color3.fromRGB(200, 0, 0),
	}

	local VP_SIZE = 56

	for _, petData in ipairs(tempPets) do
		if thisScriptStopped then
			break
		end
		local isSelected = (selectedPrompt == petData.prompt)

		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -8, 0, 66)
		row.BackgroundColor3 = isSelected and Color3.fromRGB(60, 0, 0) or C_list.card
		row.BorderSizePixel = 0
		row:SetAttribute("PetKey", (petData.name or "?") .. "_" .. tostring(petData.slot))
		row.Parent = scrollListRef
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

		local rStroke = Instance.new("UIStroke")
		rStroke.Color = isSelected and C_list.accent or C_list.stroke
		rStroke.Thickness = isSelected and 1.5 or 1
		rStroke.Parent = row

		local vp = Instance.new("ViewportFrame")
		vp.Size = UDim2.new(0, VP_SIZE, 0, VP_SIZE)
		vp.Position = UDim2.new(0, 4, 0.5, -VP_SIZE / 2)
		vp.BackgroundTransparency = 1
		vp.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		vp.BorderSizePixel = 0
		vp.ZIndex = 5
		vp.Parent = row

		local vpCam = Instance.new("Camera")
		vpCam.Parent = vp
		vp.CurrentCamera = vpCam

		task.spawn(function()
			local plots = Workspace:FindFirstChild("Plots")
			if not plots then
				return
			end
			local playerNames = {}
			for _, p in pairs(Players:GetPlayers()) do
				playerNames[p.Name] = true
			end

			local foundModel = nil
			local bestDist = 20

			for _, secondaryFoundModel in ipairs(plots:GetDescendants()) do
				if
					secondaryFoundModel:IsA("Model")
					and secondaryFoundModel.Name == petData.name
					and not playerNames[secondaryFoundModel.Name]
				then
					foundModel = secondaryFoundModel
					break
				end
			end

			if not foundModel and petData.spawn then
				local refPos = petData.spawn.Position
				for _, rootPartContainer in ipairs(plots:GetDescendants()) do
					if
						rootPartContainer:IsA("Model")
						and not playerNames[rootPartContainer.Name]
						and rootPartContainer.Name ~= "Base"
						and rootPartContainer.Name ~= "Podium"
					then
						local rp = rootPartContainer.PrimaryPart
							or rootPartContainer:FindFirstChild("RootPart")
							or rootPartContainer:FindFirstChild("FakeRootPart")
							or rootPartContainer:FindFirstChildWhichIsA("BasePart")
						if rp then
							local d = (rp.Position - refPos).Magnitude
							if d < bestDist then
								bestDist = d
								foundModel = rootPartContainer
							end
						end
					end
				end
			end

			if not foundModel then
				return
			end

			local clone = foundModel:Clone()
			for _, d in ipairs(clone:GetDescendants()) do
				if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("Highlight") then
					pcall(function()
						d:Destroy()
					end)
				end
			end
			clone.Parent = vp

			local ok, cf, size = pcall(function()
				return clone:GetBoundingBox()
			end)
			if not ok or not cf then
				return
			end

			local dist = math.max(size.Magnitude * 1.15, 2.5)
			local center = cf.Position
			local height = size.Y * 0.15

			local angle = 0
			local rotConn
			rotConn = RunService.Heartbeat:Connect(function(dt)
				if not vp.Parent or not vpCam.Parent then
					if rotConn then
						rotConn:Disconnect()
					end
					return
				end
				angle = angle + dt * 55
				local rad = math.rad(angle)
				vpCam.CFrame =
					CFrame.new(center + Vector3.new(math.sin(rad) * dist, height, math.cos(rad) * dist), center)
			end)
			table.insert(ActiveConnections, rotConn)
		end)

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Text = petData.name
		nameLabel.Size = UDim2.new(1, -(VP_SIZE + 16), 1, 0)
		nameLabel.Position = UDim2.new(0, VP_SIZE + 10, 0, -4)
		nameLabel.BackgroundTransparency = 1
		nameLabel.TextColor3 = C_list.bright
		nameLabel.Font = Enum.Font.GothamMedium
		nameLabel.TextSize = 13
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.Parent = row

		local slotLabel = Instance.new("TextLabel")
		slotLabel.Text = "slot " .. petData.slot
		slotLabel.Size = UDim2.new(1, -(VP_SIZE + 14), 1, 0)
		slotLabel.Position = UDim2.new(0, VP_SIZE + 2, 0, 6)
		slotLabel.BackgroundTransparency = 1
		slotLabel.TextColor3 = C_list.mute
		slotLabel.Font = Enum.Font.GothamMedium
		slotLabel.TextSize = 11
		slotLabel.TextXAlignment = Enum.TextXAlignment.Right
		slotLabel.Parent = row

		local clickBtn = Instance.new("TextButton")
		clickBtn.Size = UDim2.new(1, 0, 1, 0)
		clickBtn.BackgroundTransparency = 1
		clickBtn.Text = ""
		clickBtn.BorderSizePixel = 0
		clickBtn.ZIndex = 10
		clickBtn.Parent = row

		local rowBtnConn = clickBtn.MouseButton1Click:Connect(function()
			if not isStealing and not autoStealEnabled then
				selectedPrompt = petData.prompt
				selectedSlotNumber = petData.slot
				createSlotMarker(petData.prompt)
				showTpPathVisual(petData.prompt, petData.slot)
				updatePetList()
			end
		end)
		table.insert(ActiveConnections, rowBtnConn)
	end

	if #tempPets == 0 then
		local emptyCard = Instance.new("Frame")
		emptyCard.Size = UDim2.new(1, -8, 0, 120)
		emptyCard.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		emptyCard.BorderSizePixel = 0
		emptyCard.Parent = scrollListRef
		Instance.new("UICorner", emptyCard).CornerRadius = UDim.new(0, 10)
		local es = Instance.new("UIStroke")
		es.Color = Color3.fromRGB(45, 45, 45)
		es.Parent = emptyCard

		local iconCircle = Instance.new("Frame")
		iconCircle.Size = UDim2.new(0, 40, 0, 40)
		iconCircle.Position = UDim2.new(0.5, -20, 0, 18)
		iconCircle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		iconCircle.BorderSizePixel = 0
		iconCircle.Parent = emptyCard
		Instance.new("UICorner", iconCircle).CornerRadius = UDim.new(0, 20)

		local iconLabel = Instance.new("TextLabel")
		iconLabel.Size = UDim2.new(1, 0, 1, 0)
		iconLabel.BackgroundTransparency = 1
		iconLabel.Text = "⚡"
		iconLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		iconLabel.TextSize = 18
		iconLabel.Font = Enum.Font.GothamBold
		iconLabel.Parent = iconCircle

		local titleLabel = Instance.new("TextLabel")
		titleLabel.Size = UDim2.new(1, -16, 0, 22)
		titleLabel.Position = UDim2.new(0, 8, 0, 64)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = "No brainrots found"
		titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
		titleLabel.TextSize = 13
		titleLabel.Font = Enum.Font.GothamMedium
		titleLabel.Parent = emptyCard
	end
end

-- ==========================================
-- UI REDESIGN - Abas na esquerda + botões embaixo
-- CORES: VERMELHO E PRETO
-- NOME: NOX
-- ==========================================
local old = PlayerGui:FindFirstChild("NOX")
if old then
	old:Destroy()
end

local C = {
	accent = Color3.fromRGB(200, 0, 0),
	accentHi = Color3.fromRGB(255, 0, 0),
	accentDark = Color3.fromRGB(100, 0, 0),
	deepBlue = Color3.fromRGB(20, 0, 0),
	body = Color3.fromRGB(8, 8, 8),
	panel = Color3.fromRGB(14, 14, 14),
	tabBar = Color3.fromRGB(12, 12, 12),
	card = Color3.fromRGB(18, 18, 18),
	iconBg = Color3.fromRGB(30, 30, 30),
	stroke = Color3.fromRGB(50, 50, 50),
	strokeDim = Color3.fromRGB(35, 35, 35),
	textBright = Color3.fromRGB(240, 240, 240),
	textBlue = Color3.fromRGB(255, 0, 0),
	textMute = Color3.fromRGB(200, 0, 0),
	textDim = Color3.fromRGB(150, 0, 0),
	knobOn = Color3.fromRGB(200, 0, 0),
	knobOff = Color3.fromRGB(100, 0, 0),
	trackOff = Color3.fromRGB(26, 26, 26),
}

-- Efeito de borda vermelho/preto pulsante
local borderGradientSeq = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
	ColorSequenceKeypoint.new(0.25, Color3.fromRGB(20, 0, 0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 0, 0)),
	ColorSequenceKeypoint.new(0.75, Color3.fromRGB(10, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
})

local function getDevice()
	local screen = workspace.CurrentCamera.ViewportSize
	local w, h = screen.X, screen.Y
	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	if isMobile then
		if w >= 900 or h >= 900 then
			return "ipad"
		end
		return "mobile"
	end
	return "pc"
end

local DEVICE = getDevice()

local LAYOUT = {
	pc = {
		winW = 360,
		winH = 460,
		posX = UDim2.new(0.5, 0, 0.5, 0),
		tabW = 90,
		btnH = 38,
		headerH = 40,
		textSize = { header = 12, tab = 12, btn = 12, stats = 12 },
	},
	ipad = {
		winW = 320,
		winH = 420,
		posX = UDim2.new(0.5, 0, 0.5, 0),
		tabW = 80,
		btnH = 36,
		headerH = 38,
		textSize = { header = 11, tab = 11, btn = 11, stats = 11 },
	},
	mobile = {
		winW = 280,
		winH = 380,
		posX = UDim2.new(0.5, 0, 0.5, 0),
		tabW = 70,
		btnH = 34,
		headerH = 36,
		textSize = { header = 10, tab = 10, btn = 10, stats = 10 },
	},
}

local L = LAYOUT[DEVICE]

local NOX_GUI = Instance.new("ScreenGui")
NOX_GUI.Name = "NOX"
NOX_GUI.ResetOnSpawn = false
NOX_GUI.DisplayOrder = 999
NOX_GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NOX_GUI.IgnoreGuiInset = false
NOX_GUI.Parent = PlayerGui

-- Border (contorno animado vermelho/preto)
local BorderFrame = Instance.new("Frame")
BorderFrame.Name = "BorderFrame"
BorderFrame.Size = UDim2.new(0, L.winW + 4, 0, L.winH + 4)
BorderFrame.Position = L.posX
BorderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
BorderFrame.BackgroundColor3 = C.accent
BorderFrame.BorderSizePixel = 0
BorderFrame.Active = true
BorderFrame.Parent = NOX_GUI
Instance.new("UICorner", BorderFrame).CornerRadius = UDim.new(0, 14)

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = borderGradientSeq
UIGradient.Rotation = 308.077
UIGradient.Parent = BorderFrame

-- Janela principal
local Win = Instance.new("Frame")
Win.Name = "Win"
Win.Size = UDim2.new(0, L.winW, 0, L.winH)
Win.Position = L.posX
Win.AnchorPoint = Vector2.new(0.5, 0.5)
Win.BackgroundTransparency = 1
Win.BorderSizePixel = 0
Win.ZIndex = 2
Win.Active = true
Win.Parent = NOX_GUI

local Frame = Instance.new("Frame")
Frame.Name = "Frame"
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.BackgroundColor3 = C.body
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Active = true
Frame.Parent = Win
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 14)

-- ==========================================
-- HEADER (Título + Fechar/Minimizar/Lock)
-- ==========================================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, L.headerH)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = C.panel
Header.BorderSizePixel = 0
Header.ZIndex = 3
Header.Active = true
Header.Parent = Frame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -80, 1, 0)
HeaderTitle.Position = UDim2.new(0, 14, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.ZIndex = 5
HeaderTitle.Text = "NOX"
HeaderTitle.TextColor3 = C.accent
HeaderTitle.TextSize = L.textSize.header
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = Header

-- Botões do header
local function headerButton(name, txt, xOff)
	local b = Instance.new("TextButton")
	b.Name = name
	b.Size = UDim2.new(0, 22, 0, 22)
	b.Position = UDim2.new(1, xOff, 0.5, -11)
	b.BackgroundColor3 = C.card
	b.BorderSizePixel = 0
	b.ZIndex = 6
	b.Text = txt
	b.TextColor3 = C.textMute
	b.TextSize = L.textSize.header
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Parent = Header
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	local s = Instance.new("UIStroke")
	s.Color = C.stroke
	s.Parent = b
	return b
end

local hbOff = DEVICE == "mobile" and { -68, -46, -24 } or { -68, -46, -24 }
local LockBtn = headerButton("Lock", "🔓", hbOff[1])
local MinBtn = headerButton("Min", "–", hbOff[2])
local CloseBtn = headerButton("Close", "X", hbOff[3])

-- ==========================================
-- LAYOUT: Abas à esquerda + Conteúdo à direita
-- ==========================================
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, 0, 1, -(L.headerH + L.btnH + 2))
ContentArea.Position = UDim2.new(0, 0, 0, L.headerH)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel = 0
ContentArea.ZIndex = 2
ContentArea.Parent = Frame

-- ==========================================
-- ABAS (Esquerda)
-- ==========================================
local TabsContainer = Instance.new("Frame")
TabsContainer.Size = UDim2.new(0, L.tabW, 1, -4)
TabsContainer.Position = UDim2.new(0, 2, 0, 2)
TabsContainer.BackgroundTransparency = 1
TabsContainer.BorderSizePixel = 0
TabsContainer.ZIndex = 3
TabsContainer.ClipsDescendants = true
TabsContainer.Parent = ContentArea

-- Divisória vertical
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0, 1, 1, -8)
Divider.Position = UDim2.new(0, L.tabW + 4, 0, 4)
Divider.BackgroundColor3 = C.stroke
Divider.BorderSizePixel = 0
Divider.ZIndex = 3
Divider.Parent = ContentArea

-- Conteúdo (Direita)
local RightContent = Instance.new("Frame")
RightContent.Size = UDim2.new(1, -(L.tabW + 8), 1, -4)
RightContent.Position = UDim2.new(0, L.tabW + 8, 0, 2)
RightContent.BackgroundTransparency = 1
RightContent.BorderSizePixel = 0
RightContent.ZIndex = 2
RightContent.ClipsDescendants = true
RightContent.Parent = ContentArea

-- ==========================================
-- PAINEL DE ABAS (Brainrots / Settings)
-- ==========================================
local TabBrainrots = Instance.new("TextButton")
TabBrainrots.Size = UDim2.new(1, 0, 0, 44)
TabBrainrots.Position = UDim2.new(0, 0, 0, 6)
TabBrainrots.BackgroundColor3 = C.accent
TabBrainrots.BorderSizePixel = 0
TabBrainrots.ZIndex = 4
TabBrainrots.Text = "Brainrots"
TabBrainrots.TextColor3 = C.body
TabBrainrots.TextSize = L.textSize.tab
TabBrainrots.Font = Enum.Font.GothamBold
TabBrainrots.AutoButtonColor = false
TabBrainrots.Parent = TabsContainer
Instance.new("UICorner", TabBrainrots).CornerRadius = UDim.new(0, 8)

local TabSettings = Instance.new("TextButton")
TabSettings.Size = UDim2.new(1, 0, 0, 44)
TabSettings.Position = UDim2.new(0, 0, 0, 56)
TabSettings.BackgroundColor3 = C.card
TabSettings.BorderSizePixel = 0
TabSettings.ZIndex = 4
TabSettings.Text = "Settings"
TabSettings.TextColor3 = C.textMute
TabSettings.TextSize = L.textSize.tab
TabSettings.Font = Enum.Font.GothamBold
TabSettings.AutoButtonColor = false
TabSettings.Parent = TabsContainer
Instance.new("UICorner", TabSettings).CornerRadius = UDim.new(0, 8)

local function updateTabs(active)
	if active == "brainrots" then
		TabBrainrots.BackgroundColor3 = C.accent
		TabBrainrots.TextColor3 = C.body
		TabSettings.BackgroundColor3 = C.card
		TabSettings.TextColor3 = C.textMute
	else
		TabBrainrots.BackgroundColor3 = C.card
		TabBrainrots.TextColor3 = C.textMute
		TabSettings.BackgroundColor3 = C.accent
		TabSettings.TextColor3 = C.body
	end
end

-- ==========================================
-- CONTEÚDO (Brainrots)
-- ==========================================
local BrainrotsContent = Instance.new("Frame")
BrainrotsContent.Size = UDim2.new(1, 0, 1, 0)
BrainrotsContent.BackgroundTransparency = 1
BrainrotsContent.BorderSizePixel = 0
BrainrotsContent.ZIndex = 3
BrainrotsContent.Parent = RightContent

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Active = true
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 3
ScrollingFrame.ScrollBarImageColor3 = C.accent
ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.Parent = BrainrotsContent

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.Parent = ScrollingFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 6)
UIPadding.PaddingBottom = UDim.new(0, 6)
UIPadding.PaddingLeft = UDim.new(0, 4)
UIPadding.PaddingRight = UDim.new(0, 4)
UIPadding.Parent = ScrollingFrame

scrollListRef = ScrollingFrame

-- ==========================================
-- CONTEÚDO (Settings)
-- ==========================================
local SettingsContent = Instance.new("Frame")
SettingsContent.Size = UDim2.new(1, 0, 1, 0)
SettingsContent.BackgroundTransparency = 1
SettingsContent.BorderSizePixel = 0
SettingsContent.Visible = false
SettingsContent.ZIndex = 3
SettingsContent.Parent = RightContent

local parent = Instance.new("ScrollingFrame")
parent.Size = UDim2.new(1, 0, 1, 0)
parent.BackgroundTransparency = 1
parent.BorderSizePixel = 0
parent.Active = true
parent.CanvasSize = UDim2.new(0, 0, 0, 0)
parent.ScrollBarThickness = 3
parent.ScrollBarImageColor3 = C.accent
parent.ScrollingDirection = Enum.ScrollingDirection.Y
parent.AutomaticCanvasSize = Enum.AutomaticSize.Y
parent.Parent = SettingsContent

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.Padding = UDim.new(0, 4)
uiListLayout.Parent = parent

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 6)
uiPadding.PaddingBottom = UDim.new(0, 6)
uiPadding.PaddingLeft = UDim.new(0, 4)
uiPadding.PaddingRight = UDim.new(0, 4)
uiPadding.Parent = parent

-- ==========================================
-- BOTÕES INFERIORES (Flash, Block, Reset)
-- SEM EMOJIS
-- ==========================================
local ButtonBar = Instance.new("Frame")
ButtonBar.Size = UDim2.new(1, 0, 0, L.btnH + 4)
ButtonBar.Position = UDim2.new(0, 0, 1, -(L.btnH + 2))
ButtonBar.BackgroundTransparency = 1
ButtonBar.BorderSizePixel = 0
ButtonBar.ZIndex = 4
ButtonBar.Parent = Frame

-- Linha divisória acima dos botões
local TopDivider = Instance.new("Frame")
TopDivider.Size = UDim2.new(1, -16, 0, 1)
TopDivider.Position = UDim2.new(0, 8, 0, 0)
TopDivider.BackgroundColor3 = C.stroke
TopDivider.BorderSizePixel = 0
TopDivider.ZIndex = 5
TopDivider.Parent = ButtonBar

local BTN_W = 80
local BTN_GAP = 12
local totalW = BTN_W * 3 + BTN_GAP * 2
local startX = (L.winW - totalW) / 2

local function actionButton(name, label, xPos)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0, BTN_W, 1, -6)
	btn.Position = UDim2.new(0, xPos, 0, 3)
	btn.BackgroundColor3 = C.card
	btn.BorderSizePixel = 0
	btn.ZIndex = 5
	btn.Text = label
	btn.TextColor3 = C.textBright
	btn.TextSize = L.textSize.btn
	btn.Font = Enum.Font.GothamBold
	btn.AutoButtonColor = false
	btn.Parent = ButtonBar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	local s = Instance.new("UIStroke")
	s.Color = C.stroke
	s.Parent = btn
	-- Accent bar on top (vermelho)
	local acc = Instance.new("Frame")
	acc.Size = UDim2.new(1, -10, 0, 2)
	acc.Position = UDim2.new(0, 5, 0, 0)
	acc.BackgroundColor3 = C.accent
	acc.BorderSizePixel = 0
	acc.ZIndex = 6
	acc.Parent = btn
	Instance.new("UICorner", acc).CornerRadius = UDim.new(0, 2)
	return btn, acc
end

local FLASHTP, flashAccent = actionButton("FLASH TP", "FLASH", startX)
local BLOCK, blockAccent = actionButton("BLOCK", "BLOCK", startX + BTN_W + BTN_GAP)
local RESET, resetAccent = actionButton("RESET", "RESET", startX + (BTN_W + BTN_GAP) * 2)

-- ==========================================
-- TOGGLES (Settings)
-- ==========================================
local sectionOrder = 0
local toggleRefs = {}

local function sectionHeader(text)
	sectionOrder += 1
	local wrap = Instance.new("Frame")
	wrap.Size = UDim2.new(1, 0, 0, 20)
	wrap.BackgroundTransparency = 1
	wrap.BorderSizePixel = 0
	wrap.ZIndex = 4
	wrap.LayoutOrder = sectionOrder
	wrap.Parent = parent
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 0.5, 0)
	line.BackgroundColor3 = C.stroke
	line.BorderSizePixel = 0
	line.ZIndex = 5
	line.Parent = wrap
	local pill = Instance.new("Frame")
	pill.Size = UDim2.new(0, 0, 1, 0)
	pill.Position = UDim2.new(0.5, 0, 0, 0)
	pill.AnchorPoint = Vector2.new(0.5, 0)
	pill.BackgroundColor3 = C.body
	pill.BorderSizePixel = 0
	pill.ZIndex = 6
	pill.AutomaticSize = Enum.AutomaticSize.X
	pill.Parent = wrap
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.ZIndex = 7
	lbl.Text = text
	lbl.TextColor3 = C.textMute
	lbl.TextSize = 10
	lbl.Font = Enum.Font.GothamBold
	lbl.Parent = pill
	return wrap
end

local function toggleRow(title, desc, defaultOn, onToggle)
	sectionOrder += 1
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 48)
	row.BackgroundColor3 = C.card
	row.BorderSizePixel = 0
	row.ZIndex = 4
	row.LayoutOrder = sectionOrder
	row.Parent = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
	local s = Instance.new("UIStroke")
	s.Color = C.strokeDim
	s.Parent = row

	local accentBar = Instance.new("Frame")
	accentBar.Size = UDim2.new(0, 3, 1, -8)
	accentBar.Position = UDim2.new(0, 0, 0, 4)
	accentBar.BackgroundColor3 = C.accent
	accentBar.BorderSizePixel = 0
	accentBar.ZIndex = 5
	accentBar.Parent = row
	Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 2)

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -52, 0, 22)
	textLabel.Position = UDim2.new(0, 12, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.ZIndex = 5
	textLabel.Text = title
	textLabel.TextColor3 = C.textBright
	textLabel.TextSize = 12
	textLabel.Font = Enum.Font.GothamMedium
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Parent = row

	local secondaryTextLabel = Instance.new("TextLabel")
	secondaryTextLabel.Size = UDim2.new(1, -52, 0, 18)
	secondaryTextLabel.Position = UDim2.new(0, 12, 0, 20)
	secondaryTextLabel.BackgroundTransparency = 1
	secondaryTextLabel.ZIndex = 5
	secondaryTextLabel.Text = desc
	secondaryTextLabel.TextColor3 = C.textMute
	secondaryTextLabel.TextSize = 10
	secondaryTextLabel.Font = Enum.Font.Gotham
	secondaryTextLabel.TextWrapped = true
	secondaryTextLabel.TextXAlignment = Enum.TextXAlignment.Left
	secondaryTextLabel.Parent = row

	local track = Instance.new("Frame")
	track.Size = UDim2.new(0, 34, 0, 18)
	track.Position = UDim2.new(1, -40, 0.5, -9)
	track.BackgroundColor3 = C.accent
	track.BorderSizePixel = 0
	track.ZIndex = 6
	track.Parent = row
	Instance.new("UICorner", track).CornerRadius = UDim.new(0, 9)
	local ts = Instance.new("UIStroke")
	ts.Color = C.accent
	ts.Parent = track

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 12, 0, 12)
	knob.Position = UDim2.new(0, 18, 0.5, -6)
	knob.BackgroundColor3 = C.knobOn
	knob.BorderSizePixel = 0
	knob.ZIndex = 7
	knob.Parent = track
	Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 6)

	local hit = Instance.new("TextButton")
	hit.Size = UDim2.new(1, 0, 1, 0)
	hit.BackgroundTransparency = 1
	hit.ZIndex = 8
	hit.Text = ""
	hit.Parent = row

	local ref = { on = defaultOn ~= false, track = track, stroke = ts, knob = knob }
	local function render(animate)
		local info = TweenInfo.new(animate and 0.16 or 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		if ref.on then
			TweenService:Create(track, info, { BackgroundColor3 = C.accent }):Play()
			TweenService:Create(ts, info, { Color = C.accent }):Play()
			TweenService:Create(knob, info, { Position = UDim2.new(0, 18, 0.5, -6), BackgroundColor3 = C.knobOn })
				:Play()
		else
			TweenService:Create(track, info, { BackgroundColor3 = C.trackOff }):Play()
			TweenService:Create(ts, info, { Color = C.stroke }):Play()
			TweenService:Create(knob, info, { Position = UDim2.new(0, 4, 0.5, -6), BackgroundColor3 = C.knobOff })
				:Play()
		end
	end
	render(false)
	if onToggle then
		task.defer(function()
			pcall(onToggle, ref.on)
		end)
	end
	hit.MouseButton1Click:Connect(function()
		ref.on = not ref.on
		render(true)
		if onToggle then
			pcall(onToggle, ref.on)
		end
		saveSettings()
	end)
	table.insert(toggleRefs, ref)
	return row, ref
end

sectionHeader("  AUTO RESET  ")
toggleRow("Reset On Balloon", "Auto reset when ballooned", _G.AutoResetOnBalloon, function(v)
	_G.AutoResetOnBalloon = v
end)
toggleRow("Reset On Tiny", "Auto reset when tiny", _G.AutoResetOnTiny, function(v)
	_G.AutoResetOnTiny = v
end)
toggleRow("Reset On Jail", "Auto reset when jailed", _G.AutoResetOnJail, function(v)
	_G.AutoResetOnJail = v
end)

sectionHeader("  FLASH TP  ")
toggleRow("Auto Block", "Block all players after Flash", _G.AutoBlock, function(v)
	_G.AutoBlock = v
end)
toggleRow("Auto Giant", "Giant potion after Flash", _G.AutoGiant, function(v)
	_G.AutoGiant = v
end)
toggleRow("Bypass Ragdoll", "Ragdoll after Flash", _G.RagdollBypass, function(v)
	_G.RagdollBypass = v
end)
toggleRow("Anti Swap", "Tiny+Rocket on closest", _G.AntiSwap, function(v)
	_G.AntiSwap = v
end)
toggleRow("Auto Flash TP", "Auto Flash after reset", _G.AutoFlashTP, function(v)
	_G.AutoFlashTP = v
end)

sectionHeader("  LAGGER  ")
toggleRow("Lagger On Flash", "Lag during Flash TP", _G.LaggerOnFlash, function(v)
	_G.LaggerOnFlash = v
	if not v then
		stopFlashLagger()
	end
end)

-- Lagger Power Slider
do
	sectionOrder += 1
	local lagRow = Instance.new("Frame")
	lagRow.Size = UDim2.new(1, 0, 0, 64)
	lagRow.BackgroundColor3 = C.card
	lagRow.BorderSizePixel = 0
	lagRow.ZIndex = 4
	lagRow.LayoutOrder = sectionOrder
	lagRow.Parent = parent
	Instance.new("UICorner", lagRow).CornerRadius = UDim.new(0, 8)
	local lagStroke = Instance.new("UIStroke")
	lagStroke.Color = C.strokeDim
	lagStroke.Parent = lagRow

	local lagLeftBar = Instance.new("Frame")
	lagLeftBar.Size = UDim2.new(0, 3, 1, -8)
	lagLeftBar.Position = UDim2.new(0, 0, 0, 4)
	lagLeftBar.BackgroundColor3 = C.accent
	lagLeftBar.BorderSizePixel = 0
	lagLeftBar.Parent = lagRow
	Instance.new("UICorner", lagLeftBar).CornerRadius = UDim.new(0, 2)

	local lagTitle = Instance.new("TextLabel")
	lagTitle.Size = UDim2.new(1, -60, 0, 18)
	lagTitle.Position = UDim2.new(0, 12, 0, 4)
	lagTitle.BackgroundTransparency = 1
	lagTitle.Text = "Lagger Power"
	lagTitle.TextColor3 = C.textBright
	lagTitle.TextSize = 12
	lagTitle.Font = Enum.Font.GothamMedium
	lagTitle.TextXAlignment = Enum.TextXAlignment.Left
	lagTitle.Parent = lagRow

	local lagVal = Instance.new("TextLabel")
	lagVal.Size = UDim2.new(0, 50, 0, 18)
	lagVal.Position = UDim2.new(1, -56, 0, 4)
	lagVal.BackgroundTransparency = 1
	lagVal.Text = tostring(math.floor(_G.LaggerPower or 50)) .. "%"
	lagVal.TextColor3 = C.accent
	lagVal.TextSize = 12
	lagVal.Font = Enum.Font.GothamBold
	lagVal.TextXAlignment = Enum.TextXAlignment.Right
	lagVal.Parent = lagRow

	local lagTrack = Instance.new("Frame")
	lagTrack.Size = UDim2.new(1, -24, 0, 6)
	lagTrack.Position = UDim2.new(0, 12, 0, 36)
	lagTrack.BackgroundColor3 = C.trackOff
	lagTrack.BorderSizePixel = 0
	lagTrack.ZIndex = 5
	lagTrack.Parent = lagRow
	Instance.new("UICorner", lagTrack).CornerRadius = UDim.new(1, 0)

	local lagFill = Instance.new("Frame")
	lagFill.Size = UDim2.new(math.clamp((_G.LaggerPower or 50) / 100, 0, 1), 0, 1, 0)
	lagFill.BackgroundColor3 = C.accent
	lagFill.BorderSizePixel = 0
	lagFill.ZIndex = 6
	lagFill.Parent = lagTrack
	Instance.new("UICorner", lagFill).CornerRadius = UDim.new(1, 0)

	local lagKnob = Instance.new("Frame")
	lagKnob.Size = UDim2.new(0, 14, 0, 14)
	lagKnob.AnchorPoint = Vector2.new(0.5, 0.5)
	lagKnob.Position = UDim2.new(math.clamp((_G.LaggerPower or 50) / 100, 0, 1), 0, 0.5, 0)
	lagKnob.BackgroundColor3 = C.knobOn
	lagKnob.BorderSizePixel = 0
	lagKnob.ZIndex = 7
	lagKnob.Parent = lagTrack
	Instance.new("UICorner", lagKnob).CornerRadius = UDim.new(1, 0)
	local lagKnobStroke = Instance.new("UIStroke")
	lagKnobStroke.Color = C.accent
	lagKnobStroke.Thickness = 1.5
	lagKnobStroke.Parent = lagKnob

	local lagHint = Instance.new("TextLabel")
	lagHint.Size = UDim2.new(1, -24, 0, 12)
	lagHint.Position = UDim2.new(0, 12, 0, 46)
	lagHint.BackgroundTransparency = 1
	lagHint.Text = "0% = light  |  100% = max"
	lagHint.TextColor3 = C.textMute
	lagHint.TextSize = 9
	lagHint.Font = Enum.Font.Gotham
	lagHint.TextXAlignment = Enum.TextXAlignment.Left
	lagHint.Parent = lagRow

	local function updateLaggerPower(pct)
		pct = math.clamp(pct, 0, 1)
		_G.LaggerPower = math.floor(pct * 100 + 0.5)
		lagFill.Size = UDim2.new(pct, 0, 1, 0)
		lagKnob.Position = UDim2.new(pct, 0, 0.5, 0)
		lagVal.Text = tostring(_G.LaggerPower) .. "%"
		saveSettings()
	end

	local draggingLag = false
	lagTrack.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			draggingLag = true
			local pct = (inp.Position.X - lagTrack.AbsolutePosition.X) / lagTrack.AbsoluteSize.X
			updateLaggerPower(pct)
		end
	end)
	lagKnob.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			draggingLag = true
		end
	end)
	table.insert(
		ActiveConnections,
		UserInputService.InputChanged:Connect(function(inp)
			if
				draggingLag
				and (
					inp.UserInputType == Enum.UserInputType.MouseMovement
					or inp.UserInputType == Enum.UserInputType.Touch
				)
			then
				local pct = (inp.Position.X - lagTrack.AbsolutePosition.X) / lagTrack.AbsoluteSize.X
				updateLaggerPower(pct)
			end
		end)
	)
	table.insert(
		ActiveConnections,
		UserInputService.InputEnded:Connect(function(inp)
			if
				inp.UserInputType == Enum.UserInputType.MouseButton1
				or inp.UserInputType == Enum.UserInputType.Touch
			then
				draggingLag = false
			end
		end)
	)
end

sectionHeader("  COMBAT  ")
toggleRow("Auto Balloon", "Balloon brainrots in zones", _G.AutoBalloon, function(v)
	_G.AutoBalloon = v
	if not v then
		BalloonState.Active = {}
	end
end)
toggleRow("Anti Ragdoll", "Advanced anti-ragdoll", _G.AntiRagdoll, function(v)
	_G.AntiRagdoll = v
	antiRagdollEnabled = v
	if v then
		startAntiRagdoll()
	else
		stopAntiRagdoll()
	end
end)

sectionHeader("  ESP / VISUAL  ")
toggleRow("Slot ESP", "Red highlight on brainrot", _G.SlotESP, function(v)
	_G.SlotESP = v
	if v and selectedPrompt then
		createSlotMarker(selectedPrompt)
	else
		clearSlotMarker()
	end
end)
toggleRow("Auto Select Best", "Auto select lowest slot", _G.AutoSelectBest, function(v)
	_G.AutoSelectBest = v
end)

-- Block Delay selector
sectionOrder += 1
local bdContainer = Instance.new("Frame")
bdContainer.Size = UDim2.new(1, 0, 0, 64)
bdContainer.BackgroundColor3 = C.card
bdContainer.BorderSizePixel = 0
bdContainer.ZIndex = 4
bdContainer.LayoutOrder = sectionOrder
bdContainer.Parent = parent
Instance.new("UICorner", bdContainer).CornerRadius = UDim.new(0, 8)
local bdStroke = Instance.new("UIStroke")
bdStroke.Color = C.strokeDim
bdStroke.Parent = bdContainer

local bdLeftBar = Instance.new("Frame")
bdLeftBar.Size = UDim2.new(0, 3, 1, -8)
bdLeftBar.Position = UDim2.new(0, 0, 0, 4)
bdLeftBar.BackgroundColor3 = C.accent
bdLeftBar.BorderSizePixel = 0
bdLeftBar.Parent = bdContainer
Instance.new("UICorner", bdLeftBar).CornerRadius = UDim.new(0, 2)

local bdLabel = Instance.new("TextLabel")
bdLabel.Size = UDim2.new(1, -50, 0, 20)
bdLabel.Position = UDim2.new(0, 12, 0, 6)
bdLabel.BackgroundTransparency = 1
bdLabel.Text = "Block Delay"
bdLabel.TextColor3 = C.textBright
bdLabel.TextSize = 12
bdLabel.Font = Enum.Font.GothamMedium
bdLabel.TextXAlignment = Enum.TextXAlignment.Left
bdLabel.Parent = bdContainer

local bdSubLabel = Instance.new("TextLabel")
bdSubLabel.Size = UDim2.new(1, -50, 0, 16)
bdSubLabel.Position = UDim2.new(0, 12, 0, 26)
bdSubLabel.BackgroundTransparency = 1
bdSubLabel.Text = "Delay before blocking starts"
bdSubLabel.TextColor3 = C.textMute
bdSubLabel.TextSize = 9
bdSubLabel.Font = Enum.Font.Gotham
bdSubLabel.TextXAlignment = Enum.TextXAlignment.Left
bdSubLabel.Parent = bdContainer

local function makeDelayBtn(text, key, x)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 38, 0, 18)
	btn.Position = UDim2.new(1, x, 0, 8)
	btn.BackgroundColor3 = _G.BlockDelay == key and C.accent or C.card
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = _G.BlockDelay == key and C.body or C.textMute
	btn.TextSize = 9
	btn.Font = Enum.Font.GothamMedium
	btn.AutoButtonColor = false
	btn.Parent = bdContainer
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
	local st = Instance.new("UIStroke")
	st.Color = _G.BlockDelay == key and C.accent or C.stroke
	st.Parent = btn
	btn.MouseButton1Click:Connect(function()
		_G.BlockDelay = key
		saveSettings()
		for _, child in ipairs(bdContainer:GetChildren()) do
			if child:IsA("TextButton") then
				local isActive = (child.Text == "FAST" and key == "fast")
					or (child.Text == "NORMAL" and key == "normal")
					or (child.Text == "SLOW" and key == "slow")
				child.BackgroundColor3 = isActive and C.accent or C.card
				child.TextColor3 = isActive and C.body or C.textMute
				local s = child:FindFirstChildOfClass("UIStroke")
				if s then
					s.Color = isActive and C.accent or C.stroke
				end
			end
		end
	end)
	return btn
end
makeDelayBtn("FAST", "fast", -124)
makeDelayBtn("NORMAL", "normal", -80)
makeDelayBtn("SLOW", "slow", -36)

-- Carpet selector
sectionOrder += 1
local carpetContainer = Instance.new("Frame")
carpetContainer.Size = UDim2.new(1, 0, 0, 90)
carpetContainer.BackgroundColor3 = C.card
carpetContainer.BorderSizePixel = 0
carpetContainer.ZIndex = 4
carpetContainer.LayoutOrder = sectionOrder
carpetContainer.Parent = parent
Instance.new("UICorner", carpetContainer).CornerRadius = UDim.new(0, 8)
local carpetStroke = Instance.new("UIStroke")
carpetStroke.Color = C.strokeDim
carpetStroke.Parent = carpetContainer

local carpetLeftBar = Instance.new("Frame")
carpetLeftBar.Size = UDim2.new(0, 3, 1, -8)
carpetLeftBar.Position = UDim2.new(0, 0, 0, 4)
carpetLeftBar.BackgroundColor3 = C.accent
carpetLeftBar.BorderSizePixel = 0
carpetLeftBar.Parent = carpetContainer
Instance.new("UICorner", carpetLeftBar).CornerRadius = UDim.new(0, 2)

local carpetLabel = Instance.new("TextLabel")
carpetLabel.Size = UDim2.new(1, -20, 0, 20)
carpetLabel.Position = UDim2.new(0, 12, 0, 4)
carpetLabel.BackgroundTransparency = 1
carpetLabel.Text = "Flying Gear"
carpetLabel.TextColor3 = C.textBright
carpetLabel.TextSize = 12
carpetLabel.Font = Enum.Font.GothamMedium
carpetLabel.TextXAlignment = Enum.TextXAlignment.Left
carpetLabel.Parent = carpetContainer

local carpetSubLabel = Instance.new("TextLabel")
carpetSubLabel.Size = UDim2.new(1, -20, 0, 14)
carpetSubLabel.Position = UDim2.new(0, 12, 0, 22)
carpetSubLabel.BackgroundTransparency = 1
carpetSubLabel.Text = "Gear used during Flash TP"
carpetSubLabel.TextColor3 = C.textMute
carpetSubLabel.TextSize = 9
carpetSubLabel.Font = Enum.Font.Gotham
carpetSubLabel.TextXAlignment = Enum.TextXAlignment.Left
carpetSubLabel.Parent = carpetContainer

local carpetOptions = {
	{ id = "carpet", label = "CARPET" },
	{ id = "broom", label = "BROOM" },
	{ id = "sleigh", label = "SLEIGH" },
	{ id = "wings", label = "WINGS" },
	{ id = "waverider", label = "WAVE" },
}

local carpetBtns = {}
for i, opt in ipairs(carpetOptions) do
	local btn = Instance.new("TextButton")
	local bw = 38
	btn.Size = UDim2.new(0, bw, 0, 20)
	btn.Position = UDim2.new(0, 4 + (i - 1) * (bw + 4), 0, 44)
	btn.BackgroundColor3 = (_G.SelectedCarpet or "carpet") == opt.id and C.accent or C.card
	btn.BorderSizePixel = 0
	btn.Text = opt.label
	btn.TextColor3 = (_G.SelectedCarpet or "carpet") == opt.id and C.body or C.textMute
	btn.TextSize = 8
	btn.Font = Enum.Font.GothamMedium
	btn.AutoButtonColor = false
	btn.Parent = carpetContainer
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
	local btnStroke = Instance.new("UIStroke")
	btnStroke.Color = (_G.SelectedCarpet or "carpet") == opt.id and C.accent or C.stroke
	btnStroke.Parent = btn
	carpetBtns[opt.id] = { btn = btn, stroke = btnStroke }

	btn.MouseButton1Click:Connect(function()
		_G.SelectedCarpet = opt.id
		for id, data in pairs(carpetBtns) do
			local selected = id == opt.id
			data.btn.BackgroundColor3 = selected and C.accent or C.card
			data.btn.TextColor3 = selected and C.body or C.textMute
			data.stroke.Color = selected and C.accent or C.stroke
		end
		saveSettings()
	end)
end

-- ==========================================
-- KEYBINDS UI
-- ==========================================
if DEVICE == "pc" then
	sectionHeader("  KEYBINDS  ")

	local function makeKeybindRow(actionName, displayName)
		sectionOrder += 1
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 38)
		row.BackgroundColor3 = C.card
		row.BorderSizePixel = 0
		row.ZIndex = 4
		row.LayoutOrder = sectionOrder
		row.Parent = parent
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
		local s = Instance.new("UIStroke")
		s.Color = C.strokeDim
		s.Parent = row

		local nameLbl = Instance.new("TextLabel")
		nameLbl.Size = UDim2.new(1, -80, 1, 0)
		nameLbl.Position = UDim2.new(0, 12, 0, 0)
		nameLbl.BackgroundTransparency = 1
		nameLbl.ZIndex = 5
		nameLbl.Text = displayName
		nameLbl.TextColor3 = C.textBright
		nameLbl.TextSize = 12
		nameLbl.Font = Enum.Font.GothamMedium
		nameLbl.TextXAlignment = Enum.TextXAlignment.Left
		nameLbl.Parent = row

		local keyBtn = Instance.new("TextButton")
		keyBtn.Size = UDim2.new(0, 50, 0, 22)
		keyBtn.Position = UDim2.new(1, -56, 0.5, -11)
		keyBtn.BackgroundColor3 = C.iconBg
		keyBtn.BorderSizePixel = 0
		keyBtn.ZIndex = 6
		keyBtn.Text = keyNames[actionName]
		keyBtn.TextColor3 = C.textBright
		keyBtn.TextSize = 11
		keyBtn.Font = Enum.Font.GothamBold
		keyBtn.AutoButtonColor = false
		keyBtn.Parent = row
		Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)
		local ks = Instance.new("UIStroke")
		ks.Color = C.accent
		ks.Parent = keyBtn

		local listening = false
		keyBtn.MouseButton1Click:Connect(function()
			if listening then
				return
			end
			listening = true
			keyBtn.Text = "..."
			keyBtn.TextColor3 = C.accent
			local conn
			conn = UserInputService.InputBegan:Connect(function(inp, gpe)
				if gpe then
					return
				end
				if inp.UserInputType ~= Enum.UserInputType.Keyboard then
					return
				end
				conn:Disconnect()
				listening = false
				keybinds[actionName] = inp.KeyCode
				keyNames[actionName] = inp.KeyCode.Name
				keyBtn.Text = inp.KeyCode.Name
				keyBtn.TextColor3 = C.textBright
				saveKeybinds()
				if actionName == "flash" then
					local lbl = FLASHTP:FindFirstChildOfClass("TextLabel")
					if lbl then
						lbl.Text = "FLASH [" .. inp.KeyCode.Name .. "]"
					end
				elseif actionName == "block" then
					local lbl = BLOCK:FindFirstChildOfClass("TextLabel")
					if lbl then
						lbl.Text = "BLOCK [" .. inp.KeyCode.Name .. "]"
					end
				elseif actionName == "reset" then
					local lbl = RESET:FindFirstChildOfClass("TextLabel")
					if lbl then
						lbl.Text = "RESET [" .. inp.KeyCode.Name .. "]"
					end
				end
			end)
		end)
	end

	makeKeybindRow("flash", "Flash TP")
	makeKeybindRow("block", "Block")
	makeKeybindRow("reset", "Reset")
end

-- ==========================================
-- FUNÇÕES UI
-- ==========================================
local locked = false
local function syncBorder()
	BorderFrame.Position = Win.Position
end
local dragging, dragStart, startPos

-- Drag da janela
Header.InputBegan:Connect(function(input)
	if locked then
		return
	end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Win.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if
		dragging
		and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch)
	then
		local d = input.Position - dragStart
		Win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		syncBorder()
	end
end)

-- Tabs
local function setTab(tab)
	if tab == "brainrots" then
		BrainrotsContent.Visible = true
		SettingsContent.Visible = false
		updateTabs("brainrots")
	else
		BrainrotsContent.Visible = false
		SettingsContent.Visible = true
		updateTabs("settings")
	end
end

TabBrainrots.MouseButton1Click:Connect(function()
	setTab("brainrots")
end)
TabSettings.MouseButton1Click:Connect(function()
	setTab("settings")
end)
setTab("brainrots")

-- Lock / Min / Close
LockBtn.MouseButton1Click:Connect(function()
	locked = not locked
	LockBtn.Text = locked and "🔒" or "🔓"
	LockBtn.TextColor3 = locked and C.accentHi or C.textMute
	TweenService:Create(LockBtn, TweenInfo.new(0.2), { BackgroundColor3 = locked and C.accent or C.card }):Play()
end)

local minimised = false
local fullSize = Win.Size
local fullBorder = BorderFrame.Size
local MIN_WIN_H = L.headerH + L.btnH + 10
local MIN_BORDER_H = MIN_WIN_H + 4

MinBtn.MouseButton1Click:Connect(function()
	if dragging then
		return
	end
	minimised = not minimised
	local info = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local currentWinPos = Win.Position
	local heightDiff = fullSize.Y.Offset - MIN_WIN_H
	local offset = heightDiff / 2
	if minimised then
		local targetWinPos = UDim2.new(
			currentWinPos.X.Scale,
			currentWinPos.X.Offset,
			currentWinPos.Y.Scale,
			currentWinPos.Y.Offset - offset
		)
		TweenService:Create(ContentArea, info, { Size = UDim2.new(1, 0, 0, 0) }):Play()
		TweenService:Create(ButtonBar, info, { Position = UDim2.new(0, 0, 1, -(L.btnH + 2)) }):Play()
		TweenService:Create(Win, info, { Size = UDim2.new(0, L.winW, 0, MIN_WIN_H), Position = targetWinPos }):Play()
		TweenService
			:Create(BorderFrame, info, { Size = UDim2.new(0, L.winW + 4, 0, MIN_BORDER_H), Position = targetWinPos })
			:Play()
	else
		local targetWinPos = UDim2.new(
			currentWinPos.X.Scale,
			currentWinPos.X.Offset,
			currentWinPos.Y.Scale,
			currentWinPos.Y.Offset + offset
		)
		TweenService:Create(ContentArea, info, { Size = UDim2.new(1, 0, 1, -(L.headerH + L.btnH + 2)) }):Play()
		TweenService:Create(ButtonBar, info, { Position = UDim2.new(0, 0, 1, -(L.btnH + 2)) }):Play()
		TweenService:Create(Win, info, { Size = fullSize, Position = targetWinPos }):Play()
		TweenService:Create(BorderFrame, info, { Size = fullBorder, Position = targetWinPos }):Play()
	end
end)

CloseBtn.MouseButton1Click:Connect(function()
	clearSlotMarker()
	clearTpPathVisual()
	thisScriptStopped = true
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local create = TweenService:Create(Win, info, { Size = UDim2.new(0, 0, 0, 0) })
	local secondaryCreate = TweenService:Create(BorderFrame, info, { Size = UDim2.new(0, 0, 0, 0) })
	create:Play()
	secondaryCreate:Play()
	create.Completed:Connect(function()
		NOX_GUI:Destroy()
	end)
end)

-- Hover effects
local function hookButton(btn, normal, hover)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = hover }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = normal }):Play()
	end)
	btn.MouseButton1Down:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.06), { BackgroundColor3 = C.deepBlue }):Play()
	end)
	btn.MouseButton1Up:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = hover }):Play()
	end)
end

hookButton(FLASHTP, C.card, C.iconBg)
hookButton(BLOCK, C.card, C.iconBg)
hookButton(RESET, C.card, C.iconBg)
for _, b in ipairs({ LockBtn, MinBtn, CloseBtn, TabBrainrots, TabSettings }) do
	hookButton(b, b.BackgroundColor3, C.iconBg)
end

local function flashBar(bar)
	bar.BackgroundColor3 = C.accentHi
	TweenService:Create(bar, TweenInfo.new(0.4), { BackgroundColor3 = C.accent }):Play()
end

-- Button events
FLASHTP.MouseButton1Click:Connect(function()
	if selectedPrompt and selectedSlotNumber then
		if not isStealing and not autoStealEnabled then
			flashBar(flashAccent)
			if _G.AntiSwap then
				task.spawn(function()
					pcall(executeTinyAndRocket)
				end)
			end
			startTripToPetSlot(selectedPrompt, selectedSlotNumber)
		end
	end
end)

BLOCK.MouseButton1Click:Connect(function()
	flashBar(blockAccent)
	blockAllPlayers()
end)

RESET.MouseButton1Click:Connect(function()
	flashBar(resetAccent)
	ResetPlayer()
end)

-- Keybinds
task.defer(function()
	local lbl = FLASHTP:FindFirstChildOfClass("TextLabel")
	if lbl then
		lbl.Text = "FLASH [" .. keyNames.flash .. "]"
	end
	lbl = BLOCK:FindFirstChildOfClass("TextLabel")
	if lbl then
		lbl.Text = "BLOCK [" .. keyNames.block .. "]"
	end
	lbl = RESET:FindFirstChildOfClass("TextLabel")
	if lbl then
		lbl.Text = "RESET [" .. keyNames.reset .. "]"
	end
end)

local kbConn = UserInputService.InputBegan:Connect(function(inp, gpe)
	if gpe then
		return
	end
	if inp.UserInputType ~= Enum.UserInputType.Keyboard then
		return
	end
	if inp.KeyCode == keybinds.flash then
		if selectedPrompt and selectedSlotNumber and not isStealing and not autoStealEnabled then
			if _G.AntiSwap then
				task.spawn(function()
					pcall(executeTinyAndRocket)
				end)
			end
			startTripToPetSlot(selectedPrompt, selectedSlotNumber)
		end
	elseif inp.KeyCode == keybinds.block then
		blockAllPlayers()
	elseif inp.KeyCode == keybinds.reset then
		ResetPlayer()
	end
end)
table.insert(ActiveConnections, kbConn)

-- Pet list loop
task.spawn(function()
	while task.wait(1.5) do
		if thisScriptStopped then
			break
		end
		updatePetList()
	end
end)
updatePetList()

-- Entry animation
task.spawn(function()
	local target = L.posX
	local startYOffset = target.Y.Offset - 40
	Win.Position = UDim2.new(target.X.Scale, target.X.Offset, target.Y.Scale, startYOffset)
	BorderFrame.Position = Win.Position
	Win.Visible = true
	TweenService
		:Create(Win, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = target })
		:Play()
	local bt = TweenService:Create(
		BorderFrame,
		TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ Position = target }
	)
	bt:Play()
	bt.Completed:Wait()
	RunService.RenderStepped:Connect(syncBorder)
end)

pcall(function()
	clearTpPathVisual()
end)
pcall(function()
	clearSlotMarker()
end)

-- Notificação de carregamento
pcall(function()
	StarterGui:SetCore("SendNotification", {
		Title = "NOX",
		Text = "F12 = Dex Explorer + gethui()",
		Duration = 3,
	})
end)

print("[NOX] Loaded - Red/Black theme | F12 = Dex Explorer + gethui()")

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()