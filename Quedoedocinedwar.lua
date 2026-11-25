if _G.__PacketLagger and _G.__PacketLagger.Destroy then
    pcall(_G.__PacketLagger.Destroy)
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local MIN_V, MAX_V = 1000, 200000
local NET_INDEX = 6
local DEFAULT_VALUE = 22000

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

local CFG_PATH = "KyronPacket_cfg.json"

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
local initPos = UDim2.new(0.5, -20, 0.45, 0)
if type(cfg.pos) == "table" and #cfg.pos == 4 then
    initPos = UDim2.new(cfg.pos[1], cfg.pos[2], cfg.pos[3], cfg.pos[4])
end

local function loadKeyCode(name, default)
    local saved = cfg[name]
    if saved and Enum.KeyCode[saved] then
        return Enum.KeyCode[saved]
    end
    return default
end
local KB_PC      = loadKeyCode("kb_pc",      DEFAULT_KB_PC)
local KB_GAMEPAD = loadKeyCode("kb_gamepad", DEFAULT_KB_GAMEPAD)

-- ── Paleta negro brillante + gris / blanco ──────────────────────────────────
local C = {
    bg         = Color3.fromRGB(8, 8, 10),
    bgPanel    = Color3.fromRGB(14, 14, 17),
    row        = Color3.fromRGB(20, 20, 24),
    stroke     = Color3.fromRGB(55, 55, 62),
    accent     = Color3.fromRGB(230, 230, 235),
    text       = Color3.fromRGB(245, 245, 250),
    dim        = Color3.fromRGB(130, 130, 140),
    on         = Color3.fromRGB(35, 170, 95),
    onText     = Color3.fromRGB(240, 255, 245),
    btnOff     = Color3.fromRGB(22, 22, 26),
    listening  = Color3.fromRGB(60, 60, 70),
    shadow     = Color3.fromRGB(0, 0, 0),
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

-- GUI
local gui = New("ScreenGui", {
    Name = "KyronPacketLagger",
    ResetOnSpawn = false,
    DisplayOrder = 2147483000,
    IgnoreGuiInset = true,
})

-- Contenedor principal (arrastrable)
local main = New("Frame", {
    Position = initPos,
    Size = UDim2.fromOffset(46, 46),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Active = true,
    Parent = gui,
})

-- Sombra de la tuerquita
local gearShadow = New("Frame", {
    Size = UDim2.fromOffset(46, 46),
    Position = UDim2.fromOffset(2, 3),
    BackgroundColor3 = C.shadow,
    BackgroundTransparency = 0.55,
    BorderSizePixel = 0,
    Parent = main,
})
corner(gearShadow, 12)

-- Botón de la tuerquita (estado cerrado = solo esto)
local gearBtn = New("TextButton", {
    Size = UDim2.fromOffset(46, 46),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    Text = "⚙️",
    TextSize = 20,
    AutoButtonColor = false,
    Parent = main,
})
corner(gearBtn, 12)
New("UIStroke", {
    Color = C.stroke,
    Thickness = 1.5,
    Parent = gearBtn,
})

-- Panel expandido (oculto al inicio)
local panel = New("Frame", {
    Position = UDim2.fromOffset(0, 54),
    Size = UDim2.fromOffset(240, 230),
    BackgroundColor3 = C.bgPanel,
    BorderSizePixel = 0,
    Visible = false,
    Parent = main,
})
corner(panel, 10)

-- Sombra del panel
local panelShadow = New("Frame", {
    Size = UDim2.new(1, 6, 1, 6),
    Position = UDim2.fromOffset(-3, 2),
    BackgroundColor3 = C.shadow,
    BackgroundTransparency = 0.6,
    BorderSizePixel = 0,
    ZIndex = 0,
    Parent = panel,
})
corner(panelShadow, 12)

New("UIStroke", {
    Color = C.stroke,
    Thickness = 1.5,
    Parent = panel,
})

-- Header del panel
local head = New("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Color3.fromRGB(10, 10, 12),
    BorderSizePixel = 0,
    Parent = panel,
})
corner(head, 10)
New("Frame", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = Color3.fromRGB(10, 10, 12),
    BorderSizePixel = 0,
    Parent = head,
})

