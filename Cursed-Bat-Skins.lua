if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local getasset = getcustomasset or getsynasset or get_custom_asset

if not isfile("cursed_banner.png") then
    writefile("cursed_banner.png", game:HttpGet("https://i.postimg.cc/L6q8d6rG/IMG-9726.png"))
end

local assetId = getasset("cursed_banner.png")

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer.PlayerGui

local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(0, 150, 0, 100)
imageLabel.BackgroundTransparency = 1
imageLabel.Image = assetId
imageLabel.Visible = false
imageLabel.Parent = screenGui

local function updatePosition(character)
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        imageLabel.Visible = false
        return
    end
    local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
    if onScreen then
        imageLabel.Position = UDim2.new(0, pos.X - 170, 0, pos.Y - 50)
        imageLabel.Visible = true
    else
        imageLabel.Visible = false
    end
end

local currentCharacter
local connection

local function attachImage(character)
    if currentCharacter then
        currentCharacter = nil
    end
    currentCharacter = character
    if connection then
        connection:Disconnect()
        connection = nil
    end
    connection = RunService.RenderStepped:Connect(function()
        updatePosition(currentCharacter)
    end)
end

if LocalPlayer.Character then
    task.spawn(attachImage, LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.spawn(attachImage, char)
end)

local CONFIG_FILE = "CursedBatSkins.json"
local State = {
    weaponSkinsEnabled = true,
    swordSkin = "Katana",
    weaponAdjustProfiles = nil,
}

local function _isfile(f) return (isfile or (syn and syn.isfile) or function() return false end)(f) end
local function _readfile(f) return (readfile or (syn and syn.readfile) or function() return nil end)(f) end
local function _writefile(f,d) return (writefile or (syn and syn.writefile) or function() end)(f,d) end

local function loadConfig()
    pcall(function()
        if _isfile(CONFIG_FILE) then
            local data = HttpService:JSONDecode(_readfile(CONFIG_FILE))
            if type(data) == "table" then
                if data.weaponSkinsEnabled ~= nil then State.weaponSkinsEnabled = data.weaponSkinsEnabled end
                if data.swordSkin then State.swordSkin = data.swordSkin end
                if data.weaponAdjustProfiles and type(data.weaponAdjustProfiles) == "table" then State.weaponAdjustProfiles = data.weaponAdjustProfiles end
            end
        end
    end)
end

local function saveConfig()
    pcall(function()
        _writefile(CONFIG_FILE, HttpService:JSONEncode({
            weaponSkinsEnabled = State.weaponSkinsEnabled,
            swordSkin = State.swordSkin,
            weaponAdjustProfiles = State.weaponAdjustProfiles,
        }))
    end)
end
loadConfig()

local colors = {
    bg = Color3.fromRGB(12, 12, 14),
    card = Color3.fromRGB(22, 22, 26),
    cardHover = Color3.fromRGB(32, 32, 38),
    border = Color3.fromRGB(35, 35, 40),
    text = Color3.fromRGB(240, 240, 245),
    textSub = Color3.fromRGB(120, 120, 130),
    accent = Color3.fromRGB(200, 0, 0),
    accentDark = Color3.fromRGB(140, 0, 0),
    accentGlow = Color3.fromRGB(220, 60, 60),
    toggleOff = Color3.fromRGB(45, 45, 50),
    toggleOn = Color3.fromRGB(200, 0, 0),
    success = Color3.fromRGB(220, 60, 60),
    gold = Color3.fromRGB(255, 185, 50),
}

local weaponSkinLoopStarted = false
local BAT_SWING_SOUND_ID = "rbxassetid://9113305311"
local KATANA_SWING_SOUND_ID = "rbxassetid://111808555599832"
local BAN_HAMMER_SWING_SOUND_ID = "rbxassetid://137964779511233"

local WeaponAdjustDefaults = {
    Katana = {x = 0.09, y = 0.5, z = 0.55, rx = 18, ry = -180, rz = 95, scale = 5.5},
    Scythe = {x = 0.09, y = -1, z = -0.8, rx = 5, ry = -90, rz = 0, scale = 6},
}
local WeaponAdjustProfiles = State.weaponAdjustProfiles or {
    Katana = {x = 0.09, y = 0.5, z = 0.55, rx = 18, ry = -180, rz = 95, scale = 5.5},
    Scythe = {x = 0.09, y = -1, z = -0.8, rx = 5, ry = -90, rz = 0, scale = 6},
}
State.weaponAdjustProfiles = WeaponAdjustProfiles

local BAN_HAMMER_ASSET_ID = "14701192921"

local SwordSkins = {
    {name = "Katana", assetId = "47562480"},
    {name = "Scythe", assetId = "8699386664"},
    {name = "Ban Hammer", assetId = BAN_HAMMER_ASSET_ID},
    {name = "None", assetId = nil},
}

if not WeaponAdjustProfiles["Ban Hammer"] then
    WeaponAdjustProfiles["Ban Hammer"] = {x = 0, y = -1, z = 0, rx = 0, ry = 180, rz = 0, scale = 4}
