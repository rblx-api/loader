local CoreGui = game:GetService("CoreGui")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TARGET_FPS = 2000

-- 1. APPLICATION IMMÉDIATE DES FFLAGS & QUALITÉ GRAPHIQUE
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
    ["FFlagDebugSkyGray"] = "True",
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
    if setFF then
        for flag, value in pairs(FFlags) do pcall(setFF, flag, value) end
    end
    local setCap = findGlobalFunction("setfpscap")
    if setCap then setCap(TARGET_FPS) end
    local rs = settings():GetService("RenderSettings")
    rs.QualityLevel = Enum.QualityLevel.Level01
    rs.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
end)

-- 2. CIEL 100 % GRIS UNI ULTRA-LÉGER (SANS ATMOSPHERE POUR ÉVITER LE CRASH/LAG)
local GRAY_SKY_COLOR = Color3.fromRGB(115, 118, 124)

local function applyGraySkyAndLighting()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.ShadowSoftness = 0
        Lighting.Brightness = 1.15
        Lighting.ExposureCompensation = 0
        Lighting.Ambient = Color3.fromRGB(150, 150, 155)
        Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 155)
        Lighting.ColorShift_Top = GRAY_SKY_COLOR
        Lighting.ColorShift_Bottom = GRAY_SKY_COLOR
        Lighting.FogColor = GRAY_SKY_COLOR
        Lighting.FogStart = 600
        Lighting.FogEnd = 820
    end)

    for _, ch in ipairs(Lighting:GetChildren()) do
        if ch:IsA("Sky") and ch.Name ~= "__SXE_GraySky" then
            pcall(function() ch:Destroy() end)
        elseif ch:IsA("Atmosphere") or ch:IsA("Clouds") or ch:IsA("SunRaysEffect") then
            pcall(function() ch:Destroy() end)
        end
    end

    if not Lighting:FindFirstChild("__SXE_GraySky") then
        local sky = Instance.new("Sky")
        sky.Name = "__SXE_GraySky"
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

applyGraySkyAndLighting()

-- 3. FILE D'ATTENTE ANTI-CRASH & TAMPON LÉGER POUR LES BASES (Plots)
local taskQueue = {}
local qHead, qTail = 1, 0
local function enqueue(fn)
    qTail += 1
    taskQueue[qTail] = fn
end

local bufferedInsts = {}
local bCount = 0
local flushScheduled = false
local permanentStrip
local disableAnimations

local function flushBuffered()
    flushScheduled = false
    if bCount == 0 then return end
    local batch = bufferedInsts
    local total = bCount
    bufferedInsts = {}
    bCount = 0

    for i = 1, total, 35 do
        enqueue(function()
            local limit = math.min(i + 34, total)
            for j = i, limit do
                local inst = batch[j]
                if inst and inst.Parent then
                    permanentStrip(inst)
                    disableAnimations(inst)
                end
            end
        end)
    end
end

local function queueBuffered(inst)
    bCount += 1
    bufferedInsts[bCount] = inst
    if not flushScheduled then
        flushScheduled = true
        task.delay(0.12, flushBuffered)
    end
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
    -- Budget strict de 2.5 ms/frame : 0 freeze et 0 crash mémoire même quand 8 bases apparaissent
    while qHead <= qTail and (os.clock() - start) < 0.0025 do
        local fn = taskQueue[qHead]
        taskQueue[qHead] = nil
        qHead += 1
        if fn then pcall(fn) end
    end
end)

-- 4. HELPERS D'IDENTIFICATION ULTRA-RAPIDES (Brainrots vs Joueurs vs Tapis)
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
    for _ = 1, 6 do
        if not x or x == Workspace then break end
        if isCarpetName(x.Name) then return true end
        x = x.Parent
    end
    return false
end

local function isUnderPlots(inst)
    local x = inst and inst.Parent
    for _ = 1, 10 do
        if not x then break end
        if x.Name == "Plots" and x.Parent == Workspace then return true end
        if x == Workspace then break end
        x = x.Parent
    end
    return false
end

-- Uniquement les vrais joueurs (évite de confondre les Brainrots qui ont un Humanoid !)
local function isPlayerCharacterModel(m)
    if not (m and m:IsA("Model")) then return false end
    return Players:GetPlayerFromCharacter(m) ~= nil
end

