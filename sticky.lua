if _G.StickyFrontTP == nil then _G.StickyFrontTP = false end
if _G.StickySideTP == nil then _G.StickySideTP = true end
if _G.StickySideTPRange == nil then _G.StickySideTPRange = 100 end
_G.StickyStealPrioKey = _G.StickyStealPrioKey or "P"
_G.StickyStealNearKey = _G.StickyStealNearKey or "F"
if _G.StickyCFrameGoTo == nil then _G.StickyCFrameGoTo = false end
_G.StickyNoCollide = true
if _G.StickyNoCollideConstraints == nil then _G.StickyNoCollideConstraints = true end

_G.StickyCFrameGoSpeed = tonumber(_G.StickyCFrameGoSpeed) or 35
if _G.StickyTPTrail == nil then _G.StickyTPTrail = false end
if _G.StickyHybridTP == nil then _G.StickyHybridTP = false end
_G.StickyDropKeyName = _G.StickyDropKeyName or "B"
_G.StickyResetKeyName = _G.StickyResetKeyName or "X"
_G.StickyInvisKeyName = _G.StickyInvisKeyName or "U"
_G.StickyCloneKeyName = _G.StickyCloneKeyName or "V"
_G.StickyCarpetSpeedKeyName = _G.StickyCarpetSpeedKeyName or "Q"
_G.StickyNearestKey = _G.StickyNearestKey or "F"
_G.StickyStealQuickKey = _G.StickyStealQuickKey or "C"
_G.StickyStopTPKeyName = _G.StickyStopTPKeyName or "N"
_G.StickyKickKeyName = _G.StickyKickKeyName or "K"
_G._stp_tpKeyName = _G._stp_tpKeyName or "T"
do
    local POS_FILE = "StickyPanelPositions.json"
    local HttpService = game:GetService("HttpService")

    local saved = {}
    pcall(function()
        if type(readfile) ~= "function" then return end
        if type(isfile) == "function" and not isfile(POS_FILE) then return end
        local raw = readfile(POS_FILE)
        if type(raw) == "string" and #raw > 0 then
            local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
            if ok and type(data) == "table" then saved = data end
        end
    end)

    local lastChange, writePending = 0, false
    local function queueWrite()
        lastChange = os.clock()
        if writePending then return end
        writePending = true
        task.spawn(function()
            while os.clock() - lastChange < 0.5 do task.wait(0.1) end
            writePending = false
            if type(writefile) ~= "function" then return end
            pcall(function() writefile(POS_FILE, HttpService:JSONEncode(saved)) end)
        end)
    end

    local function clampOnScreen(frame)
        if not frame or not frame.Parent then return end
        local sg = frame:FindFirstAncestorOfClass("ScreenGui")
        local screen = sg and sg.AbsoluteSize
        if not screen or screen.X < 50 or screen.Y < 50 then return end
        local pos, size = frame.AbsolutePosition, frame.AbsoluteSize
        if size.X <= 0 or size.Y <= 0 then return end
        local margin = 4
        local maxX = math.max(screen.X - size.X - margin, margin)
        local maxY = math.max(screen.Y - size.Y - margin, margin)
        local dx = (pos.X < margin and margin - pos.X) or (pos.X > maxX and maxX - pos.X) or 0
        local dy = (pos.Y < margin and margin - pos.Y) or (pos.Y > maxY and maxY - pos.Y) or 0
        if math.abs(dx) >= 1 or math.abs(dy) >= 1 then
            local p = frame.Position
            frame.Position = UDim2.new(p.X.Scale, p.X.Offset + math.floor(dx + 0.5), p.Y.Scale, p.Y.Offset + math.floor(dy + 0.5))
        end
    end
    _G.StickyClampPanel = clampOnScreen

    local registered = setmetatable({}, { __mode = "k" })
    _G.StickyRememberPanel = function(frame, key)
        if typeof(frame) ~= "Instance" or not frame:IsA("GuiObject") or type(key) ~= "string" then return end
        if registered[frame] then return end
        registered[frame] = key
        local entry = saved[key]
        if type(entry) == "table" and tonumber(entry.xo) and tonumber(entry.yo) then
            pcall(function()
                frame.Position = UDim2.new(tonumber(entry.xs) or 0, tonumber(entry.xo), tonumber(entry.ys) or 0, tonumber(entry.yo))
            end)
        end
        frame:GetPropertyChangedSignal("Position"):Connect(function()
            if not frame.Parent then return end
            local p = frame.Position
            saved[key] = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset }
            queueWrite()
        end)
        local function clampSoon() task.defer(function() pcall(clampOnScreen, frame) end) end
        task.delay(0.25, function() pcall(clampOnScreen, frame) end)
        frame:GetPropertyChangedSignal("Visible"):Connect(function() if frame.Visible then clampSoon() end end)
        local sg = frame:FindFirstAncestorOfClass("ScreenGui")
        if sg then
            sg:GetPropertyChangedSignal("AbsoluteSize"):Connect(clampSoon)
            sg:GetPropertyChangedSignal("Enabled"):Connect(function() if sg.Enabled then clampSoon() end end)
        end
    end

