--[[
    Adapt Hub — Desync Aimbot
    GUI: matches Adapt Hub screenshot
      - Circle icon + "ADAPT HUB" / "PREMIUM AIMBOT" header
      - "● OFF / ● ON" status chip (click to minimize)
      - AIMBOT row: keybind chip + toggle pill
      - DESYNC row: keybind chip + toggle pill  
      - RANGE / SPEED input rows
      - Footer: "ADAPT  •  v3.0" | "LCTRL TO HIDE"

    Desync Aimbot improvements:
      - Ghost-position prediction (lerps toward server position)
      - Velocity-based lead targeting (hits moving targets)
      - Multi-frame oscillation to trigger server desync window
      - Anti-fling: caps velocity after teleport
      - Auto-swing with remote fire + hit effect
      - Smooth ramp-up velocity (no sudden fling)
]]

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local Ts         = game:GetService("TweenService")
local CoreGui    = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local WS = workspace

-- ══════════════════════════════════════════
--  CONFIG
-- ══════════════════════════════════════════
local Cfg = {
    aimbotEnabled = false,
    desyncEnabled = false,
    range         = 120,    -- max target distance
    tpDist        = 14,     -- teleport if farther than this
    swingDist     = 7,      -- auto-swing within this dist
    swingRate     = 0.08,   -- seconds between swings
    velSpeed      = 56,     -- velocity push speed
    desyncAmp     = 3.2,    -- oscillation amplitude (studs)
    desyncFreq    = 18,     -- oscillations per second
    leadFactor    = 0.18,   -- how far ahead to lead moving targets
    velLerp       = 0.28,   -- velocity smoothing (0-1)
    maxFallVel    = -110,   -- anti-fling fall cap
    aimbotKey     = Enum.KeyCode.V,
    desyncKey     = Enum.KeyCode.B,
}

-- ══════════════════════════════════════════
--  STATE
-- ══════════════════════════════════════════
local State = {
    aimActive    = false,
    desyncActive = false,
    lastSwing    = 0,
    swingCD      = false,
    phase        = 0,          -- desync oscillation phase
    ghostPos     = nil,        -- predicted server ghost position
    prevTargetPos = nil,       -- for velocity lead
    prevTick      = nil,
}

local Conns = { aimbot = nil, desync = nil }

-- ══════════════════════════════════════════
--  HELPERS
-- ══════════════════════════════════════════
local function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getBat()
    local c = LP.Character; if not c then return end
    local bat = c:FindFirstChild("Bat")
    if not bat then
        local bp = LP:FindFirstChild("Backpack")
        bat = bp and bp:FindFirstChild("Bat")
    end
    if bat and bat.Parent ~= c then
        local hum = getHum()
        if hum then pcall(function() hum:EquipTool(bat) end) end
    end
    return bat
end

local function getNearestEnemy()
    local root = getRoot(); if not root then return end
    local nearest, nearDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if r and hum and hum.Health > 0 then
                local d = (root.Position - r.Position).Magnitude
                if d < nearDist and d <= Cfg.range then
                    nearDist = d; nearest = p
                end
            end
        end
    end
    return nearest, nearDist
end

-- Get server ghost or real position + velocity lead
local function getTargetPos(target)
    if not target or not target.Character then return nil end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    -- Check for ServerGhost
    local ghost = WS:FindFirstChild("ServerGhost")
    local basePos = hrp.Position
    if ghost and ghost:IsA("BasePart") then
        local gd = (ghost.Position - hrp.Position).Magnitude
        if gd < 35 then basePos = ghost.Position end
    end

    -- Velocity lead: predict where target will be
    local now = tick()
    local lead = Vector3.zero
    if State.prevTargetPos and State.prevTick then
        local dt = now - State.prevTick
        if dt > 0 and dt < 0.5 then
            local vel = (basePos - State.prevTargetPos) / dt
            lead = vel * Cfg.leadFactor
        end
    end
    State.prevTargetPos = basePos
    State.prevTick      = now

    -- Smooth ghost interpolation
    if State.ghostPos then
        State.ghostPos = State.ghostPos:Lerp(basePos + lead, 0.45)
    else
        State.ghostPos = basePos + lead
    end

    return State.ghostPos, hrp.CFrame.LookVector
