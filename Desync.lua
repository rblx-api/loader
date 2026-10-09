local CoreGui          = game:GetService("CoreGui")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local Workspace        = game:GetService("Workspace")
local RunService       = game:GetService("RunService")
local LP               = Players.LocalPlayer
local UIS              = UserInputService

do
    local old = CoreGui:FindFirstChild("LevithonDesyncUI")
    if old then old:Destroy() end
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then
        local o = pg:FindFirstChild("LevithonDesyncUI")
        if o then o:Destroy() end
    end
    local bb = Workspace:FindFirstChild("073_Deobf_BB")
    if bb then bb:Destroy() end
end

local function new(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    o.Parent = parent
    return o
end

local BG_IMAGES = {
    "rbxassetid://87364879162642",
    "rbxassetid://75072249779643",
    "rbxassetid://116629909559577",
}
local currentBG = nil

local STEALTH = {
    NORMAL = {
        poison1B     = true,
        block1B      = false,
        blockPhysics = false,
        blockRecv    = false,
    },
    STRONG = {
        poison1B     = true,
        block1B      = true,
        blockPhysics = true,
        blockRecv    = true,
    },
}
local stealthMode = "NORMAL"
local cfg = STEALTH[stealthMode]

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
    p.Transparency = 0.5
    p.Color = Color3.fromRGB(139, 0, 0)
    p.Material = Enum.Material.SmoothPlastic
    p.CFrame = CFrame.new(basePos)
    p.Parent = f

    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.fromOffset(180, 36)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.AlwaysOnTop = true
    bb.Parent = p

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 1
    lbl.Text = "WHAT PLAYERS SEE"
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextColor3 = Color3.fromRGB(255, 80, 80)
    lbl.TextStrokeTransparency = 0.5
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

local function rebaseGhost()
    if not root then return end
    local p = root.Position
    basePos = Vector3.new(p.X, p.Y, p.Z)
    offset = Vector3.zero
    updateGhost()
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
    print("prince")

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
    print("prince")
end

LP.CharacterAdded:Connect(function(c)
    task.wait(0.25)
    if desyncOn then
        bind(c)
        preferClient(root)
    end
end)

local antiDieOn = false
local heartConn = nil
local deathConns = {}
local charAddedConn = nil

local function protectChar(char)
    if not char then return end
    local h = char:WaitForChild("Humanoid", 5)
    if not h then return end

    h.MaxHealth = math.huge
    h.Health = math.huge

    local sc = h.StateChanged:Connect(function(_, newState)
        if not antiDieOn then return end
        if newState == Enum.HumanoidStateType.Dead then
            h.Health = math.huge
            h:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end
    end)
    table.insert(deathConns, sc)

    h:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

    local hc = h:GetPropertyChangedSignal("Health"):Connect(function()
        if not antiDieOn then return end
        if h.Health < h.MaxHealth then h.Health = math.huge end
    end)
    table.insert(deathConns, hc)

    if heartConn then heartConn:Disconnect() end
    heartConn = RunService.Heartbeat:Connect(function()
        if not antiDieOn then return end
        if h and h.Parent and h.Health < h.MaxHealth then h.Health = math.huge end
    end)
end

local function startAntiDie()
    if antiDieOn then return end
    antiDieOn = true

    for _, c in ipairs(deathConns) do pcall(function() c:Disconnect() end) end
    deathConns = {}
    if heartConn then heartConn:Disconnect(); heartConn = nil end
    if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end

    protectChar(LP.Character)

    charAddedConn = LP.CharacterAdded:Connect(function(c)
        if not antiDieOn then return end
        task.wait(0.1)
        for _, c2 in ipairs(deathConns) do pcall(function() c2:Disconnect() end) end
        deathConns = {}
        protectChar(c)
    end)

    print("prince")
end

local function stopAntiDie()
    if not antiDieOn then return end
    antiDieOn = false

    for _, c in ipairs(deathConns) do pcall(function() c:Disconnect() end) end
    deathConns = {}
    if heartConn then heartConn:Disconnect(); heartConn = nil end
    if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end

    local char = LP.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then
            h:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            h.MaxHealth = 100
            h.Health = 100
        end
    end
    print("prince")
end

local antiResetOn = false
local arHeartConn = nil
local arCharAddedConn = nil
local arDescConns = {}

local function stripRag(char)
    if not char then return end
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BallSocketConstraint") or v:IsA("RagdollConstraint")
            or v:IsA("NoCollisionConstraint")
            or (type(v.Name) == "string" and v.Name:find("Ragdoll")) then
            pcall(function() v:Destroy() end)
        end
    end
end

local function applyAntiRag(char)
    local h = char and char:FindFirstChildOfClass("Humanoid")
    if not h then return end
    pcall(function()
        h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        h:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        h:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
    end)
    h.PlatformStand = false
    h.Sit = false
    stripRag(char)
end

local function hookAntiReset(char)
    if not char then return end
    applyAntiRag(char)

    local conn = char.DescendantAdded:Connect(function(v)
        if not antiResetOn then return end
        if v:IsA("BallSocketConstraint") or (type(v.Name) == "string" and v.Name:find("Ragdoll")) then
            task.defer(function() pcall(function() v:Destroy() end) end)
        end
    end)
    table.insert(arDescConns, conn)
end

local function startAntiReset()
    if antiResetOn then return end
    antiResetOn = true

    for _, c in ipairs(arDescConns) do pcall(function() c:Disconnect() end) end
    arDescConns = {}
    if arHeartConn then arHeartConn:Disconnect(); arHeartConn = nil end
    if arCharAddedConn then arCharAddedConn:Disconnect(); arCharAddedConn = nil end

    if LP.Character then hookAntiReset(LP.Character) end

    arCharAddedConn = LP.CharacterAdded:Connect(function(c)
        if not antiResetOn then return end
        task.wait(0.12)
        for _, c2 in ipairs(arDescConns) do pcall(function() c2:Disconnect() end) end
        arDescConns = {}
        hookAntiReset(c)
    end)

    arHeartConn = RunService.Heartbeat:Connect(function()
        if not antiResetOn then return end
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if not h then return end
        if h.PlatformStand then h.PlatformStand = false end
        local st = h:GetState()
        if st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
            or st == Enum.HumanoidStateType.Physics then
            pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end)
        end
    end)
    print("prince")
end

