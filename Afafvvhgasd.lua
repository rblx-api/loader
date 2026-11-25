if _G.__PacketLagger and _G.__PacketLagger.Destroy then
    pcall(_G.__PacketLagger.Destroy)
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local MIN_V, MAX_V = 1000, 200000
local NET_INDEX = 6
local DEFAULT_VALUE = 22000

-- Keybinds por defecto
local DEFAULT_KB_PC      = Enum.KeyCode.F6
local DEFAULT_KB_GAMEPAD = Enum.KeyCode.DPadDown

local function getRemote()
    local pk = ReplicatedStorage:FindFirstChild("Packages") or ReplicatedStorage:WaitForChild("Packages", 10)
    if not pk then return nil end
    local net = pk:FindFirstChild("Net") or pk:WaitForChild("Net", 10)
    if not net then return nil end
    local child = net:GetChildren()[NET_INDEX]
    if child and child:IsA("BaseRemoteEvent") then
        return child
    end
    return nil
end

local CFG_PATH = "MVPHubPacket_cfg.json"

local function readCfg()
    local ok, raw = pcall(function()
        if isfile and isfile(CFG_PATH) then
            return readfile(CFG_PATH)
        end
        return nil
    end)
    if ok and type(raw) == "string" and raw ~= "" then
        local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
        if ok2 and type(data) == "table" then return data end
    end
    return {}
end

local function saveCfg(key, val)
    local data = readCfg()
    data[key] = val
    local ok, encoded = pcall(function() return HttpService:JSONEncode(data) end)
    if ok and writefile then
        pcall(writefile, CFG_PATH, encoded)
    end
end

local cfg = readCfg()
local initValue = math.clamp(tonumber(cfg.value) or DEFAULT_VALUE, MIN_V, MAX_V)
local initPos = UDim2.new(0.5, -110, 0.4, 0)
if type(cfg.pos) == "table" and #cfg.pos == 4 then
    initPos = UDim2.new(cfg.pos[1], cfg.pos[2], cfg.pos[3], cfg.pos[4])
end
local isLocked = cfg.locked == true

-- Cargar keybinds guardadas (o usar defaults)
local function loadKeyCode(name, default)
    local saved = cfg[name]
    if saved and Enum.KeyCode[saved] then
        return Enum.KeyCode[saved]
    end
    return default
end
local KB_PC      = loadKeyCode("kb_pc",      DEFAULT_KB_PC)
local KB_GAMEPAD = loadKeyCode("kb_gamepad", DEFAULT_KB_GAMEPAD)

-- Paleta
local C = {
    bg         = Color3.fromRGB(13, 30, 15),
    bgTop      = Color3.fromRGB(18, 22, 10),
    row        = Color3.fromRGB(25, 55, 28),
    stroke     = Color3.fromRGB(180, 30, 30),
    strokeGold = Color3.fromRGB(210, 170, 50),
    text       = Color3.fromRGB(255, 245, 220),
    dim        = Color3.fromRGB(160, 190, 160),
    on         = Color3.fromRGB(220, 40, 40),
    onText     = Color3.fromRGB(255, 230, 200),
    btnOff     = Color3.fromRGB(30, 70, 35),
    listening  = Color3.fromRGB(180, 130, 0),
    panelBg    = Color3.fromRGB(16, 38, 18),
}

local function New(class, props)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    return o
end

local function corner(o, r)
    return New("UICorner", { CornerRadius = UDim.new(0, r), Parent = o })
end

local function guiParent()
    local ok, h = pcall(function() return gethui and gethui() end)
    if ok and h then return h end
    local ok2 = pcall(function() return CoreGui.Name end)
    if ok2 then return CoreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- ═══════════════════════════════════════════════════════════════
-- GUI PRINCIPAL
-- ═══════════════════════════════════════════════════════════════
local gui = New("ScreenGui", {
    Name = "MVPHubPacket",
    ResetOnSpawn = false,
    DisplayOrder = 2147483000,
    IgnoreGuiInset = true,
})

