local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local flying = false
local speed = 60
local flyConnection
local attachment
local velocity
local gui = Instance.new("ScreenGui")

gui.Name = "FlyControls"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.fromOffset(130, 48)
button.Position = UDim2.new(1, -145, 0.5, 0)
button.BackgroundColor3 = Color3.fromRGB(95, 55, 180)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "VUELO: OFF"
button.TextScaled = true
button.Parent = gui

Instance.new("UICorner", button).CornerRadius =
    UDim.new(0, 12)

local function stopFly()
    flying = false

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    if velocity then
        velocity:Destroy()
        velocity = nil
    end

    if attachment then
        attachment:Destroy()
        attachment = nil
    end

    button.Text = "VUELO: OFF"
end

local function startFly()
    local character = player.Character
    local humanoid = character and
        character:FindFirstChildOfClass("Humanoid")
    local root = character and
        character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not root then return end

    stopFly()
    flying = true
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)

    attachment = Instance.new("Attachment")
    attachment.Parent = root

    velocity = Instance.new("LinearVelocity")
    velocity.Attachment0 = attachment
    velocity.RelativeTo = Enum.ActuatorRelativeTo.World
    velocity.MaxForce = 100000
    velocity.VectorVelocity = Vector3.zero
    velocity.Parent = root

    button.Text = "VUELO: ON"

    flyConnection = RunService.RenderStepped:Connect(function()
        if not root.Parent or not humanoid.Parent then
            stopFly()
            return
        end

        local camera = workspace.CurrentCamera
        local direction = Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then
            direction += camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            direction -= camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            direction -= camera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            direction += camera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            direction += Vector3.yAxis
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction -= Vector3.yAxis
        end

        velocity.VectorVelocity =
            direction.Magnitude > 0
            and direction.Unit * speed
            or Vector3.zero
    end)
end

button.Activated:Connect(function()
    if flying then
        stopFly()
    else
        startFly()
    end
end)

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F then
        if flying then stopFly() else startFly() end
    end
end)

player.CharacterAdded:Connect(function()
    stopFly()
end)