end

-- Ground clamp: find floor below a position
local function clampToGround(pos, char)
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {char}
    rp.FilterType = Enum.RaycastFilterType.Blacklist
    local result = WS:Raycast(pos + Vector3.new(0, 10, 0), Vector3.new(0, -25, 0), rp)
    if result then
        return Vector3.new(pos.X, result.Position.Y + 3, pos.Z)
    end
    return pos
end

-- Hit effect
local function hitFX(pos)
    local p = Instance.new("Part")
    p.Size = Vector3.new(0.8, 0.8, 0.8)
    p.Position = pos; p.Anchored = true
    p.CanCollide = false
    p.BrickColor = BrickColor.new("Hot pink")
    p.Material = Enum.Material.Neon
    p.Parent = WS
    Ts:Create(p, TweenInfo.new(0.22, Enum.EasingStyle.Back), {Size = Vector3.new(3,3,3)}):Play()
    game:GetService("Debris"):AddItem(p, 0.4)
end

-- ══════════════════════════════════════════
--  SWING
-- ══════════════════════════════════════════
local function doSwing(targetPos)
    if State.swingCD then return end
    local now = tick()
    if now - State.lastSwing < Cfg.swingRate then return end
    State.lastSwing = now
    State.swingCD   = true
    task.delay(Cfg.swingRate, function() State.swingCD = false end)

    pcall(function()
        local bat = getBat(); if not bat then return end
        bat:Activate()
        local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
        if remote then
            if targetPos then remote:FireServer(targetPos) end
            remote:FireServer()
        end
        if targetPos then hitFX(targetPos) end
    end)
end

-- ══════════════════════════════════════════
--  AIMBOT LOOP
-- ══════════════════════════════════════════
local function startAimbot()
    if Conns.aimbot then return end
    Conns.aimbot = RunService.Heartbeat:Connect(function()
        if not State.aimActive then return end

        local root = getRoot(); if not root then return end
        local hum  = getHum();  if not hum or hum.Health <= 0 then return end

        local target, dist = getNearestEnemy()
        if not target then
            -- No target: decay velocity gently
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.7
            return
        end

        local targetPos, lookVec = getTargetPos(target)
        if not targetPos then return end

        -- Offset: stand slightly in front of target's look
        local offsetPos = targetPos + (lookVec or Vector3.new(0,0,1)) * 1.4
        local myPos     = root.Position
        local gap       = (myPos - offsetPos).Magnitude

        if gap > Cfg.tpDist then
            -- Teleport with ground clamp + anti-fling
            local safe = clampToGround(offsetPos, LP.Character)
            root.CFrame = CFrame.new(safe)
            root.AssemblyLinearVelocity = Vector3.zero
            hum:MoveTo(safe)
        else
            -- Smooth velocity push toward offset
            local dir     = (offsetPos - myPos)
            local dirUnit = dir.Magnitude > 0.01 and dir.Unit or Vector3.zero
            local wanted  = dirUnit * Cfg.velSpeed
            local current = root.AssemblyLinearVelocity
            -- Anti-fling fall cap
            local newY = math.max(current.Y, Cfg.maxFallVel)
            local lerped = Vector3.new(
                current.X + (wanted.X - current.X) * Cfg.velLerp,
                newY,
                current.Z + (wanted.Z - current.Z) * Cfg.velLerp
            )
            root.AssemblyLinearVelocity = lerped
        end

        -- Auto swing
        if gap < Cfg.swingDist then doSwing(targetPos) end
    end)
end

local function stopAimbot()
    if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot = nil end
    State.ghostPos      = nil
    State.prevTargetPos = nil
    State.prevTick      = nil
end

