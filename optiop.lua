local CoreGui = game:GetService("CoreGui")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

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
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
end)

local function isPetModel(inst)
    if not inst or not inst:IsA("Model") then return false end
    return inst:FindFirstChild("FakeRootPart") ~= nil
        or inst:FindFirstChild("RootPart") ~= nil
        or inst:FindFirstChildWhichIsA("AnimationController", true) ~= nil
end

local function isUnderPlots(inst)
    local x = inst and inst.Parent
    for _ = 1, 20 do
        if not x then break end
        if x.Name == "Plots" and x.Parent == workspace then return true end
        if x == workspace then break end
        x = x.Parent
    end
    return false
end

local function isBrainrotOrCharacter(inst)
    if not inst then return false end
    local lp = Players.LocalPlayer
    local char = lp and lp.Character
    if char and (inst == char or inst:IsDescendantOf(char)) then
        return true
    end
    local x = inst
    for _ = 1, 18 do
        if not x or x == workspace then break end
        if x:IsA("Model") then
            if isPetModel(x) or Players:GetPlayerFromCharacter(x) ~= nil then
                return true
            end
            local low = string.lower(x.Name)
            if string.find(low, "brainrot", 1, true) or string.find(low, "animal", 1, true) or string.find(low, "pet", 1, true) then
                return true
            end
        end
        if x.Name == "RenderedMovingAnimals" then
            return true
        end
        x = x.Parent
    end
    return false
end

local DARK_RED = Color3.fromRGB(95, 18, 18)

local function darkenBrightRed(part)
    if not part or not part:IsA("BasePart") then return end
    if isBrainrotOrCharacter(part) then return end
    pcall(function()
        local c = part.Color
        if c.R > 0.62 and c.G < 0.35 and c.B < 0.35 then
            part.Color = DARK_RED
        end
        if part.Material == Enum.Material.Neon then
            part.Material = Enum.Material.SmoothPlastic
        end
    end)
end

local function budgetedSweep(roots, callback)
    task.spawn(function()
        for _, root in ipairs(roots) do
            local ok, desc = pcall(function() return root:GetDescendants() end)
            if ok then
                local idx, count = 1, #desc
                while idx <= count do
                    local fs = os.clock()
                    while idx <= count and os.clock() - fs < 0.0015 do
                        pcall(callback, desc[idx])
                        idx += 1
                    end
                    RunService.Heartbeat:Wait()
                end
            end
        end
    end)
end

local function permanentStrip(inst)
    if not inst or not inst.Parent then return end
    if isBrainrotOrCharacter(inst) then
        if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Smoke")
            or inst:IsA("Fire") or inst:IsA("Sparkles") or inst:IsA("Beam") then
            inst.Enabled = false
        end
        return
    end

    if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Smoke")
        or inst:IsA("Fire") or inst:IsA("Sparkles") or inst:IsA("Beam") then
        inst.Enabled = false
    elseif inst:IsA("PointLight") or inst:IsA("SpotLight") or inst:IsA("SurfaceLight") then
        inst.Enabled = false
    elseif inst:IsA("PostEffect") then
        if inst.Name ~= "__SXE_DimScreen" then
            inst.Enabled = false
            pcall(function() inst:Destroy() end)
        end
    elseif inst:IsA("Explosion") then
        inst.Visible = false
    elseif inst:IsA("Decal") or inst:IsA("Texture") then
        if not isUnderPlots(inst) then
            inst.Transparency = 1
        end
    elseif inst:IsA("MeshPart") then
        pcall(function()
            inst.RenderFidelity = Enum.RenderFidelity.Performance
            inst.CastShadow = false
            inst.Reflectance = 0
            inst.Material = Enum.Material.SmoothPlastic
            inst.TextureID = ""
        end)
        darkenBrightRed(inst)
    elseif inst:IsA("BasePart") then
        pcall(function()
            inst.CastShadow = false
            inst.Reflectance = 0
            inst.Material = Enum.Material.SmoothPlastic
            inst.TopSurface = Enum.SurfaceType.Smooth
            inst.BottomSurface = Enum.SurfaceType.Smooth
        end)
        darkenBrightRed(inst)
    end
end

local animationConnections = {}
local function stopAnimator(animator)
    if not animator or not animator:IsA("Animator") then return end
    if isBrainrotOrCharacter(animator) then return end
    pcall(function()
        for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
            t:Stop(0)
            pcall(function() t:Destroy() end)
        end
    end)
    animationConnections[#animationConnections+1] = animator.AnimationPlayed:Connect(function(t)
        task.defer(function() pcall(function() t:Stop(0); t:Destroy() end) end)
    end)
end

