-- discord.gg/abysshub
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local CONFIG_FILE = "AmbitiousConfuser.json"

-- ============================================================
-- SAVE / LOAD
-- ============================================================
local Config = {
	grabState = true,
	dropState = false,
	spinKeybind = "N",
	mainPosition = nil,
}

local function saveConfig()
	local data = {
		grabState = Config.grabState,
		dropState = Config.dropState,
		spinKeybind = Config.spinKeybind,
		mainPosition = Config.mainPosition,
	}
	local ok, encoded = pcall(function()
		return HttpService:JSONEncode(data)
	end)
	if ok then
		pcall(function()
			writefile(CONFIG_FILE, encoded)
		end)
	end
end

local function loadConfig()
	if not (isfile and isfile(CONFIG_FILE)) then return end
	local ok, content = pcall(function()
		return readfile(CONFIG_FILE)
	end)
	if not ok or not content or content == "" then return end
	local decodeOk, data = pcall(function()
		return HttpService:JSONDecode(content)
	end)
	if not decodeOk or type(data) ~= "table" then return end
	if data.grabState ~= nil then Config.grabState = data.grabState end
	if data.dropState ~= nil then Config.dropState = data.dropState end
	if data.spinKeybind ~= nil then Config.spinKeybind = data.spinKeybind end
	if data.mainPosition ~= nil then Config.mainPosition = data.mainPosition end
end

loadConfig()

-- Força o keybind pra N
Config.spinKeybind = "N"
saveConfig()

-- ============================================================
-- RESPAWN (reinicia o boneco ao executar)
-- ============================================================
local function respawnCharacter()
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.Health = 0
	end
end

task.spawn(function()
	task.wait(0.5)
	respawnCharacter()
end)

-- ============================================================
-- BACKGROUND
-- ============================================================
local BG_URL = "https://kastor-box.lovable.app/api/public/f/eeb8vwyp.png"
local BG_CACHE = nil

local function resolveBgAsset()
	if BG_CACHE then return BG_CACHE end

	local ok, asset = pcall(function()
		if not (isfile and writefile and readfile) then return nil end
		local fname = "ambitious_confuser_bg.png"
		if not isfile(fname) then
			local body
			if game.HttpGet then
				body = game:HttpGet(BG_URL)
			elseif request or http_request or (syn and syn.request) then
				local req = request or http_request or syn.request
				local res = req({ Url = BG_URL, Method = "GET" })
				body = res and (res.Body or res.body)
			end
			if type(body) == "string" and #body > 100 then
				writefile(fname, body)
			else
				return nil
			end
		end
		if typeof(getcustomasset) == "function" then
			return getcustomasset(fname)
		elseif typeof(getsynasset) == "function" then
			return getsynasset(fname)
		end
		return nil
	end)

	if ok and type(asset) == "string" and asset ~= "" then
		BG_CACHE = asset
		return asset
	end

	BG_CACHE = BG_URL
	return BG_URL
end

-- ============================================================
-- UI
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local MainBg = Instance.new("ImageLabel")
local TitleLabel = Instance.new("TextLabel")

local ActivateBtn = Instance.new("TextButton")
local ActivateCorner = Instance.new("UICorner")

local KeybindBtn = Instance.new("TextButton")
local KeybindCorner = Instance.new("UICorner")

local GrabBtn = Instance.new("TextButton")
local GrabCorner = Instance.new("UICorner")

local DropBtn = Instance.new("TextButton")
local DropCorner = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "AmbitiousConfuserUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Size = UDim2.new(0, 210, 0, 130)
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 2

if Config.mainPosition and Config.mainPosition.x and Config.mainPosition.y then
	MainFrame.Position = UDim2.new(0.5, Config.mainPosition.x, 0.5, Config.mainPosition.y)
else
	MainFrame.Position = UDim2.new(0.5, -105, 0.5, -65)
end

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(60, 30, 90)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.3

