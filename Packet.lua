-- Luck.packet - VERSION CON MINIMIZAR + START VISIBLE
-- Original leaked by NXC HUB

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService      = game:GetService("HttpService")
local Workspace        = game:GetService("Workspace")

local LP = Players.LocalPlayer
if not LP then warn("Run as LocalScript.") return end

local playerGui   = LP:WaitForChild("PlayerGui")
local CONFIG_FILE = "Luck_packet_Config.json"

-- ── COLORS ──
local C = {
    panelTop  = Color3.fromRGB(10,  48,  29),
    panelBot  = Color3.fromRGB(18,  24,  23),
    edge      = Color3.fromRGB(190,  20,  35),
    red       = Color3.fromRGB(220,  20,  35),
    green     = Color3.fromRGB(0, 255, 0),
    label     = Color3.fromRGB(190, 220, 195),
    white     = Color3.fromRGB(255, 255, 255),
    field     = Color3.fromRGB(15,  29,  23),
    fieldEdge = Color3.fromRGB(25, 105,  58),
    stop      = Color3.fromRGB(105,  18,  25),
}

-- ── HELPERS ──
local function make(cls, props, parent)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do o[k] = v end
    o.Parent = parent
    return o
end
local function corner(p, r) make("UICorner", { CornerRadius = UDim.new(0, r) }, p) end
local function stroke(p, col, th, tr)
    return make("UIStroke", { Color = col, Thickness = th, Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, p)
end
local function tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- ── STATE ──
local lagging       = false
local lagThread     = nil
local intensity     = 42000
local toggleKey     = Enum.KeyCode.C
local toggleKeyName = "C"
local isMinimized   = false
local function clampIntensity(v)
    v = tonumber(v)
    if not v then return intensity end
    return math.clamp(math.floor(v), 1, 100000)
end

-- ── EVENT GRAB ──
local Event
do
    local ok, net = pcall(function()
        return ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
    end)
    if ok and net then
        local kids = net:GetChildren()
        Event = kids[230]
    end
end

-- ── SAVE / LOAD ──
local function saveConfig(panel)
    local cfg = {
        Intensity = intensity,
        Keybind   = toggleKeyName,
        PX_S = panel.Position.X.Scale, PX_O = panel.Position.X.Offset,
        PY_S = panel.Position.Y.Scale, PY_O = panel.Position.Y.Offset,
    }
    if writefile then pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(cfg)) end) end
end

local function loadConfig(panel, intBox, keyBtn)
    if not (readfile and isfile) then return end
    if not isfile(CONFIG_FILE) then return end
    local ok, cfg = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
    if not (ok and type(cfg) == "table") then return end
    if tonumber(cfg.Intensity) then
        intensity = clampIntensity(cfg.Intensity)
        intBox.Text = tostring(intensity)
    end
    if type(cfg.Keybind) == "string" and cfg.Keybind ~= "" then
        toggleKeyName = cfg.Keybind
        toggleKey     = Enum.KeyCode[cfg.Keybind] or Enum.KeyCode.C
        keyBtn.Text   = "[" .. toggleKeyName .. "]"
    end
    if tonumber(cfg.PX_S) then panel.Position = UDim2.new(cfg.PX_S, cfg.PX_O, cfg.PY_S, cfg.PY_O) end
end

-- ── GUI ──
local prev = playerGui:FindFirstChild("Luck.packet")
if prev then prev:Destroy() end

local screenGui = make("ScreenGui", {
    Name = "Luck.packet", ResetOnSpawn = false, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100,
}, playerGui)

local panel = make("Frame", {
    Name = "MainPanel", AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(380, 400),
    BackgroundColor3 = C.panelTop, BorderSizePixel = 0, Active = true, ClipsDescendants = false, ZIndex = 2,
}, screenGui)
corner(panel, 26)
stroke(panel, C.edge, 2, 0.05)
make("UIGradient", { Rotation = 90, Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, C.panelTop), ColorSequenceKeypoint.new(1, C.panelBot) }) }, panel)

