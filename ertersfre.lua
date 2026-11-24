local CoreGui = game:GetService("CoreGui")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local OPT_ON = true
local HARSH_ON = true
local TARGET_FPS = 2000

local function findGlobalFunction(name)
    local fn
    pcall(function() fn = getgenv and getgenv()[name] end)
    if type(fn) == "function" then return fn end
    pcall(function() fn = _G[name] end)
    if type(fn) == "function" then return fn end
    pcall(function() fn = getfenv(0)[name] end)
    if type(fn) == "function" then return fn end
    pcall(function() fn = rawget(getfenv(2), name) end)
    if type(fn) == "function" then return fn end
    return nil
end

local FFlags = {
    ["FFlagTaskSchedulerLimitTargetFpsToDevice"] = "False",
    ["FFlagTaskSchedulerLimitTargetFpsTo2402"] = "False",
    ["FFlagGameBasicSettingsFramerateCap5"] = "False",
    ["DFIntTaskSchedulerTargetFps"] = tostring(TARGET_FPS),
    ["FFlagHandleAltEnterFullscreenManually"] = "False",
    ["FFlagEnableTextureStreaming"] = "True",
    ["FFlagPreloadAllFonts"] = "True",
    ["DFFlagEnableSoundPreloading"] = "True",
    ["DFFlagEnableMeshPreloading"] = "True",
    ["DFFlagEnableMeshPreloading2"] = "True",
    ["DFFlagEnableTexturePreloading"] = "True",
    ["FFlagAssetPreloadingIXP"] = "True",
    ["DFFlagEnablePreloadAvatarAssets"] = "True",
    ["DFFlagTeleportClientAssetPreloadingEnabledIXP"] = "True",
    ["DFFlagTeleportClientAssetPreloadingEnabledIXP2"] = "True",
    ["DFFlagTeleportClientAssetPreloadingEnabled9"] = "True",
    ["DFFlagTeleportClientAssetPreloadingDoingExperiment"] = "True",
    ["DFFlagTeleportClientAssetPreloadingDoingExperiment2"] = "True",
    ["DFFlagTeleportPreloadingMetrics5"] = "True",
    ["DFFlagPreloadAsyncSupportTexturePack"] = "True",
    ["FFlagPreloadTextureItemsOption4"] = "True",
    ["FFlagUseNewLuaPreloadAssets"] = "True",
    ["DFFlagEnableScriptPreloadOnJoin"] = "True",
    ["FFlagLuaAppsScriptPreload"] = "True",
    ["DFFlagRemoveUnusedKtxMetadata"] = "True",
    ["DFIntContentProviderMaximumRequestsPerStep"] = "10000",
    ["DFIntContentProviderMaximumRequestsPerSecond"] = "10000",
    ["DFIntSolidModelStreamDebounceSecs"] = "0",
    ["FIntRenderGrassDetailStrands"] = "0",
    ["FIntRenderGrassHeightScaler"] = "0",
    ["FIntTerrainOctreeMaxCells"] = "0",
    ["FIntDebugForceMSAASamples"] = "0",
    ["FIntRenderShadowIntensity"] = "0",
    ["DFIntSignalRCoreTimerMs"] = "50",
    ["FIntActivatedCountTimerMSMouse"] = "0",
    ["FIntActivatedCountTimerMSKeyboard"] = "0",
}

pcall(function()
    local setFF = findGlobalFunction("setfflag")
    if not setFF then return end
    for flag, value in pairs(FFlags) do pcall(setFF, flag, value) end
end)

pcall(function()
    local setCap = findGlobalFunction("setfpscap")
    if setCap then setCap(TARGET_FPS) end
end)

pcall(function()
    local rs = settings():GetService("RenderSettings")
    rs.QualityLevel = Enum.QualityLevel.Level01
    rs.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
end)

-- File d'attente ultra-rapide (4 ms/frame) pour éviter tout freeze quand un joueur rejoint
local taskQueue = {}
local qHead, qTail = 1, 0
local function enqueue(fn)
    qTail += 1
    taskQueue[qTail] = fn
end

RunService.Heartbeat:Connect(function()
    if qHead > qTail then
        if qHead > 1 then
            table.clear(taskQueue)
            qHead, qTail = 1, 0
        end
        return
    end
    local start = os.clock()
    while qHead <= qTail and (os.clock() - start) < 0.004 do
        local fn = taskQueue[qHead]
        taskQueue[qHead] = nil
        qHead += 1
        if fn then pcall(fn) end
    end
end)

