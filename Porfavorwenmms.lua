-- KYRON PACKET LAGGER | Monochrome UI
-- Visual interface and keybind demo. POWER only changes the UI state;
-- this script intentionally does not send network traffic or create lag.

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local DEFAULT_KB_PC = Enum.KeyCode.F6
local DEFAULT_KB_CONTROL = Enum.KeyCode.DPadDown
local CFG_PATH = "KYRON_PACKET_LAGGER_cfg.json"

local function New(class, props)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    return o
end

local function corner(o, r)
    return New("UICorner", {CornerRadius = UDim.new(0, r), Parent = o})
end

local function stroke(o, color, thickness, transparency)
    return New("UIStroke", {
        Color = color, Thickness = thickness or 1,
        Transparency = transparency or 0, Parent = o
    })
end

local function readCfg()
    local ok, raw = pcall(function()
        if isfile and isfile(CFG_PATH) then return readfile(CFG_PATH) end
    end)
    if ok and type(raw) == "string" and raw ~= "" then
        local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
        if ok2 and type(data) == "table" then return data end
    end
    return {}
end

local function saveCfg(key, value)
    local data = readCfg()
    data[key] = value
    local ok, encoded = pcall(function() return HttpService:JSONEncode(data) end)
    if ok and writefile then pcall(writefile, CFG_PATH, encoded) end
end

local cfg = readCfg()
local function loadKey(name, default)
    local saved = cfg[name]
    if saved and Enum.KeyCode[saved] then return Enum.KeyCode[saved] end
    return default
end

local KB_PC = loadKey("kb_pc", DEFAULT_KB_PC)
local KB_CONTROL = loadKey("kb_control", DEFAULT_KB_CONTROL)

local C = {
    black = Color3.fromRGB(10, 10, 12),
    panel = Color3.fromRGB(17, 17, 20),
    panel2 = Color3.fromRGB(27, 27, 31),
    row = Color3.fromRGB(31, 31, 35),
    white = Color3.fromRGB(245, 245, 248),
    silver = Color3.fromRGB(177, 177, 185),
    muted = Color3.fromRGB(125, 125, 134),
    edge = Color3.fromRGB(91, 91, 101),
    active = Color3.fromRGB(225, 225, 232),
    darkText = Color3.fromRGB(18, 18, 21),
}

local oldParent
pcall(function() oldParent = gethui and gethui() end)
if not oldParent then
    local ok = pcall(function() return CoreGui.Name end)
    oldParent = ok and CoreGui or LocalPlayer:WaitForChild("PlayerGui")
end

local old = oldParent:FindFirstChild("KYRON_PACKET_LAGGER")
if old then old:Destroy() end

local gui = New("ScreenGui", {
    Name = "KYRON_PACKET_LAGGER",
    ResetOnSpawn = false,
    DisplayOrder = 2147483000,
    IgnoreGuiInset = true,
    Parent = oldParent,
})

local root = New("Frame", {
    Name = "Root",
    Position = UDim2.new(0.5, -132, 0.38, 0),
    Size = UDim2.fromOffset(264, 52),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Parent = gui,
})

-- Shadow layer
local shadow = New("Frame", {
    Name = "Shadow",
    Position = UDim2.fromOffset(3, 5),
    Size = UDim2.fromOffset(258, 47),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 0.28,
    BorderSizePixel = 0,
    ZIndex = 0,
    Parent = root,
})
corner(shadow, 13)

-- Compact power header
local header = New("Frame", {
    Name = "PowerHeader",
    Size = UDim2.fromOffset(264, 52),
    BackgroundColor3 = C.black,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 2,
    Parent = root,
})
corner(header, 12)
stroke(header, C.edge, 1.25, 0.12)

local headerGrad = New("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(32, 32, 37)),
        ColorSequenceKeypoint.new(0.52, Color3.fromRGB(12, 12, 14)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 29)),
    }),
    Rotation = 25,
    Parent = header,
})