end
if not WeaponAdjustDefaults["Ban Hammer"] then
    WeaponAdjustDefaults["Ban Hammer"] = {x = 0, y = -1, z = 0, rx = 0, ry = 180, rz = 0, scale = 4}
end

local function normalizeSwordSkinName(name)
    name = tostring(name or "Katana")
    if name == "Off" or name == "OFF" or name == "Normal" or name == "NORMAL" then
        return "None"
    end
    if name == "Tanjiro Sword" or name == "Adurite Katana" or name == "Japan Katana" or name == "Tanto" or name == "Diamond Blade" then
        return "Katana"
    end
    if name == "Staff of Irish" or name == "Staff of Cursed" or name == "Clover Bat" or name == "Dildo" then
        return "None"
    end
    for _, skin in ipairs(SwordSkins) do
        if skin.name == name then return skin.name end
    end
    return "Katana"
end

local function cloneAdjustProfile(src)
    local t = {}
    for k, v in pairs(src or {}) do t[k] = v end
    return t
end

local function getCurrentWeaponAdjust()
    local skinName = normalizeSwordSkinName(State.swordSkin)
    if not WeaponAdjustProfiles[skinName] then
        WeaponAdjustProfiles[skinName] = cloneAdjustProfile(WeaponAdjustDefaults[skinName] or WeaponAdjustDefaults.Katana)
    end
    State.weaponAdjustProfiles = WeaponAdjustProfiles
    return WeaponAdjustProfiles[skinName]
end

local function getSelectedSwordSkin()
    State.swordSkin = normalizeSwordSkinName(State.swordSkin)
    for _, skin in ipairs(SwordSkins) do
        if skin.name == State.swordSkin then return skin end
    end
    return SwordSkins[1]
end

local function getSwordSkinNames()
    local names = {}
    for _, skin in ipairs(SwordSkins) do table.insert(names, skin.name) end
    return names
end

local function isFlowerSkinObject(obj)
    return obj and type(obj.Name) == "string" and obj.Name:match("^FlowerSkin_") ~= nil
end

local function getToolHandle(tool)
    if not tool then return nil end
    return tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart", true)
end

local function isBatSkinTool(tool)
    if not (tool and tool:IsA("Tool")) then return false end
    local n = tool.Name:lower()
    return n:find("bat") or n:find("slap")
end

function applyBatSwingSound(tool)
    if not tool then return end
    local skinName = normalizeSwordSkinName(State.swordSkin)
    if skinName == "None" or not State.weaponSkinsEnabled then return end
    local isBanHammer = (skinName == "Ban Hammer")
    local isKatanaOrScythe = (skinName == "Katana" or skinName == "Scythe")
    local swingSoundId = isBanHammer and BAN_HAMMER_SWING_SOUND_ID or (isKatanaOrScythe and KATANA_SWING_SOUND_ID or BAT_SWING_SOUND_ID)
    for _, obj in ipairs(tool:GetDescendants()) do
        if obj:IsA("Sound") then
            local n = string.lower(obj.Name or "")
            pcall(function()
                if n == "" or n:find("swing") or n:find("slash") or n:find("bat") or n:find("slap") or n:find("lunge") or n:find("attack") then
                    if not obj:GetAttribute("OriginalSoundId") then
                        obj:SetAttribute("OriginalSoundId", obj.SoundId)
                    end
                    obj.SoundId = swingSoundId
                    obj.Volume = 0.7
                    obj.PlaybackSpeed = 1
                    if isBanHammer and not obj:GetAttribute("_BanHammerCutoff") then
                        obj:SetAttribute("_BanHammerCutoff", true)
                        obj.Played:Connect(function()
                            task.delay(0.4, function()
                                if obj and obj.Parent and obj.Playing then
                                    pcall(function() obj:Stop() end)
                                end
                            end)
                        end)
                    end
                end
            end)
        end
    end
end

local function forceRedVFX(model)
    if not model then return end
    local RED = Color3.fromRGB(200, 0, 0)
    local RED_LIGHT = Color3.fromRGB(255, 100, 100)
    local RED_DARK = Color3.fromRGB(140, 0, 0)
    for _, obj in ipairs(model:GetDescendants()) do
        local objName = string.lower(obj.Name or "")
        if obj:IsA("ParticleEmitter") then
            pcall(function()
                obj.Enabled = true
                obj.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, RED_LIGHT),
                    ColorSequenceKeypoint.new(0.5, RED),
                    ColorSequenceKeypoint.new(1, RED_DARK)
                })
                obj.LightEmission = math.max(obj.LightEmission or 0, 0.6)
                pcall(function() obj.Texture = "rbxasset://textures/particles/sparkles_main.dds" end)
            end)
        elseif obj:IsA("Trail") or obj:IsA("Beam") then
            pcall(function()
                obj.Enabled = true
                obj.Color = ColorSequence.new(RED, RED_DARK)
                obj.LightEmission = math.max(obj.LightEmission or 0, 0.5)
                pcall(function() obj.Texture = "" end)
            end)
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            pcall(function()
                obj.Enabled = true
                obj.Color = RED
            end)
        elseif obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Smoke") then
            pcall(function()
                obj.Enabled = true
                obj.Color = RED
                if obj:IsA("Fire") then obj.SecondaryColor = RED_LIGHT end
            end)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function() obj.Color3 = RED end)
        elseif obj:IsA("BasePart") then
            local c = obj.Color
            local redDominant = (c.R > 0.38 and c.R > (c.B * 1.03) and c.G < 0.50)
            local orangeOrYellowVFX = (c.R > 0.50 and c.G > 0.20 and c.B < 0.28)
            local looksLikeVFX = obj.Material == Enum.Material.Neon
                or objName:find("vfx") or objName:find("effect") or objName:find("trail")
                or objName:find("aura") or objName:find("glow") or objName:find("fire")
                or objName:find("flame") or objName:find("slash") or objName:find("spark")
                or objName:find("red") or objName:find("orange") or objName:find("yellow")
            if redDominant or orangeOrYellowVFX or looksLikeVFX then
                pcall(function() obj.Color = RED end)
            end
        end
    end