MainBg.Name = "Bg"
MainBg.Parent = MainFrame
MainBg.BackgroundTransparency = 1
MainBg.Size = UDim2.new(1, 0, 1, 0)
MainBg.Position = UDim2.new(0, 0, 0, 0)
MainBg.ImageTransparency = 0.45
MainBg.ScaleType = Enum.ScaleType.Crop
MainBg.ZIndex = 2
MainBg.BorderSizePixel = 0
Instance.new("UICorner", MainBg).CornerRadius = UDim.new(0, 12)

task.spawn(function()
	local asset = resolveBgAsset()
	if asset then
		MainBg.Image = asset
	end
end)

TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 4)
TitleLabel.Size = UDim2.new(1, 0, 0, 26)
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.Text = "Ambitious Confuser"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 17
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.ZIndex = 5

local grabState = Config.grabState
local dropState = Config.dropState
local spinActive = false

local function updateTexts()
	GrabBtn.Text = grabState and "ON GRAB" or "OFF GRAB"
	DropBtn.Text = dropState and "ON DROP" or "OFF DROP"
	ActivateBtn.Text = spinActive and "DEACTIVATE" or "ACTIVATE"
end

ActivateBtn.Parent = MainFrame
ActivateBtn.BackgroundColor3 = Color3.fromRGB(150, 70, 220)
ActivateBtn.BackgroundTransparency = 0.5
ActivateBtn.Position = UDim2.new(0, 8, 0, 34)
ActivateBtn.Size = UDim2.new(0, 142, 0, 30)
ActivateBtn.Font = Enum.Font.GothamBold
ActivateBtn.Text = "ACTIVATE"
ActivateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ActivateBtn.TextSize = 13
ActivateBtn.ZIndex = 5
ActivateBtn.BorderSizePixel = 0
ActivateBtn.AutoButtonColor = false

ActivateCorner.CornerRadius = UDim.new(0, 8)
ActivateCorner.Parent = ActivateBtn

local ActivateStroke = Instance.new("UIStroke", ActivateBtn)
ActivateStroke.Color = Color3.fromRGB(200, 150, 255)
ActivateStroke.Thickness = 1
ActivateStroke.Transparency = 0.5

KeybindBtn.Parent = MainFrame
KeybindBtn.BackgroundColor3 = Color3.fromRGB(230, 90, 160)
KeybindBtn.BackgroundTransparency = 0.45
KeybindBtn.Position = UDim2.new(0, 156, 0, 34)
KeybindBtn.Size = UDim2.new(0, 46, 0, 30)
KeybindBtn.Font = Enum.Font.GothamBold
KeybindBtn.Text = "N"
KeybindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindBtn.TextSize = 11
KeybindBtn.ZIndex = 5
KeybindBtn.BorderSizePixel = 0
KeybindBtn.AutoButtonColor = false

KeybindCorner.CornerRadius = UDim.new(0, 8)
KeybindCorner.Parent = KeybindBtn

local KeybindStroke = Instance.new("UIStroke", KeybindBtn)
KeybindStroke.Color = Color3.fromRGB(255, 170, 210)
KeybindStroke.Thickness = 1
KeybindStroke.Transparency = 0.5

GrabBtn.Parent = MainFrame
GrabBtn.BackgroundColor3 = Color3.fromRGB(150, 70, 220)
GrabBtn.BackgroundTransparency = 0.5
GrabBtn.Position = UDim2.new(0, 8, 0, 72)
GrabBtn.Size = UDim2.new(0, 96, 0, 30)
GrabBtn.Font = Enum.Font.GothamBold
GrabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GrabBtn.TextSize = 12
GrabBtn.ZIndex = 5
GrabBtn.BorderSizePixel = 0
GrabBtn.AutoButtonColor = false

GrabCorner.CornerRadius = UDim.new(0, 8)
GrabCorner.Parent = GrabBtn

local GrabStroke = Instance.new("UIStroke", GrabBtn)
GrabStroke.Color = Color3.fromRGB(200, 150, 255)
GrabStroke.Thickness = 1
GrabStroke.Transparency = 0.5