New("TextLabel", {
    BackgroundTransparency = 1,
    Text = "KYRON PACKET LAGGER",
    TextSize = 12,
    TextColor3 = C.accent,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Center,
    Size = UDim2.new(1, 0, 1, 0),
    Parent = head,
})

-- Línea
New("Frame", {
    Position = UDim2.new(0, 12, 0, 40),
    Size = UDim2.new(1, -24, 0, 1),
    BackgroundColor3 = C.stroke,
    BorderSizePixel = 0,
    Parent = panel,
})

-- POWER (value)
local boxRow = New("Frame", {
    Position = UDim2.fromOffset(12, 50),
    Size = UDim2.new(1, -24, 0, 32),
    BackgroundColor3 = C.row,
    BorderSizePixel = 0,
    Parent = panel,
})
corner(boxRow, 6)
New("UIStroke", { Color = C.stroke, Thickness = 1, Parent = boxRow })

New("TextLabel", {
    BackgroundTransparency = 1,
    Text = "POWER",
    TextSize = 10,
    TextColor3 = C.dim,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.new(0.4, 0, 1, 0),
    Parent = boxRow,
})

local boxWrap = New("Frame", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -8, 0.5, 0),
    Size = UDim2.new(0.52, 0, 0, 22),
    BackgroundColor3 = Color3.fromRGB(6, 6, 8),
    BorderSizePixel = 0,
    Parent = boxRow,
})
corner(boxWrap, 5)
New("UIStroke", { Color = C.stroke, Thickness = 1, Parent = boxWrap })

local box = New("TextBox", {
    Size = UDim2.new(1, -10, 1, 0),
    Position = UDim2.fromOffset(5, 0),
    BackgroundTransparency = 1,
    Text = tostring(initValue),
    PlaceholderText = MIN_V .. " - " .. MAX_V,
    PlaceholderColor3 = C.dim,
    TextColor3 = C.accent,
    Font = Enum.Font.Code,
    TextSize = 11,
    ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Center,
    Parent = boxWrap,
})

-- PC keybind
local rowPC = New("Frame", {
    Position = UDim2.fromOffset(12, 90),
    Size = UDim2.new(1, -24, 0, 28),
    BackgroundColor3 = C.row,
    BorderSizePixel = 0,
    Parent = panel,
})
corner(rowPC, 6)
New("UIStroke", { Color = C.stroke, Thickness = 1, Parent = rowPC })

New("TextLabel", {
    BackgroundTransparency = 1,
    Text = "PC",
    TextSize = 10,
    TextColor3 = C.dim,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.new(0.3, 0, 1, 0),
    Parent = rowPC,
})

local btnPC = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -6, 0.5, 0),
    Size = UDim2.new(0.55, 0, 0, 20),
    AutoButtonColor = false,
    Text = KB_PC.Name,
    TextSize = 10,
    TextColor3 = C.accent,
    Font = Enum.Font.Code,
    BackgroundColor3 = Color3.fromRGB(6, 6, 8),
    BorderSizePixel = 0,
    Parent = rowPC,
})
corner(btnPC, 4)
New("UIStroke", { Color = C.stroke, Thickness = 1, Parent = btnPC })

-- PAD keybind
local rowGP = New("Frame", {
    Position = UDim2.fromOffset(12, 126),
    Size = UDim2.new(1, -24, 0, 28),
    BackgroundColor3 = C.row,
    BorderSizePixel = 0,
    Parent = panel,
})
corner(rowGP, 6)
New("UIStroke", { Color = C.stroke, Thickness = 1, Parent = rowGP })

New("TextLabel", {
    BackgroundTransparency = 1,
    Text = "PAD",
    TextSize = 10,
    TextColor3 = C.dim,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.new(0.3, 0, 1, 0),
    Parent = rowGP,
})