local function disableAnimations(inst)
    if not inst or isBrainrotOrCharacter(inst) then return end
    if inst:IsA("Animator") then
        stopAnimator(inst)
    elseif inst:IsA("AnimationController") then
        pcall(function()
            local a = inst:FindFirstChildOfClass("Animator")
            if a then stopAnimator(a) end
        end)
    end
end

budgetedSweep({Workspace, Players}, disableAnimations)
animationConnections[#animationConnections+1] = Workspace.DescendantAdded:Connect(function(i)
    pcall(disableAnimations, i)
end)

-- Eclairage légèrement assombri + ciel uni ultra-léger
local function applyLightingAndSky()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.ShadowSoftness = 0
        Lighting.Brightness = 1.15
        Lighting.ExposureCompensation = -0.10
        Lighting.FogEnd = 100000
    end)
    for _, ch in ipairs(Lighting:GetChildren()) do
        if ch:IsA("Sky") and ch.Name ~= "__SXE_LightSky" then
            pcall(function() ch:Destroy() end)
        elseif ch:IsA("Atmosphere") or ch:IsA("Clouds") then
            pcall(function() ch:Destroy() end)
        elseif ch:IsA("PostEffect") and ch.Name ~= "__SXE_DimScreen" then
            pcall(function() ch:Destroy() end)
        end
    end
    if not Lighting:FindFirstChild("__SXE_LightSky") then
        local sky = Instance.new("Sky")
        sky.Name = "__SXE_LightSky"
        sky.SkyboxBk = ""
        sky.SkyboxDn = ""
        sky.SkyboxFt = ""
        sky.SkyboxLf = ""
        sky.SkyboxRt = ""
        sky.SkyboxUp = ""
        sky.SunAngularSize = 0
        sky.MoonAngularSize = 0
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
    cc.Brightness = -0.03
    cc.Contrast = 0.02
    cc.Saturation = -0.18
end

applyLightingAndSky()

pcall(function()
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        terrain.Decoration = false
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 1
        local clouds = terrain:FindFirstChildOfClass("Clouds")
        if clouds then clouds:Destroy() end
    end
end)

-- File d'attente anti-lag quand un joueur rejoint ou qu'une base apparaît
local pendingQueue = {}
local function enqueueStrip(inst)
    if inst and inst.Parent then
        pendingQueue[#pendingQueue + 1] = inst
    end
end

task.spawn(function()
    while true do
        if #pendingQueue > 0 then
            local start = os.clock()
            while #pendingQueue > 0 and (os.clock() - start) < 0.0015 do
                local inst = table.remove(pendingQueue)
                if inst and inst.Parent then
                    pcall(permanentStrip, inst)
                end
            end
        end
        RunService.Heartbeat:Wait()
    end
end)

budgetedSweep({Workspace, Lighting}, permanentStrip)

local permanentConnections = {}
permanentConnections[#permanentConnections+1] = Workspace.DescendantAdded:Connect(function(inst)
    enqueueStrip(inst)
end)
permanentConnections[#permanentConnections+1] = Lighting.ChildAdded:Connect(function(inst)
    if inst.Name ~= "__SXE_DimScreen" and inst.Name ~= "__SXE_LightSky" then
        if inst:IsA("PostEffect") or inst:IsA("Atmosphere") or inst:IsA("Clouds") or inst:IsA("Sky") then
            task.defer(function() pcall(function() inst:Destroy() end) end)
        end
    end
end)

-- Blocage complet des effets d'écran (Boogie Down, abeilles, flashs, tremblements)
local BAD_GUI_WORDS = {
    "boogie", "bee", "honey", "sting", "disco", "blur", "flash",
    "blind", "stun", "vignette", "overlay", "dizzy", "shake", "screenfx"
}

local function isBadScreenGui(gui)
    if not gui then return false end
    local low = string.lower(gui.Name)
    for _, w in ipairs(BAD_GUI_WORDS) do
        if string.find(low, w, 1, true) then
            return true
        end
    end
    return false
end

local function hookPlayerAntiFx(lp)
    if not lp then return end
    local pg = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui", 10)
    if pg then
        for _, ch in ipairs(pg:GetChildren()) do
            if isBadScreenGui(ch) then
                pcall(function() ch:Destroy() end)
            end
        end
        pg.ChildAdded:Connect(function(ch)
            if isBadScreenGui(ch) then
                task.defer(function() pcall(function() ch:Destroy() end) end)
            end
        end)
    end

    local function protectCharacter(char)
        if not char then return end
        -- Garder les animations du joueur intactes pour voir le Brainrot en main
        local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 10)
        if hum then
            hum:GetPropertyChangedSignal("CameraOffset"):Connect(function()
                if hum.CameraOffset ~= Vector3.zero then
                    hum.CameraOffset = Vector3.zero
                end
            end)
        end
        -- Nettoyer uniquement les particules/abeilles collées au joueur sans toucher aux Brainrots portés
        char.DescendantAdded:Connect(function(d)
            if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke")
                or d:IsA("Fire") or d:IsA("Sparkles") or d:IsA("Beam") then
                d.Enabled = false
            end
        end)
    end

    if lp.Character then protectCharacter(lp.Character) end
    lp.CharacterAdded:Connect(protectCharacter)
