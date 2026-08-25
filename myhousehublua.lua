-- MY HOUSE HUB
-- Script para Roblox 3008

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Crear la GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MYHOUSEHUB"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Fondo principal
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(255, 182, 193) -- Rosa
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Redondear bordes
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "🏠 MY HOUSE HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

-- Botón de teletransporte
local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0, 150, 0, 50)
TeleportButton.Position = UDim2.new(0.5, -75, 0.5, 10)
TeleportButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180) -- Rosa fuerte
TeleportButton.Text = "🔄 TELEPORT"
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.TextScaled = true
TeleportButton.Font = Enum.Font.GothamBold
TeleportButton.Parent = Frame

-- Redondear botón
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = TeleportButton

-- Función de teletransporte al checkpoint
TeleportButton.MouseButton1Click:Connect(function()
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            -- Buscar el checkpoint más cercano o el último guardado
            local checkpoints = workspace:FindFirstChild("Checkpoints")
            if checkpoints then
                local checkpoint = checkpoints:FindFirstChild("SpawnLocation") or checkpoints:FindFirstChild("Checkpoint")
                if checkpoint and checkpoint:IsA("BasePart") then
                    character:SetPrimaryPartCFrame(checkpoint.CFrame * CFrame.new(0, 3, 0))
                else
                    -- Si no encuentra checkpoint, va al spawn principal
                    local spawn = workspace:FindFirstChild("SpawnLocation")
                    if spawn then
                        character:SetPrimaryPartCFrame(spawn.CFrame * CFrame.new(0, 3, 0))
                    end
                end
            else
                -- Fallback: teletransportar al spawn
                local spawn = workspace:FindFirstChild("SpawnLocation")
                if spawn then
                    character:SetPrimaryPartCFrame(spawn.CFrame * CFrame.new(0, 3, 0))
                end
            end
        end
    end
end)

-- Efecto hover en el botón
TeleportButton.MouseEnter:Connect(function()
    TeleportButton.BackgroundColor3 = Color3.fromRGB(255, 20, 147) -- Rosa más intenso
end)

TeleportButton.MouseLeave:Connect(function()
    TeleportButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
end)

-- Animación de entrada
Frame:TweenPosition(UDim2.new(0.5, -150, 0.5, -100), "Out", "Bounce", 0.5, true)