local function stopAntiReset()
    if not antiResetOn then return end
    antiResetOn = false

    for _, c in ipairs(arDescConns) do pcall(function() c:Disconnect() end) end
    arDescConns = {}
    if arHeartConn then arHeartConn:Disconnect(); arHeartConn = nil end
    if arCharAddedConn then arCharAddedConn:Disconnect(); arCharAddedConn = nil end
    print("prince")
end

-- Colores
local GREEN_ENABLED = Color3.fromRGB(120, 220, 130)
local GREEN_GLOW    = Color3.fromRGB(150, 255, 160)
local OFF_COLOR     = Color3.fromRGB(40, 40, 40)
local LOCK_OFF_BG   = Color3.fromRGB(60, 60, 60)
local STRONG_COLOR  = Color3.fromRGB(90, 40, 50)

local BG_IMAGE_TRANSPARENCY = 0.0
local BG_OVERLAY_TRANSPARENCY = 0.45
local BG_RESAMPLE = Enum.ResamplerMode.Default

local parentGui = (LP:FindFirstChild("PlayerGui")) or CoreGui

local gui = new("ScreenGui", {
    Name           = "LevithonDesyncUI",
    DisplayOrder   = 999,
    ResetOnSpawn   = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, parentGui)

local mainScale = new("UIScale", { Scale = 1 }, gui)

-- ============================================================
-- MAIN FRAME
-- ============================================================
local main = new("Frame", {
    Name                   = "Main",
    Active                 = true,
    ClipsDescendants       = true,
    BackgroundTransparency = 0,
    BackgroundColor3       = Color3.fromRGB(10, 4, 16),
    BorderSizePixel        = 0,
    Position               = UDim2.new(0.5, -160, 0.4, 0),
    Size                   = UDim2.new(0, 320, 0, 240),
    Visible                = true,
}, gui)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, main)

local mainBG = new("ImageLabel", {
    Name                   = "BackgroundImage",
    BackgroundTransparency = 1,
    BorderSizePixel        = 0,
    Size                   = UDim2.new(1, 0, 1, 0),
    Position               = UDim2.new(0, 0, 0, 0),
    Image                  = "",
    ImageTransparency      = BG_IMAGE_TRANSPARENCY,
    ResampleMode           = BG_RESAMPLE,
    ScaleType              = Enum.ScaleType.Crop,
    ZIndex                 = 1,
    Visible                = false,
}, main)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, mainBG)

local mainBGOverlay = new("Frame", {
    Name                   = "BackgroundOverlay",
    BackgroundColor3       = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = BG_OVERLAY_TRANSPARENCY,
    BorderSizePixel        = 0,
    Size                   = UDim2.new(1, 0, 1, 0),
    Position               = UDim2.new(0, 0, 0, 0),
    ZIndex                 = 2,
    Visible                = false,
}, main)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, mainBGOverlay)
new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 10, 50)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(0, 0, 0)),
    }),
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.2),
        NumberSequenceKeypoint.new(0.5, 0.05),
        NumberSequenceKeypoint.new(1,   0.2),
    }),
    Rotation = 90,
}, mainBGOverlay)

local stroke = new("UIStroke", {
    Thickness       = 1.8,
    Transparency    = 0.15,
    Color           = Color3.fromRGB(255, 255, 255),
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
}, main)

local grad = new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(200, 200, 200)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(255, 255, 255)),
    }),
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.3),
        NumberSequenceKeypoint.new(0.5, 0.7),
        NumberSequenceKeypoint.new(1,   0.3),
    }),
    Rotation = 0,
}, stroke)

-- Botón Settings (engranaje)
local settingsBtn = new("TextButton", {
    Name                   = "SettingsButton",
    Text                   = "",
    BackgroundColor3       = Color3.fromRGB(35, 35, 45),
    BackgroundTransparency = 1,
    BorderSizePixel        = 0,
    Position               = UDim2.new(0, 8, 0, 8),
    Size                   = UDim2.new(0, 32, 0, 32),
    AutoButtonColor        = false,
    ZIndex                 = 20,
    ClipsDescendants       = true,
}, main)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, settingsBtn)

local gearIcon = new("Frame", {
    Name                   = "GearIcon",
    BackgroundTransparency = 1,
    AnchorPoint            = Vector2.new(0.5, 0.5),
    Position               = UDim2.new(0.5, 0, 0.5, 0),
    Size                   = UDim2.new(0, 18, 0, 18),
    ZIndex                 = 22,
}, settingsBtn)

for i = 1, 8 do
    local angle = (i - 1) * 45
    local tooth = new("Frame", {
        Name             = "Tooth" .. i,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel  = 0,
        AnchorPoint      = Vector2.new(0.5, 0.5),
        Position         = UDim2.new(0.5, 0, 0.5, 0),
        Size             = UDim2.new(0, 4, 0, 18),
        Rotation         = angle,
        ZIndex           = 22,
    }, gearIcon)
    new("UICorner", { CornerRadius = UDim.new(1, 0) }, tooth)
end

local gearOuter = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel  = 0,
    AnchorPoint      = Vector2.new(0.5, 0.5),
    Position         = UDim2.new(0.5, 0, 0.5, 0),
    Size             = UDim2.new(0, 13, 0, 13),
    ZIndex           = 23,
}, gearIcon)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, gearOuter)

local gearCenter = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(30, 30, 45),
    BorderSizePixel  = 0,
    AnchorPoint      = Vector2.new(0.5, 0.5),
    Position         = UDim2.new(0.5, 0, 0.5, 0),
    Size             = UDim2.new(0, 6, 0, 6),
    ZIndex           = 24,
}, gearIcon)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, gearCenter)

local settingsStroke = new("UIStroke", {
    Color        = Color3.fromRGB(255, 255, 255),
    Transparency = 1,
    Thickness    = 0,
}, settingsBtn)

local settingsRotAngle = 0
local settingsHovered = false
local settingsSpinSpeed = 0

task.spawn(function()
    local lastT = tick()
    while settingsBtn and settingsBtn.Parent do
        local now = tick()
        local dt = now - lastT
        lastT = now
        local targetSpin = settingsHovered and 220 or 30
        settingsSpinSpeed = settingsSpinSpeed + (targetSpin - settingsSpinSpeed) * math.min(dt * 6, 1)
        settingsRotAngle = (settingsRotAngle + settingsSpinSpeed * dt) % 360
        if gearIcon then gearIcon.Rotation = (-settingsRotAngle * 0.6) % 360 end
        task.wait(0.016)
    end
end)

settingsBtn.MouseEnter:Connect(function()
    settingsHovered = true
    TweenService:Create(settingsBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(0, 6, 0, 6),
    }):Play()
    TweenService:Create(settingsStroke, TweenInfo.new(0.25), {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0,
        Thickness = 1.6,
    }):Play()