local function getAncestorPlayerCharacter(inst)
    local x = inst
    for _ = 1, 8 do
        if not x or x == Workspace then break end
        if isPlayerCharacterModel(x) then return x end
        x = x.Parent
    end
    return nil
end

-- Cache léger pour éviter de recalculer isBrainrotModel des milliers de fois
local brainrotCache = setmetatable({}, { __mode = "k" })

local function isBrainrotModel(inst)
    if not inst then return false end
    local m = inst:IsA("Model") and inst or inst:FindFirstAncestorOfClass("Model")
    if not m or isPlayerCharacterModel(m) then return false end

    local cached = brainrotCache[m]
    if cached ~= nil then return cached end

    if isCarpetInstance(m) then
        brainrotCache[m] = false
        return false
    end

    -- 1. Brainrot sur le tapis roulant ou dans une base (Plots)
    local p = m.Parent
    if p and (p.Name == "RenderedMovingAnimals" or (p.Parent and p.Parent.Name == "Plots")) then
        if m:FindFirstChild("FakeRootPart") or m:FindFirstChild("RootPart")
            or m:FindFirstChildWhichIsA("AnimationController", true)
            or m:FindFirstChildWhichIsA("MeshPart", true)
            or m:FindFirstChildOfClass("Humanoid") then
            brainrotCache[m] = true
            return true
        end
    end

    -- 2. Brainrot porté en main par un joueur
    local char = getAncestorPlayerCharacter(m)
    if char and not BODY_PART[m.Name] then
        brainrotCache[m] = true
        return true
    end

    -- 3. Présence explicite des racines de Brainrot
    if m:FindFirstChild("FakeRootPart") or m:FindFirstChild("RootPart") then
        brainrotCache[m] = true
        return true
    end

    -- Vérification légère de soudure uniquement hors Plots
    if not isUnderPlots(m) then
        local root = m
        while root and root.Parent and root.Parent ~= Workspace do
            if isPlayerCharacterModel(root.Parent) then
                brainrotCache[m] = true
                return true
            end
            root = root.Parent
        end
    end

    brainrotCache[m] = false
    return false
end

-- 5. OPTIMISATION VISUELLE (Brainrots bien visibles, joueurs en noir, fluos assombris)
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
        if s > 0.65 or v > 0.88 then
            part.Color = Color3.fromHSV(h, math.min(s, 0.58), math.min(v, 0.85))
        end
    end)
end

local function darkenFluoColor(part)
    if not (part and part:IsA("BasePart")) then return end
    local wasNeon = (part.Material == Enum.Material.Neon)
    if wasNeon then
        part.Material = Enum.Material.SmoothPlastic
    end
    local c = part.Color
    local h, s, v = c:ToHSV()
    if wasNeon or (s > 0.45 and v > 0.52) then
        part.Color = Color3.fromHSV(h, math.min(s, 0.55), math.min(v * 0.46, 0.42))
    end
end

local PLAYER_BLACK = Color3.fromRGB(22, 22, 25)
local function applyBlackToPlayerOrCarpet(inst)
    if not inst then return end
    if isBrainrotModel(inst) then
        if inst:IsA("BasePart") and inst.Transparency < 0.95 then
            toneDownBrainrotPart(inst)
        end
        return
    end
    if inst:IsA("BasePart") then
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
        if isCarpetInstance(inst) or inst.Name ~= "face" then
            pcall(function() inst.Transparency = 1 end)
        end
    elseif inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") or inst:IsA("PointLight") then
        pcall(function() inst.Enabled = false end)
    end
end

permanentStrip = function(inst)
    if not inst or not inst.Parent then return end

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

    if isBrainrotModel(inst) then
        if inst:IsA("BasePart") and inst.Transparency < 0.95 then
            toneDownBrainrotPart(inst)
        end
        return
    end

    local char = getAncestorPlayerCharacter(inst)
    if char or isCarpetInstance(inst) then
        applyBlackToPlayerOrCarpet(inst)
        return
    end

    if inst:IsA("BasePart") then
        if inst.Transparency >= 0.95 then return end
        pcall(function()
            if inst:IsA("MeshPart") then
                inst.RenderFidelity = Enum.RenderFidelity.Performance
            end
            inst.CastShadow = false
            inst.Reflectance = 0
            inst.TopSurface = Enum.SurfaceType.Smooth
            inst.BottomSurface = Enum.SurfaceType.Smooth
            inst.Material = Enum.Material.SmoothPlastic
            darkenFluoColor(inst)
        end)
    elseif inst:IsA("Decal") or inst:IsA("Texture") then
        if isUnderPlots(inst) then return end
        pcall(function() inst.Transparency = 1 end)
    end
