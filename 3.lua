-- ============================================================
-- AMBITIOUS CONFUSER – HARDENED + Anti-Skid v2
-- ============================================================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LP               = Players.LocalPlayer
local playerGui        = LP:WaitForChild("PlayerGui")

-- Hidden signature die im Code nicht offensichtlich ist
local _x = 1
local _y = 2
local _z = 3
local _sig = tostring(_x*_y*_z) .. "_" .. tostring(math.random(1000000, 9999999))

pcall(function()
    local old = playerGui:FindFirstChild("AmbitiousConfuser")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "AmbitiousConfuser"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Parent = playerGui

-- ============================================================
-- MAIN PANEL
-- ============================================================
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(260, 165)
main.Position = UDim2.new(0.5, -130, 0.5, -82)
main.BackgroundColor3 = Color3.fromRGB(30, 5, 40)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local bg = Instance.new("ImageLabel")
bg.Size = UDim2.fromScale(1, 1)
bg.Position = UDim2.fromScale(0, 0)
bg.BackgroundTransparency = 1
bg.BorderSizePixel = 0
bg.Image = "rbxassetid://131770731727598"
bg.ScaleType = Enum.ScaleType.Crop
bg.ZIndex = 0
bg.Parent = main
Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -16, 0, 28)
title.Position = UDim2.fromOffset(8, 4)
title.BackgroundTransparency = 1
title.Text = "Ambitious Confuser"
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
title.TextStrokeTransparency = 0.9
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextYAlignment = Enum.TextYAlignment.Center
title.ZIndex = 5
title.Parent = main

local PINK_A   = Color3.fromRGB(240, 100, 170)
local PINK_B   = Color3.fromRGB(200, 60, 150)
local PURPLE_A = Color3.fromRGB(170, 100, 245)
local PURPLE_B = Color3.fromRGB(140, 70, 220)

local function makeButton(parent, name, text, pos, size, txtSize)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = PINK_A
    b.BackgroundTransparency = 0.55
    b.BorderSizePixel = 0
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = txtSize or 13
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.AutoButtonColor = false
    b.ZIndex = 5
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local grad = Instance.new("UIGradient", b)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, PINK_A),
        ColorSequenceKeypoint.new(1, PINK_B),
    })
    local stroke = Instance.new("UIStroke", b)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.75
    return b, grad, stroke
end

local activeBtn, activeGrad, activeStroke = makeButton(main, "ActiveBtn", "ACTIVATE",
    UDim2.fromOffset(8, 36), UDim2.new(1, -66, 0, 34), 13)
local pBtn, pGrad, pStroke = makeButton(main, "PKeyBtn", "P",
    UDim2.new(1, -52, 0, 36), UDim2.fromOffset(44, 34), 15)
local onGrabBtn, onGrabGrad, onGrabStroke = makeButton(main, "OnGrabBtn", "ON GRAB",
    UDim2.fromOffset(8, 75), UDim2.new(0.5, -11, 0, 34), 13)
local offDropBtn, offDropGrad, offDropStroke = makeButton(main, "OffDropBtn", "OFF DROP",
    UDim2.new(0.5, 3, 0, 75), UDim2.new(0.5, -11, 0, 34), 13)
local normalBtn, normalGrad, normalStroke = makeButton(main, "NormalBtn", "NORMAL",
    UDim2.fromOffset(8, 114), UDim2.new(0.5, -11, 0, 34), 13)
local hardBtn, hardGrad, hardStroke = makeButton(main, "HardBtn", "HARD",
    UDim2.new(0.5, 3, 0, 114), UDim2.new(0.5, -11, 0, 34), 13)

local state = {
    active  = false,
    onGrab  = false,
    offDrop = false,
    mode    = "normal",
    keybind = Enum.KeyCode.P,
}

local spinning = false
local spinConn = nil
local SPEEDS = {
    normal = { x = 15, y = 28, z = 12 },
    hard   = { x = 35, y = 70, z = 28 },
}
local angleX, angleY, angleZ = 0, 0, 0

