-- Aimbot Mobile | Like in the TikTok
-- FOV 96 / Team OFF / Kill OFF / Wall OFF = locks to EVERYONE

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

getgenv().Aimbot = {
    Enabled = true,
    FOV = 96,
    TeamCheck = false,
    KillCheck = false, -- if OFF, it will aim even if they dead / downed
    WallCheck = false, -- if OFF, it locks even through walls like in video
    AimPart = "Head",
    Smoothness = 2, -- 2 = snap like video, 5 = smooth
    InfJump = false
}

-- Destroy old one
if game:GetService("CoreGui"):FindFirstChild("AimbotMobile") then
    game:GetService("CoreGui"):FindFirstChild("AimbotMobile"):Destroy()
end
if LocalPlayer.PlayerGui:FindFirstChild("AimbotMobile") then
    LocalPlayer.PlayerGui:FindFirstChild("AimbotMobile"):Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "AimbotMobile"
Gui.ResetOnSpawn = false
Gui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 175, 0, 165)
Main.Position = UDim2.new(0, 10, 0, 120)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BackgroundTransparency = 0.15
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = Gui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 28)
Title.BackgroundTransparency = 1
Title.Text = "Aimbot Mobile"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local function AddLabel(text, y)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -10, 0, 20)
    l.Position = UDim2.new(0, 10, 0, y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(255,255,255)
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = Main
    return l
end

local AimLabel = AddLabel("Aimbot: ON", 30)
local FovLabel = AddLabel("FOV: 96", 50)
local TeamLabel = AddLabel("Team Check: OFF", 70)
local KillLabel = AddLabel("Kill Check: OFF", 90)
local WallLabel = AddLabel("Wall Check: OFF", 110)

-- Tap title to turn ON/OFF like in video
Title.Active = true
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 0, 28)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Text = ""
toggleBtn.Parent = Title

toggleBtn.MouseButton1Click:Connect(function()
    getgenv().Aimbot.Enabled = not getgenv().Aimbot.Enabled
    AimLabel.Text = getgenv().Aimbot.Enabled and "Aimbot: ON" or "Aimbot: OFF"
    AimLabel.TextColor3 = getgenv().Aimbot.Enabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
end)

-- Inf Jump button under it (extra for you)
local JumpBtn = Instance.new("TextButton")
JumpBtn.Size = UDim2.new(0, 175, 0, 25)
JumpBtn.Position = UDim2.new(0, 10, 0, 290)
JumpBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
JumpBtn.Text = "Infinite Jump: OFF"
JumpBtn.TextColor3 = Color3.fromRGB(255,255,255)
JumpBtn.Font = Enum.Font.GothamBold
JumpBtn.TextSize = 13
JumpBtn.Parent = Gui
JumpBtn.Active = true
JumpBtn.Draggable = true

JumpBtn.MouseButton1Click:Connect(function()
    getgenv().Aimbot.InfJump = not getgenv().Aimbot.InfJump
    JumpBtn.Text = getgenv().Aimbot.InfJump and "Infinite Jump: ON" or "Infinite Jump: OFF"
end)

-- FOV Circle - like in video
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255,255,255)
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Transparency = 1

local function CanSee(part)
    if not getgenv().Aimbot.WallCheck then return true end
    local origin = Camera.CFrame.Position
    local dir = part.Position - origin
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local res = workspace:Raycast(origin, dir, params)
    if res and res.Instance:IsDescendantOf(part.Parent) then return true end
    if not res then return true end
    return false
end

local function GetClosest()
    local best = nil
    local shortest = getgenv().Aimbot.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local part = plr.Character:FindFirstChild(getgenv().Aimbot.AimPart)
            if part then
                -- Kill Check OFF = don't care if dead, like video
                if getgenv().Aimbot.KillCheck and (not hum or hum.Health <= 0) then continue end
                -- Team Check OFF = aim at everyone, like video
                if getgenv().Aimbot.TeamCheck and plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then continue end
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < shortest and CanSee(part) then
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
    FOVCircle.Radius = getgenv().Aimbot.FOV
    FOVCircle.Visible = getgenv().Aimbot.Enabled

    if getgenv().Aimbot.Enabled then
        local target = GetClosest()
        if target then
            local vel = Vector3.new(0,0,0)
            local hum = target.Parent and target.Parent:FindFirstChildOfClass("Humanoid")
            if hum and hum.RootPart then vel = hum.RootPart.AssemblyLinearVelocity end
            local predicted = target.Position + (vel * 0.12)
            local desired = CFrame.lookAt(Camera.CFrame.Position, predicted)
            Camera.CFrame = Camera.CFrame:Lerp(desired, 1 / getgenv().Aimbot.Smoothness)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if getgenv().Aimbot.InfJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

print("Aimbot Mobile Loaded - Like TikTok")