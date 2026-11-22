-- Jesus | PRO STICKY AIM - LIKE THAT GUY IN THE VIDEO
-- Locks once, STAYS locked, tracks through jumps

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

getgenv().JesusPro = {
    Enabled = true,
    FOV = 140, -- a little bigger than his so you lock easier
    Smoothness = 1.8, -- 1.8 = STICKY like his. Lower = stickier. Don't go above 3
    AimPart = "Head",
    Prediction = 0.165, -- this is why his tracks when they run, predicts where they GOING
    TeamCheck = false,
    WallCheck = false, -- like his, locks even if they peek
    InfJump = false,
    Locked = nil
}

if game:GetService("CoreGui"):FindFirstChild("JesusPro") then
    game:GetService("CoreGui"):FindFirstChild("JesusPro"):Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "JesusPro"
Gui.ResetOnSpawn = false
Gui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 175, 0, 105)
Main.Position = UDim2.new(0, 10, 0, 120)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = Gui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 28)
Title.BackgroundTransparency = 1
Title.Text = "✝ JESUS PRO ✝"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 15
Title.Parent = Main

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 22)
Status.Position = UDim2.new(0, 0, 0, 30)
Status.BackgroundTransparency = 1
Status.Text = "Aimbot: ON"
Status.TextColor3 = Color3.fromRGB(0,255,0)
Status.Font = Enum.Font.GothamBold
Status.TextSize = 13
Status.Parent = Main

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(1, 0, 0, 22)
TargetLabel.Position = UDim2.new(0, 0, 0, 52)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "No Target"
TargetLabel.TextColor3 = Color3.fromRGB(255,255,255)
TargetLabel.Font = Enum.Font.Gotham
TargetLabel.TextSize = 12
TargetLabel.Parent = Main

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(1, -20, 0, 22)
Toggle.Position = UDim2.new(0, 10, 0, 76)
Toggle.BackgroundColor3 = Color3.fromRGB(255,0,0)
Toggle.Text = "ON / OFF"
Toggle.TextColor3 = Color3.fromRGB(255,255,255)
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 12
Toggle.Parent = Main

Toggle.MouseButton1Click:Connect(function()
    getgenv().JesusPro.Enabled = not getgenv().JesusPro.Enabled
    Status.Text = getgenv().JesusPro.Enabled and "Aimbot: ON" or "Aimbot: OFF"
    Status.TextColor3 = getgenv().JesusPro.Enabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    if not getgenv().JesusPro.Enabled then getgenv().JesusPro.Locked = nil end
end)

-- FOV Circle
local Circle = Drawing.new("Circle")
Circle.Color = Color3.fromRGB(255,255,255)
Circle.Thickness = 1.5
Circle.NumSides = 64
Circle.Filled = false

local function IsValid(plr)
    if not plr.Character then return false end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    if plr.Character:FindFirstChildOfClass("ForceField") then return false end
    return true
end

local function FindTarget()
    local best = nil
    local bestDist = getgenv().JesusPro.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and IsValid(plr) then
            if getgenv().JesusPro.TeamCheck and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then continue end
            local part = plr.Character:FindFirstChild(getgenv().JesusPro.AimPart)
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        best = {Player = plr, Part = part}
                    end
                end
            end
        end
    end
    return best
end

RunService.RenderStepped:Connect(function()
    Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    Circle.Radius = getgenv().JesusPro.FOV
    Circle.Visible = getgenv().JesusPro.Enabled

    if not getgenv().JesusPro.Enabled then return end

    local Locked = getgenv().JesusPro.Locked

    -- 1. IF WE ALREADY LOCKED, STAY LOCKED - THIS IS WHAT MAKES HIS SO GOOD
    -- Don't switch targets mid-fight like the old ones did
    if Locked then
        local plr = Locked.Player
        local part = Locked.Part
        -- Unlock only if dead, respawned, or REALLY far from crosshair
        if not IsValid(plr) or not part or not part.Parent then
            getgenv().JesusPro.Locked = nil
            TargetLabel.Text = "No Target"
        else
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            local dist = onScreen and (Vector2.new(pos.X, pos.Y) - center).Magnitude or 9999
            -- If they go WAY off screen, unlock. Otherwise STAY.
            if dist > getgenv().JesusPro.FOV * 2.2 then
                getgenv().JesusPro.Locked = nil
                TargetLabel.Text = "No Target"
            end
        end
    end

    -- 2. NO LOCK YET? Find one
    if not getgenv().JesusPro.Locked then
        local found = FindTarget()
        if found then
            getgenv().JesusPro.Locked = found
            TargetLabel.Text = "Locked: " .. found.Player.Name
            TargetLabel.TextColor3 = Color3.fromRGB(0,255,0)
        else
            TargetLabel.Text = "No Target"
            TargetLabel.TextColor3 = Color3.fromRGB(255,255,255)
        end
    end

    -- 3. AIM AT LOCKED TARGET WITH PREDICTION
    Locked = getgenv().JesusPro.Locked
    if Locked and Locked.Part then
        local char = Locked.Part.Parent
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local vel = Vector3.new(0,0,0)
        if hum and hum.RootPart then
            vel = hum.RootPart.AssemblyLinearVelocity
        end
        -- Predict where they WILL be, not where they ARE - this is the secret
        local predicted = Locked.Part.Position + (vel * getgenv().JesusPro.Prediction)
        -- Also add a little up for jump prediction
        predicted = predicted + Vector3.new(0, vel.Y * 0.05, 0)

        local desired = CFrame.lookAt(Camera.CFrame.Position, predicted)
        -- Sticky lerp, not instant snap, so it looks smooth like his
        Camera.CFrame = Camera.CFrame:Lerp(desired, 1 / getgenv().JesusPro.Smoothness)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if getgenv().JesusPro.InfJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

print("Jesus Pro Sticky Loaded")