end)

settingsBtn.MouseLeave:Connect(function()
    settingsHovered = false
    TweenService:Create(settingsBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 8, 0, 8),
    }):Play()
    TweenService:Create(settingsStroke, TweenInfo.new(0.25), {
        Transparency = 1,
        Thickness = 0,
    }):Play()
end)

-- ============================================================
-- BOTÓN BACKGROUND (icono paisaje)
-- ============================================================
local bgBtn = new("TextButton", {
    Name                   = "BackgroundButton",
    Text                   = "",
    BackgroundColor3       = Color3.fromRGB(70, 40, 130),
    BackgroundTransparency = 1,
    BorderSizePixel        = 0,
    Position               = UDim2.new(0, 46, 0, 9),
    Size                   = UDim2.new(0, 30, 0, 30),
    AutoButtonColor        = false,
    ZIndex                 = 20,
    ClipsDescendants       = true,
}, main)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, bgBtn)

local bgBtnStroke = new("UIStroke", {
    Color        = Color3.fromRGB(180, 220, 255),
    Transparency = 1,
    Thickness    = 0,
}, bgBtn)

local bgIcon = new("Frame", {
    BackgroundTransparency = 1,
    AnchorPoint            = Vector2.new(0.5, 0.5),
    Position               = UDim2.new(0.5, 0, 0.5, 0),
    Size                   = UDim2.new(0, 18, 0, 16),
    ZIndex                 = 21,
}, bgBtn)

new("Frame", {
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel  = 0,
    Size             = UDim2.new(1, 0, 1, 0),
    ZIndex           = 21,
    Name             = "FrameOutline",
}, bgIcon)
new("UICorner", { CornerRadius = UDim.new(0, 2) }, bgIcon.FrameOutline)

new("Frame", {
    BackgroundColor3 = Color3.fromRGB(30, 30, 45),
    BorderSizePixel  = 0,
    Size             = UDim2.new(1, -3, 1, -3),
    Position         = UDim2.new(0, 1.5, 0, 1.5),
    ZIndex           = 22,
    Name             = "FrameInner",
}, bgIcon)
new("UICorner", { CornerRadius = UDim.new(0, 2) }, bgIcon.FrameInner)

new("Frame", {
    BackgroundColor3 = Color3.fromRGB(255, 230, 120),
    BorderSizePixel  = 0,
    Size             = UDim2.new(0, 5, 0, 5),
    Position         = UDim2.new(0, 3, 0, 3),
    ZIndex           = 23,
    Name             = "Sun",
}, bgIcon)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, bgIcon.Sun)

new("Frame", {
    BackgroundColor3 = Color3.fromRGB(140, 220, 255),
    BorderSizePixel  = 0,
    Rotation         = 45,
    Size             = UDim2.new(0, 11, 0, 11),
    Position         = UDim2.new(0, 4, 0, 6),
    ZIndex           = 23,
    Name             = "Mountain",
}, bgIcon)

bgBtn.MouseEnter:Connect(function()
    TweenService:Create(bgBtn, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 34, 0, 34),
        Position = UDim2.new(0, 44, 0, 7),
    }):Play()
    TweenService:Create(bgBtnStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0,
        Thickness = 1.8,
    }):Play()
end)
bgBtn.MouseLeave:Connect(function()
    TweenService:Create(bgBtn, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 46, 0, 9),
    }):Play()
    TweenService:Create(bgBtnStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(180, 220, 255),
        Transparency = 1,
        Thickness = 0,
    }):Play()
end)

-- ============================================================
-- LOCK BUTTON
-- ============================================================
local isLocked = false

local lockBtn = new("TextButton", {
    Name                   = "LockButton",
    Text                   = "",
    BackgroundColor3       = Color3.fromRGB(70, 60, 20),
    BackgroundTransparency = 1,
    BorderSizePixel        = 0,
    AnchorPoint            = Vector2.new(1, 0),
    Position               = UDim2.new(1, -46, 0, 9),
    Size                   = UDim2.new(0, 30, 0, 30),
    AutoButtonColor        = false,
    ZIndex                 = 20,
    ClipsDescendants       = true,
}, main)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, lockBtn)

local lockText = new("TextLabel", {
    Text                   = "🔓",
    TextColor3             = Color3.fromRGB(255, 255, 255),
    Font                   = Enum.Font.GothamBold,
    TextSize               = 18,
    BackgroundTransparency = 1,
    Size                   = UDim2.new(1, 0, 1, 0),
    TextStrokeTransparency = 0.5,
    TextStrokeColor3       = Color3.fromRGB(120, 90, 20),
    ZIndex                 = 22,
}, lockBtn)

local lockBtnStroke = new("UIStroke", {
    Color        = Color3.fromRGB(255, 235, 170),
    Transparency = 1,
    Thickness    = 0,
}, lockBtn)

lockBtn.MouseEnter:Connect(function()
    TweenService:Create(lockBtn, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 34, 0, 34),
        Position = UDim2.new(1, -48, 0, 7),
    }):Play()
    TweenService:Create(lockBtnStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0,
        Thickness = 1.8,
    }):Play()
end)
lockBtn.MouseLeave:Connect(function()
    TweenService:Create(lockBtn, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -46, 0, 9),
    }):Play()
    TweenService:Create(lockBtnStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(255, 235, 170),
        Transparency = 1,
        Thickness = 0,
    }):Play()
end)

lockBtn.MouseButton1Click:Connect(function()
    isLocked = not isLocked
    if isLocked then
        lockText.Text = "🔒"
        lockText.TextColor3 = Color3.fromRGB(255, 220, 120)
        TweenService:Create(lockBtnStroke, TweenInfo.new(0.3), {
            Color = Color3.fromRGB(255, 245, 200),
            Transparency = 0,
            Thickness = 1.8,
        }):Play()
    else
        lockText.Text = "🔓"
        lockText.TextColor3 = Color3.fromRGB(255, 255, 255)
        TweenService:Create(lockBtnStroke, TweenInfo.new(0.3), {
            Color = Color3.fromRGB(255, 235, 170),
            Transparency = 1,
            Thickness = 0,
        }):Play()
    end
end)