end
	do
		if _G.StickyXrayAlpha == nil then _G.StickyXrayAlpha = 0.5 end
		local xrayOriginal = setmetatable({}, { __mode = "k" })
		local xrayConns = {}
		local xrayLoopId = 0
		local function xrayAlpha()
			return math.clamp(tonumber(_G.StickyXrayAlpha) or 0.5, 0.05, 0.95)
		end
		local XRAY_FOLDERS = { "Base", "PlotSign", "FriendPanel", "Cash", "Laser", "Decorations", "Skin", "Unlock", "Purchases" }
		local function setTransparency(instance, alpha, loopId)
			if not instance or loopId ~= xrayLoopId then return end
			local function apply(obj)
				if not obj:IsA("BasePart") then return end
				if xrayOriginal[obj] == nil then
					xrayOriginal[obj] = (obj.Transparency == alpha) and 0 or obj.Transparency
				end
				local orig = xrayOriginal[obj]
				if orig < 1 then
					local target = orig + (1 - orig) * alpha
					if math.abs(obj.Transparency - target) > 0.01 then obj.Transparency = target end
				end
			end
			apply(instance)
			for i, child in ipairs(instance:GetDescendants()) do
				apply(child)
				if i % 400 == 0 then
					if loopId ~= xrayLoopId then return end
				end
			end
		end
		local function trackSubtree(root, alpha, loopId)
			if not root or loopId ~= xrayLoopId then return end
			setTransparency(root, alpha, loopId)
			xrayConns[#xrayConns + 1] = root.DescendantAdded:Connect(function(obj)
				if loopId == xrayLoopId then setTransparency(obj, alpha, loopId) end
			end)
		end
		local function processPlot(plot, alpha, loopId)
			if not plot or loopId ~= xrayLoopId then return end
			for _, fname in ipairs(XRAY_FOLDERS) do
				trackSubtree(plot:FindFirstChild(fname), alpha, loopId)
			end
			xrayConns[#xrayConns + 1] = plot.ChildAdded:Connect(function(child)
				if loopId ~= xrayLoopId then return end
				for _, fname in ipairs(XRAY_FOLDERS) do
					if child.Name == fname then trackSubtree(child, alpha, loopId); break end
				end
			end)
			local podiums = plot:FindFirstChild("AnimalPodiums")
			if not podiums then return end
			local function processPodium(podium)
				for _, child in ipairs(podium:GetChildren()) do
					if child.Name == "Claim" then
						trackSubtree(child, alpha, loopId)
					elseif child.Name == "Base" then
						trackSubtree(child:FindFirstChild("Decorations"), alpha, loopId)
					elseif child:IsA("Model") and child.Name ~= "Decorations" then
						trackSubtree(child, alpha, loopId)
					end
				end
			end
			for _, podium in ipairs(podiums:GetChildren()) do processPodium(podium) end
			xrayConns[#xrayConns + 1] = podiums.ChildAdded:Connect(function(podium)
				if loopId == xrayLoopId then processPodium(podium) end
			end)
		end
		local function enableXray()
			for _, c in ipairs(xrayConns) do
				if typeof(c) == "RBXScriptConnection" then pcall(function() c:Disconnect() end) end
			end
			xrayConns = {}
			xrayLoopId = xrayLoopId + 1
			local id = xrayLoopId
			local plotsFolder = workspace:FindFirstChild("Plots")
			if not plotsFolder then return end
			for _, plot in ipairs(plotsFolder:GetChildren()) do
				if id ~= xrayLoopId then return end
				processPlot(plot, xrayAlpha(), id)
			end
			xrayConns[#xrayConns + 1] = plotsFolder.ChildAdded:Connect(function(plot)
				if id == xrayLoopId then processPlot(plot, xrayAlpha(), id) end
			end)
		end
		local function disableXray()
			for _, c in ipairs(xrayConns) do
				if typeof(c) == "RBXScriptConnection" then pcall(function() c:Disconnect() end) end
			end
			xrayConns = {}
			xrayLoopId = xrayLoopId + 1
			local snapshot = xrayOriginal
			xrayOriginal = setmetatable({}, { __mode = "k" })
			for obj, orig in pairs(snapshot) do
				pcall(function() if obj:IsA("BasePart") then obj.Transparency = orig end end)
			end
		end
		_G.StickyEnableXray = enableXray
		_G.StickyDisableXray = disableXray
		local function plotsWorldReady()
			local plotsFolder = workspace:FindFirstChild("Plots")
			if not plotsFolder then return false end
			local n = 0
			pcall(function() n = #plotsFolder:GetChildren() end)
			return n > 0
		end
		local function applyXrayIfEnabled()
			if _G.StickyXray ~= true then return false end
			if not plotsWorldReady() then return false end
			enableXray()
			return true
		end
		local xrayRetrying = false
		local function startXrayRetry()
			if _G.StickyXray ~= true then return end
			if xrayRetrying then return end
			xrayRetrying = true
			task.spawn(function()
				local waitMax = tonumber(_G.StickyXrayWaitMax) or 90
				local t0 = os.clock()
				local childConn
				childConn = workspace.ChildAdded:Connect(function(ch)
					if ch.Name == "Plots" and _G.StickyXray == true then
						task.defer(function()
							if plotsWorldReady() then applyXrayIfEnabled() end
						end)
					end
				end)
				while _G.StickyXray == true and (os.clock() - t0) < waitMax do
					if applyXrayIfEnabled() then break end
					task.wait(0.15)
				end
				if childConn then pcall(function() childConn:Disconnect() end) end
				xrayRetrying = false
			end)
		end
		_G.StickyApplyXrayIfEnabled = applyXrayIfEnabled
		_G.StickyStartXrayRetry = startXrayRetry
	end

local fflags = {
    ["DFIntTaskSchedulerTargetFps"] = "9999",
    ["FFlagTaskSchedulerLimitTargetFpsToDevice"] = "False",
    ["FFlagTaskSchedulerLimitTargetFpsTo2402"] = "False",
    ["FFlagGameBasicSettingsFramerateCap5"] = "False",
    ["FIntTaskSchedulerAutoThreadLimit"] = "8",
    ["DFIntTaskSchedulerJobInitThreads"] = "8",
    ["DFIntTaskSchedulerJobInGameThreads"] = "8",
    ["FIntRuntimeMaxNumOfThreads"] = "1000000",
    ["DFIntRuntimeConcurrency"] = "16",
    ["FIntRuntimeMaxNumOfMutexes"] = "1000000",
    ["FIntRuntimeMaxNumOfSemaphores"] = "1000000",
    ["FIntRuntimeMaxNumOfLatches"] = "1000000",
    ["FIntSimWorldTaskQueueParallelTasks"] = "20",

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

    ["DFIntMaxConcurrentDownloads"] = "64",
    ["FIntContentProviderConcurrentDownloadCount"] = "64",
    ["DFIntContentProviderTaskMaxCount"] = "64",
    ["DFIntHttpsTimeoutScaleNumerator"] = "1",
    ["DFFlagEnableRequestAsyncCompression"] = "false",
    ["DFFlagNetworkUseZstdWrapper"] = "False",

    ["FFlagEnableTextureStreamingForCSG"] = "True",
    ["DFFlagTextureStreamingPrefetchEnabled"] = "True",
    ["DFIntTextureStreamingPrefetchMaxRadius"] = "0",
    ["FFlagAdjustableTextureStreamingTargetMemory"] = "True",
    ["DFIntTextureStreamingTargetMemoryBudgetMb"] = "512",
    ["FFlagTM2SkipMipsForUnstreamable2"] = "True",
    ["DFFlagDoNotSkipMipsBasedOnSystemMemoryPS"] = "True",
    ["FIntDebugTextureManagerSkipMips"] = "8",
    ["DFIntDebugLimitMinTextureResolutionWhenSkipMips"] = "8",
    ["DFFlagTextureQualityOverrideEnabled"] = "True",
    ["DFIntTextureQualityOverride"] = "0",
    ["FFlagRenderUseTextureManager224"] = "False",

    ["DFFlagEnableAvatarOutfitCaching"] = "True",
    ["FFlagUserAvatarFetchOptimization"] = "True",
    ["DFIntAvatarOutfitCacheSize"] = "100",
    ["FFlagAvatarPipelineUseCache"] = "True",
    ["DFFlagLoadCharacterLayeredClothingProperty2"] = "False",
    ["DFFlagEnableDynamicHeadByDefault"] = "False",
    ["FFlagKeepZeroInfluenceBones"] = "False",

    ["FFlagDeferredUILoading"] = "True",
    ["DFFlagLazyLoadInGameMenu"] = "True",
    ["FFlagLuaMenuPerfImprovements"] = "True",
    ["FFlagFixIGMTabTransitions"] = "True",
    ["FFlagEnableInGameMenuChrome"] = "False",
    ["FFlagEnableInGameMenuChromeABTest2"] = "False",
    ["FFlagEnableInGameMenuDurationLogger"] = "False",

    ["DFIntReplicatorSeparateVarThresholds"] = "True",
    ["DFIntNetworkClusterPacketCacheNumParallelTasks"] = "8",
    ["DFIntReplicationDataCacheNumParallelTasks"] = "8",
    ["DFIntMegaReplicatorNumParallelTasks"] = "19",
    ["DFIntMegaReplicatorNetworkQualityProcessorUnit"] = "10",
    ["FFlagNextGenReplicatorEnabledRead"] = "true",
    ["FFlagNextGenReplicatorEnabledRead2"] = "True",
    ["FFlagNextGenReplicatorEnabledWrite"] = "true",
    ["FFlagNextGenReplicatorEnabledWrite2"] = "True",
    ["FFlagDebugNextGenReplicatorEnabledWriteCFrameColor"] = "true",
    ["DFFlagNextGenRepRollbackOverbudgetPackets"] = "True",
    ["DFFlagCorrectServerReplicatorStatsIP"] = "True",
    ["DFFlagDebugLargeReplicatorDisableCompression"] = "True",
    ["DFFlagDebugLargeReplicatorForceFullSend"] = "True",
    ["FFlagDebugLargeReplicatorEnabled"] = "True",
    ["FFlagDebugLargeReplicatorWrite"] = "True",
    ["FFlagDebugLargeReplicatorRead"] = "True",
    ["DFFlagReplicatorCheckReadTableCollisions"] = "True",
    ["FFlagOnlyDecrementCompletenessIfReplicating"] = "True",
    ["DFFlagCanClientReplicateProp"] = "False",
    ["DFIntNetworkCluster"] = "1",
    ["DFIntNetworkQualityResponderUnit"] = "10",
    ["DFIntPlayerNetworkUpdateQueueSize"] = "20",
    ["DFIntMaxProcessPacketsStepsPerCyclic"] = "5000",
    ["DFIntMaxProcessPacketsStepsAccumulated"] = "0",
    ["DFIntMaxFrameBufferSize"] = "4",
    ["DFIntOverrideISRReplicatorStepBandwidthBytes"] = "131072",
    ["DFIntServerBandwidthPlayerSampleRateFacsOverride"] = "2147483647",
    ["DFIntGameNetCompressionLodByteBudgetThresholdPct"] = "0",
    ["DFIntBufferCompressionThreshold"] = "100",

    ["DFFlagRakNetDecoupleRecvAndUpdateLoopShutdown"] = "True",
    ["DFFlagRakNetDetectNetUnreachable"] = "True",
    ["DFFlagRakNetDetectRecvThreadOverload"] = "True",
    ["DFFlagRakNetUnblockSelectOnShutdownByWritingToSocket"] = "True",
    ["DFFlagRakNetDisconnectNotification"] = "True",
    ["DFFlagRakNetCalculateApplicationFeedback2"] = "True",
    ["DFFlagSampleAndRefreshRakPing"] = "True",
    ["DFIntRakNetLoopMs"] = "1",
    ["DFIntRakNetSelectTimeoutMs"] = "1",
    ["DFIntRakNetApplicationFeedbackScaleUpThresholdPercent"] = "0",
    ["DFIntRakNetApplicationFeedbackScaleUpFactorHundredthPercent"] = "0",
    ["DFIntRakNetApplicationFeedbackMaxSpeedBPS"] = "0",
    ["DFIntRakNetNakResendDelayMsMax"] = "1",
    ["DFIntRakNetClockDriftAdjustmentPerPingMillisecond"] = "100",
    ["DFIntRaknetBandwidthInfluxHundredthsPercentageV2"] = "10000",
    ["DFIntSendRakNetStatsInterval"] = "2147483647",
    ["DFIntClientPacketExcessMicroseconds"] = "1000",
    ["DFIntClientPacketMaxDelayMs"] = "1",
    ["DFIntClientPacketMaxFrameMicroseconds"] = "200",
    ["DFIntTargetTimeDelayFacctorTenths"] = "25",
    ["DFIntWaitOnUpdateNetworkLoopEndedMS"] = "100",
    ["DFIntWaitOnRecvFromLoopEndedMS"] = "10",

    ["DFIntSignalRCoreError"] = "1",
    ["DFIntSignalRCore"] = "1",
    ["DFIntSignalRCoreTimerMs"] = "50",
    ["DFIntSignalRCoreRpcQueueSize"] = "4096",
    ["DFIntSignalRCoreNetworkHandler"] = "1",
    ["DFIntSignalRCoreHubConnectionDisconnectInfoHundredthsPercent"] = "10",
    ["DFIntSignalRCoreHandshakeTimeoutMs"] = "1000",
    ["DFIntSignalRCoreServerTimeoutMs"] = "5000",
    ["DFIntSignalRCoreKeepAlivePingPeriodMs"] = "1000",
    ["DFIntSignalRCoreHubMaxBackoffMs"] = "500",
    ["DFIntSignalRCoreHubBaseRetryMs"] = "50",
    ["DFIntSignalRHeartbeatIntervalSeconds"] = "1",
    ["DFIntSignalRHubConnectionConnectTimeoutMs"] = "7000",
    ["DFIntSignalRHubConnectionBaseRetryTimeMs"] = "50",
    ["DFIntSignalRHubConnectionMaxRetryTimeMs"] = "1000",
    ["DFIntSignalRHubConnectionHeartbeatTimerRateMs"] = "1000",

    ["FFlagLuauCodegen"] = "True",
    ["FFlagLuauCodegenFull"] = "True",
    ["FFlagLuauCodegenEnableAll"] = "True",
    ["FFlagLuauInstructionReordering"] = "True",
    ["FFlagLuauVector3FastPath"] = "True",
    ["FFlagDebugCodegenOptSize"] = "True",
    ["FFlagFasterPreciseTime4"] = "True",
    ["FFlagSortKeyOptimization"] = "True",
    ["FFlagMessageBusCallOptimization"] = "True",
    ["FFlagPushFrameTimeToHarmony"] = "True",
    ["FFlagRenderCBRefactor2"] = "True",

    ["FIntDebugForceMSAASamples"] = "0",
    ["FIntDebugFRMOptionalMSAALevelOverride"] = "0",
    ["DFIntDebugFRMQualityLevelOverride"] = "0",
    ["FFlagDisablePostProcess"] = "True",
    ["FFlagDisablePostFx"] = "True",
    ["DFFlagRenderBloomMakeResolutionIndependent"] = "False",
    ["DFFlagRenderSunRaysMakeResolutionIndependent"] = "False",
    ["FFlagDisableHQShadersLowEndDx112"] = "True",
    ["FFlagGraphicsCheckComputeSupport"] = "False",
    ["FFlagGraphicsEnableD3D10Compute"] = "True",
    ["FFlagDebugGraphicsPreferD3D11"] = "True",
    ["FFlagDebugGraphicsPreferD3D11FL10"] = "True",
    ["FFlagDebugGraphicsDisableDirect3D11"] = "False",
    ["FFlagHandleAltEnterFullscreenManually"] = "False",
    ["FIntFullscreenTitleBarTriggerDelayMillis"] = "3600000",
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
    ["FFlagDebugDisplayFPS"] = "True",
    ["FIntSSAOMipLevels"] = "0",
    ["FIntRenderShadowIntensity"] = "0",
    ["FIntRenderShadowmapBias"] = "0",
    ["FIntRenderLocalLightUpdatesMax"] = "1",
    ["FIntRenderLocalLightFadeInMs"] = "0",
    ["FFlagDebugRenderCollectGpuCounters"] = "True",
    ["FFlagFixGraphicsQuality"] = "True",
    ["FFlagCommitToGraphicsQualityFix"] = "True",
    ["FFlagRenderEnableHalfsPVR"] = "False",
    ["FFlagEnableAudioPannerFiltering"] = "True",
    ["FFlagRenderFixFog"] = "true",

    ["DFIntCSGLevelOfDetailSwitchingDistanceL23"] = "0",
    ["DFIntCSGLevelOfDetailSwitchingDistanceL34"] = "0",
    ["DFIntCSGLevelOfDetailSwitchingDistanceL12"] = "0",
    ["DFIntCSGLevelOfDetailSwitchingDistance"] = "0",
    ["DFIntCSGLevelOfDetailSwitchingDistanceStatic"] = "0",
    ["DFIntHACDPointSampleDistApartTenths"] = "2147483647",
    ["DFFlagDebugSkipMeshVoxelizer"] = "True",
    ["FFlagSimCSGV3IncrementalTriangulationStreamingCompression"] = "False",
    ["FFlagSortPhysicsCollisionGroups"] = "True",
    ["FFlagOptimizePhysCollide"] = "True",
    ["FFlagNewOptimizeNoCollisionPrimitiveInMidphase660"] = "True",
    ["DFFlagOptimizeNoCollisionPrimitiveInMidphaseCrash"] = "True",
    ["DFFlagJointIrregularityOptimization"] = "true",

    ["FFlagEnableTerrainMaterialsS2"] = "False",
    ["FIntTerrainArraySliceSize"] = "0",
    ["FIntRenderGrassHeightScalar"] = "0",
    ["FIntFRMMinGrassDistance"] = "0",
    ["FIntGrassMovementReducedMotionFactor"] = "0",
    ["FFlagGlobalWindRendering"] = "False",
    ["FFlagGlobalWindActivated"] = "False",
    ["FStringTerrainMaterialTable2022"] = "",
    ["FStringTerrainMaterialTablePre2022"] = "",
    ["FStringPartTexturePackTablePre2022"] = "",
    ["DFFlagDebugRenderForceTechnologyVoxel"] = "True",

    ["FFlagEnablePerformanceControlService"] = "True",
    ["DFFlagPerformanceControlEnableMemoryProbing3"] = "True",
    ["DFIntPerformanceControlFrameTimeMaxUtility"] = "-1",
    ["DFIntPerformanceControlFrameTimeMax"] = "1",
    ["DFIntPerformanceControlTextureQualityBestUtility"] = "-1",
    ["DFIntPerformanceControlReportingPeriodInMs"] = "700",
    ["DFIntNumFramesAllowedToBeAboveError"] = "1",
    ["DFIntMaxAverageFrameDelayExceedFactor"] = "1",
    ["DFIntGraphicsOptimizationModeMaxFrameTimeTargetMs"] = "25",
    ["DFIntFrameRateMSToReduceTouchEvents"] = "30",
    ["DFFlagDebugPerfMode"] = "True",
    ["DFIntMemoryUtilityCurveTotalMemoryReserve"] = "0",
    ["DFIntMemoryUtilityCurveNumSegments"] = "100",
    ["DFIntMemoryUtilityCurveBaseHundrethsPercent"] = "10000",
    ["DFIntMaxSpeedDeltaMillis"] = "1",
    ["FIntMaxSpeedDeltaMillis"] = "1",

    ["FFlagDisableTelemetryOnJoin"] = "True",
    ["DFFlagDeferTelemetryUntilAfterLoad"] = "True",
    ["FFlagDebugDisableTelemetryV2Event"] = "True",
    ["FFlagDebugDisableTelemetryV2Stat"] = "True",
    ["FFlagDebugDisableTelemetryPoint"] = "True",
    ["FFlagEnableTelemetryProtocol"] = "False",
    ["FFlagEnableTelemetryService1"] = "False",
    ["FFlagOpenTelemetryEnabled2"] = "False",
    ["FFlagEnableTelemetryServicePlaySessionInfo"] = "False",
    ["FFlagEnableTelemetryServiceMemoryCPUInfo"] = "False",
    ["DFFlagGraphicsQualityUsageTelemetry"] = "False",
    ["DFFlagReportAssetRequestV1Telemetry"] = "False",
    ["DFFlagAddMachineIDInstallerTelemetry"] = "False",
    ["DFFlagRccLoadSoundLengthTelemetryEnabled"] = "False",
    ["DFFlagBrowserTrackerIdTelemetryEnabled"] = "False",
    ["DFFlagAudioDeviceTelemetry"] = "False",
    ["DFFlagAddPlaySessionIdTelemetry"] = "False",
    ["DFFlagAddPlaySessionIdToSimConstraintTelemetryEvent"] = "False",
    ["DFFlagAddUserIdToSessionTracking"] = "False",
    ["DFIntLightstepHTTPTransportHundredthsPercent2"] = "0",
    ["DFFlagEnableLightstepReporting2"] = "False",
    ["DFIntPhysicsAnalyticsHighFrequencyIntervalSec"] = "20",
    ["DFIntClientLightingTechnologyChangedTelemetryHundredthsPercent"] = "0",
    ["DFIntContentProviderPreloadHangTelemetryHundredthsPercentage"] = "0",
    ["DFIntTrackCountryRegionAPIHundredthsPercent"] = "10000",
    ["DFIntVisibilityCheckRayCastLimitPerFrame"] = "10",
    ["DFStringTelegrafHTTPTransportUrl"] = "null",
    ["DFStringAltTelegrafHTTPTransportUrl"] = "null",
    ["DFStringLightstepToken"] = "null",
    ["DFStringLightstepHTTPTransportUrlPath"] = "null",
    ["DFStringLightstepHTTPTransportUrlHost"] = "null",
    ["DFStringRobloxAnalyticsURL"] = "null",
    ["DFStringTelemetryV2Url"] = "null",
    ["DFStringCrashUploadToBacktraceBaseUrl"] = "null",
    ["DFStringCrashUploadToBacktraceWindowsPlayerToken"] = "null",
    ["DFStringCrashUploadToBacktraceMacPlayerToken"] = "null",
    ["FStringCoreScriptBacktraceErrorUploadToken"] = "null",

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
    ["FIntFontSizePadding"] = "3",
    ["FFlagEnablePreferredTextSizeStyleFixesInAppShell3"] = "True",
    ["FFlagEnablePreferredTextSizeGuiService"] = "True",
    ["FFlagEnablePreferredTextSizeScale"] = "True",
    ["FFlagEnablePreferredTextSizeSettingInMenus2"] = "True",
    ["FFlagEnablePreferredTextSizeStyleFixesInAvatarExp"] = "True",
    ["FIntPreferredTextSizeSettingBetaFeatureRolloutPercent"] = "100",
    ["FFlagUserShowGuiHideToggles"] = "True",
    ["FFlagLuaAppLegacyInputSettingRefactor"] = "True",
    ["FFlagBetterTrackpadScrolling"] = "True",
    ["FFlagUserBetterInertialScrolling"] = "True",
    ["FFlagFixSensitivityTextPrecision"] = "False",
    ["FFlagFixIGMTabTransitions"] = "True",
    ["DFIntCanHideGuiGroupId"] = "32380007",
    ["FFlagEnablePreferredTextSizeStyleFixesInAppShell3"] = "True",
    ["FIntCameraMaxZoomDistance"] = "2147483647",
    ["FIntRobloxGuiBlurIntensity"] = "0",
    ["FIntUnifiedLightingBlendZone"] = "0",
    ["FFlagFixTextureCompositorFramebufferManagement2"] = "True",
    ["FFlagDebugCheckRenderThreading"] = "True",
    ["FFlagDebugForceGenerateHSR"] = "True",
    ["FIntHSRClusterSymmetryDistancePercent"] = "10000",
    ["DFFlagOptimizeClusterCacheAlloc"] = "True",
    ["FIntUITextureMaxUpdateDepth"] = "1",
    ["FIntEnableVisBugChecksHundredthPercent27"] = "100",
    ["FIntOverrideISRReplicatorStepBandwidthBytes"] = "131072",
    ["FIntVertexSmoothingGroupTolerance"] = "0",
    ["FFlagFixOutdatedTimeScaleParticles"] = "False",
    ["FFlagFixOutdatedParticles2"] = "False",
    ["FFlagFixParticleAttachmentCulling"] = "False",
    ["DFFlagAudioUseVolumetricPanning"] = "True",
    ["DFFlagAudioEnableVolumetricPanningForMeshes"] = "True",
    ["DFIntVoiceChatVolumeThousandths"] = "5000",
    ["FFlagLoginPageOptimizedPngs"] = "True",
    ["FFlagDebugAvatarChatVisualization"] = "True",
    ["FStringGetPlayerImageDefaultTimeout"] = "1",
    ["FStringVoiceBetaBadgeLearnMoreLink"] = "null",
    ["FStringGamesUrlPath"] = "/games/",
    ["FIntActivatedCountTimerMSMouse"] = "0",
    ["FIntActivatedCountTimerMSKeyboard"] = "0",
    ["FIntCAP1209DataSharingTOSVersion"] = "0",
    ["FIntCAP1544DataSharingUserRolloutPercentage"] = "0",
    ["DFIntSignalRCoreHubConnectionDisconnectInfoHundredthsPercent"] = "10",

    ["DebugLimitMinTextureResolutionWhenSkipMips"] = "2147483647",
    ["DoNotSkipMipsBasedOnSystemMemoryPS"] = "True",
    ["TM2SkipMipsForUnstreamable2"] = "True",
    ["RenderUseTextureManager224"] = "False",
    ["DebugTextureManagerSkipMips"] = "9",
    ["EnablePowerTraceModule"] = "True",
    ["IncludePowerSaverMode"] = "True",
    ["DebugFRMQualityLevelOverride"] = "1",
}
local function _stickyGetFFlagSetter()
    local candidates = { "setfflag", "setfastflag", "set_fflag", "setFFlag", "fflag", "mfflags" }
    for _, name in ipairs(candidates) do
        local env = (getgenv and getgenv()) or getfenv()
        local fn = rawget(env, name)
        if type(fn) == "function" then return fn end
    end
    return nil
end
local function _stickyApplyOptimizerFFlags()
    local setter = _stickyGetFFlagSetter()
    if not setter then return 0 end
    local applied = 0
    for flagName, flagValue in pairs(fflags) do
        if pcall(setter, flagName, flagValue) then applied = applied + 1 end
    end
    return applied
end
local _stickyOptimizerSaved = { quality = nil, shadows = nil, terrainDecoration = nil, effects = {} }
local function _stickySetLowGraphics(enabled)
    local ok, UGS = pcall(function() return UserSettings():GetService("UserGameSettings") end)
    if enabled then
        if ok and UGS then
            pcall(function() _stickyOptimizerSaved.quality = UGS.SavedQualityLevel end)
            pcall(function() UGS.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1 end)
        end
        pcall(function() settings().Rendering.QualityLevel = 1 end)
        local lighting = game:GetService("Lighting")
        _stickyOptimizerSaved.shadows = lighting.GlobalShadows
        lighting.GlobalShadows = false
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            _stickyOptimizerSaved.terrainDecoration = terrain.Decoration
            pcall(function() terrain.Decoration = false end)
        end
        table.clear(_stickyOptimizerSaved.effects)
        for _, obj in ipairs(lighting:GetChildren()) do
            if obj:IsA("PostEffect") then
                _stickyOptimizerSaved.effects[obj] = obj.Enabled
                pcall(function() obj.Enabled = false end)
            end
        end
    else
        if ok and UGS and _stickyOptimizerSaved.quality then pcall(function() UGS.SavedQualityLevel = _stickyOptimizerSaved.quality end) end
        local lighting = game:GetService("Lighting")
        if _stickyOptimizerSaved.shadows ~= nil then lighting.GlobalShadows = _stickyOptimizerSaved.shadows end
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain and _stickyOptimizerSaved.terrainDecoration ~= nil then pcall(function() terrain.Decoration = _stickyOptimizerSaved.terrainDecoration end) end
        for obj, wasEnabled in pairs(_stickyOptimizerSaved.effects) do pcall(function() if obj and obj.Parent then obj.Enabled = wasEnabled end end) end
    end
end
_G.StickySetFpsOptimizer = function(enabled)
    enabled = enabled == true
    _G.StickyFpsOptimizer = enabled
    if enabled then
        pcall(_stickyApplyOptimizerFFlags)
    end
    pcall(_stickySetLowGraphics, enabled)
    return enabled
end
_G.StickyToggleFpsOptimizer = function()
    return _G.StickySetFpsOptimizer(not (_G.StickyFpsOptimizer == true))
end
_G.StickyFpsOptimizer = false

_G.StickyAimbotEnabled = false
_G.StickyAimbotShotTarget = nil
_G.StickyBodySwapTP = false
_G.StickyBodySwapAimTarget = nil
_G.StickyBodySwapMouseHookInstalled = false

local StickyTPMethodNames = { ["HYBRID"] = true, ["FLING TP"] = true, ["MANUAL TP"] = true }
if _G.Sticky_FlingTp == nil then _G.Sticky_FlingTp = true end
_G.StickySetTPMethod = function(method)
    if not StickyTPMethodNames[method] then return false end
    _G.StickyTPMethod = method
    _G.StickyHybridTP = method == "HYBRID"
    _G.Sticky_FlingTp = method == "FLING TP"
    _G.StickySpinTP, _G.StickyDragTP = false, false
    _G.StickyManualTP = method == "MANUAL TP"
    return method
end
_G.StickySetHybridTP = function(enabled)
    if enabled == true then return _G.StickySetTPMethod("HYBRID") end
    if _G.StickyTPMethod == "HYBRID" then return _G.StickySetTPMethod("MANUAL TP") end
    _G.StickyHybridTP = false
    return false
end
_G.StickySetSpinTP = function(_)
    _G.StickySpinTP, _G.StickyDragTP = false, false
    return false
end
_G.StickyNormalizeTPModes = function()
    local method = _G.StickyTPMethod
    if not StickyTPMethodNames[method] then
        if _G.StickyHybridTP == true then method = "HYBRID"
        elseif _G.Sticky_FlingTp ~= false then method = "FLING TP"
        else method = "MANUAL TP" end
    end
    _G.StickySetTPMethod(method)
    return _G.StickyHybridTP == true, false
end
_G.StickyTPLineShow = function() end
_G.StickyTPLineUpdate = function() end
_G.StickyTPLineClear = function() end

do
	local UIS = game:GetService("UserInputService")
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	_G.StickyInfJump = true

	local function airProtect(hum)
		if not hum or not hum.Parent then return end
		if _G.__StickyResetBusy or _G.__StickyResetBusy or _G.AntiDieDisabled then return end
		pcall(function()
			hum.BreakJointsOnDeath = false
			hum.RequiresNeck = false
			hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
			if hum.Health < hum.MaxHealth then
				hum.Health = hum.MaxHealth
			end
			local st = hum:GetState()
			if st == Enum.HumanoidStateType.Dead
				or st == Enum.HumanoidStateType.Ragdoll
				or st == Enum.HumanoidStateType.FallingDown
				or st == Enum.HumanoidStateType.Physics then
				hum.PlatformStand = false
				hum:ChangeState(Enum.HumanoidStateType.Freefall)
			end
		end)
	end

	local function hop()
		if _G.StickyInfJump == false then return end
		if _G.__StickyResetBusy or _G.__StickyResetBusy then return end
		local LP = Players.LocalPlayer
		local char = LP and LP.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hum or not hrp then return end
		airProtect(hum)
		pcall(function()
			local vy = hum.JumpPower
			if typeof(vy) ~= "number" or vy < 40 then vy = 50 end
			if hum.UseJumpPower == false and typeof(hum.JumpHeight) == "number" then
				vy = math.max(40, math.sqrt(2 * workspace.Gravity * math.max(hum.JumpHeight, 7.2)) * 0.9)
			end
			local v = hrp.AssemblyLinearVelocity
			hrp.AssemblyLinearVelocity = Vector3.new(v.X, math.max(v.Y, vy), v.Z)
			hum.Jump = true
		end)
	end

	if not _G.__StickyInfJumpHardened then
		_G.__StickyInfJumpHardened = true
		UIS.JumpRequest:Connect(function()
			if _G.StickyInfJump == false then return end
			hop()
		end)
		local held = false
		UIS.InputBegan:Connect(function(i, g)
			if not g and i.KeyCode == Enum.KeyCode.Space then held = true end
		end)
		UIS.InputEnded:Connect(function(i)
			if i.KeyCode == Enum.KeyCode.Space then held = false end
		end)
		RunService.PreSimulation:Connect(function()
			if _G.StickyInfJump == false then return end
			if _G.__StickyResetBusy or _G.__StickyResetBusy then return end
			local LP = Players.LocalPlayer
			local char = LP and LP.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if not hum then return end
			local st = hum:GetState()
			if st == Enum.HumanoidStateType.Freefall
				or st == Enum.HumanoidStateType.Jumping
				or st == Enum.HumanoidStateType.FallingDown
				or st == Enum.HumanoidStateType.Physics
				or held then
				airProtect(hum)
			end
		end)
		RunService.Heartbeat:Connect(function()
			if _G.StickyInfJump == false then return end
			if _G.__StickyResetBusy or _G.__StickyResetBusy then return end
			local LP = Players.LocalPlayer
			local char = LP and LP.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if not hum then return end
			if held then hop() end
			local st = hum:GetState()
			if st == Enum.HumanoidStateType.Freefall
				or st == Enum.HumanoidStateType.Jumping
				or st == Enum.HumanoidStateType.FallingDown
				or st == Enum.HumanoidStateType.Physics then
				airProtect(hum)
			end
		end)
		local function bindChar(char)
			task.defer(function()
				local hum = char:WaitForChild("Humanoid", 8)
				if not hum then return end
				airProtect(hum)
				hum:GetPropertyChangedSignal("Health"):Connect(function()
					if _G.__StickyResetBusy or _G.__StickyResetBusy or _G.AntiDieDisabled then return end
					if hum.Health < hum.MaxHealth then
						pcall(function() hum.Health = hum.MaxHealth end)
					end
				end)
				hum.Died:Connect(function()
					if _G.__StickyResetBusy or _G.__StickyResetBusy or _G.AntiDieDisabled then return end
					pcall(function()
						hum.Health = hum.MaxHealth
						hum:ChangeState(Enum.HumanoidStateType.Running)
					end)
				end)
			end)
		end
		local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()
		if LP.Character then bindChar(LP.Character) end
		LP.CharacterAdded:Connect(bindChar)
	end
end

do
	local Lighting = game:GetService("Lighting")
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local RS = game:GetService("ReplicatedStorage")
	local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()
	_G.StickyAntiBee = true
	local BAD = { Blue = true, DiscoEffect = true, BeeBlur = true,
		Flashbang = true, ColorCorrection = true }
	local KILL_CLASSES = {
		BlurEffect = true, BloomEffect = true, SunRaysEffect = true,
		ColorCorrectionEffect = true, DepthOfFieldEffect = true,
	}
	local function on() return true end
	local function nuke(o)
		if not o or not o.Parent then return end
		if BAD[o.Name] then
			pcall(function() o:Destroy() end)
			return
		end
		if KILL_CLASSES[o.ClassName] then
			pcall(function() o.Enabled = false end)
		end
	end
	local buzz
	local function muteBuzz()
		pcall(function()
			if not (buzz and buzz.Parent) then
				local ctl = RS:FindFirstChild("Controllers")
				local item = ctl and ctl:FindFirstChild("ItemController")
				local bee = item and item:FindFirstChild("BeeLauncherController")
				local s = bee and bee:FindFirstChild("Buzzing")
				if s and s:IsA("Sound") then buzz = s end
			end
			if buzz then
				buzz.Volume = 0
				if buzz.IsPlaying then buzz:Stop() end
			end
		end)
	end
	local guarded = {}
	local function guard(Controls, original)
		if not Controls or guarded[Controls] then return end
		local base = original or Controls.moveFunction
		if not base then return end
		local function safeMove(self, mv, rtc) return base(self, mv, rtc) end
		guarded[Controls] = safeMove
		Controls.moveFunction = safeMove
		local _mfTick = 0
		RunService.Heartbeat:Connect(function()
			_mfTick = _mfTick + 1
			if _mfTick < 10 then return end
			_mfTick = 0
			if Controls.moveFunction ~= safeMove then Controls.moveFunction = safeMove end
		end)
	end
	local function protect()
		pcall(function()
			local cc = RS:FindFirstChild("Controllers")
			local mod = cc and cc:FindFirstChild("CharacterController")
			if mod then
				local okm, m = pcall(require, mod)
				if okm and type(m) == "table" then guard(m.Controls, m.originalMoveFunction) end
			end
		end)
		pcall(function()
			local ps = LP and (LP:FindFirstChild("PlayerScripts") or LP:WaitForChild("PlayerScripts", 5))
			local pm = ps and ps:FindFirstChild("PlayerModule")
			if pm then
				local okm, mod = pcall(require, pm)
				if okm and mod and type(mod.GetControls) == "function" then
					guard(mod:GetControls())
				end
			end
		end)
	end
	task.spawn(function()
		pcall(function() LP:WaitForChild("PlayerScripts", 8) end)
		Lighting.DescendantAdded:Connect(nuke)
		for _, o in ipairs(Lighting:GetDescendants()) do nuke(o) end
		protect()
		local acc = 1
		RunService.Heartbeat:Connect(function(dt)
			acc = acc + dt
			if acc < 0.5 then return end
			acc = 0
			for _, o in ipairs(Lighting:GetDescendants()) do nuke(o) end
			muteBuzz()
		end)
	end)
	if LP then
		LP.CharacterAdded:Connect(function() task.delay(1, protect) end)
	else
		task.spawn(function()
			local plr = Players.LocalPlayer or Players.PlayerAdded:Wait()
			plr.CharacterAdded:Connect(function() task.delay(1, protect) end)
		end)
	end
end

do
	local Players = game:GetService("Players")
	local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()
	local function psCode(link)
		if type(link) ~= "string" or link == "" then return nil end
		if not link:find("://", 1, true) then return link end
		return link:match("[?&]privateServerLinkCode=([^&]+)")
			or link:match("[?&]linkCode=([^&]+)")
			or link:match("[?&]code=([^&]+)")
	end
	local function kickOut()
		if _G.StickyKickToPS == true then
			local code = psCode(_G.StickyPrivateServerLink or _G.StickyPSCode)
			if code and code ~= "" then
				local ok = pcall(function()
					game:GetService("ExperienceService"):LaunchExperience({
						placeId = tonumber(_G.StickyPrivateServerPlaceId) or game.PlaceId,
						linkCode = code,
					})
				end)
				if ok then return end
			end
		end
		if pcall(function() game:Shutdown() end) then return end
		pcall(function() LP:Kick("") end)
	end
	_G.StickyKickOut = kickOut
	task.spawn(function()
		local PG2 = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 10)
		if not PG2 then return end
		local hooked = setmetatable({}, { __mode = "k" })
		local function hit(txt)
			return type(txt) == "string" and txt:lower():find("you stole", 1, true) ~= nil
		end
		local function isText(o)
			return o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox")
		end
		local function watch(o)
			if hooked[o] then return end
			hooked[o] = true
			if _G.StickyAutoKickOnSteal == true and hit(o.Text) then kickOut() return end
			o:GetPropertyChangedSignal("Text"):Connect(function()
				if _G.StickyAutoKickOnSteal == true and hit(o.Text) then kickOut() end
			end)
		end
		local function root(g)
			g.DescendantAdded:Connect(function(d) if isText(d) then watch(d) end end)
			local n = 0
			for _, d in ipairs(g:GetDescendants()) do
				n = n + 1
				if n % 200 == 0 then task.wait() end
				if isText(d) then watch(d) end
			end
		end
		while _G.StickyAutoKickOnSteal ~= true do task.wait(1) end
		PG2.ChildAdded:Connect(root)
		for _, g in ipairs(PG2:GetChildren()) do root(g) end
	end)
end

_G.StickyAntiDie = true
_G.AntiDieDisabled = false