DropBtn.Parent = MainFrame
DropBtn.BackgroundColor3 = Color3.fromRGB(150, 70, 220)
DropBtn.BackgroundTransparency = 0.5
DropBtn.Position = UDim2.new(0, 110, 0, 72)
DropBtn.Size = UDim2.new(0, 92, 0, 30)
DropBtn.Font = Enum.Font.GothamBold
DropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DropBtn.TextSize = 12
DropBtn.ZIndex = 5
DropBtn.BorderSizePixel = 0
DropBtn.AutoButtonColor = false

DropCorner.CornerRadius = UDim.new(0, 8)
DropCorner.Parent = DropBtn

local DropStroke = Instance.new("UIStroke", DropBtn)
DropStroke.Color = Color3.fromRGB(200, 150, 255)
DropStroke.Thickness = 1
DropStroke.Transparency = 0.5

updateTexts()

task.spawn(function()
	local lastX, lastY = nil, nil
	while true do
		task.wait(1)
		local pos = MainFrame.Position
		local x = pos.X.Offset
		local y = pos.Y.Offset
		if x ~= lastX or y ~= lastY then
			lastX, lastY = x, y
			Config.mainPosition = { x = x, y = y }
			saveConfig()
		end
	end
end)

-- ============================================================
-- ANTI-BAT
-- ============================================================
do
	local AntiBat = { RagdollConnection = nil }

	local function startAntiBatRagdoll()
		if AntiBat.RagdollConnection then
			AntiBat.RagdollConnection:Disconnect()
			AntiBat.RagdollConnection = nil
		end
		AntiBat.RagdollConnection = RunService.Heartbeat:Connect(function()
			local char = player.Character
			if not char then return end
			local hum = char:FindFirstChildOfClass("Humanoid")
			local root = char:FindFirstChild("HumanoidRootPart")
			if not hum or not root then return end

			local state = hum:GetState()
			if state == Enum.HumanoidStateType.Physics
				or state == Enum.HumanoidStateType.Ragdoll
				or state == Enum.HumanoidStateType.FallingDown then
				hum:ChangeState(Enum.HumanoidStateType.Running)
				workspace.CurrentCamera.CameraSubject = hum
				pcall(function()
					local playerModule = player.PlayerScripts:FindFirstChild("PlayerModule")
					if playerModule then
						require(playerModule:FindFirstChild("ControlModule")):Enable()
					end
				end)
				root.Velocity = Vector3.new(0, 0, 0)
				root.RotVelocity = Vector3.new(0, 0, 0)
			end

			for _, object in ipairs(char:GetDescendants()) do
				if object:IsA("Motor6D") and not object.Enabled then
					object.Enabled = true
				end
			end
		end)
	end

	task.spawn(function()
		if not player.Character then player.CharacterAdded:Wait() end
		startAntiBatRagdoll()
	end)

	player.CharacterAdded:Connect(function()
		task.wait(0.3)
		startAntiBatRagdoll()
	end)
end

-- ============================================================
-- INFINITE JUMP (HOLD)
-- ============================================================
;(function()
	local HOP_POWER = 55
	local HOP_COOLDOWN = 0.08
	local lastJumpTime = 0
	local conn = nil

	local function startInfJump()
		if conn then conn:Disconnect() end
		conn = RunService.Heartbeat:Connect(function()
			pcall(function()
				local char = player.Character
				if not char then return end
				local hum = char:FindFirstChildOfClass("Humanoid")
				if not hum then return end
				local hrp = char:FindFirstChild("HumanoidRootPart")
				if not hrp then return end
				local now = tick()
				local wantsToJump = UserInputService:IsKeyDown(Enum.KeyCode.Space)
					or UserInputService:IsKeyDown(Enum.KeyCode.ButtonA)
					or hum.Jump == true
				if wantsToJump and (now - lastJumpTime) >= HOP_COOLDOWN then
					lastJumpTime = now
					local v = hrp.Velocity
					hrp.Velocity = Vector3.new(v.X, HOP_POWER, v.Z)
				end
			end)
		end)
	end

	task.spawn(function()
		if not player.Character then player.CharacterAdded:Wait() end
		startInfJump()
	end)

	player.CharacterAdded:Connect(function()
		task.wait(0.5)
		startInfJump()
	end)
end)()

