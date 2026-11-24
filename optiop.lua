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
    ["FIntRenderMeshOptimizeVertexCache"] = "1",
    ["FFlagRenderNoLowLodMeshes"] = "False",
    ["FIntRenderTextureCompositorLowResFactor"] = "4",
}

pcall(function()
    local setFF = findGlobalFunction("setfflag")
    if not setFF then return end
    for flag, value in pairs(FFlags) do pcall(setFF, flag, value) end
end)

pcall(function()
    local setCap = findGlobalFunction("setfpscap")
    if setCap then setCap(2000) end
end)

pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
end)

local restoreList = {}
local remembered = setmetatable({}, { __mode = "k" })
local RESTORE_CAP = 25000

local function remember(inst, property, value)
    if not inst or #restoreList >= RESTORE_CAP then return end
    local props = remembered[inst]
    if not props then props = {}; remembered[inst] = props end
    if props[property] then return end
    props[property] = true
    restoreList[#restoreList+1] = {Instance=inst, Property=property, Value=value}
end

local function restoreAll()
    if #restoreList == 0 then return end
    task.spawn(function()
        local idx = 1
        local count = #restoreList
        while idx <= count do
            local fs = os.clock()
            while idx <= count and os.clock()-fs < 0.0015 do
                local e = restoreList[idx]
                pcall(function() if e.Instance and e.Instance.Parent then e.Instance[e.Property] = e.Value end end)
                idx += 1
            end
            RunService.Heartbeat:Wait()
        end
        table.clear(restoreList); table.clear(remembered)
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
                    while idx <= count and os.clock()-fs < 0.0015 do
                        pcall(callback, desc[idx]); idx += 1
                    end
                    RunService.Heartbeat:Wait()
                end
            end
        end
    end)
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

local function isHeldBrainrot(inst)
    local lp = Players.LocalPlayer
    local char = lp and lp.Character
    if not (inst and char) then return false end
    if inst:IsDescendantOf(char) then return true end
    local x = inst
    for _ = 1, 15 do
        if not x or x == workspace then break end
        if x:IsA("Tool") or x:IsA("Accessory") then return true end
        if x:IsA("Model") and x ~= char then
            if x:FindFirstChild("RootPart") or x:FindFirstChild("FakeRootPart")
                or x:FindFirstChildWhichIsA("AnimationController", true) then
                return true
            end
        end
        x = x.Parent
    end
    return false
end

local function permanentStrip(inst)
    if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Smoke")
        or inst:IsA("Fire") or inst:IsA("Sparkles") or inst:IsA("Beam") then
        inst.Enabled = false
    elseif inst:IsA("PostEffect") then
        if inst.Name ~= "__SXE_DimScreen" then
            inst.Enabled = false
        end
    elseif inst:IsA("Explosion") then
        inst.Visible = false
    elseif inst:IsA("Light") then
        inst.Enabled = false
    elseif inst:IsA("MeshPart") then
        pcall(function()
            inst.RenderFidelity = Enum.RenderFidelity.Performance
            inst.CastShadow = false
            inst.Reflectance = 0
            if not isUnderPlots(inst) and not isHeldBrainrot(inst) then
                inst.Material = Enum.Material.SmoothPlastic
            end
        end)
    elseif inst:IsA("BasePart") then
        pcall(function()
            inst.CastShadow = false
            inst.Reflectance = 0
            if not isUnderPlots(inst) and not isHeldBrainrot(inst) then
                inst.Material = Enum.Material.SmoothPlastic
            end
        end)
    end
end

local loadPhase = true

local function harshStrip(inst)
    if not loadPhase then return end
    if inst:IsA("Decal") or inst:IsA("Texture") then
        if isUnderPlots(inst) or isHeldBrainrot(inst) then return end
        if inst.Transparency ~= 1 then remember(inst,"Transparency",inst.Transparency); inst.Transparency = 1 end
    elseif inst:IsA("BillboardGui") or inst:IsA("SurfaceGui") then
        if isUnderPlots(inst) or isHeldBrainrot(inst) then return end
        if inst.Enabled then remember(inst,"Enabled",inst.Enabled); inst.Enabled = false end
    elseif inst:IsA("Sound") then
        if inst.Volume ~= 0 then remember(inst,"Volume",inst.Volume); inst.Volume = 0 end
    end
end

local animationConnections = {}
local function stopAnimator(animator)
    if not animator or not animator:IsA("Animator") then return end
    -- Conserve les animations d'outils / de portage du joueur local pour tenir le brainrot dans les mains
    local lp = Players.LocalPlayer
    if lp and lp.Character and animator:IsDescendantOf(lp.Character) then
        return
    end
    pcall(function() for _, t in ipairs(animator:GetPlayingAnimationTracks()) do t:Stop(0); pcall(function() t:Destroy() end) end end)
    animationConnections[#animationConnections+1] = animator.AnimationPlayed:Connect(function(t)
        task.defer(function() pcall(function() t:Stop(0); t:Destroy() end) end)
    end)
end

local function disableAnimations(inst)
    local lp = Players.LocalPlayer
    if lp and lp.Character and inst:IsDescendantOf(lp.Character) then
        return
    end
    if inst:IsA("Animator") then stopAnimator(inst)
    elseif inst:IsA("AnimationController") then pcall(function() local a=inst:FindFirstChildOfClass("Animator"); if a then stopAnimator(a) end end)
    elseif inst:IsA("Animation") then pcall(function() inst.AnimationId = "" end)
    elseif (inst:IsA("LocalScript") or inst:IsA("Script")) and string.lower(inst.Name) == "animate" then pcall(function() inst.Disabled = true end)
    end
end

budgetedSweep({Workspace, Players}, disableAnimations)
animationConnections[#animationConnections+1] = Workspace.DescendantAdded:Connect(function(i) pcall(disableAnimations,i) end)
animationConnections[#animationConnections+1] = Players.DescendantAdded:Connect(function(i) pcall(disableAnimations,i) end)

-- Assombrissement léger de l'écran et réduction des calculs de lumière
local function applyDimLighting()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.ShadowSoftness = 0
        Lighting.Brightness = 0.35
        Lighting.ExposureCompensation = -0.35
        Lighting.OutdoorAmbient = Color3.fromRGB(55, 55, 65)
        Lighting.Ambient = Color3.fromRGB(45, 45, 55)
        Lighting.FogEnd = 100000
    end)
    local dim = Lighting:FindFirstChild("__SXE_DimScreen")
    if not dim then
        dim = Instance.new("ColorCorrectionEffect")
        dim.Name = "__SXE_DimScreen"
        dim.Parent = Lighting
    end
    dim.Brightness = -0.18
    dim.Contrast = 0.04
    dim.Saturation = -0.05
    dim.TintColor = Color3.fromRGB(220, 225, 235)
    dim.Enabled = true
end
applyDimLighting()

pcall(function()
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        terrain.Decoration = false
        terrain.WaterWaveSize = 0; terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0; terrain.WaterTransparency = 1
        local clouds = terrain:FindFirstChildOfClass("Clouds")
        if clouds then clouds.Enabled = false end
    end
end)

pcall(function()
    local gs = UserSettings():GetService("UserGameSettings")
    remember(gs, "MasterVolume", gs.MasterVolume)
    gs.MasterVolume = 0
end)

budgetedSweep({Workspace, Lighting}, function(inst)
    permanentStrip(inst)
    if loadPhase then harshStrip(inst) end
end)

local permanentConnections = {}
permanentConnections[#permanentConnections+1] = Workspace.DescendantAdded:Connect(function(inst)
    pcall(permanentStrip, inst)
    if loadPhase then pcall(harshStrip, inst) end
end)
permanentConnections[#permanentConnections+1] = Lighting.DescendantAdded:Connect(function(inst) pcall(permanentStrip, inst) end)

local finished = false
local function finishLoadPhase()
    if finished then return end
    finished = true; loadPhase = false
    restoreAll()
end

local function waitForPlayableCharacter()
    local lp = Players.LocalPlayer
    if not lp then Players:GetPropertyChangedSignal("LocalPlayer"):Wait(); lp = Players.LocalPlayer end
    local char = lp.Character or lp.CharacterAdded:Wait()
    char:WaitForChild("Humanoid", 15)
    char:WaitForChild("HumanoidRootPart", 15)
    RunService.RenderStepped:Wait()
    finishLoadPhase()
end

task.spawn(waitForPlayableCharacter)
task.delay(30, finishLoadPhase)

_G.reyy_LoadOptStop = function()
    for _, c in ipairs(permanentConnections) do if c and c.Connected then c:Disconnect() end end
    for _, c in ipairs(animationConnections) do if c and c.Connected then c:Disconnect() end end
    table.clear(permanentConnections); table.clear(animationConnections)
    finishLoadPhase()
end

task.spawn(function()
    local _okOPT, _errOPT = pcall(function()

        _G.__SXE_KillQ = {}

        do
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
                if newcclosure then
                    return newcclosure(fn)
                end
                return fn
            end
            local function isCtrlFolder(x)
                return typeof(x) == "Instance" and x.Name == "Controllers" and x.Parent == RS
            end
            local function callerName()
                if not getcallingscript then
                    return "?"
                end
                local ok, s = pcall(getcallingscript)
                if not ok or s == nil then
                    return "nil"
                end
                return tostring(s.Name)
            end
            local function fromLoader()
                return callerName() == "ClientLoader"
            end
            local function filt(kids)
                if type(kids) ~= "table" then
                    return kids
                end
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
                    if oldNc then
                        hookmetamethod(game, "__namecall", oldNc)
                    end
                end)
            end
            pcall(function()
                oldNc = hookmetamethod(game, "__namecall", wrap(function(self, ...)
                    local method = getnamecallmethod()
                    if type(method) ~= "string" then
                        return oldNc(self, ...)
                    end
                    local ml = string.lower(method)
                    if ml ~= "getchildren" then
                        return oldNc(self, ...)
                    end
                    if not isCtrlFolder(self) then
                        return oldNc(self, ...)
                    end
                    if not fromLoader() then
                        return oldNc(self, ...)
                    end
                    return filt(oldNc(self, ...))
                end))
            end)
            task.delay(6, unhook)
        end

        task.spawn(function()
            local RS = game:GetService("ReplicatedStorage")
            local KILL = {
                RNGMachineVFX = true,
                LuckIcons = true,
                GlossaryBackground = true,
                AnimationGraphEditor = true,
                ML = true,
                PlayWaveEvents = true,
            }
            local function yeet(ch)
                if not ch then return end
                pcall(function()
                    ch:Destroy()
                end)
            end
            local function dropKill(ch)
                if ch and KILL[ch.Name] then yeet(ch) end
            end
            local kids = RS:GetChildren()
            for i = 1, #kids do dropKill(kids[i]) end
            RS.ChildAdded:Connect(dropKill)
        end)

        task.wait()
        local function _sxeBusy()
            return _G.__SXE_VelFlying == true
        end
        function _G.SXE_Kill(inst)
            if not inst then return end
            if _sxeBusy() then
                local q = _G.__SXE_KillQ
                q[#q + 1] = inst
                return
            end
            pcall(function() inst:Destroy() end)
        end
        function _G.SXE_FlushKills()
            local q = _G.__SXE_KillQ
            _G.__SXE_KillQ = {}
            for i = 1, #q do
                local x = q[i]
                if x and x.Parent then pcall(function() x:Destroy() end) end
            end
        end

        -- Blocage complet des effets d'écran (Boogie Down, Abeilles, flashs, flous, secousses)
        local function setupAntiScreenEffects()
            local LP = Players.LocalPlayer
            if not LP then return end

            local FX_KEYWORDS = {
                "boogie", "disco", "bee", "honey", "sting", "swarm",
                "blur", "flash", "blind", "stun", "dizzy", "vfx",
                "screenfx", "overlay", "vignette", "distortion", "static",
                "shake", "glitch", "poison", "slime", "ink", "web",
                "freeze", "ice", "frost", "firefx", "burn", "confuse"
            }

            local function isScreenFxGui(inst)
                if not inst then return false end
                local n = string.lower(inst.Name)
                for _, kw in ipairs(FX_KEYWORDS) do
                    if string.find(n, kw, 1, true) then
                        return true
                    end
                end
                return false
            end

            local function cleanGui(gui)
                if not gui then return end
                if gui:IsA("ScreenGui") and isScreenFxGui(gui) then
                    pcall(function() gui.Enabled = false; gui:Destroy() end)
                    return
                end
                for _, d in ipairs(gui:GetDescendants()) do
                    if (d:IsA("Frame") or d:IsA("ImageLabel") or d:IsA("ViewportFrame")) and isScreenFxGui(d) then
                        pcall(function() d.Visible = false; d:Destroy() end)
                    end
                end
            end

            local function hookPlayerGui(pg)
                if not pg then return end
                for _, ch in ipairs(pg:GetChildren()) do
                    cleanGui(ch)
                end
                pg.ChildAdded:Connect(function(ch)
                    task.defer(function() cleanGui(ch) end)
                end)
                pg.DescendantAdded:Connect(function(d)
                    if isScreenFxGui(d) then
                        task.defer(function()
                            pcall(function()
                                if d:IsA("LayerCollector") then d.Enabled = false end
                                if d:IsA("GuiObject") then d.Visible = false end
                                d:Destroy()
                            end)
                        end)
                    end
                end)
            end

            local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 10)
            if pg then hookPlayerGui(pg) end
            LP.ChildAdded:Connect(function(ch)
                if ch.Name == "PlayerGui" then hookPlayerGui(ch) end
            end)

            -- Maintien de la visibilité du brainrot porté en main et nettoyage des effets parasites sur le joueur
            local function cleanMyCharacter(char)
                if not char then return end
                local function checkDesc(d)
                    if not d then return end
                    local cn = d.ClassName
                    if cn == "ParticleEmitter" or cn == "Trail" or cn == "Beam"
                        or cn == "Smoke" or cn == "Fire" or cn == "Sparkles"
                        or cn == "Highlight" or cn == "PointLight" or cn == "SpotLight" then
                        pcall(function() d.Enabled = false; d:Destroy() end)
                    elseif isScreenFxGui(d) and not d:IsA("BasePart") and not d:IsA("Model") then
                        pcall(function() d:Destroy() end)
                    elseif d:IsA("BasePart") or d:IsA("MeshPart") then
                        -- Assure que les pièces du brainrot porté restent visibles dans les mains
                        local p = d.Parent
                        while p and p ~= char do
                            if p:IsA("Tool") or p:IsA("Accessory") or p:IsA("Model") then
                                if d.Name ~= "HumanoidRootPart" and d.Name ~= "Hitbox" and d.Name ~= "FakeRootPart" and d.Name ~= "RootPart" then
                                    if d.Transparency == 1 and (p:FindFirstChild("FakeRootPart") or p:FindFirstChild("RootPart") or p:IsA("Tool")) then
                                        pcall(function() d.Transparency = 0 end)
                                    end
                                end
                                break
                            end
                            p = p.Parent
                        end
                    end
                end
                for _, d in ipairs(char:GetDescendants()) do
                    checkDesc(d)
                end
                char.DescendantAdded:Connect(function(d)
                    task.defer(function() checkDesc(d) end)
                end)
            end

            if LP.Character then cleanMyCharacter(LP.Character) end
            LP.CharacterAdded:Connect(cleanMyCharacter)

            -- Boucle de verrouillage : caméra stable, zéro FOV forcé, écran assombri maintenu
            RunService.RenderStepped:Connect(function()
                local cam = workspace.CurrentCamera
                if cam then
                    if cam.FieldOfView ~= 70 then
                        cam.FieldOfView = 70
                    end
                    for _, ch in ipairs(cam:GetChildren()) do
                        if ch:IsA("PostEffect") or ch:IsA("BasePart") or ch:IsA("Model") then
                            pcall(function() ch:Destroy() end)
                        end
                    end
                end
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.CameraOffset ~= Vector3.zero then
                    hum.CameraOffset = Vector3.zero
                end
                local dim = Lighting:FindFirstChild("__SXE_DimScreen")
                if not dim or Lighting.Brightness ~= 0.35 then
                    applyDimLighting()
                end
            end)
        end
        task.spawn(setupAntiScreenEffects)

        local function __sxeStrip()
            local Players = game:GetService("Players")
            local Lighting = game:GetService("Lighting")
            local LP = Players.LocalPlayer
            local function kill(inst)
                _G.SXE_Kill(inst)
            end
            pcall(function() workspace.Terrain.Decoration = false end)

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

            local PLOT_KEEP = {
                Skin = true, Laser = true, AnimalPodiums = true,
                DeliveryHitbox = true, StealHitbox = true, AnimalTarget = true,
                MainRoot = true, Floor = true, Spawn = true, Door = true, Hitbox = true,
                Base = true, Wall = true, Roof = true, SecondFloor = true, ThirdFloor = true,
                ["structure base home"] = true, Unlock = true, Purchases = true,
                CashPad = true, Cash = true, Multiplier = true, FriendPanel = true, PlotSign = true
            }

            local PLOT_NUKE = {
                InvisibleWalls = true,
                Events = true,
                Sounds = true,
            }

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
            local CHAR_KEEP_CLASS = {
                Humanoid = true, Animator = true, Attachment = true,
                Motor6D = true, AnimationConstraint = true,
                BallSocketConstraint = true, Weld = true, WeldConstraint = true,
            }
            local PART_CLASS = {
                Part = true, MeshPart = true, UnionOperation = true,
                WedgePart = true, CornerWedgePart = true, TrussPart = true,
                SpawnLocation = true, Seat = true, VehicleSeat = true,
            }

            local function isMine(inst)
                if not (LP and inst) then return false end
                if inst == LP.Character or inst.Name == LP.Name then return true end
                if LP.Character and inst:IsDescendantOf(LP.Character) then return true end
                return false
            end
            local function isVisualJunk(d)
                local cn = d.ClassName
                return cn == "Beam" or cn == "Trail" or cn == "ParticleEmitter"
                    or cn == "PointLight" or cn == "SpotLight" or cn == "SurfaceLight"
                    or cn == "Fire" or cn == "Smoke" or cn == "Sparkles"
                    or cn == "Highlight"
            end
            local function isSkinJunk(d)
                if not d then return false end
                if isVisualJunk(d) then return true end
                return PART_CLASS[d.ClassName] == true and not d.CanCollide
            end
            local function isPet(inst)
                if not inst or inst.ClassName ~= "Model" then return false end
                return inst:FindFirstChild("FakeRootPart") ~= nil
                    or inst:FindFirstChild("RootPart") ~= nil
                    or inst:FindFirstChildWhichIsA("AnimationController", true) ~= nil
            end
            local function stripSkin(skin)
                if not (skin and skin.Parent) then return end
                local dd = skin:GetDescendants()
                local dump = {}
                for i = 1, #dd do
                    if isSkinJunk(dd[i]) then dump[#dump + 1] = dd[i] end
                end
                for i = 1, #dump do kill(dump[i]) end
            end

            local function stripPetVfx(pet)
                if not pet then return end
                local dd = pet:GetDescendants()
                local dump = {}
                for i = 1, #dd do
                    local d = dd[i]
                    local n = d.Name
                    local cn = d.ClassName
                    if n == "VfxInstance" or n == "_VfxInstance"
                        or cn == "ParticleEmitter" or cn == "Beam" or cn == "Trail"
                        or cn == "Fire" or cn == "Smoke" or cn == "Sparkles"
                        or cn == "PointLight" or cn == "SpotLight" or cn == "SurfaceLight" then
                        dump[#dump + 1] = d
                    end
                end
                for i = 1, #dump do kill(dump[i]) end
            end
            _G.SXE_StripPetVfx = stripPetVfx

            local function isCharJunk(d)
                if not d then return false end
                local cn = d.ClassName
                if cn == "PathfindingModifier" then return false end
                if cn == "WrapTarget" or cn == "WrapLayer" then return true end
                if cn == "Shirt" or cn == "ShirtGraphic" then return true end
                if cn == "NoCollisionConstraint" then return true end
                local nm = d.Name
                if nm == "__HITBOX" or nm == "OriginalPosition" or nm == "OriginalSize" then return true end
                if CHAR_KEEP_CLASS[cn] then return false end
                if BODY_PART[nm] then return false end
                -- Conserve les accessoires, outils et modèles de brainrots portés par les joueurs
                if cn == "Accessory" or cn == "Hat" or cn == "Tool" or cn == "Model" then return false end
                local p = d.Parent
                while p and p ~= workspace do
                    if p.ClassName == "Accessory" or p.ClassName == "Hat" or p.ClassName == "Tool" or isPet(p) then
                        return false
                    end
                    p = p.Parent
                end
                return true
            end
            local function isUuidName(n)
                return type(n) == "string" and #n == 36
                    and string.match(n, "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") ~= nil
            end
            local function isOtherAvatar(char)
                if not (char and char.ClassName == "Model") then return false end
                if isMine(char) then return false end
                if isPet(char) then return false end
                local n = char.Name
                if type(n) == "string" and string.sub(n, -6) == "_Clone" then return false end
                if Players:GetPlayerFromCharacter(char) then return true end
                if Players:FindFirstChild(n) then return true end
                return char:FindFirstChildOfClass("Humanoid") ~= nil
            end
            local hookedChars = {}
            local function stripOtherChar(char)
                if _G.__SXE_VelFlying then return end
                if not (char and char.Parent) or isMine(char) or not isOtherAvatar(char) then return end
                local function sweep()
                    local dd = char:GetDescendants()
                    local dump = {}
                    for i = 1, #dd do
                        if isCharJunk(dd[i]) then dump[#dump + 1] = dd[i] end
                    end
                    for i = 1, #dump do kill(dump[i]) end
                end
                sweep()
                if hookedChars[char] then return end
                hookedChars[char] = true
                char.DescendantAdded:Connect(function(d)
                    if _G.__SXE_VelFlying then return end
                    if d and d.Parent and not isMine(char) and isCharJunk(d) then kill(d) end
                end)
            end

            local strippedPlots = {}
            _G.__SXE_StrippedPlots = strippedPlots

            local function handlePlotChild(plot, ch)
                if not (ch and ch.Parent) then return end
                local n = ch.Name
                if n == "Skin" then stripSkin(ch); return end
                if PLOT_KEEP[n] then return end
                if PLOT_NUKE[n] then kill(ch); return end
                if isPet(ch) then
                    stripPetVfx(ch)
                    return
                end
            end

            local function stripPlotInterior(plot)
                if not (plot and plot.Parent) then return end
                strippedPlots[plot.Name] = true
                local skin = plot:FindFirstChild("Skin")
                if skin then stripSkin(skin) end
                local kids = plot:GetChildren()
                for i = 1, #kids do
                    local ch = kids[i]
                    if ch and ch.Parent then
                        local n = ch.Name
                        if PLOT_NUKE[n] then
                            kill(ch)
                        elseif isPet(ch) then
                            pcall(stripPetVfx, ch)
                        end
                    end
                end
            end

            local function connectPlot(plot)
                if not (plot and plot.Parent) then return end
                plot.ChildAdded:Connect(function(ch)
                    if _G.__SXE_VelFlying then return end
                    handlePlotChild(plot, ch)
                end)
                plot.DescendantAdded:Connect(function(d)
                    if _G.__SXE_VelFlying then return end
                    if not d then return end
                    local p = d.Parent
                    if not p then return end
                    local sk = p
                    while sk and sk ~= plot do
                        if sk.Name == "Skin" then
                            if isSkinJunk(d) then kill(d) end
                            return
                        end
                        sk = sk.Parent
                    end
                end)
            end

            local hookedPlots
            local function hookPlot(plot)
                stripPlotInterior(plot)
                connectPlot(plot)
            end
            local function hookPlots(folder)
                if not folder or hookedPlots == folder then return end
                hookedPlots = folder
                local kids = folder:GetChildren()
                for i = 1, #kids do
                    hookPlot(kids[i])
                end
                folder.ChildAdded:Connect(function(plot)
                    hookPlot(plot)
                end)
            end

            _G.SXE_LockPrioPlot = function() end

            local hookedRma
            local function hookRma(rma)
                if not rma or hookedRma == rma then return end
                hookedRma = rma
                for _, ch in ipairs(rma:GetChildren()) do
                    if isPet(ch) then stripPetVfx(ch) end
                end
                rma.ChildAdded:Connect(function(ch)
                    if isPet(ch) then stripPetVfx(ch) end
                end)
            end

            local function onWsChild(ch)
                if not ch then return end
                if _G.__SXE_VelFlying then return end
                local n = ch.Name
                if ch.ClassName == "Camera" or ch.ClassName == "Terrain" or n == "Map" then return end
                if n == "Plots" then hookPlots(ch); return end
                if n == "RenderedMovingAnimals" then hookRma(ch); return end
                if isMine(ch) then return end
                if isPet(ch) then stripPetVfx(ch); return end
                -- Ne supprime pas un modèle UUID s'il est attaché ou proche du personnage (brainrot volé porté en main)
                if isUuidName(n) then
                    local lpChar = LP and LP.Character
                    if lpChar and ch:IsA("Model") then
                        local w = ch:FindFirstChildWhichIsA("Weld", true) or ch:FindFirstChildWhichIsA("WeldConstraint", true)
                        if w and ((w.Part0 and w.Part0:IsDescendantOf(lpChar)) or (w.Part1 and w.Part1:IsDescendantOf(lpChar))) then
                            stripPetVfx(ch)
                            return
                        end
                    end
                    kill(ch)
                    return
                end
                if isOtherAvatar(ch) then stripOtherChar(ch); return end
                if ch.ClassName == "Model" then
                    ch.ChildAdded:Connect(function()
                        if isOtherAvatar(ch) then stripOtherChar(ch) end
                    end)
                end
                if string.sub(n, 1, 7) == "BeeHive" or string.sub(n, 1, 7) == "Sentry_" then
                    kill(ch)
                    return
                end
                if WS_KILL[n] or ch.ClassName == "Highlight" then kill(ch); return end
                if ch.ClassName == "Model" and string.find(n, "'s Rainbow", 1, true) then
                    kill(ch)
                end
            end

            local wsch = workspace:GetChildren()
            local plotsFolder, rmaFolder
            local rest = {}
            for i = 1, #wsch do
                local ch = wsch[i]
                local n = ch.Name
                if n == "Plots" then plotsFolder = ch
                elseif n == "RenderedMovingAnimals" then rmaFolder = ch
                else rest[#rest + 1] = ch end
            end
            if rmaFolder then hookRma(rmaFolder) end
            for i = 1, #rest do onWsChild(rest[i]) end
            if plotsFolder then hookPlots(plotsFolder) end
            workspace.ChildAdded:Connect(onWsChild)

            local function hookPlrChar(plr)
                if not plr or plr == LP then return end
                if plr.Character then stripOtherChar(plr.Character) end
                plr.CharacterAdded:Connect(stripOtherChar)
            end
            local plrs = Players:GetPlayers()
            for i = 1, #plrs do hookPlrChar(plrs[i]) end
            Players.PlayerAdded:Connect(hookPlrChar)

            local function onLit(x)
                if _G.__SXE_VelFlying then return end
                if not x or x.Name == "__SXE_DimScreen" then return end
                if x:IsA("PostEffect") then
                    kill(x)
                end
            end
            local lit = Lighting:GetChildren()
            for i = 1, #lit do onLit(lit[i]) end
            Lighting.ChildAdded:Connect(onLit)

            local function stripCamFx(x)
                if not x then return end
                if x:IsA("PostEffect") or x:IsA("BasePart") or x:IsA("Model") then kill(x) end
            end
            local hookedCam
            local function hookCam(cam)
                if not cam or hookedCam == cam then return end
                hookedCam = cam
                local ck = cam:GetChildren()
                for i = 1, #ck do stripCamFx(ck[i]) end
                cam.ChildAdded:Connect(stripCamFx)
            end
            hookCam(workspace.CurrentCamera)
            workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
                hookCam(workspace.CurrentCamera)
            end)

            do
                local ter = workspace.Terrain
                pcall(function() ter.Decoration = false end)
                local kids = ter:GetChildren()
                for i = 1, #kids do kill(kids[i]) end
                ter.ChildAdded:Connect(function(ch)
                    if _G.__SXE_VelFlying then return end
                    kill(ch)
                end)
            end
            _G.__SXE_StripDone = true
        end

        if not game:IsLoaded() then
            game.Loaded:Wait()
        end
        do
            local Players = game:GetService("Players")
            local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
            if not lp.Character then
                lp.CharacterAdded:Wait()
            end
            if not workspace:FindFirstChild("Plots") then
                workspace:WaitForChild("Plots", 10)
            end
        end
        task.spawn(function()
            pcall(__sxeStrip)
        end)

        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        if not _G.__SXE_SyncBoot then
            do
                local _xchan
                local _synInst, _syncMod
                local function _synNow()
                    if _synInst and _synInst.Parent then return _synInst end
                    local p = ReplicatedStorage:FindFirstChild("Packages")
                    _synInst = p and p:FindFirstChild("Synchronizer")
                    return _synInst
                end
                local function _trySenv()
                    if _xchan then return true end
                    local syn = _synNow()
                    if not syn then return false end
                    if type(_syncMod) ~= "table" then
                        local req = (getrenv and getrenv().require) or require
                        local ok, mod = pcall(req, syn)
                        if ok and type(mod) == "table" then _syncMod = mod end
                    end
                    local getFn = type(_syncMod) == "table" and rawget(_syncMod, "Get")
                    local gf = getfenv or (debug and debug.getfenv)
                    if type(getFn) ~= "function" or type(gf) ~= "function" then return false end
                    local ok, env = pcall(gf, getFn)
                    if not ok or type(env) ~= "table" then return false end
                    local ch = rawget(env, "Channels")
                    if type(ch) ~= "table" then return false end
                    _xchan = ch
                    return true
                end
                local function _chans()
                    if _xchan then return _xchan end
                    _trySenv()
                    return _xchan
                end

                _G.XenSyncAll = function() return _chans() end
                _G.XenSyncGet = _G.XenSyncGet or function(idx)
                    local t = _chans()
                    if not t or idx == nil then return nil end
                    local ok, cd = pcall(rawget, t, idx)
                    if ok and type(cd) == "table" then return cd end
                    local ok2, cd2 = pcall(function() return t[idx] end)
                    if ok2 and type(cd2) == "table" then return cd2 end
                    return nil
                end
                _G.SXE_IsPlotChanKey = function(k)
                    return type(k) == "string" and #k >= 32 and string.find(k, "-", 1, true) ~= nil
                end

                _G.sProp = _G.sProp or function(ch, key)
                    if type(ch) ~= "table" or key == nil then return nil end
                    local ct = rawget(ch, "CacheTable")
                    if type(ct) ~= "table" then
                        local okC, c2 = pcall(function() return ch.CacheTable end)
                        if okC and type(c2) == "table" then ct = c2 end
                    end
                    if type(ct) ~= "table" then return nil end
                    local v = rawget(ct, key)
                    if v ~= nil then return v end
                    local okV, v2 = pcall(function() return ct[key] end)
                    if okV then return v2 end
                    return nil
                end
            end
        end

        _G.SXE_PrioSet = {}

        task.defer(function()
            local plots = workspace:FindFirstChild("Plots")
            if not plots then return end
            for _, plot in ipairs(plots:GetChildren()) do
                for _, ch in ipairs(plot:GetChildren()) do
                    if not ch:IsA("Model") then continue end
                    if not (ch:FindFirstChild("RootPart") or ch:FindFirstChild("FakeRootPart")
                        or ch:FindFirstChildWhichIsA("AnimationController", true)) then
                        continue
                    end
                    pcall(_G.SXE_StripPetVfx, ch)
                end
            end
        end)

        _G.SXE_NukePlotPodiums = function() end
        _G.SXE_StripNonPrioPodiums = function() end
        _G.SXE_StripNoPrioPlots = function() end

    end)
    if not _okOPT then warn("[OPTIMIZER] erreur: " .. tostring(_errOPT)) end
end)