-- Helpers d'identification (Brainrots, joueurs, tapis magiques)
local BODY_PART = {
    HumanoidRootPart = true, Head = true, Torso = true,
    UpperTorso = true, LowerTorso = true,
    LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
    RightUpperArm = true, RightLowerArm = true, RightHand = true,
    LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
    RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
    ["Left Arm"] = true, ["Right Arm"] = true,
    ["Left Leg"] = true, ["Right Leg"] = true,
}

local function isCarpetName(name)
    if type(name) ~= "string" then return false end
    local l = string.lower(name)
    return string.find(l, "carpet", 1, true) ~= nil
        or string.find(l, "tapis", 1, true) ~= nil
        or string.find(l, "rug", 1, true) ~= nil
        or string.find(l, "mat", 1, true) ~= nil
end

local function isCarpetInstance(inst)
    local x = inst
    for _ = 1, 10 do
        if not x or x == workspace then break end
        if isCarpetName(x.Name) then return true end
        x = x.Parent
    end
    return false
end

local function isCharacterModel(m)
    if not (m and m:IsA("Model")) then return false end
    if Players:GetPlayerFromCharacter(m) then return true end
    if m:FindFirstChildOfClass("Humanoid") then return true end
    return false
end

local function getAncestorCharacter(inst)
    local x = inst
    for _ = 1, 14 do
        if not x or x == workspace then break end
        if isCharacterModel(x) then return x end
        x = x.Parent
    end
    return nil
end

local function isWeldedToCharacter(inst)
    -- Vérifie si le modèle/part est soudé à un joueur (cas des Brainrots volés/portés en main)
    local root = inst
    while root and root.Parent and root.Parent ~= workspace and root.Parent.Name ~= "Plots" do
        if isCharacterModel(root.Parent) then
            return true, root.Parent
        end
        root = root.Parent
    end
    if not root then return false, nil end
    for _, d in ipairs(root:GetDescendants()) do
        if d:IsA("Weld") or d:IsA("WeldConstraint") or d:IsA("Motor6D") then
            local p0, p1 = d.Part0, d.Part1
            local c0 = p0 and getAncestorCharacter(p0)
            if c0 then return true, c0 end
            local c1 = p1 and getAncestorCharacter(p1)
            if c1 then return true, c1 end
        end
    end
    return false, nil
end

local function isBrainrotModel(inst)
    if not inst then return false end
    local m = inst:IsA("Model") and inst or inst:FindFirstAncestorOfClass("Model")
    if not m or isCharacterModel(m) then return false end
    if isCarpetInstance(m) then return false end

    -- 1. Brainrot sur le tapis roulant ou dans une base
    if m.Parent and (m.Parent.Name == "RenderedMovingAnimals" or (m.Parent.Parent and m.Parent.Parent.Name == "Plots")) then
        if m:FindFirstChild("FakeRootPart") or m:FindFirstChild("RootPart")
            or m:FindFirstChildWhichIsA("AnimationController", true)
            or m:FindFirstChildWhichIsA("MeshPart", true) then
            return true
        end
    end

    -- 2. Brainrot porté dans les mains d'un joueur (parenté au personnage ou soudé à lui)
    local char = getAncestorCharacter(m)
    if char then
        -- Tout modèle/accessoire/outil sur un joueur qui n'est pas un tapis magique ni une partie du corps
        if not BODY_PART[m.Name] then
            return true
        end
    end
    local welded, wChar = isWeldedToCharacter(m)
    if welded and wChar and not isCarpetInstance(m) then
        return true
    end

    -- 3. Présence explicite des racines de Brainrot
    if m:FindFirstChild("FakeRootPart") or m:FindFirstChild("RootPart") then
        return true
    end

    return false
end

local function isUnderPlots(inst)
    local x = inst.Parent
    for _ = 1, 16 do
        if not x then break end
        if x.Name == "Plots" and x.Parent == workspace then return true end
        if x == workspace then break end
        x = x.Parent
    end
    return false
end

