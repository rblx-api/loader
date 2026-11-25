if _G.__PacketLagger and _G.__PacketLagger.Destroy then
    pcall(_G.__PacketLagger.Destroy)
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local MIN_V, MAX_V = 1000, 200000
local NET_INDEX = 6
local BATCH = 12             -- disparos por frame (más = más rápido, sube CPU)
local REMOTE_RETRY = 0.5     -- segundos entre reintentos de remote
local BURST_FRAMES = 3       -- frames extra al activar ON (arranque rápido)

local function getRemote()
    local pk = ReplicatedStorage:FindFirstChild("Packages") or ReplicatedStorage:WaitForChild("Packages", 10)
    if not pk then return nil end
    local net = pk:FindFirstChild("Net") or pk:WaitForChild("Net", 10)
    if not net then return nil end
    local child = net:GetChildren()[NET_INDEX]
    if child and child:IsA("BaseRemoteEvent") then return child end
    return nil
end

local CFG_PATH = "RLM_Packer_cfg.json"

local function readCfg()
    local ok, raw = pcall(function()
        if isfile and isfile(CFG_PATH) then return readfile(CFG_PATH) end
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
    if ok and writefile then pcall(writefile, CFG_PATH, encoded) end
end

local cfg = readCfg()
local initValue = math.clamp(tonumber(cfg.value) or MIN_V, MIN_V, MAX_V)
local initPos = UDim2.new(0.5, -130, 0.4, 0)
if type(cfg.pos) == "table" and #cfg.pos == 4 then
    initPos = UDim2.new(cfg.pos[1], cfg.pos[2], cfg.pos[3], cfg.pos[4])
end
local initLocked = cfg.locked == true

-- ══════════ PALETA ══════════
local C = {
    bgTop     = Color3.fromRGB(12, 12, 14),
    bgBottom  = Color3.fromRGB(0, 0, 0),
    card      = Color3.fromRGB(18, 18, 20),
    cardHover = Color3.fromRGB(28, 28, 30),
    stroke    = Color3.fromRGB(255, 255, 255),
    strokeDim = Color3.fromRGB(70, 70, 75),
    text      = Color3.fromRGB(255, 255, 255),
    dim       = Color3.fromRGB(150, 150, 155),
    accent    = Color3.fromRGB(255, 255, 255),
    onText    = Color3.fromRGB(0, 0, 0),
}

local W, H_EXP, H_COL = 260, 168, 92

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

-- ══════════ GUI (idéntica) ══════════
local gui = New("ScreenGui", {
    Name = "RLM PACKER", ResetOnSpawn = false,
    DisplayOrder = 2147483000, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
local shadow = New("Frame", {
    Position = initPos, AnchorPoint = Vector2.new(0, 0),
    Size = UDim2.fromOffset(W, H_EXP),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.55, BorderSizePixel = 0, Parent = gui,
})
corner(shadow, 16)
shadow.Position = UDim2.new(initPos.X.Scale, initPos.X.Offset + 4, initPos.Y.Scale, initPos.Y.Offset + 6)

local win = New("Frame", {
    Position = initPos, Size = UDim2.fromOffset(W, H_EXP),
    BackgroundColor3 = C.bgTop, BorderSizePixel = 0, Active = true, Parent = gui,
    ClipsDescendants = true,
})
corner(win, 14)
New("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, C.bgTop),
        ColorSequenceKeypoint.new(1, C.bgBottom),
    }, Rotation = 90, Parent = win,
})
New("UIStroke", { Color = C.stroke, Thickness = 1.2, Transparency = 0.15, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = win })
New("UIStroke", { Color = C.stroke, Thickness = 3, Transparency = 0.85, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = win })

local head = New("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Parent = win })
local led = New("Frame", {
    Position = UDim2.fromOffset(14, 16), Size = UDim2.fromOffset(6, 6),
    BackgroundColor3 = C.strokeDim, BorderSizePixel = 0, Parent = head,
})
corner(led, 3)
New("TextLabel", {
    BackgroundTransparency = 1, Text = "RLM PACKER",
    TextSize = 12, TextColor3 = C.text, Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(28, 0), Size = UDim2.new(1, -120, 1, 0),
    Parent = head,
})

local locked = initLocked
local lockBtn = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -42, 0.5, 0),
    Size = UDim2.fromOffset(56, 22), AutoButtonColor = false,
    Text = locked and "🔒 LOCK" or "🔓 LOCK",
    TextSize = 10, TextColor3 = C.text, Font = Enum.Font.GothamBold,
    BackgroundColor3 = locked and C.accent or C.card,
    BorderSizePixel = 0, Parent = head, Selectable = true,
})
corner(lockBtn, 6)
local lockStroke = New("UIStroke", { Color = C.stroke, Thickness = 1, Transparency = locked and 0 or 0.6, Parent = lockBtn })