-- ══════════════════════════════════════════
--  DESYNC LOOP
--  Multi-frame oscillation — rapidly shifts
--  position back and forth to widen the
--  server-side hitbox window
-- ══════════════════════════════════════════
local function startDesync()
    if Conns.desync then return end
    State.phase = 0
    Conns.desync = RunService.Heartbeat:Connect(function(dt)
        if not State.desyncActive then return end

        local root = getRoot(); if not root then return end
        local target = getNearestEnemy()
        if not target or not target.Character then return end
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        if not tr then return end

        -- Advance oscillation phase
        State.phase = State.phase + dt * Cfg.desyncFreq * math.pi * 2

        -- Perpendicular axis to the direction toward target
        local toTarget = (tr.Position - root.Position)
        local flatDir  = Vector3.new(toTarget.X, 0, toTarget.Z)
        local perpAxis = flatDir.Magnitude > 0.01
            and Vector3.new(-flatDir.Z, 0, flatDir.X).Unit
            or  Vector3.new(1, 0, 0)

        -- Oscillate perpendicular + slight forward sine for max desync
        local sideOsc    = math.sin(State.phase)    * Cfg.desyncAmp
        local forwardOsc = math.cos(State.phase * 2) * (Cfg.desyncAmp * 0.4)
        local forwardDir = flatDir.Magnitude > 0.01 and flatDir.Unit or Vector3.zero

        local vel = root.AssemblyLinearVelocity
        local newVel = Vector3.new(
            vel.X + perpAxis.X * sideOsc + forwardDir.X * forwardOsc,
            math.max(vel.Y, Cfg.maxFallVel),
            vel.Z + perpAxis.Z * sideOsc + forwardDir.Z * forwardOsc
        )
        root.AssemblyLinearVelocity = newVel
    end)
end

local function stopDesync()
    if Conns.desync then Conns.desync:Disconnect(); Conns.desync = nil end
    State.phase = 0
end

-- Respawn handler
LP.CharacterAdded:Connect(function()
    task.wait(0.4)
    if State.aimActive    then stopAimbot();  startAimbot()  end
    if State.desyncActive then stopDesync();  startDesync()  end
end)

-- ══════════════════════════════════════════
--  GUI  —  Adapt Hub style
-- ══════════════════════════════════════════
pcall(function()
    local o = CoreGui:FindFirstChild("AdaptDesyncAimbot")
    if o then o:Destroy() end
end)

local sg = Instance.new("ScreenGui")
sg.Name           = "AdaptDesyncAimbot"
sg.ResetOnSpawn   = false
sg.IgnoreGuiInset = true
sg.DisplayOrder   = 99
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() sg.Parent = CoreGui end)
if not sg.Parent then sg.Parent = LP:WaitForChild("PlayerGui") end

local TI = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Palette
local BG       = Color3.fromRGB(16,  14,  20)
local CARD_BG  = Color3.fromRGB(24,  20,  30)
local PINK     = Color3.fromRGB(232,  55, 128)
local PINK_DIM = Color3.fromRGB(130,  28,  70)
local PILL_OFF = Color3.fromRGB(52,   44,  66)
local WHITE    = Color3.fromRGB(255, 255, 255)
local GREY     = Color3.fromRGB(115, 105, 130)
local FOOT_C   = Color3.fromRGB(70,   62,  86)
local CHIP_BG  = Color3.fromRGB(32,   26,  42)

-- ── Main card ───────────────────────────────
local FULL_H = 220
local MINI_H = 50

local card = Instance.new("Frame")
card.Name             = "Card"
card.Size             = UDim2.new(0, 270, 0, FULL_H)
card.Position         = UDim2.new(0.5, -135, 0.3, 0)
card.BackgroundColor3 = BG
card.BorderSizePixel  = 0
card.ClipsDescendants = true
card.Active           = true
card.Parent           = sg
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)