-- Adoucissement des couleurs trop vives sur les Brainrots (sans jamais toucher à TextureID ni Transparency)
local function toneDownBrainrotPart(part)
    if not (part and part:IsA("BasePart")) then return end
    pcall(function()
        part.CastShadow = false
        part.Reflectance = 0
        if part.Material == Enum.Material.Neon then
            part.Material = Enum.Material.SmoothPlastic
        end
        local c = part.Color
        local h, s, v = c:ToHSV()
        if s > 0.55 or v > 0.80 then
            part.Color = Color3.fromHSV(h, math.min(s, 0.45), math.min(v, 0.72))
        end
    end)
end

-- Rouges fluo (bases Cursed / lasers) convertis en rouge sombre
local DARK_RED = Color3.fromRGB(95, 18, 18)
local function darkenBrightRed(part)
    if not (part and part:IsA("BasePart")) then return end
    local c = part.Color
    if c.R > 0.62 and c.G < 0.35 and c.B < 0.35 then
        part.Color = DARK_RED
        if part.Material == Enum.Material.Neon then
            part.Material = Enum.Material.SmoothPlastic
        end
    end
end

-- Joueurs et tapis magiques en noir uni (sans toucher aux Brainrots portés en main !)
local PLAYER_BLACK = Color3.fromRGB(22, 22, 25)
local function applyBlackToPlayerOrCarpet(inst)
    if not inst then return end
    if isBrainrotModel(inst) then
        if inst:IsA("BasePart") then
            toneDownBrainrotPart(inst)
        end
        return
    end
    if inst:IsA("BasePart") then
        -- Ne jamais toucher aux Hitbox / RootPart invisibles (Transparency >= 0.95)
        if inst.Transparency >= 0.95 then return end
        pcall(function()
            inst.Material = Enum.Material.SmoothPlastic
            inst.Color = PLAYER_BLACK
            inst.Reflectance = 0
            inst.CastShadow = false
        end)
    elseif inst:IsA("Shirt") or inst:IsA("Pants") or inst:IsA("ShirtGraphic") or inst:IsA("CharacterMesh") then
        pcall(function() inst:Destroy() end)
    elseif inst:IsA("Decal") or inst:IsA("Texture") then
        -- Conserver le visage si voulu ou masquer les motifs vifs sur le joueur/tapis
        if isCarpetInstance(inst) or inst.Name ~= "face" then
            pcall(function() inst.Transparency = 1 end)
        end
    elseif inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") or inst:IsA("PointLight") then
        pcall(function() inst.Enabled = false end)
    end
end

-- Nettoyage général des pièces de l'environnement (Sol lisse sans taches grises)
local function permanentStrip(inst)
    if not inst or not inst.Parent then return end

    -- 1. Particules et lumières gourmandes : toujours désactivées
    if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Smoke")
        or inst:IsA("Fire") or inst:IsA("Sparkles") or inst:IsA("Beam") then
        pcall(function() inst.Enabled = false end)
        return
    elseif inst:IsA("PointLight") or inst:IsA("SpotLight") or inst:IsA("SurfaceLight") then
        pcall(function() inst.Enabled = false end)
        return
    elseif inst:IsA("Explosion") then
        pcall(function() inst.Visible = false end)
        return
    end

    -- 2. Si c'est un Brainrot (sur la map, en base ou dans les mains) :
    --    ON NE SUPPRIME JAMAIS SES TEXTURES/MESHES NI SA TRANSPARENCE !
    if isBrainrotModel(inst) then
        if inst:IsA("BasePart") then
            -- Garder les Hitbox / FakeRootPart invisibles (Transparency == 1) tels quels
            if inst.Transparency < 0.95 then
                toneDownBrainrotPart(inst)
            end
        end
        return
    end

    -- 3. Si c'est un joueur ou un tapis magique -> noir uni
    local char = getAncestorCharacter(inst)
    if char or isCarpetInstance(inst) then
        applyBlackToPlayerOrCarpet(inst)
        return
    end

    -- 4. Décor / Sol / Bases :
    if inst:IsA("BasePart") then
        -- IMPORTANT : Ne jamais modifier la transparence d'une pièce invisible (Hitbox, zones de podiums, etc.)
        if inst.Transparency >= 0.95 then return end

        pcall(function()
            if inst:IsA("MeshPart") then
                inst.RenderFidelity = Enum.RenderFidelity.Performance
            end
            inst.CastShadow = false
            inst.Reflectance = 0
            inst.TopSurface = Enum.SurfaceType.Smooth
            inst.BottomSurface = Enum.SurfaceType.Smooth
            if inst.Material ~= Enum.Material.Neon then
                inst.Material = Enum.Material.SmoothPlastic
            end
            darkenBrightRed(inst)
        end)
    elseif inst:IsA("Decal") or inst:IsA("Texture") then
        -- Ne jamais toucher aux textures/decals sous Plots (évite les gros blocs gris sur les podiums/emplacements)
        if isUnderPlots(inst) then return end
        -- Masquer uniquement les textures répétitives du sol/map (Grass, Studs, etc.)
        pcall(function() inst.Transparency = 1 end)
    end