-- ============================================================
-- CLOSE BUTTON
-- ============================================================
local closeBtn = new("TextButton", {
    Name                   = "CloseButton",
    Text                   = "",
    BackgroundColor3       = Color3.fromRGB(160, 40, 40),
    BackgroundTransparency = 1,
    BorderSizePixel        = 0,
    AnchorPoint            = Vector2.new(1, 0),
    Position               = UDim2.new(1, -10, 0, 9),
    Size                   = UDim2.new(0, 30, 0, 30),
    AutoButtonColor        = false,
    ZIndex                 = 20,
    ClipsDescendants       = true,
}, main)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, closeBtn)

local closeStroke = new("UIStroke", {
    Color        = Color3.fromRGB(255, 160, 160),
    Transparency = 1,
    Thickness    = 0,
}, closeBtn)

local closeBar1 = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(255, 90, 90),
    BorderSizePixel  = 0,
    AnchorPoint      = Vector2.new(0.5, 0.5),
    Position         = UDim2.new(0.5, 0, 0.5, 0),
    Size             = UDim2.new(0, 18, 0, 3),
    Rotation         = 45,
    ZIndex           = 21,
}, closeBtn)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, closeBar1)

local closeBar2 = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(255, 90, 90),
    BorderSizePixel  = 0,
    AnchorPoint      = Vector2.new(0.5, 0.5),
    Position         = UDim2.new(0.5, 0, 0.5, 0),
    Size             = UDim2.new(0, 18, 0, 3),
    Rotation         = -45,
    ZIndex           = 21,
}, closeBtn)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, closeBar2)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 34, 0, 34),
        Position = UDim2.new(1, -12, 0, 7),
    }):Play()
    TweenService:Create(closeStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0,
        Thickness = 1.8,
    }):Play()
    TweenService:Create(closeBar1, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
        Rotation = 135, BackgroundColor3 = Color3.fromRGB(255, 60, 60),
    }):Play()
    TweenService:Create(closeBar2, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
        Rotation = 45, BackgroundColor3 = Color3.fromRGB(255, 60, 60),
    }):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -10, 0, 9),
    }):Play()
    TweenService:Create(closeStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(255, 160, 160),
        Transparency = 1,
        Thickness = 0,
    }):Play()
    TweenService:Create(closeBar1, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
        Rotation = 45, BackgroundColor3 = Color3.fromRGB(255, 90, 90),
    }):Play()
    TweenService:Create(closeBar2, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
        Rotation = -45, BackgroundColor3 = Color3.fromRGB(255, 90, 90),
    }):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
    pcall(stopDesync)
    pcall(stopAntiDie)
    pcall(stopAntiReset)
    if gui then gui:Destroy() end
end)

-- Título
new("TextLabel", {
    Text                   = "Levithon Hub",
    TextColor3             = Color3.new(1, 1, 1),
    Font                   = Enum.Font.GothamBlack,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 0, 0, 12),
    TextXAlignment         = Enum.TextXAlignment.Center,
    ZIndex                 = 10,
    TextSize               = 22,
    Size                   = UDim2.new(1, 0, 0, 26),
}, main)

new("Frame", {
    BackgroundColor3       = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.7,
    BorderSizePixel        = 0,
    Position               = UDim2.new(0, 20, 0, 44),
    Size                   = UDim2.new(1, -40, 0, 1),
    ZIndex                 = 10,
}, main)

-- Desync
new("TextLabel", {
    Text                   = "Desync",
    TextColor3             = Color3.fromRGB(255, 255, 255),
    Font                   = Enum.Font.GothamBold,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 16, 0, 60),
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 10,
    TextSize               = 13,
    Size                   = UDim2.new(1, -80, 0, 20),
}, main)

local dsSubLbl = new("TextLabel", {
    Text                   = "OFF",
    TextColor3             = Color3.fromRGB(255, 255, 255),
    Font                   = Enum.Font.GothamBold,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 16, 0, 80),
    TextSize               = 10,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 10,
    Size                   = UDim2.new(1, -80, 0, 16),
}, main)

local dsTrack = new("Frame", {
    AnchorPoint      = Vector2.new(1, 0.5),
    BackgroundColor3 = OFF_COLOR,
    Position         = UDim2.new(1, -14, 0, 74),
    ZIndex           = 10,
    Size             = UDim2.new(0, 48, 0, 26),
    BorderSizePixel  = 0,
}, main)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, dsTrack)
new("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.3, Thickness = 1.2 }, dsTrack)

local dsKnob = new("Frame", {
    Size             = UDim2.new(0, 18, 0, 18),
    Position         = UDim2.new(0, 4, 0.5, -9),
    ZIndex           = 11,
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel  = 0,
}, dsTrack)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, dsKnob)

local dsHit = new("TextButton", {
    Size                   = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text                   = "",
    ZIndex                 = 12,
}, dsTrack)

-- Anti Die
new("TextLabel", {
    Text                   = "Anti Die",
    TextColor3             = Color3.fromRGB(255, 255, 255),
    Font                   = Enum.Font.GothamBold,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 16, 0, 108),
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 10,
    TextSize               = 13,
    Size                   = UDim2.new(1, -80, 0, 20),
}, main)

local adSubLbl = new("TextLabel", {
    Text                   = "OFF",
    TextColor3             = Color3.fromRGB(255, 255, 255),
    Font                   = Enum.Font.GothamBold,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 16, 0, 128),
    TextSize               = 10,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 10,
    Size                   = UDim2.new(1, -80, 0, 16),
}, main)

local adTrack = new("Frame", {
    AnchorPoint      = Vector2.new(1, 0.5),
    BackgroundColor3 = OFF_COLOR,
    Position         = UDim2.new(1, -14, 0, 122),
    ZIndex           = 10,
    Size             = UDim2.new(0, 48, 0, 26),
    BorderSizePixel  = 0,
}, main)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, adTrack)
new("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.3, Thickness = 1.2 }, adTrack)

local adKnob = new("Frame", {
    Size             = UDim2.new(0, 18, 0, 18),
    Position         = UDim2.new(0, 4, 0.5, -9),
    ZIndex           = 11,
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel  = 0,
}, adTrack)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, adKnob)

local adHit = new("TextButton", {
    Size                   = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text                   = "",
    ZIndex                 = 12,
}, adTrack)

-- Slider
local sliderRow = new("Frame", {
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 0, 0, 156),
    Size                   = UDim2.new(1, 0, 0, 30),
    ZIndex                 = 6,
}, main)

new("TextLabel", {
    BackgroundTransparency = 1,
    Text                   = "Menu Size",
    TextColor3             = Color3.fromRGB(255, 255, 255),
    Font                   = Enum.Font.GothamBold,
    Position               = UDim2.new(0, 16, 0, 0),
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 6,
    TextSize               = 12,
    Size                   = UDim2.new(1, -94, 1, 0),
}, sliderRow)

