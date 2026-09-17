-- ================================================
-- DAILYS ANTI-LAG (AUTO-EXECUTE - NO UI)
-- ================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

-- ================================================
-- ANTI-LAG CORE
-- ================================================

local antiLagConnections = {}
local antiLagLoaded = false

local function clearConnections()
    for _, conn in ipairs(antiLagConnections) do
        pcall(function() conn:Disconnect() end)
    end
    antiLagConnections = {}
end

local function applyAntiLagToDescendant(obj)
    -- Particles, trails, beams, fire
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") then
        pcall(function() obj.Enabled = false end)
    end
    -- Decals & Textures
    if obj:IsA("Decal") or obj:IsA("Texture") then
        pcall(function() obj.Transparency = 1 end)
    end
    -- BasePart texture removal
    if obj:IsA("BasePart") then
        pcall(function()
            if obj:IsA("MeshPart") and obj.TextureID ~= "" then
                obj.TextureID = ""
            end
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        end)
    end
    -- Accessories & Hats
    if obj:IsA("Accessory") or obj:IsA("Hat") then
        pcall(function() obj:Destroy() end)
    end
    -- Lights
    if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
        pcall(function() obj.Enabled = false end)
    end
    -- SurfaceGuis
    if obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
        pcall(function() obj.Enabled = false end)
    end
end

local function applyAllAntiLag()
    -- Lighting
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
    end)
    -- Post-processing
    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA("BloomEffect") or child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or
           child:IsA("ColorCorrectionEffect") or child:IsA("DepthOfFieldEffect") then
            pcall(function() child.Enabled = false end)
        end
    end
    -- All workspace descendants
    for _, descendant in pairs(Workspace:GetDescendants()) do
        applyAntiLagToDescendant(descendant)
    end
    -- Quality
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
    -- FPS cap
    pcall(function()
        local UserSettings = UserSettings()
        local GameSettings = UserSettings:GetService("UserGameSettings")
        if GameSettings then
            GameSettings:SetFpsCap(1000)
        end
    end)
    -- Network
    pcall(function()
        HttpService:SetThrottlingEnabled(false)
        Workspace:SetAttribute("ReplicationPriority", 10)
    end)
end

local function loadAntiLag()
    if antiLagLoaded then return end

    clearConnections()
    applyAllAntiLag()

    -- Watch for new objects
    local conn1 = Workspace.DescendantAdded:Connect(function(descendant)
        if antiLagLoaded then
            applyAntiLagToDescendant(descendant)
        end
    end)
    table.insert(antiLagConnections, conn1)

    -- Watch for new lighting effects
    local conn2 = Lighting.DescendantAdded:Connect(function(descendant)
        if antiLagLoaded then
            if descendant:IsA("BloomEffect") or descendant:IsA("BlurEffect") or
               descendant:IsA("SunRaysEffect") or descendant:IsA("ColorCorrectionEffect") then
                pcall(function() descendant.Enabled = false end)
            end
        end
    end)
    table.insert(antiLagConnections, conn2)

    -- Watch for new players and remove their accessories
    local conn3 = Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            if antiLagLoaded then
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("Accessory") or obj:IsA("Hat") then
                        pcall(function() obj:Destroy() end)
                    end
                end
            end
        end)
    end)
    table.insert(antiLagConnections, conn3)

    antiLagLoaded = true
    print("✅ Dailys Anti-Lag loaded successfully!")
end

-- ================================================
-- AUTO-EXECUTE
-- ================================================

-- Load immediately when script runs
loadAntiLag()

-- Also load when character spawns (in case of respawn)
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if not antiLagLoaded then
        loadAntiLag()
    else
        -- Re-apply optimizations on respawn
        applyAllAntiLag()
    end
end)

print("❄️ Dailys Anti-Lag is now active!")
print("📊 All optimizations applied automatically")