end

-- Arrêt de toutes les animations (Brainrots et joueurs) sans casser l'affichage en main
local animationConnections = {}
local function stopAnimator(animator)
    if not animator or not animator:IsA("Animator") then return end
    pcall(function()
        for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
            t:Stop(0)
        end
    end)
    animationConnections[#animationConnections + 1] = animator.AnimationPlayed:Connect(function(t)
        task.defer(function()
            pcall(function() t:Stop(0) end)
        end)
    end)
end

local function disableAnimations(inst)
    if not inst then return end
    if inst:IsA("Animator") then
        stopAnimator(inst)
    elseif inst:IsA("AnimationController") then
        pcall(function()
            local a = inst:FindFirstChildOfClass("Animator")
            if a then stopAnimator(a) end
        end)
    elseif (inst:IsA("LocalScript") or inst:IsA("Script")) and string.lower(inst.Name) == "animate" then
        pcall(function() inst.Disabled = true end)
    end
end

-- Éclairage calibré : sombre mais bien lisible, ciel uni sans nuages (0 FPS perdus)
local function applyLightingAndSky()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.ShadowSoftness = 0
        Lighting.Brightness = 1.08
        Lighting.ExposureCompensation = -0.05
        Lighting.FogEnd = 100000
    end)

    -- Remplacement du ciel bleu/blanc par un ciel uni sans textures ni nuages
    for _, ch in ipairs(Lighting:GetChildren()) do
        if ch:IsA("Sky") and ch.Name ~= "__SXE_CleanSky" then
            pcall(function() ch:Destroy() end)
        elseif ch:IsA("Atmosphere") or ch:IsA("Clouds") or ch:IsA("SunRaysEffect") then
            pcall(function() ch:Destroy() end)
        end
    end
    if not Lighting:FindFirstChild("__SXE_CleanSky") then
        local sky = Instance.new("Sky")
        sky.Name = "__SXE_CleanSky"
        sky.SkyboxBk = ""
        sky.SkyboxDn = ""
        sky.SkyboxFt = ""
        sky.SkyboxLf = ""
        sky.SkyboxRt = ""
        sky.SkyboxUp = ""
        sky.CelestialBodiesShown = false
        sky.StarCount = 0
        sky.Parent = Lighting
    end

    local cc = Lighting:FindFirstChild("__SXE_DimScreen")
    if not cc then
        cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "__SXE_DimScreen"
        cc.Parent = Lighting
    end
    cc.Enabled = true
    cc.Brightness = -0.04
    cc.Contrast = 0.02
    cc.Saturation = -0.22
    cc.TintColor = Color3.fromRGB(245, 245, 248)

    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        pcall(function()
            terrain.Decoration = false
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 1
            local clouds = terrain:FindFirstChildOfClass("Clouds")
            if clouds then clouds:Destroy() end
        end)
    end
end

applyLightingAndSky()

-- Blocage complet des effets d'écran (Boogie Down, abeilles, flashs, tremblements)
local FX_KEYWORDS = {
    "boogie", "bee", "honey", "sting", "swarm", "disco", "dance",
    "blur", "flash", "blind", "stun", "ink", "slime", "mud",
    "vignette", "overlay", "distortion", "drunk", "dizzy", "shock"
}

local function isScreenFxGui(inst)
    if not inst then return false end
    local l = string.lower(inst.Name)
    for _, kw in ipairs(FX_KEYWORDS) do
        if string.find(l, kw, 1, true) then
            return true
        end
    end
    return false
end

local function blockPostEffect(x)
    if not x or x.Name == "__SXE_DimScreen" then return end
    if x:IsA("BlurEffect") or x:IsA("ColorCorrectionEffect") or x:IsA("BloomEffect")
        or x:IsA("DepthOfFieldEffect") or x:IsA("SunRaysEffect") then
        pcall(function()
            x.Enabled = false
            x:Destroy()
        end)
    end