local btnGP = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -6, 0.5, 0),
    Size = UDim2.new(0.55, 0, 0, 20),
    AutoButtonColor = false,
    Text = KB_GAMEPAD.Name,
    TextSize = 10,
    TextColor3 = C.accent,
    Font = Enum.Font.Code,
    BackgroundColor3 = Color3.fromRGB(6, 6, 8),
    BorderSizePixel = 0,
    Parent = rowGP,
})
corner(btnGP, 4)
New("UIStroke", { Color = C.stroke, Thickness = 1, Parent = btnGP })

-- Botón de encendido (abajo de todo)
local on = false
local btn = New("TextButton", {
    Position = UDim2.fromOffset(12, 168),
    Size = UDim2.new(1, -24, 0, 42),
    AutoButtonColor = false,
    Text = "POWER  OFF",
    TextSize = 13,
    TextColor3 = C.text,
    Font = Enum.Font.GothamBold,
    BackgroundColor3 = C.btnOff,
    BorderSizePixel = 0,
    Parent = panel,
})
corner(btn, 8)
New("UIStroke", { Color = C.stroke, Thickness = 1.5, Parent = btn })

-- ── Lógica ───────────────────────────────────────────────────────────────────
local Packet = { value = initValue, remote = nil }
_G.__PacketLagger = Packet
local alive = true
local fireserving = false
local fireThread = nil
local expanded = false

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

local btnStroke = btn:FindFirstChildOfClass("UIStroke")

local function paint()
    if on then
        btn.BackgroundColor3 = C.on
        btn.Text = "POWER  ON"
        btn.TextColor3 = C.onText
        if btnStroke then btnStroke.Color = Color3.fromRGB(50, 190, 100) end
        -- Efecto en la tuerquita cuando está activo
        gearBtn.BackgroundColor3 = Color3.fromRGB(18, 40, 28)
    else
        btn.BackgroundColor3 = C.btnOff
        btn.Text = "POWER  OFF"
        btn.TextColor3 = C.text
        if btnStroke then btnStroke.Color = C.stroke end
        gearBtn.BackgroundColor3 = C.bg
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

btn.Activated:Connect(function() setOn(not on) end)

-- Toggle expand / collapse
local function togglePanel()
    expanded = not expanded
    panel.Visible = expanded
    if expanded then
        main.Size = UDim2.fromOffset(240, 290)
    else
        main.Size = UDim2.fromOffset(46, 46)
    end
end

gearBtn.Activated:Connect(togglePanel)

-- Keybind selector
local listeningFor = nil
local listenConn   = nil

local function stopListening()
    listeningFor = nil
    if listenConn then listenConn:Disconnect(); listenConn = nil end
    btnPC.Text = KB_PC.Name
    btnGP.Text = KB_GAMEPAD.Name
    btnPC.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
    btnGP.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
    btnPC.TextColor3 = C.accent
    btnGP.TextColor3 = C.accent
end

local function startListening(which)
    if listeningFor == which then stopListening(); return end
    stopListening()
    listeningFor = which

    local activeBtn = which == "pc" and btnPC or btnGP
    activeBtn.Text = "..."
    activeBtn.BackgroundColor3 = C.listening
    activeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    listenConn = UserInputService.InputBegan:Connect(function(input)
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

-- Toggle por tecla
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

-- Drag (desde la tuerquita)
do
    local dragging, startPos, startMouse
    gearBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging, startPos, startMouse = true, main.Position, i.Position
        end
    end)
    globalConns[#globalConns + 1] = UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - startMouse
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    globalConns[#globalConns + 1] = UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                saveCfg("pos", { main.Position.X.Scale, main.Position.X.Offset, main.Position.Y.Scale, main.Position.Y.Offset })
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
    for _, c in ipairs(globalConns) do pcall(function() c:Disconnect() end) end
    table.clear(globalConns)
    pcall(function() gui:Destroy() end)
    if _G.__PacketLagger == Packet then _G.__PacketLagger = nil end
end

gui.Parent = guiParent()