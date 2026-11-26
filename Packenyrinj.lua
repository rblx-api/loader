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
    if ok and type(raw) == "string" and raw \~= "" then
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
local initPos = UDim2.new(0.5, -120, 0.35, 0)
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

-- Paleta profesional negro / gris / blanco
local C = {
    bg          = Color3.fromRGB(12, 12, 14),
    bg2         = Color3.fromRGB(18, 18, 22),
    row         = Color3.fromRGB(24, 24, 28),
    stroke      = Color3.fromRGB(55, 55, 62),
    strokeLight = Color3.fromRGB(90, 90, 100),
    text        = Color3.fromRGB(235, 235, 240),
    dim         = Color3.fromRGB(140, 140, 150),
    accent      = Color3.fromRGB(220, 220, 230),
    on          = Color3.fromRGB(40, 160, 80),
    off         = Color3.fromRGB(28, 28, 32),
    listening   = Color3.fromRGB(180, 140, 40),
    whiteDot    = Color3.fromRGB(245, 245, 250),
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
-- GUI PRINCIPAL (solo título + power + botón +)
-- ═══════════════════════════════════════════════════════════════

local gui = New("ScreenGui", {
    Name = "KyronPacketLagger",
    ResetOnSpawn = false,
    DisplayOrder = 2147483000,
    IgnoreGuiInset = true,
})

local main = New("Frame", {
    Position = initPos,
    Size = UDim2.fromOffset(240, 118),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    Active = true,
    ClipsDescendants = true,
    Parent = gui,
})
corner(main, 12)
New("UIStroke", { Color = C.stroke, Thickness = 1.5, Parent = main })

-- Puntos blancos decorativos
local function addDots(parent, count)
    for i = 1, count do
        local d = New("Frame", {
            Size = UDim2.fromOffset(math.random(2, 3), math.random(2, 3)),
            Position = UDim2.new(math.random(), 0, math.random(), 0),
            BackgroundColor3 = C.whiteDot,
            BackgroundTransparency = math.random(35, 70) / 100,
            BorderSizePixel = 0,
            Parent = parent,
        })
        corner(d, 10)
    end
end
addDots(main, 14)

-- Header
local head = New("Frame", {
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = C.bg2,
    BorderSizePixel = 0,
    Parent = main,
})
corner(head, 12)
New("Frame", { -- tapa inferior del header
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = C.bg2,
    BorderSizePixel = 0,
    Parent = head,
})

New("TextLabel", {
    BackgroundTransparency = 1,
    Text = "KYRON PACKET LAGGER",
    TextSize = 12,
    TextColor3 = C.text,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Center,
    Size = UDim2.new(1, 0, 1, 0),
    Parent = head,
})

-- Botón Power
local on = false
local powerBtn = New("TextButton", {
    Position = UDim2.fromOffset(12, 48),
    Size = UDim2.new(1, -56, 0, 52),
    AutoButtonColor = false,
    Text = "POWER  OFF",
    TextSize = 14,
    TextColor3 = C.dim,
    Font = Enum.Font.GothamBold,
    BackgroundColor3 = C.off,
    BorderSizePixel = 0,
    Parent = main,
})
corner(powerBtn, 10)
New("UIStroke", { Color = C.stroke, Thickness = 1, Parent = powerBtn })

-- Botón + (esquina superior derecha del área del power)
local expandBtn = New("TextButton", {
    Position = UDim2.new(1, -42, 0, 48),
    Size = UDim2.fromOffset(30, 52),
    AutoButtonColor = false,
    Text = "+",
    TextSize = 22,
    TextColor3 = C.accent,
    Font = Enum.Font.GothamBold,
    BackgroundColor3 = C.row,
    BorderSizePixel = 0,
    Parent = main,
})
corner(expandBtn, 10)
New("UIStroke", { Color = C.stroke, Thickness = 1, Parent = expandBtn })

-- ═══════════════════════════════════════════════════════════════
-- PANEL EXPANDIBLE (Value + Keybinds)
-- ═══════════════════════════════════════════════════════════════

local expanded = false
local expandPanel = New("Frame", {
    Position = UDim2.fromOffset(0, 118),
    Size = UDim2.new(1, 0, 0, 0),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = main,
})
corner(expandPanel, 0)

local expandContent = New("Frame", {
    Size = UDim2.new(1, 0, 0, 148),
    BackgroundTransparency = 1,
    Parent = expandPanel,
})

-- Separador
New("Frame", {
    Size = UDim2.new(1, -24, 0, 1),
    Position = UDim2.fromOffset(12, 0),
    BackgroundColor3 = C.stroke,
    BorderSizePixel = 0,
    Parent = expandContent,
})

-- Value
local valueRow = New("Frame", {
    Position = UDim2.fromOffset(12, 12),
    Size = UDim2.new(1, -24, 0, 32),
    BackgroundColor3 = C.row,
    BorderSizePixel = 0,
    Parent = expandContent,
})
corner(valueRow, 8)
New("UIStroke", { Color = C.stroke, Thickness = 1, Parent = valueRow })

New("TextLabel", {
    BackgroundTransparency = 1,
    Text = "VALUE",
    TextSize = 11,
    TextColor3 = C.dim,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.new(0.4, 0, 1, 0),
    Parent = valueRow,
})

local boxWrap = New("Frame", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -8, 0.5, 0),
    Size = UDim2.new(0.52, 0, 0, 22),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    Parent = valueRow,
})
corner(boxWrap, 6)
New("UIStroke", { Color = C.strokeLight, Thickness = 1, Parent = boxWrap })