-- Tiny white decorative points
for i = 1, 13 do
    local dotSize = (i % 4 == 0) and 3 or 2
    local dot = New("Frame", {
        Size = UDim2.fromOffset(dotSize, dotSize),
        Position = UDim2.new((i * 37 % 96) / 100, 0, (i * 19 % 78) / 100, 0),
        BackgroundColor3 = C.white,
        BackgroundTransparency = 0.48 + (i % 3) * 0.12,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = header,
    })
    corner(dot, 5)
end

local title = New("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(14, 7),
    Size = UDim2.new(1, -76, 0, 20),
    Text = "KYRON",
    TextColor3 = C.white,
    Font = Enum.Font.GothamBlack,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = header,
})

local subtitle = New("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(15, 27),
    Size = UDim2.new(1, -80, 0, 13),
    Text = "PACKET LAGGER  /  CONTROL PANEL",
    TextColor3 = C.muted,
    Font = Enum.Font.GothamMedium,
    TextSize = 8,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = header,
})

local power = New("TextButton", {
    Name = "PowerButton",
    Position = UDim2.new(1, -73, 0, 10),
    Size = UDim2.fromOffset(49, 31),
    BackgroundColor3 = C.panel2,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "OFF",
    TextColor3 = C.silver,
    Font = Enum.Font.GothamBlack,
    TextSize = 10,
    ZIndex = 6,
    Parent = header,
})
corner(power, 8)
stroke(power, C.edge, 1, 0.1)

local expand = New("TextButton", {
    Name = "ExpandButton",
    Position = UDim2.new(1, -25, 0, 3),
    Size = UDim2.fromOffset(19, 17),
    BackgroundTransparency = 1,
    AutoButtonColor = false,
    Text = "+",
    TextColor3 = C.white,
    Font = Enum.Font.GothamBold,
    TextSize = 17,
    ZIndex = 8,
    Parent = header,
})

-- Dropdown panel animates down from the power header
local panel = New("Frame", {
    Name = "SettingsPanel",
    Position = UDim2.fromOffset(0, 57),
    Size = UDim2.fromOffset(264, 0),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Visible = true,
    ZIndex = 2,
    Parent = root,
})
corner(panel, 12)
stroke(panel, C.edge, 1.1, 0.18)

local panelTop = New("Frame", {
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.new(1, -24, 0, 1),
    BackgroundColor3 = C.edge,
    BackgroundTransparency = 0.25,
    BorderSizePixel = 0,
    ZIndex = 3,
    Parent = panel,
})

local valueLabel = New("TextLabel", {
    Position = UDim2.fromOffset(13, 13),
    Size = UDim2.new(1, -26, 0, 16),
    BackgroundTransparency = 1,
    Text = "CONFIGURATION",
    TextColor3 = C.white,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
    Parent = panel,
})

local info = New("TextLabel", {
    Position = UDim2.fromOffset(13, 31),
    Size = UDim2.new(1, -26, 0, 20),
    BackgroundTransparency = 1,
    Text = "Choose a key for each device",
    TextColor3 = C.muted,
    Font = Enum.Font.Gotham,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
    Parent = panel,
})