local cardStroke = Instance.new("UIStroke", card)
cardStroke.Color           = Color3.fromRGB(52, 44, 66)
cardStroke.Thickness       = 1.2
cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Gradient
local grad = Instance.new("UIGradient", card)
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 24, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 10, 18)),
})
grad.Rotation = 120

-- ── Header ──────────────────────────────────
local header = Instance.new("Frame", card)
header.Size             = UDim2.new(1, 0, 0, 50)
header.BackgroundTransparency = 1
header.ZIndex           = 3

-- Circle icon
local iconBg = Instance.new("Frame", header)
iconBg.Size             = UDim2.new(0, 32, 0, 32)
iconBg.Position         = UDim2.new(0, 12, 0.5, -16)
iconBg.BackgroundColor3 = Color3.fromRGB(32, 26, 44)
iconBg.BorderSizePixel  = 0
iconBg.ZIndex           = 4
Instance.new("UICorner", iconBg).CornerRadius = UDim.new(1, 0)
local iconRing = Instance.new("UIStroke", iconBg)
iconRing.Color    = PINK
iconRing.Thickness = 2

local iconDot = Instance.new("Frame", iconBg)
iconDot.Size             = UDim2.new(0, 10, 0, 10)
iconDot.Position         = UDim2.new(0.5, -5, 0.5, -5)
iconDot.BackgroundColor3 = PINK
iconDot.BorderSizePixel  = 0
iconDot.ZIndex           = 5
Instance.new("UICorner", iconDot).CornerRadius = UDim.new(1, 0)

-- Title
local titleLbl = Instance.new("TextLabel", header)
titleLbl.Size               = UDim2.new(0, 130, 0, 20)
titleLbl.Position           = UDim2.new(0, 54, 0, 7)
titleLbl.BackgroundTransparency = 1
titleLbl.Text               = "ADAPT HUB"
titleLbl.Font               = Enum.Font.GothamBlack
titleLbl.TextSize           = 13
titleLbl.TextColor3         = WHITE
titleLbl.TextXAlignment     = Enum.TextXAlignment.Left
titleLbl.ZIndex             = 4

local subLbl = Instance.new("TextLabel", header)
subLbl.Size               = UDim2.new(0, 160, 0, 14)
subLbl.Position           = UDim2.new(0, 54, 0, 27)
subLbl.BackgroundTransparency = 1
subLbl.Text               = "PREMIUM AIMBOT"
subLbl.Font               = Enum.Font.GothamBold
subLbl.TextSize           = 9
subLbl.TextColor3         = GREY
subLbl.TextXAlignment     = Enum.TextXAlignment.Left
subLbl.ZIndex             = 4

-- Status chip
local statusChip = Instance.new("Frame", header)
statusChip.Size             = UDim2.new(0, 54, 0, 20)
statusChip.Position         = UDim2.new(1, -62, 0.5, -10)
statusChip.BackgroundColor3 = CHIP_BG
statusChip.BorderSizePixel  = 0
statusChip.ZIndex           = 4
Instance.new("UICorner", statusChip).CornerRadius = UDim.new(0, 10)
local statusStroke = Instance.new("UIStroke", statusChip)
statusStroke.Color = PILL_OFF; statusStroke.Thickness = 1

local statusLbl = Instance.new("TextLabel", statusChip)
statusLbl.Size               = UDim2.new(1, 0, 1, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text               = "● OFF"
statusLbl.Font               = Enum.Font.GothamBold
statusLbl.TextSize           = 10
statusLbl.TextColor3         = GREY
statusLbl.ZIndex             = 5

local minimized = false
local statusBtn = Instance.new("TextButton", statusChip)
statusBtn.Size               = UDim2.new(1, 0, 1, 0)
statusBtn.BackgroundTransparency = 1
statusBtn.Text               = ""
statusBtn.ZIndex             = 6
statusBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Ts:Create(card, TI, {Size = UDim2.new(0, 270, 0, minimized and MINI_H or FULL_H)}):Play()
end)