end

local function addRedWeaponVFX(model)
    if not model then return end
    local RED = Color3.fromRGB(200, 0, 0)
    local RED_DARK = Color3.fromRGB(140, 0, 0)
    local RED_LIGHT = Color3.fromRGB(255, 100, 100)
    for _, obj in ipairs(model:GetDescendants()) do
        if obj.Name == "FlowerSkin_ExtraRedVFX" then
            pcall(function() obj:Destroy() end)
        end
    end
    local bestPart = nil
    local bestLen = 0
    for _, obj in ipairs(model:GetDescendants()) do
        if obj:IsA("BasePart") then
            local s = obj.Size
            local len = math.max(s.X, s.Y, s.Z)
            if len > bestLen then
                bestLen = len
                bestPart = obj
            end
        end
    end
    if not bestPart then return end
    local a0 = Instance.new("Attachment")
    a0.Name = "FlowerSkin_ExtraRedVFX"
    a0.Position = Vector3.new(0, bestLen * 0.42, 0)
    a0.Parent = bestPart
    local a1 = Instance.new("Attachment")
    a1.Name = "FlowerSkin_ExtraRedVFX"
    a1.Position = Vector3.new(0, -bestLen * 0.42, 0)
    a1.Parent = bestPart
    local trail = Instance.new("Trail")
    trail.Name = "FlowerSkin_ExtraRedVFX"
    trail.Attachment0 = a0
    trail.Attachment1 = a1
    trail.Color = ColorSequence.new(RED_LIGHT, RED_DARK)
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.35),
        NumberSequenceKeypoint.new(1, 1)
    })
    trail.Lifetime = 0.18
    trail.LightEmission = 0.55
    trail.Parent = bestPart
    local pe = Instance.new("ParticleEmitter")
    pe.Name = "FlowerSkin_ExtraRedVFX"
    pe.Color = ColorSequence.new(RED, RED_LIGHT)
    pe.LightEmission = 0.55
    pe.Rate = 14
    pe.Lifetime = NumberRange.new(0.25, 0.45)
    pe.Speed = NumberRange.new(0.2, 0.7)
    pe.SpreadAngle = Vector2.new(12, 12)
    pe.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.08),
        NumberSequenceKeypoint.new(1, 0)
    })
    pcall(function() pe.Texture = "rbxasset://textures/particles/sparkles_main.dds" end)
    pe.Parent = bestPart
end

function clearWeaponSkin(tool)
    if not tool then return end
    for _, obj in ipairs(tool:GetDescendants()) do
        if isFlowerSkinObject(obj) then
            pcall(function() obj:Destroy() end)
        elseif obj.Name == "FlowerHub_SwingSoundHook" then
            pcall(function() obj:Destroy() end)
        elseif obj:IsA("Sound") then
            pcall(function()
                local origId = obj:GetAttribute("OriginalSoundId")
                if origId and origId ~= "" then
                    obj.SoundId = origId
                    obj:SetAttribute("OriginalSoundId", nil)
                end
            end)
        elseif obj:IsA("BasePart") then
            pcall(function()
                obj.LocalTransparencyModifier = 0
                obj.Transparency = 0
            end)
        elseif obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("ParticleEmitter") then
            pcall(function() obj.Enabled = true end)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function() obj.Transparency = 0 end)
        end
    end
end

local function hideOriginalToolVisuals(tool)
    for _, obj in ipairs(tool:GetDescendants()) do
        if isFlowerSkinObject(obj) then
        elseif obj:IsA("BasePart") then
            pcall(function()
                obj.LocalTransparencyModifier = 1
                obj.Transparency = 1
                obj.CastShadow = false
            end)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function() obj.Transparency = 1 end)
        elseif obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("ParticleEmitter") then
            pcall(function() obj.Enabled = false end)
        elseif obj:IsA("SpecialMesh") then
            pcall(function() obj.TextureId = "" end)
        elseif obj:IsA("SurfaceAppearance") then
            pcall(function() obj:Destroy() end)
        end
    end
end

local function makeCosmeticPart(folder, name, size, color, material, shape)
    local part = Instance.new("Part")
    part.Name = "FlowerSkin_" .. name
    part.Size = size
    part.Color = color
    part.Material = material or Enum.Material.Neon
    part.Shape = shape or Enum.PartType.Block
    part.Anchored = false
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Massless = true
    part.Parent = folder
    return part