local collapseBtn = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0),
    Size = UDim2.fromOffset(22, 22), AutoButtonColor = false,
    Text = "▾", TextSize = 14, TextColor3 = C.text, Font = Enum.Font.GothamBold,
    BackgroundColor3 = C.card, BorderSizePixel = 0, Parent = head, Selectable = true,
})
corner(collapseBtn, 6)
New("UIStroke", { Color = C.stroke, Thickness = 1, Transparency = 0.6, Parent = collapseBtn })

New("Frame", {
    Position = UDim2.new(0, 14, 0, 36), Size = UDim2.new(1, -28, 0, 1),
    BackgroundColor3 = C.stroke, BackgroundTransparency = 0.75,
    BorderSizePixel = 0, Parent = win,
})

local content = New("Frame", {
    Position = UDim2.fromOffset(0, 37), Size = UDim2.new(1, 0, 1, -37),
    BackgroundTransparency = 1, Parent = win,
})

local boxRow = New("Frame", {
    Position = UDim2.fromOffset(14, 13), Size = UDim2.new(1, -28, 0, 34),
    BackgroundColor3 = C.card, BorderSizePixel = 0, Parent = content,
})
corner(boxRow, 9)
New("UIStroke", { Color = C.strokeDim, Thickness = 1, Transparency = 0.4, Parent = boxRow })
New("TextLabel", {
    BackgroundTransparency = 1, Text = "VALUE",
    TextSize = 10, TextColor3 = C.dim, Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(12, 0), Size = UDim2.new(0.4, 0, 1, 0),
    Parent = boxRow,
})
local boxWrap = New("Frame", {
    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6, 0.5, 0),
    Size = UDim2.new(0.55, 0, 0, 24), BackgroundColor3 = C.bgBottom,
    BorderSizePixel = 0, Parent = boxRow,
})
corner(boxWrap, 6)
local boxStroke = New("UIStroke", { Color = C.stroke, Thickness = 1, Transparency = 0.7, Parent = boxWrap })
local box = New("TextBox", {
    Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(6, 0),
    BackgroundTransparency = 1, Text = tostring(initValue),
    PlaceholderText = MIN_V .. " - " .. MAX_V, PlaceholderColor3 = C.dim,
    TextColor3 = C.text, Font = Enum.Font.Code, TextSize = 11,
    ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Center,
    Parent = boxWrap, Selectable = true,
})
New("TextLabel", {
    BackgroundTransparency = 1, Text = "BY RALAMM",
    TextSize = 9, TextColor3 = C.dim, Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Center,
    Position = UDim2.new(0, 0, 0, 84), Size = UDim2.new(1, 0, 0, 14),
    Parent = content,
})

local on = false
local btn = New("TextButton", {
    Position = UDim2.fromOffset(14, 98), Size = UDim2.new(1, -28, 0, 40),
    AutoButtonColor = false, Text = "OFF",
    TextSize = 12, TextColor3 = C.text, Font = Enum.Font.GothamBold,
    BackgroundColor3 = C.card, BorderSizePixel = 0, Parent = win, Selectable = true,
})
corner(btn, 20)
local btnStroke = New("UIStroke", { Color = C.stroke, Thickness = 1.2, Transparency = 0.55, Parent = btn })
local btnGlow = New("UIStroke", { Color = C.stroke, Thickness = 4, Transparency = 1, Parent = btn })
local hint = New("TextLabel", {
    BackgroundTransparency = 1, Text = "Y: panel  •  A: ON/OFF  •  X: lock",
    TextSize = 8, TextColor3 = C.dim, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Center,
    Position = UDim2.new(0, 0, 1, -11), Size = UDim2.new(1, 0, 0, 10),
    Parent = win,
})

local function paintLock(instant)
    local bg = locked and C.accent or C.card
    local txt = locked and C.onText or C.text
    local label = locked and "🔒 LOCK" or "🔓 LOCK"
    local trans = locked and 0 or 0.6
    if instant then
        lockBtn.BackgroundColor3 = bg; lockBtn.TextColor3 = txt; lockBtn.Text = label
        lockStroke.Transparency = trans
    else
        local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(lockBtn, info, { BackgroundColor3 = bg, TextColor3 = txt }):Play()
        TweenService:Create(lockStroke, info, { Transparency = trans }):Play()
        lockBtn.Text = label
    end
