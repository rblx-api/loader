-- =====================================================================
--  skyr0 LOADER
--  run it from autoexec (skyrohubauth.lua carries a copy; first one wins)
--  1. FFlags        low graphics, fps unlock
--  2. Flat world    no textures / effects / images, flat lighting
--  3. No game GUI   game GUIs off, own inventory bar
--  4. Nuke          event maps, cosmetic models / GUIs emptied
--  5. Quiet         no game sounds, cosmetic scripts off
--  6. Plot clean    animations stopped, plot brainrots + event maps invisible (belt ones stay)
--  7. Controller block   unneeded game controllers never start
--  8. Rejoin F6 / hop F7 / private server F8
--  9. CoreGui       roblox UI off, own Leave button, chat, player list (Tab)
--  nothing is destroyed: things are switched off or moved to STASH.
--  getgenv().SKYR0_FFLAGS = false skips the FFlags.
-- =====================================================================
local env = (getgenv and getgenv()) or _G
-- autoexec copy + the copy inside the hub: only the first one runs
if env.__Skyr0LoaderRan then return end
env.__Skyr0LoaderRan = true
-- started after the game already loaded (hub executed by hand): the parts that
-- only matter during the join are skipped
local LATE = game:IsLoaded() and game:GetService("Players").LocalPlayer ~= nil
    and game:GetService("Players").LocalPlayer.Character ~= nil


-- ============================================================ SWITCHES
-- turn a section off by setting it to false
local ON = {
    controllerblock = true,
    plotclean = true,
    nuke = true,
    quiet = true,
    flatworld = true,
    nogamegui = true,
    coregui = true,
    fflags = true,
}

-- ============================================================ FFLAGS
local fflags = {
    -- fps / scheduler
    ["DFIntTaskSchedulerTargetFps"] = "9999",
    ["FFlagTaskSchedulerLimitTargetFpsToDevice"] = "False",
    ["FFlagTaskSchedulerLimitTargetFpsTo2402"] = "False",
    ["FFlagGameBasicSettingsFramerateCap5"] = "False",

    -- texture / graphics
    ["DFIntTextureQualityOverride"] = "0",
    ["DFFlagTextureQualityOverrideEnabled"] = "True",
    ["FIntDebugForceMSAASamples"] = "0",
    ["FIntDebugFRMOptionalMSAALevelOverride"] = "0",
    ["DFIntDebugFRMQualityLevelOverride"] = "0",
    ["FFlagDisablePostFx"] = "True",
    ["FFlagDisablePostProcess"] = "True",
    ["FFlagDebugGraphicsPreferD3D11"] = "True",
    ["FFlagDebugGraphicsPreferD3D11FL10"] = "True",
    ["FFlagDebugGraphicsDisableDirect3D11"] = "False",
    ["FFlagHandleAltEnterFullscreenManually"] = "False",
    ["FIntFullscreenTitleBarTriggerDelayMillis"] = "3600000",
    ["FFlagDebugDisplayFPS"] = "True",
    ["FIntRenderShadowIntensity"] = "0",
    ["FIntRenderShadowmapBias"] = "0",
    ["FIntRenderLocalLightUpdatesMax"] = "1",
    ["FIntRenderLocalLightFadeInMs"] = "0",
    ["FFlagFixGraphicsQuality"] = "True",
    ["FFlagCommitToGraphicsQualityFix"] = "True",
    ["DFFlagRenderBloomMakeResolutionIndependent"] = "False",
    ["DFFlagRenderSunRaysMakeResolutionIndependent"] = "False",
    ["FFlagDisableHQShadersLowEndDx112"] = "True",
    ["FFlagGraphicsCheckComputeSupport"] = "False",
    ["FFlagGraphicsEnableD3D10Compute"] = "True",
    ["FFlagFastGPULightCulling3"] = "True",
    ["FFlagDebugForceFSMCPULightCulling"] = "True",
    ["FFlagMSRendererLightGridOptimization"] = "True",
    ["DFFlagLightGridSimdNew3"] = "True",
    ["DFFlagProbesStaggerUpdateCalls"] = "True",
    ["FFlagNewLightAttenuation"] = "True",
    ["FFlagDebugForceFutureIsBrightPhase3"] = "True",
    ["FFlagDebugForceFutureIsBrightPhase2"] = "True",
    ["FFlagRenderDynamicResolutionScale11"] = "True",
    ["FFlagFRMRefactor"] = "False",
    ["FIntSSAOMipLevels"] = "0",
    ["FFlagRenderEnableHalfsPVR"] = "False",
    ["FFlagRenderFixFog"] = "True",
    ["FIntUnifiedLightingBlendZone"] = "0",
    ["FFlagFixTextureCompositorFramebufferManagement2"] = "True",
    ["FIntUITextureMaxUpdateDepth"] = "1",
    ["FIntVertexSmoothingGroupTolerance"] = "0",
    ["FFlagFixOutdatedTimeScaleParticles"] = "False",
    ["FFlagFixOutdatedParticles2"] = "False",
    ["FFlagFixParticleAttachmentCulling"] = "False",

    -- csg / lod
    ["DFIntCSGLevelOfDetailSwitchingDistance"] = "0",
    ["DFIntCSGLevelOfDetailSwitchingDistanceL12"] = "0",
    ["DFIntCSGLevelOfDetailSwitchingDistanceL23"] = "0",
    ["DFIntCSGLevelOfDetailSwitchingDistanceL34"] = "0",

    -- grass / terrain
    ["FIntTerrainArraySliceSize"] = "0",
    ["FIntRenderGrassHeightScalar"] = "0",
    ["FIntFRMMinGrassDistance"] = "0",
    ["FIntGrassMovementReducedMotionFactor"] = "0",

    -- ui (your list set the blur to 100 and then to 0 -- 0 is what it ended on)
    ["FIntRobloxGuiBlurIntensity"] = "0",
    ["FIntFontSizePadding"] = "3",
    ["FFlagUserShowGuiHideToggles"] = "True",
    ["FIntCameraMaxZoomDistance"] = "2147483647",
    ["DFIntCanHideGuiGroupId"] = "32380007",
    ["FFlagEnableCommandAutocomplete"] = "False",
    ["FFlagBetaBadgeLearnMoreLinkFormview"] = "False",
    ["FFlagControlBetaBadgeWithGuac"] = "False",
    ["FFlagVoiceBetaBadge"] = "False",
    ["FFlagEnablePartyVoiceOnlyForEligibleUsers"] = "False",
    ["FFlagEnablePartyVoiceOnlyForUnfilteredThreads"] = "False",
    ["FFlagWindowsLaunchTypeAnalytics"] = "False",
    ["FFlagVideoServiceAddHardwareCodecMetrics"] = "True",
    ["DFFlagDPIScale"] = "False",
    ["DFFlagDisableDPIScale"] = "False",
    ["FFlagEnablePreferredTextSizeStyleFixesInAppShell3"] = "True",
    ["FFlagEnablePreferredTextSizeGuiService"] = "True",
    ["FFlagEnablePreferredTextSizeScale"] = "True",
    ["FFlagEnablePreferredTextSizeSettingInMenus2"] = "True",
    ["FFlagEnablePreferredTextSizeStyleFixesInAvatarExp"] = "True",
    ["FIntPreferredTextSizeSettingBetaFeatureRolloutPercent"] = "100",
    ["FFlagLuaAppLegacyInputSettingRefactor"] = "True",
    ["FFlagBetterTrackpadScrolling"] = "True",
    ["FFlagUserBetterInertialScrolling"] = "True",
    ["FFlagFixSensitivityTextPrecision"] = "False",
    ["FFlagFixIGMTabTransitions"] = "True",
    ["FIntEnableVisBugChecksHundredthPercent27"] = "100",
    ["FIntOverrideISRReplicatorStepBandwidthBytes"] = "131072",
    ["FIntActivatedCountTimerMSMouse"] = "0",
    ["FIntActivatedCountTimerMSKeyboard"] = "0",

    -- audio / voice
    ["DFFlagAudioUseVolumetricPanning"] = "True",
    ["DFFlagAudioEnableVolumetricPanningForMeshes"] = "True",
    ["DFIntVoiceChatVolumeThousandths"] = "5000",
    ["FFlagEnableAudioPannerFiltering"] = "True",

    -- telemetry off
    ["FFlagDebugDisableTelemetryV2Event"] = "True",
    ["FFlagDebugDisableTelemetryV2Stat"] = "True",
    ["FFlagDebugDisableTelemetryPoint"] = "True",
    ["FIntCAP1209DataSharingTOSVersion"] = "0",
    ["FIntCAP1544DataSharingUserRolloutPercentage"] = "0",
    ["DFIntSignalRCoreHubConnectionDisconnectInfoHundredthsPercent"] = "10",

    -- join pipe: incoming packets get worked off in bigger chunks per frame,
    -- so the server's stream lands sooner instead of trickling in
    ["DFIntClientPacketHealthyAllocationPercent"] = "100",
    ["DFIntClientPacketMinMicroseconds"] = "0",
    ["DFIntClientPacketMaxFrameMicroseconds"] = "200000",
    ["DFIntClientPacketHealthyMsPerSecondLimit"] = "1000",
    ["DFIntClientPacketUnhealthyContEscMsPerSecond"] = "1000",
    ["DFIntMaxProcessPacketsStepsPerCyclic"] = "50",
    ["DFIntMaxProcessPacketsStepsAccumulated"] = "150",
    ["DFIntMaxProcessPacketsJobScaling"] = "100",
    ["DFIntRakNetLoopMs"] = "1",
    ["DFIntMaxStreamPacketsPerStep"] = "128",
    ["DFIntMaxConsecutiveStreamJobWorkLoad"] = "8",
    ["DFIntNetAssetInlineBytesPerStep"] = "65536",
    ["DFFlagDebugDisableExpensiveDedupNetAssetCompare"] = "True",

    -- asset fetch: content provider + http batching run flat out
    ["DFIntContentProviderJobDutyCycleMicroseconds"] = "8000",
    ["DFIntMaxContentProviderRunsPerStep"] = "40",
    ["DFIntMaxContentProviderRunsAccumulated"] = "80",
    ["DFIntAssetProviderWorkflowExecutorSleepMicroSeconds"] = "1000",
    ["DFIntNumConcurrentBatchWorkflowsPerAssetProviderInstance"] = "8",
    ["DFIntHttpBatchApi_minWaitMs"] = "0",
    ["DFIntHttpBatchApi_maxWaitMs"] = "5",
    ["DFIntDynamicTextureManagerPrepareBudgetMicroSeconds"] = "8000",
    ["FFlagTM2SkipMipsForUnstreamable2"] = "True",

    -- scheduler / gc
    ["DFIntTaskSchedulerTasksDefaultMaxTimeMsPerCycle"] = "30",
    ["DFIntGCReducesQuotaPercent"] = "0",

}