local sliderValue = new("TextLabel", {
    BackgroundTransparency = 1,
    Text                   = "100%",
    TextColor3             = Color3.fromRGB(200, 200, 200),
    Font                   = Enum.Font.GothamBold,
    AnchorPoint            = Vector2.new(1, 0.5),
    Position               = UDim2.new(1, -12, 0.5, 0),
    TextSize               = 11,
    ZIndex                 = 7,
    Size                   = UDim2.new(0, 50, 0, 30),
}, sliderRow)

local sliderTrackContainer = new("Frame", {
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 16, 0.5, 0),
    Size                   = UDim2.new(0.55, -10, 1, -10),
    ZIndex                 = 7,
}, sliderRow)

local sliderTrack = new("Frame", {
    BackgroundColor3       = Color3.fromRGB(60, 60, 60),
    BackgroundTransparency = 0.4,
    BorderSizePixel        = 0,
    Position               = UDim2.new(0, 0, 0.5, -2),
    Size                   = UDim2.new(1, 0, 0, 4),
    ZIndex                 = 7,
}, sliderTrackContainer)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, sliderTrack)

local sliderFill = new("Frame", {
    BackgroundColor3 = GREEN_ENABLED,
    BorderSizePixel  = 0,
    Size             = UDim2.new(1, 0, 1, 0),
    ZIndex           = 8,
}, sliderTrack)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, sliderFill)

local sliderKnob = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel  = 0,
    Size             = UDim2.new(0, 14, 0, 14),
    Position         = UDim2.new(1, -7, 0.5, -7),
    ZIndex           = 9,
}, sliderTrack)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, sliderKnob)
new("UIStroke", { Color = GREEN_ENABLED, Transparency = 0.4, Thickness = 1.5 }, sliderKnob)

local sliderHit = new("TextButton", {
    BackgroundTransparency = 1,
    BorderSizePixel        = 0,
    Text                   = "",
    AutoButtonColor        = false,
    ZIndex                 = 10,
    Size                   = UDim2.new(1, 0, 1, 0),
}, sliderTrackContainer)

-- ============================================================
-- SETTINGS FRAME (con fondo igual que main)
-- ============================================================
local settingsFrame = new("Frame", {
    Name                   = "Settings",
    Active                 = true,
    ClipsDescendants       = true,
    BackgroundTransparency = 0,
    BackgroundColor3       = Color3.fromRGB(10, 4, 16),
    BorderSizePixel        = 0,
    Position               = UDim2.new(0.5, -160, 0.4, 0),
    Size                   = UDim2.new(0, 320, 0, 240),
    Visible                = false,
}, gui)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, settingsFrame)

-- 🔥 Fondo con imagen para settings (RESTAURADO)
local settingsBG = new("ImageLabel", {
    Name                   = "BackgroundImage",
    BackgroundTransparency = 1,
    BorderSizePixel        = 0,
    Size                   = UDim2.new(1, 0, 1, 0),
    Position               = UDim2.new(0, 0, 0, 0),
    Image                  = "",
    ImageTransparency      = BG_IMAGE_TRANSPARENCY,
    ResampleMode           = BG_RESAMPLE,
    ScaleType              = Enum.ScaleType.Crop,
    ZIndex                 = 1,
    Visible                = false,
}, settingsFrame)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, settingsBG)

local settingsBGOverlay = new("Frame", {
    Name                   = "BackgroundOverlay",
    BackgroundColor3       = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = BG_OVERLAY_TRANSPARENCY,
    BorderSizePixel        = 0,
    Size                   = UDim2.new(1, 0, 1, 0),
    Position               = UDim2.new(0, 0, 0, 0),
    ZIndex                 = 2,
    Visible                = false,
}, settingsFrame)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, settingsBGOverlay)
new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 10, 50)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(0, 0, 0)),
    }),
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.2),
        NumberSequenceKeypoint.new(0.5, 0.05),
        NumberSequenceKeypoint.new(1,   0.2),
    }),
    Rotation = 90,
}, settingsBGOverlay)

local sStroke = new("UIStroke", {
    Thickness       = 1.8,
    Transparency    = 0.15,
    Color           = Color3.fromRGB(255, 255, 255),
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
}, settingsFrame)

local sGrad = new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(200, 200, 200)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(255, 255, 255)),
    }),
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.3),
        NumberSequenceKeypoint.new(0.5, 0.7),
        NumberSequenceKeypoint.new(1,   0.3),
    }),
    Rotation = 0,
}, sStroke)

local backBtn = new("TextButton", {
    Text                   = "←",
    TextColor3             = Color3.fromRGB(255, 255, 255),
    Font                   = Enum.Font.GothamBold,
    TextSize               = 16,
    BackgroundColor3       = LOCK_OFF_BG,
    BackgroundTransparency = 0.25,
    BorderSizePixel        = 0,
    Position               = UDim2.new(0, 8, 0, 8),
    Size                   = UDim2.new(0, 26, 0, 26),
    AutoButtonColor        = true,
    ZIndex                 = 20,
}, settingsFrame)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, backBtn)
new("UIStroke", {
    Color = Color3.fromRGB(255, 255, 255),
    Transparency = 0.4,
    Thickness = 1.2,
}, backBtn)

backBtn.MouseEnter:Connect(function()
    TweenService:Create(backBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play()
end)
backBtn.MouseLeave:Connect(function()
    TweenService:Create(backBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.25 }):Play()
end)

new("TextLabel", {
    Text                   = "Settings",
    TextColor3             = Color3.new(1, 1, 1),
    Font                   = Enum.Font.GothamBlack,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 0, 0, 12),
    TextXAlignment         = Enum.TextXAlignment.Center,
    ZIndex                 = 10,
    TextSize               = 22,
    Size                   = UDim2.new(1, 0, 0, 26),
}, settingsFrame)

new("Frame", {
    BackgroundColor3       = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.7,
    BorderSizePixel        = 0,
    Position               = UDim2.new(0, 20, 0, 44),
    Size                   = UDim2.new(1, -40, 0, 1),
    ZIndex                 = 10,
}, settingsFrame)

-- Stealth
new("TextLabel", {
    Text                   = "Stealth",
    TextColor3             = Color3.fromRGB(255, 255, 255),
    Font                   = Enum.Font.GothamBold,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 16, 0, 60),
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 10,
    TextSize               = 13,
    Size                   = UDim2.new(1, -80, 0, 20),
}, settingsFrame)