do
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local RS = game:GetService("ReplicatedStorage")
	local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()

	local antiRagdoll = { conns = {}, characterConn = nil, heartbeat = nil, character = nil, root = nil, rootConstraint = nil }
	local antiRagdollEnabled = true
	local lastVelocity = Vector3.zero
	local launchClasses = {
		BodyVelocity = true, BodyForce = true, BodyThrust = true, BodyGyro = true,
		BodyAngularVelocity = true, VectorForce = true, AngularVelocity = true, RocketPropulsion = true,
	}
	local allowedForces = { SpeedForce = true, InvisSpeedForce = true, JumpForce = true, FlightPower = true, FlightSpin = true, FlightHold = true }

	local function disconnectAntiRagdoll()
		for _, connection in ipairs(antiRagdoll.conns) do pcall(function() connection:Disconnect() end) end
		antiRagdoll.conns = {}
	end

	local function controlsEnabled()
		pcall(function()
			local scripts = LP:FindFirstChild("PlayerScripts")
			local module = scripts and scripts:FindFirstChild("PlayerModule")
			if module then require(module):GetControls():Enable() end
		end)
	end

	local function flyingCarpetActive(char)
		local root = char and char:FindFirstChild("HumanoidRootPart")
		return root and (root:FindFirstChild("FlightPower") or root:FindFirstChild("FlightSpin") or root:FindFirstChild("FlightHold")) ~= nil
	end

	local function removeLaunchObject(object)
		if allowedForces[object.Name] then return false end
		local className = object.ClassName
		local launch = launchClasses[className] or className == "LinearVelocity"
		if not launch and (className:find("Force") or className:find("Velocity") or className:find("Body") or className:find("Propulsion")) then
			launch = object.Name:find("Impulse") or object.Name:find("Knockback") or object.Name:find("Launch")
		end
		if launch then pcall(function() object:Destroy() end); return true end
		return false
	end

	local function stripLaunchObjects(char)
		local found = false
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root then for _, object in ipairs(root:GetChildren()) do found = removeLaunchObject(object) or found end end
		if char then for _, object in ipairs(char:GetChildren()) do found = removeLaunchObject(object) or found end end
		return found
	end

	local function teleportInProgress()
		return _G.StickyIsTeleporting == true
			or _G.StickyIsTeleporting == true
			or _G.__StickyManualTPActive == true
			or _G._isTpMoving == true
			or _G.__StickyResetBusy == true
			or _G.__StickyResetBusy == true
	end

	local function disableRagdollSource()
		if type(getconnections) ~= "function" then return end
		pcall(function()
			local packages = RS:FindFirstChild("Packages")
			local net = packages and packages:FindFirstChild("Net")
			local remote = net and net:FindFirstChild("RE/Ragdoll")
			if not remote then
				local ragdollPackage = packages and packages:FindFirstChild("Ragdoll")
				remote = ragdollPackage and ragdollPackage:FindFirstChild("Ragdoll")
			end
			if remote and remote:IsA("RemoteEvent") then
				for _, connection in ipairs(getconnections(remote.OnClientEvent)) do
					if not pcall(function() connection:Disable() end) then
						pcall(function() connection:Disconnect() end)
					end
				end
			end
		end)
	end

	local function cleanRagdoll(char)
		if teleportInProgress() then return end
		char = char or LP.Character
		if not char then return end
		pcall(function()
			local endTime = tonumber(LP:GetAttribute("RagdollEndTime")) or 0
			if endTime > workspace:GetServerTimeNow() then _G.StickyRagdollUntil = endTime end
			LP:SetAttribute("RagdollEndTime", 0)
		end)
		local rootConstraint
		for _, object in ipairs(char:GetDescendants()) do
			if object:IsA("BallSocketConstraint") or object:IsA("HingeConstraint") or object:IsA("NoCollisionConstraint") then
				pcall(function() object:Destroy() end)
			elseif object:IsA("Motor6D") and not object.Enabled then
				pcall(function() object.Enabled = true end)
			elseif object:IsA("AnimationConstraint") then
				if object.Name == "Root" then rootConstraint = object end
			end
		end
		local root = char:FindFirstChild("HumanoidRootPart")
		local attachment = root and root:FindFirstChild("RootRigAttachment")
		if rootConstraint and attachment and (not rootConstraint.Attachment0 or not rootConstraint.Attachment0.Parent) then
			pcall(function() rootConstraint.Attachment0 = attachment end)
		end
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			pcall(function() humanoid.PlatformStand = false end)
			local state = humanoid:GetState()
			if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll
				or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.PlatformStanding then
				pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end)
			end
			pcall(function() workspace.CurrentCamera.CameraSubject = humanoid end)
		end
		controlsEnabled()
	end

	local function isRagdolled(char, humanoid)
		local endTime = tonumber(LP:GetAttribute("RagdollEndTime")) or 0
		if endTime > workspace:GetServerTimeNow() then return true end
		if humanoid then
			local state = humanoid:GetState()
			if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll
				or state == Enum.HumanoidStateType.FallingDown then
				return true
			end
			if humanoid.PlatformStand then return true end
		end
		return false
	end

	local function hookCharacter(char)
		disconnectAntiRagdoll()
		disableRagdollSource()
		antiRagdoll.character = char
		antiRagdoll.root = char:WaitForChild("HumanoidRootPart", 10)
		local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 10)
		if not antiRagdoll.root or not humanoid then return end
		table.insert(antiRagdoll.conns, LP:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
			if antiRagdollEnabled and not teleportInProgress() and isRagdolled(char, humanoid) then cleanRagdoll(char) end
		end))
		table.insert(antiRagdoll.conns, humanoid.StateChanged:Connect(function(_, state)
			if antiRagdollEnabled and not teleportInProgress() and (state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown) then
				cleanRagdoll(char)
			end
		end))
		local queued = false
		table.insert(antiRagdoll.conns, char.DescendantAdded:Connect(function(object)
			if not antiRagdollEnabled or teleportInProgress() or (not object:IsA("BallSocketConstraint") and not object:IsA("HingeConstraint") and not object:IsA("NoCollisionConstraint")) or queued then return end
			queued = true
			task.defer(function() queued = false; cleanRagdoll(char) end)
		end))
	end

	antiRagdoll.characterConn = LP.CharacterAdded:Connect(function(char)
		if antiRagdollEnabled then hookCharacter(char) end
	end)
	antiRagdoll.heartbeat = RunService.Heartbeat:Connect(function()
		if not antiRagdollEnabled then return end
		if teleportInProgress() then
			local movingRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
			if movingRoot then lastVelocity = movingRoot.AssemblyLinearVelocity end
			return
		end
		local char = LP.Character
		local humanoid = char and char:FindFirstChildOfClass("Humanoid")
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not char or not humanoid or not root then return end
		local flying = flyingCarpetActive(char)
		local ragdolled = isRagdolled(char, humanoid)
		if ragdolled then
			_G.StickyRagdollPhysLast = os.clock()
			cleanRagdoll(char)
			pcall(function()
				humanoid.PlatformStand = false
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
				humanoid:ChangeState(Enum.HumanoidStateType.Running)
			end)
		end
		local launched = ragdolled and stripLaunchObjects(char) or false
		if ragdolled or launched then
			root.AssemblyAngularVelocity = Vector3.zero
			if _G.StickyRagdollStayPut ~= false and not _G.__StickyResetBusy and not flying then root.AssemblyLinearVelocity = Vector3.zero end
		end
		if ragdolled and not flying and not _G.__StickyResetBusy then
			local velocity = root.AssemblyLinearVelocity
			if (velocity - lastVelocity).Magnitude > (tonumber(_G.StickyLaunchSpikeThreshold) or 110) then
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
				velocity = Vector3.zero
			end
			lastVelocity = velocity
		else
			lastVelocity = root.AssemblyLinearVelocity
		end
	end)
	if LP.Character then task.spawn(function() hookCharacter(LP.Character) end) end
end

do
	_G.StickyAntiDie = true
	_G.AntiDieDisabled = false
	local function harden(hum)
		if not hum then return end
		if _G.AntiDieDisabled or _G.__StickyResetBusy or _G.__StickyResetBusy then return end
		pcall(function()
			hum.BreakJointsOnDeath = false
			hum.RequiresNeck = false
			hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
			if hum.Health <= 0 then hum.Health = hum.MaxHealth end
		end)
	end
	local function bind(char)
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
		if not hum then return end
		harden(hum)
		pcall(function()
			hum:GetPropertyChangedSignal("Health"):Connect(function()
				if _G.AntiDieDisabled or _G.__StickyResetBusy or _G.__StickyResetBusy then return end
				if hum.Health <= 0 then
					pcall(function() hum.Health = hum.MaxHealth end)
					pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
				end
			end)
			hum.Died:Connect(function()
				if _G.AntiDieDisabled or _G.__StickyResetBusy or _G.__StickyResetBusy then return end
				pcall(function() hum.Health = hum.MaxHealth end)
				pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
			end)
		end)
	end
	task.spawn(function()
		local LP = game:GetService("Players").LocalPlayer or game:GetService("Players").PlayerAdded:Wait()
		while not LP do task.wait() LP = game:GetService("Players").LocalPlayer end
		if LP.Character then bind(LP.Character) end
		LP.CharacterAdded:Connect(function(c) task.defer(bind, c) end)
		local acc = 0
		game:GetService("RunService").Heartbeat:Connect(function(dt)
			if _G.AntiDieDisabled or _G.__StickyResetBusy or _G.__StickyResetBusy then return end
			local LP = game:GetService("Players").LocalPlayer or game:GetService("Players").PlayerAdded:Wait()
			local char = LP and LP.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if not hum then return end
			acc = acc + (dt or 0.016)
			if acc < 0.05 then return end
			acc = 0
			harden(hum)
			if hum.Health < hum.MaxHealth then
				pcall(function() hum.Health = hum.MaxHealth end)
			end
			local st = hum:GetState()
			if st == Enum.HumanoidStateType.Dead or st == Enum.HumanoidStateType.Ragdoll
				or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Physics then
				pcall(function()
					hum.PlatformStand = false
					hum.Health = hum.MaxHealth
					hum:ChangeState(Enum.HumanoidStateType.Running)
				end)
			end
			if st == Enum.HumanoidStateType.Freefall or st == Enum.HumanoidStateType.Jumping then
				pcall(function()
					hum.BreakJointsOnDeath = false
					hum.RequiresNeck = false
					hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
					hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
					hum.Health = hum.MaxHealth
				end)
			end
		end)
	end)
end

_G.StickyScanProfile = function(mode)
    if mode == "fast" then

        _G.StickyScanMode     = "fast"
        _G.StickyPanelScanGap = tonumber(_G.StickyFastPanelGap)    or 0.15
        _G.StickyRepickGap    = tonumber(_G.StickyFastRepickGap)   or 0.1
        _G.StickyInRangeGap   = tonumber(_G.StickyFastInRangeGap)  or 0.1
        _G.StickyWatchdogTick = tonumber(_G.StickyFastWatchdogTick) or 0.15
        _G.StickySyncScanGap  = tonumber(_G.StickyFastSyncGap)     or 0.1
        _G.StickyAutoTPPoll   = tonumber(_G.StickyFastTPPoll)      or 0.03
    else
        _G.StickyScanMode     = "normal"
        _G.StickyPanelScanGap = tonumber(_G.StickyNormPanelGap)    or 0.25
        _G.StickyRepickGap    = tonumber(_G.StickyNormRepickGap)   or 0.25
        _G.StickyInRangeGap   = tonumber(_G.StickyNormInRangeGap)  or 0.2
        _G.StickyWatchdogTick = tonumber(_G.StickyNormWatchdogTick) or 0.2
        _G.StickySyncScanGap  = tonumber(_G.StickyNormSyncGap)     or 0.15
        _G.StickyAutoTPPoll   = tonumber(_G.StickyNormTPPoll)      or 0.03
    end
end
_G.StickyScanProfile("fast")

task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(tonumber(_G.StickyFastWindow) or 60)
    if _G.StickyScanMode == "fast" then _G.StickyScanProfile("normal") end
end)
local print = function() end
local warn  = function() end
if _G.StickyInvisAuto == nil then _G.StickyInvisAuto = false end
if _G.StickyAutoKickOnSteal == nil then _G.StickyAutoKickOnSteal = false end
if _G.StickyAutoBuy == nil then _G.StickyAutoBuy = false end
if _G.StickyStealMode == nil then _G.StickyStealMode = "priority" end
if _G.StickyAutoTP == nil then _G.StickyAutoTP = true end
_G.StickyTPStartDelay = 0.18

if not game:IsLoaded() then game.Loaded:Wait() end
local _gameLoadAt = os.clock()

task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(tonumber(_G.StickyFpsCapDelay) or 1.5)
    pcall(function() if setfpscap then setfpscap(9999) end end)
end)

task.spawn(function()
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local _RS = game:GetService("RunService")
    if not Workspace.StreamingEnabled then return end
    local plots
    local t0 = os.clock()
    repeat plots = Workspace:FindFirstChild("Plots"); if not plots then _RS.Heartbeat:Wait() end
    until plots or (os.clock() - t0) > 15
    if not plots then return end
    local function plotPos(plot)
        local ok, pv = pcall(function() return plot:GetPivot().Position end)
        if ok and pv and pv.Magnitude > 1 then return pv end
        if plot.PrimaryPart then return plot.PrimaryPart.Position end
        local bp = plot:FindFirstChildWhichIsA("BasePart", true)
        return bp and bp.Position or nil
    end
    local pending = 0
    for _, plot in ipairs(plots:GetChildren()) do
        local pos = plotPos(plot)
        if pos then
            pending = pending + 1
            task.spawn(function()
                pcall(function() LocalPlayer:RequestStreamAroundAsync(pos) end)
                pending = pending - 1
            end)
        end
    end
    local sw = os.clock()
    while pending > 0 and os.clock() - sw < 3 do task.wait(0.03) end
end)