-- Contenedor principal (se mueve)
local main = New("Frame", {
    Position = initPos,
    Size = UDim2.fromOffset(240, 0), -- altura dinámica
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Active = true,
    Parent = gui,
})

-- ── Ventana del menú (power) ──────────────────────────────────
local win = New("Frame", {
    Position = UDim2.fromOffset(0, 0),
    Size = UDim2.fromOffset(240, 130),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = main,
})
corner(win, 12)
New("UIStroke", { Color = C.strokeGold, Thickness = 2, Parent = win })

local innerBorder = New("Frame", {
    Size = UDim2.new(1, -4, 1, -4),
    Position = UDim2.fromOffset(2, 2),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Parent = win,
})
New("UIStroke", { Color = C.stroke, Thickness = 1, Parent = innerBorder })
corner(innerBorder, 11)

-- Cabecera
local head = New("Frame", {
    Size = UDim2.new(1, 0, 0, 38),
    BackgroundColor3 = Color3.fromRGB(10, 45, 12),
    BorderSizePixel = 0,
    Parent = win,
})
corner(head, 12)
New("Frame", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = Color3.fromRGB(10, 45, 12),
    BorderSizePixel = 0,
    Parent = head,
})

New("TextLabel", {
    BackgroundTransparency = 1,
    Text = "❄️  MVP HUB  ❄️",
    TextSize = 12,
    TextColor3 = C.strokeGold,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.new(1, -90, 1, 0),
    Parent = head,
})

-- ── Candado (bloquear movimiento) ─────────────────────────────
local btnLock = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -42, 0.5, 0),
    Size = UDim2.fromOffset(28, 24),
    AutoButtonColor = false,
    Text = isLocked and "🔒" or "🔓",
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(8, 22, 10),
    BorderSizePixel = 0,
    Parent = head,
})
corner(btnLock, 6)
New("UIStroke", { Color = C.strokeGold, Thickness = 1, Parent = btnLock })

-- ── Tuerca (abrir configuración) ──────────────────────────────
local btnGear = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -10, 0.5, 0),
    Size = UDim2.fromOffset(28, 24),
    AutoButtonColor = false,
    Text = "⚙️",
    TextSize = 14,
    BackgroundColor3 = Color3.fromRGB(8, 22, 10),
    BorderSizePixel = 0,
    Parent = head,
})
corner(btnGear, 6)
New("UIStroke", { Color = C.strokeGold, Thickness = 1, Parent = btnGear })

-- Separador dorado
New("Frame", {
    Position = UDim2.new(0, 12, 0, 38),
    Size = UDim2.new(1, -24, 0, 1),
    BackgroundColor3 = C.strokeGold,
    BorderSizePixel = 0,
    Parent = win,
})

-- ── Contenedor del botón Power (rectángulo con esquinas curvas) ─
local powerBox = New("Frame", {
    Position = UDim2.fromOffset(14, 50),
    Size = UDim2.new(1, -28, 0, 64),
    BackgroundColor3 = Color3.fromRGB(18, 42, 20),
    BorderSizePixel = 0,
    Parent = win,
})
corner(powerBox, 12)
New("UIStroke", { Color = Color3.fromRGB(60, 120, 65), Thickness = 1.5, Parent = powerBox })

local on = false
local btn = New("TextButton", {
    Position = UDim2.fromOffset(8, 8),
    Size = UDim2.new(1, -16, 1, -16),
    AutoButtonColor = false,
    Text = "🔴  POWER OFF",
    TextSize = 13,
    TextColor3 = C.text,
    Font = Enum.Font.GothamBold,
    BackgroundColor3 = C.btnOff,
    BorderSizePixel = 0,
    Parent = powerBox,
})
corner(btn, 10)
local btnStroke = New("UIStroke", { Color = Color3.fromRGB(50, 120, 55), Thickness = 1.5, Parent = btn })

-- ═══════════════════════════════════════════════════════════════
-- PANEL DE CONFIGURACIÓN (se desliza desde abajo)
-- ═══════════════════════════════════════════════════════════════
local SETTINGS_HEIGHT = 168
local settingsOpen = false

