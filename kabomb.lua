local CoreGui          = game:GetService("CoreGui")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local Workspace        = game:GetService("Workspace")
local RunService       = game:GetService("RunService")
local LP               = Players.LocalPlayer
local UIS              = UserInputService

do
    local old = CoreGui:FindFirstChild("HaramHubUI")
    if old then old:Destroy() end
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then
        local o = pg:FindFirstChild("HaramHubUI")
        if o then o:Destroy() end
    end
end

local function new(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    o.Parent = parent
    return o
end

-- ===================== BACKGROUND =====================
local BG_IMAGES = {
    "rbxassetid://87364879162642",
    "rbxassetid://75072249779643",
    "rbxassetid://116629909559577",
}
local currentBG = nil

-- ===================== STEALTH =====================
local STEALTH = {
    NORMAL = { poison1B = true, block1B = false, blockPhysics = false, blockRecv = false },
    STRONG = { poison1B = true, block1B = true,  blockPhysics = true,  blockRecv = true  },
}
local stealthMode = "NORMAL"
local cfg = STEALTH[stealthMode]

-- ===================== DESYNC =====================
local desyncOn = false
local speed = 30
local basePos = Vector3.zero
local offset = Vector3.zero
local root, hum
local hb, rs, step
local savedWS = 16
local ghostFolder
local syncing = false

local function worldPos()
    local y = (root and root.Position.Y) or basePos.Y
    return Vector3.new(basePos.X + offset.X, y, basePos.Z + offset.Z)
end

local function clearGhost()
    if ghostFolder then pcall(function() ghostFolder:Destroy() end) end
    ghostFolder = nil
end

local function updateGhost()
    clearGhost()
    local f = Instance.new("Folder")
    f.Name = "_CalciumGhost"
    f.Parent = workspace

    local p = Instance.new("Part")
    p.Anchored = true
    p.CanCollide = false
    p.CanQuery = false
    p.CanTouch = false
    p.Size = Vector3.new(2.4, 5.4, 2.4)
    p.Transparency = 0.55
    p.Color = Color3.fromRGB(160, 20, 20)
    p.Material = Enum.Material.SmoothPlastic
    p.CFrame = CFrame.new(basePos)
    p.Parent = f

    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.fromOffset(140, 28)
    bb.StudsOffset = Vector3.new(0, 3.4, 0)
    bb.AlwaysOnTop = true
    bb.Parent = p

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 1
    lbl.Text = "WHAT THEY SEE"
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextColor3 = Color3.fromRGB(255, 70, 70)
    lbl.TextStrokeTransparency = 0.4
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.Parent = bb

    ghostFolder = f
end

local function zeroVel(r)
    if not r then return end
    pcall(function()
        local y = r.AssemblyLinearVelocity.Y
        r.AssemblyLinearVelocity = Vector3.new(0, y, 0)
        r.Velocity = Vector3.new(0, y, 0)
        r.AssemblyAngularVelocity = Vector3.zero
        r.RotVelocity = Vector3.zero
    end)
end

local function hardSet(r, pos)
    if not r then return end
    r.CFrame = CFrame.new(pos)
    zeroVel(r)
end

local function assertReal()
    if not root or syncing then return end
    hardSet(root, worldPos())
end

local function preferClient(r)
    if not r then return end
    pcall(function() r:SetNetworkOwner(LP) end)
    if typeof(sethiddenproperty) == "function" then
        pcall(function() sethiddenproperty(r, "PhysicsRepRootPart", r) end)
    end
end

local function getDir()
    if hum and hum.MoveDirection.Magnitude > 0.05 then
        local md = hum.MoveDirection
        return Vector3.new(md.X, 0, md.Z).Unit
    end
    local cam = workspace.CurrentCamera
    local look = cam and cam.CFrame.LookVector or Vector3.new(0, 0, -1)
    local right = cam and cam.CFrame.RightVector or Vector3.new(1, 0, 0)
    look = Vector3.new(look.X, 0, look.Z)
    right = Vector3.new(right.X, 0, right.Z)
    if look.Magnitude > 1e-3 then look = look.Unit end
    if right.Magnitude > 1e-3 then right = right.Unit end
    local d = Vector3.zero
    if UIS:IsKeyDown(Enum.KeyCode.W) then d += look end
    if UIS:IsKeyDown(Enum.KeyCode.S) then d -= look end
    if UIS:IsKeyDown(Enum.KeyCode.A) then d -= right end
    if UIS:IsKeyDown(Enum.KeyCode.D) then d += right end
    if d.Magnitude > 1e-3 then return d.Unit end
    return Vector3.zero
end

local function bind(char)
    if not char then return end
    root = char:FindFirstChild("HumanoidRootPart")
    hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    savedWS = (hum.WalkSpeed > 1 and hum.WalkSpeed) or 16
    basePos = root.Position
    offset = Vector3.zero
    hum.WalkSpeed = 0
    hum.AutoRotate = false
    preferClient(root)
    zeroVel(root)
    updateGhost()
end

local function startDesync()
    if desyncOn then return end
    desyncOn = true
    bind(LP.Character)
    preferClient(root)
    print("[HARAM HUB] Desync ON |", stealthMode)

    if hb then hb:Disconnect() end
    if rs then rs:Disconnect() end
    if step then step:Disconnect() end

    hb = RunService.Heartbeat:Connect(function(dt)
        if not desyncOn or syncing then return end
        if not root or not root.Parent or not hum or not hum.Parent then
            bind(LP.Character)
            preferClient(root)
            return
        end
        local dir = getDir()
        if dir.Magnitude > 0 then
            offset = offset + dir * (speed * dt)
        end
        assertReal()
        preferClient(root)
        if hum.PlatformStand then hum.PlatformStand = false end
        local st = hum:GetState()
        if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        end
        hum.WalkSpeed = 0
    end)

    rs = RunService.RenderStepped:Connect(function()
        if not desyncOn or syncing or not root then return end
        assertReal()
    end)

    step = RunService.Stepped:Connect(function()
        if not desyncOn or syncing or not root then return end
        zeroVel(root)
        assertReal()
        if hum then hum.WalkSpeed = 0 end
    end)
end

local function stopDesync()
    if not desyncOn then return end
    syncing = true
    local r = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if r then
        local target = worldPos()
        preferClient(r)
        for _ = 1, 3 do
            hardSet(r, target)
            RunService.Heartbeat:Wait()
        end
    end
    desyncOn = false
    syncing = false
    if hb then hb:Disconnect() hb = nil end
    if rs then rs:Disconnect() rs = nil end
    if step then step:Disconnect() step = nil end
    if hum then
        hum.WalkSpeed = savedWS
        hum.AutoRotate = true
    end
    offset = Vector3.zero
    clearGhost()
    print("[HARAM HUB] Desync OFF")
end

LP.CharacterAdded:Connect(function(c)
    task.wait(0.25)
    if desyncOn then
        bind(c)
        preferClient(root)
    end
end)

-- ===================== COLORS =====================
local ACCENT       = Color3.fromRGB(190, 40, 50)
local ACCENT_GLOW  = Color3.fromRGB(255, 70, 80)
local GREEN_ON     = Color3.fromRGB(90, 210, 110)
local GREEN_GLOW   = Color3.fromRGB(130, 255, 150)
local OFF_COL      = Color3.fromRGB(28, 28, 32)
local BG_DARK      = Color3.fromRGB(12, 10, 14)
local TEXT_MAIN    = Color3.fromRGB(235, 235, 235)
local TEXT_DIM     = Color3.fromRGB(160, 160, 165)

local gui = new("ScreenGui", {
    Name           = "HaramHubUI",
    DisplayOrder   = 999,
    ResetOnSpawn   = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, CoreGui)

local mainScale = new("UIScale", { Scale = 1 }, gui)

-- ===================== MAIN (small + top left) =====================
local main = new("Frame", {
    Name                   = "Main",
    Active                 = true,
    ClipsDescendants       = true,
    BackgroundTransparency = 0,
    BackgroundColor3       = BG_DARK,
    BorderSizePixel        = 0,
    Position               = UDim2.new(0, 18, 0, 70),
    Size                   = UDim2.new(0, 210, 0, 138),
    Visible                = true,
}, gui)

new("UICorner", { CornerRadius = UDim.new(0, 8) }, main)

local mainStroke = new("UIStroke", {
    Thickness       = 1.2,
    Transparency    = 0.35,
    Color           = Color3.fromRGB(80, 30, 35),
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
}, main)

local mainBG = new("ImageLabel", {
    Name                   = "BackgroundImage",
    BackgroundTransparency = 1,
    BorderSizePixel        = 0,
    Size                   = UDim2.new(1, 0, 1, 0),
    Image                  = "",
    ImageTransparency      = 0,
    ScaleType              = Enum.ScaleType.Crop,
    ZIndex                 = 1,
    Visible                = false,
}, main)
new("UICorner", { CornerRadius = UDim.new(0, 8) }, mainBG)

local mainBGOverlay = new("Frame", {
    Name                   = "BackgroundOverlay",
    BackgroundColor3       = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.5,
    BorderSizePixel        = 0,
    Size                   = UDim2.new(1, 0, 1, 0),
    ZIndex                 = 2,
    Visible                = false,
}, main)
new("UICorner", { CornerRadius = UDim.new(0, 8) }, mainBGOverlay)

-- title bar
local titleBar = new("Frame", {
    Name                   = "TitleBar",
    BackgroundColor3       = Color3.fromRGB(18, 14, 18),
    BackgroundTransparency = 0,
    BorderSizePixel        = 0,
    Size                   = UDim2.new(1, 0, 0, 28),
    ZIndex                 = 5,
}, main)
new("UICorner", { CornerRadius = UDim.new(0, 8) }, titleBar)

-- cover bottom corners of titlebar
new("Frame", {
    BackgroundColor3 = Color3.fromRGB(18, 14, 18),
    BorderSizePixel  = 0,
    Position         = UDim2.new(0, 0, 1, -8),
    Size             = UDim2.new(1, 0, 0, 8),
    ZIndex           = 5,
}, titleBar)

new("TextLabel", {
    Name                   = "Title",
    Text                   = "HARAM HUB",
    TextColor3             = ACCENT_GLOW,
    Font                   = Enum.Font.GothamBlack,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 10, 0, 0),
    Size                   = UDim2.new(1, -70, 1, 0),
    TextXAlignment         = Enum.TextXAlignment.Left,
    TextSize               = 13,
    ZIndex                 = 6,
}, titleBar)

-- close
local closeBtn = new("TextButton", {
    Name                   = "Close",
    Text                   = "×",
    TextColor3             = Color3.fromRGB(200, 80, 80),
    Font                   = Enum.Font.GothamBold,
    TextSize               = 18,
    BackgroundTransparency = 1,
    Position               = UDim2.new(1, -26, 0, 2),
    Size                   = UDim2.new(0, 22, 0, 24),
    ZIndex                 = 7,
}, titleBar)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(255, 60, 60) }):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(200, 80, 80) }):Play()
end)
closeBtn.MouseButton1Click:Connect(function()
    pcall(stopDesync)
    if gui then gui:Destroy() end
end)