end

local function weldToHandle(handle, part, offset)
    if not (handle and part) then return end
    part.CFrame = handle.CFrame * (offset or CFrame.new())
    local weld = Instance.new("WeldConstraint")
    weld.Name = "FlowerSkin_Weld"
    weld.Part0 = handle
    weld.Part1 = part
    weld.Parent = part
end

local function applyKatanaSkin(tool)
    if not tool then return end
    local RED = Color3.fromRGB(200, 0, 0)
    local RED_LIGHT = Color3.fromRGB(255, 100, 100)
    local RED_DARK = Color3.fromRGB(140, 0, 0)
    local selectedSkin = getSelectedSwordSkin()
    if selectedSkin and selectedSkin.name == "None" then
        clearWeaponSkin(tool)
        return
    end
    if tool:FindFirstChild("FlowerSkin_KatanaRealistic") then return end
    local handle = getToolHandle(tool)
    if not handle then return end
    clearWeaponSkin(tool)
    hideOriginalToolVisuals(tool)
    local folder = Instance.new("Folder")
    folder.Name = "FlowerSkin_KatanaRealistic"
    folder.Parent = tool
    local function tryAssetKatana()
        local swordSkin = selectedSkin or getSelectedSwordSkin()
        if not swordSkin or swordSkin.name == "None" or not swordSkin.assetId then return false end
        local assetId = swordSkin.assetId
        local objects = nil
        local ok = pcall(function()
            objects = game:GetObjects("rbxassetid://" .. assetId)
        end)
        if not ok or not objects or not objects[1] then
            return false
        end
        local src = objects[1]
        local clone = src:Clone()
        clone.Name = "FlowerSkin_AssetKatana"
        if clone:IsA("Script") or clone:IsA("LocalScript") or clone:IsA("ModuleScript") then
            pcall(function() clone:Destroy() end)
            return false
        end
        for _, obj in ipairs(clone:GetDescendants()) do
            local n = string.lower(obj.Name or "")
            if n:find("sheath") or n:find("scabbard") or n:find("saya") or n:find("case") or n:find("cover") then
                pcall(function() obj:Destroy() end)
            end
        end
        for _, obj in ipairs(clone:GetDescendants()) do
            local objName = string.lower(obj.Name or "")
            if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") or obj:IsA("ScreenGui") or obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                pcall(function() obj:Destroy() end)
            elseif obj:IsA("SurfaceAppearance") or obj:IsA("MaterialVariant") then
                pcall(function() obj:Destroy() end)
            elseif obj:IsA("ParticleEmitter") then
                pcall(function()
                    obj.Enabled = true
                    obj.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, RED_LIGHT),
                        ColorSequenceKeypoint.new(0.5, RED),
                        ColorSequenceKeypoint.new(1, RED_DARK)
                    })
                    obj.LightEmission = math.max(obj.LightEmission or 0, 0.55)
                    pcall(function() obj.Texture = "rbxasset://textures/particles/sparkles_main.dds" end)
                end)
            elseif obj:IsA("Trail") or obj:IsA("Beam") then
                pcall(function()
                    obj.Enabled = true
                    obj.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, RED_LIGHT),
                        ColorSequenceKeypoint.new(1, RED_DARK)
                    })
                    obj.LightEmission = math.max(obj.LightEmission or 0, 0.45)
                    pcall(function() obj.Texture = "" end)
                end)
            elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                pcall(function()
                    obj.Enabled = true
                    obj.Color = RED
                    obj.Brightness = math.min(math.max(obj.Brightness, 0.8), 2)
                    obj.Range = math.min(math.max(obj.Range, 4), 10)
                end)
            elseif obj:IsA("Fire") or obj:IsA("Sparkles") then
                pcall(function()
                    obj.Enabled = true
                    obj.Color = RED
                    if obj:IsA("Fire") then obj.SecondaryColor = RED_LIGHT end
                end)
            elseif obj:IsA("Smoke") then
                pcall(function()
                    obj.Enabled = true
                    obj.Color = RED
                end)
            elseif obj:IsA("SpecialMesh") then
                pcall(function() obj.VertexColor = Vector3.new(0.85, 0.1, 0.1) end)
            elseif obj:IsA("BasePart") then
                obj.Anchored = false
                obj.CanCollide = false
                obj.CanTouch = false
                obj.CanQuery = false
                obj.Massless = true
                obj.CastShadow = false
                local c = obj.Color
                local redDominant = (c.R > 0.38 and c.R > (c.B * 1.05) and c.G < 0.45)
                local orangeOrYellowVFX = (c.R > 0.50 and c.G > 0.20 and c.B < 0.25)
                local looksLikeVFX = obj.Material == Enum.Material.Neon
                    or objName:find("vfx") or objName:find("effect") or objName:find("trail")
                    or objName:find("aura") or objName:find("glow") or objName:find("fire")
                    or objName:find("flame") or objName:find("slash") or objName:find("spark")
                    or objName:find("red") or objName:find("orange") or objName:find("yellow")
                if redDominant or orangeOrYellowVFX or looksLikeVFX then
                    pcall(function() obj.Color = RED end)
                end
            end
        end
        if clone:IsA("BasePart") then
            pcall(function()
                local c = clone.Color
                if (c.R > 0.38 and c.R > (c.B * 1.05) and c.G < 0.45) or (c.R > 0.50 and c.G > 0.20 and c.B < 0.25) then
                    clone.Color = RED
                end
                clone.Anchored = false
                clone.CanCollide = false
                clone.CanTouch = false
                clone.CanQuery = false
                clone.Massless = true
                clone.CastShadow = false
            end)
        end
        local model
        if clone:IsA("Model") then
            model = clone
            model.Parent = folder
        elseif clone:IsA("Tool") or clone:IsA("Accessory") then
            model = Instance.new("Model")
            model.Name = "FlowerSkin_AssetKatanaModel"
            model.Parent = folder
            clone.Parent = model
        elseif clone:IsA("BasePart") then
            model = Instance.new("Model")
            model.Name = "FlowerSkin_AssetKatanaModel"
            model.Parent = folder
            clone.Parent = model
        else
            local firstPart = clone:FindFirstChildWhichIsA("BasePart", true)
            if not firstPart then
                clone:Destroy()
                return false
            end
            model = Instance.new("Model")
            model.Name = "FlowerSkin_AssetKatanaModel"
            model.Parent = folder
            clone.Parent = model
        end
        local parts = {}
        for _, obj in ipairs(model:GetDescendants()) do
            if obj:IsA("BasePart") then table.insert(parts, obj) end
        end
        if #parts == 0 then
            model:Destroy()
            return false
        end
        local adjust = getCurrentWeaponAdjust()
        local _, size = model:GetBoundingBox()
        local longest = math.max(size.X, size.Y, size.Z)
        if longest > 0 then
            local scale = math.clamp((adjust.scale or 5.00) / longest, 0.15, 8)
            pcall(function() model:ScaleTo(scale) end)
        end
        local _, size2 = model:GetBoundingBox()
        local axis = "Y"
        if size2.X > size2.Y and size2.X > size2.Z then axis = "X" end
        if size2.Z > size2.Y and size2.Z > size2.X then axis = "Z" end
        local rot = CFrame.new()
        if axis == "X" then
            rot = CFrame.Angles(0, 0, math.rad(90))
        elseif axis == "Z" then
            rot = CFrame.Angles(math.rad(90), 0, 0)
        end
        local desired = handle.CFrame
            * CFrame.new(adjust.x or 0, adjust.y or 0, adjust.z or 0)
            * rot
            * CFrame.Angles(math.rad(adjust.rx or 0), math.rad(adjust.ry or 0), math.rad(adjust.rz or 0))
        pcall(function() model:PivotTo(desired) end)
        for _, part in ipairs(parts) do
            part.Anchored = false
            local weld = Instance.new("WeldConstraint")
            weld.Name = "FlowerSkin_AssetWeld"
            weld.Part0 = handle
            weld.Part1 = part
            weld.Parent = part
        end
        forceRedVFX(model)
        addRedWeaponVFX(model)
        task.delay(0.25, function()
            if model and model.Parent then
                forceRedVFX(model)
                addRedWeaponVFX(model)
            end
        end)
        return true
    end
    if tryAssetKatana() then
        return
    end
    local blade = makeCosmeticPart(folder, "SolidSteelBlade", Vector3.new(0.30, 4.70, 0.060), Color3.fromRGB(168, 181, 190), Enum.Material.Metal)
    weldToHandle(handle, blade, CFrame.new(0.045, 2.58, 0))
    local bladeHighlight = makeCosmeticPart(folder, "BladeHighlight", Vector3.new(0.060, 4.45, 0.066), Color3.fromRGB(224, 232, 238), Enum.Material.Metal)
    weldToHandle(handle, bladeHighlight, CFrame.new(0.155, 2.50, -0.004))
    local bladeShadow = makeCosmeticPart(folder, "BladeShadow", Vector3.new(0.055, 4.45, 0.066), Color3.fromRGB(62, 72, 82), Enum.Material.Metal)
    weldToHandle(handle, bladeShadow, CFrame.new(-0.120, 2.50, 0.004))
    local tip = Instance.new("WedgePart")
    tip.Name = "FlowerSkin_SolidBladeTip"
    tip.Size = Vector3.new(0.30, 0.58, 0.060)
    tip.Color = Color3.fromRGB(185, 198, 206)
    tip.Material = Enum.Material.Metal
    tip.Anchored = false
    tip.CanCollide = false
    tip.CanTouch = false
    tip.CanQuery = false
    tip.Massless = true
    tip.Parent = folder
    weldToHandle(handle, tip, CFrame.new(0.045, 5.10, 0) * CFrame.Angles(0, 0, math.rad(180)))
    local cuttingEdge = makeCosmeticPart(folder, "CuttingEdge", Vector3.new(0.032, 4.82, 0.070), Color3.fromRGB(235, 242, 246), Enum.Material.Metal)
    weldToHandle(handle, cuttingEdge, CFrame.new(0.210, 2.64, -0.006))
    local hamon = makeCosmeticPart(folder, "SubtleRedHamon", Vector3.new(0.026, 3.80, 0.073), RED, Enum.Material.Neon)
    hamon.Transparency = 0.18
    weldToHandle(handle, hamon, CFrame.new(0.070, 2.38, -0.009))
    local guard = makeCosmeticPart(folder, "OvalGuard", Vector3.new(1.05, 0.105, 0.36), Color3.fromRGB(18, 14, 16), Enum.Material.Metal)
    weldToHandle(handle, guard, CFrame.new(0, 0.10, 0))
    local guardRim = makeCosmeticPart(folder, "RedGuardRim", Vector3.new(1.16, 0.035, 0.42), RED_DARK, Enum.Material.Metal)
    weldToHandle(handle, guardRim, CFrame.new(0, 0.16, 0))
    local grip = makeCosmeticPart(folder, "WrappedGrip", Vector3.new(0.31, 1.02, 0.31), Color3.fromRGB(12, 10, 12), Enum.Material.SmoothPlastic, Enum.PartType.Cylinder)
    weldToHandle(handle, grip, CFrame.new(0, -0.50, 0))
    for i = 1, 6 do
        local band = makeCosmeticPart(folder, "GripWrap" .. i, Vector3.new(0.335, 0.035, 0.335), (i % 2 == 0) and RED_DARK or Color3.fromRGB(35, 18, 30), Enum.Material.Metal, Enum.PartType.Cylinder)
        weldToHandle(handle, band, CFrame.new(0, -0.93 + (i * 0.145), 0))
    end
    local pommel = makeCosmeticPart(folder, "DarkPommel", Vector3.new(0.36, 0.16, 0.36), Color3.fromRGB(18, 14, 16), Enum.Material.Metal, Enum.PartType.Ball)
    weldToHandle(handle, pommel, CFrame.new(0, -1.12, 0))
    local pommelGem = makeCosmeticPart(folder, "PommelRedGem", Vector3.new(0.16, 0.08, 0.16), RED, Enum.Material.Neon, Enum.PartType.Ball)
    weldToHandle(handle, pommelGem, CFrame.new(0, -1.22, 0))
    local bladeGlow = Instance.new("PointLight")
    bladeGlow.Name = "FlowerSkin_SubtleRedGlow"
    bladeGlow.Color = RED
    bladeGlow.Brightness = 0.35
    bladeGlow.Range = 3.2
    bladeGlow.Parent = hamon
    local a0 = Instance.new("Attachment")
    a0.Name = "FlowerSkin_TrailTop"
    a0.Position = Vector3.new(0.19, 2.25, 0)
    a0.Parent = blade
    local a1 = Instance.new("Attachment")
    a1.Name = "FlowerSkin_TrailBottom"
    a1.Position = Vector3.new(0.19, -2.15, 0)
    a1.Parent = blade
    local trail = Instance.new("Trail")
    trail.Name = "FlowerSkin_SoftSwordTrail"
    trail.Attachment0 = a0
    trail.Attachment1 = a1
    trail.Color = ColorSequence.new(RED_LIGHT, Color3.fromRGB(210, 220, 230))
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.68),
        NumberSequenceKeypoint.new(1, 1)
    })
    trail.Lifetime = 0.12
    trail.LightEmission = 0.12
    trail.Parent = blade