local stealthSubLbl = new("TextLabel", {
    Text                   = "NORMAL",
    TextColor3             = Color3.fromRGB(200, 200, 200),
    Font                   = Enum.Font.GothamBold,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 16, 0, 80),
    TextSize               = 10,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 10,
    Size                   = UDim2.new(1, -80, 0, 16),
}, settingsFrame)

local stealthTrack = new("Frame", {
    AnchorPoint      = Vector2.new(1, 0.5),
    BackgroundColor3 = OFF_COLOR,
    Position         = UDim2.new(1, -14, 0, 74),
    ZIndex           = 10,
    Size             = UDim2.new(0, 48, 0, 26),
    BorderSizePixel  = 0,
}, settingsFrame)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, stealthTrack)
new("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.3, Thickness = 1.2 }, stealthTrack)

local stealthKnob = new("Frame", {
    Size             = UDim2.new(0, 18, 0, 18),
    Position         = UDim2.new(0, 4, 0.5, -9),
    ZIndex           = 11,
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel  = 0,
}, stealthTrack)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, stealthKnob)

local stealthHit = new("TextButton", {
    Size                   = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text                   = "",
    ZIndex                 = 12,
}, stealthTrack)

-- Anti Reset
new("TextLabel", {
    Text                   = "Anti Reset",
    TextColor3             = Color3.fromRGB(255, 255, 255),
    Font                   = Enum.Font.GothamBold,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 16, 0, 108),
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 10,
    TextSize               = 13,
    Size                   = UDim2.new(1, -80, 0, 20),
}, settingsFrame)

local arSubLbl = new("TextLabel", {
    Text                   = "OFF",
    TextColor3             = Color3.fromRGB(255, 255, 255),
    Font                   = Enum.Font.GothamBold,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 16, 0, 128),
    TextSize               = 10,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 10,
    Size                   = UDim2.new(1, -80, 0, 16),
}, settingsFrame)

local arTrack = new("Frame", {
    AnchorPoint      = Vector2.new(1, 0.5),
    BackgroundColor3 = OFF_COLOR,
    Position         = UDim2.new(1, -14, 0, 122),
    ZIndex           = 10,
    Size             = UDim2.new(0, 48, 0, 26),
    BorderSizePixel  = 0,
}, settingsFrame)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, arTrack)
new("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Transparency = 0.3, Thickness = 1.2 }, arTrack)

local arKnob = new("Frame", {
    Size             = UDim2.new(0, 18, 0, 18),
    Position         = UDim2.new(0, 4, 0.5, -9),
    ZIndex           = 11,
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel  = 0,
}, arTrack)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, arKnob)

local arHit = new("TextButton", {
    Size                   = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text                   = "",
    ZIndex                 = 12,
}, arTrack)

new("TextLabel", {
    Text                   = "More settings coming soon...",
    TextColor3             = Color3.fromRGB(200, 200, 200),
    Font                   = Enum.Font.GothamBold,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 0, 1, -30),
    TextXAlignment         = Enum.TextXAlignment.Center,
    ZIndex                 = 10,
    TextSize               = 12,
    Size                   = UDim2.new(1, 0, 0, 20),
}, settingsFrame)

-- ============================================================
-- BACKGROUND CHANGER FRAME (con su propio fondo también)
-- ============================================================
local bgFrame = new("Frame", {
    Name                   = "BackgroundChanger",
    Active                 = true,
    ClipsDescendants       = true,
    BackgroundColor3       = Color3.fromRGB(10, 4, 16),
    BorderSizePixel        = 0,
    Position               = UDim2.new(0.5, -160, 0.4, 0),
    Size                   = UDim2.new(0, 320, 0, 240),
    Visible                = false,
}, gui)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, bgFrame)

local bgFrameBG = new("ImageLabel", {
    Name                   = "BackgroundImage",
    BackgroundTransparency = 1,
    BorderSizePixel        = 0,
    Size                   = UDim2.new(1, 0, 1, 0),
    Position               = UDim2.new(0, 0, 0, 0),
    Image                  = "",
    ImageTransparency      = BG_IMAGE_TRANSPARENCY,
    ResampleMode           = BG_RESAMPLE,
    ScaleType              = Enum.ScaleType.Crop,
    ZIndex                 = 1,
    Visible                = false,
}, bgFrame)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, bgFrameBG)

local bgFrameOverlay = new("Frame", {
    Name                   = "BackgroundOverlay",
    BackgroundColor3       = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = BG_OVERLAY_TRANSPARENCY,
    BorderSizePixel        = 0,
    Size                   = UDim2.new(1, 0, 1, 0),
    Position               = UDim2.new(0, 0, 0, 0),
    ZIndex                 = 2,
    Visible                = false,
}, bgFrame)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, bgFrameOverlay)

local bgStroke = new("UIStroke", {
    Thickness       = 1.8,
    Transparency    = 0.15,
    Color           = Color3.fromRGB(255, 255, 255),
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
}, bgFrame)

local bgGrad = new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(200, 200, 200)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(255, 255, 255)),
    }),
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.3),
        NumberSequenceKeypoint.new(0.5, 0.7),
        NumberSequenceKeypoint.new(1,   0.3),
    }),
    Rotation = 0,
}, bgStroke)

local bgBackBtn = new("TextButton", {
    Text                   = "←",
    TextColor3             = Color3.fromRGB(255, 255, 255),
    Font                   = Enum.Font.GothamBold,
    TextSize               = 16,
    BackgroundColor3       = LOCK_OFF_BG,
    BackgroundTransparency = 0.25,
    BorderSizePixel        = 0,
    Position               = UDim2.new(0, 8, 0, 8),
    Size                   = UDim2.new(0, 26, 0, 26),
    AutoButtonColor        = true,
    ZIndex                 = 20,
}, bgFrame)
new("UICorner", { CornerRadius = UDim.new(1, 0) }, bgBackBtn)
new("UIStroke", {
    Color = Color3.fromRGB(255, 255, 255),
    Transparency = 0.4,
    Thickness = 1.2,
}, bgBackBtn)

bgBackBtn.MouseEnter:Connect(function()
    TweenService:Create(bgBackBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play()
end)
bgBackBtn.MouseLeave:Connect(function()
    TweenService:Create(bgBackBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.25 }):Play()
end)