-- lock
local isLocked = false
local lockBtn = new("TextButton", {
    Name                   = "Lock",
    Text                   = "🔓",
    TextColor3             = TEXT_DIM,
    Font                   = Enum.Font.GothamBold,
    TextSize               = 12,
    BackgroundTransparency = 1,
    Position               = UDim2.new(1, -48, 0, 3),
    Size                   = UDim2.new(0, 20, 0, 22),
    ZIndex                 = 7,
}, titleBar)

lockBtn.MouseButton1Click:Connect(function()
    isLocked = not isLocked
    lockBtn.Text = isLocked and "🔒" or "🔓"
    lockBtn.TextColor3 = isLocked and Color3.fromRGB(255, 200, 80) or TEXT_DIM
end)

-- settings gear (simple)
local settingsBtn = new("TextButton", {
    Name                   = "Settings",
    Text                   = "⚙",
    TextColor3             = TEXT_DIM,
    Font                   = Enum.Font.GothamBold,
    TextSize               = 13,
    BackgroundTransparency = 1,
    Position               = UDim2.new(1, -70, 0, 3),
    Size                   = UDim2.new(0, 20, 0, 22),
    ZIndex                 = 7,
}, titleBar)

-- content
local content = new("Frame", {
    Name                   = "Content",
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 0, 0, 30),
    Size                   = UDim2.new(1, 0, 1, -30),
    ZIndex                 = 4,
}, main)

