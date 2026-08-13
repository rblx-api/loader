local parte = script.Parent
local Players = game:GetService("Players")

parte.Touched:Connect(function(hit)
    local jugador = Players:GetPlayerFromCharacter(hit.Parent)
    if jugador then
        local leaderstats = jugador:FindFirstChild("leaderstats")
        if leaderstats and leaderstats:FindFirstChild("Dinero") then
            leaderstats.Dinero.Value += 50
        end
    end
end)