end
local function setLocked(v, save)
    locked = v and true or false
    paintLock(false)
    if save then saveCfg("locked", locked) end
end
lockBtn.Activated:Connect(function() setLocked(not locked, true) end)

local collapsed = false
local function applyCollapse(instant)
    local targetH = collapsed and H_COL or H_EXP
    local targetBtnY = collapsed and 46 or 98
    local targetArrow = collapsed and "▸" or "▾"
    if instant then
        win.Size = UDim2.fromOffset(W, targetH); shadow.Size = UDim2.fromOffset(W, targetH)
        btn.Position = UDim2.fromOffset(14, targetBtnY)
        content.Visible = not collapsed; hint.Visible = not collapsed
        collapseBtn.Text = targetArrow
    else
        local info = TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(win, info, { Size = UDim2.fromOffset(W, targetH) }):Play()
        TweenService:Create(shadow, info, { Size = UDim2.fromOffset(W, targetH) }):Play()
        TweenService:Create(btn, info, { Position = UDim2.fromOffset(14, targetBtnY) }):Play()
        task.delay(0.12, function() content.Visible = not collapsed; hint.Visible = not collapsed end)
        collapseBtn.Text = targetArrow
    end
end
collapseBtn.Activated:Connect(function() collapsed = not collapsed; applyCollapse(false) end)

-- ══════════ POWER OPTIMIZADO (menos delay al llegar a la base) ══════════
local Packet = { value = initValue, remote = nil }
_G.__PacketLagger = Packet
local alive = true
local fireserving = false
local fireThread = nil
local heartbeatConn = nil
local payload = nil
local payloadValue = nil
local remoteScanConn = nil
local burstLeft = 0

local function rebuildPayload()
    if payloadValue == Packet.value and payload then return end
    payloadValue = Packet.value
    payload = table.create(payloadValue, function() end)
end

local function stopFireServer()
    if not fireserving then return end
    fireserving = false
    burstLeft = 0
    if heartbeatConn then pcall(function() heartbeatConn:Disconnect() end); heartbeatConn = nil end
    if fireThread then pcall(task.cancel, fireThread); fireThread = nil end
end

local function startFireServer()
    if fireserving then return end
    local remote = Packet.remote
    if not remote then return end
    rebuildPayload()
    fireserving = true
    burstLeft = BURST_FRAMES

    heartbeatConn = RunService.Heartbeat:Connect(function()
        if not fireserving or not alive then return end
        local r = Packet.remote
        if not r or not r.Parent then
            on = false; paint(false); stopFireServer(); return
        end
        local p = payload
        local n = BATCH
        if burstLeft > 0 then
            n = BATCH * 2   -- burst doble los primeros frames
            burstLeft -= 1
        end
        -- pcall por batch (1 por frame), no por disparo
        pcall(function()
            for _ = 1, n do
                r:FireServer(p)
            end
        end)
    end)
end

local function readValue()
    local n = tonumber((box.Text:gsub("[^%d]", "")))
    n = math.clamp(math.floor(n or Packet.value or MIN_V), MIN_V, MAX_V)
    box.Text = tostring(n)
    if n ~= Packet.value then
        Packet.value = n
        if payload then rebuildPayload() end
    end
    return n
end
box.FocusLost:Connect(function() readValue(); saveCfg("value", Packet.value) end)

local function paint(instant)
    local bg = on and C.accent or C.card
    local txt = on and C.onText or C.text
    local st = on and 0 or 0.55
    local gl = on and 0.45 or 1
    local ld = on and C.stroke or C.strokeDim
    local label = on and "ON" or "OFF"
    if instant then
        btn.BackgroundColor3 = bg; btn.TextColor3 = txt; btn.Text = label
        btnStroke.Transparency = st; btnGlow.Transparency = gl
        led.BackgroundColor3 = ld
    else
        local info = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(btn, info, { BackgroundColor3 = bg, TextColor3 = txt }):Play()
        TweenService:Create(btnStroke, info, { Transparency = st }):Play()
        TweenService:Create(btnGlow, info, { Transparency = gl }):Play()
        TweenService:Create(led, info, { BackgroundColor3 = ld }):Play()
        btn.Text = label
    end
end

local function setOn(v)
    on = v and true or false
    if on then
        readValue()
        if not Packet.remote or not Packet.remote.Parent then Packet.remote = getRemote() end
        if not alive then return end
        if Packet.remote then startFireServer() else on = false end
    else
        stopFireServer()
    end
    paint(false)
