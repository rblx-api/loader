--!optimize 0
-- LUAU TP | velocity walk + flash entry + steal range | green terminal

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer
local SPEED = 96
local FLOAT_SPEED = 74
local ARRIVE = 2.8
local FLOAT_THRESH = 4.6
local FLASH_DIST = 38
local STEAL_RANGE_DEFAULT = 7.2

local LuauCfg = {
    AutoOnLoad = true,
    Mode = "Flash",
    OnlyPriority = false,
    MinGen = 0,
    RecoverHit = true,
}

local C = {
    bg = Color3.fromRGB(0, 8, 0),
    surf = Color3.fromRGB(0, 14, 2),
    hi = Color3.fromRGB(0, 28, 6),
    row = Color3.fromRGB(0, 12, 3),
    line = Color3.fromRGB(0, 180, 40),
    acc = Color3.fromRGB(0, 255, 70),
    off = Color3.fromRGB(0, 22, 5),
    txt = Color3.fromRGB(180, 255, 180),
    sub = Color3.fromRGB(80, 160, 90),
    on = Color3.fromRGB(0, 255, 90),
}

local function mk(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

local function txt(parent, props)
    local t = mk("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.Code,
        TextSize = 14,
        TextColor3 = C.txt,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, parent)
    for k, v in pairs(props) do t[k] = v end
    return t
end

local gui = mk("ScreenGui", {
    Name = "LuauTP_UI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 99,
}, (gethui and gethui()) or CoreGui)

-- status bar
local bar = mk("Frame", {
    AnchorPoint = Vector2.new(0.5, 1),
    Size = UDim2.fromOffset(300, 62),
    Position = UDim2.new(0.5, 0, 1, -90),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
}, gui)
mk("UIStroke", { Color = C.line, Thickness = 1 }, bar)
mk("UICorner", { CornerRadius = UDim.new(0, 8) }, bar)

local title = txt(bar, {
    Position = UDim2.fromOffset(12, 5),
    Size = UDim2.new(1, -120, 0, 18),
    Text = "LUAU TP",
    TextSize = 16,
    Font = Enum.Font.Code,
    TextColor3 = C.acc,
})
local status = txt(bar, {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -12, 0, 5),
    Size = UDim2.fromOffset(120, 18),
    TextXAlignment = Enum.TextXAlignment.Right,
    TextSize = 12,
    TextColor3 = C.sub,
})
local progBg = mk("Frame", {
    Position = UDim2.new(0, 12, 0, 28),
    Size = UDim2.new(1, -24, 0, 9),
    BackgroundColor3 = C.off,
    BorderSizePixel = 0,
}, bar)
mk("UICorner", { CornerRadius = UDim.new(0, 4) }, progBg)
local prog = mk("Frame", {
    Size = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = C.acc,
    BorderSizePixel = 0,
}, progBg)
mk("UICorner", { CornerRadius = UDim.new(0, 4) }, prog)
local sub = txt(bar, {
    Position = UDim2.fromOffset(12, 40),
    Size = UDim2.new(1, -24, 0, 16),
    TextSize = 11,
    TextColor3 = C.sub,
})

local function setStatus(name, state, p, extra)
    title.Text = "LUAU TP"
    status.Text = state or ""
    prog.Size = UDim2.new(math.clamp(p or 0, 0, 1), 0, 1, 0)
    sub.Text = (name or "") .. (extra and ("  |  " .. extra) or "")
end

-- velocity walk + float
local function LuauWalkTo(target, stopDist)
    stopDist = stopDist or ARRIVE
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp or hum.Health <= 0 then return false end

    hum:MoveTo(target)

    local conn
    local finished = false
    conn = RunService.RenderStepped:Connect(function()
        if finished or not char.Parent or hum.Health <= 0 then
            if conn then conn:Disconnect() end
            return
        end

        local pos = hrp.Position
        local flat = Vector3.new(target.X - pos.X, 0, target.Z - pos.Z)
        local distFlat = flat.Magnitude
        local dy = target.Y - pos.Y

        if distFlat <= stopDist and math.abs(dy) <= FLOAT_THRESH then
            finished = true
            hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
            if conn then conn:Disconnect() end
            return
        end

        local md = hum.MoveDirection
        local vx, vz = 0, 0
        if md.Magnitude > 0.05 then
            vx = md.X * SPEED
            vz = md.Z * SPEED
        elseif distFlat > 0.35 then
            local unit = flat.Unit
            vx = unit.X * SPEED
            vz = unit.Z * SPEED
        end

        local vy = hrp.AssemblyLinearVelocity.Y
        if dy > FLOAT_THRESH then
            vy = math.clamp(dy * 1.9, 14, FLOAT_SPEED)
        elseif dy < -FLOAT_THRESH then
            vy = math.clamp(dy * 1.5, -FLOAT_SPEED, -9)
        end

        hrp.AssemblyLinearVelocity = Vector3.new(vx, vy, vz)
    end)

    local t0 = os.clock()
    while not finished and os.clock() - t0 < 20 do
        task.wait(0.04)
        if not char.Parent or hum.Health <= 0 then break end
    end
    if conn and conn.Connected then conn:Disconnect() end
    return finished