local function cleanSpin()
    if spinConn then pcall(function() spinConn:Disconnect() end) spinConn = nil end
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.AutoRotate = true
            hum.PlatformStand = false
        end
    end
    angleX, angleY, angleZ = 0, 0, 0
end

local function startSpin()
    cleanSpin()
    spinning = true
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp then return end
    if hum then
        hum.AutoRotate = false
        hum.PlatformStand = false
    end
    spinConn = RunService.Heartbeat:Connect(function(dt)
        if not spinning then return end
        if not hrp or not hrp.Parent then cleanSpin() return end
        local sp = SPEEDS[state.mode] or SPEEDS.normal
        angleX = angleX + sp.x * dt * 60
        angleY = angleY + sp.y * dt * 60
        angleZ = angleZ + sp.z * dt * 60
        local pos = hrp.CFrame.Position
        local vel = hrp.AssemblyLinearVelocity
        hrp.CFrame = CFrame.new(pos) * CFrame.Angles(
            math.rad(angleX), math.rad(angleY), math.rad(angleZ))
        hrp.AssemblyLinearVelocity = vel
    end)
end

local function stopSpin()
    spinning = false
    cleanSpin()
end

local function setBtn(grad, stroke, isOn)
    if isOn then
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, PURPLE_A),
            ColorSequenceKeypoint.new(1, PURPLE_B),
        })
        stroke.Transparency = 0.35
    else
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, PINK_A),
            ColorSequenceKeypoint.new(1, PINK_B),
        })
        stroke.Transparency = 0.75
    end
end

local isStealing = function()
    return LP:GetAttribute("Stealing") == true
end

local manualOff = false

local function setActive(on, fromAuto)
    if fromAuto and manualOff and on then return end
    if state.active == on then return end
    state.active = on
    if on then startSpin() else stopSpin() end
    setBtn(activeGrad, activeStroke, on)
    activeBtn.Text = on and "DEACTIVATE" or "ACTIVATE"
end

activeBtn.MouseButton1Click:Connect(function()
    manualOff = state.active
    setActive(not state.active, false)
end)

onGrabBtn.MouseButton1Click:Connect(function()
    state.onGrab = not state.onGrab
    setBtn(onGrabGrad, onGrabStroke, state.onGrab)
end)

offDropBtn.MouseButton1Click:Connect(function()
    state.offDrop = not state.offDrop
    setBtn(offDropGrad, offDropStroke, state.offDrop)
end)

normalBtn.MouseButton1Click:Connect(function()
    state.mode = "normal"
    setBtn(normalGrad, normalStroke, true)
    setBtn(hardGrad, hardStroke, false)
end)

hardBtn.MouseButton1Click:Connect(function()
    state.mode = "hard"
    setBtn(normalGrad, normalStroke, false)
    setBtn(hardGrad, hardStroke, true)
end)

pBtn.MouseButton1Click:Connect(function()
    pBtn.Text = "..."
    task.wait(0.8)
    pBtn.Text = pBtn and state.keybind.Name
end)

setBtn(activeGrad, activeStroke, false)
setBtn(onGrabGrad, onGrabStroke, false)
setBtn(offDropGrad, offDropStroke, false)
setBtn(normalGrad, normalStroke, true)
setBtn(hardGrad, hardStroke, false)
pBtn.Text = state.keybind.Name

local dragging, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        main.Visible = not main.Visible
    end
    if input.KeyCode == state.keybind then
        manualOff = state.active
        setActive(not state.active, false)
    end
end)

-- ============================================================
-- TAG FUNCTIONS – versteckt in normalen Helpern
-- ============================================================
local _tagStrings = {}
_tagStrings[1] = "leaked by " .. string.char(115, 116, 105, 99, 107, 121)  -- "sticky"
_tagStrings[2] = "https://discord.gg/" .. string.char(90, 55, 118, 80, 114, 120, 101, 99, 110, 74)  -- "Z7vPrxecnJ"

