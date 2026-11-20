-- ============================================================
-- JK HUB
-- Black & Grey edition
-- ============================================================

-- ============================================================
-- JK HUB INTRO
-- Main script starts only after the intro finishes or is skipped.
-- ============================================================
repeat task.wait() until game:IsLoaded()

local _SoundIntroPlayers = game:GetService("Players")
local _SoundIntroRunService = game:GetService("RunService")
local _SoundIntroUIS = game:GetService("UserInputService")
local _SoundIntroLighting = game:GetService("Lighting")
local _SoundIntroSoundService = game:GetService("SoundService")
local _SoundIntroTweenService = game:GetService("TweenService")
local _SoundIntroPlayer = _SoundIntroPlayers.LocalPlayer

local JK_HUB_IMAGE_FILE = "jk_hub_background.jpg"
local function resolveJKHubImage()
    local getter = getcustomasset or getsynasset
    if type(getter) == "function" and type(isfile) == "function" then
        local okFile, exists = pcall(isfile, JK_HUB_IMAGE_FILE)
        if okFile and exists then
            local okAsset, asset = pcall(getter, JK_HUB_IMAGE_FILE)
            if okAsset and type(asset) == "string" and asset ~= "" then
                return asset
            end
        end
    end
    return ""
end

local JK_HUB_BACKGROUND_IMAGE = resolveJKHubImage()
local function jkHubImageUri(value)
    if type(value) ~= "string" or value == "" then return "" end
    if value:match("^rbxasset://") or value:match("^rbxassetid://") or value:match("^https?://") then
        return value
    end
    return "rbxassetid://" .. value
end

local _SOUND_INTRO_MUSIC_URL = "https://files.catbox.moe/sr0t7p.mp3"
local _SOUND_INTRO_MUSIC_FILE = "jkHub_vs_intro_bloodhound.mp3"
local _SOUND_INTRO_MUSIC_VOLUME = 1
local _SOUND_INTRO_FALLBACK_MUSIC_ID = "rbxassetid://9046862121"
-- intro character asset removed

_G._SoundIntroFinished = false
_G._JKHubSkipIntro = false
_G._JKHubIntroActive = true

local function _soundResolveIntroMusicId()
    local assetGetter = getcustomasset or getsynasset
    if type(assetGetter) == "function" and type(writefile) == "function" then
        local exists = false
        if type(isfile) == "function" then
            pcall(function() exists = isfile(_SOUND_INTRO_MUSIC_FILE) end)
        end
        if not exists then
            local ok, data = pcall(function() return game:HttpGet(_SOUND_INTRO_MUSIC_URL) end)
            if ok and type(data) == "string" and #data > 0 then
                pcall(writefile, _SOUND_INTRO_MUSIC_FILE, data)
            end
        end
        local ok, asset = pcall(assetGetter, _SOUND_INTRO_MUSIC_FILE)
        if ok and asset then return asset end
    end
    return _SOUND_INTRO_FALLBACK_MUSIC_ID
end

local function _soundShowIntro(onFinished)
    local introSound
    local function stopIntroMusic()
        if introSound then
            pcall(function() introSound:Stop() end)
            pcall(function() introSound:Destroy() end)
            introSound = nil
        end
    end

    if _G._JKHubIntroCleanup then pcall(_G._JKHubIntroCleanup) end
    local isMobile = _SoundIntroUIS.TouchEnabled and not _SoundIntroUIS.KeyboardEnabled
    local playerGui = _SoundIntroPlayer:WaitForChild("PlayerGui")
    local old = playerGui:FindFirstChild("JKHubIntro")
    if old then old:Destroy() end
    local oldBlur = _SoundIntroLighting:FindFirstChild("JKHubIntroBlur")
    if oldBlur then oldBlur:Destroy() end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "JKHubIntro"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 1000005
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui

    introSound = Instance.new("Sound")
    introSound.Name = "JKHubIntroMusic"
    introSound.SoundId = _soundResolveIntroMusicId()
    introSound.Volume = _SOUND_INTRO_MUSIC_VOLUME
    introSound.Looped = false
    introSound.Parent = _SoundIntroSoundService
    pcall(function() introSound:Play() end)

    local instance = Instance.new("Frame")
    instance.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    instance.BackgroundTransparency = 1
    instance.BorderSizePixel = 0
    instance.Size = UDim2.fromScale(1, 1)
    instance.ZIndex = 1000
    instance.Parent = screenGui

    local introPhoto = Instance.new("ImageLabel")
    introPhoto.Name = "JKHubIntroPhoto"
    introPhoto.Size = UDim2.fromScale(1, 1)
    introPhoto.Position = UDim2.fromScale(0, 0)
    introPhoto.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    introPhoto.BackgroundTransparency = 0
    introPhoto.BorderSizePixel = 0
    introPhoto.Image = JK_HUB_BACKGROUND_IMAGE
    introPhoto.ImageColor3 = Color3.fromRGB(185, 185, 185)
    introPhoto.ImageTransparency = 0.12
    introPhoto.ScaleType = Enum.ScaleType.Crop
    introPhoto.ZIndex = 1000
    introPhoto.Parent = instance

    local rainContainer = Instance.new("Frame")
    rainContainer.Name = "PurpleRain"
    rainContainer.BackgroundTransparency = 1
    rainContainer.Size = UDim2.fromScale(1, 1)
    rainContainer.ZIndex = 1001
    rainContainer.ClipsDescendants = true
    rainContainer.Parent = instance

    local running = true
    local closing = false
    task.spawn(function()
        while running and not closing do
            local drop = Instance.new("Frame")
            drop.BackgroundColor3 = Color3.fromRGB(
                (math.random(1, 3) == 1) and 220 or 140,
                (math.random(1, 3) == 1) and 50 or 140,
                (math.random(1, 3) == 1) and 60 or 170
            )
            drop.BackgroundTransparency = math.random(40, 70) / 100
            drop.BorderSizePixel = 0
            drop.Size = UDim2.fromOffset(math.random(1, 3), math.random(15, 30))
            drop.Position = UDim2.fromScale(math.random(0, 100) / 100, -0.1)
            drop.ZIndex = 1001
            drop.Parent = rainContainer
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = drop
            local fallTime = math.random(15, 25) / 10
            local tween = _SoundIntroTweenService:Create(drop, TweenInfo.new(fallTime, Enum.EasingStyle.Linear), {
                Position = UDim2.fromScale(drop.Position.X.Scale, 1.1)
            })
            tween:Play()
            task.delay(fallTime + 0.1, function()
                if drop and drop.Parent then drop:Destroy() end
            end)
            task.wait(math.random(2, 6) / 100)
        end
    end)

    -- Character asset removed from intro
    local characterFrame = Instance.new("Frame")
    characterFrame.Name = "CharacterContainer"
    characterFrame.BackgroundTransparency = 1
    characterFrame.Visible = false
    characterFrame.Size = UDim2.fromOffset(1, 1)
    characterFrame.Parent = instance

    local frame2 = Instance.new("Frame")
    frame2.Name = "JKHubWordmark"
    frame2.BackgroundTransparency = 1
    frame2.BorderSizePixel = 0
    frame2.AnchorPoint = Vector2.new(0.5, 0.5)
    frame2.Position = UDim2.fromScale(0.5, 0.45)
    frame2.Size = isMobile and UDim2.fromOffset(280, 80) or UDim2.fromOffset(520, 120)
    frame2.ClipsDescendants = false
    frame2.ZIndex = 1003
    frame2.Parent = instance
    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 0.86
    uiScale.Parent = frame2

    local titleLogo = Instance.new("TextLabel")
    titleLogo.Name = "JKHubTitle"
    titleLogo.BackgroundTransparency = 1
    titleLogo.Size = UDim2.fromScale(1, 1)
    titleLogo.Position = UDim2.fromScale(0, 0)
    titleLogo.Text = "JK HUB"
    titleLogo.TextColor3 = Color3.fromRGB(245, 245, 255)
    titleLogo.TextTransparency = 1
    titleLogo.Font = Enum.Font.GothamBlack
    titleLogo.TextScaled = true
    titleLogo.ZIndex = 1004
    titleLogo.Parent = frame2
    local titleStroke = Instance.new("UIStroke")
    titleStroke.Color = Color3.fromRGB(80, 80, 90)
    titleStroke.Thickness = 1.5
    titleStroke.Transparency = 0.4
    titleStroke.Parent = titleLogo

    -- keep empty wordmarkItems so animation loop still works
    local wordmarkItems = {}
    local wordmarkSpecs = {}

    local textLabel = Instance.new("TextLabel")
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "TAP ANYWHERE TO SKIP"
    textLabel.TextColor3 = Color3.fromRGB(210, 210, 215)
    textLabel.TextTransparency = 1
    textLabel.TextSize = isMobile and 11 or 22
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    textLabel.Position = UDim2.new(0.5, 0, 0.85, 0)
    textLabel.Size = UDim2.new(0.8, 0, 0, 24)
    textLabel.ZIndex = 1010
    textLabel.Parent = instance

    local textLabel2 = Instance.new("TextLabel")
    textLabel2.BackgroundTransparency = 1
    textLabel2.Text = "BLACK & WHITE  •  READY TO LOAD"
    textLabel2.TextColor3 = Color3.fromRGB(160, 160, 170)
    textLabel2.TextTransparency = 1
    textLabel2.TextSize = isMobile and 10 or 16
    textLabel2.Font = Enum.Font.GothamMedium
    textLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
    textLabel2.Position = UDim2.new(0.5, 0, 0.88, 0)
    textLabel2.Size = UDim2.new(0.8, 0, 0, 22)
    textLabel2.ZIndex = 1010
    textLabel2.Parent = instance

    local skipBtn = Instance.new("TextButton")
    skipBtn.Name = "SkipAnywhereButton"
    skipBtn.BackgroundTransparency = 1
    skipBtn.Text = ""
    skipBtn.AutoButtonColor = false
    skipBtn.Size = UDim2.fromScale(1, 1)
    skipBtn.ZIndex = 1011
    skipBtn.Parent = instance

    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Name = "JKHubIntroBlur"
    blurEffect.Size = 0
    blurEffect.Parent = _SoundIntroLighting
    local canSkip = true

    local function smoothstep(a)
        local n = math.clamp(a, 0, 1)
        return n * n * (3 - 2 * n)
    end
    local function bezier(p0, p1, p2, t)
        local n = 1 - t
        return Vector2.new(n*n*p0.X + 2*n*t*p1.X + t*t*p2.X, n*n*p0.Y + 2*n*t*p1.Y + t*t*p2.Y)
    end

    local function closeIntro()
        if closing then return end
        closing = true
        running = false
        _G._JKHubSkipIntro = true
        stopIntroMusic()
        local ti = TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        _SoundIntroTweenService:Create(instance, ti, { BackgroundTransparency = 1 }):Play()
        _SoundIntroTweenService:Create(uiScale, ti, { Scale = 0.72 }):Play()
        _SoundIntroTweenService:Create(characterFrame, ti, { Position = UDim2.fromScale(0.5, 1.5) }):Play()
        _SoundIntroTweenService:Create(blurEffect, ti, { Size = 0 }):Play()
        _SoundIntroTweenService:Create(textLabel, ti, { TextTransparency = 1 }):Play()
        _SoundIntroTweenService:Create(textLabel2, ti, { TextTransparency = 1 }):Play()
        for _, item in ipairs(wordmarkItems) do
            if item.image then
                _SoundIntroTweenService:Create(item.image, ti, { ImageTransparency = 1 }):Play()
            end
        end
        if titleLogo then
            _SoundIntroTweenService:Create(titleLogo, ti, { TextTransparency = 1 }):Play()
        end
        task.delay(0.42, function()
            if screenGui.Parent then screenGui:Destroy() end
            if blurEffect.Parent then blurEffect:Destroy() end
            _G._JKHubIntroCleanup = nil
            _G._JKHubIntroActive = false
            if onFinished then onFinished() end
        end)
    end

    _G._JKHubIntroCleanup = function()
        running = false
        closing = true
        stopIntroMusic()
        if screenGui.Parent then screenGui:Destroy() end
        if blurEffect.Parent then blurEffect:Destroy() end
        _G._JKHubIntroActive = false
        _G._SoundIntroFinished = true
    end
    skipBtn.Activated:Connect(closeIntro)

    _SoundIntroTweenService:Create(instance, TweenInfo.new(0.25), { BackgroundTransparency = 0.5 }):Play()
    _SoundIntroTweenService:Create(blurEffect, TweenInfo.new(0.25), { Size = 10 }):Play()
    task.delay(0.35, function()
        if not running then return end
        if titleLogo then
            _SoundIntroTweenService:Create(titleLogo, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()
        end
    end)
    task.delay(1.5, function()
        if not running then return end
        _SoundIntroTweenService:Create(textLabel, TweenInfo.new(0.3), { TextTransparency = 0.22 }):Play()
        _SoundIntroTweenService:Create(textLabel2, TweenInfo.new(0.3), { TextTransparency = 0.18 }):Play()
    end)

    task.spawn(function()
        local now = os.clock()
        while running and not closing do
            local animTime = os.clock() - now - 0.5
            if animTime > 0 then
                local v = smoothstep((animTime - 0.38) / 0.9)
                local s1 = math.sin(animTime * 1.62) * v
                local s2 = math.sin(animTime * 3.24) * v
                uiScale.Scale = 0.86 + smoothstep(animTime / 0.78) * 0.14 + s1 * 0.012
                for i, item in ipairs(wordmarkItems) do
                    local spec = item.spec
                    local offset = i - 3
                    local distance = math.abs(offset) / 2
                    local progress = math.clamp((animTime - spec.delay) / 0.96, 0, 1)
                    local eased = 1 - (1 - progress)^3
                    local pos = bezier(spec.from, Vector2.new((spec.from.X + spec.final.X) * 0.5 - offset * 0.08, (spec.from.Y + spec.final.Y) * 0.5 + ((i % 2 == 0) and -0.23 or 0.23)), spec.final, eased)
                    item.slot.Position = UDim2.fromScale(pos.X + offset * s1 * 0.009, pos.Y + (distance*distance*12 - 6) * s1 / 230 + s2 * (1 - distance) * 2.4 / 230)
                    item.slot.Size = UDim2.fromScale(0.15 * (1 + s1 * (0.035 + distance*0.055)), 0.65 - s1 * (0.028 + distance*0.045))
                    item.slot.Rotation = spec.rotation * (1 - eased) + offset * s1 * 5.8 + s2 * (1 - distance) * 0.8
                    local a = math.sin(animTime * 2.85 + i * 0.82)
                    local b = math.sin(animTime * 2.1 + i * 0.64)
                    item.image.Position = UDim2.new(0.5, 0, 0.5, b * 1.35)
                    item.image.Size = UDim2.fromScale(1 + a * 0.026, 1 - a * 0.038)
                    item.image.Rotation = b * 0.9
                    item.image.ImageTransparency = 1 - smoothstep((progress - 0.02) / 0.18)
                end
            end
            _SoundIntroRunService.RenderStepped:Wait()
        end
    end)

    task.delay(10, function()
        if running and not closing then closeIntro() end
    end)
end

_soundShowIntro(function()
    _G._SoundIntroFinished = true
    print("[JK HUB] Intro finished — loading main script...")
end)

repeat task.wait() until _G._SoundIntroFinished == true
print("[JK HUB] Intro finished. Starting main script.")
-- ============================================================
-- END JKHub.VS INTRO GATE
-- ============================================================

-- ============================================================
-- FAST EXECUTION + PERFORMANCE FFLAGS
-- Applied as early as possible for lower latency / higher FPS
-- ============================================================
do
    local function _ehSetFFlag(name, value)
        local ok = false
        if type(setfflag) == "function" then
            ok = pcall(setfflag, name, value)
        end
        if not ok and type(setfflag) ~= "function" then
            -- some executors expose setflag / set_fflag
            if type(setflag) == "function" then
                pcall(setflag, name, value)
            elseif type(set_fflag) == "function" then
                pcall(set_fflag, name, value)
            end
        end
    end

    -- Bool / string FFlags
    _ehSetFFlag("DFFlagBrowserTrackerIdTelemetryEnabled", "False")
    _ehSetFFlag("DFFlagPreloadAsyncSupportTexturePack", "True")
    _ehSetFFlag("DFFlagTextureQualityOverrideEnabled", "True")
    _ehSetFFlag("DFFlagVideoCaptureServiceEnabled", "False")
    _ehSetFFlag("DFFlagSampleAndRefreshRakPing", "True")
    _ehSetFFlag("DFFlagRakNetUseSlidingWindow4", "True")
    _ehSetFFlag("DFFlagCoreScriptTelemetry2", "False")
    _ehSetFFlag("DFFlagEnableSoundPreloading", "True")
    _ehSetFFlag("DFFlagOptimizePartsInPart", "True")
    _ehSetFFlag("DFFlagDisableDPIScale", "True")
    _ehSetFFlag("DFFlagDebugPerfMode", "True")

    -- Int FFlags (network / packets / raknet)
    _ehSetFFlag("DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000")
    _ehSetFFlag("DFIntRakNetClockDriftAdjustmentPerPingMillisecond", "100")
    _ehSetFFlag("DFIntPerformanceControlTextureQualityBestUtility", "-1")
    _ehSetFFlag("DFIntSignalRHubConnectionHeartbeatTimerRateMs", "1000")
    _ehSetFFlag("DFIntMaxReceiveToDeserializeLatencyMilliseconds", "15")
    _ehSetFFlag("DFIntMegaReplicatorNetworkQualityProcessorUnit", "10")
    _ehSetFFlag("DFIntNetworkInDeserializeLimitGameplayMsClient", "6")
    _ehSetFFlag("DFIntSignalRHubConnectionBaseRetryTimeMs", "100")
    _ehSetFFlag("DFIntClientPacketHealthyAllocationPercent", "20")
    _ehSetFFlag("DFIntTelemetryProfilerHundredthsPercentage", "0")
    _ehSetFFlag("DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1")
    _ehSetFFlag("DFIntNetworkInProcessLimitGameplayMsClient", "6")
    _ehSetFFlag("DFIntAnimationLodFacsVisibilityDenominator", "0")
    _ehSetFFlag("DFIntRaknetBandwidthPingSendEveryXSeconds", "1")
    _ehSetFFlag("DFIntSignalRCoreKeepAlivePingPeriodMs", "250")
    _ehSetFFlag("DFIntClientPacketMaxFrameMicroseconds", "200")
    _ehSetFFlag("DFIntSoundServiceCacheCleanupMaxAgeDays", "2")
    _ehSetFFlag("DFIntMaxProcessPacketsStepsPerCyclic", "5000")
    _ehSetFFlag("DFIntClientPacketExcessMicroseconds", "1000")
    _ehSetFFlag("DFIntMaxProcessPacketsStepsAccumulated", "0")
    _ehSetFFlag("DFIntWaitOnUpdateNetworkLoopEndedMS", "100")
    _ehSetFFlag("DFIntLargePacketQueueSizeCutoffMB", "1000")
    _ehSetFFlag("DFIntMaxProcessPacketsJobScaling", "10000")
    _ehSetFFlag("DFIntRakNetNakResendDelayRttPercent", "50")
    _ehSetFFlag("DFIntSignalRCoreServerTimeoutMs", "11100")
    _ehSetFFlag("DFIntDebugFRMQualityLevelOverride", "1")
    _ehSetFFlag("DFIntClientPacketMinMicroseconds", "1")
    _ehSetFFlag("DFIntAnimationLodFacsDistanceMin", "0")
    _ehSetFFlag("DFIntAnimationLodFacsDistanceMax", "0")
    _ehSetFFlag("DFIntWaitOnRecvFromLoopEndedMS", "100")
    _ehSetFFlag("DFIntRakNetNakResendDelayMsMax", "100")
    _ehSetFFlag("DFIntCodecMaxOutgoingFrames", "10000")
    _ehSetFFlag("DFIntSignalRCoreRpcQueueSize", "256")
    _ehSetFFlag("DFIntRakNetMinAckGrowthPercent", "0")
    _ehSetFFlag("DFIntTaskSchedulerTargetFps", "9999")
    _ehSetFFlag("DFIntCodecMaxIncomingPackets", "100")
    _ehSetFFlag("DFIntRakNetMtuValue3InBytes", "1200")
    _ehSetFFlag("DFIntRakNetMtuValue1InBytes", "1280")
    _ehSetFFlag("DFIntRakNetMtuValue2InBytes", "1240")
    _ehSetFFlag("DFIntRakNetNakResendDelayMs", "10")
    _ehSetFFlag("DFIntRakNetResendRttMultiple", "1")
    _ehSetFFlag("DFIntMemCacheMaxCapacityMB", "48")
    _ehSetFFlag("DFIntClientPacketMaxDelayMs", "11")
    _ehSetFFlag("DFIntTextureQualityOverride", "0")
    _ehSetFFlag("DFIntRakNetSelectTimeoutMs", "1")
    _ehSetFFlag("DFIntSignalRCoreTimerMs", "750")
    _ehSetFFlag("DFIntConnectionMTUSize", "1260")
    _ehSetFFlag("DFIntMaxFrameBufferSize", "4")
    _ehSetFFlag("DFIntRakNetLoopMs", "1")
    _ehSetFFlag("DFIntDebugRestrictGCDistance", "1")

    -- FInt flags
    _ehSetFFlag("FIntTaskSchedulerAsyncTasksMinimumThreadCount", "2")
    _ehSetFFlag("FIntRenderMaxShadowAtlasUsageBeforeDownscale", "80")
    _ehSetFFlag("FIntPerformanceTelemetryQueueProcessLimit", "0")
    _ehSetFFlag("FIntRenderShadowMapDepthCacheMemLimit", "192")
    _ehSetFFlag("FIntUITextureMaxRenderTextureSize", "1024")
    _ehSetFFlag("FIntRakNetResendBufferArrayLength", "128")
    _ehSetFFlag("FIntTaskSchedulerAutoThreadLimit", "6")
    _ehSetFFlag("FIntTerrainOTAMaxTextureSize", "1024")
    _ehSetFFlag("FIntOcclusionWorkerThreadCount", "5")
    _ehSetFFlag("FIntTaskSchedulerMaxNumOfJobs", "86")
    _ehSetFFlag("FIntTelemetryProfilerFrequency", "0")
    _ehSetFFlag("FIntRenderLocalLightFadeInMs", "0")
    _ehSetFFlag("FIntDefaultMeshCacheSizeMB", "256")
    _ehSetFFlag("FIntReportDeviceInfoRollout", "0")
    _ehSetFFlag("FIntTaskSchedulerThreadMin", "1")
    _ehSetFFlag("FIntRobloxGuiBlurIntensity", "0")
    _ehSetFFlag("FIntTerrainArraySliceSize", "0")
    _ehSetFFlag("FIntDebugForceMSAASamples", "1")
    _ehSetFFlag("FIntRenderShadowmapBias", "0")
    _ehSetFFlag("FIntFRMMaxGrassDistance", "0")
    _ehSetFFlag("FIntFRMMinGrassDistance", "0")
    _ehSetFFlag("FIntGrassMovementReducedMotionFactor", "0")
    _ehSetFFlag("FIntDebugTextureManagerSkipMips", "7")

    -- Render / quality / misc
    _ehSetFFlag("RenderUseTextureManager224", "False")
    _ehSetFFlag("TextureQualityOverride", "1")
    _ehSetFFlag("TextureQualityOverrideEnabled", "True")
    _ehSetFFlag("PerformanceControlTextureQualityBestUtility", "1")
    _ehSetFFlag("FFlagRenderAllocateShadowMapResourcesOnDemand", "True")
    _ehSetFFlag("FFlagSpecifyNetworkReplicatorScopeForItems", "True")
    _ehSetFFlag("FFlagTaskSchedulerLimitTargetFpsTo2402", "False")
    _ehSetFFlag("FFlagHandleAltEnterFullscreenManually", "False")
    _ehSetFFlag("FFlagGameBasicSettingsFramerateCap5", "False")
    _ehSetFFlag("FFlagSpecifyNetworkReplicatorScope", "True")
    _ehSetFFlag("FFlagSendRenderFidelityTelemetry2", "False")
    _ehSetFFlag("FFlagRenderGpuTextureCompressor", "True")
    _ehSetFFlag("FFlagBaseThreadPoolUseRuntime2", "True")
    _ehSetFFlag("FFlagCacheTextBoundsInGuiText", "True")
    _ehSetFFlag("FFlagEnableTelemetryService1", "False")
    _ehSetFFlag("FFlagDebugGraphicsPreferD3D11", "True")
    _ehSetFFlag("FFlagPerfDataOnTelemetryV2", "False")
    _ehSetFFlag("FFlagOpenTelemetryEnabled2", "False")
    _ehSetFFlag("FFlagRbxStorageUseMemCache", "True")
    _ehSetFFlag("FFlagDebugForceGenerateHSR", "True")
    _ehSetFFlag("FFlagRenderInitShadowmaps", "True")
    _ehSetFFlag("FFlagFastGPULightCulling3", "True")
    _ehSetFFlag("FFlagDebugSkyGray", "True")
    _ehSetFFlag("FFlagDebugRenderingSetDeterministic", "True")
    _ehSetFFlag("FLogNetwork", "7")

    -- Fast execution helpers (executor-side, best-effort)
    pcall(function()
        if type(setfpscap) == "function" then setfpscap(0) end -- uncapped when supported
    end)
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
    pcall(function()
        local UserGameSettings = UserSettings():GetService("UserGameSettings")
        if UserGameSettings then
            UserGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
        end
    end)
end

-- A previous copy could set this flag and then stop while waiting for a
-- game-specific object. Clear that stale state so a fixed copy can start.
if _G.ExoticHubRunning then
    warn("[JK HUB] Instancia previa detectada. Se recomienda rejoin si hay comportamiento errático.")
end
_G.ExoticHubRunning = false
_G.__ExoticHubMainOriginalPos = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
if not LP then
    local _lpConn
    _lpConn = Players.PlayerAdded:Connect(function(p) LP = p end)
    local _t0 = tick()
    while not LP and tick() - _t0 < 15 do task.wait(0.1) end
    if _lpConn then _lpConn:Disconnect() end
end
if not LP then
    warn("[JK HUB] LocalPlayer no disponible en 15s. Abortando.")
    return
end

pgui = LP:WaitForChild("PlayerGui", 20)
if not pgui then
    warn("[JK HUB] PlayerGui no cargó en 20s. Abortando.")
    return
end

camera = Workspace.CurrentCamera

_G.ExoticHubRunning = true
_G.ExoticHubSession = (_G.ExoticHubSession or 0) + 1
_mySession = _G.ExoticHubSession

EXOTIC_HUB_LANGUAGE = "en"

local EXOTIC_HUB_TRANSLATIONS = {
    es = { ["RESET ALL SETTINGS"]="RESTABLECER TODO", ["SETTINGS RESET"]="AJUSTES RESTABLECIDOS", ["CONFIRM?"]="¿CONFIRMAR?", ["ERROR"]="ERROR", ["Reset All Keybinds"]="RESTABLECER TECLAS", ["RESET"]="RESTABLECER", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARGAR", ["Lagger Mode"]="MODO LAG", ["Auto Left"]="AUTO IZQUIERDA", ["Auto Right"]="AUTO DERECHA", ["Auto Bat"]="AUTO BATE", ["TP BAT"]="TP BATE", ["Insta Reset"]="REINICIO RÁPIDO", ["TP Down"]="TP ABAJO", ["Drop Brainrot"]="SOLTAR BRAINROT", ["Hide GUI"]="OCULTAR MENÚ", ["Normal Speed"]="VELOCIDAD NORMAL", ["Carry Speed"]="VELOCIDAD CARGAR", ["Current Mode"]="MODO ACTUAL", ["ACTIVATE"]="ACTIVAR" },
    pt = { ["RESET ALL SETTINGS"]="REDEFINIR TUDO", ["SETTINGS RESET"]="CONFIGURAÇÕES REDEFINIDAS", ["CONFIRM?"]="CONFIRMAR?", ["ERROR"]="ERRO", ["Reset All Keybinds"]="REDEFINIR TECLAS", ["RESET"]="REDEFINIR", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARREGAR", ["Auto Left"]="AUTO ESQUERDA", ["Auto Right"]="AUTO DIREITA", ["Hide GUI"]="OCULTAR MENU", ["Normal Speed"]="VELOCIDADE NORMAL", ["Carry Speed"]="VELOCIDADE CARREGAR", ["ACTIVATE"]="ATIVAR" },
    fr = { ["RESET ALL SETTINGS"]="RÉINITIALISER", ["SETTINGS RESET"]="PARAMÈTRES RÉINITIALISÉS", ["CONFIRM?"]="CONFIRMER ?", ["ERROR"]="ERREUR", ["Reset All Keybinds"]="RÉINITIALISER LES TOUCHES", ["RESET"]="RÉINITIALISER", ["Keybinds"]="RACCOURCIS", ["Carry Mode"]="MODE PORTER", ["Auto Left"]="AUTO GAUCHE", ["Auto Right"]="AUTO DROITE", ["Hide GUI"]="MASQUER LE MENU", ["Normal Speed"]="VITESSE NORMALE", ["Carry Speed"]="VITESSE PORTER", ["ACTIVATE"]="ACTIVER" },
    de = { ["RESET ALL SETTINGS"]="ALLES ZURÜCKSETZEN", ["SETTINGS RESET"]="EINSTELLUNGEN ZURÜCKGESETZT", ["CONFIRM?"]="BESTÄTIGEN?", ["ERROR"]="FEHLER", ["Reset All Keybinds"]="TASTEN ZURÜCKSETZEN", ["RESET"]="ZURÜCKSETZEN", ["Keybinds"]="TASTEN", ["Carry Mode"]="TRAGEMODUS", ["Auto Left"]="AUTO LINKS", ["Auto Right"]="AUTO RECHTS", ["Hide GUI"]="MENÜ AUSBLENDEN", ["Normal Speed"]="NORMALE GESCHWINDIGKEIT", ["Carry Speed"]="TRAGEGESCHWINDIGKEIT", ["ACTIVATE"]="AKTIVIEREN" },
}

function localizeExoticHubInterface(root)
    local dictionary = EXOTIC_HUB_TRANSLATIONS[EXOTIC_HUB_LANGUAGE]
    if not dictionary or not root then return end
    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            local source = object:GetAttribute("ExoticHubSourceText") or object.Text
            object:SetAttribute("ExoticHubSourceText", source)
            local translated = dictionary[source]
            if translated then object.Text = translated end
        end
    end
end

function exoticHubTranslate(source)
    local dictionary = EXOTIC_HUB_TRANSLATIONS[EXOTIC_HUB_LANGUAGE]
    return (dictionary and dictionary[source]) or source
end

local _tick          = tick
local _clamp         = math.clamp
local _floor         = math.floor
local _abs           = math.abs
local _huge          = math.huge
local _sqrt          = math.sqrt
local _V3new         = Vector3.new
local _V3zero        = Vector3.zero
local _CFnew         = CFrame.new
local _CFlookAt      = CFrame.lookAt
local _RayParams_new = RaycastParams.new

_GetPlayersCached = (function()
    local cache, cacheTime = nil, 0
    return function()
        local now = _tick()
        if cache and now - cacheTime < 0.03 then return cache end
        cache = Players:GetPlayers()
        cacheTime = now
        return cache
    end
end)()

function waitForCharReady(char, timeout)
    timeout = timeout or 5
    local deadline = _tick() + timeout
    while (not char) or (not char.Parent)
          or (not char:FindFirstChild("HumanoidRootPart"))
          or (not char:FindFirstChildOfClass("Humanoid")) do
        if _tick() > deadline then return false end
        task.wait(0.05)
    end
    return true
end

NS = 60
NS_V2 = 72
CS = 29
normalSpeedMode = "v1"  -- "v1" | "v2"
spinBotEnabled = false
spinBotSpeed = 12
spinBotConn = nil
antiLoseEnabled = false
antiLoseConn = nil
autoAfterDropBat = false
halloweenMode = false
uiLayoutMode = "Left"  -- Left | Right | Top | Bottom
customFontName = "Gotham"
CUSTOM_FONTS = {
    { "Gotham", Enum.Font.Gotham },
    { "GothamBold", Enum.Font.GothamBold },
    { "GothamBlack", Enum.Font.GothamBlack },
    { "SourceSans", Enum.Font.SourceSans },
    { "SourceSansBold", Enum.Font.SourceSansBold },
    { "Code", Enum.Font.Code },
    { "Arcade", Enum.Font.Arcade },
    { "FredokaOne", Enum.Font.FredokaOne },
    { "DenkOne", Enum.Font.DenkOne },
}
setSpinBotVisual = nil
setAntiLoseVisual = nil
setAutoAfterDropVisual = nil
setHalloweenVisual = nil

LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 58
BYPASS_AIMBOT_SPEED = 58
CONFIG_FILE = "JKHubVS_" .. tostring(LP.UserId) .. ".json"
BAT_V2_HIT_DIST = 4.5
-- Normal mode bat aimbot tuning
AUTO_BAT_SPEED = 58
AUTO_BAT_VERT_SPEED = 52
AUTO_BAT_DIST = 2.8
AUTO_BAT_HEIGHT = 4.75
AUTO_BAT_V_OFF = 1
AUTO_BAT_TURN_SPEED = 285
AUTO_BAT_MAX_TURN_RATE = 28
autoBatEquippedThisRun = false
_autoBatTargetCache = nil
_autoBatTargetAt = 0
_isDraggingButton = false

backgroundIndex = 1
-- Preview presets: image id (nil = none) + theme color name
backgroundPresets = {
    { id = JK_HUB_BACKGROUND_IMAGE, theme = "Gray", label = "JK HUB Photo" },
    { id = "120675946443720", theme = "Gray", label = "Background 2" },
    { id = "119243661145369", theme = "Gray", label = "Background 3" },
    { id = "111761531749015", theme = "Gray", label = "Background 4" },
    { id = "120480454937730", theme = "Gray", label = "Background 5" },
}
backgroundImages = {
    JK_HUB_BACKGROUND_IMAGE,
    "120675946443720",
    "119243661145369",
    "111761531749015",
    "120480454937730",
}

backgroundImageTransparency = 0
backgroundMode = "Background 1"
backgroundSelectorLabel = nil
backgroundPreviewButtons = {}
floatingButtonScale = 1
mobileButtonCircleMode = false -- false = rounded square, true = circle
mobilePanelTriangleMode = false
mobileButtonsMatchBackground = false -- use hub background image on mobile buttons
_floatingUIScales = {}
stealBarScaleBox = nil
mbButtonsScaleBox = nil

function applyBackgroundMode(mode)
    if mode == "None" or mode == nil then
        backgroundMode = "None"
        backgroundIndex = 0
    else
        backgroundMode = "Background 1"
        if type(mode) == "number" then backgroundIndex = mode end
        if not backgroundIndex or backgroundIndex < 1 then backgroundIndex = 1 end
    end
    if main then
        main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        local hasImage = backgroundMode ~= "None" and backgroundIndex and backgroundIndex >= 1 and backgroundImages[backgroundIndex]
        main.BackgroundTransparency = hasImage and 1 or 0
        local bgImage = main:FindFirstChild("BackgroundImage")
        if bgImage then
            if hasImage then
                bgImage.Image = jkHubImageUri(backgroundImages[backgroundIndex])
                bgImage.ImageTransparency = backgroundImageTransparency
            else
                bgImage.Image = ""
                bgImage.ImageTransparency = 1
            end
        end
        pcall(function()
            if applyBackgroundToAutoGrab then
                applyBackgroundToAutoGrab(hasImage and backgroundImages[backgroundIndex] or nil)
            end
        end)
        pcall(function()
            if refreshMobileButtonsBackground then
                refreshMobileButtonsBackground()
            end
        end)
    end
    if backgroundSelectorLabel then backgroundSelectorLabel.Text = backgroundMode end
    updateBackgroundPreviewSelection()
end


function applyBackgroundToAutoGrab(imageId)
    local bar = pbFrame
    if not bar and gui then
        bar = gui:FindFirstChild("SyeHubAutoGrabBar", true)
    end
    if not bar then return end
    local bg = bar:FindFirstChild("BackgroundImage")
    if not bg then
        bg = Instance.new("ImageLabel")
        bg.Name = "BackgroundImage"
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.Position = UDim2.new(0, 0, 0, 0)
        bg.BackgroundTransparency = 1
        bg.ScaleType = Enum.ScaleType.Crop
        bg.ZIndex = 500 -- behind labels (labels are 501+)
        bg.ClipsDescendants = true
        bg.Parent = bar
        pcall(function()
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 13)
            c.Parent = bg
        end)
    end
    if imageId and tostring(imageId) ~= "" then
        bg.Image = jkHubImageUri(imageId)
        bg.ImageTransparency = backgroundImageTransparency or 0
        bar.BackgroundTransparency = 1
        -- hide solid gradient relief so image shows
        local og = bar:FindFirstChild("OuterRelief")
        if og then og.Enabled = false end
    else
        bg.Image = ""
        bg.ImageTransparency = 1
        bar.BackgroundTransparency = 0
        local og = bar:FindFirstChild("OuterRelief")
        if og then og.Enabled = true end
    end
end


function applyBackgroundToMobileButtons(imageId)
    if not mobileButtonsMatchBackground then
        imageId = nil -- force clear when option off
    end
    local function styleBtn(btn)
        if not btn or not btn:IsA("GuiObject") then return end
        local bg = btn:FindFirstChild("BackgroundImage")
        if not bg then
            bg = Instance.new("ImageLabel")
            bg.Name = "BackgroundImage"
            bg.Size = UDim2.new(1, 0, 1, 0)
            bg.Position = UDim2.new(0, 0, 0, 0)
            bg.BackgroundTransparency = 1
            bg.ScaleType = Enum.ScaleType.Crop
            bg.ZIndex = (btn.ZIndex or 10)
            bg.ClipsDescendants = true
            bg.Parent = btn
            local corner = btn:FindFirstChildOfClass("UICorner")
            local c = Instance.new("UICorner")
            c.CornerRadius = corner and corner.CornerRadius or UDim.new(0, 12)
            c.Parent = bg
        else
            -- keep corner matched to circle/square mode
            local corner = btn:FindFirstChildOfClass("UICorner")
            local bc = bg:FindFirstChildOfClass("UICorner")
            if corner and bc then bc.CornerRadius = corner.CornerRadius end
        end
        local label = btn:FindFirstChild("TextLabel")
        if label then
            label.ZIndex = math.max(label.ZIndex, (btn.ZIndex or 10) + 2)
        end
        local grad = btn:FindFirstChild("BtnGrad") or btn:FindFirstChildOfClass("UIGradient")
        if imageId and tostring(imageId) ~= "" then
            bg.Image = jkHubImageUri(imageId)
            bg.ImageTransparency = backgroundImageTransparency or 0
            btn.BackgroundTransparency = 1
            if grad then grad.Enabled = false end
        else
            bg.Image = ""
            bg.ImageTransparency = 1
            btn.BackgroundTransparency = 0
            if grad then grad.Enabled = true end
        end
    end
    pcall(function()
        if MobilePanel then
            for _, btn in ipairs(MobilePanel:GetChildren()) do
                if btn:IsA("TextButton") then styleBtn(btn) end
            end
        end
        for _, panel in ipairs({tpBatFloatingButton, instaResetFloatingButton}) do
            if panel then
                for _, d in ipairs(panel:GetDescendants()) do
                    if d:IsA("TextButton") or (d:IsA("Frame") and d.Name == "Frame") then
                        styleBtn(d)
                    end
                end
            end
        end
    end)
end

function refreshMobileButtonsBackground()
    local id = nil
    if mobileButtonsMatchBackground then
        if backgroundMode ~= "None" and backgroundIndex and backgroundIndex >= 1 and backgroundImages[backgroundIndex] then
            id = backgroundImages[backgroundIndex]
        elseif backgroundPresets and backgroundIndex and backgroundPresets[backgroundIndex] then
            id = backgroundPresets[backgroundIndex].id
        end
    end
    applyBackgroundToMobileButtons(id)
end

function applyBackgroundPreset(index)
    local preset = backgroundPresets[index]
    if not preset then return end
    backgroundIndex = index
    if preset.id then
        backgroundMode = "Background 1"
        backgroundImages[index] = preset.id
    else
        backgroundMode = "None"
        backgroundIndex = 0
    end
    if main then
        main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        local bgImage = main:FindFirstChild("BackgroundImage")
        if preset.id then
            main.BackgroundTransparency = 1
            if bgImage then
                bgImage.Image = jkHubImageUri(preset.id)
                bgImage.ImageTransparency = backgroundImageTransparency
            end
        else
            main.BackgroundTransparency = 0
            if bgImage then
                bgImage.Image = ""
                bgImage.ImageTransparency = 1
            end
        end
    end
    -- Also apply the same background to the Auto Grab bar
    pcall(function()
        if applyBackgroundToAutoGrab then
            applyBackgroundToAutoGrab(preset.id)
        end
    end)
    -- Mobile buttons match background (optional)
    pcall(function()
        if refreshMobileButtonsBackground then
            refreshMobileButtonsBackground()
        end
    end)
    -- Force theme color swap in the same frame as the image
    local themes = COLOR_THEMES or _G.COLOR_THEMES
    if preset.theme and themes and themes[preset.theme] then
        local c = themes[preset.theme]
        currentColorTheme = preset.theme
        selectedColor = c
        _lastThemeColor = nil
        _lastThemeUpdate = 0
        -- Direct force so nothing can early-return or skip
        pcall(function()
            if updateAllUIThemeColors then
                updateAllUIThemeColors(c)
            end
        end)
        -- Extra hard force on the most visible accents (covers any recolor miss)
        pcall(function()
            if main then
                for _, d in ipairs(main:GetDescendants()) do
                    if d:IsA("UIStroke") and d.Name ~= "NormalStroke" then
                        local col = d.Color
                        local r, g, b = col.R, col.G, col.B
                        local gray = math.abs(r - g) < 0.08 and math.abs(g - b) < 0.08
                        local dark = (r + g + b) < 0.30
                        local white = r > 0.88 and g > 0.88 and b > 0.88
                        if not gray and not dark and not white then
                            d.Color = c
                        end
                    elseif d:IsA("UIGradient") then
                        local n = d.Name
                        if n == "FillGrad" or n == "TabBgGrad" or n == "BtnGrad" or n == "AccentGrad" or n == "UIGradient" then
                            d.Color = exoticHubGradient(c)
                        else
                            -- recolor any gradient that currently carries an accent hue
                            local ok, seq = pcall(function() return d.Color end)
                            if ok and seq then
                                local needs = false
                                for _, kp in ipairs(seq.Keypoints) do
                                    local r, g, b = kp.Value.R, kp.Value.G, kp.Value.B
                                    local gray = math.abs(r-g) < 0.08 and math.abs(g-b) < 0.08
                                    local dark = (r+g+b) < 0.30
                                    local white = r > 0.88 and g > 0.88 and b > 0.88
                                    if not gray and not dark and not white then needs = true; break end
                                end
                                if needs then d.Color = exoticHubGradient(c) end
                            end
                        end
                    elseif (d:IsA("TextLabel") or d:IsA("TextButton")) then
                        local n = d.Name
                        if n == "DiscordText" or n == "SpeedLabel" or n == "ScriptLogo"
                            or n == "Title" or n == "AccentLabel" or n == "SectTitle" then
                            d.TextColor3 = c
                        end
                    elseif d:IsA("Frame") and (d.Name == "Underline" or d.Name == "AccentBar" or d.Name == "ActiveDot" or d.Name == "Fill" or d.Name == "SelectedSlide" or d.Name == "Knob") then
                        local col = d.BackgroundColor3
                        local r, g, b = col.R, col.G, col.B
                        local gray = math.abs(r - g) < 0.08 and math.abs(g - b) < 0.08
                        if d.Name == "Knob" then
                            if not gray and (r + g + b) > 0.35 then
                                d.BackgroundColor3 = c
                            end
                        elseif d.Name == "SelectedSlide" or d.Name == "Underline" or d.Name == "AccentBar" or d.Name == "Fill" or d.Name == "ActiveDot" then
                            d.BackgroundColor3 = c
                        end
                    end
                end
            end
            if gui then
                for _, d in ipairs(gui:GetDescendants()) do
                    if d:IsA("UIStroke") and d.Name == "OuterStroke" then
                        d.Color = c
                    elseif d:IsA("Frame") and d.Name == "Fill" then
                        d.BackgroundColor3 = c
                        local fg = d:FindFirstChild("FillGrad") or d:FindFirstChildOfClass("UIGradient")
                        if fg then fg.Color = exoticHubGradient(c) end
                    elseif d:IsA("Frame") and d.Name == "Knob" then
                        local col = d.BackgroundColor3
                        local r, g, b = col.R, col.G, col.B
                        local gray = math.abs(r - g) < 0.08 and math.abs(g - b) < 0.08
                        if not gray and (r + g + b) > 0.35 then
                            d.BackgroundColor3 = c
                        end
                    end
                end
            end
            -- Tabs
            for _, tab in ipairs(tabButtons or {}) do
                local isActive = tab:FindFirstChild("Underline") and tab.Underline.Visible
                if isActive then
                    tab.BackgroundColor3 = c
                    local tg = tab:FindFirstChild("TabBgGrad")
                    if tg then tg.Color = exoticHubGradient(c) end
                end
                local ul = tab:FindFirstChild("Underline")
                if ul then ul.BackgroundColor3 = c end
                local s = tab:FindFirstChild("TabStroke")
                if s then s.Color = c end
            end
            if _G._exoticHubStealSlide then
                _G._exoticHubStealSlide.BackgroundColor3 = c
                local sg = _G._exoticHubStealSlide:FindFirstChildOfClass("UIGradient")
                if sg then sg.Color = exoticHubGradient(c) end
                local ss = _G._exoticHubStealSlide:FindFirstChildOfClass("UIStroke")
                if ss then ss.Color = c end
            end
            if colorSelectorLabel then
                colorSelectorLabel.Text = currentColorTheme
                colorSelectorLabel.TextColor3 = c
            end
            if _G.__ExoticHubRefreshESPTheme then
                pcall(_G.__ExoticHubRefreshESPTheme, c)
            end
        end)
    end
    updateBackgroundPreviewSelection()
    -- Keep MB / floating buttons on-colors in sync with image theme
    pcall(function()
        if refreshAllFloatingButtonThemes then
            refreshAllFloatingButtonThemes()
        end
    end)
    task.defer(function() pcall(saveAllSettings) end)
end

function updateBackgroundPreviewSelection()
    if not backgroundPreviewButtons then return end
    for i, btn in ipairs(backgroundPreviewButtons) do
        if btn and btn.Parent then
            local stroke = btn:FindFirstChildOfClass("UIStroke")
            local selected = false
            local preset = backgroundPresets[i]
            if preset then
                if not preset.id then
                    selected = (backgroundMode == "None" or backgroundIndex == 0)
                else
                    selected = (backgroundMode ~= "None" and backgroundIndex == i)
                end
            end
            if stroke then
                stroke.Color = selected and (getThemeColor and getThemeColor() or Color3.fromRGB(180, 180, 190)) or Color3.fromRGB(60, 60, 70)
                stroke.Thickness = selected and 2 or 1
                stroke.Transparency = selected and 0 or 0.4
            end
        end
    end
end

-- GLOBAL (not local): applyBackgroundPreset is defined earlier and must see this table
COLOR_THEMES = {
    ["Red"] = Color3.fromRGB(180, 180, 190),  -- light red
    ["Gray"] = Color3.fromRGB(180, 180, 190),
    ["Purple"] = Color3.fromRGB(160, 100, 220),
    ["Blue"] = Color3.fromRGB(80, 150, 255),
    ["Pink"] = Color3.fromRGB(255, 120, 180),
    ["Green"] = Color3.fromRGB(80, 220, 120),
    ["Vanilla"] = Color3.fromRGB(212, 180, 135),
    ["Accent"] = Color3.fromRGB(120, 220, 255),
    ["Christmas"] = Color3.fromRGB(220, 50, 50), -- festive red accent
}

currentColorTheme = "Gray"
selectedColor = COLOR_THEMES["Gray"]
christmasMode = false
_savedBackgroundBeforeChristmas = nil
rainbowAccentEnabled = false
_rainbowAccentConn = nil
_christmasPrevTheme = nil
_christmasSnowConn = nil
_christmasSnowGui = nil

function getThemeColor() return selectedColor end

function stopChristmasSnow()
    if _christmasSnowConn then
        pcall(function() _christmasSnowConn:Disconnect() end)
        _christmasSnowConn = nil
    end
    if _christmasSnowGui then
        pcall(function() _christmasSnowGui:Destroy() end)
        _christmasSnowGui = nil
    end
end

function startChristmasSnow()
    stopChristmasSnow()
    if not gui then return end
    local layer = Instance.new("Frame")
    layer.Name = "ChristmasSnow"
    layer.BackgroundTransparency = 1
    layer.Size = UDim2.fromScale(1, 1)
    layer.Position = UDim2.new(0, 0, 0, 0)
    layer.ZIndex = 100
    layer.ClipsDescendants = true
    layer.Active = false
    layer.Parent = gui
    _christmasSnowGui = layer

    local flakes = {}
    local function spawnFlake()
        if not layer.Parent then return end
        local flake = Instance.new("TextLabel")
        flake.BackgroundTransparency = 1
        flake.Text = ({"❄", "✦", "•"})[math.random(1, 3)]
        flake.TextColor3 = Color3.fromRGB(255, 255, 255)
        flake.TextTransparency = math.random(10, 45) / 100
        flake.TextSize = math.random(10, 18)
        flake.Font = Enum.Font.GothamBold
        flake.Size = UDim2.fromOffset(20, 20)
        flake.Position = UDim2.new(math.random(), 0, -0.05, 0)
        flake.ZIndex = 101
        flake.Parent = layer
        local speed = math.random(18, 38) / 10
        local drift = (math.random() - 0.5) * 0.15
        local start = os.clock()
        table.insert(flakes, {label = flake, speed = speed, drift = drift, x = flake.Position.X.Scale, start = start})
    end

    for _ = 1, 18 do
        task.defer(spawnFlake)
    end

    _christmasSnowConn = RunService.RenderStepped:Connect(function()
        if not christmasMode or not layer.Parent then
            stopChristmasSnow()
            return
        end
        local now = os.clock()
        for i = #flakes, 1, -1 do
            local f = flakes[i]
            if not f.label or not f.label.Parent then
                table.remove(flakes, i)
            else
                local tlife = now - f.start
                local y = -0.05 + tlife * (f.speed * 0.08)
                local x = f.x + math.sin(tlife * 1.4) * f.drift
                f.label.Position = UDim2.new(x, 0, y, 0)
                if y > 1.1 then
                    f.label:Destroy()
                    table.remove(flakes, i)
                end
            end
        end
        if #flakes < 22 and math.random() < 0.12 then
            spawnFlake()
        end
    end)
end

function applyChristmasMode(on)
    christmasMode = on and true or false
    if christmasMode then
        if not _christmasPrevTheme then
            _christmasPrevTheme = currentColorTheme
        end
        currentColorTheme = "Christmas"
        selectedColor = COLOR_THEMES["Christmas"] or Color3.fromRGB(220, 50, 50)
        pcall(function()
            if updateAllUIThemeColors then updateAllUIThemeColors(selectedColor) end
        end)
        -- Christmas uses background asset #2
        pcall(function()
            _savedBackgroundBeforeChristmas = backgroundIndex
            backgroundIndex = 2
            backgroundMode = "Background 2"
            if applyBackgroundPreset then
                applyBackgroundPreset(2)
            elseif backgroundImages[2] and main then
                local bgImg = main:FindFirstChild("BackgroundImage")
                if bgImg then
                    bgImg.Image = jkHubImageUri(backgroundImages[2])
                    bgImg.Visible = true
                end
            end
        end)
        pcall(startChristmasSnow)
        -- Christmas lights strip under title
        pcall(function()
            if main then
                local oldL = main:FindFirstChild("ChristmasLights")
                if oldL then oldL:Destroy() end
                local lights = Instance.new("Frame")
                lights.Name = "ChristmasLights"
                lights.Size = UDim2.new(1, -20, 0, 4)
                lights.Position = UDim2.new(0, 10, 0, 88)
                lights.BackgroundTransparency = 1
                lights.ZIndex = 50
                lights.Parent = main
                local colors = {
                    Color3.fromRGB(255, 60, 60),
                    Color3.fromRGB(60, 220, 80),
                    Color3.fromRGB(255, 220, 60),
                    Color3.fromRGB(80, 160, 255),
                    Color3.fromRGB(255, 100, 200),
                }
                for i = 1, 12 do
                    local bulb = Instance.new("Frame", lights)
                    bulb.Size = UDim2.fromOffset(8, 8)
                    bulb.Position = UDim2.new((i - 1) / 12, 4, 0.5, -4)
                    bulb.BackgroundColor3 = colors[((i - 1) % #colors) + 1]
                    bulb.BorderSizePixel = 0
                    Instance.new("UICorner", bulb).CornerRadius = UDim.new(1, 0)
                    task.spawn(function()
                        while lights.Parent and christmasMode do
                            bulb.BackgroundTransparency = 0.1 + 0.5 * math.abs(math.sin(tick() * 3 + i))
                            task.wait(0.08)
                        end
                    end)
                end
            end
        end)
        -- soft green secondary accents on logo if present
        pcall(function()
            if scriptLogo then
                scriptLogo.TextColor3 = Color3.fromRGB(230, 245, 230)
            end
            if miniBtn then
                miniBtn.Text = "JK HUB"
            end
            if MobilePanel then
                local hat = MobilePanel:FindFirstChild("MobileChristmasHat")
                if hat then hat.Visible = true end
            end
        end)
    else
        stopChristmasSnow()
        pcall(function()
            if main then
                local oldL = main:FindFirstChild("ChristmasLights")
                if oldL then oldL:Destroy() end
            end
        end)
        -- Restore background from before Christmas
        pcall(function()
            if _savedBackgroundBeforeChristmas then
                backgroundIndex = _savedBackgroundBeforeChristmas
                if applyBackgroundPreset then
                    applyBackgroundPreset(backgroundIndex)
                end
                _savedBackgroundBeforeChristmas = nil
            end
        end)
        local restore = _christmasPrevTheme or "Gray"
        if not COLOR_THEMES[restore] then restore = "Gray" end
        _christmasPrevTheme = nil
        currentColorTheme = restore
        selectedColor = COLOR_THEMES[restore]
        pcall(function()
            if updateAllUIThemeColors then updateAllUIThemeColors(selectedColor) end
        end)
        pcall(function()
            if scriptLogo then
                scriptLogo.TextColor3 = Color3.fromRGB(180, 180, 190)
            end
            if miniBtn and tostring(miniBtn.Text):find("JK HUB") then
                miniBtn.Text = "JK HUB"
            end
            if MobilePanel then
                local hat = MobilePanel:FindFirstChild("MobileChristmasHat")
                if hat then hat.Visible = false end
            end
        end)
    end
    if setChristmasModeVisual then
        pcall(setChristmasModeVisual, christmasMode)
    end
end



function setRainbowAccent(on)
    rainbowAccentEnabled = on and true or false
    if _rainbowAccentConn then
        pcall(function() _rainbowAccentConn:Disconnect() end)
        _rainbowAccentConn = nil
    end
    if rainbowAccentEnabled then
        local hue = 0
        _rainbowAccentConn = game:GetService("RunService").RenderStepped:Connect(function(dt)
            if not rainbowAccentEnabled then return end
            hue = (hue + (dt or 0.016) * 60) % 360
            selectedColor = Color3.fromHSV(hue / 360, 0.85, 1)
            currentColorTheme = "Rainbow"
            pcall(function()
                if updateAllUIThemeColors then updateAllUIThemeColors(selectedColor) end
            end)
        end)
    end
end

function exoticHubGradient(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.55)),
        ColorSequenceKeypoint.new(0.45, c),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.35)),
    })
end

function exoticHubGradientSoft(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.75)),
        ColorSequenceKeypoint.new(0.50, c:Lerp(Color3.new(1,1,1), 0.25)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.15)),
    })
end

function exoticHubGradientDark(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.fromRGB(0,0,0), 0.35)),
        ColorSequenceKeypoint.new(0.55, c:Lerp(Color3.fromRGB(0,0,0), 0.65)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.fromRGB(0,0,0), 0.80)),
    })
end

function applyExoticHubGradientToLabel(label, c)
    if not label then return end
    local grad = label:FindFirstChildOfClass("UIGradient")
    if not grad then
        grad = Instance.new("UIGradient", label)
    end
    grad.Rotation = 0
    grad.Color = exoticHubGradient(c)
end

_lastThemeUpdate = 0
_lastThemeColor = nil

function applyColorTheme(themeName)
    local color = COLOR_THEMES[themeName]
    if not color then return end
    currentColorTheme = themeName
    selectedColor = color
    updateAllUIThemeColors(color)
    saveAllSettings()
end

_uicStroke = nil
_uicAvatarStroke = nil
_uicHandle = nil
_uicLine = nil

-- Accent-like color detector (no Color3 table keys — those break on some executors)
local function _isAccentLike(c)
    if not c then return false end
    local r, g, b = c.R, c.G, c.B
    local sum = r + g + b
    if sum < 0.30 then return false end -- too dark
    if r > 0.88 and g > 0.88 and b > 0.88 then return false end -- near white
    -- gray / near-gray
    if math.abs(r - g) < 0.07 and math.abs(g - b) < 0.07 and math.abs(r - b) < 0.07 then
        return false
    end
    return true
end

local function _colorClose(a, b, tol)
    if not a or not b then return false end
    tol = tol or 0.06
    local dr, dg, db = a.R - b.R, a.G - b.G, a.B - b.B
    return (dr * dr + dg * dg + db * db) < (tol * tol)
end

local function _isNearThemeColor(c, themeSet)
    -- themeSet is a list of Color3 values (array), not a dict keyed by Color3
    if not c then return false end
    if themeSet then
        for i = 1, #themeSet do
            if _colorClose(c, themeSet[i], 0.08) then return true end
        end
    end
    return _isAccentLike(c)
end

local function _themeColorSet()
    local list = {}
    if COLOR_THEMES then
        for _, c in pairs(COLOR_THEMES) do
            list[#list + 1] = c
        end
    end
    list[#list + 1] = Color3.fromRGB(180, 180, 190)
    list[#list + 1] = Color3.fromRGB(255, 170, 180)
    list[#list + 1] = Color3.fromRGB(220, 80, 100)
    list[#list + 1] = Color3.fromRGB(255, 80, 100)
    list[#list + 1] = Color3.fromRGB(255, 100, 120)
    list[#list + 1] = Color3.fromRGB(200, 80, 100)
    if _lastThemeColor then list[#list + 1] = _lastThemeColor end
    if selectedColor then list[#list + 1] = selectedColor end
    return list
end

function updateAllUIThemeColors(color)
    if not color then return end
    local now = _tick()
    -- Never skip when color actually changed (Color3 == can be flaky on some executors)
    local same = false
    if _lastThemeColor then
        local dr = color.R - _lastThemeColor.R
        local dg = color.G - _lastThemeColor.G
        local db = color.B - _lastThemeColor.B
        same = (dr * dr + dg * dg + db * db) < 0.0001
    end
    if same and now - _lastThemeUpdate < 0.01 then return end
    local prevColor = _lastThemeColor or selectedColor
    _lastThemeUpdate = now
    _lastThemeColor = color
    selectedColor = color

    local themeSet = _themeColorSet()
    if prevColor then themeSet[#themeSet + 1] = prevColor end

    -- Progress / steal bar
    if pbFrame then
        local border = pbFrame:FindFirstChild("OuterStroke") or pbFrame:FindFirstChildOfClass("UIStroke")
        if border then border.Color = color end
        if progressFill then
            pcall(applyStealBarRedGreen)
            local fg = progressFill:FindFirstChild("FillGrad") or progressFill:FindFirstChildOfClass("UIGradient")
            if fg then fg.Color = exoticHubGradient(color) end
        end
    end

    if _uicStroke then _uicStroke.Color = color end
    if _uicAvatarStroke then _uicAvatarStroke.Color = color end
    if _uicHandle then _uicHandle.TextColor3 = color end
    if _uicLine then _uicLine.BackgroundColor3 = color end

    local function recolorTree(parent)
        if not parent then return end
        for _, child in ipairs(parent:GetDescendants()) do
            -- Named accent labels
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                local n = child.Name
                if n == "DiscordText" or n == "SpeedLabel" or n == "ScriptLogo"
                    or n == "Title" or n == "AccentLabel" or n == "SectTitle" then
                    child.TextColor3 = color
                    if applyExoticHubGradientToLabel then
                        pcall(applyExoticHubGradientToLabel, child, color)
                    end
                elseif _isNearThemeColor(child.TextColor3, themeSet) then
                    child.TextColor3 = color
                end
            end
            if child:IsA("UIStroke") then
                local named = child.Name == "OuterStroke" or child.Name == "TabStroke"
                    or child.Name == "AccentStroke" or child.Name == "KnobStroke"
                if named or _isNearThemeColor(child.Color, themeSet) or _isAccentLike(child.Color) then
                    child.Color = color
                end
            end
            if child:IsA("Frame") or child:IsA("ImageLabel") or child:IsA("ImageButton") then
                if child.Name == "Underline" or child.Name == "AccentBar"
                    or child.Name == "ActiveDot" or child.Name == "Fill" then
                    child.BackgroundColor3 = color
                elseif _isNearThemeColor(child.BackgroundColor3, themeSet)
                    and child.BackgroundTransparency < 0.95 then
                    child.BackgroundColor3 = color
                end
            end
            if child:IsA("UIGradient") then
                -- Replace gradients that were theme-colored
                local ok, seq = pcall(function() return child.Color end)
                if ok and seq then
                    local needs = false
                    for _, kp in ipairs(seq.Keypoints) do
                        if _isNearThemeColor(kp.Value, themeSet) then needs = true; break end
                    end
                    if needs or child.Name == "FillGrad" or child.Name == "TabBgGrad"
                        or child.Name == "BtnGrad" or child.Name == "AccentGrad" then
                        child.Color = exoticHubGradient(color)
                    end
                end
            end
        end
    end

    -- FAST: tabs / known floating buttons (visible immediately)
    if tpBatFloatingButton then
        paintFloatingBtn(tpBatFloatingButton:FindFirstChild("Frame"), batDesyncTpEnabled)
    end

    for _, tab in ipairs(tabButtons or {}) do
        local isActive = tab:FindFirstChild("Underline") and tab.Underline.Visible
        if isActive then
            tab.TextColor3 = Color3.fromRGB(245, 245, 255)
            tab.BackgroundColor3 = color
            tab.BackgroundTransparency = 0.15
            local tg = tab:FindFirstChild("TabBgGrad")
            if tg then tg.Color = exoticHubGradient(color) end
        else
            tab.TextColor3 = Color3.fromRGB(150, 150, 165)
            tab.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
            tab.BackgroundTransparency = 1
        end
        local ul = tab:FindFirstChild("Underline")
        if ul then ul.BackgroundColor3 = color end
        local s = tab:FindFirstChild("TabStroke")
        if s then s.Color = color end
    end

    if _G.__ExoticHubRefreshESPTheme then pcall(_G.__ExoticHubRefreshESPTheme, color) end

    if colorSelectorLabel then
        colorSelectorLabel.Text = currentColorTheme
        colorSelectorLabel.TextColor3 = color
    end

    if _G._exoticHubStealSlide then
        _G._exoticHubStealSlide.BackgroundColor3 = color
        local sg = _G._exoticHubStealSlide:FindFirstChildOfClass("UIGradient")
        if sg then sg.Color = exoticHubGradient(color) end
        local ss = _G._exoticHubStealSlide:FindFirstChildOfClass("UIStroke")
        if ss then ss.Color = color end
    end

    if main then
        local ring = main:FindFirstChild("GuiPlayerAvatarRing", true)
        if ring then
            local st = ring:FindFirstChild("AvatarStroke") or ring:FindFirstChildOfClass("UIStroke")
            if st then st.Color = color end
        end
    end
    if miniBtn then
        local stroke = miniBtn:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = color end
    end

    if refreshAllFloatingButtonThemes then
        refreshAllFloatingButtonThemes()
    elseif MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") and btn:FindFirstChild("BtnGrad") then
                paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true)
            end
        end
    end

    -- Preview selection strokes use new theme
    if updateBackgroundPreviewSelection then
        pcall(updateBackgroundPreviewSelection)
    end

    -- Toggle switch knobs (ON state → theme color)
    local function recolorToggleKnobs(rootGui)
        if not rootGui then return end
        for _, child in ipairs(rootGui:GetDescendants()) do
            if child:IsA("Frame") and child.Name == "Knob" then
                local on = false
                pcall(function() on = child:GetAttribute("ThemeToggleOn") == true end)
                -- also treat non-gray knobs as "on"
                if not on then
                    local c = child.BackgroundColor3
                    local grayish = math.abs(c.R - c.G) < 0.05 and math.abs(c.G - c.B) < 0.05
                    if not grayish and (c.R + c.G + c.B) > 0.35 then on = true end
                end
                if on then
                    child.BackgroundColor3 = color
                    child.BackgroundTransparency = 0
                    local ks = child:FindFirstChild("KnobStroke")
                    if ks and ks:IsA("UIStroke") then
                        ks.Color = color
                        ks.Transparency = 0.2
                    end
                    pcall(function() child:SetAttribute("ThemeToggleOn", true) end)
                end
            end
        end
    end
    -- FAST PATH: only hub UI (gui/main/pbFrame) — keeps color switch instant with images
    pcall(function()
        if gui then recolorTree(gui) end
        if main then recolorTree(main) end
        if pbFrame then recolorTree(pbFrame) end
    end)
    pcall(function()
        recolorToggleKnobs(gui)
        recolorToggleKnobs(main)
    end)

    -- SLOW PATH: MobilePanel / PlayerGui / CoreGui / ESP (large trees) — never block the click
    local _themeColorCapture = color
    task.defer(function()
        local c = _themeColorCapture
        if not c then return end
        pcall(function()
            if MobilePanel then recolorTree(MobilePanel) end
        end)
        pcall(function()
            if pgui then recolorToggleKnobs(pgui) end
            local cg = game:GetService("CoreGui")
            recolorToggleKnobs(cg)
        end)
        pcall(function()
            local pg = LP:FindFirstChildOfClass("PlayerGui")
            if not pg then return end
            for _, child in ipairs(pg:GetChildren()) do
                if child:IsA("ScreenGui") and (child.Name:find("ExoticHubEnemyRag") or child.Name:find("EnemyRag") or child.Name:find("Ragdoll")) then
                    for _, d in ipairs(child:GetDescendants()) do
                        if d:IsA("TextLabel") then
                            d.TextColor3 = c
                        elseif d:IsA("UIStroke") then
                            d.Color = c
                        end
                    end
                end
            end
        end)
        if _G.__ExoticHubRefreshESPTheme then
            pcall(_G.__ExoticHubRefreshESPTheme, c)
        end
    end)
end

local HOMERO_CFG = {
    body = { 10725826963, 86500008, 86500054, 86500036, 86500064, 86500078 },
    aplicarCuerpo = true,
    items = {
        { id = 103227869700418, offset = _CFnew(0,0,0) },
        { id = 84952305140948,   offset = _CFnew(0,0,0) },
        { id = 122465238537030,  offset = _CFnew(0,0,0) },
    },
    shirt = nil,
    pants = "rbxassetid://78591690208112",
    skinColor = Color3.fromRGB(234,184,146),
    headColor = Color3.fromRGB(0,0,0),
}

TAG = "ExoticHubOutfit_"

function loadObjects(id)
    local ok, res = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(id))
    end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function()
        return game:GetService("InsertService"):LoadAsset(id)
    end)
    if ok and res then return { res } end
    return nil
end

function collectParts(objs)
    local out = {}
    for _, o in ipairs(objs) do
        if o:IsA("BasePart") then out[#out + 1] = o end
        for _, d in ipairs(o:GetDescendants()) do
            if d:IsA("BasePart") then out[#out + 1] = d end
        end
    end
    return out
end

function findAtt(char, name)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("Attachment") and p.Name == name and p.Parent:IsA("BasePart") then
            return p
        end
    end
end

function applyBody(char)
    local total = 0
    for _, id in ipairs(HOMERO_CFG.body) do
        local objs = loadObjects(id)
        if objs then
            for _, mp in ipairs(collectParts(objs)) do
                local orig = char:FindFirstChild(mp.Name)
                if orig and orig:IsA("BasePart") then
                    local c = mp:Clone()
                    c.Name = TAG .. "body_" .. mp.Name
                    c.CanCollide = false
                    c.Anchored = false
                    c.Massless = true
                    c.Size = orig.Size
                    c.CFrame = orig.CFrame
                    c.Parent = char
                    local w = Instance.new("WeldConstraint")
                    w.Part0 = orig
                    w.Part1 = c
                    w.Parent = c
                    if orig:GetAttribute("ExoticHubOutfitOriginalTransparency") == nil then
                        orig:SetAttribute("ExoticHubOutfitOriginalTransparency", orig.Transparency)
                    end
                    orig.Transparency = 1
                    total = total + 1
                end
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    return total
end

function attachItem(char, entry)
    local objs = loadObjects(entry.id)
    if not objs then return false end

    local handle
    for _, p in ipairs(collectParts(objs)) do
        if p.Name == "Handle" then handle = p; break end
        if not handle then handle = p end
    end
    if not handle then
        for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        return false
    end

    local H = handle:Clone()
    for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end

    H.Name = TAG .. "item_" .. tostring(entry.id)
    H.CanCollide = false
    H.Anchored = false
    H.Massless = true

    local wrap = H:FindFirstChildWhichIsA("WrapLayer")
    local target, c0, c1

    if wrap then
        target = char:FindFirstChild("UpperTorso")
              or char:FindFirstChild("Torso")
              or char:FindFirstChild("HumanoidRootPart")
        c0 = entry.offset or _CFnew()
        c1 = _CFnew()
    else
        local hAtt = H:FindFirstChildOfClass("Attachment")
        local bAtt = hAtt and findAtt(char, hAtt.Name)
        if bAtt then
            target = bAtt.Parent
            c0 = bAtt.CFrame * (entry.offset or _CFnew())
            c1 = hAtt.CFrame
        else
            target = char:FindFirstChild("Head")
            c0 = entry.offset or _CFnew(0, 1.4, 0)
            c1 = _CFnew()
        end
    end

    if not target then H:Destroy(); return false end

    H.CFrame = target.CFrame * c0 * c1:Inverse()
    H.Parent = char

    local w = Instance.new("Weld")
    w.Part0 = target
    w.Part1 = H
    w.C0 = c0
    w.C1 = c1
    w.Parent = H
    return true
end

function applyHomeroOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    char:WaitForChild("Humanoid", 10)
    char:WaitForChild("Head", 10)
    task.wait(0.4)

    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
    end

    if HOMERO_CFG.skinColor then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        bc.HeadColor3 = HOMERO_CFG.headColor or HOMERO_CFG.skinColor
        bc.TorsoColor3 = HOMERO_CFG.skinColor
        bc.LeftArmColor3, bc.RightArmColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.LeftLegColor3, bc.RightLegColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.Parent = char
    end

    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 1 end
        end
    end

    if HOMERO_CFG.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"
        s.ShirtTemplate = HOMERO_CFG.shirt
        s.Parent = char
    end
    if HOMERO_CFG.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"
        p.PantsTemplate = HOMERO_CFG.pants
        p.Parent = char
    end
    if HOMERO_CFG.aplicarCuerpo then applyBody(char) end
    for _, e in ipairs(HOMERO_CFG.items) do attachItem(char, e) end
end

_originalAppearance = nil

function captureOriginalAppearance(char)
    if not char or _originalAppearance then return end
    local data = {
        bodyColors = nil,
        shirt = nil,
        pants = nil,
        headMesh = nil,
        headTexture = nil,
    }
    local bc = char:FindFirstChildWhichIsA("BodyColors")
    if bc then
        data.bodyColors = {
            head = bc.HeadColor3,
            torso = bc.TorsoColor3,
            leftArm = bc.LeftArmColor3,
            rightArm = bc.RightArmColor3,
            leftLeg = bc.LeftLegColor3,
            rightLeg = bc.RightLegColor3,
        }
    end
    local sh = char:FindFirstChildWhichIsA("Shirt")
    if sh then data.shirt = sh.ShirtTemplate end
    local pa = char:FindFirstChildWhichIsA("Pants")
    if pa then data.pants = pa.PantsTemplate end
    local head = char:FindFirstChild("Head")
    if head then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm and sm.MeshType == Enum.MeshType.FileMesh then
            data.headMesh = sm.MeshId
            data.headTexture = sm.TextureId
        end
    end
    _originalAppearance = data
end

function clearPreviousOutfitAssets(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child.Name:sub(1, #TAG) == TAG
        or child.Name == "AuFfitAccessory"
        or child.Name == "Korblox_RightLeg" then
            pcall(function() child:Destroy() end)
        elseif child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
            pcall(function() child:Destroy() end)
        end
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local originalTransparency = part:GetAttribute("ExoticHubOutfitOriginalTransparency")
            if originalTransparency ~= nil then
                part.Transparency = originalTransparency
                part:SetAttribute("ExoticHubOutfitOriginalTransparency", nil)
            end
            local originalLocalTransparency = part:GetAttribute("ExoticHubOutfitOriginalLocalTransparency")
            if originalLocalTransparency ~= nil then
                part.LocalTransparencyModifier = originalLocalTransparency
                part:SetAttribute("ExoticHubOutfitOriginalLocalTransparency", nil)
            end
        end
    end
    if _originalAppearance and _originalAppearance.bodyColors then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        local o = _originalAppearance.bodyColors
        bc.HeadColor3, bc.TorsoColor3 = o.head, o.torso
        bc.LeftArmColor3, bc.RightArmColor3 = o.leftArm, o.rightArm
        bc.LeftLegColor3, bc.RightLegColor3 = o.leftLeg, o.rightLeg
        bc.Parent = char
    end
    local head = char:FindFirstChild("Head")
    if head and head:IsA("MeshPart") and head:GetAttribute("ExoticHubOutfitModifiedMeshPart") then
        pcall(function()
            head.MeshId = head:GetAttribute("ExoticHubOutfitOriginalMeshId") or ""
            head.TextureID = head:GetAttribute("ExoticHubOutfitOriginalTextureId") or ""
        end)
        head:SetAttribute("ExoticHubOutfitModifiedMeshPart", nil)
        head:SetAttribute("ExoticHubOutfitOriginalMeshId", nil)
        head:SetAttribute("ExoticHubOutfitOriginalTextureId", nil)
    elseif head then
        local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh")
        if specialMesh and specialMesh:GetAttribute("ExoticHubOutfitCreatedMesh") then
            specialMesh:Destroy()
        elseif specialMesh and specialMesh:GetAttribute("ExoticHubOutfitModifiedMesh") then
            specialMesh.MeshId = specialMesh:GetAttribute("ExoticHubOutfitOriginalMeshId") or ""
            specialMesh.TextureId = specialMesh:GetAttribute("ExoticHubOutfitOriginalTextureId") or ""
            specialMesh:SetAttribute("ExoticHubOutfitModifiedMesh", nil)
            specialMesh:SetAttribute("ExoticHubOutfitOriginalMeshId", nil)
            specialMesh:SetAttribute("ExoticHubOutfitOriginalTextureId", nil)
        end
    end
end

function applyNoOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
    end
    local oldAcc = char:FindFirstChild("AuFfitAccessory")
    if oldAcc then pcall(function() oldAcc:Destroy() end) end
    local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
    if oldKorblox then pcall(function() oldKorblox:Destroy() end) end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 0
        head.CanCollide = true
        head.LocalTransparencyModifier = 0
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 0 end
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm then
            if _originalAppearance and _originalAppearance.headMesh then
                sm.MeshId = _originalAppearance.headMesh
                sm.TextureId = _originalAppearance.headTexture or ""
            else
                pcall(function() sm:Destroy() end)
            end
        end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = true end
    end)
    for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local limb = char:FindFirstChild(partName)
        if limb then limb.Transparency = 0 end
    end
    if _originalAppearance and _originalAppearance.bodyColors then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        local o = _originalAppearance.bodyColors
        bc.HeadColor3 = o.head
        bc.TorsoColor3 = o.torso
        bc.LeftArmColor3 = o.leftArm
        bc.RightArmColor3 = o.rightArm
        bc.LeftLegColor3 = o.leftLeg
        bc.RightLegColor3 = o.rightLeg
        bc.Parent = char
    end
    if _originalAppearance and _originalAppearance.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.ShirtTemplate = _originalAppearance.shirt
        s.Parent = char
    end
    if _originalAppearance and _originalAppearance.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.PantsTemplate = _originalAppearance.pants
        p.Parent = char
    end
    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 0 end
        end
    end
end

local OUTFITS = {
    { label = "OFF", customApply = applyNoOutfit },
    { accessory = 10159600649, offset = _V3new(0, 1, -0.2), shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918 ", korblox = "none", label = "Outfit 1", headlessKorblox = true },
    { accessory = 1744060292, offset = _V3new(0, 1.3, -0.2), shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918 ", korblox = "none", label = "Outfit 2", headlessKorblox = true },
    { accessory = 8349240186, offset = _V3new(0, 0.9, 0), shirt = "http://www.roblox.com/asset/?id=11926549070", pants = "http://www.roblox.com/asset/?id=13189494471", headMesh = "https://assetdelivery.roblox.com/v1/asset/?id=16673245747", headTexture = nil, korblox = "none", label = "Outfit 3", headlessKorblox = true },
    { accessory = 121097973925756, offset = _V3new(0, 0.9, 0), shirt = "http://www.roblox.com/asset/?id=123181702116947", pants = "http://www.roblox.com/asset/?id=93330291631062", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918 ", korblox = "none", label = "Outfit 4", headlessKorblox = true },
    { label = "Homero Chino", customApply = applyHomeroOutfit },
}
currentOutfitIndex = 1
outfitSelectorLabel = nil

-- ============================================================
-- SKIN CHANGER (from Eclipse/Crystal Hub) — shirt/pants/hair presets
-- ============================================================
skinChangerEnabled = false
skinChangerMode = "V1"
setSkinChangerVisual = nil
skinModeSelectorLabel = nil

local skinState = _G.__ExoticHubSkinChangerState
if type(skinState) ~= "table" or skinState.version ~= 2 then
    skinState = { version = 2, originals = setmetatable({}, { __mode = "k" }), templates = {}, generation = 0 }
    _G.__ExoticHubSkinChangerState = skinState
end

skinState.isHair = function(item)
    if not item or not item:IsA("Accessory") then return false end
    local ok, isHair = pcall(function() return item.AccessoryType == Enum.AccessoryType.Hair end)
    return (ok and isHair) or item:FindFirstChild("HairAttachment", true) ~= nil
end

skinState.resolveTemplate = function(assetId, className, propertyName)
    local key = className .. ":" .. tostring(assetId)
    if skinState.templates[key] then return skinState.templates[key] end
    local template = "rbxassetid://" .. tostring(assetId)
    local ok, objects = pcall(function() return game:GetObjects(template) end)
    if ok and objects and objects[1] then
        local root = objects[1]
        local clothing = root:IsA(className) and root or root:FindFirstChildWhichIsA(className, true)
        if clothing and clothing[propertyName] and clothing[propertyName] ~= "" then
            template = clothing[propertyName]
        end
        pcall(function() root:Destroy() end)
    end
    skinState.templates[key] = template
    return template
end

skinState.removeChanged = function(character)
    if not character then return end
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Shirt") or item:IsA("Pants")
            or item.Name == "ExoticHubSkinChanger_Hair"
            or skinState.isHair(item) then
            pcall(function() item:Destroy() end)
        end
    end
end

skinState.capture = function(character)
    if not character or skinState.originals[character] then return end
    local original = { items = {} }
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Shirt") or item:IsA("Pants") or skinState.isHair(item) then
            table.insert(original.items, item:Clone())
        end
    end
    skinState.originals[character] = original
end

skinState.presets = {
    V1 = { shirt = 74707712629633, pants = 12405320750, hair = 140188532534398 },
    V2 = { shirt = 101796619834594, pants = 18975891159, hair = 115520061093937 },
    V3 = { shirt = 18552805597, pants = 5414143509, hair = 84008082880128 },
}

skinState.attachHair = function(character, humanoid, assetId, generation)
    local ok, objects = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(assetId))
    end)
    if not ok or not objects or not objects[1] then return false end
    local root = objects[1]
    local hair = root:IsA("Accessory") and root or root:FindFirstChildWhichIsA("Accessory", true)
    if not hair then
        pcall(function() root:Destroy() end)
        return false
    end
    hair = hair:Clone()
    pcall(function() root:Destroy() end)
    hair.Name = "ExoticHubSkinChanger_Hair"
    local head = character:FindFirstChild("Head")
    local handle = hair:FindFirstChild("Handle")
    if not head or not handle then
        pcall(function() hair:Destroy() end)
        return false
    end
    if not skinChangerEnabled or LP.Character ~= character or skinState.generation ~= generation then
        pcall(function() hair:Destroy() end)
        return false
    end
    local attached = pcall(function()
        hair.Parent = character
        if humanoid and humanoid.AddAccessory then
            pcall(function() humanoid:AddAccessory(hair) end)
        end
        if not hair.Parent then hair.Parent = character end
        local weld = handle:FindFirstChildOfClass("Weld") or handle:FindFirstChildOfClass("WeldConstraint")
        if not weld then
            local w = Instance.new("Weld")
            w.Part0 = head
            w.Part1 = handle
            w.C0 = CFrame.new(0, 0.5, 0)
            w.Parent = handle
        end
    end)
    return attached
end

skinState.apply = function(active, character)
    skinState.generation = (skinState.generation or 0) + 1
    local generation = skinState.generation
    character = character or LP.Character
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    if generation ~= skinState.generation then return false end

    if active then
        local preset = skinState.presets[skinChangerMode] or skinState.presets.V1
        local shirtTemplate = skinState.resolveTemplate(preset.shirt, "Shirt", "ShirtTemplate")
        local pantsTemplate = skinState.resolveTemplate(preset.pants, "Pants", "PantsTemplate")
        if generation ~= skinState.generation or not skinChangerEnabled or LP.Character ~= character then
            return false
        end
        skinState.capture(character)
        skinState.removeChanged(character)

        local shirt = Instance.new("Shirt")
        shirt.Name = "Shirt"
        shirt.ShirtTemplate = shirtTemplate
        shirt.Parent = character

        local pants = Instance.new("Pants")
        pants.Name = "Pants"
        pants.PantsTemplate = pantsTemplate
        pants.Parent = character

        return skinState.attachHair(character, humanoid, preset.hair, generation)
    end

    local original = skinState.originals[character]
    skinState.removeChanged(character)
    if original and original.items then
        for _, item in ipairs(original.items) do
            local clone = item:Clone()
            pcall(function()
                clone.Parent = character
                if clone:IsA("Accessory") and humanoid and humanoid.AddAccessory then
                    pcall(function() humanoid:AddAccessory(clone) end)
                end
            end)
        end
    end
    return true
end

function setSkinChangerEnabled(on)
    skinChangerEnabled = on and true or false
    task.spawn(function()
        pcall(skinState.apply, skinChangerEnabled, LP.Character)
    end)
    if setSkinChangerVisual then setSkinChangerVisual(skinChangerEnabled) end
end

function cycleSkinChangerMode(dir)
    local order = { "V1", "V2", "V3" }
    local idx = 1
    for i, m in ipairs(order) do
        if m == skinChangerMode then idx = i; break end
    end
    idx = idx + (dir or 1)
    if idx < 1 then idx = #order end
    if idx > #order then idx = 1 end
    skinChangerMode = order[idx]
    if skinModeSelectorLabel then skinModeSelectorLabel.Text = skinChangerMode end
    if skinChangerEnabled then
        task.spawn(function() pcall(skinState.apply, true, LP.Character) end)
    end
    return skinChangerMode
end


function loadObjectsStd(id)
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
    if ok and res then return {res} end
    return nil
end

function applyHeadlessKorblox(char)
    if not char then return end
    pcall(function() LP.CharacterAvatarType = Enum.AvatarType.R6 end)
    local head = char:FindFirstChild("Head")
    if head then
        if head:GetAttribute("ExoticHubOutfitOriginalTransparency") == nil then
            head:SetAttribute("ExoticHubOutfitOriginalTransparency", head.Transparency)
            head:SetAttribute("ExoticHubOutfitOriginalLocalTransparency", head.LocalTransparencyModifier)
        end
        head.Transparency = 1
        head.CanCollide = false
        head.LocalTransparencyModifier = 1
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 1 end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = false end
    end)
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            local w = v:FindFirstChildWhichIsA("Weld") or v:FindFirstChildWhichIsA("WeldConstraint") or v:FindFirstChildWhichIsA("Motor6D")
            if w then
                local p0, p1 = w.Part0, w.Part1
                if (p0 and p0.Name == "Head") or (p1 and p1.Name == "Head") then
                    for _, part in ipairs(v:GetDescendants()) do
                        if part:IsA("BasePart") then
                            if part:GetAttribute("ExoticHubOutfitOriginalTransparency") == nil then
                                part:SetAttribute("ExoticHubOutfitOriginalTransparency", part.Transparency)
                                part:SetAttribute("ExoticHubOutfitOriginalLocalTransparency", part.LocalTransparencyModifier)
                            end
                            part.Transparency = 1
                            part.LocalTransparencyModifier = 1
                        end
                    end
                end
            end
        end
    end
    local rightLegConfig = { id = "rbxassetid://139607718", targetBodyPart = "RightUpperLeg", partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}, scale = _V3new(1, 1, 1), offset = _CFnew(0, 0, 0) }
    local targetPart = char:FindFirstChild(rightLegConfig.targetBodyPart)
    if targetPart then
        local oldAsset = char:FindFirstChild("Korblox_RightLeg")
        if oldAsset then oldAsset:Destroy() end
        for _, partName in ipairs(rightLegConfig.partsToHide) do
            local limb = char:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then
                if limb:GetAttribute("ExoticHubOutfitOriginalTransparency") == nil then
                    limb:SetAttribute("ExoticHubOutfitOriginalTransparency", limb.Transparency)
                end
                limb.Transparency = 1
            end
        end
        local success, objects = pcall(function() return game:GetObjects(rightLegConfig.id) end)
        if success and objects and #objects > 0 then
            local assetModel = objects[1]
            assetModel.Name = "Korblox_RightLeg"
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if mainMesh then
                mainMesh.Size = mainMesh.Size * rightLegConfig.scale
                mainMesh.CanCollide = false
                mainMesh.CFrame = targetPart.CFrame * rightLegConfig.offset
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = targetPart
                weld.Part1 = mainMesh
                weld.Parent = mainMesh
                assetModel.Parent = char
            end
        end
    end
end

function applyOutfitByIndex(index)
    local cfg = OUTFITS[index]
    if not cfg then return end
    local char = LP.Character
    if not char then return end
    clearPreviousOutfitAssets(char)
    if cfg.customApply then
        cfg.customApply(char)
        if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
        return
    end
    char:WaitForChild("Head", 5)
    local head = char:FindFirstChild("Head")
    if not head then return end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local done = false
    if head:IsA("MeshPart") then
        done = pcall(function()
            if not head:GetAttribute("ExoticHubOutfitModifiedMeshPart") then
                head:SetAttribute("ExoticHubOutfitOriginalMeshId", head.MeshId)
                head:SetAttribute("ExoticHubOutfitOriginalTextureId", head.TextureID)
                head:SetAttribute("ExoticHubOutfitModifiedMeshPart", true)
            end
            head.MeshId = cfg.headMesh
            head.TextureID = cfg.headTexture or ""
        end)
    end
    if not done then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if not sm then
            sm = Instance.new("SpecialMesh")
            sm:SetAttribute("ExoticHubOutfitCreatedMesh", true)
        elseif not sm:GetAttribute("ExoticHubOutfitModifiedMesh") then
            sm:SetAttribute("ExoticHubOutfitOriginalMeshId", sm.MeshId)
            sm:SetAttribute("ExoticHubOutfitOriginalTextureId", sm.TextureId)
            sm:SetAttribute("ExoticHubOutfitModifiedMesh", true)
        end
        sm.Parent = head
        sm.MeshType = Enum.MeshType.FileMesh
        sm.MeshId = cfg.headMesh
        sm.TextureId = cfg.headTexture or ""
    end
    if cfg.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"
        s.ShirtTemplate = cfg.shirt
        s.Parent = char
    end
    if cfg.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"
        p.PantsTemplate = cfg.pants
        p.Parent = char
    end
    local old = char:FindFirstChild("AuFfitAccessory")
    if old then old:Destroy() end
    if cfg.accessory and head then
        local objs = loadObjectsStd(cfg.accessory)
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o; break end
                local f = o:FindFirstChildWhichIsA("BasePart", true)
                if f then handle = f; break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "AuFfitAccessory"
                h.CanCollide = false
                h.Anchored = false
                h.Massless = true
                h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head
                weld.Part1 = h
                weld.C0 = _CFnew(cfg.offset)
                weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    if cfg.headlessKorblox then
        applyHeadlessKorblox(char)
    else
        if char then
            local head2 = char:FindFirstChild("Head")
            if head2 then
                head2.Transparency = 0
                head2.CanCollide = true
                head2.LocalTransparencyModifier = 0
                local face2 = head2:FindFirstChild("face")
                if face2 then face2.Transparency = 0 end
            end
            pcall(function()
                local neck = char:FindFirstChild("Neck")
                if neck then neck.Enabled = true end
            end)
            for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
                local limb = char:FindFirstChild(partName)
                if limb then limb.Transparency = 0 end
            end
            local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
            if oldKorblox then oldKorblox:Destroy() end
        end
    end
    if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
end

selectedStealMode = "V1"
autoGrabModePill = nil -- TextButton on Auto Grab bar (NORM / SEMI)

function updateAutoGrabModePill(mode)
    mode = mode or selectedStealMode
    local isSemi = (mode == "V2" or mode == "Semi" or mode == true)
    local text = isSemi and "SEMI" or "NORM"
    local pill = autoGrabModePill
    if not pill and pbFrame then
        pill = pbFrame:FindFirstChild("ModePill")
    end
    if not pill and gui then
        local bar = gui:FindFirstChild("SyeHubAutoGrabBar", true)
        if bar then pill = bar:FindFirstChild("ModePill") end
    end
    if pill then
        pill.Text = text
        autoGrabModePill = pill
    end
end


_G._exoticHubStealModeSetter = _G._exoticHubStealModeSetter or function() end
_G._exoticHubStealSlide = _G._exoticHubStealSlide or nil


speedMode = false
antiRagdollMode = "off"
_antiRagLastOn = "v2"
antiDieEnabled = false
antiBatEnabled = false
antiFlingEnabled = false
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
aimbotMode = "normal"  -- "normal" | "antiBatBypass"
aimbotModeLabel = nil
dropMode = 1
antiLagEnabled = false
removeAccessoriesEnabled = false
stretchEnabled = false
stretchFOV = 120
uiLocked = false
mobileButtonsLocked = false
uiScaleValue = 78
stealBarScale = 70
espEnabled = false
baseEspEnabled = false
brainrotEspEnabled = false
esp2Enabled = false
_baseEspFolder = nil
_brainrotEspFolder = nil
espLineEnabled = false

safeModeEnabled = false
e01TimerEnabled = true
setSafeModeVisual = nil
setE01TimerVisual = nil

vividGraphicsEnabled = false
shinyModeEnabled = false
fps120Mode = false
_shinyConn = nil
_vividEffects = {}
setVividVisual = nil

hideButtonsEnabled = false
setHideButtonsVisual = nil


autoCarryEnabled = false
setAutoCarryVisual = nil
bodyLockRangeRow = nil
ragdollStealEnabled = false
setRagdollStealVisual = nil
autoSwingEnabled = false
setAutoSwingVisual = nil
mirrorTpEnabled = false
setMirrorTpVisual = nil
ragdollCounterEnabled = false
setRagdollCounterVisual = nil
lowGraphicsEnabled = false
setLowGraphicsVisual = nil

bodyLockEnabled = false
bodyLockRange = 20
bodyLockHeight = 20
bodyLockRangeBox = nil
_bodyLockConn = nil
_blSuppressCount = 0
_blWasEnabled = false
_blRestoreTimer = nil
_blSmoothRestore = false

savedProgressBarPos = nil
savedButtonPositions = {}
        mobileButtonCircleMode = false
savedMobilePanelPos = nil
tpBatFloatingPos = nil
instaResetFloatingPos = nil
instaResetFloatingButton = nil

neonWeatherEnabled = false
skyTheme = "Off"
skySelectorLabel = nil
_originalLighting = nil
setNeonWeatherVisual = nil

currentAnimPack = "Off"
originalTryardAnims = nil
tryardHeartbeatConn = nil
animSelectorLabel = nil

lastMoveDir = _V3zero

CoreGui = game:GetService("CoreGui")

local InfiniteJump = { enabled = false, jumpPower = 50, minVelocity = 50, fallClamp = -120, mode = "Hold", jumpConn = nil, heartbeatConn = nil, jumpingConn = nil, _forceJump = false, _charHooked = false }

InfiniteJump._forceJump = false

function applyJump(root)
    if not root then return end
    local power = tonumber(InfiniteJump.jumpPower) or 50
    pcall(function()
        local vel = root.AssemblyLinearVelocity or root.Velocity
        local boosted = _V3new(vel.X, power, vel.Z)
        root.AssemblyLinearVelocity = boosted
        if root.Velocity then root.Velocity = boosted end
    end)
end

function onJumpRequest()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then applyJump(root) end
end

-- Space X Hook hold style: when Jump held or forceJump, keep Y at jumpPower if below threshold
function onHeartbeat()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local mode = InfiniteJump.mode or "Hold"
    local vel = root.AssemblyLinearVelocity or root.Velocity
    local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true) or InfiniteJump._forceJump
    if mode == "Hold" then
        if jumpHeld then
            local minV = tonumber(InfiniteJump.minVelocity) or 50
            if not vel or vel.Y < minV then
                applyJump(root)
            end
        end
    end
    vel = root.AssemblyLinearVelocity or root.Velocity
    if vel and vel.Y < (tonumber(InfiniteJump.fallClamp) or -120) then
        local clamped = _V3new(vel.X, InfiniteJump.fallClamp or -120, vel.Z)
        pcall(function()
            root.AssemblyLinearVelocity = clamped
            if root.Velocity then root.Velocity = clamped end
        end)
    end
end

function connectEvents()
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect() end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect() end
    if InfiniteJump.jumpingConn then InfiniteJump.jumpingConn:Disconnect(); InfiniteJump.jumpingConn = nil end
    InfiniteJump.jumpConn = UIS.JumpRequest:Connect(onJumpRequest)
    InfiniteJump.heartbeatConn = RunService.Heartbeat:Connect(onHeartbeat)
    -- Space X style: brief forceJump pulse on Humanoid.Jumping
    local function hookJumping(char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if InfiniteJump.jumpingConn then InfiniteJump.jumpingConn:Disconnect() end
        InfiniteJump.jumpingConn = hum.Jumping:Connect(function()
            if not InfiniteJump.enabled then return end
            InfiniteJump._forceJump = true
            task.delay(0.1, function() InfiniteJump._forceJump = false end)
        end)
    end
    if LP.Character then hookJumping(LP.Character) end
    if not InfiniteJump._charHooked then
        InfiniteJump._charHooked = true
        LP.CharacterAdded:Connect(function(char)
            task.wait(0.2)
            if InfiniteJump.enabled then hookJumping(char) end
        end)
    end
end

function InfiniteJump.start()
    if InfiniteJump.enabled then return end
    InfiniteJump.enabled = true
    connectEvents()
end

function InfiniteJump.stop()
    InfiniteJump.enabled = false
    InfiniteJump._forceJump = false
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect(); InfiniteJump.jumpConn = nil end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect(); InfiniteJump.heartbeatConn = nil end
    if InfiniteJump.jumpingConn then InfiniteJump.jumpingConn:Disconnect(); InfiniteJump.jumpingConn = nil end
end

function InfiniteJump.setJumpPower(power)
    power = tonumber(power) or 55
    InfiniteJump.jumpPower = _clamp(power, 10, 200)
end

function InfiniteJump.isRunning() return InfiniteJump.enabled == true end

-- =====================================================================
-- SPIN BOT (on brainrot hold)
-- =====================================================================
local function _playerHasBrainrot()
    local char = LP.Character
    if not char then return false end
    for _, ch in ipairs(char:GetChildren()) do
        local n = string.lower(ch.Name or "")
        if n:find("brainrot") or n:find("animal") or n:find("steal") then
            return true
        end
        if ch:IsA("Tool") and (n:find("brain") or n:find("rot") or n:find("pet")) then
            return true
        end
    end
    -- also check backpack-held via character attribute
    if char:GetAttribute("Holding") or char:GetAttribute("Carrying") then
        return true
    end
    return false
end

_spinBotYaw = 0
_spinBotSavedAutoRotate = nil
_spinBotChar = nil

local function _spinBotSetAutoRotate(char, enabled)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        if enabled then
            if _spinBotSavedAutoRotate ~= nil then
                hum.AutoRotate = _spinBotSavedAutoRotate
            else
                hum.AutoRotate = true
            end
        else
            if _spinBotSavedAutoRotate == nil or _spinBotChar ~= char then
                _spinBotSavedAutoRotate = hum.AutoRotate
                _spinBotChar = char
            end
            hum.AutoRotate = false
        end
    end)
end

function startSpinBot()
    if spinBotConn then return end
    spinBotEnabled = true
    _spinBotYaw = 0
    -- Bind after camera so shift-lock orientation does not overwrite the spin
    local priority = 350
    pcall(function()
        if Enum.RenderPriority and Enum.RenderPriority.Camera then
            priority = Enum.RenderPriority.Camera.Value + 25
        end
    end)
    local function spinStep(dt)
        if not spinBotEnabled then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        -- Spin bot on brainrot only
        if not _playerHasBrainrot() then
            _spinBotSetAutoRotate(char, true)
            return
        end
        _spinBotSetAutoRotate(char, false)
        local spd = tonumber(spinBotSpeed) or 12
        dt = dt or 0.016
        _spinBotYaw = (_spinBotYaw + math.rad(spd * 60 * dt)) % (math.pi * 2)
        pcall(function()
            local pos = hrp.Position
            hrp.CFrame = CFrame.new(pos) * CFrame.Angles(0, _spinBotYaw, 0)
            if hrp.AssemblyAngularVelocity then
                local av = hrp.AssemblyAngularVelocity
                hrp.AssemblyAngularVelocity = Vector3.new(0, av.Y, 0)
            end
        end)
    end
    local bound = false
    pcall(function()
        RunService:BindToRenderStep("SyeSpinBot", priority, spinStep)
        bound = true
    end)
    if bound then
        spinBotConn = { Disconnect = function()
            pcall(function() RunService:UnbindFromRenderStep("SyeSpinBot") end)
        end }
    else
        spinBotConn = RunService.RenderStepped:Connect(spinStep)
    end
end

function stopSpinBot()
    spinBotEnabled = false
    if spinBotConn then
        pcall(function() spinBotConn:Disconnect() end)
        spinBotConn = nil
    end
    pcall(function() RunService:UnbindFromRenderStep("SyeSpinBot") end)
    local char = LP.Character
    if char then
        _spinBotSetAutoRotate(char, true)
    end
    _spinBotSavedAutoRotate = nil
    _spinBotChar = nil
end

-- =====================================================================
-- ANTI LOSE (protect brainrot / stand up near death)
-- =====================================================================
function startAntiLose()
    if antiLoseConn then return end
    antiLoseEnabled = true
    antiLoseConn = RunService.Heartbeat:Connect(function()
        if not antiLoseEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp or hum.Health <= 0 then return end
        if hum.PlatformStand or hum:GetState() == Enum.HumanoidStateType.Physics
            or hum:GetState() == Enum.HumanoidStateType.Ragdoll
            or hum:GetState() == Enum.HumanoidStateType.FallingDown then
            pcall(function()
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
        -- soft health floor while holding
        if _playerHasBrainrot() and hum.Health < 15 and hum.Health > 0 then
            pcall(function()
                hum.Health = math.max(hum.Health, 25)
            end)
        end
    end)
end

function stopAntiLose()
    antiLoseEnabled = false
    if antiLoseConn then
        antiLoseConn:Disconnect()
        antiLoseConn = nil
    end
end

-- =====================================================================
-- HALLOWEEN MODE
-- =====================================================================
function applyHalloweenMode(on)
    -- Halloween mode removed
    halloweenMode = false
end

-- =====================================================================
-- TAB LAYOUT (Left / Right / Top / Bottom)
-- =====================================================================
function applyUILayout(mode)
    mode = mode or uiLayoutMode or "Left"
    uiLayoutMode = mode
    if main then
        if not tabBar then tabBar = main:FindFirstChild("TabBar") end
        if not tabContent then tabContent = main:FindFirstChild("TabContent") end
    end
    if not main or not tabBar or not tabContent then return end
    local TAB_W = 86
    local TAB_H = 44
    local tabLayout = tabBar:FindFirstChildOfClass("UIListLayout")
    if mode == "Left" then
        tabBar.Size = UDim2.new(0, TAB_W, 1, -108)
        tabBar.Position = UDim2.new(0, 6, 0, 96)
        if tabLayout then
            tabLayout.FillDirection = Enum.FillDirection.Vertical
            tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            tabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        end
        for _, b in ipairs(tabButtons or {}) do
            b.Size = UDim2.new(1, 0, 0, 36)
        end
        tabContent.Size = UDim2.new(1, -TAB_W - 16, 1, -108)
        tabContent.Position = UDim2.new(0, TAB_W + 12, 0, 96)
    elseif mode == "Right" then
        tabBar.Size = UDim2.new(0, TAB_W, 1, -108)
        tabBar.Position = UDim2.new(1, -TAB_W - 6, 0, 96)
        if tabLayout then
            tabLayout.FillDirection = Enum.FillDirection.Vertical
            tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            tabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        end
        for _, b in ipairs(tabButtons or {}) do
            b.Size = UDim2.new(1, 0, 0, 36)
        end
        tabContent.Size = UDim2.new(1, -TAB_W - 16, 1, -108)
        tabContent.Position = UDim2.new(0, 8, 0, 96)
    elseif mode == "Top" then
        tabBar.Size = UDim2.new(1, -12, 0, TAB_H)
        tabBar.Position = UDim2.new(0, 6, 0, 92)
        if tabLayout then
            tabLayout.FillDirection = Enum.FillDirection.Horizontal
            tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        end
        for _, b in ipairs(tabButtons or {}) do
            b.Size = UDim2.new(0, 60, 1, -6)
        end
        tabContent.Size = UDim2.new(1, -12, 1, -148)
        tabContent.Position = UDim2.new(0, 6, 0, 140)
    else -- Bottom
        tabBar.Size = UDim2.new(1, -12, 0, TAB_H)
        tabBar.Position = UDim2.new(0, 6, 1, -TAB_H - 6)
        if tabLayout then
            tabLayout.FillDirection = Enum.FillDirection.Horizontal
            tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        end
        for _, b in ipairs(tabButtons or {}) do
            b.Size = UDim2.new(0, 60, 1, -6)
        end
        tabContent.Size = UDim2.new(1, -12, 1, -148)
        tabContent.Position = UDim2.new(0, 6, 0, 96)
    end
end

-- =====================================================================
-- CUSTOM FONT
-- =====================================================================
function applyCustomFont(name)
    customFontName = name or "Gotham"
    local fontEnum = Enum.Font.Gotham
    for _, pair in ipairs(CUSTOM_FONTS or {}) do
        if pair[1] == customFontName then fontEnum = pair[2]; break end
    end
    if main then
        for _, d in ipairs(main:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                pcall(function() d.Font = fontEnum end)
            end
        end
    end
    if scriptLogo then pcall(function() scriptLogo.Font = Enum.Font.GothamBlack end) end
end


pcall(InfiniteJump.start)

function getActiveMoveSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED
    elseif laggerToggled then return LAGGER_SPEED
    elseif speedMode then return CS
    else
        if normalSpeedMode == "v2" then return NS_V2 or 72 end
        return NS
    end
end

function getSpeedModeName()
    -- [HARDCODED FIX] distinguish lagger vs lagger carry
    if laggerCarryToggled then return "LAGGER CARRY" end
    if laggerToggled then return "LAGGER" end
    if speedMode then return "CARRY" end
    return "NORMAL"
end

-- =====================================================================
-- [FIX SPEED VIOLETTE] VELOCITY HOOK
-- Ahora instala DOS hooks sobre el metatable de game:
--   __index:    devuelve _s2VelState.v (velocidad fake) a contexto externo
--   __newindex: captura escrituras externas sin aplicarlas
-- Además usa un storage compartido en _s2VelState.v para el valor visible.
-- =====================================================================
local _s2VelState = _G.__ExoticHubSpeedHookState
if type(_s2VelState) ~= "table" then
    _s2VelState = {
        hooked = false,
        velChecked = setmetatable({}, { __mode = "k" }),
        root = nil,
        v = _V3zero,
    }
    _G.__ExoticHubSpeedHookState = _s2VelState
end
_velChecked = _s2VelState.velChecked
_hookedVelParts = {}

_hookVelSupported = nil
function _hookVelHRP(hrp)
    if not hrp then return end
    _s2VelState.root = hrp
    _velChecked[hrp] = true
    if _s2VelState.hooked then return end
    if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function"
       or type(newcclosure) ~= "function" or type(checkcaller) ~= "function" then
        return
    end
    local ok = pcall(function()
        local mt = getrawmetatable(game)
        if not mt then return end

        setreadonly(mt, false)

        local originalIndex = rawget(mt, "__index")
        local originalNewIndex = rawget(mt, "__newindex")

        local function isOurRoot(t, k)
            local tk = tostring(k)
            if tk ~= "AssemblyLinearVelocity" and tk ~= "Velocity" then return false end
            if typeof(t) ~= "Instance" or not t:IsA("BasePart") then return false end
            local tn = t.Name
            if tn ~= "HumanoidRootPart" and tn ~= "Torso" and tn ~= "UpperTorso" then return false end
            local char = LP.Character
            return char ~= nil and t:IsDescendantOf(char)
        end

        if type(originalIndex) == "function" or type(originalIndex) == "table" then
            local replacementIndex = newcclosure(function(self, key)
                if not checkcaller() then
                    local good, mine = pcall(isOurRoot, self, key)
                    if good and mine then return _s2VelState.v end
                end
                if type(originalIndex) == "function" then
                    return originalIndex(self, key)
                else
                    return originalIndex[key]
                end
            end)
            mt.__index = replacementIndex
        end

        if type(originalNewIndex) == "function" then
            local replacementNewIndex = newcclosure(function(self, key, value)
                if not checkcaller() then
                    local good, mine = pcall(isOurRoot, self, key)
                    if good and mine then
                        _s2VelState.v = value
                        return
                    end
                end
                return originalNewIndex(self, key, value)
            end)
            mt.__newindex = replacementNewIndex
        end

        setreadonly(mt, true)
        _s2VelState.hooked = true
    end)
    if not ok then _s2VelState.hooked = false end
end

function _setupVelChecked(char)
    _velChecked = setmetatable({}, { __mode = "k" })
    _s2VelState.velChecked = _velChecked
    if not char then _s2VelState.root = nil; return nil end
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if hrp then
        _s2VelState.root = hrp
        _velChecked[hrp] = true
    end
    return hrp
end

if LP.Character then
    local _hrp0 = _setupVelChecked(LP.Character)
    _hookVelHRP(_hrp0)
end

function _isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand
        or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
end

-- [FIX SPEED VIOLETTE] aplica velocidad con jitter + oculta la real al juego.
-- El juego verá _s2VelState.v = 16 (fake). Nosotros aplicamos la real en
-- AssemblyLinearVelocity directamente (checkcaller bypass).
_exoticHubVelRng = Random.new()

function _applyVelocitySpeed(dir, speed, hrp)
    if not hrp or not hrp.Parent then return end
    if batDesyncTpEnabled or autoBatEnabled then return end
    if type(speed) ~= "number" or speed ~= speed or speed <= 0 or speed == math.huge then return end

    local verticalVelocity = hrp.AssemblyLinearVelocity.Y

    if dir and dir.Magnitude > 0.05 then
        pcall(function()
            if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP) end
        end)
        local unit = dir.Unit
        local jx = _exoticHubVelRng:NextNumber(-0.003, 0.003)
        local jz = _exoticHubVelRng:NextNumber(-0.003, 0.003)

        -- Velocidad falsa que el juego verá cuando consulte desde código externo
        _s2VelState.v = _V3new(unit.X * 16 + jx, verticalVelocity, unit.Z * 16 + jz)

        -- Velocidad real aplicada directamente al root (checkcaller=true)
        hrp.AssemblyLinearVelocity = _V3new(unit.X * speed + jx, verticalVelocity, unit.Z * speed + jz)
        -- Marca de "live speed" para que el Anti Fling no cancele nuestra propia velocidad
        _G.__ExoticHubLiveSpeed = { t = os.clock(), v = speed }
    else
        _s2VelState.v = _V3new(0, verticalVelocity, 0)
        hrp.AssemblyLinearVelocity = _V3new(0, verticalVelocity, 0)
    end
end

function getAutoPathSpeed()
    -- [HARDCODED FIX]
    if laggerCarryToggled then return LAGGER_CARRY_SPEED end
    if laggerToggled then return LAGGER_SPEED end
    return NS
end

ANIM_PACKS = {
    ["Zombie"] = { idle1="rbxassetid://616158929", idle2="rbxassetid://616160636", walk="rbxassetid://616168032", run="rbxassetid://616163682", jump="rbxassetid://616161997", fall="rbxassetid://616157476", climb="rbxassetid://616156119", swim="rbxassetid://616165109", swimidle="rbxassetid://616166655" },
    ["Ninja"] = { idle1="rbxassetid://656117400", idle2="rbxassetid://656117400", walk="rbxassetid://656121766", run="rbxassetid://656118852", jump="rbxassetid://656117878", fall="rbxassetid://656115606", climb="rbxassetid://656114359", swim="rbxassetid://656117400", swimidle="rbxassetid://656117400" },
    ["Knight"] = { idle1="rbxassetid://657595757", idle2="rbxassetid://657595757", walk="rbxassetid://657552124", run="rbxassetid://657564596", jump="rbxassetid://658409194", fall="rbxassetid://657600338", climb="rbxassetid://658360781", swim="rbxassetid://657595757", swimidle="rbxassetid://657595757" },
    ["Elder"] = { idle1="rbxassetid://845397899", idle2="rbxassetid://845397899", walk="rbxassetid://845403856", run="rbxassetid://845386501", jump="rbxassetid://845398858", fall="rbxassetid://845397673", climb="rbxassetid://845392038", swim="rbxassetid://845397899", swimidle="rbxassetid://845397899" },
    ["Levitate"] = { idle1="rbxassetid://616006778", idle2="rbxassetid://616006778", walk="rbxassetid://616013216", run="rbxassetid://616013216", jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://616003713", swim="rbxassetid://616006778", swimidle="rbxassetid://616006778" },
    ["Astronaut"] = { idle1="rbxassetid://891621366", idle2="rbxassetid://891621366", walk="rbxassetid://891636393", run="rbxassetid://891636393", jump="rbxassetid://891627522", fall="rbxassetid://891617961", climb="rbxassetid://891609353", swim="rbxassetid://891621366", swimidle="rbxassetid://891621366" },
    ["Pirate"] = { idle1="rbxassetid://750781874", idle2="rbxassetid://750781874", walk="rbxassetid://750785693", run="rbxassetid://750783738", jump="rbxassetid://750782230", fall="rbxassetid://750780242", climb="rbxassetid://750779899", swim="rbxassetid://750781874", swimidle="rbxassetid://750781874" },
    ["Toy"] = { idle1="rbxassetid://782841498", idle2="rbxassetid://782841498", walk="rbxassetid://782843345", run="rbxassetid://782842708", jump="rbxassetid://782847020", fall="rbxassetid://782846423", climb="rbxassetid://782843869", swim="rbxassetid://782841498", swimidle="rbxassetid://782841498" },
    ["Vampire"] = { idle1="rbxassetid://1083445855", idle2="rbxassetid://1083445855", walk="rbxassetid://1083473930", run="rbxassetid://1083462077", jump="rbxassetid://1083455352", fall="rbxassetid://1083443587", climb="rbxassetid://1083439238", swim="rbxassetid://1083445855", swimidle="rbxassetid://1083445855" },
    ["Werewolf"] = { idle1="rbxassetid://1083195517", idle2="rbxassetid://1083195517", walk="rbxassetid://1083178339", run="rbxassetid://1083216690", jump="rbxassetid://1083218792", fall="rbxassetid://1083189019", climb="rbxassetid://1083182000", swim="rbxassetid://1083195517", swimidle="rbxassetid://1083195517" },
    ["Rthro"] = { idle1="rbxassetid://2510196951", idle2="rbxassetid://2510196951", walk="rbxassetid://2510202577", run="rbxassetid://2510198475", jump="rbxassetid://2510197830", fall="rbxassetid://2510195892", climb="rbxassetid://2510192778", swim="rbxassetid://2510196951", swimidle="rbxassetid://2510196951" },
    ["Stylish"] = { idle1="rbxassetid://616136790", idle2="rbxassetid://616136790", walk="rbxassetid://616146177", run="rbxassetid://616140816", jump="rbxassetid://616139451", fall="rbxassetid://616134815", climb="rbxassetid://616133594", swim="rbxassetid://616136790", swimidle="rbxassetid://616136790" },
}

ANIM_PACK_ORDER = {{"Off", "Off"}, {"Zombie", "Zombie"}, {"Ninja", "Ninja"}, {"Knight", "Knight"}, {"Elder", "Elder"}, {"Levitate", "Levitate"}, {"Astronaut", "Astronaut"}, {"Pirate", "Pirate"}, {"Toy", "Toy"}, {"Vampire", "Vampire"}, {"Werewolf", "Werewolf"}, {"Rthro", "Rthro"}, {"Stylish", "Stylish"}}

function isPackAnim(id)
    for _, pack in pairs(ANIM_PACKS) do
        for _, v in pairs(pack) do
            if v == id then return true end
        end
    end
    return false
end

function saveOriginalAnims(char)
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    local function g(obj) return obj and obj.AnimationId or nil end
    local ids = {
        idle1 = g(animate.idle and animate.idle.Animation1),
        idle2 = g(animate.idle and animate.idle.Animation2),
        walk  = g(animate.walk and animate.walk.WalkAnim),
        run   = g(animate.run  and animate.run.RunAnim),
        jump  = g(animate.jump and animate.jump.JumpAnim),
        fall  = g(animate.fall and animate.fall.FallAnim),
        climb = g(animate.climb and animate.climb.ClimbAnim),
        swim  = g(animate.swim and animate.swim.Swim),
        swimidle = g(animate.swimidle and animate.swimidle.SwimIdle),
    }
    if not isPackAnim(ids.walk) then originalTryardAnims = ids end
end

function applyAnimPack(packName)
    currentAnimPack = packName
    if animSelectorLabel then animSelectorLabel.Text = packName end
    if packName == "Off" then
        if originalTryardAnims and LP.Character then
            local animate = LP.Character:FindFirstChild("Animate")
            if animate then
                local function s(obj,id) if obj then obj.AnimationId = id end end
                s(animate.idle and animate.idle.Animation1, originalTryardAnims.idle1)
                s(animate.idle and animate.idle.Animation2, originalTryardAnims.idle2)
                s(animate.walk and animate.walk.WalkAnim, originalTryardAnims.walk)
                s(animate.run  and animate.run.RunAnim,   originalTryardAnims.run)
                s(animate.jump and animate.jump.JumpAnim, originalTryardAnims.jump)
                s(animate.fall and animate.fall.FallAnim, originalTryardAnims.fall)
                s(animate.climb and animate.climb.ClimbAnim, originalTryardAnims.climb)
                s(animate.swim and animate.swim.Swim, originalTryardAnims.swim)
                s(animate.swimidle and animate.swimidle.SwimIdle, originalTryardAnims.swimidle)
            end
        end
        if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect(); tryardHeartbeatConn = nil end
        return
    end
    local pack = ANIM_PACKS[packName]
    if not pack then return end
    if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect() end
    tryardHeartbeatConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        if not c then return end
        local animate = c:FindFirstChild("Animate")
        if not animate then return end
        local function s(obj,id) if obj then obj.AnimationId = id end end
        s(animate.idle and animate.idle.Animation1, pack.idle1)
        s(animate.idle and animate.idle.Animation2, pack.idle2)
        s(animate.walk and animate.walk.WalkAnim, pack.walk)
        s(animate.run  and animate.run.RunAnim,   pack.run)
        s(animate.jump and animate.jump.JumpAnim, pack.jump)
        s(animate.fall and animate.fall.FallAnim, pack.fall)
        s(animate.climb and animate.climb.ClimbAnim, pack.climb)
        s(animate.swim and animate.swim.Swim, pack.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, pack.swimidle)
    end)
end

function startAnimPack(packName)
    -- [HARDCODED FIX] wait for Animate on respawn then force re-apply
    currentAnimPack = packName
    if animSelectorLabel then animSelectorLabel.Text = tostring(packName) end
    local char = LP.Character
    if not char then
        applyAnimPack(packName)
        return
    end
    task.spawn(function()
        local animate = char:FindFirstChild("Animate") or char:WaitForChild("Animate", 10)
        if not char.Parent then return end
        pcall(saveOriginalAnims, char)
        applyAnimPack(packName)
        task.wait(0.2)
        if not char.Parent then return end
        applyAnimPack(packName)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:Stop(0) end
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                task.wait()
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
    end)
end

function stopAnimPack()
    currentAnimPack = "Off"
    if animSelectorLabel then animSelectorLabel.Text = "Off" end
    applyAnimPack("Off")
end

DEFAULT_KB = {
    DropBrainrot = {kb = Enum.KeyCode.X, gp = nil},
    AutoLeft     = {kb = Enum.KeyCode.Z, gp = nil},
    AutoRight    = {kb = Enum.KeyCode.C, gp = nil},
    AutoBat      = {kb = Enum.KeyCode.E, gp = nil},
    TPFloor      = {kb = Enum.KeyCode.F, gp = nil},
    GuiHide      = {kb = Enum.KeyCode.LeftControl, gp = nil},
    CarryToggle  = {kb = Enum.KeyCode.Q, gp = nil},
    LaggerMode   = {kb = Enum.KeyCode.R, gp = nil},
    TPBat        = {kb = Enum.KeyCode.V, gp = nil},
    InstaReset   = {kb = Enum.KeyCode.H, gp = nil},
}

KB = {
    DropBrainrot = {kb = DEFAULT_KB.DropBrainrot.kb, gp = DEFAULT_KB.DropBrainrot.gp},
    AutoLeft     = {kb = DEFAULT_KB.AutoLeft.kb, gp = DEFAULT_KB.AutoLeft.gp},
    AutoRight    = {kb = DEFAULT_KB.AutoRight.kb, gp = DEFAULT_KB.AutoRight.gp},
    AutoBat      = {kb = DEFAULT_KB.AutoBat.kb, gp = DEFAULT_KB.AutoBat.gp},
    TPFloor      = {kb = DEFAULT_KB.TPFloor.kb, gp = DEFAULT_KB.TPFloor.gp},
    GuiHide      = {kb = DEFAULT_KB.GuiHide.kb, gp = DEFAULT_KB.GuiHide.gp},
    CarryToggle  = {kb = DEFAULT_KB.CarryToggle.kb, gp = DEFAULT_KB.CarryToggle.gp},
    LaggerMode   = {kb = DEFAULT_KB.LaggerMode.kb, gp = DEFAULT_KB.LaggerMode.gp},
    TPBat        = {kb = DEFAULT_KB.TPBat.kb, gp = DEFAULT_KB.TPBat.gp},
    InstaReset   = {kb = DEFAULT_KB.InstaReset.kb, gp = DEFAULT_KB.InstaReset.gp},
}

_isResetting = false
_lastSavedJSON = nil
_isLoading = false

CONFIG = { AUTO_STEAL_ENABLED = false, STEAL_RANGE = 61 }

plots = Workspace:FindFirstChild("Plots")
stealConnection = nil

local Steal = { AutoStealEnabled = false, StealRadius = CONFIG.STEAL_RANGE, StealDuration = 1.3, StealDelay = 0.25, Data = {} }  -- Auto Grab core

isStealing = false
autoGrabSetDelayRadius = 9
autoGrabStopTime = 0.96
autoGrabStopEnabled = true
-- Auto Grab pause % (hold stops at this bar % before range/finish phase)
autoGrabPausePct = 85 -- one of 75, 80, 85, 90, 95
AUTO_GRAB_PAUSE_OPTIONS = {75, 80, 85, 90, 95}
autoGrabPauseSelectorLabel = nil

function getAutoGrabPauseFraction()
    local p = tonumber(autoGrabPausePct) or 85
    if p > 1 then p = p / 100 end
    return math.clamp(p, 0.5, 0.99)
end

function cycleAutoGrabPause(dir)
    local opts = AUTO_GRAB_PAUSE_OPTIONS or {75, 80, 85, 90, 95}
    local cur = tonumber(autoGrabPausePct) or 85
    local idx = 1
    for i, v in ipairs(opts) do
        if v == cur then idx = i; break end
    end
    idx = idx + (dir or 1)
    if idx < 1 then idx = #opts end
    if idx > #opts then idx = 1 end
    autoGrabPausePct = opts[idx]
    if autoGrabPauseSelectorLabel then
        autoGrabPauseSelectorLabel.Text = tostring(autoGrabPausePct) .. "%"
    end
    return autoGrabPausePct
end

-- Normal-mode auto-steal timing variants (from new Normal logic)
autoStealVariant = 1 -- 1=Normal, 2=Semi, 3=Semi Normal
AUTO_STEAL_VARIANT_NAMES = { "Normal", "Semi", "Semi Normal" }
function getAutoStealVariantName(value)
    local idx = _clamp(tonumber(value) or autoStealVariant or 1, 1, #AUTO_STEAL_VARIANT_NAMES)
    return AUTO_STEAL_VARIANT_NAMES[idx]
end
function getAutoStealDuration()
    local stealDuration = (Steal and Steal.StealDuration) or 1.3
    local v = tonumber(autoStealVariant) or 1
    if v == 2 then return stealDuration * 0.8 end
    if v == 3 then return stealDuration * 0.9 end
    return stealDuration * 0.73 -- Normal
end

_plotsCache = nil
_plotsCacheTime = 0
function getPlotsRoot()
    local now = _tick()
    if _plotsCache and now - _plotsCacheTime < 2 and _plotsCache.Parent then
        return _plotsCache
    end
    _plotsCache = workspace:FindFirstChild("Plots")
    _plotsCacheTime = now
    return _plotsCache
end

local function isMyPlotByName(plotName)
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return false end
    local plot = plotsRoot:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled == true
        end
    end
    return false
end

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return nil, nil end
    local nearestPrompt, nearestDist, nearestName = nil, _huge, nil
    local rpos = root.Position
    for _, plot in ipairs(plotsRoot:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local sp = spawn.Position
                    local dx = sp.X - rpos.X
                    local dy = sp.Y - rpos.Y
                    local dz = sp.Z - rpos.Z
                    local dist = _sqrt(dx*dx + dy*dy + dz*dz)
                    if dist < nearestDist and dist <= Steal.StealRadius then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _, child in ipairs(att:GetChildren()) do
                                if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
                                    nearestPrompt = child
                                    nearestDist = dist
                                    nearestName = pod.Name
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
    return nearestPrompt, nearestName
end

local function executeSteal(prompt, podName)
    if isStealing then return end
    if math.random(30) == 1 then
        for p in pairs(Steal.Data) do
            if not p.Parent then Steal.Data[p] = nil end
        end
    end
    if not Steal.Data[prompt] then
        Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
                end
            end
        end)
    end
    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true

    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "0%" end

    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end

        local startTime = _tick()
        local duration = Steal.StealDuration
        local promptFired = false
        -- New Normal timing: hold until getAutoStealDuration(), then range-wait phase
        local phase1Stop = (type(getAutoStealDuration) == "function" and getAutoStealDuration()) or autoGrabStopTime or 0.96

        if true then -- always use phased Normal logic
            local pauseFrac = (type(getAutoGrabPauseFraction) == "function" and getAutoGrabPauseFraction()) or 0.85
            -- prefer explicit pause % if it finishes earlier than default phase1Stop
            local pauseTime = duration * pauseFrac
            if pauseTime > 0.2 then phase1Stop = math.min(phase1Stop, pauseTime) end
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = _tick() - startTime
                if elapsed >= phase1Stop then break end
                local progress = _clamp(elapsed / duration, 0, 1)
                if progress > pauseFrac then progress = pauseFrac end
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = _floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then
                    break
                end
                task.wait()
            end

            local stopProgress = _clamp(phase1Stop / duration, 0, 1)
            if progressFill then progressFill.Size = UDim2.new(stopProgress, 0, 1, 0) end
            if progressPct then progressPct.Text = _floor(stopProgress * 100) .. "%" end

            local phase2Timeout = math.max(2.99 - phase1Stop - math.max(duration - phase1Stop, 0), 0.05)
            local phase2Start = _tick()

            while isStealing and Steal.AutoStealEnabled do
                if _tick() - phase2Start >= phase2Timeout then
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true
                    isStealing = false
                    task.wait()
                    local newPrompt, newName = findNearestPrompt()
                    if newPrompt then executeSteal(newPrompt, newName) end
                    return
                end
                if not prompt.Parent or not prompt.Parent.Parent then
                    isStealing = false
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true
                    return
                end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                    if dist <= autoGrabSetDelayRadius then
                        break
                    elseif dist > Steal.StealRadius then
                        isStealing = false
                        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                        if progressPct then progressPct.Text = "0%" end
                        data.ready = true
                        return
                    end
                end
                task.wait()
            end

            if isStealing and Steal.AutoStealEnabled then
                local fillStart = _tick()
                local fillDuration = math.max(duration - phase1Stop, 0.05)
                while true do
                    local fp = _clamp((_tick() - fillStart) / fillDuration, 0, 1)
                    local totalProgress = stopProgress + fp * (1 - stopProgress)
                    if progressFill then progressFill.Size = UDim2.new(totalProgress, 0, 1, 0) end
                    if progressPct then progressPct.Text = _floor(totalProgress * 100) .. "%" end
                    if fp >= 1 and not promptFired then
                        promptFired = true
                        pcall(function()
                            if #data.trigger > 0 then
                                for _, f in ipairs(data.trigger) do task.spawn(f) end
                            else
                                local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                                if remote and podName then remote:FireServer(podName) end
                            end
                        end)
                        break
                    end
                    task.wait()
                end
            end
        else
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = _tick() - startTime
                local progress = _clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = _floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
                if elapsed >= duration and not promptFired then
                    promptFired = true
                    pcall(function()
                        if #data.trigger > 0 then
                            for _, f in ipairs(data.trigger) do task.spawn(f) end
                        end
                        local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                        if remote and podName then remote:FireServer(podName) end
                        if prompt and prompt.Fire then pcall(function() prompt:Fire() end) end
                    end)
                    break
                end
                task.wait()
            end
        end

        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
        if progressPct then progressPct.Text = "0%" end
        data.ready = true
        isStealing = false
    end)
end

-- =====================================================================
-- AUTO STEAL V2
-- =====================================================================
_G.ExoticHubV2Steal = _G.ExoticHubV2Steal or {
    enabled = false, radius = 10, primeRange = 80, holdMin = 1.3, holdMax = 2.6,
    entryDelay = 0.3, cooldown = 0.05,
    animals = {}, promptCache = {}, internalCache = {},
    state = {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0},
    plotSync = {caches = {}, connections = {}}, plots = nil, syncReady = false,
    scanThread = nil, conn = nil, lastScan = 0,
    animalsData = nil, channelFolder = nil, routeRemote = nil, requestData = nil
}

local function _yv2Root()
    local c = LP.Character
    return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso")) or nil
end

local function _yv2SplitPath(path)
    if typeof(path) == "table" then return path end
    local out = {}
    for p in string.gmatch(tostring(path), "[^%.]+") do table.insert(out, tonumber(p) or p) end
    return out
end

local function _yv2ResolvePath(path, root)
    local cur, par, key = root, nil, nil
    for _, p in ipairs(_yv2SplitPath(path)) do
        par = cur; key = p; cur = cur and cur[p] or nil
    end
    return cur, par, key
end

local function _yv2ApplyDiff(channelName, packet)
    local cache = _G.ExoticHubV2Steal.plotSync.caches[channelName]
    if typeof(cache) ~= "table" then return end
    local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
    local cur, par, key = _yv2ResolvePath(path, cache)
    if action == "Changed" then
        if par then par[key] = a end
    elseif action == "ArrayInsert" then
        if cur then table.insert(cur, b, a) end
    elseif action == "ArrayRemoved" then
        if cur then table.remove(cur, b) end
    elseif action == "DictionaryInsert" then
        if cur then cur[b] = a end
    elseif action == "DictionaryRemoved" then
        if cur then cur[b] = nil end
    end
end

local function _yv2AttachChannel(remote, plots, requestData)
    local A = _G.ExoticHubV2Steal
    if A.plotSync.connections[remote] then return end
    local channelName = tostring(remote.Name)
    if not plots:FindFirstChild(channelName) then return end
    if requestData and A.plotSync.caches[channelName] == nil then
        local ok, data = pcall(function() return requestData:InvokeServer(channelName) end)
        A.plotSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
    elseif A.plotSync.caches[channelName] == nil then
        A.plotSync.caches[channelName] = {}
    end
    A.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
        for _, packet in ipairs(queue) do _yv2ApplyDiff(channelName, packet) end
    end)
end

local function _yv2EnsureSync()
    local A = _G.ExoticHubV2Steal
    if A.syncReady then return true end
    local ok = pcall(function()
        A.plots = workspace:WaitForChild("Plots", 8)
        local rs = game:GetService("ReplicatedStorage")
        local pkgs = rs:FindFirstChild("Packages")
        local datas = rs:FindFirstChild("Datas")
        if not (pkgs and datas and A.plots) then return end
        A.animalsData = require(datas:WaitForChild("Animals", 10))
        local sync = pkgs:FindFirstChild("Synchronizer") or pkgs:WaitForChild("Synchronizer", 10)
        if not sync then return end
        A.channelFolder = sync:FindFirstChild("Channel") or sync:WaitForChild("Channel", 10)
        A.routeRemote = sync:FindFirstChild("CommunicationRoute") or sync:WaitForChild("CommunicationRoute", 10)
        A.requestData = sync:FindFirstChild("RequestData")
        if A.channelFolder then
            for _, child in ipairs(A.channelFolder:GetChildren()) do
                if child:IsA("RemoteEvent") then _yv2AttachChannel(child, A.plots, A.requestData) end
            end
            A.channelFolder.ChildAdded:Connect(function(child)
                if child:IsA("RemoteEvent") then _yv2AttachChannel(child, A.plots, A.requestData) end
            end)
        end
        if A.routeRemote then
            A.routeRemote.OnClientEvent:Connect(function(actions)
                for _, action in ipairs(actions) do
                    local kind, cn = action[1], tostring(action[2])
                    if A.plots and A.plots:FindFirstChild(cn) then
                        if kind == "ListenerAdded" then
                            local r = A.channelFolder and A.channelFolder:FindFirstChild(cn)
                            if r and r:IsA("RemoteEvent") then _yv2AttachChannel(r, A.plots, A.requestData) end
                        elseif kind == "ListenerRemoved" then
                            for remote, conn in pairs(A.plotSync.connections) do
                                if tostring(remote.Name) == cn then
                                    pcall(function() conn:Disconnect() end)
                                    A.plotSync.connections[remote] = nil
                                    A.plotSync.caches[cn] = nil
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
        A.syncReady = true
    end)
    return ok and A.syncReady == true
end

local function _yv2PlotOwner(plot)
    local sign = plot and plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

local function _yv2IsMyBase(animalData)
    local A = _G.ExoticHubV2Steal
    if not animalData or not animalData.plot or not A.plots then return false end
    local plot = A.plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    local owner = _yv2PlotOwner(plot)
    return owner == LP.DisplayName or owner == LP.Name
end

local function _yv2PodiumFor(animalData)
    local A = _G.ExoticHubV2Steal
    local plot = A.plots and A.plots:FindFirstChild(animalData.plot)
    local pds = plot and plot:FindFirstChild("AnimalPodiums")
    return pds and pds:FindFirstChild(animalData.slot) or nil
end

local function _yv2AnimalPos(animalData)
    local pod = _yv2PodiumFor(animalData)
    return pod and pod:GetPivot().Position or nil
end

local function _yv2DistToAnimal(animalData)
    local root = _yv2Root()
    local pos = _yv2AnimalPos(animalData)
    return root and pos and (root.Position - pos).Magnitude or math.huge
end

local function _yv2FindPrompt(animalData)
    local A = _G.ExoticHubV2Steal
    if not animalData then return nil end
    local cached = A.promptCache[animalData.uid]
    if cached and cached.Parent then return cached end
    local pod = _yv2PodiumFor(animalData)
    if not pod then return nil end
    for _, p in ipairs(pod:GetDescendants()) do
        if p:IsA("ProximityPrompt") then A.promptCache[animalData.uid] = p return p end
    end
    return nil
end

local function _yv2BuildCallbacks(prompt)
    local A = _G.ExoticHubV2Steal
    if A.internalCache[prompt] then return end
    local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
    pcall(function()
        if getconnections then
            local holds = getconnections(prompt.PromptButtonHoldBegan) or getconnections(prompt.HoldBegan) or {}
            for _, c in ipairs(holds) do
                if type(c.Function) == "function" then table.insert(data.holdCallbacks, c.Function) end
            end
            local triggers = getconnections(prompt.Triggered) or {}
            for _, c in ipairs(triggers) do
                if type(c.Function) == "function" then table.insert(data.triggerCallbacks, c.Function) end
            end
        end
    end)
    A.internalCache[prompt] = data
end

local function _yv2SetBar(p)
    if progressFill then progressFill.Size = UDim2.new(math.clamp(p, 0, 1), 0, 1, 0) end
    if progressPct then progressPct.Text = _floor(math.clamp(p, 0, 1) * 100) .. "%" end
end

local function _yv2ResetBar()
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "0%" end
end

local function _yv2Execute(prompt, animalData)
    local A = _G.ExoticHubV2Steal
    if not prompt or not prompt.Parent or not animalData then return false end
    if A.state.active then return false end
    if _tick() - (A.state.lastResultTime or 0) < (A.cooldown or 0.05) then return false end
    _yv2BuildCallbacks(prompt)
    local data = A.internalCache[prompt]
    if not data or not data.ready then return false end
    data.ready = false
    A.state.active = true
    A.state.startTime = _tick()
    A.state.phase = "holding"
    A.state.label = animalData.name or "Animal"
    task.spawn(function()
        local t0 = A.state.startTime
        local SEMI_STOP = (type(getAutoGrabPauseFraction) == "function" and getAutoGrabPauseFraction()) or ((tonumber(autoGrabPausePct) or 85) / 100)
        if #data.holdCallbacks > 0 then
            for _, fn in ipairs(data.holdCallbacks) do task.spawn(function() pcall(fn) end) end
        else
            pcall(function() if prompt.InputHoldBegin then prompt:InputHoldBegin() end end)
        end
        while A.enabled and selectedStealMode == "V2" and CONFIG.AUTO_STEAL_ENABLED and _tick() - t0 < (A.holdMin or 1.3) do
            local rawP = (_tick() - t0) / (A.holdMax or 2.6)
            _yv2SetBar(math.min(rawP, SEMI_STOP))
            task.wait()
        end
        A.state.phase = "waitingRange"
        local alreadyInRange = _yv2DistToAnimal(animalData) <= (tonumber(A.radius) or 10)
        local fired = false
        while A.enabled and selectedStealMode == "V2" and CONFIG.AUTO_STEAL_ENABLED and prompt.Parent do
            local elapsed = _tick() - t0
            if elapsed > (A.holdMax or 2.6) then break end
            local rawP2 = elapsed / (A.holdMax or 2.6)
            _yv2SetBar(math.min(rawP2, SEMI_STOP))
            if _yv2DistToAnimal(animalData) <= (tonumber(A.radius) or 10) then
                if not alreadyInRange then task.wait(A.entryDelay or 0.25) end
                if A.enabled and selectedStealMode == "V2" and CONFIG.AUTO_STEAL_ENABLED then
                    if #data.triggerCallbacks > 0 then
                        for _, fn in ipairs(data.triggerCallbacks) do task.spawn(function() pcall(fn) end) end
                    else
                        pcall(function() if prompt.InputHoldEnd then prompt:InputHoldEnd() end end)
                    end
                    fired = true
                end
                break
            end
            task.wait()
        end
        A.state.lastResult = fired and ("Stole " .. tostring(A.state.label)) or "Missed"
        A.state.active = false
        A.state.phase = "idle"
        A.state.lastResultTime = _tick()
        if fired then _yv2SetBar(1) end
        task.wait(A.cooldown or 0.05)
        data.ready = true
        _yv2ResetBar()
    end)
    return true
end

local function _yv2ScanAllPlots()
    local A = _G.ExoticHubV2Steal
    if not _yv2EnsureSync() then return 0 end
    local newCache = {}
    for _, plot in ipairs(A.plots:GetChildren()) do
        local cache = A.plotSync.caches[plot.Name]
        local animalList = cache and cache.AnimalList
        if typeof(animalList) == "table" then
            for slot, animalData in pairs(animalList) do
                if type(animalData) == "table" then
                    local animalName = animalData.Index
                    local info = A.animalsData and A.animalsData[animalName]
                    if info then
                        table.insert(newCache, {
                            name = info.DisplayName or animalName,
                            plot = plot.Name,
                            slot = tostring(slot),
                            uid = plot.Name .. "_" .. tostring(slot)
                        })
                    end
                end
            end
        end
    end
    A.animals = newCache
    return #newCache
end

local function _yv2PickClosest()
    local A = _G.ExoticHubV2Steal
    local root = _yv2Root()
    if not root then return nil end
    local best, bestDist = nil, math.huge
    for _, data in ipairs(A.animals) do
        if not _yv2IsMyBase(data) then
            local pos = _yv2AnimalPos(data)
            local dist = pos and (root.Position - pos).Magnitude or math.huge
            if dist <= (A.primeRange or 80) and dist < bestDist then
                best, bestDist = data, dist
            end
        end
    end
    return best
end

local function _yv2EnsureScanThread()
    local A = _G.ExoticHubV2Steal
    if A.scanThread then return end
    A.scanThread = task.spawn(function()
        while _G.ExoticHubV2Steal do
            if A.enabled or selectedStealMode == "V2" then pcall(_yv2ScanAllPlots) end
            task.wait(5)
        end
    end)
end

function stopAutoStealV2()
    local A = _G.ExoticHubV2Steal
    A.enabled = false
    if A.conn then A.conn:Disconnect() A.conn = nil end
    A.state.active = false
    A.state.phase = "idle"
    _yv2ResetBar()
end

function startAutoStealV2()
    local A = _G.ExoticHubV2Steal
    A.radius = tonumber(CONFIG.STEAL_RANGE) or 10
    A.holdMin = 1.3
    A.holdMax = 2.6
    A.entryDelay = 0.3
    A.cooldown = 0.05
    A.primeRange = 80
    A.enabled = true
    pcall(_yv2EnsureSync)
    _yv2EnsureScanThread()
    pcall(_yv2ScanAllPlots)
    if A.conn then A.conn:Disconnect() A.conn = nil end
    A.conn = RunService.Heartbeat:Connect(function()
        if not A.enabled or not CONFIG.AUTO_STEAL_ENABLED or selectedStealMode ~= "V2" or A.state.active then return end
        if _G._AdaptNormalStealRagdollPaused then return end
        local target = _yv2PickClosest()
        if not target then
            if _tick() - (A.lastScan or 0) > 1.2 then
                A.lastScan = _tick()
                pcall(_yv2ScanAllPlots)
            end
            return
        end
        local prompt = _yv2FindPrompt(target)
        if prompt then _yv2Execute(prompt, target) end
    end)
end

local function _startAutoStealV1()
    if stealConnection then
        local connected = false
        pcall(function() connected = stealConnection.Connected == true end)
        if connected then
            Steal.StealRadius = CONFIG.STEAL_RANGE
            Steal.AutoStealEnabled = true
            return true
        end
        pcall(function() stealConnection:Disconnect() end)
        stealConnection = nil
    end
    Steal.StealRadius = CONFIG.STEAL_RANGE
    Steal.AutoStealEnabled = true
    stealConnection = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        if _G._AdaptNormalStealRagdollPaused then return end
        if selectedStealMode ~= "V1" then return end
        local p, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
    return true
end

local function _stopAutoStealV1()
    if stealConnection then
        stealConnection:Disconnect()
        stealConnection = nil
    end
    isStealing = false
    Steal.AutoStealEnabled = false
    if progressFill then
        TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
    end
    if progressPct then progressPct.Text = "0%" end
end

function startAutoSteal()
    _stopAutoStealV1()
    stopAutoStealV2()
    CONFIG.AUTO_STEAL_ENABLED = true
    -- Semi UI maps to V2 (range-wait steal); Normal maps to V1
    if selectedStealMode == "V2" or selectedStealMode == "Semi" then
        selectedStealMode = "V2"
        startAutoStealV2()
    else
        _startAutoStealV1()
    end
    task.defer(function() pcall(saveAllSettings) end)
    return true
end

function stopAutoSteal()
    _stopAutoStealV1()
    stopAutoStealV2()
    CONFIG.AUTO_STEAL_ENABLED = false
    if progressFill then
        TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
    end
    if progressPct then progressPct.Text = "0%" end
    task.defer(function() pcall(saveAllSettings) end)
end

-- Pause / resume helpers used by Ragdoll Steal
function _pauseAutoStealForRagdoll()
    _G._AdaptNormalStealRagdollPaused = true
    -- stop the active steal loops without flipping the user's toggle
    _stopAutoStealV1()
    stopAutoStealV2()
    isStealing = false
end

function _resumeAutoStealAfterRagdoll()
    _G._AdaptNormalStealRagdollPaused = false
    if CONFIG.AUTO_STEAL_ENABLED and ragdollStealEnabled then
        if selectedStealMode == "V2" then
            startAutoStealV2()
        else
            _startAutoStealV1()
        end
    elseif CONFIG.AUTO_STEAL_ENABLED then
        startAutoSteal()
    end
end

-- ============================================================
-- RAGDOLL STEAL — pause Auto Steal while ragdolled, resume after
-- ============================================================
do
    if _G._AdaptRagdollStealEnabled == nil then
        _G._AdaptRagdollStealEnabled = ragdollStealEnabled == true
    end
    local old = _G._AdaptNormalStealRagdollState
    if old and old.Destroy then pcall(old.Destroy) end

    local state = { active = false, token = 0, humanoid = nil, conns = {} }
    _G._AdaptNormalStealRagdollState = state
    _G._AdaptNormalStealRagdollPaused = false

    local function clearConn(key)
        local c = state.conns[key]
        if c then pcall(function() c:Disconnect() end); state.conns[key] = nil end
    end

    local function isRagdolled(hum)
        if not hum then return false end
        local st = hum:GetState()
        return st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll
    end

    local function delaySec()
        return 1.45
    end

    local function clearActive(resume)
        state.token = state.token + 1
        state.active = false
        _G._AdaptNormalStealRagdollPaused = false
        if resume and CONFIG.AUTO_STEAL_ENABLED then
            pcall(_resumeAutoStealAfterRagdoll)
        end
    end

    local function onStateCheck()
        local hum = state.humanoid
        if not hum or not hum.Parent then return end
        if _G._AdaptRagdollStealEnabled ~= true and not ragdollStealEnabled then
            if state.active then clearActive(true) end
            return
        end
        if not CONFIG.AUTO_STEAL_ENABLED then
            if state.active then clearActive(false) end
            return
        end
        if isRagdolled(hum) and not state.active then
            state.active = true
            state.token = state.token + 1
            local token = state.token
            _G._AdaptNormalStealRagdollPaused = true
            pcall(_pauseAutoStealForRagdoll)
            task.delay(delaySec(), function()
                if state.token ~= token or not state.active then return end
                _G._AdaptNormalStealRagdollPaused = false
                state.active = false
                if (_G._AdaptRagdollStealEnabled == true or ragdollStealEnabled) and CONFIG.AUTO_STEAL_ENABLED then
                    pcall(_resumeAutoStealAfterRagdoll)
                end
            end)
        end
    end

    local function bindChar(character)
        clearConn("state")
        if state.active then clearActive(false) end
        local hum = character and (character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5))
        state.humanoid = hum
        if not hum then return end
        state.conns.state = hum.StateChanged:Connect(onStateCheck)
        task.defer(onStateCheck)
    end

    state.Destroy = function()
        clearActive(false)
        clearConn("state")
        clearConn("character")
        state.humanoid = nil
    end

    state.SetEnabled = function(on)
        ragdollStealEnabled = on == true
        _G._AdaptRagdollStealEnabled = ragdollStealEnabled
        if not ragdollStealEnabled then
            if state.active then clearActive(true) end
        else
            task.defer(onStateCheck)
        end
        return ragdollStealEnabled
    end

    state.conns.character = LP.CharacterAdded:Connect(bindChar)
    if LP.Character then task.defer(bindChar, LP.Character) end
end

-- ============================================================
-- MIRROR TP DOWN — when Mirror TP + Aimbot on, TP down if nearby
-- player falls ≥ 3 studs (mirrors their drop)
-- ============================================================
do
    local heightCache = {}
    local lastTpAt = 0
    local lastScanAt = 0

    local function doMirrorTpDown()
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        local now = tick()
        if now - lastTpAt < 0.08 then return end
        lastTpAt = now
        local _, yaw = root.CFrame:ToEulerAnglesYXZ()
        root.CFrame = _CFnew(root.Position.X, -7, root.Position.Z) * CFrame.Angles(0, yaw, 0)
        root.Velocity = _V3zero
        pcall(function() root.AssemblyLinearVelocity = _V3zero end)
        -- also fire the real TP Down if available
        if executeTPDown then pcall(executeTPDown) end
    end

    RunService.Heartbeat:Connect(function()
        local now = tick()
        if now < lastScanAt then return end
        lastScanAt = now + 0.35

        local mirrorOn = mirrorTpEnabled == true or _G._AdaptTPMirrorEnabled == true
        local aimbotOn = autoBatEnabled == true
        if not mirrorOn or not aimbotOn then
            table.clear(heightCache)
            return
        end

        local char = LP.Character
        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local theirHum = player.Character:FindFirstChildOfClass("Humanoid")
                if theirRoot and theirHum and theirHum.Health > 0 then
                    local dx = theirRoot.Position.X - myRoot.Position.X
                    local dz = theirRoot.Position.Z - myRoot.Position.Z
                    if dx * dx + dz * dz <= 64 then -- within 8 studs
                        local y = theirRoot.Position.Y
                        local prev = heightCache[player.UserId]
                        if prev and (prev - y) >= 3 then
                            pcall(doMirrorTpDown)
                            table.clear(heightCache)
                            break
                        end
                        heightCache[player.UserId] = y
                    else
                        heightCache[player.UserId] = nil
                    end
                end
            end
        end
    end)
end

medusaDebounce = false
medusaLastUsed = 0
dropActive = false
lastDropTime = 0
lastMoveDir = _V3new(0,0,0)
origFOV = nil
fovEnabled = false
fovValue = 70
customFovConn = nil

_anyKeyListening = false
_aimbotConn = nil
_prevAutoRotate = nil
tpBatConn = nil
tpBatPrevAutoRotate = nil
tpBatHitCD = false
TP_BAT_SWING_CD = 0.08
tpBatFloatingButton = nil

enemySpeedConn = nil
movementLoop = nil
steppedConn = nil
alConn = nil
arConn = nil
infJumpConn = nil
stretchConn = nil
stretchFovConn = nil
antiLagDescConn = nil
medusaResetConns = {}
dropConnections = {}
enemySpeedLabels = {}
Conns = {autoSteal = nil, batCounter = nil, anchor = {}, progress = nil, autoLeft = nil, autoRight = nil}
keyButtonRefs = {}
progressFill = nil
progressPct = nil
pbFrame = nil
speedLabel = nil
modeValLbl = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, bypassSpeedBox, uiScaleBox = nil, nil, nil, nil, nil, nil, nil, nil
modeSelectBtn, dropModeBtnRef = nil, nil
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual = nil, nil, nil, nil, nil
setAntiRagVisual, setUnwalkVisual, setAntiLagVisual, setLockUIVisual, setInstaGrab, setInfiniteJumpVisual, jumpPowerBox = nil, nil, nil, nil, nil, nil, nil
setAntiDieVisual = nil
setAutoTpDownVisual = nil
autoTpHeightBox = nil
tpDownModeLabel = nil
setAntiBatVisual = nil
setAntiFlingVisual = nil
setESPVIsual = nil
setESPLineVisual = nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2 = nil, nil, nil, nil, nil, nil, nil, nil
miniBtn, main, gui = nil, nil, nil
MobilePanel = nil
instaResetFloatingButton = nil
showGui = nil
hideGui = nil
mainUIScale = nil
animSelectorLabel = nil
pbScale = nil
tabButtons = nil
tabBar = nil
tabContent = nil
colorSelectorLabel = nil

GAMEPAD_KEYS = {
    [Enum.KeyCode.ButtonA] = true, [Enum.KeyCode.ButtonB] = true,
    [Enum.KeyCode.ButtonX] = true, [Enum.KeyCode.ButtonY] = true,
    [Enum.KeyCode.ButtonL1] = true, [Enum.KeyCode.ButtonR1] = true,
    [Enum.KeyCode.ButtonL2] = true, [Enum.KeyCode.ButtonR2] = true,
    [Enum.KeyCode.ButtonL3] = true, [Enum.KeyCode.ButtonR3] = true,
    [Enum.KeyCode.ButtonStart] = true, [Enum.KeyCode.ButtonSelect] = true,
    [Enum.KeyCode.DPadUp] = true, [Enum.KeyCode.DPadDown] = true,
    [Enum.KeyCode.DPadLeft] = true, [Enum.KeyCode.DPadRight] = true,
}

MOVE_KEYS = {
    [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
}

BAT_COUNTER_SLAP_LIST = {
    "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
    "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
    "Nuclear Slap", "Galaxy Slap", "Glitched Slap"
}

AP = {
    L1 = _V3new(-476.48, -6.28, 92.73),
    L2 = _V3new(-483.12, -4.95, 94.80),
    L_FACE = _V3new(-482.25, -4.96, 92.09),
    R1 = _V3new(-476.16, -6.52, 25.62),
    R2 = _V3new(-483.06, -5.03, 25.48),
    R_FACE = _V3new(-482.06, -6.93, 35.47),
}

function isGamepadInput(inp)
    return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
end

function isBindableInput(inp)
    if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
    if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
    return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
end

function kbMatch(entry, kc)
    return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
end

function resetProgressBar()
    if progressPct then progressPct.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
end

-- =====================================================================
-- TP DOWN + AUTO TP DOWN (Eclipse-style)
-- =====================================================================
_G._VynxTPDownMode = (_G._VynxTPDownMode == "half") and "half" or "full"
if _G._VynxAutoTPDownEnabled == nil then _G._VynxAutoTPDownEnabled = false end
_G._VynxAutoTPDownHeightTrigger = tonumber(_G._VynxAutoTPDownHeightTrigger) or 20

TP_DOWN_COOLDOWN = 0.03
lastTPDownAt = 0
tpDownPending = false
tpDownGeneration = 0
tpDownAlive = true

function cancelPendingTPDown()
    tpDownGeneration = tpDownGeneration + 1
    tpDownPending = false
end

pcall(function()
    LP.CharacterRemoving:Connect(cancelPendingTPDown)
end)

function _runTPDownHalf()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local rp = _RayParams_new()
    rp.FilterDescendantsInstances = {char}
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local hit = workspace:Raycast(hrp.Position, _V3new(0, -2048, 0), rp)
    if not hit then return end
    local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
    pcall(function()
        hrp.CFrame = _CFnew(hrp.Position.X, hit.Position.Y + 3, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
        hrp.AssemblyLinearVelocity = _V3zero
    end)
end

function _runTPDownFull()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 or hrp.Anchored or hum.Sit or hum.SeatPart then return end
    local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
    -- Raycast to real ground; fall back to Y = -7
    local targetY = -7
    pcall(function()
        local rp = _RayParams_new()
        rp.FilterDescendantsInstances = { char }
        rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.IgnoreWater = true
        pcall(function() rp.RespectCanCollide = true end)
        -- exclude other players
        local filter = { char }
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then filter[#filter + 1] = plr.Character end
        end
        rp.FilterDescendantsInstances = filter
        local hit = workspace:Raycast(hrp.Position + _V3new(0, 0.5, 0), _V3new(0, -4000, 0), rp)
        if hit then
            local half = (hrp.Size and hrp.Size.Y or 2) * 0.5
            local hip = (hum.HipHeight or half * 2)
            targetY = hit.Position.Y + half + hip * 0.15 + 0.15
        end
    end)
    pcall(function()
        hrp.CFrame = _CFnew(hrp.Position.X, targetY, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
        hrp.AssemblyLinearVelocity = _V3zero
        hrp.AssemblyAngularVelocity = _V3zero
    end)
end

function executeTPDown()
    if not tpDownAlive then return end
    if dropActive or _G.IsDropping then return end

    local now = os.clock()
    -- Cooldown: ignore extra presses while cooling down (do NOT queue/re-fire)
    if (now - lastTPDownAt) < (TP_DOWN_COOLDOWN or 0.03) then
        return
    end

    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 or hrp.Anchored or hum.Sit or hum.SeatPart then return end

    lastTPDownAt = now
    if cancelPendingTPDown then pcall(cancelPendingTPDown) end
    tpDownPending = false

    if _G._VynxTPDownMode == "half" then
        _runTPDownHalf()
    else
        _runTPDownFull()
    end
end

function doTpDown()
    executeTPDown()
end

_G.ExecuteTPDown = executeTPDown
_G._VynxRunTPDown = executeTPDown
_G._VynxSetTPDownMode = function(m)
    _G._VynxTPDownMode = (m == "half") and "half" or "full"
    return _G._VynxTPDownMode
end
_G._VynxTPDownIsAutoOn = function()
    return _G._VynxAutoTPDownEnabled == true
end

-- Auto TP Down: edge-trigger when height above ground >= threshold
autoTPDownElapsed = 0
autoTPDownTriggered = false
autoTPDownRoot = nil
autoTPDownRaycast = _RayParams_new()
autoTPDownRaycast.FilterType = Enum.RaycastFilterType.Exclude
pcall(function() autoTPDownRaycast.RespectCanCollide = true end)

RunService.Heartbeat:Connect(function(dt)
    if _G._VynxAutoTPDownEnabled ~= true then return end

    if dropActive or _G.IsDropping then
        autoTPDownElapsed = 0
        return
    end

    autoTPDownElapsed = autoTPDownElapsed + (dt or 0)
    if autoTPDownElapsed < 0.03 then return end -- Faster Auto TP Down checks (~33 Hz instead of 10 Hz)
    autoTPDownElapsed = 0

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root or not hum or hum.Health <= 0 then
        autoTPDownTriggered = false
        autoTPDownRoot = nil
        return
    end

    if root ~= autoTPDownRoot then
        autoTPDownRoot = root
        autoTPDownTriggered = false
    end

    local threshold = _clamp(tonumber(_G._VynxAutoTPDownHeightTrigger) or 20, 1, 1000)
    autoTPDownRaycast.FilterDescendantsInstances = { char }
    local result = workspace:Raycast(root.Position, _V3new(0, -2048, 0), autoTPDownRaycast)
    local height = result and math.max(0, root.Position.Y - result.Position.Y) or nil
    local reachedHeight = height ~= nil and height >= threshold

    if reachedHeight and not autoTPDownTriggered then
        autoTPDownTriggered = true
        executeTPDown()
    elseif not reachedHeight then
        autoTPDownTriggered = false
    end
end)

-- TP Down keybind is edge-triggered via UIS.InputBegan only (no hold-spam loop)
_tpDownKeyHeld = false
_tpDownHoldConn = nil
-- (intentionally no startTpDownHold — holding the key must not spam TP Down)

-- =====================================================================
-- ANTI RAGDOLL
-- =====================================================================
-- ============================================================
-- ANTI RAGDOLL (new recover logic)
-- ============================================================
local AntiRagdollV2 = {
    Enabled = false,
    Connection = nil,
    ResetCooldown = 0,
    fallingSince = nil,
    cache = {},
}

local function _antiRagRecover(char, hum, root)
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.Velocity = _V3zero
        root.RotVelocity = _V3zero
        root.AssemblyLinearVelocity = _V3zero
        root.AssemblyAngularVelocity = _V3zero
        for _, descendant in ipairs(char:GetDescendants()) do
            if descendant:IsA("Motor6D") or descendant:IsA("Constraint") then
                descendant.Enabled = true
            end
        end
        local cam = workspace.CurrentCamera
        if cam then cam.CameraSubject = hum end
        local scripts = LP:FindFirstChild("PlayerScripts")
        local playerModule = scripts and scripts:FindFirstChild("PlayerModule")
        local controlModule = playerModule and playerModule:FindFirstChild("ControlModule")
        if controlModule then
            local ok, result = pcall(require, controlModule)
            if ok and result then
                pcall(function() result:Enable() end)
            end
        end
        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end

local function _antiRagStripConstraints(char)
    for _, descendant in ipairs(char:GetDescendants()) do
        if descendant:IsA("BallSocketConstraint")
            or (descendant:IsA("Attachment") and tostring(descendant.Name):find("RagdollAttachment")) then
            pcall(function() descendant:Destroy() end)
        end
    end
end

local function _antiRagIsRagdolled(hum)
    if not hum then return false end
    local attr = LP:GetAttribute("RagdollEndTime")
    if attr and workspace:GetServerTimeNow() - attr < 0 then
        return true
    end
    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll
        or hum.PlatformStand then
        AntiRagdollV2.fallingSince = nil
        return true
    end
    if state == Enum.HumanoidStateType.FallingDown then
        AntiRagdollV2.fallingSince = AntiRagdollV2.fallingSince or os.clock()
        return os.clock() - AntiRagdollV2.fallingSince >= 0.18
    end
    AntiRagdollV2.fallingSince = nil
    return false
end

local function _antiRagGroundSafe(char, hum, root)
    -- Skip recover mid-air while TP Bat is driving
    if batDesyncTpEnabled then
        if hum.FloorMaterial ~= Enum.Material.Air then return true end
        local rp = _RayParams_new()
        rp.FilterType = Enum.RaycastFilterType.Exclude
        rp.FilterDescendantsInstances = { char }
        pcall(function() rp.RespectCanCollide = true end)
        return workspace:Raycast(root.Position + _V3new(0, 1, 0), _V3new(0, -5, 0), rp) ~= nil
    end
    return true
end

local function _antiRagForceUp(char, hum, root)
    if not hum or not root then return end
    pcall(function()
        LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
    end)
    if hum.Health > 0 then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    root.Anchored = false
    local skipVel = batDesyncTpEnabled == true
    if not skipVel then
        root.AssemblyLinearVelocity = _V3zero
        root.AssemblyAngularVelocity = _V3zero
    end
    if not skipVel and not autoBatEnabled then
        local _, yaw = root.CFrame:ToEulerAnglesYXZ()
        root.CFrame = _CFnew(root.Position) * CFrame.Angles(0, yaw, 0)
    end
    pcall(function()
        if workspace.CurrentCamera then
            workspace.CurrentCamera.CameraSubject = hum
        end
    end)
end

function startAntiRagdollV2()
    if AntiRagdollV2.Connection then return end
    AntiRagdollV2.Enabled = true
    AntiRagdollV2.fallingSince = nil
    AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
        if not AntiRagdollV2.Enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        if dropActive or _G.IsDropping or _G.IsDropping then return end
        if _G._ExoticHubInstaResetState and _G._ExoticHubInstaResetState.busy then return end
        if not _antiRagGroundSafe(char, hum, root) then return end

        local state = hum:GetState()
        local now = _tick()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or hum.PlatformStand
            or _antiRagIsRagdolled(hum) then
            local cd = (antiRagdollMode == "v1") and 0.28 or 0.15
            if now - AntiRagdollV2.ResetCooldown > cd then
                AntiRagdollV2.ResetCooldown = now
                if batCounterEnabled or batCounterV2Enabled then
                    -- leave room for bat counter to react first
                end
                _antiRagStripConstraints(char)
                _antiRagForceUp(char, hum, root)
                _antiRagRecover(char, hum, root)
            end
        end
    end)
end

function stopAntiRagdollV2()
    AntiRagdollV2.Enabled = false
    if AntiRagdollV2.Connection then
        AntiRagdollV2.Connection:Disconnect()
        AntiRagdollV2.Connection = nil
    end
    AntiRagdollV2.ResetCooldown = 0
    AntiRagdollV2.fallingSince = nil
    AntiRagdollV2.cache = {}
end

-- Aliases used by some call sites
function startAntiRagdoll()
    startAntiRagdollV2()
end

function stopAntiRagdoll(keepFlag)
    if not keepFlag then
        antiRagdollMode = "off"
    end
    stopAntiRagdollV2()
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if antiRagdollMode == "v1" or antiRagdollMode == "v2" then
        if AntiRagdollV2.Connection then
            AntiRagdollV2.Connection:Disconnect()
            AntiRagdollV2.Connection = nil
        end
        startAntiRagdollV2()
    end
end)

function setAntiRagdollMode(mode)
    if mode == "v1" or mode == "v2" then
        _antiRagLastOn = mode
        antiRagdollMode = mode
        startAntiRagdollV2()
    else
        stopAntiRagdollV2()
        antiRagdollMode = "off"
    end
    if setAntiRagVisual then setAntiRagVisual(antiRagdollMode == "v1" or antiRagdollMode == "v2") end
    task.defer(function() pcall(saveAllSettings) end)
end

-- =====================================================================
-- [FIX ANTI DIE VIOLETTE v2]
-- =====================================================================
_antiDieEnabled = false
_antiDieStopped = false
_antiDieSources = { toggle = false, autobat = false }

_antiDie = {
    enabled = false, loop = nil, healthConn = nil, charConn = nil,
    lastHealTime = 0, invincibleUntil = 0,
    config = {
        healthThreshold = 50,
        invincibilityFrames = 0.75,
        fallDamageProtection = false,
        ragdollProtection = true,
        autoRevive = true,
    },
}

function _antiDie.SuperHeal(hum)
    if not hum or not hum.Parent then return end
    local maxHealth = hum.MaxHealth or 100
    if maxHealth <= 0 or maxHealth == math.huge then maxHealth = 100 end
    pcall(function()
        hum.Health = maxHealth
        if hum.MaxHealth < maxHealth then hum.MaxHealth = maxHealth end
    end)
    _antiDie.invincibleUntil = _tick() + _antiDie.config.invincibilityFrames
    _antiDie.lastHealTime = _tick()
    pcall(function()
        local char = hum.Parent
        if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("NumberValue") then
                local name = child.Name:lower()
                if name:find("health") or name:find("hp") or name:find("life") then
                    child.Value = maxHealth
                end
            end
            if child:IsA("BoolValue") and child.Name:lower():find("dead") then
                child.Value = false
            end
        end
    end)
end

function _antiDie.PreventDamage(root, hum)
    if not hum then return end
    if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
    if _tick() < _antiDie.invincibleUntil then
        if hum.Health < (hum.MaxHealth or 100) then
            hum.Health = hum.MaxHealth or 100
        end
    end
    if _antiDie.config.ragdollProtection then
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown or
           state == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
            _antiDie.SuperHeal(hum)
            if root then
                pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
            end
        end
    end
    if hum.Health <= 0 then
        _antiDie.SuperHeal(hum)
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
        if root then
            pcall(function()
                root.CFrame = CFrame.new(root.Position + Vector3.new(0, 2, 0))
                root.AssemblyLinearVelocity = Vector3.zero
            end)
        end
    end
end

function _antiDie.AutoRevive()
    if not _antiDie.config.autoRevive then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum then return end
    if hum.Health <= 0 then
        _antiDie.SuperHeal(hum)
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
        if root then
            pcall(function()
                root.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
                root.AssemblyLinearVelocity = Vector3.zero
            end)
        end
    end
end

function _antiDie.AttachHealth(char)
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then hum = char and char:WaitForChild("Humanoid", 3) end
    if not hum then return end
    _antiDie.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not _antiDie.enabled then return end
        if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
        if hum.Health <= 0 then _antiDie.AutoRevive() end
    end)
    if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
end

function _antiDie.StartEngine()
    if _antiDie.enabled and _antiDie.loop then return end
    _antiDie.enabled = true
    _antiDieEnabled = true
    antiDieEnabled = true
    if _antiDie.loop then _antiDie.loop:Disconnect(); _antiDie.loop = nil end
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    _antiDie.loop = RunService.Heartbeat:Connect(function()
        if not _antiDie.enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum then return end
        if hum.Health <= 0 then _antiDie.AutoRevive()
        elseif hum.Health <= _antiDie.config.healthThreshold then _antiDie.SuperHeal(hum)
        elseif hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
        _antiDie.PreventDamage(root, hum)
    end)
    if LP.Character then _antiDie.AttachHealth(LP.Character) end
    if _antiDie.charConn then _antiDie.charConn:Disconnect(); _antiDie.charConn = nil end
    _antiDie.charConn = LP.CharacterAdded:Connect(function(char)
        if not _antiDie.enabled then return end
        task.wait(0.05)
        _antiDie.AttachHealth(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then _antiDie.SuperHeal(hum) end
    end)
end

function _antiDie.StopEngine()
    _antiDie.enabled = false
    _antiDieEnabled = false
    antiDieEnabled = false
    if _antiDie.loop then _antiDie.loop:Disconnect(); _antiDie.loop = nil end
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    if _antiDie.charConn then _antiDie.charConn:Disconnect(); _antiDie.charConn = nil end
    pcall(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum.BreakJointsOnDeath = true
        if hum.MaxHealth == math.huge or hum.MaxHealth <= 0 then
            hum.MaxHealth = 100
            hum.Health = math.min(hum.Health, 100)
        end
    end)
end

function _antiDieSetEnabled(enabled)
    enabled = enabled == true
    if enabled == _antiDieEnabled then return end
    if enabled then
        _antiDie.StartEngine()
    else
        _antiDie.StopEngine()
    end
end

function _antiDieRefresh()
    if _antiDieStopped then return end
    local manual = _antiDieSources.toggle
    _antiDieSetEnabled(manual or _antiDieSources.autobat)
end

_G.__CrystalAntiDieSource = function(source, enabled)
    if _antiDieStopped or _antiDieSources[source] == nil then return end
    _antiDieSources[source] = enabled == true
    _antiDieRefresh()
end

_G.__CrystalAntiDieSet = function(enabled)
    _G.__CrystalAntiDieSource("autobat", enabled)
end

_G.__CrystalAntiDieIsEnabled = function() return _antiDieEnabled end
_G.__CrystalAntiDieStop = function()
    _antiDieStopped = true
    _antiDieSources.toggle = false
    _antiDieSources.autobat = false
    _antiDieSetEnabled(false)
end

function activateOnCharacter(char)
    if not _antiDieEnabled then return end
    _antiDie.AttachHealth(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then _antiDie.SuperHeal(hum) end
end

AntiDieModule = {
    enabled = false,
    start = function()
        AntiDieModule.enabled = true
        antiDieEnabled = true
        _antiDieStopped = false
        _G.__CrystalAntiDieSource("toggle", true)
    end,
    stop = function()
        AntiDieModule.enabled = false
        antiDieEnabled = false
        _G.__CrystalAntiDieSource("toggle", false)
    end,
}
_G.AntiDie = AntiDieModule

-- =====================================================================
-- ANTI BAT (lógica portada desde Violette)
-- Reemplaza la versión previa de ExoticHub que usaba root.Velocity y que
-- también recuperaba del ragdoll. Ahora sólo aplica el pulso de
-- AssemblyLinearVelocity (500, y, 500) y espera un RenderStepped para
-- restaurar el componente horizontal. La recuperación de ragdoll queda
-- exclusivamente a cargo del toggle "Anti Ragdoll".
-- =====================================================================
local AntiBat = { Connection = nil }

function stopAntiBat()
    antiBatEnabled = false
    if AntiBat.Connection then
        AntiBat.Connection:Disconnect()
        AntiBat.Connection = nil
    end
end

function startAntiBat()
    stopAntiBat()
    antiBatEnabled = true

    -- Space X Hook style: random XZ desync then restore.
    -- Compatible with Hold Inf Jump: never clobber boosted Y on restore.
    AntiBat.Connection = RunService.Heartbeat:Connect(function()
        if not antiBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local vel = root.AssemblyLinearVelocity or root.Velocity
        if not vel then return end
        local y = vel.Y
        local rx = math.random(-4000, 4000)
        local rz = math.random(-4000, 4000)
        pcall(function()
            root.AssemblyLinearVelocity = Vector3.new(rx, y, rz)
            if root.Velocity then root.Velocity = Vector3.new(rx, y, rz) end
        end)
        RunService.RenderStepped:Wait()
        if not root or not root.Parent then return end
        pcall(function()
            local now = root.AssemblyLinearVelocity or root.Velocity or vel
            local yKeep = now.Y
            -- If Infinite Jump (Hold) is active and jump is held, keep / re-apply jump Y
            if InfiniteJump and InfiniteJump.enabled then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local jumpHeld = InfiniteJump._forceJump
                    or (hum and hum.Jump == true)
                    or (UIS and UIS:IsKeyDown(Enum.KeyCode.Space))
                if jumpHeld then
                    local jp = tonumber(InfiniteJump.jumpPower) or 50
                    if yKeep < jp then yKeep = jp end
                end
            end
            local restored = Vector3.new(vel.X, yKeep, vel.Z)
            root.AssemblyLinearVelocity = restored
            if root.Velocity then root.Velocity = restored end
        end)
    end)
end

LP.CharacterAdded:Connect(function()
    task.wait(0.3)
    if antiBatEnabled then startAntiBat() end
end)

-- =====================================================================
-- ANTI FLING (lógica portada desde Violette)
-- Cancela velocidades horizontales anómalas (>80 studs/s) y rotaciones
-- extremas (>40 rad/s) que no provienen del propio hub.
-- Ignora: drop activo, aimbots/paths activos, y velocidad propia reciente.
-- =====================================================================
setAntiFlingVisual = nil

local _antiFlingState = {
    connection    = nil,
    threshold     = 80,
    spinThreshold = 40,
}
_ANTI_FLING_DRIVE_GRACE = 0.3

function _afHubSpeedLive()
    local live = _G.__ExoticHubLiveSpeed
    if type(live) ~= "table" then return false end
    local stamp, speed = tonumber(live.t), tonumber(live.v)
    if not stamp or not speed or speed <= 0 then return false end
    return (os.clock() - stamp) <= _ANTI_FLING_DRIVE_GRACE
end

function _afOwnMoverActive()
    -- Si estamos usando TPBat/Desync, el CFrame salta y no queremos cancelar
    if batDesyncTpEnabled then return true end
    -- Aimbot y auto-path usan velocidades que podrían confundirse con fling
    if autoBatEnabled then return true end
    if autoLeftEnabled or autoRightEnabled then return true end
    return false
end

function startAntiFling()
    if _antiFlingState.connection then return end
    antiFlingEnabled = true
    _antiFlingState.connection = RunService.Heartbeat:Connect(function()
        if not antiFlingEnabled then return end
        local character = LP.Character
        if not character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and (humanoid.Health <= 0 or humanoid.SeatPart) then return end

        -- Guardas: no pisar nuestras propias acciones
        if dropActive or _G.IsDropping then return end
        if _afOwnMoverActive() then return end
        if _afHubSpeedLive() then return end

        local velocity = root.AssemblyLinearVelocity
        local flat = Vector3.new(velocity.X, 0, velocity.Z)

        if flat.Magnitude > _antiFlingState.threshold then
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
                root.AssemblyAngularVelocity = Vector3.zero
            end)
            return
        end
        if root.AssemblyAngularVelocity.Magnitude > _antiFlingState.spinThreshold then
            pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
        end
    end)
end

function stopAntiFling()
    antiFlingEnabled = false
    if _antiFlingState.connection then
        _antiFlingState.connection:Disconnect()
        _antiFlingState.connection = nil
    end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.3)
    if antiFlingEnabled then startAntiFling() end
end)

-- =====================================================================
-- ESP
-- =====================================================================
espEnabled = espEnabled or false
espActivePlayers = {}
espLoopConn = nil
Camera = workspace.CurrentCamera
GUI2_ESP_COLOR = Color3.fromRGB(139, 72, 246)
GUI2_ESP_TEXT_STROKE = Color3.fromRGB(48, 16, 92)


local function applyStealBarRedGreen()
    if not progressFill then return end
    progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local fg = progressFill:FindFirstChild("FillGrad") or progressFill:FindFirstChildOfClass("UIGradient")
    if not fg then
        fg = Instance.new("UIGradient")
        fg.Name = "FillGrad"
        fg.Parent = progressFill
    end
    fg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(220, 40, 50)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 200, 60)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40, 200, 80)),
    })
    fg.Rotation = 0
end

function getESPThemeColors(accent)
    local c = getThemeColor() or accent or Color3.fromRGB(245, 245, 250)
    return c, Color3.fromRGB(0, 0, 0)
end


_jkHubLoveBillboard = nil
function setJKHubLoveTag(on)
    pcall(function()
        if _jkHubLoveBillboard then
            _jkHubLoveBillboard:Destroy()
            _jkHubLoveBillboard = nil
        end
        if not on then return end
        local char = LP.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end
        local bb = Instance.new("BillboardGui")
        bb.Name = "JKHubLoveTag"
        bb.Size = UDim2.fromOffset(200, 40)
        bb.StudsOffset = Vector3.new(0, 2.8, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 120
        bb.Adornee = head
        bb.Parent = head
        local lbl = Instance.new("TextLabel", bb)
        lbl.Size = UDim2.fromScale(1, 1)
        lbl.BackgroundTransparency = 1
        lbl.Text = "JK HUB"
        lbl.TextColor3 = Color3.fromRGB(255, 100, 140)
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextScaled = true
        local st = Instance.new("UIStroke", lbl)
        st.Color = Color3.fromRGB(0, 0, 0)
        st.Thickness = 1.5
        _jkHubLoveBillboard = bb
    end)
end
jkHubLoveTagEnabled = true
task.defer(function()
    task.wait(1)
    setJKHubLoveTag(true)
end)
if LP then
    LP.CharacterAdded:Connect(function()
        task.wait(1)
        if jkHubLoveTagEnabled then setJKHubLoveTag(true) end
    end)
end

function createESP()
    local currentFill, currentLine = getESPThemeColors()
    local esp = {
        Tracer = Drawing and Drawing.new("Line") or nil,
        Highlight = Instance.new("Highlight"),
        Lines = {},
    }
    if esp.Tracer then
        esp.Tracer.Color = currentLine
        esp.Tracer.Thickness = 3
        esp.Tracer.Transparency = 1
        esp.Tracer.ZIndex = 2
    end

    esp.Highlight.Name = "ExoticHubESP_Highlight"
    esp.Highlight.FillColor = currentFill
    esp.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    esp.Highlight.FillTransparency = 0.12
    esp.Highlight.OutlineTransparency = 0.18
    esp.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local parentGui
    local ok, robGui = pcall(function() return game:GetService("CoreGui"):FindFirstChild("RobloxGui") end)
    if ok and robGui then parentGui = robGui else parentGui = LP:FindFirstChildOfClass("PlayerGui") end
    if not parentGui then parentGui = game:GetService("CoreGui") end
    pcall(function() esp.Highlight.Parent = parentGui end)

    local nameBillboard = Instance.new("BillboardGui")
    nameBillboard.Name = "ExoticHubESP_Name"
    nameBillboard.Size = UDim2.new(0, 170, 0, 28)
    nameBillboard.StudsOffset = Vector3.new(0, 1.3, 0)
    nameBillboard.AlwaysOnTop = true
    nameBillboard.Parent = parentGui

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 170, 0, 28)
    nameLabel.AnchorPoint = Vector2.new(0.5, 0)
    nameLabel.Position = UDim2.new(0.5, 0, 0, 2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = ""
    nameLabel.TextColor3 = getThemeColor()
    nameLabel.TextSize = 15
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.TextYAlignment = Enum.TextYAlignment.Center
    nameLabel.ZIndex = 5
    nameLabel.Parent = nameBillboard

    local nameOutline = Instance.new("UIStroke")
    nameOutline.Color = Color3.fromRGB(0, 0, 0)
    nameOutline.Thickness = 2.2
    nameOutline.Transparency = 0.12
    nameOutline.Parent = nameLabel

    if Drawing then
        for i = 1, 14 do
            local line = Drawing.new("Line")
            line.Color = currentLine
            line.Thickness = 2
            line.Transparency = 1
            line.ZIndex = 3
            table.insert(esp.Lines, line)
        end
    end

    esp.NameTag = nameBillboard
    esp.NameLabel = nameLabel
    esp.NameOutline = nameOutline
    return esp
end

_G.__ExoticHubRefreshESPTheme = function(accent, outlineColor)
    local c = accent or selectedColor or (getThemeColor and getThemeColor())
    local fillColor, lineColor = getESPThemeColors(c)
    for _, data in pairs(espActivePlayers) do
        if type(data) == "table" and data.esp then
            local esp = data.esp
            if esp.Tracer then pcall(function() esp.Tracer.Color = lineColor end) end
            if esp.Highlight then
                esp.Highlight.FillColor = fillColor
                esp.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
            end
            if esp.NameLabel then
                esp.NameLabel.TextColor3 = c
                esp.NameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            end
            if esp.NameOutline then esp.NameOutline.Color = Color3.fromRGB(0, 0, 0) end
            for _, line in ipairs(esp.Lines or {}) do pcall(function() line.Color = lineColor end) end
        end
    end
    -- Live-update overhead speed indicator / rag timer labels (no reset needed)
    pcall(function()
        local char = LP and LP.Character
        local head = char and char:FindFirstChild("Head")
        local bb = head and head:FindFirstChild("SyeHubSpeedIndicator")
        -- [HARDCODED FIX] full overhead recolor including shimmer
        if bb then
            for _, d in ipairs(bb:GetDescendants()) do
                if d:IsA("TextLabel") then
                    d.TextColor3 = c
                    local grad = d:FindFirstChildOfClass("UIGradient")
                    if grad then
                        grad.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, c),
                            ColorSequenceKeypoint.new(0.3, c:Lerp(Color3.new(1,1,1), 0.55)),
                            ColorSequenceKeypoint.new(0.5, c:Lerp(Color3.new(1,1,1), 0.85)),
                            ColorSequenceKeypoint.new(0.7, c:Lerp(Color3.new(1,1,1), 0.55)),
                            ColorSequenceKeypoint.new(1, c),
                        })
                    end
                end
            end
        end
        -- Any other ExoticHub overhead billboards on local character
        if char then
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("BillboardGui") and tostring(d.Name):find("ExoticHub") then
                    for _, x in ipairs(d:GetDescendants()) do
                        if x:IsA("TextLabel") then x.TextColor3 = c
                        elseif x:IsA("UIStroke") then x.Color = c end
                    end
                end
            end
        end
        -- Enemy ragdoll timer overlays in PlayerGui
        local pg = LP and LP:FindFirstChildOfClass("PlayerGui")
        if pg then
            for _, child in ipairs(pg:GetChildren()) do
                if child:IsA("ScreenGui") and (child.Name:find("ExoticHubEnemyRag") or child.Name:find("EnemyRag") or child.Name:find("Ragdoll") or child.Name:find("ExoticHub")) then
                    for _, d in ipairs(child:GetDescendants()) do
                        if d:IsA("TextLabel") then d.TextColor3 = c
                        elseif d:IsA("UIStroke") then d.Color = c end
                    end
                end
            end
        end
    end)
end

function removeESP(plr)
    local data = espActivePlayers[plr]
    if data then
        if data.esp.Tracer then pcall(function() data.esp.Tracer:Remove() end) end
        if data.esp.Highlight then pcall(function() data.esp.Highlight:Destroy() end) end
        if data.esp.NameTag then pcall(function() data.esp.NameTag:Destroy() end) end
        for _, line in ipairs(data.esp.Lines) do
            pcall(function() line:Remove() end)
        end
        espActivePlayers[plr] = nil
    end
end

function updateESP(plr, esp)
    if not espEnabled then
        if esp.Tracer then esp.Tracer.Visible = false end
        esp.Highlight.Enabled = false
        for _, line in ipairs(esp.Lines) do line.Visible = false end
        if esp.NameTag then esp.NameTag.Enabled = false end
        return
    end

    local character = plr.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local trackPart = character and (
        character:FindFirstChild("HumanoidRootPart")
        or character.PrimaryPart
        or character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")
        or character:FindFirstChild("Head")
    )

    if character and trackPart and (not hum or hum.Health > 0) then
        esp.Highlight.Adornee = character
        esp.Highlight.Enabled = espEnabled
        if esp.Tracer then esp.Tracer.Visible = false end
        for _, line in ipairs(esp.Lines) do line.Visible = false end

        if esp.NameTag and esp.NameLabel then
            pcall(function()
                esp.NameTag.Adornee = trackPart
                esp.NameTag.Enabled = espEnabled
                esp.NameLabel.Text = plr.Name or plr.DisplayName or ""
                esp.NameLabel.TextColor3 = getThemeColor()
            end)
        end
    else
        if esp.Tracer then esp.Tracer.Visible = false end
        esp.Highlight.Enabled = false
        esp.Highlight.Adornee = nil
        for _, line in ipairs(esp.Lines) do line.Visible = false end
        if esp.NameTag then esp.NameTag.Enabled = false end
    end
end

function createESPForPlayer(plr)
    if plr == LP then return end
    if espActivePlayers[plr] and espActivePlayers[plr].esp then
        if espActivePlayers[plr].esp.NameTag then
            pcall(function() espActivePlayers[plr].esp.NameTag.Enabled = espEnabled end)
        end
        return
    end
    removeESP(plr)
    local esp = createESP()
    espActivePlayers[plr] = { esp = esp }
end

espJoinConn, espLeaveConn = nil, nil
function enableESP()
    -- [HARDCODED FIX] always (re)start ESP when UI is ON
    espEnabled = true
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then task.spawn(function() createESPForPlayer(plr) end) end
    end
    local espAccumulator = 0
    if espLoopConn then espLoopConn:Disconnect() end
    espLoopConn = RunService.Heartbeat:Connect(function(dt)
        if not espEnabled then return end
        espAccumulator = espAccumulator + (dt or 0)
        if espAccumulator < 0.15 then return end
        espAccumulator = 0
        for plr, data in pairs(espActivePlayers) do
            if typeof(plr) == "Instance" and plr:IsA("Player") and data and data.esp then
                pcall(function() updateESP(plr, data.esp) end)
            end
        end
    end)
    if espJoinConn then pcall(function() espJoinConn:Disconnect() end) end
    if espLeaveConn then pcall(function() espLeaveConn:Disconnect() end) end
    espJoinConn = Players.PlayerAdded:Connect(function(plr)
        if not espEnabled or plr == LP then return end
        task.wait(0.3)
        createESPForPlayer(plr)
    end)
    espLeaveConn = Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end)
end

function disableESP()
    espEnabled = false
    if espLoopConn then espLoopConn:Disconnect(); espLoopConn = nil end
    if espJoinConn then pcall(function() espJoinConn:Disconnect() end); espJoinConn = nil end
    if espLeaveConn then pcall(function() espLeaveConn:Disconnect() end); espLeaveConn = nil end
    for plr in pairs(espActivePlayers) do
        if typeof(plr) == "Instance" and plr:IsA("Player") and plr ~= LP then removeESP(plr) end
    end
end


function setBaseESP(on)
    baseEspEnabled = on and true or false
    pcall(function()
        if _baseEspFolder then _baseEspFolder:Destroy() _baseEspFolder = nil end
        if not baseEspEnabled then return end
        local folder = Instance.new("Folder")
        folder.Name = "JKHubBaseESP"
        folder.Parent = game:GetService("CoreGui")
        _baseEspFolder = folder
        local function mark(part)
            if not part or not part:IsA("BasePart") then return end
            local h = Instance.new("Highlight")
            h.Adornee = part
            h.FillColor = Color3.fromRGB(80, 180, 255)
            h.OutlineColor = Color3.fromRGB(200, 230, 255)
            h.FillTransparency = 0.7
            h.Parent = folder
        end
        for _, obj in ipairs(workspace:GetDescendants()) do
            local n = string.lower(obj.Name or "")
            if (n:find("base") or n:find("plot") or n:find("tycoon") or n:find("house")) and obj:IsA("Model") then
                local p = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if p then mark(p) end
            end
        end
    end)
end

function setBrainrotESP(on)
    brainrotEspEnabled = on and true or false
    pcall(function()
        if _brainrotEspFolder then _brainrotEspFolder:Destroy() _brainrotEspFolder = nil end
        if not brainrotEspEnabled then return end
        local folder = Instance.new("Folder")
        folder.Name = "JKHubBrainrotESP"
        folder.Parent = game:GetService("CoreGui")
        _brainrotEspFolder = folder
        local function scan()
            if not brainrotEspEnabled or not folder.Parent then return end
            for _, c in ipairs(folder:GetChildren()) do c:Destroy() end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local has = false
                    for _, ch in ipairs(plr.Character:GetChildren()) do
                        local n = string.lower(ch.Name or "")
                        if n:find("brainrot") or n:find("animal") or (ch:IsA("Tool") and (n:find("brain") or n:find("pet"))) then
                            has = true
                            break
                        end
                    end
                    if has then
                        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local h = Instance.new("Highlight")
                            h.Adornee = plr.Character
                            h.FillColor = Color3.fromRGB(255, 80, 200)
                            h.OutlineColor = Color3.fromRGB(255, 200, 255)
                            h.FillTransparency = 0.55
                            h.Parent = folder
                        end
                    end
                end
            end
        end
        scan()
        task.spawn(function()
            while brainrotEspEnabled and folder.Parent do
                scan()
                task.wait(1)
            end
        end)
    end)
end

function setESP2(on)
    esp2Enabled = on and true or false
    -- ESP 2 = thicker outline + brighter fill variant of player ESP
    if esp2Enabled and not espEnabled then
        toggleESP(true)
        if setESPVIsual then setESPVIsual(true) end
    end
    pcall(function()
        for _, data in pairs(espActivePlayers or {}) do
            local esp = data.esp
            if esp and esp.Highlight then
                if esp2Enabled then
                    esp.Highlight.FillTransparency = 0.35
                    esp.Highlight.OutlineTransparency = 0
                    esp.Highlight.OutlineColor = Color3.fromRGB(255, 255, 100)
                else
                    local fill, line = getESPThemeColors()
                    esp.Highlight.FillTransparency = 0.55
                    esp.Highlight.OutlineColor = line or fill
                end
            end
        end
    end)
end

function toggleESP(on)
    if on then enableESP() else disableESP() end
    if setESPVIsual then setESPVIsual(on) end
end

-- =====================================================================
-- ESP LINE
-- =====================================================================
_espLineGui = nil
_espLineFrame = nil
_espLineOutline = nil
_espLineConn = nil
_espLineState = { scanElapsed = math.huge, targetRoot = nil }

function ensureESPLineGui()
    if _espLineGui and _espLineGui.Parent then return end
    _espLineGui = Instance.new("ScreenGui")
    _espLineGui.Name = "ExoticHubESPLine"
    _espLineGui.IgnoreGuiInset = true
    _espLineGui.ResetOnSpawn = false
    _espLineGui.DisplayOrder = 1000
    _espLineGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local okP = pcall(function() _espLineGui.Parent = game:GetService("CoreGui") end)
    if not okP then _espLineGui.Parent = LP:WaitForChild("PlayerGui") end

    _espLineFrame = Instance.new("Frame")
    _espLineFrame.Name = "ESPLine"
    _espLineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    _espLineFrame.BorderSizePixel = 0
    _espLineFrame.Active = false
    _espLineFrame.Visible = false
    _espLineFrame.BackgroundColor3 = getThemeColor()
    _espLineFrame.ZIndex = 1
    _espLineFrame.Parent = _espLineGui

    _espLineOutline = Instance.new("UIStroke", _espLineFrame)
    _espLineOutline.Color = Color3.fromRGB(255, 255, 255)
    _espLineOutline.Thickness = 0.7
    _espLineOutline.Transparency = 0.45
end

function stopESPLine()
    espLineEnabled = false
    if _espLineConn then _espLineConn:Disconnect(); _espLineConn = nil end
    if _espLineFrame then _espLineFrame.Visible = false end
    _espLineState.targetRoot = nil
    _espLineState.scanElapsed = math.huge
    if _espLineGui and _espLineGui.Parent then
        pcall(function() _espLineGui:Destroy() end)
    end
    _espLineGui = nil
    _espLineFrame = nil
    _espLineOutline = nil
end

function startESPLine()
    espLineEnabled = true
    ensureESPLineGui()
    if _espLineConn then _espLineConn:Disconnect() end
    _espLineState.scanElapsed = math.huge
    _espLineState.targetRoot = nil

    _espLineConn = RunService.RenderStepped:Connect(function(dt)
        if not espLineEnabled then
            if _espLineFrame then _espLineFrame.Visible = false end
            return
        end
        local ok = pcall(function()
            local activeCamera = workspace.CurrentCamera
            local myChar = LP.Character
            local myRoot = myChar and (myChar:FindFirstChild("LowerTorso") or myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
            if not activeCamera or not myRoot then
                if _espLineFrame then _espLineFrame.Visible = false end
                return
            end

            local myPosition = myRoot.Position
            _espLineState.scanElapsed = _espLineState.scanElapsed + (dt or 0)
            local cachedRoot = _espLineState.targetRoot
            local cachedCharacter = cachedRoot and cachedRoot.Parent
            local cachedHumanoid = cachedCharacter and cachedCharacter:FindFirstChildOfClass("Humanoid")
            local cachedValid = cachedRoot and cachedRoot.Parent and (not cachedHumanoid or cachedHumanoid.Health > 0)
            if _espLineState.scanElapsed >= 0.12 or not cachedValid then
                _espLineState.scanElapsed = 0
                local closestRoot, closestDistanceSq = nil, math.huge
                for _, otherPlayer in ipairs(Players:GetPlayers()) do
                    if otherPlayer ~= LP then
                        local character = otherPlayer.Character
                        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                        local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("LowerTorso") or character:FindFirstChild("Torso"))
                        if root and root:IsA("BasePart") and (not humanoid or humanoid.Health > 0) then
                            local delta = root.Position - myPosition
                            local distanceSq = delta:Dot(delta)
                            if distanceSq < closestDistanceSq then
                                closestRoot, closestDistanceSq = root, distanceSq
                            end
                        end
                    end
                end
                _espLineState.targetRoot = closestRoot
            end

            local closestRoot = _espLineState.targetRoot
            if not closestRoot or not closestRoot.Parent then
                if _espLineFrame then _espLineFrame.Visible = false end
                return
            end
            local closestPosition = closestRoot.Position

            local from = activeCamera:WorldToViewportPoint(myPosition - Vector3.new(0, myRoot.Size.Y * 0.35, 0))
            local to, targetOnScreen = activeCamera:WorldToViewportPoint(closestPosition)
            local viewport = activeCamera.ViewportSize
            local fromPoint = Vector2.new(from.X, from.Y)
            local targetPoint = Vector2.new(to.X, to.Y)

            if not targetOnScreen or to.Z <= 0 then
                local center = viewport * 0.5
                local direction = targetPoint - center
                if to.Z <= 0 then direction = -direction end
                if direction.Magnitude < 0.001 then direction = Vector2.new(0, -1) end
                local limit = Vector2.new(math.max(8, center.X - 8), math.max(8, center.Y - 8))
                local scaleX = limit.X / math.max(math.abs(direction.X), 0.001)
                local scaleY = limit.Y / math.max(math.abs(direction.Y), 0.001)
                targetPoint = center + direction * math.min(scaleX, scaleY)
            end

            if from.Z <= 0 or fromPoint.X < 0 or fromPoint.X > viewport.X or fromPoint.Y < 0 or fromPoint.Y > viewport.Y then
                fromPoint = Vector2.new(viewport.X * 0.5, viewport.Y - 8)
            end

            local delta = targetPoint - fromPoint
            local midpoint = (fromPoint + targetPoint) * 0.5
            _espLineFrame.Position = UDim2.fromOffset(midpoint.X, midpoint.Y)
            _espLineFrame.Size = UDim2.fromOffset(math.max(delta.Magnitude, 1), 2)
            _espLineFrame.Rotation = math.deg(math.atan2(delta.Y, delta.X))
            _espLineFrame.BackgroundColor3 = getThemeColor()
            _espLineFrame.Visible = true
        end)
        if not ok and _espLineFrame then
            pcall(function() _espLineFrame.Visible = false end)
        end
    end)
end

_enemySpeedAcc = 0
function updateEnemySpeedLabels()
    _enemySpeedAcc = _enemySpeedAcc + 1
    if _enemySpeedAcc < 6 then return end
    _enemySpeedAcc = 0
    local color = getThemeColor()
    local players = _GetPlayersCached()
    for i = 1, #players do
        local player = players[i]
        if player ~= LP then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local v = hrp.AssemblyLinearVelocity
                local speed = _sqrt(v.X*v.X + v.Z*v.Z)
                local label = enemySpeedLabels[player]
                if not label then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.new(0, 100, 0, 25)
                        bb.StudsOffset = _V3new(0, 5.5, 0)
                        bb.AlwaysOnTop = true
                        bb.Name = "EnemySpeedGui"
                        bb.Parent = head
                        local tl = Instance.new("TextLabel", bb)
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.TextColor3 = color
                        tl.Font = Enum.Font.GothamBold
                        tl.TextScaled = true
                        tl.TextStrokeTransparency = 0
                        tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        enemySpeedLabels[player] = tl
                        label = tl
                    end
                elseif label.Parent and label.Parent.Parent ~= char then
                    local head = char:FindFirstChild("Head")
                    if head then label.Parent.Parent = head end
                end
                if label then
                    label.Text = string.format("%.1f", speed)
                    if label.TextColor3 ~= color then label.TextColor3 = color end
                end
            else
                local label = enemySpeedLabels[player]
                if label and label.Parent and label.Parent.Parent then label.Parent.Parent = nil end
                enemySpeedLabels[player] = nil
            end
        end
    end
end

function startEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect() end
    enemySpeedConn = RunService.Heartbeat:Connect(updateEnemySpeedLabels)
end

function stopEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect(); enemySpeedConn = nil end
end

function getClosestTargetBody()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, _huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local dx = tRoot.Position.X - rpos.X
                        local dy = tRoot.Position.Y - rpos.Y
                        local dz = tRoot.Position.Z - rpos.Z
                        local d = dx*dx + dy*dy + dz*dz
                        if d < minDist then minDist = d; closest = tRoot end
                    end
                end
            end
        end
    end
    return closest
end

function _bodyLockTick()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local target = getClosestTargetBody()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    local dist = (target.Position - root.Position).Magnitude
    if dist > bodyLockRange then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    if hum.AutoRotate then hum.AutoRotate = false end
    local targetVel = target.AssemblyLinearVelocity
    local speed3 = targetVel.Magnitude
    local predictTime = _clamp(speed3 / 80, 0.08, 0.35)
    local predictedPos = target.Position + targetVel * predictTime
    local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
    local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
    local myHeight = root.Position.Y + (hum.HipHeight or 0)
    local heightDiff = targetHeight - myHeight
    local verticalCorrection = _clamp(heightDiff * 0.15, -1.5, 1.5)
    local flatTarget = _V3new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
    local toPredict = flatTarget - root.Position
    if toPredict.Magnitude > 0.1 then
        local goalCF = _CFlookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = _clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(0, ry * 42, 0))
    end
end

function startBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect() end
    local acc = 0
    _bodyLockConn = RunService.Heartbeat:Connect(function(dt)
        if not bodyLockEnabled then return end
        if _blSuppressCount > 0 then return end
        acc = acc + dt
        if acc < 0.033 then return end
        acc = 0
        _bodyLockTick()
    end)
end

function stopBodyLock()
    if _bodyLockConn then
        _bodyLockConn:Disconnect()
        _bodyLockConn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyAngularVelocity = _V3zero
        root.AssemblyLinearVelocity = _V3new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
    end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
end

function _suppressBodyLock()
    _blSuppressCount = _blSuppressCount + 1
    if _blSuppressCount == 1 and bodyLockEnabled then
        _blWasEnabled = true
        stopBodyLock()
        if bodyLockSetVisual then bodyLockSetVisual(false) end
        if _blRestoreTimer then
            task.cancel(_blRestoreTimer)
            _blRestoreTimer = nil
        end
        _blSmoothRestore = false
    end
end

function _unsuppressBodyLock(delayed)
    if _blSuppressCount > 0 then
        _blSuppressCount = _blSuppressCount - 1
    end
    if _blSuppressCount == 0 and _blWasEnabled then
        _blWasEnabled = false
        if _blRestoreTimer then
            pcall(task.cancel, _blRestoreTimer)
            _blRestoreTimer = nil
        end
        local function restore()
            _blRestoreTimer = nil
            if bodyLockEnabled then
                _blSmoothRestore = true
                startBodyLock()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                task.delay(0.5, function() _blSmoothRestore = false end)
            end
        end
        if delayed then
            _blRestoreTimer = task.delay(1, restore)
        else
            restore()
        end
    end
end

function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local oldBB = head:FindFirstChild("SyeHubSpeedIndicator")
    if oldBB then oldBB:Destroy() end
    local oldDiscord = head:FindFirstChild("DiscordText")
    if oldDiscord then oldDiscord:Destroy() end

    local bb = Instance.new("BillboardGui", head)
    bb.Name = "SyeHubSpeedIndicator"
    bb.Size = UDim2.fromOffset(200, 86)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = 0

    local discordLabel = Instance.new("TextLabel", bb)
    discordLabel.Name = "DiscordText"
    discordLabel.Size = UDim2.new(1, 0, 0, 28)
    discordLabel.Position = UDim2.new(0, 0, 0, 0)
    discordLabel.BackgroundTransparency = 1
    -- [HARDCODED FIX] overhead brand + theme color
    discordLabel.Text = "JK HUB"
    discordLabel.TextColor3 = (getThemeColor and getThemeColor()) or Color3.fromRGB(180, 180, 190)
    discordLabel.Font = Enum.Font.GothamBlack
    discordLabel.TextSize = 19
    discordLabel.TextXAlignment = Enum.TextXAlignment.Center
    discordLabel.TextYAlignment = Enum.TextYAlignment.Center
    discordLabel.TextStrokeTransparency = 0
    discordLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    local dlStroke = Instance.new("UIStroke", discordLabel)
    dlStroke.Color = Color3.fromRGB(0, 0, 0)
    dlStroke.Thickness = 1.5
    dlStroke.Transparency = 0.2
    applyShimmerToText(discordLabel, 0.9)

    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(1, 0, 0, 30)
    speedLabel.Position = UDim2.new(0, 0, 0, 28)
    speedLabel.BackgroundTransparency = 1
    -- [HARDCODED FIX] speed+mode same color as JK HUB
    speedLabel.Text = string.format("%.1f  -  %s", getActiveMoveSpeed(), getSpeedModeName())
    speedLabel.TextColor3 = (getThemeColor and getThemeColor()) or Color3.fromRGB(180, 180, 190)
    speedLabel.Font = Enum.Font.GothamBlack
    speedLabel.TextSize = 22
    speedLabel.TextXAlignment = Enum.TextXAlignment.Center
    speedLabel.TextYAlignment = Enum.TextYAlignment.Center
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    local slStroke = Instance.new("UIStroke", speedLabel)
    slStroke.Color = Color3.fromRGB(0, 0, 0)
    slStroke.Thickness = 1.5
    slStroke.Transparency = 0.2
    applyShimmerToText(speedLabel, 0.9)

    local ragLbl = Instance.new("TextLabel", bb)
    ragLbl.Name = "RagdollTimerLbl"
    ragLbl.Size = UDim2.new(1, 0, 0, 26)
    ragLbl.Position = UDim2.new(0, 0, 0, 56)
    ragLbl.BackgroundTransparency = 1
    ragLbl.Text = ""
    ragLbl.TextColor3 = Color3.fromRGB(80, 220, 80)
    ragLbl.Font = Enum.Font.GothamBlack
    ragLbl.TextSize = 20
    ragLbl.TextXAlignment = Enum.TextXAlignment.Center
    ragLbl.TextYAlignment = Enum.TextYAlignment.Center
    ragLbl.TextStrokeTransparency = 0
    ragLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    local rlStroke = Instance.new("UIStroke", ragLbl)
    rlStroke.Color = Color3.fromRGB(0, 0, 0)
    rlStroke.Thickness = 1.5
    rlStroke.Transparency = 0.2
end

-- ============================================================
-- RAGDOLL TIMER (overhead billboard, Blossom-style decimal countdown)
-- ============================================================
local _rtTimerActive = false
local _ragTimerDetectConn = nil

local function getRagTimerColor(t)
    -- Follow current theme so overhead updates without reset
    local c = (getThemeColor and getThemeColor()) or selectedColor or Color3.fromRGB(80, 220, 80)
    return c
end

local function getRagTimerLbl()
    local char = LP.Character
    if not char then return nil end
    local head = char:FindFirstChild("Head")
    if not head then return nil end
    local bb = head:FindFirstChild("SyeHubSpeedIndicator")
    if not bb then return nil end
    return bb:FindFirstChild("RagdollTimerLbl")
end

local function startRagTimerGui()
    if _rtTimerActive then return end
    _rtTimerActive = true
    task.spawn(function()
        local t = 3.0
        while t >= 0.0 do
            local lbl = getRagTimerLbl()
            if lbl then
                lbl.Text = string.format("%.1f", t)
                lbl.TextColor3 = getRagTimerColor(t)
            end
            task.wait(0.1)
            t = math.round((t - 0.1) * 10) / 10
        end
        local lbl = getRagTimerLbl()
        if lbl then
            lbl.Text = "STEAL!"
            lbl.TextColor3 = (getThemeColor and getThemeColor()) or Color3.fromRGB(80, 255, 120)
        end
        -- Wait until no longer ragdolled
        repeat task.wait(0.1) until (function()
            local c = LP.Character
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            if not hum then return true end
            local st = hum:GetState()
            return st ~= Enum.HumanoidStateType.Physics
                and st ~= Enum.HumanoidStateType.Ragdoll
                and st ~= Enum.HumanoidStateType.FallingDown
        end)()
        local lbl2 = getRagTimerLbl()
        if lbl2 then lbl2.Text = "" end
        _rtTimerActive = false
    end)
end

local function stopRagTimerDetection()
    if _ragTimerDetectConn then
        pcall(function() _ragTimerDetectConn:Disconnect() end)
        _ragTimerDetectConn = nil
    end
    _rtTimerActive = false
    local lbl = getRagTimerLbl()
    if lbl then lbl.Text = "" end
end

local function startRagTimerDetection(char)
    stopRagTimerDetection()
    if not e01TimerEnabled then return end
    _ragTimerDetectConn = RunService.Heartbeat:Connect(function()
        if not e01TimerEnabled then return end
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local st = hum:GetState()
        if st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown then
            startRagTimerGui()
        end
    end)
end

function setE01TimerEnabled(on)
    e01TimerEnabled = on and true or false
    if e01TimerEnabled then
        if LP.Character then startRagTimerDetection(LP.Character) end
        if _G.__ExoticHubE01Warning and _G.__ExoticHubE01Warning.start then
            pcall(_G.__ExoticHubE01Warning.start)
        end
    else
        stopRagTimerDetection()
        if _G.__ExoticHubE01Warning and _G.__ExoticHubE01Warning.stop then
            pcall(_G.__ExoticHubE01Warning.stop)
        end
    end
    if setE01TimerVisual then setE01TimerVisual(e01TimerEnabled) end
end

unwalkSavedAnimate = nil

function startUnwalk()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end
    end
    local anim = c:FindFirstChild("Animate")
    if anim then
        unwalkSavedAnimate = anim:Clone()
        anim:Destroy()
    end
end

function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then
                starterAnim:Clone().Parent = c
            elseif unwalkSavedAnimate then
                unwalkSavedAnimate:Clone().Parent = c
            end
        end
    end
    unwalkSavedAnimate = nil
end

function refreshSpeedModeLabel()
    -- [HARDCODED FIX] main UI + overhead update on every mode switch
    if modeValLbl then
        if laggerCarryToggled then modeValLbl.Text = "Lagger Carry"
        elseif laggerToggled then modeValLbl.Text = "Lagger Normal"
        elseif speedMode then modeValLbl.Text = "Carry"
        else modeValLbl.Text = "Normal" end
    end
    if speedLabel and speedLabel.Parent then
        local tc = (getThemeColor and getThemeColor()) or Color3.fromRGB(180, 180, 190)
        speedLabel.Text = string.format("%.1f  -  %s", getActiveMoveSpeed(), getSpeedModeName())
        speedLabel.TextColor3 = tc
        local dl = speedLabel.Parent:FindFirstChild("DiscordText")
        if dl and dl:IsA("TextLabel") then
            dl.Text = "JK HUB"
            dl.TextColor3 = tc
        end
    end
    if setCarryModeVisual then setCarryModeVisual(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function resetMovementState()
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

-- Carry key: cycle NORMAL <-> CARRY only (exits lagger states)
function toggleCarryMode()
    laggerToggled = false
    laggerCarryToggled = false
    speedMode = not speedMode
    resetMovementState()
    if setCarryModeVisual then setCarryModeVisual(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(false) end
    if setLaggerCarryVisual then setLaggerCarryVisual(false) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(false) end
    if mobSetLagger2 then mobSetLagger2(false) end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if _G.__ExoticHubApplySpeedNow then pcall(_G.__ExoticHubApplySpeedNow) end
    task.defer(function() pcall(saveAllSettings) end)
end

function toggleLaggerMode()
    -- [HARDCODED FIX]
    speedMode = false
    laggerCarryToggled = false
    laggerToggled = not laggerToggled
    resetMovementState()
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(false) end
    if setCarryModeVisual then setCarryModeVisual(false) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(false) end
    if mobSetCarry then mobSetCarry(false) end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if _G.__ExoticHubApplySpeedNow then pcall(_G.__ExoticHubApplySpeedNow) end
end

function toggleLaggerCarryMode()
    -- [HARDCODED FIX]
    speedMode = false
    laggerToggled = false
    laggerCarryToggled = not laggerCarryToggled
    resetMovementState()
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
    if setLaggerModeVisual then setLaggerModeVisual(false) end
    if setCarryModeVisual then setCarryModeVisual(false) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end
    if mobSetLagger1 then mobSetLagger1(false) end
    if mobSetCarry then mobSetCarry(false) end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if _G.__ExoticHubApplySpeedNow then pcall(_G.__ExoticHubApplySpeedNow) end
end

-- Lagger key: cycle LAGGER NORMAL <-> LAGGER CARRY only
function toggleLaggerCycle()
    speedMode = false
    if laggerToggled then
        laggerToggled = false
        laggerCarryToggled = true
    elseif laggerCarryToggled then
        laggerCarryToggled = false
        laggerToggled = true
    else
        -- first press from normal/carry → enter lagger normal
        laggerToggled = true
        laggerCarryToggled = false
    end
    resetMovementState()
    if setCarryModeVisual then setCarryModeVisual(false) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
    if mobSetCarry then mobSetCarry(false) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if _G.__ExoticHubApplySpeedNow then pcall(_G.__ExoticHubApplySpeedNow) end
    task.defer(function() pcall(saveAllSettings) end)
end

function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
    _unsuppressBodyLock(true)
end

function startAutoLeft()
    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end
    disableAllAimbots()
    _suppressBodyLock()
    if alConn then alConn:Disconnect() end
    alPhase = 1
    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if alPhase == 1 then
            local tgt = _V3new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.L1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif alPhase == 2 then
            local tgt = _V3new(AP.L2.X, root.Position.Y, AP.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobSetAutoLeft then mobSetAutoLeft(false) end
                _unsuppressBodyLock(true)
                local facePos = _V3new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.L2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
    _unsuppressBodyLock(true)
end

function startAutoRight()
    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    disableAllAimbots()
    _suppressBodyLock()
    if arConn then arConn:Disconnect() end
    arPhase = 1
    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if arPhase == 1 then
            local tgt = _V3new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.R1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif arPhase == 2 then
            local tgt = _V3new(AP.R2.X, root.Position.Y, AP.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobSetAutoRight then mobSetAutoRight(false) end
                _unsuppressBodyLock(true)
                local facePos = _V3new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.R2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function getClosestTarget()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, _huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local dx = tRoot.Position.X - rpos.X
                        local dy = tRoot.Position.Y - rpos.Y
                        local dz = tRoot.Position.Z - rpos.Z
                        local d = dx*dx + dy*dy + dz*dz
                        if d < minDist then minDist = d; closest = tRoot end
                    end
                end
            end
        end
    end
    return closest
end

function trySwing()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then return end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
end

-- Bypass swing: Activate only, with cooldown
_bypassSwingCd = false
function trySwingBypass()
    if _bypassSwingCd then return end
    _bypassSwingCd = true
    pcall(function()
        local char = LP.Character
        if not char then return end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
    task.delay(0.35, function() _bypassSwingCd = false end)
end

function getAutoBatTarget()
    local now = tick()
    if _autoBatTargetCache and (now - (_autoBatTargetAt or 0)) < 0.1 then
        if _autoBatTargetCache.Parent then return _autoBatTargetCache end
    end
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    _autoBatTargetCache = closest
    _autoBatTargetAt = now
    return closest
end

function stopAimbotAdapt()
    if _aimbotConn then
        pcall(function() _aimbotConn:Disconnect() end)
        _aimbotConn = nil
    end
    if _aimbotConn2 then
        pcall(function() _aimbotConn2:Disconnect() end)
        _aimbotConn2 = nil
    end
    autoBatEquippedThisRun = false
    _autoBatTargetCache = nil
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (_prevAutoRotate == nil) and true or _prevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
    end
    _prevAutoRotate = nil
    lastMoveDir = Vector3.zero
    _unsuppressBodyLock(true)
end

_aimbotConn2 = nil

function startAimbotAdapt()
    -- Clean normal aimbot: uses AUTO_BAT_* geometry + BAT_AIMBOT_SPEED chase
    if _aimbotConn then pcall(function() _aimbotConn:Disconnect() end); _aimbotConn = nil end
    if _aimbotConn2 then pcall(function() _aimbotConn2:Disconnect() end); _aimbotConn2 = nil end
    _suppressBodyLock()
    autoBatEquippedThisRun = false
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end

    _aimbotConn = RunService.RenderStepped:Connect(function(dt)
        if not autoBatEnabled then return end
        if batDesyncTpEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end

        local mode = tostring(aimbotMode or "normal")
        local isBypass = (mode == "antiBatBypass" or mode == "Bypass" or mode == "bypass")
        hum.AutoRotate = false

        -- Equip bat if needed
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        local target = getClosestTarget()
        if not target then return end

        local myPos = root.Position
        local targetPos = target.Position
        local targetVel = target.AssemblyLinearVelocity
        local dtSafe = (typeof(dt) == "number" and dt > 0 and dt < 0.1) and dt or (1 / 60)

        if not isBypass then
            -- ════════ CLEAN NORMAL MODE ════════
            local batSpd = tonumber(BAT_AIMBOT_SPEED) or tonumber(AUTO_BAT_SPEED) or 58
            local vertSpd = tonumber(AUTO_BAT_VERT_SPEED) or 52
            local standDist = tonumber(AUTO_BAT_DIST) or 2.8
            local heightOff = tonumber(AUTO_BAT_HEIGHT) or 4.75
            local vOff = tonumber(AUTO_BAT_V_OFF) or 1
            local turnSpd = tonumber(AUTO_BAT_TURN_SPEED) or 285
            local maxTurn = tonumber(AUTO_BAT_MAX_TURN_RATE) or 28

            -- Lead target slightly based on speed
            local speed3 = targetVel.Magnitude
            local predictT = math.clamp(speed3 / 150, 0.05, 0.18)
            local predictedPos = targetPos + targetVel * predictT

            -- Goal: hover at standDist from target, at heightOff + vOff
            local toTargetFlat = Vector3.new(predictedPos.X - myPos.X, 0, predictedPos.Z - myPos.Z)
            local flatMag = toTargetFlat.Magnitude
            local flatDir
            if flatMag > 0.05 then
                flatDir = toTargetFlat.Unit
            else
                local look = target.CFrame.LookVector
                flatDir = Vector3.new(look.X, 0, look.Z)
                if flatDir.Magnitude > 0.05 then
                    flatDir = flatDir.Unit
                else
                    flatDir = Vector3.new(0, 0, -1)
                end
            end

            -- Approach until within standDist, then orbit/hold
            local approach = 1
            if flatMag > 0.05 then
                local excess = flatMag - standDist
                if excess <= 0 then
                    approach = 0.15 -- soft hold near stand distance
                elseif excess < standDist then
                    approach = math.clamp(excess / standDist, 0.25, 1)
                end
            end

            local desiredHeight = predictedPos.Y + heightOff - vOff
            local yErr = desiredHeight - myPos.Y
            local yVel = yErr * (vertSpd * 0.38) + targetVel.Y * 0.55
            if hum.FloorMaterial ~= Enum.Material.Air then
                yVel = math.max(yVel, 10)
            end
            yVel = math.clamp(yVel, -75, 115)

            local desiredVel = Vector3.new(
                flatDir.X * batSpd * approach,
                yVel,
                flatDir.Z * batSpd * approach
            )
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.82)
            _s2VelState.v = desiredVel
            _G.__ExoticHubLiveSpeed = { t = os.clock(), v = batSpd }

            -- Smooth look-at predicted point with turn rate limits
            local aimPoint = predictedPos + Vector3.new(0, math.clamp(heightOff * 0.15, 0.2, 1.2), 0)
            if (aimPoint - myPos).Magnitude > 0.08 then
                local goalCF = CFrame.lookAt(myPos, aimPoint)
                local diffCF = root.CFrame:Inverse() * goalCF
                local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
                local turnScale = math.clamp(turnSpd / 285, 0.5, 1.6)
                local angMul = math.clamp(maxTurn * 1.5 * turnScale, 18, 55)
                rx = math.clamp(rx, -2.2, 2.2)
                ry = math.clamp(ry, -2.2, 2.2)
                rz = math.clamp(rz, -2.2, 2.2)
                root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
                    Vector3.new(rx * angMul, ry * angMul, rz * angMul)
                )
            end

            local distToTarget = (root.Position - target.Position).Magnitude
            local swingRange = math.max(standDist + 5.2, 7.5)
            if distToTarget <= swingRange then
                trySwing()
            end
        else
            -- ════════ BYPASS / ANTI-BAT MODE ════════
            local direction = targetPos - myPos
            local flatDir = Vector3.new(direction.X, 0, direction.Z)
            if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = Vector3.zero end

            local chaseSpeed = tonumber(BAT_AIMBOT_SPEED) or 58
            local desiredHeight = targetPos.Y + 3.7
            local yVel = (desiredHeight - myPos.Y) * 19.5
            if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
            yVel = math.clamp(yVel, -70, 110)

            local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
            _s2VelState.v = desiredVel
            _G.__ExoticHubLiveSpeed = { t = os.clock(), v = chaseSpeed }

            if (targetPos - myPos).Magnitude > 0.1 then
                local goalCF = CFrame.lookAt(myPos, targetPos)
                local diffCF = root.CFrame:Inverse() * goalCF
                local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
                rx = math.clamp(rx, -2.5, 2.5)
                ry = math.clamp(ry, -2.5, 2.5)
                rz = math.clamp(rz, -2.5, 2.5)
                root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
                    Vector3.new(rx * 42, ry * 42, rz * 42)
                )
            end

            local targetDist = (root.Position - target.Position).Magnitude
            if autoSwingEnabled and targetDist <= 8 then
                trySwingBypass()
            end
        end
    end)
end


-- =====================================================================
-- BAT BYPASS AIMBOT V2 (prediction + angular aim)
-- =====================================================================
BAT_V2_SPEED = BAT_V2_SPEED or 55
BAT_V2_HIT_DIST = BAT_V2_HIT_DIST or 13
BAT_V2_LEAD_STUDS = BAT_V2_LEAD_STUDS or 3
BAT_V2_BODY_LOCK_RANGE = BAT_V2_BODY_LOCK_RANGE or 60

snowVS = _G.SnowVS or {}
_G.SnowVS = snowVS
snowVS.BatBypass = snowVS.BatBypass or {}
snowVS.AimbotBypassV2 = snowVS.BatBypass

do
    local batBypass = snowVS.BatBypass
    batBypass.Enabled = batBypass.Enabled or false
    batBypass.Connection = batBypass.Connection or nil
    batBypass.Z = batBypass.Z or {
        targetPlayer = nil,
        lastTargetPos = nil,
        targetVelocity = Vector3.zero,
        smoothedVelocity = Vector3.zero,
        velocityHistory = {},
        accelerationHistory = {},
        aerialVelocityHistory = {},
        previousDirection = nil,
        lastDirectionChangeTime = 0,
        airborneTime = 0,
        lastActivationTime = 0,
        currentPing = 0.1,
        realPingMs = 0,
    }
    batBypass.ZCFG = batBypass.ZCFG or {
        FOLLOW_SPEED = BAT_V2_SPEED,
        ACTIVATE_DISTANCE = BAT_V2_HIT_DIST,
        MIN_FOLLOW_DISTANCE = 1,
        PREDICTION_TIME = 0.22,
        PREDICT_AHEAD = BAT_V2_LEAD_STUDS,
        MAX_VELOCITY_CHANGE = 150,
        VELOCITY_SMOOTHING = 0.2,
        MAX_HORIZONTAL_VELOCITY = 80,
        SERVER_TICKRATE = 1/60,
        MIN_PING_COMPENSATION = 0.03,
        MAX_PING_COMPENSATION = 0.25,
        ACCELERATION_PREDICTION_WEIGHT = 0.3,
        DIRECTION_CHANGE_DETECTION_TIME = 0.12,
        QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
        GRAVITY = 196.2,
        AIR_CONTROL_FACTOR = 0.8,
        MIN_AIRBORNE_TIME = 0.08,
    }

    local function averageVectors(vectors)
        if #vectors == 0 then return Vector3.zero end
        local sum = Vector3.zero
        for _, entry in ipairs(vectors) do sum = sum + entry end
        return sum / #vectors
    end
    local function pushBounded(history, entry, maxEntries)
        table.insert(history, entry)
        if #history > maxEntries then table.remove(history, 1) end
    end

    batBypass.FindBat = function()
        local character = LP.Character
        if not character then return nil end
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            local n = tool.Name:lower()
            if n:find("bat", 1, true) or n:find("slap", 1, true) then return tool end
        end
        local backpack = LP:FindFirstChildOfClass("Backpack")
        if backpack then
            for _, child in ipairs(backpack:GetChildren()) do
                if child:IsA("Tool") then
                    local n = child.Name:lower()
                    if n:find("bat", 1, true) or n:find("slap", 1, true) then return child end
                end
            end
        end
        return nil
    end

    local function resetPredictionState()
        local z = batBypass.Z
        z.targetPlayer = nil
        z.lastTargetPos = nil
        z.targetVelocity = Vector3.zero
        z.smoothedVelocity = Vector3.zero
        z.velocityHistory = {}
        z.accelerationHistory = {}
        z.aerialVelocityHistory = {}
        z.previousDirection = nil
        z.airborneTime = 0
    end

    local function findClosestPlayer(rootPart)
        local closestDistance, closestPlayer = math.huge, nil
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local mag = (rootPart.Position - hrp.Position).Magnitude
                    if mag < closestDistance then
                        closestDistance = mag
                        closestPlayer = player
                    end
                end
            end
        end
        return closestPlayer
    end

    local function applyAngularAim(rootPart, direction)
        if direction.Magnitude < 0.01 then return end
        local crossVector = rootPart.CFrame.LookVector:Cross(direction.Unit)
        local angle = math.asin(math.clamp(crossVector.Magnitude, -1, 1))
        rootPart.AssemblyAngularVelocity = crossVector.Magnitude > 0.1 and crossVector.Unit * angle * 80 or Vector3.zero
    end

    local function updatePing()
        local ok, result = pcall(function()
            return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        local z = batBypass.Z
        if ok and type(result) == "number" then z.realPingMs = math.floor(result) end
        z.currentPing = math.clamp(z.realPingMs / 1000, batBypass.ZCFG.MIN_PING_COMPENSATION, batBypass.ZCFG.MAX_PING_COMPENSATION)
    end

    if not batBypass.PingLoopStarted then
        batBypass.PingLoopStarted = true
        task.spawn(function()
            while true do
                pcall(updatePing)
                task.wait(0.5)
            end
        end)
    end

    batBypass.Stop = function()
        batBypass.Enabled = false
        if batBypass.Connection then
            batBypass.Connection:Disconnect()
            batBypass.Connection = nil
        end
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if humanoid then humanoid.AutoRotate = true end
        if root then root.AssemblyAngularVelocity = Vector3.zero end
        resetPredictionState()
        batBypass.Z.lastActivationTime = 0
    end

    batBypass.Start = function()
        if batBypass.Connection then return end
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then return end
        batBypass.Enabled = true
        humanoid.AutoRotate = false
        local tool = batBypass.FindBat()
        if tool and tool.Parent ~= character then
            pcall(function() humanoid:EquipTool(tool) end)
        end
        batBypass.Connection = RunService.RenderStepped:Connect(function(deltaTime)
            if not batBypass.Enabled then batBypass.Stop(); return end
            local z = batBypass.Z
            local zcfg = batBypass.ZCFG
            -- Follow current aimbot speed setting
            zcfg.FOLLOW_SPEED = tonumber(BAT_AIMBOT_SPEED) or 58
            local character2 = LP.Character
            local root = character2 and character2:FindFirstChild("HumanoidRootPart")
            local hum = character2 and character2:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health <= 0 then return end
            hum.AutoRotate = false
            tool = character2:FindFirstChildOfClass("Tool") or batBypass.FindBat()
            if tool and tool.Parent ~= character2 then
                pcall(function() hum:EquipTool(tool) end)
            end
            z.targetPlayer = findClosestPlayer(root)
            local tChar = z.targetPlayer and z.targetPlayer.Character
            local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
            local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
            if not tRoot or not tHum or tHum.Health <= 0 then
                resetPredictionState()
                return
            end
            local position = tRoot.Position
            local sampleDt = math.max(deltaTime, 1/240)
            if z.lastTargetPos then
                local targetVelocity = (position - z.lastTargetPos) / sampleDt
                local vector = targetVelocity - z.targetVelocity
                if vector.Magnitude > zcfg.MAX_VELOCITY_CHANGE then
                    targetVelocity = z.targetVelocity + vector.Unit * zcfg.MAX_VELOCITY_CHANGE
                end
                local horiz = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
                if horiz.Magnitude > zcfg.MAX_HORIZONTAL_VELOCITY then
                    local v = horiz.Unit * zcfg.MAX_HORIZONTAL_VELOCITY
                    targetVelocity = Vector3.new(v.X, targetVelocity.Y, v.Z)
                end
                pushBounded(z.accelerationHistory, (targetVelocity - z.targetVelocity) / sampleDt, 4)
                pushBounded(z.velocityHistory, targetVelocity, 8)
                z.targetVelocity = targetVelocity
                z.smoothedVelocity = z.smoothedVelocity:Lerp(targetVelocity, zcfg.VELOCITY_SMOOTHING)
            end
            z.lastTargetPos = position
            local isAirborne = tHum.FloorMaterial == Enum.Material.Air
            z.airborneTime = isAirborne and (z.airborneTime + sampleDt) or 0
            if isAirborne and z.airborneTime >= zcfg.MIN_AIRBORNE_TIME then
                pushBounded(z.aerialVelocityHistory, z.targetVelocity, 6)
            elseif not isAirborne then
                z.aerialVelocityHistory = {}
            end
            local smoothedVelocity = z.smoothedVelocity
            if isAirborne and #z.aerialVelocityHistory > 0 then
                local avg = averageVectors(z.aerialVelocityHistory)
                smoothedVelocity = Vector3.new(avg.X, z.targetVelocity.Y, avg.Z) * zcfg.AIR_CONTROL_FACTOR
            end
            local changedDirectionQuickly = false
            local horizVel = Vector3.new(z.targetVelocity.X, 0, z.targetVelocity.Z)
            if horizVel.Magnitude > 5 then
                local unit = horizVel.Unit
                if z.previousDirection and z.previousDirection:Dot(unit) < 0.5 then
                    changedDirectionQuickly = (tick() - z.lastDirectionChangeTime) < zcfg.DIRECTION_CHANGE_DETECTION_TIME
                    z.lastDirectionChangeTime = tick()
                end
                z.previousDirection = unit
            end
            local predictionTime = z.currentPing + zcfg.SERVER_TICKRATE
            if changedDirectionQuickly then predictionTime = predictionTime * zcfg.QUICK_DIRECTION_CHANGE_MULTIPLIER end
            local predictedPosition = position
                + smoothedVelocity * predictionTime
                + averageVectors(z.accelerationHistory) * zcfg.ACCELERATION_PREDICTION_WEIGHT * predictionTime * predictionTime * 0.5
            local leadTime = zcfg.PREDICTION_TIME * 1.1
            local leadPosition
            if isAirborne then
                leadPosition = predictedPosition + smoothedVelocity * leadTime + Vector3.new(0, -0.5 * zcfg.GRAVITY * leadTime * leadTime, 0)
            else
                leadPosition = predictedPosition + smoothedVelocity * leadTime
            end
            local hv = Vector3.new(smoothedVelocity.X, 0, smoothedVelocity.Z)
            if hv.Magnitude > 1 then
                leadPosition = leadPosition + hv.Unit * zcfg.PREDICT_AHEAD
            end
            local targetDirection = leadPosition - root.Position
            applyAngularAim(root, targetDirection)
            local withinRange = (position - root.Position).Magnitude <= zcfg.ACTIVATE_DISTANCE
            if withinRange and (tick() - z.lastActivationTime) >= 0.3 then
                if tool then pcall(function() tool:Activate() end) end
                z.lastActivationTime = tick()
            end
            if targetDirection.Magnitude > zcfg.MIN_FOLLOW_DISTANCE then
                root.AssemblyLinearVelocity = targetDirection.Unit * zcfg.FOLLOW_SPEED
            else
                root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.5, 0)
            end
        end)
    end

    batBypass.Toggle = function()
        if batBypass.Enabled then batBypass.Stop() else batBypass.Start() end
    end
end

function disableAutoBat()
    autoBatEnabled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    pcall(function() if snowVS and snowVS.BatBypass then snowVS.BatBypass.Stop() end end)
    pcall(stopAimbotAdapt)
    task.defer(function() pcall(saveAllSettings) end)
end

function enableAutoBat()
    local Safety = _G.__ExoticHubBrainrotSafety
    if Safety and Safety.guard and Safety.guard("batAimbot", false, function()
        autoBatEnabled = false
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
        stopAimbotAdapt()
    end) then
        return
    end
    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        stopAutoLeft()
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then autoRightSetVisual(false) end
        stopAutoRight()
    end
    if batDesyncTpEnabled then toggleBatDesyncTp() end
    autoBatEnabled = true
    local mode = tostring(aimbotMode or "normal")
    local isBypass = (mode == "antiBatBypass" or mode == "Bypass" or mode == "bypass")

    -- Always stop the other implementation first so switching modes while
    -- Auto Bat is enabled cannot leave both update loops running together.
    pcall(stopAimbotAdapt)
    pcall(function()
        if snowVS and snowVS.BatBypass then snowVS.BatBypass.Stop() end
    end)

    if isBypass then
        pcall(function()
            if snowVS and snowVS.BatBypass then
                snowVS.BatBypass.ZCFG.FOLLOW_SPEED = tonumber(BYPASS_AIMBOT_SPEED) or 60
                snowVS.BatBypass.Start()
            end
        end)
        if autoBatSetVisual then autoBatSetVisual(true) end
        if mobSetAutoBat then mobSetAutoBat(true) end
        task.defer(function() pcall(saveAllSettings) end)
        return
    end
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
    task.defer(function() pcall(saveAllSettings) end)
end

function updateTpBatButtonWithAntiDie(state)
    if tpBatFloatingButton then
        local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
        if btnFrame then
            local label = btnFrame:FindFirstChild("TextLabel")
            if state then
                btnFrame.BackgroundColor3 = getThemeColor()
                if label then
                    label.Text = "TP\nBAT"
                    label.TextColor3 = Color3.fromRGB(0,0,0)
                end
            else
                if label then label.Text = "TP\nBAT" end
                paintFloatingBtn(btnFrame, batDesyncTpEnabled)
            end
        end
    end
end

batDesyncTpEnabled = false
batDesyncTpConn = nil
batDesyncTpSetVisual = nil
hittingCooldownDesync = false
_tpBatUnwalkForced = false

-- TP Bat state (new logic)
local _tpBatState = {
    enabled = false,
    connection = nil,
    hitCooldown = false,
    antiDieConnections = {},
}

local function _tpBatDisconnectAntiDie()
    for _, conn in ipairs(_tpBatState.antiDieConnections) do
        pcall(function() conn:Disconnect() end)
    end
    _tpBatState.antiDieConnections = {}
end

local function _tpBatHookAntiDie(character)
    _tpBatDisconnectAntiDie()
    if not _tpBatState.enabled or not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    pcall(function()
        humanoid.BreakJointsOnDeath = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dying, false)
    end)

    table.insert(_tpBatState.antiDieConnections, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if _tpBatState.enabled and humanoid.Parent and humanoid.Health <= 0 then
            pcall(function()
                humanoid.Health = humanoid.MaxHealth
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
    end))
end

local function _tpBatFindBat()
    local character = LP.Character
    if not character then return nil end

    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then
            local n = child.Name:lower()
            if n:find("bat") or n:find("slap") then
                return child
            end
        end
    end

    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                local n = child.Name:lower()
                if n:find("bat") or n:find("slap") then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        pcall(function() humanoid:EquipTool(child) end)
                    end
                    return child
                end
            end
        end
    end

    return nil
end

local function _tpBatNearestPlayer(root)
    if not root then return nil, _huge end
    local best, bestD = nil, _huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local otherRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local otherHum  = player.Character:FindFirstChildOfClass("Humanoid")
            if otherRoot and otherHum and otherHum.Health > 0 then
                local d = (root.Position - otherRoot.Position).Magnitude
                if d < bestD then
                    bestD = d
                    best = player
                end
            end
        end
    end

    return best, bestD
end

local function _tpBatSwing()
    if _tpBatState.hitCooldown then return end
    _tpBatState.hitCooldown = true
    hittingCooldownDesync = true

    pcall(function()
        local bat = _tpBatFindBat()
        if not bat then return end
        bat:Activate()
        local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
        if remote then
            remote:FireServer()
        end
    end)

    task.delay(0.08, function()
        _tpBatState.hitCooldown = false
        hittingCooldownDesync = false
    end)
end

-- Compatibility aliases used by older call sites
function getBatDesync()
    return _tpBatFindBat()
end

function tryHitBatDesync()
    _tpBatSwing()
end

function getClosestPlayerDesync()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    return _tpBatNearestPlayer(root)
end

-- [EXOTIC_HUB] Marcador azul de ultima posicion
do
    local EXOTIC_HUB_MARKER_DISTANCE   = 3
    local EXOTIC_HUB_MIN_X, EXOTIC_HUB_MAX_X = -536.2, -422
    local EXOTIC_HUB_MIN_Y, EXOTIC_HUB_MAX_Y = -10,    75
    local EXOTIC_HUB_MIN_Z, EXOTIC_HUB_MAX_Z = -71.8, 192.9
    local EXOTIC_HUB_GROUND_Y          = -7
    local EXOTIC_HUB_LOOKBACK          = 0.2
    local EXOTIC_HUB_SAMPLE_INTERVAL   = 1 / 60

    local markerState = {
        markerLocked = false,
        markerTarget = nil,
        lastMarker   = nil,
        samples      = {},
        accumulator  = 0,
    }

    local function isInsideAllowedArea(pos)
        if not pos then return false end
        return pos.X >= EXOTIC_HUB_MIN_X and pos.X <= EXOTIC_HUB_MAX_X
           and pos.Y >= EXOTIC_HUB_MIN_Y and pos.Y <= EXOTIC_HUB_MAX_Y
           and pos.Z >= EXOTIC_HUB_MIN_Z and pos.Z <= EXOTIC_HUB_MAX_Z
    end

    local function finiteVector(v)
        return v ~= nil
            and v.X == v.X and v.Y == v.Y and v.Z == v.Z
            and math.abs(v.X) < 1e7
            and math.abs(v.Y) < 1e7
            and math.abs(v.Z) < 1e7
    end

    local function hideMarkerVisuals(marker)
        if not marker then return end
        pcall(function()
            marker.Transparency = 1
            local s = marker:FindFirstChild("AlwaysOnTopSphere")
            if s then s.Visible = false end
            local h = marker:FindFirstChild("LastPositionHighlight")
            if h then h.Enabled = false end
            local b = marker:FindFirstChild("LastPositionLabel")
            if b then b.Enabled = false end
        end)
    end

    local function clearLastMarker()
        markerState.markerLocked = false
        if markerState.lastMarker then
            hideMarkerVisuals(markerState.lastMarker)
        end
    end

    local function getLastMarkerCFrame()
        local marker = markerState.lastMarker
        if not (markerState.markerLocked and marker and marker.Parent and marker.Transparency < 1) then
            return nil
        end
        local tracked = markerState.markerTarget
        local trackedRoot = tracked and tracked.Character
                             and tracked.Character:FindFirstChild("HumanoidRootPart")
        if trackedRoot and isInsideAllowedArea(trackedRoot.Position) then
            clearLastMarker()
            return nil
        end
        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return marker.CFrame end
        local away = Vector3.new(
            myRoot.Position.X - marker.Position.X, 0,
            myRoot.Position.Z - marker.Position.Z
        )
        if away.Magnitude <= 0.05 then
            local look = marker.CFrame.LookVector
            away = Vector3.new(-look.X, 0, -look.Z)
        end
        if away.Magnitude <= 0.05 then away = Vector3.new(0, 0, 1) end
        local teleportPos = marker.Position + away.Unit * EXOTIC_HUB_MARKER_DISTANCE
        local flat = Vector3.new(
            marker.Position.X - teleportPos.X, 0,
            marker.Position.Z - teleportPos.Z
        )
        if flat.Magnitude > 0.05 then
            return _CFlookAt(teleportPos, teleportPos + flat.Unit)
        end
        return _CFnew(teleportPos)
    end

    local function createOrUpdateMarker(targetCFrame)
        if markerState.markerLocked then return end
        local tracked = markerState.markerTarget
        if not tracked or tracked.Parent ~= Players then return end
        local char = tracked.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        if not finiteVector(root.Position) then return end
        if isInsideAllowedArea(root.Position) then return end
        if not targetCFrame or not isInsideAllowedArea(targetCFrame.Position) then return end

        local groundCF = _CFnew(
            targetCFrame.Position.X,
            EXOTIC_HUB_GROUND_Y,
            targetCFrame.Position.Z
        ) * targetCFrame.Rotation

        local marker = markerState.lastMarker
        if not marker or not marker.Parent then
            marker = Instance.new("Part")
            marker.Name         = "ExoticHubTPBatLastPosition"
            marker.Shape        = Enum.PartType.Ball
            marker.Size         = Vector3.new(3, 3, 3)
            marker.Color        = Color3.fromRGB(0, 110, 255)
            marker.Material     = Enum.Material.Neon
            marker.Anchored     = true
            marker.CanCollide   = false
            marker.CanTouch     = false
            marker.CanQuery     = false
            marker.CastShadow   = false
            marker.Parent       = Workspace

            local overlay = Instance.new("SphereHandleAdornment")
            overlay.Name        = "AlwaysOnTopSphere"
            overlay.Adornee     = marker
            overlay.Radius      = 1.55
            overlay.Color3      = Color3.fromRGB(0, 125, 255)
            overlay.Transparency = 0.05
            overlay.AlwaysOnTop = true
            overlay.Visible     = true
            overlay.ZIndex      = 10
            overlay.Parent      = marker

            local hl = Instance.new("Highlight")
            hl.Name = "LastPositionHighlight"
            hl.Adornee = marker
            hl.FillColor = Color3.fromRGB(0, 110, 255)
            hl.FillTransparency = 0.15
            hl.OutlineColor = Color3.fromRGB(120, 200, 255)
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Enabled = true
            hl.Parent = marker

            local bb = Instance.new("BillboardGui")
            bb.Name = "LastPositionLabel"
            bb.Size = UDim2.new(0, 110, 0, 20)
            bb.StudsOffset = Vector3.new(0, 2.1, 0)
            bb.AlwaysOnTop = true
            bb.Adornee = marker
            bb.Parent = marker

            local lbl = Instance.new("TextLabel")
            lbl.Name = "Text"
            lbl.Size = UDim2.fromScale(1, 1)
            lbl.BackgroundTransparency = 1
            lbl.Text = "ultima posicion"
            lbl.TextColor3 = Color3.fromRGB(220, 235, 255)
            lbl.TextStrokeColor3 = Color3.fromRGB(0, 35, 90)
            lbl.TextStrokeTransparency = 0.25
            lbl.TextSize = 11
            lbl.Font = Enum.Font.GothamMedium
            lbl.Parent = bb

            markerState.lastMarker = marker
        end

        marker.Transparency = 0
        local s = marker:FindFirstChild("AlwaysOnTopSphere");      if s then s.Visible = true end
        local h = marker:FindFirstChild("LastPositionHighlight");  if h then h.Enabled = true end
        local b = marker:FindFirstChild("LastPositionLabel");      if b then b.Enabled = true end
        marker.CFrame = groundCF
        markerState.markerLocked = true
    end

    local function snapshotBeforeExit(history, now)
        if not history or #history == 0 then return nil end
        local cutoff = now - EXOTIC_HUB_LOOKBACK
        local selected
        for _, entry in ipairs(history) do
            if entry.time <= cutoff then selected = entry else break end
        end
        return selected or history[1]
    end

    local function pickClosestEnemy(myRoot)
        local closest, bestDistSq = nil, _huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local r = plr.Character:FindFirstChild("HumanoidRootPart")
                local h = plr.Character:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health > 0 and finiteVector(r.Position) then
                    local d = (r.Position - myRoot.Position).Magnitude
                    if d < bestDistSq then closest = plr; bestDistSq = d end
                end
            end
        end
        return closest
    end

    local function monitorLastTarget()
        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local tracked = markerState.markerTarget
        if tracked and tracked.Parent == Players then
            local char = tracked.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            local sample = markerState.samples[tracked] or {}
            markerState.samples[tracked] = sample

            if root and hum and hum.Health > 0 and finiteVector(root.Position) then
                if isInsideAllowedArea(root.Position) then
                    local now = _tick()
                    if markerState.markerLocked then sample.history = {} end
                    sample.history = sample.history or {}
                    table.insert(sample.history, { time = now, safeCFrame = root.CFrame })
                    while sample.history[1]
                        and now - sample.history[1].time > (EXOTIC_HUB_LOOKBACK + 0.25) do
                        table.remove(sample.history, 1)
                    end
                    sample.safeCFrame = root.CFrame
                    if markerState.markerLocked then clearLastMarker() end
                else
                    local snap = snapshotBeforeExit(sample.history, _tick())
                    createOrUpdateMarker((snap and snap.safeCFrame) or sample.safeCFrame)
                end
            end

            if (hum and hum.Health <= 0) or (not root and not sample.safeCFrame) then
                markerState.markerTarget = nil
                clearLastMarker()
            else
                return
            end
        end

        local closest = pickClosestEnemy(myRoot)
        if closest then
            markerState.markerTarget = closest
            local r = closest.Character:FindFirstChild("HumanoidRootPart")
            if r then
                local sample = markerState.samples[closest] or {}
                markerState.samples[closest] = sample
                sample.safeCFrame = r.CFrame
                sample.history = { { time = _tick(), safeCFrame = r.CFrame } }
            end
        end
    end

    local monitorConn = RunService.Heartbeat:Connect(function(dt)
        markerState.accumulator = markerState.accumulator + (dt or 0)
        if markerState.accumulator < EXOTIC_HUB_SAMPLE_INTERVAL then return end
        markerState.accumulator = markerState.accumulator % EXOTIC_HUB_SAMPLE_INTERVAL
        pcall(monitorLastTarget)
    end)

    _G.ExoticHubGetLastMarkerCFrame = getLastMarkerCFrame
    _G.ExoticHubClearLastMarker     = clearLastMarker
    _G.ExoticHubMarkerConn          = monitorConn

    LP.CharacterAdded:Connect(function()
        clearLastMarker()
        markerState.markerTarget = nil
        markerState.samples      = {}
    end)
end

function batDesyncTpUpdate()
    if not batDesyncTpEnabled or not _tpBatState.enabled then
        return
    end

    local character = LP.Character
    if not character then return end

    local root     = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end
    if humanoid.Health <= 0 then return end

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        pcall(function()
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                track:Stop()
            end
        end)
    end

    local bat = _tpBatFindBat()
    if bat and bat.Parent ~= character then
        pcall(function() humanoid:EquipTool(bat) end)
    end

    local target, distance = _tpBatNearestPlayer(root)
    if not target then return end

    local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot or distance > 100 then return end

    pcall(function()
        if root.SetNetworkOwner then root:SetNetworkOwner(nil) end
    end)

    if not _tpBatState.enabled or root.Parent ~= character or not targetRoot.Parent then
        return
    end

    root.CFrame = _CFnew(targetRoot.Position + _V3new(0, 0.9, 0))
    root.AssemblyLinearVelocity = targetRoot.AssemblyLinearVelocity

    pcall(function()
        if root.SetNetworkOwner then root:SetNetworkOwner(LP) end
    end)

    local camera = workspace.CurrentCamera
    if camera then
        camera.CFrame = _CFnew(camera.CFrame.Position, targetRoot.Position)
    end

    _tpBatSwing()

    pcall(function()
        for _, descendant in ipairs(character:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false
            end
        end
    end)
end

function startBatDesyncTp()
    if batDesyncTpConn then return end
    if not unwalkEnabled then
        startUnwalk()
        unwalkEnabled = true
        _tpBatUnwalkForced = true
        if setUnwalkVisual then setUnwalkVisual(true) end
    end
    batDesyncTpEnabled = true
    _tpBatState.enabled = true
    _tpBatHookAntiDie(LP.Character)
    batDesyncTpConn = RunService.Heartbeat:Connect(batDesyncTpUpdate)
    _tpBatState.connection = batDesyncTpConn
    if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
    updateTpBatButtonWithAntiDie(true)
end

function stopBatDesyncTp()
    if batDesyncTpConn then
        batDesyncTpConn:Disconnect()
        batDesyncTpConn = nil
    end
    _tpBatState.connection = nil
    batDesyncTpEnabled = false
    _tpBatState.enabled = false
    _tpBatDisconnectAntiDie()

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        pcall(function()
            if root.SetNetworkOwner then
                root:SetNetworkOwner(LP)
            end
        end)
    end

    if _tpBatUnwalkForced then
        stopUnwalk()
        unwalkEnabled = false
        _tpBatUnwalkForced = false
        if setUnwalkVisual then setUnwalkVisual(false) end
    end
    if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
    updateTpBatButtonWithAntiDie(false)
end

function toggleBatDesyncTp()
    if batDesyncTpEnabled then
        stopBatDesyncTp()
        updateTpBatButtonWithAntiDie(false)
    else
        disableAllAimbots()
        if autoLeftEnabled then
            autoLeftEnabled = false; stopAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if mobSetAutoLeft then mobSetAutoLeft(false) end
        end
        if autoRightEnabled then
            autoRightEnabled = false; stopAutoRight()
            if autoRightSetVisual then autoRightSetVisual(false) end
            if mobSetAutoRight then mobSetAutoRight(false) end
        end
        startBatDesyncTp()
        updateTpBatButtonWithAntiDie(true)
    end
    if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
    saveAllSettings()
end

-- Re-hook anti-die when character respawns while TP Bat is active
pcall(function()
    LP.CharacterAdded:Connect(function(character)
        if _tpBatState.enabled then
            task.wait(0.1)
            _tpBatHookAntiDie(character)
        end
    end)
end)

function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
    end
    for _, ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then
            return ch
        end
    end
    return nil
end

function isBatTool(tool)
    if not tool then return false end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        if tool.Name == name then return true end
    end
    return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end

function findBatForCounter()
    local char = LP.Character
    if not char then return nil end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local tool = char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
        if tool then return tool end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
            return child
        end
    end
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
                return child
            end
        end
    end
    return nil
end

function swingBatForCounter(bat, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= character and humanoid then
        pcall(function() humanoid:EquipTool(bat) end)
        task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        task.wait(0.1)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.1)
        pcall(function() bat:Activate() end)
    end
end

batCounterDebounce = false

function stopBatCounter()
    if Conns.batCounter then
        Conns.batCounter:Disconnect()
        Conns.batCounter = nil
    end
    batCounterDebounce = false
end

function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        if batCounterDebounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            batCounterDebounce = true
            _suppressBodyLock()
            task.spawn(function()
                task.wait(0.15)
                local bat = findBatForCounter()
                if bat then swingBatForCounter(bat, character) end
                task.wait(0.3)
                batCounterDebounce = false
                _unsuppressBodyLock(true)
            end)
        end
    end)
end

function findMedusa()
    local c = LP.Character
    if not c then return nil end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then return t end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then return t end
            end
        end
    end
    return nil
end

function useMedusaCounter()
    if medusaDebounce then return end
    if _tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
    local c = LP.Character
    if not c then return end
    medusaDebounce = true
    local med = findMedusa()
    if not med then medusaDebounce = false; return end
    if med.Parent ~= c then
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2:EquipTool(med) end
    end
    pcall(function() med:Activate() end)
    medusaLastUsed = _tick()
    medusaDebounce = false
end

function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusaCounter() end
    end)
end

function setupMedusaCounter(char)
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
    if not char or not medusaCounterEnabled then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end))
end

function stopMedusaCounter()
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
end

-- ============================================================
-- DROP BRAINROT (Stand/Fling + Jump Drop)
-- ============================================================
DROP_ASCEND_DURATION = 0.18
DROP_ASCEND_SPEED = 155
_dropConn = nil
_G.__ExoticHubDropToken = _G.__ExoticHubDropToken or 0
_G.IsDropping = false

local function _dropDisableOtherCollisions()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            for _, child in ipairs(player.Character:GetChildren()) do
                if child:IsA("BasePart") then
                    child.CanCollide = false
                end
            end
        end
    end
end

local function _dropCleanupThreads()
    for _, t in ipairs(dropConnections) do
        if typeof(t) == "RBXScriptConnection" then
            pcall(function() t:Disconnect() end)
        elseif type(t) == "thread" then
            pcall(task.cancel, t)
        end
    end
    dropConnections = {}
end

function stopDropBrainrot()
    _G.__ExoticHubDropToken = (_G.__ExoticHubDropToken or 0) + 1
    dropActive = false
    _G.IsDropping = false
    if autoAfterDropBat then
        task.defer(function()
            task.wait(0.05)
            if not autoBatEnabled and enableAutoBat then
                pcall(enableAutoBat)
                if autoBatSetVisual then autoBatSetVisual(true) end
                if mobSetAutoBat then mobSetAutoBat(true) end
            end
        end)
    end
    if _dropConn then
        pcall(function() _dropConn:Disconnect() end)
        _dropConn = nil
    end
    _dropCleanupThreads()
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = _V3new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z)
            root.Velocity = _V3new(root.Velocity.X, 0, root.Velocity.Z)
        end
    end
    if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
    if mobSetDropBR then mobSetDropBR(false) end
end

function runDropBrainrot()
    if dropActive then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- cancel any previous drop
    if _dropConn then pcall(function() _dropConn:Disconnect() end); _dropConn = nil end
    _dropCleanupThreads()

    dropActive = true
    _G.IsDropping = true
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(true) end

    -- disable aimbot while dropping
    local wasAutoBat = false
    if autoBatEnabled then
        wasAutoBat = true
        autoBatEnabled = false
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
        if stopAimbotAdapt then pcall(stopAimbotAdapt) end
    end

    local function finishDrop()
        dropActive = false
        _G.IsDropping = false
        if _dropConn then pcall(function() _dropConn:Disconnect() end); _dropConn = nil end
        _dropCleanupThreads()
        if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
        if mobSetDropBR then mobSetDropBR(false) end
        if wasAutoBat then
            task.defer(function()
                if enableAutoBat then pcall(enableAutoBat) end
            end)
        end
    end

    -- ========== MODE 1: FLING / STAND ==========
    if dropMode == 1 then
        local flingActive = true
        local steppedConn = RunService.Stepped:Connect(function()
            if not flingActive then return end
            _dropDisableOtherCollisions()
        end)
        table.insert(dropConnections, steppedConn)

        local flingThread = task.spawn(function()
            while flingActive do
                RunService.Heartbeat:Wait()
                local c = LP.Character
                local r = c and c:FindFirstChild("HumanoidRootPart")
                if not r then break end
                local vel = r.Velocity
                r.Velocity = vel * 10000 + _V3new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if r and r.Parent then r.Velocity = vel end
                RunService.Stepped:Wait()
                if r and r.Parent then r.Velocity = vel + _V3new(0, 0.1, 0) end
            end
        end)
        table.insert(dropConnections, flingThread)

        task.delay(0.1, function()
            flingActive = false
            finishDrop()
        end)
        return
    end

    -- ========== MODE 2: JUMP DROP (ascend + place on ground) ==========
    _G.__ExoticHubDropToken = (_G.__ExoticHubDropToken or 0) + 1
    local myToken = _G.__ExoticHubDropToken

    local rayParams = _G.__ExoticHubDropRayParams
    if not rayParams then
        rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        pcall(function() rayParams.RespectCanCollide = true end)
        _G.__ExoticHubDropRayParams = rayParams
    end
    rayParams.FilterDescendantsInstances = { char }

    local groundHit = workspace:Raycast(
        root.Position + _V3new(0, 0.35, 0),
        _V3new(0, -2000, 0),
        rayParams
    )
    if not groundHit then
        finishDrop()
        return
    end

    local rotation = root.CFrame.Rotation
    local saveX, saveZ = root.Position.X, root.Position.Z
    local t0 = tick()

    _dropConn = RunService.Heartbeat:Connect(function()
        local r = char and char:FindFirstChild("HumanoidRootPart")
        local h = char and char:FindFirstChildOfClass("Humanoid")
        if myToken ~= _G.__ExoticHubDropToken or not r or not h or h.Health <= 0 then
            if _dropConn then pcall(function() _dropConn:Disconnect() end); _dropConn = nil end
            finishDrop()
            return
        end

        -- ceiling hit → place under it
        local upHit = workspace:Raycast(r.Position, _V3new(0, 1, 0), rayParams)
        if upHit then
            if _dropConn then pcall(function() _dropConn:Disconnect() end); _dropConn = nil end
            r.CFrame = _CFnew(
                r.Position.X,
                upHit.Position.Y - r.Size.Y * 0.5 - 0.05,
                r.Position.Z
            ) * rotation
            r.AssemblyLinearVelocity = _V3zero
            r.AssemblyAngularVelocity = _V3zero
            finishDrop()
            return
        end

        -- timed out → place on ground
        if tick() - t0 >= DROP_ASCEND_DURATION then
            if _dropConn then pcall(function() _dropConn:Disconnect() end); _dropConn = nil end
            rayParams.FilterDescendantsInstances = { char }
            local hit = workspace:Raycast(
                r.Position + _V3new(0, 0.35, 0),
                _V3new(0, -2000, 0),
                rayParams
            ) or groundHit
            if hit then
                local off = (h.HipHeight or 2) + r.Size.Y * 0.5 + 0.2
                r.CFrame = _CFnew(saveX, hit.Position.Y + off, saveZ) * rotation
                r.AssemblyLinearVelocity = _V3zero
                r.AssemblyAngularVelocity = _V3zero
            end
            finishDrop()
            return
        end

        -- keep ascending
        r.AssemblyLinearVelocity = _V3new(
            r.AssemblyLinearVelocity.X,
            DROP_ASCEND_SPEED,
            r.AssemblyLinearVelocity.Z
        )
    end)
end

function silentDrop()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local t0 = os.clock()
    local conn
    conn = RunService.Heartbeat:Connect(function()
        local r = char and char:FindFirstChild("HumanoidRootPart")
        if not r then
            if conn then conn:Disconnect() end
            return
        end
        if os.clock() - t0 >= 0.2 then
            if conn then conn:Disconnect() end
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = { char }
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local hit = workspace:Raycast(r.Position, _V3new(0, -2000, 0), rp)
            if hit then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local off = (hum and hum.HipHeight or 2) + r.Size.Y / 2
                r.CFrame = _CFnew(r.Position.X, hit.Position.Y + off, r.Position.Z)
                r.Velocity = _V3zero
            end
            return
        end
        r.AssemblyLinearVelocity = _V3new(
            r.AssemblyLinearVelocity.X,
            150,
            r.AssemblyLinearVelocity.Z
        )
    end)
end

function executeDropWithToggle(setVisual)
    if dropActive then return end
    task.spawn(function()
        if setVisual then setVisual(true) end
        runDropBrainrot()
        while dropActive do task.wait() end
        task.wait(0.05)
        if setVisual then setVisual(false) end
    end)
end

LP.CharacterRemoving:Connect(function()
    _dropCleanupThreads()
    dropActive = false
    _G.IsDropping = false
end)

-- =====================================================================
-- ANTI LAG ULTRA
-- =====================================================================
_alSaved = setmetatable({}, { __mode = "k" })
_alDetached = {}
_alAnimators = setmetatable({}, { __mode = "k" })
_alStoppedTracks = setmetatable({}, { __mode = "k" })
_alGeneration = 0
_alScanCancel = nil
_alConns = {}
_alLightOrig = nil
_alRunning = false

local AL_LOW_FLAGS = {
    {"DFIntClusterSenderMaxJoinBandwidthBps", "2100000000"},
    {"DFIntClusterSenderMaxUpdateBandwidthBps", "2100000000"},
    {"DFIntServerFramesBetweenJoins", "1"},
    {"DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000"},
    {"DFIntConnectionMTUSize", "1400"},
    {"FIntRakNetResendBufferArrayLength", "1024"},
    {"DFIntRakNetNakResendDelayMsMax", "1"},
    {"DFIntWaitOnUpdateNetworkLoopEndedMS", "100"},
    {"DFIntWaitOnRecvFromLoopEndedMS", "100"},
    {"DFIntLargePacketQueueSizeCutoffMB", "1000"},
    {"DFIntSendRakNetStatsInterval", "2147483647"},
    {"DFIntRakNetLoopMs", "1"},
    {"DFIntRakNetSelectTimeoutMs", "1"},
    {"DFIntNetworkClusterPacketCacheNumParallelTasks", "8"},
    {"DFIntReplicationDataCacheNumParallelTasks", "8"},
    {"DFIntMegaReplicatorNumParallelTasks", "16"},
    {"DFIntMaxProcessPacketsStepsPerCyclic", "512"},
    {"DFIntMaxProcessPacketsStepsAccumulated", "0"},
    {"DFIntMaxProcessPacketsJobScaling", "1000"},
    {"DFIntClientPacketMaxFrameMicroseconds", "200000"},
    {"DFIntClientPacketExcessMicroseconds", "10000"},
    {"DFIntClientPacketMinMicroseconds", "1"},
    {"DFIntClientPacketMaxDelayMs", "1"},
    {"DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1"},
    {"DFIntMaxFrameBufferSize", "4"},
    {"DFIntBufferCompressionThreshold", "100"},
    {"DFIntOverrideISRReplicatorStepBandwidthBytes", "131072"},
    {"DFIntTaskSchedulerJobInitThreads", "8"},
    {"DFIntTaskSchedulerJobInGameThreads", "8"},
    {"FIntTaskSchedulerAutoThreadLimit", "16"},
    {"FIntTaskSchedulerAsyncTasksMinimumThreadCount", "4"},
    {"DFIntRuntimeConcurrency", "16"},
    {"FIntSimWorldTaskQueueParallelTasks", "20"},
    {"DFIntHttpBatchLimit", "256"},
    {"FIntHttpBatchLimit", "256"},
    {"DFIntHttpCurlConnectionCacheSize", "512"},
    {"FIntDefaultMeshCacheSizeMB", "512"},
    {"DFIntMemCacheMaxCapacityMB", "256"},
    {"DFIntNumAssetsMaxToPreload", "1"},
    {"DFFlagEnableSoundPreloading", "false"},
    {"FFlagSlimContentProvider", "true"},
    {"DFFlagDebugSkipMeshVoxelizer", "true"},
    {"DFFlagTextureQualityOverrideEnabled", "true"},
    {"DFIntTextureQualityOverride", "0"},
    {"FIntDebugTextureManagerSkipMips", "7"},
    {"DFIntDebugLimitMinTextureResolutionWhenSkipMips", "8"},
    {"FFlagTM2SkipMipsForUnstreamable2", "true"},
    {"DFFlagDoNotSkipMipsBasedOnSystemMemoryPS", "true"},
    {"FFlagRenderUseTextureManager224", "false"},
    {"DFIntDebugFRMQualityLevelOverride", "1"},
    {"DFFlagDebugPauseVoxelizer", "true"},
    {"FFlagFastGPULightCulling3", "true"},
    {"FIntRenderLocalLightFadeInMs", "0"},
    {"FIntRenderLocalLightUpdatesMax", "1"},
    {"FIntRenderShadowmapBias", "0"},
    {"FIntSSAOMipLevels", "0"},
    {"FIntDebugForceMSAASamples", "1"},
    {"FIntDebugFRMOptionalMSAALevelOverride", "0"},
    {"FIntRobloxGuiBlurIntensity", "0"},
    {"FIntFRMMinGrassDistance", "0"},
    {"FIntFRMMaxGrassDistance", "0"},
    {"DFFlagCoreScriptTelemetry2", "false"},
    {"DFFlagBrowserTrackerIdTelemetryEnabled", "false"},
    {"FFlagPerfDataOnTelemetryV2", "false"},
    {"FFlagSendRenderFidelityTelemetry2", "false"},
    {"FFlagEnableTelemetryServiceMemoryCPUInfo", "false"},
    {"DFIntTelemetryProfilerHundredthsPercentage", "0"},
    {"FIntTelemetryProfilerFrequency", "0"},
    {"FIntPerformanceTelemetryQueueProcessLimit", "0"},
    {"DFIntContentProviderPreloadHangTelemetryHundredthsPercentage", "0"},
}

function _alApplyLowFlags()
    local env = (getgenv and getgenv()) or _G
    local setter = rawget(env, "setfflag") or rawget(_G, "set_fflag")
    local getter = rawget(env, "getfflag") or rawget(_G, "get_fflag")
    if type(setter) ~= "function" then return end
    for _, flag in ipairs(AL_LOW_FLAGS) do
        local canSet = true
        if type(getter) == "function" then
            local ok, current = pcall(getter, flag[1])
            canSet = ok and current ~= nil
        end
        if canSet then pcall(setter, flag[1], tostring(flag[2])) end
    end
end

function _alSaveLighting()
    if _alLightOrig then return end
    _alLightOrig = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Ambient = Lighting.Ambient,
        GlobalShadows = Lighting.GlobalShadows,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
    }
end

function _alApplyLowPermanentSettings()
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    pcall(function()
        UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.FogStart = 0
        Lighting.FogEnd = 1e10
    end)
    pcall(function()
        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere then
            atmosphere.Density = 0
            atmosphere.Glare = 0
            atmosphere.Haze = 0
        end
    end)
    pcall(function()
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.Decoration = false
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            local clouds = terrain:FindFirstChildOfClass("Clouds")
            if clouds then clouds.Enabled = false end
        end
    end)
end

function _alChange(object, property, value)
    pcall(function()
        local original = object[property]
        if original == value then return end
        object[property] = value
        local bucket = _alSaved[object]
        if not bucket then bucket = {}; _alSaved[object] = bucket end
        if not bucket[property] then bucket[property] = { value = original } end
    end)
end

-- ============================================================
-- ANTI LAG (aggressive workspace cleaner)
-- ============================================================
_alIsProtected = function(arg)
    local character2 = LP.Character
    if character2 and (arg:IsDescendantOf(character2) or arg == character2) then
        return true
    end
    local backpack = LP:FindFirstChild("Backpack")
    if backpack and (arg:IsDescendantOf(backpack) or arg == backpack) then
        return true
    end
    local ok, result = pcall(function()
        local parent = arg
        while parent and parent ~= workspace and parent ~= game do
            if parent:GetAttribute("ExoticHubESP") == true then return true end
            if parent:GetAttribute("ExoticHubGhostBody") == true then return true end
            if parent:GetAttribute("ExoticHubAntiTPBatProxy") == true then return true end
            if type(parent.Name) == "string" and (
                parent.Name:match("^ExoticHub")
                or parent.Name:match("^VX7")
                or parent.Name:match("^ESP_")
            ) then
                return true
            end
            if parent:IsA("BasePart") and type(parent.Name) == "string" and parent.Name:match("^Sentry_%d+$") then
                return true
            end
            if parent:IsA("LayerCollector") or parent:IsA("GuiObject") or parent:IsA("GuiBase2d") then
                return true
            end
            parent = parent.Parent
        end
        return false
    end)
    if ok and result then return true end

    local animals = workspace:FindFirstChild("RenderedMovingAnimals")
    if animals and (arg:IsDescendantOf(animals) or arg == animals) then return true end

    ok, result = pcall(function()
        local parent = arg
        while parent and parent ~= workspace and parent ~= game do
            if parent:FindFirstChildOfClass("Humanoid") then return true end
            if parent:IsA("Model") and parent:FindFirstChildOfClass("AnimationController") then return true end
            parent = parent.Parent
        end
        return false
    end)
    if ok and result then return true end

    ok, result = pcall(function()
        local root = character2 and (character2:FindFirstChild("HumanoidRootPart") or character2:FindFirstChild("UpperTorso"))
        if not root then return false end
        if arg:IsA("Model") then
            local primary = arg.PrimaryPart or arg:FindFirstChildOfClass("BasePart")
            if primary and (root.Position - primary.Position).Magnitude <= 10 then
                return true
            end
        end
        return false
    end)
    if ok and result then return true end
    return false
end

_antiLagConns = {}
_antiLagLoop = nil
_antiLagWhitelist = {}
_antiLagMapWhitelist = {}

function _alAdd(tbl, obj)
    if obj then tbl[obj] = true end
end

function _alFindPath(...)
    local parts = { ... }
    local cur = workspace
    for _, name in ipairs(parts) do
        cur = cur:FindFirstChild(name)
        if not cur then return nil end
    end
    return cur
end

function _alRebuildWhitelist()
    table.clear(_antiLagWhitelist)
    table.clear(_antiLagMapWhitelist)
    _alAdd(_antiLagWhitelist, workspace:FindFirstChild("Camera"))
    _alAdd(_antiLagWhitelist, workspace:FindFirstChild("Terrain"))
    _alAdd(_antiLagWhitelist, workspace:FindFirstChild("Debris"))
    _alAdd(_antiLagWhitelist, workspace:FindFirstChild("Plots"))
    _alAdd(_antiLagWhitelist, workspace:FindFirstChild("RenderedMovingAnimals"))
    _alAdd(_antiLagWhitelist, _alFindPath("Map"))
    _alAdd(_antiLagMapWhitelist, _alFindPath("Map", "WallModels"))
    _alAdd(_antiLagMapWhitelist, _alFindPath("Map", "__StreamCheck_DontDelete"))
    _alAdd(_antiLagMapWhitelist, _alFindPath("Map", "Carpet"))
    _alAdd(_antiLagMapWhitelist, _alFindPath("Map", "Ground"))
    _alAdd(_antiLagMapWhitelist, _alFindPath("Map", "Ground_Left"))
    _alAdd(_antiLagMapWhitelist, _alFindPath("Map", "Ground_Right"))
end

function _alIsUUID(name)
    return type(name) == "string"
        and name:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") ~= nil
end

function _alRemoveAnimControllers()
    for i, v in ipairs(workspace:GetDescendants()) do
        if not antiLagEnabled then return end
        if not _alIsProtected(v) and v:IsA("AnimationController") then
            pcall(function() v:Destroy() end)
        end
        if i % 160 == 0 then RunService.Heartbeat:Wait() end
    end
end

function _alRemoveVisuals()
    for i, v in ipairs(workspace:GetDescendants()) do
        if not antiLagEnabled then return end
        if i % 160 == 0 then RunService.Heartbeat:Wait() end
        if _alIsProtected(v) then continue end
        pcall(function()
            if v:IsA("Texture") or v:IsA("Decal") or v:IsA("SurfaceAppearance") then
                v:Destroy()
            elseif v:IsA("SpecialMesh") then
                v.TextureId = ""
            elseif v:IsA("MeshPart") then
                v.TextureID = ""
                v.CastShadow = false
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam")
                or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles")
                or v:IsA("Highlight") or v:IsA("Explosion")
                or v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
                v:Destroy()
            elseif v:IsA("BasePart") then
                v.CastShadow = false
                v.Material = Enum.Material.Plastic
                v.MaterialVariant = ""
                v.Reflectance = 0
            end
        end)
    end
end

function _alHasSound(obj)
    if obj:IsA("Sound") or obj:IsA("SoundGroup") then return true end
    return obj:FindFirstChildOfClass("Sound", true) ~= nil
        or obj:FindFirstChildOfClass("SoundGroup", true) ~= nil
end

function _alCleanMap()
    local map = workspace:FindFirstChild("Map")
    if not map then return end
    for _, child in ipairs(map:GetChildren()) do
        if not _antiLagMapWhitelist[child] and not _alHasSound(child) and not _alIsProtected(child) then
            pcall(function() child:Destroy() end)
        end
    end
end

function _alCleanWorkspace()
    _alRebuildWhitelist()
    for _, child in ipairs(workspace:GetChildren()) do
        if not _antiLagWhitelist[child]
            and not _alIsUUID(child.Name)
            and not Players:FindFirstChild(child.Name)
            and not _alIsProtected(child)
            and not _alHasSound(child) then
            pcall(function() child:Destroy() end)
        end
    end
    _alCleanMap()
end

function _alCleanLighting()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("Sky") or child:IsA("Atmosphere") or child:IsA("Clouds") then
            -- keep
        elseif child:IsA("PostEffect") then
            pcall(function() child:Destroy() end)
        end
    end
end

function applyAntiLag()
    antiLagEnabled = true
    _alRunning = true
    _alRemoveAnimControllers()
    if not antiLagEnabled then _alRunning = false; return end
    _alRemoveVisuals()
    if not antiLagEnabled then _alRunning = false; return end
    _alCleanWorkspace()
    _alCleanLighting()

    for _, conn in pairs(_antiLagConns) do
        pcall(function() conn:Disconnect() end)
    end
    _antiLagConns = {}

    table.insert(_antiLagConns, workspace.DescendantAdded:Connect(function(descendant)
        if not antiLagEnabled then return end
        if _alIsProtected(descendant) then return end
        task.defer(function()
            if not antiLagEnabled or _alIsProtected(descendant) then return end
            pcall(function()
                if descendant:IsA("Texture") or descendant:IsA("Decal")
                    or descendant:IsA("SurfaceAppearance")
                    or descendant:IsA("ParticleEmitter") or descendant:IsA("Trail")
                    or descendant:IsA("Beam") or descendant:IsA("Fire")
                    or descendant:IsA("Smoke") or descendant:IsA("Sparkles")
                    or descendant:IsA("Highlight") or descendant:IsA("AnimationController") then
                    descendant:Destroy()
                end
            end)
        end)
    end))

    table.insert(_antiLagConns, Lighting.DescendantAdded:Connect(function(descendant)
        if not antiLagEnabled then return end
        if descendant:IsA("Sky") or descendant:IsA("Atmosphere") or descendant:IsA("Clouds") then return end
        if descendant:IsA("PostEffect") then
            pcall(function() descendant:Destroy() end)
        end
    end))

    local okMS, MaterialService = pcall(function() return game:GetService("MaterialService") end)
    if okMS and MaterialService then
        table.insert(_antiLagConns, MaterialService.DescendantAdded:Connect(function(descendant)
            if not antiLagEnabled then return end
            if _alIsProtected(descendant) then return end
            pcall(function() descendant:Destroy() end)
        end))
    end

    if _antiLagLoop then pcall(task.cancel, _antiLagLoop) end
    _antiLagLoop = task.spawn(function()
        while antiLagEnabled do
            task.wait(2)
            if antiLagEnabled then
                pcall(_alCleanWorkspace)
                pcall(_alCleanLighting)
            end
        end
    end)
end

function undoAntiLag()
    antiLagEnabled = false
    _alRunning = false
    for _, conn in pairs(_antiLagConns) do
        pcall(function() conn:Disconnect() end)
    end
    _antiLagConns = {}
    if _antiLagLoop then
        pcall(task.cancel, _antiLagLoop)
        _antiLagLoop = nil
    end
end

function enableAntiLag()
    if antiLagEnabled and _alRunning then return end
    applyAntiLag()
end

function disableAntiLag()
    undoAntiLag()
end

-- ============================================================
-- LOW GRAPHICS (Potato Graphics)
-- ============================================================
potatoGraphicsActive = false
potatoGraphicsDescConn = nil

_applyPotatoObj = function(arg)
    local parent = arg
    while parent do
        local str6 = tostring(parent.Name)
        if str6 == "TutorialArrow"
            or str6 == "ChargeSoundPart"
            or str6 == "CraftingMachine"
            or str6 == "DO_NOT_REMOVE_ForgeTextureCache" then
            return
        end
        parent = parent.Parent
    end
    pcall(function()
        if arg:IsA("BasePart") then
            arg.Material = Enum.Material.Plastic
            arg.MaterialVariant = ""
            arg.Reflectance = 0
            arg.CastShadow = false
            if arg:IsA("MeshPart") then
                arg.TextureID = ""
            end
        elseif arg:IsA("Decal")
            or arg:IsA("Texture")
            or arg:IsA("SurfaceAppearance")
            or arg:IsA("Shirt")
            or arg:IsA("Pants")
            or arg:IsA("ShirtGraphic")
            or arg:IsA("CharacterMesh") then
            arg:Destroy()
        elseif arg:IsA("SpecialMesh") then
            arg.TextureId = ""
        elseif arg:IsA("ParticleEmitter")
            or arg:IsA("Trail")
            or arg:IsA("Beam")
            or arg:IsA("Fire")
            or arg:IsA("Smoke")
            or arg:IsA("Sparkles")
            or arg:IsA("PointLight")
            or arg:IsA("SpotLight")
            or arg:IsA("SurfaceLight")
            or arg:IsA("PostEffect") then
            arg.Enabled = false
        elseif arg:IsA("AnimationController") or arg:IsA("Animator") then
            for _, v88 in ipairs(arg:GetPlayingAnimationTracks()) do
                pcall(function() v88:Stop(0) end)
            end
        end
    end)
end

function enablePotatoGraphics()
    if potatoGraphicsActive then return end
    potatoGraphicsActive = true
    lowGraphicsEnabled = true
    _G.ExoticHubPotatoGraphics = true

    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)

    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.Brightness = 1
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.FogEnd = 9e9
        Lighting.ShadowSoftness = 0
        for _, child in ipairs(Lighting:GetChildren()) do
            if not child:GetAttribute("ExoticHubVividGraphics")
                and (child:IsA("BlurEffect")
                    or child:IsA("SunRaysEffect")
                    or child:IsA("BloomEffect")
                    or child:IsA("DepthOfFieldEffect")
                    or child:IsA("ColorCorrectionEffect")) then
                child.Enabled = false
            end
        end
    end)

    pcall(function()
        local terrain = Workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.Decoration = false
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 1
        end
    end)

    task.spawn(function()
        local n35 = 0
        for _, descendant in ipairs(Workspace:GetDescendants()) do
            if not potatoGraphicsActive then return end
            _applyPotatoObj(descendant)
            n35 = n35 + 1
            if n35 % 350 == 0 then task.wait() end
        end
    end)

    if potatoGraphicsDescConn then
        potatoGraphicsDescConn:Disconnect()
    end
    potatoGraphicsDescConn = Workspace.DescendantAdded:Connect(function(descendant)
        if potatoGraphicsActive then
            _applyPotatoObj(descendant)
        end
    end)
end

function disablePotatoGraphics()
    potatoGraphicsActive = false
    lowGraphicsEnabled = false
    _G.ExoticHubPotatoGraphics = false
    if potatoGraphicsDescConn then
        potatoGraphicsDescConn:Disconnect()
        potatoGraphicsDescConn = nil
    end
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
    end)
    pcall(function()
        local terrain = Workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.Decoration = true
        end
    end)
end

-- ============================================================
-- SAFE MODE — Brainrot safety (blocks combat while carrying)
-- ============================================================
do
    local WEAPON_KEYS = { "bat", "slap", "medusa", "head", "stone" }
    local CHAR_SKIP = {
        animate = true, animsaves = true, health = true, rig = true,
        ["body colors"] = true, bodycolors = true, humanoid = true,
        head = true, torso = true, uppertorso = true, lowertorso = true,
        humanoidrootpart = true,
    }
    local function _isWeaponName(n)
        n = tostring(n or ""):lower()
        for _, k in ipairs(WEAPON_KEYS) do
            if n:find(k, 1, true) then return true end
        end
        return false
    end
    local function _isCharPart(obj)
        local n = obj.Name:lower()
        if CHAR_SKIP[n] or _isWeaponName(n) then return true end
        if obj:FindFirstChildOfClass("Humanoid") then return true end
        if obj:FindFirstChildWhichIsA("Accoutrement", true) then return true end
        return false
    end
    local Safety = {}
    Safety.isHoldingBrainrot = function()
        local char = LP.Character
        if not char then return false end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Tool") and not _isWeaponName(child.Name) then
                return true, "tool", child.Name
            end
        end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Model") and not _isCharPart(child) and child:FindFirstChildWhichIsA("BasePart") then
                return true, "model", child.Name
            end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local sitting = hum and (hum.Sit or hum.SeatPart ~= nil)
        local root = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
        if root and not sitting then
            local ok, parts = pcall(function() return root:GetConnectedParts(true) end)
            if ok and parts then
                for _, p in ipairs(parts) do
                    if not p:IsDescendantOf(char) and not p:IsA("Seat") and not p:IsA("VehicleSeat") then
                        local tool = p:FindFirstAncestorWhichIsA("Tool")
                        if not _isWeaponName(tool and tool.Name or p.Name) then
                            local model = p:FindFirstAncestorOfClass("Model")
                            if not (model and Players:GetPlayerFromCharacter(model)) then
                                return true, "weld", model and model.Name or (tool and tool.Name) or p.Name
                            end
                        end
                    end
                end
            end
        end
        return false
    end
    Safety.cancel = function(key)
        _G.__ExoticHubSafetyTokens = _G.__ExoticHubSafetyTokens or {}
        _G.__ExoticHubSafetyTokens[key] = (_G.__ExoticHubSafetyTokens[key] or 0) + 1
    end
    Safety.guard = function(key, forceBypass, onBlock, onAllow)
        if forceBypass or not safeModeEnabled then return false end
        local ok, holding = pcall(Safety.isHoldingBrainrot)
        if not ok or not holding then return false end
        Safety.cancel(key)
        pcall(onBlock)
        return true
    end
    _G.__ExoticHubBrainrotSafety = Safety
end

-- ============================================================
-- E01 WARNING — billboard when you start carrying brainrot
-- ============================================================
do
    local E01 = {
        wasCarrying = false,
        lastTriggered = -math.huge,
        elapsed = 0,
        generation = 0,
        board = nil,
        timer = nil,
        monitor = nil,
        respawn = nil,
    }
    function E01.clear()
        E01.generation = E01.generation + 1
        if E01.timer then E01.timer:Disconnect(); E01.timer = nil end
        if E01.board then pcall(function() E01.board:Destroy() end); E01.board = nil end
    end
    function E01.show()
        local char = LP.Character
        local head = char and char:FindFirstChild("Head")
        if not head then return end
        E01.clear()
        local gen = E01.generation
        local bb = Instance.new("BillboardGui")
        bb.Name = "ExoticHub_WARNING_E01"
        bb.Adornee = head
        bb.Size = UDim2.fromOffset(252, 56)
        bb.StudsOffset = _V3new(0, 4.95, 0)
        bb.AlwaysOnTop = true
        bb.LightInfluence = 0
        bb.MaxDistance = 150
        bb.Parent = head
        E01.board = bb
        local frame = Instance.new("Frame", bb)
        frame.Size = UDim2.fromOffset(252, 56)
        frame.BackgroundColor3 = Color3.fromRGB(22, 2, 7)
        frame.BackgroundTransparency = 0.35
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = Color3.fromRGB(232, 31, 58)
        stroke.Thickness = 1.15
        stroke.Transparency = 0.28
        local title = Instance.new("TextLabel", frame)
        title.Size = UDim2.new(1, 0, 0, 22)
        title.BackgroundTransparency = 1
        title.Text = "WARNING E01"
        title.Font = Enum.Font.GothamBold
        title.TextSize = 13
        title.TextColor3 = Color3.fromRGB(255, 90, 100)
        local sub = Instance.new("TextLabel", frame)
        sub.Size = UDim2.new(1, 0, 0, 30)
        sub.Position = UDim2.fromOffset(0, 23)
        sub.BackgroundTransparency = 1
        sub.Text = "SAFE IN 3.00s"
        sub.Font = Enum.Font.GothamMedium
        sub.TextSize = 18
        sub.TextColor3 = Color3.fromRGB(255, 100, 110)
        local t0 = os.clock()
        E01.timer = RunService.RenderStepped:Connect(function()
            if gen ~= E01.generation then return end
            if not bb.Parent then E01.clear(); return end
            local left = math.max(0, 3 - (os.clock() - t0))
            if left > 0 then
                sub.Text = string.format("SAFE IN %.2fs", left)
                if left < 1 then
                    sub.TextColor3 = Color3.fromRGB(255, 203, 72)
                    stroke.Color = Color3.fromRGB(240, 145, 40)
                end
                return
            end
            E01.timer:Disconnect(); E01.timer = nil
            sub.Text = "SAFE TO STEAL"
            sub.TextColor3 = Color3.fromRGB(73, 255, 145)
            stroke.Color = Color3.fromRGB(42, 218, 112)
            task.delay(1.5, function()
                if gen == E01.generation then E01.clear() end
            end)
        end)
    end
    function E01.stop()
        if E01.monitor then E01.monitor:Disconnect(); E01.monitor = nil end
        if E01.respawn then E01.respawn:Disconnect(); E01.respawn = nil end
        E01.wasCarrying = false
        E01.clear()
    end
    function E01.start()
        if E01.monitor then return end
        E01.wasCarrying = false
        E01.lastTriggered = -math.huge
        E01.elapsed = 0
        E01.monitor = RunService.Heartbeat:Connect(function(dt)
            E01.elapsed = E01.elapsed + (dt or 0)
            if E01.elapsed < 0.08 then return end
            E01.elapsed = 0
            if not e01TimerEnabled then return end
            local Safety = _G.__ExoticHubBrainrotSafety
            local ok, carrying = pcall(function()
                return Safety and Safety.isHoldingBrainrot and Safety.isHoldingBrainrot()
            end)
            carrying = ok and carrying == true
            local char = LP.Character
            if not carrying and char then
                for _, attr in ipairs({"Carrying", "IsCarrying", "HasBrainrot"}) do
                    if char:GetAttribute(attr) == true or LP:GetAttribute(attr) == true then
                        carrying = true
                        break
                    end
                end
            end
            if carrying and not E01.wasCarrying and os.clock() - E01.lastTriggered > 3.25 then
                E01.lastTriggered = os.clock()
                E01.show()
            end
            E01.wasCarrying = carrying
        end)
        E01.respawn = LP.CharacterAdded:Connect(function()
            E01.wasCarrying = false
            E01.lastTriggered = -math.huge
            E01.clear()
        end)
    end
    _G.__ExoticHubE01Warning = E01
    -- Start if toggle is already on
    if e01TimerEnabled then task.defer(function() pcall(E01.start) end) end
end

-- ============================================================
-- ENEMY RAGDOLL TIMER — countdown overlay on ragdolled enemies
-- ============================================================
enemyRagdollTimerEnabled = true
do
    local scanConn, removeConn
    local acc, states, overlays = 0, {}, {}
    local function clearOne(plr)
        local o = overlays[plr]
        if not o then return end
        o.token = (o.token or 0) + 1
        if o.posConn then o.posConn:Disconnect(); o.posConn = nil end
        if o.gui then pcall(function() o.gui:Destroy() end) end
        overlays[plr] = nil
    end
    local function clearAll()
        local keys = {}
        for k in pairs(overlays) do keys[#keys + 1] = k end
        for _, k in ipairs(keys) do clearOne(k) end
        table.clear(states)
    end
    local function isRagdolled(plr, char, hum)
        local st = hum:GetState()
        if st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown then
            return true
        end
        local endT = plr:GetAttribute("RagdollEndTime")
            or char:GetAttribute("RagdollEndTime")
            or hum:GetAttribute("RagdollEndTime")
        if type(endT) == "number" and endT > workspace:GetServerTimeNow() then
            return true
        end
        return false
    end
    local function spawnOverlay(plr, char, duration)
        local root = char:FindFirstChild("HumanoidRootPart")
        local pgui = LP:FindFirstChildOfClass("PlayerGui") or pgui
        if not root or not pgui then return end
        clearOne(plr)
        local name = "ExoticHubEnemyRag_" .. tostring(plr.UserId)
        local old = pgui:FindFirstChild(name)
        if old then old:Destroy() end
        local sg = Instance.new("ScreenGui")
        sg.Name = name
        sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true
        sg.DisplayOrder = 100
        sg.Parent = pgui
        local holder = Instance.new("Frame", sg)
        holder.Size = UDim2.fromOffset(104, 50)
        holder.AnchorPoint = Vector2.new(0.5, 0.5)
        holder.BackgroundTransparency = 1
        holder.Visible = false
        holder.ZIndex = 1000
        local box = Instance.new("Frame", holder)
        box.Size = UDim2.new(1, -8, 1, -8)
        box.Position = UDim2.fromOffset(4, 4)
        box.BackgroundColor3 = Color3.fromRGB(12, 13, 17)
        box.BackgroundTransparency = 0.16
        box.BorderSizePixel = 0
        box.ZIndex = 1001
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 11)
        local accent = getThemeColor and getThemeColor() or Color3.fromRGB(180, 180, 190)
        local stroke = Instance.new("UIStroke", box)
        stroke.Color = accent
        stroke.Transparency = 0.18
        stroke.Thickness = 1.2
        local tag = Instance.new("TextLabel", box)
        tag.Size = UDim2.new(1, 0, 0, 14)
        tag.Position = UDim2.fromOffset(0, 3)
        tag.BackgroundTransparency = 1
        tag.Text = "RAGDOLL"
        tag.Font = Enum.Font.GothamBold
        tag.TextSize = 7
        tag.TextColor3 = accent
        tag.ZIndex = 1002
        local num = Instance.new("TextLabel", box)
        num.Size = UDim2.new(1, -8, 0, 25)
        num.Position = UDim2.fromOffset(4, 14)
        num.BackgroundTransparency = 1
        num.Font = Enum.Font.GothamBlack
        num.TextSize = 19
        num.TextColor3 = accent
        num.TextStrokeTransparency = 0.38
        num.ZIndex = 1002
        local entry = { gui = sg, token = 1 }
        overlays[plr] = entry
        local token = entry.token
        entry.posConn = RunService.RenderStepped:Connect(function()
            if not root.Parent or not holder.Parent then holder.Visible = false; return end
            local cam = workspace.CurrentCamera
            if not cam then holder.Visible = false; return end
            local v, onScreen = cam:WorldToViewportPoint(root.Position + _V3new(0, 1.85, 0))
            holder.Visible = onScreen and v.Z > 0
            if holder.Visible then holder.Position = UDim2.fromOffset(v.X, v.Y) end
        end)
        task.spawn(function()
            local left = duration or 2.5
            while enemyRagdollTimerEnabled and overlays[plr] == entry and entry.token == token and sg.Parent and left > 0 do
                num.Text = string.format("%.1f", math.max(left, 0))
                local c = getThemeColor and getThemeColor() or accent
                num.TextColor3 = c; tag.TextColor3 = c; stroke.Color = c
                task.wait(0.1)
                left = left - 0.1
            end
            if enemyRagdollTimerEnabled and overlays[plr] == entry and entry.token == token and sg.Parent then
                num.Text = "STEAL!"
                while enemyRagdollTimerEnabled and overlays[plr] == entry and entry.token == token and sg.Parent do
                    task.wait(0.1)
                    local c2 = plr.Character
                    local h2 = c2 and c2:FindFirstChildOfClass("Humanoid")
                    if not h2 or h2.Health <= 0 or c2 ~= char then break end
                    if not isRagdolled(plr, c2, h2) then break end
                end
            end
            if overlays[plr] == entry and entry.token == token then clearOne(plr) end
        end)
    end
    local function startEnemyRagTimer()
        if scanConn then return end
        acc = 0
        scanConn = RunService.Heartbeat:Connect(function(dt)
            if not enemyRagdollTimerEnabled then return end
            acc = acc + (dt or 0)
            if acc < 0.05 then return end
            acc = 0
            local seen = {}
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP then
                    seen[plr] = true
                    local char = plr.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local st = states[plr]
                    if not st or st.character ~= char then
                        st = { character = char, ragdolled = false }
                        states[plr] = st
                        clearOne(plr)
                    end
                    if hum and hum.Health > 0 then
                        local rag = isRagdolled(plr, char, hum)
                        if rag and not st.ragdolled then
                            spawnOverlay(plr, char, 2.5)
                        end
                        st.ragdolled = rag
                    else
                        st.ragdolled = false
                        clearOne(plr)
                    end
                end
            end
            for k in pairs(states) do
                if not seen[k] then states[k] = nil; clearOne(k) end
            end
        end)
        removeConn = Players.PlayerRemoving:Connect(function(plr)
            states[plr] = nil
            clearOne(plr)
        end)
    end
    local function stopEnemyRagTimer()
        if scanConn then scanConn:Disconnect(); scanConn = nil end
        if removeConn then removeConn:Disconnect(); removeConn = nil end
        clearAll()
    end
    _G.__ExoticHubEnemyRagTimer = { start = startEnemyRagTimer, stop = stopEnemyRagTimer }
    if enemyRagdollTimerEnabled then task.defer(startEnemyRagTimer) end
end

function applyStretchFOV(val)
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = val end) end
end

function enableStretch()
    if stretchConn then return end
    stretchEnabled = true
    local cam = workspace.CurrentCamera
    if not cam then return end
    origFOV = cam.FieldOfView or 70
    applyStretchFOV(stretchFOV)
    stretchConn = RunService.RenderStepped:Connect(function()
        if not stretchEnabled then
            stretchConn:Disconnect()
            stretchConn = nil
            return
        end
        local c = workspace.CurrentCamera
        if c then c.CFrame = c.CFrame * _CFnew(0,0,0,1,0,0,0,0.7,0,0,0,1) end
    end)
    if stretchFovConn then stretchFovConn:Disconnect() end
    stretchFovConn = RunService.RenderStepped:Connect(function()
        if stretchEnabled then applyStretchFOV(stretchFOV)
        else stretchFovConn:Disconnect(); stretchFovConn = nil end
    end)
end

function disableStretch()
    stretchEnabled = false
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = origFOV or 70 end) end
end

-- =====================================================================
-- CUSTOM FOV (locks camera FOV every frame)
-- =====================================================================
setCustomFovVisual = nil
fovBox = nil
_customFovOriginal = nil

function enableCustomFOV()
    if fovEnabled then return end
    fovEnabled = true
    if customFovConn then
        pcall(function() customFovConn:Disconnect() end)
        customFovConn = nil
    end
    local cam = workspace.CurrentCamera
    if cam and _customFovOriginal == nil then
        _customFovOriginal = cam.FieldOfView
    end
    local target = _clamp(tonumber(fovValue) or 70, 30, 120)
    if cam then pcall(function() cam.FieldOfView = target end) end
    customFovConn = RunService.RenderStepped:Connect(function()
        if not fovEnabled then return end
        if stretchEnabled then return end
        local c = workspace.CurrentCamera
        local t = _clamp(tonumber(fovValue) or 70, 30, 120)
        if c and math.abs(c.FieldOfView - t) > 0.01 then
            c.FieldOfView = t
        end
    end)
end

function disableCustomFOV()
    if not fovEnabled then return end
    fovEnabled = false
    if customFovConn then
        pcall(function() customFovConn:Disconnect() end)
        customFovConn = nil
    end
    if not stretchEnabled then
        local cam = workspace.CurrentCamera
        if cam then
            pcall(function() cam.FieldOfView = _customFovOriginal or 70 end)
        end
    end
    _customFovOriginal = nil
end

function setCustomFOV(on)
    if on then enableCustomFOV() else disableCustomFOV() end
end

function setFOVValue(v)
    fovValue = _clamp(tonumber(v) or 70, 30, 120)
    if fovEnabled and not stretchEnabled then
        local cam = workspace.CurrentCamera
        if cam then pcall(function() cam.FieldOfView = fovValue end) end
    end
    return fovValue
end

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if not fovEnabled or stretchEnabled then return end
    task.defer(function()
        if fovEnabled and not stretchEnabled then
            local cam = workspace.CurrentCamera
            if cam then pcall(function() cam.FieldOfView = _clamp(tonumber(fovValue) or 70, 30, 120) end) end
        end
    end)
end)

_G.CustomFOV = {
    Enable = enableCustomFOV,
    Disable = disableCustomFOV,
    Set = setCustomFOV,
    SetValue = setFOVValue,
    IsEnabled = function() return fovEnabled end,
    GetValue = function() return fovValue end,
}

function saveLightingState()
    if _originalLighting then return end
    _originalLighting = {
        Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient, GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart,
        FogColor = Lighting.FogColor, Ambient = Lighting.Ambient,
        ColorCorrection = nil, Bloom = nil,
    }
    for _, e in ipairs(Lighting:GetChildren()) do
        if e:IsA("ColorCorrectionEffect") then
            _originalLighting.ColorCorrection = { Enabled = e.Enabled, Brightness = e.Brightness, Contrast = e.Contrast, Saturation = e.Saturation, TintColor = e.TintColor }
        elseif e:IsA("BloomEffect") then
            _originalLighting.Bloom = { Enabled = e.Enabled, Intensity = e.Intensity, Size = e.Size, Threshold = e.Threshold }
        end
    end
end

function restoreLightingState()
    if not _originalLighting then return end
    local old = _originalLighting
    Lighting.Brightness = old.Brightness
    Lighting.ClockTime = old.ClockTime
    Lighting.OutdoorAmbient = old.OutdoorAmbient
    Lighting.GlobalShadows = old.GlobalShadows
    Lighting.FogEnd = old.FogEnd
    Lighting.FogStart = old.FogStart
    Lighting.FogColor = old.FogColor
    Lighting.Ambient = old.Ambient
    if old.ColorCorrection then
        local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if cc then
            cc.Enabled = old.ColorCorrection.Enabled; cc.Brightness = old.ColorCorrection.Brightness
            cc.Contrast = old.ColorCorrection.Contrast; cc.Saturation = old.ColorCorrection.Saturation
            cc.TintColor = old.ColorCorrection.TintColor
        end
    end
    if old.Bloom then
        local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
        if bloom then
            bloom.Enabled = old.Bloom.Enabled; bloom.Intensity = old.Bloom.Intensity
            bloom.Size = old.Bloom.Size; bloom.Threshold = old.Bloom.Threshold
        end
    end
end

SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}

SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.55,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}

function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end

function _v4mpClearSky()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute("_AdaptDuelsSky") then
            pcall(function() child:Destroy() end)
        end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute("_AdaptDuelsSky") then
                pcall(function() child:Destroy() end)
            end
        end
    end
end

function applyCustomSky(mode)
    _v4mpClearSky()
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        skyTheme = "Off"
        return
    end
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    Lighting.GlobalShadows = true
    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
    if preset.sky then
        local skyInst = Instance.new("Sky")
        skyInst:SetAttribute("_AdaptDuelsSky", true)
        if preset.sky.stars then skyInst.StarCount = preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end
        skyInst.Parent = Lighting
    end
    if preset.atm then
        local atm = Instance.new("Atmosphere")
        atm:SetAttribute("_AdaptDuelsSky", true)
        atm.Density = preset.atm.dens or 0.3
        atm.Color = _vC3(preset.atm.color)
        atm.Decay = _vC3(preset.atm.decay)
        atm.Glare = preset.atm.glare or 1
        atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds")
        clouds:SetAttribute("_AdaptDuelsSky", true)
        clouds.Cover = preset.clouds.cover or 0.5
        clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _vC3(preset.clouds.color)
        clouds.Parent = terrain
    end
    skyTheme = mode
end



function set120FpsMode(on)
    fps120Mode = on and true or false
    pcall(function()
        if type(setfpscap) == "function" then
            setfpscap(fps120Mode and 120 or 0)
        end
    end)
end

function setShinyMode(on)
    shinyModeEnabled = on and true or false
    local char = LP.Character
    local function applyShiny(c)
        if not c then return end
        for _, d in ipairs(c:GetDescendants()) do
            if d:IsA("BasePart") then
                pcall(function()
                    if shinyModeEnabled then
                        d.Material = Enum.Material.Neon
                        d.Reflectance = 0.35
                    else
                        d.Reflectance = 0
                    end
                end)
            end
        end
    end
    if shinyModeEnabled then
        applyShiny(char)
        if _shinyConn then pcall(function() _shinyConn:Disconnect() end) end
        _shinyConn = LP.CharacterAdded:Connect(function(c)
            task.wait(0.5)
            if shinyModeEnabled then applyShiny(c) end
        end)
    else
        if _shinyConn then pcall(function() _shinyConn:Disconnect() end) _shinyConn = nil end
        applyShiny(char)
    end
end

function enableVividGraphics()
    if vividGraphicsEnabled and #_vividEffects > 0 then return end
    vividGraphicsEnabled = true
    for _, eff in ipairs(_vividEffects) do
        pcall(function() eff:Destroy() end)
    end
    _vividEffects = {}
    local color = Instance.new("ColorCorrectionEffect")
    color.Parent = Lighting
    color.Saturation = 0.6; color.Contrast = 0.4; color.Brightness = 0.05
    color.TintColor = Color3.fromRGB(255, 240, 220)
    table.insert(_vividEffects, color)
    local bloom = Instance.new("BloomEffect")
    bloom.Parent = Lighting
    bloom.Intensity = 0.8; bloom.Size = 24; bloom.Threshold = 1
    table.insert(_vividEffects, bloom)
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Parent = Lighting
    atmosphere.Density = 0.3; atmosphere.Offset = 0.25
    atmosphere.Color = Color3.fromRGB(199, 199, 255)
    atmosphere.Decay = Color3.fromRGB(106, 112, 125)
    atmosphere.Glare = 0.2; atmosphere.Haze = 1
    table.insert(_vividEffects, atmosphere)
    local sun = Instance.new("SunRaysEffect")
    sun.Parent = Lighting
    sun.Intensity = 0.2; sun.Spread = 0.8
    table.insert(_vividEffects, sun)
    local dof = Instance.new("DepthOfFieldEffect")
    dof.Parent = Lighting
    dof.FocusDistance = 25; dof.InFocusRadius = 10
    dof.NearIntensity = 0.2; dof.FarIntensity = 0.4
    table.insert(_vividEffects, dof)
    task.spawn(function()
        while vividGraphicsEnabled and color and color.Parent do
            color.Contrast = 0.35 + math.sin(tick() * 2) * 0.05
            task.wait(0.03)
        end
    end)
end

function disableVividGraphics()
    vividGraphicsEnabled = false
    for _, eff in ipairs(_vividEffects) do
        pcall(function() eff:Destroy() end)
    end
    _vividEffects = {}
end

function toggleVividGraphics(on)
    if on then enableVividGraphics() else disableVividGraphics() end
    saveAllSettings(true)
end

function applyHideButtons(state)
    hideButtonsEnabled = state
    if MobilePanel then
        for _, child in ipairs(MobilePanel:GetChildren()) do
            if child:IsA("TextButton") then
                child.Visible = not state
            end
        end
    end
    if tpBatFloatingButton then
        local frame = tpBatFloatingButton:FindFirstChild("Frame")
        if frame then frame.Visible = not state end
    end
    if instaResetFloatingButton then
        local frame = instaResetFloatingButton:FindFirstChild("Frame")
        if frame then frame.Visible = not state end
    end
    -- When buttons are shown, re-apply theme colors for ON states
    if not state then
        pcall(function()
            if refreshAllFloatingButtonThemes then refreshAllFloatingButtonThemes() end
        end)
    end
end

function toggleHideButtons(on)
    applyHideButtons(on)
    if setHideButtonsVisual then setHideButtonsVisual(on) end
    saveAllSettings(true)
end

function paintFloatingBtn(btnFrame, active)
    if not btnFrame then return end
    local bg = btnFrame:FindFirstChild("BtnGrad") or btnFrame:FindFirstChildOfClass("UIGradient")
    local label = btnFrame:FindFirstChild("TextLabel")
    local stroke = btnFrame:FindFirstChild("NormalStroke") or btnFrame:FindFirstChildOfClass("UIStroke")
    -- Outer ring so ON state is obvious
    local outline = btnFrame:FindFirstChild("ActiveOutline")
    if not outline then
        outline = Instance.new("UIStroke")
        outline.Name = "ActiveOutline"
        outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        outline.Parent = btnFrame
    end
    -- Theme color from current background image / color theme
    local c = (getThemeColor and getThemeColor()) or selectedColor or Color3.fromRGB(180, 180, 190)
    if active then
        -- ON: bright theme fill + clear outline ring
        btnFrame.BackgroundColor3 = c
        btnFrame.BackgroundTransparency = 0.08
        if bg and bg.Enabled ~= false then
            bg.Color = exoticHubGradient(c)
            bg.Rotation = 90
        end
        if label then
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextStrokeTransparency = 0.4
        end
        if stroke then
            stroke.Color = Color3.fromRGB(255, 255, 255)
            stroke.Thickness = 2
            stroke.Transparency = 0
        end
        outline.Enabled = true
        outline.Color = c
        outline.Thickness = 3.5
        outline.Transparency = 0
    else
        -- OFF: neutral dark, no active ring
        btnFrame.BackgroundColor3 = Color3.fromRGB(8, 10, 16)
        btnFrame.BackgroundTransparency = 0
        if bg then
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(36, 40, 52)),
                ColorSequenceKeypoint.new(0.40, Color3.fromRGB(16, 18, 26)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(6, 8, 12)),
            })
            bg.Rotation = 125
        end
        if label then
            label.TextColor3 = Color3.fromRGB(235, 235, 245)
            label.TextStrokeTransparency = 1
        end
        if stroke then
            stroke.Color = Color3.fromRGB(70, 70, 80)
            stroke.Thickness = 1
            stroke.Transparency = 0.35
        end
        outline.Enabled = false
        outline.Thickness = 0
        outline.Transparency = 1
    end
end

function refreshAllFloatingButtonThemes()
    pcall(function()
        if MobilePanel then
            for _, btn in ipairs(MobilePanel:GetChildren()) do
                if btn:IsA("TextButton") then
                    local active = btn:GetAttribute("MobActive") == true
                    paintFloatingBtn(btn, active)
                end
            end
        end
        if tpBatFloatingButton then
            local frame = tpBatFloatingButton:FindFirstChild("Frame")
            if frame then paintFloatingBtn(frame, batDesyncTpEnabled == true) end
        end
        if instaResetFloatingButton then
            local frame = instaResetFloatingButton:FindFirstChild("Frame")
            if frame then paintFloatingBtn(frame, false) end
        end
    end)
end

function applyFloatingButtonScale()
    for _, uiScale in ipairs(_floatingUIScales) do
        if uiScale and uiScale.Parent then
            uiScale.Scale = floatingButtonScale
        end
    end
end

function applyMobileButtonShape(circle)
    if circle ~= nil then
        mobileButtonCircleMode = circle and true or false
    end
    local radius = mobileButtonCircleMode and UDim.new(1, 0) or UDim.new(0, 12)
    local function shapeFrame(frame)
        if not frame then return end
        local corner = frame:FindFirstChildOfClass("UICorner")
        if not corner then
            corner = Instance.new("UICorner")
            corner.Parent = frame
        end
        corner.CornerRadius = radius
    end
    pcall(function()
        if MobilePanel then
            for _, btn in ipairs(MobilePanel:GetChildren()) do
                if btn:IsA("TextButton") then
                    shapeFrame(btn)
                end
            end
        end
        if tpBatFloatingButton then
            local frame = tpBatFloatingButton:FindFirstChild("Frame") or tpBatFloatingButton:FindFirstChildWhichIsA("TextButton") or tpBatFloatingButton:FindFirstChildWhichIsA("Frame")
            -- ScreenGui children
            for _, d in ipairs(tpBatFloatingButton:GetDescendants()) do
                if d:IsA("TextButton") or (d:IsA("Frame") and d.Name == "Frame") then
                    shapeFrame(d)
                end
            end
        end
        if instaResetFloatingButton then
            for _, d in ipairs(instaResetFloatingButton:GetDescendants()) do
                if d:IsA("TextButton") or (d:IsA("Frame") and d.Name == "Frame") then
                    shapeFrame(d)
                end
            end
        end
    end)
end

function drag(f, dragZoneHeight, ignoreLock)
    local dn, ds, sp, di = false, nil, nil, nil
    local endConn = nil
    local zone = dragZoneHeight or 99999
    local function stopDrag()
        local wasDragging = dn
        dn = false
        di = nil
        if endConn then
            endConn:Disconnect()
            endConn = nil
        end
        if wasDragging then task.defer(function() pcall(saveAllSettings) end) end
    end
    pcall(function() f.Active = true end)
    f.InputBegan:Connect(function(i)
        if not ignoreLock and uiLocked then return end
        if _isDraggingButton then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local framePos = f.AbsolutePosition
            if i.Position.Y > framePos.Y + zone then return end
            dn = true; ds = i.Position; sp = f.Position
            if endConn then endConn:Disconnect() end
            endConn = i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then stopDrag() end
            end)
        end
    end)
    f.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    f.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
    end)
    UIS.InputChanged:Connect(function(i)
        if not dn then return end
        if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
        if not ignoreLock and uiLocked then stopDrag(); return end
        if _isDraggingButton then return end
        if not ds or not sp then return end
        local nX = sp.X.Offset + (i.Position.X - ds.X)
        local nY = sp.Y.Offset + (i.Position.Y - ds.Y)
        f.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY)
    end)
end

-- =====================================================================
-- [FIX SPEED VIOLETTE] SPEED ENGINE
-- Evento: PreSimulation (pre-física)
-- SetNetworkOwner por frame con movimiento
-- Jitter aleatorio para no ser detectado por patrones
-- Acumulador de 16ms
-- =====================================================================
_G.__ExoticHubSpeedEngine = _G.__ExoticHubSpeedEngine or { started = false, conn = nil }
_G.__ExoticHubSpeedEngine.signal = nil
do
    local _ok, _sig = pcall(function() return RunService.PreSimulation end)
    _G.__ExoticHubSpeedEngine.signal = (_ok and _sig) or RunService.Heartbeat
end

function _spd_isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
end

function _spd_shouldUseStealSpeed(isStealing)
    -- Manual Carry mode always uses carry speed
    if speedMode then return true end
    -- Auto Carry only: use carry speed while stealing OR holding a brainrot
    -- (do NOT auto-switch just because Auto Steal is on)
    if autoCarryEnabled then
        if isStealing then return true end
        local ok, holding = pcall(function()
            local Safety = _G.__ExoticHubBrainrotSafety
            return Safety and Safety.isHoldingBrainrot and Safety.isHoldingBrainrot()
        end)
        if ok and holding then return true end
    end
    return false
end

function _spd_getSelectedBoostSpeed()
    -- [HARDCODED FIX] lagger carry uses LAGGER_CARRY_SPEED while walking
    if laggerCarryToggled then return LAGGER_CARRY_SPEED end
    if laggerToggled then return LAGGER_SPEED end
    return NS
end

function _spd_getSelectedStealSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED end
    if laggerToggled then return LAGGER_SPEED end
    return CS
end

function _spd_getTargetSpeed(isStealing)
    if _spd_shouldUseStealSpeed(isStealing) then return _spd_getSelectedStealSpeed() end
    return _spd_getSelectedBoostSpeed()
end

function _spd_resetMovement()
    lastMoveDir = _V3zero
    _s2VelState.v = _V3new(0, _s2VelState.v.Y or 0, 0)
end

function _spd_stop()
    if _G.__ExoticHubSpeedEngine.conn then
        _G.__ExoticHubSpeedEngine.conn:Disconnect()
        _G.__ExoticHubSpeedEngine.conn = nil
    end
    _spd_resetMovement()
end

function _spd_start()
    _spd_stop()
    _G.__ExoticHubSpeedEngine.started = true
    _G.__ExoticHubSpeedEngine.acc = 0

    _G.__ExoticHubSpeedEngine.conn = _G.__ExoticHubSpeedEngine.signal:Connect(function(dt)
        _G.__ExoticHubSpeedEngine.acc = (_G.__ExoticHubSpeedEngine.acc or 0) + (dt or 0)
        if _G.__ExoticHubSpeedEngine.acc < 0.016 then return end
        _G.__ExoticHubSpeedEngine.acc = 0

        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root or humanoid.Health <= 0 then return end
        if autoBatEnabled or batDesyncTpEnabled
           or autoLeftEnabled or autoRightEnabled
           or dropActive or _G.IsDropping then
            _spd_resetMovement()
            return
        end
        if _spd_isRagdollState(humanoid) then
            lastMoveDir = _V3zero
            return
        end
        if _s2VelState.root ~= root or not _velChecked[root] then
            lastMoveDir = _V3zero
            _setupVelChecked(character)
            _hookVelHRP(root)
        end
        local direction
        if humanoid.MoveDirection.Magnitude > 0 then
            lastMoveDir = humanoid.MoveDirection
            direction = humanoid.MoveDirection
        elseif lastMoveDir.Magnitude > 0 then
            for key in pairs(MOVE_KEYS) do
                if UIS:IsKeyDown(key) then
                    direction = lastMoveDir
                    break
                end
            end
        end
        local selectedSpeed = _spd_getTargetSpeed(LP:GetAttribute("Stealing") == true)
        _applyVelocitySpeed(direction, tonumber(selectedSpeed) or 16, root)
    end)
end

function _spd_applyNow()
    local character = LP.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 or _spd_isRagdollState(hum) then return end
    local direction = hum.MoveDirection.Magnitude > 0.05 and hum.MoveDirection or nil
    _applyVelocitySpeed(direction, _spd_getTargetSpeed(LP:GetAttribute("Stealing") == true), root)
end

function _spd_refresh()
    _spd_start()
end

_G.__ExoticHubRefreshSpeedEngine = _spd_refresh
_G.__ExoticHubStopSpeedEngine = _spd_stop
_G.__ExoticHubApplySpeedNow = _spd_applyNow

pcall(_spd_start)

LP.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    _spd_resetMovement()
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if root then _setupVelChecked(character); _hookVelHRP(root) end
    _spd_start()
end)
LP.CharacterRemoving:Connect(function()
    _spd_stop()
    _s2VelState.root = nil
end)

function setupMovementAndIndicators(char)
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end

    local ccAcc = 0
    steppedConn = RunService.Heartbeat:Connect(function(dt)
        ccAcc = ccAcc + dt
        if ccAcc < 0.05 then return end
        ccAcc = 0
        local plist = _GetPlayersCached()
        for i = 1, #plist do
            local p = plist[i]
            if p ~= LP then
                local ch = p.Character
                if ch then
                    local parts = ch:GetChildren()
                    for j = 1, #parts do
                        local part = parts[j]
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    end)

    movementLoop = RunService.RenderStepped:Connect(function()
        local char2 = LP.Character
        if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled
           and not batDesyncTpEnabled then
            if _isRagdollState(hum) then
                lastMoveDir = _V3zero
            else
                local md = hum.MoveDirection
                if md.Magnitude > 0 then
                    lastMoveDir = md
                end
            end
        end
        -- [HARDCODED FIX] speed reader + mode = theme color (same as JK HUB)
        if speedLabel and speedLabel.Parent then
            local displaySpeed = getActiveMoveSpeed()
            local tc = (getThemeColor and getThemeColor()) or Color3.fromRGB(180, 180, 190)
            speedLabel.Text = string.format("%.1f  -  %s", displaySpeed, getSpeedModeName())
            speedLabel.TextColor3 = tc
            local dl = speedLabel.Parent:FindFirstChild("DiscordText")
            if dl and dl:IsA("TextLabel") then
                dl.Text = "JK HUB"
                dl.TextColor3 = tc
            end
        end
    end)
    setupSpeedIndicator(char)
    if e01TimerEnabled then startRagTimerDetection(char) end
    startEnemySpeed()
end

function toggleLockUI(state)
    if state == nil then uiLocked = not uiLocked else uiLocked = state end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
end

function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
    if batDesyncTpEnabled then stopBatDesyncTp() end
end

function stopAllBackgroundTasks()
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    stopEnemySpeed()
    if stretchEnabled then disableStretch() end
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    if antiDieEnabled then AntiDieModule.stop() end
    if antiBatEnabled then stopAntiBat() end
    if antiFlingEnabled then stopAntiFling() end
    stopBatCounter()
    stopBatCounterV2()
    stopMedusaCounter()
    stopAutoSteal()
    disableAutoBat()
    if batDesyncTpEnabled then stopBatDesyncTp() end
    stopAutoLeft()
    stopAutoRight()
    if unwalkEnabled and not _tpBatUnwalkForced then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    if espEnabled then toggleESP(false) end
    if espLineEnabled then stopESPLine() end
    if dropActive then stopDropBrainrot() end
    if bodyLockEnabled then stopBodyLock() end
    _blSuppressCount = 0
    _blWasEnabled = false
    if _blRestoreTimer then pcall(task.cancel, _blRestoreTimer); _blRestoreTimer = nil end
    if _bodyLockConn then _bodyLockConn:Disconnect(); _bodyLockConn = nil end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    dropActive = false
    alPhase = 1
    arPhase = 1
    lastDropTime = 0
    medusaDebounce = false
    medusaLastUsed = 0
    if _G.__ExoticHubStopSpeedEngine then pcall(_G.__ExoticHubStopSpeedEngine) end
end

_exoticHubSaveState = {lastAt = 0, queued = false, writing = false, revision = 0}
function resolveExoticHubFileApi()
    local env = (getgenv and getgenv()) or _G
    local readCandidates = {readfile, syn and syn.readfile, env.readfile}
    local writeCandidates = {writefile, syn and syn.writefile, env.writefile}
    local readFn, writeFn
    for _, fn in pairs(readCandidates) do if type(fn) == "function" then readFn = fn; break end end
    for _, fn in pairs(writeCandidates) do if type(fn) == "function" then writeFn = fn; break end end
    return readFn, writeFn
end

function exoticHubFileExists(path)
    local readFn = resolveExoticHubFileApi()
    if not readFn then return false end
    local ok, data = pcall(readFn, path)
    return ok and type(data) == "string"
end

function buildConfigTable()
    local config = {
        normalSpeed = NS, carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED, laggerSpeed2 = LAGGER_CARRY_SPEED,
        stealRadius = CONFIG.STEAL_RANGE,
        antiRagdollMode = antiRagdollMode,
        selectedStealMode = selectedStealMode,
        -- explicit booleans so OFF is saved as false (not omitted)
        autoSteal = CONFIG.AUTO_STEAL_ENABLED == true,
        autoGrabPausePct = autoGrabPausePct or 85,
        autoBatEnabled = autoBatEnabled == true,
        autoLeftEnabled = autoLeftEnabled == true,
        autoRightEnabled = autoRightEnabled == true,
        medusaCounter = medusaCounterEnabled == true,
        batCounter = batCounterEnabled == true,
        batCounterV2 = batCounterV2Enabled == true,
        unwalkEnabled = unwalkEnabled == true,
        laggerToggled = laggerToggled == true,
        laggerCarryToggled = laggerCarryToggled == true,
        carryMode = speedMode == true,
        autoCarry = autoCarryEnabled == true,
        batAimbotSpeed = BAT_AIMBOT_SPEED, bypassAimbotSpeed = BYPASS_AIMBOT_SPEED, aimbotMode = aimbotMode,
        autoBatSpeed = AUTO_BAT_SPEED, autoBatVertSpeed = AUTO_BAT_VERT_SPEED,
        autoBatDist = AUTO_BAT_DIST, autoBatHeight = AUTO_BAT_HEIGHT,
        autoBatVOff = AUTO_BAT_V_OFF, autoBatTurnSpeed = AUTO_BAT_TURN_SPEED,
        autoBatMaxTurnRate = AUTO_BAT_MAX_TURN_RATE,
        autoSwing = autoSwingEnabled == true,
        ragdollSteal = ragdollStealEnabled == true,
        mirrorTp = mirrorTpEnabled == true,
        dropMode = dropMode, stretchEnabled = stretchEnabled == true, stretchFOV = stretchFOV,
        customFovEnabled = fovEnabled == true, fovValue = fovValue,
        uiScale = uiScaleValue, stealBarScale = stealBarScale, animPack = currentAnimPack,
        espEnabled = espEnabled == true,
        espLineEnabled = espLineEnabled == true,
        vividGraphics = vividGraphicsEnabled == true,
        shinyModeEnabled = shinyModeEnabled == true,
        fps120Mode = fps120Mode == true,
        baseEspEnabled = baseEspEnabled == true,
        brainrotEspEnabled = brainrotEspEnabled == true,
        esp2Enabled = esp2Enabled == true,
        rainbowAccentEnabled = rainbowAccentEnabled == true,
        bodyLockHeight = bodyLockHeight or 20,
        mobilePanelTriangleMode = mobilePanelTriangleMode == true,
        lowGraphics = lowGraphicsEnabled == true,
        hideButtons = hideButtonsEnabled == true,
        safeMode = safeModeEnabled == true,
        e01Timer = e01TimerEnabled == true,
        antiLag = antiLagEnabled == true,
        tpBatEnabled = batDesyncTpEnabled == true,
        antiDieEnabled = antiDieEnabled == true,
        antiBat = antiBatEnabled == true,
        antiFling = antiFlingEnabled == true,
        skyTheme = skyTheme, mobileButtonPositions = savedButtonPositions,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        guiHideKey = {kb = KB.GuiHide.kb and KB.GuiHide.kb.Name, gp = KB.GuiHide.gp and KB.GuiHide.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        tpBatKey = {kb = KB.TPBat.kb and KB.TPBat.kb.Name, gp = KB.TPBat.gp and KB.TPBat.gp.Name},
        instaResetKey = {kb = KB.InstaReset.kb and KB.InstaReset.kb.Name, gp = KB.InstaReset.gp and KB.InstaReset.gp.Name},
        tpBatFloatingPos = tpBatFloatingPos, instaResetFloatingPos = instaResetFloatingPos,
        bodyLockEnabled = bodyLockEnabled, bodyLockRange = bodyLockRange,
        progressBarPos = savedProgressBarPos, lockUI = uiLocked,
        spinBotEnabled = spinBotEnabled == true,
        spinBotSpeed = spinBotSpeed or 12,
        antiLoseEnabled = antiLoseEnabled == true,
        autoAfterDropBat = autoAfterDropBat == true,
        halloweenMode = halloweenMode == true,
        uiLayoutMode = uiLayoutMode or "Left",
        customFontName = customFontName or "Gotham",
        normalSpeedMode = normalSpeedMode or "v1",
        NS_V2 = NS_V2 or 72,
        infJumpMode = (InfiniteJump and InfiniteJump.mode) or "Hold",
        jumpPower = (InfiniteJump and InfiniteJump.jumpPower) or 55,
        backgroundIndex = backgroundIndex,
        backgroundImageTransparency = backgroundImageTransparency,
        backgroundMode = backgroundMode, floatingButtonScale = floatingButtonScale,
        mobileButtonCircleMode = mobileButtonCircleMode == true,
        mobileButtonsMatchBackground = mobileButtonsMatchBackground == true,
        christmasMode = christmasMode == true,
        outfitIndex = currentOutfitIndex, skinChangerEnabled = skinChangerEnabled, skinChangerMode = skinChangerMode, autoTpDownEnabled = (_G._VynxAutoTPDownEnabled == true), autoTpDownHeight = tonumber(_G._VynxAutoTPDownHeightTrigger) or 20, tpDownMode = _G._VynxTPDownMode or "full", themeColor = currentColorTheme,
    }
    if main then
        local basePos = _G.__ExoticHubMainOriginalPos or main.Position
        config.mainPosition = {
            XScale = basePos.X.Scale,
            XOffset = basePos.X.Offset,
            YScale = basePos.Y.Scale,
            YOffset = basePos.Y.Offset,
        }
    end
    if pbFrame then
        config.progressBarPos = {XScale = pbFrame.Position.X.Scale, XOffset = pbFrame.Position.X.Offset, YScale = pbFrame.Position.Y.Scale, YOffset = pbFrame.Position.Y.Offset}
    end
    if MobilePanel then
        config.mobilePanelPos = {XScale = 0, XOffset = 10, YScale = 0, YOffset = 0}
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") then
                savedButtonPositions[btn.Name] = {
                    XScale = btn.Position.X.Scale,
                    XOffset = btn.Position.X.Offset,
                    YScale = btn.Position.Y.Scale,
                    YOffset = btn.Position.Y.Offset,
                }
            end
        end
        config.mobileButtonPositions = savedButtonPositions
    end
    return config
end

function saveAllSettings(force)
    if _isResetting or _isLoading then return true end
    local config = buildConfigTable()
    config.configVersion = 2
    config.userId = LP.UserId
    local encodedOk, json = pcall(function() return HS:JSONEncode(config) end)
    if not encodedOk then return false end
    if not force and json == _lastSavedJSON then return true end
    if _exoticHubSaveState.writing or (not force and _tick() - _exoticHubSaveState.lastAt < 0.25) then
        if not _exoticHubSaveState.queued then
            _exoticHubSaveState.queued = true
            task.delay(0.25, function()
                _exoticHubSaveState.queued = false
                saveAllSettings(true)
            end)
        end
        return true
    end
    local readFn, writeFn = resolveExoticHubFileApi()
    if not readFn or not writeFn then
        warn("[Exotic Hub Save] Executor file API is unavailable.")
        return false
    end
    _exoticHubSaveState.writing = true
    _exoticHubSaveState.revision = _exoticHubSaveState.revision + 1
    config.revision = _exoticHubSaveState.revision
    config.savedAt = os.time()
    json = HS:JSONEncode(config)
    local ok = pcall(function()
        if exoticHubFileExists(CONFIG_FILE) then
            local previous = readFn(CONFIG_FILE)
            if type(previous) == "string" then writeFn(CONFIG_FILE .. ".backup", previous) end
        end
        writeFn(CONFIG_FILE, json)
        local readBack = readFn(CONFIG_FILE)
        if readBack ~= json then error("save verification failed") end
        HS:JSONDecode(readBack)
    end)
    _exoticHubSaveState.writing = false
    _exoticHubSaveState.lastAt = _tick()
    if ok then _lastSavedJSON = json else warn("[Exotic Hub Save] Write or verification failed.") end
    return ok
end

task.spawn(function()
    local readFn, writeFn = resolveExoticHubFileApi()
    if readFn and writeFn then
        local oldPath = "BloodHounds_" .. tostring(LP.UserId) .. ".json"
        local okOld, old = pcall(readFn, oldPath)
        local okNew, _ = pcall(readFn, CONFIG_FILE)
        if okOld and type(old) == "string" and not okNew then
            pcall(writeFn, CONFIG_FILE, old)
            warn("[JK HUB] Config migrada de " .. oldPath .. " a " .. CONFIG_FILE)
        end
    end
end)

function loadAllSettings()
    local readFn = resolveExoticHubFileApi()
    if not readFn or not exoticHubFileExists(CONFIG_FILE) then return false end
    local success, data = pcall(function() return HS:JSONDecode(readFn(CONFIG_FILE)) end)
    if not success or not data then return false end
    _isLoading = true
    NS = data.normalSpeed or NS
    CS = data.carrySpeed or CS
    LAGGER_SPEED = data.laggerSpeed1 or LAGGER_SPEED
    LAGGER_CARRY_SPEED = data.laggerSpeed2 or LAGGER_CARRY_SPEED
    CONFIG.STEAL_RANGE = data.stealRadius or CONFIG.STEAL_RANGE
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if tonumber(data.configVersion) >= 2 and data.lockUI ~= nil then
        uiLocked = data.lockUI
    else
        uiLocked = false
    end
    mobileButtonsLocked = false
    if data.spinBotEnabled ~= nil then spinBotEnabled = data.spinBotEnabled == true end
    if data.spinBotSpeed then spinBotSpeed = tonumber(data.spinBotSpeed) or spinBotSpeed end
    if data.antiLoseEnabled ~= nil then antiLoseEnabled = data.antiLoseEnabled == true end
    if data.autoAfterDropBat ~= nil then autoAfterDropBat = data.autoAfterDropBat == true end
    halloweenMode = false -- removed
    if data.uiLayoutMode == "Left" or data.uiLayoutMode == "Right" or data.uiLayoutMode == "Top" or data.uiLayoutMode == "Bottom" then
        uiLayoutMode = data.uiLayoutMode
    end
    if data.customFontName then customFontName = tostring(data.customFontName) end
    if data.normalSpeedMode == "v1" or data.normalSpeedMode == "v2" then normalSpeedMode = data.normalSpeedMode end
    if data.NS_V2 then NS_V2 = tonumber(data.NS_V2) or NS_V2 end
    if data.jumpPower and tonumber(data.jumpPower) then
        pcall(function() InfiniteJump.setJumpPower(tonumber(data.jumpPower)) end)
    end
    if data.antiRagdollMode then
        antiRagdollMode = data.antiRagdollMode
        if antiRagdollMode == "v1" or antiRagdollMode == "v2" then _antiRagLastOn = antiRagdollMode end
    else
        antiRagdollMode = data.antiRagdoll and "v2" or "off"
    end
    antiDieEnabled = data.antiDieEnabled or false
    antiBatEnabled = data.antiBat or false
    antiFlingEnabled = data.antiFling or false
    selectedStealMode = (data.selectedStealMode == "V2") and "V2" or "V1"
    if selectedStealMode == "V2" then
        CONFIG.STEAL_RANGE = 60
        Steal.StealRadius = 60
        if radInput then radInput.Text = "60" end
    end
    CONFIG.AUTO_STEAL_ENABLED = data.autoSteal == true
    if data.autoGrabPausePct then
        local p = tonumber(data.autoGrabPausePct)
        if p and (p == 75 or p == 80 or p == 85 or p == 90 or p == 95) then autoGrabPausePct = p end
    end
    medusaCounterEnabled = data.medusaCounter == true
    batCounterEnabled = data.batCounter == true
    batCounterV2Enabled = data.batCounterV2 == true
    unwalkEnabled = data.unwalkEnabled == true or data.unwalk == true
    antiLagEnabled = data.antiLag == true
    laggerToggled = data.laggerToggled == true
    speedMode = data.carryMode == true
    laggerCarryToggled = data.laggerCarryToggled == true
    autoCarryEnabled = data.autoCarry == true
    -- restore OFF as well as ON for aimbot / side paths
    autoBatEnabled = data.autoBatEnabled == true
    autoLeftEnabled = data.autoLeftEnabled == true
    autoRightEnabled = data.autoRightEnabled == true
    uiScaleValue = _clamp(tonumber(data.uiScale) or 78, 50, 150)
    stealBarScale = _clamp(tonumber(data.stealBarScale) or 70, 50, 200)
    if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
    if pbScale then pbScale.Scale = stealBarScale / 100 end
    espEnabled = data.espEnabled or false
    espLineEnabled = data.espLineEnabled or false
    if espEnabled then pcall(toggleESP, true) else pcall(toggleESP, false) end

    vividGraphicsEnabled = data.vividGraphics or false
    shinyModeEnabled = data.shinyModeEnabled == true
    fps120Mode = data.fps120Mode == true
    baseEspEnabled = data.baseEspEnabled == true
    brainrotEspEnabled = data.brainrotEspEnabled == true
    esp2Enabled = data.esp2Enabled == true
    if shinyModeEnabled then task.defer(function() pcall(setShinyMode, true) end) end
    if fps120Mode then task.defer(function() pcall(set120FpsMode, true) end) end
    if baseEspEnabled then task.defer(function() pcall(setBaseESP, true) end) end
    if brainrotEspEnabled then task.defer(function() pcall(setBrainrotESP, true) end) end
    if esp2Enabled then task.defer(function() pcall(setESP2, true) end) end
    rainbowAccentEnabled = data.rainbowAccentEnabled == true
    if rainbowAccentEnabled then task.defer(function() pcall(setRainbowAccent, true) end) end
    bodyLockHeight = tonumber(data.bodyLockHeight) or bodyLockHeight or 20
    mobilePanelTriangleMode = data.mobilePanelTriangleMode == true
    lowGraphicsEnabled = data.lowGraphics == true
    hideButtonsEnabled = data.hideButtons or false
    safeModeEnabled = data.safeMode == true
    e01TimerEnabled = data.e01Timer ~= false
    if not e01TimerEnabled then stopRagTimerDetection() end
    ragdollStealEnabled = data.ragdollSteal == true
    _G._AdaptRagdollStealEnabled = ragdollStealEnabled
    mirrorTpEnabled = data.mirrorTp == true
    _G._AdaptTPMirrorEnabled = mirrorTpEnabled
    if lowGraphicsEnabled then
        task.defer(function() pcall(enablePotatoGraphics) end)
    end

    currentColorTheme = COLOR_THEMES[data.themeColor] and data.themeColor or "Red"
    selectedColor = COLOR_THEMES[currentColorTheme]
    task.defer(function() updateAllUIThemeColors(selectedColor) end)
    task.defer(function() if christmasMode then applyChristmasMode(true) end end)

    local tpBatStateLoaded = data.tpBatEnabled or false
    if tpBatStateLoaded then
        task.defer(function()
            pcall(function()
                startBatDesyncTp()
                if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
                updateTpBatButtonWithAntiDie(true)
            end)
        end)
    else
        if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
        updateTpBatButtonWithAntiDie(false)
    end
    skyTheme = data.skyTheme or "Off"
    if skyTheme ~= "Off" then pcall(applyCustomSky, skyTheme) end
    if skySelectorLabel then skySelectorLabel.Text = skyTheme end
    if data.animPack and ANIM_PACKS[data.animPack] then
        pcall(startAnimPack, data.animPack)
    else
        currentAnimPack = "Off"
        stopAnimPack()
    end
    local function lk(e, d)
        if not d then return end
        if d.kb and Enum.KeyCode[d.kb] then e.kb = Enum.KeyCode[d.kb] end
        if d.gp and Enum.KeyCode[d.gp] then e.gp = Enum.KeyCode[d.gp] end
    end
    lk(KB.DropBrainrot, data.dropBrainrotKey)
    lk(KB.AutoLeft, data.autoLeftKey)
    lk(KB.AutoRight, data.autoRightKey)
    lk(KB.AutoBat, data.autoBatKey)
    lk(KB.TPFloor, data.tpFloorKey)
    lk(KB.GuiHide, data.guiHideKey)
    lk(KB.CarryToggle, data.carryToggleKey)
    lk(KB.LaggerMode, data.laggerModeKey)
    lk(KB.TPBat, data.tpBatKey)
    lk(KB.InstaReset, data.instaResetKey)
    if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    if data.mainPosition and main then
        main.Position = UDim2.new(data.mainPosition.XScale or 0, data.mainPosition.XOffset or 20, data.mainPosition.YScale or 0, data.mainPosition.YOffset or 2)
    end
    if data.tpBatFloatingPos then tpBatFloatingPos = data.tpBatFloatingPos end
    if data.instaResetFloatingPos then instaResetFloatingPos = data.instaResetFloatingPos end
    if data.progressBarPos then savedProgressBarPos = data.progressBarPos end
    if data.bodyLockEnabled ~= nil then
        bodyLockEnabled = data.bodyLockEnabled
        if bodyLockEnabled then
            task.defer(function()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                startBodyLock()
            end)
        end
    end
    if data.bodyLockRange then
        bodyLockRange = data.bodyLockRange
        if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    end
    dropMode = data.dropMode or 1
    stretchEnabled = data.stretchEnabled or false
    stretchFOV = data.stretchFOV or 120
    if data.customFovEnabled ~= nil then fovEnabled = data.customFovEnabled == true end
    if data.fovValue then fovValue = math.clamp(tonumber(data.fovValue) or 70, 30, 120) end
    BAT_AIMBOT_SPEED = data.batAimbotSpeed or BAT_AIMBOT_SPEED
    BYPASS_AIMBOT_SPEED = data.bypassAimbotSpeed or BYPASS_AIMBOT_SPEED
    if data.aimbotMode == "antiBatBypass" or data.aimbotMode == "normal" then aimbotMode = data.aimbotMode end
    AUTO_BAT_SPEED = data.autoBatSpeed or AUTO_BAT_SPEED
    AUTO_BAT_VERT_SPEED = data.autoBatVertSpeed or AUTO_BAT_VERT_SPEED
    AUTO_BAT_DIST = data.autoBatDist or AUTO_BAT_DIST
    AUTO_BAT_HEIGHT = data.autoBatHeight or AUTO_BAT_HEIGHT
    AUTO_BAT_V_OFF = data.autoBatVOff or AUTO_BAT_V_OFF
    AUTO_BAT_TURN_SPEED = data.autoBatTurnSpeed or AUTO_BAT_TURN_SPEED
    AUTO_BAT_MAX_TURN_RATE = data.autoBatMaxTurnRate or AUTO_BAT_MAX_TURN_RATE
    if data.autoSwing ~= nil then autoSwingEnabled = data.autoSwing == true end
    backgroundIndex = data.backgroundIndex or 1
    backgroundImageTransparency = data.backgroundImageTransparency or 0
    backgroundMode = data.backgroundMode == "None" and "None" or "Background 1"
    floatingButtonScale = data.floatingButtonScale or 1
    if data.mobileButtonCircleMode ~= nil then mobileButtonCircleMode = data.mobileButtonCircleMode == true end
    if data.mobileButtonsMatchBackground ~= nil then mobileButtonsMatchBackground = data.mobileButtonsMatchBackground == true end
    if data.christmasMode ~= nil then christmasMode = data.christmasMode == true end
    task.defer(function()
        if backgroundMode == "None" or backgroundIndex == 0 then
            pcall(applyBackgroundPreset, 2) -- None
        elseif backgroundPresets[backgroundIndex] then
            pcall(applyBackgroundPreset, backgroundIndex)
        else
            pcall(applyBackgroundMode, backgroundMode)
        end
    end)
    if data.outfitIndex and data.outfitIndex >= 1 and data.outfitIndex <= #OUTFITS then
        currentOutfitIndex = data.outfitIndex
        task.defer(function()
            pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            if outfitSelectorLabel then
                outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
            end
        end)
    end
    if data.skinChangerMode == "V1" or data.skinChangerMode == "V2" or data.skinChangerMode == "V3" then
        skinChangerMode = data.skinChangerMode
    end
    if data.skinChangerEnabled ~= nil then
        skinChangerEnabled = data.skinChangerEnabled == true
    end
    if _G._exoticHubStealModeSetter then
        -- Auto Steal Mode UI hidden; mode is controlled by Normal/Semi under Auto Steal
    end
    if vividGraphicsEnabled then
        task.defer(function() pcall(enableVividGraphics) end)
    else
        task.defer(function() pcall(disableVividGraphics) end)
    end
    autoBatEnabled = false
    autoLeftEnabled = false
    autoRightEnabled = false
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    refreshSpeedModeLabel()
    _lastSavedJSON = HS:JSONEncode(buildConfigTable())
    _isLoading = false
    return true
end

function forceResetUI()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if bypassSpeedBox then bypassSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    local function safeSet(fn, val) if fn then fn(val) end end
    safeSet(autoBatSetVisual, false)
    safeSet(autoLeftSetVisual, false)
    safeSet(autoRightSetVisual, false)
    safeSet(setBatCounterVisual, false)
    safeSet(setBatCounterV2Visual, false)
    safeSet(setMedusaVisual, false)
    safeSet(setUnwalkVisual, false)
    safeSet(setAntiLagVisual, false)
    safeSet(setLockUIVisual, false)
    safeSet(setInstaGrab, false)
    safeSet(batDesyncTpSetVisual, false)
    safeSet(setESPVIsual, false)
    safeSet(setESPLineVisual, false)
    safeSet(setVividVisual, false)
    safeSet(setHideButtonsVisual, true) -- Show Buttons ON after reset
    safeSet(setSafeModeVisual, false)
    safeSet(setE01TimerVisual, true)
    safeSet(bodyLockSetVisual, false)
    if uiScaleBox then uiScaleBox.Text = "78" end
    if stealBarScaleBox then stealBarScaleBox.Text = "70" end
    if mbButtonsScaleBox then mbButtonsScaleBox.Text = "100" end
    safeSet(setAntiDieVisual, false)
    safeSet(setAntiBatVisual, false)
    safeSet(setAntiFlingVisual, false)
    safeSet(setAntiRagVisual, false)
    disableVividGraphics()
    applyHideButtons(false)
    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    safeSet(mobSetAutoBat, false)
    safeSet(mobSetAutoLeft, false)
    safeSet(mobSetAutoRight, false)
    safeSet(mobSetDropBR, false)
    safeSet(mobSetTpDown, false)
    safeSet(mobSetCarry, false)
    safeSet(mobSetLagger1, false)
    safeSet(mobSetLagger2, false)
    refreshSpeedModeLabel()
    updateProgressBarVisibility()
    disableAntiLag()
    if stopAntiBat then stopAntiBat() end
    if stopAntiFling then stopAntiFling() end
    if stopESPLine then stopESPLine() end
    skyTheme = "Off"
    pcall(applyCustomSky, "Off")
    if skySelectorLabel then skySelectorLabel.Text = "Off" end
    if antiDieEnabled then
        AntiDieModule.stop()
        antiDieEnabled = false
    end
    updateTpBatButtonWithAntiDie(false)
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end
    currentColorTheme = "Gray"
    selectedColor = COLOR_THEMES["Gray"]
    updateAllUIThemeColors(selectedColor)
    if miniBtn then
        local stroke = miniBtn:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = Color3.fromRGB(42, 43, 47) end
    end
    if MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") then
                local label = btn:FindFirstChildOfClass("TextLabel")
                if label then
                    local isActive = btn.BackgroundColor3 == selectedColor
                    if not isActive then label.TextColor3 = selectedColor end
                end
            end
        end
    end
    saveAllSettings()
end

function resetFloatingPositions()
    if MobilePanel then
        savedButtonPositions = {}
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") and btn.Name then
                btn.Position = getDefaultButtonPosition(btn.Name)
            end
        end
    end
    if tpBatFloatingButton and tpBatFloatingButton:FindFirstChild("Frame") then
        local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = getDefaultButtonPosition("TpBat")
        tpBatFloatingPos = nil
    end
    if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
        instaResetFloatingButton.Frame.Position = getDefaultButtonPosition("InstaReset")
        instaResetFloatingPos = nil
    end
    if pbFrame then
        pbFrame.Position = UDim2.new(0.5, -160, 0.80, 0)
        savedProgressBarPos = nil
    end
    savedMobilePanelPos = nil
    tpBatFloatingPos = nil
end

function resetToFactoryDefaults()
    _isResetting = true
    local ok, err = pcall(function()
        stopAutoSteal()
        stopBatCounter()
        stopBatCounterV2()
        stopMedusaCounter()
        if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
        if antiDieEnabled then AntiDieModule.stop() end
        if antiBatEnabled and stopAntiBat then stopAntiBat() end
        if antiFlingEnabled and stopAntiFling then stopAntiFling() end
        stopUnwalk()
        disableAutoBat()
        if batDesyncTpEnabled then stopBatDesyncTp() end
        stopBodyLock()
        if espEnabled then toggleESP(false) end
        if espLineEnabled and stopESPLine then stopESPLine() end
        if stretchEnabled then disableStretch() end
        if antiLagEnabled then disableAntiLag() end
        if vividGraphicsEnabled then disableVividGraphics() end
        if hideButtonsEnabled then applyHideButtons(false) end
        if dropActive then stopDropBrainrot() end
        skyTheme = "Off"
        pcall(applyCustomSky, "Off")
        if skySelectorLabel then skySelectorLabel.Text = "Off" end
        if antiDieEnabled then AntiDieModule.stop(); antiDieEnabled = false end
        NS = 60; CS = 29; LAGGER_SPEED = 15; LAGGER_CARRY_SPEED = 24.5
        CONFIG.STEAL_RANGE = 61
        speedMode = false; laggerToggled = false; laggerCarryToggled = false
        antiRagdollMode = "off"; antiDieEnabled = false
        antiBatEnabled = false
        antiFlingEnabled = false
        medusaCounterEnabled = false; batCounterEnabled = false; batCounterV2Enabled = false
        autoBatEnabled = false; autoLeftEnabled = false; autoRightEnabled = false
        unwalkEnabled = false; antiLagEnabled = false
        uiLocked = false; mobileButtonsLocked = false
        CONFIG.AUTO_STEAL_ENABLED = false
        selectedStealMode = "V1"
        if _G._exoticHubStealModeSetter then pcall(_G._exoticHubStealModeSetter, "V1") end
        pcall(function() if updateAutoGrabModePill then updateAutoGrabModePill("V1") end end)
        BAT_AIMBOT_SPEED = 58
        dropMode = 1; stretchEnabled = false; stretchFOV = 120; fovEnabled = false; fovValue = 70; pcall(function() if disableCustomFOV then disableCustomFOV() end end)
        uiScaleValue = 78
        stealBarScale = 70
        if mainUIScale then mainUIScale.Scale = 1 end
        if pbScale then pbScale.Scale = 1 end
        espEnabled = false; espLineEnabled = false; vividGraphicsEnabled = false; lowGraphicsEnabled = false; hideButtonsEnabled = false
        pcall(disablePotatoGraphics)
        safeModeEnabled = false; e01TimerEnabled = true
        bodyLockEnabled = false; bodyLockRange = 20
        backgroundIndex = 1; backgroundImageTransparency = 0; backgroundMode = "Background 1"
        floatingButtonScale = 1
        mobileButtonCircleMode = false
        if batDesyncTpEnabled then stopBatDesyncTp() end
        currentAnimPack = "Off"; stopAnimPack()
        currentOutfitIndex = 1
        christmasMode = false; pcall(stopChristmasSnow); currentColorTheme = "Gray"; selectedColor = COLOR_THEMES["Gray"]
        if main then main.Position = UDim2.new(0, 20, 0, 2); _G.__ExoticHubMainOriginalPos = main.Position end
        for key, val in pairs(DEFAULT_KB) do
            if KB[key] then KB[key].kb = val.kb; KB[key].gp = val.gp end
        end
        resetFloatingPositions()
        forceResetUI()
        updateProgressBarVisibility()
        refreshSpeedModeLabel()
        _lastSavedJSON = nil
    end)
    _isResetting = false
    if not ok then warn("[resetToFactoryDefaults]", err) end
    if ok then saveAllSettings(true) end
    return ok
end

function updateProgressBarVisibility()
    local on = CONFIG.AUTO_STEAL_ENABLED == true
    if pbFrame then pbFrame.Visible = on end
    if _G.StealBar and _G.StealBar.Show then
        pcall(_G.StealBar.Show, on)
    end
end

function applyShimmerToText(obj, speed)
    -- [HARDCODED FIX] shimmer always follows theme (same as JK HUB)
    if not obj then return nil end
    speed = speed or 0.8
    local color = (getThemeColor and getThemeColor()) or Color3.fromRGB(180, 180, 190)
    local seq = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(0.3, color:Lerp(Color3.new(1,1,1), 0.55)),
        ColorSequenceKeypoint.new(0.5, color:Lerp(Color3.new(1,1,1), 0.85)),
        ColorSequenceKeypoint.new(0.7, color:Lerp(Color3.new(1,1,1), 0.55)),
        ColorSequenceKeypoint.new(1, color),
    })
    local grad = obj:FindFirstChildOfClass("UIGradient")
    if not grad then
        grad = Instance.new("UIGradient")
        grad.Name = "ExoticHubShimmer"
        grad.Parent = obj
        grad.Rotation = 45
        grad.Offset = Vector2.new(0, 0)
        task.spawn(function()
            local t = 0
            while grad and grad.Parent do
                t = t + 0.02
                grad.Offset = Vector2.new(math.sin(t * speed) * 0.4, 0)
                task.wait(0.04)
            end
        end)
    end
    grad.Color = seq
    return grad
end

-- Default mobile/floating button layout (right side, vertically centered)
-- Positions use Scale so they stay anchored on different screen sizes.
-- Mobile button positions (2-column grid, right side, vertically centered)
-- Order: drop, autoLeft, aimbot, autoRight, tpDown, carrySpeed, laggerCarry, lagger, aimbot2, reset
local DEFAULT_BUTTON_POSITIONS = (function()
    local BW, BH, GAP = 60, 60, 6
    local COLS = 2
    local names = {
        {"DropBR", "AutoLeft"},
        {"AutoBat", "AutoRight"},
        {"TpDown", "Carry"},
        {"Lagger2", "Lagger1"},
        {"TpBat", "InstaReset"},
    }
    local rows = #names
    local totalW = COLS * BW + (COLS - 1) * GAP
    local totalH = rows * BH + (rows - 1) * GAP
    local originX = -(totalW + 16) -- inset from right edge
    local originY = -math.floor(totalH / 2) -- vertically centered
    local map = {}
    for r, row in ipairs(names) do
        for c, name in ipairs(row) do
            local x = originX + (c - 1) * (BW + GAP)
            local y = originY + (r - 1) * (BH + GAP)
            map[name] = UDim2.new(1, x, 0.5, y)
        end
    end
    return map
end)()

function getDefaultButtonPosition(btnName)
    local pos = DEFAULT_BUTTON_POSITIONS[btnName]
    if pos then return pos end
    return UDim2.new(1, -152, 0.5, -59)
end

-- [FIX INSTA RESET VIOLETTE]
do
    if not _G.InstaResetLoaded then
        _G.InstaResetLoaded = true

        local state = _G._ExoticHubInstaResetState
        if type(state) ~= "table" then
            state = {
                busy = false, busyAt = 0,
                token = 0,
                cameraConn = nil, cameraHeld = false, cameraHeldAt = 0,
                speed = 1000000,
                wantAntiDie = nil,
                wantAntiBat = nil,
                wantTpBatDie = nil,
            }
            _G._ExoticHubInstaResetState = state
        end

        local HOLD_TIME   = 1.5
        local FALLBACK    = 1.2
        local WAIT_RESPAWN = 8

        local function suspendGuards()
            if _antiDieEnabled then
                state.wantAntiDie = true
                pcall(function() _antiDieSetEnabled(false) end)
            end
            if AntiDieModule and AntiDieModule.enabled then
                state.wantAntiDie = true
                pcall(function() AntiDieModule.stop() end)
            end
            if antiBatEnabled then
                state.wantAntiBat = true
                pcall(stopAntiBat)
            end
            if _G._AdaptTpBatAntiDie and _G._VynxTPBatOn then
                state.wantTpBatDie = true
                pcall(_G._AdaptTpBatAntiDie.stop)
            end
        end

        local function restoreGuards()
            if state.wantAntiDie then
                state.wantAntiDie = nil
                pcall(function()
                    antiDieEnabled = true
                    if AntiDieModule then AntiDieModule.start() end
                    if _antiDieSetEnabled then _antiDieSetEnabled(true) end
                end)
            end
            if state.wantAntiBat then
                state.wantAntiBat = nil
                pcall(function() if antiBatEnabled then startAntiBat() end end)
            end
            if state.wantTpBatDie and _G._AdaptTpBatAntiDie and _G._VynxTPBatOn then
                state.wantTpBatDie = nil
                pcall(_G._AdaptTpBatAntiDie.start)
            end
        end

        local function holdCamera(oldChar)
            local cam = workspace.CurrentCamera
            if not cam then return end
            if state.cameraHeld and (os.clock() - (state.cameraHeldAt or 0)) < 5 then return end
            state.cameraHeld = true
            state.cameraHeldAt = os.clock()
            local heldCFrame, heldFocus = cam.CFrame, cam.Focus

            pcall(function()
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = heldCFrame
                cam.Focus = heldFocus
            end)

            state.cameraConn = RunService.RenderStepped:Connect(function()
                if workspace.CurrentCamera ~= cam then return end
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = heldCFrame
                cam.Focus = heldFocus
            end)

            task.spawn(function()
                local elapsed = 0
                while LP.Character == oldChar and elapsed < 3 do
                    elapsed = elapsed + task.wait()
                end
                if state.cameraConn then
                    pcall(function() state.cameraConn:Disconnect() end)
                    state.cameraConn = nil
                end
                state.cameraHeld = false
                local newCam = workspace.CurrentCamera or cam
                if newCam then
                    pcall(function()
                        newCam.CameraType = Enum.CameraType.Custom
                        local newChar = LP.Character
                        local hum = newChar and newChar:FindFirstChildOfClass("Humanoid")
                        if hum then newCam.CameraSubject = hum end
                    end)
                end
            end)
        end

        local function flingUp(character)
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not (root and root:IsA("BasePart")) then return false end
            local hum = character:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function()
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                    hum.BreakJointsOnDeath = true
                    hum.PlatformStand = true
                    hum:ChangeState(Enum.HumanoidStateType.Freefall)
                end)
            end
            local vel = Vector3.new(0, math.clamp(state.speed, 1000, 10000000), 0)
            local function pulse()
                if not root.Parent then return false end
                return pcall(function()
                    root.AssemblyAngularVelocity = Vector3.zero
                    root.AssemblyLinearVelocity = vel
                end)
            end
            if not pulse() then return false end
            task.spawn(function()
                local elapsed = 0
                while elapsed < HOLD_TIME do
                    elapsed = elapsed + RunService.Heartbeat:Wait()
                    if not root.Parent then return end
                    if LP.Character ~= character then return end
                    pulse()
                end
            end)
            return true
        end

        local function hardKill(character)
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            pcall(function()
                hum.PlatformStand = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum.BreakJointsOnDeath = true
                if hum.MaxHealth == math.huge or hum.MaxHealth <= 0 then hum.MaxHealth = 100 end
                hum.Health = 0
            end)
            pcall(function() character:BreakJoints() end)
        end

        local function doReset()
            local character = LP.Character
            local hum = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not (character and hum and root and root:IsA("BasePart")) then
                return
            end
            if state.busy and (os.clock() - (state.busyAt or 0)) < 5 then return end

            state.busy = true
            state.busyAt = os.clock()
            state.token = (state.token or 0) + 1
            local myToken = state.token

            suspendGuards()

            task.spawn(function()
                holdCamera(character)

                if not flingUp(character) then
                    hardKill(character)
                end

                local elapsed = 0
                while LP.Character == character and elapsed < FALLBACK do
                    elapsed = elapsed + task.wait()
                end
                if LP.Character == character then
                    local hum2 = character:FindFirstChildOfClass("Humanoid")
                    if hum2 and hum2.Health > 0 then
                        hardKill(character)
                    end
                end

                local waited = 0
                while LP.Character == character and waited < WAIT_RESPAWN do
                    waited = waited + task.wait()
                end

                if state.token ~= myToken then return end
                state.busy = false
                restoreGuards()
            end)
        end

        RunService.Heartbeat:Connect(function()
            if not state.wantAntiDie then return end
            if state.busy and (os.clock() - (state.busyAt or 0)) < 10 then
                if _antiDieEnabled then pcall(function() _antiDieSetEnabled(false) end) end
                if AntiDieModule and AntiDieModule.enabled then pcall(function() AntiDieModule.stop() end) end
                return
            end
            if (os.clock() - (state.busyAt or 0)) >= 10 then
                state.busy = false
                restoreGuards()
            end
        end)

        LP.CharacterAdded:Connect(function()
            state.cameraHeld = false
            if state.cameraConn then
                pcall(function() state.cameraConn:Disconnect() end)
                state.cameraConn = nil
            end
        end)

        local _lastRequest = 0
        _G.InstaReset = {
            Trigger = function()
                local now = os.clock()
                if now - _lastRequest < 0.15 then return end
                _lastRequest = now
                doReset()
            end,
        }
        _G.VynxDoInstaReset = _G.InstaReset.Trigger
    end
end


-- Starborn custom font for EXOTIC title (certz)
_G.__ExoticHubStarbornFont = nil
do
    local function loadStarbornFont()
        if type(isfile) ~= "function" or type(writefile) ~= "function" then return nil end
        if type(getcustomasset) ~= "function" then return nil end
        local okGet, data
        if not isfile("starborn.ttf") then
            okGet, data = pcall(function()
                return game:HttpGet("https://files.catbox.moe/pwgdui.ttf")
            end)
            if not okGet or type(data) ~= "string" or #data < 1000 then return nil end
            pcall(writefile, "starborn.ttf", data)
        end
        if not isfile("starborn.json") then
            local assetId = nil
            local okAsset, asset = pcall(getcustomasset, "starborn.ttf")
            if not okAsset or not asset then return nil end
            assetId = asset
            local json = HS:JSONEncode({
                name = "Starborn",
                faces = {{
                    name = "Regular",
                    weight = 400,
                    style = "normal",
                    assetId = assetId,
                }}
            })
            pcall(writefile, "starborn.json", json)
        end
        local okFace, face = pcall(function()
            return Font.new(getcustomasset("starborn.json"))
        end)
        if okFace and face then return face end
        return nil
    end
    local ok, font = pcall(loadStarbornFont)
    if ok and font then
        _G.__ExoticHubStarbornFont = font
    end
end


-- =====================================================================
-- SYE HUB INTRO
-- =====================================================================
function playSyeHubIntro(onDone)
    -- Old intro removed; JK HUB gate at top handles intro
    if type(onDone) == "function" then task.defer(onDone) end
    do return end
    local INTRO_AUDIO_URL = "https://files.catbox.moe/sr0t7p.mp3"
    local introSound = nil
    local function stopIntroSound()
        if introSound then
            pcall(function()
                introSound:Stop()
                introSound:Destroy()
            end)
            introSound = nil
        end
    end
    local function loadIntroSound()
        local soundId = nil
        local body = nil
        pcall(function()
            local req = (syn and syn.request) or (http and http.request) or request or http_request
            if type(req) == "function" then
                local res = req({ Url = INTRO_AUDIO_URL, Method = "GET" })
                if res then
                    body = res.Body or res.body
                end
            end
        end)
        if (not body or #body < 1000) and game.HttpGet then
            pcall(function() body = game:HttpGet(INTRO_AUDIO_URL) end)
        end
        if (not body or #body < 1000) and game.HttpGetAsync then
            pcall(function() body = game:HttpGetAsync(INTRO_AUDIO_URL) end)
        end
        if body and #body > 1000 and writefile then
            local gca = getcustomasset or getsynasset
            pcall(function()
                writefile("syehub_intro.mp3", body)
                if type(gca) == "function" then
                    local id = gca("syehub_intro.mp3")
                    if type(id) == "string" and #id > 0 then soundId = id end
                end
            end)
        end
        if not soundId then soundId = INTRO_AUDIO_URL end
        local s = Instance.new("Sound")
        s.Name = "SyeHubIntroSong"
        s.SoundId = tostring(soundId)
        s.Volume = 1.05
        s.Looped = false
        s.PlaybackSpeed = 0.98 -- slight warble like radio
        s.RollOffMode = Enum.RollOffMode.InverseTapered
        s.EmitterSize = 8
        s.Parent = game:GetService("SoundService")

        -- Radio-style processing
        pcall(function()
            local eq = Instance.new("EqualizerSoundEffect")
            eq.Name = "RadioEQ"
            eq.HighGain = -18
            eq.MidGain = 4
            eq.LowGain = -12
            eq.Priority = 10
            eq.Enabled = true
            eq.Parent = s
        end)
        pcall(function()
            local dist = Instance.new("DistortionSoundEffect")
            dist.Name = "RadioDistortion"
            dist.Level = 0.18
            dist.Priority = 8
            dist.Enabled = true
            dist.Parent = s
        end)
        pcall(function()
            local trem = Instance.new("TremoloSoundEffect")
            trem.Name = "RadioTremolo"
            trem.Depth = 0.35
            trem.Duty = 0.5
            trem.Frequency = 4.5
            trem.Priority = 6
            trem.Enabled = true
            trem.Parent = s
        end)
        pcall(function()
            local pitch = Instance.new("PitchShiftSoundEffect")
            pitch.Name = "RadioPitch"
            pitch.Octave = 0.97
            pitch.Priority = 5
            pitch.Enabled = true
            pitch.Parent = s
        end)
        pcall(function()
            local chorus = Instance.new("ChorusSoundEffect")
            chorus.Name = "RadioChorus"
            chorus.Depth = 0.12
            chorus.Mix = 0.25
            chorus.Rate = 0.8
            chorus.Priority = 4
            chorus.Enabled = true
            chorus.Parent = s
        end)

        pcall(function()
            game:GetService("ContentProvider"):PreloadAsync({ s })
        end)
        local t0 = tick()
        while not s.IsLoaded and tick() - t0 < 8 do
            task.wait(0.05)
        end
        introSound = s
        return s
    end
    pcall(loadIntroSound)
    if introSound then
        pcall(function() introSound:Play() end)
        -- soft radio static bed under the track
        task.spawn(function()
            local static = Instance.new("Sound")
            static.Name = "SyeHubRadioStatic"
            static.SoundId = "rbxassetid://9113826542" -- soft noise / static-like if available
            static.Volume = 0.12
            static.Looped = true
            static.PlaybackSpeed = 1.15
            static.Parent = game:GetService("SoundService")
            pcall(function()
                local eq = Instance.new("EqualizerSoundEffect")
                eq.HighGain = 6
                eq.MidGain = -8
                eq.LowGain = -20
                eq.Parent = static
            end)
            pcall(function() static:Play() end)
            -- stop with intro sound
            local prevStop = stopIntroSound
            stopIntroSound = function()
                pcall(function()
                    static:Stop()
                    static:Destroy()
                end)
                prevStop()
            end
        end)
    end

    local introGui = Instance.new("ScreenGui")
    introGui.Name = "SyeHubIntro"
    introGui.ResetOnSpawn = false
    introGui.IgnoreGuiInset = true
    introGui.DisplayOrder = 9999
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(introGui) end end)
    local okP = pcall(function() introGui.Parent = game:GetService("CoreGui") end)
    if not okP then
        introGui.Parent = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 2)
    end

    local bg = Instance.new("Frame", introGui)
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(4, 4, 8)
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel = 0
    bg.ZIndex = 1

    -- Radio on-air badge
    local radioBadge = Instance.new("Frame", introGui)
    radioBadge.Name = "RadioBadge"
    radioBadge.AnchorPoint = Vector2.new(0.5, 0)
    radioBadge.Position = UDim2.new(0.5, 0, 0, 28)
    radioBadge.Size = UDim2.fromOffset(150, 28)
    radioBadge.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    radioBadge.BackgroundTransparency = 0.25
    radioBadge.BorderSizePixel = 0
    radioBadge.ZIndex = 20
    Instance.new("UICorner", radioBadge).CornerRadius = UDim.new(0, 8)
    local radioDot = Instance.new("Frame", radioBadge)
    radioDot.Size = UDim2.fromOffset(8, 8)
    radioDot.Position = UDim2.new(0, 12, 0.5, -4)
    radioDot.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    radioDot.BorderSizePixel = 0
    radioDot.ZIndex = 21
    Instance.new("UICorner", radioDot).CornerRadius = UDim.new(1, 0)
    local radioLbl = Instance.new("TextLabel", radioBadge)
    radioLbl.Size = UDim2.new(1, -28, 1, 0)
    radioLbl.Position = UDim2.new(0, 26, 0, 0)
    radioLbl.BackgroundTransparency = 1
    radioLbl.Text = "RADIO  ·  ON AIR"
    radioLbl.TextColor3 = Color3.fromRGB(230, 230, 240)
    radioLbl.Font = Enum.Font.GothamBold
    radioLbl.TextSize = 11
    radioLbl.TextXAlignment = Enum.TextXAlignment.Left
    radioLbl.ZIndex = 21
    task.spawn(function()
        while radioBadge and radioBadge.Parent do
            radioDot.BackgroundTransparency = 0
            task.wait(0.45)
            if not radioBadge.Parent then break end
            radioDot.BackgroundTransparency = 0.65
            task.wait(0.45)
        end
    end)

    local rainLayer = Instance.new("Frame", introGui)
    rainLayer.Name = "SpiderLayer"
    rainLayer.BackgroundTransparency = 1
    rainLayer.Size = UDim2.fromScale(1, 1)
    rainLayer.ZIndex = 2
    rainLayer.ClipsDescendants = true
    local rainRunning = true
    local theme = (getThemeColor and getThemeColor()) or Color3.fromRGB(180, 180, 190)
    -- Spiders dropping down on silk threads
    task.spawn(function()
        while rainRunning and introGui.Parent do
            local x = math.random(2, 98) / 100
            local spiderSize = math.random(18, 32)
            local fallTime = math.random(22, 40) / 10

            local holder = Instance.new("Frame")
            holder.BackgroundTransparency = 1
            holder.Size = UDim2.fromOffset(spiderSize + 4, 220)
            holder.Position = UDim2.fromScale(x, -0.15)
            holder.ZIndex = 3
            holder.Parent = rainLayer

            local thread = Instance.new("Frame", holder)
            thread.Name = "Silk"
            thread.AnchorPoint = Vector2.new(0.5, 0)
            thread.Position = UDim2.new(0.5, 0, 0, 0)
            thread.Size = UDim2.fromOffset(1, 1)
            thread.BackgroundColor3 = Color3.fromRGB(210, 210, 220)
            thread.BackgroundTransparency = 0.35
            thread.BorderSizePixel = 0
            thread.ZIndex = 3

            local spider = Instance.new("TextLabel", holder)
            spider.Name = "Spider"
            spider.AnchorPoint = Vector2.new(0.5, 0)
            spider.Position = UDim2.new(0.5, 0, 0, 0)
            spider.Size = UDim2.fromOffset(spiderSize, spiderSize)
            spider.BackgroundTransparency = 1
            spider.Text = "🕷"
            spider.TextScaled = true
            spider.ZIndex = 4
            spider.Rotation = math.random(-12, 12)

            -- grow silk as spider descends
            TS:Create(thread, TweenInfo.new(fallTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(1, 160 + math.random(0, 80))
            }):Play()
            TS:Create(spider, TweenInfo.new(fallTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0, 140 + math.random(0, 70)),
                Rotation = spider.Rotation + math.random(-25, 25)
            }):Play()
            TS:Create(holder, TweenInfo.new(fallTime + 0.8, Enum.EasingStyle.Linear), {
                Position = UDim2.fromScale(x, 1.05)
            }):Play()

            task.delay(fallTime + 1.0, function()
                if holder then pcall(function() holder:Destroy() end) end
            end)
            task.wait(math.random(12, 28) / 100)
        end
    end)

    local center = Instance.new("Frame", introGui)
    center.AnchorPoint = Vector2.new(0.5, 0.5)
    center.Position = UDim2.fromScale(0.5, 0.48)
    center.Size = UDim2.fromOffset(320, 200)
    center.BackgroundTransparency = 1
    center.ZIndex = 10

    local ring = Instance.new("Frame", center)
    ring.AnchorPoint = Vector2.new(0.5, 0.5)
    ring.Position = UDim2.fromScale(0.5, 0.32)
    ring.Size = UDim2.fromOffset(90, 90)
    ring.BackgroundTransparency = 1
    ring.ZIndex = 11
    local ringStroke = Instance.new("UIStroke", ring)
    ringStroke.Color = theme
    ringStroke.Thickness = 2.5
    ringStroke.Transparency = 1
    Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)

    local letters = {"S", "Y", "E"}
    local letterFrames = {}
    local word = Instance.new("Frame", center)
    word.AnchorPoint = Vector2.new(0.5, 0.5)
    word.Position = UDim2.fromScale(0.5, 0.32)
    word.Size = UDim2.fromOffset(210, 80)
    word.BackgroundTransparency = 1
    word.ZIndex = 12
    for i, ch in ipairs(letters) do
        local lab = Instance.new("TextLabel", word)
        lab.Size = UDim2.fromOffset(64, 80)
        lab.Position = UDim2.new(0, (i - 1) * 70, 0, 0)
        lab.BackgroundTransparency = 1
        lab.Text = ch
        lab.Font = Enum.Font.GothamBlack
        lab.TextSize = 58
        lab.TextColor3 = Color3.fromRGB(255, 255, 255)
        lab.TextTransparency = 1
        lab.Rotation = (i % 2 == 0) and 16 or -16
        lab.ZIndex = 13
        local st = Instance.new("UIStroke", lab)
        st.Thickness = 1.4
        st.Transparency = 0.35
        st.Color = theme
        letterFrames[i] = lab
    end

    local tag = Instance.new("TextLabel", center)
    tag.AnchorPoint = Vector2.new(0.5, 0)
    tag.Position = UDim2.new(0.5, 0, 0.58, 0)
    tag.Size = UDim2.new(1, 0, 0, 22)
    tag.BackgroundTransparency = 1
    tag.Text = "JK HUB"
    tag.Font = Enum.Font.GothamBold
    tag.TextSize = 14
    tag.TextColor3 = theme
    tag.TextTransparency = 1
    tag.ZIndex = 12

    local barBg = Instance.new("Frame", center)
    barBg.AnchorPoint = Vector2.new(0.5, 0)
    barBg.Position = UDim2.new(0.5, 0, 0.78, 0)
    barBg.Size = UDim2.fromOffset(160, 4)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    barBg.BackgroundTransparency = 1
    barBg.BorderSizePixel = 0
    barBg.ClipsDescendants = true
    barBg.ZIndex = 12
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)
    local barFill = Instance.new("Frame", barBg)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 13
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)
    local barGrad = Instance.new("UIGradient", barFill)
    barGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme:Lerp(Color3.new(0,0,0), 0.3)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, theme:Lerp(Color3.new(0,0,0), 0.3)),
    })

    local skipHint = Instance.new("TextLabel", introGui)
    skipHint.AnchorPoint = Vector2.new(0.5, 1)
    skipHint.Position = UDim2.new(0.5, 0, 1, -28)
    skipHint.Size = UDim2.new(0.8, 0, 0, 20)
    skipHint.BackgroundTransparency = 1
    skipHint.Text = "TAP TO SKIP"
    skipHint.Font = Enum.Font.GothamMedium
    skipHint.TextSize = 12
    skipHint.TextColor3 = Color3.fromRGB(200, 200, 210)
    skipHint.TextTransparency = 1
    skipHint.ZIndex = 20

    local skipBtn = Instance.new("TextButton", introGui)
    skipBtn.BackgroundTransparency = 1
    skipBtn.Text = ""
    skipBtn.Size = UDim2.fromScale(1, 1)
    skipBtn.ZIndex = 50
    skipBtn.AutoButtonColor = false

    local finished = false
    local function finish()
        if finished then return end
        finished = true
        rainRunning = false
        pcall(stopIntroSound)
        local ti = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TS:Create(bg, ti, { BackgroundTransparency = 1 }):Play()
        for _, lab in ipairs(letterFrames) do
            TS:Create(lab, ti, { TextTransparency = 1 }):Play()
        end
        TS:Create(tag, ti, { TextTransparency = 1 }):Play()
        TS:Create(skipHint, ti, { TextTransparency = 1 }):Play()
        TS:Create(barBg, ti, { BackgroundTransparency = 1 }):Play()
        TS:Create(ringStroke, ti, { Transparency = 1 }):Play()
        task.delay(0.4, function()
            if introGui then pcall(function() introGui:Destroy() end) end
            if onDone then pcall(onDone) end
        end)
    end
    skipBtn.Activated:Connect(finish)

    local INTRO_DURATION = 7
    local tStart = tick()
    task.spawn(function()
        TS:Create(bg, TweenInfo.new(0.35), { BackgroundTransparency = 0.12 }):Play()
        TS:Create(ringStroke, TweenInfo.new(0.4), { Transparency = 0.25 }):Play()
        for i, lab in ipairs(letterFrames) do
            task.wait(0.1)
            if finished then return end
            TS:Create(lab, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                TextTransparency = 0,
                Rotation = 0,
            }):Play()
        end
        if finished then return end
        TS:Create(tag, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()
        TS:Create(skipHint, TweenInfo.new(0.3), { TextTransparency = 0.25 }):Play()
        TS:Create(barBg, TweenInfo.new(0.25), { BackgroundTransparency = 0.35 }):Play()
        local fillTime = math.max(0.8, INTRO_DURATION - (tick() - tStart) - 0.5)
        TS:Create(barFill, TweenInfo.new(fillTime, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 1, 0)
        }):Play()
        -- pulse letters
        while not finished and (tick() - tStart) < (INTRO_DURATION - 0.4) do
            for i, lab in ipairs(letterFrames) do
                local y = ((i % 2 == 0) and -3 or 3)
                TS:Create(lab, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Position = UDim2.new(0, (i - 1) * 70, 0, y)
                }):Play()
            end
            task.wait(0.35)
            for i, lab in ipairs(letterFrames) do
                TS:Create(lab, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Position = UDim2.new(0, (i - 1) * 70, 0, 0)
                }):Play()
            end
            task.wait(0.35)
        end
        if not finished then finish() end
    end)
    task.delay(INTRO_DURATION, function()
        if not finished then finish() end
    end)
end


function buildGui()
    -- JK HUB monochrome interface
    local ROW_BG = Color3.fromRGB(6, 6, 7)
    local ROW_BORDER = Color3.fromRGB(34, 34, 40)
    local WHITE = Color3.fromRGB(255, 255, 255)
    local INP = Color3.fromRGB(18, 18, 22)
    local GUI_W, GUI_H = 430, 480

    local GUI_NAMES = {"SyeHub", "SyeHubMobilePanel", "TpBatButton", "InstaResetButton",
                       "SyeHubSpeedIndicator", "JKHubVSBootErrors", "EnvyHubVS"}

    local _okCg, _coreGui = pcall(function() return game:GetService("CoreGui") end)
    local _pgOld = LP:FindFirstChild("PlayerGui")
    for _, n in ipairs(GUI_NAMES) do
        if _okCg and _coreGui then
            local okFind, oldCg = pcall(function() return _coreGui:FindFirstChild(n) end)
            if okFind and oldCg then pcall(function() oldCg:Destroy() end) end
        end
        if _pgOld then
            local okFind2, o = pcall(function() return _pgOld:FindFirstChild(n) end)
            if okFind2 and o then pcall(function() o:Destroy() end) end
        end
    end

    gui = Instance.new("ScreenGui")
    gui.Name = "SyeHub"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 60
    gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local guiOk = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not guiOk then gui.Parent = LP:WaitForChild("PlayerGui") end

    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    main.Position = UDim2.new(0.5, -GUI_W / 2, 0.5, -GUI_H / 2)
    main.BackgroundColor3 = Color3.fromRGB(6, 6, 7)
    main.BackgroundTransparency = 0
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Active = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = Color3.fromRGB(40, 40, 47)
    mainStroke.Thickness = 1.25
    mainStroke.Transparency = 0.35

    local scriptHeader = Instance.new("Frame", main)
    scriptHeader.Name = "ScriptHeader"
    scriptHeader.Size = UDim2.new(1, -20, 0, 84)
    scriptHeader.Position = UDim2.new(0, 10, 0, 8)
    scriptHeader.BackgroundTransparency = 1
    scriptHeader.BorderSizePixel = 0
    scriptHeader.ZIndex = 8
    scriptHeader.Active = true
    Instance.new("UICorner", scriptHeader).CornerRadius = UDim.new(0, 12)

    -- Invisible drag handle covering the title area (lets you drag the GUI)
    local dragHandle = Instance.new("TextButton", main)
    dragHandle.Name = "DragHandle"
    dragHandle.Size = UDim2.new(1, -56, 0, 96)
    dragHandle.Position = UDim2.new(0, 0, 0, 0)
    dragHandle.BackgroundTransparency = 1
    dragHandle.Text = ""
    dragHandle.AutoButtonColor = false
    dragHandle.ZIndex = 50
    dragHandle.Active = true

    -- Player avatar circle in main GUI header
    local guiAvatarRing = Instance.new("Frame", scriptHeader)
    guiAvatarRing.Name = "GuiPlayerAvatarRing"
    guiAvatarRing.Size = UDim2.fromOffset(48, 48)
    guiAvatarRing.Position = UDim2.new(0, 12, 0.5, -24)
    guiAvatarRing.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    guiAvatarRing.BorderSizePixel = 0
    guiAvatarRing.ZIndex = 12
    Instance.new("UICorner", guiAvatarRing).CornerRadius = UDim.new(1, 0)
    local guiAvatarStroke = Instance.new("UIStroke", guiAvatarRing)
    guiAvatarStroke.Name = "AvatarStroke"
    guiAvatarStroke.Color = (getThemeColor and getThemeColor()) or selectedColor or Color3.fromRGB(180, 180, 190)
    guiAvatarStroke.Thickness = 2.2
    guiAvatarStroke.Transparency = 0.15
    local guiAvatarImg = Instance.new("ImageLabel", guiAvatarRing)
    guiAvatarImg.Name = "GuiPlayerAvatar"
    guiAvatarImg.Size = UDim2.new(1, -4, 1, -4)
    guiAvatarImg.Position = UDim2.new(0, 2, 0, 2)
    guiAvatarImg.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    guiAvatarImg.BackgroundTransparency = 0
    guiAvatarImg.BorderSizePixel = 0
    guiAvatarImg.ScaleType = Enum.ScaleType.Crop
    guiAvatarImg.ZIndex = 13
    Instance.new("UICorner", guiAvatarImg).CornerRadius = UDim.new(1, 0)
    pcall(function()
        local uid = LP.UserId
        if uid and uid > 0 then
            guiAvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(uid) .. "&w=150&h=150"
        else
            guiAvatarImg.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        end
    end)

    -- JK HUB title
    scriptLogo = Instance.new("TextLabel", scriptHeader)
    scriptLogo.Name = "ScriptLogo"
    scriptLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    scriptLogo.Position = UDim2.new(0.5, 12, 0.55, 6)
    scriptLogo.Size = UDim2.new(1, -70, 0, 64)
    scriptLogo.BackgroundTransparency = 1
    scriptLogo.Text = "JK HUB"
    scriptLogo.TextColor3 = Color3.fromRGB(226, 226, 232)
    scriptLogo.Font = Enum.Font.FredokaOne
    scriptLogo.TextSize = 32
    scriptLogo.TextScaled = true
    scriptLogo.TextTruncate = Enum.TextTruncate.None
    scriptLogo.TextXAlignment = Enum.TextXAlignment.Center
    scriptLogo.TextYAlignment = Enum.TextYAlignment.Center
    scriptLogo.ZIndex = 9
    local logoStroke = Instance.new("UIStroke", scriptLogo)
    logoStroke.Color = Color3.fromRGB(12, 12, 16)
    logoStroke.Thickness = 3
    logoStroke.Transparency = 0.15
    local logoStroke2 = Instance.new("UIStroke", scriptLogo)
    logoStroke2.Name = "BubbleOuter"
    logoStroke2.Color = Color3.fromRGB(180, 180, 190)
    logoStroke2.Thickness = 1.2
    logoStroke2.Transparency = 0.55

    local bgImage = Instance.new("ImageLabel", main)
    bgImage.Name = "BackgroundImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    if backgroundMode == "None" or not backgroundIndex or backgroundIndex < 1 or not backgroundImages[backgroundIndex] then
        bgImage.Image = ""
        bgImage.ImageTransparency = 1
        main.BackgroundTransparency = 0
        main.BackgroundColor3 = Color3.fromRGB(6, 6, 7)
    else
        bgImage.Image = jkHubImageUri(backgroundImages[backgroundIndex])
        bgImage.ImageTransparency = backgroundImageTransparency or 0
        main.BackgroundTransparency = 0
        main.BackgroundColor3 = Color3.fromRGB(6, 6, 7)
    end
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ImageColor3 = Color3.fromRGB(185, 185, 185)
    bgImage.ZIndex = 0
    bgImage.ClipsDescendants = true
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 14)

    mainUIScale = Instance.new("UIScale", main)
    mainUIScale.Scale = uiScaleValue / 100

    -- Lock button (left of minimize)
    local lockBtn = Instance.new("TextButton", main)
    lockBtn.Name = "LockBtn"
    lockBtn.Size = UDim2.new(0, 38, 0, 38)
    lockBtn.Position = UDim2.new(1, -92, 0, 10)
    lockBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    lockBtn.BackgroundTransparency = 0.25
    lockBtn.BorderSizePixel = 0
    lockBtn.Text = "🔓"
    lockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    lockBtn.Font = Enum.Font.GothamBold
    lockBtn.TextSize = 16
    lockBtn.AutoButtonColor = false
    lockBtn.ZIndex = 200
    Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 10)
    local lockStroke = Instance.new("UIStroke", lockBtn)
    lockStroke.Color = Color3.fromRGB(120, 120, 135)
    lockStroke.Thickness = 1.5
    lockStroke.Transparency = 0.35
    local function refreshLockBtn()
        lockBtn.Text = uiLocked and "🔒" or "🔓"
        if uiLocked then
            lockStroke.Color = getThemeColor()
            lockStroke.Transparency = 0.15
        else
            lockStroke.Color = Color3.fromRGB(120, 120, 135)
            lockStroke.Transparency = 0.35
        end
    end
    refreshLockBtn()
    lockBtn.MouseButton1Click:Connect(function()
        toggleLockUI(not uiLocked)
        refreshLockBtn()
        if setLockUIVisual then setLockUIVisual(uiLocked) end
        task.defer(function() pcall(saveAllSettings) end)
    end)
    lockBtn.MouseEnter:Connect(function()
        TS:Create(lockBtn, TweenInfo.new(0.12), {
            BackgroundTransparency = 0.1,
            BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        }):Play()
        TS:Create(lockStroke, TweenInfo.new(0.12), {Color = getThemeColor(), Transparency = 0.15}):Play()
    end)
    lockBtn.MouseLeave:Connect(function()
        refreshLockBtn()
        TS:Create(lockBtn, TweenInfo.new(0.12), {
            BackgroundTransparency = 0.25,
            BackgroundColor3 = Color3.fromRGB(28, 28, 34)
        }):Play()
    end)
    _G.__SyeLockBtnRefresh = refreshLockBtn

    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -50, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(28, 8, 12)
    closeBtn.BackgroundTransparency = 0.05
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 70, 90)
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 18
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 12)
    local closeStroke = Instance.new("UIStroke", closeBtn)
    closeStroke.Color = Color3.fromRGB(220, 40, 60)
    closeStroke.Thickness = 1.8
    closeStroke.Transparency = 0.2
    local closeGrad = Instance.new("UIGradient", closeBtn)
    closeGrad.Rotation = 90
    closeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 12, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 4, 8)),
    })

    closeBtn.MouseEnter:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundColor3 = Color3.fromRGB(180, 25, 45),
            BackgroundTransparency = 0,
        }):Play()
        TS:Create(closeStroke, TweenInfo.new(0.12), {Color = Color3.fromRGB(255, 80, 100), Transparency = 0}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {
            TextColor3 = Color3.fromRGB(255, 70, 90),
            BackgroundColor3 = Color3.fromRGB(28, 8, 12),
            BackgroundTransparency = 0.05,
        }):Play()
        TS:Create(closeStroke, TweenInfo.new(0.12), {Color = Color3.fromRGB(220, 40, 60), Transparency = 0.2}):Play()
    end)

    local minimizeBtn = Instance.new("TextButton", main)
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Size = UDim2.new(0, 36, 0, 36)
    minimizeBtn.Position = UDim2.new(1, -94, 0, 12)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    minimizeBtn.BackgroundTransparency = 0.1
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = "—"
    minimizeBtn.TextColor3 = Color3.fromRGB(230, 230, 240)
    minimizeBtn.Font = Enum.Font.GothamBlack
    minimizeBtn.TextSize = 16
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.ZIndex = 200
    Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 10)
    local minStroke = Instance.new("UIStroke", minimizeBtn)
    minStroke.Color = Color3.fromRGB(100, 100, 120)
    minStroke.Thickness = 1.2
    minStroke.Transparency = 0.35
    minimizeBtn.MouseEnter:Connect(function()
        TS:Create(minimizeBtn, TweenInfo.new(0.12), {BackgroundColor3 = getThemeColor(), TextColor3 = Color3.fromRGB(255,255,255)}):Play()
    end)
    minimizeBtn.MouseLeave:Connect(function()
        TS:Create(minimizeBtn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(18, 18, 24), TextColor3 = Color3.fromRGB(230,230,240)}):Play()
    end)
    minimizeBtn.MouseButton1Click:Connect(function()
        if hideGui then hideGui() end
    end)

    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Name = "MinimizedFrame"
    miniBtn.Size = UDim2.new(0, 170, 0, 44)
    miniBtn.Position = UDim2.new(0, 18, 0, 60)
    miniBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    miniBtn.BackgroundTransparency = 0.02
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = "JK HUB"
    miniBtn.TextColor3 = Color3.fromRGB(235, 235, 245)
    miniBtn.Font = Enum.Font.GothamBlack
    miniBtn.TextSize = 13
    miniBtn.TextTruncate = Enum.TextTruncate.AtEnd
    miniBtn.AutoButtonColor = false
    miniBtn.ZIndex = 20
    miniBtn.Visible = false
    miniBtn.Active = true
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 16)
    -- Allow dragging the minimized pill as well
    do
        local mDn, mDs, mSp, mMoved = false, nil, nil, false
        miniBtn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                mDn = true; mMoved = false; mDs = i.Position; mSp = miniBtn.Position
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if not mDn or not mDs or not mSp then return end
            if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
            local delta = i.Position - mDs
            if delta.Magnitude > 6 then mMoved = true end
            if mMoved then
                miniBtn.Position = UDim2.new(mSp.X.Scale, mSp.X.Offset + delta.X, mSp.Y.Scale, mSp.Y.Offset + delta.Y)
            end
        end)
        local function endMiniDrag(i)
            if not mDn then return end
            if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
            mDn = false
            if not mMoved then
                -- treated as click → showGui is already connected via MouseButton1Click
            end
        end
        miniBtn.InputEnded:Connect(endMiniDrag)
        UIS.InputEnded:Connect(endMiniDrag)
    end

    local _mainAnimating = false
    local mainOriginalPos = main.Position
    _G.__ExoticHubMainOriginalPos = mainOriginalPos
    main:GetPropertyChangedSignal("Position"):Connect(function()
        if not _mainAnimating then
            mainOriginalPos = main.Position
            _G.__ExoticHubMainOriginalPos = mainOriginalPos
        end
    end)

    local animScale = Instance.new("UIScale", main)
    animScale.Scale = 1
    local _openTween, _closeTween = nil, nil

    showGui = function()
        if not main then return end
        if _openTween then _openTween:Cancel() end
        if _closeTween then _closeTween:Cancel() end
        _mainAnimating = true
        main.Visible = true
        miniBtn.Visible = false
        main.Position = UDim2.new(mainOriginalPos.X.Scale, mainOriginalPos.X.Offset - 60, mainOriginalPos.Y.Scale, mainOriginalPos.Y.Offset)
        animScale.Scale = 0.5
        local info = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        _openTween = TS:Create(main, info, {Position = mainOriginalPos})
        TS:Create(animScale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        _openTween:Play()
        _openTween.Completed:Connect(function()
            _openTween = nil
            _mainAnimating = false
        end)
    end

    hideGui = function()
        if not main or not main.Visible then return end
        if _openTween then _openTween:Cancel() end
        if _closeTween then _closeTween:Cancel() end
        _mainAnimating = true
        local targetPos = UDim2.new(mainOriginalPos.X.Scale, mainOriginalPos.X.Offset - 60, mainOriginalPos.Y.Scale, mainOriginalPos.Y.Offset)
        local info = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        _closeTween = TS:Create(main, info, {Position = targetPos})
        TS:Create(animScale, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.5}):Play()
        _closeTween:Play()
        _closeTween.Completed:Connect(function()
            main.Visible = false
            miniBtn.Visible = true
            _closeTween = nil
            _mainAnimating = false
        end)
    end

    closeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)

    -- Enable dragging the main GUI (title bar / top area)
    -- ignoreLock=true so "Lock Buttons" only affects mobile buttons, not the window
    drag(main, 96, true)
    do
        local dn, ds, sp = false, nil, nil
        dragHandle.InputBegan:Connect(function(i)
            if _isDraggingButton then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dn = true
                ds = i.Position
                sp = main.Position
            end
        end)
        dragHandle.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                if dn then
                    dn = false
                    task.defer(function() pcall(saveAllSettings) end)
                end
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                if dn then
                    dn = false
                    task.defer(function() pcall(saveAllSettings) end)
                end
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if not dn or not ds or not sp then return end
            if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
            if _isDraggingButton then return end
            main.Position = UDim2.new(
                sp.X.Scale, sp.X.Offset + (i.Position.X - ds.X),
                sp.Y.Scale, sp.Y.Offset + (i.Position.Y - ds.Y)
            )
        end)
    end

    local TAB_H = 44
    tabBar = Instance.new("Frame", main)
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, -12, 0, TAB_H)
    tabBar.Position = UDim2.new(0, 6, 1, -TAB_H - 6)
    tabBar.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    tabBar.BackgroundTransparency = 0.25
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 10
    Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 12)
    local tabBarStroke = Instance.new("UIStroke", tabBar)
    tabBarStroke.Color = Color3.fromRGB(35, 35, 42)
    tabBarStroke.Thickness = 1
    tabBarStroke.Transparency = 0.4

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Padding = UDim.new(0, 6)
    local tabPad = Instance.new("UIPadding", tabBar)
    tabPad.PaddingTop = UDim.new(0, 6)
    tabPad.PaddingBottom = UDim.new(0, 6)
    tabPad.PaddingLeft = UDim.new(0, 8)
    tabPad.PaddingRight = UDim.new(0, 8)

    tabContent = Instance.new("Frame", main)
    tabContent.Name = "TabContent"
    tabContent.Size = UDim2.new(1, -12, 1, -108 - TAB_H - 8)
    tabContent.Position = UDim2.new(0, 6, 0, 96)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.ZIndex = 5

    local tabs = {"Movement", "Combat", "Keys", "Visuals", "Settings"}
    tabButtons = {}
    local contentPages = {}

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(0, 88, 1, -4)
        btn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        btn.BackgroundTransparency = 0.35
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(138, 138, 146)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.TextScaled = false
        btn.TextTruncate = Enum.TextTruncate.AtEnd
        btn.AutoButtonColor = false
        btn.ZIndex = 11
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)

        local tabBgGrad = Instance.new("UIGradient", btn)
        tabBgGrad.Name = "TabBgGrad"
        tabBgGrad.Color = exoticHubGradient(getThemeColor())
        tabBgGrad.Rotation = 0

        local tabStroke = Instance.new("UIStroke", btn)
        tabStroke.Name = "TabStroke"
        tabStroke.Color = getThemeColor()
        tabStroke.Thickness = 1.5
        tabStroke.Transparency = 1

        local underline = Instance.new("Frame", btn)
        underline.Name = "Underline"
        underline.Size = UDim2.new(0, 3, 0.5, 0)
        underline.Position = UDim2.new(1, -2, 0.5, 0)
        underline.AnchorPoint = Vector2.new(1, 0.5)
        underline.BackgroundColor3 = getThemeColor()
        underline.BorderSizePixel = 0
        underline.Visible = false
        underline.ZIndex = 12
        Instance.new("UICorner", underline).CornerRadius = UDim.new(1, 0)

        local page = Instance.new("ScrollingFrame", tabContent)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Position = UDim2.new(0, 0, 0, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ClipsDescendants = true
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = getThemeColor()
        page.ScrollBarImageTransparency = 0.3
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.ZIndex = 6
        page.Visible = (i == 1)

        local layout = Instance.new("UIListLayout", page)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 6)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local padding = Instance.new("UIPadding", page)
        padding.PaddingLeft = UDim.new(0, 6)
        padding.PaddingRight = UDim.new(0, 6)
        padding.PaddingTop = UDim.new(0, 6)
        padding.PaddingBottom = UDim.new(0, 24)

        contentPages[name] = page

        btn.MouseButton1Click:Connect(function()
            for _, pg2 in pairs(contentPages) do pg2.Visible = false end
            page.Visible = true
            for _, b in ipairs(tabButtons) do
                local ul = b:FindFirstChild("Underline")
                if ul then ul.Visible = false end
                local bs = b:FindFirstChild("TabStroke")
                TS:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Color3.fromRGB(26, 26, 34),
                    TextColor3 = Color3.fromRGB(150, 150, 165)
                }):Play()
                if bs then TS:Create(bs, TweenInfo.new(0.2), {Transparency = 1}):Play() end
            end
            local ul = btn:FindFirstChild("Underline")
            if ul then ul.Visible = true end
            local bs = btn:FindFirstChild("TabStroke")
            TS:Create(btn, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
                BackgroundTransparency = 0.15,
                BackgroundColor3 = getThemeColor(),
                TextColor3 = Color3.fromRGB(245, 245, 255)
            }):Play()
            if bs then TS:Create(bs, TweenInfo.new(0.22), {Transparency = 0.3}):Play() end
        end)

        btn.MouseEnter:Connect(function()
            if btn:FindFirstChild("Underline") and btn.Underline.Visible then return end
            TS:Create(btn, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.55,
                TextColor3 = Color3.fromRGB(215, 215, 230)
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            if btn:FindFirstChild("Underline") and btn.Underline.Visible then return end
            TS:Create(btn, TweenInfo.new(0.15), {
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(150, 150, 165)
            }):Play()
        end)

        table.insert(tabButtons, btn)
    end

    if tabButtons[1] then
        local ul = tabButtons[1]:FindFirstChild("Underline")
        if ul then ul.Visible = true end
        tabButtons[1].BackgroundColor3 = getThemeColor()
        tabButtons[1].BackgroundTransparency = 0.15
        tabButtons[1].TextColor3 = Color3.fromRGB(245, 245, 255)
        local bs = tabButtons[1]:FindFirstChild("TabStroke")
        if bs then bs.Transparency = 0.3 end
    end

    local pageCounters = {}

    local function getNextOrder(page)
        if not pageCounters[page] then pageCounters[page] = 0 end
        pageCounters[page] = pageCounters[page] + 1
        return pageCounters[page]
    end

    local function mkSect(page, txt)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 30)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7

        local accent = Instance.new("Frame", f)
        accent.Name = "SectAccent"
        accent.Size = UDim2.new(0, 3, 0, 15)
        accent.Position = UDim2.new(0, 5, 0.5, -7)
        accent.AnchorPoint = Vector2.new(0, 0.5)
        accent.BackgroundColor3 = getThemeColor()
        accent.BorderSizePixel = 0
        accent.ZIndex = 8
        Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)
        local accentGrad = Instance.new("UIGradient", accent)
        accentGrad.Color = exoticHubGradient(getThemeColor())
        accentGrad.Rotation = 90

        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -28, 1, 0)
        l.Position = UDim2.new(0, 14, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = Color3.fromRGB(235, 235, 245)
        l.Font = Enum.Font.GothamBlack
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextYAlignment = Enum.TextYAlignment.Center
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        l.TextStrokeTransparency = 0.55
        l.ZIndex = 8

        local line = Instance.new("Frame", f)
        line.Name = "SectLine"
        line.Size = UDim2.new(0, 48, 0, 1)
        line.Position = UDim2.new(1, -6, 0.5, 0)
        line.AnchorPoint = Vector2.new(1, 0.5)
        line.BackgroundColor3 = getThemeColor()
        line.BorderSizePixel = 0
        line.ZIndex = 8
        line.Visible = false -- keep layout clean, avoid overlapping section titles
        local lineGrad = Instance.new("UIGradient", line)
        lineGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 0.45),
            NumberSequenceKeypoint.new(1.00, 1.00),
        })

        return f
    end

    local function mkRow(page, h)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, -4, 0, h or 42)
        f.BackgroundColor3 = ROW_BG
        f.BackgroundTransparency = 0.7
        f.BorderSizePixel = 0
        f.ClipsDescendants = true
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 11)

        local rowGrad = Instance.new("UIGradient", f)
        rowGrad.Name = "RowGrad"
        rowGrad.Rotation = 90
        rowGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 0.00),
            NumberSequenceKeypoint.new(1.00, 0.30),
        })

        local rowStroke = Instance.new("UIStroke", f)
        rowStroke.Color = ROW_BORDER
        rowStroke.Thickness = 1
        rowStroke.Transparency = 0.55

        f.MouseEnter:Connect(function()
            TS:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(22,22,26)}):Play()
            TS:Create(rowStroke, TweenInfo.new(0.15), {Color = getThemeColor(), Transparency = 0.35}):Play()
        end)
        f.MouseLeave:Connect(function()
            TS:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = ROW_BG}):Play()
            TS:Create(rowStroke, TweenInfo.new(0.15), {Color = ROW_BORDER, Transparency = 0.55}):Play()
        end)
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        -- leave ~70px on the right for toggles / boxes so text never collides
        l.Size = UDim2.new(1, -72, 1, 0)
        l.Position = UDim2.new(0, 10, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = Color3.fromRGB(240, 240, 250)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextYAlignment = Enum.TextYAlignment.Center
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.TextWrapped = false
        l.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        l.TextStrokeTransparency = 0.5
        l.ZIndex = 8
        return l
    end

    -- Toggle switch (track + sliding thumb). Name kept as mkPill so every caller still works.
    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Name = "Track"
        pill.Size = UDim2.new(0, 38, 0, 20)
        -- Align all activation toggles to the right edge of the row
        pill.AnchorPoint = Vector2.new(1, 0.5)
        pill.Position = UDim2.new(1, -18, 0.5, 0)
        pill.BackgroundTransparency = 1
        pill.BorderSizePixel = 0
        pill.ZIndex = 8

        -- "Knob" = the colored switch body (theme code recolors this when ON)
        local dot = Instance.new("Frame", pill)
        dot.Name = "Knob"
        dot.Size = UDim2.new(1, 0, 1, 0)
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Position = UDim2.new(0.5, 0, 0.5, 0)
        dot.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
        dot.BorderSizePixel = 0
        dot.ZIndex = 9
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local dotStroke = Instance.new("UIStroke", dot)
        dotStroke.Color = Color3.fromRGB(120, 120, 140)
        dotStroke.Thickness = 1
        dotStroke.Transparency = 0.5
        dotStroke.Name = "KnobStroke"

        -- Sliding white thumb
        local thumb = Instance.new("Frame", dot)
        thumb.Name = "Thumb"
        thumb.Size = UDim2.new(0, 14, 0, 14)
        thumb.AnchorPoint = Vector2.new(0, 0.5)
        thumb.Position = UDim2.new(0, 3, 0.5, 0)
        thumb.BackgroundColor3 = WHITE
        thumb.BorderSizePixel = 0
        thumb.ZIndex = 10
        Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

        return pill, dot
    end

    local function animPill(pill, dot, on)
        local dotStroke = dot:FindFirstChild("KnobStroke")
        local fadeInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local onCol = (getThemeColor and getThemeColor()) or Color3.fromRGB(200, 35, 45)
        pcall(function()
            dot:SetAttribute("ThemeToggleOn", on == true)
        end)
        TS:Create(dot, fadeInfo, {
            BackgroundColor3 = on and onCol or Color3.fromRGB(100, 100, 120),
            BackgroundTransparency = on and 0 or 0.1,
        }):Play()
        local thumb = dot:FindFirstChild("Thumb")
        if thumb then
            TS:Create(thumb, fadeInfo, {
                Position = on
                    and UDim2.new(1, -17, 0.5, 0)
                    or UDim2.new(0, 3, 0.5, 0),
            }):Play()
        end
        if dotStroke then
            TS:Create(dotStroke, fadeInfo, {
                Color = on and onCol or Color3.fromRGB(120, 120, 140),
                Thickness = on and 2.2 or 1,
                Transparency = on and 0 or 0.5,
            }):Play()
        end
        -- Outer outline on the whole toggle track when ON
        local trackStroke = pill and pill:FindFirstChild("ToggleOutline")
        if pill and not trackStroke then
            trackStroke = Instance.new("UIStroke")
            trackStroke.Name = "ToggleOutline"
            trackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            trackStroke.Parent = pill
        end
        if trackStroke then
            trackStroke.Enabled = on and true or false
            trackStroke.Color = onCol
            trackStroke.Thickness = on and 2 or 0
            trackStroke.Transparency = on and 0.05 or 1
        end
    end

    local function mkToggle(page, txt, cb)
        local row = mkRow(page, 42)
        mkLabel(row, txt)
        local pill, dot = mkPill(row, 62)
        local on = false
        local function sv(s) on = s; animPill(pill, dot, s) end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            on = not on
            sv(on)
            pcall(cb, on)
            task.defer(function() pcall(saveAllSettings) end)
        end)
        return sv
    end

    local function mkSelector(parent, default, options, cb)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(1, -60, 0, 26)
        label.Position = UDim2.new(0, 30, 0.5, -13)
        label.BackgroundTransparency = 1
        label.Text = default
        label.TextColor3 = WHITE
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.TextTruncate = Enum.TextTruncate.AtEnd
        label.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateLabel(newText) label.Text = newText end
        leftBtn.MouseButton1Click:Connect(function()
            if cb then cb(-1, updateLabel); task.defer(function() pcall(saveAllSettings) end) end
        end)
        rightBtn.MouseButton1Click:Connect(function()
            if cb then cb(1, updateLabel); task.defer(function() pcall(saveAllSettings) end) end
        end)
        return label
    end

    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        local bw = w or 50
        local xo = math.max(xOff or 56, bw + 12)
        tb.Size = UDim2.new(0, bw, 0, 24)
        tb.Position = UDim2.new(1, -xo, 0.5, -12)
        tb.BackgroundColor3 = INP
        tb.BackgroundTransparency = 0.7
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = WHITE
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 11
        tb.TextXAlignment = Enum.TextXAlignment.Center
        tb.TextTruncate = Enum.TextTruncate.AtEnd
        tb.ClearTextOnFocus = false
        tb.ZIndex = 8
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = ROW_BORDER
        bs.Thickness = 1.2
        bs.Transparency = 0.25
        tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.12), {Color = getThemeColor(), Transparency = 0}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs, TweenInfo.new(0.12), {Color = ROW_BORDER, Transparency = 0.25}):Play()
            if cb then
                local n = tonumber(tb.Text)
                if n then cb(n) else tb.Text = tostring(default) end
                task.defer(function() saveAllSettings() end)
            end
        end)
        return tb
    end

    local function mkKeyButton(parent, kbEntry)
        local clearBtn = Instance.new("TextButton", parent)
        clearBtn.Name = "KeyClearX"
        clearBtn.Size = UDim2.new(0, 22, 0, 22)
        clearBtn.Position = UDim2.new(1, -26, 0.5, -11)
        clearBtn.BackgroundColor3 = Color3.fromRGB(40, 18, 22)
        clearBtn.BackgroundTransparency = 0.15
        clearBtn.BorderSizePixel = 0
        clearBtn.Text = "×"
        clearBtn.TextColor3 = Color3.fromRGB(255, 120, 130)
        clearBtn.Font = Enum.Font.GothamBold
        clearBtn.TextSize = 14
        clearBtn.ZIndex = 9
        clearBtn.AutoButtonColor = false
        Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 6)

        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 70, 0, 24)
        btn.Position = UDim2.new(1, -100, 0.5, -12)
        btn.BackgroundColor3 = INP
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
        btn.Text = getLabel()
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.TextTruncate = Enum.TextTruncate.AtEnd
        btn.ZIndex = 8
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = ROW_BORDER
        bs.Thickness = 1
        local li = false; local lc; local pv = btn.Text; local listenStart = 0
        btn.Activated:Connect(function()
            if li then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = _tick(); btn.Text = "..."; btn.TextColor3 = WHITE
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return end
                local isGp = isGamepadInput(inp)
                if isGp and _tick()-listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; btn.TextColor3 = WHITE
                li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end
                if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end
                task.defer(function() saveAllSettings() end)
            end)
        end)
        clearBtn.MouseButton1Click:Connect(function()
            kbEntry.kb = nil
            kbEntry.gp = nil
            btn.Text = "None"
            btn.TextColor3 = WHITE
            task.defer(function() pcall(saveAllSettings) end)
        end)
        table.insert(keyButtonRefs, {btn = btn, entry = kbEntry, clear = clearBtn})
        return btn
    end

    local function addKeybindRow(page, labelText, kbEntry)
        local row = mkRow(page, 40)
        mkLabel(row, labelText)
        mkKeyButton(row, kbEntry)
    end

    local speedPage = contentPages["Movement"]

    -- ================================================================
    -- MOVEMENT TAB
    -- ================================================================
    mkSect(speedPage, "Speed Config")
    do
        local modes = { "v1", "v2" }
        local modeIdx = (normalSpeedMode == "v2") and 2 or 1
        local row = mkRow(speedPage, 42)
        local title = Instance.new("TextLabel", row)
        title.Size = UDim2.new(0.36, 0, 1, 0)
        title.BackgroundTransparency = 1
        title.Text = "Normal Speed"
        title.TextColor3 = Color3.fromRGB(235, 235, 240)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 5
        local modeLbl = Instance.new("TextLabel", row)
        modeLbl.Size = UDim2.new(0, 28, 0, 22)
        modeLbl.Position = UDim2.new(1, -148, 0.5, -11)
        modeLbl.BackgroundTransparency = 1
        modeLbl.Text = (normalSpeedMode == "v2") and "V2" or "V1"
        modeLbl.TextColor3 = Color3.fromRGB(220, 220, 230)
        modeLbl.Font = Enum.Font.GothamBold
        modeLbl.TextSize = 11
        modeLbl.TextXAlignment = Enum.TextXAlignment.Center
        modeLbl.ZIndex = 6
        local triBtn = Instance.new("TextButton", row)
        triBtn.Size = UDim2.new(0, 24, 0, 22)
        triBtn.Position = UDim2.new(1, -116, 0.5, -11)
        triBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        triBtn.BorderSizePixel = 0
        triBtn.Text = "▼"
        triBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
        triBtn.Font = Enum.Font.GothamBold
        triBtn.TextSize = 11
        triBtn.ZIndex = 6
        Instance.new("UICorner", triBtn).CornerRadius = UDim.new(0, 6)
        triBtn.MouseButton1Click:Connect(function()
            modeIdx = modeIdx % #modes + 1
            normalSpeedMode = modes[modeIdx]
            modeLbl.Text = (normalSpeedMode == "v2") and "V2" or "V1"
            if _G.__ExoticHubApplySpeedNow then pcall(_G.__ExoticHubApplySpeedNow) end
            task.defer(function() pcall(saveAllSettings) end)
        end)
        normalBox = mkBox(row, (normalSpeedMode == "v2") and (NS_V2 or 72) or NS, 50, 88, function(v)
            if v and v > 0 and v <= 500 then
                if normalSpeedMode == "v2" then NS_V2 = v else NS = v end
                if _G.__ExoticHubApplySpeedNow then pcall(_G.__ExoticHubApplySpeedNow) end
                task.defer(function() pcall(saveAllSettings) end)
            end
        end)
        _G.__SyeNormalSpeedModeLabel = modeLbl
        _G.__SyeNormalSpeedBox = normalBox
    end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 50, 56, function(v) if v > 0 and v <= 500 then CS = v; if _G.__ExoticHubApplySpeedNow then pcall(_G.__ExoticHubApplySpeedNow) end end end) end

    mkSect(speedPage, "Lagger Config")
    do local row = mkRow(speedPage, 42); mkLabel(row, "Lagger Normal"); laggerBox = mkBox(row, LAGGER_SPEED, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_SPEED = v; if _G.__ExoticHubApplySpeedNow then pcall(_G.__ExoticHubApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Lagger Carry"); lagger2Box = mkBox(row, LAGGER_CARRY_SPEED, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_CARRY_SPEED = v; if _G.__ExoticHubApplySpeedNow then pcall(_G.__ExoticHubApplySpeedNow) end end end) end
    setAutoCarryVisual = mkToggle(speedPage, "Auto Carry", function(on)
        -- Auto Carry only controls automatic carry-speed while stealing/holding.
        -- It must NOT force Carry mode (speedMode) on or off.
        autoCarryEnabled = on and true or false
        refreshSpeedModeLabel()
        if _G.__ExoticHubApplySpeedNow then pcall(_G.__ExoticHubApplySpeedNow) end
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setAutoCarryVisual then setAutoCarryVisual(autoCarryEnabled == true) end

    mkSect(speedPage, "TP Down")
    setAutoTpDownVisual = mkToggle(speedPage, "Auto TP Down", function(on)
        _G._VynxAutoTPDownEnabled = on and true or false
        if not on then
            autoTPDownElapsed = 0
            autoTPDownTriggered = false
            autoTPDownRoot = nil
        end
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setAutoTpDownVisual then setAutoTpDownVisual(_G._VynxAutoTPDownEnabled == true) end
    do
        local row = mkRow(speedPage, 42)
        mkLabel(row, "Auto TP Height")
        autoTpHeightBox = mkBox(row, tonumber(_G._VynxAutoTPDownHeightTrigger) or 20, 50, 56, function(v)
            if v and v >= 1 and v <= 1000 then
                _G._VynxAutoTPDownHeightTrigger = _floor(v + 0.5)
            end
        end)
    end

    mkSect(speedPage, "Jump")
    do
        -- Infinite Jump toggle + triangle mode (Hold / Manual)
        local modes = { "Hold", "Manual" }
        local modeIdx = 1
        for i, m in ipairs(modes) do
            if m == (InfiniteJump.mode or "Hold") then
                modeIdx = i
                break
            end
        end
        local row = mkRow(speedPage, 42)
        local title = Instance.new("TextLabel", row)
        title.Size = UDim2.new(0.42, 0, 1, 0)
        title.BackgroundTransparency = 1
        title.Text = "Infinite Jump"
        title.TextColor3 = Color3.fromRGB(235, 235, 240)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 5

        local modeLbl = Instance.new("TextLabel", row)
        modeLbl.Size = UDim2.new(0, 58, 0, 22)
        modeLbl.Position = UDim2.new(1, -148, 0.5, -11)
        modeLbl.BackgroundTransparency = 1
        modeLbl.Text = modes[modeIdx]
        modeLbl.TextColor3 = Color3.fromRGB(220, 220, 230)
        modeLbl.Font = Enum.Font.GothamBold
        modeLbl.TextSize = 11
        modeLbl.TextXAlignment = Enum.TextXAlignment.Center
        modeLbl.ZIndex = 6

        local triBtn = Instance.new("TextButton", row)
        triBtn.Size = UDim2.new(0, 26, 0, 22)
        triBtn.Position = UDim2.new(1, -86, 0.5, -11)
        triBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        triBtn.BorderSizePixel = 0
        triBtn.Text = "▼"
        triBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
        triBtn.Font = Enum.Font.GothamBold
        triBtn.TextSize = 11
        triBtn.ZIndex = 6
        Instance.new("UICorner", triBtn).CornerRadius = UDim.new(0, 6)
        triBtn.MouseButton1Click:Connect(function()
            modeIdx = modeIdx % #modes + 1
            InfiniteJump.mode = modes[modeIdx]
            modeLbl.Text = modes[modeIdx]
            task.defer(function() pcall(saveAllSettings) end)
        end)

        local pill = Instance.new("TextButton", row)
        pill.Size = UDim2.new(0, 48, 0, 24)
        pill.Position = UDim2.new(1, -52, 0.5, -12)
        pill.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
        pill.BorderSizePixel = 0
        pill.Text = ""
        pill.ZIndex = 6
        pill.AutoButtonColor = false
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local knob = Instance.new("Frame", pill)
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = UDim2.new(0, 3, 0.5, -9)
        knob.BackgroundColor3 = Color3.fromRGB(160, 160, 170)
        knob.BorderSizePixel = 0
        knob.ZIndex = 7
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local function setVis(on)
            on = on == true
            TS:Create(knob, TweenInfo.new(0.12), {
                Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = on and getThemeColor() or Color3.fromRGB(160, 160, 170),
            }):Play()
            TS:Create(pill, TweenInfo.new(0.12), {
                BackgroundColor3 = on and Color3.fromRGB(40, 40, 50) or Color3.fromRGB(30, 30, 36),
            }):Play()
        end
        setInfiniteJumpVisual = setVis
        local state = InfiniteJump and InfiniteJump.enabled == true
        setVis(state)
        pill.MouseButton1Click:Connect(function()
            state = not state
            jumpEnabled = state
            if state then
                pcall(function() InfiniteJump.start() end)
            else
                pcall(function() InfiniteJump.stop() end)
            end
            setVis(state)
            task.defer(function() pcall(saveAllSettings) end)
        end)
        _G.__SyeInfJumpModeLabel = modeLbl
    end
    do
        local row = mkRow(speedPage, 42)
        mkLabel(row, "Jump Power")
        jumpPowerBox = mkBox(row, (InfiniteJump and InfiniteJump.jumpPower) or 55, 50, 56, function(v)
            if v and v >= 10 and v <= 200 then
                pcall(function() InfiniteJump.setJumpPower(v) end)
                task.defer(function() pcall(saveAllSettings) end)
            end
        end)
        _G.__SyeJumpPowerBox = jumpPowerBox
    end
    do
        local modes = { "v1", "v2" }
        local labels = { v1 = "V1", v2 = "V2" }
        local modeIdx = 2
        local cur = _antiRagLastOn or "v2"
        if antiRagdollMode == "v1" or antiRagdollMode == "v2" then cur = antiRagdollMode end
        for i, m in ipairs(modes) do
            if m == cur then
                modeIdx = i
                break
            end
        end
        local row = mkRow(speedPage, 42)
        local title = Instance.new("TextLabel", row)
        title.Size = UDim2.new(0.42, 0, 1, 0)
        title.BackgroundTransparency = 1
        title.Text = "Anti Ragdoll"
        title.TextColor3 = Color3.fromRGB(235, 235, 240)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 5

        local modeLbl = Instance.new("TextLabel", row)
        modeLbl.Size = UDim2.new(0, 40, 0, 22)
        modeLbl.Position = UDim2.new(1, -148, 0.5, -11)
        modeLbl.BackgroundTransparency = 1
        modeLbl.Text = labels[modes[modeIdx]] or "V2"
        modeLbl.TextColor3 = Color3.fromRGB(220, 220, 230)
        modeLbl.Font = Enum.Font.GothamBold
        modeLbl.TextSize = 11
        modeLbl.TextXAlignment = Enum.TextXAlignment.Center
        modeLbl.ZIndex = 6

        local triBtn = Instance.new("TextButton", row)
        triBtn.Size = UDim2.new(0, 26, 0, 22)
        triBtn.Position = UDim2.new(1, -86, 0.5, -11)
        triBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        triBtn.BorderSizePixel = 0
        triBtn.Text = "▼"
        triBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
        triBtn.Font = Enum.Font.GothamBold
        triBtn.TextSize = 11
        triBtn.ZIndex = 6
        Instance.new("UICorner", triBtn).CornerRadius = UDim.new(0, 6)
        triBtn.MouseButton1Click:Connect(function()
            modeIdx = modeIdx % #modes + 1
            local key = modes[modeIdx]
            _antiRagLastOn = key
            modeLbl.Text = labels[key] or key
            if antiRagdollMode == "v1" or antiRagdollMode == "v2" then
                setAntiRagdollMode(key)
            else
                task.defer(function() pcall(saveAllSettings) end)
            end
        end)

        local pill = Instance.new("TextButton", row)
        pill.Size = UDim2.new(0, 48, 0, 24)
        pill.Position = UDim2.new(1, -52, 0.5, -12)
        pill.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
        pill.BorderSizePixel = 0
        pill.Text = ""
        pill.ZIndex = 6
        pill.AutoButtonColor = false
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local knob = Instance.new("Frame", pill)
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = UDim2.new(0, 3, 0.5, -9)
        knob.BackgroundColor3 = Color3.fromRGB(160, 160, 170)
        knob.BorderSizePixel = 0
        knob.ZIndex = 7
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local function setVis(on)
            on = on == true
            TS:Create(knob, TweenInfo.new(0.12), {
                Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = on and getThemeColor() or Color3.fromRGB(160, 160, 170),
            }):Play()
            TS:Create(pill, TweenInfo.new(0.12), {
                BackgroundColor3 = on and Color3.fromRGB(40, 40, 50) or Color3.fromRGB(30, 30, 36),
            }):Play()
        end
        setAntiRagVisual = setVis
        local onNow = antiRagdollMode == "v1" or antiRagdollMode == "v2"
        setVis(onNow)
        pill.MouseButton1Click:Connect(function()
            local currentlyOn = antiRagdollMode == "v1" or antiRagdollMode == "v2"
            if currentlyOn then
                setAntiRagdollMode("off")
                setVis(false)
            else
                setAntiRagdollMode(_antiRagLastOn or modes[modeIdx] or "v2")
                setVis(true)
            end
        end)
        _G.__SyeAntiRagModeLabel = modeLbl
    end

    mkSect(speedPage, "Body Lock")
    bodyLockSetVisual = mkToggle(speedPage, "Body Lock", function(on)
        bodyLockEnabled = on
        if bodyLockRangeRow then bodyLockRangeRow.Visible = on end
        if on then
            if _blSuppressCount == 0 then startBodyLock() end
        else
            stopBodyLock()
        end
        task.defer(function() pcall(saveAllSettings) end)
    end)
    do
        local row = mkRow(speedPage, 42)
        bodyLockRangeRow = row
        row.Visible = bodyLockEnabled == true
        mkLabel(row, "Body Lock Radius")
        bodyLockRangeBox = mkBox(row, bodyLockRange, 50, 56, function(v)
            if v and v > 0 then
                bodyLockRange = _clamp(_floor(v), 5, 200)
                if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
                task.defer(function() pcall(saveAllSettings) end)
            end
        end)
    end

    -- ================================================================
    -- COMBAT TAB
    -- ================================================================
    
    do
        local row = mkRow(speedPage, 42)
        mkLabel(row, "Body Lock Height")
        bodyLockHeightBox = mkBox(row, bodyLockHeight or 20, 50, 56, function(v)
            if v and v >= 0 then
                bodyLockHeight = math.clamp(math.floor(v), 0, 100)
                if bodyLockHeightBox then bodyLockHeightBox.Text = tostring(bodyLockHeight) end
                task.defer(function() pcall(saveAllSettings) end)
            end
        end)
    end
local combatPage = contentPages["Combat"]

    mkSect(combatPage, "Steal Config")
    do
        local row = mkRow(combatPage, 42)
        mkLabel(row, "Auto Grab Pause")
        local opts = AUTO_GRAB_PAUSE_OPTIONS or {75, 80, 85, 90, 95}
        local cur = tonumber(autoGrabPausePct) or 85
        local label = Instance.new("TextLabel", row)
        label.Size = UDim2.new(0, 48, 0, 26)
        label.Position = UDim2.new(1, -100, 0.5, -13)
        label.BackgroundTransparency = 1
        label.Text = tostring(cur) .. "%"
        label.TextColor3 = Color3.fromRGB(235, 235, 240)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.ZIndex = 9
        autoGrabPauseSelectorLabel = label
        local left = Instance.new("TextButton", row)
        left.Size = UDim2.new(0, 26, 0, 26)
        left.Position = UDim2.new(1, -130, 0.5, -13)
        left.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        left.Text = "<"
        left.TextColor3 = Color3.fromRGB(255,255,255)
        left.Font = Enum.Font.GothamBold
        left.ZIndex = 10
        Instance.new("UICorner", left).CornerRadius = UDim.new(0, 6)
        local right = Instance.new("TextButton", row)
        right.Size = UDim2.new(0, 26, 0, 26)
        right.Position = UDim2.new(1, -46, 0.5, -13)
        right.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        right.Text = ">"
        right.TextColor3 = Color3.fromRGB(255,255,255)
        right.Font = Enum.Font.GothamBold
        right.ZIndex = 10
        Instance.new("UICorner", right).CornerRadius = UDim.new(0, 6)
        left.MouseButton1Click:Connect(function()
            cycleAutoGrabPause(-1)
            task.defer(function() pcall(saveAllSettings) end)
        end)
        right.MouseButton1Click:Connect(function()
            cycleAutoGrabPause(1)
            task.defer(function() pcall(saveAllSettings) end)
        end)
    end

    do
        local row = mkRow(combatPage, 42)
        mkLabel(row, "Radius")
        radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 56, function(v)
            if v and v >= 5 and v <= 300 then
                CONFIG.STEAL_RANGE = _floor(v + 0.5)
                Steal.StealRadius = CONFIG.STEAL_RANGE
                if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
                saveAllSettings()
            end
        end)
    end
    setRagdollStealVisual = mkToggle(combatPage, "Ragdoll Steal", function(on)
        ragdollStealEnabled = on and true or false
        _G._AdaptRagdollStealEnabled = ragdollStealEnabled
        local st = _G._AdaptNormalStealRagdollState
        if st and st.SetEnabled then pcall(st.SetEnabled, ragdollStealEnabled) end
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setRagdollStealVisual then setRagdollStealVisual(ragdollStealEnabled == true) end
    do
        local row = mkRow(combatPage, 42)
        mkLabel(row, "Auto Steal")

        local expandBtn = Instance.new("TextButton", row)
        expandBtn.Name = "ExpandTriangle"
        expandBtn.Size = UDim2.new(0, 22, 0, 22)
        expandBtn.Position = UDim2.new(1, -88, 0.5, -11)
        expandBtn.BackgroundTransparency = 1
        expandBtn.BorderSizePixel = 0
        expandBtn.Text = "▶"
        expandBtn.TextColor3 = Color3.fromRGB(180, 180, 195)
        expandBtn.Font = Enum.Font.GothamBold
        expandBtn.TextSize = 12
        expandBtn.AutoButtonColor = false
        expandBtn.ZIndex = 10

        local pill, dot = mkPill(row, 62)
        local on = false
        local function sv(s)
            on = s
            animPill(pill, dot, s)
        end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            on = not on
            sv(on)
            CONFIG.AUTO_STEAL_ENABLED = on
            if on then pcall(startAutoSteal) else stopAutoSteal() end
            updateProgressBarVisibility()
            task.defer(function() pcall(saveAllSettings) end)
        end)
        setInstaGrab = sv
        if CONFIG.AUTO_STEAL_ENABLED then sv(true) end

        -- Expanded row: Normal | Semi split
        local modeRow = mkRow(combatPage, 42)
        modeRow.Name = "AutoStealModeRow"
        modeRow.Visible = false

        local holder = Instance.new("Frame", modeRow)
        holder.Name = "StealModeSplit"
        holder.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        holder.BackgroundTransparency = 0.15
        holder.Size = UDim2.new(1, -24, 0, 30)
        holder.Position = UDim2.new(0, 12, 0.5, -15)
        holder.BorderSizePixel = 0
        holder.ClipsDescendants = true
        holder.ZIndex = 8
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 15)
        local holderStroke = Instance.new("UIStroke", holder)
        holderStroke.Color = Color3.fromRGB(60, 60, 70)
        holderStroke.Thickness = 1
        holderStroke.Transparency = 0.35

        local slide = Instance.new("Frame", holder)
        slide.Name = "SelectedSlide"
        slide.BackgroundColor3 = getThemeColor()
        slide.BackgroundTransparency = 0.15
        slide.Size = UDim2.new(0.5, -3, 1, -4)
        slide.Position = UDim2.new(0, 2, 0, 2)
        slide.BorderSizePixel = 0
        slide.ZIndex = 9
        Instance.new("UICorner", slide).CornerRadius = UDim.new(0, 13)
        local slideGrad = Instance.new("UIGradient", slide)
        slideGrad.Color = exoticHubGradient(getThemeColor())
        local slideStroke = Instance.new("UIStroke", slide)
        slideStroke.Color = getThemeColor()
        slideStroke.Thickness = 1.2
        slideStroke.Transparency = 0.1

        local leftText = Instance.new("TextLabel", holder)
        leftText.BackgroundTransparency = 1
        leftText.Text = "Normal"
        leftText.TextColor3 = Color3.fromRGB(255, 255, 255)
        leftText.Font = Enum.Font.GothamBlack
        leftText.TextSize = 12
        leftText.Size = UDim2.new(0.5, 0, 1, 0)
        leftText.Position = UDim2.new(0, 0, 0, 0)
        leftText.ZIndex = 10

        local rightText = Instance.new("TextLabel", holder)
        rightText.BackgroundTransparency = 1
        rightText.Text = "Semi"
        rightText.TextColor3 = Color3.fromRGB(150, 150, 165)
        rightText.Font = Enum.Font.GothamBlack
        rightText.TextSize = 12
        rightText.Size = UDim2.new(0.5, 0, 1, 0)
        rightText.Position = UDim2.new(0.5, 0, 0, 0)
        rightText.ZIndex = 10

        local leftClick = Instance.new("TextButton", holder)
        leftClick.BackgroundTransparency = 1
        leftClick.Text = ""
        leftClick.AutoButtonColor = false
        leftClick.Size = UDim2.new(0.5, 0, 1, 0)
        leftClick.Position = UDim2.new(0, 0, 0, 0)
        leftClick.ZIndex = 11

        local rightClick = Instance.new("TextButton", holder)
        rightClick.BackgroundTransparency = 1
        rightClick.Text = ""
        rightClick.AutoButtonColor = false
        rightClick.Size = UDim2.new(0.5, 0, 1, 0)
        rightClick.Position = UDim2.new(0.5, 0, 0, 0)
        rightClick.ZIndex = 11

        local function setStealSemiVisual(semi)
            local onSemi = semi and true or false
            -- Normal = Auto Steal V1, Semi = Auto Steal V2
            selectedStealMode = onSemi and "V2" or "V1"
            autoStealVariant = onSemi and 2 or 1 -- Semi uses 0.8x duration, Normal uses 0.73x
            autoGrabStopEnabled = true -- always use phased hold from new Normal logic
            if onSemi then
                -- V2 uses a tighter default radius like the old mode switcher
                if (tonumber(CONFIG.STEAL_RANGE) or 0) < 10 then
                    CONFIG.STEAL_RANGE = 60
                    Steal.StealRadius = 60
                    if radInput then radInput.Text = "60" end
                end
            end
            TS:Create(slide, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = onSemi and UDim2.new(0.5, 1, 0, 2) or UDim2.new(0, 2, 0, 2)
            }):Play()
            TS:Create(leftText, TweenInfo.new(0.18), {
                TextColor3 = onSemi and Color3.fromRGB(150, 150, 165) or Color3.fromRGB(255, 255, 255)
            }):Play()
            TS:Create(rightText, TweenInfo.new(0.18), {
                TextColor3 = onSemi and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 165)
            }):Play()
            -- Keep Auto Grab bar pill in sync (NORM / SEMI)
            pcall(function()
                if updateAutoGrabModePill then updateAutoGrabModePill(selectedStealMode) end
            end)
            if CONFIG.AUTO_STEAL_ENABLED then
                pcall(startAutoSteal)
            end
        end

        leftClick.MouseButton1Click:Connect(function()
            setStealSemiVisual(false)
            task.defer(function() pcall(saveAllSettings) end)
        end)
        rightClick.MouseButton1Click:Connect(function()
            setStealSemiVisual(true)
            task.defer(function() pcall(saveAllSettings) end)
        end)

        setStealSemiVisual(selectedStealMode == "V2" or selectedStealMode == "Semi")
        -- Expose for load/save restore (position of Normal/Semi slider)
        _G._exoticHubStealModeSetter = function(semi)
            setStealSemiVisual(semi == true or semi == "V2" or semi == "Semi")
        end

        local expanded = true
        modeRow.Visible = true
        if expandBtn then
            expandBtn.Text = "▼"
            expandBtn.TextColor3 = getThemeColor and getThemeColor() or Color3.fromRGB(180, 180, 190)
        end
        expandBtn.MouseButton1Click:Connect(function()
            expanded = not expanded
            modeRow.Visible = expanded
            expandBtn.Text = expanded and "▼" or "▶"
            expandBtn.TextColor3 = expanded and (getThemeColor and getThemeColor() or Color3.fromRGB(180, 180, 190)) or Color3.fromRGB(180, 180, 195)
        end)
        expandBtn.MouseEnter:Connect(function()
            if not expanded then expandBtn.TextColor3 = Color3.fromRGB(220, 220, 235) end
        end)
        expandBtn.MouseLeave:Connect(function()
            if not expanded then expandBtn.TextColor3 = Color3.fromRGB(180, 180, 195) end
        end)
    end

    mkSect(combatPage, "Bat Aimbot")
    do
        local row = mkRow(combatPage, 42)
        mkLabel(row, "Bat Aimbot")

        local expandBtn = Instance.new("TextButton", row)
        expandBtn.Name = "ExpandTriangle"
        expandBtn.Size = UDim2.new(0, 22, 0, 22)
        expandBtn.Position = UDim2.new(1, -88, 0.5, -11)
        expandBtn.BackgroundTransparency = 1
        expandBtn.BorderSizePixel = 0
        expandBtn.Text = "▶"
        expandBtn.TextColor3 = Color3.fromRGB(180, 180, 195)
        expandBtn.Font = Enum.Font.GothamBold
        expandBtn.TextSize = 12
        expandBtn.AutoButtonColor = false
        expandBtn.ZIndex = 10

        local pill, dot = mkPill(row, 62)
        local on = false
        local function sv(s)
            on = s
            animPill(pill, dot, s)
        end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            on = not on
            sv(on)
            if on then enableAutoBat() else disableAutoBat() end
            if mobSetAutoBat then mobSetAutoBat(on) end
            task.defer(function() pcall(saveAllSettings) end)
        end)
        autoBatSetVisual = sv

        -- Expanded row: Normal | Bypass split
        local modeRow = mkRow(combatPage, 42)
        modeRow.Name = "AimbotModeRow"
        modeRow.Visible = true -- always show Normal / Bypass switch

        mkLabel(modeRow, "Aimbot Mode")
        local holder = Instance.new("Frame", modeRow)
        holder.Name = "AimbotModeSplit"
        holder.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        holder.BackgroundTransparency = 0.15
        holder.Size = UDim2.new(0, 150, 0, 30)
        holder.Position = UDim2.new(1, -162, 0.5, -15)
        holder.AnchorPoint = Vector2.new(0, 0)
        holder.BorderSizePixel = 0
        holder.ClipsDescendants = true
        holder.ZIndex = 8
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 15)
        local holderStroke = Instance.new("UIStroke", holder)
        holderStroke.Color = Color3.fromRGB(60, 60, 70)
        holderStroke.Thickness = 1
        holderStroke.Transparency = 0.35

        local slide = Instance.new("Frame", holder)
        slide.Name = "SelectedSlide"
        slide.BackgroundColor3 = getThemeColor()
        slide.BackgroundTransparency = 0.15
        slide.Size = UDim2.new(0.5, -3, 1, -4)
        slide.Position = UDim2.new(0, 2, 0, 2)
        slide.BorderSizePixel = 0
        slide.ZIndex = 9
        Instance.new("UICorner", slide).CornerRadius = UDim.new(0, 13)
        local slideGrad = Instance.new("UIGradient", slide)
        slideGrad.Color = exoticHubGradient(getThemeColor())
        local slideStroke = Instance.new("UIStroke", slide)
        slideStroke.Color = getThemeColor()
        slideStroke.Thickness = 1.2
        slideStroke.Transparency = 0.1

        local leftText = Instance.new("TextLabel", holder)
        leftText.BackgroundTransparency = 1
        leftText.Text = "Normal"
        leftText.TextColor3 = Color3.fromRGB(255, 255, 255)
        leftText.Font = Enum.Font.GothamBlack
        leftText.TextSize = 12
        leftText.Size = UDim2.new(0.5, 0, 1, 0)
        leftText.Position = UDim2.new(0, 0, 0, 0)
        leftText.ZIndex = 10

        local rightText = Instance.new("TextLabel", holder)
        rightText.BackgroundTransparency = 1
        rightText.Text = "Bypass"
        rightText.TextColor3 = Color3.fromRGB(150, 150, 165)
        rightText.Font = Enum.Font.GothamBlack
        rightText.TextSize = 12
        rightText.Size = UDim2.new(0.5, 0, 1, 0)
        rightText.Position = UDim2.new(0.5, 0, 0, 0)
        rightText.ZIndex = 10

        local leftClick = Instance.new("TextButton", holder)
        leftClick.BackgroundTransparency = 1
        leftClick.Text = ""
        leftClick.AutoButtonColor = false
        leftClick.Size = UDim2.new(0.5, 0, 1, 0)
        leftClick.Position = UDim2.new(0, 0, 0, 0)
        leftClick.ZIndex = 11

        local rightClick = Instance.new("TextButton", holder)
        rightClick.BackgroundTransparency = 1
        rightClick.Text = ""
        rightClick.AutoButtonColor = false
        rightClick.Size = UDim2.new(0.5, 0, 1, 0)
        rightClick.Position = UDim2.new(0.5, 0, 0, 0)
        rightClick.ZIndex = 11

        local function setAimbotModeVisual(mode)
            local isBypass = (mode == "antiBatBypass" or mode == "Bypass")
            aimbotMode = isBypass and "antiBatBypass" or "normal"
            TS:Create(slide, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = isBypass and UDim2.new(0.5, 1, 0, 2) or UDim2.new(0, 2, 0, 2)
            }):Play()
            TS:Create(leftText, TweenInfo.new(0.18), {
                TextColor3 = isBypass and Color3.fromRGB(150, 150, 165) or Color3.fromRGB(255, 255, 255)
            }):Play()
            TS:Create(rightText, TweenInfo.new(0.18), {
                TextColor3 = isBypass and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 165)
            }):Play()
        end

        local function chooseAimbotMode(mode)
            local normalized = (mode == "antiBatBypass" or mode == "Bypass" or mode == "bypass")
                and "antiBatBypass" or "normal"
            local same = (aimbotMode == normalized)
            aimbotMode = normalized
            if aimbotModeLabel then
                aimbotModeLabel.Text = normalized == "antiBatBypass" and "Bypass" or "Normal"
            end
            setAimbotModeVisual(normalized)
            if same then
                return
            end
            -- Apply the selection immediately when Auto Bat is already on.
            -- disableAutoBat cleans up the previous mode before the new one starts.
            if autoBatEnabled then
                disableAutoBat()
                enableAutoBat()
            end
            task.defer(function() pcall(saveAllSettings) end)
        end

        leftClick.MouseButton1Click:Connect(function()
            chooseAimbotMode("normal")
        end)
        rightClick.MouseButton1Click:Connect(function()
            chooseAimbotMode("antiBatBypass")
        end)

        setAimbotModeVisual(aimbotMode)
        -- Expose for load/save restore (position of Normal/Bypass slider)
        _G._exoticHubAimbotModeSetter = function(mode)
            setAimbotModeVisual(mode)
        end

        local expanded = true
        modeRow.Visible = true
        if expandBtn then
            expandBtn.Text = "▼"
            expandBtn.TextColor3 = getThemeColor and getThemeColor() or Color3.fromRGB(180, 180, 190)
        end
        expandBtn.MouseButton1Click:Connect(function()
            expanded = not expanded
            modeRow.Visible = expanded
            expandBtn.Text = expanded and "▼" or "▶"
            expandBtn.TextColor3 = expanded and (getThemeColor and getThemeColor() or Color3.fromRGB(180, 180, 190)) or Color3.fromRGB(180, 180, 195)
        end)
        expandBtn.MouseEnter:Connect(function()
            if not expanded then expandBtn.TextColor3 = Color3.fromRGB(220, 220, 235) end
        end)
        expandBtn.MouseLeave:Connect(function()
            if not expanded then expandBtn.TextColor3 = Color3.fromRGB(180, 180, 195) end
        end)
    end
    do
        local row = mkRow(combatPage, 42)
        mkLabel(row, "Aimbot Speed")
        batSpeedBox = mkBox(row, BAT_AIMBOT_SPEED, 50, 56, function(v)
            if v and v > 0 and v <= 200 then
                BAT_AIMBOT_SPEED = v
                BYPASS_AIMBOT_SPEED = v
                pcall(function()
                    if snowVS and snowVS.BatBypass and snowVS.BatBypass.ZCFG then
                        snowVS.BatBypass.ZCFG.FOLLOW_SPEED = v
                    end
                end)
                task.defer(function() pcall(saveAllSettings) end)
            end
        end)
    end
    -- Hint row under mode
    do
        local row = mkRow(combatPage, 28)
        local hint = Instance.new("TextLabel", row)
        hint.BackgroundTransparency = 1
        hint.Size = UDim2.new(1, -16, 1, 0)
        hint.Position = UDim2.new(0, 12, 0, 0)
        hint.Font = Enum.Font.Gotham
        hint.TextSize = 11
        hint.TextXAlignment = Enum.TextXAlignment.Left
        hint.TextColor3 = Color3.fromRGB(150, 150, 160)
        hint.Text = "Normal = standard bat aimbot  ·  Bypass = prediction aimbot"
        hint.ZIndex = 8
    end
    -- Lagger Aimbot Speed removed
    setAutoSwingVisual = mkToggle(combatPage, "Auto Swing", function(on)
        autoSwingEnabled = on and true or false
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled == true) end
    setMirrorTpVisual = mkToggle(combatPage, "Mirror TP", function(on)
        mirrorTpEnabled = on and true or false
        _G._AdaptTPMirrorEnabled = mirrorTpEnabled
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setMirrorTpVisual then setMirrorTpVisual(mirrorTpEnabled == true) end

    mkSect(combatPage, "Drop Mode")
    do
        local modes = { {1, "Fling"}, {2, "Jump Drop"} }
        local idx = (dropMode == 2) and 2 or 1
        local row = mkRow(combatPage, 42)
        local title = Instance.new("TextLabel", row)
        title.Size = UDim2.new(0.42, 0, 1, 0)
        title.BackgroundTransparency = 1
        title.Text = "Drop Mode"
        title.TextColor3 = Color3.fromRGB(235, 235, 240)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 5
        local modeLbl = Instance.new("TextLabel", row)
        modeLbl.Size = UDim2.new(0, 80, 0, 22)
        modeLbl.Position = UDim2.new(1, -120, 0.5, -11)
        modeLbl.BackgroundTransparency = 1
        modeLbl.Text = modes[idx][2]
        modeLbl.TextColor3 = Color3.fromRGB(220, 220, 230)
        modeLbl.Font = Enum.Font.GothamBold
        modeLbl.TextSize = 11
        modeLbl.TextXAlignment = Enum.TextXAlignment.Center
        modeLbl.ZIndex = 6
        local triBtn = Instance.new("TextButton", row)
        triBtn.Size = UDim2.new(0, 26, 0, 22)
        triBtn.Position = UDim2.new(1, -34, 0.5, -11)
        triBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        triBtn.BorderSizePixel = 0
        triBtn.Text = "▼"
        triBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
        triBtn.Font = Enum.Font.GothamBold
        triBtn.TextSize = 11
        triBtn.ZIndex = 6
        Instance.new("UICorner", triBtn).CornerRadius = UDim.new(0, 6)
        triBtn.MouseButton1Click:Connect(function()
            idx = idx % #modes + 1
            dropMode = modes[idx][1]
            modeLbl.Text = modes[idx][2]
            if dropModeBtnRef then dropModeBtnRef.Text = modes[idx][2] end
            task.defer(function() pcall(saveAllSettings) end)
        end)
        dropModeBtnRef = modeLbl
        _G.__SyeDropModeLabel = modeLbl
    end

    mkSect(combatPage, "Spin Bot")
    setSpinBotVisual = mkToggle(combatPage, "Spin Bot (Brainrot)", function(on)
        if on then startSpinBot() else stopSpinBot() end
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setSpinBotVisual then setSpinBotVisual(spinBotEnabled == true) end
    do
        local row = mkRow(combatPage, 42)
        mkLabel(row, "Spin Bot Speed")
        spinBotSpeedBox = mkBox(row, spinBotSpeed or 12, 50, 56, function(v)
            if v and v >= 1 and v <= 60 then
                spinBotSpeed = v
                task.defer(function() pcall(saveAllSettings) end)
            end
        end)
    end

    -- Anti Lose removed
    antiLoseEnabled = false
    pcall(stopAntiLose)
    setAntiLoseVisual = nil

    setAutoAfterDropVisual = mkToggle(combatPage, "Auto After Drop Bat", function(on)
        autoAfterDropBat = on == true
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setAutoAfterDropVisual then setAutoAfterDropVisual(autoAfterDropBat == true) end

    mkSect(combatPage, "Anti Die")
    setAntiDieVisual = mkToggle(combatPage, "Anti Die", function(on)
        if on then
            pcall(function() if AntiDieModule and AntiDieModule.start then AntiDieModule.start() end end)
            antiDieEnabled = true
        else
            pcall(function() if AntiDieModule and AntiDieModule.stop then AntiDieModule.stop() end end)
            antiDieEnabled = false
        end
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setAntiDieVisual then setAntiDieVisual(antiDieEnabled == true) end

    mkSect(combatPage, "Anti Bat")
    setAntiBatVisual = mkToggle(combatPage, "Anti Bat", function(on)
        if on then
            pcall(startAntiBat)
        else
            pcall(stopAntiBat)
        end
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setAntiBatVisual then setAntiBatVisual(antiBatEnabled == true) end
    if antiBatEnabled then pcall(startAntiBat) end

    mkSect(combatPage, "Bat Counter")
    do
        local row = mkRow(combatPage, 42)
        mkLabel(row, "Bat Counter")

        -- Expand triangle (opens Bat Counter V2)
        local expandBtn = Instance.new("TextButton", row)
        expandBtn.Name = "ExpandTriangle"
        expandBtn.Size = UDim2.new(0, 22, 0, 22)
        expandBtn.Position = UDim2.new(1, -88, 0.5, -11)
        expandBtn.BackgroundTransparency = 1
        expandBtn.BorderSizePixel = 0
        expandBtn.Text = "▶"
        expandBtn.TextColor3 = Color3.fromRGB(180, 180, 195)
        expandBtn.Font = Enum.Font.GothamBold
        expandBtn.TextSize = 12
        expandBtn.AutoButtonColor = false
        expandBtn.ZIndex = 10

        local pill, dot = mkPill(row, 62)
        local on = false
        local function sv(s)
            on = s
            animPill(pill, dot, s)
        end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            on = not on
            sv(on)
            batCounterEnabled = on
            if on then startBatCounter() else stopBatCounter() end
            task.defer(function() pcall(saveAllSettings) end)
        end)
        setBatCounterVisual = sv

        -- Nested Bat Counter V2 row (hidden until expanded)
        local v2Row = mkRow(combatPage, 42)
        v2Row.Name = "BatCounterV2Row"
        v2Row.Visible = false
        v2Row.Size = UDim2.new(1, -12, 0, 42)

        local v2Label = Instance.new("TextLabel", v2Row)
        v2Label.Size = UDim2.new(0.55, -10, 1, 0)
        v2Label.Position = UDim2.new(0, 18, 0, 0)
        v2Label.BackgroundTransparency = 1
        v2Label.Text = "Bat Counter V2"
        v2Label.TextColor3 = Color3.fromRGB(170, 170, 185)
        v2Label.Font = Enum.Font.GothamBold
        v2Label.TextSize = 12
        v2Label.TextXAlignment = Enum.TextXAlignment.Left
        v2Label.ZIndex = 8

        local v2Pill, v2Dot = mkPill(v2Row, 62)
        local v2On = false
        local function sv2(s)
            v2On = s
            animPill(v2Pill, v2Dot, s)
        end
        local v2Clk = Instance.new("TextButton", v2Pill)
        v2Clk.Size = UDim2.new(1, 0, 1, 0)
        v2Clk.BackgroundTransparency = 1
        v2Clk.Text = ""
        v2Clk.AutoButtonColor = false
        v2Clk.ZIndex = 10
        v2Clk.MouseButton1Click:Connect(function()
            v2On = not v2On
            sv2(v2On)
            batCounterV2Enabled = v2On
            if v2On then startBatCounterV2() else stopBatCounterV2() end
            task.defer(function() pcall(saveAllSettings) end)
        end)
        setBatCounterV2Visual = sv2
        if batCounterV2Enabled then sv2(true) end

        local expanded = false
        expandBtn.MouseButton1Click:Connect(function()
            expanded = not expanded
            v2Row.Visible = expanded
            expandBtn.Text = expanded and "▼" or "▶"
            expandBtn.TextColor3 = expanded and getThemeColor() or Color3.fromRGB(180, 180, 195)
        end)
        expandBtn.MouseEnter:Connect(function()
            if not expanded then
                expandBtn.TextColor3 = Color3.fromRGB(220, 220, 235)
            end
        end)
        expandBtn.MouseLeave:Connect(function()
            if not expanded then
                expandBtn.TextColor3 = Color3.fromRGB(180, 180, 195)
            end
        end)
    end
    setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on)
        medusaCounterEnabled = on
        if on then
            if LP.Character then setupMedusaCounter(LP.Character) else stopMedusaCounter() end
        else
            stopMedusaCounter()
        end
    end)
    if setMedusaVisual then setMedusaVisual(medusaCounterEnabled) end

    -- ================================================================
    -- KEYS TAB
    -- ================================================================
    task.defer(function()
        pcall(applyUILayout, uiLayoutMode or "Left")
        pcall(applyCustomFont, customFontName or "Gotham")
        if spinBotEnabled then pcall(startSpinBot) end
        if antiLoseEnabled then pcall(startAntiLose) end
    end)

    local keyPage = contentPages["Keys"]
    mkSect(keyPage, "Movement Keys")
    addKeybindRow(keyPage, "Carry Mode", KB.CarryToggle)
    addKeybindRow(keyPage, "Lagger Mode", KB.LaggerMode)
    addKeybindRow(keyPage, "Auto Left", KB.AutoLeft)
    addKeybindRow(keyPage, "Auto Right", KB.AutoRight)
    addKeybindRow(keyPage, "TP Down", KB.TPFloor)

    mkSect(keyPage, "Combat Keys")
    addKeybindRow(keyPage, "Bat Aimbot", KB.AutoBat)
    addKeybindRow(keyPage, "TP BAT", KB.TPBat)
    addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(keyPage, "Insta Reset", KB.InstaReset)

    mkSect(keyPage, "Interface Keys")
    addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)

    do
        local note = Instance.new("TextLabel", keyPage)
        note.Size = UDim2.new(1, -16, 0, 40)
        note.BackgroundTransparency = 1
        note.Text = "Click a slot, then press a keyboard or controller button. ESC cancels."
        note.TextColor3 = Color3.fromRGB(140,140,155)
        note.Font = Enum.Font.Gotham
        note.TextSize = 11
        note.TextWrapped = true
        note.TextXAlignment = Enum.TextXAlignment.Left
        note.LayoutOrder = getNextOrder(keyPage)
        note.ZIndex = 8
    end
    local spacer = Instance.new("Frame", keyPage)
    spacer.Size = UDim2.new(1, 0, 0, 16)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = getNextOrder(keyPage)
    spacer.ZIndex = 7

    -- ================================================================
    -- VISUALS TAB
    -- ================================================================
    local visualPage = contentPages["Visuals"]

    mkSect(visualPage, "ESP")
    setESPVIsual = mkToggle(visualPage, "ESP", function(on) toggleESP(on) end)
    setESP2Visual = mkToggle(visualPage, "ESP 2", function(on)
        setESP2(on)
        task.defer(function() pcall(saveAllSettings) end)
    end)
    setBaseESPVisual = mkToggle(visualPage, "Base ESP", function(on)
        setBaseESP(on)
        task.defer(function() pcall(saveAllSettings) end)
    end)
    setBrainrotESPVisual = mkToggle(visualPage, "Brainrot ESP", function(on)
        setBrainrotESP(on)
        task.defer(function() pcall(saveAllSettings) end)
    end)
    setESPLineVisual = mkToggle(visualPage, "Tracers", function(on)
        if on then startESPLine() else stopESPLine() end
    end)
    setRagdollCounterVisual = mkToggle(visualPage, "Ragdoll Counter", function(on)
        ragdollCounterEnabled = on and true or false
        if on then
            if antiRagdollMode ~= "v2" then
                startAntiRagdollV2()
                antiRagdollMode = "v2"
            end
        else
            stopAntiRagdollV2()
            antiRagdollMode = "off"
        end
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setRagdollCounterVisual then setRagdollCounterVisual(antiRagdollMode == "v2" or ragdollCounterEnabled == true) end

    mkSect(visualPage, "Custom Skys")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Custom Skys")
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        skySelectorLabel = Instance.new("TextLabel", container)
        skySelectorLabel.Size = UDim2.new(0, 96, 0, 26)
        skySelectorLabel.Position = UDim2.new(0.5, -48, 0.5, -13)
        skySelectorLabel.BackgroundTransparency = 1
        skySelectorLabel.Text = skyTheme
        skySelectorLabel.TextColor3 = WHITE
        skySelectorLabel.Font = Enum.Font.GothamBold
        skySelectorLabel.TextSize = 11
        skySelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        skySelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateSkySelector(direction)
            local idx = 1
            for i, name in ipairs(SKY_PRESETS_LIST) do
                if name == skyTheme then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #SKY_PRESETS_LIST end
            if newIdx > #SKY_PRESETS_LIST then newIdx = 1 end
            local name = SKY_PRESETS_LIST[newIdx]
            skyTheme = name
            pcall(applyCustomSky, name)
            if skySelectorLabel then skySelectorLabel.Text = name end
            pcall(saveAllSettings)
        end
        leftBtn.MouseButton1Click:Connect(function() updateSkySelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateSkySelector(1) end)
    end

    mkSect(visualPage, "Anim Pack")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Custom Animations")
        local currentIndex = 1
        for i, entry in ipairs(ANIM_PACK_ORDER) do
            if entry[2] == currentAnimPack then currentIndex = i; break end
        end
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        animSelectorLabel = Instance.new("TextLabel", container)
        animSelectorLabel.Size = UDim2.new(0, 80, 0, 26)
        animSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        animSelectorLabel.BackgroundTransparency = 1
        animSelectorLabel.Text = ANIM_PACK_ORDER[currentIndex][2]
        animSelectorLabel.TextColor3 = WHITE
        animSelectorLabel.Font = Enum.Font.GothamBold
        animSelectorLabel.TextSize = 12
        animSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        animSelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateAnimSelector(direction)
            local idx = 1
            for i, entry in ipairs(ANIM_PACK_ORDER) do
                if entry[2] == currentAnimPack then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #ANIM_PACK_ORDER end
            if newIdx > #ANIM_PACK_ORDER then newIdx = 1 end
            local packName = ANIM_PACK_ORDER[newIdx][2]
            if packName == "Off" then stopAnimPack() else startAnimPack(packName) end
            if animSelectorLabel then animSelectorLabel.Text = packName end
            pcall(saveAllSettings)
        end
        leftBtn.MouseButton1Click:Connect(function() updateAnimSelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateAnimSelector(1) end)
    end

    mkSect(visualPage, "Performance")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Stretch Rez")
        local stretchPill, stretchDot = mkPill(row, 48)
        local stretchOn = stretchEnabled == true
        local function setStretch(s)
            stretchOn = s
            animPill(stretchPill, stretchDot, s)
            if s then enableStretch() else disableStretch() end
            stretchEnabled = s
            task.defer(function() pcall(saveAllSettings) end)
        end
        local stretchClk = Instance.new("TextButton", stretchPill)
        stretchClk.Size = UDim2.new(1,0,1,0)
        stretchClk.BackgroundTransparency = 1
        stretchClk.Text = ""
        stretchClk.AutoButtonColor = false
        stretchClk.ZIndex = 10
        stretchClk.MouseButton1Click:Connect(function() setStretch(not stretchOn) end)
        _G.stretchToggleSetter = setStretch
        if stretchEnabled then setStretch(true) end
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Stretch FOV")
        stretchFovBox = mkBox(row, stretchFOV or 120, 50, 56, function(v)
            if v and v >= 70 and v <= 120 then
                stretchFOV = math.floor(v)
                if stretchEnabled then pcall(applyStretchFOV, stretchFOV) end
                task.defer(function() pcall(saveAllSettings) end)
            end
        end)
    end
    do
        -- Slider for Stretch FOV 70-120
        local row = mkRow(visualPage, 40)
        mkLabel(row, "Stretch Slider")
        local valLbl = Instance.new("TextLabel", row)
        valLbl.Size = UDim2.new(0, 36, 0, 20)
        valLbl.Position = UDim2.new(1, -40, 0.5, -10)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = tostring(stretchFOV or 120)
        valLbl.TextColor3 = Color3.fromRGB(235, 235, 240)
        valLbl.Font = Enum.Font.GothamBold
        valLbl.TextSize = 12
        valLbl.ZIndex = 9
        local track = Instance.new("Frame", row)
        track.Size = UDim2.new(0, 120, 0, 8)
        track.Position = UDim2.new(1, -170, 0.5, -4)
        track.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        track.BorderSizePixel = 0
        track.ZIndex = 8
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
        local fill = Instance.new("Frame", track)
        fill.Size = UDim2.new(math.clamp(((stretchFOV or 120) - 70) / 50, 0, 1), 0, 1, 0)
        fill.BackgroundColor3 = getThemeColor()
        fill.BorderSizePixel = 0
        fill.ZIndex = 9
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
        local knob = Instance.new("Frame", track)
        knob.Size = UDim2.fromOffset(14, 14)
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Position = UDim2.new(math.clamp(((stretchFOV or 120) - 70) / 50, 0, 1), 0, 0.5, 0)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.BorderSizePixel = 0
        knob.ZIndex = 10
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        local dragging = false
        local function setFromX(x)
            local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            stretchFOV = math.floor(70 + rel * 50 + 0.5)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, 0, 0.5, 0)
            valLbl.Text = tostring(stretchFOV)
            if stretchFovBox then stretchFovBox.Text = tostring(stretchFOV) end
            if stretchEnabled then pcall(applyStretchFOV, stretchFOV) end
        end
        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                setFromX(input.Position.X)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                setFromX(input.Position.X)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    dragging = false
                    task.defer(function() pcall(saveAllSettings) end)
                end
            end
        end)
    end
    setAntiLagVisual = mkToggle(visualPage, "Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
    end)
    mkSect(visualPage, "Avatar Changer")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Outfit")
        local idx = currentOutfitIndex or 1
        if idx < 1 then idx = 1 end
        if idx > #OUTFITS then idx = #OUTFITS end
        local label = Instance.new("TextLabel", row)
        label.Size = UDim2.new(0, 90, 0, 26)
        label.Position = UDim2.new(1, -130, 0.5, -13)
        label.BackgroundTransparency = 1
        label.Text = (OUTFITS[idx] and OUTFITS[idx].label) or "OFF"
        label.TextColor3 = Color3.fromRGB(235, 235, 240)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.ZIndex = 8
        outfitSelectorLabel = label
        local left = Instance.new("TextButton", row)
        left.Size = UDim2.new(0, 26, 0, 26)
        left.Position = UDim2.new(1, -160, 0.5, -13)
        left.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        left.Text = "<"
        left.TextColor3 = Color3.fromRGB(255,255,255)
        left.Font = Enum.Font.GothamBold
        left.ZIndex = 9
        Instance.new("UICorner", left).CornerRadius = UDim.new(0, 6)
        local right = Instance.new("TextButton", row)
        right.Size = UDim2.new(0, 26, 0, 26)
        right.Position = UDim2.new(1, -34, 0.5, -13)
        right.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        right.Text = ">"
        right.TextColor3 = Color3.fromRGB(255,255,255)
        right.Font = Enum.Font.GothamBold
        right.ZIndex = 9
        Instance.new("UICorner", right).CornerRadius = UDim.new(0, 6)
        local function cycleOutfit(d)
            idx = idx + d
            if idx < 1 then idx = #OUTFITS end
            if idx > #OUTFITS then idx = 1 end
            currentOutfitIndex = idx
            label.Text = OUTFITS[idx].label
            pcall(applyOutfitByIndex, idx)
            task.defer(function() pcall(saveAllSettings) end)
        end
        left.MouseButton1Click:Connect(function() cycleOutfit(-1) end)
        right.MouseButton1Click:Connect(function() cycleOutfit(1) end)
    end
    do
        local row = mkRow(visualPage, 42)
        local openSkinBtn = Instance.new("TextButton", row)
        openSkinBtn.Size = UDim2.new(1, -12, 0, 34)
        openSkinBtn.Position = UDim2.new(0, 6, 0.5, -17)
        openSkinBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        openSkinBtn.BorderSizePixel = 0
        openSkinBtn.Text = "Open GUI Skin Changer"
        openSkinBtn.TextColor3 = Color3.fromRGB(230, 230, 240)
        openSkinBtn.Font = Enum.Font.GothamBold
        openSkinBtn.TextSize = 12
        openSkinBtn.AutoButtonColor = false
        openSkinBtn.ZIndex = 8
        Instance.new("UICorner", openSkinBtn).CornerRadius = UDim.new(0, 10)
        local sks = Instance.new("UIStroke", openSkinBtn)
        sks.Color = getThemeColor()
        sks.Thickness = 1.2
        openSkinBtn.MouseButton1Click:Connect(function()
            pcall(function()
                local parent = game:GetService("CoreGui")
                local old = parent:FindFirstChild("JKHubSkinChangerGui")
                if old then old:Destroy() end
                local sg = Instance.new("ScreenGui")
                sg.Name = "JKHubSkinChangerGui"
                sg.ResetOnSpawn = false
                sg.DisplayOrder = 20000
                sg.Parent = parent
                local frame = Instance.new("Frame", sg)
                frame.Size = UDim2.fromOffset(280, 220)
                frame.Position = UDim2.new(0.5, -140, 0.5, -110)
                frame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
                Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
                local st = Instance.new("UIStroke", frame)
                st.Color = getThemeColor()
                st.Thickness = 1.5
                local title = Instance.new("TextLabel", frame)
                title.Size = UDim2.new(1, -40, 0, 30)
                title.Position = UDim2.new(0, 12, 0, 8)
                title.BackgroundTransparency = 1
                title.Text = "Skin Changer"
                title.TextColor3 = Color3.fromRGB(255,255,255)
                title.Font = Enum.Font.GothamBold
                title.TextSize = 15
                title.TextXAlignment = Enum.TextXAlignment.Left
                local close = Instance.new("TextButton", frame)
                close.Size = UDim2.fromOffset(28, 28)
                close.Position = UDim2.new(1, -36, 0, 8)
                close.BackgroundColor3 = Color3.fromRGB(40, 20, 25)
                close.Text = "X"
                close.TextColor3 = Color3.fromRGB(255,180,180)
                close.Font = Enum.Font.GothamBold
                close.AutoButtonColor = false
                Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
                close.MouseButton1Click:Connect(function() sg:Destroy() end)
                local enableBtn = Instance.new("TextButton", frame)
                enableBtn.Size = UDim2.new(1, -24, 0, 36)
                enableBtn.Position = UDim2.new(0, 12, 0, 50)
                enableBtn.BackgroundColor3 = getThemeColor()
                enableBtn.Text = skinChangerEnabled and "Disable Skin" or "Enable Skin"
                enableBtn.TextColor3 = Color3.fromRGB(255,255,255)
                enableBtn.Font = Enum.Font.GothamBold
                enableBtn.TextSize = 13
                enableBtn.AutoButtonColor = false
                Instance.new("UICorner", enableBtn).CornerRadius = UDim.new(0, 10)
                enableBtn.MouseButton1Click:Connect(function()
                    setSkinChangerEnabled(not skinChangerEnabled)
                    enableBtn.Text = skinChangerEnabled and "Disable Skin" or "Enable Skin"
                    if setSkinChangerVisual then setSkinChangerVisual(skinChangerEnabled) end
                end)
                local cycleBtn = Instance.new("TextButton", frame)
                cycleBtn.Size = UDim2.new(1, -24, 0, 36)
                cycleBtn.Position = UDim2.new(0, 12, 0, 100)
                cycleBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
                cycleBtn.Text = "Mode: " .. tostring(skinChangerMode or "V1")
                cycleBtn.TextColor3 = Color3.fromRGB(230,230,240)
                cycleBtn.Font = Enum.Font.GothamBold
                cycleBtn.TextSize = 13
                cycleBtn.AutoButtonColor = false
                Instance.new("UICorner", cycleBtn).CornerRadius = UDim.new(0, 10)
                cycleBtn.MouseButton1Click:Connect(function()
                    cycleSkinChangerMode(1)
                    cycleBtn.Text = "Mode: " .. tostring(skinChangerMode or "V1")
                end)
                local note = Instance.new("TextLabel", frame)
                note.Size = UDim2.new(1, -24, 0, 40)
                note.Position = UDim2.new(0, 12, 0, 150)
                note.BackgroundTransparency = 1
                note.Text = "Cycles skin presets on your character"
                note.TextColor3 = Color3.fromRGB(160,160,170)
                note.Font = Enum.Font.Gotham
                note.TextSize = 11
                note.TextWrapped = true
            end)
        end)
    end
    setSkinChangerVisual = mkToggle(visualPage, "Skin Changer", function(on)
        pcall(setSkinChangerEnabled, on)
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setSkinChangerVisual then setSkinChangerVisual(skinChangerEnabled == true) end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Skin Mode")
        local modes = {"V1", "V2", "V3"}
        local idx = 1
        for i, m in ipairs(modes) do
            if m == (skinChangerMode or "V1") then idx = i; break end
        end
        local label = Instance.new("TextLabel", row)
        label.Size = UDim2.new(0, 50, 0, 26)
        label.Position = UDim2.new(1, -100, 0.5, -13)
        label.BackgroundTransparency = 1
        label.Text = modes[idx] or "V1"
        label.TextColor3 = Color3.fromRGB(235, 235, 240)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.ZIndex = 8
        skinModeSelectorLabel = label
        local left = Instance.new("TextButton", row)
        left.Size = UDim2.new(0, 26, 0, 26)
        left.Position = UDim2.new(1, -130, 0.5, -13)
        left.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        left.Text = "<"
        left.TextColor3 = Color3.fromRGB(255,255,255)
        left.Font = Enum.Font.GothamBold
        left.ZIndex = 9
        Instance.new("UICorner", left).CornerRadius = UDim.new(0, 6)
        local right = Instance.new("TextButton", row)
        right.Size = UDim2.new(0, 26, 0, 26)
        right.Position = UDim2.new(1, -34, 0.5, -13)
        right.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        right.Text = ">"
        right.TextColor3 = Color3.fromRGB(255,255,255)
        right.Font = Enum.Font.GothamBold
        right.ZIndex = 9
        Instance.new("UICorner", right).CornerRadius = UDim.new(0, 6)
        local function cycle(d)
            if cycleSkinChangerMode then
                local m = cycleSkinChangerMode(d)
                label.Text = tostring(m or skinChangerMode or "V1")
            else
                idx = idx + d
                if idx < 1 then idx = #modes end
                if idx > #modes then idx = 1 end
                skinChangerMode = modes[idx]
                label.Text = skinChangerMode
                if skinChangerEnabled then pcall(setSkinChangerEnabled, true) end
            end
            task.defer(function() pcall(saveAllSettings) end)
        end
        left.MouseButton1Click:Connect(function() cycle(-1) end)
        right.MouseButton1Click:Connect(function() cycle(1) end)
    end

        do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Bg Opacity")
        local box = mkBox(row, math.floor(((backgroundImageTransparency or 0) * 100) + 0.5), 50, 56, function(v)
            local val = math.clamp(tonumber(v) or 0, 0, 100)
            backgroundImageTransparency = val / 100
            pcall(function()
                if main then
                    local bg = main:FindFirstChild("BackgroundImage")
                    if bg then bg.ImageTransparency = backgroundImageTransparency end
                end
            end)
            task.defer(function() pcall(saveAllSettings) end)
        end)
    end

setLowGraphicsVisual = mkToggle(visualPage, "Potato Graphics", function(on)
        lowGraphicsEnabled = on and true or false
        if on then
            -- low graphics and vivid are mutually exclusive
            if vividGraphicsEnabled then
                pcall(disableVividGraphics)
                if setVividVisual then setVividVisual(false) end
            end
            pcall(enablePotatoGraphics)
        else
            pcall(disablePotatoGraphics)
        end
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setLowGraphicsVisual then setLowGraphicsVisual(lowGraphicsEnabled == true) end
    if lowGraphicsEnabled then pcall(enablePotatoGraphics) end

    setFps120Visual = mkToggle(visualPage, "120 FPS Mode", function(on)
        set120FpsMode(on)
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setFps120Visual then setFps120Visual(fps120Mode == true) end

    setShinyModeVisual = mkToggle(visualPage, "Shiny Mode", function(on)
        setShinyMode(on)
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setShinyModeVisual then setShinyModeVisual(shinyModeEnabled == true) end

    setVividVisual = mkToggle(visualPage, "Vivid Graphics 2", function(on)
        if on then
            if lowGraphicsEnabled then
                lowGraphicsEnabled = false
                pcall(disablePotatoGraphics)
                if setLowGraphicsVisual then setLowGraphicsVisual(false) end
            end
            pcall(enableVividGraphics)
        else
            pcall(disableVividGraphics)
        end
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setVividVisual then setVividVisual(vividGraphicsEnabled == true) end
    if vividGraphicsEnabled and not lowGraphicsEnabled then pcall(enableVividGraphics) end
    setCustomFovVisual = mkToggle(visualPage, "FOV", function(on)
        setCustomFOV(on)
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setCustomFovVisual then setCustomFovVisual(fovEnabled) end
    do
        local row = mkRow(visualPage, 48)
        mkLabel(row, "FOV Value")
        local valLbl = Instance.new("TextLabel", row)
        valLbl.Size = UDim2.new(0, 36, 0, 20)
        valLbl.Position = UDim2.new(1, -44, 0.5, -10)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = tostring(fovValue or 70)
        valLbl.TextColor3 = Color3.fromRGB(235, 235, 240)
        valLbl.Font = Enum.Font.GothamBold
        valLbl.TextSize = 12
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.ZIndex = 9

        local track = Instance.new("Frame", row)
        track.Name = "FOVSliderTrack"
        track.Size = UDim2.new(0, 110, 0, 8)
        track.Position = UDim2.new(1, -160, 0.5, -4)
        track.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
        track.BorderSizePixel = 0
        track.ZIndex = 8
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame", track)
        fill.Name = "FOVSliderFill"
        fill.Size = UDim2.new(math.clamp(((fovValue or 70) - 30) / 90, 0, 1), 0, 1, 0)
        fill.BackgroundColor3 = getThemeColor()
        fill.BorderSizePixel = 0
        fill.ZIndex = 9
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("TextButton", track)
        knob.Name = "FOVSliderKnob"
        knob.Size = UDim2.new(0, 16, 0, 16)
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Position = UDim2.new(math.clamp(((fovValue or 70) - 30) / 90, 0, 1), 0, 0.5, 0)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.BorderSizePixel = 0
        knob.Text = ""
        knob.ZIndex = 10
        knob.AutoButtonColor = false
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local function applyFromAlpha(a)
            a = math.clamp(a, 0, 1)
            local v = math.floor(30 + a * 90 + 0.5)
            fill.Size = UDim2.new(a, 0, 1, 0)
            knob.Position = UDim2.new(a, 0, 0.5, 0)
            valLbl.Text = tostring(v)
            fill.BackgroundColor3 = getThemeColor()
            setFOVValue(v)
        end

        local dragging = false
        local function setFromInput(x)
            local abs = track.AbsolutePosition.X
            local w = track.AbsoluteSize.X
            if w <= 0 then return end
            applyFromAlpha((x - abs) / w)
        end
        knob.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)
        track.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                setFromInput(inp.Position.X)
            end
        end)
        UIS.InputChanged:Connect(function(inp)
            if not dragging then return end
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                setFromInput(inp.Position.X)
            end
        end)
        UIS.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    dragging = false
                    task.defer(function() pcall(saveAllSettings) end)
                end
            end
        end)
        fovBox = valLbl
        _G.__SyeFovSliderApply = applyFromAlpha
    end



    -- Halloween mode removed

    mkSect(visualPage, "Font")
    do
        local openRow = mkRow(visualPage, 42)
        local openFontBtn = Instance.new("TextButton", openRow)
        openFontBtn.Size = UDim2.new(1, -12, 0, 34)
        openFontBtn.Position = UDim2.new(0, 6, 0.5, -17)
        openFontBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        openFontBtn.BorderSizePixel = 0
        openFontBtn.Text = "Open Custom Font GUI"
        openFontBtn.TextColor3 = Color3.fromRGB(230, 230, 240)
        openFontBtn.Font = Enum.Font.GothamBold
        openFontBtn.TextSize = 12
        openFontBtn.AutoButtonColor = false
        openFontBtn.ZIndex = 8
        Instance.new("UICorner", openFontBtn).CornerRadius = UDim.new(0, 10)
        local ofs = Instance.new("UIStroke", openFontBtn)
        ofs.Color = getThemeColor()
        ofs.Thickness = 1.2
        ofs.Transparency = 0.35
        openFontBtn.MouseButton1Click:Connect(function()
            pcall(function()
                local parent = game:GetService("CoreGui")
                local old = parent:FindFirstChild("JKHubFontPicker")
                if old then old:Destroy() end
                local sg = Instance.new("ScreenGui")
                sg.Name = "JKHubFontPicker"
                sg.ResetOnSpawn = false
                sg.DisplayOrder = 20000
                sg.Parent = parent
                local frame = Instance.new("Frame", sg)
                frame.Size = UDim2.fromOffset(300, 380)
                frame.Position = UDim2.new(0.5, -150, 0.5, -190)
                frame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
                frame.BorderSizePixel = 0
                Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
                local stroke = Instance.new("UIStroke", frame)
                stroke.Color = getThemeColor()
                stroke.Thickness = 1.5
                local title = Instance.new("TextLabel", frame)
                title.Size = UDim2.new(1, -40, 0, 32)
                title.Position = UDim2.new(0, 12, 0, 8)
                title.BackgroundTransparency = 1
                title.Text = "Custom GUI Fonts"
                title.TextColor3 = Color3.fromRGB(255,255,255)
                title.Font = Enum.Font.GothamBold
                title.TextSize = 15
                title.TextXAlignment = Enum.TextXAlignment.Left
                local close = Instance.new("TextButton", frame)
                close.Size = UDim2.fromOffset(28, 28)
                close.Position = UDim2.new(1, -36, 0, 8)
                close.BackgroundColor3 = Color3.fromRGB(40, 20, 25)
                close.Text = "X"
                close.TextColor3 = Color3.fromRGB(255,180,180)
                close.Font = Enum.Font.GothamBold
                close.TextSize = 14
                close.AutoButtonColor = false
                Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
                close.MouseButton1Click:Connect(function() sg:Destroy() end)
                local scroll = Instance.new("ScrollingFrame", frame)
                scroll.Size = UDim2.new(1, -16, 1, -52)
                scroll.Position = UDim2.new(0, 8, 0, 44)
                scroll.BackgroundTransparency = 1
                scroll.BorderSizePixel = 0
                scroll.ScrollBarThickness = 4
                scroll.CanvasSize = UDim2.new(0, 0, 0, #(CUSTOM_FONTS or {}) * 40)
                for i, pair in ipairs(CUSTOM_FONTS or {}) do
                    local btn = Instance.new("TextButton", scroll)
                    btn.Size = UDim2.new(1, -8, 0, 34)
                    btn.Position = UDim2.new(0, 4, 0, (i-1)*40)
                    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
                    btn.BorderSizePixel = 0
                    btn.Text = pair[1]
                    btn.TextColor3 = Color3.fromRGB(230,230,240)
                    btn.Font = pair[2]
                    btn.TextSize = 14
                    btn.AutoButtonColor = false
                    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
                    btn.MouseButton1Click:Connect(function()
                        customFontName = pair[1]
                        pcall(applyCustomFont, customFontName)
                        task.defer(function() pcall(saveAllSettings) end)
                        btn.BackgroundColor3 = getThemeColor()
                        task.delay(0.25, function() if btn and btn.Parent then btn.BackgroundColor3 = Color3.fromRGB(22,22,28) end end)
                    end)
                end
            end)
        end)
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Custom Font")
        local idx = 1
        for i, pair in ipairs(CUSTOM_FONTS or {}) do
            if pair[1] == (customFontName or "Gotham") then idx = i; break end
        end
        local label = Instance.new("TextLabel", row)
        label.Size = UDim2.new(0, 90, 0, 26)
        label.Position = UDim2.new(1, -130, 0.5, -13)
        label.BackgroundTransparency = 1
        label.Text = (CUSTOM_FONTS[idx] and CUSTOM_FONTS[idx][1]) or "Gotham"
        label.TextColor3 = Color3.fromRGB(235, 235, 240)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.ZIndex = 8
        local left = Instance.new("TextButton", row)
        left.Size = UDim2.new(0, 26, 0, 26)
        left.Position = UDim2.new(1, -160, 0.5, -13)
        left.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        left.Text = "<"
        left.TextColor3 = Color3.fromRGB(255,255,255)
        left.Font = Enum.Font.GothamBold
        left.TextSize = 12
        left.ZIndex = 9
        Instance.new("UICorner", left).CornerRadius = UDim.new(0, 6)
        local right = Instance.new("TextButton", row)
        right.Size = UDim2.new(0, 26, 0, 26)
        right.Position = UDim2.new(1, -34, 0.5, -13)
        right.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        right.Text = ">"
        right.TextColor3 = Color3.fromRGB(255,255,255)
        right.Font = Enum.Font.GothamBold
        right.TextSize = 12
        right.ZIndex = 9
        Instance.new("UICorner", right).CornerRadius = UDim.new(0, 6)
        local function cycle(d)
            idx = idx + d
            if idx < 1 then idx = #CUSTOM_FONTS end
            if idx > #CUSTOM_FONTS then idx = 1 end
            customFontName = CUSTOM_FONTS[idx][1]
            label.Text = customFontName
            applyCustomFont(customFontName)
            task.defer(function() pcall(saveAllSettings) end)
        end
        left.MouseButton1Click:Connect(function() cycle(-1) end)
        right.MouseButton1Click:Connect(function() cycle(1) end)
    end

    -- ================================================================
    -- SETTINGS TAB
    -- ================================================================
    local configPage = contentPages["Settings"]

    -- SAFETY
    
        mkSect(configPage, "YouTube Music Player")
    do
        local ytSound = nil
        local row = mkRow(configPage, 42)
        local urlBox = Instance.new("TextBox", row)
        urlBox.Size = UDim2.new(1, -12, 0, 32)
        urlBox.Position = UDim2.new(0, 6, 0.5, -16)
        urlBox.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        urlBox.BorderSizePixel = 0
        urlBox.PlaceholderText = "Direct MP3 URL (YouTube rips / catbox / etc)"
        urlBox.Text = "https://files.catbox.moe/sr0t7p.mp3"
        urlBox.TextColor3 = Color3.fromRGB(230, 230, 240)
        urlBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
        urlBox.Font = Enum.Font.Gotham
        urlBox.TextSize = 11
        urlBox.ClearTextOnFocus = false
        urlBox.ZIndex = 9
        Instance.new("UICorner", urlBox).CornerRadius = UDim.new(0, 8)
        local pad = Instance.new("UIPadding", urlBox)
        pad.PaddingLeft = UDim.new(0, 8)

        local row2 = mkRow(configPage, 42)
        local playBtn = Instance.new("TextButton", row2)
        playBtn.Size = UDim2.new(0.48, -8, 0, 34)
        playBtn.Position = UDim2.new(0, 6, 0.5, -17)
        playBtn.BackgroundColor3 = Color3.fromRGB(18, 48, 32)
        playBtn.BorderSizePixel = 0
        playBtn.Text = "▶  PLAY"
        playBtn.TextColor3 = Color3.fromRGB(170, 255, 200)
        playBtn.Font = Enum.Font.GothamBold
        playBtn.TextSize = 12
        playBtn.AutoButtonColor = false
        playBtn.ZIndex = 9
        Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 10)

        local stopBtn = Instance.new("TextButton", row2)
        stopBtn.Size = UDim2.new(0.48, -8, 0, 34)
        stopBtn.Position = UDim2.new(0.52, 2, 0.5, -17)
        stopBtn.BackgroundColor3 = Color3.fromRGB(48, 18, 24)
        stopBtn.BorderSizePixel = 0
        stopBtn.Text = "■  STOP"
        stopBtn.TextColor3 = Color3.fromRGB(255, 180, 190)
        stopBtn.Font = Enum.Font.GothamBold
        stopBtn.TextSize = 12
        stopBtn.AutoButtonColor = false
        stopBtn.ZIndex = 9
        Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 10)

        local function stopYt()
            if ytSound then
                pcall(function() ytSound:Stop() end)
                pcall(function() ytSound:Destroy() end)
                ytSound = nil
            end
            playBtn.Text = "▶  PLAY"
        end

        playBtn.MouseButton1Click:Connect(function()
            stopYt()
            local url = tostring(urlBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
            if url == "" then return end
            playBtn.Text = "…"
            task.spawn(function()
                local asset = nil
                local loader = getcustomasset or getsynasset
                if type(loader) == "function" and type(writefile) == "function" then
                    local fname = "jkHub_yt_music.mp3"
                    local ok, data = pcall(function() return game:HttpGet(url) end)
                    if ok and type(data) == "string" and #data > 256 then
                        pcall(writefile, fname, data)
                        local ok2, a = pcall(loader, fname)
                        if ok2 then asset = a end
                    end
                end
                if not asset then
                    playBtn.Text = "FAILED"
                    task.delay(1.2, function() playBtn.Text = "▶  PLAY" end)
                    return
                end
                local s = Instance.new("Sound")
                s.Name = "JKHubYouTubeMusic"
                s.SoundId = asset
                s.Volume = 0.85
                s.Looped = true
                s.Parent = game:GetService("SoundService")
                pcall(function() s:Play() end)
                ytSound = s
                playBtn.Text = "♪ PLAYING"
                s.Ended:Connect(function()
                    if ytSound == s then
                        ytSound = nil
                        playBtn.Text = "▶  PLAY"
                    end
                end)
            end)
        end)
        stopBtn.MouseButton1Click:Connect(stopYt)
    end

mkSect(configPage, "Tab Layout")
    do
        local modes = {"Left", "Right", "Top", "Bottom"}
        local row = mkRow(configPage, 48)
        row.Size = UDim2.new(1, 0, 0, 48)
        local layoutBtns = {}
        local function refreshLayoutBtns()
            for mode, btn in pairs(layoutBtns) do
                local on = (uiLayoutMode or "Left") == mode
                btn.BackgroundColor3 = on and getThemeColor() or Color3.fromRGB(22, 22, 28)
                btn.TextColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 190)
            end
        end
        for i, mode in ipairs(modes) do
            local btn = Instance.new("TextButton", row)
            btn.Size = UDim2.new(0.24, -6, 0, 34)
            btn.Position = UDim2.new((i - 1) * 0.25, 4, 0.5, -17)
            btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
            btn.BorderSizePixel = 0
            btn.Text = mode
            btn.TextColor3 = Color3.fromRGB(180, 180, 190)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.AutoButtonColor = false
            btn.ZIndex = 9
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
            layoutBtns[mode] = btn
            btn.MouseButton1Click:Connect(function()
                applyUILayout(mode)
                refreshLayoutBtns()
                task.defer(function() pcall(saveAllSettings) end)
            end)
        end
        refreshLayoutBtns()
    end

mkSect(configPage, "Safety")
    setSafeModeVisual = mkToggle(configPage, "Safe Mode", function(on)
        safeModeEnabled = on and true or false
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setSafeModeVisual then setSafeModeVisual(safeModeEnabled == true) end

    setE01TimerVisual = mkToggle(configPage, "E01 Timer", function(on)
        setE01TimerEnabled(on)
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setE01TimerVisual then setE01TimerVisual(e01TimerEnabled == true) end
    -- ensure runtime matches toggle on UI build
    pcall(setE01TimerEnabled, e01TimerEnabled == true)

    -- APPEARANCE
    mkSect(configPage, "Appearance")
    do
        local themeNames = {}
        for n in pairs(COLOR_THEMES or {}) do table.insert(themeNames, n) end
        table.sort(themeNames)
        local idx = 1
        for i, n in ipairs(themeNames) do
            if n == (currentColorTheme or "Red") then idx = i; break end
        end
        local row = mkRow(configPage, 42)
        mkLabel(row, "Accent Color")
        local label = Instance.new("TextLabel", row)
        label.Size = UDim2.new(0, 80, 0, 26)
        label.Position = UDim2.new(1, -120, 0.5, -13)
        label.BackgroundTransparency = 1
        label.Text = themeNames[idx] or "Red"
        label.TextColor3 = getThemeColor()
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.ZIndex = 8
        colorSelectorLabel = label
        local left = Instance.new("TextButton", row)
        left.Size = UDim2.new(0, 26, 0, 26)
        left.Position = UDim2.new(1, -150, 0.5, -13)
        left.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        left.Text = "<"
        left.TextColor3 = Color3.fromRGB(255,255,255)
        left.Font = Enum.Font.GothamBold
        left.ZIndex = 9
        Instance.new("UICorner", left).CornerRadius = UDim.new(0, 6)
        local right = Instance.new("TextButton", row)
        right.Size = UDim2.new(0, 26, 0, 26)
        right.Position = UDim2.new(1, -34, 0.5, -13)
        right.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        right.Text = ">"
        right.TextColor3 = Color3.fromRGB(255,255,255)
        right.Font = Enum.Font.GothamBold
        right.ZIndex = 9
        Instance.new("UICorner", right).CornerRadius = UDim.new(0, 6)
        local function cycle(d)
            idx = idx + d
            if idx < 1 then idx = #themeNames end
            if idx > #themeNames then idx = 1 end
            local name = themeNames[idx]
            currentColorTheme = name
            selectedColor = COLOR_THEMES[name]
            label.Text = name
            label.TextColor3 = selectedColor
            pcall(updateAllUIThemeColors, selectedColor)
            task.defer(function() pcall(saveAllSettings) end)
        end
        left.MouseButton1Click:Connect(function() cycle(-1) end)
        right.MouseButton1Click:Connect(function() cycle(1) end)
    end
    do
        local row = mkRow(configPage, 42)
        mkLabel(row, "UI Scale")
        uiScaleBox = mkBox(row, uiScaleValue, 50, 56, function(v)
            if v and v >= 50 and v <= 150 then
                uiScaleValue = _floor(v + 0.5)
                if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
                if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
                task.defer(function() pcall(saveAllSettings) end)
            end
        end)
    end

    -- Background / theme image previews (row of thumbnails)
    do
        local row = mkRow(configPage, 64)
        row.Size = UDim2.new(1, 0, 0, 64)
        backgroundPreviewButtons = {}

        local layout = Instance.new("UIListLayout", row)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        local pad = Instance.new("UIPadding", row)
        pad.PaddingLeft = UDim.new(0, 8)

        for i, preset in ipairs(backgroundPresets) do
            local btn = Instance.new("ImageButton", row)
            btn.Name = "BgPreview_" .. tostring(i)
            btn.Size = UDim2.new(0, 52, 0, 52)
            btn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
            btn.BackgroundTransparency = 0.15
            btn.BorderSizePixel = 0
            btn.AutoButtonColor = false
            btn.LayoutOrder = i
            btn.ZIndex = 10
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = Color3.fromRGB(60, 60, 70)
            stroke.Thickness = 1
            stroke.Transparency = 0.4

            if preset.id then
                btn.Image = jkHubImageUri(preset.id)
                btn.ScaleType = Enum.ScaleType.Crop
                btn.ImageTransparency = 0
            else
                btn.Image = ""
                local noneLbl = Instance.new("TextLabel", btn)
                noneLbl.Size = UDim2.new(1, 0, 1, 0)
                noneLbl.BackgroundTransparency = 1
                noneLbl.Text = "NONE"
                noneLbl.TextColor3 = Color3.fromRGB(180, 180, 190)
                noneLbl.Font = Enum.Font.GothamBold
                noneLbl.TextSize = 11
                noneLbl.ZIndex = 11
            end

            btn.MouseButton1Click:Connect(function()
                applyBackgroundPreset(i)
            end)
            backgroundPreviewButtons[i] = btn
        end
        updateBackgroundPreviewSelection()
    end


    -- STEAL BAR
    mkSect(configPage, "Steal Bar")
    do
        local row = mkRow(configPage, 42)
        mkLabel(row, "Steal Bar Size")
        stealBarScaleBox = mkBox(row, stealBarScale, 50, 56, function(v)
            if v and v >= 50 and v <= 200 then
                stealBarScale = _floor(v + 0.5)
                if pbScale then pbScale.Scale = stealBarScale / 100 end
                if stealBarScaleBox then stealBarScaleBox.Text = tostring(stealBarScale) end
                task.defer(function() pcall(saveAllSettings) end)
            end
        end)
    end

    -- MB BUTTONS
    mkSect(configPage, "MB Buttons")
    do
        local row = mkRow(configPage, 42)
        mkLabel(row, "MB Buttons Size")
        mbButtonsScaleBox = mkBox(row, math.floor((floatingButtonScale or 1) * 100 + 0.5), 50, 56, function(v)
            if v and v >= 50 and v <= 200 then
                floatingButtonScale = v / 100
                applyFloatingButtonScale()
                if mbButtonsScaleBox then mbButtonsScaleBox.Text = tostring(_floor(v + 0.5)) end
                task.defer(function() pcall(saveAllSettings) end)
            end
        end)
    end
    setCircleButtonsVisual = mkToggle(configPage, "Circle Buttons", function(on)
        mobileButtonCircleMode = on == true
        pcall(function() applyMobileButtonShape(mobileButtonCircleMode) end)
    pcall(function() if refreshMobileButtonsBackground then refreshMobileButtonsBackground() end end)
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setCircleButtonsVisual then setCircleButtonsVisual(mobileButtonCircleMode == true) end

    setTrianglePanelVisual = mkToggle(configPage, "Triangle Mobile Panel", function(on)
        mobilePanelTriangleMode = on == true
        pcall(function()
            if MobilePanel then
                local container = MobilePanel:FindFirstChild("FloatingPanel") or MobilePanel:FindFirstChildWhichIsA("Frame")
                if container then
                    local corner = container:FindFirstChildOfClass("UICorner")
                    if not corner then
                        corner = Instance.new("UICorner", container)
                    end
                    -- Triangle-ish: sharp corners when on, soft when off
                    corner.CornerRadius = on and UDim.new(0, 4) or UDim.new(0, 18)
                end
            end
        end)
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setTrianglePanelVisual then setTrianglePanelVisual(mobilePanelTriangleMode == true) end
    setMatchBgButtonsVisual = mkToggle(configPage, "Buttons Match BG", function(on)
        mobileButtonsMatchBackground = on == true
        pcall(function() if refreshMobileButtonsBackground then refreshMobileButtonsBackground() end end)
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setMatchBgButtonsVisual then setMatchBgButtonsVisual(mobileButtonsMatchBackground == true) end
    setChristmasModeVisual = mkToggle(configPage, "Christmas Mode", function(on)
        applyChristmasMode(on == true)
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setChristmasModeVisual then setChristmasModeVisual(christmasMode == true) end

    setRainbowAccentVisual = mkToggle(configPage, "Rainbow Accent", function(on)
        setRainbowAccent(on)
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setRainbowAccentVisual then setRainbowAccentVisual(rainbowAccentEnabled == true) end
    setHideButtonsVisual = mkToggle(configPage, "Show Buttons", function(on)
        -- on = show → hideButtonsEnabled = false
        applyHideButtons(not on)
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setHideButtonsVisual then setHideButtonsVisual(not hideButtonsEnabled) end

    -- Speed Bypass UI removed
    setLockUIVisual = mkToggle(configPage, "Lock Buttons", function(on)
        toggleLockUI(on)
        task.defer(function() pcall(saveAllSettings) end)
    end)
    if setLockUIVisual then setLockUIVisual(uiLocked == true) end

    mkSect(configPage, "Config")
    do
        local row = mkRow(configPage, 42)
        mkLabel(row, "Save Config")
        local saveBtn = Instance.new("TextButton", row)
        saveBtn.Size = UDim2.new(0, 92, 0, 24)
        saveBtn.Position = UDim2.new(1, -100, 0.5, -12)
        saveBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
        saveBtn.BorderSizePixel = 0
        saveBtn.Text = "SAVE"
        saveBtn.TextColor3 = Color3.fromRGB(15, 20, 18)
        saveBtn.Font = Enum.Font.GothamBold
        saveBtn.TextSize = 11
        saveBtn.ZIndex = 9
        saveBtn.AutoButtonColor = false
        Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 7)
        local saveDebounce = false
        saveBtn.MouseButton1Click:Connect(function()
            if saveDebounce then return end
            saveDebounce = true
            local ok = pcall(function() saveAllSettings(true) end)
            saveBtn.Text = ok and "SAVED" or "ERROR"
            saveBtn.BackgroundColor3 = ok and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(220, 80, 90)
            task.delay(1.2, function()
                if saveBtn and saveBtn.Parent then
                    saveBtn.Text = "SAVE"
                    saveBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
                    saveDebounce = false
                end
            end)
        end)
    end
    do
        local row = mkRow(configPage, 42)
        mkLabel(row, "Reset Positions")
        local resetPosBtn = Instance.new("TextButton", row)
        resetPosBtn.Size = UDim2.new(0, 92, 0, 24)
        resetPosBtn.Position = UDim2.new(1, -100, 0.5, -12)
        resetPosBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        resetPosBtn.BorderSizePixel = 0
        resetPosBtn.Text = "RESET"
        resetPosBtn.TextColor3 = Color3.fromRGB(20, 20, 25)
        resetPosBtn.Font = Enum.Font.GothamBold
        resetPosBtn.TextSize = 11
        resetPosBtn.ZIndex = 9
        Instance.new("UICorner", resetPosBtn).CornerRadius = UDim.new(0, 7)
        local resetDebounce = false
        resetPosBtn.MouseButton1Click:Connect(function()
            if resetDebounce then return end
            resetDebounce = true
            resetFloatingPositions()
            resetPosBtn.Text = "DONE"
            task.delay(1.2, function()
                if resetPosBtn and resetPosBtn.Parent then
                    resetPosBtn.Text = "RESET"
                    resetDebounce = false
                end
            end)
            task.defer(function() pcall(saveAllSettings) end)
        end)
    end

    -- ======================================================================
    -- ======================================================================
    -- AUTO STEAL GUI — Crystal / Fade style (switched)
    -- ======================================================================
    do
        local StatsSvc = nil
        pcall(function() StatsSvc = game:GetService("Stats") end)

        local grabBarGui = Instance.new("Frame", gui)
        grabBarGui.Name = "SyeHubAutoGrabBar"
        grabBarGui.Size = UDim2.fromOffset(360, 64)
        grabBarGui.AnchorPoint = Vector2.new(0.5, 0)
        if savedProgressBarPos then
            grabBarGui.Position = UDim2.new(
                savedProgressBarPos.XScale or 0.5,
                savedProgressBarPos.XOffset or 0,
                savedProgressBarPos.YScale or 0.80,
                savedProgressBarPos.YOffset or 0
            )
        else
            grabBarGui.Position = UDim2.new(0.5, 0, 0.80, 0)
        end
        grabBarGui.BackgroundColor3 = Color3.fromRGB(4, 4, 6)
        grabBarGui.BackgroundTransparency = 0
        grabBarGui.BorderSizePixel = 0
        grabBarGui.Active = true
        grabBarGui.ClipsDescendants = true
        grabBarGui.ZIndex = 500
        grabBarGui.Visible = CONFIG.AUTO_STEAL_ENABLED == true
        Instance.new("UICorner", grabBarGui).CornerRadius = UDim.new(0, 13)

        -- Background image layer (synced with hub background presets)
        local grabBg = Instance.new("ImageLabel", grabBarGui)
        grabBg.Name = "BackgroundImage"
        grabBg.Size = UDim2.new(1, 0, 1, 0)
        grabBg.Position = UDim2.new(0, 0, 0, 0)
        grabBg.BackgroundTransparency = 1
        grabBg.Image = ""
        grabBg.ImageTransparency = 1
        grabBg.ScaleType = Enum.ScaleType.Crop
        grabBg.ZIndex = 500
        Instance.new("UICorner", grabBg).CornerRadius = UDim.new(0, 13)
        -- Apply current hub background if any
        pcall(function()
            if backgroundMode ~= "None" and backgroundIndex and backgroundImages[backgroundIndex] then
                grabBg.Image = jkHubImageUri(backgroundImages[backgroundIndex])
                grabBg.ImageTransparency = backgroundImageTransparency or 0
                grabBarGui.BackgroundTransparency = 1
            end
        end)

        local barStroke = Instance.new("UIStroke", grabBarGui)
        barStroke.Name = "OuterStroke"
        barStroke.Color = Color3.fromRGB(55, 55, 60)
        barStroke.Thickness = 1.2
        barStroke.Transparency = 0.18
        barStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local outerGrad = Instance.new("UIGradient", grabBarGui)
        outerGrad.Name = "OuterRelief"
        outerGrad.Rotation = 90
        outerGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(14, 14, 18)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(5, 5, 8)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(8, 8, 12)),
        })

        pbScale = Instance.new("UIScale", grabBarGui)
        pbScale.Scale = (stealBarScale or 70) / 100

        local topStrip = Instance.new("Frame", grabBarGui)
        topStrip.Name = "TopStrip"
        topStrip.Size = UDim2.new(1, 0, 0, 1)
        topStrip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        topStrip.BackgroundTransparency = 0.88
        topStrip.BorderSizePixel = 0
        topStrip.ZIndex = 501

        -- Player avatar circle
        local avatarRing = Instance.new("Frame", grabBarGui)
        avatarRing.Name = "PlayerAvatarRing"
        avatarRing.Size = UDim2.fromOffset(40, 40)
        avatarRing.Position = UDim2.new(0, 10, 0.5, -20)
        avatarRing.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        avatarRing.BorderSizePixel = 0
        avatarRing.ZIndex = 505
        Instance.new("UICorner", avatarRing).CornerRadius = UDim.new(1, 0)
        local avStroke = Instance.new("UIStroke", avatarRing)
        avStroke.Color = (getThemeColor and getThemeColor()) or Color3.fromRGB(200, 200, 210)
        avStroke.Thickness = 2
        avStroke.Transparency = 0.2
        local avatarImg = Instance.new("ImageLabel", avatarRing)
        avatarImg.Name = "PlayerAvatar"
        avatarImg.Size = UDim2.new(1, -4, 1, -4)
        avatarImg.Position = UDim2.new(0, 2, 0, 2)
        avatarImg.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
        avatarImg.BorderSizePixel = 0
        avatarImg.ScaleType = Enum.ScaleType.Crop
        avatarImg.ZIndex = 506
        Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)
        pcall(function()
            local uid = LP.UserId
            if uid and uid > 0 then
                avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(uid) .. "&w=150&h=150"
            end
        end)

        local modePill = Instance.new("TextButton", grabBarGui)
        modePill.Name = "ModePill"
        modePill.Size = UDim2.new(0, 52, 0, 18)
        modePill.Position = UDim2.new(0, 58, 0, 10)
        modePill.BackgroundColor3 = (getThemeColor and getThemeColor()) or Color3.fromRGB(180, 180, 190)
        modePill.BorderSizePixel = 0
        modePill.Text = (selectedStealMode == "V2" or selectedStealMode == "Semi") and "SEMI" or "NORM"
        autoGrabModePill = modePill
        modePill.Font = Enum.Font.GothamBlack
        modePill.TextSize = 9
        modePill.TextColor3 = Color3.fromRGB(255, 255, 255)
        modePill.ZIndex = 506
        modePill.AutoButtonColor = false
        Instance.new("UICorner", modePill).CornerRadius = UDim.new(0, 6)
        modePill.MouseButton1Click:Connect(function()
            local toSemi = not (selectedStealMode == "V2" or selectedStealMode == "Semi")
            if _G._exoticHubStealModeSetter then
                pcall(_G._exoticHubStealModeSetter, toSemi)
            else
                selectedStealMode = toSemi and "V2" or "V1"
                modePill.Text = toSemi and "SEMI" or "NORM"
            end
            pcall(function()
                if updateAutoGrabModePill then updateAutoGrabModePill(selectedStealMode) end
            end)
            task.defer(function() pcall(saveAllSettings) end)
        end)

        local autoGrabTitle = Instance.new("TextLabel", grabBarGui)
        autoGrabTitle.Name = "AutoGrabTitle"
        autoGrabTitle.Size = UDim2.new(1, -170, 0, 18)
        autoGrabTitle.Position = UDim2.new(0, 70, 0, 10)
        autoGrabTitle.BackgroundTransparency = 1
        autoGrabTitle.Text = "AUTO GRAB"
        autoGrabTitle.Font = Enum.Font.GothamBlack
        autoGrabTitle.TextSize = 12
        autoGrabTitle.TextColor3 = Color3.fromRGB(245, 245, 250)
        autoGrabTitle.TextXAlignment = Enum.TextXAlignment.Left
        autoGrabTitle.ZIndex = 506

        local percentLbl = Instance.new("TextLabel", grabBarGui)
        percentLbl.Name = "Percent"
        percentLbl.Size = UDim2.new(0, 54, 0, 18)
        percentLbl.Position = UDim2.new(1, -148, 0, 10)
        percentLbl.BackgroundTransparency = 1
        percentLbl.Text = "0%"
        percentLbl.Font = Enum.Font.GothamBlack
        percentLbl.TextSize = 14
        percentLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        percentLbl.TextXAlignment = Enum.TextXAlignment.Right
        percentLbl.ZIndex = 506

        local pbFpsLabel = Instance.new("TextLabel", grabBarGui)
        pbFpsLabel.Name = "FPSPING"
        pbFpsLabel.Size = UDim2.new(0, 88, 0, 18)
        pbFpsLabel.Position = UDim2.new(1, -88, 0, 10)
        pbFpsLabel.BackgroundTransparency = 1
        pbFpsLabel.Text = "0fps · 0ms"
        pbFpsLabel.Font = Enum.Font.GothamBold
        pbFpsLabel.TextSize = 11
        pbFpsLabel.TextColor3 = Color3.fromRGB(190, 190, 205)
        pbFpsLabel.TextXAlignment = Enum.TextXAlignment.Right
        pbFpsLabel.ZIndex = 506

        local pbTrack = Instance.new("Frame", grabBarGui)
        pbTrack.Name = "StealTrack"
        pbTrack.Size = UDim2.new(1, -24, 0, 12)
        pbTrack.Position = UDim2.new(0, 12, 1, -22)
        pbTrack.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        pbTrack.BorderSizePixel = 0
        pbTrack.ClipsDescendants = true
        pbTrack.ZIndex = 504
        Instance.new("UICorner", pbTrack).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame", pbTrack)
        fill.Name = "Fill"
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BackgroundColor3 = (getThemeColor and getThemeColor()) or Color3.fromRGB(180, 180, 190)
        fill.BorderSizePixel = 0
        fill.ClipsDescendants = true
        fill.ZIndex = 505
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local fillGrad = Instance.new("UIGradient", fill)
        fillGrad.Name = "FillGrad"
        fillGrad.Rotation = -8
        do
            local c = (getThemeColor and getThemeColor()) or Color3.fromRGB(180, 180, 190)
            local dark = c:Lerp(Color3.new(0, 0, 0), 0.45)
            local light = c:Lerp(Color3.new(1, 1, 1), 0.32)
            fillGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, dark),
                ColorSequenceKeypoint.new(0.40, c),
                ColorSequenceKeypoint.new(0.72, light),
                ColorSequenceKeypoint.new(1.00, dark),
            })
        end

        local fillGlow = Instance.new("Frame", fill)
        fillGlow.Size = UDim2.new(0, 70, 1, -2)
        fillGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        fillGlow.Position = UDim2.new(1, -48, 0.5, 0)
        fillGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        fillGlow.BackgroundTransparency = 0.28
        fillGlow.BorderSizePixel = 0
        fillGlow.ZIndex = 505
        Instance.new("UICorner", fillGlow).CornerRadius = UDim.new(1, 0)
        local glowGrad = Instance.new("UIGradient", fillGlow)
        glowGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.05),
            NumberSequenceKeypoint.new(1, 1),
        })

        local fillShine = Instance.new("Frame", fill)
        fillShine.Size = UDim2.new(0, 40, 1, -4)
        fillShine.AnchorPoint = Vector2.new(0.5, 0.5)
        fillShine.Position = UDim2.new(1, -34, 0.5, 0)
        fillShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        fillShine.BackgroundTransparency = 0.08
        fillShine.BorderSizePixel = 0
        fillShine.ZIndex = 506
        Instance.new("UICorner", fillShine).CornerRadius = UDim.new(1, 0)

        pbFrame = grabBarGui
        progressFill = fill
        progressPct = percentLbl

        -- drag
        if drag then
            pcall(drag, grabBarGui)
        else
            local dragging, dragStart, startPos = false, nil, nil
            grabBarGui.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = grabBarGui.Position
                end
            end)
            UIS.InputChanged:Connect(function(input)
                if not dragging then return end
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    local d = input.Position - dragStart
                    grabBarGui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
                end
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if dragging then
                        dragging = false
                        savedProgressBarPos = {
                            XScale = grabBarGui.Position.X.Scale,
                            XOffset = grabBarGui.Position.X.Offset,
                            YScale = grabBarGui.Position.Y.Scale,
                            YOffset = grabBarGui.Position.Y.Offset,
                        }
                        task.defer(function() pcall(saveAllSettings) end)
                    end
                end
            end)
        end

        grabBarGui:GetPropertyChangedSignal("Position"):Connect(function()
            if not pbFrame then return end
            savedProgressBarPos = {
                XScale = pbFrame.Position.X.Scale,
                XOffset = pbFrame.Position.X.Offset,
                YScale = pbFrame.Position.Y.Scale,
                YOffset = pbFrame.Position.Y.Offset,
            }
            task.defer(function() pcall(saveAllSettings) end)
        end)

        task.spawn(function()
            while grabBarGui and grabBarGui.Parent do
                if fill and fill.AbsoluteSize.X > 20 then
                    fillShine.Position = UDim2.new(0, -20, 0.5, 0)
                    local tw = TS:Create(fillShine, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Position = UDim2.new(1, 20, 0.5, 0)
                    })
                    tw:Play()
                    tw.Completed:Wait()
                end
                task.wait(1.6)
            end
        end)

        task.spawn(function()
            local frameCount, windowStart, fpsAvg, lastPing = 0, tick(), 60, 0
            local conn = RunService.RenderStepped:Connect(function()
                frameCount = frameCount + 1
            end)
            while grabBarGui and grabBarGui.Parent do
                local now = tick()
                local elapsed = now - windowStart
                if elapsed > 0.05 then
                    fpsAvg = fpsAvg + ((frameCount / elapsed) - fpsAvg) * 0.5
                    frameCount = 0
                    windowStart = now
                end
                local ok, v = pcall(function() return LP:GetNetworkPing() * 1000 end)
                if ok and type(v) == "number" then lastPing = math.floor(v + 0.5) end
                pbFpsLabel.Text = string.format("%dfps · %dms", math.floor(fpsAvg + 0.5), lastPing)
                if modePill and getThemeColor then
                    modePill.BackgroundColor3 = getThemeColor()
                end
                if fill and getThemeColor then
                    local c = getThemeColor()
                    fill.BackgroundColor3 = c
                    local g = fill:FindFirstChild("FillGrad")
                    if g then
                        local dark = c:Lerp(Color3.new(0, 0, 0), 0.45)
                        local light = c:Lerp(Color3.new(1, 1, 1), 0.32)
                        g.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0.00, dark),
                            ColorSequenceKeypoint.new(0.40, c),
                            ColorSequenceKeypoint.new(0.72, light),
                            ColorSequenceKeypoint.new(1.00, dark),
                        })
                    end
                end
                task.wait(0.25)
            end
            if conn then conn:Disconnect() end
        end)

        pcall(applyStealBarRedGreen)
    _G.StealBar = {
            SetProgress = function(pct)
                pct = math.clamp(tonumber(pct) or 0, 0, 100)
                if progressFill then progressFill.Size = UDim2.new(pct / 100, 0, 1, 0) end
                if progressPct then progressPct.Text = math.floor(pct) .. "%" end
            end,
            Show = function(on)
                if grabBarGui then grabBarGui.Visible = on and true or false end
            end,
            IsVisible = function()
                return grabBarGui and grabBarGui.Visible
            end,
            SetLocked = function() end,
            IsLocked = function() return false end,
        }
    end

end -- buildGui

function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "SyeHubMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local BTN_W, BTN_H = 60, 60
    local buttons = {}
    -- Order: drop, autoLeft, aimbot, autoRight, tpDown, carrySpeed, laggerCarry, lagger
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger2", "Lagger1"}
    local buttonTexts = {"DROP", "AUTO\nLEFT", "AIMBOT", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPEED", "LAGGER\nCARRY", "LAGGER"}

    -- Christmas hat overlay on mobile panel (top of first column)
    local mobileHat = Instance.new("TextLabel", panel)
    mobileHat.Name = "MobileChristmasHat"
    mobileHat.Size = UDim2.fromOffset(40, 32)
    mobileHat.Position = UDim2.new(1, -70, 0.35, -40)
    mobileHat.BackgroundTransparency = 1
    mobileHat.Text = "🎅"
    mobileHat.TextSize = 28
    mobileHat.Font = Enum.Font.GothamBlack
    mobileHat.ZIndex = 50
    mobileHat.Visible = (christmasMode == true)
    mobileHat.Rotation = -15

    local function createButton(name, text, order, isToggle, callback)
        local btn = Instance.new("TextButton", panel)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.BackgroundColor3 = Color3.fromRGB(10,10,10)
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 10

        local savedPos = savedButtonPositions[name]
        if savedPos then
            if savedPos.XScale ~= nil or savedPos.YScale ~= nil then
                btn.Position = UDim2.new(
                    savedPos.XScale or 1,
                    savedPos.XOffset or savedPos.X or 0,
                    savedPos.YScale or 0.5,
                    savedPos.YOffset or savedPos.Y or 0
                )
            else
                btn.Position = getDefaultButtonPosition(name)
            end
        else
            btn.Position = getDefaultButtonPosition(name)
        end

        btn.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = mobileButtonCircleMode and UDim.new(1, 0) or UDim.new(0, 12)

        local bgGrad = Instance.new("UIGradient", btn)
        bgGrad.Name = "BtnGrad"
        bgGrad.Rotation = 90
        bgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(28, 28, 32)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(18, 18, 22)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(8, 8, 10)),
        })

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(120,120,128)
        stroke.Thickness = 1
        stroke.Transparency = 0.55
        stroke.Name = "NormalStroke"

        local label = Instance.new("TextLabel", btn)
        label.Name = "TextLabel"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(235, 235, 245)
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 11
        label.TextWrapped = true
        label.ZIndex = 11

        local uiScale = Instance.new("UIScale", btn)
        uiScale.Scale = floatingButtonScale
        table.insert(_floatingUIScales, uiScale)

        local active = false
        local function setActive(state)
            active = state
            btn:SetAttribute("MobActive", state and true or false)
            paintFloatingBtn(btn, state)
        end
        setActive(false)

        local dragging = false
        local hasMoved = false
        local dragStart = nil
        local startPos = nil
        local movedDistance = 0

        local function onInputBegan(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; hasMoved = false; movedDistance = 0
                dragStart = input.Position; startPos = btn.Position
                _isDraggingButton = true
                if name == "TpDown" and callback then
                    pcall(callback, setActive)
                end
            end
        end

        local function onInputChanged(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                movedDistance = delta.Magnitude
                if not uiLocked then
                    hasMoved = true
                    btn.Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + delta.X,
                        startPos.Y.Scale, startPos.Y.Offset + delta.Y
                    )
                end
            end
        end

        local function onInputEnded(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if movedDistance < 12 then
                        if name == "TpDown" then
                            -- already fired on InputBegan
                        elseif isToggle then
                            if callback then callback(setActive) end
                        else
                            if callback then callback(setActive, active) end
                        end
                    elseif not uiLocked and hasMoved then
                        savedButtonPositions[name] = {
                            XScale = btn.Position.X.Scale,
                            XOffset = btn.Position.X.Offset,
                            YScale = btn.Position.Y.Scale,
                            YOffset = btn.Position.Y.Offset,
                        }
                        task.defer(function() pcall(saveAllSettings) end)
                    end
                    dragging = false; hasMoved = false
                    dragStart = nil; startPos = nil; movedDistance = 0
                    _isDraggingButton = false
                end
            end
        end

        btn.InputBegan:Connect(onInputBegan)
        btn.InputChanged:Connect(onInputChanged)
        btn.InputEnded:Connect(onInputEnded)

        UIS.InputEnded:Connect(function(inp)
            if inp.UserInputType ~= Enum.UserInputType.Touch
               and inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            if dragging then onInputEnded(inp) end
        end)

        buttons[name] = {btn = btn, setActive = setActive, label = label}
        return setActive
    end

    for i, name in ipairs(buttonNames) do
        local text = buttonTexts[i]
        local callback
        if name == "DropBR" then
            callback = function(setActive)
                if autoBatEnabled then return end
                setActive(true)
                executeDropWithToggle(function(v)
                    if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end
                end)
                task.delay(0.3, function() setActive(false) end)
            end
        elseif name == "AutoLeft" then
            callback = function(setActive)
                autoLeftEnabled = not autoLeftEnabled
                setActive(autoLeftEnabled)
                if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
                if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
            end
        elseif name == "AutoBat" then
            callback = function(setActive)
                if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
                setActive(autoBatEnabled)
            end
        elseif name == "AutoRight" then
            callback = function(setActive)
                autoRightEnabled = not autoRightEnabled
                setActive(autoRightEnabled)
                if autoRightEnabled then startAutoRight() else stopAutoRight() end
                if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
            end
        elseif name == "TpDown" then
            callback = function(setActive)
                doTpDown()
                setActive(true)
                task.delay(0.04, function() setActive(false) end)
            end
        elseif name == "Carry" then
            callback = function(setActive)
                if not speedMode then
                    speedMode = true; laggerToggled = false; laggerCarryToggled = false; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    speedMode = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__ExoticHubApplySpeedNow then pcall(_G.__ExoticHubApplySpeedNow) end
            end
        elseif name == "Lagger1" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerToggled then
                    laggerToggled = true; laggerCarryToggled = false; setActive(true)
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    laggerToggled = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__ExoticHubApplySpeedNow then pcall(_G.__ExoticHubApplySpeedNow) end
            end
        elseif name == "Lagger2" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerCarryToggled then
                    laggerCarryToggled = true; laggerToggled = false; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                else
                    laggerToggled = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__ExoticHubApplySpeedNow then pcall(_G.__ExoticHubApplySpeedNow) end
            end
        end
        local setActive = createButton(name, text, i-1, true, callback)
        if name == "AutoBat" then mobSetAutoBat = setActive end
        if name == "AutoLeft" then mobSetAutoLeft = setActive end
        if name == "AutoRight" then mobSetAutoRight = setActive end
        if name == "DropBR" then mobSetDropBR = setActive end
        if name == "TpDown" then mobSetTpDown = setActive end
        if name == "Carry" then mobSetCarry = setActive end
        if name == "Lagger1" then mobSetLagger1 = setActive end
        if name == "Lagger2" then mobSetLagger2 = setActive end
    end

    if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled) end
    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerCarryToggled) end

    pcall(function() applyMobileButtonShape(mobileButtonCircleMode) end)
    pcall(function() if refreshMobileButtonsBackground then refreshMobileButtonsBackground() end end)
    return panel
end

function createTpBatFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "TpBatButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 21
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    if tpBatFloatingPos then
        btnFrame.Position = UDim2.new(
            tpBatFloatingPos.XScale or 1,
            tpBatFloatingPos.XOffset or -135,
            tpBatFloatingPos.YScale or 0.5,
            tpBatFloatingPos.YOffset or 215
        )
    else
        btnFrame.Position = getDefaultButtonPosition("TpBat")
    end
    btnFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 12)
    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(28, 28, 32)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(18, 18, 22)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(8, 8, 10)),
    })

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "TP\nBAT"
    label.TextColor3 = Color3.fromRGB(235, 235, 245)
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21

    local uiScale = Instance.new("UIScale", btnFrame)
    uiScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, uiScale)

    local function setActive(state)
        label.Text = "TP\nBAT"
        paintFloatingBtn(btnFrame, state)
    end

    local dragging = false; local hasMoved = false; local dragStart, startPos
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; hasMoved = false; dragStart = inp.Position; startPos = btnFrame.Position
        end
    end)
    btnFrame.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            if hasMoved and not uiLocked then
                btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    btnFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    toggleBatDesyncTp()
                    setActive(batDesyncTpEnabled)
                elseif not uiLocked and hasMoved then
                    tpBatFloatingPos = {XScale = btnFrame.Position.X.Scale, XOffset = btnFrame.Position.X.Offset, YScale = btnFrame.Position.Y.Scale, YOffset = btnFrame.Position.Y.Offset}
                    task.defer(function() pcall(saveAllSettings) end)
                end
                dragging = false; hasMoved = false
            end
        end
    end)

    tpBatFloatingButton = panel
    return panel
end

function createInstaResetFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "InstaResetButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 23
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    if instaResetFloatingPos then
        btnFrame.Position = UDim2.new(
            instaResetFloatingPos.XScale or 1,
            instaResetFloatingPos.XOffset or -12,
            instaResetFloatingPos.YScale or 0.5,
            instaResetFloatingPos.YOffset or 86
        )
    else
        btnFrame.Position = getDefaultButtonPosition("InstaReset")
    end
    btnFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 12)

    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(28, 28, 32)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(18, 18, 22)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(8, 8, 10)),
    })

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "RESET"
    label.TextColor3 = Color3.fromRGB(235, 235, 245)
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21

    local uiScale = Instance.new("UIScale", btnFrame)
    uiScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, uiScale)

    local dragging, hasMoved, dragStart, startPos, activeInput
    local RESET_TAP_THRESHOLD = 12

    local function pointInside(pos)
        local ap = btnFrame.AbsolutePosition
        local as = btnFrame.AbsoluteSize
        return pos.X >= ap.X and pos.X <= ap.X + as.X and pos.Y >= ap.Y and pos.Y <= ap.Y + as.Y
    end

    local function setActive(state)
        if state then
            TS:Create(btnFrame, TweenInfo.new(0.05), {BackgroundColor3 = Color3.fromRGB(40, 40, 48)}):Play()
            TS:Create(label, TweenInfo.new(0.05), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        else
            paintFloatingBtn(btnFrame, false)
        end
    end

    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if activeInput then return end
            activeInput = inp
            dragging = true; hasMoved = false
            dragStart = inp.Position; startPos = btnFrame.Position
        end
    end)

    UIS.InputChanged:Connect(function(inp)
        if not dragging or not activeInput then return end
        local isTouchMove = activeInput.UserInputType == Enum.UserInputType.Touch and inp == activeInput
        local isMouseMove = activeInput.UserInputType == Enum.UserInputType.MouseButton1 and inp.UserInputType == Enum.UserInputType.MouseMovement
        if not isTouchMove and not isMouseMove then return end
        local delta = inp.Position - dragStart
        if delta.Magnitude > RESET_TAP_THRESHOLD then hasMoved = true end
        if hasMoved and not uiLocked then
            btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UIS.InputEnded:Connect(function(inp)
        if inp ~= activeInput then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        if dragging then
            local delta = inp.Position - dragStart
            local validTap = not hasMoved and delta.Magnitude <= RESET_TAP_THRESHOLD and pointInside(inp.Position)
            if validTap then
                setActive(true)
                if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end
                task.delay(0.2, function() setActive(false) end)
            elseif not uiLocked and hasMoved then
                instaResetFloatingPos = {XScale = btnFrame.Position.X.Scale, XOffset = btnFrame.Position.X.Offset, YScale = btnFrame.Position.Y.Scale, YOffset = btnFrame.Position.Y.Offset}
                pcall(saveAllSettings)
            end
            dragging = false; hasMoved = false
            activeInput = nil
        end
    end)

    instaResetFloatingButton = panel
    return panel
end

batCounterV2Enabled = false
batCounterV2Debounce = false
batCounterV2Conn = nil
batCounterV2HitCooldown = false
BAT_COUNTER_V2_SWING_CD = 0.08
setBatCounterV2Visual = nil

_batCounterV2OriginalTpState = false
_batCounterV2SuppressCount = 0
_lastBatCounterV2Time = 0
_batCounterV2Cooldown = 0.01
_batCounterV2TpHoldActive = false
_batCounterV2TpHoldTarget = nil
_batCounterV2TpHoldConn = nil

function isPlayerRagdolled(player)
    if not player or not player.Character then return false end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local state = hum:GetState()
    return state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown
end

-- Keep TP Bat on until the target enemy is ragdolled (enemy ragdoll timer fires)
function _batCounterV2ReleaseTpBat()
    if _batCounterV2TpHoldConn then
        pcall(function() _batCounterV2TpHoldConn:Disconnect() end)
        _batCounterV2TpHoldConn = nil
    end
    _batCounterV2TpHoldActive = false
    _batCounterV2TpHoldTarget = nil
    -- Only turn TP Bat off if we were the ones who turned it on
    if not _batCounterV2OriginalTpState and batDesyncTpEnabled then
        stopBatDesyncTp()
        if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
        updateTpBatButtonWithAntiDie(false)
    end
end

function _batCounterV2HoldTpUntilEnemyRagdoll(targetPlayer)
    if _batCounterV2TpHoldConn then
        pcall(function() _batCounterV2TpHoldConn:Disconnect() end)
        _batCounterV2TpHoldConn = nil
    end
    _batCounterV2TpHoldActive = true
    _batCounterV2TpHoldTarget = targetPlayer
    local startedAt = os.clock()
    local MAX_HOLD = 4.0 -- safety timeout

    _batCounterV2TpHoldConn = RunService.Heartbeat:Connect(function()
        if not _batCounterV2TpHoldActive then
            if _batCounterV2TpHoldConn then
                pcall(function() _batCounterV2TpHoldConn:Disconnect() end)
                _batCounterV2TpHoldConn = nil
            end
            return
        end
        -- safety timeout
        if os.clock() - startedAt > MAX_HOLD then
            _batCounterV2ReleaseTpBat()
            return
        end
        local target = _batCounterV2TpHoldTarget
        if not target then
            _batCounterV2ReleaseTpBat()
            return
        end
        -- Enemy left / died
        local char = target.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum or hum.Health <= 0 then
            _batCounterV2ReleaseTpBat()
            return
        end
        -- Enemy ragdolled → enemy ragdoll timer will show; release TP Bat
        if isPlayerRagdolled(target) then
            _batCounterV2ReleaseTpBat()
            return
        end
        -- Also check RagdollEndTime attribute (matches enemy ragdoll timer logic)
        local endT = target:GetAttribute("RagdollEndTime")
            or char:GetAttribute("RagdollEndTime")
            or hum:GetAttribute("RagdollEndTime")
        if type(endT) == "number" and endT > workspace:GetServerTimeNow() then
            _batCounterV2ReleaseTpBat()
            return
        end
    end)
end

function hasAnimalEquipped(player)
    if not player or not player.Character then return false end
    for _, child in ipairs(player.Character:GetChildren()) do
        if child:IsA("Tool") then
            if child:FindFirstChild("Handle") or child.Name:find("Animal") or child.Name:find("Pet") then return true end
        end
    end
    return false
end

function getAttackingPlayerWithAnimal()
    local myChar = LP.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local closest, minDist = nil, _huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            if not hasAnimalEquipped(plr) then continue end
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - myRoot.Position).Magnitude
                if dist < 12 and dist < minDist then
                    minDist = dist; closest = plr
                end
            end
        end
    end
    return closest
end

function getBatV2Counter()
    local char = LP.Character
    if not char then return nil end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local name = child.Name:lower()
            if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then return child end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, child in ipairs(bp:GetChildren()) do
            if child:IsA("Tool") then
                local name = child.Name:lower()
                if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then
                    child.Parent = char
                    return child
                end
            end
        end
    end
    if bp then
        for _, child in ipairs(bp:GetChildren()) do
            if child:IsA("Tool") then child.Parent = char; return child end
        end
    end
    return nil
end

function tryHitBatCounterV2()
    if batCounterV2HitCooldown then return end
    batCounterV2HitCooldown = true
    pcall(function()
        local bat = getBatV2Counter()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(BAT_COUNTER_V2_SWING_CD, function() batCounterV2HitCooldown = false end)
end

-- Bat Counter V2 (original): when YOU are ragdolled/attacked by someone with an animal,
-- briefly enable TP Bat, teleport to them, and swing.
function executeBatCounterV2()
    local now = _tick()
    if now - (_lastBatCounterV2Time or 0) < (_batCounterV2Cooldown or 0.01) then return end
    if batCounterV2Debounce then return end
    batCounterV2Debounce = true
    _lastBatCounterV2Time = now
    local attacker = getAttackingPlayerWithAnimal()
    if not attacker then batCounterV2Debounce = false; return end
    if isPlayerRagdolled(attacker) then batCounterV2Debounce = false; return end
    if not hasAnimalEquipped(attacker) then batCounterV2Debounce = false; return end
    _batCounterV2OriginalTpState = batDesyncTpEnabled
    if not batDesyncTpEnabled then
        startBatDesyncTp()
        if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
        updateTpBatButtonWithAntiDie(true)
    end
    local function doCounterHit()
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local attChar = attacker.Character
        if not attChar then return end
        local attRoot = attChar:FindFirstChild("HumanoidRootPart")
        if not attRoot then return end
        if not hasAnimalEquipped(attacker) then batCounterV2Debounce = false; return end
        if sethiddenproperty then sethiddenproperty(hrp, "PhysicsRepRootPart", attRoot) end
        local targetPos = attRoot.Position + _V3new(0, 0.9, 0)
        if (hrp.Position - targetPos).Magnitude > 8 then hrp.CFrame = _CFnew(targetPos) end
        tryHitBatCounterV2()
        task.delay(0.05, function() tryHitBatCounterV2() end)
        task.delay(0.1, function() tryHitBatCounterV2() end)
    end
    doCounterHit()
    task.delay(0.2, function()
        if not _batCounterV2OriginalTpState and batDesyncTpEnabled then
            stopBatDesyncTp()
            if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
            updateTpBatButtonWithAntiDie(false)
        end
        batCounterV2Debounce = false
    end)
end

function stopBatCounterV2()
    if batCounterV2Conn then
        batCounterV2Conn:Disconnect()
        batCounterV2Conn = nil
    end
    batCounterV2Debounce = false
    batCounterV2HitCooldown = false
    if _batCounterV2ReleaseTpBat then pcall(_batCounterV2ReleaseTpBat) end
end

function startBatCounterV2()
    -- [HARDCODED FIX] always rebuild V2 counter loop
    batCounterV2Enabled = true
    if batCounterV2Conn then pcall(function() batCounterV2Conn:Disconnect() end); batCounterV2Conn = nil end
    batCounterV2Debounce = false
    batCounterV2HitCooldown = false
    batCounterV2Conn = RunService.Heartbeat:Connect(function()
        if not batCounterV2Enabled then return end
        if batCounterV2Debounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return end
        local state = humanoid:GetState()
        local isBeingAttacked = state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.GettingUp
            or state == Enum.HumanoidStateType.Stunned
        if isBeingAttacked then
            local attacker = getAttackingPlayerWithAnimal()
            if attacker and not isPlayerRagdolled(attacker) and hasAnimalEquipped(attacker) then
                executeBatCounterV2()
            end
        end
    end)
end

function toggleBatCounterV2()
    batCounterV2Enabled = not batCounterV2Enabled
    if batCounterV2Enabled then startBatCounterV2() else stopBatCounterV2() end
    return batCounterV2Enabled
end

function updateUIFromLoaded()
    task.wait()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if stealBarScaleBox then stealBarScaleBox.Text = tostring(stealBarScale) end
    if mbButtonsScaleBox then mbButtonsScaleBox.Text = tostring(math.floor((floatingButtonScale or 1) * 100 + 0.5)) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    refreshSpeedModeLabel()

    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end

    if savedProgressBarPos and pbFrame then
        pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -160, savedProgressBarPos.YScale or 0.80, savedProgressBarPos.YOffset or 0)
    end

    -- Restore background image + theme color (not just mode flag)
    if backgroundMode == "None" or backgroundIndex == 0 then
        pcall(applyBackgroundPreset, 2)
    elseif backgroundIndex and backgroundPresets[backgroundIndex] then
        pcall(applyBackgroundPreset, backgroundIndex)
    else
        pcall(applyBackgroundMode, backgroundMode)
        if currentColorTheme and COLOR_THEMES[currentColorTheme] then
            selectedColor = COLOR_THEMES[currentColorTheme]
            _lastThemeColor = nil
            pcall(updateAllUIThemeColors, selectedColor)
        end
    end
    applyFloatingButtonScale()
    if pbScale then pbScale.Scale = (stealBarScale or 70) / 100 end

    -- Restore Normal/Semi and Normal/Bypass slider positions
    if _G._exoticHubStealModeSetter then
        pcall(_G._exoticHubStealModeSetter, selectedStealMode == "V2" or selectedStealMode == "Semi")
    end
    if _G._exoticHubAimbotModeSetter then
        pcall(_G._exoticHubAimbotModeSetter, aimbotMode or "normal")
    end

    if setLockUIVisual then setLockUIVisual(uiLocked == true) end
    if setHideButtonsVisual then setHideButtonsVisual(not hideButtonsEnabled) end
    if setSafeModeVisual then setSafeModeVisual(safeModeEnabled == true) end
    if setE01TimerVisual then setE01TimerVisual(e01TimerEnabled == true) end
    if e01TimerEnabled and LP.Character then startRagTimerDetection(LP.Character) end
    if not e01TimerEnabled then stopRagTimerDetection() end

    if antiRagdollMode == "v2" then
        if setAntiRagVisual then setAntiRagVisual(antiRagdollMode == "v1" or antiRagdollMode == "v2") end
        startAntiRagdollV2()
    else
        if setAntiRagVisual then setAntiRagVisual(false) end
    end

    if antiDieEnabled then
        if setAntiDieVisual then setAntiDieVisual(true) end
        AntiDieModule.start()
    else
        if setAntiDieVisual then setAntiDieVisual(false) end
    end

    if antiBatEnabled then
        if setAntiBatVisual then setAntiBatVisual(true) end
        startAntiBat()
    else
        if setAntiBatVisual then setAntiBatVisual(false) end
    end

    if antiFlingEnabled then
        if setAntiFlingVisual then setAntiFlingVisual(true) end
        startAntiFling()
    else
        if setAntiFlingVisual then setAntiFlingVisual(false) end
        stopAntiFling()
    end

    if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then setInstaGrab(true); pcall(startAutoSteal) end

    if medusaCounterEnabled then
        if setMedusaVisual then setMedusaVisual(true) end
        if LP.Character then setupMedusaCounter(LP.Character) end
    else
        if setMedusaVisual then setMedusaVisual(false) end
        stopMedusaCounter()
    end

    if batCounterEnabled and setBatCounterVisual then
        setBatCounterVisual(true)
        startBatCounter()
    end
    if batCounterV2Enabled and setBatCounterV2Visual then
        setBatCounterV2Visual(true)
        startBatCounterV2()
    end
    if unwalkEnabled and setUnwalkVisual then
        setUnwalkVisual(true)
        task.spawn(function() task.wait(0.5); startUnwalk() end)
    end
    if antiLagEnabled then
        if setAntiLagVisual then setAntiLagVisual(true) end
        enableAntiLag()
    else
        if setAntiLagVisual then setAntiLagVisual(false) end
        disableAntiLag()
    end
    if espEnabled then
        toggleESP(true)
        if setESPVIsual then setESPVIsual(true) end
    else
        toggleESP(false)
        if setESPVIsual then setESPVIsual(false) end
    end
    if espLineEnabled then
        if setESPLineVisual then setESPLineVisual(true) end
        startESPLine()
    else
        if setESPLineVisual then setESPLineVisual(false) end
        stopESPLine()
    end

    if vividGraphicsEnabled then
        enableVividGraphics()
        if setVividVisual then setVividVisual(true) end
    else
        disableVividGraphics()
        if setVividVisual then setVividVisual(false) end
    end

    if fovEnabled then
        if setCustomFovVisual then setCustomFovVisual(true) end
        enableCustomFOV()
    else
        if setCustomFovVisual then setCustomFovVisual(false) end
    end
    if fovBox then fovBox.Text = tostring(fovValue or 70) end

    if batDesyncTpEnabled then
        if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
        if not batDesyncTpConn then startBatDesyncTp() end
        updateTpBatButtonWithAntiDie(true)
    else
        if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
        updateTpBatButtonWithAntiDie(false)
    end

    if stretchEnabled then
        enableStretch()
        if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    else
        if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    end

    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end

    if bodyLockEnabled and bodyLockSetVisual then
        if _blSuppressCount == 0 then
            bodyLockSetVisual(true)
            startBodyLock()
        else
            bodyLockSetVisual(false)
        end
    end
    if bodyLockRangeRow then bodyLockRangeRow.Visible = bodyLockEnabled == true end
    if setAutoCarryVisual then setAutoCarryVisual(autoCarryEnabled == true) end
    if setRagdollStealVisual then setRagdollStealVisual(ragdollStealEnabled == true) end
    if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled == true) end
    if setRagdollCounterVisual then setRagdollCounterVisual(antiRagdollMode == "v2" or ragdollCounterEnabled == true) end
    if setLowGraphicsVisual then setLowGraphicsVisual(lowGraphicsEnabled == true) end
    if lowGraphicsEnabled and not potatoGraphicsActive then pcall(enablePotatoGraphics) end
    if setMirrorTpVisual then setMirrorTpVisual(mirrorTpEnabled == true) end
    if setRagdollStealVisual then setRagdollStealVisual(ragdollStealEnabled == true) end

    updateProgressBarVisibility()
    startEnemySpeed()

    toggleLockUI(uiLocked)
    if setAutoTpDownVisual then setAutoTpDownVisual(_G._VynxAutoTPDownEnabled == true) end
    if autoTpHeightBox then autoTpHeightBox.Text = tostring(tonumber(_G._VynxAutoTPDownHeightTrigger) or 20) end
    if tpDownModeLabel then tpDownModeLabel.Text = (_G._VynxTPDownMode == "half") and "Half" or "Full" end

    pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
    if outfitSelectorLabel then outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label end
    if skinModeSelectorLabel then skinModeSelectorLabel.Text = skinChangerMode end
    if setSkinChangerVisual then setSkinChangerVisual(skinChangerEnabled) end
    if skinChangerEnabled then
        task.defer(function()
            task.wait(0.3)
            pcall(skinState.apply, true, LP.Character)
        end)
    end
end

-- =====================================================================
-- ARRANQUE BLINDADO
-- =====================================================================
_bootErrors = {}

function _bootSection(name, fn)
    print("[JK HUB Boot] Iniciando:", name)
    local ok, err = pcall(fn)
    if not ok then
        print("[JK HUB Boot] FALLÓ:", name, tostring(err))
        table.insert(_bootErrors, {name = name, err = tostring(err)})
        warn("[JK HUB Boot] Error en '" .. name .. "': " .. tostring(err))
    else
        print("[JK HUB Boot] OK:", name)
    end
    return ok
end

_bootSection("buildGui", function()
    buildGui()
end)

-- Intro handled by JK HUB gate at top — reveal UI
if gui and main then
    main.Visible = false
    if miniBtn then miniBtn.Visible = false end
    if MobilePanel then MobilePanel.Enabled = false end
    task.defer(function()
        task.wait(0.05)
        if showGui then
            pcall(showGui)
        elseif main then
            main.Visible = true
        end
        if MobilePanel then MobilePanel.Enabled = true end
    end)
end

_bootSection("applyDefaultTheme", function()
    -- Only default red if nothing is loaded yet; loadAllSettings will override
    if not currentColorTheme or currentColorTheme == "" then
        currentColorTheme = "Gray"
    end
    selectedColor = COLOR_THEMES[currentColorTheme] or COLOR_THEMES["Gray"]
    if updateAllUIThemeColors then updateAllUIThemeColors(selectedColor) end
end)

if gui and main then
    _bootSection("loadAllSettings", function()
        if loadAllSettings() then
            updateUIFromLoaded()
        end
        -- Restore saved theme + background (do NOT force red)
        task.defer(function()
            local idx = backgroundIndex
            if backgroundMode == "None" or idx == 0 then
                pcall(applyBackgroundPreset, 2)
            elseif idx and backgroundPresets[idx] then
                pcall(applyBackgroundPreset, idx)
            elseif currentColorTheme and COLOR_THEMES[currentColorTheme] then
                selectedColor = COLOR_THEMES[currentColorTheme]
                _lastThemeColor = nil
                _lastThemeUpdate = 0
                pcall(updateAllUIThemeColors, selectedColor)
            end
            -- Restore mode slider positions
            if _G._exoticHubAimbotModeSetter then
                pcall(_G._exoticHubAimbotModeSetter, aimbotMode or "normal")
            end
            if _G._exoticHubStealModeSetter then
                pcall(_G._exoticHubStealModeSetter, selectedStealMode == "V2" or selectedStealMode == "Semi")
            end
        end)
    end)

    _bootSection("createMobilePanel", function()
        MobilePanel = createMobilePanel()
        pcall(function() applyMobileButtonShape(mobileButtonCircleMode) end)
    end)

    _bootSection("createTpBatFloatingButton", function()
        tpBatFloatingButton = createTpBatFloatingButton()
    end)

    -- Insta Reset floating button removed from mobile/utility panel
    -- _bootSection("createInstaResetFloatingButton", function()
    --     instaResetFloatingButton = createInstaResetFloatingButton()
    -- end)
    instaResetFloatingButton = nil

    if hideButtonsEnabled then
        _bootSection("applyHideButtons", function()
            applyHideButtons(true)
            if setHideButtonsVisual then setHideButtonsVisual(true) end
        end)
    end

    _bootSection("localizeExoticHubInterface", function()
        if gui then localizeExoticHubInterface(gui) end
        if MobilePanel then localizeExoticHubInterface(MobilePanel) end
        if tpBatFloatingButton then localizeExoticHubInterface(tpBatFloatingButton) end
        if instaResetFloatingButton then localizeExoticHubInterface(instaResetFloatingButton) end
    end)

    if LP.Character then
        task.spawn(function()
            task.wait(0.1)
            if waitForCharReady(LP.Character, 5) then
                pcall(function() captureOriginalAppearance(LP.Character) end)
                pcall(function() setupMovementAndIndicators(LP.Character) end)
                if currentAnimPack ~= "Off" then
                    pcall(function() startAnimPack(currentAnimPack) end)
                end
                pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            end
        end)
    end

    if #_bootErrors > 0 then
        task.defer(function()
            pcall(function()
                local env = (getgenv and getgenv()) or _G
                local writeFn = env.writefile or (syn and syn.writefile)
                if type(writeFn) == "function" then
                    local log = "[Exotic Hub Boot Errors] " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
                    for _, e in ipairs(_bootErrors) do
                        log = log .. e.name .. ": " .. e.err .. "\n"
                    end
                    pcall(writeFn, "ExoticHub_boot_errors.txt", log)
                    warn("[JK HUB] Errores escritos a ExoticHub_boot_errors.txt")
                end
            end)
        end)

        task.defer(function()
            pcall(function()
                local errGui = Instance.new("ScreenGui")
                errGui.Name = "JKHubVSBootErrors"
                errGui.ResetOnSpawn = false
                errGui.DisplayOrder = 999
                local okCg, cg = pcall(function() return game:GetService("CoreGui") end)
                if okCg and cg then
                    pcall(function() errGui.Parent = cg end)
                end
                if not errGui.Parent then errGui.Parent = LP:WaitForChild("PlayerGui") end

                local frame = Instance.new("Frame", errGui)
                frame.Size = UDim2.new(0, 460, 0, 60 + #_bootErrors * 22)
                frame.Position = UDim2.new(0, 10, 1, -80 - #_bootErrors * 22)
                frame.BackgroundColor3 = Color3.fromRGB(40, 10, 15)
                frame.BorderSizePixel = 0
                Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
                local stroke = Instance.new("UIStroke", frame)
                stroke.Color = Color3.fromRGB(255, 80, 90)
                stroke.Thickness = 1.5

                local title = Instance.new("TextLabel", frame)
                title.Size = UDim2.new(1, -20, 0, 24)
                title.Position = UDim2.new(0, 10, 0, 8)
                title.BackgroundTransparency = 1
                title.Text = "⚠ JK HUB: " .. #_bootErrors .. " sección(es) fallaron"
                title.TextColor3 = Color3.fromRGB(255, 100, 110)
                title.Font = Enum.Font.GothamBold
                title.TextSize = 13
                title.TextXAlignment = Enum.TextXAlignment.Left

                for i, e in ipairs(_bootErrors) do
                    local lbl = Instance.new("TextLabel", frame)
                    lbl.Size = UDim2.new(1, -20, 0, 18)
                    lbl.Position = UDim2.new(0, 10, 0, 34 + (i - 1) * 20)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = "• " .. e.name .. ": " .. e.err:sub(1, 110)
                    lbl.TextColor3 = Color3.fromRGB(255, 180, 180)
                    lbl.Font = Enum.Font.Code
                    lbl.TextSize = 10
                    lbl.TextXAlignment = Enum.TextXAlignment.Left
                    lbl.TextTruncate = Enum.TextTruncate.AtEnd
                end

                local copyBtn = Instance.new("TextButton", frame)
                copyBtn.Size = UDim2.new(0, 100, 0, 22)
                copyBtn.Position = UDim2.new(0, 10, 1, -30)
                copyBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 30)
                copyBtn.Text = "COPIAR LOG"
                copyBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
                copyBtn.Font = Enum.Font.GothamBold
                copyBtn.TextSize = 11
                copyBtn.BorderSizePixel = 0
                Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)
                copyBtn.MouseButton1Click:Connect(function()
                    local buf = ""
                    for _, e in ipairs(_bootErrors) do
                        buf = buf .. e.name .. ": " .. e.err .. "\n"
                    end
                    pcall(function()
                        if setclipboard then setclipboard(buf) end
                    end)
                    copyBtn.Text = "¡COPIADO!"
                    task.delay(1.2, function() copyBtn.Text = "COPIAR LOG" end)
                end)

                local closeBtn = Instance.new("TextButton", frame)
                closeBtn.Size = UDim2.new(0, 60, 0, 22)
                closeBtn.Position = UDim2.new(1, -70, 1, -30)
                closeBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 30)
                closeBtn.Text = "CERRAR"
                closeBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
                closeBtn.Font = Enum.Font.GothamBold
                closeBtn.TextSize = 11
                closeBtn.BorderSizePixel = 0
                Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
                closeBtn.MouseButton1Click:Connect(function()
                    pcall(function() errGui:Destroy() end)
                end)

                task.delay(60, function()
                    pcall(function() errGui:Destroy() end)
                end)
            end)
        end)
    end
else
    warn("[JK HUB Boot] Fatal: buildGui falló. El script no puede continuar.")
end

if LP and LP.CharacterAdded then
    pcall(function()
        local _respawnQueue = 0
        LP.CharacterAdded:Connect(function(char)
            pcall(function()
                _respawnQueue = _respawnQueue + 1
                local myId = _respawnQueue

                if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
                isStealing = false
                if stopAutoLeft then stopAutoLeft() end
                if stopAutoRight then stopAutoRight() end
                if stopBatCounter then stopBatCounter() end
                if stopBatCounterV2 then stopBatCounterV2() end
                if stopMedusaCounter then stopMedusaCounter() end
                if not _tpBatUnwalkForced and stopUnwalk then stopUnwalk() end
                if stopDropBrainrot then stopDropBrainrot() end
                if autoBatEnabled and disableAutoBat then disableAutoBat() end
                if batDesyncTpEnabled and stopBatDesyncTp then stopBatDesyncTp() end
                if bodyLockEnabled and stopBodyLock then stopBodyLock() end

                local deadline = _tick() + 5
                while (not char.Parent) or (not char:FindFirstChild("HumanoidRootPart")) or (not char:FindFirstChildOfClass("Humanoid")) do
                    if _tick() > deadline then return end
                    if myId ~= _respawnQueue then return end
                    task.wait(0.05)
                end

                _hookedVelParts = {}
                local _hrpRespawn = _setupVelChecked(char)
                _hookVelHRP(_hrpRespawn)

                if not _originalAppearance then task.defer(function() captureOriginalAppearance(char) end) end
                if setupMovementAndIndicators then setupMovementAndIndicators(char) end
                if antiRagdollMode == "v2" then startAntiRagdollV2() end
                if antiBatEnabled then startAntiBat() end
                if antiFlingEnabled then startAntiFling() end
                if AntiDieModule.enabled then task.defer(function() activateOnCharacter(char) end) end
                if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end
                if batDesyncTpEnabled then task.defer(startBatDesyncTp) end
                if bodyLockEnabled and _blSuppressCount == 0 then startBodyLock() end

                if medusaCounterEnabled then
                    setupMedusaCounter(char)
                    if setMedusaVisual then setMedusaVisual(true) end
                else
                    stopMedusaCounter()
                    if setMedusaVisual then setMedusaVisual(false) end
                end

                if batCounterEnabled then startBatCounter() end
                if batCounterV2Enabled then startBatCounterV2() end
                if unwalkEnabled and not _tpBatUnwalkForced then startUnwalk() end
                -- [HARDCODED FIX] respawn animations
                if currentAnimPack and currentAnimPack ~= "Off" then
                    task.spawn(function()
                        task.wait(0.6)
                        if char and char.Parent then
                            pcall(function() char:WaitForChild("Animate", 10) end)
                            pcall(startAnimPack, currentAnimPack)
                        end
                    end)
                end

                updateProgressBarVisibility()
                refreshSpeedModeLabel()

                pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
                if outfitSelectorLabel then outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label end
                if skinChangerEnabled then
                    task.defer(function()
                        task.wait(0.4)
                        pcall(skinState.apply, true, char)
                    end)
                end
            end)
        end)
    end)
end

lastLaggerToggle = 0
LAGGER_COOLDOWN = 0.3

UIS.InputEnded:Connect(function(input)
    if not input or not input.KeyCode then return end
    if KB and KB.TPFloor and kbMatch(KB.TPFloor, input.KeyCode) then
        _tpDownKeyHeld = false
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if _anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or UIS:GetFocusedTextBox() then return end
    elseif not isGamepadInput(input) then
        return
    end
    if not isBindableInput(input) then return end

    local kc = input.KeyCode
    if not kc then return end

    if kbMatch(KB.LaggerMode, kc) then
        if _tick() - lastLaggerToggle >= LAGGER_COOLDOWN then
            lastLaggerToggle = _tick()
            toggleLaggerCycle()
            task.defer(function() pcall(saveAllSettings) end)
        end
        return
    end
    if kbMatch(KB.CarryToggle, kc) then
        toggleCarryMode()
        task.defer(function() pcall(saveAllSettings) end)
        return
    end
    if kbMatch(KB.DropBrainrot, kc) then
        if not dropActive then
            if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
            executeDropWithToggle(dropBrainrotSetVisual)
        end
        return
    end
    if kbMatch(KB.TPFloor, kc) then
        -- fire once per key press (InputBegan is already edge-triggered)
        if not _tpDownKeyHeld then
            _tpDownKeyHeld = true
            doTpDown()
        end
        return
    end
    if kbMatch(KB.InstaReset, kc) then
        if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end
        return
    end
    if kbMatch(KB.AutoLeft, kc) then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
        task.defer(function() pcall(saveAllSettings) end)
        return
    end
    if kbMatch(KB.AutoRight, kc) then
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
        task.defer(function() pcall(saveAllSettings) end)
        return
    end
    if kbMatch(KB.AutoBat, kc) then
        if not autoBatEnabled then
            enableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(true) end
            if mobSetAutoBat then mobSetAutoBat(true) end
        else
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        task.defer(function() pcall(saveAllSettings) end)
        return
    end
    if kbMatch(KB.TPBat, kc) then
        toggleBatDesyncTp()
        if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
        if tpBatFloatingButton then
            local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
            if btnFrame then paintFloatingBtn(btnFrame, batDesyncTpEnabled) end
        end
        task.defer(function() pcall(saveAllSettings) end)
        return
    end
    if kbMatch(KB.GuiHide, kc) then
        if main then
            if main.Visible then hideGui() else showGui() end
        end
        return
    end
end)



-- =====================================================================
-- SPEED BYPASS REMOVED
-- =====================================================================
_G.__SyeBypassEnabled = false
_G.__SyeBypassRunning = false
_G.__SyeBypassLaunch = function() end
_G.__SyeBypassToggleUI = function() end