local settings = New("Frame", {
    Position = UDim2.fromOffset(0, 130), -- empieza justo debajo del menú
    Size = UDim2.fromOffset(240, 0),     -- altura 0 al inicio
    BackgroundColor3 = C.panelBg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = main,
})
corner(settings, 12)
New("UIStroke", { Color = C.strokeGold, Thickness = 2, Parent = settings })

local settingsInner = New("Frame", {
    Size = UDim2.new(1, -4, 1, -4),
    Position = UDim2.fromOffset(2, 2),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Parent = settings,
})
New("UIStroke", { Color = C.stroke, Thickness = 1, Parent = settingsInner })
corner(settingsInner, 11)

-- Título del panel
New("TextLabel", {
    BackgroundTransparency = 1,
    Text = "⚙️  Configuración",
    TextSize = 11,
    TextColor3 = C.strokeGold,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(12, 8),
    Size = UDim2.new(1, -24, 0, 18),
    Parent = settings,
})

-- Fila del valor
local boxRow = New("Frame", {
    Position = UDim2.fromOffset(10, 32),
    Size = UDim2.new(1, -20, 0, 28),
    BackgroundColor3 = C.row,
    BorderSizePixel = 0,
    Parent = settings,
})
corner(boxRow, 7)
New("UIStroke", { Color = Color3.fromRGB(50, 110, 55), Thickness = 1, Parent = boxRow })
New("TextLabel", {
    BackgroundTransparency = 1,
    Text = "🎁 Value",
    TextSize = 10,
    TextColor3 = C.text,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(10, 0),
    Size = UDim2.new(0.42, 0, 1, 0),
    Parent = boxRow,
})
local boxWrap = New("Frame", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -6, 0.5, 0),
    Size = UDim2.new(0.52, 0, 0, 18),
    BackgroundColor3 = Color3.fromRGB(8, 22, 10),
    BorderSizePixel = 0,
    Parent = boxRow,
})
corner(boxWrap, 5)
New("UIStroke", { Color = C.strokeGold, Thickness = 1, Parent = boxWrap })
local box = New("TextBox", {
    Size = UDim2.new(1, -10, 1, 0),
    Position = UDim2.fromOffset(5, 0),
    BackgroundTransparency = 1,
    Text = tostring(initValue),
    PlaceholderText = MIN_V .. " - " .. MAX_V,
    PlaceholderColor3 = C.dim,
    TextColor3 = C.strokeGold,
    Font = Enum.Font.Code,
    TextSize = 10,
    ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Center,
    Parent = boxWrap,
})

-- Fila keybind PC
local rowPC = New("Frame", {
    Position = UDim2.fromOffset(10, 68),
    Size = UDim2.new(1, -20, 0, 26),
    BackgroundColor3 = C.row,
    BorderSizePixel = 0,
    Parent = settings,
})
corner(rowPC, 6)
New("UIStroke", { Color = Color3.fromRGB(50, 110, 55), Thickness = 1, Parent = rowPC })
New("TextLabel", {
    BackgroundTransparency = 1,
    Text = "⌨ PC",
    TextSize = 9,
    TextColor3 = C.text,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(8, 0),
    Size = UDim2.new(0.35, 0, 1, 0),
    Parent = rowPC,
})
local btnPC = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -5, 0.5, 0),
    Size = UDim2.new(0.6, 0, 0, 18),
    AutoButtonColor = false,
    Text = KB_PC.Name,
    TextSize = 9,
    TextColor3 = C.strokeGold,
    Font = Enum.Font.Code,
    BackgroundColor3 = Color3.fromRGB(8, 22, 10),
    BorderSizePixel = 0,
    Parent = rowPC,
})
corner(btnPC, 4)
New("UIStroke", { Color = C.strokeGold, Thickness = 1, Parent = btnPC })

