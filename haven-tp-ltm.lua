print("[Haven TP LTM] loading...")
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService  = game:GetService("HttpService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

local SAVE_FILE = "haven_tp_ltm.json"

local S = {
    currentIsland = 1,
    jumpPower = 40,
    speed = 180,
    isRunning = false,
    cancelled = false,
    minimized = false,
    token = 0,
}

local ISLANDS = {
    [1] = { Vector3.new(-477.6947937011719, 589.7150268554688, 43.36784744262695), Vector3.new(-428.7076110839844, 581.099365234375, 48.85251998901367) },
    [2] = { Vector3.new(-427.9349060058594, 2413.630126953125, 64.57102966308594), Vector3.new(-478.62750244140627, 2242.79931640625, 68.71845245361328) },
    [3] = { Vector3.new(-474.3545227050781, 4337.53955078125, 66.73695373535156), Vector3.new(-399.5567932128906, 4021.148193359375, 35.86958312988281) },
    [4] = { Vector3.new(-441.6107177734375, 6572.6220703125, -2.9265573024749758), Vector3.new(-462.0755920410156, 6479.14697265625, 30.364107131958009) },
    [5] = { Vector3.new(-450.3829650878906, 10306.4580078125, 32.63842010498047), Vector3.new(-392.8767395019531, 10299.484375, 24.287227630615236) },
    [6] = { Vector3.new(-460.9732971191406, 14333.2158203125, 117.75733184814453), Vector3.new(-460.8213806152344, 14264.2890625, 78.51557159423828) },
    [7] = { Vector3.new(-516.943603515625, 19996.8515625, 20.481746673583986), Vector3.new(-414.93377685546877, 19681.548828125, -1.2127071619033814) },
}

local ISLAND_COLORS = {
    Color3.fromRGB(255, 82, 82),
    Color3.fromRGB(255, 152, 0),
    Color3.fromRGB(255, 220, 60),
    Color3.fromRGB(76, 217, 100),
    Color3.fromRGB(0, 210, 200),
    Color3.fromRGB(88, 166, 255),
    Color3.fromRGB(168, 130, 255),
}

local function loadSave()
    if not isfile or not readfile then return end
    local ok, data = pcall(function()
        if isfile(SAVE_FILE) then return HttpService:JSONDecode(readfile(SAVE_FILE)) end
    end)
    if not ok or type(data) ~= "table" then return end
    if type(data.jumpPower) == "number" then S.jumpPower = math.max(0, data.jumpPower) end
    if type(data.speed) == "number" then S.speed = math.max(1, data.speed) end
end

local function saveAll()
    if not writefile then return end
    pcall(function()
        writefile(SAVE_FILE, HttpService:JSONEncode({
            jumpPower = S.jumpPower,
            speed = S.speed,
        }))
    end)
end

loadSave()

local function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function applyJumpPower()
    local h = getHum()
    if h then
        pcall(function()
            h.UseJumpPower = true
            h.JumpPower = S.jumpPower
        end)
    end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    applyJumpPower()
end)
if LP.Character then task.defer(applyJumpPower) end

UIS.JumpRequest:Connect(function()
    local h = getHum()
    if h and h.Parent then
        pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end)
    end
end)

local espFolder = Instance.new("Folder")
espFolder.Name = "HavenTP_LTM_ESP"
espFolder.Parent = workspace

local espParts = {}

local function clearESP()
    for _, part in pairs(espParts) do
        pcall(function() part:Destroy() end)
    end
    espParts = {}
end

local function buildESP()
    clearESP()
    for i = 1, 7 do
        local island = ISLANDS[i]
        local color = ISLAND_COLORS[i]
        if island and #island >= 2 then
            local pos = island[2]
            local part = Instance.new("Part")
            part.Size = Vector3.new(2.4, 2.4, 2.4)
            part.Position = pos
            part.Anchored = true
            part.CanCollide = false
            part.CanQuery = false
            part.CanTouch = false
            part.Material = Enum.Material.Neon
            part.Color = color
            part.Transparency = 0.25
            part.Name = "ESP_" .. i
            part.Parent = espFolder

            local light = Instance.new("PointLight", part)
            light.Color = color
            light.Range = 30
            light.Brightness = 6

            local hl = Instance.new("Highlight", part)
            hl.FillColor = color
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.55
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

            local bb = Instance.new("BillboardGui", part)
            bb.Size = UDim2.fromOffset(140, 30)
            bb.StudsOffset = Vector3.new(0, 4.5, 0)
            bb.AlwaysOnTop = true
            bb.MaxDistance = math.huge

            local lbl = Instance.new("TextLabel", bb)
            lbl.Size = UDim2.fromScale(1, 1)
            lbl.BackgroundTransparency = 1
            lbl.Text = "ISLAND " .. i
            lbl.TextColor3 = color
            lbl.TextStrokeTransparency = 0
            lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
            lbl.Font = Enum.Font.GothamBlack
            lbl.TextSize = 18

            espParts[i] = part
        end
    end
