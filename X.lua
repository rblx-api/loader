-- UI combinada de ejemplo para TU PROPIO juego de Roblox.
-- Incluye: panel arrastrable, minimizar/restaurar, Teleport de prueba,
-- Reset y optimizador visual local. No incluye Invis Steal ni funciones
-- para robar/teletransportarse a objetos o jugadores en juegos ajenos.
--
-- Para probar el teleport, crea un BasePart en Workspace llamado:
-- TestTeleportTarget
-- Coloca este LocalScript en StarterPlayer > StarterPlayerScripts.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "CombinedSafeUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.fromOffset(300, 190)
panel.Position = UDim2.new(0.5, -150, 0.5, -95)
panel.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
panel.BorderSizePixel = 0
panel.Active = true
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)

local outline = Instance.new("UIStroke")
outline.Color = Color3.fromRGB(145, 90, 255)
outline.Thickness = 1.5
outline.Parent = panel

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -44, 0, 38)
header.Position = UDim2.fromOffset(12, 0)
header.BackgroundTransparency = 1
header.Text = "Xen-style UI  •  Safe tools"
header.TextColor3 = Color3.fromRGB(245, 245, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 14
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = panel

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(28, 26)
minimize.Position = UDim2.new(1, -34, 0, 6)
minimize.BackgroundColor3 = Color3.fromRGB(65, 50, 95)
minimize.Text = "−"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 20
minimize.Parent = panel
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 6)

local function makeButton(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -24, 0, 34)
    b.Position = UDim2.fromOffset(12, y)
    b.BackgroundColor3 = Color3.fromRGB(48, 42, 65)
    b.TextColor3 = Color3.fromRGB(250, 250, 255)
    b.Text = text
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 12
    b.AutoButtonColor = true
    b.Parent = panel
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    return b
end

local teleportButton = makeButton("TELEPORT TO TEST MARKER", 48)
local resetButton = makeButton("RESET CHARACTER", 88)
local optimizerButton = makeButton("OPTIMIZER: OFF", 128)

-- Arrastrar el panel desde la cabecera.
local dragging = false
local dragInput, dragStart, startPosition
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)

local minimized = false
minimize.Activated:Connect(function()
    minimized = not minimized
    for _, child in ipairs(panel:GetChildren()) do
        if child ~= header and child ~= minimize and not child:IsA("UICorner") and not child:IsA("UIStroke") then
            child.Visible = not minimized
        end
    end
    panel.Size = minimized and UDim2.fromOffset(300, 38) or UDim2.fromOffset(300, 190)
    minimize.Text = minimized and "+" or "−"
end)

teleportButton.Activated:Connect(function()
    local target = Workspace:FindFirstChild("TestTeleportTarget")
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if target and target:IsA("BasePart") and root then
        root.CFrame = target.CFrame + Vector3.new(0, 3, 0)
    else
        teleportButton.Text = "ADD Workspace.TestTeleportTarget"
        task.delay(2, function()
            if teleportButton.Parent then teleportButton.Text = "TELEPORT TO TEST MARKER" end
        end)
    end
end)

resetButton.Activated:Connect(function()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.Health = 0 end
end)

local optimized = false
local saved = {}
local function setOptimizer(enabled)
    optimized = enabled
    optimizerButton.Text = optimized and "OPTIMIZER: ON" or "OPTIMIZER: OFF"
    optimizerButton.BackgroundColor3 = optimized and Color3.fromRGB(65, 105, 75) or Color3.fromRGB(48, 42, 65)
    if optimized then
        saved.GlobalShadows = Lighting.GlobalShadows
        Lighting.GlobalShadows = false
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                if saved[obj] == nil then saved[obj] = obj.Enabled end
                obj.Enabled = false
            elseif obj:IsA("BasePart") then
                if saved[obj] == nil then saved[obj] = {Material = obj.Material, Reflectance = obj.Reflectance}
                end
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            end
        end
    else
        if saved.GlobalShadows ~= nil then Lighting.GlobalShadows = saved.GlobalShadows end
        for obj, value in pairs(saved) do
            if typeof(obj) == "Instance" and obj.Parent then
                pcall(function()
                    if typeof(value) == "boolean" then
                        obj.Enabled = value
                    elseif typeof(value) == "table" then
                        obj.Material = value.Material
                        obj.Reflectance = value.Reflectance
                    end
                end)
            end
        end
        table.clear(saved)
    end
end

optimizerButton.Activated:Connect(function()
    setOptimizer(not optimized)
end)