local function makeKeyRow(labelText, y, keyText)
    local row = New("Frame", {
        Position = UDim2.fromOffset(12, y),
        Size = UDim2.new(1, -24, 0, 31),
        BackgroundColor3 = C.row,
        BorderSizePixel = 0,
        ZIndex = 4,
        Parent = panel,
    })
    corner(row, 7)
    stroke(row, Color3.fromRGB(70, 70, 79), 1, 0.3)

    New("TextLabel", {
        Position = UDim2.fromOffset(9, 0),
        Size = UDim2.new(0.42, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = C.silver,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = row,
    })

    local keyButton = New("TextButton", {
        Position = UDim2.new(1, -91, 0.5, -10),
        Size = UDim2.fromOffset(82, 20),
        BackgroundColor3 = C.panel,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = keyText,
        TextColor3 = C.white,
        Font = Enum.Font.Code,
        TextSize = 9,
        ZIndex = 5,
        Parent = row,
    })
    corner(keyButton, 5)
    stroke(keyButton, C.edge, 1, 0.2)
    return keyButton
end

local btnPC = makeKeyRow("PC KEYBIND", 59, KB_PC.Name)
local btnControl = makeKeyRow("CONTROL", 97, KB_CONTROL.Name)

local status = New("TextLabel", {
    Position = UDim2.fromOffset(13, 137),
    Size = UDim2.new(1, -26, 0, 18),
    BackgroundTransparency = 1,
    Text = "POWER IS A VISUAL DEMO",
    TextColor3 = C.muted,
    Font = Enum.Font.GothamMedium,
    TextSize = 8,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
    Parent = panel,
})

local opened = false
local animating = false
local PANEL_HEIGHT = 168

local function setExpanded(value)
    if animating then return end
    opened = value
    animating = true
    expand.Text = opened and "−" or "+"
    local target = opened and PANEL_HEIGHT or 0
    local targetRoot = opened and 230 or 52
    local t1 = TweenService:Create(panel, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(264, target)
    })
    local t2 = TweenService:Create(root, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(264, targetRoot)
    })
    t1:Play()
    t2:Play()
    t2.Completed:Connect(function()
        animating = false
    end)
end

expand.Activated:Connect(function()
    setExpanded(not opened)
end)

local powerOn = false
local function setPower(value)
    powerOn = value
    if powerOn then
        power.Text = "ON"
        power.BackgroundColor3 = C.active
        power.TextColor3 = C.darkText
        status.Text = "VISUAL POWER: ON"
        status.TextColor3 = C.white
    else
        power.Text = "OFF"
        power.BackgroundColor3 = C.panel2
        power.TextColor3 = C.silver
        status.Text = "VISUAL POWER: OFF"
        status.TextColor3 = C.muted
    end
end
power.Activated:Connect(function()
    setPower(not powerOn)
end)

local listeningFor = nil
local listenConn = nil
local function stopListening()
    listeningFor = nil
    if listenConn then listenConn:Disconnect(); listenConn = nil end
    btnPC.Text = KB_PC.Name
    btnControl.Text = KB_CONTROL.Name
    btnPC.TextColor3 = C.white
    btnControl.TextColor3 = C.white
    btnPC.BackgroundColor3 = C.panel
    btnControl.BackgroundColor3 = C.panel
end

local function startListening(which)
    if listeningFor == which then stopListening(); return end
    stopListening()
    listeningFor = which
    local activeButton = which == "pc" and btnPC or btnControl
    activeButton.Text = "PRESS KEY..."
    activeButton.TextColor3 = C.darkText
    activeButton.BackgroundColor3 = C.active

    listenConn = UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Escape then
            stopListening()
            return
        end
        if input.KeyCode == Enum.KeyCode.Unknown then return end

        if which == "pc" then
            KB_PC = input.KeyCode
            saveCfg("kb_pc", KB_PC.Name)
        else
            KB_CONTROL = input.KeyCode
            saveCfg("kb_control", KB_CONTROL.Name)
        end
        stopListening()
    end)
end

btnPC.Activated:Connect(function() startListening("pc") end)
btnControl.Activated:Connect(function() startListening("control") end)

local keyCooldown = false
local globalConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if listeningFor or gameProcessed or keyCooldown then return end
    if input.KeyCode == KB_PC or input.KeyCode == KB_CONTROL then
        keyCooldown = true
        setPower(not powerOn)
        task.delay(0.25, function() keyCooldown = false end)
    end
end)

-- Drag from the title/header on mouse or touch
do
    local dragging = false
    local dragStart, startPosition
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = root.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            root.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

setPower(false)
print("KYRON PACKET LAGGER | Monochrome UI loaded")