end

local antiFlingConn = nil

local function startAntiFling()
    if antiFlingConn then pcall(function() antiFlingConn:Disconnect() end) end
    antiFlingConn = RunService.Heartbeat:Connect(function()
        if not S.isRunning then return end
        local r = getRoot()
        if not r then return end
        local vel = r.AssemblyLinearVelocity
        local maxVel = S.speed * 1.3
        if vel.Magnitude > maxVel then
            pcall(function() r.AssemblyLinearVelocity = vel.Unit * maxVel end)
        end
        if r.AssemblyAngularVelocity.Magnitude > 3 then
            pcall(function() r.AssemblyAngularVelocity = Vector3.zero end)
        end
    end)
end

local function stopAntiFling()
    if antiFlingConn then
        pcall(function() antiFlingConn:Disconnect() end)
        antiFlingConn = nil
    end
end

local function stopFly()
    S.isRunning = false
    stopAntiFling()
    local h, r = getHum(), getRoot()
    if h and h.Parent then
        h.WalkSpeed = 16
        h.PlatformStand = false
        h.AutoRotate = true
    end
    if r and r.Parent then
        r.AssemblyLinearVelocity = Vector3.zero
        r.AssemblyAngularVelocity = Vector3.zero
    end
end

local function tweenMove(target, token)
    local char = LP.Character
    if not char then return false end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end

    pcall(function() root:SetNetworkOwner(LP) end)

    local oldVel = root:FindFirstChild("HavenVel")
    if oldVel then oldVel:Destroy() end
    local oldAO = root:FindFirstChild("HavenAO")
    if oldAO then oldAO:Destroy() end
    local oldAtt = root:FindFirstChild("HavenAtt")
    if oldAtt then oldAtt:Destroy() end
    local oldOAtt = root:FindFirstChild("HavenOrientAtt")
    if oldOAtt then oldOAtt:Destroy() end

    local att = Instance.new("Attachment", root)
    att.Name = "HavenAtt"

    local vel = Instance.new("LinearVelocity", root)
    vel.Name = "HavenVel"
    vel.Attachment0 = att
    vel.RelativeTo = Enum.ActuatorRelativeTo.World
    vel.MaxForce = math.huge
    vel.VectorVelocity = Vector3.zero

    local oAtt = Instance.new("Attachment", root)
    oAtt.Name = "HavenOrientAtt"

    local ao = Instance.new("AlignOrientation", root)
    ao.Name = "HavenAO"
    ao.Attachment0 = oAtt
    ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
    ao.CFrame = root.CFrame
    ao.MaxTorque = math.huge
    ao.MaxAngularVelocity = 300
    ao.Responsiveness = 40

    hum.WalkSpeed = 0
    hum.PlatformStand = true
    hum.AutoRotate = false

    local savedCollide = {}
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part ~= root then
            savedCollide[part] = part.CanCollide
            part.CanCollide = false
        end
    end

    local speed = S.speed
    local ARRIVE = 3.5
    local SLOW_DIST = 30
    local MIN_SPD = math.max(15, speed * 0.15)
    local deadline = tick() + 120

    while S.isRunning and token == S.token and tick() < deadline do
        if not root or not root.Parent or not hum.Parent or hum.Health <= 0 then break end

        local currentPos = root.Position
        local diff = target - currentPos
        local dist = diff.Magnitude

        if dist <= ARRIVE then break end

        local spd = speed
        if dist < SLOW_DIST then
            spd = math.max(MIN_SPD, speed * (dist / SLOW_DIST))
        end

        local dir = diff.Unit
        vel.VectorVelocity = dir * spd

        local flatDir = Vector3.new(dir.X, 0, dir.Z)
        if flatDir.Magnitude > 0.01 then
            ao.CFrame = CFrame.lookAt(Vector3.zero, flatDir.Unit)
        end

        local av = root.AssemblyAngularVelocity
        if av.Magnitude > 3 then
            pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
        end

        local lv = root.AssemblyLinearVelocity
        if lv.Magnitude > spd * 1.6 then
            pcall(function() root.AssemblyLinearVelocity = dir * spd end)
        end

        hum.PlatformStand = true
        hum.AutoRotate = false

        RunService.Heartbeat:Wait()
    end

    if vel.Parent then vel:Destroy() end
    if ao.Parent then ao:Destroy() end
    if att.Parent then att:Destroy() end
    if oAtt.Parent then oAtt:Destroy() end

    if root and root.Parent then
        for _ = 1, 5 do
            if not root.Parent then break end
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            RunService.Heartbeat:Wait()
        end
        pcall(function() root.CFrame = CFrame.new(target) end)
        pcall(function()
            root.Anchored = true
            RunService.Heartbeat:Wait()
            RunService.Heartbeat:Wait()
            root.Anchored = false
        end)
        for _ = 1, 3 do
            if not root.Parent then break end
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            RunService.Heartbeat:Wait()
        end
    end

    task.wait(0.05)
    for part, val in pairs(savedCollide) do
        if part and part.Parent then
            pcall(function() part.CanCollide = val end)
        end
    end

    if hum and hum.Parent then
        hum.WalkSpeed = 16
        hum.PlatformStand = false
        hum.AutoRotate = true
    end

    return true