-- desync row
new("TextLabel", {
    Text                   = "Desync",
    TextColor3             = TEXT_MAIN,
    Font                   = Enum.Font.GothamBold,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 12, 0, 10),
    Size                   = UDim2.new(0.5, 0, 0, 16),
    TextSize               = 12,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 5,
}, content)

local dsSub = new("TextLabel", {
    Text                   = "OFF",
    TextColor3             = TEXT_DIM,
    Font                   = Enum.Font.Gotham,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 12, 0, 26),
    Size                   = UDim2.new(0.5, 0, 0, 14),
    TextSize               = 10,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 5,
}, content)

local dsTrack = new("Frame", {
    AnchorPoint      = Vector2.new(1, 0.5),
    BackgroundColor3 = OFF_COL,
    Position         = UDim2.new(1, -12, 0, 24),
    Size             = UDim2.new(0, 40, 0, 20),
    BorderSizePixel  = 0,
    ZIndex           = 5,
}, content)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, dsTrack)

local dsKnob = new("Frame", {
    Size             = UDim2.new(0, 14, 0, 14),
    Position         = UDim2.new(0, 3, 0.5, -7),
    BackgroundColor3 = Color3.fromRGB(220, 220, 220),
    BorderSizePixel  = 0,
    ZIndex           = 6,
}, dsTrack)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, dsKnob)

