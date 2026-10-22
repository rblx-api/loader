-- =====================================================================
--  skyr0 LOADER  (standalone)
-- ---------------------------------------------------------------------
--  Run it before the hub. It does NOT load the hub -- run the hub yourself.
--  1. FFlags -- fps unlock, low graphics, fast join / asset preload.
--
--  Settings (set before running):
--    getgenv().SKYR0_FFLAGS = false               -- skip the FFlags
-- =====================================================================
local env = (getgenv and getgenv()) or _G

-- ============================================================ FFLAGS
local fflags = {
    -- fps / scheduler
    ["DFIntTaskSchedulerTargetFps"] = "9999",
    ["FFlagTaskSchedulerLimitTargetFpsToDevice"] = "False",
    ["FFlagTaskSchedulerLimitTargetFpsTo2402"] = "False",
    ["FFlagGameBasicSettingsFramerateCap5"] = "False",
    ["FIntTaskSchedulerAutoThreadLimit"] = "8",
    ["DFIntTaskSchedulerJobInitThreads"] = "8",
    ["DFIntTaskSchedulerJobInGameThreads"] = "8",
    ["FIntRuntimeMaxNumOfThreads"] = "1000000",
    ["FIntSimWorldTaskQueueParallelTasks"] = "20",

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
    ["FFlagDebugRenderCollectGpuCounters"] = "True",
    ["FFlagRenderEnableHalfsPVR"] = "False",
    ["FFlagRenderFixFog"] = "True",
    ["FIntUnifiedLightingBlendZone"] = "0",
    ["FFlagFixTextureCompositorFramebufferManagement2"] = "True",
    ["FFlagDebugCheckRenderThreading"] = "True",
    ["FFlagDebugForceGenerateHSR"] = "True",
    ["FIntHSRClusterSymmetryDistancePercent"] = "10000",
    ["DFFlagOptimizeClusterCacheAlloc"] = "True",
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

    -- avatar
    ["DFFlagEnableAvatarOutfitCaching"] = "True",
    ["FFlagUserAvatarFetchOptimization"] = "True",
    ["DFIntAvatarOutfitCacheSize"] = "100",
    ["FFlagAvatarPipelineUseCache"] = "True",
    ["DFFlagLoadCharacterLayeredClothingProperty2"] = "False",
    ["DFFlagEnableDynamicHeadByDefault"] = "False",
    ["FFlagKeepZeroInfluenceBones"] = "False",
    ["FFlagDebugAvatarChatVisualization"] = "True",

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

    -- misc strings
    ["FFlagLoginPageOptimizedPngs"] = "True",
    ["FStringGetPlayerImageDefaultTimeout"] = "1",
    ["FStringVoiceBetaBadgeLearnMoreLink"] = "null",
    ["FStringGamesUrlPath"] = "/games/",

    -- undocumented (no prefix -- many setters reject these; failures are counted, not fatal)
    ["DebugLimitMinTextureResolutionWhenSkipMips"] = "2147483647",
    ["DoNotSkipMipsBasedOnSystemMemoryPS"] = "True",
    ["TM2SkipMipsForUnstreamable2"] = "True",
    ["RenderUseTextureManager224"] = "False",
    ["DebugTextureManagerSkipMips"] = "9",
    ["EnablePowerTraceModule"] = "True",
    ["IncludePowerSaverMode"] = "True",
    ["DebugFRMQualityLevelOverride"] = "1",

    -- fast start
    ["DFFlagLuaAppFastGameStartup"] = "True",
    ["FFlagFastLuaAppStartup"] = "True",
    ["FFlagAppShellAlwaysSkipExperienceLoadingScreen"] = "True",
    ["FFlagEnableQuickGameLaunch"] = "True",
    ["DFFlagEnableJoinDataDownloadOptimization"] = "True",
    ["FIntJoinDataAdditionalDataCacheTimeoutSeconds"] = "0",
    ["DFIntJoinDataCompressionLevel"] = "0",
    ["DFIntJoinDataItemEstimatedCompressionRatioHundreths"] = "0",
    ["DFIntServerFramesBetweenJoins"] = "1",
    ["DFIntClusterSenderMaxJoinBandwidthBps"] = "2100000000",
    ["DFIntClusterSenderMaxUpdateBandwidthBps"] = "2100000000",
    ["DFIntClusterCompressionLevel"] = "0",
    ["DFFlagAllowPropertyDefaultSkip"] = "True",
    ["FFlagSlimPropertySet3"] = "True",
    ["FFlagSlimService9"] = "True",

    -- asset loading
    ["FFlagEnableTextureStreaming"] = "True",
    ["FFlagPreloadAllFonts"] = "True",
    ["DFFlagEnableSoundPreloading"] = "True",
    ["DFFlagEnableMeshPreloading"] = "True",
    ["DFFlagEnableMeshPreloading2"] = "True",
    ["DFFlagEnableTexturePreloading"] = "True",
    ["DFIntAssetPreloading"] = "2147483647",
    ["DFIntNumAssetsMaxToPreload"] = "2147483647",
    ["FFlagAssetPreloadingIXP"] = "True",
    ["DFFlagEnablePreloadAvatarAssets"] = "True",
    ["DFIntPreloadAvatarAssets"] = "2147483647",
    ["DFFlagTeleportClientAssetPreloadingEnabledIXP"] = "True",
    ["DFFlagTeleportClientAssetPreloadingEnabledIXP2"] = "True",
    ["DFFlagTeleportClientAssetPreloadingEnabled9"] = "True",
    ["DFIntTeleportClientAssetPreloadingHundredthsPercentage"] = "100000",
    ["DFIntTeleportClientAssetPreloadingHundredthsPercentage2"] = "100000",
    ["DFFlagTeleportClientAssetPreloadingDoingExperiment"] = "True",
    ["DFFlagTeleportClientAssetPreloadingDoingExperiment2"] = "True",
    ["DFFlagTeleportPreloadingMetrics5"] = "True",
    ["DFFlagPreloadAsyncSupportTexturePack"] = "True",
    ["FFlagPreloadTextureItemsOption4"] = "True",
    ["FFlagUseNewLuaPreloadAssets"] = "True",
    ["DFFlagEnableScriptPreloadOnJoin"] = "True",
    ["FFlagLuaAppsScriptPreload"] = "True",
    ["DFFlagRemoveUnusedKtxMetadata"] = "True",
    ["FFlagKtx2Support3"] = "True",
    ["FFlagSlimContentProvider"] = "True",

    -- lazy menus
    ["FFlagDeferredUILoading"] = "True",
    ["DFFlagLazyLoadInGameMenu"] = "True",
    ["FFlagLuaMenuPerfImprovements"] = "True",
    ["FFlagEnableInGameMenuChrome"] = "False",
    ["FFlagEnableInGameMenuChromeABTest2"] = "False",
    ["FFlagEnableInGameMenuDurationLogger"] = "False",
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
    if not setter then
        warn("[skyr0 loader] no setfflag in this executor -- FFlags skipped")
        return
    end
    local applied, failed = 0, 0
    for name, value in pairs(fflags) do
        if pcall(setter, name, value) then applied += 1 else failed += 1 end
    end
    print(("[skyr0 loader] FFlags applied: %d, failed: %d"):format(applied, failed))
end

-- ============================================================ GO
-- FFlags right now, before anything else runs (a few hundred cheap calls)
if env.SKYR0_FFLAGS ~= false then pcall(applyFFlags) end
pcall(function() if setfpscap then setfpscap(999) end end)