new("TextLabel", {
    Text                   = "Background",
    TextColor3             = Color3.new(1, 1, 1),
    Font                   = Enum.Font.GothamBlack,
    BackgroundTransparency = 1,
    Position               = UDim2.new(0, 0, 0, 12),
    TextXAlignment         = Enum.TextXAlignment.Center,
    ZIndex                 = 10,
    TextSize               = 22,
    Size                   = UDim2.new(1, 0, 0, 26),
}, bgFrame)

new("Frame", {
    BackgroundColor3       = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.7,
    BorderSizePixel        = 0,
    Position               = UDim2.new(0, 20, 0, 44),
    Size                   = UDim2.new(1, -40, 0, 1),
    ZIndex                 = 10,
}, bgFrame)

local bgScroll = new("ScrollingFrame", {
    BackgroundTransparency = 1,
    BorderSizePixel        = 0,
    Position               = UDim2.new(0, 8, 0, 52),
    Size                   = UDim2.new(1, -16, 1, -60),
    CanvasSize             = UDim2.new(0, 0, 0, 0),
    ScrollBarThickness     = 4,
    ScrollBarImageColor3   = Color3.fromRGB(120, 120, 140),
    ZIndex                 = 10,
}, bgFrame)

-- ============================================================
-- APLICAR FONDO A TODOS LOS FRAMES
-- ============================================================
local function applyBackground(assetId)
    if not assetId then
        main.BackgroundColor3 = Color3.fromRGB(10, 4, 16)
        settingsFrame.BackgroundColor3 = Color3.fromRGB(10, 4, 16)
        bgFrame.BackgroundColor3 = Color3.fromRGB(10, 4, 16)

        mainBG.Visible = false
        mainBGOverlay.Visible = false
        settingsBG.Visible = false
        settingsBGOverlay.Visible = false
        bgFrameBG.Visible = false
        bgFrameOverlay.Visible = false
        return
    end

    main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    settingsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

    -- Main
    mainBG.Image = assetId
    mainBG.Visible = true
    mainBGOverlay.Visible = true

    -- Settings
    settingsBG.Image = assetId
    settingsBG.Visible = true
    settingsBGOverlay.Visible = true

    -- Background changer
    bgFrameBG.Image = assetId
    bgFrameBG.Visible = true
    bgFrameOverlay.Visible = true
end

local function selectBG(assetId)
    currentBG = assetId

    for _, child in ipairs(bgScroll:GetChildren()) do
        if child:IsA("TextButton") then
            local isSelected = (child:GetAttribute("AssetId") == assetId)
            local st = child:FindFirstChildOfClass("UIStroke")
            if st then
                TweenService:Create(st, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                    Color        = Color3.fromRGB(255, 255, 255),
                    Transparency = isSelected and 0 or 1,
                    Thickness    = isSelected and 3 or 1,
                }):Play()
            end

            local inner = child:FindFirstChild("ThumbImage")
            if inner then
                TweenService:Create(inner, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                    Size = isSelected and UDim2.new(1, -2, 1, -2) or UDim2.new(1, -4, 1, -4),
                }):Play()
            end
        end
    end

    applyBackground(assetId)
end

-- Crear thumbs
local thumbSize = 70
local thumbPadding = 8
local thumbsPerRow = 3
local totalRows = math.ceil(#BG_IMAGES / thumbsPerRow)
bgScroll.CanvasSize = UDim2.new(0, 0, 0, totalRows * (thumbSize + thumbPadding) + thumbPadding)

for i, assetId in ipairs(BG_IMAGES) do
    local row = math.floor((i - 1) / thumbsPerRow)
    local col = (i - 1) % thumbsPerRow

    local thumb = new("TextButton", {
        Name             = "Thumb_" .. i,
        Size             = UDim2.new(0, thumbSize, 0, thumbSize),
        Position         = UDim2.new(0, thumbPadding + col * (thumbSize + thumbPadding),
                                         0, thumbPadding + row * (thumbSize + thumbPadding)),
        BackgroundColor3 = Color3.fromRGB(30, 20, 40),
        BorderSizePixel  = 0,
        Text             = "",
        AutoButtonColor  = false,
        ClipsDescendants = false,
        ZIndex           = 11,
    }, bgScroll)
    new("UICorner", { CornerRadius = UDim.new(0, 8) }, thumb)

    new("UIStroke", {
        Color           = Color3.fromRGB(255, 255, 255),
        Transparency    = 1,
        Thickness       = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, thumb)

    local tImg = new("ImageLabel", {
        Name                   = "ThumbImage",
        Size                   = UDim2.new(1, -4, 1, -4),
        Position               = UDim2.new(0, 2, 0, 2),
        BackgroundTransparency = 1,
        Image                  = assetId,
        ResampleMode           = Enum.ResamplerMode.Default,
        ScaleType              = Enum.ScaleType.Crop,
        ZIndex                 = 12,
    }, thumb)
    new("UICorner", { CornerRadius = UDim.new(0, 6) }, tImg)

    thumb:SetAttribute("AssetId", assetId)

    thumb.MouseEnter:Connect(function()
        TweenService:Create(thumb, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, thumbSize + 6, 0, thumbSize + 6),
            Position = UDim2.new(0, thumbPadding + col * (thumbSize + thumbPadding) - 3,
                                    0, thumbPadding + row * (thumbSize + thumbPadding) - 3),
        }):Play()
    end)
    thumb.MouseLeave:Connect(function()
        TweenService:Create(thumb, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, thumbSize, 0, thumbSize),
            Position = UDim2.new(0, thumbPadding + col * (thumbSize + thumbPadding),
                                    0, thumbPadding + row * (thumbSize + thumbPadding)),
        }):Play()
    end)

    thumb.MouseButton1Click:Connect(function()
        selectBG(assetId)
    end)
end

if currentBG then
    selectBG(currentBG)
end

-- ============================================================
-- Stealth UI
-- ============================================================
local function refreshStealthUI()
    local strong = (stealthMode == "STRONG")
    stealthSubLbl.Text       = strong and "STRONG" or "NORMAL"
    stealthSubLbl.TextColor3 = strong and Color3.fromRGB(255, 150, 150) or Color3.fromRGB(200, 200, 200)
    TweenService:Create(stealthKnob, TweenInfo.new(0.25), {
        Position = strong and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9),
    }):Play()
    TweenService:Create(stealthTrack, TweenInfo.new(0.35), {
        BackgroundColor3 = strong and STRONG_COLOR or OFF_COLOR,
    }):Play()
    cfg = STEALTH[stealthMode]
end

