-- ============================================================
--  RIVALS AIMBOT – Halloween (lite + lag-free + WORKS WHILE MOVING)
--  Key fix: BindToRenderStep at Camera.Value + 1 (runs AFTER the
--  default camera controller, so tracking sticks while you move)
-- ============================================================
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local Camera     = workspace.CurrentCamera
local LP         = Players.LocalPlayer
local mouse      = LP:GetMouse()
local playerGui  = LP:WaitForChild("PlayerGui")

-- CONFIG
local AIM_PART   = "Head"
local MAX_DIST   = 1000
local AIM_SPEED  = 22          -- higher = snappier tracking
local SCAN_RATE  = 0.08        -- seconds between rescans when target is lost
local SNAP_ANGLE = math.rad(28) -- snap instantly if crosshair is this far off

-- STATE
local enabled, target, targetPart, lastStatus = false, nil, nil, ""

-- CLEANUP (safe re-execution)
if playerGui:FindFirstChild("SpookyAimbot") then playerGui.SpookyAimbot:Destroy() end
pcall(function() RunService:UnbindFromRenderStep("RivalsAimCam") end)

-- ------------------------------------------------------------
--  SMALL UI (same as before)
-- ------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "SpookyAimbot"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 170, 0, 88)
frame.Position = UDim2.new(0.5, -85, 0.5, -44)
frame.BackgroundColor3 = Color3.fromRGB(25, 15, 35)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 120, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -46, 0, 20)
title.Position = UDim2.new(0, 6, 0, 3)
title.BackgroundTransparency = 1
title.Text = "🎃 Rivals Aimbot"
title.TextColor3 = Color3.fromRGB(255, 150, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 18, 0, 18)
minBtn.Position = UDim2.new(1, -42, 0, 3)
minBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 13
minBtn.Parent = frame
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 4)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 18, 0, 18)
closeBtn.Position = UDim2.new(1, -22, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 11
closeBtn.Parent = frame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

local aimBtn = Instance.new("TextButton")
aimBtn.Size = UDim2.new(1, -12, 0, 28)
aimBtn.Position = UDim2.new(0, 6, 0, 28)
aimBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
aimBtn.TextColor3 = Color3.fromRGB(255, 210, 210)
aimBtn.Font = Enum.Font.GothamSemibold
aimBtn.TextSize = 12
aimBtn.Text = "Aimbot: OFF"
aimBtn.Parent = frame
Instance.new("UICorner", aimBtn).CornerRadius = UDim.new(0, 6)

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -12, 0, 16)
statusLbl.Position = UDim2.new(0, 6, 0, 60)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Target: none"
statusLbl.TextColor3 = Color3.fromRGB(180, 180, 220)
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 10
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Parent = frame

local bodyElements = {aimBtn, statusLbl}
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    frame.Size = minimized and UDim2.new(0, 170, 0, 24) or UDim2.new(0, 170, 0, 88)
    for _, v in ipairs(bodyElements) do v.Visible = not minimized end
    minBtn.Text = minimized and "+" or "-"
end)
closeBtn.MouseButton1Click:Connect(function()
    pcall(function() RunService:UnbindFromRenderStep("RivalsAimCam") end)
    gui:Destroy()
end)

-- ------------------------------------------------------------
--  TOGGLE
-- ------------------------------------------------------------
local function toggleAim()
    enabled = not enabled
    aimBtn.Text = enabled and "Aimbot: ON" or "Aimbot: OFF"
    aimBtn.BackgroundColor3 = enabled
        and Color3.fromRGB(0, 140, 0)
        or  Color3.fromRGB(60, 30, 90)
    if not enabled then
        target, targetPart = nil, nil
        if lastStatus ~= "Target: none" then
            lastStatus = "Target: none"
            statusLbl.Text = lastStatus
        end
    end
end
aimBtn.MouseButton1Click:Connect(toggleAim)
UIS.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.Z then toggleAim() end
end)

-- ------------------------------------------------------------
--  TARGET FINDER (only from throttled loop)
-- ------------------------------------------------------------
local function findTarget()
    local closest, shortest = nil, MAX_DIST
    local camPos = Camera.CFrame.Position
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            local char = p.Character
            if char then
                local part = char:FindFirstChild(AIM_PART)
                local hum  = char:FindFirstChildOfClass("Humanoid")
                if part and hum and hum.Health > 0 then
                    local d = (part.Position - camPos).Magnitude
                    if d < shortest then
                        shortest = d
                        closest  = p
                    end
                end
            end
        end
    end
    return closest
end

-- ------------------------------------------------------------
--  SILENT AIM (optional; uses cached targetPart, zero lookups)
-- ------------------------------------------------------------
if hookmetamethod and getrawmetatable and newcclosure then
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    setreadonly(mt, false)
    mt.__index = newcclosure(function(self, key)
        if enabled and targetPart and self == mouse then
            if key == "Target" then return targetPart end
            if key == "Hit"    then return CFrame.new(targetPart.Position) end
        end
        return oldIndex(self, key)
    end)
    setreadonly(mt, true)
end

-- ------------------------------------------------------------
--  THROTTLED TARGET SCAN (runs ~12.5 Hz, not every frame)
-- ------------------------------------------------------------
task.spawn(function()
    while gui.Parent do
        if enabled then
            local valid = targetPart
                and targetPart.Parent
                and targetPart:IsA("BasePart")
                and (targetPart.Position - Camera.CFrame.Position).Magnitude <= MAX_DIST * 1.25

            if not valid then
                local found = findTarget()
                if found and found.Character then
                    target     = found
                    targetPart = found.Character:FindFirstChild(AIM_PART)
                else
                    target, targetPart = nil, nil
                end
            end

            local s = target and ("Target: " .. target.Name) or "Target: none"
            if s ~= lastStatus then
                lastStatus = s
                statusLbl.Text = s
            end
        end
        task.wait(SCAN_RATE)
    end
end)

-- ------------------------------------------------------------
--  >>> THE KEY FIX <<<
--  BindToRenderStep at Camera.Value + 1 so we run AFTER the
--  default camera controller. This makes tracking stick while
--  you strafe, walk, jump — anything.
-- ------------------------------------------------------------
RunService:BindToRenderStep("RivalsAimCam", Enum.RenderPriority.Camera.Value + 1, function(dt)
    if not (enabled and targetPart and targetPart.Parent) then return end
    if not targetPart:IsA("BasePart") then return end

    local camPos   = Camera.CFrame.Position
    local toTarget = targetPart.Position - camPos
    local dist     = toTarget.Magnitude
    if dist < 1 then return end

    -- Build a CFrame at our current eye position looking at the head
    local desired = CFrame.new(camPos, camPos + toTarget)

    -- Frame-rate independent smoothing
    local alpha = 1 - math.exp(-AIM_SPEED * dt)

    -- If the target is way off from the crosshair (e.g. just acquired),
    -- snap instantly instead of slowly sliding
    local angle = math.acos(math.clamp(Camera.CFrame.LookVector:Dot(toTarget.Unit), -1, 1))
    if angle > SNAP_ANGLE then alpha = 1 end

    Camera.CFrame = Camera.CFrame:Lerp(desired, alpha)
end)

print("🎃 Rivals Aimbot loaded – press Z to toggle")