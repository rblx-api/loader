-- Script Optimizado para Ejecutores Móviles
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Tabla de Configuración
_G.Config = {
    AutoBuy = true,
    ESP = true,
    ESPLines = true,
    WalkSpeed = 16,
    Delay = 0.1 -- Retardo óptimo para evitar cuelgues en móviles
}

-- Opcional: Modificación de Velocidad (Optimizado)
local function SetWalkSpeed()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = _G.Config.WalkSpeed
    end
end

-- Bucle AutoBuy (Reemplaza a RenderStepped para evitar crashes)
task.spawn(function()
    while task.wait(_G.Config.Delay) do
        if _G.Config.AutoBuy then
            pcall(function()
                -- Coloca aquí tu lógica de compra o iteración de ítems
                -- Ejemplo seguro para Prompts de Proximidad:
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and obj.Enabled then
                        if fireproximityprompt then
                            fireproximityprompt(obj)
                        end
                    end
                end
            end)
        end
    end
end)

-- Mantener la velocidad del personaje al reaparecer
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    SetWalkSpeed()
end)

-- Ejecución inicial
SetWalkSpeed()