-- Fila keybind Gamepad
local rowGP = New("Frame", {
    Position = UDim2.fromOffset(10, 100),
    Size = UDim2.new(1, -20, 0, 26),
    BackgroundColor3 = C.row,
    BorderSizePixel = 0,
    Parent = settings,
})
corner(rowGP, 6)
New("UIStroke", { Color = Color3.fromRGB(50, 110, 55), Thickness = 1, Parent = rowGP })
New("TextLabel", {
    BackgroundTransparency = 1,
    Text = "🎮 Pad",
    TextSize = 9,
    TextColor3 = C.text,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(8, 0),
    Size = UDim2.new(0.35, 0, 1, 0),
    Parent = rowGP,
})
local btnGP = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -5, 0.5, 0),
    Size = UDim2.new(0.6, 0, 0, 18),
    AutoButtonColor = false,
    Text = KB_GAMEPAD.Name,
    TextSize = 9,
    TextColor3 = C.strokeGold,
    Font = Enum.Font.Code,
    BackgroundColor3 = Color3.fromRGB(8, 22, 10),
    BorderSizePixel = 0,
    Parent = rowGP,
})
corner(btnGP, 4)
New("UIStroke", { Color = C.strokeGold, Thickness = 1, Parent = btnGP })

-- Hint
New("TextLabel", {
    BackgroundTransparency = 1,
    Text = "Presiona Escape para cancelar",
    TextSize = 8,
    TextColor3 = C.dim,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Center,
    Position = UDim2.fromOffset(0, 136),
    Size = UDim2.new(1, 0, 0, 16),
    Parent = settings,
})

-- ═══════════════════════════════════════════════════════════════
-- LÓGICA PRINCIPAL
-- ═══════════════════════════════════════════════════════════════
local Packet = { value = initValue, remote = nil }
_G.__PacketLagger = Packet
local alive = true
local fireserving = false
local fireThread = nil

local function stopFireServer()
    if not fireserving then return end
    fireserving = false
    if fireThread then pcall(task.cancel, fireThread); fireThread = nil end
end

local function startFireServer()
    if fireserving then return end
    local remote = Packet.remote
    if not remote then return end
    fireserving = true
    local payload = table.create(Packet.value, function() end)
    fireThread = task.spawn(function()
        while fireserving and alive do
            for _ = 1, 3 do pcall(function() remote:FireServer(payload) end) end
            task.wait(0.01)
        end
    end)
end

local function readValue()
    local n = tonumber((box.Text:gsub("[^%d]", "")))
    n = math.clamp(math.floor(n or Packet.value or DEFAULT_VALUE), MIN_V, MAX_V)
    box.Text = tostring(n)
    Packet.value = n
    return n
end

box.FocusLost:Connect(function()
    readValue()
    saveCfg("value", Packet.value)
end)

local function paint()
    if on then
        btn.BackgroundColor3 = C.on
        btn.Text = "🟢  POWER ON"
        btn.TextColor3 = Color3.fromRGB(255, 230, 200)
        if btnStroke then btnStroke.Color = Color3.fromRGB(255, 80, 80) end
        powerBox.BackgroundColor3 = Color3.fromRGB(45, 20, 20)
    else
        btn.BackgroundColor3 = C.btnOff
        btn.Text = "🔴  POWER OFF"
        btn.TextColor3 = C.text
        if btnStroke then btnStroke.Color = Color3.fromRGB(50, 120, 55) end
        powerBox.BackgroundColor3 = Color3.fromRGB(18, 42, 20)
    end
end

local function setOn(v)
    on = v and true or false
    if on then
        readValue()
        if not Packet.remote then Packet.remote = getRemote() end
        if not alive then return end
        if Packet.remote then
            startFireServer()
        else
            on = false
        end
    else
        stopFireServer()
    end
    paint()
end

btn.Activated:Connect(function()
    setOn(not on)
end)

-- ── Animación del panel de configuración ──────────────────────
local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function toggleSettings()
    settingsOpen = not settingsOpen
    if settingsOpen then
        -- Abrir: expandir altura y mover el panel
        TweenService:Create(settings, tweenInfo, {
            Size = UDim2.fromOffset(240, SETTINGS_HEIGHT)
        }):Play()
        btnGear.BackgroundColor3 = Color3.fromRGB(40, 80, 30)
    else
        -- Cerrar
        TweenService:Create(settings, tweenInfo, {
            Size = UDim2.fromOffset(240, 0)
        }):Play()
        btnGear.BackgroundColor3 = Color3.fromRGB(8, 22, 10)
        -- Cerrar también el listener de keybind si estaba abierto
        if listeningFor then
            stopListening()
        end
    end