local dsHit = new("TextButton", {
    Size                   = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text                   = "",
    ZIndex                 = 7,
}, dsTrack)

-- size slider
new("TextLabel", {
    Text                   = "Size",
    TextColor3             = TEXT_MAIN,
    Font                   = Enum.Font.GothamBold,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 12, 0, 52),
    Size                   = UDim2.new(0.4, 0, 0, 14),
    TextSize               = 11,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 5,
}, content)

local sizeVal = new("TextLabel", {
    Text                   = "100%",
    TextColor3             = TEXT_DIM,
    Font                   = Enum.Font.Gotham,
    BackgroundTransparency = 1,
    Position               = UDim2.new(1, -48, 0, 52),
    Size                   = UDim2.new(0, 36, 0, 14),
    TextSize               = 10,
    TextXAlignment         = Enum.TextXAlignment.Right,
    ZIndex                 = 5,
}, content)

local sliderTrack = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
    BorderSizePixel  = 0,
    Position         = UDim2.new(0, 12, 0, 72),
    Size             = UDim2.new(1, -24, 0, 4),
    ZIndex           = 5,
}, content)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, sliderTrack)

local sliderFill = new("Frame", {
    BackgroundColor3 = ACCENT,
    BorderSizePixel  = 0,
    Size             = UDim2.new(1, 0, 1, 0),
    ZIndex           = 6,
}, sliderTrack)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, sliderFill)

local sliderKnob = new("Frame", {
    Size             = UDim2.new(0, 11, 0, 11),
    Position         = UDim2.new(1, -5.5, 0.5, -5.5),
    BackgroundColor3 = Color3.fromRGB(240, 240, 240),
    BorderSizePixel  = 0,
    ZIndex           = 7,
}, sliderTrack)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, sliderKnob)

