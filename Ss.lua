-- Jesus | RIVALS V3 - FIXED, NO MORE DRIFT
-- Camera stays still unless you hold FIRE

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

_G.Jesus = {
    Aimbot = false,
    TeamCheck = true,
    FOV = 100, -- smaller = less random snapping
    Smoothness = 5, -- 5 = smooth assist, not crazy snap. If you want snappier use 3
    AimPart = "Head",
    InfJump = false,
    ShowFOV = true,
    Firing = false, -- ONLY true when holding our FIRE button
}

if game:GetService("CoreGui"):FindFirstChild("Jesus") then
    game:GetService("CoreGui"):FindFirstChild("Jesus"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Jesus"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 230, 0, 280)
Main.Position = UDim2.new(0.5, -115, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Title.Text = "✝ JESUS | RIVALS V3 ✝"
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

-- THE FIX: Big FIRE button - ONLY this triggers aim
local FireBtn = Instance.new("TextButton")
FireBtn.Size = UDim2.new(0, 90, 0, 90)
FireBtn.Position = UDim2.new(0.80, 0, 0.55, 0)
FireBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
FireBtn.Text = "FIRE"
FireBtn.TextColor3 = Color3.fromRGB(255,255,255)
FireBtn.Font = Enum.Font.GothamBlack
FireBtn.TextSize = 18
FireBtn.Parent = ScreenGui
Instance.new("UICorner", FireBtn).CornerRadius = UDim.new(1, 0)

-- Hold to aim, let go to stop - camera WON'T move on its own anymore
FireBtn.MouseButton1Down:Connect(function()
    _G.Jesus.Firing = true
    FireBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
end)
FireBtn.MouseButton1Up:Connect(function()
    _G.Jesus.Firing = false
    FireBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
end)

-- PC players can still use mouse click
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        _G.Jesus.Firing = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        _G.Jesus.Firing = false
    end
end)

local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255,0,0)
FOVCircle.Thickness = 2
FOVCircle.NumSides = 64
FOVCircle.Filled = false

local function IsAlive(plr)
    if not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    if plr.Character:FindFirstChildOfClass("ForceField") then return false end
    return true
end

local function GetClosest()
    local best = nil
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
                        best = part
                    end
                end
            end
        end
    end
    return best
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = _G.Jesus.FOV
    FOVCircle.Visible = _G.Jesus.ShowFOV

    -- FIX 1: If NOT firing, DO NOT TOUCH CAMERA AT ALL
    -- FIX 2: If no one in FOV, DO NOT TOUCH CAMERA
    if _G.Jesus.Aimbot and _G.Jesus.Firing then
        local part = GetClosest()
        if part then
            local char = part.Parent
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local velocity = Vector3.new(0,0,0)
            if hum and hum.RootPart then
                velocity = hum.RootPart.AssemblyLinearVelocity
            end
            local predictedPos = part.Position + (velocity * 0.12)
            local desired = CFrame.lookAt(Camera.CFrame.Position, predictedPos)
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

print("Jesus V3 Fixed Loaded")