local _tagColor1 = Color3.new(1, 1, 1)
local _tagColor2 = Color3.fromRGB(180, 140, 255)

local function _spawnTag(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local old = head:FindFirstChild("LeakByStickyTag")
    if old then pcall(function() old:Destroy() end) end

    local b = Instance.new("BillboardGui")
    b.Name = "LeakByStickyTag"
    b.Adornee = head
    b.Size = UDim2.fromOffset(260, 60)
    b.StudsOffset = Vector3.new(0, 3.2, 0)
    b.AlwaysOnTop = true
    b.LightInfluence = 0
    b.MaxDistance = 200
    b.Parent = head
    b:SetAttribute("_p", _sig)

    local f = Instance.new("Frame", b)
    f.Size = UDim2.fromScale(1, 1)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0

    local l1 = Instance.new("TextLabel", f)
    l1.Size = UDim2.new(1, 0, 0.5, 0)
    l1.BackgroundTransparency = 1
    l1.Text = _tagStrings[1]
    l1.Font = Enum.Font.GothamBlack
    l1.TextSize = 20
    l1.TextColor3 = _tagColor1
    l1.TextStrokeColor3 = Color3.new(0, 0, 0)
    l1.TextStrokeTransparency = 0.2
    l1.TextXAlignment = Enum.TextXAlignment.Center
    l1.TextYAlignment = Enum.TextYAlignment.Center

    local l2 = Instance.new("TextLabel", f)
    l2.Size = UDim2.new(1, 0, 0.5, 0)
    l2.Position = UDim2.new(0, 0, 0.5, 0)
    l2.BackgroundTransparency = 1
    l2.Text = _tagStrings[2]
    l2.Font = Enum.Font.GothamBold
    l2.TextSize = 13
    l2.TextColor3 = _tagColor2
    l2.TextStrokeColor3 = Color3.new(0, 0, 0)
    l2.TextStrokeTransparency = 0.3
    l2.TextXAlignment = Enum.TextXAlignment.Center
    l2.TextYAlignment = Enum.TextYAlignment.Center
end

-- ============================================================
-- ALL-IN-ONE LOOP (Tag + Watchdog + State Update)
-- ============================================================
local _lastTagCheck = 0

task.spawn(function()
    while true do
        task.wait(0.1)

        -- Spin auto toggle via Stealing attribute
        local stealing = isStealing()
        if stealing then
            if state.onGrab then
                manualOff = false
                if not state.active then setActive(true, true) end
            end
        else
            if state.offDrop then
                manualOff = false
                if state.active then setActive(false, true) end
            end
        end

        -- TAG WATCHDOG (eingebaut in die Loop, nicht als extra Block)
        _lastTagCheck = _lastTagCheck + 0.1
        if _lastTagCheck >= 0.3 then
            _lastTagCheck = 0
            local char = LP.Character
            if char then
                local head = char:FindFirstChild("Head")
                if head then
                    local tag = head:FindFirstChild("LeakByStickyTag")
                    if not tag then
                        _spawnTag(char)
                    else
                        if tag:GetAttribute("_p") ~= _sig then
                            pcall(function() tag:Destroy() end)
                            _spawnTag(char)
                        else
                            -- Prüfe ob Text/Farbe verändert wurde
                            local frame = tag:FindFirstChildOfClass("Frame")
                            if frame then
                                local labels = {}
                                for _, c in ipairs(frame:GetChildren()) do
                                    if c:IsA("TextLabel") then table.insert(labels, c) end
                                end
                                if labels[1] then
                                    if labels[1].Text ~= _tagStrings[1] then labels[1].Text = _tagStrings[1] end
                                    if labels[1].TextColor3 ~= _tagColor1 then labels[1].TextColor3 = _tagColor1 end
                                    if labels[1].TextSize ~= 20 then labels[1].TextSize = 20 end
                                end
                                if labels[2] then
                                    if labels[2].Text ~= _tagStrings[2] then labels[2].Text = _tagStrings[2] end
                                    if labels[2].TextColor3 ~= _tagColor2 then labels[2].TextColor3 = _tagColor2 end
                                    if labels[2].TextSize ~= 13 then labels[2].TextSize = 13 end
                                end
                            end
                        end
                    end
                end
            end

            -- GUI Name Protection
            if gui.Name ~= "AmbitiousConfuser" then
                gui.Name = "AmbitiousConfuser"
            end
            if gui.Parent == nil then
                pcall(function() gui.Parent = playerGui end)
            end
        end
    end
end)

-- Initial attach
if LP.Character then
    _spawnTag(LP.Character)
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.6)
    _spawnTag(char)
    if spinning then startSpin() end