-- Divider
local div = Instance.new("Frame", card)
div.Size             = UDim2.new(1, -24, 0, 1)
div.Position         = UDim2.new(0, 12, 0, 50)
div.BackgroundColor3 = Color3.fromRGB(44, 38, 58)
div.BorderSizePixel  = 0; div.ZIndex = 3

-- ── Row builder ─────────────────────────────
local function makeRow(parent, labelText, yPos, defKey)
    local row = Instance.new("Frame", parent)
    row.Size             = UDim2.new(1, -24, 0, 36)
    row.Position         = UDim2.new(0, 12, 0, yPos)
    row.BackgroundColor3 = CARD_BG
    row.BorderSizePixel  = 0
    row.ZIndex           = 3
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
    local rs = Instance.new("UIStroke", row)
    rs.Color = Color3.fromRGB(52,44,66); rs.Thickness = 1

    local lbl = Instance.new("TextLabel", row)
    lbl.Size               = UDim2.new(0, 90, 1, 0)
    lbl.Position           = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text               = labelText
    lbl.Font               = Enum.Font.GothamBlack
    lbl.TextSize           = 12
    lbl.TextColor3         = WHITE
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.ZIndex             = 4

    -- Keybind chip
    local kbChip = Instance.new("Frame", row)
    kbChip.Size             = UDim2.new(0, 26, 0, 18)
    kbChip.Position         = UDim2.new(1, -80, 0.5, -9)
    kbChip.BackgroundColor3 = CHIP_BG
    kbChip.BorderSizePixel  = 0; kbChip.ZIndex = 4
    Instance.new("UICorner", kbChip).CornerRadius = UDim.new(0, 5)
    local kbs = Instance.new("UIStroke", kbChip)
    kbs.Color = PILL_OFF; kbs.Thickness = 1

    local kbBtn = Instance.new("TextButton", kbChip)
    kbBtn.Size               = UDim2.new(1, 0, 1, 0)
    kbBtn.BackgroundTransparency = 1
    kbBtn.Text               = defKey or "—"
    kbBtn.Font               = Enum.Font.GothamBold
    kbBtn.TextSize           = 9
    kbBtn.TextColor3         = GREY
    kbBtn.AutoButtonColor    = false
    kbBtn.ZIndex             = 5

    -- Pill
    local pill = Instance.new("Frame", row)
    pill.Size             = UDim2.new(0, 42, 0, 22)
    pill.Position         = UDim2.new(1, -48, 0.5, -11)
    pill.BackgroundColor3 = PILL_OFF
    pill.BorderSizePixel  = 0; pill.ZIndex = 4
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", pill)
    knob.Size             = UDim2.new(0, 16, 0, 16)
    knob.Position         = UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = GREY
    knob.BorderSizePixel  = 0; knob.ZIndex = 5
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local pillBtn = Instance.new("TextButton", pill)
    pillBtn.Size               = UDim2.new(1, 0, 1, 0)
    pillBtn.BackgroundTransparency = 1
    pillBtn.Text               = ""; pillBtn.ZIndex = 6

    local function setOn(on)
        if on then
            Ts:Create(pill,  TI, {BackgroundColor3 = PINK_DIM}):Play()
            Ts:Create(knob,  TI, {BackgroundColor3 = PINK, Position = UDim2.new(0,23,0.5,-8)}):Play()
            Ts:Create(rs,    TI, {Color = PINK_DIM}):Play()
            Ts:Create(kbs,   TI, {Color = PINK_DIM}):Play()
        else
            Ts:Create(pill,  TI, {BackgroundColor3 = PILL_OFF}):Play()
            Ts:Create(knob,  TI, {BackgroundColor3 = GREY, Position = UDim2.new(0,3,0.5,-8)}):Play()
            Ts:Create(rs,    TI, {Color = Color3.fromRGB(52,44,66)}):Play()
            Ts:Create(kbs,   TI, {Color = PILL_OFF}):Play()
        end
    end
    return pillBtn, setOn, kbBtn, kbs
end