-- only held while joining: meshes / texture preloads / voxelizer wait until
-- you're standing in the game, then everything goes back to normal
local joinFlags = {
    ["FFlagDebugRenderMeshPauseContentRequests"] = "True",
    ["FFlagDebugContentProviderSkipPreloadFromTextureManager"] = "True",
    ["FFlagDebugPauseVoxelizer"] = "True",
}

local function getFFlagSetter()
    for _, name in ipairs({ "setfflag", "setfastflag", "set_fflag", "setFFlag", "fflag", "mfflags" }) do
        local fn = rawget(getfenv(), name) or (getgenv and getgenv()[name])
        if type(fn) == "function" then return fn end
    end
    return nil
end

local function applyFFlags()
    local setter = getFFlagSetter()
    if not setter then return end
    for name, value in pairs(fflags) do pcall(setter, name, value) end
    if LATE then return end

    -- join-only flags: on now, off once the character has a root part
    for name, value in pairs(joinFlags) do pcall(setter, name, value) end
    task.spawn(function()
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        while not lp do task.wait() lp = Players.LocalPlayer end
        local char = lp.Character or lp.CharacterAdded:Wait()
        char:WaitForChild("HumanoidRootPart", 60)
        for name in pairs(joinFlags) do pcall(setter, name, "False") end
    end)
end

-- ============================================================ GO
-- FFlags right now, before anything else runs (a few hundred cheap calls)
if ON.fflags and env.SKYR0_FFLAGS ~= false then pcall(applyFFlags) end
pcall(function() if setfpscap then setfpscap(999) end end)

pcall(function() game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen() end)

-- roblox's join curtain (loading gui + black blackout) never shows: you see
-- the world the moment it's there instead of after the fade
if not LATE then
    task.spawn(function()
        local core
        pcall(function() core = game:GetService("CoreGui") end)
        if not core then return end
        local CURTAIN = { RobloxLoadingGUI = true, DevGUIBlackoutCurtain = true }
        local function shut(g)
            if g:IsA("LayerCollector") then pcall(function() g.Enabled = false end) end
        end
        local function curtain(g)
            if not CURTAIN[g.Name] then return end
            shut(g)
            for _, d in ipairs(g:GetDescendants()) do shut(d) end
            g.DescendantAdded:Connect(shut)
        end
        for _, c in ipairs(core:GetChildren()) do curtain(c) end
        core.ChildAdded:Connect(curtain)
    end)
end

-- ============================================================ WORK QUEUE
-- new instances are handled here, max ~2ms per frame (no join spikes)
local QUEUE
do
    local RunService = game:GetService("RunService")
    local BUDGET = 0.002
    local fns, args, head, tail = {}, {}, 1, 0
    QUEUE = function(fn, inst)
        tail += 1
        fns[tail], args[tail] = fn, inst
    end
    RunService.Heartbeat:Connect(function()
        if head > tail then return end
        local stop = os.clock() + BUDGET
        while head <= tail do
            local fn, inst = fns[head], args[head]
            fns[head], args[head] = nil, nil
            head += 1
            if inst.Parent then pcall(fn, inst) end
            if os.clock() > stop then break end
        end
        if head > tail then head, tail = 1, 0 end
    end)
end

-- ============================================================ STASH
-- "delete" = move into an unparented folder (never :Destroy, no errors)
local STASH = Instance.new("Folder")
STASH.Name = "Stash"
local function stash(inst)
    pcall(function() inst.Parent = STASH end)
end

-- things with an Enabled switch are just switched off and kept off
local function switchOff(inst)
    pcall(function()
        inst.Enabled = false
        inst:GetPropertyChangedSignal("Enabled"):Connect(function()
            if inst.Enabled then inst.Enabled = false end
        end)
    end)
end

-- ============================================================ FLAT WORLD
-- smooth plastic, no textures / effects / images, flat lighting.
-- only the game's own stuff is touched, never any hub's:
-- game GUIs are known by name, ESP (AlwaysOnTop) and Skyr0* are skipped
local GAME_GUI = {}
local guiLearned = {}   -- run with each new name (a gui that showed up early)
do
    -- runs for every instance replicating into ReplicatedStorage (~110k on
    -- join): a table lookup, not an IsA call
    local GUI_CLASS = { ScreenGui = true, BillboardGui = true, SurfaceGui = true }
    local function learn(inst)
        if GUI_CLASS[inst.ClassName] and not GAME_GUI[inst.Name] then
            GAME_GUI[inst.Name] = true
            for _, f in ipairs(guiLearned) do task.defer(f, inst.Name) end
        end
    end
    task.spawn(function()
        local SG = game:GetService("StarterGui")
        for _, c in ipairs(SG:GetChildren()) do learn(c) end
        SG.ChildAdded:Connect(learn)
        local RS = game:GetService("ReplicatedStorage")
        for _, d in ipairs(RS:GetDescendants()) do learn(d) end
        RS.DescendantAdded:Connect(learn)
    end)
end

local function espLike(x)
    local cn = x.ClassName
    if cn == "Highlight" then return x.DepthMode == Enum.HighlightDepthMode.AlwaysOnTop end
    if cn == "BillboardGui" then return x.AlwaysOnTop end
    return false
end

local function isOurs(inst)
    local x = inst
    for _ = 1, 6 do
        if not x then return false end
        if x.Name:sub(1, 5) == "Skyr0" or espLike(x) then return true end
        x = x.Parent
    end
    return false
end

-- PlayerGui: is this inside one of the game's own GUIs?
local function inGameGui(inst, pg)
    local x = inst
    while x and x.Parent ~= pg do x = x.Parent end
    return x ~= nil and GAME_GUI[x.Name] == true
end