local sliderHit = new("TextButton", {
    Size                   = UDim2.new(1, 0, 1, 12),
    Position               = UDim2.new(0, 0, 0.5, -6),
    BackgroundTransparency = 1,
    Text                   = "",
    ZIndex                 = 8,
}, sliderTrack)

-- stealth mini
new("TextLabel", {
    Text                   = "Stealth",
    TextColor3             = TEXT_MAIN,
    Font                   = Enum.Font.GothamBold,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 12, 0, 90),
    Size                   = UDim2.new(0.4, 0, 0, 14),
    TextSize               = 11,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 5,
}, content)

local stealthSub = new("TextLabel", {
    Text                   = "NORMAL",
    TextColor3             = TEXT_DIM,
    Font                   = Enum.Font.Gotham,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 70, 0, 90),
    Size                   = UDim2.new(0.35, 0, 0, 14),
    TextSize               = 10,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 5,
}, content)

local stealthTrack = new("Frame", {
    AnchorPoint      = Vector2.new(1, 0.5),
    BackgroundColor3 = OFF_COL,
    Position         = UDim2.new(1, -12, 0, 97),
    Size             = UDim2.new(0, 40, 0, 18),
    BorderSizePixel  = 0,
    ZIndex           = 5,
}, content)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, stealthTrack)

local stealthKnob = new("Frame", {
    Size             = UDim2.new(0, 12, 0, 12),
    Position         = UDim2.new(0, 3, 0.5, -6),
    BackgroundColor3 = Color3.fromRGB(200, 200, 200),
    BorderSizePixel  = 0,
    ZIndex           = 6,
}, stealthTrack)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, stealthKnob)

local stealthHit = new("TextButton", {
    Size                   = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text                   = "",
    ZIndex                 = 7,
}, stealthTrack)

-- ===================== SETTINGS PANEL =====================
local settingsFrame = new("Frame", {
    Name                   = "Settings",
    Active                 = true,
    ClipsDescendants       = true,
    BackgroundColor3       = BG_DARK,
    BorderSizePixel        = 0,
    Position               = UDim2.new(0, 18, 0, 70),
    Size                   = UDim2.new(0, 210, 0, 138),
    Visible                = false,
}, gui)
new("UICorner", { CornerRadius = UDim.new(0, 8) }, settingsFrame)
new("UIStroke", {
    Thickness = 1.2, Transparency = 0.35, Color = Color3.fromRGB(80, 30, 35),
}, settingsFrame)

local sTitleBar = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(18, 14, 18),
    BorderSizePixel  = 0,
    Size             = UDim2.new(1, 0, 0, 28),
    ZIndex           = 5,
}, settingsFrame)
new("UICorner", { CornerRadius = UDim.new(0, 8) }, sTitleBar)
new("Frame", {
    BackgroundColor3 = Color3.fromRGB(18, 14, 18),
    BorderSizePixel  = 0,
    Position         = UDim2.new(0, 0, 1, -8),
    Size             = UDim2.new(1, 0, 0, 8),
    ZIndex           = 5,
}, sTitleBar)

new("TextLabel", {
    Text                   = "SETTINGS",
    TextColor3             = ACCENT_GLOW,
    Font                   = Enum.Font.GothamBlack,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 10, 0, 0),
    Size                   = UDim2.new(1, -40, 1, 0),
    TextXAlignment         = Enum.TextXAlignment.Left,
    TextSize               = 13,
    ZIndex                 = 6,
}, sTitleBar)

local backBtn = new("TextButton", {
    Text                   = "←",
    TextColor3             = TEXT_DIM,
    Font                   = Enum.Font.GothamBold,
    TextSize               = 16,
    BackgroundTransparency = 1,
    Position               = UDim2.new(1, -28, 0, 2),
    Size                   = UDim2.new(0, 24, 0, 24),
    ZIndex                 = 7,
}, sTitleBar)