-- ── Input row builder ───────────────────────
local function makeInputRow(parent, labelText, yPos, default, callback)
    local row = Instance.new("Frame", parent)
    row.Size             = UDim2.new(1, -24, 0, 32)
    row.Position         = UDim2.new(0, 12, 0, yPos)
    row.BackgroundColor3 = CARD_BG
    row.BorderSizePixel  = 0; row.ZIndex = 3
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", row).Color = Color3.fromRGB(44,38,58)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size               = UDim2.new(0.55, 0, 1, 0)
    lbl.Position           = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text               = labelText
    lbl.Font               = Enum.Font.GothamBold
    lbl.TextSize           = 11
    lbl.TextColor3         = GREY
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.ZIndex             = 4

    local box = Instance.new("TextBox", row)
    box.Size             = UDim2.new(0, 60, 0, 22)
    box.Position         = UDim2.new(1, -68, 0.5, -11)
    box.BackgroundColor3 = CHIP_BG
    box.BorderSizePixel  = 0
    box.Text             = tostring(default)
    box.Font             = Enum.Font.GothamBold
    box.TextSize         = 11
    box.TextColor3       = WHITE
    box.ClearTextOnFocus = false
    box.ZIndex           = 4
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    local bs = Instance.new("UIStroke", box)
    bs.Color = PILL_OFF; bs.Thickness = 1

    box.Focused:Connect(function() Ts:Create(bs, TI, {Color = PINK}):Play() end)
    box.FocusLost:Connect(function()
        Ts:Create(bs, TI, {Color = PILL_OFF}):Play()
        local n = tonumber(box.Text)
        if n then callback(n) else box.Text = tostring(default) end
    end)
end

-- ── Wire rows ────────────────────────────────
local y = 56

-- AIMBOT row
local abPillBtn, abSet, abKbBtn, abKbs = makeRow(card, "AIMBOT", y, "V")
y = y + 42

-- DESYNC row
local dsPillBtn, dsSet, dsKbBtn, dsKbs = makeRow(card, "DESYNC", y, "B")
y = y + 42

-- RANGE input
makeInputRow(card, "Range (studs)", y, Cfg.range, function(v)
    Cfg.range = math.clamp(v, 5, 500)
end)
y = y + 36

-- SPEED input
makeInputRow(card, "Vel Speed", y, Cfg.velSpeed, function(v)
    Cfg.velSpeed = math.clamp(v, 10, 200)
end)
y = y + 36

-- ── Footer ───────────────────────────────────
local footer = Instance.new("Frame", card)
footer.Size             = UDim2.new(1, 0, 0, 22)
footer.Position         = UDim2.new(0, 0, 1, -22)
footer.BackgroundTransparency = 1
footer.ZIndex           = 3

local footL = Instance.new("TextLabel", footer)
footL.Size               = UDim2.new(0.5, 0, 1, 0)
footL.Position           = UDim2.new(0, 14, 0, 0)
footL.BackgroundTransparency = 1
footL.Text               = "ADAPT  •  v3.0"
footL.Font               = Enum.Font.GothamBold
footL.TextSize           = 9
footL.TextColor3         = FOOT_C
footL.TextXAlignment     = Enum.TextXAlignment.Left
footL.ZIndex             = 4

local footR = Instance.new("TextLabel", footer)
footR.Size               = UDim2.new(0.5, -14, 1, 0)
footR.Position           = UDim2.new(0.5, 0, 0, 0)
footR.BackgroundTransparency = 1
footR.Text               = "LCTRL TO HIDE"
footR.Font               = Enum.Font.GothamBold
footR.TextSize           = 9
footR.TextColor3         = FOOT_C
footR.TextXAlignment     = Enum.TextXAlignment.Right
footR.ZIndex             = 4