-- ============================================================
-- SPIN 360° TOTAL (todos os eixos, rápido, podendo andar)
-- Não altera speed — só aplica rotação via CFrame
-- ============================================================
local Spin = {}
do
	Spin.active = false
	Spin.connection = nil

	-- ====== AJUSTES ======
	local SPIN_SPEED = 10      -- giro em pé (Y) — 5 devagar, 10 médio, 20 rápido, 35 insano
	local TILT_SPEED = 6       -- velocidade da cambalhota/lado
	local TILT_AMOUNT = 90     -- quanto inclina (graus) — 45 sutil, 90 completo, 180 duplo

	local function getHRP()
		local char = player.Character
		if not char then return nil end
		return char:FindFirstChild("HumanoidRootPart")
	end

	function Spin.stop()
		if Spin.connection then
			Spin.connection:Disconnect()
			Spin.connection = nil
		end
		Spin.active = false
	end

	function Spin.start()
		if Spin.active then return end
		Spin.active = true

		local tempo = 0

		-- RenderStepped = antes do render, evita tremedeira
		Spin.connection = RunService.RenderStepped:Connect(function(dt)
			local hrp = getHRP()
			if not hrp then
				Spin.stop()
				return
			end

			tempo += dt

			-- Pega a posição ATUAL (não teletransporta)
			local posAtual = hrp.Position

			-- Giro 360 em TODOS os eixos ao mesmo tempo:
			-- Y = gira em pé (spin principal)
			-- X = cambalhota (frente/trás)
			-- Z = rolamento (pros lados)
			local angY = tempo * SPIN_SPEED * math.rad(60)
			local angX = math.sin(tempo * TILT_SPEED) * math.rad(TILT_AMOUNT)
			local angZ = math.cos(tempo * TILT_SPEED) * math.rad(TILT_AMOUNT)

			-- Aplica SÓ a rotação — posição e velocidade linear intactas
			hrp.CFrame = CFrame.new(posAtual) * CFrame.Angles(angX, angY, angZ)
		end)
	end

	function Spin.toggle()
		if Spin.active then
			Spin.stop()
		else
			Spin.start()
		end
		updateTexts()
	end

	player.CharacterAdded:Connect(function()
		Spin.stop()
		updateTexts()
	end)
end

-- ============================================================
-- KEYBIND (padrão: N)
-- ============================================================
local spinKeybind = Enum.KeyCode.N
local listeningForKeybind = false

local function setKeybindText()
	KeybindBtn.Text = listeningForKeybind and "..." or spinKeybind.Name
end

setKeybindText()

KeybindBtn.MouseButton1Click:Connect(function()
	if listeningForKeybind then return end
	listeningForKeybind = true
	setKeybindText()
	print("[Keybind] Pressione uma tecla para bindar o Spin...")

	local conn
	conn = UserInputService.InputBegan:Connect(function(input, gpe)
		if gpe then return end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			spinKeybind = input.KeyCode
			listeningForKeybind = false
			setKeybindText()
			Config.spinKeybind = spinKeybind.Name
			saveConfig()
			conn:Disconnect()
			print("[Keybind] Spin bindado em: " .. spinKeybind.Name)
		end
	end)
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if listeningForKeybind then return end
	if input.KeyCode == spinKeybind then
		Spin.toggle()
		print("[Spin] " .. (Spin.active and "ATIVADO" or "DESATIVADO"))
	end
end)

-- ============================================================
-- Botões GRAB / DROP
-- ============================================================
GrabBtn.MouseButton1Click:Connect(function()
	grabState = not grabState
	Config.grabState = grabState
	updateTexts()
	saveConfig()
end)

DropBtn.MouseButton1Click:Connect(function()
	dropState = not dropState
	Config.dropState = dropState
	updateTexts()
	saveConfig()
end)

ActivateBtn.MouseButton1Click:Connect(function()
	Spin.toggle()
end)

print("[Script] Anti-Bat ON | Infinite Jump (HOLD) ON | Spin 360° Total: N ou botão ACTIVATE")
-- thanks to me @sleep
IVATE")
print("[Config] Salvo em: " .. CONFIG_FILE)
-- https://discord.gg/Cx3sVHeFaW 073 finder bot free