end

function refreshWeaponSkins()
    local containers = {}
    if LocalPlayer.Character then table.insert(containers, LocalPlayer.Character) end
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack") or LocalPlayer:FindFirstChild("Backpack")
    if bp then table.insert(containers, bp) end
    for _, container in ipairs(containers) do
        for _, tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") and isBatSkinTool(tool) then
                if State.weaponSkinsEnabled then
                    pcall(applyBatSwingSound, tool)
                    applyKatanaSkin(tool)
                else
                    clearWeaponSkin(tool)
                end
            end
        end
    end
end

function startWeaponSkinLoop()
    if weaponSkinLoopStarted then return end
    weaponSkinLoopStarted = true
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        pcall(refreshWeaponSkins)
    end)
    task.spawn(function()
        while task.wait(0.75) do
            pcall(refreshWeaponSkins)
        end
    end)
end

function forceRefreshWeaponSkins()
    local containers = {}
    if LocalPlayer.Character then table.insert(containers, LocalPlayer.Character) end
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack") or LocalPlayer:FindFirstChild("Backpack")
    if bp then table.insert(containers, bp) end
    for _, container in ipairs(containers) do
        for _, tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") and isBatSkinTool(tool) then
                clearWeaponSkin(tool)
            end
        end
    end
    refreshWeaponSkins()