end

Lighting.ChildAdded:Connect(function(ch)
    if ch:IsA("Sky") and ch.Name ~= "__SXE_CleanSky" then
        pcall(function() ch:Destroy() end)
    elseif ch:IsA("Atmosphere") or ch:IsA("Clouds") then
        pcall(function() ch:Destroy() end)
    else
        blockPostEffect(ch)
    end
end)

local function hookCamera(cam)
    if not cam then return end
    for _, ch in ipairs(cam:GetChildren()) do blockPostEffect(ch) end
    cam.ChildAdded:Connect(blockPostEffect)
end
hookCamera(Workspace.CurrentCamera)
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    hookCamera(Workspace.CurrentCamera)
end)

local function hookPlayerGui()
    local lp = Players.LocalPlayer
    if not lp then return end
    local pg = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui", 10)
    if not pg then return end
    for _, d in ipairs(pg:GetDescendants()) do
        if isScreenFxGui(d) and (d:IsA("ScreenGui") or d:IsA("Frame") or d:IsA("ImageLabel")) then
            pcall(function() d.Visible = false end)
            if d:IsA("ScreenGui") then pcall(function() d.Enabled = false end) end
        end
    end
    pg.DescendantAdded:Connect(function(d)
        if isScreenFxGui(d) then
            pcall(function()
                if d:IsA("ScreenGui") then d.Enabled = false end
                if d:IsA("GuiObject") then d.Visible = false end
            end)
        end
    end)
end
task.spawn(hookPlayerGui)

-- Anti-tremblement caméra & anti-zoom forcé
RunService.RenderStepped:Connect(function()
    local lp = Players.LocalPlayer
    local char = lp and lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.CameraOffset ~= Vector3.zero then
        hum.CameraOffset = Vector3.zero
    end
    local cam = Workspace.CurrentCamera
    if cam and cam.FieldOfView ~= 70 then
        cam.FieldOfView = 70
    end
end)

-- Suppression des taches / plaques décoratives grises sur les emplacements de Brainrots (podiums)
local function near(a, b)
    return math.abs(a - b) < 0.25
end

local function isGraySpotPlate(d)
    if not (d and d:IsA("BasePart")) then return false end
    if isBrainrotModel(d) then return false end
    if d.Name == "Spawn" or d.Name == "structure base home" or d.Name == "Base" or d.Name == "Floor" then
        return false
    end
    -- Plaques / socles décoratifs carrés ou plats sur les emplacements de Brainrots (4x1x4, 2x0.5x2, 6x0.2x6, 4x0.2x4, etc.)
    local s = d.Size
    if not d.CanCollide and s.Y <= 1.2 and s.X <= 8 and s.Z <= 8 then
        return true
    end
    if near(s.X, 4) and near(s.Y, 1) and near(s.Z, 4) then return true end
    if near(s.X, 2) and near(s.Y, 0.5) and near(s.Z, 2) then return true end
    if near(s.X, 6) and near(s.Y, 0.2) and near(s.Z, 6) then return true end
    if near(s.X, 4) and near(s.Y, 0.2) and near(s.Z, 4) then return true end
    return false
end

local function cleanPodiumGrayBlobs(plot)
    if not (plot and plot.Parent) then return end
    local pods = plot:FindFirstChild("AnimalPodiums")
    if pods then
        for _, d in ipairs(pods:GetDescendants()) do
            if isGraySpotPlate(d) then
                pcall(function() d:Destroy() end)
            end
        end
    end
    local dec = plot:FindFirstChild("Decorations")
    if dec then
        for _, d in ipairs(dec:GetDescendants()) do
            if isGraySpotPlate(d) then
                pcall(function() d:Destroy() end)
            end
        end
    end
end

-- Balayage initial rapide en file d'attente
for _, inst in ipairs(Workspace:GetDescendants()) do
    enqueue(function()
        permanentStrip(inst)
        disableAnimations(inst)
    end)
end

Workspace.DescendantAdded:Connect(function(inst)
    -- Traitement immédiat pour les Brainrots portés en main, les joueurs et les effets
    if isBrainrotModel(inst) then
        if inst:IsA("BasePart") and inst.Transparency < 0.95 then
            toneDownBrainrotPart(inst)
        end
        disableAnimations(inst)
        return
    end
    local char = getAncestorCharacter(inst)
    if char or isCarpetInstance(inst) then
        applyBlackToPlayerOrCarpet(inst)
        disableAnimations(inst)
        return
    end
    if isUnderPlots(inst) and isGraySpotPlate(inst) then
        pcall(function() inst:Destroy() end)
        return
    end
    enqueue(function()
        permanentStrip(inst)
        disableAnimations(inst)
    end)
end)