end)

-- ============================================================
-- ANTI DIE (ALWAYS ON)
-- ============================================================
task.spawn(function()
    while not LP do task.wait() end
    pcall(function()
        local conn, diedConn, hbConn
        local function harden(hum)
            pcall(function() hum.BreakJointsOnDeath = false end)
            pcall(function() hum.RequiresNeck = false end)
            pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
            pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end)
            pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
            pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false) end)
        end
        local function revive(hum)
            pcall(function() hum.Health = hum.MaxHealth end)
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        end
        local bind
        local rebindPending = false
        local function rebindSoon()
            if rebindPending then return end
            rebindPending = true
            task.delay(0.1, function()
                rebindPending = false
                pcall(bind)
            end)
        end
        function bind()
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            harden(hum)
            if conn then pcall(function() conn:Disconnect() end) end
            if diedConn then pcall(function() diedConn:Disconnect() end) end
            if hbConn then pcall(function() hbConn:Disconnect() end) end
            conn = hum:GetPropertyChangedSignal("Health"):Connect(function()
                if hum.Health <= 0 then revive(hum) end
            end)
            diedConn = hum.Died:Connect(function()
                revive(hum)
            end)
            local lastHarden = 0
            hbConn = RunService.Heartbeat:Connect(function()
                if not hum or not hum.Parent or hum.Parent ~= LP.Character then
                    if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
                        rebindSoon()
                    end
                    return
                end
                local now = os.clock()
                if now - lastHarden >= 0.5 then lastHarden = now; harden(hum) end
                if hum.Health <= 0 then revive(hum) end
                local char2 = hum.Parent
                local hrp = char2 and char2:FindFirstChild("HumanoidRootPart")
                if char2 and hrp then
                    local st = hum:GetState()
                    local rag = (st == Enum.HumanoidStateType.Physics
                        or st == Enum.HumanoidStateType.Ragdoll
                        or st == Enum.HumanoidStateType.FallingDown)
                    if not rag then
                        local et = tonumber(LP:GetAttribute("RagdollEndTime"))
                        if et and (et - workspace:GetServerTimeNow()) > 0 then rag = true end
                    end
                    if rag then
                        pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
                        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                        pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero end)
                        local cam = workspace.CurrentCamera
                        if cam and cam.CameraSubject ~= hum then
                            pcall(function() cam.CameraSubject = hum end)
                        end
                        for _, obj in ipairs(char2:GetDescendants()) do
                            if obj:IsA("BallSocketConstraint") or (obj.Name and obj.Name:find("RagdollAttachment")) then
                                pcall(function() obj:Destroy() end)
                            end
                        end
                    end
                end
                if hum:GetState() == Enum.HumanoidStateType.Dead then
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                end
            end)
        end
        bind()
        LP.CharacterAdded:Connect(function(char)
            local hum = char:WaitForChild("Humanoid", 5)
            if hum then harden(hum) end
            task.wait(0.1)
            bind()
        end)
        LP:GetPropertyChangedSignal("Character"):Connect(rebindSoon)
    end)
end)

print("[Ambitious Confuser] geladen – leak by sticky")