end

for _, name in pairs({"IrishBatSkins", "AdaptCherry", "CursedBatSkins"}) do
    pcall(function() local o = CoreGui:FindFirstChild(name); if o then o:Destroy() end end)
    pcall(function() local o = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(name); if o then o:Destroy() end end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "CursedBatSkins"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local W, H = 240, 140
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, W, 0, H)
mainFrame.Position = UDim2.new(1, -W - 8, 0, 8)
mainFrame.BackgroundColor3 = colors.bg
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local innerGrad = Instance.new("UIGradient", mainFrame)
innerGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 20, 22)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 12, 14)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 10))
})
innerGrad.Rotation = 145

local borderStroke = Instance.new("UIStroke", mainFrame)
borderStroke.Thickness = 1.5
borderStroke.Transparency = 0.2
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
local borderGrad = Instance.new("UIGradient", borderStroke)
borderGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 0, 0)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 185, 50)),
    ColorSequenceKeypoint.new(0.65, Color3.fromRGB(200, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 185, 50))
})
RunService.Heartbeat:Connect(function(dt)
    if mainFrame and mainFrame.Parent then borderGrad.Rotation = (borderGrad.Rotation + 60 * dt) % 360 end
end)

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local titleDiv = Instance.new("Frame", mainFrame)
titleDiv.Size = UDim2.new(1, -16, 0, 1)
titleDiv.Position = UDim2.new(0, 8, 0, 30)
titleDiv.BackgroundColor3 = colors.accent
titleDiv.BackgroundTransparency = 0.7
titleDiv.BorderSizePixel = 0

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size = UDim2.new(1, -40, 1, 0)
titleLbl.Position = UDim2.new(0, 12, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Cursed Bat Skins"
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 12
titleLbl.TextColor3 = colors.text
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

local minimizeBtn = Instance.new("TextButton", titleBar)
minimizeBtn.Size = UDim2.new(0, 22, 0, 22)
minimizeBtn.Position = UDim2.new(1, -26, 0, 4)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
minimizeBtn.BackgroundTransparency = 0.5
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = colors.textSub
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 12
minimizeBtn.BorderSizePixel = 0
minimizeBtn.AutoButtonColor = false
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 5)

minimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0, TextColor3 = colors.text}):Play()
end)
minimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0.5, TextColor3 = colors.textSub}):Play()
end)

local miniBtn = Instance.new("TextButton", gui)
miniBtn.Name = "MiniClover"
miniBtn.Size = UDim2.new(0, 40, 0, 40)
miniBtn.Position = UDim2.new(1, -48, 0, 8)
miniBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
miniBtn.BackgroundTransparency = 0.1
miniBtn.Text = "C"
miniBtn.TextColor3 = colors.accent
miniBtn.Font = Enum.Font.GothamBlack
miniBtn.TextSize = 18
miniBtn.BorderSizePixel = 0
miniBtn.Visible = false
miniBtn.ZIndex = 200
miniBtn.AutoButtonColor = false
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 10)
local miniStroke = Instance.new("UIStroke", miniBtn)
miniStroke.Color = colors.accent
miniStroke.Thickness = 1.5
miniStroke.Transparency = 0.4

miniBtn.MouseEnter:Connect(function()
    TweenService:Create(miniStroke, TweenInfo.new(0.15), {Transparency = 0, Thickness = 2}):Play()
    TweenService:Create(miniBtn, TweenInfo.new(0.15), {Size = UDim2.new(0, 44, 0, 44)}):Play()
end)
miniBtn.MouseLeave:Connect(function()
    TweenService:Create(miniStroke, TweenInfo.new(0.15), {Transparency = 0.4, Thickness = 1.5}):Play()
    TweenService:Create(miniBtn, TweenInfo.new(0.15), {Size = UDim2.new(0, 40, 0, 40)}):Play()
end)

local miniDragging, miniDragStart, miniStartPos = false, nil, nil
miniBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        miniDragging = true; miniDragStart = input.Position; miniStartPos = miniBtn.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then miniDragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if miniDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - miniDragStart
        miniBtn.Position = UDim2.new(miniStartPos.X.Scale, miniStartPos.X.Offset + delta.X, miniStartPos.Y.Scale, miniStartPos.Y.Offset + delta.Y)
    end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.delay(0.15, function() mainFrame.Visible = false; miniBtn.Visible = true end)
end)

miniBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if miniDragStart and (input.Position - miniDragStart).Magnitude < 10 then
            miniBtn.Visible = false; mainFrame.Visible = true; mainFrame.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, W, 0, H)}):Play()
        end
    end
end)

local dragging, dragStart, startPos = false, nil, nil
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = mainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local toggleRow = Instance.new("Frame", mainFrame)
toggleRow.Size = UDim2.new(1, -20, 0, 40)
toggleRow.Position = UDim2.new(0, 10, 0, 38)
toggleRow.BackgroundColor3 = colors.card
toggleRow.BorderSizePixel = 0
Instance.new("UICorner", toggleRow).CornerRadius = UDim.new(0, 7)

local toggleLbl = Instance.new("TextLabel", toggleRow)
toggleLbl.Size = UDim2.new(1, -60, 1, 0)
toggleLbl.Position = UDim2.new(0, 12, 0, 0)
toggleLbl.BackgroundTransparency = 1
toggleLbl.Text = "Bat Skins"
toggleLbl.Font = Enum.Font.GothamBold
toggleLbl.TextSize = 12
toggleLbl.TextColor3 = colors.text
toggleLbl.TextXAlignment = Enum.TextXAlignment.Left