end

local UI
local function buildUI()
    local mk = function(cls, parent, props)
        local o = Instance.new(cls)
        for k,v in pairs(props or {}) do o[k]=v end
        o.Parent = parent
        return o
    end
    local crn = function(o, r)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, r or 8)
        c.Parent = o
        return c
    end
    local strk = function(o, c, t, tr)
        local s = Instance.new("UIStroke")
        s.Color = c
        s.Thickness = t or 1
        s.Transparency = tr or 0
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent = o
        return s
    end
    local grd = function(o, c1, c2, rot)
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new(c1, c2)
        g.Rotation = rot or 0
        g.Parent = o
        return g
    end

    local C = {
        bg        = Color3.fromRGB(26, 20, 32),
        card      = Color3.fromRGB(33, 25, 44),
        cardHi    = Color3.fromRGB(47, 36, 63),
        input     = Color3.fromRGB(31, 23, 41),
        accent    = Color3.fromRGB(168, 130, 255),
        accent2   = Color3.fromRGB(132, 82, 255),
        accentHi  = Color3.fromRGB(255, 245, 255),
        text      = Color3.fromRGB(232, 226, 242),
        mute      = Color3.fromRGB(152, 122, 152),
        mute2     = Color3.fromRGB(112, 85, 95),
        stroke    = Color3.fromRGB(60, 46, 68),
        strokeHi  = Color3.fromRGB(86, 66, 102),
        danger    = Color3.fromRGB(255, 95, 95),
        green     = Color3.fromRGB(80, 220, 150),
        yellow    = Color3.fromRGB(255, 200, 80),
    }

    local gui = mk("ScreenGui", PG, {
        Name = "HavenTP_LTM",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
        IgnoreGuiInset = true,
    })

    local W, H = 250, 320
    local HEADER_H = 46
    local PAD = 10
    local GAP = 8

    local root = mk("Frame", gui, {
        Size = UDim2.fromOffset(W, H),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        ZIndex = 5,
    })
    local uiScale = Instance.new("UIScale")
    uiScale.Parent = root

    local glowWrap = mk("Frame", root, {
        Size = UDim2.new(1, 24, 1, 24),
        Position = UDim2.fromOffset(-12, -12),
        BackgroundColor3 = C.accent,
        BackgroundTransparency = 0.92,
        BorderSizePixel = 0,
        ZIndex = 0,
    })
    crn(glowWrap, 30)
    local gwg = Instance.new("UIGradient")
    gwg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.accent),
        ColorSequenceKeypoint.new(0.33, C.accent2),
        ColorSequenceKeypoint.new(0.66, C.accent),
        ColorSequenceKeypoint.new(1, C.accent2),
    })
    gwg.Rotation = 45
    gwg.Parent = glowWrap

    local shadow = mk("Frame", root, {
        Size = UDim2.new(1, 4, 1, 4),
        Position = UDim2.fromOffset(-2, 6),
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        ZIndex = 1,
    })
    crn(shadow, 16)

    local main = mk("Frame", root, {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = C.bg,
        BorderSizePixel = 0,
        Active = true,
        ClipsDescendants = true,
        ZIndex = 5,
    })
    crn(main, 16)
    strk(main, C.strokeHi, 1, 0.3)

    local header = mk("Frame", main, {
        Size = UDim2.new(1, 0, 0, HEADER_H),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Active = true,
        ZIndex = 10,
    })

    local logoOuter = mk("Frame", header, {
        Size = UDim2.fromOffset(28, 28),
        Position = UDim2.new(0, PAD, 0.5, -14),
        BackgroundColor3 = C.accent,
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        ZIndex = 11,
    })
    crn(logoOuter, 9)

    local logoMid = mk("Frame", logoOuter, {
        Size = UDim2.fromScale(0.72, 0.72),
        Position = UDim2.fromScale(0.14, 0.14),
        BackgroundColor3 = C.accent,
        BackgroundTransparency = 0.55,
        BorderSizePixel = 0,
        ZIndex = 12,
    })
    crn(logoMid, 6)

    local logoCore = mk("Frame", logoMid, {
        Size = UDim2.fromScale(0.68, 0.68),
        Position = UDim2.fromScale(0.16, 0.16),
        BackgroundColor3 = C.accentHi,
        BorderSizePixel = 0,
        ZIndex = 13,
    })
    crn(logoCore, 5)
    grd(logoCore, C.accentHi, C.accent, 45)

    mk("TextLabel", header, {
        Size = UDim2.new(1, -170, 0, 15),
        Position = UDim2.fromOffset(PAD + 36, 8),
        BackgroundTransparency = 1,
        Text = "HAVEN TP LTM",
        TextColor3 = C.accentHi,
        Font = Enum.Font.GothamBlack,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 12,
    })

    mk("TextLabel", header, {
        Size = UDim2.new(1, -170, 0, 10),
        Position = UDim2.fromOffset(PAD + 36, 23),
        BackgroundTransparency = 1,
        Text = "islands · tp · esp",
        TextColor3 = C.mute,
        Font = Enum.Font.GothamMedium,
        TextSize = 8,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 12,
    })

    local closeBtn = mk("TextButton", header, {
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.new(1, -22, 0.5, -10),
        BackgroundColor3 = C.card,
        BackgroundTransparency = 0.3,
        Text = "×",
        TextColor3 = C.mute,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        ZIndex = 12,
    })
    crn(closeBtn, 6)

    local minBtn = mk("TextButton", header, {
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.new(1, -45, 0.5, -10),
        BackgroundColor3 = C.card,
        BackgroundTransparency = 0.3,
        Text = "−",
        TextColor3 = C.mute,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        ZIndex = 12,
    })
    crn(minBtn, 6)

    local statusDot = mk("Frame", header, {
        Size = UDim2.fromOffset(5, 5),
        Position = UDim2.new(1, -112, 0.5, -2),
        BackgroundColor3 = C.green,
        BorderSizePixel = 0,
        ZIndex = 12,
    })
    crn(statusDot, 2)

    local statusLbl = mk("TextLabel", header, {
        Size = UDim2.fromOffset(55, 12),
        Position = UDim2.new(1, -104, 0.5, -6),
        BackgroundTransparency = 1,
        Text = "Ready",
        TextColor3 = C.mute,
        Font = Enum.Font.GothamBold,
        TextSize = 8,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 12,
    })

    minBtn.MouseEnter:Connect(function()
        TweenService:Create(minBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = C.accent, BackgroundTransparency = 0, TextColor3 = C.accentHi,
        }):Play()
    end)
    minBtn.MouseLeave:Connect(function()
        TweenService:Create(minBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = C.card, BackgroundTransparency = 0.3, TextColor3 = C.mute,
        }):Play()
    end)
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = C.danger, BackgroundTransparency = 0, TextColor3 = Color3.new(1,1,1),
        }):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = C.card, BackgroundTransparency = 0.3, TextColor3 = C.mute,
        }):Play()
    end)

    local content = mk("Frame", main, {
        Size = UDim2.new(1, -PAD * 2, 1, -(HEADER_H + 6)),
        Position = UDim2.fromOffset(PAD, HEADER_H + 3),
        BackgroundTransparency = 1,
        ZIndex = 6,
    })

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.FillDirection = Enum.FillDirection.Vertical
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, GAP)
    contentLayout.Parent = content

    local function card(order, height)
        local c = mk("Frame", content, {
            Size = UDim2.new(1, 0, 0, height),
            BackgroundColor3 = C.card,
            BorderSizePixel = 0,
            LayoutOrder = order,
            ZIndex = 7,
        })
        crn(c, 12)
        strk(c, C.stroke, 1, 0.35)
        return c
    end

    local function arrowBtn(parent, xPos, xOff, text)
        local b = mk("TextButton", parent, {
            Size = UDim2.fromOffset(26, 26),
            Position = UDim2.new(xPos, xOff, 0.5, -13),
            BackgroundColor3 = C.cardHi,
            Text = text,
            TextColor3 = C.text,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            ZIndex = 9,
        })
        crn(b, 7)
        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = C.accent, TextColor3 = C.accentHi}):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = C.cardHi, TextColor3 = C.text}):Play()
        end)
        b.MouseButton1Down:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.06), {BackgroundColor3 = C.accent2}):Play()
        end)
        return b
    end

    local islandCard = card(1, 48)

    local islandStrip = mk("Frame", islandCard, {
        Size = UDim2.new(0, 3, 1, -14),
        Position = UDim2.fromOffset(0, 7),
        BackgroundColor3 = ISLAND_COLORS[S.currentIsland],
        BorderSizePixel = 0,
        ZIndex = 8,
    })
    crn(islandStrip, 2)

    mk("TextLabel", islandCard, {
        Size = UDim2.new(1, -95, 0, 10),
        Position = UDim2.fromOffset(12, 7),
        BackgroundTransparency = 1,
        Text = "CURRENT ISLAND",
        TextColor3 = C.mute,
        Font = Enum.Font.GothamBold,
        TextSize = 8,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8,
    })

    local islandValue = mk("TextLabel", islandCard, {
        Size = UDim2.new(1, -95, 0, 20),
        Position = UDim2.fromOffset(12, 20),
        BackgroundTransparency = 1,
        Text = "Island " .. S.currentIsland,
        TextColor3 = C.accentHi,
        Font = Enum.Font.GothamBlack,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8,
    })

    local prevIslandBtn = arrowBtn(islandCard, 1, -64, "◀")
    local nextIslandBtn = arrowBtn(islandCard, 1, -34, "▶")

    local statsCard = card(2, 74)

    mk("TextLabel", statsCard, {
        Size = UDim2.new(0, 95, 0, 10),
        Position = UDim2.fromOffset(10, 8),
        BackgroundTransparency = 1,
        Text = "JUMP POWER",
        TextColor3 = C.mute,
        Font = Enum.Font.GothamBold,
        TextSize = 8,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8,
    })

    mk("TextLabel", statsCard, {
        Size = UDim2.new(0, 95, 0, 10),
        Position = UDim2.fromOffset(128, 8),
        BackgroundTransparency = 1,
        Text = "SPEED",
        TextColor3 = C.mute,
        Font = Enum.Font.GothamBold,
        TextSize = 8,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8,
    })

    local function smallBtn(parent, xOff, text)
        local b = mk("TextButton", parent, {
            Size = UDim2.fromOffset(22, 26),
            Position = UDim2.fromOffset(xOff, 36),
            BackgroundColor3 = C.cardHi,
            Text = text,
            TextColor3 = C.text,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            ZIndex = 9,
        })
        crn(b, 6)
        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = C.accent, TextColor3 = C.accentHi}):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = C.cardHi, TextColor3 = C.text}):Play()
        end)
        b.MouseButton1Down:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.06), {BackgroundColor3 = C.accent2}):Play()
        end)
        return b
    end

    local jumpMinus = smallBtn(statsCard, 10, "−")

    local jumpBox = mk("TextBox", statsCard, {
        Size = UDim2.fromOffset(52, 26),
        Position = UDim2.fromOffset(34, 36),
        BackgroundColor3 = C.input,
        Text = tostring(S.jumpPower),
        PlaceholderText = "50",
        PlaceholderColor3 = C.mute2,
        TextColor3 = C.accentHi,
        Font = Enum.Font.GothamBlack,
        TextSize = 12,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 8,
    })
    crn(jumpBox, 6)
    strk(jumpBox, C.stroke, 1, 0.3)

    local jumpPlus = smallBtn(statsCard, 88, "+")

    local speedMinus = smallBtn(statsCard, 128, "−")

    local speedBox = mk("TextBox", statsCard, {
        Size = UDim2.fromOffset(52, 26),
        Position = UDim2.fromOffset(152, 36),
        BackgroundColor3 = C.input,
        Text = tostring(S.speed),
        PlaceholderText = "180",
        PlaceholderColor3 = C.mute2,
        TextColor3 = C.accentHi,
        Font = Enum.Font.GothamBlack,
        TextSize = 12,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 8,
    })
    crn(speedBox, 6)
    strk(speedBox, C.stroke, 1, 0.3)

    local speedPlus = smallBtn(statsCard, 206, "+")

    local actionsCard = card(3, 86)
    local actionsLayout = Instance.new("UIListLayout")
    actionsLayout.FillDirection = Enum.FillDirection.Vertical
    actionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    actionsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    actionsLayout.Padding = UDim.new(0, 6)
    actionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    actionsLayout.Parent = actionsCard

    local actionsPad = Instance.new("UIPadding")
    actionsPad.PaddingTop = UDim.new(0, 10)
    actionsPad.PaddingBottom = UDim.new(0, 10)
    actionsPad.PaddingLeft = UDim.new(0, 10)
    actionsPad.PaddingRight = UDim.new(0, 10)
    actionsPad.Parent = actionsCard

    local function mkActionBtn(parent, text, c1, c2, order, height, size)
        local b = mk("TextButton", parent, {
            Size = UDim2.new(1, 0, 0, height),
            BackgroundColor3 = c1,
            Text = text,
            TextColor3 = Color3.new(1,1,1),
            Font = Enum.Font.GothamBlack,
            TextSize = size,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            LayoutOrder = order,
            ZIndex = 8,
        })
        crn(b, 10)
        grd(b, c1, c2, 90)
        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.12}):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
        end)
        b.MouseButton1Down:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.06), {BackgroundTransparency = 0.28}):Play()
        end)
        return b
    end

    local goBtn = mkActionBtn(actionsCard, "START", Color3.fromRGB(64,190,120), Color3.fromRGB(38,140,90), 1, 32, 13)
    local stopBtn = mkActionBtn(actionsCard, "STOP", Color3.fromRGB(230,85,85), Color3.fromRGB(170,55,55), 2, 24, 11)

    return {
        gui = gui, root = root, main = main, header = header, content = content,
        minBtn = minBtn, closeBtn = closeBtn, statusDot = statusDot, statusLbl = statusLbl,
        uiScale = uiScale, islandValue = islandValue, islandStrip = islandStrip,
        prevIslandBtn = prevIslandBtn, nextIslandBtn = nextIslandBtn,
        jumpBox = jumpBox, jumpMinus = jumpMinus, jumpPlus = jumpPlus,
        speedBox = speedBox, speedMinus = speedMinus, speedPlus = speedPlus,
        goBtn = goBtn, stopBtn = stopBtn,
        W = W, H = H, HEADER_H = HEADER_H, C = C,
    }