-- Surveillance des bases (Plots) pour nettoyer les plaques grises sans toucher aux Brainrots
local function setupPlot(plot)
    if not (plot and plot.Parent) then return end
    enqueue(function()
        cleanPodiumGrayBlobs(plot)
    end)
    plot.DescendantAdded:Connect(function(d)
        if isGraySpotPlate(d) then
            pcall(function() d:Destroy() end)
        end
    end)
end

task.spawn(function()
    local plots = Workspace:FindFirstChild("Plots") or Workspace:WaitForChild("Plots", 10)
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
        setupPlot(plot)
    end
    plots.ChildAdded:Connect(setupPlot)
end)

-- Surveillance de tous les joueurs (y compris toi) : avatar + tapis en noir, Brainrot en main visible
local function hookPlayer(plr)
    if not plr then return end
    local function onChar(char)
        if not char then return end
        for _, d in ipairs(char:GetDescendants()) do
            if not isBrainrotModel(d) then
                applyBlackToPlayerOrCarpet(d)
            elseif d:IsA("BasePart") and d.Transparency < 0.95 then
                toneDownBrainrotPart(d)
            end
            disableAnimations(d)
        end
        char.DescendantAdded:Connect(function(d)
            -- Si c'est un Brainrot volé/porté en main : on le garde 100% visible !
            if isBrainrotModel(d) then
                if d:IsA("BasePart") and d.Transparency < 0.95 then
                    toneDownBrainrotPart(d)
                end
                disableAnimations(d)
                return
            end
            applyBlackToPlayerOrCarpet(d)
            disableAnimations(d)
        end)
    end
    if plr.Character then onChar(plr.Character) end
    plr.CharacterAdded:Connect(onChar)
end

for _, plr in ipairs(Players:GetPlayers()) do
    hookPlayer(plr)
end
Players.PlayerAdded:Connect(hookPlayer)

-- Conservation explicite de tous les contrôleurs essentiels (vol, portage, boutiques, roues)
do
    local KEEP = {
        CustomProximityPromptController = true,
        InteractController = true,
        PlotController = true,
        AnimalController = true,
        PetController = true,
        WorldBrainrotController = true,
        EquipBrainrotsController = true,
        EquipBrainrotsRenderController = true,
        SelectBrainrotsController = true,
        BrainrotPreloadingController = true,
        AssetStreamController = true,
        AdminPanelController = true,
        NotificationController = true,
        ShopController = true,
        SpinWheelController = true,
        StealController = true,
        CarryController = true,
        HoldController = true,
        ToolController = true,
    }
    local function wrap(fn)
        return newcclosure and newcclosure(fn) or fn
    end
    local oldNc
    local undone = false
    pcall(function()
        oldNc = hookmetamethod(game, "__namecall", wrap(function(self, ...)
            if not undone then
                local method = getnamecallmethod()
                if type(method) == "string" and string.lower(method) == "getchildren"
                    and typeof(self) == "Instance" and self.Name == "Controllers" and self.Parent == ReplicatedStorage then
                    local ok, s = pcall(getcallingscript)
                    if ok and s and s.Name == "ClientLoader" then
                        local kids = oldNc(self, ...)
                        if type(kids) == "table" then
                            local out = {}
                            for i = 1, #kids do
                                if kids[i] and KEEP[kids[i].Name] then
                                    out[#out + 1] = kids[i]
                                end
                            end
                            return out
                        end
                    end
                end
            end
            return oldNc(self, ...)
        end))
    end)
    task.delay(6, function()
        undone = true
        pcall(function()
            if oldNc then hookmetamethod(game, "__namecall", oldNc) end
        end)
    end)
end

-- Initialisation des variables globales de compatibilité
_G.SXE_PrioSet = _G.SXE_PrioSet or {}
_G.SXE_NukePlotPodiums = function() end
_G.SXE_StripNonPrioPodiums = function() end
_G.SXE_StripNoPrioPlots = function() end
_G.SXE_LockPrioPlot = function() end