local box = New("TextBox", {
    Size = UDim2.new(1, -10, 1, 0),
    Position = UDim2.fromOffset(5, 0),
    BackgroundTransparency = 1,
    Text = tostring(initValue),
    PlaceholderText = MIN_V .. " - " .. MAX_V,
    PlaceholderColor3 = C.dim,
    TextColor3 = C.accent,
    Font = Enum.Font.Code,
    TextSize = 12,
    ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Center,
    Parent = boxWrap,
})

-- Keybind PC
local rowPC = New("Frame", {
    Position = UDim2.fromOffset(12, 54),
    Size = UDim2.new(1, -24, 0, 32),
    BackgroundColor3 = C.row,
    BorderSizePixel = 0,
    Parent = expandContent,
})
corner(rowPC, 8)
New("UIStroke", { Color = C.stroke, Thickness = 1, Parent = rowPC })

New("TextLabel", {
    BackgroundTransparency = 1,
    Text = "PC",
    TextSize = 11,
    TextColor3 = C.dim,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.new(0.35, 0, 1, 0),
    Parent = rowPC,
})

local btnPC = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -8, 0.5, 0),
    Size = UDim2.new(0.55, 0, 0, 22),
    AutoButtonColor = false,
    Text = KB_PC.Name,
    TextSize = 11,
    TextColor3 = C.accent,
    Font = Enum.Font.Code,
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    Parent = rowPC,
})
corner(btnPC, 6)
New("UIStroke", { Color = C.strokeLight, Thickness = 1, Parent = btnPC })

-- Keybind Control
local rowGP = New("Frame", {
    Position = UDim2.fromOffset(12, 96),
    Size = UDim2.new(1, -24, 0, 32),
    BackgroundColor3 = C.row,
    BorderSizePixel = 0,
    Parent = expandContent,
})
corner(rowGP, 8)
New("UIStroke", { Color = C.stroke, Thickness = 1, Parent = rowGP })

New("TextLabel", {
    BackgroundTransparency = 1,
    Text = "CONTROL",
    TextSize = 11,
    TextColor3 = C.dim,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.new(0.4, 0, 1, 0),
    Parent = rowGP,
})

local btnGP = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -8, 0.5, 0),
    Size = UDim2.new(0.5, 0, 0, 22),
    AutoButtonColor = false,
    Text = KB_GAMEPAD.Name,
    TextSize = 11,
    TextColor3 = C.accent,
    Font = Enum.Font.Code,
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    Parent = rowGP,
})
corner(btnGP, 6)
New("UIStroke", { Color = C.strokeLight, Thickness = 1, Parent = btnGP })

-- ═══════════════════════════════════════════════════════════════
-- LÓGICA
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

local function paintPower()
    if on then
        powerBtn.BackgroundColor3 = C.on
        powerBtn.Text = "POWER  ON"
        powerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        local s = powerBtn:FindFirstChildOfClass("UIStroke")
        if s then s.Color = Color3.fromRGB(60, 200, 100) end
    else
        powerBtn.BackgroundColor3 = C.off
        powerBtn.Text = "POWER  OFF"
        powerBtn.TextColor3 = C.dim
        local s = powerBtn:FindFirstChildOfClass("UIStroke")
        if s then s.Color = C.stroke end
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
    paintPower()
end

powerBtn.Activated:Connect(function()
    setOn(not on)
end)

-- ── Expand / Collapse con animación ───────────────────────────
local function toggleExpand()
    expanded = not expanded
    local targetH = expanded and 148 or 0
    local targetMainH = expanded and (118 + 148) or 118

    expandBtn.Text = expanded and "−" or "+"

    TweenService:Create(expandPanel, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 0, targetH)
    }):Play()

    TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(240, targetMainH)
    }):Play()
end

expandBtn.Activated:Connect(toggleExpand)

-- ── Keybind selector ──────────────────────────────────────────
local listeningFor = nil
local listenConn = nil

local function stopListening()
    listeningFor = nil
    if listenConn then listenConn:Disconnect(); listenConn = nil end
    btnPC.Text = KB_PC.Name
    btnGP.Text = KB_GAMEPAD.Name
    btnPC.BackgroundColor3 = C.bg
    btnGP.BackgroundColor3 = C.bg
    btnPC.TextColor3 = C.accent
    btnGP.TextColor3 = C.accent
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

-- ── Toggle por keybind ────────────────────────────────────────
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

-- ── Arrastrar ─────────────────────────────────────────────────
do
    local dragging, startPos, startMouse
    head.InputBegan:Connect(function(i)
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