-- Christmas lights
local bulbColors = { Color3.fromRGB(255,25,35), Color3.fromRGB(0,255,70), Color3.fromRGB(255,220,45), Color3.fromRGB(0,210,255) }
for i = 0, 9 do
    local color = bulbColors[(i % #bulbColors) + 1]
    local x = 0.06 + (0.88 * i / 9)
    for _, y in ipairs({0.015, 0.985}) do
        local bulb = make("Frame", { Name="ChristmasLight", AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(x,y), Size=UDim2.fromOffset(7,7), BackgroundColor3=color, BorderSizePixel=0, ZIndex=20 }, panel)
        corner(bulb, 10); stroke(bulb, Color3.fromRGB(255,255,255), 1, 0.2)
    end
end
for i = 0, 7 do
    local color = bulbColors[(i % #bulbColors) + 1]
    local y = 0.12 + (0.76 * i / 7)
    for _, x in ipairs({0.015, 0.985}) do
        local bulb = make("Frame", { Name="ChristmasLight", AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(x,y), Size=UDim2.fromOffset(7,7), BackgroundColor3=color, BorderSizePixel=0, ZIndex=20 }, panel)
        corner(bulb, 10); stroke(bulb, Color3.fromRGB(255,255,255), 1, 0.2)
    end
end

local function updateSize()
    if isMinimized then return end
    local cam = Workspace.CurrentCamera
    if not cam then return end
    local vp  = cam.ViewportSize
    local w   = math.clamp(math.min(vp.X * 0.80, vp.Y * 0.55), 250, 380)
    local h   = math.clamp(w * 1.05, 300, vp.Y * 0.85)
    panel.Size = UDim2.fromOffset(math.floor(w), math.floor(h))
end
updateSize()
if Workspace.CurrentCamera then Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateSize) end
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(updateSize)

-- drag handle
local dragHandle = make("TextButton", {
    Position=UDim2.fromScale(0,0), Size=UDim2.fromScale(1,0.20),
    BackgroundTransparency=1, Text="", AutoButtonColor=false, Active=true, ZIndex=5,
}, panel)

local logoImg = make("ImageLabel", {
    Name="LuckPacketLogo", BackgroundTransparency=1,
    Position=UDim2.fromScale(0.055,0.08), Size=UDim2.fromScale(0.13,0.80),
    Image="rbxassetid://77864604756347", ScaleType=Enum.ScaleType.Fit, ZIndex=6,
}, dragHandle)

local titleLbl = make("TextLabel", {
    BackgroundTransparency=1, Position=UDim2.fromScale(0.21,0.22), Size=UDim2.fromScale(0.50,0.42),
    Font=Enum.Font.GothamBold, Text="Luck.packet", TextColor3=C.white, TextScaled=true, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=6,
}, dragHandle)
make("UITextSizeConstraint", { MinTextSize=14, MaxTextSize=21 }, titleLbl)

make("Frame", { Position=UDim2.fromScale(0.055,0.78), Size=UDim2.new(0.89,0,0,3), BackgroundColor3=C.red, BorderSizePixel=0, ZIndex=6 }, dragHandle)

-- BOTON MINIMIZAR (-)
local minBtn = make("TextButton", {
    Name="MinimizeBtn", Position=UDim2.fromScale(0.835,0.15), Size=UDim2.fromScale(0.11,0.50),
    BackgroundColor3=C.field, BorderSizePixel=0, AutoButtonColor=false,
    Font=Enum.Font.GothamBold, Text="-", TextColor3=C.white, TextScaled=true, ZIndex=10,
}, dragHandle)
corner(minBtn, 8); stroke(minBtn, C.fieldEdge, 1, 0.25)
make("UITextSizeConstraint", { MinTextSize=14, MaxTextSize=18 }, minBtn)

-- content holder
local contentHolder = make("Frame", {
    Name="ContentHolder", BackgroundTransparency=1,
    Position=UDim2.fromScale(0,0.20), Size=UDim2.fromScale(1,0.80), BorderSizePixel=0, ZIndex=2,
}, panel)

make("TextLabel", {
    BackgroundTransparency=1, Position=UDim2.fromScale(0.055,0.04), Size=UDim2.fromScale(0.89,0.055),
    Font=Enum.Font.GothamBold, Text="POWER", TextColor3=C.label, TextScaled=true, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
}, contentHolder)

local powerBox = make("TextBox", {
    Position=UDim2.fromScale(0.055,0.11), Size=UDim2.fromScale(0.89,0.135),
    BackgroundColor3=C.field, BorderSizePixel=0, ClearTextOnFocus=false,
    Font=Enum.Font.GothamBold, Text=tostring(intensity), TextColor3=C.white, TextScaled=true, TextXAlignment=Enum.TextXAlignment.Center, ZIndex=3,
}, contentHolder)
corner(powerBox, 14); stroke(powerBox, C.fieldEdge, 1, 0.25)
make("UITextSizeConstraint", { MinTextSize=15, MaxTextSize=22 }, powerBox)

make("TextLabel", {
    BackgroundTransparency=1, Position=UDim2.fromScale(0.055,0.29), Size=UDim2.fromScale(0.89,0.055),
    Font=Enum.Font.GothamBold, Text="KEYBIND", TextColor3=C.label, TextScaled=true, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
}, contentHolder)

local keyBtn = make("TextButton", {
    Position=UDim2.fromScale(0.055,0.36), Size=UDim2.fromScale(0.89,0.125),
    BackgroundColor3=C.field, BorderSizePixel=0, AutoButtonColor=false,
    Font=Enum.Font.GothamBold, Text="["..toggleKeyName.."]", TextColor3=C.white, TextScaled=true, ZIndex=3,
}, contentHolder)
corner(keyBtn, 14); stroke(keyBtn, C.fieldEdge, 1, 0.25)
make("UITextSizeConstraint", { MinTextSize=15, MaxTextSize=22 }, keyBtn)

-- START / STOP
local startBtn = make("TextButton", {
    Position=UDim2.fromScale(0.055,0.65), Size=UDim2.fromScale(0.89,0.155),
    BackgroundColor3=C.green, BorderSizePixel=0, AutoButtonColor=false,
    Font=Enum.Font.GothamBold, Text="START", TextColor3=C.white, TextScaled=true, ZIndex=4,
}, contentHolder)
corner(startBtn, 15)
local startOutline = stroke(startBtn, C.red, 2, 0)
make("UITextSizeConstraint", { MinTextSize=16, MaxTextSize=23 }, startBtn)

-- ── MINIMIZED BAR (STAR + START) ───────────────────────────────────────────
-- Este es el que aparece cuando minimizas
local minimizedBar = make("Frame", {
    Name="MinimizedBar",
    AnchorPoint=Vector2.new(0.5,0.5),
    Position=panel.Position,
    Size=UDim2.fromOffset(210, 65),
    BackgroundColor3=C.panelTop,
    BorderSizePixel=0,
    Visible=false,
    ZIndex=30,
    Active=true,
}, screenGui)
corner(minimizedBar, 18)
stroke(minimizedBar, C.edge, 2, 0.05)
make("UIGradient", { Rotation=90, Color=ColorSequence.new({ ColorSequenceKeypoint.new(0,C.panelTop), ColorSequenceKeypoint.new(1,C.panelBot) }) }, minimizedBar)

-- Boton STAR (logo) para ABRIR menu
local starBtn = make("ImageButton", {
    Name="StarBtn",
    Position=UDim2.fromScale(0.05,0.12),
    Size=UDim2.fromScale(0.26,0.76),
    BackgroundColor3=C.field,
    BorderSizePixel=0,
    AutoButtonColor=false,
    ZIndex=31,
}, minimizedBar)
corner(starBtn, 12)
stroke(starBtn, C.fieldEdge, 1, 0.2)

local starImg = make("ImageLabel", {
    BackgroundTransparency=1,
    Position=UDim2.fromScale(0.15,0.15),
    Size=UDim2.fromScale(0.70,0.70),
    Image="rbxassetid://77864604756347",
    ScaleType=Enum.ScaleType.Fit,
    ZIndex=32,
}, starBtn)

-- Boton START en modo minimizado (el que pediste)
local miniStartBtn = make("TextButton", {
    Name="MiniStartBtn",
    Position=UDim2.fromScale(0.36,0.12),
    Size=UDim2.fromScale(0.59,0.76),
    BackgroundColor3=C.green,
    BorderSizePixel=0,
    AutoButtonColor=false,
    Font=Enum.Font.GothamBold,
    Text="START",
    TextColor3=C.white,
    TextScaled=true,
    ZIndex=31,
}, minimizedBar)
corner(miniStartBtn, 12)
local miniStartOutline = stroke(miniStartBtn, C.red, 2, 0)
make("UITextSizeConstraint", { MinTextSize=12, MaxTextSize=16 }, miniStartBtn)

-- ── PAINT HELPERS ──
local function paintRunning()
    tween(startBtn, { BackgroundColor3=C.stop }, 0.15)
    startBtn.Text="STOP"
    tween(startOutline, { Transparency=0 }, 0.15)
    tween(miniStartBtn, { BackgroundColor3=C.stop }, 0.15)
    miniStartBtn.Text="STOP"
    tween(miniStartOutline, { Transparency=0 }, 0.15)
end
local function paintIdle()
    tween(startBtn, { BackgroundColor3=C.green }, 0.15)
    startBtn.Text="START"
    tween(startOutline, { Transparency=1 }, 0.15)
    tween(miniStartBtn, { BackgroundColor3=C.green }, 0.15)
    miniStartBtn.Text="START"
    tween(miniStartOutline, { Transparency=1 }, 0.15)
end

-- ── LAGGER ENGINE ──
local function startLagging()
    if lagging then return end
    if not Event then warn("[Luck.packet] Event not found — check Packages.Net[230]") return end
    intensity=clampIntensity(powerBox.Text)
    powerBox.Text=tostring(intensity)
    lagging=true
    paintRunning()
    local payload=table.create(intensity, function() end)
    lagThread=task.spawn(function()
        while lagging do
            for _=1,3 do pcall(function() Event:FireServer(payload) end) end
            task.wait(0.01)
        end
    end)
end
local function stopLagging()
    if not lagging then return end
    lagging=false
    if lagThread then pcall(task.cancel, lagThread) lagThread=nil end
    paintIdle()
end
local function toggle() if lagging then stopLagging() else startLagging() end end

-- ── MINIMIZE LOGIC ──
local function clampOffset(ox, oy)
    local cam=Workspace.CurrentCamera
    if not cam then return ox, oy end
    local vp=cam.ViewportSize
    local hw, hh
    if minimizedBar.Visible then hw=minimizedBar.AbsoluteSize.X/2 hh=minimizedBar.AbsoluteSize.Y/2
    else hw=panel.AbsoluteSize.X/2 hh=panel.AbsoluteSize.Y/2 end
    return math.clamp(ox, -vp.X/2+hw, vp.X/2-hw), math.clamp(oy, -vp.Y/2+hh, vp.Y/2-hh)
end

local function setMinimized(state)
    isMinimized=state
    if state then
        panel.Visible=false
        minimizedBar.Position=panel.Position
        minimizedBar.Visible=true
        minimizedBar.Size=UDim2.fromOffset(0,0)
        tween(minimizedBar, { Size=UDim2.fromOffset(210,65) }, 0.25)
    else
        minimizedBar.Visible=false
        panel.Position=minimizedBar.Position
        panel.Visible=true
        saveConfig(panel)
    end
end

minBtn.Activated:Connect(function() setMinimized(true) end)
starBtn.Activated:Connect(function() setMinimized(false) end)
-- el START minimizado hace la misma funcion que el START grande
miniStartBtn.Activated:Connect(toggle)
startBtn.Activated:Connect(toggle)

-- drag para minimizedBar
local dragging, dragStart, panelStart, dragInput=false,nil,nil,nil
local function beginDrag(input, targetPos)
    dragging=true; dragStart=input.Position; panelStart=targetPos; dragInput=input
    input.Changed:Connect(function()
        if input.UserInputState==Enum.UserInputState.End then dragging=false; dragInput=nil
            if minimizedBar.Visible then saveConfig(minimizedBar) else saveConfig(panel) end
        end
    end)
end

dragHandle.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        beginDrag(input, panel.Position)
    end
end)
minimizedBar.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        beginDrag(input, minimizedBar.Position)
    end
end)

dragHandle.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
end)
minimizedBar.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging or not dragStart then return end
    local isMM=input.UserInputType==Enum.UserInputType.MouseMovement
    local isT=dragInput and input==dragInput
    if not isMM and not isT then return end
    local d=input.Position-dragStart
    local ox=panelStart.X.Offset+d.X
    local oy=panelStart.Y.Offset+d.Y
    ox, oy=clampOffset(ox, oy)
    local newPos=UDim2.new(0.5, ox, 0.5, oy)
    if minimizedBar.Visible then minimizedBar.Position=newPos else panel.Position=newPos end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false; dragInput=nil end
end)

-- ── CONNECTIONS ──
powerBox.FocusLost:Connect(function()
    intensity=clampIntensity(powerBox.Text); powerBox.Text=tostring(intensity); saveConfig(panel)
end)

local waitingForKey=false
keyBtn.Activated:Connect(function()
    if waitingForKey then return end
    waitingForKey=true; keyBtn.Text="[PRESS KEY]"; keyBtn.TextColor3=C.green
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if waitingForKey then
        if input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode~=Enum.KeyCode.Unknown and input.KeyCode~=Enum.KeyCode.Escape then
            toggleKey=input.KeyCode; toggleKeyName=toggleKey.Name; keyBtn.Text="["..toggleKeyName.."]"; keyBtn.TextColor3=C.white; waitingForKey=false; saveConfig(panel)
        end
        return
    end
    if input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode==toggleKey then toggle() end
end)

task.defer(function() loadConfig(panel, powerBox, keyBtn) minimizedBar.Position=panel.Position end)
paintIdle()