end

-- 6. ARRÊT DES ANIMATIONS (SANS CONNEXIONS PERMANENTES LOURDES)
local function stopAnimator(animator)
    if not animator or not animator:IsA("Animator") then return end
    pcall(function()
        for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
            t:Stop(0)
        end
    end)
    local conn
    conn = animator.AnimationPlayed:Connect(function(t)
        pcall(function() t:Stop(0) end)
    end)
    animator.Destroying:Once(function()
        if conn then conn:Disconnect() end
    end)
end

disableAnimations = function(inst)
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

-- 7. BLOCAGE DES EFFETS D'ÉCRAN & POST-PROCESSING
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
    if not x then return end
    if x:IsA("BlurEffect") or x:IsA("ColorCorrectionEffect") or x:IsA("BloomEffect")
        or x:IsA("DepthOfFieldEffect") or x:IsA("SunRaysEffect") then
        pcall(function()
            x.Enabled = false
            x:Destroy()
        end)
    end
end

for _, ch in ipairs(Lighting:GetChildren()) do
    blockPostEffect(ch)
end

Lighting.ChildAdded:Connect(function(ch)
    if ch:IsA("Sky") and ch.Name ~= "__SXE_GraySky" then
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

-- 8. NETTOYAGE RAPIDE DES PODIUMS & BALAYAGE INITIAL PAR PAQUETS LÉGERS
local function near(a, b)
    return math.abs(a - b) < 0.25
end

local function isGraySpotPlate(d)
    if not (d and d:IsA("BasePart")) then return false end
    if isBrainrotModel(d) then return false end
    if d.Name == "Spawn" or d.Name == "structure base home" or d.Name == "Base" or d.Name == "Floor" then
        return false
    end
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
    for _, folderName in ipairs({"AnimalPodiums", "Decorations"}) do
        local folder = plot:FindFirstChild(folderName)
        if folder then
            for _, d in ipairs(folder:GetDescendants()) do
                if isGraySpotPlate(d) then
                    enqueue(function()
                        if d and d.Parent then pcall(function() d:Destroy() end) end
                    end)
                end
            end
        end
    end
end

-- Balayage initial découpé en petits paquets de 50 objets (0 lag, 0 crash au lancement)
task.spawn(function()
    local descendants = Workspace:GetDescendants()
    for i = 1, #descendants, 50 do
        enqueue(function()
            local limit = math.min(i + 49, #descendants)
            for j = i, limit do
                local inst = descendants[j]
                if inst and inst.Parent then
                    permanentStrip(inst)
                    disableAnimations(inst)
                end
            end
        end)
    end
end)

Workspace.DescendantAdded:Connect(function(inst)
    if isUnderPlots(inst) then
        if isGraySpotPlate(inst) then
            pcall(function() inst:Destroy() end)
            return
        end
        queueBuffered(inst)
        return
    end
    if isBrainrotModel(inst) then
        if inst:IsA("BasePart") and inst.Transparency < 0.95 then
            toneDownBrainrotPart(inst)
        end
        disableAnimations(inst)
        return
    end
    local char = getAncestorPlayerCharacter(inst)
    if char or isCarpetInstance(inst) then
        applyBlackToPlayerOrCarpet(inst)
        disableAnimations(inst)
        return
    end
    queueBuffered(inst)
end)

-- Surveillance des bases (Plots)
local function setupPlot(plot)
    if not (plot and plot.Parent) then return end
    enqueue(function()
        cleanPodiumGrayBlobs(plot)
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

-- Surveillance de tous les joueurs
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

-- 9. CONSERVATION DES CONTRÔLEURS ESSENTIELS
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

_G.SXE_PrioSet = _G.SXE_PrioSet or {}
_G.SXE_NukePlotPodiums = function() end
_G.SXE_StripNonPrioPodiums = function() end
_G.SXE_StripNoPrioPlots = function() end
_G.SXE_LockPrioPlot = function() end