end

UI = buildUI()

local function setJumpPower(n)
    if n ~= n or n == math.huge or n == -math.huge then return end
    S.jumpPower = math.max(0, math.floor(n + 0.5))
    UI.jumpBox.Text = tostring(S.jumpPower)
    applyJumpPower()
    saveAll()
end

local function setSpeed(n)
    if n ~= n or n == math.huge or n == -math.huge then return end
    S.speed = math.max(1, math.floor(n + 0.5))
    UI.speedBox.Text = tostring(S.speed)
    saveAll()
end

local function setStatus(text, color)
    UI.statusLbl.Text = text
    UI.statusDot.BackgroundColor3 = color
end

local function runPath()
    if S.isRunning then return end
    local island = ISLANDS[S.currentIsland]
    if not island then return end

    S.isRunning = true
    S.cancelled = false
    S.token = S.token + 1
    local myToken = S.token

    startAntiFling()

    task.spawn(function()
        for i, target in ipairs(island) do
            if S.cancelled or myToken ~= S.token then break end
            setStatus("WP " .. i .. "/" .. #island, UI.C.yellow)
            tweenMove(target, myToken)
        end
        stopFly()
        if not S.cancelled and myToken == S.token then
            setStatus("Ready", UI.C.green)
        end
    end)
end

UI.prevIslandBtn.MouseButton1Click:Connect(function()
    S.currentIsland = S.currentIsland - 1
    if S.currentIsland < 1 then S.currentIsland = 7 end
    UI.islandValue.Text = "Island " .. S.currentIsland
    UI.islandStrip.BackgroundColor3 = ISLAND_COLORS[S.currentIsland]
end)

UI.nextIslandBtn.MouseButton1Click:Connect(function()
    S.currentIsland = S.currentIsland + 1
    if S.currentIsland > 7 then S.currentIsland = 1 end
    UI.islandValue.Text = "Island " .. S.currentIsland
    UI.islandStrip.BackgroundColor3 = ISLAND_COLORS[S.currentIsland]
end)

UI.jumpMinus.MouseButton1Click:Connect(function() setJumpPower(S.jumpPower - 5) end)
UI.jumpPlus.MouseButton1Click:Connect(function() setJumpPower(S.jumpPower + 5) end)
UI.speedMinus.MouseButton1Click:Connect(function() setSpeed(S.speed - 10) end)
UI.speedPlus.MouseButton1Click:Connect(function() setSpeed(S.speed + 10) end)

UI.jumpBox:GetPropertyChangedSignal("Text"):Connect(function()
    local t = UI.jumpBox.Text:gsub("[^%d]", "")
    if t ~= UI.jumpBox.Text then UI.jumpBox.Text = t end
end)
UI.jumpBox.FocusLost:Connect(function()
    local n = tonumber(UI.jumpBox.Text)
    if n then setJumpPower(n) else UI.jumpBox.Text = tostring(S.jumpPower) end
end)

UI.speedBox:GetPropertyChangedSignal("Text"):Connect(function()
    local t = UI.speedBox.Text:gsub("[^%d]", "")
    if t ~= UI.speedBox.Text then UI.speedBox.Text = t end
end)
UI.speedBox.FocusLost:Connect(function()
    local n = tonumber(UI.speedBox.Text)
    if n then setSpeed(n) else UI.speedBox.Text = tostring(S.speed) end
end)

UI.goBtn.MouseButton1Click:Connect(function()
    setStatus("Starting", UI.C.yellow)
    runPath()
end)

UI.stopBtn.MouseButton1Click:Connect(function()
    S.cancelled = true
    S.token = S.token + 1
    stopFly()
    setStatus("Stopped", UI.C.danger)
end)

local function setMinimized(min)
    S.minimized = min
    local targetH = min and UI.HEADER_H or UI.H
    local info = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(UI.root, info, {Size = UDim2.fromOffset(UI.W, targetH)}):Play()
    if min then
        task.delay(0.12, function()
            if S.minimized then UI.content.Visible = false end
        end)
        UI.minBtn.Text = "+"
    else
        UI.content.Visible = true
        UI.minBtn.Text = "−"
    end
end

UI.minBtn.MouseButton1Click:Connect(function()
    setMinimized(not S.minimized)
end)

UI.closeBtn.MouseButton1Click:Connect(function()
    S.cancelled = true
    stopFly()
    clearESP()
    UI.gui.Enabled = false
end)

do
    local dragging = false
    local dragStart, startPos
    UI.header.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = UI.root.Position
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement
        and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local scale = UI.uiScale.Scale
        local d = (inp.Position - dragStart) / scale
        UI.root.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function fitToViewport()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vp = cam.ViewportSize
    local margin = 20
    local scale = math.min((vp.X - margin) / UI.W, (vp.Y - margin) / UI.H, 1)
    scale = math.max(scale, 0.55)
    UI.uiScale.Scale = scale
end

fitToViewport()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitToViewport)
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    local cam = workspace.CurrentCamera
    if cam then
        cam:GetPropertyChangedSignal("ViewportSize"):Connect(fitToViewport)
    end
    fitToViewport()
end)

buildESP()
UI.islandValue.Text = "Island " .. S.currentIsland
UI.islandStrip.BackgroundColor3 = ISLAND_COLORS[S.currentIsland]
UI.jumpBox.Text = tostring(S.jumpPower)
UI.speedBox.Text = tostring(S.speed)
setStatus("Ready", UI.C.green)

print("[Haven TP LTM] ready.")