end

-- pathfinder
local function getSteal()
    local x = getgenv().X7Internal
    if type(x) == "table" and type(x.B) == "function" then
        local ok, steal = pcall(x.B)
        if ok and type(steal) == "table" then return steal end
    end
    local hub = getgenv().Hub
    if hub and hub.Steal then return hub.Steal end
    return nil
end

local function findBestTarget()
    local steal = getSteal()
    if not steal then return nil, nil end

    local target
    pcall(function()
        if type(steal.Choose) == "function" then
            target = steal.Choose(function(e)
                if LuauCfg.OnlyPriority and (e.Value or 0) <= 0 then return false end
                if LuauCfg.MinGen > 0 and (e.Income or 0) < LuauCfg.MinGen * 1e6 then return false end
                return true
            end)
        end
    end)

    if not target and type(steal.Ranked) == "function" then
        local ranked = steal.Ranked(true)
        if type(ranked) == "table" and #ranked > 0 then target = ranked[1] end
    end
    if not target then return nil, nil end

    local pos
    pcall(function()
        if type(steal.Spot) == "function" then pos = steal.Spot(target) end
    end)
    if not pos and target.Part and target.Part.Parent then
        pos = target.Part.Position + Vector3.new(0, 2.5, 0)
    end

    return target, pos
end

local function getStealRange(target)
    if not target then return STEAL_RANGE_DEFAULT end
    local prompt = target.Prompt
    if prompt and prompt:IsA("ProximityPrompt") then
        local d = prompt.MaxActivationDistance
        if type(d) == "number" and d > 1 then
            return math.clamp(d * 0.78, 4.5, 11)
        end
    end
    if target.Model then
        for _, d in target.Model:GetDescendants() do
            if d:IsA("ProximityPrompt") then
                local d2 = d.MaxActivationDistance
                if type(d2) == "number" and d2 > 1 then
                    return math.clamp(d2 * 0.78, 4.5, 11)
                end
            end
        end
    end
    return STEAL_RANGE_DEFAULT
end

local function calcFinalPos(target, basePos, range)
    if not basePos then return nil end
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return basePos end

    local dir = (hrp.Position - basePos)
    dir = Vector3.new(dir.X, 0, dir.Z)
    if dir.Magnitude < 0.1 then
        dir = Vector3.new(0, 0, -1)
    else
        dir = dir.Unit
    end
    local final = basePos + dir * range
    final = Vector3.new(final.X, basePos.Y + 1.2, final.Z)
    return final
end

local function doFlash(aimPos)
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return false end

    local tool = char:FindFirstChild("Flash Teleport") or (LP:FindFirstChildOfClass("Backpack") and LP.Backpack:FindFirstChild("Flash Teleport"))
    if not tool or not tool:IsA("Tool") then
        setStatus(nil, "NO FLASH", 0.3)
        return false
    end

    if tool.Parent ~= char then
        hum:EquipTool(tool)
        local t = os.clock() + 1.1
        while tool.Parent ~= char and os.clock() < t do
            RunService.Heartbeat:Wait()
        end
    end
    if tool.Parent ~= char then return false end

    pcall(function()
        getgenv().ShadowGrappleAim = aimPos
    end)
    local pm = getgenv().ShadowPM
    if type(pm) == "table" then
        pcall(function()
            pm.Hit = CFrame.new(aimPos)
            pm.Target = Workspace.Terrain
        end)
    end

    setStatus(nil, "FLASHING", 0.55)
    pcall(tool.Activate, tool)

    local start = hrp.Position
    local t0 = os.clock()
    while os.clock() - t0 < 1.4 do
        RunService.Heartbeat:Wait()
        if (hrp.Position - start).Magnitude > 9 then return true end
        local cd = tool:GetAttribute("CooldownTime")
        if type(cd) == "number" and cd > 0 then return true end
    end
    return (hrp.Position - start).Magnitude > 4
end

local busy = false
local function LuauGo()
    if busy then return false end
    busy = true

    setStatus(nil, "SCANNING", 0.08, "pathfinder")
    local target, pos = findBestTarget()
    if not target or not pos then
        setStatus(nil, "NO TARGET", 0)
        busy = false
        return false
    end

    local label = tostring(target.Index or "BRAINROT")
    local range = getStealRange(target)
    local finalPos = calcFinalPos(target, pos, range)

    setStatus(label, "WALKING", 0.2, "velocity")
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local dist = (hrp.Position - pos).Magnitude
        if dist > FLASH_DIST + 4 then
            local dir = (pos - hrp.Position)
            dir = Vector3.new(dir.X, 0, dir.Z).Unit
            local preFlash = pos - dir * (FLASH_DIST - 2)
            preFlash = Vector3.new(preFlash.X, pos.Y + 1, preFlash.Z)
            LuauWalkTo(preFlash, 4)
        end
    end

    setStatus(label, "FLASH", 0.5, "entry")
    doFlash(pos)

    setStatus(label, "FINAL", 0.75, string.format("range %.1f", range))
    if finalPos then
        LuauWalkTo(finalPos, 1.6)
    else
        LuauWalkTo(pos, 2.2)
    end

    setStatus(label, "IN RANGE", 1, "steal ready")
    busy = false
    return true