-- ══════════════════════════════════════════
--  GLOBAL STATUS UPDATE
-- ══════════════════════════════════════════
local function refreshStatus()
    local anyOn = State.aimActive or State.desyncActive
    if anyOn then
        statusLbl.Text = "● ON"
        Ts:Create(statusLbl,  TI, {TextColor3 = PINK}):Play()
        Ts:Create(statusStroke, TI, {Color = PINK_DIM}):Play()
        Ts:Create(iconRing,   TI, {Color = PINK}):Play()
        Ts:Create(cardStroke, TI, {Color = PINK_DIM}):Play()
    else
        statusLbl.Text = "● OFF"
        Ts:Create(statusLbl,  TI, {TextColor3 = GREY}):Play()
        Ts:Create(statusStroke, TI, {Color = PILL_OFF}):Play()
        Ts:Create(iconRing,   TI, {Color = Color3.fromRGB(90,80,110)}):Play()
        Ts:Create(cardStroke, TI, {Color = Color3.fromRGB(52,44,66)}):Play()
    end
end

-- ── Toggle logic ─────────────────────────────
abPillBtn.MouseButton1Click:Connect(function()
    State.aimActive = not State.aimActive
    abSet(State.aimActive)
    if State.aimActive then startAimbot() else stopAimbot() end
    refreshStatus()
end)

dsPillBtn.MouseButton1Click:Connect(function()
    State.desyncActive = not State.desyncActive
    dsSet(State.desyncActive)
    if State.desyncActive then startDesync() else stopDesync() end
    refreshStatus()
end)

-- ── Keybind chips ────────────────────────────
local function setupKeybind(kbBtn, kbs, defaultKey, onFire)
    local bound    = defaultKey
    local listening = false

    kbBtn.MouseButton1Click:Connect(function()
        listening = true
        kbBtn.Text = "?"
        Ts:Create(kbs, TI, {Color = PINK}):Play()
    end)

    UIS.InputBegan:Connect(function(inp, gpe)
        if listening and not gpe then
            if inp.KeyCode == Enum.KeyCode.Escape then
                listening = false
                kbBtn.Text = tostring(bound):gsub("Enum.KeyCode.", "")
                Ts:Create(kbs, TI, {Color = PILL_OFF}):Play()
                return
            end
            if inp.UserInputType == Enum.UserInputType.Keyboard then
                bound = inp.KeyCode
                kbBtn.Text = tostring(inp.KeyCode):gsub("Enum.KeyCode.", "")
                listening = false
                Ts:Create(kbs, TI, {Color = PILL_OFF}):Play()
                return
            end
        end
        if not listening and inp.KeyCode == bound and not gpe then
            onFire()
        end
    end)
end

setupKeybind(abKbBtn, abKbs, Enum.KeyCode.V, function()
    State.aimActive = not State.aimActive
    abSet(State.aimActive)
    if State.aimActive then startAimbot() else stopAimbot() end
    refreshStatus()
end)

setupKeybind(dsKbBtn, dsKbs, Enum.KeyCode.B, function()
    State.desyncActive = not State.desyncActive
    dsSet(State.desyncActive)
    if State.desyncActive then startDesync() else stopDesync() end
    refreshStatus()
end)

-- LCTRL hides/shows
UIS.InputBegan:Connect(function(inp, gpe)
    if inp.KeyCode == Enum.KeyCode.LeftControl and not gpe then
        card.Visible = not card.Visible
    end
end)

-- ── Drag ─────────────────────────────────────
local dragging, dragStart, cardStart = false, nil, nil
header.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1
    or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = inp.Position; cardStart = card.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UIS.InputChanged:Connect(function(inp)
    if not dragging then return end
    if inp.UserInputType == Enum.UserInputType.MouseMovement
    or inp.UserInputType == Enum.UserInputType.Touch then
        local d = inp.Position - dragStart
        card.Position = UDim2.new(cardStart.X.Scale, cardStart.X.Offset+d.X,
                                   cardStart.Y.Scale, cardStart.Y.Offset+d.Y)
    end
end)

refreshStatus()
print("Adapt Desync Aimbot loaded — V = aimbot, B = desync, LCTRL = hide")