end

task.spawn(function()
    local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
    hookPlayerAntiFx(lp)
end)

RunService.RenderStepped:Connect(function()
    local cam = Workspace.CurrentCamera
    if cam then
        for _, ch in ipairs(cam:GetChildren()) do
            if ch:IsA("PostEffect") then
                pcall(function() ch:Destroy() end)
            end
        end
        if cam.FieldOfView > 85 or cam.FieldOfView < 65 then
            cam.FieldOfView = 70
        end
    end
end)

_G.reyy_LoadOptStop = function()
    for _, c in ipairs(permanentConnections) do if c and c.Connected then c:Disconnect() end end
    for _, c in ipairs(animationConnections) do if c and c.Connected then c:Disconnect() end end
    table.clear(permanentConnections)
    table.clear(animationConnections)
end

-- Conservation des contrôleurs du jeu (boutiques, roues, vol et portage de Brainrots)
task.spawn(function()
    local _okOPT, _errOPT = pcall(function()
        _G.__SXE_KillQ = {}
        _G.SXE_PrioSet = {}

        local RS = game:GetService("ReplicatedStorage")
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
            if newcclosure then return newcclosure(fn) end
            return fn
        end
        local function isCtrlFolder(x)
            return typeof(x) == "Instance" and x.Name == "Controllers" and x.Parent == RS
        end
        local function callerName()
            if not getcallingscript then return "?" end
            local ok, s = pcall(getcallingscript)
            if not ok or s == nil then return "nil" end
            return tostring(s.Name)
        end
        local function fromLoader()
            return callerName() == "ClientLoader"
        end
        local function filt(kids)
            if type(kids) ~= "table" then return kids end
            local out = {}
            for i = 1, #kids do
                local k = kids[i]
                if k and KEEP[k.Name] then
                    out[#out + 1] = k
                end
            end
            return out
        end

        local oldNc
        local undone = false
        local function unhook()
            if undone then return end
            undone = true
            pcall(function()
                if oldNc then hookmetamethod(game, "__namecall", oldNc) end
            end)
        end
        pcall(function()
            oldNc = hookmetamethod(game, "__namecall", wrap(function(self, ...)
                local method = getnamecallmethod()
                if type(method) ~= "string" or string.lower(method) ~= "getchildren" then
                    return oldNc(self, ...)
                end
                if not isCtrlFolder(self) or not fromLoader() then
                    return oldNc(self, ...)
                end
                return filt(oldNc(self, ...))
            end))
        end)
        task.delay(6, unhook)

        local WS_KILL = {
            InvisibleWalls = true,
            AdminBoard = true,
            SoccerScoreBoard = true,
            EventBoard = true,
            Present = true,
            StPatricksPot = true,
            RoadPanel = true,
            Honey = true,
            Trap = true,
            Events = true,
            Sounds = true,
            Dev = true,
            ToolsAdds = true,
            __PROJECTILES = true,
            UFO = true,
        }

        local function cleanWorkspaceItem(ch)
            if not ch or not ch.Parent then return end
            if isBrainrotOrCharacter(ch) then return end
            local n = ch.Name
            if WS_KILL[n] or ch.ClassName == "Highlight" then
                pcall(function() ch:Destroy() end)
                return
            end
            if string.sub(n, 1, 7) == "BeeHive" or string.sub(n, 1, 7) == "Sentry_" then
                pcall(function() ch:Destroy() end)
                return
            end
            if ch:IsA("Model") and string.find(n, "'s Rainbow", 1, true) then
                pcall(function() ch:Destroy() end)
                return
            end
        end

        for _, ch in ipairs(Workspace:GetChildren()) do
            cleanWorkspaceItem(ch)
        end
        Workspace.ChildAdded:Connect(cleanWorkspaceItem)

        _G.SXE_NukePlotPodiums = function() end
        _G.SXE_StripNonPrioPodiums = function() end
        _G.SXE_StripNoPrioPlots = function() end
        _G.SXE_LockPrioPlot = function() end
        _G.__SXE_StripDone = true
    end)
    if not _okOPT then warn("[OPTIMIZER] erreur: " .. tostring(_errOPT)) end
end)