stealthHit.MouseButton1Click:Connect(function()
    stealthMode = (stealthMode == "NORMAL") and "STRONG" or "NORMAL"
    refreshStealthUI()
end)

refreshStealthUI()

-- Anti Reset handler
arHit.MouseButton1Click:Connect(function()
    local newState = not antiResetOn
    local targetPos = newState and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
    TweenService:Create(arKnob, TweenInfo.new(0.25), { Position = targetPos }):Play()
    TweenService:Create(arTrack, TweenInfo.new(0.35), {
        BackgroundColor3 = newState and GREEN_ENABLED or OFF_COLOR,
    }):Play()
    arSubLbl.Text       = newState and "ACTIVE" or "OFF"
    arSubLbl.TextColor3 = newState and GREEN_GLOW or Color3.fromRGB(255, 255, 255)
    if newState then
        task.spawn(function()
            local ok = pcall(startAntiReset)
            if not ok then print("prince") end
        end)
    else
        task.spawn(function() pcall(stopAntiReset) end)
    end
end)

-- Slider
local isSliding = false
local sliderConnection = nil

local function updateMenuScale(scale)
    local menuScale = math.clamp(scale, 0.5, 1.5)
    mainScale.Scale = menuScale
    local percent = math.round(menuScale * 100)
    sliderValue.Text = tostring(percent) .. "%"
    local fillPercent = (menuScale - 0.5) / 1.0
    sliderFill.Size = UDim2.new(fillPercent, 0, 1, 0)
    sliderKnob.Position = UDim2.new(fillPercent, -7, 0.5, -7)
end

local function getSliderPosition(input)
    if not sliderTrack or not sliderTrack.AbsoluteSize then return 0.5 end
    local trackSize = sliderTrack.AbsoluteSize.X
    if trackSize <= 0 then return 0.5 end
    local relativeX = input.Position.X - sliderTrack.AbsolutePosition.X
    return math.clamp(relativeX / trackSize, 0, 1)
end

local function handleSliderInput(input)
    if not sliderTrack or not sliderTrack.AbsoluteSize then return end
    local pos = getSliderPosition(input)
    updateMenuScale(0.5 + (pos * 1.0))
end

sliderHit.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        isSliding = true
        handleSliderInput(input)
        if sliderConnection then sliderConnection:Disconnect() end
        sliderConnection = UIS.InputChanged:Connect(function(inputChanged)
            if isSliding and (inputChanged.UserInputType == Enum.UserInputType.MouseMovement or
                              inputChanged.UserInputType == Enum.UserInputType.Touch) then
                handleSliderInput(inputChanged)
            end
        end)
    end
end)

sliderHit.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        isSliding = false
        if sliderConnection then sliderConnection:Disconnect(); sliderConnection = nil end
    end
end)

UIS.InputEnded:Connect(function(input)
    if isSliding and (input.UserInputType == Enum.UserInputType.MouseButton1 or
                       input.UserInputType == Enum.UserInputType.Touch) then
        isSliding = false
        if sliderConnection then sliderConnection:Disconnect(); sliderConnection = nil end
    end
end)

updateMenuScale(1.0)

-- Gradiente animado
task.spawn(function()
    local r = 0
    while gui and gui.Parent do
        local dt = task.wait()
        r = (r + 120 * dt) % 360
        if grad then grad.Rotation = r end
        if sGrad then sGrad.Rotation = r end
        if bgGrad then bgGrad.Rotation = r end
    end
end)

-- Navegación
settingsBtn.MouseButton1Click:Connect(function()
    settingsFrame.Position = main.Position
    main.Visible = false
    settingsFrame.Visible = true
end)

backBtn.MouseButton1Click:Connect(function()
    main.Position = settingsFrame.Position
    settingsFrame.Visible = false
    main.Visible = true
end)

bgBtn.MouseButton1Click:Connect(function()
    bgFrame.Position = main.Position
    main.Visible = false
    bgFrame.Visible = true
end)

bgBackBtn.MouseButton1Click:Connect(function()
    main.Position = bgFrame.Position
    bgFrame.Visible = false
    main.Visible = true
end)

-- Desync handler
dsHit.MouseButton1Click:Connect(function()
    local newState = not desyncOn
    local targetPos = newState and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
    TweenService:Create(dsKnob, TweenInfo.new(0.25), { Position = targetPos }):Play()
    TweenService:Create(dsTrack, TweenInfo.new(0.35), {
        BackgroundColor3 = newState and GREEN_ENABLED or OFF_COLOR,
    }):Play()
    dsSubLbl.Text       = newState and "ACTIVE" or "OFF"
    dsSubLbl.TextColor3 = newState and GREEN_GLOW or Color3.fromRGB(255, 255, 255)
    if newState then
        task.spawn(function()
            local ok = pcall(startDesync)
            if not ok then print("prince") end
        end)
    else
        task.spawn(function() pcall(stopDesync) end)
    end
end)

-- Anti Die handler
adHit.MouseButton1Click:Connect(function()
    local newState = not antiDieOn
    local targetPos = newState and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
    TweenService:Create(adKnob, TweenInfo.new(0.25), { Position = targetPos }):Play()
    TweenService:Create(adTrack, TweenInfo.new(0.35), {
        BackgroundColor3 = newState and GREEN_ENABLED or OFF_COLOR,
    }):Play()
    adSubLbl.Text       = newState and "ACTIVE" or "OFF"
    adSubLbl.TextColor3 = newState and GREEN_GLOW or Color3.fromRGB(255, 255, 255)
    if newState then
        task.spawn(function()
            local ok = pcall(startAntiDie)
            if not ok then print("prince") end
        end)
    else
        task.spawn(function() pcall(stopAntiDie) end)
    end
end)

-- Drag genérico
local function makeDraggable(frame, checkLock)
    local dragging, dragStart, startPos = false, nil, nil

    frame.InputBegan:Connect(function(input)
        if checkLock and checkLock() then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(main, function() return isLocked end)
makeDraggable(settingsFrame, nil)
makeDraggable(bgFrame, nil)

print("[Levithon Hub] Loaded successfully.") nil, nil

settingsFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        sDragging  = true
        sDragStart = input.Position
        sStartPos  = settingsFrame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if sDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        settingsFrame.Position = UDim2.new(
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        sDragging = false
    end
end)

local bDragging, bDragStart, bStartPos = false, nil, nil

bgFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        bDragging  = true
        bDragStart = input.Position
        bStartPos  = bgFrame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if bDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        bgFrame.Position = UDim2.new(
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        bDragging = false
    end
end)