end

-- panel
local panel = mk("Frame", {
    Size = UDim2.fromOffset(270, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    Position = UDim2.new(0, 18, 0, 90),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    Active = true,
}, gui)
mk("UIStroke", { Color = C.line, Thickness = 1 }, panel)
mk("UICorner", { CornerRadius = UDim.new(0, 8) }, panel)

local header = mk("TextButton", {
    Size = UDim2.new(1, 0, 0, 34),
    BackgroundColor3 = C.surf,
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false,
}, panel)
mk("UICorner", { CornerRadius = UDim.new(0, 8) }, header)

txt(header, {
    Position = UDim2.fromOffset(14, 0),
    Size = UDim2.new(1, -28, 1, 0),
    Text = "LUAU TP",
    TextSize = 16,
    Font = Enum.Font.Code,
    TextColor3 = C.acc,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local dragging, dragStart, startPos = false, nil, nil
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local list = mk("Frame", {
    Position = UDim2.fromOffset(0, 34),
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
}, panel)
mk("UIListLayout", { Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder }, list)
mk("UIPadding", {
    PaddingLeft = UDim.new(0, 12),
    PaddingRight = UDim.new(0, 12),
    PaddingTop = UDim.new(0, 10),
    PaddingBottom = UDim.new(0, 14),
}, list)

local function rowToggle(label, get, set)
    local r = mk("Frame", {
        LayoutOrder = #list:GetChildren() + 1,
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = C.surf,
        BorderSizePixel = 0,
    }, list)
    mk("UICorner", { CornerRadius = UDim.new(0, 6) }, r)

    txt(r, {
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -56, 1, 0),
        Text = label,
        TextSize = 13,
    })
    local sw = mk("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(38, 20),
        BackgroundColor3 = C.off,
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
    }, r)
    mk("UICorner", { CornerRadius = UDim.new(0, 10) }, sw)

    local knob = mk("Frame", {
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = C.on,
        BorderSizePixel = 0,
    }, sw)
    mk("UICorner", { CornerRadius = UDim.new(1, 0) }, knob)

    local function refresh()
        local on = get()
        sw.BackgroundColor3 = on and C.acc or C.off
        knob.Position = on and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    end
    sw.MouseButton1Click:Connect(function()
        set(not get())
        refresh()
    end)
    refresh()
end

rowToggle("AUTO TP ON LOAD", function() return LuauCfg.AutoOnLoad end, function(v) LuauCfg.AutoOnLoad = v end)
rowToggle("RECOVER ON HIT", function() return LuauCfg.RecoverHit end, function(v) LuauCfg.RecoverHit = v end)
rowToggle("ONLY PRIORITY", function() return LuauCfg.OnlyPriority end, function(v) LuauCfg.OnlyPriority = v end)

-- TELEPORT button + keybind
local currentBind = Enum.KeyCode.T
local waitingForBind = false

local tpBtn = mk("TextButton", {
    LayoutOrder = 99,
    Size = UDim2.new(1, 0, 0, 38),
    BackgroundColor3 = C.acc,
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false,
}, list)
mk("UICorner", { CornerRadius = UDim.new(0, 7) }, tpBtn)

local tpLabel = txt(tpBtn, {
    Size = UDim2.new(1, 0, 1, 0),
    Text = "TELEPORT  [T]",
    TextSize = 15,
    Font = Enum.Font.Code,
    TextColor3 = Color3.new(0, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Center,
})

local function updateBindText()
    tpLabel.Text = "TELEPORT  [" .. currentBind.Name .. "]"
end
updateBindText()

tpBtn.MouseButton1Click:Connect(function()
    if waitingForBind then return end
    LuauGo()
end)

tpBtn.MouseButton2Click:Connect(function()
    waitingForBind = true
    tpLabel.Text = "PRESS KEY..."
    tpLabel.TextColor3 = C.acc
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if waitingForBind and input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode ~= Enum.KeyCode.Escape and input.KeyCode ~= Enum.KeyCode.Unknown then
            currentBind = input.KeyCode
        end
        waitingForBind = false
        tpLabel.TextColor3 = Color3.new(0, 0, 0)
        updateBindText()
        return
    end

    if gp then return end
    if input.KeyCode == currentBind then
        LuauGo()
    end
end)

task.spawn(function()
    if not LuauCfg.AutoOnLoad then return end
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(2.4)
    local t0 = os.clock()
    while os.clock() - t0 < 14 do
        if getSteal() then break end
        task.wait(0.3)
    end
    LuauGo()
end)