if ON.flatworld then
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")

    local PART = {
        Part = true, MeshPart = true, UnionOperation = true, WedgePart = true,
        CornerWedgePart = true, TrussPart = true, SpawnLocation = true, Seat = true,
        VehicleSeat = true, IntersectOperation = true, NegateOperation = false,
    }
    local KILL = {
        ParticleEmitter = true, Trail = true, Beam = true, Smoke = true, Fire = true,
        Sparkles = true, PointLight = true, SpotLight = true, SurfaceLight = true,
        Highlight = true, SurfaceAppearance = true, UIGradient = true,
    }
    local WEAR = { Accessory = true, Shirt = true, Pants = true, ShirtGraphic = true }

    local function otherCharacter(inst)
        local m = inst:FindFirstAncestorOfClass("Model")
        while m do
            local plr = Players:GetPlayerFromCharacter(m)
            if plr then return plr ~= Players.LocalPlayer end
            m = m:FindFirstAncestorOfClass("Model")
        end
        return false
    end

    local function flatten(inst)
        local cn = inst.ClassName
        if PART[cn] then
            inst.Material = Enum.Material.SmoothPlastic
            inst.Reflectance = 0
            inst.CastShadow = false
            if cn == "MeshPart" then
                inst.TextureID = ""
            end
        elseif cn == "Decal" or cn == "Texture" then
            inst.Texture = ""
        elseif cn == "SpecialMesh" then
            inst.TextureId = ""
        elseif cn == "ImageLabel" or cn == "ImageButton" then
            inst.Image = ""
        elseif KILL[cn] then
            -- never destroy on your own character / tools: tool scripts
            -- WaitForChild their beams (grapple rope etc.)
            local c = Players.LocalPlayer and Players.LocalPlayer.Character
            if c and inst:IsDescendantOf(c) then return end
            if cn == "SurfaceAppearance" then
                stash(inst)   -- no switch; nothing looks it up by name
            else
                switchOff(inst)
                -- :Emit() ignores Enabled; zero lifetime kills those bursts too
                if cn == "ParticleEmitter" then inst.Lifetime = NumberRange.new(0) end
            end
        else
            return
        end
    end

    -- one table lookup for anything that isn't a target
    local ANY = {}
    for k, v in pairs(PART) do if v then ANY[k] = true end end
    for k in pairs(KILL) do ANY[k] = true end
    ANY.Decal, ANY.Texture, ANY.SpecialMesh, ANY.ImageLabel, ANY.ImageButton = true, true, true, true, true

    local function apply(inst)
        if ANY[inst.ClassName] and not isOurs(inst) then pcall(flatten, inst) end
    end
    -- only: optional filter (PlayerGui: just the game's GUIs, never a hub's)
    local function cover(root, only)
        local function go(d)
            if not only or only(d) then apply(d) end
        end
        for _, d in ipairs(root:GetDescendants()) do go(d) end
        -- deferred so the game's own setup (mutation colours etc.) runs first
        root.DescendantAdded:Connect(function(d)
            if ANY[d.ClassName] then QUEUE(go, d) end
        end)
    end

    cover(workspace)

    -- the game's GUIs: ReplicatedGui (moved into PlayerGui by the game) + PlayerGui
    task.spawn(function()
        local RS = game:GetService("ReplicatedStorage")
        local rg = RS:WaitForChild("ReplicatedGui", 120)
        if rg then cover(rg) end
    end)
    task.spawn(function()
        local lp = Players.LocalPlayer
        while not lp do task.wait() lp = Players.LocalPlayer end
        local pg = lp:WaitForChild("PlayerGui", 60)
        if pg then cover(pg, function(d) return inGameGui(d, pg) end) end
    end)

    -- lighting
    -- kept in place (CycleController tweens Lighting.SunRays by name), just off
    local function stripLighting(inst)
        if inst:IsA("PostEffect") or inst:IsA("Clouds") then
            switchOff(inst)
        elseif inst:IsA("Atmosphere") then
            pcall(function() inst.Density, inst.Haze, inst.Glare = 0, 0, 0 end)
        elseif inst:IsA("Sky") then
            pcall(function() inst.CelestialBodiesShown, inst.StarCount = false, 0 end)
        end
    end
    local function flatLighting()
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.Brightness = 1
            Lighting.Ambient = Color3.fromRGB(140, 140, 140)
            Lighting.OutdoorAmbient = Color3.fromRGB(140, 140, 140)
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            Lighting.FogEnd = 1e6
        end)
    end
    for _, d in ipairs(Lighting:GetDescendants()) do stripLighting(d) end
    Lighting.DescendantAdded:Connect(function(d) task.defer(stripLighting, d) end)
    flatLighting()
    -- the game's day/night cycle keeps rewriting lighting; put it back
    Lighting.Changed:Connect(function(prop)
        if prop == "GlobalShadows" or prop == "Ambient" or prop == "OutdoorAmbient" or prop == "Brightness" then
            task.defer(flatLighting)
        end
    end)
    pcall(function()
        local t = workspace.Terrain
        t.Decoration = false
        t.WaterWaveSize = 0
        t.WaterWaveSpeed = 0
        t.WaterReflectance = 0
    end)
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
end