backBtn.MouseButton1Click:Connect(function()
    main.Position = settingsFrame.Position
    settingsFrame.Visible = false
    main.Visible = true
end)

new("TextLabel", {
    Text                   = "nothing else here yet",
    TextColor3             = TEXT_DIM,
    Font                   = Enum.Font.Gotham,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 0, 0.5, -10),
    Size                   = UDim2.new(1, 0, 0, 20),
    TextSize               = 11,
    TextXAlignment         = Enum.TextXAlignment.Center,
    ZIndex                 = 5,
}, settingsFrame)

-- ===================== LOGIC =====================
local function refreshStealth()
    local strong = stealthMode == "STRONG"
    stealthSub.Text = strong and "STRONG" or "NORMAL"
    stealthSub.TextColor3 = strong and ACCENT_GLOW or TEXT_DIM
    TweenService:Create(stealthKnob, TweenInfo.new(0.2), {
        Position = strong and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    }):Play()
    TweenService:Create(stealthTrack, TweenInfo.new(0.25), {
        BackgroundColor3 = strong and Color3.fromRGB(90, 25, 30) or OFF_COL
    }):Play()
    cfg = STEALTH[stealthMode]
end

stealthHit.MouseButton1Click:Connect(function()
    stealthMode = stealthMode == "NORMAL" and "STRONG" or "NORMAL"
    refreshStealth()
    print("[HARAM HUB] Stealth:", stealthMode)
end)
refreshStealth()

dsHit.MouseButton1Click:Connect(function()
    local on = not desyncOn
    TweenService:Create(dsKnob, TweenInfo.new(0.2), {
        Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    }):Play()
    TweenService:Create(dsTrack, TweenInfo.new(0.25), {
        BackgroundColor3 = on and GREEN_ON or OFF_COL
    }):Play()
    dsSub.Text = on and "ACTIVE" or "OFF"
    dsSub.TextColor3 = on and GREEN_GLOW or TEXT_DIM
    if on then
        task.spawn(function()
            local ok, err = pcall(startDesync)
            if not ok then warn("[HARAM HUB]", err) end
        end)
    else
        task.spawn(function() pcall(stopDesync) end)
    end
end)

-- slider
local sliding = false
local slideConn

local function setScale(s)
    s = math.clamp(s, 0.6, 1.4)
    mainScale.Scale = s
    sizeVal.Text = math.round(s * 100) .. "%"
    local p = (s - 0.6) / 0.8
    sliderFill.Size = UDim2.new(p, 0, 1, 0)
    sliderKnob.Position = UDim2.new(p, -5.5, 0.5, -5.5)
end

local function onSlide(input)
    local abs = sliderTrack.AbsoluteSize.X
    if abs <= 0 then return end
    local rel = (input.Position.X - sliderTrack.AbsolutePosition.X) / abs
    setScale(0.6 + math.clamp(rel, 0, 1) * 0.8)
end

sliderHit.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
        onSlide(input)
        if slideConn then slideConn:Disconnect() end
        slideConn = UIS.InputChanged:Connect(function(i)
            if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                onSlide(i)
            end
        end)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliding = false
        if slideConn then slideConn:Disconnect() slideConn = nil end
    end
end)

setScale(1)

settingsBtn.MouseButton1Click:Connect(function()
    settingsFrame.Position = main.Position
    main.Visible = false
    settingsFrame.Visible = true
end)

-- drag
local dragging, dragStart, startPos = false, nil, nil

main.InputBegan:Connect(function(input)
    if isLocked then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if isLocked or not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- settings drag
local sDrag, sStart, sPos = false, nil, nil
settingsFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sDrag = true
        sStart = input.Position
        sPos = settingsFrame.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if not sDrag then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local d = input.Position - sStart
        settingsFrame.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sDrag = false
    end
end)