end

btnGear.Activated:Connect(toggleSettings)

-- ── Candado (bloquear / desbloquear movimiento) ───────────────
local function updateLockVisual()
    btnLock.Text = isLocked and "🔒" or "🔓"
    btnLock.BackgroundColor3 = isLocked and Color3.fromRGB(60, 25, 25) or Color3.fromRGB(8, 22, 10)
end
updateLockVisual()

btnLock.Activated:Connect(function()
    isLocked = not isLocked
    saveCfg("locked", isLocked)
    updateLockVisual()
end)

-- ── Selector de keybind ───────────────────────────────────────
local IGNORED_KEYS = {
    [Enum.KeyCode.Unknown] = true,
    [Enum.KeyCode.Return]  = true,
    [Enum.KeyCode.Escape]  = true,
}

local listeningFor = nil
local listenConn   = nil

local function stopListening()
    listeningFor = nil
    if listenConn then
        listenConn:Disconnect()
        listenConn = nil
    end
    btnPC.Text = KB_PC.Name
    btnGP.Text = KB_GAMEPAD.Name
    btnPC.BackgroundColor3 = Color3.fromRGB(8, 22, 10)
    btnGP.BackgroundColor3 = Color3.fromRGB(8, 22, 10)
    btnPC.TextColor3 = C.strokeGold
    btnGP.TextColor3 = C.strokeGold
end

local function startListening(which)
    if listeningFor == which then
        stopListening()
        return
    end
    stopListening()
    listeningFor = which

    local activeBtn = which == "pc" and btnPC or btnGP
    activeBtn.Text = "..."
    activeBtn.BackgroundColor3 = C.listening
    activeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    listenConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.Escape then
            stopListening()
            return
        end
        if input.KeyCode == Enum.KeyCode.Unknown then return end
        if which == "pc" then
            KB_PC = input.KeyCode
            saveCfg("kb_pc", tostring(KB_PC.Name))
        else
            KB_GAMEPAD = input.KeyCode
            saveCfg("kb_gamepad", tostring(KB_GAMEPAD.Name))
        end
        stopListening()
    end)
end

btnPC.Activated:Connect(function() startListening("pc") end)
btnGP.Activated:Connect(function() startListening("gamepad") end)

-- ── Keybind toggle ────────────────────────────────────────────
local kbCooldown = false
local function onToggleKeybind()
    if kbCooldown then return end
    kbCooldown = true
    setOn(not on)
    task.delay(0.3, function() kbCooldown = false end)
end

local globalConns = {}

globalConns[#globalConns + 1] = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if listeningFor then return end
    if gameProcessed then return end
    if input.KeyCode == KB_PC or input.KeyCode == KB_GAMEPAD then
        onToggleKeybind()
    end
end)

-- ── Arrastrar ventana (solo si no está bloqueada) ─────────────
do
    local dragging, startPos, startMouse
    head.InputBegan:Connect(function(i)
        if isLocked then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = main.Position
            startMouse = i.Position
        end
    end)
    globalConns[#globalConns + 1] = UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - startMouse
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
    globalConns[#globalConns + 1] = UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                saveCfg("pos", {
                    main.Position.X.Scale, main.Position.X.Offset,
                    main.Position.Y.Scale, main.Position.Y.Offset
                })
            end
            dragging = false
        end
    end)
end

task.spawn(function()
    local r = getRemote()
    if alive and r then Packet.remote = r end
end)

function Packet.Destroy()
    alive = false
    stopFireServer()
    stopListening()
    for _, c in ipairs(globalConns) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(globalConns)
    pcall(function() gui:Destroy() end)
    if _G.__PacketLagger == Packet then
        _G.__PacketLagger = nil
    end
end

gui.Parent = guiParent()