end
btn.Activated:Connect(function() setOn(not on) end)

local function remoteScanner()
    if remoteScanConn then return end
    remoteScanConn = task.spawn(function()
        while alive do
            if not Packet.remote or not Packet.remote.Parent then
                local r = getRemote()
                if r then Packet.remote = r end
            end
            task.wait(REMOTE_RETRY)
        end
    end)
end

btn.MouseEnter:Connect(function() if not on then TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = C.cardHover }):Play() end end)
btn.MouseLeave:Connect(function() if not on then TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = C.card }):Play() end end)
collapseBtn.MouseEnter:Connect(function() TweenService:Create(collapseBtn, TweenInfo.new(0.15), { BackgroundColor3 = C.cardHover }):Play() end)
collapseBtn.MouseLeave:Connect(function() TweenService:Create(collapseBtn, TweenInfo.new(0.15), { BackgroundColor3 = C.card }):Play() end)
lockBtn.MouseEnter:Connect(function() if not locked then TweenService:Create(lockBtn, TweenInfo.new(0.15), { BackgroundColor3 = C.cardHover }):Play() end end)
lockBtn.MouseLeave:Connect(function() if not locked then TweenService:Create(lockBtn, TweenInfo.new(0.15), { BackgroundColor3 = C.card }):Play() end end)
box.Focused:Connect(function() TweenService:Create(boxStroke, TweenInfo.new(0.15), { Transparency = 0.1 }):Play() end)
box.FocusLost:Connect(function() TweenService:Create(boxStroke, TweenInfo.new(0.15), { Transparency = 0.7 }):Play() end)

-- ══════════ MANDO ══════════
local function bindSelectionGroup()
    pcall(function()
        box.SelectionGroup = true; btn.SelectionGroup = true
        collapseBtn.SelectionGroup = true; lockBtn.SelectionGroup = true
        GuiService.SelectedObject = btn
    end)
end
local gamepadConns = {}
local function isGamepad(i)
    return i.UserInputType == Enum.UserInputType.Gamepad1 or i.UserInputType == Enum.UserInputType.Gamepad2
        or i.UserInputType == Enum.UserInputType.Gamepad3 or i.UserInputType == Enum.UserInputType.Gamepad4
end
gamepadConns[#gamepadConns+1] = UserInputService.InputBegan:Connect(function(input)
    if not isGamepad(input) then return end
    if input.KeyCode == Enum.KeyCode.ButtonY then collapsed = not collapsed; applyCollapse(false)
    elseif input.KeyCode == Enum.KeyCode.ButtonA then
        if GuiService.SelectedObject == box then return end
        setOn(not on)
    elseif input.KeyCode == Enum.KeyCode.ButtonX then setLocked(not locked, true) end
end)
gamepadConns[#gamepadConns+1] = UserInputService.GamepadConnected:Connect(bindSelectionGroup)
if UserInputService.GamepadEnabled then task.defer(bindSelectionGroup) end

-- ══════════ DRAG (respeta LOCK) ══════════
local globalConns = {}
do
    local dragging, startPos, startMouse
    head.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if collapseBtn:IsAncestorOf(i) then return end
            if lockBtn:IsAncestorOf(i) then return end
            if locked then return end
            dragging, startPos, startMouse = true, win.Position, i.Position
        end
    end)
    globalConns[#globalConns + 1] = UserInputService.InputChanged:Connect(function(i)
        if dragging and not locked and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - startMouse
            local np = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            win.Position = np
            shadow.Position = UDim2.new(np.X.Scale, np.X.Offset + 4, np.Y.Scale, np.Y.Offset + 6)
        end
    end)
    globalConns[#globalConns + 1] = UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if dragging then saveCfg("pos", { win.Position.X.Scale, win.Position.X.Offset, win.Position.Y.Scale, win.Position.Y.Offset }) end
            dragging = false
        end
    end)
end
for _, c in ipairs(gamepadConns) do globalConns[#globalConns + 1] = c end

remoteScanner()
task.spawn(function()
    local r = getRemote()
    if alive and r then Packet.remote = r end
end)

function Packet.Destroy()
    alive = false
    stopFireServer()
    if remoteScanConn then pcall(task.cancel, remoteScanConn); remoteScanConn = nil end
    for _, c in ipairs(globalConns) do pcall(function() c:Disconnect() end) end
    table.clear(globalConns)
    pcall(function() gui:Destroy() end)
    if _G.__PacketLagger == Packet then _G.__PacketLagger = nil end
end

gui.Parent = guiParent()
applyCollapse(true)
paintLock(true)