local pillBg = Instance.new("Frame", toggleRow)
pillBg.Size = UDim2.new(0, 80, 0, 22)
pillBg.Position = UDim2.new(1, -86, 0.5, -11)
pillBg.BackgroundColor3 = State.weaponSkinsEnabled and colors.toggleOn or colors.toggleOff
pillBg.BorderSizePixel = 0
Instance.new("UICorner", pillBg).CornerRadius = UDim.new(0, 11)

local pillText = Instance.new("TextLabel", pillBg)
pillText.Size = UDim2.new(1, 0, 1, 0)
pillText.BackgroundTransparency = 1
pillText.Text = "/cursedhub"
pillText.Font = Enum.Font.GothamBold
pillText.TextSize = 10
pillText.TextColor3 = colors.text
pillText.TextXAlignment = Enum.TextXAlignment.Center

local skinsOn = State.weaponSkinsEnabled
local toggleClick = Instance.new("TextButton", toggleRow)
toggleClick.Size = UDim2.new(1, 0, 1, 0)
toggleClick.BackgroundTransparency = 1
toggleClick.Text = ""
toggleClick.ZIndex = 5
toggleClick.MouseButton1Click:Connect(function()
    skinsOn = not skinsOn
    State.weaponSkinsEnabled = skinsOn
    TweenService:Create(pillBg, TweenInfo.new(0.18), {BackgroundColor3 = skinsOn and colors.toggleOn or colors.toggleOff}):Play()
    refreshWeaponSkins()
    saveConfig()
end)

local skinRow = Instance.new("Frame", mainFrame)
skinRow.Size = UDim2.new(1, -20, 0, 40)
skinRow.Position = UDim2.new(0, 10, 0, 84)
skinRow.BackgroundColor3 = colors.card
skinRow.BorderSizePixel = 0
Instance.new("UICorner", skinRow).CornerRadius = UDim.new(0, 7)

local skinLbl = Instance.new("TextLabel", skinRow)
skinLbl.Size = UDim2.new(0, 45, 1, 0)
skinLbl.Position = UDim2.new(0, 12, 0, 0)
skinLbl.BackgroundTransparency = 1
skinLbl.Text = "Skin"
skinLbl.Font = Enum.Font.GothamBold
skinLbl.TextSize = 12
skinLbl.TextColor3 = colors.text
skinLbl.TextXAlignment = Enum.TextXAlignment.Left

local skinBtn = Instance.new("TextButton", skinRow)
skinBtn.Size = UDim2.new(1, -70, 0, 28)
skinBtn.Position = UDim2.new(0, 60, 0.5, -14)
skinBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
skinBtn.BorderSizePixel = 0
skinBtn.TextColor3 = colors.gold
skinBtn.Font = Enum.Font.GothamBold
skinBtn.TextSize = 10
skinBtn.AutoButtonColor = false
skinBtn.ZIndex = 5
Instance.new("UICorner", skinBtn).CornerRadius = UDim.new(0, 5)
local skinBtnStroke = Instance.new("UIStroke", skinBtn)
skinBtnStroke.Color = colors.accent
skinBtnStroke.Thickness = 1
skinBtnStroke.Transparency = 0.5

skinBtn.MouseEnter:Connect(function()
    TweenService:Create(skinBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(38, 38, 46)}):Play()
    TweenService:Create(skinBtnStroke, TweenInfo.new(0.1), {Transparency = 0}):Play()
end)
skinBtn.MouseLeave:Connect(function()
    TweenService:Create(skinBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(28, 28, 34)}):Play()
    TweenService:Create(skinBtnStroke, TweenInfo.new(0.1), {Transparency = 0.5}):Play()
end)

local function refreshSkinBtn()
    State.swordSkin = normalizeSwordSkinName(State.swordSkin)
    skinBtn.Text = string.upper(State.swordSkin)
end
refreshSkinBtn()

skinBtn.MouseButton1Click:Connect(function()
    local names = getSwordSkinNames()
    local cur = normalizeSwordSkinName(State.swordSkin)
    local idx = 1
    for i, name in ipairs(names) do if name == cur then idx = i; break end end
    State.swordSkin = names[(idx % #names) + 1]
    refreshSkinBtn()
    TweenService:Create(skinBtn, TweenInfo.new(0.06), {BackgroundColor3 = colors.accent, TextColor3 = colors.bg}):Play()
    task.delay(0.15, function()
        if skinBtn and skinBtn.Parent then
            TweenService:Create(skinBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(28, 28, 34), TextColor3 = colors.gold}):Play()
        end
    end)
    if State.weaponSkinsEnabled then forceRefreshWeaponSkins() end
    saveConfig()
end)

UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.LeftControl then
        if mainFrame.Visible then
            TweenService:Create(mainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            task.delay(0.15, function() mainFrame.Visible = false; miniBtn.Visible = true end)
        else
            miniBtn.Visible = false; mainFrame.Visible = true; mainFrame.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, W, 0, H)}):Play()
        end
    end
end)

startWeaponSkinLoop()
if State.weaponSkinsEnabled then pcall(refreshWeaponSkins) end
task.spawn(function() while task.wait(10) do pcall(saveConfig) end end)