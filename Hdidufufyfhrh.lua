-- ============================================
-- VLEXUS.lua - VERSIÓN COMPLETA Y FUNCIONAL
-- ============================================

-- Configuración
local VLEXUS = {}
VLEXUS.Version = "1.0.0"
VLEXUS.Author = "rblx-api"

-- Sistema de notificación
function VLEXUS.Notify(title, message, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = message,
        Duration = duration or 5
    })
end

-- Anti-afk
function VLEXUS.AntiAFK()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
    VLEXUS.Notify("VLEXUS", "Anti-AFK activado", 3)
end

-- ESP (ver jugadores a través de paredes)
function VLEXUS.ESP()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.Parent = player.Character
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.Parent = character
        end)
    end)
    
    VLEXUS.Notify("VLEXUS", "ESP activado", 3)
end

-- Fly (volar)
function VLEXUS.Fly(speed)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    
    if not Humanoid or not HumanoidRootPart then return end
    
    local flying = true
    local bg = Instance.new("BodyGyro")
    local bv = Instance.new("BodyVelocity")
    
    bg.Parent = HumanoidRootPart
    bv.Parent = HumanoidRootPart
    
    bg.MaxTorque = Vector3.new(0, 0, 0)
    bv.MaxForce = Vector3.new(100000, 100000, 100000)
    
    Humanoid.PlatformStand = true
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if flying then
            bv.Velocity = HumanoidRootPart.CFrame.LookVector * (speed or 50)
            bg.CFrame = HumanoidRootPart.CFrame
        end
    end)
    
    VLEXUS.Notify("VLEXUS", "Fly activado", 3)
end

-- Infinite Yield (comandos admin)
function VLEXUS.InfiniteYield()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    VLEXUS.Notify("VLEXUS", "Infinite Yield cargado", 3)
end

-- Auto-farm (ejemplo básico)
function VLEXUS.AutoFarm()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    spawn(function()
        while wait(1) do
            -- Busca el NPC más cercano
            local nearestNPC = nil
            local nearestDist = math.huge
            
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not obj:IsDescendantOf(LocalPlayer.Character) then
                    local dist = (obj.PrimaryPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearestNPC = obj
                    end
                end
            end
            
            if nearestNPC then
                -- Ataca al NPC
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end
        end
    end)
    
    VLEXUS.Notify("VLEXUS", "Auto-farm activado", 3)
end

-- Ejecutar todo automáticamente
VLEXUS.AntiAFK()
VLEXUS.ESP()
VLEXUS.Fly(50)
VLEXUS.InfiniteYield()
VLEXUS.AutoFarm()

-- Notificación final
VLEXUS.Notify("VLEXUS", "¡Todos los módulos cargados!", 5)

-- Retorna el objeto para uso externo
return VLEXUS