-- ============================================================ NO GAME GUI
-- the game's GUIs are switched off (not removed: the game waits on them),
-- a small inventory bar replaces the hotbar
if ON.nogamegui then
    local Players = game:GetService("Players")
    local StarterGui = game:GetService("StarterGui")
    local UIS = game:GetService("UserInputService")
    local LP = Players.LocalPlayer
    while not LP do task.wait() LP = Players.LocalPlayer end

    local done = {}
    local function hide(g)
        -- only the game's own GUIs: a hub's ScreenGui here is left alone
        if done[g] or not g:IsA("LayerCollector") or not GAME_GUI[g.Name] then return end
        done[g] = true
        pcall(function() g.Enabled = false end)
        g:GetPropertyChangedSignal("Enabled"):Connect(function()
            if g.Enabled then g.Enabled = false end
        end)
    end

    task.spawn(function()
        local pg = LP:WaitForChild("PlayerGui", 60)
        if not pg then return end
        for _, g in ipairs(pg:GetChildren()) do hide(g) end
        pg.ChildAdded:Connect(function(g) task.defer(hide, g) end)
        -- a gui that got here before its name was learned
        guiLearned[#guiLearned + 1] = function(name)
            for _, g in ipairs(pg:GetChildren()) do
                if g.Name == name then hide(g) end
            end
        end
    end)

    -- roblox's own: player list, health bar, emotes, default backpack
    task.spawn(function()
        for _ = 1, 20 do
            for _, t in ipairs({ Enum.CoreGuiType.PlayerList, Enum.CoreGuiType.Health,
                Enum.CoreGuiType.EmotesMenu, Enum.CoreGuiType.Backpack }) do
                pcall(StarterGui.SetCoreGuiEnabled, StarterGui, t, false)
            end
            task.wait(1)
        end
    end)

    -- ---------------------------------------------------------- inventory
    -- one slot per tool, keys 1-0, click / tap to equip
    local TOUCH = UIS.TouchEnabled and not UIS.KeyboardEnabled
    local ACCENT = Color3.fromRGB(120, 90, 255)
    local SLOT = TOUCH and 58 or 56
    local GAP = 5
    local KEYS = {
        [Enum.KeyCode.One] = 1, [Enum.KeyCode.Two] = 2, [Enum.KeyCode.Three] = 3,
        [Enum.KeyCode.Four] = 4, [Enum.KeyCode.Five] = 5, [Enum.KeyCode.Six] = 6,
        [Enum.KeyCode.Seven] = 7, [Enum.KeyCode.Eight] = 8, [Enum.KeyCode.Nine] = 9,
        [Enum.KeyCode.Zero] = 10,
        [Enum.KeyCode.KeypadOne] = 1, [Enum.KeyCode.KeypadTwo] = 2, [Enum.KeyCode.KeypadThree] = 3,
        [Enum.KeyCode.KeypadFour] = 4, [Enum.KeyCode.KeypadFive] = 5, [Enum.KeyCode.KeypadSix] = 6,
        [Enum.KeyCode.KeypadSeven] = 7, [Enum.KeyCode.KeypadEight] = 8, [Enum.KeyCode.KeypadNine] = 9,
        [Enum.KeyCode.KeypadZero] = 10,
    }

    local gui = Instance.new("ScreenGui")
    gui.Name = "Skyr0Inventory"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 150
    local root
    pcall(function() root = gethui and gethui() end)
    if not root then pcall(function() root = game:GetService("CoreGui") end) end
    if not pcall(function() gui.Parent = root end) or not gui.Parent then
        gui.Parent = LP:WaitForChild("PlayerGui")
    end

    -- outer frame sizes to the slots, capped to the screen width; the inner
    -- ScrollingFrame scrolls sideways when there are more tools than fit
    local bar = Instance.new("Frame")
    bar.Name = "Bar"
    bar.AnchorPoint = Vector2.new(0.5, 1)
    bar.Position = UDim2.new(0.5, 0, 1, TOUCH and -6 or -10)
    bar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    bar.BackgroundTransparency = 0.25
    bar.BorderSizePixel = 0
    bar.Visible = false
    bar.Parent = gui
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 10)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Position = UDim2.fromOffset(6, 6)
    scroll.Size = UDim2.new(1, -12, 1, -12)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = TOUCH and 0 or 3
    scroll.ScrollingDirection = Enum.ScrollingDirection.X
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    scroll.CanvasSize = UDim2.new()
    scroll.ElasticBehavior = Enum.ElasticBehavior.Never
    scroll.Parent = bar
    local list = Instance.new("UIListLayout", scroll)
    list.FillDirection = Enum.FillDirection.Horizontal
    list.Padding = UDim.new(0, GAP)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.VerticalAlignment = Enum.VerticalAlignment.Center

    local seen = {}         -- tools in the order they first showed up
    local order = {}        -- what the bar shows: owned tools, your order
    local slots = {}        -- [tool] = slot button

    -- drag a slot onto another to swap; order saved by tool name
    local SAVE = "skyr0_inventory.txt"
    local names = {}
    pcall(function()
        if isfile and isfile(SAVE) then
            for line in readfile(SAVE):gmatch("[^\n]+") do names[#names + 1] = line end
        end
    end)
    local function save()
        pcall(function() if writefile then writefile(SAVE, table.concat(names, "\n")) end end)
    end
    local function rankOf(t)
        local i = table.find(names, t.Name)
        if not i then
            names[#names + 1] = t.Name
            i = #names
        end
        return i
    end

    local function char() return LP.Character end
    local function hum()
        local c = char()
        return c and c:FindFirstChildOfClass("Humanoid")
    end
    local function owned(t)
        local bp = LP:FindFirstChildOfClass("Backpack")
        local c = char()
        return t.Parent ~= nil and ((bp ~= nil and t.Parent == bp) or (c ~= nil and t.Parent == c))
    end

    local function toggle(t)
        local h = hum()
        if not (h and t and owned(t)) then return end
        if t.Parent == char() then
            h:UnequipTools()
        else
            h:EquipTool(t)
        end
    end

    local function resize()
        local cam = workspace.CurrentCamera
        local maxW = (cam and cam.ViewportSize.X or 800) - 20
        local n = #order
        local want = n * SLOT + math.max(0, n - 1) * GAP + 12
        bar.Size = UDim2.fromOffset(math.min(want, maxW), SLOT + 12)
    end

    local press, ghost, dragEndAt = nil, nil, 0
    local refresh

    local function makeSlot(t)
        local b = Instance.new("TextButton")
        b.Name = "Slot"
        b.Size = UDim2.fromOffset(SLOT, SLOT)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        b.BorderSizePixel = 0
        b.AutoButtonColor = true
        b.Text = ""
        b.Parent = scroll
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local sel = Instance.new("UIStroke", b)
        sel.Name = "Sel"
        sel.Thickness = 2
        sel.Color = ACCENT
        sel.Enabled = false

        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.BackgroundTransparency = 1
        icon.AnchorPoint = Vector2.new(0.5, 0)
        icon.Position = UDim2.new(0.5, 0, 0, 4)
        icon.Size = UDim2.fromOffset(SLOT - 18, SLOT - 18)
        icon.ScaleType = Enum.ScaleType.Fit
        icon.Parent = b

        local name = Instance.new("TextLabel")
        name.Name = "ToolName"
        name.BackgroundTransparency = 1
        name.Font = Enum.Font.GothamBold
        name.TextColor3 = Color3.new(1, 1, 1)
        name.TextStrokeTransparency = 0.5
        name.TextWrapped = true
        name.TextTruncate = Enum.TextTruncate.AtEnd
        name.Parent = b

        local num = Instance.new("TextLabel")
        num.Name = "Num"
        num.BackgroundTransparency = 1
        num.Position = UDim2.fromOffset(4, 2)
        num.Size = UDim2.fromOffset(14, 12)
        num.Font = Enum.Font.GothamBold
        num.TextSize = 11
        num.TextColor3 = Color3.fromRGB(190, 190, 205)
        num.TextStrokeTransparency = 0.4
        num.TextXAlignment = Enum.TextXAlignment.Left
        num.Visible = not TOUCH
        num.ZIndex = 3
        num.Parent = b

        b.Activated:Connect(function()
            -- the release at the end of a drag isn't a click
            if os.clock() - (dragEndAt or 0) < 0.15 then return end
            toggle(t)
        end)
        b.InputBegan:Connect(function(input)
            local ty = input.UserInputType
            if ty == Enum.UserInputType.MouseButton1 or ty == Enum.UserInputType.Touch then
                press = { tool = t, button = b, from = Vector2.new(input.Position.X, input.Position.Y) }
            end
        end)
        return b
    end

    local function paint(b, t)
        local tex = t.TextureId
        local hasIcon = type(tex) == "string" and tex ~= ""
        b.Icon.Image = hasIcon and tex or ""
        b.Icon.Visible = hasIcon
        local name = b.ToolName
        name.Text = t.Name
        if hasIcon then
            -- small caption under the icon
            name.Position = UDim2.new(0, 2, 1, -13)
            name.Size = UDim2.new(1, -4, 0, 12)
            name.TextSize = 9
            name.TextWrapped = false
        else
            -- no icon: the name fills the slot
            name.Position = UDim2.fromOffset(3, 3)
            name.Size = UDim2.new(1, -6, 1, -6)
            name.TextSize = TOUCH and 11 or 10
            name.TextWrapped = true
        end
    end

    refresh = function()
        -- drop tools that left, the rest in your order (first-seen breaks ties)
        local kept, at = {}, {}
        for i, t in ipairs(seen) do
            if owned(t) then
                kept[#kept + 1] = t
                at[t] = i
            elseif slots[t] then
                slots[t]:Destroy()
                slots[t] = nil
            end
        end
        seen = kept
        order = table.clone(kept)
        table.sort(order, function(a, b)
            local ra, rb = rankOf(a), rankOf(b)
            if ra ~= rb then return ra < rb end
            return at[a] < at[b]
        end)
        bar.Visible = #order > 0
        local c = char()
        for i, t in ipairs(order) do
            local b = slots[t]
            if not b then
                b = makeSlot(t)
                slots[t] = b
            end
            paint(b, t)
            b.LayoutOrder = i
            b.Num.Text = i <= 9 and tostring(i) or (i == 10 and "0" or "")
            b.Sel.Enabled = c ~= nil and t.Parent == c
            b.BackgroundColor3 = b.Sel.Enabled and Color3.fromRGB(58, 52, 80) or Color3.fromRGB(40, 40, 48)
        end
        resize()
    end

    local function add(t)
        if t:IsA("Tool") and not table.find(seen, t) then
            seen[#seen + 1] = t
            -- icon / name can change right after the tool is given
            t:GetPropertyChangedSignal("TextureId"):Connect(function() task.defer(refresh) end)
        end
        task.defer(refresh)
    end

    local hooked = setmetatable({}, { __mode = "k" })
    local function watch(container)
        if not container or hooked[container] then return end
        hooked[container] = true
        for _, t in ipairs(container:GetChildren()) do add(t) end
        container.ChildAdded:Connect(add)
        container.ChildRemoved:Connect(function() task.defer(refresh) end)
    end

    watch(LP:FindFirstChildOfClass("Backpack"))
    if LP.Character then watch(LP.Character) end
    LP.ChildAdded:Connect(function(c) if c:IsA("Backpack") then watch(c) end end)
    LP.CharacterAdded:Connect(function(c)
        watch(c)
        task.defer(refresh)
    end)
    pcall(function()
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
    end)

    -- drag: hold a slot, move it, let go over another slot -> they swap
    local function slotAt(pos)
        for t, b in pairs(slots) do
            local p, sz = b.AbsolutePosition, b.AbsoluteSize
            if pos.X >= p.X and pos.X <= p.X + sz.X and pos.Y >= p.Y and pos.Y <= p.Y + sz.Y then
                return t
            end
        end
    end
    local function dragTo(pos)
        if not ghost then
            if (pos - press.from).Magnitude < 8 then return end
            ghost = press.button:Clone()
            for _, d in ipairs(ghost:GetDescendants()) do
                if d:IsA("LuaSourceContainer") then d:Destroy() end
            end
            ghost.Size = UDim2.fromOffset(SLOT, SLOT)
            ghost.AnchorPoint = Vector2.new(0.5, 0.5)
            ghost.BackgroundTransparency = 0.3
            ghost.ZIndex = 10
            ghost.Parent = gui
            press.button.BackgroundTransparency = 0.7
            scroll.ScrollingEnabled = false
        end
        local inset = gui.IgnoreGuiInset and Vector2.zero or game:GetService("GuiService"):GetGuiInset()
        ghost.Position = UDim2.fromOffset(pos.X - inset.X, pos.Y - inset.Y)
    end
    UIS.InputChanged:Connect(function(input)
        if not press then return end
        local ty = input.UserInputType
        if ty == Enum.UserInputType.MouseMovement or ty == Enum.UserInputType.Touch then
            dragTo(Vector2.new(input.Position.X, input.Position.Y))
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if not press then return end
        local ty = input.UserInputType
        if ty ~= Enum.UserInputType.MouseButton1 and ty ~= Enum.UserInputType.Touch then return end
        local p = press
        press = nil
        if not ghost then return end
        ghost:Destroy()
        ghost = nil
        dragEndAt = os.clock()
        scroll.ScrollingEnabled = true
        if p.button.Parent then p.button.BackgroundTransparency = 0 end
        local other = slotAt(Vector2.new(input.Position.X, input.Position.Y))
        if other and other ~= p.tool then
            local a, b = rankOf(p.tool), rankOf(other)
            names[a], names[b] = names[b], names[a]
            save()
            refresh()
        end
    end)

    -- number keys: slot n = key n. the game's own hotbar is off, so these are ours
    UIS.InputBegan:Connect(function(input, gpe)
        if gpe or UIS:GetFocusedTextBox() then return end
        local i = KEYS[input.KeyCode]
        if i and order[i] then toggle(order[i]) end
    end)

    refresh()
end

-- ============================================================ NUKE
-- empties cosmetic / unused folders in ReplicatedStorage (folders stay).
-- TraitsPerAnimal and Animations are never touched
local NUKE_EMPTY = {          -- path from ReplicatedStorage -> destroy children
    { "Models", "TsunamiWaves" },
    { "Models", "Events" },
    { "Models", "FishingRods" },
    { "LuckIcons" },
    { "RNGMachineVFX" },
    { "GlossaryBackground" },
    { "AnimationGraphEditor" },
    -- blocked controllers' content (bloat scan + checked against the code
    -- that still runs: nothing kept reads these)
    { "Controllers", "EventController", "Events" },              -- ~33.5k: every event map / stage / vfx (but NUKE_KEEP)
    { "Controllers", "SantaMerchantController", "SpawnEffects" },
    { "Controllers", "BeeMerchantController", "SpawnEffects" },
    { "Controllers", "BrainrotTraderController", "SpawnEffects" },
    { "Vfx", "LiveSoccerBursts" },                                -- ~2.9k
}

-- event modules the nuke leaves alone: they require Shared.Snapshot (belt
-- brainrot movement), see emptyChild
local NUKE_KEEP = {
    ["Water"] = true, ["North Pole"] = true, ["Dul Dul Dul"] = true,
    ["Karkerkar Kurkur"] = true, ["Los Matteos"] = true,
    ["Chicleteira Bicicleteira"] = true, ["Sammyni Spyderini"] = true,
}

-- GUIs of blocked features
local NUKE_GUIS = {
    CoinsShop = true, BrainrotTrader = true, Merchant = true, HauntedBase = true,
    TacoBase = true, TacoMerchant = true, TradeLiveTrade = true, SurfaceGui = true,
    -- not Index / ValentinesShop: the game waits on them forever
}

if ON.nuke then
    local RS = game:GetService("ReplicatedStorage")

    local function dropGui(g)
        if NUKE_GUIS[g.Name] and (g:IsA("LayerCollector")) then
            stash(g)
        end
    end
    local function watchGuis(parent)
        parent.ChildAdded:Connect(function(c) task.defer(dropGui, c) end)
        for _, c in ipairs(parent:GetChildren()) do dropGui(c) end
    end
    task.spawn(function()
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        while not lp do task.wait() lp = Players.LocalPlayer end
        local pg = lp:WaitForChild("PlayerGui", 60)
        if pg then watchGuis(pg) end
    end)

    local function emptyChild(c)
        -- these event modules load Snapshot, which makes the belt move
        if NUKE_KEEP[c.Name] and c.Parent and c.Parent.Name == "Events" then return end
        stash(c)
    end

    local function watchEmpty(folder)
        folder.ChildAdded:Connect(function(c) task.defer(emptyChild, c) end)
        for _, c in ipairs(folder:GetChildren()) do emptyChild(c) end
    end

    local function blankIcon(i)
        if i.ClassName == "ImageLabel" and i.Image ~= "" then
            pcall(function() i.Image = "" end)
        end
    end

    local function watchAll(folder, fn)
        folder.DescendantAdded:Connect(function(d) task.defer(fn, d) end)
        for _, d in ipairs(folder:GetDescendants()) do fn(d) end
    end

    -- hook each target as soon as its folder exists
    local pending = {}
    for _, path in ipairs(NUKE_EMPTY) do
        pending[#pending + 1] = { path = path, fn = watchEmpty }
    end
    pending[#pending + 1] = { path = { "ReplicatedGui" }, fn = function(f)
        watchGuis(f)
        watchAll(f, blankIcon)
    end }

    local function resolve(path)
        local cur = RS
        for _, n in ipairs(path) do
            cur = cur:FindFirstChild(n)
            if not cur then return nil end
        end
        return cur
    end

    local function tryAll()
        for i = #pending, 1, -1 do
            local f = resolve(pending[i].path)
            if f then
                local job = table.remove(pending, i)
                pcall(job.fn, f)
            end
        end
        return #pending == 0
    end

    if not tryAll() then
        local cn
        -- only re-check when something with a target's name shows up
        local names = {}
        for _, job in ipairs(pending) do names[job.path[#job.path]] = true end
        cn = RS.DescendantAdded:Connect(function(d)
            if names[d.Name] then
                if tryAll() then cn:Disconnect() end
            end
        end)
        -- the game's GUIs get moved into PlayerGui; icons there too
        task.spawn(function()
            if not game:IsLoaded() then game.Loaded:Wait() end
            task.wait(2)
            if cn.Connected then tryAll() cn:Disconnect() end
        end)
    end
end

-- ============================================================ QUIET
-- game sounds blanked (never downloaded), cosmetic scripts switched off
local QUIET_SCRIPTS = {   -- script name -> name of its parent (or a set of names)
    EclipseOrbit = "Client", PhantomSequence = "Client",
    StarburstRotate = "Observers", ScrollingTextureObserver = "Observers",
    EmitThroughPartObserver = "Observers", WaveriderBoostBeamsObserver = "Observers",
    PortalScript = "Portal", CameraShake = "Client",
    Analytics = "UserGenerated",   -- ReplicatedFirst's telemetry starter
    -- shop NPCs: idle anim + prompt that opens CoinsShop / Shop (hidden anyway)
    Npc = { ShopNPCCash = true, ShopNPCRobuxIdle = true },
}
local QUIET_PARENT_SCRIPTS = { Sammy = true, Gone = true }   -- generic "Script" children
-- every script anywhere under these goes off: folder name -> name of its
-- parent (true = any parent). telemetry senders, event-map loops, npc rigs
local QUIET_ZONES = {
    -- telemetry (FastFlags stays: game code reads its flags)
    Analytics = "UserGenerated", Logging = "UserGenerated", Observability = "UserGenerated",
    Events = { EventController = true, Workspace = true },
    LosTraders = "Workspace", EventBoard = "Workspace",
    JumpLTMMachine = "Workspace", TradePlazaPortal = "Workspace",
}

if ON.quiet then
    local SCRIPT = { Script = true, LocalScript = true }

    -- only scripts get here (a few hundred), so the ancestor walk is cheap
    local function inZone(d)
        local x = d.Parent
        while x and x.Parent do
            local zone = QUIET_ZONES[x.Name]
            if zone then
                local pn = x.Parent == workspace and "Workspace" or x.Parent.Name
                if zone == true or zone == pn or (type(zone) == "table" and zone[pn]) then
                    return true
                end
            end
            x = x.Parent
        end
        return false
    end

    local function quiet(d)
        local cn = d.ClassName
        if cn == "Sound" then
            if d.SoundId ~= "" and not isOurs(d) then
                pcall(function() d.SoundId = "" end)
            end
        elseif SCRIPT[cn] then
            local p = d.Parent
            local want = QUIET_SCRIPTS[d.Name]
            local hit = want and p and (p.Name == want or (type(want) == "table" and want[p.Name]))
            if hit or (d.Name == "Script" and p and QUIET_PARENT_SCRIPTS[p.Name]) or inZone(d) then
                pcall(function() d.Enabled = false end)
            end
        end
    end

    -- straight from the signal (not the work queue): a script has to be
    -- switched off before it gets to run
    local function watch(root)
        for _, d in ipairs(root:GetDescendants()) do quiet(d) end
        root.DescendantAdded:Connect(quiet)
    end
    watch(game:GetService("ReplicatedFirst"))
    watch(game:GetService("ReplicatedStorage"))
    watch(workspace)
    pcall(watch, game:GetService("SoundService"))
    -- the game's GUIs (button / notification sounds), never a hub's
    task.spawn(function()
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        while not lp do task.wait() lp = Players.LocalPlayer end
        local pg = lp:WaitForChild("PlayerGui", 60)
        if not pg then return end
        local function inGame(d) if d.ClassName == "Sound" and inGameGui(d, pg) then quiet(d) end end
        for _, d in ipairs(pg:GetDescendants()) do inGame(d) end
        pg.DescendantAdded:Connect(inGame)
    end)
end

-- ============================================================ PLOT CLEAN
-- world animations stopped (yours and the belt's keep going), world GUIs
-- off (income / signs / timer kept), plot brainrots invisible
if ON.plotclean then
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    while not LP do task.wait() LP = Players.LocalPlayer end


    local function mine(o)
        local c = LP.Character
        return c ~= nil and o:IsDescendantOf(c)
    end
    -- the carpet (belt) brainrots keep walking: frozen they look stuck in place
    local function onBelt(o)
        local belt = workspace:FindFirstChild("RenderedMovingAnimals")
        return belt ~= nil and o:IsDescendantOf(belt)
    end

    local function stopTracks(a)
        a.AnimationPlayed:Connect(function(t)
            -- checked again per track: a model can end up on the belt later
            if onBelt(a) or mine(a) then return end
            pcall(t.Stop, t, 0)
        end)
        for _, t in ipairs(a:GetPlayingAnimationTracks()) do pcall(t.Stop, t, 0) end
    end

    local function keepGui(g)
        -- its timer would keep it otherwise
        if g:FindFirstAncestor("IncubatorMachine") then return false end
        if g.Name == "YourBase" or g:FindFirstChild("Traits") then return true end
        if g:FindFirstAncestor("PlotSign") then return true end
        local ok, timer = pcall(g.FindFirstChild, g, "RemainingTime", true)
        if ok and timer then return true end
        return isOurs(g)
    end

    local function handle(o)
        local cn = o.ClassName
        if cn == "Animator" then
            if not mine(o) and not onBelt(o) then stopTracks(o) end
        elseif cn == "BillboardGui" or cn == "SurfaceGui" then
            -- overheads get their Traits child a moment after they're made
            task.delay(0.5, function()
                if o.Parent and not keepGui(o) then
                    switchOff(o)
                end
            end)
        end
    end

    local WANT = { Animator = true, BillboardGui = true, SurfaceGui = true }
    for _, o in ipairs(workspace:GetDescendants()) do
        if WANT[o.ClassName] then pcall(handle, o) end
    end
    workspace.DescendantAdded:Connect(function(o)
        if WANT[o.ClassName] then QUEUE(handle, o) end
    end)

    -- plot brainrots: invisible from the frame they appear (client only,
    -- model / overhead / plot data untouched). belt ones aren't in a plot

    local function isBrainrot(m)
        if not m:IsA("Model") or not m:FindFirstChild("AnimationController") then return false end
        local any = false
        for _, d in ipairs(m:GetDescendants()) do
            if d:IsA("BasePart") then
                if d.CanCollide or d.CanQuery or not d.Massless then return false end
                any = true
            end
        end
        return any
    end

    local function hide(d)
        if d:IsA("BasePart") then d.LocalTransparencyModifier = 1 end
    end

    local function hideBrainrot(m)
        for _, d in ipairs(m:GetDescendants()) do hide(d) end
        -- traits / mutations / the humanoid swap add parts later
        m.DescendantAdded:Connect(hide)
    end

    local function watchPlot(plot)
        local function check(c)
            -- PlotClient sets CanCollide etc. on the clone before parenting it,
            -- so this works straight from ChildAdded (no frame where it's drawn)
            if isBrainrot(c) and not isOurs(c) then pcall(hideBrainrot, c) end
        end
        plot.ChildAdded:Connect(check)
        for _, c in ipairs(plot:GetChildren()) do check(c) end
    end

    -- event maps (workspace.Events): invisible for you only, collisions and
    -- the parts themselves untouched (event code indexes them by name)
    task.spawn(function()
        local ev = workspace:WaitForChild("Events", 90)
        if not ev then return end
        local function hideEv(d)
            if d:IsA("BasePart") and not isOurs(d) then d.LocalTransparencyModifier = 1 end
        end
        for _, d in ipairs(ev:GetDescendants()) do hideEv(d) end
        ev.DescendantAdded:Connect(hideEv)
    end)

    task.spawn(function()
        local plots = workspace:WaitForChild("Plots", 90)
        if not plots then return end
        plots.ChildAdded:Connect(watchPlot)
        for _, p in ipairs(plots:GetChildren()) do watchPlot(p) end
    end)
end

-- ============================================================ CONTROLLER BLOCK
-- these controllers are pulled out before the game's loader sees them, so
-- they never start. require() is never hooked (that breaks the game).
local BLOCKED_CONTROLLERS = {
    -- events / limited-time
    EclipseEventController = true, LiveSoccerEventController = true,
    ThanksgivingTurkeyController = true, TacoDropController = true,
    JumpLTMController = true, JumpLTMLevelController = true, JumpLTMPlotUIController = true,
    GlobalCountdownController = true, RSVPController = true, PollController = true,
    -- machines
    RNGMachineController = true, FuseMachineController = true, CraftingMachineController = true,
    TraitIncubatorController = true, PoleGameController = true, PinataController = true,
    -- trading
    TradeController = true, TradePlazaServerBrowserController = true, TradePlazaSignController = true,
    TradePlazaPortalController = true, BrainrotTraderController = true, SelectBrainrotsController = true,
    -- shops / merchants
    MerchantController = true, SantaMerchantController = true,
    BeeMerchantController = true, TacoMerchantController = true, ShovelShopController = true,
    CoinsShopController = true, RodsShopController = true, CodesController = true,
    -- menus / boards / cosmetic
    GlossaryController = true, IndexController = true, BaseIndexController = true,
    BasePreviewController = true, LeaderboardController = true, LiveboardController = true,
    AdminboardController = true, SkullEmojiEffectController = true,
    RainbowController = true, NewPlayersController = true, FTUEController = true,
    -- duels / fishing
    DuelsMachineMatchController = true,     -- background asset preloads
    BrainrotPreloadingController = true,
    -- nothing that still runs uses these (dependency check over the dump)
    ABTestController = true, ChatController = true, TextChatController = true,
    ClientAnimationsController = true, EffectController = true, FavoriteController = true,
    LightingController = true, MultiJumpController = true, PlayerOverheadController = true,
    SettingsController = true, DuelsMachineController = true, VFXController = true,
    VoiceChatController = true, FishingController = true,
}

-- late (hub run by hand): the controllers are already running and kept code
-- still requires some of them by path, so pulling them now would only break it
if ON.controllerblock and not LATE then
    local RS = game:GetService("ReplicatedStorage")

    -- decoys: once the game's loader has passed, they're put back (unstarted)
    local pulled, folder, addCn = {}, nil, nil

    local function pull(m)
        if BLOCKED_CONTROLLERS[m.Name] and m:IsA("ModuleScript") then
            pulled[#pulled + 1] = m
            stash(m)
        end
    end

    local function watch(f)
        folder = f
        addCn = f.ChildAdded:Connect(function(c) task.defer(pull, c) end)
        for _, c in ipairs(f:GetChildren()) do pull(c) end
    end

    local ctrl = RS:FindFirstChild("Controllers")
    if ctrl then
        watch(ctrl)
    else
        local cn
        cn = RS.ChildAdded:Connect(function(c)
            if c.Name == "Controllers" then
                cn:Disconnect()
                watch(c)
            end
        end)
    end

    task.spawn(function()
        workspace:WaitForChild("Plots", 120)
        local rg = RS:WaitForChild("ReplicatedGui", 120)
        -- ReplicatedGui empty = the game's loader just took its snapshot
        if rg and #rg:GetChildren() > 0 then
            local done = false
            local cn = rg.ChildRemoved:Connect(function()
                if #rg:GetChildren() == 0 then done = true end
            end)
            local give = os.clock() + 120
            while not done and rg.Parent and os.clock() < give do task.wait() end
            cn:Disconnect()
        end
        task.wait()
        if addCn then addCn:Disconnect() end
        local back = 0
        for _, m in ipairs(pulled) do
            if folder and m.Parent == STASH then
                pcall(function() m.Parent = folder end)
                back += 1
            end
        end
    end)
end

-- ============================================================ FAST REJOIN / HOP
-- F6 rejoin (private servers too), F7 hop, F8 your private server
-- (link in workspace/skyr0_hub_pscode.txt)
local ACTIONS = { run = function() end }
local REJOIN_KEY = Enum.KeyCode.F6
local HOP_KEY = Enum.KeyCode.F7
local PS_KEY = Enum.KeyCode.F8

task.spawn(function()
    local Players = game:GetService("Players")
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local UIS = game:GetService("UserInputService")
    local lp = Players.LocalPlayer
    while not lp do task.wait() lp = Players.LocalPlayer end

    local busy = false
    local psFallback = false

    -- private server link code: same file the old hub saves it in.
    -- accepts the full share link (...privateServerLinkCode=XXXX) or just the code
    local PS_FILE = "skyr0_hub_pscode.txt"
    local function psCode()
        local ok, raw = pcall(function() return isfile(PS_FILE) and readfile(PS_FILE) end)
        if not ok or type(raw) ~= "string" then return nil end
        raw = raw:gsub("%s+", "")
        local code = raw:match("[?&]privateServerLinkCode=([%w%-_]+)") or raw:match("[?&]linkCode=([%w%-_]+)")
        if code then return code end
        -- a 32-char hex "code=" from a share link isn't a link code
        if raw:match("[?&]code=") or (#raw == 32 and raw:match("^[0-9a-f]+$")) then return nil end
        return raw:match("^[%w%-_]+$")
    end

    local function joinPS()
        local code = psCode()
        if not code then
            warn("[skyr0 loader] no private server link code in workspace/" .. PS_FILE)
            return false
        end
        local ok = pcall(function()
            game:GetService("ExperienceService"):LaunchExperience({ placeId = game.PlaceId, linkCode = code })
        end)
        if ok then return true end
        return pcall(function() TeleportService:TeleportToPrivateServer(game.PlaceId, code, { lp }) end)
    end

    local function rejoin()
        -- private server: plain Teleport to the place (Ninja Hub's "Rejoin PS").
        -- if roblox refuses, TeleportInitFailed falls back to the saved link code
        if game.PrivateServerId ~= "" then
            psFallback = true
            TeleportService:Teleport(game.PlaceId, lp)
            return
        end
        if #Players:GetPlayers() <= 1 then
            -- alone: the server shuts down when we leave, take any server
            TeleportService:Teleport(game.PlaceId, lp)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
        end
    end

    local function hop()
        local cursor = ""
        for _ = 1, 5 do
            local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100%s")
                :format(game.PlaceId, cursor ~= "" and "&cursor=" .. cursor or "")
            local ok, data = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
            if not ok or type(data) ~= "table" then break end
            local pick = {}
            for _, s in ipairs(data.data or {}) do
                if s.id ~= game.JobId and s.playing and s.maxPlayers and s.playing < s.maxPlayers - 1 then
                    pick[#pick + 1] = s.id
                end
            end
            if #pick > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, pick[math.random(#pick)], lp)
                return
            end
            cursor = data.nextPageCursor
            if not cursor then break end
        end
        warn("[skyr0 loader] no open server found, rejoining instead")
        rejoin()
    end

    TeleportService.TeleportInitFailed:Connect(function(player, result, msg)
        if player ~= lp then return end
        warn("[skyr0 loader] teleport failed: " .. tostring(result) .. " " .. tostring(msg))
        if psFallback then
            psFallback = false
            if psCode() then
                print("[skyr0 loader] trying the saved private server link instead")
                if joinPS() then return end
            end
        end
        busy = false
    end)

    ACTIONS.run = function(kind)
        if busy then return end
        busy = true
        if kind == "rejoin" then
            print("[skyr0 loader] rejoining")
            if not pcall(rejoin) then busy = false end
        elseif kind == "ps" then
            print("[skyr0 loader] joining private server")
            if not joinPS() then busy = false end
        elseif kind == "hop" then
            print("[skyr0 loader] server hopping")
            if not pcall(hop) then busy = false end
        else
            busy = false
        end
    end

    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == REJOIN_KEY then
            ACTIONS.run("rejoin")
        elseif input.KeyCode == PS_KEY then
            ACTIONS.run("ps")
        elseif input.KeyCode == HOP_KEY then
            ACTIONS.run("hop")
        end
    end)
end)

-- ============================================================ COREGUI REBUILD
-- roblox's UI off; own Leave button, chat ("/") and player list (Tab)
if ON.coregui then
    local Players = game:GetService("Players")
    local StarterGui = game:GetService("StarterGui")
    local UIS = game:GetService("UserInputService")
    local TextChatService = game:GetService("TextChatService")
    local LP = Players.LocalPlayer
    while not LP do task.wait() LP = Players.LocalPlayer end

    local BG = Color3.fromRGB(18, 18, 22)
    local CELL = Color3.fromRGB(40, 40, 48)
    local ACCENT = Color3.fromRGB(120, 90, 255)
    local TOUCH = UIS.TouchEnabled

    -- ---------------------------------------------------------- roblox's gui off
    local function coreOff()
        pcall(StarterGui.SetCoreGuiEnabled, StarterGui, Enum.CoreGuiType.All, false)
        pcall(StarterGui.SetCore, StarterGui, "TopbarEnabled", false)
        for _, name in ipairs({ "ChatWindowConfiguration", "ChatInputBarConfiguration",
            "ChannelTabsConfiguration", "BubbleChatConfiguration" }) do
            local cfg = TextChatService:FindFirstChild(name)
            if cfg then pcall(function() cfg.Enabled = false end) end
        end
    end
    task.spawn(function()
        -- the game and roblox flip some of these back on while loading
        for _ = 1, 30 do
            coreOff()
            task.wait(1)
        end
    end)

    -- roblox's own GUIs only (any hub's are left alone); Esc menu, prompts
    -- and the dev console stay
    local ROBLOX_CORE = {
        RobloxGui = true, TopBarApp = true, TopBar = true, TopBarStandalone = true,
        UnibarMenu = true, PlayerList = true, PlayerListMaster = true,
        ExperienceChat = true, BubbleChat = true, Chat = true, EmotesMenu = true,
        Backpack = true, ThemeProvider = true, HeadsetDisconnectedDialog = true,
        RobloxNetworkPauseNotification = true, TeleportGui = true, CaptureOverlay = true,
        CaptureNotification = true, ScreenshotHud = true, FTUXMenu = true,
        AvatarEditorPromptsApp = true, SelfView = true, SelfViewApp = true,
        VRGui = true, ContextActionGui = true, ConnectionHealth = true,
        ToastNotifications = true, NotificationScreenGui = true, TrustAndSafety = true,
        InspectAndBuy = true, BlockingModalScreen = true, VoiceChatPrompt = true,
        PermissionsPrompts = true, RoactAppExperimentProvider = true,
    }
    local CORE_KEEP = {
        InGameMenu = true, RobloxPromptGui = true, PurchasePromptApp = true,
        PurchasePrompt = true, DevConsoleMaster = true, RobloxLoadingGUI = true,
        ScreenshotHud = false,
    }
    task.spawn(function()
        local core
        pcall(function() core = game:GetService("CoreGui") end)
        if not core then return end
        local hiddenRoot
        pcall(function() hiddenRoot = gethui and gethui() end)
        -- some executors' gethui IS CoreGui: then only the Skyr0 names protect
        if hiddenRoot == core then hiddenRoot = nil end
        local hidden = {}
        local function ours(g)
            if g.Name:sub(1, 5) == "Skyr0" then return true end
            if hiddenRoot and (g == hiddenRoot or hiddenRoot:IsDescendantOf(g) or g:IsDescendantOf(hiddenRoot)) then
                return true
            end
            -- not roblox's own app = a hub's gui: leave it
            local top = g
            while top.Parent and top.Parent ~= core do top = top.Parent end
            if not ROBLOX_CORE[top.Name] then
                return true
            end
            return false
        end
        local function keepOff(g)
            if g.Enabled then
                pcall(function() g.Enabled = false end)
            end
        end
        local function off(g)
            if not g:IsA("LayerCollector") or CORE_KEEP[g.Name] or ours(g) or hidden[g] then return end
            -- the Esc menu / prompts can sit under another gui: leave those trees
            local x = g.Parent
            while x and x ~= core do
                if CORE_KEEP[x.Name] then return end
                x = x.Parent
            end
            hidden[g] = true
            keepOff(g)
            pcall(function()
                g:GetPropertyChangedSignal("Enabled"):Connect(function() keepOff(g) end)
            end)
        end
        local function hideRobloxGuiParts()
            local rg = core:FindFirstChild("RobloxGui")
            if not rg then return end
            for _, c in ipairs(rg:GetChildren()) do
                if c:IsA("GuiObject") and not CORE_KEEP[c.Name] and c.Name ~= "SettingsClippingShield"
                    and c.Name ~= "SettingsShield" and c.Name ~= "Modules" then
                    pcall(function() c.Visible = false end)
                end
            end
        end
        -- every gui anywhere in CoreGui, now and later (through the work queue)
        for _, d in ipairs(core:GetDescendants()) do
            if d:IsA("LayerCollector") then off(d) end
        end
        hideRobloxGuiParts()
        pcall(function()
            core.DescendantAdded:Connect(function(d)
                if d:IsA("LayerCollector") then QUEUE(off, d) end
            end)
        end)
        task.delay(10, hideRobloxGuiParts)
        -- roblox rebuilds bits of RobloxGui (menu icon etc.) when it feels like it
        while true do
            task.wait(3)
            hideRobloxGuiParts()
        end
    end)

    -- ---------------------------------------------------------- helpers
    local root
    pcall(function() root = gethui and gethui() end)
    if not root then pcall(function() root = game:GetService("CoreGui") end) end
    local function screen(name, order)
        local g = Instance.new("ScreenGui")
        g.Name = name
        g.ResetOnSpawn = false
        g.IgnoreGuiInset = true
        g.DisplayOrder = order
        if not pcall(function() g.Parent = root end) or not g.Parent then
            g.Parent = LP:WaitForChild("PlayerGui")
        end
        return g
    end
    local function corner(o, r) Instance.new("UICorner", o).CornerRadius = UDim.new(0, r or 8) end
    local function button(parent, text, w)
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromOffset(w, TOUCH and 26 or 24)
        b.BackgroundColor3 = CELL
        b.BorderSizePixel = 0
        b.Font = Enum.Font.GothamBold
        b.TextSize = 11
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Text = text
        b.Parent = parent
        corner(b, 6)
        return b
    end

    -- ---------------------------------------------------------- top bar
    local topGui = screen("Skyr0Topbar", 160)
    local top = Instance.new("Frame")
    top.AnchorPoint = Vector2.new(0.5, 0)
    top.Position = UDim2.new(0.5, 0, 0, 6)
    top.Size = UDim2.fromOffset(0, TOUCH and 34 or 32)
    top.AutomaticSize = Enum.AutomaticSize.X
    top.BackgroundColor3 = BG
    top.BackgroundTransparency = 0.25
    top.BorderSizePixel = 0
    top.Parent = topGui
    corner(top, 8)
    local tp = Instance.new("UIPadding", top)
    tp.PaddingLeft, tp.PaddingRight = UDim.new(0, 4), UDim.new(0, 4)
    local tl = Instance.new("UIListLayout", top)
    tl.FillDirection = Enum.FillDirection.Horizontal
    tl.Padding = UDim.new(0, 4)
    tl.VerticalAlignment = Enum.VerticalAlignment.Center
    tl.SortOrder = Enum.SortOrder.LayoutOrder

    -- just Leave (the inventory bar is its own panel)
    local bLeave = button(top, "Leave", 50)
    bLeave.BackgroundColor3 = Color3.fromRGB(150, 45, 55)

    bLeave.Activated:Connect(function()
        if not pcall(function() game:Shutdown() end) then
            pcall(function() LP:Kick("left") end)
        end
    end)

    -- ---------------------------------------------------------- chat
    local chatGui = screen("Skyr0Chat", 155)
    local chat = Instance.new("Frame")
    chat.AnchorPoint = Vector2.new(0, 1)
    chat.Position = UDim2.new(0, 8, 1, TOUCH and -150 or -90)
    chat.Size = UDim2.fromOffset(TOUCH and 280 or 360, TOUCH and 150 or 190)
    chat.BackgroundColor3 = BG
    chat.BackgroundTransparency = 0.35
    chat.BorderSizePixel = 0
    chat.Parent = chatGui
    corner(chat, 8)

    local log = Instance.new("ScrollingFrame")
    log.Position = UDim2.fromOffset(6, 6)
    log.Size = UDim2.new(1, -12, 1, -40)
    log.BackgroundTransparency = 1
    log.BorderSizePixel = 0
    log.ScrollBarThickness = 3
    log.AutomaticCanvasSize = Enum.AutomaticSize.Y
    log.CanvasSize = UDim2.new()
    log.Parent = chat
    local ll = Instance.new("UIListLayout", log)
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Padding = UDim.new(0, 2)

    local box = Instance.new("TextBox")
    box.Position = UDim2.new(0, 6, 1, -30)
    box.Size = UDim2.new(1, -12, 0, 24)
    box.BackgroundColor3 = CELL
    box.BorderSizePixel = 0
    box.ClearTextOnFocus = false
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.TextColor3 = Color3.new(1, 1, 1)
    box.PlaceholderText = TOUCH and "tap to chat" or "press / to chat"
    box.PlaceholderColor3 = Color3.fromRGB(150, 150, 160)
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.Text = ""
    box.Parent = chat
    corner(box, 6)
    Instance.new("UIPadding", box).PaddingLeft = UDim.new(0, 6)

    local lines, n = {}, 0
    local function addLine(name, text, color)
        n += 1
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.Size = UDim2.new(1, -4, 0, 0)
        l.AutomaticSize = Enum.AutomaticSize.Y
        l.Font = Enum.Font.Gotham
        l.TextSize = 12
        l.TextWrapped = true
        l.RichText = true
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextColor3 = Color3.fromRGB(230, 230, 235)
        local safe = tostring(text):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
        if name then
            local hex = (color or ACCENT):ToHex()
            local nm = tostring(name):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
            l.Text = ('<font color="#%s"><b>%s:</b></font> %s'):format(hex, nm, safe)
        else
            l.TextColor3 = Color3.fromRGB(160, 160, 170)
            l.Text = safe
        end
        l.LayoutOrder = n
        l.Parent = log
        lines[#lines + 1] = l
        if #lines > 60 then table.remove(lines, 1):Destroy() end
        task.defer(function() log.CanvasPosition = Vector2.new(0, 1e6) end)
    end

    local function nameColor(userId)
        local hues = { 0.0, 0.08, 0.15, 0.33, 0.5, 0.6, 0.75, 0.88 }
        return Color3.fromHSV(hues[(userId % #hues) + 1], 0.55, 1)
    end

    pcall(function()
        TextChatService.MessageReceived:Connect(function(msg)
            local src = msg.TextSource
            if src then
                local plr = Players:GetPlayerByUserId(src.UserId)
                addLine(plr and plr.DisplayName or src.Name, msg.Text, nameColor(src.UserId))
            else
                addLine(nil, msg.Text)
            end
        end)
    end)

    local function send(text)
        text = text:gsub("^%s+", ""):gsub("%s+$", "")
        if text == "" then return end
        local ok = pcall(function()
            local ch = TextChatService:FindFirstChild("TextChannels")
            ch = ch and ch:FindFirstChild("RBXGeneral")
            ch:SendAsync(text)
        end)
        if not ok then
            -- legacy chat
            pcall(function()
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents
                    .SayMessageRequest:FireServer(text, "All")
            end)
        end
    end
    box.FocusLost:Connect(function(enter)
        if enter then
            send(box.Text)
            box.Text = ""
        end
    end)

    -- ---------------------------------------------------------- player list
    local plGui = screen("Skyr0Players", 155)
    local pl = Instance.new("Frame")
    pl.AnchorPoint = Vector2.new(1, 0)
    pl.Position = UDim2.new(1, -8, 0, 46)
    pl.Size = UDim2.fromOffset(200, 0)
    pl.AutomaticSize = Enum.AutomaticSize.Y
    pl.BackgroundColor3 = BG
    pl.BackgroundTransparency = 0.25
    pl.BorderSizePixel = 0
    pl.Visible = false
    pl.Parent = plGui
    corner(pl, 8)
    local pp = Instance.new("UIPadding", pl)
    pp.PaddingTop, pp.PaddingBottom = UDim.new(0, 6), UDim.new(0, 6)
    pp.PaddingLeft, pp.PaddingRight = UDim.new(0, 8), UDim.new(0, 8)
    local pll = Instance.new("UIListLayout", pl)
    pll.SortOrder = Enum.SortOrder.LayoutOrder
    pll.Padding = UDim.new(0, 2)

    local function refreshPlayers()
        for _, c in ipairs(pl:GetChildren()) do
            if c:IsA("TextLabel") then c:Destroy() end
        end
        local all = Players:GetPlayers()
        table.sort(all, function(a, b) return a.DisplayName:lower() < b.DisplayName:lower() end)
        local head = Instance.new("TextLabel")
        head.BackgroundTransparency = 1
        head.Size = UDim2.new(1, 0, 0, 16)
        head.Font = Enum.Font.GothamBold
        head.TextSize = 12
        head.TextColor3 = Color3.fromRGB(170, 170, 185)
        head.TextXAlignment = Enum.TextXAlignment.Left
        head.Text = ("%d players"):format(#all)
        head.LayoutOrder = 0
        head.Parent = pl
        for i, p in ipairs(all) do
            local l = Instance.new("TextLabel")
            l.BackgroundTransparency = 1
            l.Size = UDim2.new(1, 0, 0, 16)
            l.Font = p == LP and Enum.Font.GothamBold or Enum.Font.Gotham
            l.TextSize = 12
            l.TextColor3 = p == LP and ACCENT or Color3.new(1, 1, 1)
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.TextTruncate = Enum.TextTruncate.AtEnd
            l.Text = ("%s  @%s"):format(p.DisplayName, p.Name)
            l.LayoutOrder = i
            l.Parent = pl
        end
    end
    refreshPlayers()
    Players.PlayerAdded:Connect(function(p)
        refreshPlayers()
        addLine(nil, p.DisplayName .. " joined")
    end)
    Players.PlayerRemoving:Connect(function(p)
        task.defer(refreshPlayers)
        addLine(nil, p.DisplayName .. " left")
    end)

    -- ---------------------------------------------------------- keys
    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.Slash then
            chat.Visible = true
            task.defer(function() box:CaptureFocus() box.Text = "" end)
        elseif input.KeyCode == Enum.KeyCode.Tab then
            pl.Visible = not pl.Visible
        end
    end)
end