local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local antiDieEnabled = true
local antiDieConnection
local healthConnection

local function setupAntiDie(character)
    if antiDieConnection then
        antiDieConnection:Disconnect()
        antiDieConnection = nil
    end

    if healthConnection then
        healthConnection:Disconnect()
        healthConnection = nil
    end

    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then
        return
    end

    pcall(function()
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)

    healthConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if antiDieEnabled and humanoid.Parent and humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end)

    antiDieConnection = RunService.Heartbeat:Connect(function()
        if antiDieEnabled and humanoid.Parent then
            pcall(function()
                if humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.3)
    if antiDieEnabled then
        setupAntiDie(character)
    end
end)

if LocalPlayer.Character and antiDieEnabled then
    setupAntiDie(LocalPlayer.Character)
end