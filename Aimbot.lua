-- Jesus | 【entity-RIVALS¦canonical_name=RIVALS】 EDITION
-- Camera Aim + Inf Jump + No Forcefield Aim

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

_G.Jesus = {
    Aimbot = false,
    TeamCheck = true,
    FOV = 110, -- 【entity-Rivals¦canonical_name=RIVALS】 = smaller FOV is better, less snap
    Smoothness = 4, -- lower = faster snap for 【entity-Rivals¦canonical_name=RIVALS】 fast movement
    AimPart = "Head", -- 【entity-Rivals¦canonical_name=RIVALS】 headshot = 1 tap
    InfJump = false,
    ShowFOV = true,
    Holding = false,
    Prediction = 0.12 -- predicts movement, important for 【entity-Rivals¦canonical_name=RIVALS】
}

if game:GetService("CoreGui"):FindFirstChild("Jesus") then
    game:GetService("CoreGui"):FindFirstChild("Jesus"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Jesus"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 230, 0, 320)
Main.Position = UDim2.new(0.5, -115, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- 【entity-Rivals¦canonical_name=RIVALS】 red
Title.Text = "✝ JESUS | 【entity-RIVALS¦canonical_name=RIVALS】 ✝"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local function MakeButton(name, y, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 38)
    btn.Position = UDim2.new(0.075, 0, 0, y)
    btn.BackgroundColor3 = default and Color3.fromRGB(255,0,0) or Color3.fromRGB(30,30,30)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = name .. (default and ": ON" or ": OFF")
    btn.Parent = Main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(255,0,0) or Color3.fromRGB(30,30,30)
        callback(state)
    end)
end

MakeButton("AIMBOT", 60, false, function(v) _G.Jesus.Aimbot = v end)
MakeButton("INFINITE JUMP", 108, false, function(v) _G.Jesus.InfJump = v end)
MakeButton("TEAM CHECK", 156, true, function(v) _G.Jesus.TeamCheck = v end)
MakeButton("SHOW FOV", 204, true, function(v) _G.Jesus.ShowFOV = v end)

-- Aim Part Switcher
local AimPartBtn = Instance.new("TextButton")
AimPartBtn.Size = UDim2.new(0.85, 0, 0, 38)
AimPartBtn.Position = UDim2.new(0.075, 0, 0, 252)
AimPartBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
AimPartBtn.TextColor3 = Color3.fromRGB(255,255,255)
AimPartBtn.Font = Enum.Font.GothamBold
AimPartBtn.TextSize = 14
AimPartBtn.Text = "AIM PART: Head"
AimPartBtn.Parent = Main
Instance.new("UICorner", AimPartBtn).CornerRadius = UDim.new(0, 8)

local parts = {"Head", "UpperTorso", "HumanoidRootPart"}
local partIndex = 1
AimPartBtn.MouseButton1Click:Connect(function()
    partIndex = partIndex + 1
    if partIndex > #parts then partIndex = 1 end
    _G.Jesus.AimPart = parts[partIndex]
    AimPartBtn.Text = "AIM PART: " .. _G.Jesus.AimPart
end)

-- Mobile AIM Hold Button
local AimBtn = Instance.new("TextButton")
AimBtn.Size = UDim2.new(0, 80, 0, 80)
AimBtn.Position = UDim2.new(0.82, 0, 0.55, 0)
AimBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
AimBtn.Text = "AIM"
AimBtn.TextColor3 = Color3.fromRGB(255,255,255)
AimBtn.Font = Enum.Font.GothamBlack
AimBtn.TextSize = 16
AimBtn.Parent = ScreenGui
Instance.new("UICorner", AimBtn).CornerRadius = UDim.new(1, 0)

AimBtn.MouseButton1Down:Connect(function() _G.Jesus.Holding = true end)
AimBtn.MouseButton1Up:Connect(function() _G.Jesus.Holding = false end)

-- FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255,0,0)
FOVCircle.Thickness = 2
FOVCircle.NumSides = 64
FOVCircle.Filled = false

local function IsAlive(plr)
    if not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    -- Rivals spawn protection - don't aim if forcefield
    if plr.Character:FindFirstChildOfClass("ForceField") then return false end
    return true
end

local function GetClosest()
    local closest = nil
    local closestPart = nil
    local shortest = _G.Jesus.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and IsAlive(plr) then
            if _G.Jesus.TeamCheck and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then continue end
            local part = plr.Character:FindFirstChild(_G.Jesus.AimPart) or plr.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = plr
                        closestPart = part
                    end
                end
            end
        end
    end
    return closest, closestPart
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = _G.Jesus.FOV
    FOVCircle.Visible = _G.Jesus.ShowFOV

    if _G.Jesus.Aimbot and _G.Jesus.Holding then
        local plr, part = GetClosest()
        if plr and part then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local velocity = Vector3.new(0,0,0)
            if hum and hum.RootPart then
                velocity = hum.RootPart.AssemblyLinearVelocity or hum.RootPart.Velocity
            end
            -- Prediction for Rivals movement
            local predictedPos = part.Position + (velocity * _G.Jesus.Prediction)
            local camPos = Camera.CFrame.Position
            local desired = CFrame.lookAt(camPos, predictedPos)
            Camera.CFrame = Camera.CFrame:Lerp(desired, 1 / _G.Jesus.Smoothness)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.Jesus.InfJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

print("Jesus Rivals Loaded")