_G.StickyBootDelay = tonumber(_G.StickyBootDelay) or 0.3
if _G.StickyWaitForTools == nil then _G.StickyWaitForTools = true end
_G.StickyToolWait = tonumber(_G.StickyToolWait) or 6
do
    local _bootT0 = os.clock()
    local _BOOT_TOOLS = {
        "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings",
        "Grapple Hook",
    }
    local _BOOT_SET = {}
    for _, n in ipairs(_BOOT_TOOLS) do _BOOT_SET[n] = true end

    local function _boxHasTool(box, want)
        if not box then return false end
        for _, t in ipairs(box:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name
                if n == want or _BOOT_SET[n] then return true end
            end
        end
        return false
    end
    local function _toolsReady()
        local plr = game:GetService("Players").LocalPlayer
        if not plr then return false end
        local want = (type(_G.StickyCarpetTool) == "string" and _G.StickyCarpetTool ~= "")
            and _G.StickyCarpetTool or nil
        return _boxHasTool(plr.Character, want)
            or _boxHasTool(plr:FindFirstChild("Backpack"), want)
    end
    _G.StickyToolsReady = _toolsReady
    _G.StickyBootWait = function()

        local d    = tonumber(_G.StickyBootDelay) or 0.3
        local cap  = tonumber(_G.StickyToolWait) or 6
        local want = (_G.StickyWaitForTools ~= false)
        local t0   = os.clock()
        while true do
            local ready = true
            if want then
                local ok, r = pcall(_toolsReady)
                ready = (ok and r) and true or false
            end
            if ready and (os.clock() - _bootT0) >= d then
                return
            end
            if os.clock() - t0 >= cap then
                return
            end
            task.wait(tonumber(_G.StickyBootPoll) or 0.03)
        end
    end
end

_G.StickyPriVersion = _G.StickyPriVersion or 0
if type(_G.StickyPriorityDefault) ~= "table" then _G.StickyPriorityDefault = {} end
if type(_G.SHARED_PRIORITY_ITEMS) ~= "table" then _G.SHARED_PRIORITY_ITEMS = {} end
if type(_G.SHARED_BLACKLIST_ITEMS) ~= "table" then _G.SHARED_BLACKLIST_ITEMS = {} end
if type(_G.SHARED_MUTATION_PRIORITY) ~= "table" then _G.SHARED_MUTATION_PRIORITY = {} end
if type(_G.SHARED_TRAIT_PRIORITY) ~= "table" then _G.SHARED_TRAIT_PRIORITY = {} end
if type(_G.SHARED_MUTATION_DISABLED) ~= "table" then _G.SHARED_MUTATION_DISABLED = {} end

if LPH_OBFUSCATED == nil then
    local env = getfenv()
    env["LPH_NO_" .. "VIRTUALIZE"] = function(...) return ... end
    env["LPH_JIT_" .. "MAX"]       = function(...) return ... end
end

do
    local _HS = game:GetService("HttpService")
    local _TS = game:GetService("TeleportService")
    _G.Sticky_DEFAULT_CONFIG_JSON = [==[{"mutationList":["Bloodrot","Candy","Crystal","Cursed","Cyber","Diamond","Divine","Galaxy","Gold","Lava","Phantom","Radioactive","Rainbow","YinYang"],"traitList":["1 Year","10B","26",":3","Algeria","Argentina","Aura Shades","Australia","Austria","Ball","Bee","Belgium","Blue Balloon","Blue Egg","Bosnia and Herzegovina","Brazil","Bubblegum","Bull","Bunny Ears","Burger","Canada","Cape Verde","Chocolate","Claws","Colombia","Cometstruck","Croatia","Curacao","Czechia","DR Congo","Disco","Ecuador","Egypt","England","Explosive","Fire","Fire Bee","Fireworks","France","Galactic","Germany","Ghana","Glitched","Granny","Green Balloon","Green Egg","Haiti","Halo","Ice Bee","Indonesia","Iran","Iraq","Ivory Coast","Jackolantern Pet","Japan","Job Application","John Pork","Jordan","Lightning","Lucky","Matteo Hat","Meowl","Mexico","Morocco","Netherlands","New Zealand","Norway","Nyan","Orange Balloon","Orange Egg","Paint","Panama","Paraguay","Pink Balloon","Pink Egg","Portugal","Qatar","Queen Bee","RIP Gravestone","Rainbow Balloon","Red Balloon","Reindeer Pet","Rose","Santa Hat","Saudi Arabia","Scotland","Senegal","Shark Fin","Skeleton","Skibidi","Sleepy","Snowy","Sombrero","South Africa","South Korea","Spain","Spider","Strawberry","Sun","Sweden","Switzerland","Taco","Tie","Tunisia","Turkey","UFO","United States","Uruguay","Uzbekistan","Wet","Witch Hat","Zombie"],"alertSound":"111786441593851","stealLead":0.07,"exX":1977,"landingDelay":0.15000000000000003,"infJump":true,"invisAngle":216,"xray":true,"goSpeed":220,"faceAway":false,"antiBee":true,"cframeSpeed":450,"stealFireKey":"LeftAlt","autoKickOnSteal":false,"invisDepth":10,"cloneKey":"V","autoBuyRange":17,"antiFlash":true,"autoBuyHover":9,"resetKey":"X","closeSpeed":300,"walkSpeedOn":false,"stealMode":"priority","dropKey":"G","priAlert":false,"nearestKey":"F","faceAwayNearest":false,"exY":355,"autoSteal":true,"priorityList":["Headless Horseman","Strawberry Elephant","Signore Carapace","John Pork","Meowl","Elefanto Frigo","Arcadragon","Skibidi Toilet","Griffin","Antonio","Dragon Aquanini","Dragon Gingerini","Love Love Bear","Kalika Bros","Moby Bros","Grabatron","Jelly Moby","La Supreme Combinasion","Ginger Gerat","Digi Narwhal","Hydra Dragon Cannelloni","Hydra Bunny","Bunny and Eggy","Kraken","Fishino Clownino","Tirilikalika Tirilikalako","Pancake and Syrup","Dragon Cannelloni","Sammyni Cakini","Ketupat Bros","Bumbatron","Venuspino","Dug dug dug","La Casa Boo","Rico Dinero","Foxini Lanternini","Duggy Bros","Rosey and Teddy","Globa Steppa","Los Hackers","Cerberus","Fragrama and Chocrama","Cooki and Milki","La Secret Combinasion","Burguro and Fryuro","Capitano Moby","Spooky and Pumpky","Garama and Madundung","Popcuru and Fizzuru","Pizza and Ranch","Reinito Sleighito","Tenini Ballini","Fragola La La La","Ketchuru and Musturu","Tralaledon","Tictac Sahur","Ketupat Kepat","Tang Tang Keletang","Orcaledon","La Ginger Sekolah","Los Spaghettis","Lavadorito Spinito","Swaggy Bros","La Taco Combinasion","Los Primos","Los Chillis","Chillin Chili","Tuff Toucan","W or L","Chipso and Queso","Guest 666","Money Money Reindeer","Quackini Snackini","Los Sekolahs","Los Tacoritas","Los Amigos","Fortunu and Cashuru","Jolly Jolly Sahur","Boppin Bunny","Gym Bros","Los Cupids","Festive 67","Celularcini Viciosini","Cloverat Clapat","La Food Combinasion","Hopilikalika Hopilikalako","Celestial Pegasus","Sammyni Fattini","Money Money Bros","La Spooky Grande","Cash or Card","Swag Soda","Los Planitos","Lovin Rose","Tacorita Bicicleta","Los Jolly Combinasionas","La Romantic Grande","La Easter Grande","Los Hotspotsitos","Rosetti Tualetti","Los Bros","Gobblino Uniciciclino","Chicleteira Cupideira","La Extinct Grande","Las Sis","Nacho Spyder","Gold Gold Gold","Los Mariachis","Snailo Clovero","La Jolly Grande","Los Candies","Churrito Bunnito","Bananito","Eviledon","Los 67","Los Sweethearts","Noo my Heart","La Lucky Grande","Ventoliero Pavonero","Baskito","Chimnino","Los Puggies","Camera Ramena","Los 25","Spinny Hammy","Money Money Puggy","Cigno Fulgoro","Los Spooky Combinasionas","Chicleteira Noelteira","Mariachi Corazoni","Tacorillo Crocodillo","Noo my Gold","Los Mobilis","Mieteteira Bicicleteira","DJ Panda","Los Combinasionas","Nuclearo Dinossauro","Bacuru and Egguru","Spaghetti Tualetti","La Grande Combinasion","Esok Sekolah"],"walkSpeed":29,"grabBeforeKick":true,"carpetStrict":true,"autoBuy":false,"psLink":"","antiDie":false,"carpetSpeedValue":140,"alertMinGen":80000000,"tpVelocity":550,"panelY":457,"invisAuto":true,"autoTp":true,"kickToPS":false,"faceAwayDelay":2,"climbSpeed":100,"carpetTool":"Waverider","carpetSpeedKey":"Q","stealQuickKey":"C","panelX":1068}]==]
    local DEFAULT_CONFIG
    pcall(function() DEFAULT_CONFIG = _HS:JSONDecode(_G.Sticky_DEFAULT_CONFIG_JSON) end)
    local fileData, tpData
    if readfile then
        pcall(function()
            local raw = readfile("SideTP.json")
            if type(raw) == "string" and #raw > 0 then fileData = _HS:JSONDecode(raw) end
        end)
    end
    pcall(function()
        local td = _TS:GetLocalPlayerTeleportData()
        if td and td.SideTP then tpData = td.SideTP end
    end)
    local merged = {}
    if type(DEFAULT_CONFIG) == "table" then for k, v in pairs(DEFAULT_CONFIG) do merged[k] = v end end
    if type(tpData) == "table" then for k, v in pairs(tpData) do merged[k] = v end end
    if type(fileData) == "table" then for k, v in pairs(fileData) do merged[k] = v end end

    if type(merged.tpDelay) == "number" then _G._stp_tpDelay = merged.tpDelay end
    if type(merged.tpVelocity) == "number" then _G.TPVelocity = math.clamp(merged.tpVelocity, 200, 750) end
    if type(merged.climbSpeed) == "number" then _G.StickyClimb = math.clamp(merged.climbSpeed, 100, 250) end
    if type(merged.cframeSpeed) == "number" then _G.StickyCFrameSpeed = math.clamp(merged.cframeSpeed, 100, 900) end
    if type(merged.walkSpeed) == "number" then _G.StickyWalkSpeed = math.clamp(merged.walkSpeed, 16, 29) end
    if type(merged.carpetTool) == "string" then _G.StickyCarpetTool = merged.carpetTool end
    if type(merged.landingDelay) == "number" then _G.LandingDelay = math.clamp(merged.landingDelay, 0.01, 1.0) end
    if type(merged.closeSpeed) == "number" then _G.StickyCloseSpeed = math.clamp(merged.closeSpeed, 20, 400) end
    if type(merged.problemBaseSpeed) == "number" then _G.StickyProblemBaseSpeed = math.clamp(merged.problemBaseSpeed, 20, 400) end
    if type(merged.slowCrossRow) == "boolean" then _G.StickySlowCrossRow = merged.slowCrossRow end
    if type(merged.stealLead) == "number" then _G.StickyStealLead = math.clamp(merged.stealLead, 0, 2) end
    _G.StickyStealQuick = false
    if type(merged.stealQuickKey) == "string" then _G.StickyStealQuickKey = merged.stealQuickKey end
    if type(merged.stealFireKey) == "string" then _G.StickyStealFireKey = merged.stealFireKey end
    if type(merged.tpKey) == "string" then _G._stp_tpKeyName = merged.tpKey end
    if type(merged.nearestKey) == "string" then _G.StickyNearestKey = merged.nearestKey end
    if type(merged.stealNearKey) == "string" then _G.StickyStealNearKey = merged.stealNearKey end
    if type(merged.stealPrioKey) == "string" then _G.StickyStealPrioKey = merged.stealPrioKey end
    if type(merged.xrayAlpha) == "number" then _G.StickyXrayAlpha = math.clamp(merged.xrayAlpha, 0.05, 0.95) end
    if type(merged.playerESP) == "boolean" then _G.StickyPlayerESP = merged.playerESP end
    if type(merged.fmlyESP) == "boolean" then _G.StickyFmlyESP = merged.fmlyESP end
    if type(merged.sonESP) == "boolean" then _G.StickySonESP = merged.sonESP end
    if type(merged.fovEnabled) == "boolean" then _G.StickyFovEnabled = merged.fovEnabled end
    if type(merged.fovValue) == "number" then _G.StickyFovValue = math.clamp(merged.fovValue, 0, 120) end
    if type(merged.flingTp) == "boolean" then _G.Sticky_FlingTp = merged.flingTp end
    if type(merged.autoDestroyTurret) == "boolean" then _G.StickyAutoDestroyTurret = merged.autoDestroyTurret end
    if type(merged.conveyorESP) == "boolean" then _G.StickyConveyorESP = merged.conveyorESP end
    if type(merged.trapESP) == "boolean" then _G.StickyTrapESP = merged.trapESP end
    if type(merged.lineToBase) == "boolean" then _G.StickyLineToBase = merged.lineToBase end
    if type(merged.adminPanelUiOn) == "boolean" then _G.StickyAdminPanelUiOn = merged.adminPanelUiOn end
    if type(merged.adminBlacklist) == "table" then _G.StickyAdminBlacklist = merged.adminBlacklist end
    if type(merged.optimizer) == "boolean" then _G.StickyFpsOptimizer = merged.optimizer end
    if type(merged.stealMode) == "string" then
        _G.StickyStealMode = merged.stealMode == "nearest" and "nearest" or "priority"
    end
    if type(merged.autoTp) == "boolean" then _G.StickyAutoTP = merged.autoTp end
    if type(merged.autoKickOnSteal) == "boolean" then _G.StickyAutoKickOnSteal = merged.autoKickOnSteal end
    if type(merged.tpTrail) == "boolean" then _G.StickyTPTrail = merged.tpTrail end
    local savedTPMethod = type(merged.tpMethod) == "string" and merged.tpMethod or nil
    if not StickyTPMethodNames[savedTPMethod] then
        if merged.hybridTp == true then savedTPMethod = "HYBRID"
        elseif merged.flingTp == true or (merged.flingTp == nil and _G.Sticky_FlingTp ~= false) then savedTPMethod = "FLING TP"
        else savedTPMethod = "MANUAL TP" end
    end
    _G.StickySetTPMethod(savedTPMethod)
    _G.StickyInstaTpBrainrot = true
    _G.StickyCFrameGoTo = true
    if type(merged.invisAuto) == "boolean" then _G.StickyInvisAuto = merged.invisAuto end
    if type(merged.invisAutoRecover) == "boolean" then _G.StickyInvisAutoRecover = merged.invisAutoRecover end
    if type(merged.prioritySoundID) == "string" then _G.StickyPrioritySoundID = merged.prioritySoundID end
    if _G.StickyStealMode ~= "nearest" then _G.StickyStealMode = "priority" end
    _G._stealUserOff = false
    if type(merged.priorityList) == "table" then
        local clean = {}
        for _, v in ipairs(merged.priorityList) do
            if type(v) == "string" and v ~= "" then clean[#clean + 1] = v end
        end
        if #clean > 0 then
            local L = _G.SHARED_PRIORITY_ITEMS
            table.clear(L)
            for i = 1, #clean do L[i] = clean[i] end
            _G.StickyPriVersion = _G.StickyPriVersion + 1
        end
    end
    if type(merged.priorityDefault) == "table" then
        local d = {}
        for _, v in ipairs(merged.priorityDefault) do
            if type(v) == "string" and v ~= "" then d[#d + 1] = v end
        end
        if #d > 0 then _G.StickyPriorityDefault = d end
    end
    if type(merged.mutationList) == "table" then
        local clean = {}
        for _, v in ipairs(merged.mutationList) do
            if type(v) == "string" and v ~= "" then clean[#clean + 1] = v end
        end
        if #clean > 0 then
            local L = _G.SHARED_MUTATION_PRIORITY
            table.clear(L)
            for i = 1, #clean do L[i] = clean[i] end
        end
    end
    if type(merged.mutationDisabled) == "table" then
        local D = _G.SHARED_MUTATION_DISABLED
        table.clear(D)
        for _, v in ipairs(merged.mutationDisabled) do
            if type(v) == "string" and v ~= "" then D[v] = true end
        end
    end
    if type(merged.traitList) == "table" then
        local clean = {}
        for _, v in ipairs(merged.traitList) do
            if type(v) == "string" and v ~= "" then clean[#clean + 1] = v end
        end
        if #clean > 0 then
            local L = _G.SHARED_TRAIT_PRIORITY
            table.clear(L)
            for i = 1, #clean do L[i] = clean[i] end
        end
    end
    if type(merged.blacklistList) == "table" then
        local clean = {}
        for _, v in ipairs(merged.blacklistList) do
            if type(v) == "string" and v ~= "" then clean[#clean + 1] = v end
        end
        local L = _G.SHARED_BLACKLIST_ITEMS
        if type(L) ~= "table" then L = {}; _G.SHARED_BLACKLIST_ITEMS = L end
        table.clear(L)
        for i = 1, #clean do L[i] = clean[i] end
    end

    if type(merged.invisAuto) == "boolean" then _G.StickyInvisAuto = merged.invisAuto end
    if type(merged.invisDepth) == "number" then _G.StickyInvisDepth = math.clamp(merged.invisDepth, 0, 10) end
    if type(merged.invisAngle) == "number" then _G.StickyInvisAngle = math.clamp(merged.invisAngle, 0, 360) end
    if type(merged.autoTp) == "boolean" then _G.StickyAutoTP = merged.autoTp end
    if type(merged.autoBuy) == "boolean" then _G.StickyAutoBuy = merged.autoBuy end
    if type(merged.autoBuyRange) == "number" then _G.StickyAutoBuyRange = math.clamp(merged.autoBuyRange, 5, 40) end
    if type(merged.autoBuyHover) == "number" then _G.StickyAutoBuyHover = math.clamp(merged.autoBuyHover, 0, 20) end
    if type(merged.panelX) == "number" then _G._stp_panelX = merged.panelX end
    if type(merged.panelY) == "number" then _G._stp_panelY = merged.panelY end
    if type(merged.panelPos) == "table" then _G._stp_pos = merged.panelPos end
    if type(merged.autoKickOnSteal) == "boolean" then _G.StickyAutoKickOnSteal     = merged.autoKickOnSteal end
    if type(merged.resetKey)        == "string"  then _G.StickyResetKeyName        = merged.resetKey end
    if type(merged.invisKey)        == "string"  then _G.StickyInvisKeyName        = merged.invisKey end
    if type(merged.cloneKey)        == "string"  then _G.StickyCloneKeyName        = merged.cloneKey end
    if type(merged.carpetSpeedKey)  == "string"  then _G.StickyCarpetSpeedKeyName  = merged.carpetSpeedKey end
    if type(merged.kickKey)         == "string"  then _G.StickyKickKeyName         = merged.kickKey end
    if type(merged.stopTpKey)       == "string"  then _G.StickyStopTPKeyName       = merged.stopTpKey end
    if type(merged.dropKey)         == "string"  then _G.StickyDropKeyName         = merged.dropKey end
    if type(merged.goSpeed)      == "number"  then _G.StickyGoSpeed            = math.clamp(merged.goSpeed, 80, 600) end
    if type(merged.kickToPS)     == "boolean" then _G.StickyKickToPS           = merged.kickToPS end
    if type(merged.psLink)       == "string"  then _G.StickyPrivateServerLink  = merged.psLink end
    if type(merged.priAlert)     == "boolean" then _G.StickyPriAlert           = merged.priAlert end
    if type(merged.alertSound)   == "string"  then _G.StickyAlertSound         = merged.alertSound end
    if type(merged.alertMinGen)  == "number"  then _G.StickyAlertMinGen        = merged.alertMinGen end
    if type(merged.walkSpeedOn)  == "boolean" then _G.StickyWalkSpeedOn        = merged.walkSpeedOn end
    if type(merged.xray)         == "boolean" then _G.StickyXray               = merged.xray end
    if type(merged) == "table" and merged.cframeGoTo ~= nil then _G.StickyCFrameGoTo = merged.cframeGoTo == true; _G.StickyCFrameGoTo = _G.StickyCFrameGoTo end
    if type(merged.uiOpenKey) == "string" then _G.StickyUiOpenKey = merged.uiOpenKey end
    if type(merged.frontTp) == "boolean" then _G.StickyFrontTP = merged.frontTp end
    if type(merged.sideTp) == "boolean" then _G.StickySideTP = merged.sideTp end
    if type(merged.sideTpRange) == "number" then _G.StickySideTPRange = math.clamp(merged.sideTpRange, 20, 200) end

    if type(merged.antiFlash)    == "boolean" then _G.StickyAntiFlash          = merged.antiFlash end
    if type(merged.faceAway)        == "boolean" then _G.StickyFaceAway        = merged.faceAway end
    if type(merged.faceAwayNearest) == "boolean" then _G.StickyFaceAwayNearest = merged.faceAwayNearest end
    if type(merged.faceAwayDelay)   == "number"  then _G.StickyFaceAwayDelay   = merged.faceAwayDelay end
    if type(merged.antiBee)      == "boolean" then _G.StickyAntiBee            = merged.antiBee end
    if type(merged.infJump)      == "boolean" then _G.StickyInfJump            = merged.infJump end
    if type(merged.antiDie)      == "boolean" then _G.AntiDieDisabled = false end
    _G.AntiDieDisabled = false
    _G.StickyAntiDie = true
    if type(merged.carpetSpeedValue) == "number" then _G.StickyCarpetSpeedValue = merged.carpetSpeedValue end
    if type(merged.exX) == "number" then _G._Sticky_exX = merged.exX end
    if type(merged.exY) == "number" then _G._Sticky_exY = merged.exY end
    if type(merged.fX)  == "number" then _G._Sticky_fX  = merged.fX  end
    if type(merged.fY)  == "number" then _G._Sticky_fY  = merged.fY  end
    if type(merged.kX)  == "number" then _G._Sticky_kX  = merged.kX  end
    if type(merged.kY)  == "number" then _G._Sticky_kY  = merged.kY  end

    if writefile then
        pcall(function()
            local t = type(fileData) == "table" and fileData or {}
            if t.autoTp == nil then t.autoTp = type(merged.autoTp) == "boolean" and merged.autoTp or true end
            writefile("SideTP.json", _HS:JSONEncode(t))
        end)
    end
end

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local RS         = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()

if _G.StickyNoZeroVel == nil then _G.StickyNoZeroVel = false end
function _vzOK()
    if _G.StickyNoZeroVel == true then return false end
    if _G.StickyZeroWhileStealing ~= true and LP:GetAttribute("Stealing") == true then return false end
    return true
end
function _vzL(p)
    if p and _vzOK() then
        p.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
end
function _vzA(p)
    if p and _vzOK() then
        p.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end

_BLOCKING_MACHINE_TYPES = {
    Fuse     = true,
    Duel     = true,
    Trade    = true,
    Crafting = true,
}
function _StickyIsFusing(animalData)
    if type(animalData) ~= "table" then return false end
    local m = animalData.Machine
    if type(m) ~= "table" then return false end
    return _BLOCKING_MACHINE_TYPES[m.Type] == true
end

do

local RS  = game:GetService("ReplicatedStorage")
local RUN = game:GetService("RunService")

local _netFolder
local function _netDir()
    if _netFolder then return _netFolder end
    local pk = RS:FindFirstChild("Packages") or RS:WaitForChild("Packages", 10)
    if not pk then return nil end
    _netFolder = pk:FindFirstChild("Net") or pk:WaitForChild("Net", 10)
    return _netFolder
end
local _net
local function _getNet()
    if _net then return _net end
    local dir = _netDir()
    if not dir then return nil end
    local ok, m = pcall(require, dir)
    if ok and type(m) == "table" then _net = m end
    return _net
end
local _queue, _hooked, _original = {}, false, nil
local function _host()
    for _, sig in ipairs({ RUN.Heartbeat, RUN.RenderStepped, RUN.PostSimulation }) do
        local ok, conns = pcall(getconnections, sig)
        if ok then
            for _, c in ipairs(conns) do
                local f = c.Function
                if f and f ~= _G.__mkSyncHost and islclosure(f) and not isexecutorclosure(f) then
                    local s = select(2, pcall(debug.info, f, "s"))
                    if type(s) == "string" and s:find("^ReplicatedStorage%.") and not s:find("ReplicatedFirst") then
                        return f
                    end
                end
            end
        end
    end
end
local function _install()
    if _hooked then return true end
    if not _getNet() then return false end
    local h = _host()
    if not h then return false end
    _G.__mkNetHost = h
    local w = function(...)
        local job = table.remove(_queue, 1)
        if job then
            local ok, r = pcall(_net[job.kind], _net, job.name)
            job.result = (ok and typeof(r) == "Instance") and r or nil
            job.done = true
        end
        return _original(...)
    end
    local ok, env = pcall(getfenv, h)
    if ok and type(env) == "table" then pcall(setfenv, w, env) end
    _original = hookfunction(h, w)
    _hooked = true
    return true
end
local _cache = {}
local function _get(name, kind)
    kind = (kind == "RemoteFunction" and "RemoteFunction")
        or (kind == "UnreliableRemoteEvent" and "UnreliableRemoteEvent")
        or "RemoteEvent"
    if type(name) ~= "string" or name == "" then return nil end
    local logical = name:match("^R[EF]/(.+)$") or name:match("^URE/(.+)$") or name
    local ck = kind .. "|" .. logical
    local hit = _cache[ck]
    if hit and hit.Parent then return hit end
    _cache[ck] = nil
    if not _getNet() then return nil end
    if not _install() then return nil end
    local job = { kind = kind, name = logical }
    table.insert(_queue, job)
    local t = os.clock() + (tonumber(_G.StickyNetTimeout) or 5)
    while not job.done and os.clock() < t do RUN.Heartbeat:Wait() end
    if job.result and job.result.Parent then
        _cache[ck] = job.result
        return job.result
    end
    return nil
end
_G.StickyNet = {
    RemoteEvent = function(_, name) return _get(name, "RemoteEvent") end,
    RemoteFunction = function(_, name) return _get(name, "RemoteFunction") end,
    UnreliableRemoteEvent = function(_, name) return _get(name, "UnreliableRemoteEvent") end,
}
_G.StickyGetRemote = _get
_G.Resolve = _get
_G.__secureGetRemote = function(method, name) return _get(name, method) end
_G.StickyNetHooked = function() return _hooked end
do
    local _dummy = Instance.new("RemoteEvent")
    local _rawFire = (clonefunction and clonefunction(_dummy.FireServer)) or _dummy.FireServer
    _G.RawFire = function(name, ...)
        local r = _get(name)
        if not r then return false end
        _rawFire(r, ...)
        return true
    end
end
end

do
local _xchan
local _lastTry, _attempts = 0, 0
local _deepScans, _lastDeep = 0, 0
local _mod

local MAX_ATTEMPTS, RETRY_GAP = 40, 0.5
local BOOT_T0, BOOT_BURST, BOOT_GAP = os.clock(), 3.0, 0.10
local MAX_DEEP, DEEP_GAP = 3, 1.5
local _bootDone = false
local _bootGrace = 4.0

local RS_SYNC = game:GetService("ReplicatedStorage")
local _mask_sc
local function _getMask()
    if _mask_sc and _mask_sc.Parent then return _mask_sc end
    local c = RS_SYNC:FindFirstChild("Controllers")
    _mask_sc = c and c:FindFirstChild("PlotController")
    return _mask_sc
end
local secure_call = _G.secure_call
if type(secure_call) ~= "function" then

    local RUN = game:GetService("RunService")
    local state = { ready = false, inside = false }
    local conn, original
    local function host()
        for _, sig in ipairs({ RUN.Heartbeat, RUN.RenderStepped, RUN.PostSimulation }) do
            local ok, conns = pcall(getconnections, sig)
            if ok then
                for _, c in ipairs(conns) do
                    local f = c.Function
                    if f and f ~= _G.__mkNetHost and islclosure(f) and not isexecutorclosure(f) then
                        local s = select(2, pcall(debug.info, f, "s"))
                        if type(s) == "string" and s:find("^ReplicatedStorage%.") and not s:find("ReplicatedFirst") then
                            return f, c, s
                        end
                    end
                end
            end
        end
    end
    local function install()
        if state.ready then return true end
        local h, c, src = host()
        if not h then return false end
        local chunk = loadstring([[
            local state, pack, unpack = ...
            return function(...)
                local job = state.job
                if job and not job.done then
                    job.done = true
                    state.inside = true
                    job.result = pack(pcall(job.fn, unpack(job.args, 1, job.args.n)))
                    state.inside = false
                end
                return state.original(...)
            end
        ]], "=" .. src)
        if not chunk then return false end
        local ok, env = pcall(getfenv, h)
        if ok and type(env) == "table" then pcall(setfenv, chunk, env) end
        local wrapper = chunk(state, table.pack, table.unpack)
        _G.__mkSyncHost = h
        original = hookfunction(h, wrapper)
        state.original = original
        conn = c
        state.ready = true
        return true
    end
    secure_call = function(fn, ...)
        if type(fn) ~= "function" then return nil end
        if state.inside then return fn(...) end
        if not install() then return nil end
        state.job = { fn = fn, args = table.pack(...), done = false }
        pcall(function() conn:Fire(0) end)
        local job = state.job
        state.job = nil
        if not job or not job.done or not job.result then return nil end
        if not job.result[1] then error(job.result[2], 2) end
        return table.unpack(job.result, 2, job.result.n)
    end
    _G.secure_call = secure_call
    _G.StickySyncHooked = function() return state.ready end
end
task.spawn(function()
    pcall(function()
        local sync = _getSyncMod()
        if sync and type(sync.GetAllChannels) == "function" then
            local mask = _getMask()
            if mask then pcall(secure_call, sync.GetAllChannels, mask) end
        end
    end)
end)
local _syncMod_sc, _nextTry_sc = nil, 0
local function _getSyncMod()
    if _syncMod_sc then return _syncMod_sc end
    local p = RS_SYNC:FindFirstChild("Packages")
    local m = p and p:FindFirstChild("Synchronizer")
    if not m then return nil end
    local ok, mod = pcall(require, m)
    if ok and type(mod) == "table" then _syncMod_sc = mod end
    return _syncMod_sc
end
_G.__secureChans = function()
    if os.clock() < _nextTry_sc then return _xchan end
    local sync = _getSyncMod()
    if not sync then _nextTry_sc = os.clock() + 0.1; return _xchan end
    if type(sync.GetAllChannels) ~= "function" then _nextTry_sc = os.clock() + 0.1; return _xchan end
    local mask = _getMask()
    if not mask then _nextTry_sc = os.clock() + 0.1; return _xchan end
    local ok, reg = pcall(secure_call, sync.GetAllChannels, mask)
    if ok and type(reg) == "table" then
        _xchan = reg; _nextTry_sc = os.clock() + 1.5
        _G.StickySyncDiag = "GetAllChannels (secure_call) - undetect/instant"
    else
        _nextTry_sc = os.clock() + 0.1
    end
    return _xchan
end

local function _retryGap()
    if (os.clock() - BOOT_T0) < BOOT_BURST then return BOOT_GAP end
    return RETRY_GAP
end

local function _channelCount(t)
    if type(t) ~= "table" then return 0 end
    local ok, hits = pcall(function()
        local h, n = 0, 0
        for _, v in next, t do
            n = n + 1
            if type(v) == "table" and type(rawget(v, "CacheTable")) == "table" then
                h = h + 1
            end
            
            if n >= 50 then break end
        end
        return h
    end)
    return (ok and hits) or 0
end

local function _module()
    if _mod then return _mod end
    local ok, m = pcall(function()
        return require(game:GetService("ReplicatedStorage").Packages.Synchronizer)
    end)
    if ok and type(m) == "table" then _mod = m; return _mod end
    local ok2, m2 = pcall(function()
        local pkgs = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
        local sync = pkgs and pkgs:FindFirstChild("Synchronizer")
        if not sync then return nil end
        return require(sync)
    end)
    if ok2 and type(m2) == "table" then _mod = m2 end
    return _mod
end

local function _probe(mod)
    local gu = (debug and debug.getupvalue) or getupvalue
    if type(gu) ~= "function" then return nil, 0, nil end
    local best, bestN, where = nil, 0, nil
    local function consider(t, tag)
        local n = _channelCount(t)
        if n > bestN then best, bestN, where = t, n, tag end
    end
    local cands = {
        { mod.Get, 10, 4, "Get/10/4" },
        { mod.GetAllChannels, 10, 1, "GetAll/10/1" },
        { mod.Wait, 10, 1, "Wait/10/1" },
    }
    for _, c in ipairs(cands) do
        if type(c[1]) == "function" then
            local o, u = pcall(gu, c[1], c[2])
            if o and type(u) == "table" then
                consider(rawget(u, c[3]), c[4])
                if bestN > 0 then return best, bestN, where end
            end
        end
    end
    for _, fn in ipairs({ mod.Get, mod.GetAllChannels, mod.Wait, mod.WaitAndCall, mod.GetTableFromChannel }) do
        if type(fn) == "function" then
            for i = 8, 12 do
                local o, u = pcall(gu, fn, i)
                if o and type(u) == "table" then
                    consider(u, "up" .. i)
                    for j = 1, 4 do consider(rawget(u, j), "up" .. i .. "/" .. j) end
                    if bestN > 0 then return best, bestN, where end
                end
            end
        end
    end
    local ok, up = pcall(gu, mod.Get, 9)
    if ok and type(up) == "table" then
        consider(rawget(up, 3), "Get/9/3")
        if bestN > 0 then return best, bestN, where end
        consider(up, "Get/9")
        if bestN > 0 then return best, bestN, where end
    end
    return best, bestN, where
end

local function _deepScan(mod)
    local gu = (debug and debug.getupvalue) or getupvalue
    if type(gu) ~= "function" then return nil, 0, nil end
    local best, bestN, where = nil, 0, nil
    local function consider(t, tag)
        local n = _channelCount(t)
        if n > bestN then best, bestN, where = t, n, tag end
    end
    local _fnCount = 0
    for fname, fn in next, mod do
        if type(fn) == "function" then
            _fnCount = _fnCount + 1
            if _fnCount > 30 then break end
            for i = 1, 16 do
                local o, u = pcall(gu, fn, i)
                if not o then break end
                if type(u) == "table" then
                    consider(u, tostring(fname) .. "/" .. i)
                    for j = 1, 4 do
                        consider(rawget(u, j), tostring(fname) .. "/" .. i .. "/" .. j)
                    end
                end
            end
        end
    end
    return best, bestN, where
end

local _gcFound, _gcFoundN, _gcState = nil, 0, "idle"

local function _gcScanOnce()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    local live, names, nLive = {}, {}, 0
    for _, p in ipairs(plots:GetChildren()) do live[p.Name] = true; nLive = nLive + 1; names[nLive] = p.Name end
    if nLive == 0 then return end

    local function score(t)
        local hits, seen = 0, 0
        for k, v in next, t do
            seen = seen + 1
            if type(k) == "string" and live[k]
                and type(v) == "table" and type(rawget(v, "CacheTable")) == "table" then
                hits = hits + 1
            end
            if seen >= 64 then break end
        end
        return hits
    end

    local best, bestN = nil, 0
    local hasFilter = type(filtergc) == "function"

    if hasFilter then
        local tries = {}
        if nLive >= 2 then tries[1] = { names[1], names[2], "CacheTable" } end
        tries[#tries + 1] = { names[1], "CacheTable" }
        if nLive >= 3 then tries[#tries + 1] = { names[2], names[3], "CacheTable" } end
        for _, keys in ipairs(tries) do
            local ok, res = pcall(filtergc, "table", { Keys = keys }, false)
            if ok and type(res) == "table" then
                for _, t in ipairs(res) do
                    if type(t) == "table" then
                        local n = score(t)
                        if n > bestN and n >= 2 then best, bestN = t, n end
                    end
                end
            end
            if bestN >= nLive then break end
        end
    end

    if bestN == 0 and type(getgc) == "function"
        and (not hasFilter or _G.StickyAllowFullGc == true)
        and not (_G.StickyIsTeleporting and _G.StickyIsTeleporting())
        and (os.clock() - (_G.__gcFullAt or 0)) >= (tonumber(_G.StickyFullGcGap) or 3.0)
        and (workspace.StreamingEnabled == false or os.clock() - _gameLoadAt >= 4.0) then
        _G.__gcFullAt = os.clock()
        pcall(function()
            local gc = getgc(true)
            local _gcLimit = math.min(#gc, 4000)
            for i = 1, _gcLimit do
                local t = gc[i]
                if type(t) == "table" then
                    local pk = 0
                    for k in next, t do
                        if type(k) == "string" and live[k] then pk = pk + 1; if pk >= 2 then break end end
                    end
                    if pk >= 2 then
                        local n = score(t)
                        if n > bestN and n >= 2 then best, bestN = t, n end
                    end
                    if bestN >= nLive then break end
                end
            end
        end)
    end
    if best and bestN > _gcFoundN then _gcFound, _gcFoundN = best, bestN end
end

local _gcLastScan = 0
local _gcRescans = 0
local _gcMiss, _gcLastPlots = 0, -1
local function _gcChans()
    if _gcFound then
        local _pl = workspace:FindFirstChild("Plots")
        local _nLive = _pl and #_pl:GetChildren() or 0
        if _G.StickySyncRescan == true and _gcFoundN < _nLive
            and _gcRescans < (tonumber(_G.StickySyncMaxRescan) or 20)
            and (os.clock() - _gcLastScan) >= (tonumber(_G.StickySyncRescanGap) or 3) then
            _gcLastScan = os.clock()
            _gcRescans = _gcRescans + 1
            _gcScanOnce()
        end
        return _gcFound, _gcFoundN, "gc/plot-key+CacheTable"
    end

    local _pl = workspace:FindFirstChild("Plots")
    local _n = _pl and #_pl:GetChildren() or 0
    if _n ~= _gcLastPlots then
        _gcLastPlots = _n

        _gcMiss = (_gcMiss > 2) and 2 or _gcMiss
        _gcLastScan = _gcLastScan - 0.05
    end

    local gap = tonumber(_G.StickySyncScanGap) or 0.2
    local back = math.min(_gcMiss * (tonumber(_G.StickySyncMissStep) or 0.15),
                          tonumber(_G.StickySyncMissMax) or 1)
    if os.clock() - _gcLastScan < (gap + back) then return nil, 0, nil end
    _gcLastScan = os.clock()
    _gcScanOnce()
    if _gcFound then
        _gcMiss = 0
        return _gcFound, _gcFoundN, "gc/plot-key+CacheTable"
    end

    if _n > 0 then _gcMiss = _gcMiss + 1 end
    return nil, 0, nil
end

local function _apiChans(mod)
    if type(mod) ~= "table" then return nil, 0, nil end
    local fn = rawget(mod, "GetAllChannels")
    if type(fn) ~= "function" then return nil, 0, nil end
    local function _accept(reg, tag)
        if type(reg) ~= "table" then return nil, 0, nil end
        local n = _channelCount(reg)
        if n > 0 then return reg, n, tag end
        return nil, 0, nil
    end

    if _G.StickyAllowSecureSyncCall ~= false and type(secure_call) == "function" then
        for _, form in ipairs({ "self", "plain" }) do
            local ok, reg = pcall(function()
                if form == "self" then return secure_call(fn, mod) end
                return secure_call(fn)
            end)
            if ok then
                local r, n, t = _accept(reg, "GetAllChannels/secure_call(" .. form .. ")")
                if r then return r, n, t end
            end
        end
    end
    if _G.StickyAllowRawSyncCall then
        for _, form in ipairs({ "self", "plain" }) do
            local ok, reg = pcall(function()
                if form == "self" then return fn(mod) end
                return fn()
            end)
            if ok then
                local r, n, t = _accept(reg, "GetAllChannels/RAW(" .. form .. ")")
                if r then return r, n, t end
            end
        end
    end
    return nil, 0, nil
end

local _xchan2, _nextTry2, _attempts2 = nil, 0, 0
local _xchan2Until = 0
local _nextApi = 0
local _chansLastScan = 0
local function _chans()
    if _xchan2 then
        local now = os.clock()
        if now < _xchan2Until then return _xchan2 end
        if _channelCount(_xchan2) > 0 then _xchan2Until = now + 2 return _xchan2 end
    end
    local now = os.clock()
    if now - _chansLastScan < 0.02 then return _xchan2 end
    if now < _nextTry2 then return _xchan2 end
    _chansLastScan = now
    _attempts2 = _attempts2 + 1

    local best, n, where
    if _G.StickyAllowSecureSyncCall ~= false and os.clock() >= _nextApi then
        local mod = _getSyncMod()
        if mod then best, n, where = _apiChans(mod) end
        if not best or n == 0 then _nextApi = os.clock() + (tonumber(_G.StickySyncApiGap) or 0.5) end
    end

    if not best or n == 0 then best, n, where = _gcChans() end

    if (not best or n == 0) and _attempts2 <= 400 and _G.StickyAllowUpvalueProbe then
        local mod = _getSyncMod()
        if mod then
            best, n, where = _probe(mod)
            local inBoot = _gameLoadAt and (os.clock() - _gameLoadAt) < 4
            if (not best or n == 0) and (not inBoot) and os.clock() - _lastDeep > 2 then
                _lastDeep = os.clock()
                _deepScans = _deepScans + 1
                best, n, where = _deepScan(mod)
            end
        end
    end
    if best and n > 0 then
        _xchan2 = best
        _G.StickySyncDiag = string.format("%s - %d channels", tostring(where), n)
        return _xchan2
    end

    local inBoot2 = _gameLoadAt and (os.clock() - _gameLoadAt) < 4
    _nextTry2 = os.clock() + (inBoot2 and 0.1 or ((_G.StickyScanMode == "fast") and 0.03 or 0.1))
    return _xchan2
end
_G.__secureChans = _chans

_G.StickySyncAll=function()return _chans()end
_G.StickySyncGet=function(idx)
local t=_chans()
if not t or idx==nil then return nil end
local ok,cd=pcall(rawget,t,idx)
if ok and type(cd)=="table" then return cd end
local ok2,cd2=pcall(function() return t[idx] end)
if ok2 and type(cd2)=="table" then return cd2 end
return nil
end
_G.sProp=function(ch,key)
if type(ch)~="table" or key==nil then return nil end
local ct=rawget(ch,"CacheTable")
if type(ct)~="table" then
local okC,c2=pcall(function() return ch.CacheTable end)
if okC and type(c2)=="table" then ct=c2 end
end
if type(ct)~="table" then return nil end
local v=rawget(ct,key)
if v~=nil then return v end
local okV,v2=pcall(function() return ct[key] end)
if okV then return v2 end
return nil
end
_G._StickyRawCT=function(plotName)
local c=_G.StickySyncGet(plotName)
if not c then return nil end
return rawget(c,"CacheTable")
end
local _AD,_MD,_TD
local function _data()
if _AD then return true end
local ok=pcall(function()

local R=game:GetService("ReplicatedStorage")
local d=R:FindFirstChild("Datas") or R:WaitForChild("Datas",2)
if not d then return end
local a=d:FindFirstChild("Animals") or d:WaitForChild("Animals",2)
if a then _AD=require(a) end
local m=d:FindFirstChild("Mutations") or d:WaitForChild("Mutations",2)
if m then _MD=require(m) end
local t=d:FindFirstChild("Traits") or d:WaitForChild("Traits",2)
if t then _TD=require(t) end
end)
return ok and _AD~=nil
end
_G._StickyGen=function(index,mutation,traits)
if not _data() then return 0 end
local info=_AD[index]
if not info or not info.Generation then return 0 end
local mult=1
if mutation and mutation~="None" and mutation~="" then
local m=_MD[mutation]
if m and m.Modifier then mult=mult+m.Modifier end
end
if type(traits)=="table" then
for _,tr in ipairs(traits)do
local t=_TD[tr]
if t and t.MultiplierModifier then mult=mult+t.MultiplierModifier end
end
end
return info.Generation*mult
end
local _sharedAnimals
_G._StickyAnimShim=setmetatable({GetGeneration=function(_,index,mutation,traits)return _G._StickyGen(index,mutation,traits)end},{
__index=function(_,k)

if not _sharedAnimals then
local ok,real=pcall(function()
local R=game:GetService("ReplicatedStorage")
local sh=R:FindFirstChild("Shared") or R:WaitForChild("Shared",3)
local an=sh and (sh:FindFirstChild("Animals") or sh:WaitForChild("Animals",3))
return an and require(an) or nil
end)
if ok and type(real)=="table" then _sharedAnimals=real end
end
if not _sharedAnimals then return nil end
return rawget(_sharedAnimals,k)
end})
_G.Sticky_GetPlotChannel=function(plotName)return _G.StickySyncGet(plotName)end
_G.Sticky_GetAllPlots=function()return _G.StickySyncAll() or {} end
_G.Sticky_GetPlotAnimalList=function(plotName)
local ct=_G._StickyRawCT(plotName)
local al=ct and ct.AnimalList
return type(al)=="table" and al or nil
end
end

_G.StickySyncAll  = _G.StickySyncAll
_G.StickySyncGet  = _G.StickySyncGet
_G.StickyRawCT    = _G._StickyRawCT
_G.StickyGen      = _G._StickyGen
_G.StickyAnimShim = _G._StickyAnimShim
_G.stealthGet    = function(n) return _G.StickySyncGet(n) end
_G.SyncInt       = {_cache={},_data=nil}

task.spawn(function()
    for i = 1, 260 do
        local t = _G.StickySyncAll()
        local pl = workspace:FindFirstChild("Plots")
        local kids = pl and pl:GetChildren()
        local want = kids and #kids or 0
        if want > 0 and type(t) == "table" then
            local have = 0
            for k = 1, want do
                if rawget(t, kids[k].Name) ~= nil then have = have + 1 end
            end
            if have >= want then _G.StickyChannelsReady = true return end
        end
        task.wait(i <= 100 and 0.04 or 0.1)
    end
end)

_G.StickyGetSyncData = _G.StickyGetSyncData or function(plot)
    local plotName = type(plot) == "string" and plot or (plot and plot.Name)
    if not plotName then return nil end
    local Pkgs = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
    local Sync = Pkgs and Pkgs:FindFirstChild("Synchronizer")
    if not Sync then return nil end
    local okMod, mod = pcall(require, Sync)
    if not okMod or type(mod) ~= "table" then return nil end

    local okT, data = pcall(function() return _G.StickyRawCT(plotName) end)
    if okT and type(data) == "table" then return data end

    local okC, ch = pcall(function() return _G.StickySyncGet(plotName) end)
    if okC and ch then
        local synth = { __channel = ch }
        pcall(function() local ct = rawget(ch, "CacheTable"); if type(ct)=="table" then synth.AnimalList = ct.AnimalList; synth.Owner = ct.Owner end end)
        return synth
    end
    return nil
end

_mkNextModTry = 0

function _StickyBuildDefaultBrainrotPriority()
    if not AnimalsData then return end
    table.clear(_brainrotDefaultPri)
    table.clear(_brainrotDefaultRarity)
    local rarities = { OG = 1, Secret = 2, ["Brainrot God"] = 3, ["Brainrot Titan"] = 4, ["Brainrot Legendary"] = 5, Legendary = 6, Mythic = 7, Epic = 8, Rare = 9, Uncommon = 10, Common = 11 }
    local list = {}
    for name, info in pairs(AnimalsData) do
        if type(info) == "table" then
            local r = tostring(info.Rarity or "Common")
            local rIdx = rarities[r] or 12
            table.insert(list, { name = info.DisplayName or name, index = name, r = r, rIdx = rIdx })
        end
    end
    table.sort(list, function(a, b)
        if a.rIdx ~= b.rIdx then return a.rIdx < b.rIdx end
        return (a.name or a.index) < (b.name or b.index)
    end)
    for i, v in ipairs(list) do
        local nn = _normName(v.name)
        local ni = _normName(v.index)
        _brainrotDefaultPri[nn] = i
        _brainrotDefaultRarity[nn] = v.r
        if _brainrotDefaultPri[ni] == nil then
            _brainrotDefaultPri[ni] = i
            _brainrotDefaultRarity[ni] = v.r
        end
    end
    if #_G.SHARED_PRIORITY_ITEMS == 0 then
        local cap = tonumber(_G.StickyDefaultPrioCap) or 60
        for i, v in ipairs(list) do
            if i > cap then break end
            _G.SHARED_PRIORITY_ITEMS[i] = v.name
        end
    end
    _G.StickyPriVersion = (_G.StickyPriVersion or 0) + 1
end

function loadModules()
    if AnimalsData then
        if not AnimalsShared and _G.StickyAnimShim then AnimalsShared = _G.StickyAnimShim end
        return true
    end
    if os.clock() < _mkNextModTry then return false end
    _mkNextModTry = os.clock() + (tonumber(_G.StickyModRetry) or 0.5)
    pcall(function()
        local Datas = RS:FindFirstChild("Datas") or RS:WaitForChild("Datas", 1.5)
        if Datas then
            local a = Datas:FindFirstChild("Animals") or Datas:WaitForChild("Animals", 1.5)
            if a then AnimalsData = require(a) end
        end
    end)
    pcall(_StickyBuildDefaultBrainrotPriority)
    AnimalsShared = _G.StickyAnimShim
    if not NumberUtils then
        pcall(function()
            local Utils = RS:FindFirstChild("Utils")
            local n = Utils and Utils:FindFirstChild("NumberUtils")
            if n then NumberUtils = require(n) end
        end)
    end
    return AnimalsData ~= nil
end

function loadNet() return false end

function getRemote(method, name)
    return _G.__secureGetRemote(method, name)
end
_G.StickyGetRemote = getRemote

do
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local RS = game:GetService("ReplicatedStorage")
	local LP = Players.LocalPlayer

	local getRemote
	do
		local _netFolder
		local function _netDir()
			if _netFolder then return _netFolder end
			local pk = RS:FindFirstChild("Packages") or RS:WaitForChild("Packages", 10)
			if not pk then return nil end
			_netFolder = pk:FindFirstChild("Net") or pk:WaitForChild("Net", 10)
			return _netFolder
		end
		local _net
		local function _getNet()
			if _net then return _net end
			local dir = _netDir()
			if not dir then return nil end
			local ok, m = pcall(require, dir)
			if ok and type(m) == "table" then _net = m end
			return _net
		end
		local _queue, _hooked, _original = {}, false, nil
		local function _host()
			if type(getconnections) ~= "function" then return nil end
			for _, sig in ipairs({ RunService.Heartbeat, RunService.RenderStepped, RunService.PostSimulation }) do
				local ok, conns = pcall(getconnections, sig)
				if ok and type(conns) == "table" then
					for _, c in ipairs(conns) do
						local f = c.Function
						if f and f ~= _G.__lefaSyncHost and type(islclosure) == "function" and islclosure(f)
							and (type(isexecutorclosure) ~= "function" or not isexecutorclosure(f)) then
							local s = select(2, pcall(debug.info, f, "s"))
							if type(s) == "string" and s:find("^ReplicatedStorage%.") and not s:find("ReplicatedFirst") then
								return f
							end
						end
					end
				end
			end
			return nil
		end
		local function _install()
			if _hooked then return true end
			if type(hookfunction) ~= "function" then return false end
			if not _getNet() then return false end
			local h = _host()
			if not h then return false end
			_G.__lefaNetHost = h
			local w = function(...)
				local job = table.remove(_queue, 1)
				if job then
					local ok, r = pcall(_net[job.kind], _net, job.name)
					job.result = (ok and typeof(r) == "Instance") and r or nil
					job.done = true
				end
				return _original(...)
			end
			local ok, env = pcall(getfenv, h)
			if ok and type(env) == "table" then pcall(setfenv, w, env) end
			_original = hookfunction(h, w)
			_hooked = true
			return true
		end
		local _cache = {}
		local function _get(name, kind)
			kind = (kind == "RemoteFunction" and "RemoteFunction")
				or (kind == "UnreliableRemoteEvent" and "UnreliableRemoteEvent")
				or "RemoteEvent"
			if type(name) ~= "string" or name == "" then return nil end
			local logical = name:match("^R[EF]/(.+)$") or name:match("^URE/(.+)$") or name
			local ck = kind .. "|" .. logical
			local hit = _cache[ck]
			if hit and hit.Parent then return hit end
			_cache[ck] = nil
			if not _getNet() then return nil end
			if not _install() then
				if type(_G.__secureGetRemote) == "function" then
					local r = _G.__secureGetRemote(kind, logical)
					if r and r.Parent then _cache[ck] = r; return r end
				end
				if type(_G.StickyGetRemote) == "function" then
					local r = _G.StickyGetRemote(kind, logical)
					if r and r.Parent then _cache[ck] = r; return r end
				end
				return nil
			end
			local job = { kind = kind, name = logical }
			table.insert(_queue, job)
			local t = os.clock() + (tonumber(_G.LefaNetTimeout) or 5)
			while not job.done and os.clock() < t do RunService.Heartbeat:Wait() end
			if job.result and job.result.Parent then
				_cache[ck] = job.result
				return job.result
			end
			return nil
		end
		_G.__lefaGetRemote = _G.__lefaGetRemote or function(method, name) return _get(name, method) end
		getRemote = function(method, name) return _get(name, method) end
	end

	local GRAPPLE_ARG = 0.8
	local _grappleUseItem, _grappleItemUse

	task.spawn(function() _grappleUseItem = getRemote("RemoteEvent", "UseItem") end)
	task.spawn(function() _grappleItemUse = getRemote("RemoteEvent", "75c9466d-e4c0-4b02-b26a-c3615fcc1e42") end)

	local function _fireGrapple()
		local fired = false
		if not (_grappleUseItem and _grappleUseItem.Parent) then
			_grappleUseItem = getRemote("RemoteEvent", "UseItem")
		end
		if not (_grappleItemUse and _grappleItemUse.Parent) then
			_grappleItemUse = getRemote("RemoteEvent", "75c9466d-e4c0-4b02-b26a-c3615fcc1e42")
		end
		if _grappleUseItem and _grappleUseItem.Parent then
			pcall(function() _grappleUseItem:FireServer(GRAPPLE_ARG) end)
			fired = true
		end
		if _grappleItemUse and _grappleItemUse.Parent then
			pcall(function() _grappleItemUse:FireServer(GRAPPLE_ARG) end)
			fired = true
		end
		if not fired then
			local r = getRemote("RemoteEvent", "UseItem")
			if r then
				pcall(function() r:FireServer(GRAPPLE_ARG) end)
				fired = true
			end
		end
		if fired then _G.LastGrappleAt = os.clock() end
		return fired
	end

	local function fireGrapple(destino)
		local char = LP.Character
		if not char then return false end
		if not char:FindFirstChild("Grapple Hook") then
			local bp = LP:FindFirstChild("Backpack")
			local tool = bp and bp:FindFirstChild("Grapple Hook")
			local hum = char:FindFirstChildOfClass("Humanoid")
			if tool and hum then pcall(function() hum:EquipTool(tool) end) end
			task.wait(0.05)
			char = LP.Character or char
		end
		if not char:FindFirstChild("Grapple Hook") then return false end
		return _fireGrapple()
	end

	_G.StickyFireGrapple2 = function(value, exato)
		return fireGrapple(value)
	end
	_G.Sticky_FireGrapple = _G.StickyFireGrapple2
	_G.StickyFireGrapple = fireGrapple
	_G.StickyFireGrappleBoth = function(...)
		return fireGrapple(...)
	end
	_G.LefaFireGrapple = fireGrapple
	_G.StickyGrappleReady = function()
		return true
	end

	function fireGrappleBeforeTP(destino)
		local char = LP.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not char or not hum then return false end
		local justEquipped = false
		if not char:FindFirstChild("Grapple Hook") then
			local bp = LP:FindFirstChild("Backpack")
			local g = bp and bp:FindFirstChild("Grapple Hook")
			if g then
				pcall(function() hum:EquipTool(g) end)
				justEquipped = true
			end
		end
		if justEquipped or not char:FindFirstChild("Grapple Hook") then
			local waitS = math.max(0.05, (tonumber(_G.StickyGrappleWaitMs) or tonumber(_G.StickyGrappleWaitMs) or 200) / 1000)
			pcall(function() char:WaitForChild("Grapple Hook", waitS) end)
		end
		if justEquipped then
			task.wait((tonumber(_G.StickyGrappleSettleMs) or tonumber(_G.StickyGrappleSettleMs) or 60) / 1000)
		end
		char = LP.Character
		if not (char and char:FindFirstChild("Grapple Hook")) then return false end
		local res = _fireGrapple()
		_G.__StickyGrapplePrimed = true
		RunService.Heartbeat:Wait()
		RunService.Heartbeat:Wait()
		return res and true or false
	end
	_G.StickyFireGrappleBeforeTP = fireGrappleBeforeTP

	_G.__StickyLefaFireGrapple = fireGrapple
	rawset(getfenv and getfenv(0) or _G, "fireGrapple", fireGrapple)
	getgenv = getgenv or function() return _G end
	pcall(function()
		if type(getgenv) == "function" then
			getgenv().fireGrapple = fireGrapple
			getgenv().fireGrappleBeforeTP = fireGrappleBeforeTP
		end
	end)
end

function fireGrapple(destino)
	if type(_G.StickyFireGrapple2) == "function" then
		return _G.StickyFireGrapple2(destino)
	end
	return false
end
function fireGrappleBeforeTP(destino)
	if type(_G.StickyFireGrappleBeforeTP) == "function" then
		return _G.StickyFireGrappleBeforeTP(destino)
	end
	return fireGrapple(destino)
end
_G.StickyFireGrapple = fireGrapple

CARPET_SPEED = 280
INBASE_SPEED = 450
SKY_CLONE_WAIT = 0.35
CARPET_NAMES = { "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings" }

FLY_TOOLS = { "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings" }
function findTool(name)
    local char = LP.Character
    local bp = LP:FindFirstChild("Backpack")
    return (char and char:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
end
GRAPPLE_NAMES = { "Grapple Hook" }
function findGrapple()
    for _, n in ipairs(GRAPPLE_NAMES) do
        local t = findTool(n)
        if t and t:IsA("Tool") then return t, n end
    end
    return nil
end
function listTools()
    local out, char, bp = {}, LP.Character, LP:FindFirstChild("Backpack")
    if char then for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then out[#out + 1] = t.Name end end end
    if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then out[#out + 1] = t.Name end end end
    return table.concat(out, ", ")
end
_lastCarpetName = nil
function equipCarpet()
    local char = LP.Character
    if not char then return nil end
    if _lastCarpetName then
        local t = char:FindFirstChild(_lastCarpetName)
        if t and t.Parent == char then return _lastCarpetName end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    for _, n in ipairs(CARPET_NAMES) do
        local t = findTool(n)
        if t and t:IsA("Tool") then
            if t.Parent ~= char then pcall(function() hum:EquipTool(t) end) end
            _lastCarpetName = n
            return n
        end
    end
    return nil
end
function setCarpetTool(name)
    if type(name) ~= "string" or name == "" then return end
    _G.StickyCarpetTool = name

    _lastCarpetName = nil
    for i = #CARPET_NAMES, 1, -1 do
        if CARPET_NAMES[i] == name then table.remove(CARPET_NAMES, i) end
    end
    table.insert(CARPET_NAMES, 1, name)
end
_G.StickySetCarpetTool = setCarpetTool
if type(_G.StickyCarpetTool) == "string" and _G.StickyCarpetTool ~= "" then
    setCarpetTool(_G.StickyCarpetTool)
end
_carpetEngaging = false
function carpetEngage(force)
    if not force then
        local c = LP.Character
        if c then
            for _, n in ipairs(CARPET_NAMES) do
                local t = c:FindFirstChild(n)
                if t and t:IsA("Tool") then
                    _G.TPEngage = "carpet=" .. tostring(n)
                    return n
                end
            end
        end
    end
    if _carpetEngaging then
        local _tw = os.clock()
        repeat RunService.Heartbeat:Wait() until (not _carpetEngaging) or os.clock() - _tw > 6
        local c = LP.Character
        if c then
            for _, n in ipairs(CARPET_NAMES) do
                local t = c:FindFirstChild(n)
                if t and t:IsA("Tool") then return n end
            end
        end
    end
    _carpetEngaging = true
    local _t0 = os.clock()
    while not findTool("Grapple Hook") and os.clock() - _t0 < (tonumber(_G.StickyGrappleToolWait) or 5) do
        RunService.Heartbeat:Wait()
    end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then _carpetEngaging = false; return nil end

    if not char:FindFirstChild("Grapple Hook") then
        local g = findTool("Grapple Hook")
        if g then pcall(function() hum:EquipTool(g) end) end
    end
    local _te = os.clock()
    while not (LP.Character and LP.Character:FindFirstChild("Grapple Hook")) and os.clock() - _te < 1.5 do
        local c = LP.Character
        local h2 = c and c:FindFirstChildOfClass("Humanoid")
        local g = findTool("Grapple Hook")
        if g and h2 then pcall(function() h2:EquipTool(g) end) end
        RunService.Heartbeat:Wait()
    end
    if LP.Character and LP.Character:FindFirstChild("Grapple Hook") then
        (function()
            if type(_G.StickyFireGrapple2) == "function" then
                return _G.StickyFireGrapple2()
            elseif type(fireGrapple) == "function" then
                return fireGrapple()
            end
            return false
        end)()
    end
    task.wait(0.06)
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then pcall(function() h:UnequipTools() end) end
    task.wait(0.04)
    local cn
    local _tc = os.clock()
    repeat
        cn = equipCarpet()
        local c = LP.Character
        if cn and c and c:FindFirstChild(cn) then break end
        RunService.Heartbeat:Wait()
    until os.clock() - _tc > 0.5
    _G.TPEngage = "carpet=" .. tostring(cn)
    _carpetEngaging = false
    return cn
end

_G.StickyEquipCarpet = equipCarpet
_G.StickyCarpetEngaging = function() return _carpetEngaging end

if _G.StickyKeepCarpet == nil then _G.StickyKeepCarpet = true end
LP.CharacterAdded:Connect(function(c)
    if _G.StickyKeepCarpet == false then return end
    task.spawn(function()
        c:WaitForChild("Humanoid", 10)
        task.wait(tonumber(_G.StickyCarpetRespawnDelay) or 0.6)
        if _G.StickyKeepCarpet == false then return end
        if _carpetEngaging or LP.Character ~= c then return end
        if LP:GetAttribute("Stealing") == true then return end
        for _, n in ipairs(CARPET_NAMES) do
            if c:FindFirstChild(n) then return end
        end
        pcall(equipCarpet)
    end)
end)

PET_PRIORITY_TIERS = {
    [1] = { pets = {"Headless Horseman"}, threshold = 0 },
    [2] = { pets = {"Signore Carapace"}, threshold = 0 },
    [3] = { pets = {"John Pork"}, threshold = 0 },
    [4] = { pets = {"Strawberry Elephant"}, threshold = 0 },
    [5] = { pets = {"Arcadragon"}, threshold = 5e9 },
    [6] = { pets = {"Elefanto Frigo"}, threshold = 10e9 },
    [7] = { pets = {"Meowl"}, threshold = 5e9 },
    [8] = { pets = {"Skibidi Toilet"}, threshold = 5e9 },
    [9] = { pets = {"Love Love Bear"}, threshold = 0 },
    [10] = { pets = {"Antonio"}, threshold = 0 },
    [11] = { pets = {"Pancake and Syrup"}, threshold = 0 },
    [12] = { pets = {"Griffin"}, threshold = 0 },
    [13] = { pets = {"Globa Steppa","La Supreme Combinasion","Fishino Clownino","Dragon Gingerini","Tirilikalika Tirilikalako"}, threshold = 5e9 },
    [14] = { pets = {"Ginger Gerat","Pet"}, threshold = 10e9 },
    [15] = { pets = {"Hydra Bunny","Digi Narwhal","Kalika Bros"}, threshold = 3e9 },
    [16] = { pets = {"Hydra Dragon Cannelloni","Dragon Cannelloni","Bunny and Eggy"}, threshold = 3e9 },
    [17] = { pets = {"Ketupat Bros","Rosey and Teddy","La Casa Boo","Fragola la la"}, threshold = 3e9 },
    [18] = { pets = {"Fragola La La La","Cerberus","Guest 666","Los Hackers"}, threshold = 1e9 },
    [19] = { pets = {"Garama and Madunung","Spooky and Pumpky","Reinito Sleighito","Burguro And Fryuro","Cooki and Milki","Fragrama and Chocrama","La Food Combinasion","Los Amigos","Foxini Lanternini","Capitano Moby","Fortunu and Cashuru","Los Sekolahs","Celestial Pegasus"}, threshold = 750e6 },
    [20] = { pets = {"La Secret Combinasion","Sammyni Fattini","Cloverat Clapat","Popcuru and Fizzuru"}, threshold = 1e9 },
}

TIER_LOOKUP = {}
for tier, data in pairs(PET_PRIORITY_TIERS) do
    for _, name in ipairs(data.pets) do TIER_LOOKUP[name] = tier end
end

LOCKED_TIERS = { [1]=true, [2]=true, [3]=true, [4]=true }

DIRECT_THRESHOLDS = {
    [3] = { [4] = 10e9 },
    [4] = {},
    [5] = { [6] = math.huge },
    [6] = { [9] = math.huge, [10] = math.huge, [12] = 15e9 },
    [10] = { [12] = 20e9 },
    [11] = { [12] = 10e9 },
}

MUTATION_PRIORITY = {
    ["Galaxy"]=1,["Candy"]=1,["Yin Yang"]=1,["YinYang"]=1,["Divine"]=1,
    ["Cursed"]=1,["Lava"]=1,["Radioactive"]=1,["Cyber"]=1,["Rainbow"]=1,["Bloodrot"]=2,
}

TRAIT_PRIORITY = {}

MUTATION_ICONS, TRAIT_ICONS = {}, {}

function _StickyLoadGameData()
    local ok1, mData = pcall(function() return require(game.ReplicatedStorage.Datas.Mutations) end)
    if ok1 and type(mData) == "table" then
        local mList = {}
        for name, data in pairs(mData) do
            if type(data) == "table" then
                MUTATION_ICONS[name] = data.Icon
                mList[#mList + 1] = name
            end
        end
        table.sort(mList)
        if #_G.SHARED_MUTATION_PRIORITY == 0 then
            for i = 1, #mList do _G.SHARED_MUTATION_PRIORITY[i] = mList[i] end
        end
    end
    local ok2, tData = pcall(function() return require(game.ReplicatedStorage.Datas.Traits) end)
    if ok2 and type(tData) == "table" then
        local tList = {}
        for name, data in pairs(tData) do
            if type(data) == "table" then
                TRAIT_ICONS[name] = data.Icon
                tList[#tList + 1] = name
            end
        end
        table.sort(tList)
        if #_G.SHARED_TRAIT_PRIORITY == 0 then
            for i = 1, #tList do _G.SHARED_TRAIT_PRIORITY[i] = tList[i] end
        end
    end
end

task.spawn(function()
    pcall(function()
        local Datas = game:GetService("ReplicatedStorage"):FindFirstChild("Datas")
        local a = Datas and Datas:FindFirstChild("Animals")
        if a and not AnimalsData then AnimalsData = require(a) end
        if AnimalsData then _StickyBuildDefaultBrainrotPriority() end
    end)
    pcall(_StickyLoadGameData)
end)

function getMutPrio(m)
    if not m or m == "" or m == "None" then return 0 end
    local n = tostring(m)
    local dis = _G.SHARED_MUTATION_DISABLED
    if type(dis) == "table" and (dis[n] or dis[_normName(n)]) then return 0 end
    local idx = _priIndexOfMut(n)
    if not idx then
        n = n:lower():gsub("[%s%-_]","")
        idx = _priIndexOfMut(n)
    end
    if idx then return 999 - idx end
    if MUTATION_PRIORITY[m] then return MUTATION_PRIORITY[m] end
    if MUTATION_PRIORITY[n] then return MUTATION_PRIORITY[n] end
    return 0
end

function getTraitPrio(t)
    if not t or t == "" then return 0 end
    local name = type(t) == "table" and t.name or tostring(t)
    local n = name
    local idx = _priIndexOfTrait(n)
    if not idx then
        n = n:lower():gsub("[%s%-_]","")
        idx = _priIndexOfTrait(n)
    end
    if idx then return 999 - idx end
    if TRAIT_PRIORITY[name] then return TRAIT_PRIORITY[name] end
    if TRAIT_PRIORITY[n] then return TRAIT_PRIORITY[n] end
    return 0
end

function getCumThreshold(hi, lo)
    if DIRECT_THRESHOLDS[hi] and DIRECT_THRESHOLDS[hi][lo] then return DIRECT_THRESHOLDS[hi][lo] end
    if LOCKED_TIERS[hi] then return math.huge end
    local total = 0
    for t = hi + 1, lo do
        local td = PET_PRIORITY_TIERS[t]
        if td and td.threshold > 0 then total = total + td.threshold end
    end
    return total
end

function _normName(s)
    return tostring(s):lower():gsub("[%s%-_'%.]", "")
end
_priCacheVer, _priCache = -1, {}
_brainrotDefaultPri = {}
_brainrotDefaultRarity = {}
_mutPriCacheVer, _mutPriCache = -1, {}
_traitPriCacheVer, _traitPriCache = -1, {}

function _priLookup(listName)
    local ver = _G.StickyPriVersion or 0
    if listName == "mutation" then
        if _mutPriCacheVer ~= ver then
            table.clear(_mutPriCache)
            local plist = _G.SHARED_MUTATION_PRIORITY
            if type(plist) == "table" then
                for i = #plist, 1, -1 do _mutPriCache[_normName(plist[i])] = i end
            end
            _mutPriCacheVer = ver
        end
        return _mutPriCache
    elseif listName == "trait" then
        if _traitPriCacheVer ~= ver then
            table.clear(_traitPriCache)
            local plist = _G.SHARED_TRAIT_PRIORITY
            if type(plist) == "table" then
                for i = #plist, 1, -1 do _traitPriCache[_normName(plist[i])] = i end
            end
            _traitPriCacheVer = ver
        end
        return _traitPriCache
    else
        if _priCacheVer ~= ver then
            table.clear(_priCache)
            local plist = _G.SHARED_PRIORITY_ITEMS
            if type(plist) == "table" then
                for i = #plist, 1, -1 do _priCache[_normName(plist[i])] = i end
            end
            _priCacheVer = ver
        end
        return _priCache
    end
end
_G.StickyPriLookup = function() return _priLookup() end
function _priIndexOf(name)
    if not name then return nil end
    local n = _normName(name)
    local idx = _priLookup()[n]
    if idx then return idx end
    local def = _brainrotDefaultPri[n]
    if def and _brainrotDefaultRarity[n] == "OG" then
        return def * 0.001
    end
    return nil
end
function _priIndexOfMut(name)
    if not name then return nil end
    return _priLookup("mutation")[_normName(name)]
end
function _priIndexOfTrait(name)
    if not name then return nil end
    return _priLookup("trait")[_normName(name)]
end

function petOutranks(aName, bName, aMut, bMut, aMPS, bMPS, aTraits, bTraits)
    local iA = _priIndexOf(aName)
    local iB = _priIndexOf(bName)
    if iA ~= nil and iB ~= nil then
        if iA ~= iB then return iA < iB end
    end
    if (iA ~= nil) ~= (iB ~= nil) then return iA ~= nil end
    if iA == nil and iB == nil then
        if (aMPS or 0) ~= (bMPS or 0) then return (aMPS or 0) > (bMPS or 0) end
    end
    local ma, mb = getMutPrio(aMut), getMutPrio(bMut)
    if ma ~= mb then return ma > mb end
    if type(aTraits) == "table" and type(bTraits) == "table" then
        local pa, pb = 0, 0
        for _, t in ipairs(aTraits) do pa = math.max(pa, getTraitPrio(t)) end
        for _, t in ipairs(bTraits) do pb = math.max(pb, getTraitPrio(t)) end
        if pa ~= pb then return pa > pb end
    end
    return (aMPS or 0) > (bMPS or 0)
end

function getPlotChannel(plotName)
    local channel
    pcall(function() channel = _G.StickySyncGet(plotName) end)
    return channel
end

function channelGet(channel, key)
    if not channel then return nil end
    local ok, v = pcall(function()
        local ct = rawget(channel, "CacheTable")
        if type(ct) == "table" then
            local r = rawget(ct, key)
            if r ~= nil then return r end
        end
        local d = rawget(channel, "Data")
        if type(d) == "table" then
            local r = rawget(d, key)
            if r ~= nil then return r end
        end
        return rawget(channel, key)
    end)
    if ok then return v end
    return nil
end

function _ownerIsMe(owner)
    if not owner then return false end
    local result = false
    pcall(function()
        if typeof(owner) == "Instance" and owner:IsA("Player") then
            result = owner.UserId == LP.UserId
        elseif type(owner) == "table" and owner.UserId then
            result = owner.UserId == LP.UserId
        elseif typeof(owner) == "Instance" then
            result = owner == LP
        elseif type(owner) == "string" then
            result = owner:lower() == LP.Name:lower()
                or owner:lower() == (LP.DisplayName or LP.Name):lower()
        end
    end)
    return result
end

function isMyPlot(channel)
    if not channel then return false end
    return _ownerIsMe(channelGet(channel, "Owner"))
end

_ownerInGameCache, _ownerInGameAt = {}, {}
function _ownerInGame(owner)
    if not owner then return false end
    local cacheKey
    if typeof(owner) == "Instance" then cacheKey = "i:" .. tostring(owner)
    elseif type(owner) == "number" then cacheKey = "n:" .. owner
    elseif type(owner) == "string" then cacheKey = "s:" .. owner:lower()
    else cacheKey = "o:" .. tostring(owner) end
    local now = os.clock()
    local cached = _ownerInGameAt[cacheKey]
    if cached and (now - cached.t) < 2 then return cached.v end
    local inGame = false
    pcall(function()
        if typeof(owner) == "Instance" and owner:IsA("Player") then
            inGame = owner.Parent == Players
        elseif type(owner) == "number" then
            inGame = Players:GetPlayerByUserId(owner) ~= nil
        elseif type(owner) == "table" and owner.Name then
            inGame = Players:FindFirstChild(tostring(owner.Name)) ~= nil
        elseif typeof(owner) == "Instance" and owner.Name then
            inGame = Players:FindFirstChild(owner.Name) ~= nil
        elseif type(owner) == "string" then
            if Players:FindFirstChild(owner) then
                inGame = true
            else
                local lo = owner:lower()
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl.Name:lower() == lo or (pl.DisplayName or ""):lower() == lo then inGame = true break end
                end
            end
        end
    end)
    _ownerInGameCache[cacheKey] = { v = inGame, t = now }
    _ownerInGameAt[cacheKey] = { v = inGame, t = now }
    return inGame
end

function ownerInGame(channel)
    if not channel then return false end
    return _ownerInGame(channelGet(channel, "Owner"))
end

_petModelCache = setmetatable({}, { __mode = "v" })
_genCache = {}

local _MPS_SUFFIX = { K = 1e3, M = 1e6, B = 1e9, T = 1e12, Q = 1e15 }
_wmpsCache, _wmpsAt = {}, {}
function _worldMPS(plot, slot)
    local podiums = plot and plot:FindFirstChild("AnimalPodiums")
    local podium = podiums and podiums:FindFirstChild(tostring(slot))
    if not podium then return nil end

    local _ck = plot.Name .. "\0" .. tostring(slot)
    local _now = os.clock()
    if _wmpsAt[_ck] and (_now - _wmpsAt[_ck]) < (tonumber(_G.StickyWorldMPSTTL) or 1) then
        return _wmpsCache[_ck]
    end
    local best = nil
    local function _scanLabels(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                local txt = child.Text
                if type(txt) == "string" and txt ~= "" then
                    local num, suf = txt:match("%$%s*([%d%.]+)%s*([KMBTQ]?)%s*/s")
                    if num then
                        local v = tonumber(num)
                        if v then
                            v = v * (_MPS_SUFFIX[suf] or 1)
                            if not best or v > best then best = v end
                        end
                    end
                end
            end
            _scanLabels(child)
        end
    end
    _scanLabels(podium)
    _wmpsCache[_ck], _wmpsAt[_ck] = best, _now
    return best
end
function getPetPosition(plot, slot, strict)
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(tostring(slot))
    if not podium then return nil end

    local key = plot.Name .. "\0" .. tostring(slot)
    local cached = _petModelCache[key]
    if cached and cached.Parent and cached:IsDescendantOf(podium) then
        local ok, cf = pcall(function() return cached:GetBoundingBox() end)
        if ok then return cf.Position end
    end
    _petModelCache[key] = nil

    local _skipNames = { Claim = true, Base = true, Decorations = true }
    local function _findModel(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("Model") and not _skipNames[child.Name] then
                if child:FindFirstChildWhichIsA("MeshPart", true) then
                    return child
                end
            end
            local found = _findModel(child)
            if found then return found end
        end
        return nil
    end

    local model = _findModel(podium)
    if model then
        local ok, cf = pcall(function() return model:GetBoundingBox() end)
        if ok then
            _petModelCache[key] = model
            return cf.Position
        end
    end

    if strict then return nil end
    local ok, cf = pcall(function() return podium:GetPivot() end)
    if ok then return cf.Position end
    return podium.Position
end

function scanAllPets()
    local pets = {}
    if not loadModules() then
        _G.StickyScanTotal, _G.StickyScanUsed, _G.StickyScanNoChan = 0, 0, 8
        return pets
    end

    local Plots = workspace:FindFirstChild("Plots")
    if not Plots then
        _G.StickyScanTotal, _G.StickyScanUsed, _G.StickyScanNoChan = 0, 0, 8
        return pets
    end

    local _mkSeen, _mkUse, _mkTotal = 0, 0, 0
    local _mkNoChan = 0
    local _mkTags = {}
    for _, plot in ipairs(Plots:GetChildren()) do
        _mkTotal = _mkTotal + 1
        local channel = getPlotChannel(plot.Name)
        if not channel then _mkTags[#_mkTags + 1] = "nochan" _mkNoChan = _mkNoChan + 1 continue end
        _mkSeen = _mkSeen + 1
        local owner = channelGet(channel, "Owner")
        if _ownerIsMe(owner) then _G.StickyMyPlot = plot.Name _mkTags[#_mkTags + 1] = "MINE" continue end
        if _G.StickyMyPlot == plot.Name then _mkTags[#_mkTags + 1] = "MINE" continue end
        if not _G.StickyMyPlot and owner == nil then _mkTags[#_mkTags + 1] = "noowner?" continue end
        if _G.StickyRequireOwner ~= false and not _ownerInGame(owner) then _mkTags[#_mkTags + 1] = "left" continue end
        _mkUse = _mkUse + 1

        local animalList = channelGet(channel, "AnimalList")
        if not animalList then _mkTags[#_mkTags + 1] = "nolist" continue end
        local _mkPlotN = 0

        for slot, animalData in pairs(animalList) do
            if type(animalData) ~= "table" then continue end
            local animalName = animalData.Index
            if not animalName then continue end
            local animalInfo = AnimalsData and AnimalsData[animalName]
            if not animalInfo and _G.StickyRequireKnown == true then continue end
            if _StickyIsFusing(animalData) then continue end

            local mutation = animalData.Mutation or "None"
            local traits = animalData.Traits
            if type(traits) ~= "table" then traits = {} end

            local genValue
            local _gk = plot.Name .. "\0" .. tostring(slot)
            local _gc = _genCache[_gk]
            if _gc and _gc.n == animalName and _gc.m == animalData.Mutation and _gc.t == animalData.Traits then
                genValue = _gc.g
            else
                genValue = 0
                pcall(function()
                    local shim = AnimalsShared or _G.StickyAnimShim
                    if shim then genValue = shim:GetGeneration(animalName, animalData.Mutation, animalData.Traits, nil) end
                end)
                if genValue and genValue > 0 then
                    _genCache[_gk] = { n = animalName, m = animalData.Mutation, t = animalData.Traits, g = genValue }
                end
            end
            if (not genValue or genValue <= 0) and _G.StickyWorldMPS ~= false then
                local wm = _worldMPS(plot, slot)
                if wm and wm > 0 then genValue = wm end
            end

            local displayName = (animalInfo and animalInfo.DisplayName) or animalName

            local pos = getPetPosition(plot, slot, (_G.StickyRequireOwner == false) or (_G.StickyRequireModel == true))

            if pos then
                if genValue >= (tonumber(_G.StickyMinMPS) or 0) then
                    table.insert(pets, {
                        name = displayName,
                        index = animalName,
                        mps = genValue,
                        mutation = mutation,
                        traits = traits,
                        position = pos,
                        plot = plot.Name,
                        slot = tostring(slot),
                    })
                    _mkPlotN = _mkPlotN + 1
                end
            end
        end
        _mkTags[#_mkTags + 1] = tostring(_mkPlotN)
    end

    _G.StickyScanTotal, _G.StickyScanUsed, _G.StickyScanNoChan = _mkTotal, _mkUse, _mkNoChan
    _G.StickyScanInfo = string.format("plots %d scanned of %d  pets %d  [%s]  %s", _mkUse, _mkTotal, #pets, table.concat(_mkTags, " "), tostring(_G.StickyScanMode))
    local function _bestTraitPrio(traits)
        if type(traits) ~= "table" then return 0 end
        local best = 0
        for _, t in ipairs(traits) do
            local p = getTraitPrio(t)
            if p > best then best = p end
        end
        return best
    end

    for _, p in ipairs(pets) do
        p._pri = _priIndexOf(p.name) or (p.index and _priIndexOf(p.index)) or nil
        p._mp = tonumber(p.mps) or 0
        p._mut = getMutPrio(p.mutation)
        p._trait = _bestTraitPrio(p.traits)
    end

    local function _petOrder(a, b)
        local ia, ib = a._pri, b._pri
        if (ia ~= nil) ~= (ib ~= nil) then return ia ~= nil end
        if ia and ib and ia ~= ib then return ia < ib end
        if ia == nil then
            if a._mp ~= b._mp then return a._mp > b._mp end
        end
        if a._mut ~= b._mut then return a._mut > b._mut end
        if a._trait ~= b._trait then return a._trait > b._trait end
        if a._mp ~= b._mp then return a._mp > b._mp end
        local pa, pb = tostring(a.plot), tostring(b.plot)
        if pa ~= pb then return pa < pb end
        return (tonumber(a.slot) or 0) < (tonumber(b.slot) or 0)
    end

    local mode = _G.StickyStealMode
    if mode == "highest" then
        table.sort(pets, function(a, b)
            local ma, mb = tonumber(a.mps) or 0, tonumber(b.mps) or 0
            if ma ~= mb then return ma > mb end
            local pa, pb = tostring(a.plot), tostring(b.plot)
            if pa ~= pb then return pa < pb end
            return (tonumber(a.slot) or 0) < (tonumber(b.slot) or 0)
        end)
        return pets
    end

    table.sort(pets, _petOrder)

    return pets
end
_G.StickyScanAllPets = scanAllPets

_scanShared, _scanSharedAt = nil, 0
function scanAllPetsCached(maxAge)
    local now = os.clock()
    if _scanShared and (now - _scanSharedAt) <= (tonumber(maxAge) or 0.15) then
        return _scanShared
    end
    local ok, p = pcall(scanAllPets)
    if ok and type(p) == "table" then
        _scanShared, _scanSharedAt = p, now
        return p
    end
    return nil
end
_G.StickyScanCached = scanAllPetsCached

function scanForTP()

    local inBoot = _gameLoadAt and (os.clock() - _gameLoadAt) < 4
    local full = scanAllPetsCached(tonumber(_G.StickyScanCacheAge) or (inBoot and 0.1 or 0.2))
    if type(full) ~= "table" then full = {} end
    if _G.StickyScanTiered and _G.StickyUseTiered ~= false then
        local ok, tiered = pcall(_G.StickyScanTiered)
        if ok and type(tiered) == "table" and #tiered > 0 then
            local seen = {}
            for _, p in ipairs(full) do
                if p and p.plot and p.slot ~= nil then
                    seen[tostring(p.plot) .. "_" .. tostring(p.slot)] = true
                end
            end
            for _, p in ipairs(tiered) do
                if p and p.plot and p.slot ~= nil then
                    local uid = tostring(p.plot) .. "_" .. tostring(p.slot)
                    if not seen[uid] then
                        seen[uid] = true
                        full[#full + 1] = p
                    end
                end
            end
        end
    end
    return full
end

function _petUid(p)
    if not p then return nil end
    return tostring(p.plot) .. "_" .. tostring(p.slot)
end
function _pickPetOnFoot(pets, myPos)
    if not pets or #pets == 0 then return nil end
    local best
    if _G.StickyStealMode == "nearest" and myPos then
        local bestD = math.huge
        for _, p in ipairs(pets) do
            if not p.conveyor and p.position then
                local d = (p.position - myPos).Magnitude
                if d < bestD then bestD = d; best = p end
            end
        end
    else
        for _, p in ipairs(pets) do
            if not p.conveyor then best = p; break end
        end
    end
    return best or pets[1]
end
function _findTPSyncedPet(pets)
    local uid = _G.StickyStealTargetUID
    if type(uid) ~= "string" or uid == "" then return nil end
    for _, p in ipairs(pets) do
        if _petUid(p) == uid then return p end
    end
    return nil
end
function _clearTPSync()
    _G.StickyTPSyncActive = false
    _G.StickyStealTargetUID = nil
    _G.StickyStealTarget = nil
end
function _armTPSync(pet)
    if not pet then return end
    _G.StickyStealTargetUID = _petUid(pet)
    _G.StickyStealTarget = pet
    _G.StickyTPSyncActive = true
    local gen = (_G._StickyTPSyncGen or 0) + 1
    _G._StickyTPSyncGen = gen
    task.delay(12, function()
        if _G._StickyTPSyncGen == gen then _clearTPSync() end
    end)
end
_G.StickyClearTPSync = _clearTPSync
function _findStealTarget(pets)
    if not _G.StickyTPSyncActive then return nil end
    return _findTPSyncedPet(pets)
end
function _publishStealTarget(pet)
    if not pet then return end
    _G.StickyStealTargetUID = _petUid(pet)
    _G.StickyStealTarget = pet
end

MK_UPPER = {
    B = {{coord=Vector3.new(-487.921448,16.850713,-75.768013),facing="NORTH"},{coord=Vector3.new(-332.379730,16.850722,-75.762100),facing="NORTH"},{coord=Vector3.new(-487.134918,16.850713,-18.094154),facing="SOUTH"},{coord=Vector3.new(-316.300171,16.850713,-17.845898),facing="SOUTH"}},
    C = {{coord=Vector3.new(-330.765381,16.850713,31.424425),facing="NORTH"},{coord=Vector3.new(-502.989349,16.850713,31.172430),facing="NORTH"},{coord=Vector3.new(-489.077087,16.850713,89.010147),facing="SOUTH"},{coord=Vector3.new(-330.908936,16.850713,88.930145),facing="SOUTH"}},
    D = {{coord=Vector3.new(-331.264893,16.850713,138.209167),facing="NORTH"},{coord=Vector3.new(-487.935181,16.850713,138.026321),facing="NORTH"},{coord=Vector3.new(-487.774933,16.850713,195.882538),facing="SOUTH"},{coord=Vector3.new(-330.799133,16.850575,196.022354),facing="SOUTH"}},
}
MK_LOWER = {
    B = {{coord=Vector3.new(-335.725586,-3.048217,-74.984589),facing="NORTH"},{coord=Vector3.new(-503.214233,-3.048217,-75.043137),facing="NORTH"},{coord=Vector3.new(-483.619385,-3.718430,-18.844337),facing="SOUTH"},{coord=Vector3.new(-316.147095,-3.048218,-18.818844),facing="SOUTH"}},
    C = {{coord=Vector3.new(-335.985413,-3.048218,32.051426),facing="NORTH"},{coord=Vector3.new(-503.277008,-3.048217,31.956175),facing="NORTH"},{coord=Vector3.new(-483.749390,-3.048218,88.147003),facing="SOUTH"},{coord=Vector3.new(-315.793823,-3.048217,88.163979),facing="SOUTH"}},
    D = {{coord=Vector3.new(-335.476654,-3.048218,139.001083),facing="NORTH"},{coord=Vector3.new(-503.710083,-3.048218,138.989883),facing="NORTH"},{coord=Vector3.new(-315.654938,-3.048218,195.302444),facing="SOUTH"},{coord=Vector3.new(-483.859253,-3.048218,195.269043),facing="SOUTH"}},
}
UPPER_Y_THRESHOLD = 7
TALL_PETS = { ["La Secret Combinasion"]=true, ["La Jolly Grande"]=true }
TALL_OFFSET = 3

BASES_LOW = {
    [1] = Vector3.new(-476.52, -2, 220.94090270996094),
    [2] = Vector3.new(-476.52, -2, 113.77315521240234),
    [3] = Vector3.new(-476.52, -2, 6.178487777709961),
    [4] = Vector3.new(-476.52, -2, -101.07275390625),
    [5] = Vector3.new(-342.66, -2, 221.44737243652344),
    [6] = Vector3.new(-342.66, -2, 113.41409301757812),
    [7] = Vector3.new(-342.66, -2, 6.249461650848389),
    [8] = Vector3.new(-342.66, -2, -99.73458862304688),
}
BASES_HIGH = {
    [1] = Vector3.new(-479.51, 18, 220.94090270996094),
    [2] = Vector3.new(-479.51, 18, 113.77315521240234),
    [3] = Vector3.new(-479.51, 18, 6.178487777709961),
    [4] = Vector3.new(-479.51, 18, -101.07275390625),
    [5] = Vector3.new(-339.48, 18, 221.44737243652344),
    [6] = Vector3.new(-339.48, 18, 113.41409301757812),
    [7] = Vector3.new(-339.48, 18, 6.249461650848389),
    [8] = Vector3.new(-339.48, 18, -99.73458862304688),
}
FRONT_Y_LOW   = -3.048217
FRONT_Y_HIGH  = 16.850713
COLUMN_SPLIT_X = -410
FRONT_Z_CLAMP  = 18
SIDE_NEAR_Z    = 45

function getClosestBaseIdx(pos)
    local closest, dist = 1, math.huge
    for i = 1, 8 do
        local b = BASES_LOW[i]
        local d = (pos.X - b.X)^2 + (pos.Z - b.Z)^2
        if d < dist then dist = d; closest = i end
    end
    return closest
end

function buildFrontCandidate(idx, isUpper, playerZ)
    local base = isUpper and BASES_HIGH[idx] or BASES_LOW[idx]
    local frontY = isUpper and FRONT_Y_HIGH or FRONT_Y_LOW
    local frontZ = math.clamp(playerZ - base.Z, -FRONT_Z_CLAMP, FRONT_Z_CLAMP) + base.Z
    local coord = Vector3.new(base.X, frontY, frontZ)
    local faceDir = (idx <= 4) and Vector3.new(-1, 0, 0) or Vector3.new(1, 0, 0)
    return coord, faceDir
end

function plotSides(coordTable, idx)
    local base = BASES_LOW[idx]
    local isWest = idx <= 4
    local out = {}
    for _, coords in pairs(coordTable) do
        for _, data in ipairs(coords) do
            if ((data.coord.X < COLUMN_SPLIT_X) == isWest)
               and math.abs(data.coord.Z - base.Z) < SIDE_NEAR_Z then
                out[#out + 1] = data
            end
        end
    end
    return out
end

function _floor1LaserSolid(plotName)
    local solid = false
    pcall(function()
        local Plots = workspace:FindFirstChild("Plots")
        local plot = Plots and Plots:FindFirstChild(plotName)
        if not plot then return end
        for _, d in ipairs(plot:GetDescendants()) do
            if d:IsA("BasePart") and (d.Name == "LaserHitbox" or d.Name == "Laser")
                and d.CanCollide and d.Position.Y <= 9 then
                solid = true
                break
            end
        end
    end)
    return solid
end

function isPlotUnlocked(plotName)
    local ok, res = pcall(function()
        local channel = getPlotChannel(plotName)
        if not channel then return false end
        if channelGet(channel, "BlockEndTimeFirstFloor") ~= nil then return false end
        return not _floor1LaserSolid(plotName)
    end)
    return ok and (res == true)
end

function findClosest(petPos, coordTable)
    local best, bestKey, bestDist = nil, nil, math.huge
    for skyKey, coords in pairs(coordTable) do
        for _, data in ipairs(coords) do
            local c = data.coord
            local d = math.sqrt((petPos.X - c.X)^2 + (petPos.Z - c.Z)^2)
            if d < bestDist then bestDist = d; best = data; bestKey = skyKey end
        end
    end
    return best, bestKey
end

do
_vizParts = {}
_vizGen = 0

function _vizEnsure()
    if _vizFolder and _vizFolder.Parent then return end
    _vizFolder = Instance.new("Folder")
    _vizFolder.Name = "StickyPathViz"
    _vizFolder.Parent = workspace
    _vizAnchor = Instance.new("Part")
    _vizAnchor.Name = "Anchor"
    _vizAnchor.Anchored = true; _vizAnchor.CanCollide = false; _vizAnchor.CanQuery = false
    _vizAnchor.CanTouch = false; _vizAnchor.Transparency = 1; _vizAnchor.Size = Vector3.one
    _vizAnchor.CFrame = CFrame.new()
    _vizAnchor.Parent = _vizFolder
end
clearViz = function()
    for i = #_vizParts, 1, -1 do
        local part = _vizParts[i]
        if part and part.Parent then pcall(function() part:Destroy() end) end
        _vizParts[i] = nil
    end
    if _vizAnchor and _vizAnchor.Parent then
        for _, child in ipairs(_vizAnchor:GetChildren()) do pcall(function() child:Destroy() end) end
    end
end
local function _ghost(cf, size, color, op)
    _vizEnsure()
    local a = Instance.new("BoxHandleAdornment")
    a.Adornee = _vizAnchor
    a.AlwaysOnTop = true
    a.ZIndex = 0
    pcall(function() a.Shading = Enum.AdornShading.XRayShaded end)
    a.Color3 = color
    a.Transparency = 1 - op
    a.Size = size
    a.CFrame = cf
    a.Parent = _vizAnchor
end
local function _neon(cf, size, color, ball, transp)
    _vizEnsure()
    local p = Instance.new("Part")
    p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
    p.Material = Enum.Material.Neon; p.Color = color
    p.Transparency = transp or 0
    if ball then p.Shape = Enum.PartType.Ball end
    p.Size = size; p.CFrame = cf; p.Parent = _vizFolder
    _vizParts[#_vizParts + 1] = p
end
function vizLine(a, b, color)
    local d = b - a
    if d.Magnitude < 0.05 then return end
    _neon(CFrame.lookAt((a + b) * 0.5, b), Vector3.new(0.18, 0.18, d.Magnitude), color, false, 0)
    _neon(CFrame.lookAt((a + b) * 0.5, b), Vector3.new(0.40, 0.40, d.Magnitude), color, false, 0.7)
end
function vizDot(pos, color, sz)
    _neon(CFrame.new(pos), Vector3.new(sz, sz, sz), color, true, 0)
end
vizPath = function(fromPos, waypoints)
    if _G.StickyTPTrail ~= true then return end
    if not fromPos or type(waypoints) ~= "table" or #waypoints == 0 then return end
    local LINE = Color3.fromRGB(255, 255, 255)
    local ORB  = Color3.fromRGB(255, 255, 255)
    if type(vizDot) == "function" then
        pcall(vizDot, fromPos, ORB, 1.4)
    end
    local prev = fromPos
    for _, wp in ipairs(waypoints) do
        if typeof(wp) == "Vector3" then
            if type(vizLine) == "function" then
                pcall(vizLine, prev, wp, LINE)
            end
            prev = wp
        end
    end
    if type(vizDot) == "function" and typeof(prev) == "Vector3" then
        pcall(vizDot, prev, ORB, 1.4)
    end
end

end

MK_SPEED = 125
MK_ARRIVE = 3
_STRIP_OK = (type(getconnections) == "function")
function _climbCap()
    local v = math.clamp(tonumber(_G.StickyClimb) or 200, 100, 250)
    if not _STRIP_OK then v = 55 end
    return v
end

function vZero(hrp)
    if hrp then _vzL(hrp); _vzA(hrp) end
end

function _setFlightVel(hrp, vel)
    if hrp and typeof(vel) == "Vector3" and _G.StickyTPBusy == true
        and _G.Sticky_FlingTp == true and vel.Magnitude > 5 then
        local flat = Vector3.new(vel.X, 0, vel.Z)
        if flat.Magnitude > 0.1 then
            local unit = flat.Unit
            local perp = Vector3.new(-unit.Z, 0, unit.X)
            local now = os.clock()
            local amp = math.clamp(tonumber(_G.Sticky_FlingAmp) or 1, 0, 3) * 0.62
            local speed = vel.Magnitude * 0.94
            local slide = ((math.sin(now * 13) * 0.55) + (math.cos(now * 6.5) * 0.35)) * math.min(80, speed * 0.19) * amp
            local wave = ((math.sin(now * 15) * 0.5) + (math.cos(now * 7.5) * 0.32)) * math.min(42, speed * 0.105) * amp
            local pulse = 1 + math.sin(now * 18) * 0.09 * amp
            vel = Vector3.new(unit.X * speed * pulse + perp.X * slide, vel.Y * 0.94 + wave, unit.Z * speed * pulse + perp.Z * slide)
            pcall(function()
                local spinTime = os.clock()
                local spinAmp = math.clamp(tonumber(_G.Sticky_FlingAmp) or 1, 0, 3) * 0.62
                hrp.CFrame = CFrame.new(hrp.Position)
                    * CFrame.Angles(0, (spinTime * 12) % (math.pi * 2), 0)
                    * CFrame.Angles(math.sin(spinTime * 13) * math.rad(30) * spinAmp, 0, (spinTime * 10) % (math.pi * 2))
            end)
        end
    end
    local char = hrp and hrp.Parent
    local part = (char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))) or hrp
    if part then part.AssemblyLinearVelocity = vel end
end

local _cfGen, _cfRunning = 0, false
local function _stickyHybridFaceBack(hrp, target)
    if _G.StickyHybridTP ~= true or not hrp or not hrp.Parent or typeof(target) ~= "Vector3" then return end
    local d = target - hrp.Position
    local flat = Vector3.new(d.X, 0, d.Z)
    if flat.Magnitude < 0.05 then return end
    pcall(function() hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position - flat.Unit) end)
end
_G.StickyHybridFaceBack = _stickyHybridFaceBack

function cframeMoveThrough(hrp, waypoints, hopsOverride)
    if not hrp or not hrp.Parent or not waypoints or #waypoints == 0 then return false end
    _cfGen = _cfGen + 1
    local myGen = _cfGen
    local stepSize = math.clamp(tonumber(_G.StickyCFrameGoSpeed) or tonumber(_G.StickyCFrameStep) or 40, 0.5, 500)
    local stepDelay = math.clamp(tonumber(_G.StickyCFrameDelay) or 0.03, 0.01, 0.2)
    local lagThresh = math.clamp(tonumber(_G.StickyCFrameLagThresh) or 8, 2, 30)
    local MAX_RETRIES = 4
    if type(vizPath) == "function" then pcall(vizPath, hrp.Position, waypoints) end
    local char = hrp.Parent
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
    _cfRunning = true
    local stopConn
    if humanoid and animator then
        pcall(function()
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do track:Stop() end
        end)
        stopConn = humanoid.AnimationPlayed:Connect(function(track)
            pcall(function() track:Stop() end)
        end)
    end
    local target = waypoints[#waypoints]
    local points = {}
    local function fillSteps(from, to)
        local d = to - from
        local segLen = d.Magnitude
        if segLen < 0.1 then return end
        local u = d / segLen
        local walked = 0
        while walked < segLen do
            local s = math.min(stepSize, segLen - walked)
            walked = walked + s
            points[#points + 1] = from + u * walked
        end
    end
    local fullPath = { hrp.Position }
    for i = 1, #waypoints do fullPath[#fullPath + 1] = waypoints[i] end
    if (fullPath[#fullPath] - target).Magnitude > 0.1 then fullPath[#fullPath + 1] = target end
    for i = 1, #fullPath - 1 do fillSteps(fullPath[i], fullPath[i + 1]) end
    if hopsOverride then
        local maxPts = math.clamp(math.floor(tonumber(hopsOverride) or 4), 1, 50)
        if #points > maxPts then
            local trimmed = {}
            for i = 1, maxPts - 1 do
                local idx = math.floor(i * #points / maxPts)
                trimmed[#trimmed + 1] = points[math.max(1, idx)]
            end
            trimmed[#trimmed + 1] = points[#points]
            points = trimmed
        end
    end
    local function yawOf(h)
        local dir = _G.StickyLastFacingDir
        if typeof(dir) == "Vector3" and dir.Magnitude > 0.01 then
            return math.atan2(-dir.X, -dir.Z)
        end
        local _, y = h.CFrame:ToEulerAnglesYXZ()
        return y
    end
    local retries, idx = 0, 1
    local aborted = false
    while idx <= #points and retries < MAX_RETRIES do
        if not _cfRunning or _cfGen ~= myGen or not hrp.Parent then aborted = true; break end
        if _G.StickyTPStop or _G.StickyTPStop then aborted = true; break end
        local tp = points[idx]
        local faceYaw = yawOf(hrp)
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(tp) * CFrame.Angles(0, faceYaw, 0)
            _stickyHybridFaceBack(hrp, target)
        end)
        task.wait(stepDelay)
        if not hrp.Parent then aborted = true; break end
        if (hrp.Position - tp).Magnitude > lagThresh then
            retries = retries + 1
            pcall(function()
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = CFrame.new(tp) * CFrame.Angles(0, faceYaw, 0)
            end)
            task.wait(0.05)
        else
            idx = idx + 1
            retries = 0
        end
    end
    if not aborted and hrp.Parent then
        local faceYaw = yawOf(hrp)
        local function settle()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(target) * CFrame.Angles(0, faceYaw, 0)
        end
        pcall(settle)
        for _ = 1, 3 do
            task.wait()
            if not hrp.Parent or _cfGen ~= myGen then break end
            pcall(settle)
        end
    end
    if stopConn then pcall(function() stopConn:Disconnect() end) end
    if _cfGen == myGen then _cfRunning = false end
    pcall(function()
        if hrp and hrp.Parent then
            hrp.Anchored = false
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end)
    return not aborted
end
_G.StickyCFrameMoveThrough = cframeMoveThrough
_G.StickyCFrameStop = function() _cfRunning = false end

function velMoveThrough(hrp, waypoints, speedOverride, allowJump, quickStart)
    if not hrp or not hrp.Parent or #waypoints == 0 then return end
    local _runSpeed = speedOverride or (_G.TPVelocity and math.clamp(_G.TPVelocity, 200, 750)) or CARPET_SPEED
    vizPath(hrp.Position, waypoints)
    local wpIdx = 1
    local done = false
    local conn
    local function finish(snapToEnd)
        if done then return end
        done = true
        _G.__StickyVizFollow = false
        if hrp and hrp.Parent then
            _vzL(hrp)
            _vzA(hrp)
            if snapToEnd then
                local _, y = hrp.CFrame:ToEulerAnglesYXZ()
                hrp.CFrame = CFrame.new(waypoints[#waypoints]) * CFrame.Angles(0, y, 0)
            end
        end
        if conn then conn:Disconnect() end
    end
    local lastDist, stall = math.huge, 0

    local _stStart = os.clock()
    local _lastJump = 0

    local _routeLen = 0
    do
        local _p = hrp.Position
        for _, wp in ipairs(waypoints) do
            _routeLen = _routeLen + (_p - wp).Magnitude
            _p = wp
        end
    end
    local _mayJump = _routeLen >= (tonumber(_G.StickyJumpMinDist) or 100)

    local _ = quickStart

    conn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
        if not hrp or not hrp.Parent or done then
            if conn then conn:Disconnect() end
            return
        end
        if _G.StickyTPStop then finish(false) return end
        equipCarpet()
        if _mayJump and _G.StickyJumpEachStep ~= false then
            local _now = os.clock()
            if _now - _lastJump >= (tonumber(_G.StickyJumpGap) or 0.2) then
                _lastJump = _now
                local _jh = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if _jh then
                    pcall(function() _jh:ChangeState(Enum.HumanoidStateType.Jumping) end)
                    pcall(function() _jh.Jump = true end)
                end
            end
        end
        local target = waypoints[wpIdx]
        local diff = target - hrp.Position
        local mag = diff.Magnitude
        local _spd = _runSpeed
        if _G.StickyHybridTP == true then
            local ramp = math.clamp(mag / 42, 0.35, 1)
            _spd = _runSpeed * (0.55 + ramp * 0.45)
        end
        if wpIdx < #waypoints and mag < 26 then
            local nxt = waypoints[wpIdx + 1]
            local b = nxt - target
            if mag > 0.1 and b.Magnitude > 0.1 and diff.Unit:Dot(b.Unit) < 0.9 then
                _spd = math.min(_spd, 240)
            end
        end
        local _arr = math.max(MK_ARRIVE, _spd / 60 * 1.25)
        if mag < _arr then
            wpIdx = wpIdx + 1
            if wpIdx > #waypoints then finish(true) return end
            lastDist, stall = math.huge, 0
            if _G.StickyZeroEachStep ~= false and _vzOK() then
                pcall(function()
                    local _v = hrp.AssemblyLinearVelocity
                    local _keepY = (_G.StickyZeroStepKeepY == false) and 0 or math.max(_v.Y, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, _keepY, 0)
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)
            end
            if _mayJump and _G.StickyJumpEachStep ~= false then
                local _wh = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if _wh then
                    _lastJump = os.clock()
                    pcall(function() _wh:ChangeState(Enum.HumanoidStateType.Jumping) end)
                    pcall(function() _wh.Jump = true end)
                end
            end
            target = waypoints[wpIdx]
            diff = target - hrp.Position
            mag = diff.Magnitude
        end

        if mag > lastDist - 0.05 then stall = stall + 1 else stall = 0 end
        lastDist = mag
        if stall >= (tonumber(_G.StickyStallFrames) or 18) then finish(false) return end

        if mag >= 0.1 then
            local dir = diff.Unit
            if (allowJump or diff.Y > 10) and diff.Y > 5 and wpIdx < #waypoints then
                local hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if hum then
                    local st = hum:GetState()
                    if st ~= Enum.HumanoidStateType.Jumping and st ~= Enum.HumanoidStateType.Freefall then
                        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() hum.Jump = true end)
                    end
                end
            end
            local _sp = _spd
            local _mc = _climbCap()
            if dir.Y > 0 and dir.Y * _sp > _mc then
                _sp = _mc / dir.Y
            end
            _setFlightVel(hrp, Vector3.new(dir.X * _sp, dir.Y * _sp, dir.Z * _sp))
            if _G.StickySpinTP == true then
                local spinPosition = hrp.Position
                local spinYaw = (os.clock() * (tonumber(_G.StickySpinRate) or 22)) % (math.pi * 2)
                pcall(function() hrp.CFrame = CFrame.new(spinPosition) * CFrame.Angles(0, spinYaw, 0) end)
            end
            _stickyHybridFaceBack(hrp, target)
        end
    end))

    local totalDist = 0
    do
        local prev = hrp.Position
        for _, wp in ipairs(waypoints) do
            totalDist = totalDist + (prev - wp).Magnitude
            prev = wp
        end
    end
    local timeout = totalDist / math.min(MK_SPEED, _runSpeed) + (tonumber(_G.StickyFlightGrace) or 2)
    local elapsed = 0
    while not done and elapsed < timeout do
        task.wait(0.05)
        elapsed = elapsed + 0.05
        if not (hrp and hrp.Parent) then break end
    end
    finish(false)
    vZero(hrp)
end

_OTHER_CLONES = {}
do
    local _MY_CLONE = tostring(LP.UserId) .. "_Clone"
    local _seen = {}
    local function _isOtherClone(inst)
        if not inst then return false end
        local n = inst.Name
        if n == _MY_CLONE then return false end
        if n:match("^%d+_Clone$") then return true end
        if not n:find("lone", 1, true) then return false end
        if not inst:IsA("Model") then return false end
        if inst == LP.Character then return false end
        if not inst:FindFirstChild("HumanoidRootPart") then return false end
        if not inst:FindFirstChildOfClass("Humanoid") then return false end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl.Character == inst then return false end
        end
        return true
    end
    local function _neutralize(inst)
        if not inst or _seen[inst] then return end
        _seen[inst] = true
        _OTHER_CLONES[#_OTHER_CLONES + 1] = inst
        local function declaw(d)
            if d:IsA("BasePart") and d.CanCollide then pcall(function() d.CanCollide = false end) end
        end
        for _, d in ipairs(inst:GetDescendants()) do declaw(d) end
        inst.DescendantAdded:Connect(declaw)
        inst.Destroying:Connect(function()
            _seen[inst] = nil
            for i = #_OTHER_CLONES, 1, -1 do
                if _OTHER_CLONES[i] == inst then table.remove(_OTHER_CLONES, i); break end
            end
        end)
    end
    local function _scan(inst)
        if _isOtherClone(inst) then _neutralize(inst) end
    end
    for _, c in ipairs(workspace:GetChildren()) do _scan(c) end
    workspace.ChildAdded:Connect(function(c)
        _scan(c)
        task.defer(function() if c and c.Parent == workspace then _scan(c) end end)
    end)
end

do

    local _pSeen = setmetatable({}, { __mode = "k" })
    local _ncBag = setmetatable({}, { __mode = "k" })
    local function _declaw(d)
        if d:IsA("BasePart") and d.CanCollide then pcall(function() d.CanCollide = false end) end
    end
    local function _declawChar(char)
        if not char then return end
        for _, d in ipairs(char:GetDescendants()) do _declaw(d) end
        if not _pSeen[char] then
            _pSeen[char] = true
            char.DescendantAdded:Connect(_declaw)
        end
    end

    local _THEIRS = { "HumanoidRootPart", "UpperTorso", "LowerTorso", "Torso", "Head" }
    local function _noCollide(char)
        if not char then return end
        local c = LP.Character
        local mine = c and c:FindFirstChild("HumanoidRootPart")
        if not mine then return end
        local bag = _ncBag[char]
        if not bag or bag.root ~= mine then bag = { root = mine }; _ncBag[char] = bag end
        for _, n in ipairs(_THEIRS) do
            local part = char:FindFirstChild(n)
            if part and part:IsA("BasePart") then
                local nc = bag[n]
                if not (nc and nc.Parent) then
                    pcall(function()
                        local k = Instance.new("NoCollisionConstraint")
                        k.Part0, k.Part1 = mine, part
                        k.Parent = mine
                        bag[n] = k
                    end)
                end
            end
        end
    end
    local _watched = setmetatable({}, { __mode = "k" })
    local _pinHooked = setmetatable({}, { __mode = "k" })
    local function _pin(p)
        if not p:IsA("BasePart") then return end
        if p.CanCollide then p.CanCollide = false end
        if _watched[p] then return end
        _watched[p] = true
        pcall(function()
            p:GetPropertyChangedSignal("CanCollide"):Connect(function()
                if p.CanCollide then p.CanCollide = false end
            end)
        end)
    end
    local function _pinChar(ch)
        if not ch then return end
        for _, d in ipairs(ch:GetDescendants()) do _pin(d) end
        if not _pinHooked[ch] then
            _pinHooked[ch] = true
            ch.DescendantAdded:Connect(function(d) task.defer(_pin, d) end)
        end
    end
    local function _hookPlayer(pl)
        if pl == LP then return end
        if pl.Character then _declawChar(pl.Character); _noCollide(pl.Character); _pinChar(pl.Character) end
        pl.CharacterAdded:Connect(function(c)
            task.wait(0.05)
            _declawChar(c)
            _noCollide(c)
            _pinChar(c)
        end)
    end
    for _, pl in ipairs(Players:GetPlayers()) do _hookPlayer(pl) end
    Players.PlayerAdded:Connect(_hookPlayer)

    LP.CharacterAdded:Connect(function()
        task.wait(0.3)
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LP and pl.Character then _noCollide(pl.Character) end
        end
    end)

    local function _pinPlayer(pl)
        if pl == LP then return end
        if pl.Character then _pinChar(pl.Character) end
        pl.CharacterAdded:Connect(function(c) task.wait(0.15) _pinChar(c) end)
    end
    for _, pl in ipairs(Players:GetPlayers()) do _pinPlayer(pl) end
    Players.PlayerAdded:Connect(_pinPlayer)

    local _MY_CLONE_N = tostring(LP.UserId) .. "_Clone"
    local function _clones()
        local t = _OTHER_CLONES
        return (type(t) == "table") and t or {}
    end

    local _ncAcc = 0
    RunService.Stepped:Connect(function(_, dt)
        if _G.StickyNoCollide == false or _G.isCloning == true then return end
        _ncAcc = _ncAcc + (dt or 0.016)
        if _ncAcc < 0.1 then return end
        _ncAcc = 0
        local c = LP.Character
        local myHrp = c and c:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        local mp = myHrp.Position
        local rng = tonumber(_G.StickyNoCollideRange) or 28
        for _, pl in ipairs(Players:GetPlayers()) do
            local ch = (pl ~= LP) and pl.Character
            local h = ch and ch:FindFirstChild("HumanoidRootPart")
            if h and (h.Position - mp).Magnitude <= rng then
                for _, d in ipairs(ch:GetDescendants()) do
                    if d:IsA("BasePart") and d.CanCollide then d.CanCollide = false end
                end
            end
        end
        for _, cl in ipairs(_clones()) do
            if cl and cl.Parent and cl.Name ~= _MY_CLONE_N then
                local h = cl:FindFirstChild("HumanoidRootPart")
                if h and (h.Position - mp).Magnitude <= rng then
                    for _, d in ipairs(cl:GetDescendants()) do
                        if d:IsA("BasePart") and d.CanCollide then d.CanCollide = false end
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(1)
            if _G.isCloning ~= true then
                for _, pl in ipairs(Players:GetPlayers()) do
                    local ch = (pl ~= LP) and pl.Character
                    if ch then _pinChar(ch) end
                end
                for _, cl in ipairs(_clones()) do
                    if cl and cl.Parent and cl.Name ~= _MY_CLONE_N then _pinChar(cl) end
                end
            end
        end
    end)
end
local _len
do
local _DIRS = { Vector3.new(1,0,0), Vector3.new(-1,0,0), Vector3.new(0,0,1), Vector3.new(0,0,-1) }
local _STRUCT = { ["structure base home"] = true, ["Wall"] = true, ["Floor"] = true, ["Roof"] = true }
local _SKIP_NAME = { ["DeliveryHitbox"]=true, ["StealHitbox"]=true, ["LaserHitbox"]=true,
    ["AnimalTarget"]=true, ["Multiplier"]=true, ["Laser"]=true, ["Hitbox"]=true,
    ["Spawn"]=true, ["MainRoot"]=true, ["SecondFloor"]=true, ["ThirdFloor"]=true, ["Slope"]=true }
local function _blocks(inst)
    if not inst then return false end
    if _SKIP_NAME[inst.Name] then return false end
    if inst.CanCollide then return true end
    local _par = inst.Parent
    if _par and (_par.Name == "ObstacleVolumes" or _par.Name == "ObstacleVolume") then return false end
    if _STRUCT[inst.Name] then return true end
    local s = inst.Size
    if s and math.max(s.X * s.Y, s.X * s.Z, s.Y * s.Z) > 150 then return true end
    return false
end
local function _blocksWide(inst)
    if not inst then return false end
    if _SKIP_NAME[inst.Name] then return false end
    if inst.CanCollide then return true end
    local _par = inst.Parent
    if _par and (_par.Name == "ObstacleVolumes" or _par.Name == "ObstacleVolume") then return false end
    if _STRUCT[inst.Name] then return true end
    local s = inst.Size
    if s and math.max(s.X * s.Y, s.X * s.Z, s.Y * s.Z) > 30 then return true end
    return false
end
local function _block(origin, target, blockFn)
    blockFn = blockFn or _blocks
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    for _, cl in ipairs(_OTHER_CLONES) do skip[#skip + 1] = cl end
    local o = origin
    for _ = 1, 16 do
        rp.FilterDescendantsInstances = skip
        local d = target - o
        if d.Magnitude < 0.05 then return nil end
        local res = workspace:Raycast(o, d, rp)
        if not res then return nil end
        if blockFn(res.Instance) then return res end
        skip[#skip + 1] = res.Instance
        o = res.Position + d.Unit * 0.3
    end
    return nil
end
local function _clear(a, b) return _block(a, b) == nil end
local function _clearDist(origin, dir, maxD)
    local res = _block(origin, origin + dir.Unit * maxD)
    if not res then return maxD end
    return (res.Position - origin).Magnitude
end
function _len(pts)
    local s, prev = 0, pts[1]
    for k = 2, #pts do s = s + (pts[k] - prev).Magnitude; prev = pts[k] end
    return s
end
local function _pull(pts)
    if #pts <= 2 then return pts end
    local out = { pts[1] }
    local i = 1
    while i < #pts do
        local j = #pts
        while j > i + 1 and not _clear(out[#out], pts[j]) do j = j - 1 end
        out[#out + 1] = pts[j]
        i = j
    end
    return out
end
local function _stages(toPos)
    local st = {}
    for _, dr in ipairs(_DIRS) do
        local cd = _clearDist(toPos, dr, 46)
        if cd >= 12 then st[#st + 1] = toPos + dr * math.min(cd - 5, 38) end
    end
    return st
end
local function _routeClear(pts)
    for i = 1, #pts - 1 do
        if not _clear(pts[i], pts[i + 1]) then return false end
    end
    return true
end
local function _peakY(pts)
    local m = -math.huge
    for _, p in ipairs(pts) do if p.Y > m then m = p.Y end end
    return m
end
local function _starts(fromPos)
    local pts = { fromPos }
    if _block(fromPos, fromPos + Vector3.new(0, 40, 0)) then
        for _, dr in ipairs(_DIRS) do
            local cd = _clearDist(fromPos, dr, 40)
            if cd >= 12 then pts[#pts + 1] = fromPos + dr * math.min(cd - 5, 34) end
        end
    end
    return pts
end

local function _candidates(sp, stage, toPos)
    local list = {}
    local function add(mid)
        if mid then list[#list + 1] = { sp, mid, stage, toPos }
        else list[#list + 1] = { sp, stage, toPos } end
    end
    add(nil)
    add(Vector3.new(stage.X, sp.Y, stage.Z))
    add(Vector3.new(sp.X, stage.Y, sp.Z))
    local dir = Vector3.new(stage.X - sp.X, 0, stage.Z - sp.Z)
    if dir.Magnitude > 0.1 then
        dir = dir.Unit
        local perp = Vector3.new(-dir.Z, 0, dir.X)
        for _, off in ipairs({ 20, -20, 40, -40 }) do
            add(sp + perp * off)
        end
    end
    return list
end

local PathfindingService = game:GetService("PathfindingService")
local _CLEARANCE = 16
local function _clearWideRay(a, b)
    return _block(a, b, _blocksWide) == nil
end

local _SWEEP_R = 4
local _ENDPOINT_SLACK = 6
local _canSphere = nil
local function _sweepBlockFn(inst)
    if _G.StickyStrictSweep == false then return _blocks(inst) end
    return _blocksWide(inst)
end
local function _sweepDir(a, b)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    for _, cl in ipairs(_OTHER_CLONES) do skip[#skip + 1] = cl end
    local o = a
    for _ = 1, 24 do
        rp.FilterDescendantsInstances = skip
        local d = b - o
        if d.Magnitude < 0.05 then return false end
        local res
        local ok = pcall(function() res = workspace:Spherecast(o, _SWEEP_R, d, rp) end)
        if not ok then _canSphere = false; return nil end
        if not res then return false end
        if _sweepBlockFn(res.Instance) then return true end
        skip[#skip + 1] = res.Instance
        local adv = (res.Distance or 0) - 0.05
        if adv > 0 then o = o + d.Unit * math.min(adv, d.Magnitude) end
    end
    return true
end
local function _sweepBlocked(a, b, slackA, slackB)
    if _canSphere == nil then
        _canSphere = pcall(function()
            workspace:Spherecast(Vector3.new(0, 10000, 0), 1, Vector3.new(0, -1, 0), RaycastParams.new())
        end)
    end
    if not _canSphere then return nil end
    local d = b - a
    local len = d.Magnitude
    if len < 0.1 then return false end
    local u = d / len
    local a2 = a + u * math.min(slackA or _ENDPOINT_SLACK, len * 0.4)
    local b2 = b - u * math.min(slackB or _ENDPOINT_SLACK, len * 0.4)
    local fwd = _sweepDir(a2, b2)
    if fwd == nil then return nil end
    if fwd then return true end
    local rev = _sweepDir(b2, a2)
    if rev == nil then return nil end
    return rev
end

local function _clearWide(a, b, slackA, slackB)
    if not _clear(a, b) then return false end
    local sw = _sweepBlocked(a, b, slackA, slackB)
    if sw ~= nil then return not sw end
    local d = Vector3.new(b.X - a.X, 0, b.Z - a.Z)
    if d.Magnitude < 0.1 then
        local ox = Vector3.new(_CLEARANCE, 0, 0)
        local oz = Vector3.new(0, 0, _CLEARANCE)
        return _clearWideRay(a + ox, b + ox) and _clearWideRay(a - ox, b - ox)
            and _clearWideRay(a + oz, b + oz) and _clearWideRay(a - oz, b - oz)
    end
    local perp = Vector3.new(-d.Z, 0, d.X).Unit * _CLEARANCE
    local up = Vector3.new(0, _CLEARANCE, 0)
    return _clearWideRay(a + perp, b + perp)
        and _clearWideRay(a - perp, b - perp)
        and _clearWideRay(a + up, b + up)
        and _clearWideRay(a - up, b - up)
end

local function _crestClear(a, b)
    if not _clear(a, b) then return false end
    local cl = tonumber(_G.StickyCrestClearance) or 6
    local d = Vector3.new(b.X - a.X, 0, b.Z - a.Z)
    if d.Magnitude < 0.1 then
        return true
    end
    local perp = Vector3.new(-d.Z, 0, d.X).Unit * cl
    return _clearWideRay(a + perp, b + perp)
        and _clearWideRay(a - perp, b - perp)
        and _clearWideRay(a + Vector3.new(0, cl, 0), b + Vector3.new(0, cl, 0))
end

local function _pullWide(pts)
    if #pts <= 2 then return pts end
    local out = { pts[1] }
    local i = 1
    local n = #pts
    while i < n do
        local j = n
        while j > i + 1 do
            local a, b = out[#out], pts[j]
            local sA = (i == 1) and _ENDPOINT_SLACK or 0
            local sB = (j == n) and _ENDPOINT_SLACK or 0
            if _clearWide(a, b, sA, sB) then break end
            j = j - 1
        end
        out[#out + 1] = pts[j]
        i = j
    end
    return out
end

local function _pushOffWalls(pts)
    if #pts <= 2 then return pts end
    local MARGIN = 8
    local MAX_PUSH = 12
    local out = { pts[1] }
    for i = 2, #pts - 1 do
        local p = pts[i]
        local shift = Vector3.zero
        for _, dr in ipairs(_DIRS) do
            local res = _block(p, p + dr * MARGIN, _blocks)
            if res then
                local dist = (res.Position - p).Magnitude
                if dist < MARGIN then
                    shift = shift - dr * (MARGIN - dist)
                end
            end
        end
        do
            local resUp = _block(p, p + Vector3.new(0, MARGIN, 0), _blocks)
            if resUp then
                local dist = (resUp.Position - p).Magnitude
                if dist < 4 then shift = shift + Vector3.new(0, -(4 - dist), 0) end
            end
        end
        if shift.Magnitude > 0.1 then
            if shift.Magnitude > MAX_PUSH then shift = shift.Unit * MAX_PUSH end
            local moved = p + shift
            if _clear(out[#out], moved) then
                out[#out + 1] = moved
            else
                out[#out + 1] = p
            end
        else
            out[#out + 1] = p
        end
    end
    out[#out + 1] = pts[#pts]
    return out
end

                                end
                            end
                        end
                    end
                end)
            end