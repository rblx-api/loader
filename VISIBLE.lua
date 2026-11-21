-- Visible Hub | Mobile + PC (UNC / Synapse / Fluxus / Solara / Delta / Wave / etc.)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local player = Players.LocalPlayer
-- Prevent stacked Heartbeats; allow re-inject by cleaning previous run
if getgenv then
    if getgenv()._K7DuelsRunning then
        pcall(function()
            local names = {"K7Duels", "K7MobileButtons", "K7InfoBar", "K7StealBar", "AspectStealBar", "RyukStealBarUI", "RyukStealBar", "K7DuelsMogIntro", "K7RagdollCountdown", "K7DemonRecovery_RAGDOLL", "K7DemonRecovery_STONE", "K7DemonRecovery_E01", "K7Demon_E01Timer", "K7HitCountdown", "CrystalHitCountdown", "RaVeRagdollBB", "RagCountdownBillboard"}
            for _, name in ipairs(names) do
                pcall(function()
                    if gethui then
                        local h = gethui()
                        local o = h and h:FindFirstChild(name)
                        if o then o:Destroy() end
                    end
                end)
                pcall(function()
                    local cg = game:GetService("CoreGui")
                    local o = cg:FindFirstChild(name)
                    if o then o:Destroy() end
                end)
                pcall(function()
                    local plr = game:GetService("Players").LocalPlayer
                    if plr and plr:FindFirstChild("PlayerGui") then
                        local o = plr.PlayerGui:FindFirstChild(name)
                        if o then o:Destroy() end
                    end
                end)
            end
        end)
    end
    getgenv()._K7DuelsRunning = true
end

pcall(function()
    if getgenv and type(getgenv()._K7DuelsCfg)=="table" and getgenv()._K7DuelsCfg.introEnabled ~= nil then
    end
end)

-- ============================
-- EXECUTOR COMPAT (PC + Mobile)
-- ============================
local function _resolve(name)
    local g = rawget(_G, name) or (getgenv and getgenv()[name])
    if typeof(g)=="function" then return g end
    if syn and typeof(syn[name])=="function" then return syn[name] end
    if fluxus and typeof(fluxus[name])=="function" then return fluxus[name] end
    return nil
end

local _gethui = _resolve("gethui") or (typeof(gethui)=="function" and gethui) or nil
local _getcustomasset = _resolve("getcustomasset") or (typeof(getcustomasset)=="function" and getcustomasset) or nil
local _request = _resolve("request")
    or _resolve("http_request")
    or (syn and syn.request)
    or (http and (http.request or http.Request))
    or (fluxus and fluxus.request)
    or (typeof(request)=="function" and request)
    or (typeof(http_request)=="function" and http_request)
    or nil

local function protectGui(gui)
    if not gui then return end
    pcall(function()
        if typeof(protect_gui)=="function" then protect_gui(gui)
        elseif syn and syn.protect_gui then syn.protect_gui(gui)
        elseif typeof(hide_in_gcoregui)=="function" then hide_in_gcoregui(gui)
        end
    end)
end

local function parentGui(gui)
    if not gui then return end
    protectGui(gui)
    local ok = false
    if _gethui then
        ok = pcall(function() gui.Parent = _gethui() end)
    end
    if not ok or not gui.Parent then
        ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    end
    if not gui.Parent then
        pcall(function()
            local plr = Players.LocalPlayer
            if plr then gui.Parent = plr:WaitForChild("PlayerGui") end
        end)
    end
end

local _isfile = (typeof(isfile)=="function" and isfile)
    or (syn and syn.isfile)
    or (fluxus and fluxus.isfile)
    or (getgenv and getgenv().isfile)
    or function(p)
        local ok, data = pcall(function() return readfile(p) end)
        return ok and data ~= nil
    end
local _readfile = (typeof(readfile)=="function" and readfile)
    or (syn and syn.readfile)
    or (fluxus and fluxus.readfile)
    or (getgenv and getgenv().readfile)
    or function() return nil end
local _writefile = (typeof(writefile)=="function" and writefile)
    or (syn and syn.writefile)
    or (fluxus and fluxus.writefile)
    or (getgenv and getgenv().writefile)
    or function() end
isfile, readfile, writefile = _isfile, _readfile, _writefile

-- ============================
-- UNCAP FPS (all executors — Delta-style aggressive)
-- ============================
do
    local function resolve(name)
        local g = rawget(_G, name)
        if type(g) == "function" then return g end
        pcall(function()
            if getgenv and type(getgenv()[name]) == "function" then g = getgenv()[name] end
        end)
        if type(g) == "function" then return g end
        pcall(function()
            if syn and type(syn[name]) == "function" then g = syn[name] end
        end)
        if type(g) == "function" then return g end
        pcall(function()
            if fluxus and type(fluxus[name]) == "function" then g = fluxus[name] end
        end)
        if type(g) == "function" then return g end
        pcall(function()
            if delta and type(delta[name]) == "function" then g = delta[name] end
        end)
        if type(g) == "function" then return g end
        pcall(function()
            if volt and type(volt[name]) == "function" then g = volt[name] end
        end)
        if type(g) == "function" then return g end
        -- bare global (Delta / Volt / UNC often inject these)
        pcall(function()
            if typeof(_G[name]) == "function" then g = _G[name] end
        end)
        if type(g) == "function" then return g end
        pcall(function()
            if typeof and typeof(getfenv()[name]) == "function" then g = getfenv()[name] end
        end)
        return type(g) == "function" and g or nil
    end

    local function applyUncap()
        -- 1) Executor FPS APIs (try uncapped then high caps)
        local setCap = resolve("setfpscap")
            or resolve("set_fps_cap")
            or resolve("setfpslimit")
            or resolve("setfps")
        if type(setCap) == "function" then
            for _, v in ipairs({0, 9999, 1000, 500, 240, 144, 120}) do
                pcall(setCap, v)
            end
        end

        -- 2) Roblox TaskScheduler FFlags (breaks many 60 FPS locks)
        local setFlag = resolve("setfflag")
            or resolve("setfastflag")
            or resolve("setfflags")
        if type(setFlag) == "function" then
            local flags = {
                {"DFIntTaskSchedulerTargetFps", "9999"},
                {"DFIntTaskSchedulerTargetFps", "240"},
                {"TaskSchedulerTargetFps", "9999"},
                {"FFlagTaskSchedulerLimitTargetFpsTo2402", "False"},
                {"FFlagTaskSchedulerLimitTargetFpsToPhysicalCores", "False"},
                {"TaskSchedulerLimitTargetFpsToPhysicalCores", "False"},
                {"TaskSchedulerAsyncTasksLimitsEnabled", "False"},
                {"FFlagGameBasicSettingsFramerateCap", "True"},
            }
            for _, pair in ipairs(flags) do
                pcall(setFlag, pair[1], pair[2])
            end
        end

        -- 3) Dedicated unlock helpers if present
        for _, name in ipairs({"unlockfps", "UnlockFps", "remove_fps_cap", "removefpscap"}) do
            local fn = resolve(name)
            if type(fn) == "function" then pcall(fn) end
        end
    end

    pcall(applyUncap)

    -- Re-apply several times (some executors ignore first call / reset on load)
    task.spawn(function()
        for _ = 1, 8 do
            task.wait(0.35)
            pcall(applyUncap)
        end
    end)
    task.spawn(function()
        pcall(function()
            if not game:IsLoaded() then game.Loaded:Wait() end
        end)
        task.wait(1.25)
        pcall(applyUncap)
        task.wait(2)
        pcall(applyUncap)
    end)
end


-- ============================================================
-- TP BAT (Exe Hub V1 / V2 / V3) — logic only, Visible Hub UI
-- ============================================================
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local localPlayer = Players.LocalPlayer

    local versionConfigs = {
        V1 = {
            range = 850,
            loopDelay = 0.018,
            smartRotation = true,
            resetVelocity = true,
            predictMovement = false,
            predictionFactor = 0,
            healthCheck = true,
            behindTarget = false,
            behindDistance = 4,
            antiFling = true,
            snapDistance = 4,
            heightOffset = 2.5,
        },
        V2 = {
            range = 430,
            loopDelay = 0.08,
            smartRotation = false,
            resetVelocity = true,
            predictMovement = true,
            predictionFactor = 0.25,
            healthCheck = true,
            behindTarget = false,
            behindDistance = 0,
            antiFling = false,
        },
        V3 = {
            range = 500,
            loopDelay = 0.03,
            smartRotation = true,
            resetVelocity = true,
            predictMovement = false,
            predictionFactor = 0,
            healthCheck = true,
            behindTarget = false,
            behindDistance = 4,
            antiFling = true,
            heightOffset = 1.2,
        },
    }

    _G._VisibleTPBat = _G._VisibleTPBat or {
        enabled = false,
        version = "V1",
        autoBat = true,
        autoBatDelay = 0.08,
        cameraLock = true,
        running = false,
        thread = nil,
        ragdollConn = nil,
        hittingCooldown = false,
    }
    local S = _G._VisibleTPBat

    local function getCfg()
        return versionConfigs[S.version] or versionConfigs.V1
    end

    local function myRoot()
        local c = localPlayer.Character
        return c and c:FindFirstChild("HumanoidRootPart")
    end
    local function myHum()
        local c = localPlayer.Character
        return c and c:FindFirstChildOfClass("Humanoid")
    end

    local function recoverFromRagdoll()
        local hum = myHum()
        if not hum then return end
        pcall(function()
            hum.PlatformStand = false
            hum.Sit = false
            hum.AutoRotate = true
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Physics
                or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown
                or st == Enum.HumanoidStateType.PlatformStanding then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end

    local function isRagdolled()
        local hum = myHum()
        if not hum then return false end
        if hum.PlatformStand or hum.Sit then return true end
        local st = hum:GetState()
        return st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
            or st == Enum.HumanoidStateType.GettingUp
            or st == Enum.HumanoidStateType.PlatformStanding
    end

    local function isBatTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = string.lower(tool.Name)
        return string.find(n, "bat", 1, true) ~= nil or string.find(n, "slap", 1, true) ~= nil
    end

    local function getBat()
        local char = localPlayer.Character
        if not char then return nil end
        for _, child in ipairs(char:GetChildren()) do
            if isBatTool(child) then return child end
        end
        local pack = localPlayer:FindFirstChild("Backpack")
        if pack then
            for _, child in ipairs(pack:GetChildren()) do
                if isBatTool(child) then
                    pcall(function()
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then hum:EquipTool(child) else child.Parent = char end
                    end)
                    return child
                end
            end
        end
        return char:FindFirstChild("Bat")
    end

    local function forceHitBat(targetRoot)
        recoverFromRagdoll()
        pcall(function()
            local bat = getBat()
            if not bat then return end
            pcall(function() bat:Activate() end)
            if targetRoot and typeof(firetouchinterest) == "function" then
                local handle = bat:FindFirstChild("Handle")
                if handle then
                    pcall(function()
                        firetouchinterest(handle, targetRoot, 0)
                        firetouchinterest(handle, targetRoot, 1)
                    end)
                    local torso = targetRoot.Parent and (
                        targetRoot.Parent:FindFirstChild("UpperTorso")
                        or targetRoot.Parent:FindFirstChild("Torso")
                        or targetRoot.Parent:FindFirstChild("Head")
                    )
                    if torso then
                        pcall(function()
                            firetouchinterest(handle, torso, 0)
                            firetouchinterest(handle, torso, 1)
                        end)
                    end
                end
            end
            for _, ev in ipairs(bat:GetDescendants()) do
                if ev:IsA("RemoteEvent") then
                    pcall(function() ev:FireServer() end)
                end
            end
        end)
    end

    local function tryHitBat(targetRoot)
        recoverFromRagdoll()
        local rag = isRagdolled()
        if S.hittingCooldown and not rag then return end
        if not rag then S.hittingCooldown = true end
        forceHitBat(targetRoot)
        if not rag then
            task.delay(S.autoBatDelay or 0.08, function() S.hittingCooldown = false end)
        end
    end

    local function isValidEnemy(player)
        local cfg = getCfg()
        if player == localPlayer or not player.Character then return false end
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if not hum then return false end
        if cfg.healthCheck and hum.Health <= 0 then return false end
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return false end
        return true, root, hum
    end

    local function predictPosition(root)
        local cfg = getCfg()
        if not cfg.predictMovement then return root.Position end
        return root.Position + (root.AssemblyLinearVelocity * (cfg.predictionFactor or 0))
    end

    local function findNearestEnemy()
        local cfg = getCfg()
        local me = myRoot()
        if not me then return nil end
        local best, bestPlr, bestD = nil, nil, cfg.range
        for _, plr in ipairs(Players:GetPlayers()) do
            local ok, root = isValidEnemy(plr)
            if ok then
                local d = (root.Position - me.Position).Magnitude
                if d < bestD then
                    bestD, best, bestPlr = d, root, plr
                end
            end
        end
        return best, bestPlr
    end

    local function applyCamLock(pos)
        local on = S.cameraLock == true
        if _G._AmbitiousGetTPBatCameraLock then
            on = _G._AmbitiousGetTPBatCameraLock() == true
        end
        if not on then return end
        pcall(function()
            local cam = workspace.CurrentCamera
            if cam and typeof(pos) == "Vector3" then
                cam.CFrame = CFrame.new(cam.CFrame.Position, pos)
            end
        end)
    end

    local function teleportTo(targetRoot, targetPlayer)
        local me = myRoot()
        local hum = myHum()
        if not me or not targetRoot then return end
        -- Clean Hub full TP Bat: Network Owner teleport only (no version modes)
        pcall(function()
            if me.SetNetworkOwner then me:SetNetworkOwner(nil) end
        end)
        task.wait()
        local targetPosition = targetRoot.Position + Vector3.new(0, 0.9, 0)
        me.CFrame = CFrame.new(targetPosition)
        me.AssemblyLinearVelocity = targetRoot.AssemblyLinearVelocity
        pcall(function()
            if me.SetNetworkOwner then me:SetNetworkOwner(localPlayer) end
        end)
        if hum then
            hum.PlatformStand = false
            hum.Sit = false
        end
        applyCamLock(targetRoot.Position)
    end


    function startVisibleTpBat()
        if S.running then return end
        S.running = true
        S.enabled = true
        S.thread = task.spawn(function()
            while S.enabled do
                local target, plr = findNearestEnemy()
                if target then
                    recoverFromRagdoll()
                    teleportTo(target, plr)
                    if S.autoBat then tryHitBat(target) end
                end
                local delayTime = getCfg().loopDelay or 0.08
                if isRagdolled() then delayTime = 0.03 end
                task.wait(delayTime)
            end
        end)
        if S.ragdollConn then pcall(function() S.ragdollConn:Disconnect() end) end
        S.ragdollConn = RunService.Heartbeat:Connect(function()
            if not S.enabled then return end
            if not isRagdolled() then return end
            recoverFromRagdoll()
            local target = select(1, findNearestEnemy())
            if target then
                teleportTo(target)
                if S.autoBat then forceHitBat(target) end
            end
        end)
    end

    function stopVisibleTpBat()
        S.enabled = false
        S.running = false
        if S.thread then pcall(function() task.cancel(S.thread) end); S.thread = nil end
        if S.ragdollConn then pcall(function() S.ragdollConn:Disconnect() end); S.ragdollConn = nil end
    end

    function setVisibleTpBatVersion(v)
        if v == "V1" or v == "V2" or v == "V3" then
            S.version = v
        end
    end
    _G._AmbitiousGetTPBatCameraLock = function()
        return S.cameraLock == true
    end
    _G._AmbitiousSetTPBatCameraLock = function(v)
        S.cameraLock = v == true
    end

    function toggleVisibleTpBat(on)
        if on == nil then on = not S.enabled end
        if on then startVisibleTpBat() else stopVisibleTpBat() end
        return S.enabled
    end

    _G.startVisibleTpBat = startVisibleTpBat
    _G.stopVisibleTpBat = stopVisibleTpBat
    _G.setVisibleTpBatVersion = setVisibleTpBatVersion
    _G.toggleVisibleTpBat = toggleVisibleTpBat

    localPlayer.CharacterAdded:Connect(function()
        if S.enabled then
            stopVisibleTpBat()
            task.wait(0.5)
            startVisibleTpBat()
        end
    end)
    localPlayer.CharacterRemoving:Connect(function()
        if S.running then
            -- keep enabled flag, stop loops until CharacterAdded restarts
            if S.thread then pcall(function() task.cancel(S.thread) end); S.thread = nil end
            if S.ragdollConn then pcall(function() S.ragdollConn:Disconnect() end); S.ragdollConn = nil end
            S.running = false
        end
    end)
end


local function k7HttpGet(url)
    if _request then
        local ok, res = pcall(function()
            return _request({
                Url = url,
                Method = "GET",
                Headers = { ["User-Agent"] = "Mozilla/5.0" },
            })
        end)
        if ok and type(res)=="table" then
            return res.Body or res.body or res.Data or res.data
        elseif ok and type(res)=="string" then
            return res
        end
    end
    local ok2, body = pcall(function() return game:HttpGet(url) end)
    if ok2 then return body end
    return nil
end

local function k7GetCustomAsset(path)
    if not path then return nil end
    local asset = nil
    pcall(function()
        if _getcustomasset then asset = _getcustomasset(path) end
    end)
    if asset and asset ~= "" then return asset end
    pcall(function()
        if syn and syn.getcustomasset then asset = syn.getcustomasset(path) end
    end)
    if asset and asset ~= "" then return asset end
    pcall(function()
        if getcustomasset then asset = getcustomasset(path, true) end
    end)
    if asset and asset ~= "" then return asset end
    return nil
end

getconnections = getconnections or get_signal_cons or getconnects
    or (syn and syn.get_signal_cons) or (getgenv and getgenv().getconnections)

local K7_LOGO_RBX = "rbxassetid://135382218880707"
local _k7LogoAsset = K7_LOGO_RBX
local function getK7LogoAsset()
    return K7_LOGO_RBX
end

local _K7_MINI_LOGO_B64 = table.concat({
    "/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAQDAwMDAgQDAwMEBAQFBgoGBgUFBgwICQcKDgwPDg4MDQ0PERYTDxAVEQ0NExoTFRcYGRkZDxIbHRsYHRYYGRj/",
    "2wBDAQQEBAYFBgsGBgsYEA0QGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBgYGBj/wAARCAEAAQADASIAAhEBAxEB/8QA",
    "HQABAAICAwEBAAAAAAAAAAAAAAYHBQgCAwQBCf/EAE8QAAEDAwIEBAMDBwkEBgsAAAECAwQABREGIQcSMUETIlFhFHGBIzKRCBVCUmKhsSQzQ3KSwdHS4RYX",
    "gvAlU4OywtM0N0RUVXSUoqOz8f/EABsBAAICAwEAAAAAAAAAAAAAAAAEBQYBAgMH/8QAOhEAAQMCAwQIBQIGAgMAAAAAAQACAwQRBSExEkFRYQYTInGBkaHw",
    "FDKxwdFCghUjM1Jy4SSyYqLC/9oADAMBAAIRAxEAPwDf6lKUISlKUISlKUISlKUISuK1pbbK1dAMmuVD03oQgIIyDkGleO3OFUZTC/5xhRaVj26H8CK9lZIs",
    "bLANxdKUpWFlKV8CkqGQQa+0ISlKUISlKUISlKUISlcVrS22pa1BKUjJJ6AV0MlUlQfUClv9BJHX9o/3Cs2WLr00pSsLKUpShCUpShCUpShCUpShCUpShCUp",
    "ShCU7Uri4sNtlR37Aep9KEIhQWgKHeuVcW0lDYSevU/OuVCFhbZIEW7TLZLUEvreU+0o7B1CvT1I6EewrNVgpDqJWuo0RfIExGS8MndS1bDHyAP4123y/wAC",
    "zMJ+KkJbKtyM749h69qYdG6RzQ0ZkLg2QMaS45BZdSgkZUQBWAveq7ZaI61vym0co3JVVd3/AIlvzXVxYTi46eiUMtGQ+r/gBAT/AMSh8qhkpq+Pc0uPo/8A",
    "OLp38e+vl0/RpGEJ+uam6LAi4h1Qbcrgept6XULWY5sgilaXnxt78lLk8VJD8yQu1W2bOiIVu6w2VAGpHbOI630jxrJeR8oLp/gmqwiay4nRrfItrVvjxecc",
    "rRisJZS18gkCs1p3QGobwtMrUV/uslatylUlYA9sA1L1WG0sbCZg1o3WcXE+gCg8PxPFJ5dlrTbftN2QO7tOurTa1vb1DL8G5M/14jg/8NetjWOnn1hH5wQ2",
    "o/ougoP76w0Thlp9plPiIeUody4rP8a7neG2nXE8uJKR7PK/xqsPbQ3sC7yVsaa3UhvqpUxLiyU8zEhtweqVA13VXj/DFcYlyx3+bDX1AKuYV0idxF0vj42E",
    "3fYieq2TyuAfLvWvwUcn9CQE8Dkfwt/ipGf1YyOYzH59FZNfCQlJUSABuSajVg1zY7858Mh4xZo+9EkDkcH0PWs9JSXkoYABS4fN6co3P49PrScsD4nbMgsU",
    "1HKyRu0w3C6+T41wOLP8nScpR+ufU+3oPrXsoNhilcybrcBKUpWFlKUpQhKUpQhKUpQhKUpQhKVwcSVI8v3huPnX1CwtAUP/AOUIXKlKUISsWqYJGqBbkHAj",
    "tB9f7RVkJH03P4V6Lm+5DgLmtpK/BBUpv9ZPcfOotoOabxKvF8dUAt6R4SUH7zaE9AaZihJjfKdBl4n/AEl5JQJGx7z9AprXW+83HjredUEoQMkmuD0yKw2V",
    "uyG0JHUlVV9fdWv325OWPTTzYUkhLk5eChj1I/WV6Dt1rNNSPndkMhqdwRPUNiGeu4L7cNXCzKlRbfEM2+zni8IyPMWUkAJ5z2wBWMg6Av2oppuWqp6xznPg",
    "NkgY9Cf7hUv0zp6waejZbfbflOHmdkuq5luK7kmpKJcXG0hr+0KefW9RdtM2x/uIz8OASYoxNY1BuOG7x4lYi1aQsVojpaiwGU47hIrIvW6KpogMJ6dAOtd/",
    "xUb/AK9v+0KfFRv+va/tCo10srztOJJUg1jGjZaBZYUwbKg8zhQ2ofoLGFfhWTiNoSR4LRQ2B1UnBJ9ga7w7HUchxsn1yK7AUkZSQflWHyOcLFZa0A3C+0pS",
    "uS3ShAIwRkUpQhR++6Nsd/bBlRUofTuh9ryrQfUKG4qPsytTaKfDd18W82joJaU5eZT+0B94e43qV3y6ItrLHIoLkOPJQ0wDu5k4I/A5zXtkPRUMESnG0pI3",
    "CyKeiqJGsDJBtMO4/bglHwsLi5hs4b/zxXG33GFdILcyBIQ+ysZStByK9VVJf9QWXR13Vc7Fdo6A4rMi3lfke90gdF/x716P95WoLvFS5YNLTQ2of+kS0hho",
    "f8S8Z+lMnB5nASRizDvdlbvv9ko/GKeElkru0Nwz8rZqyZ1wh26P40t9Lac4A6lR9ABuTXCKJckCRKCmUqHljjqkftH19u3vVNSLnfo6H9Sag1bbIrTB8NAh",
    "MKlLCz0bbJ5UlZ9Bn3wKsfQIv7unDNv0l1bkhXO007y8zSOwUQACfXG1aVWH/Dxbe0Du368Bcefu5RYoysfZgNtd3rmpX0FK6XXilwNNgKcUM4PRI9TXakFK",
    "ACoqPcnvUWpZfaUrqeUeZtodVqx9BuaELtpSlCEpSlCErzSFGMlUlKVKQN3EpGSR6geor01xWeVBOCcdhQDmsFcWH2ZMdL7DiXG1jKVJOQa7Khk1u96YmP3K",
    "2pTNtbqi45FGymiepT7VJLNdo17szNwinyODcd0nuDTEsBa3rGm7feRXKOYOdsOyd70XtcbS6yptYylQIIqm+W4acv8Ac9Osy1Q0zCVRncZCT2/w+lXNUL1D",
    "Fjaj1fBtLKUL+FV48p0foAdE59TTWGz9W5zXDskXPK2hS1dDthrm/MDl46qqpq7WqV+adWrvNunqOEOOXRSIcj2DnL9mT6L2/aqHakuVj0RM+GmaT1RGGObL",
    "d1wFj9YHkwoe4JrZjUmj7VqO0KhTY6FjlwCRVA6q05qDRUZdpk29rUWl1qJNrnEkNe7Dn3mj7dParbg2JQ1Dg1xN97dogH/E315HLmFSccweriPWxPy42BPj",
    "lfxHkSoZbOL3DeVIWxL/ANp7eUb+I9dcj6+TI/Cs6viBw9Zt6ZarhqFTCwShxu7c6VY7AhHX2ODVa6p4S2HV9ukXHh4+7OWykuSbFNV4c+MB18Mj+dSPUZ9x",
    "VGOpvunnn7eIypMJYKn4klBCkBJ+8rG4I/XSf7xVs+CpJbvZtWGo2jcd4OY78wdygY2TzWa2ch3CzfTLP7b81tozxS4bPoym4apbTnGVXIA/9ysnF1poSavl",
    "jTdV9OYrVcUhIHrnk2+taSQHrdcJJTY0y3pSVZVEkvAHH7GN1/LY+xrYThm3atVfHXK6xHlx7RbzIVZYZDQkrZ+8jm64x5jnJ2OK1dQ0ZidI0uy/8r8uW/iQ",
    "FpXxV1NbZm14gfhbB2pzSlxtr12bvmo2bdGTlya5cAlkH9XmKPMr2Tkmprw3VcZ9weuMZ27IsYTyMJuiwp54/r4AHKPQHJ9fSq64aWGVxJlxb3f1MN2qGMwb",
    "TEBTGjD2T+kr1UdzWxceOzFjpYYQlCEjAAFUDHKhsBdTg3dvubhvLmeJ04cVd+jlDUFjZ53d26/+uA8TwHbSlfFEJSVE4A3qqK3ri880wyXXlhCEjJUTsKgu",
    "oOKFot4ci2hDt1ngEJYiILis/JOaj+sNRqv0mQyhchFhgr5HzHz4k50f0DeN8dOZQ6DbrVOao1BxUi2iW9a7UuwWplK3CEspjIDQ/SI2UcZA71bMIwBs5HXE",
    "A8CbDu3knkPNUnG+lJp3mClbd3G17fgc8+6ynb981i5cje725bbA4QfDVdZI52k/stJyrPzxUSvPEbSjb/Jd9S3jUkpR5Ux4P8lZUfbGVkfhWsl01yxKvyIF",
    "6uNwny5C0hTsNQQlGT93Cxv89qi6tbXWdcHIVjaYgtOEsqcZBLriOmFOEk4x2GBV9iwemjeGON3aWaNn1zd6hVlxxKqbtSP2W68fsAfFq2fk8Y4dlUsWqx2y",
    "0vJ2CWAmRLPzWrm5PmTn2rOWi/XrUtpVrDWc6Tb9Otq5EtpUVvznOzTWdznuRsOtVlw24bWi26WTrbW6nm7WF/ZMAkPT3OoaaHpturoO9XXozTV14i6nj3m9",
    "x0R4MZIRBgM5DMRr0SO59VHcmuGJGipWOLG2Iyc7U3/tbe9zxJvs96j6PDH1swjBLhz077aW+vcpJoHTFx1rf4+ptQxG4lsheW22psfZxk/+JZ7q71d8p9uB",
    "bVvBGUtp2QDjPYCkGFHt8FuLHQlCEDAArrehNz05klam8gpbCikbdCcdfWvLq6uNXLtOFmjQcAvXKCgbRQ9XHrvPErnEZkJK35biVPOYHKgeVAHYevU716q6",
    "2ytGG3Fcx7KxjP8ArXZSBNynwLBKxq3yrVbUbOyIynMDsSoDf99dl4uCbVYZdwUnm8FsqA9T2ry6ejD82JuTzpflzEJdddPy2SB2A9K6sZZhkPd4rm513Bg7",
    "1mKUpXFdUpSlCEpSlCF4JjzMNtfxOPh3QRk9EnHT5H+NRfh50upYWpUT4jLWRgd84/dXt4iKeRoKUpkHOU5IGcDPWshpSC3bdGQWEDH2IWonuSMmnxZlITvc",
    "beWaSN3VIH9ov55Ls1FdV2mzl1hAW+6tLLSScDmUcAn2FdtltTdptiWAQt5Xnedxu4s9TUDXcWdScXGIiXlqhR/OEA4Clo749Nx/yKs2tamIwMbGdTmft5La",
    "nlEznPGgNh90rxXO2xLnAXHltJWgjfIr21HNb6gY05o+VOedCDykJJ/jXCnY98jWx6k5LvM9rGFz9AtZeIGnYTOr1J0+8+i4IfS3CciKKXfGJwEoI361COOU",
    "2zP6dt1pvryp1+aaU1OvduSlPiPfpJUlOA4Eg4J2J61bEa13ZFuk6hTGQzeZbBMZclQbbtUVQ3edWdkuLB+YTt1NVTdtP6XmaMva9PXJ2+3izJRKdlOtfYcq",
    "1FKyyg7q5VFPmVsc9K9bwtzHuYJHE7GVxxdlmdzbkZfqNzYgArx/E6omo2om2GpOmnDmN5GgyyuQtRLrb1Wm6qLRylZBbdGUh0Z+8Adx/pV+cBNcNp4oW+RO",
    "JS44pMWSgYCZDSvKoq/awdz3+fWq9exWnb649c5RRLkJRIRIAJQ6FJG6h1Sffpsdq8uhJb1o1Uwh9BQ7lLoWFA+XrkEbEbdqcija2d1I7JrwR5qermmqoetH",
    "zDMd4X6M8EydN6mvei3nMmBKW22c/ebPmbV9UkVe1ay2W/Muaw0lruG6lTF7iCBKUnYeOx0P1Qf3Vsu0sOMocByFAGvM+kkLhUCZwzcM/wDIZO9QVYei1WJ6",
    "MMH6cvDUehC514rtFkTbJJiRZHw7zrZQh3GeQkda9tKr7XFpBG5WRwBFiqNv2g9dQtPkSdeyIduitlKWLc2mKAnrupPmJPUnO5rX7WaRo/hNMmSZD8y56kc8",
    "TxZTpcW3CbP2Yyrf7RY5j7BNbT8VJ/x5haOZfLRnqKpLif6KOgczq/7II+ZFaQ8f+IKLpfS3b2whtILUROxSy0PInlHQnCfpXp/RiWaVoklA2R2jYAafLprd",
    "2f7ea80x6GEVbaSnGe83J79eVh3HkqRLcyZPecZZdVOkqSzGQndSipW+O/Tb/iq5+CHDGIvXKGLw20+5FQqRcVlQU1BaSCVZxspwAdM4BwNz0gWn7bK0pZxf",
    "JrJF/uCwm3tOHK221A80gp6jOcJJ9yOgq/7VaHNC8E4dibKm75qwhyST99mGk9/66v3J96n9h2yX3s95sOV83H9oue+w71cTqrt+Hj+X6/6vYeN9ymGnLZO4",
    "n66Tc1pWLWyS1bIZ+4wwDgEe56k9TvW1On7FEsFobhxkAco8xA61WvByxi06ebaiMfblI53FDytJ7fM+1W4y0GW+UKUok5KlHJJrzPpFXmafqWZMbkB79lXj",
    "AcPbTQB1u0dSuS0BYwScdx61y6DalcVqShJUtQSB3NVxTy8xebk21Tgc5cZBUP0VA4/iKxFhv6b8x4LDmVskiQsbY3ISB7kb5qD6j1/Ctsu9WWGhx918lTTb",
    "Iyc8vmx9d89Kj2hbpqNLr7FkYMhbwShbiwfDCwkAlKuhH+tT0eDv+HdI/LQi/v3ZQkmLMFQ2Fmet7Z9yszV96Q9GXp22nx50n7JSUDm8MHqT9Kz9jt35p09E",
    "t3MVFlsJJJzvWO0vYRaIalzOV24vKLjzx3JJ7A+lSGoueRob1Meg38TxUlDG4u61+p3cAlKUpVMpSlKEJSlKEKHcS5/weh3mQypxUghA5e3f+6vkrVUK38NW",
    "Z8d5t1wsJbbTzDzKIwB+NZfVdmN800/CQstu45m1jqlQ3Bqgk2a6ru90iSXHGJdqjOz0wmVfZScA4KQfuEE5Iz8sYqxYZSwVUIDzYsNzzvYfgct6rmL1s1E8",
    "yMbcOFhyOfv6KccPtHfnKMrUQucmO6XlqaU313PmznsSOnoBVqw5K15jSeVMlseYA/eHZQ9j+6ojwpkRVcN4DLUhLi0o82++akc54HUduZj4VIBUpwD9FrGC",
    "T9cYpLE3vlqXsf8ApvbwUjh0TIqdhZvtfmSstVNcQr43M16iAqzTbwi2BLjdvZbIRIfO6S4sjlDadiRuScDGAauWuvwGfELnhI5j+lyjNLUVU2mk6wtvlxt7",
    "8M+a71tKamPqw63r9VQK+HGuNfSDM1lJbjw+YuN2uPkMoPqoZ86v2lZrBT9KWrSXEWyykNhFruiXLNPQegS6OUE/JfKfpWz+NqpTjlYFq05JfYBSh8c4I/Qe",
    "TulX1xj8KseFYzLU1Ap3nZYcrDIC/wB99+IVfxLBIYaR5ibd2tzqSOP07lp9xb4cy0Jk2x2OFSLJ43K4lOCuMDkYPcIVnbqAr0Fa/WOf4N5EOQ2eVIUGcnBS",
    "rB2B/a6Y/vrdXiNenYzen+IjDQkW6/QQxdoRzyOuJHhPA+ijuQeucVqHxX07F03xHmW+1rcXGbWHI/ON1tKAWk7dTgirvUvkMMdUR2hrbiDZw8D9VWej85cX",
    "0b8xuPLd5ixW0XBi7HUXAG62hhxSp1mW3eYo6EFs4cSB/VJz8q3T0Zd273omBcWlZDjST+6vzc/Jo1yi28TISJ6+aLJzGkkn77axyKz9DW8vBeY7bE3bRUte",
    "X7TLWynPdGcpP1BFV/pZTiaLr2cn+fZd5EA/uUj0ceaOvkpXfqvbzuPO5Hc1W7XVJfbixHJDqglCElRJrtqtOKl+dUzD0fbHCJ11dDGUn7iD95R9AEgn6VQ6",
    "KmNTMIx48gNT5K611W2lgdM7d6ncPFVHxI1a4NP3O/NEquF/cNqtiM7iOlWFLH9deB8k1qNq26aTt+tXESQu+yIaQhCUL5YiSkY5Tgcy98nbAPTfrVpflAa4",
    "i2rU3h20gpgR0xLYyVZDTYTjxSB+kTnAPzPatZ7bbJ971W3BYZdcfdWG+UDJ5j+jivXKRogp44oxm7MjluHgAPG5XmtDCaiSStnORvn73HPwNtyvbgTpC4cQ",
    "uKEjU1/cJt8fMmfIdHlQ2NyB9BsOwFW3BTO1/wAXPz4yxyRZEgRbeyQcJYbwkBI/VSMZPTPucV7NPadi8MuAjVgnvEzb04Fy2oyxzuNJ2SwhQ7rUDlXQJSo1",
    "dHBnRbsOArVF1jsomyUBLLLaOVuO0PutoHZI/EnJOSaQxLFm00ck4zA7DOf9x8Tv4AW1yMNo3YlWDZyaLE924eX/AGN9FZ9itTVnsjMNoDKU+ZXqayVdbboW",
    "ShQ5Vjqn+/5V2V5U9xc4udqV6m1oaABouJcSHQ2ThRGQKrbitfXI0Vm1x3HAopLy0trKFLA2CQR0ySB8qmOq5gt+l5M8LKFsjnQsHBCu3+FV1YdL3rVl4Yv9",
    "8d+wGyQrbmGQdh9O/wC6pXDI44z8VKey31Ki8Te+RvwsQ7Tt/Ab1XrOnJZvke23O2oim4OpK3Qtbi1t/qFSicDmwSB12zWyNntEKzWtqHDZS2hCQNh1qPa2t",
    "TXwcG5MoSl2NJbAV6AqAqYDZAye1dMVxJ1ZHG7QZ3HPL7LTC8NjonyNbvtn753XSQDcE57Nkj8a766mPOkvHqvp7Dt/z7121ClTASlKVhZSlKUISlKUISqI4",
    "otXiLr8Isa1sypsbwEOtnBRlaTn36Y+tXvURvdoTK4k2WWWg4EIcKh+rjGD++pTCKoU0xeRfI5HzUXi9H8XB1R3kfVVIxD1Foueww7yRpEhKltPRjyNKUAVc",
    "imjsMgEZTjBI2q4NCGRL00i7zvNKmedSj1A7J+QrAcWrPJn2aNLisrWWCrJaGVJyMcw/577b16eHOqmbjbk2lbaGlsIAb5VZCgNu4ByCCMVJV0rqyiFQAL37",
    "VvemmXJIUMIo6x1OSdm3ZB9VP6+FQCwk9T0r7WNvUjwIaPCX/K1LAjoG5Ur0x6Yzn2qttbtGysLnbIuslWC1hao140lLhyQOVScAnse1Z0dK6pLCJMRyO4Mp",
    "WkpIraKQxvDxuWJGB7S071p3N0+5ceGGsNDSD/K7Q7+d4QPXwlHldA9shJrVzjXaFtC23tLwcdMduLJbB8zDzbaQR8iOUj6jbFbq6hxpjjhbJNwSBGfUq2zC",
    "obOMujlyfbcH5pNaocbWXdD8Xb7b50Nu4W6Q+fiITwKUdfKUEbpIzsoeuDkZFeuUk5qIHsOjht+dg71Ad4ryyGF1JiWy3nlx3j0Nh/iqa0lc37fdGZLSggqW",
    "kKCNvr7djX6KaM1MlWvtK6sQ6PA1BbkxpJz/AO1MYQrPuU8pr84ruxAs+pkfBeMuFKYRIbQ9stvnTkAkbEgnr0PpW1nBDU7t64I3K38yjP05KavDAz5vDBDb",
    "wH0KVfSuIjFRSmB27Lwdl/22T4FSOK3gnirmaA5++648V+gbr6GoapCyAlKebNau6/1kqHb9S65S4ErWVWe1rUehP8+6PphAPuatHVmtubhHDNsV4twuiURo",
    "qE7lS14A/jWlv5ResUMzGNGWWSHYdoZERBbPlcdG7rp9yrJqC6LYZsvdLMMhr/i05j9xsOY2k30mqzVOjooTrmfH8C55HZVH6xucq+6yUpvLquZIbCd8YAAx",
    "V/cJ9JOOastGmGizAjMxRLvsoIAcB3cWlSzuOVOE4BG+apbhnDcamS9ZXBKlQrakhJSvlW7IWlQaQg+uQVEjoEk+lbPaatr9j4Sx2VNJZvmrVYIbGCzCSRzY",
    "7+dW2T1AO9XDrQ5r59HPyHLn+1oJ8lB4r2AyjYLga8+X25Xup7oi0u8TOKruoJTBRa2VBEKOejTCfKnb1IA/fW0cdhuNFQw0kJQgYAFQrhdpVrTej2fsgl11",
    "IUdugxsKnVeWY7Xiqn2Y/kbkByCvuCYeKKmAPzHM95XjuRLUFUtC0oXHBcBV0IA3B+Yr0sueLHbd5SnnSFcp6jI6VwlssyILzEj+aWgpXvjYjeopZ787arOl",
    "y8KP5vU4pEaWtWTyA+Xn+fY1GxwmVnZ1B92Um+QMd2tCsprG2Ku2jJ0NC+RRRzJPuN68PD+6s3DSDDCQEvRh4S0d9u/1qJay4h/FR/zfY23Fpc2LmQnxNtkp",
    "zuc7bgHFSfh1YX7NpdK5hzJfAUsBOAPQYqQlpnQ0X87Ik3A381HxVLZqz+TmALE7uSkN8jIlaflMudPDKgfQjcH8RXc4S6y0wT5nACrHXlxv/h9a+XRTSbNK",
    "U8rDaWlEn5CuUFKzDbeeILziAVEDpt0HtUXc7A7/AMKTt2l6cYG1KUrmt0pSlCEpSlCEpSlCEryvIT+c4zpG4StAPucH+416q6ZQ+w5x1QQsfT/k1lpzWCub",
    "zaHWFNuJCkkYINUy1pK9z9Qzblp6QI0Rp1aWXNxzE45seqcj8c1cMhp6Q2plLhaQpJBWN1b+np864W6M3DgIhNICUsjkGOh96dpK11K1xZqUpVUjaktD9Aq5",
    "01r6RbZLtq1Svk8JZbElRyOYb4J7bYIzUrsdxj6h1FJu0UhcSO2I7KyPvKJyoj9wqA8WtLx4LjerI5WnkcQJTSSSh5vPmSpP6WQTtXHhvrWBaLc5apqVJCnV",
    "KjuJSeR0KOU8pPsR13qZnoo6im+Lpm9o5EcOPvmoeGukgq/g6k9kZg8eAVykgDc4r7XUv7eIrw1DKk+VXUZ7V0RZi3HfhpLJZkJTzEZylY6ZSe4/xqshpsrH",
    "tKquO+k03bS350Yb+2YGFKHXHY/Q4rWD8oPTv+2nD2w69aQPiZULwZXqX2fIsH32CvrW+V4gtXGySYbwBQ4gpOa1Ou2nnJGjNdcP30KW7BV+eYSc4PKfI7j8",
    "Uq+lX3otXbUYjefkNv2vyPkdk+CoXSumMErayP2Rn9NoDmVoZqBp3/ZS0ynPMuM47DdUR5kEK50JPtyk4+o7VaP5N2r2bNxUhi4OgW6YlUCYnsWnRyK2+Ss/",
    "SoTq6AuJpB+P5lSmriHJXOOgU3hog+4C8++KiWnbs5a5ZebHLyqSdvXNTItT1hhlya4EHysm5YvjKI7Guo+q3xN9n6O09d7leVkjSfi2yAFnZcxeUpUP6rfM",
    "r6prTTUV7N8vD0qcpTMNtSvEKACpSjvyjPVR/cMmrQ4r8Zo+sNN2SD4JYQzHS9OKDvKlcqUKX8ylCBntg1REUS75dmo6EEoLhS22jJ3J7dyT6/KmKuV0bepF",
    "usecwNMtPC5Lv3WUdg1EW3qJt2Qvw95eAV98DtLDV0qHZUMiJbXpiZLnOoqLbLSFFx1Z6ZwrrsNsVtdw8tSNfcT3r+I6kWtjlYiNKGzUZvytpHzxk/M1Uml7",
    "XG0HwSYW0EoumpGkwWCDkoioOX157c6zy/IGtgOF92f07As9oh2F/FwXgSJH2fMkDzKQk+ZSR+tgDJAyaWxiSSOkIi3AtG7TN58xb9p4pXC3RVWIdbKcr3A9",
    "B9b3335K9UIS22lCBhKRgCuVK4POJaYW4ogBIJJNeU6r07RQ/iDqdi0aedhMr8SbJSW0NoO+O59tqrDWOtUXeyxLUzHDEaPyLebWU8ywMeQJBzk9N/nWIvPx",
    "uqtdSrfHSJLMlwre2yrkSvAQk9htkjvkelXNYeH+m4duYWLe0pWArJT3q4BlNhUcbpRtP19/bz5Kp7VVij5GxnZj077KN8NtBIQ2NRXhkLlv+ZsKOeRPZP0G",
    "1WsAEpAAwBXRHjNwmgywOVgdEfqfL2rtUpRWEIIz1J9BVarax9XKZHnu5BWKjpWUsQijGi8sttL/ADh5AWy0nmLZ6LV2z7f89q9LCC3HQ2o5KUgE1xdbyyWx",
    "1WcE/wAf3V3UqTlZMgZ3SldEqWzEZ53TuTyoSN1LV2AHc1yY8bwuaRy853KU9E+3v86LZXRfOy7aUpWFlKUpQhdb7immS6ElQTuoAZOO+K+tOtvMpdaWlaFD",
    "KVJOQRXOosxNVYtZrtMg/wAjnkvRlY2Qvuj5HrXWOPrAQNRmub37BF9CpTXTKWlMVaTuVjkSPUnpXFmRzyHY7g5XG8H+sk9D/d9K4RliY78Wk5aGUtfteqv7",
    "h7fOtA22ZW175L1JHKgJz0GK4N4BWO/MSa7K63PIsOjO2yselarZea4WuJdEIbmth1tB5gg9M+p9apviVpS2WRxq5wmi1zq5X2WcpLjZIyoY/SHUH1q8a80m",
    "BEmJUmSwh3mGDzjO1SGH4g+kkDrnZ4JCvoGVcRjIzO/gqV0dxLmwUMW+c+xNjeN4KZbK+bA6pC09UqIHQj19KtKNDnXEIvE2S5HdSD8M21gBKT+sP0idtqqL",
    "iHpFqw3tU63RwluSjohBUErSQpCsD0IO+/U1ZWhtWMahsqYyvJKZSAUk/ex3H4VMYrFG+JtXStyOvv6qKwqWVkrqOqdct05qXuNB+Gph3CgtPKr3yN61t1s+",
    "dJ8YrNdZoPgeKbfNUejkd0cmT9D+IrZZKuZOcEfOql466QN80U9NjI+3aSdx19aV6PVLI6oRy/K/snxyTWPUrp6R2x8wzHhmtGeNWkv9iOI97hXSGl63yHEN",
    "KSokZQFZS4kjoQOnzxjetdpsFVrvsmDIQUlpwoJzgHB2P4b/AFrfPinbGuJnCvTNwlslc56G5CS4DumYyMFC/ULCRjuCoH1rUTWlo8KxWaRPjKRMcYUwHebd",
    "aW3FI8w+XKkHP6O9X+rifUwsnI7bcnd4JB87ewqlgFcxoNNc5aX1ta49NVXjzqnlnxVEBOzaB3q2OCmlmb3qJpb0lLDaHUIdfUeVDDas8yir5DGB61WjFtXO",
    "v7cGKy4twqDSW0jKlHpgAd81sXo3SbrdygaDsKXn7guSDPcbTlPiYwGwO/JlWT6k+lYwSlc6Z0zzYNvnwtv8E50hrBFSmJmpW09mvOhpmpnrvaraJFr0/ESy",
    "q7TWwUx2kDCW47R25lKyeY5JJ7VZHDaDcL9dJWvb60puRLAbiR1HPw7A+6n575PuarLT+lIt3vkLQdlObFZ3g5cpKTtNlgbjPdKOg98mtkWWo9ttiW2wlDTS",
    "MDsBgVUcdqI4h1UN7uFszchu7xdqRuFhrdZ6K0EjgambS9wBpf8A0Mgc95uRZehbiG08y1BI9SarniDreGxEFmt0oqkOH7ZbWPsW+pUSdhtnrUF1TrS/anvS",
    "bXbwvlMhbLLbOUoVy4ytwg5wCcYGM+tZmz8JpM+Wyb+7ysJw4WGVEJJz1OSSon3Jxjal6fDIaLZmrH2OoHv3zUrPiM9aHQ0TctC4/Zerg7Y3ZEZeopTHhNuZ",
    "THaO5SnOck9yepPc/SrZRytLcT0TnPyzXVAgxbVbW4UNvkZbHKlIr0NpIypX3lbn2qGr6s1c7pdAdByUzQ0gpYWxDcvqvO0Qk9Rsa4MEKb5wcqJ83sfT6V8d",
    "PgtqdT235c7KrBTbwrTkxJuy2hBkLUoPjbw1HflPt70tHE6Q7LdUw+QMzdopHXluM9i2W16bJVhtpJUfeolceJtkhym22eZ5tX9KNkn5Hv8ASsEiVc+IGpXY",
    "rcj4e1sjKkp6qB6Z9/8ASnYsOk+eYbLRmUpJiEZ7EJ2nHLJTWwePdkp1BOQEqdT/ACZnr4LZ7/1j3P0rP15bfBbt1vaiNOOrQ2kJSXFZOBXqpKV4c8kabu5O",
    "RtLWgHVKUpXNbpSlKEJWKv1lReYCW0uliQ0oOMvpGShQ71laVsx5Y4ObqtXNDhsnRVVervqJK5MVfluURssqUyk5fbV3SP8AnFT3S9wYuOlIT7OBhpKFJH6J",
    "AwR+6vLeA0zrOzSnEJQhXiNKdI6kjypP1rw6htT9kYfv+n3THdT53owP2To7nHY+4qUkcydjIwNknQ7r6W96KPY18L3SXuBu9b+9VKRKQH1Mu4bWAVAE/eT6",
    "iu7ZSPUEVEbHf7RrmzOMrAS6nKVIzhSD0JBrA3LU970ikWi4tKWypfKzOJz5O2ffFcG0Ej3mIZPG4/ZdnVsbWCW92HeFZTZJRgnODjPrXOvNBkxpUJt2M4la",
    "CkbpOa7niRHWU/e5Tj50iWkGxTYNxcLyLhMTJpkvthaUp5EBQ29zUD1TYVacuzWpLKjw0pXl5sHCcZqyEDlbSPQYrHahQ2vS84OpSpIZUSD8qbo6l0cgG45E",
    "cktVQNkjO4jMHgUsF3Re7CzcEIKCvIUg9UkHBFem4w259seiOpCkuIKSDUS4XeGNEpT4/O8XVKcQTkoOdgam9a1TBDO5rNxyW1M8ywtc7eFqpdNMPt23Weg1",
    "ozyp/Pdu7EKR5XQn3wUK+lar8Tm5164U2S7S8rmR35MRx5SMEAFCkgnufMo561vrxKhCza6smqko+yQ94MgfrNrBQsH5pJ+oFalcW9Oy7Wm6aVZZLgau5AaT",
    "nlWlweRY9Ogx869V6P1YrYix36hfxsWu/wDk95XluIw/w7Ehsjf6ajzuR3NVIaGiItsYX9uO8bvJK40JSDyhB5fO9n1AVge5J7VtZw70yvh/oGPLjIUvVWoU",
    "lq35GVR2Dst/574SfU+1QbhHoG03WZIv98UpnTliSkqX15ko2KQO5WrGPdVbP8K9PS9Takk68vsYNFzDcKNjyxmU7IQn5D99GLVcdBTmHcPm5nUN+7uWW9do",
    "o34vWhrflG/u3+Gg53P6VOuHOioulNGMw1NAvLRl0q3JJ6596rbXOq7zFvUmyR58tUZTpYZbYSFOK2yRzE7AZAzv16Vbmq9VQtM2wrd87yknkbBx9SegHuaq",
    "bQ7cK/8AEhMy4LDjilLeRzZKUrJ+4nI9ACfU/KqThjnudLX1Ldoa+Kt2JBoEVBTO2Tobbgsnw107OtN0RertaFx4/ghpoc5cLIySVLJ3JUSSTirkZ8wLpGOb",
    "oD2HahQPD8JCeVPQn2rtGwxUHXVrqyXrXCxU1Q0TKOIRR6BfCAcZ7b19pXxSglJUogAbkntSScXRu9KxjDbR/tK/0/j8qrLi9dUfySzcw6KkqQPvu8gyEJ9z",
    "j8M1N73qBiw2Jy4OIW4txX2LKRlSydhge/WqB1BeLrqDUTV3lsFEwLLdviISHgtzoVEg4CUg/iRt1qxYDQukm692TRe3f71O5VzpBXNjgNO09t27krT4eaRj",
    "O2c3y8Ro70mb9pyhOUJSRsEg58tTC16fhWd1xyAyGudxRKE7ApJ6fTtX3S0ZcPR9vjuAhaGUgpPb2rMVF1tXJLK/tZX8LDRTFJSxwxMa0aBKUpSKbSlKUISl",
    "KUISlKUIXRLiszIi476ApChjft7j3rEqgyrtZ0W6cpTbSRySFZ8zuNsD2Pc1na+ZSn0FdGSFui0cwO1Vc3jRU+zXJF30lkFKeVUcqJAHtnt7VH52qUX6G5YN",
    "WwFxpCTlDiU9Md/b/WrmyD3FRW46VgS9XGXJZS4zLYLSk46LG+fqP4VK0uItJ/5AuRod6jaihI/oGwOo3eSrPSV6m6Q1ULbJlF+E6rDeduZBxhYHTYnBx7Gr",
    "zBS8hC07pOFVTOruG1zhtt3G3zXH2ouS20E5UkEEfXr0qa6C1czeram3ycNTo6QlaCfvAbZpnFo46mNtVAb/AN1kvhj308jqaYWGrfuLqa1wdaQ8jkcSFJzk",
    "pPQ1zpVdU6o+9bRadRIu1shZbfBbltsjc9wsDuR3+dZ5txDrYW2oKSe9ctq6w2lLvOk8ueoHQ10fIX22tQtGsDb2UY4iWRN90JMi484QVII6gjoRWvurNPnV",
    "+noWqIsda570EQHEoO/xTboZyfflOa2peQl1hbSsEKGKoa5SJ2jbhfbDboLrsufIRLtKgglDTysocWT2CRyr+YFWbo9WSRgtj+ZpuO45EHloTyCp3SzC/iQ2",
    "Qd2XHUH6gd6jdo0e1Lulv4Y2JKRa7WpMi7yG+kiVj7me4R0+efStgpL8LSOmWWI7KlqADTLLYypasViOG+jWNJaWbbX9pLd+0edVupSjuST65qTNwQ7c1XCW",
    "ApaRyMII/m09z8z/AICk8WxIVM2yTdjf/Y7z4nyGSlcGwr4KnsBZ7teXLw9Tmd6g8HRdw1Hek3rV4SoJ/m4o+6O4z7ipwi0W5hxkMQmUFB5gQkZGK9+RTA5i",
    "e9Rc9ZJNqbAaAaBS8NNHFfZGZ1O8r7SlM0qmErwLWmZJ5dlRWslauy1dh7gdT74rukhx8iO2SlJ/nFjsPQe5qG6wv7q2DpzTiHHZqiELLKfK0n0z0FM00Blf",
    "st8+A4rhUTCJpcfLjyVf66usrVGtTaIshIRvGZQk5UCo8qnPQADI9STUw0/wrtmnb1b50YcyUpIdSR+ljY/3fhWa0voSBZYyHpJ+ImkhanVDoQc7fWphtUrV",
    "4sWsFPSmzALHmoykwsF5qKkXeTfu5IlKU55QBnc4r7SlQKmkpSlCEpSlYQlKUrKEpSlCEqJ6405NvVsRJtj6RLihSkR3VLDT4/VVyEEH0UDt79KllK6Qyuie",
    "Ht1C5yxNlYWO0K1xkahRDeYMVNxti3QR4hnPH4dwHlUlSFKKVFKuo7j51dOj76nVOkWpEkJRMZV4MpCT9x1PUj2OxB7giqm436WfhOO3iCP5POUFEAfzckDA",
    "+QWkcvzSn1qK8EeJjMe/JZmyQGn+WJLCj0I2ad/8B+aKulRhrcQw34ynF3N13n391QcPrp8MxZ9FVOux3yk+n4V/a41CbDpVQbW2J0n7Fnm6JOMqWf2UgFR+",
    "VUpBMe4zEv2YXEXea8IsR/41wcyuqnVJBxypSCojGOg71guLXEJy+6zRbbW4XC8oR44Sfus826vmtQz/AFUj1q1eDWmcwhqqU0AgtmNbkkf0Wcrd+a1DP9UJ",
    "rUUf8Jw4Ty5PfoPzy/BW8lXLjGLiCA2ij1PFYrV1/lQdTzIcu53NSYzzcdHw8pTIx4SFEkJ6klR3rOWzXUu3cKG5bjpkT3pr8SKZCubAQtXmWepCUpye5x71",
    "U3G28ptXEaYhasBcwKGPZlupIbNMunAiBd4ba3BFmzC8hsFSg24paSsAbnlyDgds12lw+H4SlklFg8/b8rhBX1grq5sRJ2B2QsdK1xIlurkybtdXxzFPifHf",
    "CoJ9EpSQB8sk+9eZvWTanQlyXdEo6FQvh/zVXdvuk2yPsurtL8pyOXEsvsNoeQpKsZyFJUk/dG+xG9Z9PEa57c1jlAd/+jo//lVYJMJLTaGMFu47VvoVVoMR",
    "c9u1U1MjXbwG3U1h6iblPhmJKvMiQrCWmGrytxbqycJSACds9T0Aye1S3WbM+w6b07Fus592Spt5cp5l0oUpSUcwAWN8An64qtLDxcetl/YPgtxZKsciJcJp",
    "CV57cyEpUnPTO/yqZcY9WRLnw/smoo4KEKak8yFdW18oSpJ9wcioWooahlbDG+OzXHjfOx3qyUdZEcNqXQzue8DeLEeCzfDHULszU0qJHkzVxfzcp/lkyFPY",
    "WF4yCem1QWfrGU2tlUmdeHXXWQ8tTdwcbSCck7DYAV9/J1uX51u0+SFZ/wCjXR/+QVT2qNTph6lTBU04+j4ZLSm2/vHmRjbY+vpT9FhLX4lUQ2+UD770jX1t",
    "V/CaVzXkOJNyNbK1U62yoAzLtjrkXs7/AP3V6o+t3m3Ati5XptQI+0buXjBPpkHmH4iq7i8V7whhDadPO8iUhIJgME//AKqxV217KkTfjZdudhrcR8OHVsIa",
    "SlJUFYwhCQSSB1z02qQjwWSR+y+Jtv8AK/pdRc9Y+JhdDVSFw3EWC2f/ANvZ1w4W3Pml4uURyO0qSwOTxG3Vp5XAN+UkEg+hBrBaS1Q+7ru3RotwuS0uTfh3",
    "UyZankqQULPQ98pG9R3TDjDnBfUdxckIMpUiG2GUKyEMoWnkUD35sqV7Zx2qL8Ib4LlxejR0qBSi5JV1/ZdFV+PC4xTVbmt+Q/UD2FY5MRqnVdBtP+YDatoc",
    "1ttIS7J5ozLhZT/SOpG+/ZPv79qwWqEI03w0u0i0pEd1mMtaHBurm/WJPU1J0JSlOEjFRniN/wCqq/Y/90XVHpTeVjN1x9V6HUC0bnb7FUDcdXPR7lJZNyve",
    "GlEFarqtIxnA9q6G9bLKxz3S7Ae16P8Amqr5eqWxrKe0UOPFuSVpS2AshSF5BIIIxkdx3qXMcTbuVJH5sUB/8jH/APLr1mbB3RgBkYOQ1dZeKU1e9wLqipka",
    "b7hfJWPYblcNQz2LbYrtdlz3lDz/AJzU6iOgbrcWB2A2APUkds1sK0gtsIQpRWUpAKj1PvVF8KdRajvepW24jSG4yfPNPw7SEpRg4GUJHmJ6D0BPpV715xj1",
    "2z9WQBbgb+q9S6NtBpBIHudfe4W9EpSlQisCUpShCUpShCUpShCUpShCxmobJE1FpuXaJictPtlOR1Seyh7g4NfnvxFh3fhrxEkPPQ0uR3VrZls7hCyR5htu",
    "AoEKGOmdulfo3VFflDcMmdV2A3ZhhxSyEsyfCbK1AA+RwJG5KSSDjso1bOieL/BVBgkPYfkVWekuGCqhE7W3czzI3+O8LX3gjpi7cSddm53DxAmUpWVDbwo4",
    "2WoemRhtPzV+rW+MWMxDhNRIzaW2WkBCEJGAkAYAqu+C+gWtEaBZDsXwJspCSttX3mWwPI3n1A3P7SjVlUp0kxY4hVHZPYbkEzgGGChp8xZzsz9h4LRr8qZy",
    "ajivyRmXFpL2SUgkD7Nv0rYLQuqImk/yeI1zmpCnFOvhpnP84rnUfoBuSewBqcX7h7o7UFzVcrxbUuSFAczgdU3zYGBnBFdr+hNJzNORbK5bEKgxSSyhDigU",
    "E9fMDnfvTNVjlPVUVPSSMNo9efcuFPhE9PVT1Mbhd97a7zvWn18462mRepC3dIQZSis5dTZ0kK365KwT8yM1iHeOVoSkhOhYJHtZUf562wvfDrhhYISZc+1S",
    "EpcWG0JafeWpaiCcABW/QmvKrQ/Cd3SLeoDBkmAThJS+6FFRVy8vLnOc7YqYZjmG7I2KZ1tBmot2E1wcQ+obcZnu46LSK76ol61vsZmy2R2CgPF5xQZ8JtGQ",
    "AcJBISMDJ33JNXlxVtV1s35LttVJZdTLkKlSQ0oeZIWUkA++MH61f+kdCcNZDabzZbIHFNOlAMvnWptaevlWTgisnr5nR79six9WQ3JTZWVMNMpUV5A8xHLv",
    "gDrXKp6TiWeCKKIhsZvbf4LpB0fEUMsz5G3eNd2oNyea1x/JAElUS5GS2tCxCdGFDH9IK1/1xdnrXxqckPw5T0NttKVBpGSctY2zsevev0DtFu0DoixJv9oi",
    "qaYuCUIQ4gqdW6DuEgE59TivJB4a8MtSwxeolmK231KOQ64jfJBHLnbBztWIekkcVVNVOjdsvsPLW66yYK6SGOnD27Tbnwcdy05a/KAt0eOhkaJgKCUgZVZW",
    "yf8Av1GdX8TTrCJ8JbNLqjSXUeCkRoKY6MFSVZISTzHy7dMZNbr6h0Jwl074Ee42aUXHcuIbjuOrXgYBOx6ZIFYqLaOCiJSXFWO4ICTkmSh4tj3Vknb505Bj",
    "tKLTRU7uRCTqMPkv1M07b8CftZVbw3sF7g/k8X253FCwkNR2U5OQtQf5zj15eYD559KojQHEaZofWD92VCll9L4dZWlnnAI5hgg42837q/SZ2zWS5aX/ADQq",
    "Gwu1uthIZbHKgp6jGOnbpUUPB3h0hZUbOQVeslz/ADUlSdLIh14qYyRIb2HC2hTc/Rt4EXUPHYGvO97ha7RfytdQvEZiOj3+BH+epnA4oat4gaKu6DESbeIb",
    "i5Clxg2UJxgEEKO5V0GOgJq2P9znD4nIs7n0kuf5qkNt0fpy0aefskC2NNwpAIebJKi5kYPMTudqSq8YwosHw1LsuuM/e9MU+FYl1l56i7LHLj6L81mdRq0/",
    "xQuc+dbZElv4lZSlLIcBKXeYcyVbEbYqzY/H2AsDm0PbifT8zt/5q27Xwa4eLOTZFZ9pDn+an+5rh9/8FX/9S5/mqWm6V4dOQ6aFx8UjF0drYW7MUgHn+FSf",
    "D3jTfLtIbtOmbBGiKdWAGEW9LSVrPTor2JJ7AE1tMz4vw7fjcvico5+Xpnvio1YOHuk9M3Iz7Raw1JKSkOrcU4Ug9ccxOPpUoqo4xW01VNtUsWw31KsWFUlR",
    "TRkVMm24+QCUpSolSiUpShCUpShCUpShCUpShCHJBwcH1rDT7ZepOfhNQuRh6COhVZmlbMeWG4/K1c0OFioW/pvWi9mtaKHzYCf4VipGi9du9dXrX/2riP4V",
    "ZNKbbXyt0t5D8JZ1FG7W/mfyqcl8PNZq8z7rN0TnPhu3WU2D+BrO6L0dqe0343CdPRAg8uBao8hyShR9Spwkj5CrGpXaTFp5IzE61j77vRcY8Lgjl65t796q",
    "fj7cFWrQUCelRSWpoOf+zXVRLc1uzwjYvCm5adNB/wAdCTJTgHxCQop68vNvitor7p6zaltf5uvkBuZG5gvw152I77V0r0pp9zSQ0wu2Mm1BAQIu/KBnPz60",
    "/QY1HS07IjHch1yTw5c1G4hgTquokm2yLt2RYkZ568RnooTwGmKuPC12eok+PPeXk/SsL+ULcH7TaLNcmm1FCXHW1KAzy8yR/gatiyWK06cs6LXZYTcSIglS",
    "WkdMnqa53azWu+2xdvu8JmZGX95p1OR86UixGOPEPi9m7bk25JubCzLhvwJdnsgX7lrJqDixp2VwbsFhgvum5wPCLiSny5Sgg4Pfc1dvBwur4O2p91Ckl4uP",
    "AKGDhTiiP41yb4N8NmnkuJ0rE5knIyVEfgTU2YYZjRkR47SWmm0hKEIGAkDsBXfE8RpJoBBSsI7RcSSN+7JcsOw2oiqXVNS8EloaLAjId6oP8oy7Cz3G0vkr",
    "AdiusnkPKd1p6HsfeqNh6nairb8N6ehXgqQFPy/GCSQOqebc/wCtbq6j0bprVrbKNQWpmaGc+GVkgpz13BrCRuEHDmJKRIZ0vE50EFPNlQ29iak8M6QUlLSt",
    "hljJcL6WUVinRqesqXzMkADrcd3osro7xJHCyzJQpxha7e0ApQypJ5Bvv3qA3Hh/rBU91x5Ue+KWrKJT9wkRlIH9RB5R9KuBCEttpQhISlIwANgBX2q5BiEk",
    "D3Pj3+9cirLUUEdQxrJdyqWJoLXbaQReUxfRKbhIcA/tGsxG0lrtrHNq/H1Wv+NWFStn4nM/W3l+UMw+Jul/MqLRLFqtrHxGrlLHoIyT/Gs9EjTGBiTcFSfm",
    "2lP8K9dKUkmc/W3kAmWRBml/MlKUpXJdEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpS",
    "lCEpSlCEpSlYQlKUrKEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCEpSlCF/9k="
})

local function k7B64Decode(data)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = tostring(data or ""):gsub("[^"..b.."=]", "")
    return (data:gsub(".", function(x)
        if x == "=" then return "" end
        local r, f = "", (b:find(x) - 1)
        for i = 6, 1, -1 do r = r .. (f % 2^i - f % 2^(i-1) > 0 and "1" or "0") end
        return r
    end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
        if #x ~= 8 then return "" end
        local c = 0
        for i = 1, 8 do c = c + (x:sub(i, i) == "1" and 2^(8 - i) or 0) end
        return string.char(c)
    end))
end

local _k7MiniLogoAsset = nil
local function k7GetMiniLogoAsset()
    if _k7MiniLogoAsset then return _k7MiniLogoAsset end
    local path = "k7_visible_mini_logo.jpg"
    pcall(function()
        if writefile then writefile(path, k7B64Decode(_K7_MINI_LOGO_B64)) end
    end)
    local asset = k7GetCustomAsset(path)
    if asset and asset ~= "" then
        _k7MiniLogoAsset = asset
        return asset
    end
    return "rbxassetid://135382218880707"
end

local function k7ApplyMiniLogo(img)
    if not img then return end
    pcall(function()
        img.Image = k7GetMiniLogoAsset()
        img.ImageTransparency = 0
        img.ScaleType = Enum.ScaleType.Crop
        img.Visible = true
    end)
end


local function destroyOldGui(name)
    if not name then return end
    pcall(function()
        if _gethui then
            local h = _gethui(); local o = h and h:FindFirstChild(name); if o then o:Destroy() end
        end
    end)
    pcall(function()
        local cg = game:GetService("CoreGui"); local o = cg:FindFirstChild(name); if o then o:Destroy() end
    end)
    pcall(function()
        local plr = Players.LocalPlayer
        if plr then
            local pg = plr:FindFirstChild("PlayerGui")
            if pg then local o = pg:FindFirstChild(name); if o then o:Destroy() end end
        end
    end)
end

-- ============================================================
-- SKY THEME SYSTEM
-- ============================================================
local K7_SKY_TAG = "K7SkyTheme"
local currentSkyTheme = "Night"
local K7_SKY_PRESETS = {
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
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
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
    ["Clear Sky"]={clock=13.5,brightness=3,ambient={180,200,220},outAmb={190,210,230},sky={sun=12,stars=0,moon=0},atm={dens=0.28,color={140,200,255},decay={90,160,230},glare=1.4,haze=1.4},clouds={cover=0.25,dens=0.35,color={255,255,255}}},
}
local SkyOrder={"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky","Clear Sky"}
local function k7SkyColor(rgb) return Color3.fromRGB(rgb[1],rgb[2],rgb[3]) end
local function K7ApplyCustomSky(mode)
    for _,child in ipairs(Lighting:GetChildren()) do if child:GetAttribute(K7_SKY_TAG) then pcall(function() child:Destroy() end) end end
    local terrain=workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(K7_SKY_TAG) then pcall(function() child:Destroy() end) end end end
    local preset=K7_SKY_PRESETS[mode]
    if not preset or preset.kind=="off" then Lighting.ClockTime=14;Lighting.Brightness=2;Lighting.OutdoorAmbient=Color3.fromRGB(127,127,127);Lighting.Ambient=Color3.fromRGB(127,127,127);Lighting.FogEnd=100000;Lighting.GlobalShadows=true;return end
    Lighting.FogStart=0;Lighting.FogEnd=100000;Lighting.FogColor=Color3.fromRGB(200,200,200);Lighting.ColorShift_Top=Color3.fromRGB(0,0,0);Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0);Lighting.GlobalShadows=true
    Lighting.ClockTime=preset.clock or 14;Lighting.Brightness=preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient=k7SkyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient=k7SkyColor(preset.ambient) end
    if preset.sky then
        local skyInst=Instance.new("Sky");skyInst:SetAttribute(K7_SKY_TAG,true)
        if preset.sky.stars then skyInst.StarCount=preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize=preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize=preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId="rbxasset://sky/moon.jpg" end
        skyInst.Parent=Lighting
    end
    if preset.atm then
        local atm=Instance.new("Atmosphere");atm:SetAttribute(K7_SKY_TAG,true)
        atm.Density=preset.atm.dens or 0.3;atm.Color=k7SkyColor(preset.atm.color);atm.Decay=k7SkyColor(preset.atm.decay);atm.Glare=preset.atm.glare or 1;atm.Haze=preset.atm.haze or 1;atm.Parent=Lighting
    end
    if preset.clouds and terrain then
        local clouds=Instance.new("Clouds");clouds:SetAttribute(K7_SKY_TAG,true)
        clouds.Cover=preset.clouds.cover or 0.5;clouds.Density=preset.clouds.dens or 0.5;clouds.Color=k7SkyColor(preset.clouds.color);clouds.Parent=terrain
    end
end

-- ============================================================
-- GUI THEME SYSTEM – FORCED COLD WHITE + ELECTRIC BLUE
-- ============================================================
currentGuiTheme = "Azure"

GUI_THEME_ORDER = {"Obsidian","Snow","Azure","Jade","Crimson","Violet","Amber","Slate","Blood & Ash","Cure Purple"}

GUI_THEMES = {
    ["Obsidian"] = {
        BG=Color3.fromRGB(8,8,10), BG2=Color3.fromRGB(14,14,16), ROW_BG=Color3.fromRGB(16,16,18),
        ROW_BORDER=Color3.fromRGB(32,32,36), WHITE=Color3.fromRGB(235,235,240), GRAY=Color3.fromRGB(120,120,130),
        INP=Color3.fromRGB(20,20,22), ACCENT=Color3.fromRGB(255,255,255), ACCENT2=Color3.fromRGB(200,200,210),
        ACCENT3=Color3.fromRGB(36,36,40), OFF=Color3.fromRGB(24,24,28), SECT=Color3.fromRGB(100,100,110),
        MOB_ON=Color3.fromRGB(255,255,255), MOB_OFF=Color3.fromRGB(16,16,18), MOB_BORDER_OFF=Color3.fromRGB(40,40,44),
        MOB_TEXT_OFF=Color3.fromRGB(160,160,170), MOB_TEXT_ON=Color3.fromRGB(10,10,12),
        STEAL_BG=Color3.fromRGB(10,10,12), STEAL_FILL=Color3.fromRGB(235,235,240), STEAL_ACCENT=Color3.fromRGB(255,255,255),
        PARTICLE=Color3.fromRGB(200,200,210),
    },
    ["Snow"] = {
        BG=Color3.fromRGB(18,18,20), BG2=Color3.fromRGB(24,24,28), ROW_BG=Color3.fromRGB(28,28,32),
        ROW_BORDER=Color3.fromRGB(48,48,54), WHITE=Color3.fromRGB(245,245,250), GRAY=Color3.fromRGB(140,140,150),
        INP=Color3.fromRGB(20,20,24), ACCENT=Color3.fromRGB(230,230,240), ACCENT2=Color3.fromRGB(190,190,200),
        ACCENT3=Color3.fromRGB(44,44,50), OFF=Color3.fromRGB(34,34,38), SECT=Color3.fromRGB(130,130,140),
        MOB_ON=Color3.fromRGB(230,230,240), MOB_OFF=Color3.fromRGB(28,28,32), MOB_BORDER_OFF=Color3.fromRGB(50,50,56),
        MOB_TEXT_OFF=Color3.fromRGB(170,170,180), MOB_TEXT_ON=Color3.fromRGB(16,16,18),
        STEAL_BG=Color3.fromRGB(20,20,22), STEAL_FILL=Color3.fromRGB(220,220,230), STEAL_ACCENT=Color3.fromRGB(230,230,240),
        PARTICLE=Color3.fromRGB(210,210,220),
    },
    -- Cold White + Electric Blue (default)
    ["Azure"] = {
        BG=Color3.fromRGB(6,9,15), BG2=Color3.fromRGB(12,17,28), ROW_BG=Color3.fromRGB(16,22,36),
        ROW_BORDER=Color3.fromRGB(32,60,110), WHITE=Color3.fromRGB(228,240,255), GRAY=Color3.fromRGB(120,155,205),
        INP=Color3.fromRGB(10,15,26), ACCENT=Color3.fromRGB(0,190,255), ACCENT2=Color3.fromRGB(0,140,225),
        ACCENT3=Color3.fromRGB(20,42,76), OFF=Color3.fromRGB(14,20,34), SECT=Color3.fromRGB(0,190,255),
        MOB_ON=Color3.fromRGB(0,190,255), MOB_OFF=Color3.fromRGB(14,20,34), MOB_BORDER_OFF=Color3.fromRGB(32,60,110),
        MOB_TEXT_OFF=Color3.fromRGB(180,205,235), MOB_TEXT_ON=Color3.fromRGB(4,10,20),
        STEAL_BG=Color3.fromRGB(10,15,26), STEAL_FILL=Color3.fromRGB(0,190,255), STEAL_ACCENT=Color3.fromRGB(0,190,255),
        PARTICLE=Color3.fromRGB(0,190,255),
    },
    ["Jade"] = {
        BG=Color3.fromRGB(8,12,10), BG2=Color3.fromRGB(12,18,14), ROW_BG=Color3.fromRGB(14,22,18),
        ROW_BORDER=Color3.fromRGB(28,48,36), WHITE=Color3.fromRGB(220,240,230), GRAY=Color3.fromRGB(110,145,125),
        INP=Color3.fromRGB(10,16,12), ACCENT=Color3.fromRGB(80,190,140), ACCENT2=Color3.fromRGB(60,150,110),
        ACCENT3=Color3.fromRGB(24,48,34), OFF=Color3.fromRGB(18,28,22), SECT=Color3.fromRGB(100,160,130),
        MOB_ON=Color3.fromRGB(80,190,140), MOB_OFF=Color3.fromRGB(14,22,18), MOB_BORDER_OFF=Color3.fromRGB(32,52,40),
        MOB_TEXT_OFF=Color3.fromRGB(140,180,155), MOB_TEXT_ON=Color3.fromRGB(6,18,12),
        STEAL_BG=Color3.fromRGB(10,16,12), STEAL_FILL=Color3.fromRGB(70,180,130), STEAL_ACCENT=Color3.fromRGB(80,190,140),
        PARTICLE=Color3.fromRGB(90,180,140),
    },
    ["Crimson"] = {
        BG=Color3.fromRGB(12,8,8), BG2=Color3.fromRGB(18,12,12), ROW_BG=Color3.fromRGB(22,14,14),
        ROW_BORDER=Color3.fromRGB(48,28,28), WHITE=Color3.fromRGB(245,230,230), GRAY=Color3.fromRGB(150,120,120),
        INP=Color3.fromRGB(16,10,10), ACCENT=Color3.fromRGB(220,70,70), ACCENT2=Color3.fromRGB(180,55,55),
        ACCENT3=Color3.fromRGB(48,24,24), OFF=Color3.fromRGB(28,18,18), SECT=Color3.fromRGB(170,110,110),
        MOB_ON=Color3.fromRGB(220,70,70), MOB_OFF=Color3.fromRGB(22,14,14), MOB_BORDER_OFF=Color3.fromRGB(52,30,30),
        MOB_TEXT_OFF=Color3.fromRGB(185,140,140), MOB_TEXT_ON=Color3.fromRGB(20,6,6),
        STEAL_BG=Color3.fromRGB(14,10,10), STEAL_FILL=Color3.fromRGB(200,60,60), STEAL_ACCENT=Color3.fromRGB(220,70,70),
        PARTICLE=Color3.fromRGB(210,80,80),
    },
    ["Violet"] = {
        BG=Color3.fromRGB(10,8,14), BG2=Color3.fromRGB(16,12,22), ROW_BG=Color3.fromRGB(20,16,28),
        ROW_BORDER=Color3.fromRGB(42,34,58), WHITE=Color3.fromRGB(235,230,245), GRAY=Color3.fromRGB(135,125,160),
        INP=Color3.fromRGB(14,10,18), ACCENT=Color3.fromRGB(150,110,220), ACCENT2=Color3.fromRGB(120,85,180),
        ACCENT3=Color3.fromRGB(36,28,52), OFF=Color3.fromRGB(24,20,34), SECT=Color3.fromRGB(140,120,180),
        MOB_ON=Color3.fromRGB(150,110,220), MOB_OFF=Color3.fromRGB(20,16,28), MOB_BORDER_OFF=Color3.fromRGB(46,36,62),
        MOB_TEXT_OFF=Color3.fromRGB(165,150,190), MOB_TEXT_ON=Color3.fromRGB(14,8,22),
        STEAL_BG=Color3.fromRGB(12,10,16), STEAL_FILL=Color3.fromRGB(140,100,210), STEAL_ACCENT=Color3.fromRGB(150,110,220),
        PARTICLE=Color3.fromRGB(150,115,210),
    },
    ["Amber"] = {
        BG=Color3.fromRGB(12,10,8), BG2=Color3.fromRGB(18,16,12), ROW_BG=Color3.fromRGB(24,20,14),
        ROW_BORDER=Color3.fromRGB(52,44,28), WHITE=Color3.fromRGB(245,240,225), GRAY=Color3.fromRGB(155,140,110),
        INP=Color3.fromRGB(16,14,10), ACCENT=Color3.fromRGB(230,180,70), ACCENT2=Color3.fromRGB(190,145,50),
        ACCENT3=Color3.fromRGB(48,40,22), OFF=Color3.fromRGB(28,24,16), SECT=Color3.fromRGB(170,150,100),
        MOB_ON=Color3.fromRGB(230,180,70), MOB_OFF=Color3.fromRGB(24,20,14), MOB_BORDER_OFF=Color3.fromRGB(54,46,30),
        MOB_TEXT_OFF=Color3.fromRGB(185,170,130), MOB_TEXT_ON=Color3.fromRGB(18,14,4),
        STEAL_BG=Color3.fromRGB(14,12,8), STEAL_FILL=Color3.fromRGB(210,165,60), STEAL_ACCENT=Color3.fromRGB(230,180,70),
        PARTICLE=Color3.fromRGB(220,175,80),
    },
    ["Slate"] = {
        BG=Color3.fromRGB(10,11,13), BG2=Color3.fromRGB(16,17,20), ROW_BG=Color3.fromRGB(20,22,26),
        ROW_BORDER=Color3.fromRGB(38,42,48), WHITE=Color3.fromRGB(225,230,235), GRAY=Color3.fromRGB(125,135,145),
        INP=Color3.fromRGB(14,15,18), ACCENT=Color3.fromRGB(140,155,175), ACCENT2=Color3.fromRGB(110,125,145),
        ACCENT3=Color3.fromRGB(32,36,42), OFF=Color3.fromRGB(24,26,30), SECT=Color3.fromRGB(130,140,155),
        MOB_ON=Color3.fromRGB(140,155,175), MOB_OFF=Color3.fromRGB(20,22,26), MOB_BORDER_OFF=Color3.fromRGB(42,46,54),
        MOB_TEXT_OFF=Color3.fromRGB(155,165,180), MOB_TEXT_ON=Color3.fromRGB(10,12,14),
        STEAL_BG=Color3.fromRGB(12,13,15), STEAL_FILL=Color3.fromRGB(130,145,165), STEAL_ACCENT=Color3.fromRGB(140,155,175),
        PARTICLE=Color3.fromRGB(145,160,180),
    },
    ["Blood & Ash"] = {
        BG=Color3.fromRGB(13,13,13),
        BG2=Color3.fromRGB(26,26,26),
        ROW_BG=Color3.fromRGB(26,26,26),
        ROW_BORDER=Color3.fromRGB(139,0,0),
        WHITE=Color3.fromRGB(240,240,240),
        GRAY=Color3.fromRGB(255,153,153),
        INP=Color3.fromRGB(13,13,13),
        ACCENT=Color3.fromRGB(227,27,35),
        ACCENT2=Color3.fromRGB(139,0,0),
        ACCENT3=Color3.fromRGB(40,10,10),
        OFF=Color3.fromRGB(26,26,26),
        SECT=Color3.fromRGB(255,153,153),
        MOB_ON=Color3.fromRGB(227,27,35),
        MOB_OFF=Color3.fromRGB(26,26,26),
        MOB_BORDER_OFF=Color3.fromRGB(139,0,0),
        MOB_TEXT_OFF=Color3.fromRGB(255,153,153),
        MOB_TEXT_ON=Color3.fromRGB(240,240,240),
        STEAL_BG=Color3.fromRGB(13,13,13),
        STEAL_FILL=Color3.fromRGB(227,27,35),
        STEAL_ACCENT=Color3.fromRGB(227,27,35),
        PARTICLE=Color3.fromRGB(227,27,35),
    },
    ["Cure Purple"] = {
        BG=Color3.fromRGB(8,8,10),
        BG2=Color3.fromRGB(14,14,16),
        ROW_BG=Color3.fromRGB(18,18,20),
        ROW_BORDER=Color3.fromRGB(40,40,44),
        WHITE=Color3.fromRGB(235,235,240),
        GRAY=Color3.fromRGB(130,130,138),
        INP=Color3.fromRGB(16,16,18),
        ACCENT=Color3.fromRGB(200,200,210),
        ACCENT2=Color3.fromRGB(160,160,170),
        ACCENT3=Color3.fromRGB(36,36,40),
        OFF=Color3.fromRGB(28,28,32),
        SECT=Color3.fromRGB(120,120,128),
        MOB_ON=Color3.fromRGB(220,220,230),
        MOB_OFF=Color3.fromRGB(18,18,20),
        MOB_BORDER_OFF=Color3.fromRGB(40,40,44),
        MOB_TEXT_OFF=Color3.fromRGB(150,150,158),
        MOB_TEXT_ON=Color3.fromRGB(10,10,12),
        STEAL_BG=Color3.fromRGB(10,10,12),
        STEAL_FILL=Color3.fromRGB(200,200,210),
        STEAL_ACCENT=Color3.fromRGB(220,220,230),
        PARTICLE=Color3.fromRGB(180,180,190),
    },
}
function getTheme()
    return GUI_THEMES["Azure"]
end

-- ============================================================
-- STATE
-- ============================================================
TS=TweenService
LP=Players.LocalPlayer

-- ============================================================
-- INFINITE JUMP MODULE
-- ============================================================
local InfJump = {
    enabled = false,
    mode = "manual",
    holdConn = nil,
    boostPower = 50,
    holdBoost = 55,
    holdThreshold = 35,
    fallClamp = -120,
}

local function manualJumpBoost(boost)
    if not InfJump.enabled or InfJump.mode ~= "manual" then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        root.Velocity = Vector3.new(root.Velocity.X, boost, root.Velocity.Z)
    end
end

local function startHoldMode()
    if InfJump.holdConn then InfJump.holdConn:Disconnect() end
    InfJump.holdConn = RunService.Heartbeat:Connect(function()
        if not InfJump.enabled or InfJump.mode ~= "hold" then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
        if isJumpHeld and root.Velocity.Y < InfJump.holdThreshold then
            root.Velocity = Vector3.new(root.Velocity.X, InfJump.holdBoost, root.Velocity.Z)
        end
        if root.Velocity.Y < InfJump.fallClamp then
            root.Velocity = Vector3.new(root.Velocity.X, InfJump.fallClamp, root.Velocity.Z)
        end
    end)
end

local function stopHoldMode()
    if InfJump.holdConn then
        InfJump.holdConn:Disconnect()
        InfJump.holdConn = nil
    end
end

function InfJump:setMode(mode)
    if mode ~= "manual" and mode ~= "hold" then return end
    self.mode = mode
    if self.enabled and mode == "hold" then
        startHoldMode()
    else
        stopHoldMode()
    end
end

function InfJump:toggle(on)
    self.enabled = on
    if on then
        if self.mode == "hold" then startHoldMode() end
    else
        stopHoldMode()
    end
end

UIS.JumpRequest:Connect(function()
    manualJumpBoost(InfJump.boostPower)
end)

UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space and not UIS:GetFocusedTextBox() then
        task.delay(0.12, function()
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                manualJumpBoost(InfJump.boostPower)
            end
        end)
    end
end)

RunService.Heartbeat:Connect(function()
    if UIS:IsKeyDown(Enum.KeyCode.Space) then
        manualJumpBoost(InfJump.boostPower)
    end
end)

-- ===== ANIMATION PACKS + CHARTER =====
-- Ambitious-style: load Animation tracks on Animator + drive via Humanoid events
-- (does NOT rely on patching Animate script asset IDs)

local ANIM_PACKS = {
    [1] = nil, -- NONE
    [2] = { -- Adidas Sports
        idle = "rbxassetid://18537376492",
        walk = "rbxassetid://18537392113",
        run  = "rbxassetid://18537384940",
        jump = "rbxassetid://18537380791",
        fall = "rbxassetid://18537367238",
        climb = "rbxassetid://18537363391",
    },
    [3] = { -- Adidas Community
        idle = "rbxassetid://122257458498464",
        walk = "rbxassetid://122150855457006",
        run  = "rbxassetid://82598234841035",
        jump = "rbxassetid://75290611992385",
        fall = "rbxassetid://98600215928904",
        climb = "rbxassetid://88763136693023",
    },
    [4] = { -- Adidas Aura
        idle = "rbxassetid://110211186840347",
        walk = "rbxassetid://83842218823011",
        run  = "rbxassetid://118320322718866",
        jump = "rbxassetid://109996626521204",
        fall = "rbxassetid://95603166884636",
        climb = "rbxassetid://97824616490448",
    },
    [5] = { -- Wicked Popular
        idle = "rbxassetid://118832222982049",
        walk = "rbxassetid://92072849924640",
        run  = "rbxassetid://72301599441680",
        jump = "rbxassetid://104325245285198",
        fall = "rbxassetid://121152442762481",
        climb = "rbxassetid://131326830509784",
    },
    [6] = { -- Elder
        idle = "rbxassetid://10921101664",
        walk = "rbxassetid://10921111375",
        run  = "rbxassetid://10921104374",
        jump = "rbxassetid://10921107367",
        fall = "rbxassetid://10921105765",
        climb = "rbxassetid://10921100400",
    },
    [7] = { -- Zombie
        idle = "rbxassetid://10921344533",
        walk = "rbxassetid://10921355261",
        run  = "rbxassetid://616163682",
        jump = "rbxassetid://10921351278",
        fall = "rbxassetid://10921350320",
        climb = "rbxassetid://10921343576",
    },
    [8] = { -- Mage
        idle = "rbxassetid://10921144709",
        walk = "rbxassetid://10921152678",
        run  = "rbxassetid://10921148209",
        jump = "rbxassetid://10921149743",
        fall = "rbxassetid://10921148939",
        climb = "rbxassetid://10921143404",
    },
    [9] = { -- Catwalk Glam
        idle = "rbxassetid://133806214992291",
        walk = "rbxassetid://109168724482748",
        run  = "rbxassetid://81024476153754",
        jump = "rbxassetid://116936326516985",
        fall = "rbxassetid://92294537340807",
        climb = "rbxassetid://119377220967554",
    },
    [10] = { -- Astronaut
        idle = "rbxassetid://10921034824",
        walk = "rbxassetid://10921046031",
        run  = "rbxassetid://10921039308",
        jump = "rbxassetid://10921042494",
        fall = "rbxassetid://10921040576",
        climb = "rbxassetid://10921032124",
    },
    [11] = { -- Toy
        idle = "rbxassetid://10921301576",
        walk = "rbxassetid://10921312010",
        run  = "rbxassetid://10921306285",
        jump = "rbxassetid://10921308158",
        fall = "rbxassetid://10921307241",
        climb = "rbxassetid://10921300839",
    },
    [12] = { -- No Boundaries
        idle = "rbxassetid://18747067405",
        walk = "rbxassetid://18747074203",
        run  = "rbxassetid://18747070484",
        jump = "rbxassetid://18747069148",
        fall = "rbxassetid://18747062535",
        climb = "rbxassetid://18747060903",
    },
    [13] = { -- NFL
        idle = "rbxassetid://92080889861410",
        walk = "rbxassetid://110358958299415",
        run  = "rbxassetid://117333533048078",
        jump = "rbxassetid://119846112151352",
        fall = "rbxassetid://129773241321032",
        climb = "rbxassetid://134630013742019",
    },
    [14] = { -- Amazon Unboxed
        idle = "rbxassetid://98281136301627",
        walk = "rbxassetid://90478085024465",
        run  = "rbxassetid://134824450619865",
        jump = "rbxassetid://121454505477205",
        fall = "rbxassetid://94788218468396",
        climb = "rbxassetid://121145883950231",
    },
    [15] = { -- Vampire
        idle = "rbxassetid://10921315373",
        walk = "rbxassetid://10921326949",
        run  = "rbxassetid://10921320299",
        jump = "rbxassetid://10921322186",
        fall = "rbxassetid://10921321317",
        climb = "rbxassetid://10921314188",
    },
    [16] = { -- Ninja
        idle = "rbxassetid://656117400",
        walk = "rbxassetid://656121766",
        run  = "rbxassetid://656118852",
        jump = "rbxassetid://656117878",
        fall = "rbxassetid://656115606",
        climb = "rbxassetid://656114359",
    },
    [17] = { -- Robot
        idle = "rbxassetid://616088211",
        walk = "rbxassetid://616095330",
        run  = "rbxassetid://616091570",
        jump = "rbxassetid://616090535",
        fall = "rbxassetid://616087089",
        climb = "rbxassetid://616086039",
    },
    [18] = { -- Levitation
        idle = "rbxassetid://616006778",
        walk = "rbxassetid://616013216",
        run  = "rbxassetid://616010382",
        jump = "rbxassetid://616008936",
        fall = "rbxassetid://616005863",
        climb = "rbxassetid://616003713",
    },
    [19] = { -- Stylish
        idle = "rbxassetid://616136790",
        walk = "rbxassetid://616146177",
        run  = "rbxassetid://616140816",
        jump = "rbxassetid://616139451",
        fall = "rbxassetid://616134815",
        climb = "rbxassetid://616133594",
    },
    [20] = { -- Bubbly
        idle = "rbxassetid://910004836",
        walk = "rbxassetid://910034870",
        run  = "rbxassetid://910025107",
        jump = "rbxassetid://910016857",
        fall = "rbxassetid://910001910",
        climb = "rbxassetid://909997997",
    },
    [21] = { -- Cartoon
        idle = "rbxassetid://742637544",
        walk = "rbxassetid://742640026",
        run  = "rbxassetid://742638842",
        jump = "rbxassetid://742637942",
        fall = "rbxassetid://742637151",
        climb = "rbxassetid://742636889",
    },
}

-- Name aliases for UI (Batman Hub animation presets)
local PACK_INDEX_BY_NAME = {
    ["NONE"] = 1,
    ["Adidas Sports"] = 2,
    ["Adidas Community"] = 3,
    ["Adidas Aura"] = 4,
    ["Wicked Popular"] = 5,
    ["Elder"] = 6,
    ["Zombie"] = 7,
    ["Mage"] = 8,
    ["Catwalk Glam"] = 9,
    ["Astronaut"] = 10,
    ["Toy"] = 11,
    ["No Boundaries"] = 12,
    ["NFL"] = 13,
    ["Amazon Unboxed"] = 14,
    ["Vampire"] = 15,
    ["Ninja"] = 16,
    ["Robot"] = 17,
    ["Levitation"] = 18,
    ["Stylish"] = 19,
    ["Bubbly"] = 20,
    ["Cartoon"] = 21,
    ["CUSTOM"] = 22,
}
local PACK_NAME_BY_INDEX = {
    [1] = "NONE",
    [2] = "Adidas Sports",
    [3] = "Adidas Community",
    [4] = "Adidas Aura",
    [5] = "Wicked Popular",
    [6] = "Elder",
    [7] = "Zombie",
    [8] = "Mage",
    [9] = "Catwalk Glam",
    [10] = "Astronaut",
    [11] = "Toy",
    [12] = "No Boundaries",
    [13] = "NFL",
    [14] = "Amazon Unboxed",
    [15] = "Vampire",
    [16] = "Ninja",
    [17] = "Robot",
    [18] = "Levitation",
    [19] = "Stylish",
    [20] = "Bubbly",
    [21] = "Cartoon",
    [22] = "CUSTOM",
}
local CUSTOM_ANIM_PACK_INDEX = 22

-- Compatibility table for any code still iterating PACKS
PACKS = {
    ["Adidas Sports"] = ANIM_PACKS[2],
    ["Adidas Community"] = ANIM_PACKS[3],
    ["Adidas Aura"] = ANIM_PACKS[4],
    ["Wicked Popular"] = ANIM_PACKS[5],
    ["Elder"] = ANIM_PACKS[6],
    ["Zombie"] = ANIM_PACKS[7],
    ["Mage"] = ANIM_PACKS[8],
    ["Catwalk Glam"] = ANIM_PACKS[9],
    ["Astronaut"] = ANIM_PACKS[10],
    ["Toy"] = ANIM_PACKS[11],
    ["No Boundaries"] = ANIM_PACKS[12],
    ["NFL"] = ANIM_PACKS[13],
    ["Amazon Unboxed"] = ANIM_PACKS[14],
    ["Vampire"] = ANIM_PACKS[15],
    ["Ninja"] = ANIM_PACKS[16],
    ["Robot"] = ANIM_PACKS[17],
    ["Levitation"] = ANIM_PACKS[18],
    ["Stylish"] = ANIM_PACKS[19],
    ["Bubbly"] = ANIM_PACKS[20],
    ["Cartoon"] = ANIM_PACKS[21],
}

_G.AmbitiousCustomAnimIds = _G.AmbitiousCustomAnimIds or {
    idle = "", walk = "", run = "", jump = "", fall = "", climb = "",
}
_G.AmbitiousCustomAnimSlots = { "idle", "walk", "run", "jump", "fall", "climb" }
_G._AmbitiousAnimPackConns = _G._AmbitiousAnimPackConns or {}

local selectedAnimPackIndex = 9
local _animPackSystemEnabled = false
local _animPackTracks = {}
local _animPackCurrentAnim = "idle"
local animPack = "Catwalk Glam"
local animPackEnabled = false
local applyingAnim = false

local function _animLoadTrack(animator, id)
    local animation = Instance.new("Animation")
    local success, result = pcall(function()
        if type(game.GetObjects) == "function" then
            local objects = game:GetObjects(id)
            for _, obj in pairs(objects) do
                if obj:IsA("Animation") then return obj.AnimationId end
                local deep = obj:FindFirstChildWhichIsA("Animation", true)
                if deep then return deep.AnimationId end
            end
        end
    end)
    animation.AnimationId = (success and result) and result or id
    return animator:LoadAnimation(animation)
end

local function _animStopAll()
    for _, track in pairs(_animPackTracks) do
        pcall(function() track:Stop(0) end)
    end
    _animPackTracks = {}
    for _, c in ipairs(_G._AmbitiousAnimPackConns) do
        pcall(function() c:Disconnect() end)
    end
    _G._AmbitiousAnimPackConns = {}
end

local function _animCustomPack()
    local t, any = {}, false
    for _, slot in ipairs(_G.AmbitiousCustomAnimSlots) do
        local id = _G.AmbitiousCustomAnimIds[slot]
        if id and tostring(id) ~= "" then
            local num = tostring(id):gsub("%D", "")
            if num ~= "" then
                t[slot] = "rbxassetid://" .. num
                any = true
            end
        end
    end
    if not any then return nil end
    return t
end

local function _animRestoreDefault()
    _animStopAll()
    local char = LP.Character
    if char then
        local Animate = char:FindFirstChild("Animate")
        if Animate then Animate.Disabled = false end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local animator = humanoid:FindFirstChildOfClass("Animator")
            if animator then
                for _, t in pairs(animator:GetPlayingAnimationTracks()) do
                    pcall(function() t:Stop(0) end)
                end
            end
        end
    end
end

local function _animStartSystem(char)
    _animStopAll()
    if not _animPackSystemEnabled then return end
    if not char then return end

    local pack
    if selectedAnimPackIndex == CUSTOM_ANIM_PACK_INDEX then
        pack = _animCustomPack()
        if not pack then return end
    else
        pack = ANIM_PACKS[selectedAnimPackIndex]
    end
    if not pack then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = humanoid:WaitForChild("Animator", 5)
    end
    if not animator then
        local ok, a = pcall(function()
            local an = Instance.new("Animator")
            an.Parent = humanoid
            return an
        end)
        animator = ok and a or nil
    end
    if not animator then return end

    local Animate = char:FindFirstChild("Animate")

    local partial = false
    if selectedAnimPackIndex == CUSTOM_ANIM_PACK_INDEX then
        for _, sl in ipairs({"idle", "walk", "run", "jump", "fall"}) do
            if not pack[sl] then partial = true break end
        end
    end

    if not partial then
        if Animate then Animate.Disabled = true end
    elseif Animate then
        Animate.Disabled = false
    end
    task.wait(0.1)
    if not partial then
        for _, t in pairs(animator:GetPlayingAnimationTracks()) do
            pcall(function() t:Stop(0) end)
        end
    end

    for name, id in pairs(pack) do
        if type(id) == "string" and (name == "idle" or name == "walk" or name == "run" or name == "jump" or name == "fall" or name == "climb") then
            local ok, track = pcall(function() return _animLoadTrack(animator, id) end)
            if ok and track then
                track.Looped = (name == "idle" or name == "walk" or name == "run" or name == "fall")
                if partial then
                    track.Priority = Enum.AnimationPriority.Action
                elseif name == "idle" then
                    track.Priority = Enum.AnimationPriority.Idle
                elseif name == "walk" or name == "run" then
                    track.Priority = Enum.AnimationPriority.Movement
                else
                    track.Priority = Enum.AnimationPriority.Action
                end
                _animPackTracks[name] = track
            end
        end
    end

    local function playAnim(name, forceRestart)
        if not _animPackSystemEnabled then return end
        if not _animPackTracks[name] then
            local cur = _animPackTracks[_animPackCurrentAnim]
            if cur then pcall(function() cur:Stop(0.15) end) end
            _animPackCurrentAnim = name
            return
        end
        if _animPackCurrentAnim == name and not forceRestart then return end
        if _animPackTracks[_animPackCurrentAnim] and _animPackCurrentAnim ~= name then
            pcall(function() _animPackTracks[_animPackCurrentAnim]:Stop(0.15) end)
        end
        _animPackCurrentAnim = name
        if forceRestart then pcall(function() _animPackTracks[name]:Stop() end) end
        pcall(function() _animPackTracks[name]:Play(0.15) end)
    end

    local _conns = _G._AmbitiousAnimPackConns
    table.insert(_conns, humanoid.Running:Connect(function(speed)
        if not _animPackSystemEnabled then return end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then return end
        if speed > 14 then playAnim("run")
        elseif speed > 0.5 then playAnim("walk")
        else playAnim("idle") end
    end))
    table.insert(_conns, humanoid.Jumping:Connect(function(active)
        if not _animPackSystemEnabled or not active then return end
        playAnim("jump", true)
    end))
    table.insert(_conns, humanoid.FreeFalling:Connect(function(active)
        if not _animPackSystemEnabled or not active then return end
        playAnim("fall")
    end))
    table.insert(_conns, humanoid.StateChanged:Connect(function(_, newState)
        if not _animPackSystemEnabled then return end
        if newState == Enum.HumanoidStateType.Landed then
            if humanoid.MoveDirection.Magnitude > 0 then
                if humanoid.WalkSpeed > 14 then playAnim("run") else playAnim("walk") end
            else
                playAnim("idle")
            end
        end
    end))

    local currentState = humanoid:GetState()
    if currentState == Enum.HumanoidStateType.Jumping then
        _animPackCurrentAnim = "jump"
        if _animPackTracks.jump then pcall(function() _animPackTracks.jump:Play(0.15) end) end
    elseif currentState == Enum.HumanoidStateType.Freefall then
        _animPackCurrentAnim = "fall"
        if _animPackTracks.fall then pcall(function() _animPackTracks.fall:Play(0.15) end) end
    elseif humanoid.MoveDirection.Magnitude > 0.1 then
        if humanoid.WalkSpeed > 14 then
            _animPackCurrentAnim = "run"
            if _animPackTracks.run then pcall(function() _animPackTracks.run:Play(0.15) end) end
        else
            _animPackCurrentAnim = "walk"
            if _animPackTracks.walk then pcall(function() _animPackTracks.walk:Play(0.15) end) end
        end
    else
        _animPackCurrentAnim = "idle"
        if _animPackTracks.idle then pcall(function() _animPackTracks.idle:Play(0.15) end) end
    end
end

-- Public API matching Visible Hub call sites
function applyAnimPack(packName)
    if applyingAnim then return false end
    applyingAnim = true
    local ok, err = pcall(function()
        local index = PACK_INDEX_BY_NAME[packName]
        if not index then
            for name, idx in pairs(PACK_INDEX_BY_NAME) do
                if name:lower() == tostring(packName):lower() then index = idx break end
            end
        end
        index = index or 1
        selectedAnimPackIndex = index
        animPack = PACK_NAME_BY_INDEX[index] or packName

        if index == 1 then
            _animPackSystemEnabled = false
            animPackEnabled = false
            _animRestoreDefault()
            return
        end

        if index == CUSTOM_ANIM_PACK_INDEX then
            local custom = _animCustomPack()
            if not custom then
                _animPackSystemEnabled = true
                animPackEnabled = true
                return
            end
        end

        _animPackSystemEnabled = true
        animPackEnabled = true
        local char = LP.Character
        if char then
            _animStartSystem(char)
        end
    end)
    applyingAnim = false
    return ok
end

function stopAnimPack()
    _animPackSystemEnabled = false
    animPackEnabled = false
    selectedAnimPackIndex = 1
    animPack = "NONE"
    _animRestoreDefault()
end

-- Re-apply on respawn
LP.CharacterAdded:Connect(function(newChar)
    task.spawn(function()
        task.wait(0.3)
        pcall(function() newChar:WaitForChild("Animate", 3) end)
        pcall(function() newChar:WaitForChild("Humanoid", 5) end)
        if _animPackSystemEnabled and selectedAnimPackIndex ~= 1 then
            task.wait(0.2)
            _animStartSystem(newChar)
        end
    end)
end)

-- Start if already spawned and pack was enabled
if LP.Character and animPackEnabled and selectedAnimPackIndex ~= 1 then
    task.spawn(function()
        task.wait(0.5)
        if _animPackSystemEnabled then _animStartSystem(LP.Character) end
    end)
end

headlessEnabled = headlessEnabled or false
korbloxEnabled = korbloxEnabled or false


local HEADLESS_MESH_ID = "rbxassetid://1095708"
local KORBLOX_MESH_ID = "rbxassetid://101851696"
local KORBLOX_TEXTURE_ID = "rbxassetid://101851254"
local DARK_GREY_COLOR = Color3.fromRGB(64, 64, 64)

local function removeFace(head)
    local face = head:FindFirstChild("face")
    if face then face:Destroy() end
end

function applyHeadlessToChar(char, enabled)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    if enabled then
        head.Transparency = 1
        head.CanCollide = false
        removeFace(head)
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.MeshId == HEADLESS_MESH_ID then child:Destroy() end
        end
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = HEADLESS_MESH_ID
        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
        mesh.Name = "HeadlessMesh"
        mesh.Parent = head
        head:GetPropertyChangedSignal("Transparency"):Connect(function()
            if head.Transparency ~= 1 then head.Transparency = 1 end
        end)
        head.ChildAdded:Connect(function(child)
            if child.Name == "face" and child:IsA("Decal") then child:Destroy() end
        end)
    else
        head.Transparency = 0
        head.CanCollide = true
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" then child:Destroy() end
        end
        removeFace(head)
    end
end

function applyKorbloxToChar(char, enabled)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    if enabled then
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") then child:Destroy() end
                end
                rightLeg.Color = DARK_GREY_COLOR
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = rightLeg
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 1
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 1 end
                if rightFoot then rightFoot.Transparency = 1 end
                local oldKorblox = char:FindFirstChild("KorbloxLeg")
                if oldKorblox then oldKorblox:Destroy() end
                local korbloxLeg = Instance.new("Part")
                korbloxLeg.Name = "KorbloxLeg"
                korbloxLeg.Size = Vector3.new(1, 2, 1)
                korbloxLeg.Anchored = false
                korbloxLeg.CanCollide = false
                korbloxLeg.Color = DARK_GREY_COLOR
                korbloxLeg.Parent = char
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = KORBLOX_MESH_ID
                mesh.TextureId = KORBLOX_TEXTURE_ID
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Name = "KorbloxMesh"
                mesh.Parent = korbloxLeg
                local weld = Instance.new("Weld")
                weld.Part0 = rightUpperLeg
                weld.Part1 = korbloxLeg
                weld.C0 = CFrame.new(0, -0.8, 0)
                weld.Name = "KorbloxWeld"
                weld.Parent = korbloxLeg
            end
        end
    else
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = char:FindFirstChild("Right Leg")
            if rightLeg then
                for _, child in ipairs(rightLeg:GetChildren()) do
                    if child:IsA("SpecialMesh") and child.Name == "KorbloxMesh" then child:Destroy() end
                end
                rightLeg.Color = Color3.fromRGB(255, 255, 255)
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.Transparency = 0
                local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
                local rightFoot = char:FindFirstChild("RightFoot")
                if rightLowerLeg then rightLowerLeg.Transparency = 0 end
                if rightFoot then rightFoot.Transparency = 0 end
                local korbloxLeg = char:FindFirstChild("KorbloxLeg")
                if korbloxLeg then korbloxLeg:Destroy() end
            end
        end
    end
end

function applyCharterToChar(char)
    if not char then return end
    applyHeadlessToChar(char, headlessEnabled)
    applyKorbloxToChar(char, korbloxEnabled)
end

-- ===== END ANIMATION / CHARTER =====

NS,CS=60,30
LAGGER_SPEED=15
LAGGER_CARRY_SPEED=24.5
carrySpeedActive = false
laggerModeEnabled = false
laggerCarryActive = false
speedCycleMode = "V1"

antiRagdollEnabled=false
antiRagdollMode="V1"
tpBatVersion="V1"
aimbotMode="Default"
playerEspEnabled,playerTracersEnabled=false,false
medusaCounterEnabled,batCounterEnabled,unwalkEnabled=false,false,false
medusaDebounce,medusaLastUsed,dropActive=false,0,false
autoLeftEnabled,autoRightEnabled=false,false
autoLeftSetVisual,autoRightSetVisual=nil,nil
speedLabel=nil
autoBatEnabled=false
batAimbotEnabled=false
antiBatBypassLockEnabled=false
antiBatV2SpeenEnabled=false
antiBatV2SpeenSpeed=80
antiBatV2SpeenConn=nil
antiDesyncAimbotEnabled=false
AIMBOT_SPEED=50
LAGGER_AIMBOT_SPEED=40
AIMBOT_SPEED=AIMBOT_SPEED or 50
autoSwingEnabled=true
autoMoveSwingEnabled=false
autoMoveSwingInterval=0.3
_alSwingDebounce=false
_arSwingDebounce=false
autoBatSetVisual=nil
resetAutoBatMotion=nil
setBatCounterVisual=nil
startBatCounter,stopBatCounter=nil,nil
antiLagEnabled,removeAccessoriesEnabled,antiLagDescConn=false,false,nil
optimizerEnabled=false
optimizerMode="Ultra"
optimizerJobs,optimizerConn=nil,nil
setOptimizerVisual=nil
enableOptimizer,disableOptimizer,setOptimizerMode=nil,nil,nil
antiDieEnabled=false
setAntiDieVisual=nil
unwalkSavedAnimate,_anyKeyListening=false,false
autoTPEnabled,autoTPHeight,autoTPConn,setAutoTPVisual=false,30,nil,nil
mirrorTPDownEnabled,mirrorTPPreviousY,mirrorTPLastTeleport=false,{},0
MIRROR_TP_DROP_THRESHOLD,MIRROR_TP_DOWN_Y=3,-7.00
setMirrorTPVisual=nil
guiTransparencyEnabled,mobileButtonsEnabled,mobileButtonsLocked=false,true,false
mobileButtonsSize=80
stealBarPos = nil
stealBarScale = 1
circleButtonsEnabled=false
stealBarFrame=nil
progressFill=nil
setStealStatusText=nil
mobBtnRefs={}
mobGuiRef=nil
fovValue=70
fovOptions={70,80,100,120,140,180}
fovIndex=1
laggerModePillRef=nil
carryModePillRef=nil
autoSwitchSpeedEnabled = false
tabLayoutMode = "Top"
mobBtnTransparencyEnabled=false
perButtonDragEnabled=true
antiKickEnabled=false
safeModeEnabled=false
setSafeModeVisual=nil
antiKickSetVisual=nil
brainrotDetected=false
activeBatBillboard=nil
activeMedusaBillboard=nil
ragdollGuiEnabled=true
noCamCollisionEnabled=false
introEnabled=true
selectedIntroMusic=1
keepMusicEnabled=false
keepMusicIndex=1
keepMusicSound=nil
keepMusicLoopConn=nil
setKeepMusicVisual=nil
musicUI=nil
persistentRagdollGui=nil
uiLocked=false
uiScale=0.80
DROP_ASCEND_DURATION=0.2
DROP_ASCEND_SPEED=150

MOB_POS_FILE="k7duels_btnpos.json"
forceDefaultBtnPos=false
activeMobDrag=nil
local function loadBtnPositions()
    local data={}
    pcall(function()
        local raw=readfile(MOB_POS_FILE)
        if raw and #raw>2 then
            local decoded=HS:JSONDecode(raw)
            if type(decoded)=="table" then data=decoded end
        end
    end)
    if not data or next(data)==nil then
        pcall(function()
            local raw=readfile("k7duels.json")
            if raw then
                local cfg=HS:JSONDecode(raw)
                if type(cfg)=="table" and type(cfg.btnPositions)=="table" and next(cfg.btnPositions)~=nil then
                    data=cfg.btnPositions
                end
            end
        end)
    end
    return data or {}
end
local function saveBtnPositions()
    if not mobGuiRef then return end
    local out={}
    for _,child in ipairs(mobGuiRef:GetDescendants()) do
        if child:IsA("Frame") and child:GetAttribute("BtnKey") then
            local key=child:GetAttribute("BtnKey")
            out[key]={xs=0,xo=child.Position.X.Offset,ys=0,yo=child.Position.Y.Offset}
        end
    end
    if next(out)==nil then return end
    if writefile then
        pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode(out)) end)
    end
    if writefile and isfile and isfile("k7duels.json") then
        pcall(function()
            local cfg=HS:JSONDecode(readfile("k7duels.json"))
            if type(cfg)=="table" then
                cfg.btnPositions=out
                writefile("k7duels.json",HS:JSONEncode(cfg))
            end
        end)
    end
end
task.spawn(function()
    while true do
        task.wait(2)
        pcall(saveBtnPositions)
    end
end)

refreshSpeedModeLabel,saveConfig=nil,nil
startUnwalk,stopUnwalk,setupMedusa,stopMedusaCounter=nil,nil,nil,nil
startAntiRagdoll,stopAntiRagdoll,startAutoLeft,stopAutoLeft,startAutoRight,stopAutoRight=nil,nil,nil,nil,nil,nil
startAutoTP,stopAutoTP,enableAntiLag,disableAntiLag=nil,nil,nil,nil
enableOptimizer,disableOptimizer,setOptimizerMode=nil,nil,nil
startBatAimbot,stopBatAimbot,queueAutoBatStart,runDrop,runTPFloor=nil,nil,nil,nil,nil
startAutoSteal,stopAutoSteal,enableAntiKick,disableAntiKick,toggleCarryMode,toggleLaggerMode,toggleLaggerCarryMode=nil,nil,nil,nil,nil,nil,nil

local function addShimmerToLabel(lbl,color1,color2)
    local gr=Instance.new("UIGradient",lbl)
    gr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color1 or Color3.fromRGB(200,200,210)),ColorSequenceKeypoint.new(0.5,color2 or Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,color1 or Color3.fromRGB(200,200,210))})
    gr.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,0.3,0)})
    return gr
end

-- ============================================================
-- FOV — 7UP lock (property signal + RenderStepped fallback + reattach)
-- ============================================================
fovConn = nil
fovPropConn = nil
fovValue = tonumber(fovValue) or 70
fovOptions = fovOptions or {70,80,100,120,140,180}
fovIndex = fovIndex or 1

local function _fovTarget()
    return tonumber(fovValue) or 70
end

local function _attachFOVLock(cam)
    if not cam then return end
    if fovPropConn then pcall(function() fovPropConn:Disconnect() end); fovPropConn = nil end
    pcall(function() cam.FieldOfView = _fovTarget() end)
    fovPropConn = cam:GetPropertyChangedSignal("FieldOfView"):Connect(function()
        local target = _fovTarget()
        if cam.FieldOfView ~= target then
            pcall(function() cam.FieldOfView = target end)
        end
    end)
end

local function applyFOV()
    if fovConn then pcall(function() fovConn:Disconnect() end); fovConn = nil end
    _attachFOVLock(workspace.CurrentCamera)
    fovConn = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        if not cam then return end
        local target = _fovTarget()
        if cam.FieldOfView ~= target then
            pcall(function() cam.FieldOfView = target end)
        end
    end)
end

applyFOV()
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    task.wait()
    _attachFOVLock(workspace.CurrentCamera)
end)
LP.CharacterAdded:Connect(function()
    task.wait(0.3)
    _attachFOVLock(workspace.CurrentCamera)
end)

-- ============================================================
-- ANTI-DIE SYSTEM
-- ============================================================
local AntiDie = {
    enabled = false, _connection = nil, _healthConn = nil, _charConn = nil,
    HEAL_THRESHOLD = 100, VOID_OFFSET = 10, SAFE_Y = 50, INVINCIBILITY = 1.0, _invincibleUntil = 0,
}

local function _antiDieHeal(hum)
    if not hum or not hum.Parent then return end
    local maxH = hum.MaxHealth
    if not maxH or maxH <= 0 then maxH = 100 end
    pcall(function() hum.Health = maxH end)
    AntiDie._invincibleUntil = tick() + AntiDie.INVINCIBILITY
end

local function _antiDieOnChar(char)
    if not AntiDie.enabled or not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then hum = char:WaitForChild("Humanoid", 3) end
    if not hum then return end
    if AntiDie._healthConn then pcall(function() AntiDie._healthConn:Disconnect() end); AntiDie._healthConn = nil end
    if AntiDie.enabled then
        pcall(function()
            hum.BreakJointsOnDeath = false
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            if hum.MaxHealth < 100 then hum.MaxHealth = 100 end
        end)
        AntiDie._healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
            if not AntiDie.enabled or not hum.Parent then return end
            if hum.Health <= 0 or hum.Health < AntiDie.HEAL_THRESHOLD then
                _antiDieHeal(hum)
            end
        end)
        _antiDieHeal(hum)
    end
end

function AntiDie:_run()
    if self._connection then return end
    self._connection = RunService.Heartbeat:Connect(function()
        if not self.enabled then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if hum.Health <= 0 then
            _antiDieHeal(hum)
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        elseif hum.Health < self.HEAL_THRESHOLD then
            _antiDieHeal(hum)
        elseif tick() < self._invincibleUntil and hum.Health < (hum.MaxHealth or 100) then
            _antiDieHeal(hum)
        end
        local st = hum:GetState()
        if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
            _antiDieHeal(hum)
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            local voidY = workspace.FallenPartsDestroyHeight or -500
            if root.Position.Y < voidY + self.VOID_OFFSET then
                local spawn = workspace:FindFirstChild("SpawnLocation")
                if spawn then root.CFrame = spawn.CFrame + Vector3.new(0, 3, 0)
                else root.CFrame = CFrame.new(0, self.SAFE_Y, 0) end
                pcall(function()
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                end)
            end
        end
    end)
    if self._charConn then pcall(function() self._charConn:Disconnect() end); self._charConn = nil end
    self._charConn = player.CharacterAdded:Connect(function(char)
        if not self.enabled then return end
        task.defer(function() task.wait(0.05); _antiDieOnChar(char) end)
    end)
    task.defer(function() _antiDieOnChar(player.Character) end)
end

function AntiDie:stop()
    self.enabled = false
    if self._connection then self._connection:Disconnect(); self._connection = nil end
    if self._healthConn then pcall(function() self._healthConn:Disconnect() end); self._healthConn = nil end
    if self._charConn then pcall(function() self._charConn:Disconnect() end); self._charConn = nil end
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function()
            hum.BreakJointsOnDeath = true
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end) end
    end
end

function AntiDie:toggle(state)
    if state == true then self.enabled = true; self:_run()
    else self:stop() end
end

function AntiDie:start() self:toggle(true) end

-- ============================================================
-- ANTI BAT (Batman Hub engine as V1) + Visible Hub Aka V2
-- ============================================================
_G.AmbitiousAntiBatEnabled = _G.AmbitiousAntiBatEnabled == true
do
    antiBatMode = antiBatMode or "V1"

    -- Shared state (compatible with existing UI / config)
    local AB_MIN_POWER = 10000
    local AB_MAX_POWER = 20000
    local AB_RAGDOLL_POWER = 100
    local abCurrentPower = math.random(AB_MIN_POWER, AB_MAX_POWER)
    local abRagdollPowerUntil = 0
    local abAngle = 0
    local abPendingRestore = nil
    local AntiBatConn = nil
    local abRestoreBinding = "VisibleBatmanAntiBatRestore"

    local function antiBatIsRagdolled()
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return false end
        if humanoid.PlatformStand then return true end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then return true end
        if character:GetAttribute("Ragdolled") or character:GetAttribute("Ragdoll") then return true end
        local endT = LP:GetAttribute("RagdollEndTime") or character:GetAttribute("RagdollEndTime")
        if endT then
            local ok, now = pcall(function() return workspace:GetServerTimeNow() end)
            if ok and tonumber(endT) and tonumber(endT) - now > 0 then return true end
        end
        return false
    end

    -- Power loop (Batman): low power while ragdolled, high random otherwise
    _G.__VISIBLE_AB_GEN = (_G.__VISIBLE_AB_GEN or 0) + 1
    local abGen = _G.__VISIBLE_AB_GEN
    task.spawn(function()
        while abGen == _G.__VISIBLE_AB_GEN do
            task.wait(0.1)
            if not _G.AmbitiousAntiBatEnabled or antiBatMode ~= "V1" then
                continue
            end
            if antiBatIsRagdolled() then
                abRagdollPowerUntil = os.clock() + 1
            end
            if os.clock() < abRagdollPowerUntil then
                abCurrentPower = AB_RAGDOLL_POWER
            else
                abCurrentPower = math.random(AB_MIN_POWER, AB_MAX_POWER)
            end
        end
    end)

    local function restoreAntiBatVelocity()
        local pending = abPendingRestore
        abPendingRestore = nil
        if not pending or not pending.root or not pending.root.Parent then return end
        pcall(function()
            local current = pending.root.AssemblyLinearVelocity
            -- Only restore if our fake values are still on the root (Batman behavior)
            if current.X == pending.fake.X and current.Z == pending.fake.Z then
                pending.root.AssemblyLinearVelocity = Vector3.new(pending.real.X, current.Y, pending.real.Z)
            end
        end)
    end

    pcall(function()
        RunService:UnbindFromRenderStep(abRestoreBinding)
    end)
    pcall(function()
        RunService:BindToRenderStep(abRestoreBinding, Enum.RenderPriority.First.Value - 1, restoreAntiBatVelocity)
    end)

    -- ===== V2 (Aka) kept as-is =====
    local AkaAntiBatConn, AkaAntiBatRag
    local function stopAkaAntiBat()
        if AkaAntiBatConn then pcall(function() AkaAntiBatConn:Disconnect() end) AkaAntiBatConn = nil end
        if AkaAntiBatRag then pcall(function() AkaAntiBatRag:Disconnect() end) AkaAntiBatRag = nil end
    end
    local function startAkaAntiBat()
        stopAkaAntiBat()
        local function hookRoot()
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            if AkaAntiBatConn then pcall(function() AkaAntiBatConn:Disconnect() end) end
            AkaAntiBatConn = RunService.Heartbeat:Connect(function()
                if not _G.AmbitiousAntiBatEnabled or antiBatMode ~= "V2" then return end
                if _G._VisibleTPDownUntil and os.clock() < _G._VisibleTPDownUntil then return end
                if not root.Parent then return end
                local vx, vz = root.Velocity.X, root.Velocity.Z
                root.Velocity = Vector3.new(1000, root.Velocity.Y, 1000)
                RunService.RenderStepped:Wait()
                if root.Parent then
                    root.Velocity = Vector3.new(vx, root.Velocity.Y, vz)
                end
            end)
        end
        hookRoot()
        AkaAntiBatRag = RunService.Heartbeat:Connect(function()
            if not _G.AmbitiousAntiBatEnabled or antiBatMode ~= "V2" then return end
            local char = LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if hum then
                local st = hum:GetState()
                if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                    pcall(function() workspace.CurrentCamera.CameraSubject = hum end)
                    if root then
                        root.Velocity = Vector3.zero
                        root.RotVelocity = Vector3.zero
                    end
                end
            end
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("Motor6D") and not d.Enabled then
                    d.Enabled = true
                end
            end
        end)
        LP.CharacterAdded:Connect(function()
            task.wait(0.3)
            if _G.AmbitiousAntiBatEnabled and antiBatMode == "V2" then hookRoot() end
        end)
    end

    local function stopAntiBat()
        if AntiBatConn then pcall(function() AntiBatConn:Disconnect() end) AntiBatConn = nil end
        if stopAkaAntiBat then pcall(stopAkaAntiBat) end
        restoreAntiBatVelocity()
        _G._AmbitiousAntiBatHookRoot = nil
        _G._AmbitiousAntiBatSpiking = false
        abPendingRestore = nil
    end

    -- ===== V1 = Batman Hub Anti Bat engine =====
    local function startAntiBat()
        stopAntiBat()
        stopAkaAntiBat()
        if antiBatMode == "V2" then
            startAkaAntiBat()
            return
        end

        AntiBatConn = RunService.Heartbeat:Connect(function()
            restoreAntiBatVelocity()
            if not _G.AmbitiousAntiBatEnabled then return end
            if antiBatMode ~= "V1" then return end
            if _G._VisibleTPDownUntil and os.clock() < _G._VisibleTPDownUntil then return end
            if _G.__BatmanInstantResetBusy or _G._VisibleInstantResetBusy then return end

            local character = LP.Character
            if not character then return end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health <= 0 then return end
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then return end

            local ok, currentVelocity = pcall(function()
                return humanoidRootPart.AssemblyLinearVelocity
            end)
            if not ok or not currentVelocity then return end

            local realHorizontal = Vector3.new(currentVelocity.X, 0, currentVelocity.Z)
            abAngle = math.rad(math.random(0, 360))
            local power = abCurrentPower
            local fakeVelocity = Vector3.new(
                math.cos(abAngle) * power,
                currentVelocity.Y,
                math.sin(abAngle) * power
            )

            _G._AmbitiousAntiBatFakeLinear = fakeVelocity
            _G._AmbitiousAntiBatHookRoot = humanoidRootPart
            _G._AmbitiousAntiBatSpiking = true

            if not pcall(function()
                humanoidRootPart.AssemblyLinearVelocity = fakeVelocity
            end) then
                _G._AmbitiousAntiBatSpiking = false
                return
            end

            abPendingRestore = {
                root = humanoidRootPart,
                real = realHorizontal,
                fake = Vector3.new(fakeVelocity.X, 0, fakeVelocity.Z),
            }
            _G._AmbitiousAntiBatSpiking = false
        end)
    end

    -- Metatable velocity spoof (same as Batman / VX7)
    pcall(function()
        if type(getrawmetatable) ~= "function" then return end
        local v10 = getrawmetatable(game)
        if type(v10) ~= "table" then return end
        local v11 = setreadonly or make_writeable
        local v12 = isreadonly or iswriteable
        local fn12 = newcclosure or function(cb) return cb end
        local v13 = checkcaller
        local fn13 = rawequal or function(a, b) return a == b end
        if type(v13) ~= "function" then return end
        if v12 and v11 and v12(v10) then pcall(v11, v10, false) end
        local index, newindex = v10.__index, v10.__newindex
        v10.__index = fn12(function(arg, arg2)
            if (arg2 == "AssemblyLinearVelocity" or arg2 == "Velocity" or arg2 == "AssemblyAngularVelocity" or arg2 == "RotVelocity")
                and _G.AmbitiousAntiBatEnabled and not v13()
                and _G._AmbitiousAntiBatHookRoot and fn13(arg, _G._AmbitiousAntiBatHookRoot)
            then
                if arg2 == "AssemblyLinearVelocity" or arg2 == "Velocity" then
                    return _G._AmbitiousAntiBatFakeLinear or Vector3.zero
                end
                return _G._AmbitiousAntiBatFakeAngular or Vector3.zero
            end
            if type(index) == "function" then return index(arg, arg2) end
            if type(index) == "table" then return index[arg2] end
            return nil
        end)
        v10.__newindex = fn12(function(arg, arg2, val)
            if (arg2 == "AssemblyLinearVelocity" or arg2 == "Velocity" or arg2 == "AssemblyAngularVelocity" or arg2 == "RotVelocity")
                and _G.AmbitiousAntiBatEnabled and not v13()
                and _G._AmbitiousAntiBatHookRoot and fn13(arg, _G._AmbitiousAntiBatHookRoot)
            then
                if arg2 == "AssemblyLinearVelocity" or arg2 == "Velocity" then
                    _G._AmbitiousAntiBatFakeLinear = val
                else
                    _G._AmbitiousAntiBatFakeAngular = val
                end
                return
            end
            if type(newindex) == "function" then return newindex(arg, arg2, val) end
            if type(newindex) == "table" then newindex[arg2] = val end
        end)
        if v11 then pcall(v11, v10, true) end
    end)

    _G._AmbitiousAntiBatFakeLinear = Vector3.zero
    _G._AmbitiousAntiBatFakeAngular = Vector3.zero
    _G.AmbitiousAntiBat = {
        setEnabled = function(on)
            on = on == true
            _G.AmbitiousAntiBatEnabled = on
            if on then startAntiBat() else stopAntiBat() end
        end,
        isEnabled = function() return _G.AmbitiousAntiBatEnabled == true end,
    }
    if _G.AmbitiousAntiBatEnabled then startAntiBat() end
    LP.CharacterAdded:Connect(function()
        if _G.AmbitiousAntiBatEnabled then startAntiBat() else stopAntiBat() end
    end)
end

-- ============================================================
-- ANTI BAT V2 SPEEN BODY
-- ============================================================
local function stopAntiBatV2Speen()
    antiBatV2SpeenEnabled = false
    if antiBatV2SpeenConn then
        pcall(function() antiBatV2SpeenConn:Disconnect() end)
        antiBatV2SpeenConn = nil
    end
    pcall(function()
        RunService:UnbindFromRenderStep("VisibleSpeenBody")
    end)
    pcall(function()
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyAngularVelocity = Vector3.zero
            pcall(function() root.RotVelocity = Vector3.zero end)
        end
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
    end)
end

local function startAntiBatV2Speen()
    -- do not call full stop (it flips enabled false mid-toggle); clear only connections
    if antiBatV2SpeenConn then
        pcall(function() antiBatV2SpeenConn:Disconnect() end)
        antiBatV2SpeenConn = nil
    end
    pcall(function() RunService:UnbindFromRenderStep("VisibleSpeenBody") end)

    antiBatV2SpeenEnabled = true

    local function applySpin()
        if not antiBatV2SpeenEnabled then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not root.Parent then return end

        local spd = tonumber(antiBatV2SpeenSpeed) or 80
        if spd < 1 then spd = 1 end
        if spd > 500 then spd = 500 end

        pcall(function()
            if hum then
                hum.AutoRotate = false
                hum.PlatformStand = false
            end
            -- force full Y spin (anti-fling is told to ignore this while speen is on)
            root.AssemblyAngularVelocity = Vector3.new(0, spd, 0)
            pcall(function() root.RotVelocity = Vector3.new(0, spd, 0) end)
        end)
    end

    applySpin()
    -- Heartbeat + last RenderStep so spin wins over aimbot/anti-fling same frame
    antiBatV2SpeenConn = RunService.Heartbeat:Connect(applySpin)
    pcall(function()
        RunService:BindToRenderStep("VisibleSpeenBody", Enum.RenderPriority.Last.Value, applySpin)
    end)
end

local function toggleAntiBatV2Speen(on)
    if on == nil then on = not antiBatV2SpeenEnabled end
    if on then startAntiBatV2Speen() else stopAntiBatV2Speen() end
    if setAntiBatV2SpeenVisual then pcall(setAntiBatV2SpeenVisual, antiBatV2SpeenEnabled) end
    if mobBtnRefs and mobBtnRefs.antiBatV2 then pcall(mobBtnRefs.antiBatV2, antiBatV2SpeenEnabled) end
    pcall(saveConfig)
end
_G.toggleAntiBatV2Speen = toggleAntiBatV2Speen
_G.startAntiBatV2Speen = startAntiBatV2Speen
_G.stopAntiBatV2Speen = stopAntiBatV2Speen


-- ============================================================
-- E01 WARNING + flags (ragdoll timers handled by VX7 RagdollTimer below)
-- ============================================================
enemyRagdollTimerEnabled = enemyRagdollTimerEnabled ~= false
e01WarningEnabled = (e01WarningEnabled ~= false)
e01WarningScale = tonumber(e01WarningScale) or 1

do
    local gen, board, timer = 0, nil, nil
    local lastCarry = false
    local lastTriggered = -math.huge
    local elapsed = 0
    local function e01Clear()
        gen += 1
        if timer then pcall(function() timer:Disconnect() end) timer = nil end
        if board then pcall(function() board:Destroy() end) board = nil end
    end
    local function e01Show()
        e01Clear()
        local myGen = gen
        local sg = Instance.new("ScreenGui")
        sg.Name = "Visible_WARNING_E01"
        sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true
        sg.DisplayOrder = 10050
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function()
            if parentGui then parentGui(sg)
            else
                local ok = pcall(function() sg.Parent = game:GetService("CoreGui") end)
                if not ok then sg.Parent = LP:WaitForChild("PlayerGui") end
            end
        end)
        board = sg
        local f = Instance.new("Frame", sg)
        f.AnchorPoint = Vector2.new(0.5, 0)
        f.Position = UDim2.new(0.5, 0, 0, 58)
        f.Size = UDim2.fromOffset(158, 38)
        f.BackgroundColor3 = Color3.fromRGB(8, 14, 28)
        f.BackgroundTransparency = 0.08
        f.BorderSizePixel = 0
        f.ZIndex = 10051
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
        local st = Instance.new("UIStroke", f)
        st.Color = Color3.fromRGB(70, 170, 255)
        st.Thickness = 1.4
        st.Transparency = 0.08
        local title = Instance.new("TextLabel", f)
        title.Size = UDim2.new(1, 0, 0, 16)
        title.Position = UDim2.fromOffset(0, 1)
        title.BackgroundTransparency = 1
        title.Text = "WARNING E01"
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 10
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.ZIndex = 10052
        local sub = Instance.new("TextLabel", f)
        sub.Size = UDim2.new(1, 0, 0, 18)
        sub.Position = UDim2.fromOffset(0, 16)
        sub.BackgroundTransparency = 1
        sub.Font = Enum.Font.GothamBold
        sub.TextSize = 11
        sub.TextColor3 = Color3.fromRGB(120, 200, 255)
        sub.ZIndex = 10052
        local now = os.clock()
        timer = RunService.RenderStepped:Connect(function()
            if myGen ~= gen or not board or not board.Parent then return end
            local left = math.max(0, 3 - (os.clock() - now))
            if left > 0 then
                sub.Text = string.format("SAFE IN %.2fs", left)
                return
            end
            sub.Text = "READY TO STEAL"
            sub.TextColor3 = Color3.fromRGB(40, 220, 90)
            st.Color = Color3.fromRGB(40, 220, 90)
            if timer then timer:Disconnect() timer = nil end
            task.delay(1.6, function()
                if myGen == gen then e01Clear() end
            end)
        end)
    end
    local function holding()
        local char = LP.Character
        if not char then return false end
        for _, attr in ipairs({"Carrying", "IsCarrying", "HasBrainrot", "Holding", "Stealing"}) do
            if char:GetAttribute(attr) == true or LP:GetAttribute(attr) == true then
                return true
            end
        end
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") or t:IsA("Model") then
                local n = string.lower(t.Name)
                if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then
                    continue
                end
                if string.find(n, "brain", 1, true) or string.find(n, "animal", 1, true)
                    or string.find(n, "pet", 1, true) or t:GetAttribute("Brainrot")
                    or t:FindFirstChild("PromptAttachment", true) then
                    return true
                end
                if t:IsA("Tool") and not string.find(n, "bat", 1, true) then
                    return true
                end
            end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Sit then return true end
        return false
    end
    RunService.Heartbeat:Connect(function(dt)
        elapsed += dt
        if elapsed < 0.08 then return end
        elapsed = 0
        if not e01WarningEnabled then return end
        local nowHold = holding()
        if nowHold ~= lastCarry and os.clock() - lastTriggered > 2.4 then
            lastTriggered = os.clock()
            e01Show()
        end
        lastCarry = nowHold
    end)
    LP.CharacterAdded:Connect(function()
        lastCarry = false
        lastTriggered = -math.huge
        e01Clear()
    end)
    _G._VisibleE01Show = e01Show
    
_G._VisibleE01Stop = e01Clear
end

-- BODY LOCK (Zurich)
bodyLockEnabled = bodyLockEnabled == true
do
    local conn, target, lastScan = nil, nil, 0
    local RANGE = 20
    local controlledHum, controlledRoot, origAuto
    local function release()
        if controlledRoot and controlledRoot.Parent then
            local av = controlledRoot.AssemblyAngularVelocity
            controlledRoot.AssemblyAngularVelocity = Vector3.new(av.X, 0, av.Z)
        end
        if controlledHum and controlledHum.Parent and origAuto ~= nil then
            controlledHum.AutoRotate = origAuto
        end
        controlledHum, controlledRoot, origAuto = nil, nil, nil
    end
    local function valid(plr)
        if not plr or plr == LP or not plr.Character then return false end
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        local root = plr.Character:FindFirstChild("HumanoidRootPart")
        return hum and hum.Health > 0 and root
    end
    local function closest(myRoot)
        local best, bestD = nil, RANGE
        for _, plr in ipairs(Players:GetPlayers()) do
            if valid(plr) then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                local d = (root.Position - myRoot.Position).Magnitude
                if d <= bestD then best, bestD = plr, d end
            end
        end
        return best
    end
    local function stop()
        if conn then pcall(function() conn:Disconnect() end) conn = nil end
        release()
        target = nil
    end
    local function start()
        if conn then return end
        conn = RunService.RenderStepped:Connect(function()
            if not bodyLockEnabled then return end
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not hum or hum.Health <= 0 or not root then release() return end
            if hum.PlatformStand or hum:GetState() == Enum.HumanoidStateType.Ragdoll then release() return end
            if LP:GetAttribute("Stealing") == true and (autoBatEnabled or batAimbotEnabled) then
                release(); target = nil; return
            end
            local now = os.clock()
            if not valid(target) or now - lastScan >= 0.15 then
                target = closest(root)
                lastScan = now
            end
            local tRoot = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            if not tRoot then release() return end
            if (tRoot.Position - root.Position).Magnitude > RANGE then
                release(); target = nil; return
            end
            local look = Vector3.new(tRoot.Position.X, root.Position.Y, tRoot.Position.Z)
            local dir = look - root.Position
            if dir.Magnitude > 0.05 then
                if controlledHum ~= hum then
                    release()
                    controlledHum, controlledRoot, origAuto = hum, root, hum.AutoRotate
                    hum.AutoRotate = false
                end
                dir = dir.Unit
                local cur = math.rad(root.Orientation.Y)
                local want = math.atan2(-dir.X, -dir.Z)
                local ang = math.atan2(math.sin(want - cur), math.cos(want - cur))
                local av = root.AssemblyAngularVelocity
                root.AssemblyAngularVelocity = Vector3.new(av.X, math.clamp(ang * 18, -30, 30), av.Z)
            end
        end)
    end
    _G._VisibleSetBodyLock = function(on)
        bodyLockEnabled = on == true
        if bodyLockEnabled then start() else stop() end
    end
    LP.CharacterAdded:Connect(function()
        release(); target = nil
    end)
    if bodyLockEnabled then start() end
end

-- MEDUSA STEAL DELAY (Zurich)
medusaStealDelayEnabled = medusaStealDelayEnabled ~= false
do
    local ignoreUntil = 0
    local function ignoring()
        return medusaStealDelayEnabled == true and tick() < ignoreUntil
    end
    _G._VisibleMedusaIgnoreUntil = function()
        return ignoring()
    end
    _G._VisibleMedusaHit = function()
        if not medusaStealDelayEnabled then return false end
        ignoreUntil = tick() + 4.2
        if Steal and Steal.AutoStealEnabled and type(stopAutoSteal) == "function" and type(startAutoSteal) == "function" then
            -- keep steal running through the stone window; restart after delay
            task.delay(4.2, function()
                if not medusaStealDelayEnabled then return end
                if Steal.AutoStealEnabled then
                    pcall(stopAutoSteal)
                    pcall(startAutoSteal)
                end
            end)
        end
        return true
    end
    LP.CharacterAdded:Connect(function(char)
        task.defer(function()
            local function watch(part)
                if not part or not part:IsA("BasePart") then return end
                part:GetPropertyChangedSignal("Anchored"):Connect(function()
                    if part.Anchored and medusaStealDelayEnabled then
                        pcall(_G._VisibleMedusaHit)
                    end
                end)
            end
            for _, d in ipairs(char:GetDescendants()) do watch(d) end
            char.DescendantAdded:Connect(watch)
        end)
    end)
end


-- ============================================================
-- X-RAY SUITE (Ambitious): Plot X-Ray + Brainrot X-Ray + Transparent Tools
-- One master toggle drives all three.
-- ============================================================
local xraySuiteEnabled = false
_G.AmbitiousBrainrotXRayEnabled = false
_G.AmbitiousTransparentToolsEnabled = false

_G._AmbitiousXRayFolders = {
    "Base", "PlotSign", "FriendPanel", "Cash", "Laser",
    "Decorations", "Skin", "Unlock", "Purchases"
}
_G._AmbitiousXRayOrigTrans = {}
_G._AmbitiousXRayConns = {}
_G._AmbitiousXRayLoopId = 0

local function setXRayTargetTransparency(instance, alphaPercent, loopId)
    if not instance then return end
    if loopId and loopId ~= _G._AmbitiousXRayLoopId then return end
    local function apply(obj)
        if not obj or not obj.Parent then return end
        if obj:IsA("BasePart") then
            if _G._AmbitiousXRayOrigTrans[obj] == nil then
                _G._AmbitiousXRayOrigTrans[obj] = obj.Transparency
            end
            local orig = _G._AmbitiousXRayOrigTrans[obj]
            if type(orig) == "number" and orig < 1 then
                local target = orig + (1 - orig) * alphaPercent
                if math.abs(obj.Transparency - target) > 0.01 then obj.Transparency = target end
            end
        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
            if _G._AmbitiousXRayOrigTrans[obj] == nil then
                _G._AmbitiousXRayOrigTrans[obj] = { text = obj.TextTransparency, bg = obj.BackgroundTransparency }
            end
            local orig = _G._AmbitiousXRayOrigTrans[obj]
            if type(orig) == "table" then
                if orig.text and orig.text < 1 then
                    local t = orig.text + (1 - orig.text) * alphaPercent
                    if math.abs(obj.TextTransparency - t) > 0.01 then obj.TextTransparency = t end
                end
                if orig.bg and orig.bg < 1 then
                    local t = orig.bg + (1 - orig.bg) * alphaPercent
                    if math.abs(obj.BackgroundTransparency - t) > 0.01 then obj.BackgroundTransparency = t end
                end
            end
        elseif obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
            if _G._AmbitiousXRayOrigTrans[obj] == nil then
                _G._AmbitiousXRayOrigTrans[obj] = obj.BackgroundTransparency
            end
            local orig = _G._AmbitiousXRayOrigTrans[obj]
            if type(orig) == "number" and orig < 1 then
                local t = orig + (1 - orig) * alphaPercent
                if math.abs(obj.BackgroundTransparency - t) > 0.01 then obj.BackgroundTransparency = t end
            end
        elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
            if _G._AmbitiousXRayOrigTrans[obj] == nil then
                _G._AmbitiousXRayOrigTrans[obj] = { img = obj.ImageTransparency, bg = obj.BackgroundTransparency }
            end
            local orig = _G._AmbitiousXRayOrigTrans[obj]
            if type(orig) == "table" then
                if orig.img and orig.img < 1 then
                    local t = orig.img + (1 - orig.img) * alphaPercent
                    if math.abs(obj.ImageTransparency - t) > 0.01 then obj.ImageTransparency = t end
                end
                if orig.bg and orig.bg < 1 then
                    local t = orig.bg + (1 - orig.bg) * alphaPercent
                    if math.abs(obj.BackgroundTransparency - t) > 0.01 then obj.BackgroundTransparency = t end
                end
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            if _G._AmbitiousXRayOrigTrans[obj] == nil then
                _G._AmbitiousXRayOrigTrans[obj] = obj.Transparency
            end
            local orig = _G._AmbitiousXRayOrigTrans[obj]
            if type(orig) == "number" and orig < 1 then
                local t = orig + (1 - orig) * alphaPercent
                if math.abs(obj.Transparency - t) > 0.01 then obj.Transparency = t end
            end
        end
    end
    pcall(apply, instance)
    for _, d in ipairs(instance:GetDescendants()) do
        if loopId and loopId ~= _G._AmbitiousXRayLoopId then return end
        pcall(apply, d)
    end
end

local function trackXRaySubtree(root, alphaPercent, loopId)
    if not root then return end
    if loopId ~= _G._AmbitiousXRayLoopId then return end
    setXRayTargetTransparency(root, alphaPercent, loopId)
    table.insert(_G._AmbitiousXRayConns, root.DescendantAdded:Connect(function(obj)
        if loopId ~= _G._AmbitiousXRayLoopId then return end
        setXRayTargetTransparency(obj, alphaPercent, loopId)
    end))
end

local function processPlotXRay(plot, alphaPercent, loopId)
    if not plot or loopId ~= _G._AmbitiousXRayLoopId then return end
    for _, fname in ipairs(_G._AmbitiousXRayFolders) do
        if loopId ~= _G._AmbitiousXRayLoopId then return end
        trackXRaySubtree(plot:FindFirstChild(fname), alphaPercent, loopId)
    end
    local animalPodiums = plot:FindFirstChild("AnimalPodiums")
    if animalPodiums then
        local function processPodium(podium)
            for _, child in ipairs(podium:GetChildren()) do
                if child.Name == "Claim" then
                    trackXRaySubtree(child, alphaPercent, loopId)
                elseif child.Name == "Base" then
                    trackXRaySubtree(child:FindFirstChild("Decorations"), alphaPercent, loopId)
                elseif child:IsA("Model") and child.Name ~= "Decorations" then
                    trackXRaySubtree(child, alphaPercent, loopId)
                end
            end
        end
        for _, podium in ipairs(animalPodiums:GetChildren()) do processPodium(podium) end
        table.insert(_G._AmbitiousXRayConns, animalPodiums.ChildAdded:Connect(function(podium)
            if loopId ~= _G._AmbitiousXRayLoopId then return end
            task.wait(0.1)
            processPodium(podium)
        end))
    end
end

local function applyTransparencyToAllPlotsXRay(alphaPercent, loopId)
    local plotsFolder = workspace:FindFirstChild("Plots")
    if not plotsFolder then return end
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        if loopId ~= _G._AmbitiousXRayLoopId then return end
        processPlotXRay(plot, alphaPercent, loopId)
        task.wait()
    end
    table.insert(_G._AmbitiousXRayConns, plotsFolder.ChildAdded:Connect(function(plot)
        if loopId ~= _G._AmbitiousXRayLoopId then return end
        task.wait(0.2)
        processPlotXRay(plot, alphaPercent, loopId)
    end))
end

local function setPlotXRay(enabled)
    for _, conn in ipairs(_G._AmbitiousXRayConns) do
        if typeof(conn) == "RBXScriptConnection" then pcall(function() conn:Disconnect() end) end
    end
    _G._AmbitiousXRayConns = {}
    _G._AmbitiousXRayLoopId = _G._AmbitiousXRayLoopId + 1
    local currentLoopId = _G._AmbitiousXRayLoopId
    if enabled then
        local alphaPercent = 0.5
        task.spawn(function()
            while currentLoopId == _G._AmbitiousXRayLoopId and not workspace:FindFirstChild("Plots") do
                task.wait(0.5)
            end
            if currentLoopId ~= _G._AmbitiousXRayLoopId then return end
            pcall(applyTransparencyToAllPlotsXRay, alphaPercent, currentLoopId)
        end)
    else
        local snapshot = _G._AmbitiousXRayOrigTrans
        _G._AmbitiousXRayOrigTrans = {}
        for obj, orig in pairs(snapshot) do
            pcall(function()
                if not obj or not obj.Parent then return end
                if obj:IsA("BasePart") and type(orig) == "number" then
                    obj.Transparency = orig
                elseif (obj:IsA("TextLabel") or obj:IsA("TextButton")) and type(orig) == "table" then
                    obj.TextTransparency = orig.text
                    obj.BackgroundTransparency = orig.bg
                elseif (obj:IsA("Frame") or obj:IsA("ScrollingFrame")) and type(orig) == "number" then
                    obj.BackgroundTransparency = orig
                elseif (obj:IsA("ImageLabel") or obj:IsA("ImageButton")) and type(orig) == "table" then
                    obj.ImageTransparency = orig.img
                    obj.BackgroundTransparency = orig.bg
                elseif (obj:IsA("Decal") or obj:IsA("Texture")) and type(orig) == "number" then
                    obj.Transparency = orig
                end
            end)
        end
    end
end

-- Brainrot X-Ray
_G._AmbitiousBrainrotXRay = {
    enabled = false,
    trans = 0.85,
    saved = {},
    conns = {},
    scanId = 0,
    names = nil,
}
_G._AmbitiousBrainrotXRay.loadNames = function()
    local BRX = _G._AmbitiousBrainrotXRay
    if BRX.names then return end
    BRX.names = {}
    pcall(function()
        local RS = game:GetService("ReplicatedStorage")
        local datas = RS:FindFirstChild("Datas") or RS:FindFirstChild("Data")
        local animals = datas and (datas:FindFirstChild("Animals") or datas:FindFirstChild("Animal"))
        if animals then
            for _, child in ipairs(animals:GetChildren()) do
                BRX.names[child.Name] = true
            end
        end
        for _, m in ipairs(RS:GetDescendants()) do
            if m.Name == "Animals" or m.Name == "AnimalList" then
                pcall(function()
                    local ok, t = pcall(require, m)
                    if ok and type(t) == "table" then
                        for k, v in pairs(t) do
                            if type(k) == "string" then BRX.names[k] = true end
                            if type(v) == "table" and type(v.Name) == "string" then BRX.names[v.Name] = true end
                            if type(v) == "string" then BRX.names[v] = true end
                        end
                    end
                end)
            end
        end
    end)
    if not next(BRX.names) then
        BRX.names = setmetatable({}, { __index = function() return true end })
    end
end
_G._AmbitiousBrainrotXRay.isHitbox = function(o)
    local n = string.lower(o.Name or "")
    return (string.find(n, "hit") or string.find(n, "target") or string.find(n, "box")
        or string.find(n, "root") or string.find(n, "collect") or string.find(n, "prompt")) ~= nil
end
_G._AmbitiousBrainrotXRay.applyOne = function(o)
    local BRX = _G._AmbitiousBrainrotXRay
    if not (o:IsA("BasePart") or o:IsA("Decal") or o:IsA("Texture")) then return end
    local orig = BRX.saved[o]
    if orig == nil then
        orig = o.Transparency
        if orig > 0.5 and orig < 0.99 and o:IsA("BasePart") and BRX.isHitbox(o) then orig = 1 end
        BRX.saved[o] = orig
    end
    if orig < 0.5 and o.Transparency ~= BRX.trans then
        o.Transparency = BRX.trans
    end
end
_G._AmbitiousBrainrotXRay.applyModel = function(m)
    for _, o in ipairs(m:GetDescendants()) do
        _G._AmbitiousBrainrotXRay.applyOne(o)
    end
end
_G._AmbitiousBrainrotXRay.isAnimal = function(m)
    local BRX = _G._AmbitiousBrainrotXRay
    return m:IsA("Model") and BRX.names and BRX.names[m.Name] == true
end
_G._AmbitiousBrainrotXRay.animalAncestor = function(inst)
    local BRX = _G._AmbitiousBrainrotXRay
    local p = inst.Parent
    for _ = 1, 5 do
        if not p or p == workspace then return nil end
        if p:IsA("Model") and BRX.names and BRX.names[p.Name] then return p end
        p = p.Parent
    end
    return nil
end
_G._AmbitiousBrainrotXRay.restoreAll = function()
    local BRX = _G._AmbitiousBrainrotXRay
    local snapshot = BRX.saved
    BRX.saved = {}
    for o, orig in pairs(snapshot) do
        pcall(function()
            if o and o.Parent then o.Transparency = orig end
        end)
    end
end
function _G.AmbitiousSetBrainrotXRay(on)
    local BRX = _G._AmbitiousBrainrotXRay
    on = on and true or false
    BRX.enabled = on
    _G.AmbitiousBrainrotXRayEnabled = on
    for _, c in ipairs(BRX.conns) do pcall(function() c:Disconnect() end) end
    BRX.conns = {}
    BRX.scanId = BRX.scanId + 1
    if not on then BRX.restoreAll(); return end
    BRX.loadNames()
    local myScan = BRX.scanId
    task.spawn(function()
        local n = 0
        for _, d in ipairs(workspace:GetDescendants()) do
            if BRX.scanId ~= myScan then return end
            if BRX.isAnimal(d) then BRX.applyModel(d) end
            if d:IsA("Model") and d.Parent and d.Parent.Name == "AnimalPodiums" then
                if d.Name ~= "Base" and d.Name ~= "Decorations" then BRX.applyModel(d) end
            end
            n = n + 1
            if n % 500 == 0 then task.wait() end
        end
    end)
    table.insert(BRX.conns, workspace.DescendantAdded:Connect(function(inst)
        if not BRX.enabled then return end
        if inst:IsA("Model") then
            if BRX.isAnimal(inst) then BRX.applyModel(inst)
            elseif inst.Parent and inst.Parent.Name == "AnimalPodiums" and inst.Name ~= "Base" then
                BRX.applyModel(inst)
            end
        elseif inst:IsA("BasePart") or inst:IsA("Decal") or inst:IsA("Texture") then
            if BRX.animalAncestor(inst) then BRX.applyOne(inst) end
        end
    end))
end

-- Transparent Tools (simple)
local _ttConns = {}
local _ttSaved = {}
local function setTransparentTools(on)
    _G.AmbitiousTransparentToolsEnabled = on == true
    for _, c in ipairs(_ttConns) do pcall(function() c:Disconnect() end) end
    _ttConns = {}
    if not on then
        local snap = _ttSaved
        _ttSaved = {}
        for o, orig in pairs(snap) do
            pcall(function() if o and o.Parent then o.Transparency = orig end end)
        end
        return
    end
    local TRANSP = 0.5
    local function applyTool(tool)
        if not tool or not tool:IsA("Tool") then return end
        for _, d in ipairs(tool:GetDescendants()) do
            if d:IsA("BasePart") and d.Transparency < 1 then
                if _ttSaved[d] == nil then _ttSaved[d] = d.Transparency end
                d.Transparency = TRANSP
            end
        end
        table.insert(_ttConns, tool.DescendantAdded:Connect(function(d)
            if d:IsA("BasePart") and d.Transparency < 1 then
                if _ttSaved[d] == nil then _ttSaved[d] = d.Transparency end
                d.Transparency = TRANSP
            end
        end))
    end
    local function watchContainer(container)
        if not container then return end
        for _, ch in ipairs(container:GetChildren()) do
            if ch:IsA("Tool") then applyTool(ch) end
        end
        table.insert(_ttConns, container.ChildAdded:Connect(function(ch)
            if ch:IsA("Tool") then applyTool(ch) end
        end))
    end
    watchContainer(LP:FindFirstChildOfClass("Backpack"))
    if LP.Character then watchContainer(LP.Character) end
    table.insert(_ttConns, LP.CharacterAdded:Connect(function(char)
        if not _G.AmbitiousTransparentToolsEnabled then return end
        task.wait(0.2)
        watchContainer(char)
        watchContainer(LP:FindFirstChildOfClass("Backpack"))
    end))
end

-- Master toggle
function setXRaySuite(on)
    xraySuiteEnabled = on == true
    setPlotXRay(xraySuiteEnabled)
    if _G.AmbitiousSetBrainrotXRay then _G.AmbitiousSetBrainrotXRay(xraySuiteEnabled) end
    setTransparentTools(xraySuiteEnabled)
end
setXRay = setPlotXRay -- alias

-- ============================================================
-- KEEP MUSIC + INTRO SONG
-- ============================================================
local KEEP_MUSIC_SONGS = {
    "https://files.catbox.moe/f0wih0.mp3",
    "https://files.catbox.moe/lprp3g.mp3",
    "https://files.catbox.moe/akvg2m.mp3",
    "https://files.catbox.moe/dtsp9i.mp3",
    "https://files.catbox.moe/ddnbup.mp3",
    "https://files.catbox.moe/h3cuo6.mp3",
    "https://files.catbox.moe/2mw4g9.mp3",
    "https://files.catbox.moe/x0zr5p.mp3",
    "https://files.catbox.moe/24b3c5.mp3",
    "https://files.catbox.moe/jvpu0j.mp3",
    "rbxassetid://111051961329728",
    "rbxassetid://75168161337918",
    "rbxassetid://104260039274085",
    "rbxassetid://92893445219567",
}
local KEEP_MUSIC_NAMES = {
    "Song 1", "Song 2", "Song 3", "Song 4", "Song 5",
    "Song 6", "Song 7", "Song 8", "Song 9", "Song 10",
    "Song 11", "Song 12", "Song 13", "Song 14",
}
local previewLoading = false
local previewSound = nil
local previewCacheFile = "K7MusicPreview_cache"
local keepMusicCacheFile = "K7KeepMusic_cache"

local function stopKeepMusic()
    keepMusicEnabled = false
    if keepMusicLoopConn then pcall(function() keepMusicLoopConn:Disconnect() end); keepMusicLoopConn = nil end
    if keepMusicSound and keepMusicSound.Parent then
        pcall(function() keepMusicSound:Stop(); keepMusicSound:Destroy() end)
    end
    keepMusicSound = nil
end

local function stopPreview()
    pcall(function()
        if previewSound and previewSound.Parent then
            previewSound:Stop()
            previewSound:Destroy()
            previewSound = nil
        end
    end)
end

local function playPreview(idx)
    if previewLoading then return end
    if not idx or idx < 1 or idx > #KEEP_MUSIC_SONGS then return end
    previewLoading = true
    stopPreview()
    task.spawn(function()
        pcall(function()
            local url = KEEP_MUSIC_SONGS[idx]
            local asset = nil
            if type(url) == "string" and url:match("^rbxassetid://") then
                asset = url
            else
                local contentBody = nil
                if type(k7HttpGet) == "function" then
                    contentBody = k7HttpGet(url)
                end
                if not contentBody then
                    local ok, body = pcall(function() return game:HttpGet(url) end)
                    if ok then contentBody = body end
                end
                if not contentBody or #contentBody < 100 then return end
                if writefile then writefile(previewCacheFile, contentBody) end
                asset = k7GetCustomAsset and k7GetCustomAsset(previewCacheFile) or nil
                if not asset and getcustomasset then
                    pcall(function() asset = getcustomasset(previewCacheFile) end)
                end
            end
            if not asset then return end
            local snd = Instance.new("Sound", game:GetService("SoundService"))
            snd.SoundId = asset
            snd.Volume = 0.7
            snd.Looped = false
            previewSound = snd
            snd:Play()
            task.delay(12, function()
                if previewSound == snd then stopPreview() end
            end)
        end)
        previewLoading = false
    end)
end

local function startKeepMusic(songIdx)
    stopKeepMusic()
    keepMusicEnabled = true
    keepMusicIndex = songIdx or keepMusicIndex or 1
    if keepMusicIndex < 1 or keepMusicIndex > #KEEP_MUSIC_SONGS then keepMusicIndex = 1 end
    task.spawn(function()
        pcall(function()
            local url = KEEP_MUSIC_SONGS[keepMusicIndex]
            local asset = nil
            if type(url) == "string" and url:match("^rbxassetid://") then
                asset = url
            else
                local contentBody = nil
                if type(k7HttpGet) == "function" then
                    contentBody = k7HttpGet(url)
                end
                if not contentBody then
                    local ok, body = pcall(function() return game:HttpGet(url) end)
                    if ok then contentBody = body end
                end
                if not contentBody or #contentBody < 100 then return end
                if not keepMusicEnabled then return end
                if writefile then writefile(keepMusicCacheFile, contentBody) end
                asset = k7GetCustomAsset and k7GetCustomAsset(keepMusicCacheFile) or nil
                if not asset and getcustomasset then
                    pcall(function() asset = getcustomasset(keepMusicCacheFile) end)
                end
            end
            if not asset or not keepMusicEnabled then return end
            local snd = Instance.new("Sound", game:GetService("SoundService"))
            snd.Name = "K7KeepMusic"
            snd.SoundId = asset
            snd.Volume = 0.65
            snd.Looped = true
            snd.PlaybackSpeed = 1
            keepMusicSound = snd
            local t0 = os.clock()
            while not snd.IsLoaded and (os.clock() - t0) < 15 do
                task.wait(0.1)
                if not keepMusicEnabled then return end
            end
            if not keepMusicEnabled then return end
            snd:Play()
            keepMusicLoopConn = snd.Stopped:Connect(function()
                if keepMusicEnabled and keepMusicSound == snd then
                    task.wait(0.15)
                    if keepMusicEnabled and keepMusicSound == snd then
                        pcall(function()
                            snd.TimePosition = 0
                            snd:Play()
                        end)
                    end
                end
            end)
            task.spawn(function()
                while keepMusicEnabled and keepMusicSound == snd do
                    task.wait(2)
                    if keepMusicEnabled and keepMusicSound == snd and not snd.IsPlaying then
                        pcall(function()
                            snd.TimePosition = 0
                            snd:Play()
                        end)
                    end
                end
            end)
        end)
    end)
end

local function playIntroSong()
    if not introEnabled then return end
    while not game:IsLoaded() do task.wait(0.1) end
    local SoundService = game:GetService("SoundService")
    local introSong = Instance.new("Sound", SoundService)
    introSong.Name = "IntroSong"
    introSong.SoundId = "rbxassetid://96888529539074"
    introSong.Volume = 0.55
    introSong.TimePosition = 14
    introSong:Play()
    task.delay(15, function()
        if introSong then introSong:Stop(); introSong:Destroy() end
    end)
end

-- ============================================================
--  VX7 Ragdoll Timer (All-in-One)
--  Player + Enemy ragdoll/medusa countdown billboards.
--  Default ragdoll = 2.5s | Medusa = 3.5s
--  Uses RagdollEndTime attribute when available for real time.
-- ============================================================

local RagdollTimer = {}
_G._VisibleRagdollTimer = RagdollTimer

RagdollTimer.Config = {
    playerEnabled        = false,
    enemyEnabled         = false,
    defaultRagdollTime   = 2.5,
    defaultMedusaTime    = 3.5,
    medusaPartThreshold  = 3,
    updateInterval       = 0.05,
    tickInterval         = 0.1,
}

local function _rtGuiParent()
    local pg = nil
    if parentGui then
        local sg = Instance.new("Folder")
        -- just resolve host via existing helper when parenting ScreenGuis
    end
    if _gethui then
        pcall(function() pg = _gethui() end)
    end
    if not pg then
        pcall(function() pg = game:GetService("CoreGui") end)
    end
    if not pg then
        pcall(function() pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 2) end)
    end
    return pg
end

local function isMedusa(char)
    if not char then return false end
    local count = 0
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("BasePart") and d.Anchored and d.Transparency == 1 then
            count += 1
            if count >= RagdollTimer.Config.medusaPartThreshold then
                return true
            end
        end
    end
    return false
end

local function getRagdollRemaining(char, hum, plr)
    if not hum or hum.Health <= 0 then return false, nil end
    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll then
        return true, nil
    end
    if hum.PlatformStand then return true, nil end

    local serverTime = workspace:GetServerTimeNow()
    local attr = nil
    if plr then
        attr = plr:GetAttribute("RagdollEndTime")
    end
    attr = attr or char:GetAttribute("RagdollEndTime") or hum:GetAttribute("RagdollEndTime")
    if type(attr) == "number" and attr > serverTime then
        return true, attr - serverTime
    end
    if state == Enum.HumanoidStateType.FallingDown then
        return true, nil
    end
    return false, nil
end

-- PLAYER RAGDOLL TIMER
do
    local connection, charConn
    local generation = 0
    local billboard

    local function clearBillboard()
        generation += 1
        if billboard then
            pcall(function() billboard:Destroy() end)
            billboard = nil
        end
    end

    local function showBillboard(seconds)
        local char = LP.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        generation += 1
        local myGen = generation

        local host = _rtGuiParent()
        if host then
            local old = host:FindFirstChild("RagCountdownBillboard")
            if old then pcall(function() old:Destroy() end) end
        end
        pcall(function()
            local pg = LP:FindFirstChild("PlayerGui")
            if pg then
                local old = pg:FindFirstChild("RagCountdownBillboard")
                if old then old:Destroy() end
            end
        end)

        local gui = Instance.new("BillboardGui")
        gui.Name          = "RagCountdownBillboard"
        gui.Adornee       = hrp
        gui.Size          = UDim2.new(0, 64, 0, 32)
        gui.StudsOffset   = Vector3.new(0, 2.3, 0)
        gui.AlwaysOnTop   = true
        gui.MaxDistance   = 120
        local parented = false
        if host then parented = pcall(function() gui.Parent = host end) end
        if not parented or not gui.Parent then
            pcall(function()
                local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 1)
                if pg then gui.Parent = pg end
            end)
        end
        billboard = gui

        local lbl = Instance.new("TextLabel")
        lbl.Size                   = UDim2.fromScale(1, 1)
        lbl.BackgroundTransparency = 1
        lbl.Font                   = Enum.Font.GothamBlack
        lbl.TextScaled             = false
        lbl.TextSize               = 18
        lbl.TextColor3             = Color3.fromRGB(255, 255, 255)
        lbl.TextStrokeColor3       = Color3.new(0, 0, 0)
        lbl.TextStrokeTransparency = 0
        lbl.Parent = gui

        task.spawn(function()
            local remaining = tonumber(seconds) or RagdollTimer.Config.defaultRagdollTime
            while myGen == generation and gui.Parent and remaining > 0 do
                lbl.Text = string.format("%.1f", math.max(remaining, 0))
                task.wait(RagdollTimer.Config.tickInterval)
                remaining -= RagdollTimer.Config.tickInterval
            end
            if remaining <= 0 and myGen == generation and gui.Parent then
                lbl.Text = "READY!"
                task.wait(0.5)
            end
            if myGen == generation then
                if gui.Parent then gui:Destroy() end
                if billboard == gui then billboard = nil end
            end
        end)
    end

    local function startLoop()
        if connection then connection:Disconnect(); connection = nil end
        if charConn   then charConn:Disconnect();   charConn   = nil end
        if not RagdollTimer.Config.playerEnabled then return end

        local wasRagdolled = false
        local acc = 0

        connection = RunService.Heartbeat:Connect(function(dt)
            if not RagdollTimer.Config.playerEnabled then
                clearBillboard()
                return
            end
            acc += dt or (1/60)
            if acc < RagdollTimer.Config.updateInterval then return end
            acc = 0

            local char = LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return end

            local ragdolled, remaining = getRagdollRemaining(char, hum, LP)
            if ragdolled and not wasRagdolled then
                showBillboard(remaining)
            end
            wasRagdolled = ragdolled
        end)

        charConn = LP.CharacterAdded:Connect(function()
            task.wait(0.5)
            wasRagdolled = false
            clearBillboard()
        end)
    end

    function RagdollTimer.SetPlayerEnabled(on)
        RagdollTimer.Config.playerEnabled = on == true
        ragdollGuiEnabled = RagdollTimer.Config.playerEnabled
        if RagdollTimer.Config.playerEnabled then
            startLoop()
        else
            if connection then connection:Disconnect(); connection = nil end
            if charConn   then charConn:Disconnect();   charConn   = nil end
            clearBillboard()
        end
    end
end

-- ENEMY RAGDOLL TIMER
do
    local connection, removeConn
    local tracked = {}
    local active  = {}
    local acc = 0

    local function clearOne(player)
        local data = active[player]
        if not data then return end
        data.token += 1
        if data.positionConn then
            data.positionConn:Disconnect()
            data.positionConn = nil
        end
        if data.gui then
            pcall(function() data.gui:Destroy() end)
        end
        active[player] = nil
    end

    local function clearAll()
        local keys = {}
        for k in pairs(active) do table.insert(keys, k) end
        for _, p in ipairs(keys) do clearOne(p) end
        table.clear(tracked)
    end

    local function showCountdown(player, char, seconds, kind)
        local head = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
        if not head then return end

        seconds = tonumber(seconds) or RagdollTimer.Config.defaultRagdollTime
        kind    = kind == "medusa" and "medusa" or "ragdoll"

        clearOne(player)

        local host = _rtGuiParent()
        local gui = Instance.new("BillboardGui")
        gui.Name = "VisibleEnemyRagdoll"
        gui.Adornee = head
        gui.Size = UDim2.fromOffset(90, 28)
        gui.StudsOffset = Vector3.new(0, 3.2, 0)
        gui.AlwaysOnTop = true
        gui.MaxDistance = 220
        gui.LightInfluence = 0
        local parented = false
        if host then
            parented = pcall(function() gui.Parent = host end)
        end
        if not parented or not gui.Parent then
            pcall(function()
                local pg = LP:FindFirstChild("PlayerGui")
                if pg then gui.Parent = pg else gui.Parent = head end
            end)
        end
        if not gui.Parent then
            pcall(function() gui.Parent = head end)
        end

        local f = Instance.new("Frame", gui)
        f.Size = UDim2.fromScale(1, 1)
        f.BackgroundColor3 = Color3.fromRGB(8, 16, 28)
        f.BackgroundTransparency = 0.72
        f.BorderSizePixel = 0
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

        local stroke = Instance.new("UIStroke", f)
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 1
        stroke.Transparency = 0.15

        local lab = Instance.new("TextLabel", f)
        lab.Name = "T"
        lab.Size = UDim2.fromScale(1, 1)
        lab.BackgroundTransparency = 1
        lab.Font = Enum.Font.GothamBold
        lab.TextSize = 13
        lab.TextColor3 = Color3.fromRGB(255, 255, 255)
        lab.TextStrokeColor3 = Color3.new(0, 0, 0)
        lab.TextStrokeTransparency = 0.2
        lab.Text = ""

        local data = { gui = gui, token = 1, effectType = kind, positionConn = nil }
        active[player] = data
        local myToken = data.token

        task.spawn(function()
            local remaining = seconds
            while RagdollTimer.Config.enemyEnabled
                and active[player] == data
                and data.token == myToken
                and gui.Parent
                and remaining > 0
            do
                lab.Text = string.format("%.1fs", math.max(remaining, 0))
                local c = player.Character
                local h = c and (c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart"))
                if h and gui.Adornee ~= h then
                    gui.Adornee = h
                end
                task.wait(RagdollTimer.Config.tickInterval)
                remaining -= RagdollTimer.Config.tickInterval
            end

            if RagdollTimer.Config.enemyEnabled
                and active[player] == data
                and data.token == myToken
                and gui.Parent
            then
                lab.Text = "STEAL!"
                while RagdollTimer.Config.enemyEnabled
                    and active[player] == data
                    and data.token == myToken
                    and gui.Parent
                do
                    task.wait(RagdollTimer.Config.tickInterval)
                    local c = player.Character
                    local hum = c and c:FindFirstChildOfClass("Humanoid")
                    if not hum or hum.Health <= 0 or c ~= char then break end
                    local still
                    if kind == "medusa" then
                        still = isMedusa(c)
                    else
                        still = select(1, getRagdollRemaining(c, hum, player))
                    end
                    if not still then break end
                    local h = c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart")
                    if h and gui.Adornee ~= h then
                        gui.Adornee = h
                    end
                end
            end

            if active[player] == data and data.token == myToken then
                if gui.Parent then pcall(function() gui:Destroy() end) end
                active[player] = nil
            end
        end)
    end

    local function startLoop()
        if connection then connection:Disconnect(); connection = nil end
        if removeConn then removeConn:Disconnect(); removeConn = nil end
        clearAll()
        if not RagdollTimer.Config.enemyEnabled then return end
        acc = 0

        connection = RunService.Heartbeat:Connect(function(dt)
            if not RagdollTimer.Config.enemyEnabled then return end
            acc += dt
            if acc < RagdollTimer.Config.updateInterval then return end
            acc = 0

            local seen = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LP then
                    seen[player] = true
                    local char = player.Character
                    local hum  = char and char:FindFirstChildOfClass("Humanoid")
                    local state = tracked[player]

                    if not state or state.character ~= char then
                        state = { character = char, ragdolled = false, stoned = false }
                        tracked[player] = state
                        clearOne(player)
                    end

                    if hum and hum.Health > 0 then
                        local ragdolled = getRagdollRemaining(char, hum, player)
                        local stoned    = isMedusa(char)

                        if stoned and not state.stoned then
                            showCountdown(player, char, RagdollTimer.Config.defaultMedusaTime, "medusa")
                        elseif ragdolled and not state.ragdolled and not stoned then
                            local activeData = active[player]
                            if not activeData or activeData.effectType ~= "medusa" then
                                local _, remaining = getRagdollRemaining(char, hum, player)
                                showCountdown(player, char, remaining or RagdollTimer.Config.defaultRagdollTime, "ragdoll")
                            end
                        end
                        state.stoned    = stoned
                        state.ragdolled = ragdolled
                    else
                        state.ragdolled = false
                        state.stoned    = false
                        clearOne(player)
                    end
                end
            end

            for p in pairs(tracked) do
                if not seen[p] then
                    tracked[p] = nil
                    clearOne(p)
                end
            end
        end)

        removeConn = Players.PlayerRemoving:Connect(function(player)
            tracked[player] = nil
            clearOne(player)
        end)
    end

    function RagdollTimer.SetEnemyEnabled(on)
        RagdollTimer.Config.enemyEnabled = on == true
        enemyRagdollTimerEnabled = RagdollTimer.Config.enemyEnabled
        if RagdollTimer.Config.enemyEnabled then
            startLoop()
        else
            if connection then connection:Disconnect(); connection = nil end
            if removeConn then removeConn:Disconnect(); removeConn = nil end
            clearAll()
        end
    end
end

function RagdollTimer.SetPlayerTime(seconds)
    RagdollTimer.Config.defaultRagdollTime = tonumber(seconds) or 2.5
end

function RagdollTimer.SetMedusaTime(seconds)
    RagdollTimer.Config.defaultMedusaTime = tonumber(seconds) or 3.5
end

function RagdollTimer.Destroy()
    RagdollTimer.SetPlayerEnabled(false)
    RagdollTimer.SetEnemyEnabled(false)
end

-- legacy stubs so old callers don't error
function createRagdollBillboard(duration, labelText, color)
    return nil
end
function setupRagdollTriggers()
end
local function showStealCountdown(char)
end
_G._K7ShowStealCountdown = showStealCountdown

-- boot from current flags
-- Always on (no UI toggles)
ragdollGuiEnabled = true
enemyRagdollTimerEnabled = true
task.defer(function()
    RagdollTimer.SetPlayerEnabled(true)
    RagdollTimer.SetEnemyEnabled(true)
end)

local function getSpeedThemeColors()
    local th=getTheme()
    local accent=th and th.ACCENT or Color3.fromRGB(0,190,255)
    local accent2=th and th.ACCENT2 or Color3.fromRGB(0,140,225)
    local gray=th and th.GRAY or Color3.fromRGB(120,155,205)
    return accent,accent2,gray
end
local function setupSpeedIndicator(char)
    local head=char:WaitForChild("Head",5);if not head then return end
    local root=char:FindFirstChild("HumanoidRootPart") or head
    pcall(function()
        local old=head:FindFirstChild("K7SpeedBB")
        if old then old:Destroy() end
    end)
    speedLabel=nil
    local accent,accent2,gray=getSpeedThemeColors()
    local bb=Instance.new("BillboardGui")
    bb.Name="K7SpeedBB";bb.Size=UDim2.new(0,130,0,48);bb.StudsOffset=Vector3.new(0,3.2,0)
    bb.Adornee=root
    bb.AlwaysOnTop=true;bb.MaxDistance=80;bb.Parent=root
    local discordLabel=Instance.new("TextLabel",bb)
    discordLabel.Name="DiscordLbl";discordLabel.Size=UDim2.new(1,0,0.38,0)
    discordLabel.BackgroundTransparency=1;discordLabel.Text=".gg/VisibleHub"
    discordLabel.TextColor3=gray;discordLabel.Font=Enum.Font.GothamBold
    discordLabel.TextScaled=true;discordLabel.TextStrokeTransparency=0.4
    speedLabel=Instance.new("TextLabel",bb)
    speedLabel.Name="SpeedLbl";speedLabel.Size=UDim2.new(1,0,0.55,0)
    speedLabel.Position=UDim2.new(0,0,0.38,0);speedLabel.BackgroundTransparency=1
    speedLabel.Text="0.0";speedLabel.TextColor3=accent
    speedLabel.Font=Enum.Font.GothamBold;speedLabel.TextScaled=true
    speedLabel.TextStrokeTransparency=0.35
    local gr1=addShimmerToLabel(speedLabel,accent2,accent)
    local gr2=addShimmerToLabel(discordLabel,gray,accent)
    task.spawn(function()
        local t=0
        while bb and bb.Parent do
            t=t+0.03
            pcall(function()
                gr1.Offset=Vector2.new(math.sin(t)*0.4,0)
                gr2.Offset=Vector2.new(math.sin(t)*0.4,0)
            end)
            task.wait(0.05)
        end
    end)
end
local function getActiveMoveSpeed()
    if laggerCarryActive or (laggerModeEnabled and carrySpeedActive) then return LAGGER_CARRY_SPEED
    elseif laggerModeEnabled then return LAGGER_SPEED
    elseif carrySpeedActive then return CS
    else return NS end
end

-- ============================================================
-- Movement helpers
-- ============================================================
local _moveDt = 1/60
local _speedActive = false
local _lastHorizSpeed = 0
local _actualSpeed = 0
local _lastPos = nil
local _lastPosT = 0

local function applyImpulseVel(part, targetVel)
    if not part or not part.Parent then return end
    pcall(function()
        local mass = part.AssemblyMass
        if not mass or mass ~= mass or mass <= 0 then mass = 1 end
        local current = part.AssemblyLinearVelocity
        local delta = targetVel - current
        part:ApplyImpulse(delta * mass)
    end)
end

local function applyVel(part, targetVel)
    applyImpulseVel(part, targetVel)
end

local function applyAngVel(part, targetAng)
    if not part or not part.Parent then return end
    pcall(function()
        local mass = part.AssemblyMass
        if not mass or mass <= 0 then mass = 1 end
        local current = part.AssemblyAngularVelocity
        local target = targetAng or Vector3.zero
        part:ApplyAngularImpulse((target - current) * mass * 0.35)
    end)
end

-- ============================================================
-- ANTI-DIE / SPEED system
-- ============================================================
local function isRagdollState(hum)
    if not hum then return true end
    local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll
end

local MOVE_KEYS = {
    [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true, [Enum.KeyCode.Down] = true,
    [Enum.KeyCode.Left] = true, [Enum.KeyCode.Right] = true,
}

lastMoveDir = lastMoveDir or Vector3.zero

local velChecked = {}
local hookedVelParts = {}

local function setupVelChecked(char)
    velChecked = {}
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
    if hrp then velChecked[hrp] = true end
    return hrp
end

local function hookVelHRP(hrp)
    if not hrp or hookedVelParts[hrp] then return end
    if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function" then return end
    hookedVelParts[hrp] = true
    local mt = getrawmetatable(hrp)
    if not mt then return end
    pcall(function()
        setreadonly(mt, false)
        local originalVelIndex = rawget(mt, "__index")
        local wrapper = function(self, key)
            if type(checkcaller) == "function" and not checkcaller() and velChecked[self] and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                local real
                if type(originalVelIndex) == "function" then real = originalVelIndex(self, key)
                elseif type(originalVelIndex) == "table" then real = originalVelIndex[key] end
                if typeof(real) == "Vector3" and real.Magnitude > 20 then return real.Unit * 20 end
                return real
            end
            if type(originalVelIndex) == "function" then return originalVelIndex(self, key)
            elseif type(originalVelIndex) == "table" then return originalVelIndex[key] end
        end
        if type(newcclosure) == "function" then mt.__index = newcclosure(wrapper)
        else mt.__index = wrapper end
        setreadonly(mt, true)
    end)
end

local function hookCharacterVelocity(char)
    hookedVelParts = {}
    local hrp = setupVelChecked(char)
    hookVelHRP(hrp)
end

if LP.Character then task.defer(function() hookCharacterVelocity(LP.Character) end) end
LP.CharacterAdded:Connect(function(char) task.defer(function() hookCharacterVelocity(char) end) end)

local function applyASVelocitySpeed(dir, speed)
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum or not root or hum.Health <= 0 then return end
    if dir and dir.Magnitude > 0.05 then
        pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end)
        local unit = dir.Unit
        root.AssemblyLinearVelocity = Vector3.new(unit.X * speed, root.AssemblyLinearVelocity.Y, unit.Z * speed)
        pcall(function() root.Velocity = Vector3.new(unit.X * speed, root.Velocity.Y, unit.Z * speed) end)
    else
        root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
        pcall(function() root.Velocity = Vector3.new(0, root.Velocity.Y, 0) end)
    end
end

local _displaySpeed = 0
local _speedConn = nil

local function applyVelocitySpeed()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum or not root or hum.Health <= 0 then _displaySpeed = 0; return end
    if autoBatEnabled or autoLeftEnabled or autoRightEnabled then
        local hv = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z)
        _displaySpeed = hv.Magnitude
        return
    end
    pcall(function()
        if hum.CameraOffset and hum.CameraOffset.Magnitude > 0.05 then
            hum.CameraOffset = Vector3.new(0, 0, 0)
        end
    end)
    if isRagdollState(hum) then
        lastMoveDir = Vector3.zero
        _displaySpeed = 0
        return
    end
    local spd = getActiveMoveSpeed()
    local md = hum.MoveDirection
    local dir = nil
    if md.Magnitude > 0.05 then
        lastMoveDir = md
        dir = md
    elseif lastMoveDir.Magnitude > 0.05 then
        local anyHeld = false
        for key in pairs(MOVE_KEYS) do
            if UIS:IsKeyDown(key) then anyHeld = true break end
        end
        if anyHeld then dir = lastMoveDir end
    end
    if dir and dir.Magnitude > 0.05 then
        applyASVelocitySpeed(dir, spd)
        _displaySpeed = spd
    else
        applyASVelocitySpeed(nil, 0)
        _displaySpeed = 0
    end
end

if _speedConn then pcall(function() _speedConn:Disconnect() end) end
_speedConn = RunService.RenderStepped:Connect(function()
    applyVelocitySpeed()
    if speedLabel then speedLabel.Text = string.format("%.1f", _displaySpeed or 0) end
end)

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    setupSpeedIndicator(char)
    setupRagdollTriggers()
    if medusaCounterEnabled then setupMedusa(char) end
    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then task.wait(0.5); startUnwalk() end
    hookCharacterVelocity(char)
end)
if LP.Character then
    setupSpeedIndicator(LP.Character)
    setupRagdollTriggers()
end

opponentSpeedEnabled = opponentSpeedEnabled ~= false
do
    local oppGuis, lastPos, lastT, smooth = {}, {}, {}, {}
    local host = LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
    local function oppClear(plr)
        local g = oppGuis[plr]
        if g then pcall(function() g:Destroy() end) oppGuis[plr] = nil end
        lastPos[plr], lastT[plr], smooth[plr] = nil, nil, nil
    end
    local function oppMake(plr, head)
        local bb = Instance.new("BillboardGui")
        bb.Name = "VisibleOppSpeed"
        bb.Adornee = head
        bb.Size = UDim2.fromOffset(70, 20)
        bb.StudsOffset = Vector3.new(0, 2.6, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 300
        bb.ResetOnSpawn = false
        bb.Parent = host
        local lab = Instance.new("TextLabel", bb)
        lab.Name = "S"
        lab.Size = UDim2.fromScale(1, 1)
        lab.BackgroundTransparency = 1
        lab.Font = Enum.Font.GothamBold
        lab.TextScaled = true
        lab.TextColor3 = Color3.fromRGB(80, 200, 255)
        lab.TextStrokeTransparency = 0.35
        lab.Text = "0"
        oppGuis[plr] = bb
        return bb
    end
    RunService.Heartbeat:Connect(function()
        if not opponentSpeedEnabled then
            for plr in pairs(oppGuis) do oppClear(plr) end
            return
        end
        local now = os.clock()
        local seen = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                seen[plr] = true
                local head = plr.Character:FindFirstChild("Head")
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if head and root then
                    local g = oppGuis[plr]
                    if not g or not g.Parent then g = oppMake(plr, head) end
                    g.Adornee = head
                    local pos = root.Position
                    local prev, pt = lastPos[plr], lastT[plr]
                    local measured
                    if prev and pt and now - pt > 0.02 then
                        local d = pos - prev
                        measured = Vector3.new(d.X, 0, d.Z).Magnitude / math.max(now - pt, 1/120)
                    else
                        local v = root.AssemblyLinearVelocity
                        measured = Vector3.new(v.X, 0, v.Z).Magnitude
                    end
                    lastPos[plr], lastT[plr] = pos, now
                    local sm = smooth[plr] or measured
                    sm = sm + (measured - sm) * 0.35
                    if sm < 1.2 then sm = 0 end
                    smooth[plr] = sm
                    local lab = g:FindFirstChild("S")
                    if lab then lab.Text = string.format("%.0f", sm) end
                else
                    oppClear(plr)
                end
            end
        end
        for plr in pairs(oppGuis) do
            if not seen[plr] then oppClear(plr) end
        end
    end)
end

-- AUTO SWITCH ON CARRY
local _autoSwitchWasSteal = false
local _autoSwitchApplied = false

local function isAutoSwitchEnabled()
    if autoSwitchSpeedEnabled == true then return true end
    if getgenv and getgenv().AntiSammyAutoSwitchSpeed == true then return true end
    return false
end

local function detectStealOrCarry(char, hum)
    local okAttr, stealing = pcall(function()
        return LP:GetAttribute("Stealing") == true
            or char:GetAttribute("Stealing") == true
            or char:GetAttribute("IsStealing") == true
            or char:GetAttribute("Carrying") == true
            or char:GetAttribute("IsCarrying") == true
    end)
    if okAttr and stealing then return true end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local n = child.Name:lower()
            if not (n:find("bat", 1, true) or n:find("slap", 1, true) or n:find("medusa", 1, true)
                or n:find("head", 1, true) or n:find("stone", 1, true)) then
                return true
            end
        elseif child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            local n = child.Name:lower()
            if n:find("brainrot", 1, true) or n:find("animal", 1, true) or n:find("carry", 1, true)
                or n:find("grab", 1, true) or n:find("steal", 1, true) or n:find("hold", 1, true)
                or n:find("skibidi", 1, true) or n:find("toilet", 1, true) then
                return true
            end
        end
    end
    if hum then
        local ws = hum.WalkSpeed
        if type(ws) == "number" and ws > 0 and ws <= 25 and ws ~= 16 then return true end
    end
    return false
end

function updateAutoSwitchSpeed()
    if not isAutoSwitchEnabled() then
        if _autoSwitchApplied then _autoSwitchApplied = false; _autoSwitchWasSteal = false end
        return
    end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local isSteal = detectStealOrCarry(char, hum)
    if isSteal == _autoSwitchWasSteal then return end
    _autoSwitchWasSteal = isSteal
    if isSteal then
        carrySpeedActive = true
        _autoSwitchApplied = true
        if laggerCarryActive and not laggerModeEnabled then laggerModeEnabled = true end
    else
        if _autoSwitchApplied then
            carrySpeedActive = false
            _autoSwitchApplied = false
        end
    end
    if type(refreshSpeedModeLabel) == "function" then pcall(refreshSpeedModeLabel) end
    if mobBtnRefs then
        if mobBtnRefs.carrySpeed then pcall(mobBtnRefs.carrySpeed, carrySpeedActive) end
        if mobBtnRefs.lagger then pcall(mobBtnRefs.lagger, laggerModeEnabled) end
        if mobBtnRefs.laggerCarry then
            local lc = laggerCarryActive or (laggerModeEnabled and carrySpeedActive)
            pcall(mobBtnRefs.laggerCarry, lc)
        end
    end
end
task.spawn(function()
    while true do task.wait(0.1); pcall(updateAutoSwitchSpeed) end
end)

-- ============================================================
-- AUTO LEFT / AUTO RIGHT — 7UP path logic
-- ============================================================
alConn, arConn = nil, nil
alPhase, arPhase = 1, 1

AP_L1 = Vector3.new(-476.48, -6.28, 92.73)
AP_L2 = Vector3.new(-483.12, -4.95, 94.80)
AP_R1 = Vector3.new(-476.16, -6.52, 25.62)
AP_R2 = Vector3.new(-483.06, -5.03, 25.48)

local AP_REACH_THRESHOLD = 1.5

stopAutoLeft = function()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    autoLeftEnabled = false
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:Move(Vector3.zero, false) end
    if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0) end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobBtnRefs and mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
    carrySpeedActive = true
    if mobBtnRefs and mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(true) end
    if type(refreshSpeedModeLabel) == "function" then pcall(refreshSpeedModeLabel) end
end

stopAutoRight = function()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    autoRightEnabled = false
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:Move(Vector3.zero, false) end
    if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0) end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobBtnRefs and mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
    carrySpeedActive = true
    if mobBtnRefs and mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(true) end
    if type(refreshSpeedModeLabel) == "function" then pcall(refreshSpeedModeLabel) end
end

startAutoLeft = function()
    if safeModeTryStart and not safeModeTryStart() then return end
    if autoRightEnabled then stopAutoRight() end
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    autoLeftEnabled = true
    carrySpeedActive = false
    if mobBtnRefs and mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(false) end
    if type(refreshSpeedModeLabel) == "function" then pcall(refreshSpeedModeLabel) end

    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero, false); return end

        local spd = tonumber(NS) or 60

        if alPhase == 1 then
            local tgt = Vector3.new(AP_L1.X, hrp.Position.Y, AP_L1.Z)
            if (tgt - hrp.Position).Magnitude < AP_REACH_THRESHOLD then
                alPhase = 2
                return
            end
            local d = AP_L1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.1 then
                mv = mv.Unit
                hum:Move(mv, false)
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
            end
        else
            local tgt = Vector3.new(AP_L2.X, hrp.Position.Y, AP_L2.Z)
            if (tgt - hrp.Position).Magnitude < AP_REACH_THRESHOLD then
                stopAutoLeft()
                return
            end
            local d = AP_L2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.1 then
                mv = mv.Unit
                hum:Move(mv, false)
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
            end
        end
    end)
end

startAutoRight = function()
    if safeModeTryStart and not safeModeTryStart() then return end
    if autoLeftEnabled then stopAutoLeft() end
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    autoRightEnabled = true
    carrySpeedActive = false
    if mobBtnRefs and mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(false) end
    if type(refreshSpeedModeLabel) == "function" then pcall(refreshSpeedModeLabel) end

    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero, false); return end

        local spd = tonumber(NS) or 60

        if arPhase == 1 then
            local tgt = Vector3.new(AP_R1.X, hrp.Position.Y, AP_R1.Z)
            if (tgt - hrp.Position).Magnitude < AP_REACH_THRESHOLD then
                arPhase = 2
                return
            end
            local d = AP_R1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.1 then
                mv = mv.Unit
                hum:Move(mv, false)
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
            end
        else
            local tgt = Vector3.new(AP_R2.X, hrp.Position.Y, AP_R2.Z)
            if (tgt - hrp.Position).Magnitude < AP_REACH_THRESHOLD then
                stopAutoRight()
                return
            end
            local d = AP_R2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z)
            if mv.Magnitude > 0.1 then
                mv = mv.Unit
                hum:Move(mv, false)
                hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
            end
        end
    end)
end

local ANTI_FLING_AIMBOT_LIN = 95
local ANTI_FLING_AIMBOT_ANG = 20
local function applyAimbotAntiFling(root)
    if not root or not root.Parent then return end
    pcall(function()
        local v = root.AssemblyLinearVelocity
        if v.Magnitude > ANTI_FLING_AIMBOT_LIN then root.AssemblyLinearVelocity = v.Unit * ANTI_FLING_AIMBOT_LIN end
        if not antiBatV2SpeenEnabled and root.AssemblyAngularVelocity.Magnitude > ANTI_FLING_AIMBOT_ANG then root.AssemblyAngularVelocity = Vector3.zero end
        local char = LP.Character
        if char then
            for _, p in ipairs(char:GetChildren()) do
                if p:IsA("BasePart") and p ~= root then
                    local pv = p.AssemblyLinearVelocity
                    if pv.Magnitude > ANTI_FLING_AIMBOT_LIN * 1.15 then p.AssemblyLinearVelocity = pv.Unit * ANTI_FLING_AIMBOT_LIN end
                    if not antiBatV2SpeenEnabled and p.AssemblyAngularVelocity.Magnitude > ANTI_FLING_AIMBOT_ANG then p.AssemblyAngularVelocity = Vector3.zero end
                end
            end
        end
    end)
end

runDrop=function()
    if dropActive then return end
    local char=LP.Character;if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart");if not root then return end
    dropActive=true
    local brainrot = nil
    for _,tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then brainrot = tool; break end
    end
    if brainrot then
        local bp = LP:FindFirstChild("Backpack")
        if bp then brainrot.Parent = bp end
    end
    local t0=tick();local dc
    dc=RunService.Heartbeat:Connect(function()
        local r=char and char:FindFirstChild("HumanoidRootPart")
        if not r then dc:Disconnect();dropActive=false;return end
        if tick()-t0>=DROP_ASCEND_DURATION then
            dc:Disconnect()
            local rp=RaycastParams.new();rp.FilterDescendantsInstances={char};rp.FilterType=Enum.RaycastFilterType.Exclude
            local rr=workspace:Raycast(r.Position,Vector3.new(0,-2000,0),rp)
            if rr then
                local hum2=char:FindFirstChildOfClass("Humanoid")
                local off=(hum2 and hum2.HipHeight or 2)+(r.Size.Y/2)
                r.CFrame=CFrame.new(r.Position.X,rr.Position.Y+off,r.Position.Z)
                r.AssemblyLinearVelocity=Vector3.new(0,0,0)
            end
            dropActive=false;return
        end
        r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,DROP_ASCEND_SPEED,r.AssemblyLinearVelocity.Z)
    end)
end

local autoTPPaused = false
local function doAutoTPDown(force)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if not hum2 then return end
    if not force then
        if hum2.FloorMaterial ~= Enum.Material.Air then return end
        if not (hrp.Position.Y >= autoTPHeight) then return end
    end
    local yaw = select(2, hrp.CFrame:ToEulerAnglesYXZ())
    local dest = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
    _G._VisibleTPDownUntil = os.clock() + 0.4
    hrp.CFrame = dest
    hrp.Velocity = Vector3.zero
    hrp.AssemblyLinearVelocity = Vector3.zero
    task.defer(function()
        if hrp and hrp.Parent then
            hrp.CFrame = dest
            hrp.Velocity = Vector3.zero
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end
local function pauseAutoTP() autoTPPaused = true end
local function resumeAutoTP() autoTPPaused = false end
startAutoTP = function()
    if autoTPConn then task.cancel(autoTPConn); autoTPConn = nil end
    autoTPConn = task.spawn(function()
        while autoTPEnabled do
            task.wait(0.1)
            if not autoTPPaused then pcall(function() doAutoTPDown(false) end) end
        end
    end)
end
stopAutoTP = function()
    autoTPEnabled = false
    autoTPPaused = false
    if autoTPConn then task.cancel(autoTPConn); autoTPConn = nil end
end
runTPFloor = function() pcall(function() doAutoTPDown(true) end) end

-- MIRROR TP DOWN
local function mirrorTPAimbotActive()
    return autoBatEnabled == true or batAimbotEnabled == true
end
local function mirrorTPTeleportDown(targetRoot)
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end
    local now = tick()
    if now - (mirrorTPLastTeleport or 0) < 0.08 then return end
    mirrorTPLastTeleport = now
    local _, yaw = root.CFrame:ToEulerAnglesYXZ()
    local y
    if targetRoot then
        y = targetRoot.Position.Y
    else
        y = (MIRROR_TP_DOWN_Y or -7)
    end
    root.CFrame = CFrame.new(root.Position.X, y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
    pcall(function()
        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z)
    end)
end
do
    local flagName = "_K7MirrorTPStarted"
    if not _G[flagName] then
        _G[flagName] = true
        RunService.Heartbeat:Connect(function()
            if not mirrorTPDownEnabled or not mirrorTPAimbotActive() then
                if next(mirrorTPPreviousY) then table.clear(mirrorTPPreviousY) end
                return
            end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local currentY = root.Position.Y
                        local previousY = mirrorTPPreviousY[plr.UserId]
                        if previousY and previousY - currentY >= (MIRROR_TP_DROP_THRESHOLD or 3) then
                            pcall(mirrorTPTeleportDown, root)
                            table.clear(mirrorTPPreviousY)
                            return
                        end
                        mirrorTPPreviousY[plr.UserId] = currentY
                    end
                end
            end
        end)
    end
end
local function setMirrorTPDown(enabled)
    mirrorTPDownEnabled = enabled == true
    if not mirrorTPDownEnabled then table.clear(mirrorTPPreviousY) end
    if setMirrorTPVisual then setMirrorTPVisual(mirrorTPDownEnabled) end
end

defLightBrightness,defLightClock,defLightAmbient=nil,nil,nil
-- ============================================================
-- AMBITIOUS-STYLE ANTI LAG (no optimizer)
-- ============================================================
local function applyAntiLagDerender(obj)
    pcall(function()
        if not obj or not obj.Parent then return end
        if obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") then return end
        if obj:IsA("Accessory") or obj:IsA("Hat") then
            local char = LP.Character
            if char and obj:IsDescendantOf(char) then return end
            pcall(function() obj:Destroy() end)
            return
        end
        if obj:IsA("BasePart") then
            local char = LP.Character
            if char and obj:IsDescendantOf(char) then return end
            local model = obj:FindFirstAncestorOfClass("Model")
            if model and Players:GetPlayerFromCharacter(model) then return end
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
            pcall(function()
                obj.TopSurface = Enum.SurfaceType.Smooth
                obj.BottomSurface = Enum.SurfaceType.Smooth
                obj.FrontSurface = Enum.SurfaceType.Smooth
                obj.BackSurface = Enum.SurfaceType.Smooth
                obj.LeftSurface = Enum.SurfaceType.Smooth
                obj.RightSurface = Enum.SurfaceType.Smooth
            end)
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") then
                    child.Transparency = 0.5
                end
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 0.5
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj.Enabled = false
        end
    end)
end

enableAntiLag = function()
    removeAccessoriesEnabled = true
    antiLagEnabled = true
    defLightBrightness = defLightBrightness or Lighting.Brightness
    defLightClock = defLightClock or Lighting.ClockTime
    defLightAmbient = defLightAmbient or Lighting.OutdoorAmbient
    pcall(function()
        settings().Rendering.QualityLevel = 1
    end)
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.Brightness = 1
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end
    end)
    pcall(function()
        local t = workspace:FindFirstChildOfClass("Terrain")
        if t then
            t.WaterWaveSize = 0
            t.WaterWaveSpeed = 0
            t.WaterReflectance = 0
            t.WaterTransparency = 0
            t.Decoration = false
        end
    end)
    for _, obj in ipairs(workspace:GetDescendants()) do
        applyAntiLagDerender(obj)
    end
    if antiLagDescConn then pcall(function() antiLagDescConn:Disconnect() end) end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if removeAccessoriesEnabled and antiLagEnabled then
            applyAntiLagDerender(obj)
        end
    end)
end

disableAntiLag = function()
    removeAccessoriesEnabled = false
    antiLagEnabled = false
    if antiLagDescConn then pcall(function() antiLagDescConn:Disconnect() end); antiLagDescConn = nil end
    pcall(function()
        if defLightBrightness then Lighting.Brightness = defLightBrightness end
        if defLightClock then Lighting.ClockTime = defLightClock end
        if defLightAmbient then Lighting.OutdoorAmbient = defLightAmbient end
        Lighting.ExposureCompensation = 0
        Lighting.GlobalShadows = true
        Lighting.EnvironmentDiffuseScale = 1
        Lighting.EnvironmentSpecularScale = 1
    end)
end

enableOptimizer = function() end
disableOptimizer = function() end
setOptimizerMode = function() end

local function findMedusa()
    local c=LP.Character;if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChild("Backpack");if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
local function useMedusaCounter()
    if medusaDebounce then return end;if MEDUSA_COOLDOWN>(tick()-medusaLastUsed) then return end
    local c=LP.Character;if not c then return end;medusaDebounce=true
    local med=findMedusa();if not med then medusaDebounce=false;return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end);medusaLastUsed=tick();medusaDebounce=false
end
local function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency == 1 then
            if medusaCounterEnabled then useMedusaCounter() end
        end
    end)
end
setupMedusa=function(char)
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end))
end
stopMedusaCounter=function() for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={} end
BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local function findBatForCounter()
    local c=LP.Character;if not c then return nil end;local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end
local function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
end
startBatCounter=function()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not batCounterEnabled or batCounterDebounce then return end
        local char=LP.Character;if not char then return end
        local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
        local st=hum2:GetState()
        local isRag = (st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or hum2.PlatformStand==true)
        if not isRag then return end
        batCounterDebounce=true
        task.spawn(function()
            local mode = batCounterMode or "V1"
            local bat = (findBatForCounter and findBatForCounter()) or findBat()
            if mode == "V2" then
                _G.AmbitiousBatCounterV2On = true
                local root = char:FindFirstChild("HumanoidRootPart")
                local target, targetPlr = getClosestTarget()
                if root and target then
                    pcall(function()
                        if sethiddenproperty then sethiddenproperty(root, "PhysicsRepRootPart", target) end
                        local look = CFrame.new(root.Position, target.Position)
                        root.CFrame = look
                    end)
                end
                if bat then
                    if bat.Parent ~= char then
                        pcall(function() hum2:EquipTool(bat) end)
                        task.wait(0.05)
                    end
                    for _=1,4 do pcall(function() bat:Activate() end); task.wait(0.05) end
                    local rem = bat:FindFirstChildWhichIsA("RemoteEvent")
                    if rem then pcall(function() rem:FireServer() end) end
                end
                task.wait(0.7)
                _G.AmbitiousBatCounterV2On = false
                pcall(function()
                    local r = char:FindFirstChild("HumanoidRootPart")
                    if r and sethiddenproperty then sethiddenproperty(r, "PhysicsRepRootPart", nil) end
                end)
            else
                if bat then
                    if swingBatForCounter then swingBatForCounter(bat, char)
                    else
                        if bat.Parent ~= char then pcall(function() hum2:EquipTool(bat) end) end
                        pcall(function() bat:Activate() end)
                    end
                end
            end
            task.wait(0.5)
            batCounterDebounce=false
        end)
    end)
end
stopBatCounter=function()
    if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end
    batCounterDebounce=false
    _G.AmbitiousBatCounterV2On = false
end
aimbotConn=nil
aimbotV2Conn=nil

local function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
        end
    end
    return nil
end

local function getClosestTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil, math.huge end
    local closest, closestPlr, minDist = nil, nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot; closestPlr = plr end
            end
        end
    end
    return closest, closestPlr, minDist
end

local function swingCurrentBat(char)
    if not autoSwingEnabled then return end
    char = char or LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local bat = findBat and findBat() or nil
    if not bat then
        local pack = LP:FindFirstChild("Backpack")
        if pack then
            for _, t in ipairs(pack:GetChildren()) do
                if t:IsA("Tool") and (string.find(string.lower(t.Name), "bat", 1, true) or string.find(string.lower(t.Name), "slap", 1, true)) then
                    pcall(function()
                        if hum then hum:EquipTool(t) else t.Parent = char end
                    end)
                    bat = t
                    break
                end
            end
        end
    end
    if bat and bat:IsA("Tool") then
        pcall(function() bat:Activate() end)
        pcall(function()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end)
    end
end

task.spawn(function()
    while task.wait(0.08) do
        if not autoSwingEnabled then continue end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local closest, _, dist = getClosestTarget()
        if closest and dist and dist <= 8 then
            swingCurrentBat(char)
        end
    end
end)

do
    task.spawn(function()
        task.wait(1.5)
        local sg = Instance.new("ScreenGui")
        sg.Name = "K7VisionAimbotTarget"
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 40
        sg.IgnoreGuiInset = true
        pcall(function()
            if parentGui then parentGui(sg) else
                local ok = pcall(function() sg.Parent = game:GetService("CoreGui") end)
                if not ok then sg.Parent = LP:WaitForChild("PlayerGui") end
            end
        end)
        local th = (type(getTheme) == "function" and getTheme()) or {}
        local bg = th.BG or Color3.fromRGB(6, 9, 15)
        local accent = th.ACCENT or Color3.fromRGB(0, 190, 255)
        local accent2 = th.ACCENT2 or Color3.fromRGB(0, 140, 225)
        local white = th.WHITE or Color3.fromRGB(228, 240, 255)
        local f = Instance.new("Frame", sg)
        f.Size = UDim2.new(0, 200, 0, 36)
        f.Position = UDim2.new(0.5, -100, 0, 80)
        f.BackgroundColor3 = bg
        f.BackgroundTransparency = 0.12
        f.BorderSizePixel = 0
        f.Visible = false
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", f)
        st.Color = accent; st.Thickness = 1; st.Transparency = 0.2
        local stGrad = Instance.new("UIGradient", st)
        stGrad.Color = ColorSequence.new(accent, accent2)
        stGrad.Rotation = 0
        local lockTxt = Instance.new("TextLabel", f)
        lockTxt.Size = UDim2.new(0, 60, 1, 0); lockTxt.Position = UDim2.new(0, 10, 0, 0)
        lockTxt.BackgroundTransparency = 1; lockTxt.Text = "LOCKED"
        lockTxt.TextColor3 = accent; lockTxt.Font = Enum.Font.GothamBlack
        lockTxt.TextSize = 11; lockTxt.TextXAlignment = Enum.TextXAlignment.Left
        local targetLabel = Instance.new("TextLabel", f)
        targetLabel.Size = UDim2.new(1, -76, 1, 0); targetLabel.Position = UDim2.new(0, 70, 0, 0)
        targetLabel.BackgroundTransparency = 1; targetLabel.Text = ""
        targetLabel.TextColor3 = white; targetLabel.Font = Enum.Font.GothamBlack
        targetLabel.TextSize = 12; targetLabel.TextXAlignment = Enum.TextXAlignment.Left
        targetLabel.TextTruncate = Enum.TextTruncate.AtEnd
        local labelGrad = Instance.new("UIGradient", targetLabel)
        labelGrad.Color = ColorSequence.new(accent, accent2); labelGrad.Rotation = 0
        local rot = 0
        RunService.Heartbeat:Connect(function(dt)
            rot = (rot + (dt or 0.016) * 35) % 360
            stGrad.Rotation = rot
            local th2 = (type(getTheme) == "function" and getTheme()) or th
            local a = th2.ACCENT or accent
            lockTxt.TextColor3 = a; st.Color = a
            if autoBatEnabled and _aimbotTargetPlr and _aimbotTargetPlr.Parent then
                local name = _aimbotTargetPlr.DisplayName or _aimbotTargetPlr.Name or "?"
                if targetLabel.Text ~= name then targetLabel.Text = name end
                if not f.Visible then f.Visible = true end
            else
                if f.Visible then f.Visible = false end
            end
        end)
    end)
end

local BAT_TOOL_NAMES = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
function ensureBatEquipped()
    local char = LP.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local function isBatTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = tostring(tool.Name):lower()
        if n:find("bat", 1, true) or n:find("slap", 1, true) or n:find("glove", 1, true) then return true end
        for _, name in ipairs(BAT_TOOL_NAMES) do if tool.Name == name then return true end end
        return false
    end
    for _, ch in ipairs(char:GetChildren()) do if isBatTool(ch) then return ch end end
    local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if bp and hum then
        for _, name in ipairs(BAT_TOOL_NAMES) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then pcall(function() hum:EquipTool(t) end); return t end
        end
        for _, t in ipairs(bp:GetChildren()) do
            if isBatTool(t) then pcall(function() hum:EquipTool(t) end); return t end
        end
    end
    return nil
end

local function aimEquipBat()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") then
            local n = string.lower(t.Name)
            if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then
                return t
            end
        end
    end
    local bat = (ensureBatEquipped and ensureBatEquipped()) or (findBat and findBat())
    if bat and hum then
        pcall(function() hum:EquipTool(bat) end)
        if bat.Parent ~= char then
            pcall(function() bat.Parent = char end)
        end
    end
    return bat
end

local AceAntiBypassAimbot = {conn = nil, swingCooldown = false, prevAutoRotate = nil}
local AceNormalAimbot = {conn = nil, target = nil, swingCooldown = false, nextSwingAt = 0}

batAimbotEnabled = false
antiBatBypassLockEnabled = false
antiDesyncAimbotEnabled = false

AIMBOT_SPEED = 58
LAGGER_AIMBOT_SPEED = 40
local AceAntiBypassAimbotSpeed = 58
local AceAntiBypassLaggerAimbotSpeed = 40
ANTI_DESYNC_AIMBOT_SPEED = 58

setBatAimbotVisual = setBatAimbotVisual
setAntiBatBypassLockVisual = setAntiBatBypassLockVisual

function GetCurrentSpeedMode()
    if laggerCarryActive or laggerModeEnabled then return "Lagger"
    elseif carrySpeedActive then return "Carry"
    else return "Normal" end
end
function GetBatAimbotSpeed()
    local mode = GetCurrentSpeedMode()
    if mode == "Lagger" then return tonumber(LAGGER_AIMBOT_SPEED) or 40
    else return tonumber(AIMBOT_SPEED) or 58 end
end
function GetAntiBypassAimbotSpeed()
    local mode = GetCurrentSpeedMode()
    if mode == "Lagger" then return tonumber(AceAntiBypassLaggerAimbotSpeed) or 40
    else return tonumber(AceAntiBypassAimbotSpeed) or 58 end
end
function FindAimbotBat() return ensureBatEquipped() end

function GetClosestAimbotTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    return closest
end

function AntiBypassGetClosest()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    return closest, minDist
end
function AntiBypassFindBat() return ensureBatEquipped() end
function AntiBypassTrySwing()
    if AceAntiBypassAimbot.swingCooldown then return end
    AceAntiBypassAimbot.swingCooldown = true
    pcall(function()
        local char = LP.Character
        if not char then return end
        local bat = AntiBypassFindBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
    task.delay(0.03, function() AceAntiBypassAimbot.swingCooldown = false end)
end

local ZBat = {
    on = false,
    conn = nil,
    equipped = false,
    Speed = 58,
    VertSpeed = 52,
    Dist = 0,
    Height = 1.5,
    VertOffset = 0,
    TurnSpeed = 285,
    MaxTurnRate = 28,
}

local function _zbFindBat()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
    end
    local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
        end
    end
    return nil
end

local function _zbGetTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local d = (tRoot.Position - root.Position).Magnitude
                if d < minDist then minDist = d; closest = tRoot end
            end
        end
    end
    return closest
end

function StartBatAimbot()
    -- Default bat aimbot: Yout Bat V2 (exact port of core chase/hit)
    if antiBatBypassLockEnabled then StopAntiBatBypassLock() end
    if ZBat.conn then pcall(function() ZBat.conn:Disconnect() end); ZBat.conn = nil end
    if AceNormalAimbot.conn then AceNormalAimbot.conn:Disconnect(); AceNormalAimbot.conn = nil end
    if AceNormalAimbot.safetyConn then pcall(function() AceNormalAimbot.safetyConn:Disconnect() end); AceNormalAimbot.safetyConn = nil end

    batAimbotEnabled = true
    autoBatEnabled = true
    ZBat.on = true
    ZBat.equipped = false
    AceNormalAimbot.target = nil
    AceNormalAimbot.swingCooldown = false
    AceNormalAimbot.nextSwingAt = 0
    AceNormalAimbot._intendedVel = Vector3.zero
    AceNormalAimbot._generation = (AceNormalAimbot._generation or 0) + 1
    local generation = AceNormalAimbot._generation

    -- Yout Bat V2 constants
    local BAT_V2_SPEED = 58
    local BAT_V2_HIT_DIST = 10
    local TURN_RATE = 40
    local MAX_TURN = 28

    pcall(function() if pauseAutoTP then pauseAutoTP() end end)

    local function findBatTool(char)
        if not char then return nil end
        local t = char:FindFirstChildOfClass("Tool")
        if t then
            local n = string.lower(t.Name)
            if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then return t end
        end
        if type(ensureBatEquipped) == "function" then
            local b = ensureBatEquipped()
            if b then return b end
        end
        if type(FindAimbotBat) == "function" then
            local b = FindAimbotBat()
            if b then return b end
        end
        local pack = LP:FindFirstChild("Backpack")
        if pack then
            for _, tool in ipairs(pack:GetChildren()) do
                if tool:IsA("Tool") then
                    local n = string.lower(tool.Name)
                    if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then
                        return tool
                    end
                end
            end
        end
        return nil
    end

    local function ensureAngVel(root)
        if AceNormalAimbot._ang and AceNormalAimbot._ang.Parent then return AceNormalAimbot._ang end
        pcall(function()
            if AceNormalAimbot._ang then AceNormalAimbot._ang:Destroy() end
            if AceNormalAimbot._att then AceNormalAimbot._att:Destroy() end
        end)
        local att = root:FindFirstChild("VisibleYoutBatV2Att")
        if not att then
            att = Instance.new("Attachment")
            att.Name = "VisibleYoutBatV2Att"
            att.Parent = root
        end
        local av = Instance.new("AngularVelocity")
        av.Name = "VisibleYoutBatV2AV"
        av.Attachment0 = att
        av.RelativeTo = Enum.ActuatorRelativeTo.World
        av.MaxTorque = 1e6
        av.AngularVelocity = Vector3.zero
        av.Parent = root
        AceNormalAimbot._att = att
        AceNormalAimbot._ang = av
        return av
    end

    local function getClosestRoot(myRoot)
        local best, bestD = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                local tHum = plr.Character:FindFirstChildOfClass("Humanoid")
                if tRoot and tHum and tHum.Health > 0 then
                    local d = (tRoot.Position - myRoot.Position).Magnitude
                    if d < bestD then bestD, best = d, tRoot end
                end
            end
        end
        if type(GetClosestAimbotTarget) == "function" then
            local t = GetClosestAimbotTarget()
            if t then return t, (t.Position - myRoot.Position).Magnitude end
        end
        return best, bestD
    end

    AceNormalAimbot.conn = RunService.Heartbeat:Connect(function()
        if not batAimbotEnabled or not ZBat.on or AceNormalAimbot._generation ~= generation then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end

        local ang = ensureAngVel(root)

        if not ZBat.equipped then
            ZBat.equipped = true
            local bat = findBatTool(char)
            if bat and bat.Parent ~= char then
                pcall(function() hum:EquipTool(bat) end)
            end
        end

        local targetRoot, dist = getClosestRoot(root)
        if not targetRoot then
            AceNormalAimbot.target = nil
            _aimbotTargetPlr = nil
            hum.AutoRotate = true
            if ang then ang.AngularVelocity = Vector3.zero end
            pcall(function() if type(_vaDestroySphere) == "function" then _vaDestroySphere() end end)
            return
        end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") == targetRoot then
                _aimbotTargetPlr = plr
                break
            end
        end
        AceNormalAimbot.target = targetRoot

        -- Yout lead point: look-vector offset based on target speed
        local tVel = Vector3.zero
        pcall(function() tVel = targetRoot.AssemblyLinearVelocity end)
        local lead = (tVel.Magnitude < 0.1) and 1.5 or 5
        local aimPos = targetRoot.Position + targetRoot.CFrame.LookVector * lead

        -- Keep aim circle on lead point
        if type(_vaEnsureSphere) == "function" then
            local sph = _vaEnsureSphere()
            if sph then sph.CFrame = CFrame.new(aimPos + Vector3.new(0, 2, 0)) end
        end

        local offset = aimPos - root.Position
        local flat = Vector3.new(offset.X, 0, offset.Z)
        hum.AutoRotate = false

        if offset.Magnitude > 0.01 and flat.Magnitude > 0.01 then
            local yawErr = (math.deg(math.atan2(-flat.X, -flat.Z)) - root.Orientation.Y + 180) % 360 - 180
            local pitchErr = (math.deg(math.atan2(offset.Y, flat.Magnitude)) - root.Orientation.X + 180) % 360 - 180
            local yaw = math.clamp(math.rad(yawErr) * TURN_RATE, -MAX_TURN, MAX_TURN)
            local pitch = math.clamp(math.rad(pitchErr) * TURN_RATE, -MAX_TURN, MAX_TURN)
            local ry = math.rad(root.Orientation.Y)
            if ang then
                ang.AngularVelocity = Vector3.new(0, yaw, 0) + Vector3.new(math.cos(ry), 0, -math.sin(ry)) * pitch
            end
        else
            if ang then ang.AngularVelocity = Vector3.zero end
        end

        -- Yout velocity: unit * 58 + vertical assist
        local intended
        if flat.Magnitude > 0.1 then
            intended = flat.Unit * BAT_V2_SPEED
        else
            intended = Vector3.zero
        end
        if math.abs(offset.Y) > 0.8 then
            intended = intended + Vector3.new(0, math.sign(offset.Y) * BAT_V2_SPEED, 0)
        else
            intended = intended + Vector3.new(0, -2, 0)
        end
        AceNormalAimbot._intendedVel = intended
        root.Velocity = intended
        pcall(function() root.AssemblyLinearVelocity = intended end)

        if flat.Magnitude > 0.5 then
            pcall(function() hum:Move(flat.Unit, false) end)
        end

        -- Swing when close
        local hitDist = (targetRoot.Position - root.Position).Magnitude
        local now = tick()
        if hitDist <= BAT_V2_HIT_DIST and now >= (AceNormalAimbot.nextSwingAt or 0) then
            AceNormalAimbot.nextSwingAt = now + 0.04
            local bat = findBatTool(char)
            if bat then
                if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
                pcall(function() bat:Activate() end)
                pcall(function()
                    if typeof(firetouchinterest) == "function" then
                        local handle = bat:FindFirstChild("Handle")
                        if handle then
                            firetouchinterest(handle, targetRoot, 0)
                            firetouchinterest(handle, targetRoot, 1)
                        end
                    end
                end)
            end
        end
    end)

    -- Safety: clamp wild velocity (Yout)
    AceNormalAimbot.safetyConn = RunService.RenderStepped:Connect(function()
        if not batAimbotEnabled or AceNormalAimbot._generation ~= generation then return end
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local v = root.Velocity
        if math.abs(v.X) > 350 or math.abs(v.Z) > 350 then
            local iv = AceNormalAimbot._intendedVel or Vector3.zero
            root.Velocity = iv
            pcall(function() root.AssemblyLinearVelocity = iv end)
        end
    end)

    ZBat.conn = AceNormalAimbot.conn

    if setBatAimbotVisual then setBatAimbotVisual(true) end
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
end

function StopBatAimbot()
    ZBat.on = false
    ZBat.equipped = false
    AceNormalAimbot._generation = (AceNormalAimbot._generation or 0) + 1
    if AceNormalAimbot.conn then
        AceNormalAimbot.conn:Disconnect()
        AceNormalAimbot.conn = nil
    end
    if AceNormalAimbot.safetyConn then
        pcall(function() AceNormalAimbot.safetyConn:Disconnect() end)
        AceNormalAimbot.safetyConn = nil
    end
    if ZBat.conn then
        pcall(function() ZBat.conn:Disconnect() end)
        ZBat.conn = nil
    end
    AceNormalAimbot.target = nil
    AceNormalAimbot.swingCooldown = false
    AceNormalAimbot.nextSwingAt = 0
    AceNormalAimbot._intendedVel = Vector3.zero
    pcall(function()
        if AceNormalAimbot._ang then
            AceNormalAimbot._ang.AngularVelocity = Vector3.zero
            AceNormalAimbot._ang:Destroy()
            AceNormalAimbot._ang = nil
        end
        if AceNormalAimbot._att then
            AceNormalAimbot._att:Destroy()
            AceNormalAimbot._att = nil
        end
    end)
    pcall(function()
        if type(_vaDestroySphere) == "function" then
            _vaDestroySphere()
        elseif VisibleAim and VisibleAim.sphere then
            VisibleAim.sphere:Destroy()
            VisibleAim.sphere = nil
        end
    end)

    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        pcall(function()
            root.Velocity = root.Velocity * 0.3
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then
        pcall(function()
            hum2.AutoRotate = true
            hum2.PlatformStand = false
        end)
    end

    batAimbotEnabled = false
    autoBatEnabled = false
    _aimbotTargetPlr = nil
    pcall(function() if resumeAutoTP then resumeAutoTP() end end)
    if setBatAimbotVisual then setBatAimbotVisual(false) end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
end


local BypassAim = {
    conn = nil,
    hittingCooldown = false,
    prevAutoRotate = nil,
}

local function _bypassSwing()
    if BypassAim.hittingCooldown then return end
    BypassAim.hittingCooldown = true
    pcall(function()
        local char = LP.Character
        if not char then return end
        local bat = ensureBatEquipped() or _zbFindBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then pcall(function() ev:FireServer() end) end
        end
    end)
    task.delay(0.08, function()
        BypassAim.hittingCooldown = false
    end)
end

function StartAntiBatBypassLock()
    if batAimbotEnabled then StopBatAimbot() end
    if BypassAim.conn then BypassAim.conn:Disconnect(); BypassAim.conn = nil end

    antiBatBypassLockEnabled = true
    autoBatEnabled = true

    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        BypassAim.prevAutoRotate = hum0.AutoRotate
        hum0.AutoRotate = false
    end
    pcall(function() if pauseAutoTP then pauseAutoTP() end end)
    pcall(ensureBatEquipped)

    BypassAim.conn = RunService.RenderStepped:Connect(function()
        if not antiBatBypassLockEnabled then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local target, dist = AntiBypassGetClosest()
        if not target then return end

        local fp  = target.Position + target.CFrame.LookVector * 1.5
        local dir = fp - hrp.Position
        if dir.Magnitude < 0.01 then return end
        dir = dir.Unit

        local speed = GetAntiBypassAimbotSpeed()
        hrp.Velocity = Vector3.new(dir.X * speed, dir.Y * speed, dir.Z * speed)

        if dist <= 5 and autoSwingEnabled then
            _bypassSwing()
        end
    end)

    if setAntiBatBypassLockVisual then setAntiBatBypassLockVisual(true) end
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
end

function StopAntiBatBypassLock()
    antiBatBypassLockEnabled = false
    autoBatEnabled = false
    if BypassAim.conn then
        BypassAim.conn:Disconnect()
        BypassAim.conn = nil
    end
    BypassAim.hittingCooldown = false

    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (BypassAim.prevAutoRotate == nil) and true or BypassAim.prevAutoRotate
    end
    BypassAim.prevAutoRotate = nil

    pcall(function() if resumeAutoTP then resumeAutoTP() end end)
    if setAntiBatBypassLockVisual then setAntiBatBypassLockVisual(false) end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
end

startBatAimbot = StartBatAimbot
stopBatAimbot = function()
    StopBatAimbot()
    pcall(function() if StopAntiBatBypassLock then StopAntiBatBypassLock() end end)
end

queueAutoBatStart = function()
    if antiKickEnabled and brainrotDetected then return end
    -- Instant exclusive toggle (Ace-style, no waits)
    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then pcall(autoLeftSetVisual, false) end
        pcall(stopAutoLeft)
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then pcall(autoRightSetVisual, false) end
        pcall(stopAutoRight)
    end
    if antiBatBypassLockEnabled then pcall(StopAntiBatBypassLock) end
    -- Start immediately; startBatAimbot clears prior state itself
    pcall(startBatAimbot)
end

resetAutoBatMotion=function()
    local char=LP.Character;local hrp=char and char:FindFirstChild("HumanoidRootPart");local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hrp then applyVel(hrp, hrp.AssemblyLinearVelocity*0.3);applyAngVel(hrp, Vector3.zero) end
    if hum then hum.AutoRotate=true end
    ZBat.on = false
    ZBat.equipped = false
    if ZBat.conn then ZBat.conn:Disconnect(); ZBat.conn = nil end
end

do
    local CIRCLE = {
        predictionSphere = nil,
        targetPlayer = nil,
        lastTargetPos = nil,
        targetVelocity = Vector3.new(0,0,0),
        smoothedVelocity = Vector3.new(0,0,0),
        velocityHistory = {},
        MAX_HISTORY = 8,
        airborneTime = 0,
        lastActivationTime = 0,
        highYVelocityTime = 0,
        pingHistory = {},
        currentPing = 0.1,
        accelerationHistory = {},
        MAX_ACCEL_HISTORY = 4,
        lastDirectionChangeTime = 0,
        previousDirection = nil,
        wasAirborne = false,
        aerialVelocityHistory = {},
        MAX_AERIAL_HISTORY = 6,
        aerialSmoothVelocity = Vector3.new(0,0,0),
        lastYVelocity = 0,
        peakHeight = 0,
        groundHeight = 0,
        lastJumpTime = 0,
        isMultiJumping = false,
        verticalVelocityHistory = {},
        MAX_VERTICAL_HISTORY = 5,
        lastGroundedPosition = nil,
        realPingMs = 0,
    }

    local CFG = {
        FOLLOW_SPEED = AIMBOT_SPEED or 50,
        ACTIVATE_DISTANCE = 7,
        MIN_FOLLOW_DISTANCE = 3,
        PREDICTION_TIME = 0.16,
        PREDICT_AHEAD = 1.5,
        JUMP_SPEED_BOOST = 1.5,
        JUMP_THRESHOLD = 8,
        MAX_SPEED = AIMBOT_SPEED or 50,
        ACTIVATION_DELAY = 0.2,
        AIRBORNE_THRESHOLD = 0.15,
        FLOAT_Y_THRESHOLD = 3,
        FALLING_THRESHOLD = -8,
        RISING_THRESHOLD = 8,
        VERTICAL_OFFSET_MULTIPLIER = 0.15,
        JUMPBOOST_Y_THRESHOLD = 35,
        EXTREME_JUMPBOOST_THRESHOLD = 50,
        JUMPBOOST_SUSTAINED_TIME = 0.15,
        MAX_VELOCITY_CHANGE = 150,
        VELOCITY_SMOOTHING = 0.2,
        MAX_HORIZONTAL_VELOCITY = 80,
        ERRATIC_MOVEMENT_THRESHOLD = 3,
        SERVER_TICKRATE = 1/60,
        PING_SAMPLE_SIZE = 10,
        MIN_PING_COMPENSATION = 0.03,
        MAX_PING_COMPENSATION = 0.25,
        ACCELERATION_PREDICTION_WEIGHT = 0.3,
        DIRECTION_CHANGE_DETECTION_TIME = 0.12,
        QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
        GRAVITY = 196.2,
        AIR_CONTROL_FACTOR = 0.8,
        AERIAL_VELOCITY_DECAY = 0.95,
        AERIAL_DIRECTION_CHANGE_WEIGHT = 0.6,
        MIN_AIRBORNE_TIME = 0.08,
        AERIAL_SMOOTHING = 0.15,
        PEAK_JUMP_THRESHOLD = 3,
        AERIAL_PREDICTION_BOOST = 1.2,
        STRAFE_DETECTION_THRESHOLD = 0.7,
        HIGH_JUMP_THRESHOLD = 20,
        FALLING_SPEED_THRESHOLD = -15,
        GRAVITY_PREDICTION_WEIGHT = 1.0,
        MULTI_JUMP_DETECTION_WINDOW = 0.2,
        UPWARD_VELOCITY_RESET_THRESHOLD = 10,
        VERTICAL_POSITION_LEAD = 2.5,
        FALLING_VERTICAL_LEAD = 3.5,
        SPHERE_SMOOTH_SPEED = 15,
    }

    local C = CIRCLE

    task.spawn(function()
        while true do
            pcall(function()
                local ok, val = pcall(function() return LP.Ping end)
                if ok and type(val) == "number" and val > 0 then
                    C.realPingMs = val
                    return
                end
                local ok2, val2 = pcall(function()
                    return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                end)
                if ok2 and type(val2) == "number" then
                    C.realPingMs = math.floor(val2)
                end
            end)
            task.wait(0.5)
        end
    end)

    local function updatePing()
        local pingSeconds = C.realPingMs / 1000
        table.insert(C.pingHistory, pingSeconds)
        if #C.pingHistory > CFG.PING_SAMPLE_SIZE then
            table.remove(C.pingHistory, 1)
        end
        local sum = 0
        for _, p in ipairs(C.pingHistory) do sum = sum + p end
        C.currentPing = math.clamp(sum / #C.pingHistory, CFG.MIN_PING_COMPENSATION, CFG.MAX_PING_COMPENSATION)
    end
    task.spawn(function()
        while true do
            task.wait(0.5)
            pcall(updatePing)
        end
    end)

    local function getNearestPlayer()
        local char = LP.Character
        if not char then return nil end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end

        local myPos = root.Position
        local nearestDist = math.huge
        local nearestPlayer = nil

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local otherRoot = p.Character:FindFirstChild("HumanoidRootPart")
                if otherRoot then
                    local dist = (myPos - otherRoot.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearestPlayer = p
                    end
                end
            end
        end
        return nearestPlayer
    end

    local function getCircleCombatTool(char)
        if not char then return nil end
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("bat") or n:find("slap") then
                    return tool
                end
            end
        end
        local bp = LP:FindFirstChild("Backpack")
        if bp then
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") then
                    local n = tool.Name:lower()
                    if n:find("bat") or n:find("slap") then
                        return tool
                    end
                end
            end
        end
        return nil
    end

    local function getAverageVelocity()
        if #C.velocityHistory == 0 then return Vector3.zero end
        local sum = Vector3.zero
        for _, vel in ipairs(C.velocityHistory) do sum = sum + vel end
        return sum / #C.velocityHistory
    end

    local function getAverageAcceleration()
        if #C.accelerationHistory == 0 then return Vector3.zero end
        local sum = Vector3.zero
        for _, a in ipairs(C.accelerationHistory) do sum = sum + a end
        return sum / #C.accelerationHistory
    end

    local function getAverageAerialVelocity()
        if #C.aerialVelocityHistory == 0 then return Vector3.zero end
        local sum = Vector3.zero
        for _, vel in ipairs(C.aerialVelocityHistory) do
            sum = sum + Vector3.new(vel.X, 0, vel.Z)
        end
        return sum / #C.aerialVelocityHistory
    end

    local function getAverageVerticalVelocity()
        if #C.verticalVelocityHistory == 0 then return 0 end
        local sum = 0
        for _, y in ipairs(C.verticalVelocityHistory) do sum = sum + y end
        return sum / #C.verticalVelocityHistory
    end

    local function detectMultiJump(currentYVel)
        local t = tick()
        if C.lastYVelocity < -5 and currentYVel > CFG.UPWARD_VELOCITY_RESET_THRESHOLD then
            if t - C.lastJumpTime < CFG.MULTI_JUMP_DETECTION_WINDOW then
                return true
            end
            C.lastJumpTime = t
            return true
        end
        return false
    end

    local function isFallingFromHeight(currentPos, yVel)
        return (currentPos.Y - C.groundHeight > CFG.HIGH_JUMP_THRESHOLD) and yVel < CFG.FALLING_SPEED_THRESHOLD
    end

    local function isAerialStrafing()
        if #C.aerialVelocityHistory < 3 then return false end
        local dc = 0
        for i = 2, #C.aerialVelocityHistory do
            local v1 = Vector3.new(C.aerialVelocityHistory[i-1].X, 0, C.aerialVelocityHistory[i-1].Z)
            local v2 = Vector3.new(C.aerialVelocityHistory[i].X, 0, C.aerialVelocityHistory[i].Z)
            if v1.Magnitude > 3 and v2.Magnitude > 3 then
                if v1.Unit:Dot(v2.Unit) < CFG.STRAFE_DETECTION_THRESHOLD then
                    dc = dc + 1
                end
            end
        end
        return dc >= 2
    end

    local function detectDirectionChange(currentVel)
        local horizontal = Vector3.new(currentVel.X, 0, currentVel.Z)
        if horizontal.Magnitude < 5 then return false end
        if C.previousDirection then
            local dot = C.previousDirection:Dot(horizontal.Unit)
            if dot < 0.5 then
                local t = tick()
                if t - C.lastDirectionChangeTime < CFG.DIRECTION_CHANGE_DETECTION_TIME then
                    C.previousDirection = horizontal.Unit
                    C.lastDirectionChangeTime = t
                    return true
                end
                C.lastDirectionChangeTime = t
            end
        end
        C.previousDirection = horizontal.Unit
        return false
    end

    local function isErraticMovement()
        if #C.velocityHistory < 3 then return false end
        local changes = 0
        for i = 2, #C.velocityHistory do
            local v1 = Vector3.new(C.velocityHistory[i-1].X, 0, C.velocityHistory[i-1].Z)
            local v2 = Vector3.new(C.velocityHistory[i].X, 0, C.velocityHistory[i].Z)
            if v1.Magnitude > 5 and v2.Magnitude > 5 then
                if v1.Unit:Dot(v2.Unit) < 0.3 then
                    changes = changes + 1
                end
            end
        end
        return changes >= CFG.ERRATIC_MOVEMENT_THRESHOLD
    end

    local function isInfiniteJumping()
        if #C.velocityHistory < 3 then return false end
        local yc = 0
        for i = 2, #C.velocityHistory do
            if math.abs(C.velocityHistory[i].Y - C.velocityHistory[i-1].Y) > 15 then
                yc = yc + 1
            end
        end
        return yc >= 2
    end

    local function isJumpBoostCheat()
        return math.abs(C.targetVelocity.Y) > CFG.JUMPBOOST_Y_THRESHOLD and C.highYVelocityTime > CFG.JUMPBOOST_SUSTAINED_TIME
    end

    local function isExtremeJumpBoost()
        return math.abs(C.targetVelocity.Y) > CFG.EXTREME_JUMPBOOST_THRESHOLD
    end

    local function isFloating()
        return C.airborneTime > CFG.AIRBORNE_THRESHOLD and math.abs(C.targetVelocity.Y) > CFG.FLOAT_Y_THRESHOLD
    end

    local function checkAirborne(targetRoot)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {C.targetPlayer.Character, LP.Character}
        local rayResult = workspace:Raycast(targetRoot.Position, Vector3.new(0, -100, 0), params)
        if rayResult then
            C.groundHeight = rayResult.Position.Y
            return false
        end
        return true
    end

    local function clampVelocityChange(newVel, oldVel, maxChange)
        local delta = newVel - oldVel
        if delta.Magnitude > maxChange then
            return oldVel + (delta.Unit * maxChange)
        end
        return newVel
    end

    local function smoothVelocity(current, target, alpha)
        return current:Lerp(target, alpha)
    end

    local function predictAerialPosition(currentPos, velocity, dt, isStrafing, isFastFalling, isMultiJump)
        local horizVel = Vector3.new(velocity.X, 0, velocity.Z)
        local vertVel = velocity.Y

        if isStrafing then
            local avgAerial = getAverageAerialVelocity()
            horizVel = Vector3.new(avgAerial.X, 0, avgAerial.Z) * CFG.AIR_CONTROL_FACTOR
        else
            horizVel = horizVel * CFG.AIR_CONTROL_FACTOR
        end
        horizVel = horizVel * CFG.AERIAL_VELOCITY_DECAY

        local gravityEffect = CFG.GRAVITY * CFG.GRAVITY_PREDICTION_WEIGHT
        if isMultiJump then
            gravityEffect = gravityEffect * 0.3
            vertVel = vertVel * 0.9
        end

        local verticalDisplacement
        if isFastFalling then
            verticalDisplacement = (vertVel * dt) - (0.5 * gravityEffect * 1.2 * dt * dt) - (CFG.FALLING_VERTICAL_LEAD * dt)
        else
            verticalDisplacement = (vertVel * dt) - (0.5 * gravityEffect * dt * dt)
        end

        if vertVel > CFG.RISING_THRESHOLD and not isMultiJump then
            verticalDisplacement = verticalDisplacement + (CFG.VERTICAL_POSITION_LEAD * dt)
        end

        return currentPos + horizVel * dt + Vector3.new(0, verticalDisplacement, 0)
    end

    local function predictServerPosition(currentPos, velocity, acceleration, ping, isQuickTurn, isAerial, isStrafing, isFastFalling, isMultiJump)
        local serverDelay = ping + CFG.SERVER_TICKRATE
        if isQuickTurn then
            serverDelay = serverDelay * CFG.QUICK_DIRECTION_CHANGE_MULTIPLIER
        end
        if isAerial then
            return predictAerialPosition(currentPos, velocity, serverDelay, isStrafing, isFastFalling, isMultiJump)
        end
        local predictedPos = currentPos + velocity * serverDelay
        if acceleration.Magnitude > 1 then
            predictedPos = predictedPos + (acceleration * CFG.ACCELERATION_PREDICTION_WEIGHT) * (serverDelay * serverDelay * 0.5)
        end
        return predictedPos
    end

    local function createPredictionSphere()
        if C.predictionSphere then C.predictionSphere:Destroy() end
        C.predictionSphere = Instance.new("Part")
        C.predictionSphere.Name = "PredictionSphere"
        C.predictionSphere.Shape = Enum.PartType.Ball
        C.predictionSphere.Size = Vector3.new(2, 2, 2)
        C.predictionSphere.Anchored = true
        C.predictionSphere.CanCollide = false
        C.predictionSphere.Material = Enum.Material.Neon
        C.predictionSphere.Color = Color3.fromRGB(0, 190, 255)
        C.predictionSphere.Transparency = 0.4

        local light = Instance.new("PointLight")
        light.Color = Color3.fromRGB(0, 190, 255)
        light.Range = 8
        light.Brightness = 2
        light.Parent = C.predictionSphere

        local outline = Instance.new("Highlight")
        outline.FillTransparency = 1
        outline.OutlineColor = Color3.fromRGB(120, 220, 255)
        outline.OutlineTransparency = 0
        outline.Parent = C.predictionSphere

        C.predictionSphere.Parent = workspace
        return C.predictionSphere
    end

    local function updatePredictionSphere(targetPosition, dt)
        if not C.predictionSphere then return end
        local alpha = math.min(1, dt * CFG.SPHERE_SMOOTH_SPEED)
        C.predictionSphere.CFrame = C.predictionSphere.CFrame:Lerp(CFrame.new(targetPosition), alpha)
    end

    local function updateRotationAngular(lookDirection, rootPart)
        if not rootPart or lookDirection.Magnitude < 0.01 then return end
        local currentLook = rootPart.CFrame.LookVector
        local targetDir = lookDirection.Unit
        local axis = currentLook:Cross(targetDir)
        local angle = math.asin(math.clamp(axis.Magnitude, -1, 1))
        if axis.Magnitude > 0.01 then
            rootPart.AssemblyAngularVelocity = axis.Unit * angle * 80
        else
            rootPart.AssemblyAngularVelocity = Vector3.zero
        end
    end

    local function startFollowing(char)
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then return end

        humanoid.AutoRotate = false
        if not C.predictionSphere then createPredictionSphere() end

        if Conns.circle then Conns.circle:Disconnect() end

        Conns.circle = RunService.RenderStepped:Connect(function(dt)
            if not autoBatEnabled then
                if Conns.circle then
                    Conns.circle:Disconnect()
                    Conns.circle = nil
                end
                return
            end

            C.targetPlayer = getNearestPlayer()
            if not C.targetPlayer or not C.targetPlayer.Character then
                if C.predictionSphere then C.predictionSphere.Transparency = 1 end
                C.targetPlayer = nil
                C.lastTargetPos = nil
                C.targetVelocity = Vector3.zero
                C.smoothedVelocity = Vector3.zero
                C.velocityHistory = {}
                C.accelerationHistory = {}
                C.aerialVelocityHistory = {}
                C.verticalVelocityHistory = {}
                C.aerialSmoothVelocity = Vector3.zero
                C.airborneTime = 0
                C.highYVelocityTime = 0
                C.previousDirection = nil
                C.wasAirborne = false
                C.lastYVelocity = 0
                C.peakHeight = 0
                C.isMultiJumping = false
                pcall(function()
                    local rp = rootPart
                    if rp and rp.Parent then
                        local v = rp.AssemblyLinearVelocity
                        rp.AssemblyLinearVelocity = Vector3.new(v.X * 0.15, v.Y, v.Z * 0.15)
                        rp.AssemblyAngularVelocity = Vector3.zero
                    end
                end)
                return
            end

            local targetRoot = C.targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not targetRoot then
                if C.predictionSphere then C.predictionSphere.Transparency = 1 end
                return
            end

            if C.predictionSphere then C.predictionSphere.Transparency = 0.4 end

            local tool = getCircleCombatTool(char)
            if tool and tool.Parent ~= char then
                pcall(function() humanoid:EquipTool(tool) end)
            end

            local targetPos = targetRoot.Position
            local myPos = rootPart.Position

            if C.lastTargetPos then
                local deltaPos = targetPos - C.lastTargetPos
                local rawVelocity = deltaPos / dt
                rawVelocity = clampVelocityChange(rawVelocity, C.targetVelocity, CFG.MAX_VELOCITY_CHANGE)

                local horizontalVel = Vector3.new(rawVelocity.X, 0, rawVelocity.Z)
                if horizontalVel.Magnitude > CFG.MAX_HORIZONTAL_VELOCITY then
                    horizontalVel = horizontalVel.Unit * CFG.MAX_HORIZONTAL_VELOCITY
                    rawVelocity = Vector3.new(horizontalVel.X, rawVelocity.Y, horizontalVel.Z)
                end

                local currentAcceleration = (rawVelocity - C.targetVelocity) / dt
                table.insert(C.accelerationHistory, currentAcceleration)
                if #C.accelerationHistory > C.MAX_ACCEL_HISTORY then table.remove(C.accelerationHistory, 1) end

                table.insert(C.verticalVelocityHistory, rawVelocity.Y)
                if #C.verticalVelocityHistory > C.MAX_VERTICAL_HISTORY then table.remove(C.verticalVelocityHistory, 1) end

                C.targetVelocity = rawVelocity
                C.smoothedVelocity = smoothVelocity(C.smoothedVelocity, C.targetVelocity, CFG.VELOCITY_SMOOTHING)

                table.insert(C.velocityHistory, C.targetVelocity)
                if #C.velocityHistory > C.MAX_HISTORY then table.remove(C.velocityHistory, 1) end
            end
            C.lastTargetPos = targetPos

            if math.abs(C.targetVelocity.Y) > CFG.JUMPBOOST_Y_THRESHOLD then
                C.highYVelocityTime = C.highYVelocityTime + dt
            else
                C.highYVelocityTime = 0
            end

            local isAirborne = checkAirborne(targetRoot)
            if isAirborne then
                C.airborneTime = C.airborneTime + dt
                if targetPos.Y > C.peakHeight then C.peakHeight = targetPos.Y end
                if C.airborneTime >= CFG.MIN_AIRBORNE_TIME then
                    table.insert(C.aerialVelocityHistory, C.targetVelocity)
                    if #C.aerialVelocityHistory > C.MAX_AERIAL_HISTORY then table.remove(C.aerialVelocityHistory, 1) end
                    C.aerialSmoothVelocity = smoothVelocity(C.aerialSmoothVelocity, C.targetVelocity, CFG.AERIAL_SMOOTHING)
                end
                C.wasAirborne = true
            else
                C.airborneTime = 0
                C.wasAirborne = false
                C.aerialVelocityHistory = {}
                C.aerialSmoothVelocity = Vector3.zero
                C.lastGroundedPosition = targetPos
                C.peakHeight = 0
            end

            local isJumping = math.abs(C.targetVelocity.Y) > CFG.JUMP_THRESHOLD
            local isInfJump = isInfiniteJumping()
            local isFloater = isFloating()
            local isJumpBoost = isJumpBoostCheat()
            local isExtremeBoost = isExtremeJumpBoost()
            local isErratic = isErraticMovement()
            local avgVelocity = getAverageVelocity()
            local avgAcceleration = getAverageAcceleration()
            local isQuickTurn = detectDirectionChange(C.targetVelocity)
            local isStrafing = isAerialStrafing()
            local isTrulyAirborne = isAirborne and C.airborneTime >= CFG.MIN_AIRBORNE_TIME
            local wasRising = C.lastYVelocity > CFG.RISING_THRESHOLD
            C.isMultiJumping = detectMultiJump(C.targetVelocity.Y)
            local isFastFalling = isFallingFromHeight(targetPos, C.targetVelocity.Y)
            local avgYVel = getAverageVerticalVelocity()
            C.lastYVelocity = C.targetVelocity.Y

            local predictionVel = C.targetVelocity
            local predictionAccel = avgAcceleration
            local useCurrentPos = false

            if isExtremeBoost then
                useCurrentPos = true
                predictionVel = Vector3.new(avgVelocity.X, 0, avgVelocity.Z)
                predictionAccel = Vector3.zero
            elseif isJumpBoost then
                local avgH = Vector3.new(avgVelocity.X, 0, avgVelocity.Z)
                predictionVel = Vector3.new(avgH.X, C.targetVelocity.Y * 0.15, avgH.Z)
                predictionAccel = Vector3.new(avgAcceleration.X, 0, avgAcceleration.Z)
            elseif isInfJump or isFloater then
                local avgH = Vector3.new(avgVelocity.X, 0, avgVelocity.Z)
                predictionVel = Vector3.new(avgH.X, C.targetVelocity.Y * 0.5, avgH.Z)
                predictionAccel = Vector3.new(avgAcceleration.X * 0.5, 0, avgAcceleration.Z * 0.5)
            elseif isTrulyAirborne and isStrafing then
                local avgAerial = getAverageAerialVelocity()
                predictionVel = Vector3.new(
                    C.aerialSmoothVelocity.X * CFG.AERIAL_DIRECTION_CHANGE_WEIGHT + avgAerial.X * (1 - CFG.AERIAL_DIRECTION_CHANGE_WEIGHT),
                    avgYVel,
                    C.aerialSmoothVelocity.Z * CFG.AERIAL_DIRECTION_CHANGE_WEIGHT + avgAerial.Z * (1 - CFG.AERIAL_DIRECTION_CHANGE_WEIGHT)
                )
                predictionAccel = Vector3.new(avgAcceleration.X * 0.3, 0, avgAcceleration.Z * 0.3)
            elseif isTrulyAirborne then
                predictionVel = Vector3.new(C.aerialSmoothVelocity.X, avgYVel, C.aerialSmoothVelocity.Z)
                predictionAccel = Vector3.zero
            elseif isErratic then
                predictionVel = Vector3.new(C.smoothedVelocity.X, C.targetVelocity.Y, C.smoothedVelocity.Z)
                predictionAccel = Vector3.new(avgAcceleration.X * 0.7, 0, avgAcceleration.Z * 0.7)
            end

            local serverPredictedPos
            if useCurrentPos then
                serverPredictedPos = targetPos
            else
                serverPredictedPos = predictServerPosition(
                    targetPos, predictionVel, predictionAccel, C.currentPing,
                    isQuickTurn, isTrulyAirborne, isStrafing, isFastFalling, C.isMultiJumping
                )
            end

            local predTime = CFG.PREDICTION_TIME * 1.1
            if isErratic then
                predTime = predTime * 0.6
            elseif isQuickTurn then
                predTime = predTime * 1.2
            elseif isTrulyAirborne and isStrafing then
                predTime = predTime * 0.7
            elseif isTrulyAirborne and isFastFalling then
                predTime = predTime * 1.3
            elseif isTrulyAirborne then
                predTime = predTime * 0.85
            end

            local predictedPos
            if isTrulyAirborne then
                predictedPos = predictAerialPosition(serverPredictedPos, predictionVel, predTime, isStrafing, isFastFalling, C.isMultiJumping)
            else
                predictedPos = serverPredictedPos + predictionVel * predTime
            end

            local verticalOffset = Vector3.zero
            if not isTrulyAirborne and not isExtremeBoost and not isJumpBoost and not isInfJump then
                if C.targetVelocity.Y < CFG.FALLING_THRESHOLD then
                    verticalOffset = Vector3.new(0, C.targetVelocity.Y * CFG.VERTICAL_OFFSET_MULTIPLIER, 0)
                elseif C.targetVelocity.Y > CFG.RISING_THRESHOLD then
                    verticalOffset = Vector3.new(0, C.targetVelocity.Y * CFG.VERTICAL_OFFSET_MULTIPLIER, 0)
                end
            end
            predictedPos = predictedPos + verticalOffset

            local interceptOffset = Vector3.zero
            local horizontalVel = Vector3.new(predictionVel.X, 0, predictionVel.Z)
            if horizontalVel.Magnitude > 1 and not useCurrentPos then
                interceptOffset = horizontalVel.Unit * CFG.PREDICT_AHEAD
            end

            local bodyLowOffset = Vector3.new(0, -2.5, 0)
            local interceptPoint = predictedPos + interceptOffset + bodyLowOffset

            updatePredictionSphere(interceptPoint, dt)

            local toTarget = interceptPoint - myPos
            if toTarget.Magnitude > 0.1 then
                updateRotationAngular(toTarget, rootPart)
            end

            local actualDistance = (targetPos - myPos).Magnitude
            if actualDistance <= CFG.ACTIVATE_DISTANCE then
                local currentTime = tick()
                if currentTime - C.lastActivationTime >= 0.3 then
                    if useCurrentPos or (isErratic and not isTrulyAirborne) then
                        interceptPoint = serverPredictedPos
                    elseif isTrulyAirborne then
                        interceptPoint = predictAerialPosition(serverPredictedPos, predictionVel, CFG.ACTIVATION_DELAY, isStrafing, isFastFalling, C.isMultiJumping)
                    else
                        interceptPoint = serverPredictedPos + predictionVel * CFG.ACTIVATION_DELAY
                    end

                    local tool = getCircleCombatTool(char)
                    if tool then
                        if tool.Parent ~= char then
                            pcall(function() humanoid:EquipTool(tool) end)
                        end
                        pcall(function() tool:Activate() end)
                        local ev = tool:FindFirstChildWhichIsA("RemoteEvent")
                        if ev then
                            pcall(function() ev:FireServer() end)
                        end
                    end
                    C.lastActivationTime = currentTime
                end
            end

            local direction = interceptPoint - myPos
            if direction.Magnitude > CFG.MIN_FOLLOW_DISTANCE then
                local dirUnit = direction.Unit
                local baseSpd = tonumber(AIMBOT_SPEED) or CFG.FOLLOW_SPEED or 50
                local currentSpeed = baseSpd
                if isJumping then currentSpeed = currentSpeed * CFG.JUMP_SPEED_BOOST end
                if isExtremeBoost then
                    currentSpeed = currentSpeed * 1.3
                elseif isJumpBoost or isInfJump or isFloater then
                    currentSpeed = currentSpeed * 1.15
                end
                if isErratic then
                    currentSpeed = currentSpeed * 0.9
                elseif isQuickTurn then
                    currentSpeed = currentSpeed * 1.1
                elseif isTrulyAirborne and isStrafing then
                    currentSpeed = currentSpeed * 0.95
                elseif isTrulyAirborne and isFastFalling then
                    currentSpeed = currentSpeed * 1.15
                elseif isTrulyAirborne then
                    currentSpeed = currentSpeed * 1.05
                end
                currentSpeed = math.min(currentSpeed, baseSpd)
                rootPart.AssemblyLinearVelocity = dirUnit * currentSpeed
            else
                rootPart.AssemblyLinearVelocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y * 0.5, 0)
            end
        end)
    end

    local function recoverCharacterFromAimbot()
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            pcall(function()
                local y = root.AssemblyLinearVelocity.Y
                if y > 40 then y = 20 elseif y < -80 then y = -40 end
                root.AssemblyLinearVelocity = Vector3.new(0, y * 0.35, 0)
                root.AssemblyAngularVelocity = Vector3.zero
            end)
        end
        if hum then
            pcall(function()
                hum.AutoRotate = true
                hum.PlatformStand = false
                local st = hum:GetState()
                if st == Enum.HumanoidStateType.Physics
                    or st == Enum.HumanoidStateType.Ragdoll
                    or st == Enum.HumanoidStateType.FallingDown
                    or st == Enum.HumanoidStateType.Flying then
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    task.defer(function()
                        if hum and hum.Parent then
                            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                        end
                    end)
                end
            end)
        end
    end

    local function stopCircle()
        if Conns.circle then
            Conns.circle:Disconnect()
            Conns.circle = nil
        end
        if C.predictionSphere then
            pcall(function() C.predictionSphere:Destroy() end)
            C.predictionSphere = nil
        end
        recoverCharacterFromAimbot()
        task.defer(function()
            task.wait()
            recoverCharacterFromAimbot()
        end)
        C.targetPlayer = nil
        C.lastTargetPos = nil
        C.targetVelocity = Vector3.zero
        C.smoothedVelocity = Vector3.zero
        C.velocityHistory = {}
        C.accelerationHistory = {}
        C.aerialVelocityHistory = {}
        C.verticalVelocityHistory = {}
        C.aerialSmoothVelocity = Vector3.zero
        C.airborneTime = 0
        C.highYVelocityTime = 0
        C.previousDirection = nil
        C.wasAirborne = false
        C.lastYVelocity = 0
        C.peakHeight = 0
        C.groundHeight = 0
        C.isMultiJumping = false
        C.lastActivationTime = 0
    end

    startBatAimbotV2 = function()
        stopBatAimbotV2()
        if autoLeftEnabled then
            autoLeftEnabled = false
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if stopAutoLeft then stopAutoLeft() end
            if mobBtnRefs and mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
        end
        if autoRightEnabled then
            autoRightEnabled = false
            if autoRightSetVisual then autoRightSetVisual(false) end
            if stopAutoRight then stopAutoRight() end
            if mobBtnRefs and mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
        end
        autoBatEnabled = true
        local char = LP.Character
        if char then startFollowing(char) end
    end

    stopBatAimbotV2 = function()
        stopCircle()
        task.spawn(function()
            for _ = 1, 3 do
                task.wait(0.05)
                recoverCharacterFromAimbot()
            end
        end)
    end

    LP.CharacterAdded:Connect(function(char)
        if autoBatEnabled and aimbotMode ~= "Default" and aimbotMode ~= "Bypass" and aimbotMode ~= "Bypass V2" then
            task.wait(0.5)
            startFollowing(char)
        end
    end)
end

local VisibleAim = {
    on = false,
    conn = nil,
    safety = nil,
    sphere = nil,
    ang = nil,
    intended = Vector3.zero,
}

local function _vaNet(root)
    if not root then return end
    pcall(function()
        if root.SetNetworkOwner then
            root:SetNetworkOwner(LP)
        end
    end)
    if type(sethiddenproperty) == "function" then
        pcall(sethiddenproperty, root, "NetworkIsSleeping", false)
    end
end

local function _vaAng(root)
    if VisibleAim.ang and VisibleAim.ang.Parent then return VisibleAim.ang end
    pcall(function()
        if VisibleAim.ang then VisibleAim.ang:Destroy() end
    end)
    local att = root:FindFirstChild("VisibleAimAtt")
    if not att then
        att = Instance.new("Attachment")
        att.Name = "VisibleAimAtt"
        att.Parent = root
    end
    local av = Instance.new("AngularVelocity")
    av.Name = "VisibleAimAV"
    av.Attachment0 = att
    av.RelativeTo = Enum.ActuatorRelativeTo.World
    av.MaxTorque = 1e6
    av.AngularVelocity = Vector3.zero
    av.Parent = root
    VisibleAim.ang = av
    return av
end

local function _vaDestroySphere()
    if VisibleAim.sphere then
        pcall(function() VisibleAim.sphere:Destroy() end)
        VisibleAim.sphere = nil
    end
end

local function _vaEnsureSphere()
    if VisibleAim.sphere and VisibleAim.sphere.Parent then return VisibleAim.sphere end
    _vaDestroySphere()
    local p = Instance.new("Part")
    p.Name = "VisibleAimCircle"
    p.Shape = Enum.PartType.Ball
    p.Size = Vector3.new(2.2, 2.2, 2.2)
    p.Color = Color3.fromRGB(80, 180, 255)
    p.Material = Enum.Material.Neon
    p.Transparency = 0.25
    p.Anchored = true
    p.CanCollide = false
    p.CanQuery = false
    p.CanTouch = false
    p.CastShadow = false
    p.Parent = workspace
    VisibleAim.sphere = p
    return p
end

local function _vaClosest()
    local me = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not me then return nil, nil end
    local best, bestPlr, bestD = nil, nil, 1e9
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                local d = (root.Position - me.Position).Magnitude
                if d < bestD then
                    bestD, best, bestPlr = d, root, plr
                end
            end
        end
    end
    return best, bestPlr
end

startBatAimbot = function()
    pcall(function() if stopBatAimbotV2 then stopBatAimbotV2() end end)
    pcall(function() if StopBatAimbot then StopBatAimbot() end end)
    pcall(function() if StopAntiBatBypassLock then StopAntiBatBypassLock() end end)
    if VisibleAim.conn then pcall(function() VisibleAim.conn:Disconnect() end) VisibleAim.conn = nil end
    if VisibleAim.safety then pcall(function() VisibleAim.safety:Disconnect() end) VisibleAim.safety = nil end

    VisibleAim.on = true
    autoBatEnabled = true
    batAimbotEnabled = true
    VisibleAim.intended = Vector3.zero
    VisibleAim._nextSwingAt = 0
    VisibleAim._bb = {
        lastTargetPos = nil,
        targetVelocity = Vector3.zero,
        lastActivationTime = 0,
    }
    VisibleAim._predData = VisibleAim._predData or {}
    pcall(function() if stopCircle then stopCircle() end end)
    pcall(_vaDestroySphere)
    pcall(aimEquipBat)

    local isBypass = (aimbotMode == "Bypass")
    local isBypassV2 = (aimbotMode == "Bypass V2")
    local baseSpeed = tonumber(AIMBOT_SPEED) or 58

    -- Batman predicted aimbot config (DEFAULT)
    local ZCFG = {
        FOLLOW_SPEED = baseSpeed,
        ACTIVATE_DISTANCE = 13,
        MIN_FOLLOW_DISTANCE = 1,
        PREDICTION_TIME = 0.22,
        PREDICT_AHEAD = 3,
        MAX_VELOCITY_CHANGE = 150,
        SERVER_TICKRATE = 1/60,
        MIN_PING = 0.03,
        MAX_PING = 0.25,
        GRAVITY = 196.2,
    }

    VisibleAim.conn = RunService.RenderStepped:Connect(function(dt)
        if not VisibleAim.on or not autoBatEnabled then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        if not char:FindFirstChildOfClass("Tool") then pcall(aimEquipBat) end
        hum.AutoRotate = false

        local target = _vaClosest()
        if not target then
            hum.AutoRotate = true
            root.AssemblyAngularVelocity = Vector3.zero
            VisibleAim._bb.lastTargetPos = nil
            return
        end

        local me, them = root.Position, target.Position
        local spd = tonumber(AIMBOT_SPEED) or baseSpeed
        ZCFG.FOLLOW_SPEED = spd

        if isBypassV2 then
            -- ===== Bypass V2: Ambitious Bat Aimbot V1 + BYPASS chase =====
            local myPos = me
            local targetPos = them
            local direction = targetPos - myPos
            local flatDir = Vector3.new(direction.X, 0, direction.Z)
            if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = Vector3.zero end

            local chaseSpeed = spd
            -- BYPASS mode height (same as Ambitious V1 BYPASS chase)
            local desiredHeight = targetPos.Y + 3.7
            local yVel = (desiredHeight - myPos.Y) * 19.5
            if hum.FloorMaterial ~= Enum.Material.Air then
                yVel = math.max(yVel, 13)
            end
            yVel = math.clamp(yVel, -70, 110)

            local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
            -- BYPASS-style smooth chase
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
            VisibleAim.intended = desiredVel

            local toTarget = targetPos - myPos
            if toTarget.Magnitude > 0.1 then
                local goalCF = CFrame.lookAt(myPos, targetPos)
                local diffCF = root.CFrame:Inverse() * goalCF
                local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
                root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(
                    math.clamp(rx, -2.5, 2.5) * 42,
                    math.clamp(ry, -2.5, 2.5) * 42,
                    math.clamp(rz, -2.5, 2.5) * 42
                ))
            end

            -- Swing when close (Ambitious-style)
            local dist = (root.Position - them).Magnitude
            if dist <= 8 and autoSwingEnabled ~= false then
                local now = os.clock()
                if now >= (VisibleAim._nextSwingAt or 0) then
                    VisibleAim._nextSwingAt = now + 0.08
                    pcall(function()
                        if swingCurrentBat then swingCurrentBat(char)
                        else
                            local bat = char:FindFirstChildOfClass("Tool")
                            if bat then bat:Activate() end
                        end
                    end)
                end
            end
        elseif not isBypass then
            -- DEFAULT: Batman Hub full predicted bat aimbot
            local Z = VisibleAim._bb
            Z.velocityHistory = Z.velocityHistory or {}
            Z.accelerationHistory = Z.accelerationHistory or {}
            local safeDt = math.max(dt or 1/60, 1/240)
            local targetPos = them
            local rawVelocity = Vector3.zero
            if Z.lastTargetPos then
                rawVelocity = (targetPos - Z.lastTargetPos) / safeDt
                local velocityDelta = rawVelocity - (Z.targetVelocity or Vector3.zero)
                if velocityDelta.Magnitude > 150 then
                    rawVelocity = (Z.targetVelocity or Vector3.zero) + velocityDelta.Unit * 150
                end
            end
            Z.lastTargetPos = targetPos
            -- smooth velocity
            local prev = Z.targetVelocity or Vector3.zero
            Z.targetVelocity = prev:Lerp(rawVelocity, 0.2)
            table.insert(Z.velocityHistory, Z.targetVelocity)
            if #Z.velocityHistory > 5 then table.remove(Z.velocityHistory, 1) end
            if Z.lastSmoothed then
                local accel = (Z.targetVelocity - Z.lastSmoothed) / safeDt
                table.insert(Z.accelerationHistory, accel)
                if #Z.accelerationHistory > 4 then table.remove(Z.accelerationHistory, 1) end
            end
            Z.lastSmoothed = Z.targetVelocity

            local avgAccel = Vector3.zero
            if #Z.accelerationHistory > 0 then
                for _, a in ipairs(Z.accelerationHistory) do avgAccel = avgAccel + a end
                avgAccel = avgAccel / #Z.accelerationHistory
            end

            local ping = math.clamp(0.08, 0.03, 0.25)
            local serverDelay = ping + (1/60)
            local predictionVelocity = Z.targetVelocity
            local predicted = targetPos + predictionVelocity * serverDelay
            predicted = predicted + avgAccel * 0.3 * (serverDelay * serverDelay * 0.5)
            local predictionTime = 0.22 * 1.1
            local th = target.Parent and target.Parent:FindFirstChildOfClass("Humanoid")
            local airborne = th and th.FloorMaterial == Enum.Material.Air
            if airborne then
                predicted = predicted + predictionVelocity * predictionTime
                predicted = predicted + Vector3.new(0, -0.5 * 196.2 * predictionTime * predictionTime, 0)
            else
                predicted = predicted + predictionVelocity * predictionTime
            end
            local flatPrediction = Vector3.new(predictionVelocity.X, 0, predictionVelocity.Z)
            if flatPrediction.Magnitude > 1 then
                predicted = predicted + flatPrediction.Unit * 3
            end

            local toTarget = predicted - me
            if toTarget.Magnitude > 0.01 then
                local axis = root.CFrame.LookVector:Cross(toTarget.Unit)
                local angle = math.asin(math.clamp(axis.Magnitude, -1, 1))
                if axis.Magnitude > 0.01 then
                    root.AssemblyAngularVelocity = axis.Unit * angle * 80
                else
                    root.AssemblyAngularVelocity = Vector3.zero
                end
            end

            if (them - me).Magnitude <= 13 and tick() - (Z.lastActivationTime or 0) >= 0.3 then
                Z.lastActivationTime = tick()
                pcall(function()
                    local bat = char:FindFirstChildOfClass("Tool")
                    if bat then bat:Activate()
                    elseif swingCurrentBat then swingCurrentBat(char) end
                end)
            end

            if toTarget.Magnitude > 1 then
                local speed = math.clamp(spd, 1, 120)
                local desired = toTarget.Unit * speed
                root.AssemblyLinearVelocity = desired
                VisibleAim.intended = desired
            else
                local y = root.AssemblyLinearVelocity.Y * 0.5
                root.AssemblyLinearVelocity = Vector3.new(0, y, 0)
                VisibleAim.intended = Vector3.new(0, y, 0)
            end
        else
            -- BYPASS: Vision Hub AntiBatBypass
            local function visionPredictVel(rootPart)
                if not rootPart then return Vector3.zero end
                local now = tick()
                local data = VisibleAim._predData[rootPart]
                if not data then
                    VisibleAim._predData[rootPart] = { pos = rootPart.Position, time = now, vel = Vector3.zero }
                    return Vector3.zero
                end
                local ddt = math.clamp(now - data.time, 1/120, 0.25)
                local raw = (rootPart.Position - data.pos) / ddt
                if raw.Magnitude > 80 then raw = raw.Unit * 80 end
                data.vel = data.vel:Lerp(raw, 0.25)
                data.pos = rootPart.Position
                data.time = now
                return data.vel
            end
            local V_VERT, V_DIST, V_HEIGHT, V_OFF, V_TURN, V_MAX = 52, -2.8, 4.75, 1, 285, 28
            local tVel = visionPredictVel(target)
            local aimPos = them + tVel * math.clamp(tVel.Magnitude / 130, 0.05, 0.12) + Vector3.new(0, V_OFF, 0)
            local toAim = aimPos - me
            local flat = Vector3.new(toAim.X, 0, toAim.Z)
            if toAim.Magnitude > 0.01 and flat.Magnitude > 0.01 then
                local yawErr = (math.deg(math.atan2(-flat.X, -flat.Z)) - root.Orientation.Y + 180) % 360 - 180
                local pitchErr = (math.deg(math.atan2(toAim.Y, flat.Magnitude)) - root.Orientation.X + 180) % 360 - 180
                local yawRate = math.clamp(math.rad(yawErr) * V_TURN, -V_MAX, V_MAX)
                local pitchRate = math.clamp(math.rad(pitchErr) * V_TURN, -V_MAX, V_MAX)
                local yawRad = math.rad(root.Orientation.Y)
                local forward = Vector3.new(math.cos(yawRad), 0, -math.sin(yawRad))
                root.AssemblyAngularVelocity = Vector3.new(0, yawRate, 0) + forward * pitchRate
            else
                root.AssemblyAngularVelocity = Vector3.zero
            end
            local unit = toAim.Magnitude > 0.01 and toAim.Unit or Vector3.zero
            local offsetTarget = aimPos - unit * V_DIST + Vector3.new(0, V_HEIGHT, 0) - me
            local horiz = Vector3.new(offsetTarget.X, 0, offsetTarget.Z)
            local move = horiz.Magnitude > 0.1 and horiz.Unit * spd or Vector3.zero
            local vert = math.abs(offsetTarget.Y) > 0.1 and Vector3.new(0, math.sign(offsetTarget.Y) * V_VERT, 0) or Vector3.new(0, -2, 0)
            local desired = move + vert
            root.AssemblyLinearVelocity = desired
            VisibleAim.intended = desired
            if horiz.Magnitude > 0.5 then pcall(function() hum:Move(horiz.Unit, false) end) end
            if (root.Position - them).Magnitude <= 8 then
                local now = os.clock()
                if now >= (VisibleAim._nextSwingAt or 0) then
                    VisibleAim._nextSwingAt = now + 0.08
                    pcall(function()
                        if swingCurrentBat then swingCurrentBat(char)
                        else local bat = char:FindFirstChildOfClass("Tool"); if bat then bat:Activate() end end
                    end)
                end
            end
        end

        do
            local v = root.AssemblyLinearVelocity
            if math.abs(v.X) > 350 or math.abs(v.Z) > 350 then
                root.AssemblyLinearVelocity = VisibleAim.intended or Vector3.zero
            end
        end
    end)

    if setAimbotVisual then pcall(setAimbotVisual, true) end
    if setBatAimbotVisual then pcall(setBatAimbotVisual, true) end
    if autoBatSetVisual then pcall(autoBatSetVisual, true) end
    if mobBtnRefs and mobBtnRefs.autoBat then pcall(mobBtnRefs.autoBat, true) end
end
stopBatAimbot = function()
    VisibleAim.on = false
    autoBatEnabled = false
    batAimbotEnabled = false
    if VisibleAim.conn then pcall(function() VisibleAim.conn:Disconnect() end) VisibleAim.conn = nil end
    if VisibleAim.safety then pcall(function() VisibleAim.safety:Disconnect() end) VisibleAim.safety = nil end
    pcall(function() if stopCircle then stopCircle() end end)
    _vaDestroySphere()
    if VisibleAim.ang then
        pcall(function() VisibleAim.ang.AngularVelocity = Vector3.zero end)
        pcall(function() VisibleAim.ang:Destroy() end)
        VisibleAim.ang = nil
    end
    pcall(function() if stopBatAimbotV2 then stopBatAimbotV2() end end)
    pcall(function() if StopBatAimbot then StopBatAimbot() end end)
    pcall(function() if StopAntiBatBypassLock then StopAntiBatBypassLock() end end)
    local c = LP.Character
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if hum then pcall(function() hum.AutoRotate = true; hum.PlatformStand = false end) end
    if root then
        pcall(function()
            root.AssemblyAngularVelocity = Vector3.zero
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.3
        end)
    end
    if setAimbotVisual then pcall(setAimbotVisual, false) end
    if setBatAimbotVisual then pcall(setBatAimbotVisual, false) end
    if autoBatSetVisual then pcall(autoBatSetVisual, false) end
    if mobBtnRefs and mobBtnRefs.autoBat then pcall(mobBtnRefs.autoBat, false) end
end

saveConfig=function()
    local ok, err = pcall(function()
        local function ks(e)
            if type(e)~="table" then return {kb=nil,gp=nil} end
            local ok, res = pcall(function()
                if e.kb then return {kb=e.kb.Name,gp=e.gp and e.gp.Name}
                elseif e.gp then return {gp=e.gp.Name}
                else return {kb=nil,gp=nil} end
            end)
            if ok and type(res)=="table" then return res end
            return {kb=nil,gp=nil}
        end
        local btnPos = {}
        pcall(function() btnPos = loadBtnPositions() or {} end)
        local cfg = {
            normalSpeed=NS, carrySpeed=CS,
            dropBrainrotKey=ks(KB.DropBrainrot), autoLeftKey=ks(KB.AutoLeft), autoRightKey=ks(KB.AutoRight),
            autoBatKey=ks(KB.AutoBat), tpBatKey=ks(KB.TPBat), laggerToggleKey=ks(KB.LaggerToggle),
            laggerCarryKey=ks(KB.LaggerCarry), tpFloorKey=ks(KB.TPFloor), 
            guiHideKey=ks(KB.GuiHide), speedToggleKey=ks(KB.SpeedToggle), antiDesyncKey=ks(KB.AntiDesync),
            instantResetKey=ks(KB.InstantReset),
            grabRadius=Steal.StealRadius, stealDuration=Steal.StealDuration, stealMode=Steal.StealMode or "normal",
            autoGrabSetDelayRadius=autoGrabSetDelayRadius, autoGrabStopTime=autoGrabStopTime,
            autoGrabStopEnabled=autoGrabStopEnabled==true,
            antiRagdoll=antiRagdollEnabled==true,
            antiRagdollMode=antiRagdollMode or "V1",
            tpBatVersion=tpBatVersion or (_G._VisibleTPBat and _G._VisibleTPBat.version) or "V1",
            aimbotMode=aimbotMode or "Default",
            tpBatCameraLock=(_G._AmbitiousGetTPBatCameraLock and _G._AmbitiousGetTPBatCameraLock()) or (_G._VisibleTPBat and _G._VisibleTPBat.cameraLock) or false,
            antiFling=true,
            playerEsp=playerEspEnabled==true,
            autoStealEnabled=Steal.AutoStealEnabled==true,
            infiniteJump=InfJump.enabled==true, infJumpMode=InfJump.mode,
            medusaCounter=medusaCounterEnabled==true, batCounter=batCounterEnabled==true,
            carrySpeedActive=carrySpeedActive==true, laggerModeEnabled=laggerModeEnabled==true,
            laggerCarryActive=laggerCarryActive==true,
            laggerSpeed=LAGGER_SPEED, laggerCarrySpeed=LAGGER_CARRY_SPEED,
            autoBat=autoBatEnabled==true, aimbotSpeed=AIMBOT_SPEED,
            animPack=animPack,
            stealBarPos=stealBarPos,
            animPackEnabled=animPackEnabled==true,
            headlessEnabled=headlessEnabled==true,
            korbloxEnabled=korbloxEnabled==true,
            visibleAvatarEnabled=_G._VisibleAvatarPortEnabled or {},
            visibleAvatarSelected=_G._VisibleAvatarPortSelectedByCategory or {},
            autoSwing=autoSwingEnabled==true, unwalkEnabled=unwalkEnabled==true,
            antiLag=antiLagEnabled==true, antiDie=antiDieEnabled==true, antiBat=_G.AmbitiousAntiBatEnabled==true, antiBatV2SpeenEnabled=antiBatV2SpeenEnabled==true, antiBatV2SpeenSpeed=tonumber(antiBatV2SpeenSpeed) or 80, antiBatMode=antiBatMode or "V1", kawatanSkin=kawatanSkinEnabled==true, kawatanSkinColor=kawatanSkinColor or "PURPLE", kawatanBodyType=kawatanBodyType or "OFF", bodyLock=bodyLockEnabled==true, medusaStealDelay=medusaStealDelayEnabled~=false, e01Warning=e01WarningEnabled~=false, xraySuite=xraySuiteEnabled==true, batCounterMode=batCounterMode or "V1", stealStopPercent=SemiSteal.CONFIG.STOP_PERCENT, stealDelayRadius=SemiSteal.CONFIG.DELAY_RADIUS, autoTPEnabled=autoTPEnabled==true, autoTPHeight=autoTPHeight, mirrorTPDown=mirrorTPDownEnabled==true,
            guiTransparencyEnabled=guiTransparencyEnabled==true,
            mobileButtonsEnabled=mobileButtonsEnabled==true, mobileButtonsLocked=mobileButtonsLocked==true,
            uiLocked=uiLocked==true,
            mobileButtonsSize=mobileButtonsSize, stealBarScale=stealBarScale, circleButtonsEnabled=circleButtonsEnabled==true,
            antiKick=antiKickEnabled==true, safeMode=safeModeEnabled==true, fovValue=fovValue, perButtonDrag=true,
            skyTheme=currentSkyTheme, guiTheme=currentGuiTheme,
            autoMoveSwing=autoMoveSwingEnabled==true, autoMoveSwingInterval=autoMoveSwingInterval,
            ragdollGui=true, noCamCollision=noCamCollisionEnabled==true, introEnabled=introEnabled==true,
            selectedIntroMusic=selectedIntroMusic, btnPositions=btnPos,
            keepMusicEnabled=keepMusicEnabled==true,
            keepMusicIndex=keepMusicIndex or 1,
            autoSwitchSpeedEnabled = autoSwitchSpeedEnabled == true,
            tabLayoutMode = tabLayoutMode or "Top",
            speedCycleMode = speedCycleMode or "V1",
            uiScale = tonumber(uiScale) or 1,
            selectedBgId = (function()
                local id = nil
                pcall(function()
                    if getgenv and type(getgenv()._K7SelectedBgId) == "string" then id = getgenv()._K7SelectedBgId end
                end)
                if (not id or id == "" or id == "0") and type(_G._K7SelectedBgId) == "string" then id = _G._K7SelectedBgId end
                if not id or id == "" or id == "0" then id = "93489483341327" end
                return id
            end)(),
            bgOpacity = (function()
                local op = nil
                pcall(function()
                    if getgenv and type(getgenv()._K7BgOpacity) == "number" then op = getgenv()._K7BgOpacity end
                end)
                if type(op) ~= "number" and type(_G._K7BgOpacity) == "number" then op = _G._K7BgOpacity end
                if type(op) ~= "number" then op = 0.95 end
                return op
            end)(),
        }
        local encoded = HS:JSONEncode(cfg)
        local wrote = false
        pcall(function() writefile("k7duels.json", encoded); wrote = true end)
        pcall(function() writefile("K7DuelsConfig.json", encoded) end)
        pcall(function()
            if getgenv then
                getgenv()._K7DuelsCfg = cfg
                getgenv()._K7IntroEnabled = cfg.introEnabled
            end
        end)
    end)
end
task.spawn(function() while task.wait(5) do saveConfig() end end)

local function resetAllSettings()
    NS=60;CS=30;LAGGER_SPEED=15;LAGGER_CARRY_SPEED=24.5;carrySpeedActive=false;laggerModeEnabled=false;laggerCarryActive=false
    speedCycleMode="V1"
    antiRagdollEnabled=false
    antiRagdollMode="V1"
    InfJump.enabled=false;InfJump.mode="manual";InfJump:setMode("manual")
    medusaCounterEnabled=false;batCounterEnabled=false;unwalkEnabled=false
    autoLeftEnabled=false;autoRightEnabled=false;autoBatEnabled=false;autoSwingEnabled=true;autoMoveSwingEnabled=false
    autoTPEnabled=false;autoTPHeight=30;mirrorTPDownEnabled=false;antiLagEnabled=false;optimizerEnabled=false;optimizerMode="Ultra"
    Steal.AutoStealEnabled=false;Steal.StealRadius=70;Steal.StealDuration=1.3;Steal.StealRange=10
    autoGrabSetDelayRadius = 0;autoGrabStopTime = 1.1;autoGrabStopEnabled=false
    guiTransparencyEnabled=false;mobileButtonsEnabled=true;mobileButtonsSize=80;stealBarScale=1
    circleButtonsEnabled=false;antiKickEnabled=false;uiLocked=false;uiScale=0.80;fovValue=70;fovIndex=1
    stealBarPos=nil
    KB.DropBrainrot={kb=nil,gp=nil};KB.AutoLeft={kb=nil,gp=nil};KB.AutoRight={kb=nil,gp=nil}
    KB.AutoBat={kb=nil,gp=nil};KB.TPBat={kb=nil,gp=nil};KB.TPFloor={kb=nil,gp=nil}
    KB.GuiHide={kb=nil,gp=nil};KB.SpeedToggle={kb=nil,gp=nil};KB.LaggerToggle={kb=nil,gp=nil}
    KB.LaggerCarry={kb=nil,gp=nil};KB.AntiDesync={kb=nil,gp=nil};KB.LaggerPanel={kb=nil,gp=nil}
    if refreshSpeedModeLabel then refreshSpeedModeLabel() end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
    stopBatAimbot();stopAutoSteal();stopAutoLeft();stopAutoRight();stopAntiRagdoll();stopAutoTP();stopHoldInfJump()
    if antiLagEnabled then disableAntiLag() end
    if optimizerEnabled then disableOptimizer() end;saveConfig()
end

setInstaGrab,setInfJumpVisual,setAntiRagVisual,setMedusaVisual,setUnwalkVisual,setAntiLagVisual,setAutoSwingVisual=nil,nil,nil,nil,nil,nil,nil
setTranspVisual,setLockVisual,setMobLockVisual,setMobVisual,setCircleBtnsVisual=nil,nil,nil,nil,nil
normalBox,carryBox,laggerBox,laggerCarryBox,radInput,autoTPHeightBox,durationBox=nil,nil,nil,nil,nil,nil,nil
delayRadBox=nil;stopTimeBox=nil
mainFrame=nil
mainGuiRef=nil
_persistentConns={}
local function trackConn(conn) table.insert(_persistentConns,conn);return conn end
local function clearPersistentConns() for _,c in ipairs(_persistentConns) do pcall(function() c:Disconnect() end) end;_persistentConns={} end

refreshSpeedModeLabel=function()
    if modeValLbl then
        if laggerCarryActive or (laggerModeEnabled and carrySpeedActive) then modeValLbl.Text="Lagger Carry"
        elseif laggerModeEnabled then modeValLbl.Text="Lagger"
        elseif carrySpeedActive then modeValLbl.Text="Carry"
        else modeValLbl.Text="Normal" end
    end
    if laggerModePillRef and laggerModePillRef.pill and laggerModePillRef.dot then
        local pill=laggerModePillRef.pill;local dot=laggerModePillRef.dot;local on=laggerModeEnabled
        local th=(type(getTheme)=="function" and getTheme()) or {}
        local PINK2=th.ACCENT or Color3.fromRGB(0,190,255);local OFF=th.OFF or Color3.fromRGB(14,20,34);local GRAY=th.GRAY or Color3.fromRGB(120,155,205);local W=th.WHITE or Color3.fromRGB(228,240,255)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and W or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),BackgroundColor3=on and PINK2 or GRAY}):Play()
    end
    if carryModePillRef and carryModePillRef.pill and carryModePillRef.dot then
        local pill=carryModePillRef.pill;local dot=carryModePillRef.dot;local on=carrySpeedActive
        local th=(type(getTheme)=="function" and getTheme()) or {}
        local PINK2=th.ACCENT or Color3.fromRGB(0,190,255);local OFF=th.OFF or Color3.fromRGB(14,20,34);local GRAY=th.GRAY or Color3.fromRGB(120,155,205);local W=th.WHITE or Color3.fromRGB(228,240,255)
        TweenService:Create(pill,TweenInfo.new(0.16,Enum.EasingStyle.Quad),{BackgroundColor3=on and W or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),BackgroundColor3=on and PINK2 or GRAY}):Play()
    end
end
toggleCarryMode=function()
    if speedCycleMode == "V2" then
        laggerModeEnabled = false
        laggerCarryActive = false
        carrySpeedActive = not carrySpeedActive
    else
        carrySpeedActive = not carrySpeedActive
        if carrySpeedActive then laggerCarryActive = false end
    end
    refreshSpeedModeLabel()
    if mobBtnRefs and mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs and mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs and mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive or (laggerModeEnabled and carrySpeedActive)) end
    pcall(saveConfig)
end
toggleLaggerMode=function()
    if speedCycleMode == "V2" then
        if not laggerModeEnabled and not laggerCarryActive then
            laggerModeEnabled = true
            carrySpeedActive = false
            laggerCarryActive = false
        else
            laggerModeEnabled = true
            laggerCarryActive = false
            carrySpeedActive = not carrySpeedActive
        end
    else
        laggerModeEnabled = not laggerModeEnabled
        if laggerModeEnabled then laggerCarryActive = false end
    end
    refreshSpeedModeLabel()
    if mobBtnRefs and mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs and mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs and mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive or (laggerModeEnabled and carrySpeedActive)) end
    pcall(saveConfig)
end
toggleLaggerCarryMode=function()
    if speedCycleMode == "V2" then
        if (laggerModeEnabled and carrySpeedActive) or laggerCarryActive then
            laggerModeEnabled = false
            carrySpeedActive = false
            laggerCarryActive = false
        else
            laggerModeEnabled = true
            carrySpeedActive = true
            laggerCarryActive = false
        end
    else
        laggerCarryActive = not laggerCarryActive
        if laggerCarryActive then carrySpeedActive = false; laggerModeEnabled = false end
    end
    refreshSpeedModeLabel()
    if mobBtnRefs and mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs and mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs and mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive or (laggerModeEnabled and carrySpeedActive)) end
    pcall(saveConfig)
end

LP.CharacterAdded:Connect(function(char)
    task.defer(function()
        local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
        if not hum then return end
        pcall(function()
            hum.BreakJointsOnDeath = true
            hum.RequiresNeck = true
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
            local root = char:FindFirstChild("HumanoidRootPart")
            if root and sethiddenproperty then
                pcall(function() sethiddenproperty(root, "NetworkIsSleeping", false) end)
            end
        end)
    end)
end)

antiRagdollMode = (antiRagdollMode == "V2") and "V2" or "V1"

do
    local _arv = {
        Enabled = false,
        Connection = nil,
        CharConn = nil,
        NoSplatterCooldown = 0,
    }

    local function getChar()
        return LP.Character
    end

    local function getHumanoid(char)
        char = char or getChar()
        if not char then return nil end
        return char:FindFirstChildOfClass("Humanoid")
    end

    local function getRoot(char)
        char = char or getChar()
        if not char then return nil end
        return char:FindFirstChild("HumanoidRootPart")
    end

    local function isRagdollStateAR(hum)
        if not hum then return false end
        local st = hum:GetState()
        return hum.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
    end

    local function forceNoSplatterReset()
        local char = getChar()
        if not char then return end
        local hum  = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end

        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)

            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero

            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") then obj.Enabled = true end
                if obj:IsA("Constraint") then obj.Enabled = true end
            end

            if workspace.CurrentCamera then
                workspace.CurrentCamera.CameraSubject = hum
            end

            local PM = LP:FindFirstChild("PlayerScripts")
                and LP.PlayerScripts:FindFirstChild("PlayerModule")
            if PM then
                local cm = PM:FindFirstChild("ControlModule")
                if cm then
                    local ok, CM = pcall(require, cm)
                    if ok and CM and CM.Enable then
                        pcall(function() CM:Enable() end)
                    end
                end
            end

            hum.AutoRotate = true
            hum.PlatformStand = false
            hum.Sit = false
        end)
    end

    local function applySplatterReset(char, hum, root)
        if not char or not hum or not root then return end
        pcall(function()
            LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
        end)

        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BallSocketConstraint") then
                d:Destroy()
            elseif d:IsA("Attachment") and d.Name:find("RagdollAttachment") then
                d:Destroy()
            end
        end

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") and not obj.Enabled then
                obj.Enabled = true
            end
        end

        if hum.Health > 0 then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        end

        if workspace.CurrentCamera then
            workspace.CurrentCamera.CameraSubject = hum
        end

        root.Anchored = false
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end

    local function antiRagdollTick()
        if not _arv.Enabled or not antiRagdollEnabled then return end

        local char = getChar()
        if not char then return end
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end

        local root = char:FindFirstChild("HumanoidRootPart")
        local ragdolled = isRagdollStateAR(hum)

        if antiRagdollMode == "V2" then
            if ragdolled then
                local now = tick()
                if now - (_arv.NoSplatterCooldown or 0) > 0.15 then
                    _arv.NoSplatterCooldown = now
                    forceNoSplatterReset()
                end
            end
            return
        end

        if not root then return end

        local endTime = LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
            ragdolled = true
        end

        if ragdolled then
            applySplatterReset(char, hum, root)
        end
    end

    local function hookCharacter()
        if not antiRagdollEnabled then return end
        if _arv.Connection then
            _arv.Connection:Disconnect()
            _arv.Connection = nil
        end
        _arv.Connection = RunService.Heartbeat:Connect(antiRagdollTick)
    end

    startAntiRagdoll = function()
        if _arv.Connection and _arv.Enabled then return end
        _arv.Enabled = true
        antiRagdollEnabled = true
        _arv.NoSplatterCooldown = 0

        if _arv.Connection then
            _arv.Connection:Disconnect()
            _arv.Connection = nil
        end
        _arv.Connection = RunService.Heartbeat:Connect(antiRagdollTick)

        if _arv.CharConn then
            pcall(function() _arv.CharConn:Disconnect() end)
            _arv.CharConn = nil
        end
        _arv.CharConn = LP.CharacterAdded:Connect(function()
            task.wait(0.5)
            if antiRagdollEnabled then
                hookCharacter()
            end
        end)
    end

    stopAntiRagdoll = function()
        _arv.Enabled = false
        antiRagdollEnabled = false
        if _arv.Connection then
            _arv.Connection:Disconnect()
            _arv.Connection = nil
        end
        if _arv.CharConn then
            _arv.CharConn:Disconnect()
            _arv.CharConn = nil
        end
    end
end

startUnwalk=function()
    local c=LP.Character;if not c then return end;local hum=c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate");if anim then unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end
stopUnwalk=function() local c=LP.Character;if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c;unwalkSavedAnimate=nil end end

local ANTI_FLING_MAX_LIN = 160
local ANTI_FLING_MAX_ANG = 45
local _antiFlingConn = nil

local function _antiFlingApply(root, char, maxLin, maxAng)
    if not root or not root.Parent then return end
    pcall(function()
        local v = root.AssemblyLinearVelocity
        local horiz = Vector3.new(v.X, 0, v.Z)
        local hMag = horiz.Magnitude
        if hMag > maxLin then
            local scale = maxLin / hMag
            root.AssemblyLinearVelocity = Vector3.new(v.X * scale, v.Y, v.Z * scale)
        elseif v.Magnitude > maxLin * 1.35 then
            root.AssemblyLinearVelocity = v.Unit * maxLin
        end
        -- Speen Body needs high Y angular — do not zero it
        if not antiBatV2SpeenEnabled then
            local av = root.AssemblyAngularVelocity
            if av.Magnitude > maxAng then root.AssemblyAngularVelocity = Vector3.zero end
        end
        if char then
            for _, p in ipairs(char:GetChildren()) do
                if p:IsA("BasePart") and p ~= root then
                    local pv = p.AssemblyLinearVelocity
                    local ph = Vector3.new(pv.X, 0, pv.Z)
                    if ph.Magnitude > maxLin * 1.2 then
                        local scale = (maxLin * 1.05) / ph.Magnitude
                        p.AssemblyLinearVelocity = Vector3.new(pv.X * scale, pv.Y, pv.Z * scale)
                    end
                    if not antiBatV2SpeenEnabled and p.AssemblyAngularVelocity.Magnitude > maxAng then
                        p.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            end
        end
    end)
end

local function startAntiFling()
    if _antiFlingConn then return end
    _antiFlingConn = RunService.Heartbeat:Connect(function()
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local aimOn = autoBatEnabled
        local maxLin = aimOn and ANTI_FLING_AIMBOT_LIN or ANTI_FLING_MAX_LIN
        local maxAng = aimOn and ANTI_FLING_AIMBOT_ANG or ANTI_FLING_MAX_ANG
        _antiFlingApply(root, char, maxLin, maxAng)
    end)
end

task.spawn(function() task.wait(0.35); startAntiFling() end)
LP.CharacterAdded:Connect(function() task.defer(startAntiFling) end)

local _noPlayerColConn = nil
local _noPlayerColHB = nil
local function applyNoPlayerCollision()
    pcall(function()
        local function stripOther(char)
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then pcall(function() part.CanCollide = false end) end
            end
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then stripOther(plr.Character) end
        end
        if not _noPlayerColConn then
            _noPlayerColConn = Players.PlayerAdded:Connect(function(plr)
                plr.CharacterAdded:Connect(function(char) task.wait(0.15); stripOther(char) end)
                if plr.Character then stripOther(plr.Character) end
            end)
        end
        if not _noPlayerColHB then
            _noPlayerColHB = RunService.Heartbeat:Connect(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        for _, part in ipairs(plr.Character:GetChildren()) do
                            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                        end
                    end
                end
            end)
        end
    end)
end
task.spawn(function() task.wait(1); applyNoPlayerCollision() end)

-- ============================================================
-- K7 USER FINGERPRINT
-- ============================================================
do
local K7_MARKER = "K7DuelsMarker"
local _k7Users = {}
local K7_ZOOM_MAX = 127.89134
local K7_ZOOM_MIN = 0.41278
local K7_NAME_DIST = 101.337

local function markK7UserId(uid)
    if type(uid) == "number" and uid ~= LP.UserId then _k7Users[uid] = true end
end

local function applyK7Fingerprint()
    pcall(function()
        LP.CameraMaxZoomDistance = K7_ZOOM_MAX
        LP.CameraMinZoomDistance = K7_ZOOM_MIN
        LP.NameDisplayDistance = K7_NAME_DIST
    end)
    pcall(function()
        if getgenv then
            getgenv()._K7DuelsFP = "v2"
            getgenv()._K7DuelsRunning = true
        end
    end)
end

local function placeK7Marker(char)
    applyK7Fingerprint()
end

LP.CharacterAdded:Connect(function(char) task.wait(0.3); placeK7Marker(char) end)

local function _matchesK7FP(plr)
    if not plr then return false end
    local char = plr.Character
    if char then
        local marker = char:FindFirstChild(K7_MARKER, true)
        if marker then return true end
        local tag = char:FindFirstChild("K7DuelsTag", true)
        if tag then return true end
        local cAttrOk, cAttr = pcall(function() return char:GetAttribute("K7Duels") end)
        if cAttrOk and cAttr == true then return true end
    end
    local hits = 0
    local ok1, zmax = pcall(function() return plr.CameraMaxZoomDistance end)
    if ok1 and typeof(zmax) == "number" and math.abs(zmax - K7_ZOOM_MAX) < 0.002 then hits = hits + 1 end
    local ok2, zmin = pcall(function() return plr.CameraMinZoomDistance end)
    if ok2 and typeof(zmin) == "number" and math.abs(zmin - K7_ZOOM_MIN) < 0.002 then hits = hits + 1 end
    local ok3, nd = pcall(function() return plr.NameDisplayDistance end)
    if ok3 and typeof(nd) == "number" and math.abs(nd - K7_NAME_DIST) < 0.05 then hits = hits + 1 end
    if hits >= 2 then return true end
    if hits >= 1 and ok1 and typeof(zmax) == "number" and math.abs(zmax - K7_ZOOM_MAX) < 0.0005 then return true end
    local attrOk, attr = pcall(function() return plr:GetAttribute("K7Duels") end)
    if attrOk and attr == true then return true end
    local fpOk, fp = pcall(function() return plr:GetAttribute("K7FP") end)
    if fpOk and fp == "v2" then return true end
    return false
end

local function isK7User(plr)
    if not plr or plr == LP then return false end
    if _k7Users[plr.UserId] then return true end
    if _matchesK7FP(plr) then markK7UserId(plr.UserId); return true end
    return false
end

local _k7TagFolder = nil
local function ensureK7TagFolder()
    if _k7TagFolder and _k7TagFolder.Parent then return _k7TagFolder end
    local f = Instance.new("Folder")
    f.Name = "K7UserTags"
    local parented = false
    pcall(function() if parentGui then parentGui(f); parented = f.Parent ~= nil end end)
    if not parented then pcall(function() f.Parent = game:GetService("CoreGui") end) end
    if not f.Parent then pcall(function() f.Parent = LP:WaitForChild("PlayerGui") end) end
    _k7TagFolder = f
    return f
end
local _k7Billboards = {}
local function updateK7Tags()
    local folder = ensureK7TagFolder()
    local seen = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and isK7User(plr) then
            seen[plr] = true
            local char = plr.Character
            local head = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
            if head then
                local o = _k7Billboards[plr]
                if not o or not o.Parent then
                    pcall(function() if o then o:Destroy() end end)
                    local bb = Instance.new("BillboardGui")
                    bb.Name = "UsingK7_" .. tostring(plr.UserId)
                    bb.Size = UDim2.new(0, 220, 0, 36)
                    bb.StudsOffset = Vector3.new(0, 3.2, 0)
                    bb.AlwaysOnTop = true
                    bb.MaxDistance = 600
                    bb.Adornee = head
                    bb.Parent = folder
                    local lbl = Instance.new("TextLabel", bb)
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = "USING VISIBLE"
                    lbl.TextColor3 = Color3.fromRGB(0, 190, 255)
                    lbl.Font = Enum.Font.GothamBlack
                    lbl.TextSize = 18
                    lbl.TextStrokeTransparency = 0.15
                    lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
                    _k7Billboards[plr] = bb
                else
                    o.Adornee = head
                    o.Enabled = true
                end
            end
        end
    end
    for plr, bb in pairs(_k7Billboards) do
        if not seen[plr] then pcall(function() bb:Destroy() end); _k7Billboards[plr] = nil end
    end
end
task.spawn(function() while true do task.wait(0.75); pcall(updateK7Tags) end end)

task.spawn(function()
    applyK7Fingerprint()
    local acc = 0
    while true do
        RunService.Heartbeat:Wait()
        pcall(applyK7Fingerprint)
        acc = acc + 1
        if acc >= 30 then
            acc = 0
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP then
                    pcall(function() if _matchesK7FP(plr) then markK7UserId(plr.UserId) end end)
                end
            end
        end
    end
end)
end -- K7 USER FINGERPRINT

-- ============================================================
-- PLAYER ESP
-- ============================================================
do
    local PlayerESP = {
        enabled        = false,
        tracersEnabled = false,
        markerEnabled  = false,
        conns          = {},
        playerData     = {},
        tracerGui      = nil,
        tracerFrame    = nil,
        tracerState    = { scanElapsed = math.huge, targetRoot = nil },
        lastMarker     = nil,
        markerLocked   = false,
        markerTarget   = nil,
        markerSamples  = {},
    }

    local LP_MIN_X, LP_MAX_X = -536.2, -422
    local LP_MIN_Y, LP_MAX_Y = -10, 75
    local LP_MIN_Z, LP_MAX_Z = -71.8, 192.9
    local LP_GROUND_Y   = -7
    local LP_LOOKBACK   = 0.2

    local function _espAccent()
        local th = (type(getTheme) == "function" and getTheme()) or nil
        return (th and th.ACCENT) or Color3.fromRGB(0, 190, 255)
    end
    local function isInsideAllowedArea(pos)
        if not pos then return false end
        return pos.X >= LP_MIN_X and pos.X <= LP_MAX_X
            and pos.Y >= LP_MIN_Y and pos.Y <= LP_MAX_Y
            and pos.Z >= LP_MIN_Z and pos.Z <= LP_MAX_Z
    end
    local function finiteVector(v)
        return v ~= nil
            and v.X == v.X and v.Y == v.Y and v.Z == v.Z
            and math.abs(v.X) < 10000000
            and math.abs(v.Y) < 10000000
            and math.abs(v.Z) < 10000000
    end

    local espLoopConn = nil
    local espJoinConn = nil
    local espLeaveConn = nil

    local function _espParentGui()
        local parentGui
        local ok, robGui = pcall(function() return game:GetService("CoreGui"):FindFirstChild("RobloxGui") end)
        if ok and robGui then
            parentGui = robGui
        else
            parentGui = LP:FindFirstChildOfClass("PlayerGui")
        end
        if not parentGui then
            parentGui = game:GetService("CoreGui")
        end
        return parentGui
    end

    local function cleanupESPPlayer(plr)
        local d = PlayerESP.playerData[plr]
        if not d then return end
        pcall(function() if d.highlight then d.highlight:Destroy() end end)
        pcall(function() if d.nameTag then d.nameTag:Destroy() end end)
        if d.conns then for _, c in ipairs(d.conns) do pcall(function() c:Disconnect() end) end end
        PlayerESP.playerData[plr] = nil
    end

    local function createESPForPlayer(plr)
        if plr == LP then return end
        if PlayerESP.playerData[plr] then
            local d = PlayerESP.playerData[plr]
            if d.highlight then pcall(function() d.highlight.Enabled = PlayerESP.enabled end) end
            if d.nameTag then pcall(function() d.nameTag.Enabled = PlayerESP.enabled end) end
            return
        end
        cleanupESPPlayer(plr)

        local parentGui = _espParentGui()
        local accent = _espAccent()

        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = accent
        highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
        highlight.FillTransparency = 0.12
        highlight.OutlineTransparency = 0.18
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Enabled = PlayerESP.enabled
        pcall(function() highlight.Parent = parentGui end)

        local nameBillboard = Instance.new("BillboardGui")
        nameBillboard.Name = "ESP_Name"
        nameBillboard.Size = UDim2.new(0, 170, 0, 28)
        nameBillboard.StudsOffset = Vector3.new(0, 1.3, 0)
        nameBillboard.AlwaysOnTop = true
        nameBillboard.Enabled = PlayerESP.enabled
        nameBillboard.Parent = parentGui

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0, 170, 0, 28)
        nameLabel.AnchorPoint = Vector2.new(0.5, 0)
        nameLabel.Position = UDim2.new(0.5, 0, 0, 2)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = plr.Name or plr.DisplayName or ""
        nameLabel.TextColor3 = accent
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

        PlayerESP.playerData[plr] = {
            highlight = highlight,
            nameTag = nameBillboard,
            nameLabel = nameLabel,
            nameOutline = nameOutline,
        }
    end

    local function updateESPPlayer(plr)
        local d = PlayerESP.playerData[plr]
        if not d then return end

        if not PlayerESP.enabled then
            if d.highlight then d.highlight.Enabled = false end
            if d.nameTag then pcall(function() d.nameTag.Enabled = false end) end
            return
        end

        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local trackPart = char and (
            char:FindFirstChild("HumanoidRootPart")
            or char.PrimaryPart
            or char:FindFirstChild("UpperTorso")
            or char:FindFirstChild("Torso")
            or char:FindFirstChild("Head")
        )

        if (not d.highlight) or (not d.highlight.Parent) then
            PlayerESP.playerData[plr] = nil
            createESPForPlayer(plr)
            d = PlayerESP.playerData[plr]
            if not d then return end
        end
        if char and trackPart then
            local accent = _espAccent()
            if d.highlight then
                pcall(function()
                    d.highlight.Adornee = char
                    d.highlight.Enabled = true
                    d.highlight.FillColor = accent
                    d.highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
                end)
            end
            if d.nameTag and d.nameLabel then
                pcall(function()
                    d.nameTag.Adornee = trackPart
                    d.nameTag.Enabled = true
                    d.nameLabel.Text = plr.Name or plr.DisplayName or ""
                    d.nameLabel.TextColor3 = accent
                    d.nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    if d.nameOutline then
                        d.nameOutline.Color = Color3.fromRGB(0, 0, 0)
                    end
                end)
            end
        end
    end

    local function enableESP()
        if PlayerESP.enabled then return end
        PlayerESP.enabled = true
        playerEspEnabled = true

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then task.spawn(function() createESPForPlayer(plr) end) end
        end

        local acc = 0
        if espLoopConn then pcall(function() espLoopConn:Disconnect() end) end
        espLoopConn = RunService.Heartbeat:Connect(function(dt)
            if not PlayerESP.enabled then return end
            acc = acc + (dt or 0)
            if acc < 0.12 then return end
            acc = 0
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP then
                    if not PlayerESP.playerData[plr] then
                        pcall(function() createESPForPlayer(plr) end)
                    end
                    pcall(function() updateESPPlayer(plr) end)
                end
            end
        end)

        if espJoinConn then pcall(function() espJoinConn:Disconnect() end) end
        espJoinConn = Players.PlayerAdded:Connect(function(plr)
            if not PlayerESP.enabled or plr == LP then return end
            task.defer(function()
                if not PlayerESP.enabled then return end
                createESPForPlayer(plr)
                plr.CharacterAdded:Connect(function(char)
                    if not PlayerESP.enabled then return end
                    task.wait(0.15)
                    createESPForPlayer(plr)
                    updateESPPlayer(plr)
                end)
            end)
        end)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                pcall(function()
                    plr.CharacterAdded:Connect(function()
                        if not PlayerESP.enabled then return end
                        task.wait(0.15)
                        createESPForPlayer(plr)
                        updateESPPlayer(plr)
                    end)
                end)
            end
        end

        if espLeaveConn then pcall(function() espLeaveConn:Disconnect() end) end
        espLeaveConn = Players.PlayerRemoving:Connect(function(plr)
            cleanupESPPlayer(plr)
        end)
    end

    local function disableESP()
        PlayerESP.enabled = false
        playerEspEnabled = false
        if espLoopConn then pcall(function() espLoopConn:Disconnect() end); espLoopConn = nil end
        if espJoinConn then pcall(function() espJoinConn:Disconnect() end); espJoinConn = nil end
        if espLeaveConn then pcall(function() espLeaveConn:Disconnect() end); espLeaveConn = nil end
        for plr in pairs(PlayerESP.playerData) do
            if typeof(plr) == "Instance" and plr:IsA("Player") then
                cleanupESPPlayer(plr)
            end
        end
        PlayerESP.playerData = {}
    end

    function startPlayerEsp() enableESP() end
    function stopPlayerEsp()  disableESP() end

    do -- TRACER SECTION
    local function ensureTracerGui()
        if PlayerESP.tracerGui and PlayerESP.tracerGui.Parent then return end
        local old = _G.__K7PlayerTracerLine
        if old then pcall(function() old:Remove() end) end

        local tracerGui = Instance.new("ScreenGui")
        tracerGui.Name = "K7PlayerTracerOverlay"
        tracerGui.IgnoreGuiInset = true
        tracerGui.ResetOnSpawn = false
        tracerGui.DisplayOrder = 1000
        tracerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        tracerGui.Parent = LP:WaitForChild("PlayerGui")

        local playerTracer = Instance.new("Frame")
        playerTracer.Name = "ESPLine"
        playerTracer.AnchorPoint = Vector2.new(0.5, 0.5)
        playerTracer.BorderSizePixel = 0
        playerTracer.Active = false
        playerTracer.Visible = false
        playerTracer.ZIndex = 1
        playerTracer.BackgroundColor3 = _espAccent()
        playerTracer.Parent = tracerGui

        local outline = Instance.new("UIStroke", playerTracer)
        outline.Color = Color3.fromRGB(255, 255, 255)
        outline.Thickness = 0.7
        outline.Transparency = 0.45

        PlayerESP.tracerGui = tracerGui
        PlayerESP.tracerFrame = playerTracer
        _G.__K7PlayerTracerLine = { Remove = function() tracerGui:Destroy() end }
    end

    local function enableTracers()
        if PlayerESP.tracersEnabled then return end
        PlayerESP.tracersEnabled = true
        playerTracersEnabled = true
        ensureTracerGui()
        PlayerESP.tracerState = { scanElapsed = math.huge, targetRoot = nil }

        table.insert(PlayerESP.conns, RunService.RenderStepped:Connect(function(dt)
            local tracerFrame = PlayerESP.tracerFrame
            if not PlayerESP.tracersEnabled then
                if tracerFrame and tracerFrame.Visible then tracerFrame.Visible = false end
                PlayerESP.tracerState.targetRoot = nil
                PlayerESP.tracerState.scanElapsed = math.huge
                return
            end
            if not tracerFrame or not tracerFrame.Parent then return end

            local ok = pcall(function()
                local activeCamera = workspace.CurrentCamera
                local myCharacter = LP.Character
                local myRoot = myCharacter and (
                    myCharacter:FindFirstChild("LowerTorso")
                    or myCharacter:FindFirstChild("HumanoidRootPart")
                    or myCharacter:FindFirstChild("Torso"))
                if not activeCamera or not myRoot then
                    tracerFrame.Visible = false
                    return
                end

                local myPosition = myRoot.Position
                PlayerESP.tracerState.scanElapsed = PlayerESP.tracerState.scanElapsed + (dt or 0)

                local cachedRoot = PlayerESP.tracerState.targetRoot
                local cachedCharacter = cachedRoot and cachedRoot.Parent
                local cachedHumanoid = cachedCharacter and cachedCharacter:FindFirstChildOfClass("Humanoid")
                local cachedValid = cachedRoot and cachedRoot.Parent and (not cachedHumanoid or cachedHumanoid.Health > 0)

                if PlayerESP.tracerState.scanElapsed >= 0.12 or not cachedValid then
                    PlayerESP.tracerState.scanElapsed = 0
                    local closestRoot, closestDistanceSq = nil, math.huge
                    for _, otherPlayer in ipairs(Players:GetPlayers()) do
                        if otherPlayer ~= LP then
                            local character = otherPlayer.Character
                            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                            local root = character and (
                                character:FindFirstChild("HumanoidRootPart")
                                or character:FindFirstChild("LowerTorso")
                                or character:FindFirstChild("Torso"))
                            if root and root:IsA("BasePart") and (not humanoid or humanoid.Health > 0) then
                                local delta = root.Position - myPosition
                                local distanceSq = delta:Dot(delta)
                                if distanceSq < closestDistanceSq then
                                    closestRoot, closestDistanceSq = root, distanceSq
                                end
                            end
                        end
                    end
                    PlayerESP.tracerState.targetRoot = closestRoot
                end

                local closestRoot = PlayerESP.tracerState.targetRoot
                if not closestRoot or not closestRoot.Parent then
                    tracerFrame.Visible = false
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

                if from.Z <= 0 or fromPoint.X < 0 or fromPoint.X > viewport.X
                    or fromPoint.Y < 0 or fromPoint.Y > viewport.Y then
                    fromPoint = Vector2.new(viewport.X * 0.5, viewport.Y - 8)
                end

                local delta = targetPoint - fromPoint
                local midpoint = (fromPoint + targetPoint) * 0.5
                tracerFrame.Position = UDim2.fromOffset(midpoint.X, midpoint.Y)
                tracerFrame.Size = UDim2.fromOffset(math.max(delta.Magnitude, 1), 2)
                tracerFrame.Rotation = math.deg(math.atan2(delta.Y, delta.X))
                tracerFrame.BackgroundColor3 = _espAccent()
                tracerFrame.Visible = true
            end)
            if not ok then pcall(function() tracerFrame.Visible = false end) end
        end))
    end

    local function disableTracers()
        PlayerESP.tracersEnabled = false
        playerTracersEnabled = false
        if PlayerESP.tracerFrame then PlayerESP.tracerFrame.Visible = false end
        if PlayerESP.tracerGui then pcall(function() PlayerESP.tracerGui:Destroy() end) end
        PlayerESP.tracerGui = nil
        PlayerESP.tracerFrame = nil
        _G.__K7PlayerTracerLine = nil
    end

    function startPlayerTracers() enableTracers() end
    function stopPlayerTracers()  disableTracers() end
    end -- TRACER SECTION

    do -- MARKER SECTION
    local function clearLastPositionMarker()
        PlayerESP.markerLocked = false
        if PlayerESP.lastMarker then
            pcall(function()
                PlayerESP.lastMarker.Transparency = 1
                local s = PlayerESP.lastMarker:FindFirstChild("AlwaysOnTopSphere")
                if s then s.Visible = false end
                local h = PlayerESP.lastMarker:FindFirstChild("LastPositionHighlight")
                if h then h.Enabled = false end
                local b = PlayerESP.lastMarker:FindFirstChild("LastPositionLabel")
                if b then b.Enabled = false end
            end)
        end
    end

    local function createMarkerPart()
        local marker = Instance.new("Part")
        marker.Name = "K7LastPositionMarker"
        marker.Shape = Enum.PartType.Ball
        marker.Size = Vector3.new(3, 3, 3)
        marker.Color = Color3.fromRGB(0, 190, 255)
        marker.Material = Enum.Material.Neon
        marker.Anchored = true
        marker.CanCollide = false
        marker.CanTouch = false
        marker.CanQuery = false
        marker.CastShadow = false
        marker.Parent = workspace

        local sphere = Instance.new("SphereHandleAdornment")
        sphere.Name = "AlwaysOnTopSphere"
        sphere.Adornee = marker
        sphere.Radius = 1.55
        sphere.Color3 = Color3.fromRGB(0, 190, 255)
        sphere.Transparency = 0.05
        sphere.AlwaysOnTop = true
        sphere.Visible = true
        sphere.ZIndex = 10
        sphere.Parent = marker

        local hl = Instance.new("Highlight")
        hl.Name = "LastPositionHighlight"
        hl.Adornee = marker
        hl.FillColor = Color3.fromRGB(0, 190, 255)
        hl.FillTransparency = 0.15
        hl.OutlineColor = Color3.fromRGB(120, 220, 255)
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
        lbl.TextColor3 = Color3.fromRGB(220, 240, 255)
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 35, 90)
        lbl.TextStrokeTransparency = 0.25
        lbl.TextSize = 11
        lbl.Font = Enum.Font.GothamMedium
        lbl.Parent = bb

        return marker
    end

    local function updateLastPositionMarker(targetCFrame)
        if PlayerESP.markerLocked then return end
        local tracked = PlayerESP.markerTarget
        local character = tracked and tracked.Parent == Players and tracked.Character
        local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not targetRoot or not humanoid or humanoid.Health <= 0
            or not finiteVector(targetRoot.Position) then return end
        if isInsideAllowedArea(targetRoot.Position) then return end
        if not targetCFrame or not isInsideAllowedArea(targetCFrame.Position) then return end

        local groundCFrame = CFrame.new(
            targetCFrame.Position.X,
            LP_GROUND_Y,
            targetCFrame.Position.Z
        ) * targetCFrame.Rotation

        local marker = PlayerESP.lastMarker
        if not marker or not marker.Parent then
            marker = createMarkerPart()
            PlayerESP.lastMarker = marker
        end
        marker.Transparency = 0
        local s = marker:FindFirstChild("AlwaysOnTopSphere");    if s then s.Visible = true end
        local h = marker:FindFirstChild("LastPositionHighlight"); if h then h.Enabled = true end
        local b = marker:FindFirstChild("LastPositionLabel");     if b then b.Enabled = true end
        marker.CFrame = groundCFrame
        PlayerESP.markerLocked = true
    end

    local function snapshotBeforeExit(sample, now)
        if not sample or not sample.history or #sample.history == 0 then return nil end
        local cutoff = now - LP_LOOKBACK
        local selected = nil
        for _, entry in ipairs(sample.history) do
            if entry.time <= cutoff then selected = entry else break end
        end
        return selected or sample.history[1]
    end

    local function monitorLastPosition()
        if not PlayerESP.markerEnabled then return end
        local myChar = LP.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local tracked = PlayerESP.markerTarget
        if tracked and tracked.Parent == Players then
            local targetRoot = tracked.Character and tracked.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = tracked.Character and tracked.Character:FindFirstChildOfClass("Humanoid")
            local sample = PlayerESP.markerSamples[tracked] or {}
            PlayerESP.markerSamples[tracked] = sample

            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 and finiteVector(targetRoot.Position) then
                if isInsideAllowedArea(targetRoot.Position) then
                    local now = tick()
                    if PlayerESP.markerLocked then sample.history = {} end
                    sample.history = sample.history or {}
                    table.insert(sample.history, {
                        time = now,
                        safePosition = targetRoot.Position,
                        safeCFrame = targetRoot.CFrame,
                    })
                    while sample.history[1] and now - sample.history[1].time > (LP_LOOKBACK + 0.25) do
                        table.remove(sample.history, 1)
                    end
                    sample.safePosition = targetRoot.Position
                    sample.safeCFrame = targetRoot.CFrame
                    clearLastPositionMarker()
                else
                    local snapshot = snapshotBeforeExit(sample, tick())
                    updateLastPositionMarker((snapshot and snapshot.safeCFrame) or sample.safeCFrame)
                end
            end

            if (targetHumanoid and targetHumanoid.Health <= 0)
                or (not targetRoot and not sample.safeCFrame) then
                PlayerESP.markerTarget = nil
                clearLastPositionMarker()
            else
                return
            end
        end

        local closest, closestDistanceSq = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if root and hum and hum.Health > 0 and finiteVector(root.Position) then
                    local delta = root.Position - myRoot.Position
                    local distanceSq = delta:Dot(delta)
                    if distanceSq < closestDistanceSq then
                        closest = player
                        closestDistanceSq = distanceSq
                    end
                end
            end
        end

        if closest then
            PlayerESP.markerTarget = closest
            local targetRoot = closest.Character:FindFirstChild("HumanoidRootPart")
            local sample = PlayerESP.markerSamples[closest] or {}
            PlayerESP.markerSamples[closest] = sample
            sample.safePosition = targetRoot.Position
            sample.safeCFrame = targetRoot.CFrame
            sample.history = {
                { time = tick(), safePosition = targetRoot.Position, safeCFrame = targetRoot.CFrame }
            }
        end
    end

    local function enableLastPositionMarker()
        if PlayerESP.markerEnabled then return end
        PlayerESP.markerEnabled = true
        PlayerESP.markerSamples = {}
        PlayerESP.markerTarget  = nil
        PlayerESP.markerLocked  = false

        local acc = 0
        local interval = 1 / 60
        table.insert(PlayerESP.conns, RunService.Heartbeat:Connect(function(dt)
            acc = acc + (dt or 0)
            if acc < interval then return end
            acc = acc % interval
            pcall(monitorLastPosition)
        end))
    end

    local function disableLastPositionMarker()
        PlayerESP.markerEnabled = false
        PlayerESP.markerSamples = {}
        PlayerESP.markerTarget  = nil
        clearLastPositionMarker()
        if PlayerESP.lastMarker then
            pcall(function() PlayerESP.lastMarker:Destroy() end)
            PlayerESP.lastMarker = nil
        end
    end

    _G.K7PlayerESP = PlayerESP
    _G.__K7TPBatIsInsideMap = isInsideAllowedArea

    _G.__K7TPBatGetMarkerCFrame = function()
        local marker = PlayerESP.lastMarker
        if PlayerESP.markerLocked and marker and marker.Parent and marker.Transparency < 1 then
            local tracked = PlayerESP.markerTarget
            local trackedRoot = tracked and tracked.Character and tracked.Character:FindFirstChild("HumanoidRootPart")
            if trackedRoot and isInsideAllowedArea(trackedRoot.Position) then
                clearLastPositionMarker()
                return nil
            end
            local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return marker.CFrame end
            local markerPosition = marker.Position
            local away = Vector3.new(
                myRoot.Position.X - markerPosition.X,
                0,
                myRoot.Position.Z - markerPosition.Z
            )
            if away.Magnitude <= 0.05 then
                local look = marker.CFrame.LookVector
                away = Vector3.new(-look.X, 0, -look.Z)
            end
            if away.Magnitude <= 0.05 then away = Vector3.new(0, 0, 1) end
            local teleportPosition = markerPosition + away.Unit * 3
            local flat = Vector3.new(markerPosition.X - teleportPosition.X, 0, markerPosition.Z - teleportPosition.Z)
            if flat.Magnitude > 0.05 then
                return CFrame.lookAt(teleportPosition, teleportPosition + flat.Unit)
            end
            return CFrame.new(teleportPosition)
        end
        return nil
    end

    _G.__K7TPBatTrackTarget = function(player)
        if PlayerESP.markerLocked then return PlayerESP.markerTarget end
        local current = PlayerESP.markerTarget
        local currentCharacter = current and current.Parent == Players and current.Character
        local currentHumanoid = currentCharacter and currentCharacter:FindFirstChildOfClass("Humanoid")
        local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
        local currentSample = current and PlayerESP.markerSamples[current]
        if current and current.Parent == Players then
            if currentHumanoid and currentHumanoid.Health > 0
                and ((currentRoot and isInsideAllowedArea(currentRoot.Position))
                or (currentSample and currentSample.safeCFrame)) then return current end
            if not currentHumanoid and currentSample and currentSample.safeCFrame then return current end
        end
        if player and player ~= LP and player.Parent == Players then
            PlayerESP.markerTarget = player
            return player
        end
        return PlayerESP.markerTarget
    end

    _G.__K7TPBatForceMarker = function(player, fallbackCFrame)
        if player and player.Parent == Players then
            PlayerESP.markerTarget = player
        end
        local sample = player and PlayerESP.markerSamples[player]
        local snapshot = sample and snapshotBeforeExit(sample, tick())
        local remembered = snapshot and snapshot.safeCFrame or (sample and sample.safeCFrame)
        if not remembered and fallbackCFrame and isInsideAllowedArea(fallbackCFrame.Position) then
            remembered = fallbackCFrame
        end
        if remembered then updateLastPositionMarker(remembered) end
        return _G.__K7TPBatGetMarkerCFrame()
    end

    _G.__K7TPBatClearTracking = function()
        PlayerESP.markerLocked = false
        clearLastPositionMarker()
    end

    task.spawn(function()
        task.wait(0.5)
        enableLastPositionMarker()
    end)

    function _G.K7ToggleLastPositionMarker(on)
        if on then enableLastPositionMarker() else disableLastPositionMarker() end
    end
    end -- MARKER SECTION
end

-- ============================================================
-- STEAL SYSTEM
-- ============================================================
KB={DropBrainrot={kb=nil,gp=nil},AutoLeft={kb=nil,gp=nil},AutoRight={kb=nil,gp=nil},AutoBat={kb=nil,gp=nil},TPBat={kb=nil,gp=nil},TPFloor={kb=nil,gp=nil},GuiHide={kb=nil,gp=nil},SpeedToggle={kb=nil,gp=nil},LaggerToggle={kb=nil,gp=nil},LaggerCarry={kb=nil,gp=nil},AntiDesync={kb=nil,gp=nil},LaggerPanel={kb=nil,gp=nil},InstantReset={kb=Enum.KeyCode.T,gp=nil}}

local _IR = {
    Cooldown=false, Thread=nil, Character=nil, Stop=false,
    CameraLocked=false, LockedCameraCFrame=nil, SavedAntiDie=false,
    TICK=0.05, MAX_ATTEMPTS=40
}

local function stopInstantReset()
    _IR.Stop = true
    if _IR.Thread then
        pcall(function() task.cancel(_IR.Thread) end)
        _IR.Thread = nil
    end
    _IR.Cooldown = false
    _IR.Character = nil
    _IR.CameraLocked = false
    _IR.LockedCameraCFrame = nil
    pcall(function()
        local cam = workspace.CurrentCamera
        if cam then
            cam.CameraType = Enum.CameraType.Custom
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then cam.CameraSubject = hum end
        end
    end)

    local character = LP.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            pcall(function()
                humanoid.HipHeight = 2
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CanCollide = true
                end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end
    end

    if _IR.SavedAntiDie and AntiDie and type(AntiDie.toggle) == "function" then
        task.delay(0.35, function()
            pcall(function() AntiDie:toggle(true) end)
            antiDieEnabled = true
            if setAntiDieVisual then pcall(setAntiDieVisual, true) end
            _IR.SavedAntiDie = false
        end)
    end
end

local function InstantReset()
    if _IR.Cooldown then return end
    _IR.Cooldown = true
    _IR.Stop = false

    local character = LP.Character
    if not character then
        _IR.Cooldown = false
        return
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        _IR.Cooldown = false
        return
    end

    _IR.SavedAntiDie = antiDieEnabled == true
    if antiDieEnabled and AntiDie and type(AntiDie.toggle) == "function" then
        pcall(function() AntiDie:toggle(false) end)
        antiDieEnabled = false
    end

    local camera = workspace.CurrentCamera
    if camera then
        _IR.LockedCameraCFrame = camera.CFrame
        _IR.CameraLocked = true
        pcall(function() camera.CFrame = _IR.LockedCameraCFrame end)
    end

    _IR.Character = character
    local isRespawning = false
    local resetSuccessful = false
    local camConn
    if camera then
        pcall(function()
            camera.CameraType = Enum.CameraType.Scriptable
            camera.CFrame = _IR.LockedCameraCFrame
        end)
        camConn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            if cam and _IR.LockedCameraCFrame then
                cam.CameraType = Enum.CameraType.Scriptable
                cam.CFrame = _IR.LockedCameraCFrame
            end
        end)
    end

    _IR.Thread = task.spawn(function()
        local attempts = 0
        local fling = Vector3.new(0, 1000000, 0)
        pcall(function()
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            humanoid.BreakJointsOnDeath = true
            humanoid.PlatformStand = true
            humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
        end)

        while character and character.Parent and humanoid and humanoid.Health > 0
            and not isRespawning and not _IR.Stop do
            if LP.Character ~= character then
                isRespawning = true
                break
            end

            pcall(function()
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.AssemblyAngularVelocity = Vector3.zero
                    rootPart.AssemblyLinearVelocity = fling
                    rootPart.CanCollide = false
                end
                humanoid.PlatformStand = true
            end)

            if not character or not character.Parent or not humanoid
                or humanoid.Health <= 0 or LP.Character ~= character then
                resetSuccessful = true
                break
            end

            attempts = attempts + 1
            if attempts >= _IR.MAX_ATTEMPTS then
                break
            end
            task.wait(_IR.TICK)
        end

        if not resetSuccessful then
            if character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning then
                pcall(function()
                    humanoid.Health = 0
                end)
                task.wait(0.1)
                if not character.Parent or humanoid.Health <= 0 then
                    resetSuccessful = true
                end
            end
        end

        if not resetSuccessful and character and character.Parent and humanoid then
            pcall(function()
                humanoid.HipHeight = originalHipHeight
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CanCollide = true
                end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end

        _IR.CameraLocked = false
        _IR.Cooldown = false
        _IR.Thread = nil
        _IR.Character = nil
        _IR.Stop = false

        if _IR.SavedAntiDie and AntiDie and type(AntiDie.toggle) == "function" then
            task.delay(0.35, function()
                pcall(function() AntiDie:toggle(true) end)
                antiDieEnabled = true
                if setAntiDieVisual then pcall(setAntiDieVisual, true) end
                _IR.SavedAntiDie = false
            end)
        end
    end)
end

LP.CharacterAdded:Connect(function()
    stopInstantReset()
end)

task.spawn(function()
    while true do
        task.wait(0.016)
        if _IR.CameraLocked and _IR.LockedCameraCFrame then
            local cam = workspace.CurrentCamera
            if cam then
                pcall(function() cam.CFrame = _IR.LockedCameraCFrame end)
            end
        end
    end
end)

_G.CureInstantReset = InstantReset

-- ============================================================
-- ANTI-SAMMY AUTO STEAL (integrated)
-- ============================================================
pcall(function()
    getgenv()._AS_StealProgress = getgenv()._AS_StealProgress or 0
end)
_GACC = _GACC or {}
_GACC.autoCarryWatch = _GACC.autoCarryWatch or function() end
_GACC.accent = _GACC.accent or Color3.fromRGB(0, 190, 255)

Steal = {
    AutoStealEnabled = false,
    StealRadius = 60,
    StealDuration = 1.3,
    StealDelay = 0.25,
    StealMode = "semi",
    StealRange = 10,
    EntryDelay = 0.3,
    HoldMax = 2.6,
    Data = {},
}
lastStealTick = 0
isStealing, stealStartTime = false, nil
stealBarForce = nil
stealBarStatus = nil
autoGrabSetDelayRadius = 0
autoGrabStopTime = 1.1
autoGrabStopEnabled = false
stealMode = "normal"
normalStealVersion = "86"
NORMAL_STEAL_PERCENT = { ["75"] = 0.75, ["80"] = 0.80, ["86"] = 0.86, ["90"] = 0.90 }
normalStealProgress = 0
normalStealPaused = false

SemiSteal = {
    State = {
        active = false, startTime = 0, duration = 1.3, progress = 0, inRange = false,
        paused = false, phase = "idle", label = "", lastResult = "", lastResultTime = 0,
        totalSteals = 0, failedSteals = 0,
    },
    CONFIG = {
        HOLD_MIN = 1.3, HOLD_MAX = 2.6, ENTRY_DELAY = 0.3, COOLDOWN = 0.05,
        STEAL_RANGE = 9, PRIME_RANGE = 80, RADIUS = 60, DURATION = 1.3,
        DELAY_RADIUS = 8, STOP_TIME = 1.29, STOP_TIME_ENABLED = true,
        STOP_PERCENT = 75, USE_STOP_PERCENT = true,
    },
}
local startSemiAutoSteal, stopSemiAutoSteal

Conns = Conns or {}
Conns.autoSteal = Conns.autoSteal
Conns.antiRag = Conns.antiRag
Conns.batCounter = Conns.batCounter
Conns.anchor = Conns.anchor or {}
MEDUSA_COOLDOWN = MEDUSA_COOLDOWN or 25
batCounterDebounce = batCounterDebounce or false
modeValLbl = modeValLbl
lastMoveDir = lastMoveDir or Vector3.new(0, 0, 0)
_lastRagExitTime = _lastRagExitTime or 0

local function asIsMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end
isMyPlotByName = asIsMyPlotByName

isNearPodiumWithPrompt = function()
    local char = LP.Character
    local hrpL = char and char:FindFirstChild("HumanoidRootPart")
    if not hrpL then return false end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    for _, plot in ipairs(plots:GetChildren()) do
        if asIsMyPlotByName(plot.Name) then continue end
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if not podiums then continue end
        for _, podium in ipairs(podiums:GetChildren()) do
            local base = podium:FindFirstChild("Base")
            if not base then continue end
            local sp = base:FindFirstChild("Spawn")
            if not sp then continue end
            local d = (hrpL.Position - sp.Position).Magnitude
            if d > Steal.StealRadius then continue end
            local att = sp:FindFirstChild("PromptAttachment")
            if not att then continue end
            for _, obj in ipairs(att:GetChildren()) do
                if obj:IsA("ProximityPrompt") and obj.Enabled then return true, d end
            end
        end
    end
    return false, math.huge
end

function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil, nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil, nil, nil end
    local nearestPrompt, nearestDist, nearestName = nil, math.huge, nil
    for _, plot in ipairs(plots:GetChildren()) do
        local isMine = false
        pcall(function() isMine = isMyPlotByName(plot.Name) end)
        if isMine then continue end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local dist = (spawn.Position - root.Position).Magnitude
                    if dist < nearestDist and dist <= (Steal.StealRadius or 60) then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _, child in ipairs(att:GetChildren()) do
                                if child:IsA("ProximityPrompt")
                                    and child.ActionText
                                    and child.ActionText:find("Steal")
                                then
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
    return nearestPrompt, nearestDist, nearestName
end

function executeSteal(prompt, podName)
    if isStealing then return end
    if not prompt then return end
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
    stealStartTime = tick()
    stealBarForce = nil
    stealBarStatus = nil
    normalStealProgress = 0
    normalStealPaused = false
    pcall(function() getgenv()._AS_StealProgress = 0 end)

    if progressFill then
        progressFill.Size = UDim2.new(0, 0, 1, 0)
    end
    if progressPct then progressPct.Text = "0%" end

    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end
        pcall(function()
            if prompt.InputHoldBegin then prompt:InputHoldBegin() end
        end)

        local startTime = tick()
        local duration = tonumber(Steal.StealDuration) or 1.3
        if duration <= 0 then duration = 1.3 end
        local stopEnabled = autoGrabStopEnabled == true
        local stopTime = tonumber(autoGrabStopTime) or 1.1
        local delayRadius = tonumber(autoGrabSetDelayRadius) or 0

        local function promptPos()
            local ok, pos = pcall(function()
                if prompt.Parent and prompt.Parent.Parent and prompt.Parent.Parent:IsA("BasePart") then
                    return prompt.Parent.Parent.Position
                end
                return nil
            end)
            return ok and pos or nil
        end

        local function fireTriggers()
            for _, f in ipairs(data.trigger) do task.spawn(f) end
            pcall(function()
                if fireproximityprompt then fireproximityprompt(prompt) end
            end)
            pcall(function()
                if prompt.InputHoldEnd then prompt:InputHoldEnd() end
            end)
        end

        if stopEnabled then
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = tick() - startTime
                local prog = math.clamp(elapsed / duration, 0, 1)
                normalStealProgress = prog
                pcall(function() getgenv()._AS_StealProgress = prog end)
                if progressFill then progressFill.Size = UDim2.new(prog, 0, 1, 0) end
                if progressPct then progressPct.Text = math.floor(prog * 100) .. "%" end
                if elapsed >= stopTime then break end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local pos = promptPos()
                if hrp and pos and (hrp.Position - pos).Magnitude > (Steal.StealRadius or 60) then
                    break
                end
                task.wait()
            end

            local stopProgress = math.clamp(stopTime / duration, 0, 1)
            normalStealProgress = stopProgress
            normalStealPaused = true
            pcall(function() getgenv()._AS_StealProgress = stopProgress end)
            if progressFill then progressFill.Size = UDim2.new(stopProgress, 0, 1, 0) end
            if progressPct then progressPct.Text = math.floor(stopProgress * 100) .. "%" end

            local phase2Timeout = math.max(2.99 - stopTime - math.max(duration - stopTime, 0), 0.05)
            local phase2Start = tick()
            while isStealing and Steal.AutoStealEnabled do
                if tick() - phase2Start >= phase2Timeout then
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true
                    isStealing = false
                    stealStartTime = nil
                    normalStealPaused = false
                    task.wait()
                    executeSteal(prompt, podName)
                    return
                end
                if not prompt.Parent or not prompt.Parent.Parent then
                    isStealing = false
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true
                    stealStartTime = nil
                    normalStealPaused = false
                    return
                end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local pos = promptPos()
                if hrp and pos then
                    local dist = (hrp.Position - pos).Magnitude
                    if dist <= delayRadius then
                        break
                    elseif dist > (Steal.StealRadius or 60) then
                        isStealing = false
                        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                        if progressPct then progressPct.Text = "0%" end
                        data.ready = true
                        stealStartTime = nil
                        normalStealPaused = false
                        return
                    end
                end
                task.wait()
            end

            if isStealing and Steal.AutoStealEnabled then
                normalStealPaused = false
                local fillStart = tick()
                local fillDuration = math.max(duration - stopTime, 0.05)
                while true do
                    local fp = math.clamp((tick() - fillStart) / fillDuration, 0, 1)
                    local prog = stopProgress + fp * (1 - stopProgress)
                    normalStealProgress = prog
                    pcall(function() getgenv()._AS_StealProgress = prog end)
                    if progressFill then progressFill.Size = UDim2.new(prog, 0, 1, 0) end
                    if progressPct then progressPct.Text = math.floor(prog * 100) .. "%" end
                    if fp >= 1 then break end
                    task.wait()
                end
                fireTriggers()
            end
        else
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = tick() - startTime
                local progress = math.clamp(elapsed / duration, 0, 1)
                normalStealProgress = progress
                pcall(function() getgenv()._AS_StealProgress = progress end)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = math.floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local pos = promptPos()
                if hrp and pos and (hrp.Position - pos).Magnitude > (Steal.StealRadius or 60) then
                    break
                end
                if elapsed >= duration then
                    fireTriggers()
                    break
                end
                task.wait()
            end
        end

        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
        if progressPct then progressPct.Text = "0%" end
        normalStealProgress = 0
        pcall(function() getgenv()._AS_StealProgress = 0 end)
        data.ready = true
        isStealing = false
        stealStartTime = nil
        normalStealPaused = false
        stealBarForce = nil
        stealBarStatus = nil
    end)
end

startAutoSteal = function()
    Steal.AutoStealEnabled = true
    if Conns.autoSteal then
        pcall(function() Conns.autoSteal:Disconnect() end)
        Conns.autoSteal = nil
    end
    Conns.autoSteal = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p, _, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
end

stopAutoSteal = function()
    Steal.AutoStealEnabled = false
    if Conns.autoSteal then
        pcall(function() Conns.autoSteal:Disconnect() end)
        Conns.autoSteal = nil
    end
    isStealing = false
    stealStartTime = nil
    normalStealProgress = 0
    normalStealPaused = false
    stealBarForce = nil
    stealBarStatus = nil
    pcall(function() getgenv()._AS_StealProgress = 0 end)
    if progressFill then
        pcall(function()
            TweenService:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
        end)
    end
    if progressPct then progressPct.Text = "0%" end
    pcall(function() if resetProgressBar then resetProgressBar() end end)
end

do
    local opConnection = nil
    local opPromptData = {}

    local function opIsMyPlot(plot)
        local sign = plot and plot:FindFirstChild("PlotSign")
        local yourBase = sign and sign:FindFirstChild("YourBase")
        return yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled == true
    end

    local function opPromptPosition(prompt)
        local attachment = prompt and prompt.Parent
        local spawn = attachment and attachment.Parent
        return spawn and spawn:IsA("BasePart") and spawn.Position or nil
    end

    local function findNearestOPPrompt()
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local plotsFolder = workspace:FindFirstChild("Plots")
        if not root or not plotsFolder then return nil end
        local nearest, minDistance = nil, math.huge
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            if not opIsMyPlot(plot) then
                local podiums = plot:FindFirstChild("AnimalPodiums")
                if podiums then
                    for _, podium in ipairs(podiums:GetChildren()) do
                        local base = podium:FindFirstChild("Base")
                        local spawn = base and base:FindFirstChild("Spawn")
                        local attachment = spawn and spawn:FindFirstChild("PromptAttachment")
                        if spawn and attachment then
                            local distance = (spawn.Position - root.Position).Magnitude
                            if distance <= SemiSteal.CONFIG.RADIUS and distance < minDistance then
                                for _, child in ipairs(attachment:GetChildren()) do
                                    if child:IsA("ProximityPrompt") and child.Enabled then
                                        local at = tostring(child.ActionText or "")
                                        if at == "" or at:find("Steal") then
                                            nearest, minDistance = child, distance
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        return nearest
    end

    local function finishOPSteal(data, fired)
        if fired then
            SemiSteal.State.totalSteals = SemiSteal.State.totalSteals + 1
            SemiSteal.State.lastResult = "OP steal completed"
            if _GACC.autoCarryWatch then _GACC.autoCarryWatch(1.25) end
            stealBarForce = 1
            stealBarStatus = "STOLE"
            normalStealProgress = 1
            pcall(function() getgenv()._AS_StealProgress = 1 end)
            if setStealStatusText then pcall(setStealStatusText, "STOLE") end
        else
            SemiSteal.State.failedSteals = SemiSteal.State.failedSteals + 1
            SemiSteal.State.lastResult = "OP steal cancelled"
        end
        SemiSteal.State.lastResultTime = tick()
        SemiSteal.State.active = false
        SemiSteal.State.progress = 0
        SemiSteal.State.inRange = false
        SemiSteal.State.paused = false
        SemiSteal.State.phase = "idle"
        isStealing = false
        stealStartTime = nil
        data.ready = true
        task.delay(0.05, function()
            if not isStealing and stealBarForce ~= 1 then
                normalStealProgress = 0
                pcall(function() getgenv()._AS_StealProgress = 0 end)
            end
        end)
    end

    local function executeOPSteal(prompt)
        if isStealing or not prompt or not prompt.Parent then return end
        if not opPromptData[prompt] then
            local data = { hold = {}, trigger = {}, ready = true }
            if getconnections then
                local okHold, holdConnections = pcall(getconnections, prompt.PromptButtonHoldBegan)
                if okHold then
                    for _, connection in ipairs(holdConnections) do
                        if connection.Function then table.insert(data.hold, connection.Function) end
                    end
                end
                local okTrigger, triggerConnections = pcall(getconnections, prompt.Triggered)
                if okTrigger then
                    for _, connection in ipairs(triggerConnections) do
                        if connection.Function then table.insert(data.trigger, connection.Function) end
                    end
                end
            end
            opPromptData[prompt] = data
        end
        local data = opPromptData[prompt]
        if not data.ready then return end
        data.ready = false
        isStealing = true
        stealStartTime = tick()
        local duration = math.max(tonumber(SemiSteal.CONFIG.DURATION) or 1.4, 0.05)
        SemiSteal.State.active = true
        SemiSteal.State.startTime = stealStartTime
        SemiSteal.State.duration = duration
        SemiSteal.State.progress = 0
        SemiSteal.State.paused = false
        SemiSteal.State.phase = "holding"
        SemiSteal.State.inRange = false

        task.spawn(function()
            for _, callback in ipairs(data.hold) do task.spawn(callback) end
            local fired = false
            local cancelled = false
            local function distanceFromPrompt()
                local position = opPromptPosition(prompt)
                local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if not position or not root then return nil end
                return (root.Position - position).Magnitude
            end
            local function stillRunning()
                return isStealing and Steal.AutoStealEnabled and stealMode == "op" and prompt.Parent ~= nil
            end

            if SemiSteal.CONFIG.STOP_TIME_ENABLED then
                local stopAt
                if SemiSteal.CONFIG.USE_STOP_PERCENT then
                    local pct = math.clamp(tonumber(SemiSteal.CONFIG.STOP_PERCENT) or 75, 1, 100)
                    stopAt = duration * (pct / 100)
                else
                    stopAt = math.clamp(tonumber(SemiSteal.CONFIG.STOP_TIME) or 1.29, 0.05, duration)
                end
                local started = tick()
                while stillRunning() do
                    local elapsed = tick() - started
                    local distance = distanceFromPrompt()
                    if not distance or distance > SemiSteal.CONFIG.RADIUS then cancelled = true break end
                    SemiSteal.State.inRange = true
                    SemiSteal.State.progress = math.clamp(elapsed / duration, 0, 1)
                    normalStealProgress = SemiSteal.State.progress
                    pcall(function() getgenv()._AS_StealProgress = SemiSteal.State.progress end)
                    if elapsed >= stopAt then break end
                    task.wait()
                end
                if not stillRunning() then cancelled = true end
                if not cancelled then
                    local stopProgress = math.clamp(stopAt / duration, 0, 1)
                    SemiSteal.State.progress = stopProgress
                    SemiSteal.State.paused = true
                    SemiSteal.State.phase = "waiting"
                    local delayTime = math.max(2.99 - stopAt - math.max(duration - stopAt, 0), 0.05)
                    local delayStarted = tick()
                    local enteredDelayRadius = false
                    while stillRunning() and tick() - delayStarted < delayTime do
                        local distance = distanceFromPrompt()
                        if not distance or distance > SemiSteal.CONFIG.RADIUS then cancelled = true break end
                        SemiSteal.State.inRange = distance <= SemiSteal.CONFIG.DELAY_RADIUS
                        if SemiSteal.State.inRange then enteredDelayRadius = true break end
                        task.wait()
                    end
                    if not stillRunning() then cancelled = true end
                    if enteredDelayRadius and not cancelled then
                        SemiSteal.State.paused = false
                        SemiSteal.State.phase = "finishing"
                        local finishStarted = tick()
                        local remaining = math.max(duration - stopAt, 0.05)
                        while stillRunning() do
                            local finishProgress = math.clamp((tick() - finishStarted) / remaining, 0, 1)
                            SemiSteal.State.progress = stopProgress + finishProgress * (1 - stopProgress)
                            normalStealProgress = SemiSteal.State.progress
                            pcall(function() getgenv()._AS_StealProgress = SemiSteal.State.progress end)
                            if finishProgress >= 1 then break end
                            task.wait()
                        end
                        if stillRunning() then
                            for _, callback in ipairs(data.trigger) do task.spawn(callback) end
                            fired = true
                            SemiSteal.State.progress = 1
                        end
                    end
                end
            else
                local started = tick()
                while stillRunning() do
                    local elapsed = tick() - started
                    local distance = distanceFromPrompt()
                    if not distance or distance > SemiSteal.CONFIG.RADIUS then cancelled = true break end
                    SemiSteal.State.inRange = true
                    SemiSteal.State.progress = math.clamp(elapsed / duration, 0, 1)
                    normalStealProgress = SemiSteal.State.progress
                    pcall(function() getgenv()._AS_StealProgress = SemiSteal.State.progress end)
                    if elapsed >= duration then
                        for _, callback in ipairs(data.trigger) do task.spawn(callback) end
                        fired = true
                        SemiSteal.State.progress = 1
                        break
                    end
                    task.wait()
                end
            end
            task.wait(0.05)
            finishOPSteal(data, fired)
        end)
    end

    startSemiAutoSteal = function()
        if opConnection then return end
        stealMode = "op"
        opConnection = RunService.Heartbeat:Connect(function()
            if not Steal.AutoStealEnabled or stealMode ~= "op" or isStealing or SemiSteal.State.active then return end
            local prompt = findNearestOPPrompt()
            if prompt then executeOPSteal(prompt) end
        end)
    end

    stopSemiAutoSteal = function()
        if opConnection then opConnection:Disconnect() opConnection = nil end
        for _, data in pairs(opPromptData) do data.ready = true end
        SemiSteal.State.active = false
        SemiSteal.State.progress = 0
        SemiSteal.State.inRange = false
        SemiSteal.State.paused = false
        SemiSteal.State.phase = "idle"
        isStealing = false
        stealStartTime = nil
    end
end

function getPingMs()
    local candidates = {}
    local function add(v)
        local n = nil
        if type(v) == "number" then n = v
        elseif type(v) == "string" then n = tonumber((tostring(v):match("[%d%.]+")) or "") end
        if type(n) == "number" and n > 0 and n < 5000 then
            table.insert(candidates, math.floor(n + 0.5))
        end
    end
    pcall(function()
        local Stats = game:GetService("Stats")
        local network = nil
        pcall(function() network = Stats.Network end)
        if not network then pcall(function() network = Stats:FindFirstChild("Network") end) end
        if network then
            local ssi = nil
            pcall(function() ssi = network.ServerStatsItem end)
            if not ssi then pcall(function() ssi = network:FindFirstChild("ServerStatsItem") end) end
            if ssi then
                pcall(function()
                    local item = ssi["Data Ping"]
                    if item then
                        pcall(function() add(item:GetValue()) end)
                        pcall(function() add(item:GetValueString()) end)
                    end
                end)
                pcall(function()
                    local item = ssi:FindFirstChild("Data Ping")
                    if item then
                        pcall(function() add(item:GetValue()) end)
                        pcall(function() add(item:GetValueString()) end)
                    end
                end)
                pcall(function()
                    for _, child in ipairs(ssi:GetChildren()) do
                        if tostring(child.Name):lower():find("ping", 1, true) then
                            pcall(function() add(child:GetValue()) end)
                            pcall(function() add(child:GetValueString()) end)
                        end
                    end
                end)
            end
        end
        pcall(function()
            local perf = Stats:FindFirstChild("PerformanceStats") or Stats.PerformanceStats
            if perf then
                local ps = perf:FindFirstChild("Ping") or perf.Ping
                if ps then pcall(function() add(ps:GetValue()) end) end
            end
        end)
    end)
    pcall(function()
        local p = LP:GetNetworkPing()
        if type(p) == "number" and p > 0 then add(p * 1000) end
    end)
    if #candidates == 0 then return 0 end
    table.sort(candidates)
    return candidates[1]
end

local function createStealBar()
    pcall(function()
        if destroyOldGui then
            destroyOldGui("K7InfoBar")
            destroyOldGui("K7StealBar")
            destroyOldGui("AspectStealBar")
        end
        local cg = game:GetService("CoreGui")
        local pg = LP:FindFirstChild("PlayerGui")
        for _, n in ipairs({"K7InfoBar", "K7StealBar", "AspectStealBar", "RyukStealBarUI", "RyukStealBar"}) do
            local o = cg:FindFirstChild(n); if o then o:Destroy() end
            if pg then local o2 = pg:FindFirstChild(n); if o2 then o2:Destroy() end end
            if _gethui then
                local h = _gethui()
                local o3 = h and h:FindFirstChild(n)
                if o3 then o3:Destroy() end
            end
        end
    end)
    local th = (type(getTheme) == "function" and getTheme()) or {}
    local COL_BG     = th.STEAL_BG or th.BG or Color3.fromRGB(6, 9, 15)
    local COL_BG2    = th.BG2 or Color3.fromRGB(12, 17, 28)
    local COL_ACCENT = th.STEAL_ACCENT or th.ACCENT or Color3.fromRGB(0, 190, 255)
    local COL_FILL   = th.STEAL_FILL or th.ACCENT or Color3.fromRGB(0, 190, 255)
    local COL_WHITE  = th.WHITE or Color3.fromRGB(228, 240, 255)
    local COL_GRAY   = th.GRAY or Color3.fromRGB(120, 155, 205)
    local COL_TRACK  = th.OFF or Color3.fromRGB(14, 20, 34)
    local COL_BORDER = th.ROW_BORDER or COL_ACCENT
    local stealGui = Instance.new("ScreenGui")
    stealGui.Name = "K7InfoBar"
    stealGui.ResetOnSpawn = false
    stealGui.IgnoreGuiInset = true
    stealGui.DisplayOrder = 12
    pcall(function()
        if parentGui then parentGui(stealGui)
        else
            if not pcall(function() stealGui.Parent = game:GetService("CoreGui") end) then
                stealGui.Parent = LP:WaitForChild("PlayerGui")
            end
        end
    end)
    local bar = Instance.new("Frame", stealGui)
    bar.Name = "K7StealBarFrame"
    local _sbScale = tonumber(stealBarScale) or 1
    if _sbScale < 0.5 then _sbScale = 0.5 elseif _sbScale > 1.2 then _sbScale = 1.2 end
    stealBarScale = _sbScale
    bar.Size = UDim2.new(0, 320, 0, 56)
    do
        local p = stealBarPos
        if type(p) == "table" and p.sx ~= nil then bar.Position = UDim2.new(p.sx, p.ox, p.sy, p.oy)
        else bar.Position = UDim2.new(0.5, -math.floor(160 * _sbScale), 0, 28) end
    end
    local barScale = Instance.new("UIScale", bar)
    barScale.Name = "StealBarScale"
    barScale.Scale = _sbScale
    bar.BackgroundTransparency = 1
    bar.BorderSizePixel = 0
    bar.Active = true
    bar.ZIndex = 80
    local bg = Instance.new("Frame", bar)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = COL_BG
    bg.BackgroundTransparency = 0.08
    bg.BorderSizePixel = 0
    bg.ZIndex = 80
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 9)
    local stroke = Instance.new("UIStroke", bg)
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = 2
    stroke.Transparency = 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local bannerFrame = Instance.new("Frame", bar)
    bannerFrame.Size = UDim2.new(1, 0, 0, 22)
    bannerFrame.BackgroundColor3 = COL_BG2
    bannerFrame.BackgroundTransparency = 0.15
    bannerFrame.BorderSizePixel = 0
    bannerFrame.ZIndex = 82
    Instance.new("UICorner", bannerFrame).CornerRadius = UDim.new(0, 9)
    progressRadLbl = Instance.new("TextLabel", bannerFrame)
    progressRadLbl.Name = "BannerLabel"
    progressRadLbl.Size = UDim2.new(1, -54, 1, 0)
    progressRadLbl.Position = UDim2.new(0, 10, 0, 0)
    progressRadLbl.BackgroundTransparency = 1
    progressRadLbl.Text = "Visible Hub  •  Ping: 0ms  •  FPS: 0"
    progressRadLbl.TextColor3 = COL_WHITE
    progressRadLbl.Font = Enum.Font.GothamBold
    progressRadLbl.TextSize = 9
    progressRadLbl.TextXAlignment = Enum.TextXAlignment.Left
    progressRadLbl.TextYAlignment = Enum.TextYAlignment.Center
    progressRadLbl.ZIndex = 83
    statusDot = Instance.new("Frame", bannerFrame)
    statusDot.Name = "StatusDot"
    statusDot.Size = UDim2.new(0, 6, 0, 6)
    statusDot.Position = UDim2.new(1, -52, 0.5, -3)
    statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    statusDot.BorderSizePixel = 0
    statusDot.ZIndex = 83
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)
    progressPct = Instance.new("TextLabel", bannerFrame)
    progressPct.Name = "ProgressPct"
    progressPct.Size = UDim2.new(0, 52, 1, 0)
    progressPct.Position = UDim2.new(1, -56, 0, 0)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = COL_WHITE
    progressPct.Font = Enum.Font.GothamBold
    progressPct.TextSize = 13
    progressPct.TextXAlignment = Enum.TextXAlignment.Center
    progressPct.TextYAlignment = Enum.TextYAlignment.Center
    progressPct.ZIndex = 83
    local pbg = Instance.new("Frame", bar)
    pbg.Size = UDim2.new(0.94, 0, 0, 14)
    pbg.Position = UDim2.new(0.03, 0, 0, 32)
    pbg.BackgroundColor3 = COL_TRACK
    pbg.BackgroundTransparency = 0.35
    pbg.BorderSizePixel = 0
    pbg.ZIndex = 82
    Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 6)
    progressFill = Instance.new("Frame", pbg)
    progressFill.Name = "ProgressFill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = COL_FILL
    progressFill.BackgroundTransparency = 0
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 83
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 6)
    stealBarFrame = bar
    local function getPingMsLocal()
        if type(getPingMs) == "function" then
            local ok, v = pcall(getPingMs)
            if ok and type(v) == "number" then return v end
        end
        return 0
    end
    getPingMs = getPingMs
    function formatStealPct(prog) return math.floor((prog or 0) * 100 + 0.5) .. "%" end
    function setStealStatusText(status, extra)
        if not progressPct or not progressPct.Parent then return end
        if status == "SEARCHING" then
            if statusDot then statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 120) end
            if not isStealing and not stealBarForce then
                progressPct.Text = "..."
            end
        elseif status == "STEALING" or status == "HOLDING" or status == "CLOSER" then
            if statusDot then statusDot.BackgroundColor3 = Color3.fromRGB(255, 200, 50) end
        elseif status == "STOLE" then
            if statusDot then statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 120) end
        elseif status == "MISSED" then
            progressPct.Text = "MISS"
            if statusDot then statusDot.BackgroundColor3 = Color3.fromRGB(255, 80, 80) end
        end
    end
    function resetProgressBar()
        stealBarForce = nil
        stealBarStatus = nil
        if progressFill and progressFill.Parent then progressFill.Size = UDim2.new(0, 0, 1, 0) end
        if Steal and Steal.AutoStealEnabled then setStealStatusText("SEARCHING")
        else
            if progressPct then progressPct.Text = "0%" end
            if statusDot then statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 120) end
        end
    end
    local fpsCounter, fpsElapsed = 0, 0
    local renderConn
    renderConn = RunService.RenderStepped:Connect(function(dt)
        if not bar or not bar.Parent then if renderConn then renderConn:Disconnect() end; return end
        fpsCounter = fpsCounter + 1
        fpsElapsed = fpsElapsed + dt
    end)
    bar.AncestryChanged:Connect(function() if not bar.Parent and renderConn then renderConn:Disconnect() end end)
    task.spawn(function()
        while bar and bar.Parent do
            local fps = 0
            if fpsElapsed > 0 then fps = math.floor(fpsCounter / fpsElapsed + 0.5) end
            local ping = (type(getPingMs)=="function" and getPingMs()) or getPingMsLocal()
            if progressRadLbl and progressRadLbl.Parent then
                progressRadLbl.Text = string.format("Visible Hub  •  %dms  •  %dfps", ping, fps)
            end
            fpsCounter = 0; fpsElapsed = 0
            task.wait(0.5)
        end
    end)
    task.spawn(function()
        while progressFill and progressFill.Parent do
            if not isStealing then
                if stealStartTime == nil and (not stealBarForce) then
                end
            end
            task.wait(0.05)
        end
    end)
    local dragging, dragStart, startPosition = false, nil, nil
    bar.InputBegan:Connect(function(input)
        if uiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = bar.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    pcall(function()
                        local pos = bar.Position
                        stealBarPos = {sx = pos.X.Scale, ox = pos.X.Offset, sy = pos.Y.Scale, oy = pos.Y.Offset}
                        if type(saveConfig) == "function" then saveConfig() end
                    end)
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if uiLocked then dragging = false; return end
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            bar.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end
    end)
    pcall(function()
        local id = nil
        pcall(function()
            if getgenv and type(getgenv()._K7SelectedBgId) == "string" and getgenv()._K7SelectedBgId ~= "" and getgenv()._K7SelectedBgId ~= "0" then
                id = getgenv()._K7SelectedBgId
            end
        end)
        if (not id or id == "" or id == "0") and type(_G._K7SelectedBgId) == "string" and _G._K7SelectedBgId ~= "" and _G._K7SelectedBgId ~= "0" then
            id = _G._K7SelectedBgId
        end
        if not id or id == "" or id == "0" then id = "93489483341327" end
        local op = 0.95
        pcall(function()
            if getgenv and type(getgenv()._K7BgOpacity) == "number" then op = getgenv()._K7BgOpacity end
        end)
        if type(_G._K7BgOpacity) == "number" then op = _G._K7BgOpacity end
        local function paint(parent, cornerR, trans)
            if not parent then return end
            local img = parent:FindFirstChild("CustomBgImg")
            if not img then
                img = Instance.new("ImageLabel")
                img.Name = "CustomBgImg"
                img.Size = UDim2.fromScale(1, 1)
                img.BackgroundTransparency = 1
                img.ScaleType = Enum.ScaleType.Crop
                img.ZIndex = (parent.ZIndex or 1)
                img.Visible = true
                if cornerR then Instance.new("UICorner", img).CornerRadius = UDim.new(0, cornerR) end
                img.Parent = parent
            end
            img.Image = "rbxassetid://" .. tostring(id)
            img.ImageTransparency = math.clamp(1 - op, 0.02, 0.4)
            img.Visible = true
            if parent:IsA("GuiObject") then
                parent.BackgroundTransparency = trans or 0.55
            end
        end
        local solidBg = nil
        local banner = nil
        for _, ch in ipairs(bar:GetChildren()) do
            if ch:IsA("Frame") then
                if ch:FindFirstChild("BannerLabel") or (type(ch.Name) == "string" and ch.Name:lower():find("banner")) then
                    banner = ch
                elseif not solidBg and ch.Name ~= "ProgressFill" then
                    solidBg = ch
                end
            end
        end
        if solidBg then
            paint(solidBg, 9, 0.55)
        else
            paint(bar, 9, 0.55)
        end
        if banner then
            paint(banner, 9, 0.5)
        end
    end)
    return bar
end

-- ============================================================
-- MOBILE BUTTONS
-- ============================================================
local function destroyMobileButtons()
    pcall(saveBtnPositions)
    if mobGuiRef then pcall(function() mobGuiRef:Destroy() end); mobGuiRef=nil end
    for _,n in ipairs({"K7MobileButtons"}) do
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end
        local pgui=LP:FindFirstChild("PlayerGui");if pgui then local o=pgui:FindFirstChild(n);if o then o:Destroy() end end
    end
    mobBtnRefs={}
end
local function buildMobileButtons()
    destroyMobileButtons();if not mobileButtonsEnabled then return end
    perButtonDragEnabled=true
    local savedPositions=loadBtnPositions()
    local BTN_SIZE=math.floor(mobileButtonsSize*0.55)
    local BTN_GAP=12
    local CORNER_R=circleButtonsEnabled and BTN_SIZE or math.max(8,math.floor(BTN_SIZE*0.22))
    local fontSize=math.max(7,math.floor(mobileButtonsSize*0.10))
    local buttons={
        {key="drop",        label="DROP\nBR",       toggle=false, exclusive=false},
        {key="autoLeft",    label="AUTO\nLEFT",     toggle=true,  exclusive=true},
        {key="autoBat",     label="BAT\nAIMBOT",    toggle=true,  exclusive=true},
        {key="autoRight",   label="AUTO\nRIGHT",    toggle=true,  exclusive=true},
        {key="tpDown",      label="TP\nDOWN",       toggle=false, exclusive=false},
        {key="carrySpeed",  label="CARRY\nSPD",     toggle=true,  exclusive=false},
        {key="lagger",      label="LAGGER\nMODE",   toggle=true,  exclusive=false},
        {key="laggerCarry", label="LAGGER\nCARRY",  toggle=true,  exclusive=false},
    }
    local COLS=2
    local totalW=(COLS*(BTN_SIZE+BTN_GAP))-BTN_GAP
    local totalH=(math.ceil(#buttons/COLS)*(BTN_SIZE+BTN_GAP))-BTN_GAP
    local PAD=10
    local vp=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    local savedPanel=savedPositions["_panel"]
    local defPanelX=vp.X-totalW-PAD*2-18
    local defPanelY=math.max(10,vp.Y/2-(totalH+PAD*2)/2)
    local panelXO=savedPanel and savedPanel.xo or defPanelX
    local panelYO=savedPanel and savedPanel.yo or defPanelY
    local mobGui=Instance.new("ScreenGui")
    mobGui.Name="K7MobileButtons";mobGui.ResetOnSpawn=false;mobGui.DisplayOrder=15;mobGui.IgnoreGuiInset=true
    parentGui(mobGui)
    mobGuiRef=mobGui
    local th = getTheme()
    local PINK_ON      = th.MOB_ON
    local BTN_BG_OFF   = th.MOB_OFF
    local PANEL_BG     = th.BG
    local BORDER_OFF   = th.MOB_BORDER_OFF
    local BORDER_ON    = th.MOB_ON
    local TEXT_OFF     = th.MOB_TEXT_OFF
    local TEXT_ON      = th.MOB_TEXT_ON
    local STROKE_W     = 1
    local panel
    if not perButtonDragEnabled then
        panel=Instance.new("Frame",mobGui)
        panel.Name="MobPanel"
        panel.Size=UDim2.new(0,totalW+PAD*2,0,totalH+PAD*2)
        panel.Position=UDim2.new(0,panelXO,0,panelYO)
        panel.BackgroundColor3=PANEL_BG
        panel.BackgroundTransparency=1
        panel.BorderSizePixel=0;panel.Active=true;panel.ZIndex=99
        local panelStroke=Instance.new("UIStroke",panel)
        panelStroke.Color=Color3.fromRGB(80,80,80);panelStroke.Thickness=1;panelStroke.Transparency=0.7
        local gDragStart,gDragStartPos,gDragDown=nil,nil,false
        panel.InputBegan:Connect(function(input)
            if uiLocked or mobileButtonsLocked then return end
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                gDragDown=true;gDragStart=input.Position;gDragStartPos=panel.Position
                input.Changed:Connect(function()
                    if input.UserInputState==Enum.UserInputState.End then
                        gDragDown=false
                        if writefile then
                            local posData=loadBtnPositions()
                            posData["_panel"]={xo=panel.Position.X.Offset,yo=panel.Position.Y.Offset}
                            pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode(posData)) end)
                        end
                    end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if gDragDown and not uiLocked and not mobileButtonsLocked and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                local delta=input.Position-gDragStart
                panel.Position=UDim2.new(0,gDragStartPos.X.Offset+delta.X,0,gDragStartPos.Y.Offset+delta.Y)
            end
        end)
    end
    for i,def in ipairs(buttons) do
        local col=(i-1)%COLS
        local rowN=math.floor((i-1)/COLS)
        local localX=PAD+col*(BTN_SIZE+BTN_GAP)
        local localY=PAD+rowN*(BTN_SIZE+BTN_GAP)
        local frameParent=perButtonDragEnabled and mobGui or panel
        local frame=Instance.new("Frame",frameParent)
        frame.Name="MobBtn_"..def.key
        frame.Size=UDim2.new(0,BTN_SIZE,0,BTN_SIZE)
        local sp = (not forceDefaultBtnPos) and savedPositions[def.key] or nil
        local cam = workspace.CurrentCamera
        local vpX = (cam and cam.ViewportSize.X) or 800
        local vpY = (cam and cam.ViewportSize.Y) or 600
        if sp and tonumber(sp.xo)~=nil and tonumber(sp.yo)~=nil and tonumber(sp.xo) > vpX*0.35 then
            frame.Position = UDim2.new(0,tonumber(sp.xo),0,tonumber(sp.yo))
        else
            local xo = vpX - (totalW + PAD + 18) + localX
            local yo = math.max(10, vpY/2 - (totalH+PAD*2)/2) + localY
            frame.Position = UDim2.new(0,xo,0,yo)
        end
        frame.BackgroundColor3=BTN_BG_OFF
        frame.BackgroundTransparency=0.05
        frame.BorderSizePixel=0;frame.Active=true;frame.ZIndex=102
        frame:SetAttribute("BtnKey",def.key)
        local uic=Instance.new("UICorner",frame)
        uic.CornerRadius=circleButtonsEnabled and UDim.new(1,0) or UDim.new(0,math.max(8,CORNER_R))
        local fstroke=Instance.new("UIStroke",frame)
        fstroke.Color=BORDER_OFF;fstroke.Thickness=1;fstroke.Transparency=0.35
        local btn=Instance.new("TextButton",frame)
        btn.Size=UDim2.new(1,0,1,0);btn.BackgroundTransparency=1
        btn.Text=def.label
        btn.TextColor3=TEXT_OFF
        btn.Font=Enum.Font.GothamBold
        btn.TextSize=fontSize
        btn.LineHeight=1.05
        btn.TextWrapped=true;btn.AutoButtonColor=false;btn.ZIndex=105
        btn.TextStrokeTransparency=1
        local isOn=false
        local function setOn(v)
            isOn=v
            if v then
                frame:SetAttribute("BtnIsOn",true)
                TweenService:Create(frame,TweenInfo.new(0.12,Enum.EasingStyle.Quad),{BackgroundColor3=Color3.fromRGB(240,246,255)}):Play()
                TweenService:Create(fstroke,TweenInfo.new(0.12),{Color=PINK_ON,Thickness=STROKE_W+1}):Play()
                TweenService:Create(btn,TweenInfo.new(0.12),{TextColor3=Color3.fromRGB(6,9,15)}):Play()
            else
                frame:SetAttribute("BtnIsOn",false)
                TweenService:Create(frame,TweenInfo.new(0.12,Enum.EasingStyle.Quad),{BackgroundColor3=BTN_BG_OFF}):Play()
                TweenService:Create(fstroke,TweenInfo.new(0.12),{Color=BORDER_OFF,Thickness=STROKE_W}):Play()
                TweenService:Create(btn,TweenInfo.new(0.12),{TextColor3=TEXT_OFF}):Play()
            end
        end
        mobBtnRefs[def.key]=setOn
        local function flash()
            TweenService:Create(frame,TweenInfo.new(0.06),{BackgroundColor3=Color3.fromRGB(240,240,240)}):Play()
            task.delay(0.18,function() TweenService:Create(frame,TweenInfo.new(0.1),{BackgroundColor3=BTN_BG_OFF}):Play() end)
        end
        local dragStart2,dragStartPos2,dragMoved,dragDown=nil,nil,false,false
        btn.InputBegan:Connect(function(input)
            if uiLocked or mobileButtonsLocked then return end
            if activeMobDrag and activeMobDrag~=frame then return end
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragMoved=false
                dragDown=true
                activeMobDrag=frame
                dragStart2=input.Position
                dragStartPos2=Vector2.new(frame.Position.X.Offset, frame.Position.Y.Offset)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not dragDown or uiLocked or mobileButtonsLocked or activeMobDrag~=frame then return end
            if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
                local delta=input.Position-dragStart2
                if delta.Magnitude>18 then dragMoved=true end
                if dragMoved then
                    frame.Position=UDim2.new(0,dragStartPos2.X+delta.X,0,dragStartPos2.Y+delta.Y)
                end
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if not dragDown or activeMobDrag~=frame then return end
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                local wasDrag=dragMoved
                dragDown=false
                activeMobDrag=nil
                if wasDrag then pcall(saveBtnPositions) end
                task.delay(0.08,function() dragMoved=false end)
            end
        end)
        btn.Activated:Connect(function()
            if dragMoved then return end
            if def.key=="tpDown" then runTPFloor();flash();return end
            if def.key=="drop" then runDrop();flash();return end
            if def.exclusive then
                local alreadyOn=(def.key=="autoLeft" and autoLeftEnabled) or (def.key=="autoRight" and autoRightEnabled) or (def.key=="autoBat" and autoBatEnabled)
                if alreadyOn then
                    if def.key=="autoLeft" then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;setOn(false)
                    elseif def.key=="autoRight" then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;setOn(false)
                    elseif def.key=="autoBat" then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;setOn(false)
                    end
                    return
                end
                if autoLeftEnabled and def.key~="autoLeft" then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoRightEnabled and def.key~="autoRight" then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if autoBatEnabled and def.key~="autoBat" then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                if def.key=="autoLeft" then autoLeftEnabled=true;if safeModeTryStart and not safeModeTryStart() then return end;startAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(true) end;setOn(true)
                elseif def.key=="autoRight" then autoRightEnabled=true;if safeModeTryStart and not safeModeTryStart() then return end;startAutoRight();if autoRightSetVisual then autoRightSetVisual(true) end;setOn(true)
                elseif def.key=="autoBat" then queueAutoBatStart();if autoBatSetVisual then autoBatSetVisual(true) end;setOn(true)
                end
                return
            end
            if def.key=="laggerCarry" then toggleLaggerCarryMode();setOn(laggerCarryActive);if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end;saveConfig();return end
        end)
    end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
    if mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(carrySpeedActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerModeEnabled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryActive) end
end

-- ============================================================
-- SAFE MODE
-- ============================================================
local function safeModeGetCountdownLabel()
    local ok, label = pcall(function()
        local pg = LP:FindFirstChild("PlayerGui")
        if not pg then return nil end
        local top = pg:FindFirstChild("DuelsMachineTopFrame")
        if not top then return nil end
        local inner = top:FindFirstChild("DuelsMachineTopFrame") or top
        local timer = inner:FindFirstChild("Timer", true)
        if not timer then return nil end
        return timer:FindFirstChild("Label") or timer:FindFirstChildWhichIsA("TextLabel")
    end)
    return (ok and label) or nil
end
local function safeModeCountdownNumber(text)
    local t = tostring(text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
    if t == "GO" or t == "START" or t == "READY" then return true end
    local n = tonumber(t)
    return n ~= nil and n >= 0 and n <= 10
end
local function safeModeInDuelCountdown()
    local label = safeModeGetCountdownLabel()
    return label and safeModeCountdownNumber(label.Text) or false
end
local function safeModeHoldingBrainrot()
    local ok, val = pcall(function() return LP:GetAttribute("Stealing") end)
    if ok and val == true then return true end
    local ok2, val2 = pcall(function() return LP:GetAttribute("AntiKick") end)
    if ok2 and val2 == true then return true end
    if brainrotDetected then return true end
    local char = LP.Character
    if not char then return false end
    local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok3 and val3 == true then return true end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name:lower()
            if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then return true end
        end
    end
    return false
end
local function safeModeIsLocked()
    if not safeModeEnabled then return false end
    return safeModeInDuelCountdown() or safeModeHoldingBrainrot()
end
local function safeModeForceStop(reason)
    if autoBatEnabled then
        autoBatEnabled=false
        if stopBatAimbot then pcall(stopBatAimbot) end
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
    end
    if autoLeftEnabled then
        autoLeftEnabled=false
        if stopAutoLeft then pcall(stopAutoLeft) end
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
    end
    if autoRightEnabled then
        autoRightEnabled=false
        if stopAutoRight then pcall(stopAutoRight) end
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobBtnRefs and mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
    end
end
local function safeModeTryStart()
    return true
end
local function enableSafeMode() safeModeEnabled = false end
local function disableSafeMode() safeModeEnabled = false end
safeModeEnabled = false
antiKickEnabled = false
_antiKickConns = {}
enableAntiKick = function()
    antiKickEnabled = false
    brainrotDetected = false
end
disableAntiKick = function()
    antiKickEnabled = false
    brainrotDetected = false
    for _, c in ipairs(_antiKickConns) do pcall(function() c:Disconnect() end) end
    _antiKickConns = {}
end

-- ============================================================
-- MAIN GUI
-- ============================================================
local function buildGui()
    clearPersistentConns()
    pcall(createStealBar)
    local th = getTheme()
    local BG, BG2, ROW_BG, ROW_BORDER = th.BG, th.BG2, th.ROW_BG, th.ROW_BORDER
    local WHITE, GRAY, INP = th.WHITE, th.GRAY, th.INP
    local PINK, PINK2, PINK3 = th.ACCENT, th.ACCENT2, th.ACCENT3
    local OFF, TAB_ACTIVE, TAB_INACT, SECT_LBL = th.OFF, th.ACCENT, th.GRAY, th.SECT
    local animUI
    pcall(function() if mainGuiRef then mainGuiRef:Destroy() end end)
    mainGuiRef = nil
    pcall(function() destroyOldGui("K7Duels") end)
    pcall(function()
        local cg=game:GetService("CoreGui")
        local o=cg:FindFirstChild("K7Duels"); if o then o:Destroy() end
        local pg=LP:FindFirstChild("PlayerGui")
        if pg then local o2=pg:FindFirstChild("K7Duels"); if o2 then o2:Destroy() end end
    end)
    local gui=Instance.new("ScreenGui");gui.Name="K7Duels";gui.ResetOnSpawn=false;gui.DisplayOrder=10;gui.IgnoreGuiInset=true
    parentGui(gui)
    mainGuiRef = gui
    local W, H = 300, 420
    mainFrame=Instance.new("Frame",gui);mainFrame.Name="Main"
    mainFrame.Size=UDim2.new(0,W,0,H);mainFrame.Position=UDim2.new(0.5,-W/2,0.5,-H/2)
    mainFrame.BackgroundColor3=BG
    mainFrame.BackgroundTransparency=0
    mainFrame.BorderSizePixel=0;mainFrame.ClipsDescendants=true;mainFrame.ZIndex=5
    Instance.new("UICorner",mainFrame).CornerRadius=UDim.new(0,12)
    local mfStroke=Instance.new("UIStroke",mainFrame)
    mfStroke.Color=Color3.fromRGB(0,0,0);mfStroke.Thickness=2;mfStroke.Transparency=0
    local mainUiScale = Instance.new("UIScale", mainFrame)
    mainUiScale.Name = "MainUIScale"
    do
        local s = tonumber(uiScale) or 0.80
        if s < 0.5 then s = 0.5 elseif s > 2 then s = 2 end
        uiScale = s
        mainUiScale.Scale = s
    end
    local function applyMainUiScale(v)
        local s = tonumber(v)
        if not s then return false end
        if s < 0.5 then s = 0.5 elseif s > 2 then s = 2 end
        uiScale = s
        if mainFrame and mainFrame.Parent then
            local sc = mainFrame:FindFirstChild("MainUIScale")
            if not sc then
                sc = Instance.new("UIScale")
                sc.Name = "MainUIScale"
                sc.Parent = mainFrame
            end
            sc.Scale = s
        end
        return true
    end
    _G._K7ApplyMainUiScale = applyMainUiScale

    local customBg = Instance.new("ImageLabel", mainFrame)
    customBg.Name = "CustomBg"
    customBg.Size = UDim2.fromScale(1, 1)
    customBg.BackgroundTransparency = 1
    customBg.ScaleType = Enum.ScaleType.Crop
    customBg.ImageTransparency = 1
    customBg.Visible = false
    customBg.ZIndex = 1
    Instance.new("UICorner", customBg).CornerRadius = UDim.new(0, 12)

    local selectedBgId = "93489483341327"
    local bgOpacity = 0.95
    pcall(function()
        if getgenv and type(getgenv()._K7SelectedBgId) == "string" and getgenv()._K7SelectedBgId ~= "" and getgenv()._K7SelectedBgId ~= "0" then
            selectedBgId = getgenv()._K7SelectedBgId
        elseif type(_G._K7SelectedBgId) == "string" and _G._K7SelectedBgId ~= "" and _G._K7SelectedBgId ~= "0" then
            selectedBgId = _G._K7SelectedBgId
        end
        if getgenv and type(getgenv()._K7BgOpacity) == "number" then
            bgOpacity = getgenv()._K7BgOpacity
        elseif type(_G._K7BgOpacity) == "number" then
            bgOpacity = _G._K7BgOpacity
        end
    end)
    do
        local hasBg = selectedBgId ~= "" and selectedBgId ~= "0"
        if hasBg then
            customBg.Image = "rbxassetid://" .. selectedBgId
            customBg.ImageTransparency = math.clamp(1 - bgOpacity, 0.02, 0.4)
            customBg.Visible = true
            mainFrame.BackgroundTransparency = 0.8
            task.spawn(function()
                pcall(function()
                    game:GetService("ContentProvider"):PreloadAsync({customBg.Image})
                end)
            end)
        end
    end
    local headerRef, headerFixRef, tabBarRef, miniBtnRef = nil, nil, nil, nil
    local function ensureBgImage(parent, cornerR)
        if not parent then return nil end
        local img = parent:FindFirstChild("CustomBgImg")
        if not img then
            img = Instance.new("ImageLabel")
            img.Name = "CustomBgImg"
            img.Size = UDim2.fromScale(1, 1)
            img.BackgroundTransparency = 1
            img.ScaleType = Enum.ScaleType.Crop
            img.ZIndex = (parent.ZIndex or 1)
            img.Visible = false
            if cornerR then
                Instance.new("UICorner", img).CornerRadius = UDim.new(0, cornerR)
            end
            img.Parent = parent
        end
        return img
    end
    local function setExtraBg(parent, hasBg, cornerR)
        if not parent then return end
        local img = ensureBgImage(parent, cornerR)
        if hasBg then
            img.Image = "rbxassetid://" .. selectedBgId
            img.ImageTransparency = math.clamp(1 - bgOpacity, 0.02, 0.4)
            img.Visible = true
            if parent:IsA("GuiObject") then
                parent.BackgroundTransparency = math.max(parent.BackgroundTransparency, 0.55)
            end
        else
            img.Image = ""
            img.ImageTransparency = 1
            img.Visible = false
        end
    end
    local function applyCustomBg(id, op)
        selectedBgId = tostring(id or "")
        bgOpacity = tonumber(op) or bgOpacity
        local hasBg = selectedBgId ~= "" and selectedBgId ~= "0"
        local rowT = hasBg and 0.55 or 0
        local chromeT = hasBg and 0.65 or 0
        local frameT = hasBg and 0.8 or 0
        pcall(function()
            if getgenv then
                getgenv()._K7SelectedBgId = hasBg and selectedBgId or ""
                getgenv()._K7BgOpacity = bgOpacity
            end
            _G._K7SelectedBgId = hasBg and selectedBgId or ""
            _G._K7BgOpacity = bgOpacity
        end)
        if hasBg then
            customBg.Image = "rbxassetid://" .. selectedBgId
            customBg.ImageTransparency = math.clamp(1 - bgOpacity, 0.02, 0.4)
            customBg.Visible = true
            task.spawn(function()
                pcall(function()
                    game:GetService("ContentProvider"):PreloadAsync({customBg.Image})
                end)
            end)
        else
            customBg.Image = ""
            customBg.ImageTransparency = 1
            customBg.Visible = false
        end
        mainFrame.BackgroundTransparency = frameT
        if headerRef then headerRef.BackgroundTransparency = chromeT end
        if headerFixRef then headerFixRef.BackgroundTransparency = chromeT end
        if tabBarRef then tabBarRef.BackgroundTransparency = chromeT end
        if miniBtnRef then
            local img = miniBtnRef:FindFirstChild("MiniCircle") and miniBtnRef.MiniCircle:FindFirstChild("MiniBg")
            if img then
                k7ApplyMiniLogo(img)
            end
        end
        pcall(function()
            local bar = stealBarFrame
            if not bar or not bar.Parent then
                local function findBar(root)
                    if not root then return nil end
                    local sg = root:FindFirstChild("K7InfoBar") or root:FindFirstChild("K7StealBar")
                    if sg then return sg:FindFirstChild("K7StealBarFrame") or sg end
                    return nil
                end
                bar = findBar(game:GetService("CoreGui"))
                if not bar and _gethui then
                    local h = nil
                    pcall(function() h = _gethui() end)
                    bar = findBar(h)
                end
                if not bar and LP then
                    bar = findBar(LP:FindFirstChild("PlayerGui"))
                end
            end
            if bar then
                local solidBg, banner = nil, nil
                for _, ch in ipairs(bar:GetChildren()) do
                    if ch:IsA("Frame") then
                        if ch:FindFirstChild("BannerLabel") or (type(ch.Name) == "string" and ch.Name:lower():find("banner")) then
                            banner = ch
                        elseif not solidBg then
                            solidBg = ch
                        end
                    end
                end
                if solidBg then
                    setExtraBg(solidBg, hasBg, 9)
                    if hasBg then solidBg.BackgroundTransparency = 0.55 else solidBg.BackgroundTransparency = 0.08 end
                else
                    setExtraBg(bar, hasBg, 9)
                end
                if banner and banner:IsA("Frame") then
                    setExtraBg(banner, hasBg, 9)
                    if hasBg then banner.BackgroundTransparency = 0.5 else banner.BackgroundTransparency = 0.15 end
                end
            end
        end)
        pcall(function()
            for _, f in ipairs(bgAwareFrames or {}) do
                if f and f.Parent then
                    f.BackgroundTransparency = rowT
                end
            end
            for _, d in ipairs(mainFrame:GetDescendants()) do
                if d:GetAttribute("BgAware") then
                    d.BackgroundTransparency = rowT
                elseif d:IsA("Frame") and d.Parent and d.Parent:GetAttribute("BgAware") then
                    if d.BackgroundTransparency < 0.85 then
                        d.BackgroundTransparency = hasBg and 0.35 or 0
                    end
                elseif (d:IsA("TextButton") or d:IsA("TextBox")) and d.Parent and d.Parent:GetAttribute("BgAware") then
                    if d.BackgroundTransparency < 0.85 and d.Text ~= "X" and d.Text ~= "-" then
                        d.BackgroundTransparency = hasBg and 0.3 or 0
                    end
                end
            end
        end)
    end

    local function dragHandle(handle)
        local dn,ds,sp,di=false
        handle.InputBegan:Connect(function(i)
            if uiLocked then return end
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                dn=true;ds=i.Position;sp=mainFrame.Position
                i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dn=false end end)
            end
        end)
        handle.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end)
        trackConn(UIS.InputChanged:Connect(function(i)
            if i==di and dn and not uiLocked then
                mainFrame.Position=UDim2.new(sp.X.Scale,sp.X.Offset+(i.Position.X-ds.X),sp.Y.Scale,sp.Y.Offset+(i.Position.Y-ds.Y))
            end
        end))
    end
    pcall(function() applyCustomBg(selectedBgId, bgOpacity) end)
    local headerH = 40
    local header=Instance.new("Frame",mainFrame)
    header.Name = "Header"
    header.Size=UDim2.new(1,0,0,headerH)
    header.BackgroundColor3=BG;header.BorderSizePixel=0;header.ZIndex=6
    local headerUic=Instance.new("UICorner",header)
    headerUic.CornerRadius=UDim.new(0,12)
    headerRef = header
    local headerFix=Instance.new("Frame",mainFrame)
    headerFix.Name = "HeaderFix"
    headerFix.Size=UDim2.new(1,0,0,14);headerFix.Position=UDim2.new(0,0,0,headerH-12)
    headerFix.BackgroundColor3=BG;headerFix.BorderSizePixel=0;headerFix.ZIndex=5
    headerFixRef = headerFix
    pcall(function()
        if type(applyCustomBg) == "function" then
            applyCustomBg(selectedBgId, bgOpacity)
        end
    end)
    local accentTick=Instance.new("Frame",header)
    accentTick.Size=UDim2.new(0,3,0,16);accentTick.Position=UDim2.new(0,10,0.5,-8)
    accentTick.BackgroundColor3=PINK;accentTick.BorderSizePixel=0;accentTick.ZIndex=8
    Instance.new("UICorner",accentTick).CornerRadius=UDim.new(1,0)
    local hDivider=Instance.new("Frame",mainFrame)
    hDivider.Size=UDim2.new(1,-20,0,1);hDivider.Position=UDim2.new(0,10,0,headerH)
    hDivider.BackgroundColor3=Color3.fromRGB(32,60,110);hDivider.BackgroundTransparency=0.35;hDivider.BorderSizePixel=0;hDivider.ZIndex=7
    dragHandle(header)
    local titleLbl=Instance.new("TextLabel",header)
    titleLbl.Size=UDim2.new(1,-120,0,18);titleLbl.Position=UDim2.new(0,18,0,4)
    titleLbl.BackgroundTransparency=1;titleLbl.Text="Visible Hub"
    titleLbl.TextColor3=WHITE;titleLbl.Font=Enum.Font.GothamMedium
    titleLbl.TextSize=13;titleLbl.TextXAlignment=Enum.TextXAlignment.Left;titleLbl.ZIndex=8
    local discSmall=Instance.new("TextLabel",header)
    discSmall.Size=UDim2.new(0,120,0,12);discSmall.Position=UDim2.new(0,18,0,22)
    discSmall.BackgroundTransparency=1;discSmall.Text="Made By Scoom"
    discSmall.TextColor3=Color3.fromRGB(120,155,205);discSmall.Font=Enum.Font.Gotham
    discSmall.TextSize=9;discSmall.TextXAlignment=Enum.TextXAlignment.Left;discSmall.ZIndex=8
    local pingFpsLbl=Instance.new("TextLabel",header)
    pingFpsLbl.Size=UDim2.new(0,88,0,12);pingFpsLbl.Position=UDim2.new(1,-122,0,14)
    pingFpsLbl.BackgroundTransparency=1;pingFpsLbl.Text="-- ms  ·  -- fps"
    pingFpsLbl.TextColor3=Color3.fromRGB(110,150,200);pingFpsLbl.Font=Enum.Font.Code
    pingFpsLbl.TextSize=9;pingFpsLbl.TextXAlignment=Enum.TextXAlignment.Right;pingFpsLbl.ZIndex=8
    task.spawn(function()
        local frames=0;local t0=tick()
        while pingFpsLbl and pingFpsLbl.Parent do
            frames=frames+1;local now=tick()
            if now-t0>=0.5 then
                local fps=math.floor(frames/(now-t0)+0.5)
                local ms = (type(getPingMs)=="function" and getPingMs()) or 0
                if ms <= 0 then
                    pcall(function()
                        local Stats = game:GetService("Stats")
                        local network = Stats:FindFirstChild("Network") or Stats.Network
                        local serverStats = network and (network:FindFirstChild("ServerStatsItem") or network.ServerStatsItem)
                        local item = serverStats and (serverStats:FindFirstChild("Data Ping") or serverStats["Data Ping"])
                        if item then
                            local v = nil
                            pcall(function() v = item:GetValue() end)
                            if type(v) == "number" then ms = math.floor(v + 0.5)
                            elseif type(v) == "string" then
                                local num = tonumber((tostring(v):match("[%d%.]+")) or "")
                                if num then ms = math.floor(num + 0.5) end
                            end
                        end
                    end)
                end
                if ms <= 0 then
                    pcall(function()
                        local p = LP:GetNetworkPing()
                        if type(p) == "number" and p > 0 then ms = math.floor((p * 1000) + 0.5) end
                    end)
                end
                pingFpsLbl.Text = (ms > 0 and ms or "--") .. " ms  ·  " .. fps .. " fps"
                frames=0;t0=now
            end
            task.wait()
        end
    end)
    local closeBtn=Instance.new("TextButton",header)
    closeBtn.Size=UDim2.new(0,22,0,22);closeBtn.Position=UDim2.new(1,-30,0.5,-11)
    closeBtn.BackgroundColor3=Color3.fromRGB(20,42,76);closeBtn.BorderSizePixel=0
    closeBtn.Text="–";closeBtn.TextColor3=Color3.fromRGB(180,205,235)
    closeBtn.Font=Enum.Font.GothamMedium;closeBtn.TextSize=14;closeBtn.ZIndex=10
    Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
    local miniBtn=Instance.new("TextButton",gui)
    miniBtn.Name="MiniFrame"
    miniBtn.Size=UDim2.new(0,64,0,84)
    miniBtn.Position=UDim2.new(0,16,0.5,-42)
    miniBtn.BackgroundTransparency=1
    miniBtn.BorderSizePixel=0
    miniBtn.Text=""
    miniBtn.AutoButtonColor=false
    miniBtn.ZIndex=20
    miniBtn.Visible=false
    miniBtnRef = miniBtn

    local MiniCircle=Instance.new("Frame",miniBtn)
    MiniCircle.Name="MiniCircle"
    MiniCircle.Size=UDim2.new(0,56,0,56)
    MiniCircle.Position=UDim2.new(0.5,-28,0,0)
    MiniCircle.BackgroundColor3=Color3.fromRGB(6,9,15)
    MiniCircle.BorderSizePixel=0
    MiniCircle.ZIndex=21
    Instance.new("UICorner",MiniCircle).CornerRadius=UDim.new(1,0)
    local miniStroke=Instance.new("UIStroke",MiniCircle)
    miniStroke.Name="MiniStroke"
    miniStroke.Color=Color3.fromRGB(0,0,0)
    miniStroke.Thickness=2
    miniStroke.Transparency=0
    miniStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border

    local MiniBg=Instance.new("ImageLabel",MiniCircle)
    MiniBg.Name="MiniBg"
    MiniBg.Size=UDim2.new(1,0,1,0)
    MiniBg.BackgroundTransparency=1
    MiniBg.BorderSizePixel=0
    MiniBg.ScaleType=Enum.ScaleType.Crop
    MiniBg.ZIndex=22
    Instance.new("UICorner",MiniBg).CornerRadius=UDim.new(1,0)

    local MiniLabel=Instance.new("TextLabel",miniBtn)
    MiniLabel.Name="MiniLabel"
    MiniLabel.Size=UDim2.new(1,0,0,18)
    MiniLabel.Position=UDim2.new(0,0,0,58)
    MiniLabel.BackgroundTransparency=1
    MiniLabel.Text="VISIBLE"
    MiniLabel.TextColor3=Color3.fromRGB(0,190,255)
    MiniLabel.Font=Enum.Font.GothamBlack
    MiniLabel.TextSize=11
    MiniLabel.TextStrokeTransparency=0.3
    MiniLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)
    MiniLabel.ZIndex=23

    k7ApplyMiniLogo(MiniBg)
    pcall(function() if type(applyCustomBg)=="function" then applyCustomBg(selectedBgId, bgOpacity) end end)

    miniBtn.MouseEnter:Connect(function()
        TweenService:Create(miniStroke,TweenInfo.new(0.16),{Transparency=0,Color=Color3.fromRGB(0,0,0)}):Play()
    end)
    miniBtn.MouseLeave:Connect(function()
        TweenService:Create(miniStroke,TweenInfo.new(0.18),{Transparency=0,Color=Color3.fromRGB(0,0,0)}):Play()
    end)

    do
        local mdn,mds,msp,moved=false,nil,nil,false
        miniBtn.InputBegan:Connect(function(i)
            if uiLocked then return end
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                mdn=true;moved=false;mds=i.Position;msp=miniBtn.Position
                i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then mdn=false end end)
            end
        end)
        trackConn(UIS.InputChanged:Connect(function(i)
            if mdn and not uiLocked and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                local dx,dy=i.Position.X-mds.X,i.Position.Y-mds.Y
                if math.abs(dx)+math.abs(dy)>4 then moved=true end
                miniBtn.Position=UDim2.new(msp.X.Scale,msp.X.Offset+dx,msp.Y.Scale,msp.Y.Offset+dy)
            end
        end))
        miniBtn:SetAttribute("K7MiniMoved",false)
        miniBtn.MouseButton1Click:Connect(function()
            if moved then moved=false; return end
            mainFrame.Visible=true;miniBtn.Visible=false
            TweenService:Create(mainFrame,TweenInfo.new(0.18,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,W,0,H)}):Play()
        end)
    end
    closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible=false;miniBtn.Visible=true end)
    local TAB_H = 30
    local contentFrameY = headerH + TAB_H + 1
    local contentH = H - contentFrameY
    local tabBar = Instance.new("Frame", mainFrame)
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, 0, 0, TAB_H)
    tabBar.Position = UDim2.new(0, 0, 0, headerH)
    tabBar.BackgroundColor3 = BG
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 9
    tabBarRef = tabBar
    pcall(function() if type(applyCustomBg)=="function" then applyCustomBg(selectedBgId, bgOpacity) end end)
    local tabBarDivider = Instance.new("Frame", mainFrame)
    tabBarDivider.Size = UDim2.new(1, -20, 0, 1)
    tabBarDivider.Position = UDim2.new(0, 10, 0, headerH + TAB_H)
    tabBarDivider.BackgroundColor3 = Color3.fromRGB(32,60,110)
    tabBarDivider.BackgroundTransparency = 0.4
    tabBarDivider.BorderSizePixel = 0
    tabBarDivider.ZIndex = 10
    local tabNames = {"Main", "Combat", "Visual", "Keybinds", "Settings"}
    local tabPages = {}
    local tabButtons = {}
    local currentTab = "Main"
    local function makePage(name)
        local page = Instance.new("ScrollingFrame", mainFrame)
        page.Name = "Page_" .. name
        page.Size = UDim2.new(1, 0, 0, contentH)
        page.Position = UDim2.new(0, 0, 0, contentFrameY)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = PINK3
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.Visible = false
        page.ZIndex = 8
        page.Active = true
        page.ClipsDescendants = true
        local ll = Instance.new("UIListLayout", page)
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Padding = UDim.new(0, 0)
        local pd = Instance.new("UIPadding", page)
        pd.PaddingLeft = UDim.new(0, 12)
        pd.PaddingRight = UDim.new(0, 12)
        pd.PaddingTop = UDim.new(0, 6)
        pd.PaddingBottom = UDim.new(0, 12)
        return page
    end
    for _, name in ipairs(tabNames) do tabPages[name] = makePage(name) end
    tabPages["Speed"] = tabPages["Main"]
    tabPages["Auto"] = tabPages["Combat"]
    tabPages["Visuals"] = tabPages["Visual"]
    tabPages["Steal"] = tabPages["Combat"]
    local function switchTab(name)
        if not tabPages[name] then return end
        currentTab = name
        if tabLayoutMode == "None" then
            for _, n in ipairs(tabNames) do
                local page = tabPages[n]
                if page then page.Visible = true end
            end
            return
        end
        for _, n in ipairs(tabNames) do
            local page = tabPages[n]
            if page then page.Visible = (n == name) end
        end
        for n, btn in pairs(tabButtons) do
            local active = (n == name)
            btn.TextColor3 = active and WHITE or Color3.fromRGB(130,155,195)
            btn.BackgroundTransparency = 1
            local underline = btn:FindFirstChild("Underline")
            if underline then
                underline.BackgroundTransparency = active and 0 or 1
                underline.BackgroundColor3 = PINK
            end
        end
    end
    local tabBtnW = 1 / #tabNames
    for i, name in ipairs(tabNames) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Name = "Tab_" .. name
        btn.Size = UDim2.new(tabBtnW, -2, 1, -2)
        btn.Position = UDim2.new(tabBtnW * (i - 1), 1, 0, 1)
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(130,155,195)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 11
        btn.AutoButtonColor = false
        btn.ZIndex = 11
        local underline = Instance.new("Frame", btn)
        underline.Name = "Underline"
        underline.Size = UDim2.new(0.42, 0, 0, 2)
        underline.Position = UDim2.new(0.29, 0, 1, -2)
        underline.BackgroundColor3 = PINK
        underline.BackgroundTransparency = 1
        underline.BorderSizePixel = 0
        underline.ZIndex = 12
        Instance.new("UICorner", underline).CornerRadius = UDim.new(1, 0)
        btn.Activated:Connect(function()
            if _anyKeyListening then return end
            switchTab(name)
        end)
        tabButtons[name] = btn
    end
    switchTab("Main")

    local combinedScroll = Instance.new("ScrollingFrame", mainFrame)
    combinedScroll.Name = "CombinedScroll"
    combinedScroll.Size = UDim2.new(1, 0, 0, contentH)
    combinedScroll.Position = UDim2.new(0, 0, 0, contentFrameY)
    combinedScroll.BackgroundTransparency = 1
    combinedScroll.BorderSizePixel = 0
    combinedScroll.ScrollBarThickness = 2
    combinedScroll.ScrollBarImageColor3 = PINK3
    combinedScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    combinedScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    combinedScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    combinedScroll.Visible = false
    combinedScroll.ZIndex = 8
    combinedScroll.Active = true
    combinedScroll.ClipsDescendants = true
    combinedScroll.ElasticBehavior = Enum.ElasticBehavior.Never
    combinedScroll.ScrollingEnabled = true
    local combinedLay = Instance.new("UIListLayout", combinedScroll)
    combinedLay.SortOrder = Enum.SortOrder.LayoutOrder
    combinedLay.Padding = UDim.new(0, 4)
    local combinedPad = Instance.new("UIPadding", combinedScroll)
    combinedPad.PaddingLeft = UDim.new(0, 0)
    combinedPad.PaddingRight = UDim.new(0, 0)
    combinedPad.PaddingTop = UDim.new(0, 2)
    combinedPad.PaddingBottom = UDim.new(0, 8)

    local BASE_H = H
    local BASE_W = W
    local NONE_H = BASE_H
    local NONE_W = 268
    local SIDEBAR_W = 64
    local SIDEBAR_BTN_H = 30
    local SIDEBAR_BTN_GAP = 4
    local _noneSizeConns = {}

    local function setMainSize(w, h)
        W, H = w, h
        mainFrame.Size = UDim2.new(0, w, 0, h)
        local pos = mainFrame.Position
        mainFrame.Position = UDim2.new(0.5, -math.floor(w / 2), pos.Y.Scale, pos.Y.Offset)
    end

    local function clearNoneSizeConns()
        for _, c in ipairs(_noneSizeConns) do
            pcall(function() c:Disconnect() end)
        end
        table.clear(_noneSizeConns)
    end

    local function refreshCombinedCanvas()
        if not combinedScroll or not combinedScroll.Parent then return end
        local total = 8
        for _, name in ipairs(tabNames) do
            local page = tabPages[name]
            if page and page.Parent == combinedScroll then
                local lay = page:FindFirstChildOfClass("UIListLayout")
                local h = 40
                if lay then
                    h = math.max(lay.AbsoluteContentSize.Y + 18, 40)
                else
                    h = math.max(page.AbsoluteSize.Y, 40)
                end
                page.Size = UDim2.new(1, 0, 0, h)
                total = total + h + 6
            end
        end
        combinedScroll.CanvasSize = UDim2.new(0, 0, 0, total + 12)
    end

    local function applyTabLayout(mode)
        mode = mode or tabLayoutMode or "Top"
        if mode ~= "Top" and mode ~= "Sidebar" and mode ~= "Bottom" and mode ~= "None" then
            mode = "Top"
        end
        tabLayoutMode = mode
        clearNoneSizeConns()

        for i, name in ipairs(tabNames) do
            local page = tabPages[name]
            if page and page.Parent == combinedScroll then
                page.Parent = mainFrame
            end
            if page then
                page.ScrollingEnabled = true
                page.AutomaticSize = Enum.AutomaticSize.None
                page.ClipsDescendants = true
                page.CanvasSize = UDim2.new(0, 0, 0, 0)
                page.AutomaticCanvasSize = Enum.AutomaticSize.Y
                local pad = page:FindFirstChildOfClass("UIPadding")
                if pad then
                    pad.PaddingLeft = UDim.new(0, 12)
                    pad.PaddingRight = UDim.new(0, 12)
                end
            end
            local btn = tabButtons[name]
            if btn then
                btn.TextSize = 11
                btn.TextWrapped = false
            end
        end
        combinedScroll.Visible = false
        combinedScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

        local nTabs = #tabNames
        if mode == "None" then
            setMainSize(NONE_W, NONE_H)
            tabBar.Visible = false
            tabBarDivider.Visible = false
            combinedScroll.Visible = true
            combinedScroll.Position = UDim2.new(0, 0, 0, headerH + 2)
            combinedScroll.Size = UDim2.new(1, 0, 0, H - headerH - 4)
            combinedScroll.ScrollingEnabled = true
            combinedScroll.Active = true
            combinedScroll.ScrollBarThickness = 3
            for i, name in ipairs(tabNames) do
                local page = tabPages[name]
                if page then
                    page.Parent = combinedScroll
                    page.Visible = true
                    page.ScrollingEnabled = false
                    page.AutomaticCanvasSize = Enum.AutomaticSize.None
                    page.CanvasSize = UDim2.new(0, 0, 0, 0)
                    page.AutomaticSize = Enum.AutomaticSize.None
                    page.Size = UDim2.new(1, 0, 0, 80)
                    page.Position = UDim2.new(0, 0, 0, 0)
                    page.LayoutOrder = i
                    page.ClipsDescendants = false
                    local pad = page:FindFirstChildOfClass("UIPadding")
                    if pad then
                        pad.PaddingLeft = UDim.new(0, 12)
                        pad.PaddingRight = UDim.new(0, 12)
                        pad.PaddingTop = UDim.new(0, 4)
                        pad.PaddingBottom = UDim.new(0, 8)
                    end
                    local lay = page:FindFirstChildOfClass("UIListLayout")
                    if lay then
                        table.insert(_noneSizeConns, lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                            if tabLayoutMode == "None" then refreshCombinedCanvas() end
                        end))
                    end
                end
            end
            task.defer(refreshCombinedCanvas)
            task.delay(0.15, refreshCombinedCanvas)
            task.delay(0.4, refreshCombinedCanvas)
        elseif mode == "Sidebar" then
            setMainSize(BASE_W, BASE_H)
            tabBar.Visible = true
            tabBarDivider.Visible = true
            tabBar.Size = UDim2.new(0, SIDEBAR_W, 0, H - headerH - 4)
            tabBar.Position = UDim2.new(0, 0, 0, headerH)
            tabBarDivider.Size = UDim2.new(0, 1, 0, H - headerH - 8)
            tabBarDivider.Position = UDim2.new(0, SIDEBAR_W, 0, headerH + 4)
            for i, name in ipairs(tabNames) do
                local btn = tabButtons[name]
                if btn then
                    btn.Size = UDim2.new(1, -8, 0, SIDEBAR_BTN_H)
                    btn.Position = UDim2.new(0, 4, 0, 8 + (i - 1) * (SIDEBAR_BTN_H + SIDEBAR_BTN_GAP))
                    btn.TextSize = 10
                    btn.TextWrapped = true
                    local underline = btn:FindFirstChild("Underline")
                    if underline then
                        underline.Size = UDim2.new(0, 2, 0.55, 0)
                        underline.Position = UDim2.new(0, 0, 0.225, 0)
                        underline.AnchorPoint = Vector2.new(0, 0)
                    end
                end
                local page = tabPages[name]
                if page then
                    page.Position = UDim2.new(0, SIDEBAR_W + 2, 0, headerH + 2)
                    page.Size = UDim2.new(1, -(SIDEBAR_W + 2), 0, H - headerH - 4)
                    page.Visible = (name == currentTab)
                end
            end
        elseif mode == "Bottom" then
            setMainSize(BASE_W, BASE_H)
            tabBar.Visible = true
            tabBarDivider.Visible = true
            tabBar.Size = UDim2.new(1, 0, 0, TAB_H)
            tabBar.Position = UDim2.new(0, 0, 1, -TAB_H)
            tabBarDivider.Size = UDim2.new(1, -20, 0, 1)
            tabBarDivider.Position = UDim2.new(0, 10, 1, -TAB_H)
            local tabBtnW = 1 / nTabs
            for i, name in ipairs(tabNames) do
                local btn = tabButtons[name]
                if btn then
                    btn.Size = UDim2.new(tabBtnW, -2, 1, -2)
                    btn.Position = UDim2.new(tabBtnW * (i - 1), 1, 0, 1)
                    local underline = btn:FindFirstChild("Underline")
                    if underline then
                        underline.Size = UDim2.new(0.42, 0, 0, 2)
                        underline.Position = UDim2.new(0.29, 0, 0, 0)
                        underline.AnchorPoint = Vector2.new(0, 0)
                    end
                end
                local page = tabPages[name]
                if page then
                    page.Position = UDim2.new(0, 0, 0, headerH + 2)
                    page.Size = UDim2.new(1, 0, 0, H - headerH - TAB_H - 4)
                    page.Visible = (name == currentTab)
                end
            end
        else
            setMainSize(BASE_W, BASE_H)
            tabBar.Visible = true
            tabBarDivider.Visible = true
            tabBar.Size = UDim2.new(1, 0, 0, TAB_H)
            tabBar.Position = UDim2.new(0, 0, 0, headerH)
            tabBarDivider.Size = UDim2.new(1, -20, 0, 1)
            tabBarDivider.Position = UDim2.new(0, 10, 0, headerH + TAB_H)
            local tabBtnW = 1 / nTabs
            for i, name in ipairs(tabNames) do
                local btn = tabButtons[name]
                if btn then
                    btn.Size = UDim2.new(tabBtnW, -2, 1, -2)
                    btn.Position = UDim2.new(tabBtnW * (i - 1), 1, 0, 1)
                    local underline = btn:FindFirstChild("Underline")
                    if underline then
                        underline.Size = UDim2.new(0.42, 0, 0, 2)
                        underline.Position = UDim2.new(0.29, 0, 1, -2)
                        underline.AnchorPoint = Vector2.new(0, 0)
                    end
                end
                local page = tabPages[name]
                if page then
                    page.Position = UDim2.new(0, 0, 0, headerH + TAB_H + 1)
                    page.Size = UDim2.new(1, 0, 0, H - headerH - TAB_H - 1)
                    page.Visible = (name == currentTab)
                end
            end
        end
        if mode ~= "None" then
            switchTab(currentTab or "Main")
        end
    end

    task.defer(function()
        pcall(function() applyTabLayout(tabLayoutMode) end)
    end)

    local contentFrame = tabPages["Main"]
    local function mkSectionLbl(parent, txt)
        local spacer=Instance.new("Frame",parent)
        spacer.Size=UDim2.new(1,0,0,10);spacer.BackgroundTransparency=1;spacer.LayoutOrder=#parent:GetChildren()
        local row=Instance.new("Frame",parent)
        row.Size=UDim2.new(1,0,0,14);row.BackgroundTransparency=1;row.LayoutOrder=#parent:GetChildren()
        local l=Instance.new("TextLabel",row)
        l.Size=UDim2.new(1,0,1,0);l.BackgroundTransparency=1
        l.Text=txt;l.TextColor3=Color3.fromRGB(0,190,255)
        l.Font=Enum.Font.GothamMedium;l.TextSize=10
        l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=9
        local line=Instance.new("Frame",row)
        line.Size=UDim2.new(1,-(#txt*6+12),0,1);line.Position=UDim2.new(0,#txt*6+10,0.5,0)
        line.BackgroundColor3=Color3.fromRGB(32,60,110);line.BackgroundTransparency=0.35;line.BorderSizePixel=0;line.ZIndex=9
        local sp2=Instance.new("Frame",parent)
        sp2.Size=UDim2.new(1,0,0,3);sp2.BackgroundTransparency=1;sp2.LayoutOrder=#parent:GetChildren()
    end
    local bgAwareFrames = {}
    local function mkRow(parent, h)
        local f=Instance.new("Frame",parent)
        f.Size=UDim2.new(1,0,0,h or 34)
        f.BackgroundColor3=Color3.fromRGB(16,22,36);f.BorderSizePixel=0;f.ZIndex=8
        f.LayoutOrder=#parent:GetChildren()
        f:SetAttribute("BgAware", true)
        if selectedBgId ~= "" and selectedBgId ~= "0" then
            f.BackgroundTransparency = 0.55
        else
            f.BackgroundTransparency = 0.15
        end
        table.insert(bgAwareFrames, f)
        local stroke=Instance.new("UIStroke",f)
        stroke.Color=Color3.fromRGB(32,60,110);stroke.Thickness=1;stroke.Transparency=0.65
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
        local spacer=Instance.new("Frame",parent)
        spacer.Size=UDim2.new(1,0,0,3);spacer.BackgroundTransparency=1
        spacer.LayoutOrder=#parent:GetChildren()+1
        return f
    end
    local function mkLabel(row, txt)
        local l=Instance.new("TextLabel",row)
        l.Size=UDim2.new(0.58,0,1,0);l.Position=UDim2.new(0,11,0,0)
        l.BackgroundTransparency=1;l.Text=txt
        l.TextColor3=Color3.fromRGB(228,240,255);l.Font=Enum.Font.Gotham
        l.TextSize=12;l.TextXAlignment=Enum.TextXAlignment.Left;l.ZIndex=9
        return l
    end
    local function mkPill(row)
        local pill=Instance.new("Frame",row)
        pill.Size=UDim2.new(0,36,0,18);pill.Position=UDim2.new(1,-46,0.5,-9)
        pill.BackgroundColor3=OFF;pill.BorderSizePixel=0;pill.ZIndex=9
        Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
        local pStroke=Instance.new("UIStroke",pill)
        pStroke.Name="PillStroke";pStroke.Color=ROW_BORDER;pStroke.Thickness=1;pStroke.Transparency=0.55
        local dot=Instance.new("Frame",pill)
        dot.Size=UDim2.new(0,12,0,12);dot.Position=UDim2.new(0,3,0.5,-6)
        dot.BackgroundColor3=GRAY;dot.BorderSizePixel=0;dot.ZIndex=10
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        return pill,dot
    end
    local function animPill(pill, dot, on)
        TweenService:Create(pill,TweenInfo.new(0.14,Enum.EasingStyle.Quad),{BackgroundColor3=on and WHITE or OFF}):Play()
        TweenService:Create(dot,TweenInfo.new(0.14,Enum.EasingStyle.Quad),{
            Position=on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6),
            BackgroundColor3=on and PINK or GRAY
        }):Play()
        local ps=pill:FindFirstChild("PillStroke")
        if ps then TweenService:Create(ps,TweenInfo.new(0.14),{Transparency=on and 0.35 or 0.55, Color=on and PINK or ROW_BORDER}):Play() end
    end
    local function mkToggle(parent, txt, cb)
        local row=mkRow(parent,34);mkLabel(row,txt)
        local pill,dot=mkPill(row)
        local on=false
        local function sv(state) on=state; animPill(pill,dot,state) end
        local clk=Instance.new("TextButton",pill)
        clk.Size=UDim2.new(1,0,1,0)
        clk.BackgroundTransparency=1
        clk.Text=""
        clk.ZIndex=11
        clk.Activated:Connect(function()
            on = not on
            sv(on)
            if cb then local ok, err = pcall(cb, on) end
        end)
        return sv
    end
    local function mkToggleWithMode(parent, txt, options, current, onToggle, onMode)
        local selected = current
        for _, o in ipairs(options or {}) do
            if o == current then selected = o break end
        end
        options = options or {}
        local open = false
        local row = mkRow(parent, 34)
        mkLabel(row, txt)

        local pill, dot = mkPill(row)
        local on = false
        local function sv(state) on = state; animPill(pill, dot, state) end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.ZIndex = 12
        clk.Activated:Connect(function()
            on = not on
            sv(on)
            if onToggle then pcall(onToggle, on) end
        end)

        local valueLbl = Instance.new("TextLabel", row)
        valueLbl.Size = UDim2.new(0, 78, 0, 22)
        valueLbl.Position = UDim2.new(1, -158, 0.5, -11)
        valueLbl.BackgroundTransparency = 1
        valueLbl.Text = tostring(selected)
        valueLbl.TextColor3 = PINK
        valueLbl.Font = Enum.Font.GothamBold
        valueLbl.TextSize = 9
        valueLbl.TextXAlignment = Enum.TextXAlignment.Right
        valueLbl.ZIndex = 11

        local arrow = Instance.new("TextButton", row)
        arrow.Size = UDim2.fromOffset(28, 22)
        arrow.Position = UDim2.new(1, -78, 0.5, -11)
        arrow.BackgroundColor3 = Color3.fromRGB(20,32,52)
        arrow.BackgroundTransparency = 0.15
        arrow.BorderSizePixel = 0
        arrow.Text = "▼"
        arrow.TextColor3 = WHITE
        arrow.Font = Enum.Font.GothamBold
        arrow.TextSize = 11
        arrow.AutoButtonColor = false
        arrow.ZIndex = 12
        Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 6)
        local arrowStroke = Instance.new("UIStroke", arrow)
        arrowStroke.Color = ROW_BORDER
        arrowStroke.Thickness = 1
        arrowStroke.Transparency = 0.35

        local drop = Instance.new("Frame", parent)
        drop.Size = UDim2.new(1, 0, 0, 0)
        drop.BackgroundTransparency = 1
        drop.BorderSizePixel = 0
        drop.ClipsDescendants = true
        drop.LayoutOrder = (row.LayoutOrder or 0) + 1
        drop.ZIndex = 8

        local panel = Instance.new("Frame", drop)
        panel.Size = UDim2.new(1, 0, 0, 34)
        panel.BackgroundColor3 = ROW_BG
        panel.BackgroundTransparency = 0.12
        panel.BorderSizePixel = 0
        panel.ZIndex = 9
        Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 8)
        local panelStroke = Instance.new("UIStroke", panel)
        panelStroke.Color = ROW_BORDER
        panelStroke.Thickness = 1
        panelStroke.Transparency = 0.3

        local optionBoxes, optionStrokes = {}, {}
        local function refreshGlow()
            for opt, box in pairs(optionBoxes) do
                local active = (opt == selected)
                box.BackgroundTransparency = 1
                local lbl = box:FindFirstChild("Label")
                if lbl then lbl.TextColor3 = active and PINK or WHITE end
                local s = optionStrokes[opt]
                if s then
                    s.Color = active and PINK or ROW_BORDER
                    s.Transparency = active and 0.05 or 0.4
                    s.Thickness = active and 1.6 or 1
                end
            end
        end

        for i, opt in ipairs(options) do
            local box = Instance.new("Frame", panel)
            box.Size = UDim2.new(1 / math.max(#options, 1), -8, 1, -8)
            box.Position = UDim2.new((i - 1) / math.max(#options, 1), 4, 0, 4)
            box.BackgroundTransparency = 1
            box.BorderSizePixel = 0
            box.ZIndex = 14
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

            local b = Instance.new("TextButton", box)
            b.Name = "Label"
            b.Size = UDim2.fromScale(1, 1)
            b.BackgroundTransparency = 1
            b.BorderSizePixel = 0
            b.Text = opt
            b.TextColor3 = WHITE
            b.Font = Enum.Font.GothamBold
            b.TextSize = 10
            b.ZIndex = 15
            b.AutoButtonColor = false

            optionBoxes[opt] = box
            local s = Instance.new("UIStroke", box)
            s.Color = ROW_BORDER
            s.Thickness = 1
            s.Transparency = 0.4
            optionStrokes[opt] = s

            b.Activated:Connect(function()
                if _anyKeyListening then return end
                selected = opt
                valueLbl.Text = selected
                refreshGlow()
                if onMode then pcall(onMode, selected) end
            end)
        end
        refreshGlow()

        arrow.Activated:Connect(function()
            if _anyKeyListening then return end
            open = not open
            arrow.Text = open and "▲" or "▼"
            TweenService:Create(drop, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                Size = open and UDim2.new(1, 0, 0, 38) or UDim2.new(1, 0, 0, 0)
            }):Play()
        end)

        return sv
    end
    local function mkBoxRow(parent, txt, default, cb)
        local row=mkRow(parent,34);mkLabel(row,txt)
        local tb=Instance.new("TextBox",row)
        tb.Size=UDim2.new(0,54,0,20);tb.Position=UDim2.new(1,-62,0.5,-10)
        tb.BackgroundColor3=Color3.fromRGB(10,15,26);tb.BorderSizePixel=0
        tb.Text=tostring(default);tb.TextColor3=Color3.fromRGB(228,240,255)
        tb.Font=Enum.Font.Code;tb.TextSize=11
        tb.ClearTextOnFocus=false;tb.ZIndex=9
        Instance.new("UICorner",tb).CornerRadius=UDim.new(0,5)
        local tbs=Instance.new("UIStroke",tb);tbs.Color=Color3.fromRGB(32,60,110);tbs.Thickness=1;tbs.Transparency=0.5
        tb.FocusLost:Connect(function()
            if cb then local n=tonumber(tb.Text);if n then cb(n) else tb.Text=tostring(default) end end
        end)
        return tb
    end
    local GAMEPAD_KEYS={[Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,[Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,[Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,[Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true}
    local function isGamepadInput(inp) return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad")~=nil end
    local function isBindableInput(inp)
        if not inp or inp.KeyCode==Enum.KeyCode.Unknown then return false end
        if inp.UserInputType==Enum.UserInputType.Keyboard then return true end
        return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode]==true
    end
    local function kbMatch(entry,kc)
        if not kc or kc == Enum.KeyCode.Unknown then return false end
        if not entry or type(entry)~="table" then return false end
        if entry.kb == nil and entry.gp == nil then return false end
        local ok, hit = pcall(function()
            if entry.kb ~= nil and kc == entry.kb then return true end
            if entry.gp ~= nil and kc == entry.gp then return true end
            return false
        end)
        return ok and hit == true
    end
    local function formatKeybindText(entry)
        if not entry then return "..." end
        local parts = {}
        if entry.kb then table.insert(parts, entry.kb.Name) end
        if entry.gp then table.insert(parts, entry.gp.Name) end
        if #parts == 0 then return "..." end
        return table.concat(parts, " / ")
    end
    local function mkKBButton(row, kbEntry, cb)
        local function getLabel() return formatKeybindText(kbEntry) end
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,90,0,22);btn.Position=UDim2.new(1,-98,0.5,-11)
        btn.BackgroundColor3=INP;btn.BorderSizePixel=0
        btn.Text=getLabel();btn.TextColor3=WHITE
        btn.Font=Enum.Font.GothamMedium;btn.TextSize=10
        btn.TextTruncate=Enum.TextTruncate.AtEnd
        btn.AutoButtonColor=false;btn.ZIndex=9
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
        local kbs=Instance.new("UIStroke",btn);kbs.Color=ROW_BORDER;kbs.Thickness=1;kbs.Transparency=0.4
        local li=false;local lc;local pv=btn.Text;local ls=0
        btn.Activated:Connect(function()
            if li then
                li=false;_anyKeyListening=false
                if lc then lc:Disconnect();lc=nil end
                btn.Text=getLabel();btn.TextColor3=PINK
                return
            end
            pv=btn.Text;li=true;_anyKeyListening=true;ls=tick()
            btn.Text="Press key...";btn.TextColor3=WHITE
            lc=UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode==Enum.KeyCode.Escape then
                    li=false;_anyKeyListening=false
                    if lc then lc:Disconnect();lc=nil end
                    btn.Text=getLabel();btn.TextColor3=PINK
                    return
                end
                local isGp=isGamepadInput(inp)
                if isGp and not(tick()-ls>=0.15) then return end
                if not isBindableInput(inp) then return end
                if isGp then kbEntry.gp=inp.KeyCode
                else kbEntry.kb=inp.KeyCode end
                li=false;_anyKeyListening=false
                if lc then lc:Disconnect();lc=nil end
                btn.Text=getLabel();btn.TextColor3=PINK
                if cb then cb(inp.KeyCode,isGp) end
                pcall(saveConfig)
            end)
        end)
        return btn
    end
    local function mkKBRow(parent, txt, kbEntry, onKB)
        local row=mkRow(parent,34);mkLabel(row,txt)
        mkKBButton(row,kbEntry,function(k,isGp) if onKB then onKB(k,isGp) end end)
        return row
    end

    -- Speed tab
    local pg=tabPages["Speed"]
    mkSectionLbl(pg,"Speed Cycle")
    do
        local options = {"V1", "V2"}
        local selected = (speedCycleMode == "V2") and "V2" or "V1"
        local open = false

        local row = mkRow(pg, 34)
        mkLabel(row, "Cycle Mode")

        local valueLbl = Instance.new("TextLabel", row)
        valueLbl.Size = UDim2.new(0, 78, 0, 22)
        valueLbl.Position = UDim2.new(1, -110, 0.5, -11)
        valueLbl.BackgroundTransparency = 1
        valueLbl.Text = selected
        valueLbl.TextColor3 = PINK
        valueLbl.Font = Enum.Font.GothamBold
        valueLbl.TextSize = 9
        valueLbl.TextXAlignment = Enum.TextXAlignment.Right
        valueLbl.ZIndex = 11

        local arrow = Instance.new("TextButton", row)
        arrow.Size = UDim2.fromOffset(28, 22)
        arrow.Position = UDim2.new(1, -30, 0.5, -11)
        arrow.BackgroundColor3 = Color3.fromRGB(20,32,52)
        arrow.BackgroundTransparency = 0.15
        arrow.BorderSizePixel = 0
        arrow.Text = "▼"
        arrow.TextColor3 = WHITE
        arrow.Font = Enum.Font.GothamBold
        arrow.TextSize = 11
        arrow.AutoButtonColor = false
        arrow.ZIndex = 12
        Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 6)
        local arrowStroke = Instance.new("UIStroke", arrow)
        arrowStroke.Color = ROW_BORDER
        arrowStroke.Thickness = 1
        arrowStroke.Transparency = 0.35

        local drop = Instance.new("Frame", pg)
        drop.Size = UDim2.new(1, 0, 0, 0)
        drop.BackgroundTransparency = 1
        drop.BorderSizePixel = 0
        drop.ClipsDescendants = true
        drop.LayoutOrder = (row.LayoutOrder or 0) + 1
        drop.ZIndex = 8

        local panel = Instance.new("Frame", drop)
        panel.Size = UDim2.new(1, 0, 0, 34)
        panel.BackgroundColor3 = ROW_BG
        panel.BackgroundTransparency = 0.12
        panel.BorderSizePixel = 0
        panel.ZIndex = 9
        Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 8)
        local panelStroke = Instance.new("UIStroke", panel)
        panelStroke.Color = ROW_BORDER
        panelStroke.Thickness = 1
        panelStroke.Transparency = 0.3

        local optionBoxes, optionStrokes = {}, {}
        local function refreshGlow()
            for opt, box in pairs(optionBoxes) do
                local active = (opt == selected)
                box.BackgroundTransparency = 1
                local lbl = box:FindFirstChild("Label")
                if lbl then lbl.TextColor3 = active and PINK or WHITE end
                local s = optionStrokes[opt]
                if s then
                    s.Color = active and PINK or ROW_BORDER
                    s.Transparency = active and 0.05 or 0.4
                    s.Thickness = active and 1.6 or 1
                end
            end
        end

        for i, opt in ipairs(options) do
            local box = Instance.new("Frame", panel)
            box.Size = UDim2.new(1 / #options, -8, 1, -8)
            box.Position = UDim2.new((i - 1) / #options, 4, 0, 4)
            box.BackgroundTransparency = 1
            box.BorderSizePixel = 0
            box.ZIndex = 14
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

            local b = Instance.new("TextButton", box)
            b.Name = "Label"
            b.Size = UDim2.fromScale(1, 1)
            b.BackgroundTransparency = 1
            b.BorderSizePixel = 0
            b.Text = opt
            b.TextColor3 = WHITE
            b.Font = Enum.Font.GothamBold
            b.TextSize = 10
            b.ZIndex = 15
            b.AutoButtonColor = false

            optionBoxes[opt] = box
            local s = Instance.new("UIStroke", box)
            s.Color = ROW_BORDER
            s.Thickness = 1
            s.Transparency = 0.4
            optionStrokes[opt] = s

            b.Activated:Connect(function()
                if _anyKeyListening then return end
                selected = opt
                speedCycleMode = (opt == "V2") and "V2" or "V1"
                valueLbl.Text = selected
                refreshGlow()
                saveConfig()
            end)
        end
        refreshGlow()

        arrow.Activated:Connect(function()
            if _anyKeyListening then return end
            open = not open
            arrow.Text = open and "▲" or "▼"
            TweenService:Create(drop, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                Size = open and UDim2.new(1, 0, 0, 38) or UDim2.new(1, 0, 0, 0)
            }):Play()
        end)
    end
    mkSectionLbl(pg,"Normal Mode")
    normalBox=mkBoxRow(pg,"Normal Speed",NS,function(v) if v>0 and v<=500 then NS=v end;saveConfig() end)
    carryBox=mkBoxRow(pg,"Carry Speed",CS,function(v) if v>0 and v<=500 then CS=v end;saveConfig() end)
    mkSectionLbl(pg,"Lagger Mode")
    laggerBox=mkBoxRow(pg,"Lagger Speed",LAGGER_SPEED,function(v) if v>0 and v<=500 then LAGGER_SPEED=v end;saveConfig() end)
    laggerCarryBox=mkBoxRow(pg,"Lagger Carry Speed",LAGGER_CARRY_SPEED,function(v) if v>0 and v<=500 then LAGGER_CARRY_SPEED=v end;saveConfig() end)
    do
        local switchRow = mkRow(pg, 34)
        mkLabel(switchRow, "Auto Switch Speed")
        local switchPill = Instance.new("Frame", switchRow)
        switchPill.Size = UDim2.new(0, 40, 0, 20)
        switchPill.Position = UDim2.new(1, -50, 0.5, -10)
        switchPill.BackgroundColor3 = OFF
        switchPill.BorderSizePixel = 0
        switchPill.ZIndex = 9
        Instance.new("UICorner", switchPill).CornerRadius = UDim.new(1, 0)
        local switchStroke = Instance.new("UIStroke", switchPill)
        switchStroke.Name = "PillStroke"
        switchStroke.Color = ROW_BORDER
        switchStroke.Thickness = 1
        switchStroke.Transparency = 0.45
        local switchDot = Instance.new("Frame", switchPill)
        switchDot.Size = UDim2.new(0, 14, 0, 14)
        switchDot.Position = UDim2.new(0, 3, 0.5, -7)
        switchDot.BackgroundColor3 = GRAY
        switchDot.BorderSizePixel = 0
        switchDot.ZIndex = 10
        Instance.new("UICorner", switchDot).CornerRadius = UDim.new(1, 0)
        local function setAutoSwitchVisual(state) animPill(switchPill, switchDot, state) end
        setAutoSwitchVisual(autoSwitchSpeedEnabled == true)
        local switchClick = Instance.new("TextButton", switchPill)
        switchClick.Size = UDim2.new(1, 0, 1, 0)
        switchClick.BackgroundTransparency = 1
        switchClick.Text = ""
        switchClick.ZIndex = 11
        switchClick.Activated:Connect(function()
            autoSwitchSpeedEnabled = not autoSwitchSpeedEnabled
            setAutoSwitchVisual(autoSwitchSpeedEnabled)
            pcall(updateAutoSwitchSpeed)
            saveConfig()
        end)
    end

    -- Combat tab
    pg=tabPages["Combat"]
    mkSectionLbl(pg,"Combat")
    setInfJumpVisual=mkToggleWithMode(pg,"Infinite Jump",
        {"Manual","Hold"},
        (InfJump.mode=="hold") and "Hold" or "Manual",
        function(on)
            InfJump:toggle(on)
            saveConfig()
        end,
        function(mode)
            local m = (mode == "Hold") and "hold" or "manual"
            InfJump:setMode(m)
            if InfJump.enabled and m == "hold" then startHoldMode() end
            saveConfig()
        end
    )
    setAntiRagVisual=mkToggleWithMode(pg,"Anti Ragdoll",
        {"V1","V2"},
        (antiRagdollMode == "V2") and "V2" or "V1",
        function(on)
            antiRagdollEnabled = on
            if on then startAntiRagdoll() else stopAntiRagdoll() end
            saveConfig()
        end,
        function(mode)
            antiRagdollMode = (mode == "V2") and "V2" or "V1"
            if antiRagdollEnabled then
                stopAntiRagdoll()
                task.wait(0.05)
                startAntiRagdoll()
            end
            saveConfig()
        end
    )

    tpBatVersion = (_G._VisibleTPBat and _G._VisibleTPBat.version) or tpBatVersion or "V1"
    local function _setCamLock(on)
        on = on == true
        if _G._AmbitiousSetTPBatCameraLock then
            _G._AmbitiousSetTPBatCameraLock(on)
        end
        if _G._VisibleTPBat then
            _G._VisibleTPBat.cameraLock = on
        end
    end
    local function _getCamLock()
        if _G._AmbitiousGetTPBatCameraLock then
            return _G._AmbitiousGetTPBatCameraLock() == true
        end
        return _G._VisibleTPBat and _G._VisibleTPBat.cameraLock == true
    end

    setTpBatCamLockVisual=mkToggle(pg, "TP Camera Lock", function(on)
        _setCamLock(on)
        saveConfig()
    end)
    if setTpBatCamLockVisual then pcall(setTpBatCamLockVisual, _getCamLock()) end

    setAimbotVisual=mkToggleWithMode(pg,"Aimbot",
        {"Default","Bypass","Bypass V2"},
        (aimbotMode == "Bypass V2" and "Bypass V2") or (aimbotMode == "Bypass" and "Bypass") or "Default",
        function(on)
            if on then
                if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end end
                if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end end
                queueAutoBatStart()
            else
                stopBatAimbot()
                if autoBatSetVisual then autoBatSetVisual(false) end
                if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end
            end
            saveConfig()
        end,
        function(mode)
            if mode == "Bypass V2" then
                aimbotMode = "Bypass V2"
            elseif mode == "Bypass" then
                aimbotMode = "Bypass"
            else
                aimbotMode = "Default"
            end
            if autoBatEnabled or batAimbotEnabled then
                -- instant restart, no delay (Ace-style)
                pcall(stopBatAimbot)
                pcall(startBatAimbot)
            end
            saveConfig()
        end
    )
    autoBatSetVisual = setAimbotVisual
    setBatAimbotVisual = setAimbotVisual

    setTpBatVisual=mkToggle(pg,"TP Bat",function(on)
        -- Clean Hub full TP Bat only (no V1/V2/V3/Cam modes)
        if type(toggleVisibleTpBat) == "function" then
            toggleVisibleTpBat(on)
        elseif _G.toggleVisibleTpBat then
            _G.toggleVisibleTpBat(on)
        end
        saveConfig()
    end)
    if setTpBatVisual and _G._VisibleTPBat and _G._VisibleTPBat.enabled then
        pcall(setTpBatVisual, true)
    end


    do
        local row = mkRow(pg, 34)
        mkLabel(row, "Aimbot Speed")
        local speedBox = Instance.new("TextBox", row)
        speedBox.Size = UDim2.new(0, 58, 0, 22)
        speedBox.Position = UDim2.new(1, -66, 0.5, -11)
        speedBox.BackgroundColor3 = INP
        speedBox.BorderSizePixel = 0
        speedBox.Text = tostring(AIMBOT_SPEED or 50)
        speedBox.TextColor3 = PINK
        speedBox.Font = Enum.Font.GothamBold
        speedBox.TextSize = 10
        speedBox.ClearTextOnFocus = false
        speedBox.ZIndex = 9
        Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 5)
        speedBox.FocusLost:Connect(function()
            local n = tonumber(speedBox.Text)
            if n and n >= 10 and n <= 200 then
                AIMBOT_SPEED = n
                speedBox.Text = tostring(n)
                saveConfig()
            else
                speedBox.Text = tostring(AIMBOT_SPEED or 50)
            end
        end)
    end

    batCounterMode = batCounterMode or "V1"
    _G.AmbitiousBatCounterV2On = false
    setBatCounterVisual=mkToggleWithMode(pg,"Bat Counter",
        {"V1","V2"},
        (batCounterMode == "V2") and "V2" or "V1",
        function(on)
            batCounterEnabled = on
            if on then startBatCounter() else stopBatCounter() end
            saveConfig()
        end,
        function(mode)
            batCounterMode = (mode == "V2") and "V2" or "V1"
            if batCounterEnabled then
                stopBatCounter()
                task.wait(0.05)
                startBatCounter()
            end
            saveConfig()
        end
    )
    setMedusaVisual=mkToggle(pg,"Medusa Counter",function(on) medusaCounterEnabled=on;if on then setupMedusa(LP.Character) else stopMedusaCounter() end;saveConfig() end)
    setAutoSwingVisual=mkToggle(pg,"Auto Swing",function(on) autoSwingEnabled=on;saveConfig() end)
    if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
    setMirrorTPVisual=mkToggle(pg,"Mirror TP Down",function(on) setMirrorTPDown(on);saveConfig() end)
    if setMirrorTPVisual then setMirrorTPVisual(mirrorTPDownEnabled==true) end
    setUnwalkVisual=mkToggle(pg,"Unwalk",function(on) unwalkEnabled=on;if on then startUnwalk() else stopUnwalk() end;saveConfig() end)
    setAutoTPVisual=mkToggle(pg,"Auto TP",function(on) autoTPEnabled=on;if on then startAutoTP() else stopAutoTP() end;saveConfig() end)
    autoTPHeightBox=mkBoxRow(pg,"TP Height",autoTPHeight,function(v) if v>=0 and v<=500 then autoTPHeight=v end;saveConfig() end)

    mkSectionLbl(pg,"Auto Steal")
    radInput=mkBoxRow(pg,"Steal Radius",Steal.StealRadius,function(v)
        if v>=0.5 and v<=300 then
            Steal.StealRadius=v
            SemiSteal.CONFIG.RADIUS = v
        end
        saveConfig()
    end)
    durationBox=mkBoxRow(pg,"Steal Duration",Steal.StealDuration,function(v) if v>=0.1 and v<=10 then Steal.StealDuration=v else durationBox.Text=tostring(Steal.StealDuration) end;saveConfig() end)
    delayRadBox=mkBoxRow(pg,"Delay Radius",autoGrabSetDelayRadius > 0 and autoGrabSetDelayRadius or (SemiSteal.CONFIG.DELAY_RADIUS or 8),function(v)
        if v>=0 and v<=40 then
            autoGrabSetDelayRadius=v
            SemiSteal.CONFIG.DELAY_RADIUS = v
        else
            if delayRadBox then delayRadBox.Text=tostring(autoGrabSetDelayRadius) end
        end
        saveConfig()
    end)
    stopTimeBox=mkBoxRow(pg,"Stop % (Semi V3)",SemiSteal.CONFIG.STOP_PERCENT or 75,function(v)
        if v and v>=1 and v<=100 then
            SemiSteal.CONFIG.STOP_PERCENT = math.floor(v)
            SemiSteal.CONFIG.USE_STOP_PERCENT = true
            SemiSteal.CONFIG.STOP_TIME_ENABLED = true
            autoGrabStopEnabled = true
            autoGrabStopTime = (SemiSteal.CONFIG.DURATION or 1.3) * (SemiSteal.CONFIG.STOP_PERCENT / 100)
        else
            if stopTimeBox then stopTimeBox.Text=tostring(SemiSteal.CONFIG.STOP_PERCENT or 75) end
        end
        saveConfig()
    end)
    delayRadBox2=nil
    setStopModeVisual=mkToggle(pg,"Stop Mode (Semi V3)",function(on)
        autoGrabStopEnabled = on == true
        SemiSteal.CONFIG.STOP_TIME_ENABLED = on == true
        SemiSteal.CONFIG.USE_STOP_PERCENT = on == true
        saveConfig()
    end)
    if setStopModeVisual then pcall(setStopModeVisual, autoGrabStopEnabled==true) end
    do
        local row=mkRow(pg,30);mkLabel(row,"Enable Auto Steal")
        local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,40,0,20);pill.Position=UDim2.new(1,-50,0.5,-10)
        pill.BackgroundColor3=OFF;pill.BorderSizePixel=0;pill.ZIndex=9
        Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
        local pStroke=Instance.new("UIStroke",pill);pStroke.Name="PillStroke";pStroke.Color=ROW_BORDER;pStroke.Thickness=1;pStroke.Transparency=0.45
        local dot=Instance.new("Frame",pill);dot.Size=UDim2.new(0,14,0,14);dot.Position=UDim2.new(0,3,0.5,-7)
        dot.BackgroundColor3=GRAY;dot.BorderSizePixel=0;dot.ZIndex=10
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        local on=false
        local function sv(s) on=s;animPill(pill,dot,s) end
        setInstaGrab=sv
        local function toggleSteal()
            on = not on
            sv(on)
            Steal.AutoStealEnabled = on
            if on then
                if Conns.autoSteal then pcall(function() Conns.autoSteal:Disconnect() end); Conns.autoSteal=nil end
                startAutoSteal()
            else
                stopAutoSteal()
                Steal.AutoStealEnabled = false
            end
            saveConfig()
        end
        local clk=Instance.new("TextButton",pill)
        clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=11
        clk.Activated:Connect(toggleSteal)
    end

    -- Visual tab
    pg=tabPages["Visual"]
    -- Avatar Changer port (native Visual-tab controls)
    mkSectionLbl(pg,"AVATAR CHANGER")
    local avatarPortOpen = false
    local avatarPortBody = Instance.new("Frame", pg)
    avatarPortBody.Name = "AvatarChangerPort"
    avatarPortBody.Size = UDim2.new(1, 0, 0, 0)
    avatarPortBody.BackgroundColor3 = Color3.fromRGB(18, 28, 48)
    avatarPortBody.BackgroundTransparency = 0.08
    avatarPortBody.ClipsDescendants = false
    avatarPortBody.LayoutOrder = 2
    avatarPortBody.Visible = false
    avatarPortBody.ZIndex = 20
    Instance.new("UICorner", avatarPortBody).CornerRadius = UDim.new(0, 6)
    -- Detach from the scrolling Visual page: this is a standalone modal.
    avatarPortBody.Parent = mainFrame
    avatarPortBody.AnchorPoint = Vector2.new(0.5, 0.5)
    avatarPortBody.Position = UDim2.new(0.5, 0, 0.5, 0)
    avatarPortBody.Size = UDim2.new(0, 360, 0, 340)
    avatarPortBody.ZIndex = 100
    local avatarPortGui = Instance.new("ScreenGui")
    avatarPortGui.Name = "VisibleHubAvatarChanger"
    avatarPortGui.ResetOnSpawn = false
    avatarPortGui.IgnoreGuiInset = true
    avatarPortGui.DisplayOrder = 10000
    avatarPortGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    avatarPortGui.Parent = LP:WaitForChild("PlayerGui")
    avatarPortBody.Parent = avatarPortGui
    avatarPortBody.BackgroundColor3 = Color3.fromRGB(8, 13, 24)
    avatarPortBody.BackgroundTransparency = 0
    local pickerFrame = Instance.new("Frame")
    pickerFrame.Name = "AvatarCatalogPicker"
    pickerFrame.Size = UDim2.new(0, 360, 0, 430)
    pickerFrame.Position = UDim2.new(0.5, -180, 0.5, -215)
    pickerFrame.BackgroundColor3 = Color3.fromRGB(8, 13, 24)
    pickerFrame.BorderSizePixel = 0
    pickerFrame.Visible = false
    pickerFrame.ZIndex = 1000
    pickerFrame.Parent = avatarPortGui
    Instance.new("UICorner", pickerFrame).CornerRadius = UDim.new(0, 10)
    local AvatarPortInput = game:GetService("UserInputService")
    local function makeDraggable(frame, handle)
        local dragging, dragStart, startPos
        handle = handle or frame
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        AvatarPortInput.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end)
    end
    makeDraggable(pickerFrame)
    makeDraggable(avatarPortBody)
    local pickerTitle = Instance.new("TextLabel", pickerFrame)
    pickerTitle.Size = UDim2.new(1, -50, 0, 34)
    pickerTitle.Position = UDim2.new(0, 14, 0, 8)
    pickerTitle.BackgroundTransparency = 1
    pickerTitle.Text = "Select Avatar Item"
    pickerTitle.TextColor3 = WHITE
    pickerTitle.Font = Enum.Font.GothamBold
    pickerTitle.TextSize = 15
    pickerTitle.TextXAlignment = Enum.TextXAlignment.Left
    pickerTitle.ZIndex = 1001
    local pickerClose = Instance.new("TextButton", pickerFrame)
    pickerClose.Size = UDim2.new(0, 30, 0, 26)
    pickerClose.Position = UDim2.new(1, -40, 0, 10)
    pickerClose.Text = "X"
    pickerClose.TextColor3 = WHITE
    pickerClose.BackgroundColor3 = Color3.fromRGB(35, 52, 82)
    pickerClose.ZIndex = 1001
    Instance.new("UICorner", pickerClose).CornerRadius = UDim.new(0, 6)
    pickerClose.MouseButton1Click:Connect(function() pickerFrame.Visible = false end)
    local pickerSearch = Instance.new("TextBox", pickerFrame)
    pickerSearch.Size = UDim2.new(1, -28, 0, 34)
    pickerSearch.Position = UDim2.new(0, 14, 0, 50)
    pickerSearch.PlaceholderText = "Search..."
    pickerSearch.Text = ""
    pickerSearch.TextColor3 = WHITE
    pickerSearch.BackgroundColor3 = Color3.fromRGB(20, 31, 52)
    pickerSearch.ZIndex = 1001
    Instance.new("UICorner", pickerSearch).CornerRadius = UDim.new(0, 7)
    local pickerHint = Instance.new("TextLabel", pickerFrame)
    pickerHint.Size = UDim2.new(1, -28, 0, 80)
    pickerHint.Position = UDim2.new(0, 14, 0, 96)
    pickerHint.BackgroundTransparency = 1
    pickerHint.Text = "Type an item name to search the catalog.\nSelect an item to equip it visually."
    pickerHint.TextColor3 = Color3.fromRGB(180, 195, 220)
    pickerHint.TextWrapped = true
    pickerHint.TextSize = 13
    pickerHint.ZIndex = 1001
    local pickerResults = Instance.new("ScrollingFrame", pickerFrame)
    pickerResults.Size = UDim2.new(1, -28, 1, -145)
    pickerResults.Position = UDim2.new(0, 14, 0, 135)
    pickerResults.BackgroundTransparency = 1
    pickerResults.BorderSizePixel = 0
    pickerResults.ScrollBarThickness = 4
    pickerResults.CanvasSize = UDim2.new(0, 0, 0, 0)
    pickerResults.AutomaticCanvasSize = Enum.AutomaticSize.Y
    pickerResults.ZIndex = 1001
    local pickerResultsLayout = Instance.new("UIGridLayout", pickerResults)
    pickerResultsLayout.CellSize = UDim2.new(0, 104, 0, 124)
    pickerResultsLayout.CellPadding = UDim2.new(0, 7, 0, 7)
    pickerResultsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local pickerCategory = nil
    local selectedByCategory = _G._VisibleAvatarPortSelectedByCategory or {}
    _G._VisibleAvatarPortSelectedByCategory = selectedByCategory
    local function equipRominaStyle(itemId, itemType, itemName)
        local character = LP.Character
        if not character then return false end
        local ok, applied = pcall(function()
            local objects = game:GetObjects("rbxassetid://" .. tostring(itemId))
            if not objects or not objects[1] then return false end
            local item = objects[1]
            if item:IsA("Folder") or item:IsA("Model") then
                item = item:FindFirstChildOfClass("Accessory") or item:FindFirstChildOfClass("Shirt") or item:FindFirstChildOfClass("Pants") or item:FindFirstChildOfClass("ShirtGraphic")
            end
            if not item then return false end
            if item:IsA("Shirt") then
                for _, c in ipairs(character:GetChildren()) do if c:IsA("Shirt") then c:Destroy() end end
                item.Name = "VisibleShirt"
                item.Parent = character
                return true
            elseif item:IsA("Pants") then
                for _, c in ipairs(character:GetChildren()) do if c:IsA("Pants") then c:Destroy() end end
                item.Name = "VisiblePants"
                item.Parent = character
                return true
            elseif item:IsA("ShirtGraphic") then
                for _, c in ipairs(character:GetChildren()) do if c:IsA("ShirtGraphic") then c:Destroy() end end
                item.Name = "VisibleTShirt"
                item.Parent = character
                return true
            elseif item:IsA("Accessory") then
                local handle = item:FindFirstChild("Handle")
                if not handle then return false end
                local attachment = handle:FindFirstChildOfClass("Attachment")
                local targetPart = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
                local targetAttachment
                if attachment then
                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            targetAttachment = part:FindFirstChild(attachment.Name)
                            if targetAttachment then targetPart = part break end
                        end
                    end
                end
                if not targetPart then return false end
                item.Name = "Visible" .. tostring(itemName or "Accessory")
                item.Parent = character
                handle.CFrame = targetPart.CFrame
                for _, child in ipairs(handle:GetChildren()) do
                    if child:IsA("Weld") or child:IsA("ManualWeld") or child:IsA("WeldConstraint") then child:Destroy() end
                end
                local weld = Instance.new("Weld")
                weld.Part0 = handle
                weld.Part1 = targetPart
                if attachment and targetAttachment then weld.C0 = attachment.CFrame; weld.C1 = targetAttachment.CFrame end
                weld.Parent = handle
                return true
            end
            return false
        end)
        return ok and applied == true
    end
    local function removeRominaStyle(categoryName, saved)
        local character = LP.Character
        if not character then return end
        local itemName = saved and saved.name or ""
        for _, child in ipairs(character:GetChildren()) do
            if categoryName == "Shirts" and child:IsA("Shirt") and child.Name == "VisibleShirt" then
                child:Destroy()
            elseif categoryName == "Pants" and child:IsA("Pants") and child.Name == "VisiblePants" then
                child:Destroy()
            elseif categoryName == "T-Shirts" and child:IsA("ShirtGraphic") and child.Name == "VisibleTShirt" then
                child:Destroy()
            elseif child:IsA("Accessory") and child.Name == "Visible" .. itemName then
                child:Destroy()
      end
    end
    _G._VisibleAvatarPortRestore = function()
        local enabledMap = _G._VisibleAvatarPortEnabled or {}
        local selectedMap = _G._VisibleAvatarPortSelectedByCategory or {}
        for categoryName, saved in pairs(selectedMap) do
            if enabledMap[categoryName] == true and saved and saved.id then
                pcall(equipRominaStyle, saved.id, nil, saved.name)
            end
        end
    end
    end
    local avatarVisualOverlay = nil
    local avatarVisualConn = nil
    local function clearAvatarVisualOverlay()
        if avatarVisualConn then pcall(function() avatarVisualConn:Disconnect() end) end
        avatarVisualConn = nil
        if avatarVisualOverlay then pcall(function() avatarVisualOverlay:Destroy() end) end
        avatarVisualOverlay = nil
    end
    local function applyAvatarVisualOverlay(desc)
        clearAvatarVisualOverlay()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not (char and hum and desc) then return end
        local ok, model = pcall(function()
            return Players:CreateHumanoidModelFromDescriptionAsync(desc, hum.RigType)
        end)
        if not ok or not model then
            pickerHint.Visible = true
            pickerHint.Text = "Could not create visual item:\n" .. tostring(model)
            warn("[Visible Hub] Could not create avatar visual model: " .. tostring(model))
            return
        end
        model.Name = "VisibleAvatarItems"
        model.Parent = workspace
        for _, obj in ipairs(model:GetDescendants()) do
            if obj:IsA("Humanoid") or obj:IsA("Animator") or obj:IsA("Script") or obj:IsA("LocalScript") then
                obj:Destroy()
            elseif obj:IsA("BasePart") then
                obj.Anchored = true
                obj.CanCollide = false
                obj.CanTouch = false
                obj.CanQuery = false
                obj.Massless = true
                if obj.Parent and obj.Parent:IsA("Model") and obj.Name ~= "Handle" then
                    obj.Transparency = 1
                end
            end
        end
        avatarVisualOverlay = model
        pickerHint.Visible = true
        pickerHint.Text = "Item selected. Visual overlay created."
        avatarVisualConn = RunService.RenderStepped:Connect(function()
            if avatarVisualOverlay and avatarVisualOverlay.Parent and LP.Character then
                avatarVisualOverlay:PivotTo(LP.Character:GetPivot())
            end
        end)
    end
    local function clearPickerResults()
        for _, child in ipairs(pickerResults:GetChildren()) do
            if not child:IsA("UIListLayout") and not child:IsA("UIGridLayout") then child:Destroy() end
        end
    end
    pickerSearch.FocusLost:Connect(function(enter)
        if not enter or pickerSearch.Text == "" then return end
        clearPickerResults()
        pickerHint.Text = "Searching catalog..."
        task.spawn(function()
            local ok, pages = pcall(function()
                local params = CatalogSearchParams.new()
                params.SearchKeyword = pickerSearch.Text
                params.Limit = 30
                local typeMap = {
                    HairAccessory = Enum.AvatarAssetType.HairAccessory,
                    HatAccessory = Enum.AvatarAssetType.Hat,
                    FaceAccessory = Enum.AvatarAssetType.FaceAccessory,
                    Shirt = Enum.AvatarAssetType.Shirt,
                    Pants = Enum.AvatarAssetType.Pants,
                    FrontAccessory = Enum.AvatarAssetType.FrontAccessory,
                    BackAccessory = Enum.AvatarAssetType.BackAccessory,
                    WaistAccessory = Enum.AvatarAssetType.WaistAccessory,
                }
                if pickerCategory and typeMap[pickerCategory[2]] then
                    params.AssetTypes = {typeMap[pickerCategory[2]]}
                end
                return game:GetService("AvatarEditorService"):SearchCatalogAsync(params)
            end)
            if not ok or not pages then
                pickerHint.Text = "Catalog search unavailable in this client."
                return
            end
            local okPage, items = pcall(function() return pages:GetCurrentPage() end)
            if not okPage or type(items) ~= "table" or #items == 0 then
                pickerHint.Text = "No catalog items found."
                return
            end
            pickerHint.Text = "Select an item"
            pickerHint.Visible = false
            for _, item in ipairs(items) do
                local id = tonumber(item.Id or item.AssetId)
                if id then
                    local result = Instance.new("TextButton", pickerResults)
                    result.Size = UDim2.new(0, 104, 0, 124)
                    result.BackgroundColor3 = Color3.fromRGB(20, 31, 52)
                    result.TextColor3 = WHITE
                    result.Text = ""
                    result.ZIndex = 1002
                    Instance.new("UICorner", result).CornerRadius = UDim.new(0, 6)
                    local thumb = Instance.new("ImageLabel", result)
                    thumb.Size = UDim2.new(1, -12, 0, 86)
                    thumb.Position = UDim2.new(0, 6, 0, 6)
                    thumb.BackgroundTransparency = 1
                    thumb.Image = "rbxthumb://type=Asset&id=" .. tostring(id) .. "&w=150&h=150"
                    thumb.ScaleType = Enum.ScaleType.Fit
                    thumb.ZIndex = 1003
                    local nameLabel = Instance.new("TextLabel", result)
                    nameLabel.Size = UDim2.new(1, -8, 0, 30)
                    nameLabel.Position = UDim2.new(0, 4, 1, -34)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Text = tostring(item.Name or "Catalog item")
                    nameLabel.TextColor3 = Color3.fromRGB(235, 200, 55)
                    nameLabel.TextSize = 8
                    nameLabel.TextWrapped = true
                    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
                    nameLabel.ZIndex = 1003
                    result.MouseButton1Click:Connect(function()
                        _G._VisibleAvatarPortSelectedId = id
                        _G._VisibleAvatarPortSelectedName = tostring(item.Name or "")
                        if pickerCategory then selectedByCategory[pickerCategory[1]] = {id = id, name = tostring(item.Name or "")} end
                        _G._VisibleAvatarPortSelectedByCategory = selectedByCategory
                        local char = LP.Character
                        local hum = char and char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            pickerCategory = pickerCategory or {"Hair", "HairAccessory"}
                            local ok, desc = pcall(function() return hum:GetAppliedDescription() end)
                            if ok and desc then
                                local prop = pickerCategory[2]
                                if prop == "HairAccessory" or prop == "HatAccessory" or prop == "FaceAccessory" or prop == "FrontAccessory" or prop == "BackAccessory" or prop == "WaistAccessory" then
                                    desc[prop] = tostring(id)
                                else
                                    desc[prop] = id
                                end
                                _G._VisibleAvatarPortDescription = desc
                                local enabledMap = _G._VisibleAvatarPortEnabled or {}
                                local categoryEnabled = enabledMap[pickerCategory[1]] == true
                                local equipped = categoryEnabled and equipRominaStyle(id, nil, item.Name) or false
                                if not equipped then
                                    pickerHint.Visible = true
                                    pickerHint.Text = categoryEnabled and "Could not equip this catalog item." or "Turn this category ON first."
                                end
                            end
                        end
                        pickerSearch.Text = tostring(item.Name or "")
                        pickerFrame.Visible = false
                    end)
                end
            end
        end)
    end)
    local avatarPortLayout = Instance.new("UIListLayout", avatarPortBody)
    avatarPortLayout.Padding = UDim.new(0, 3)
    avatarPortLayout.SortOrder = Enum.SortOrder.LayoutOrder
    local avatarPortRow = mkRow(pg, 34)
    mkLabel(avatarPortRow, "Avatar Changer")
    local avatarPortButton = Instance.new("TextButton", avatarPortRow)
    avatarPortButton.Size = UDim2.new(0, 58, 0, 24)
    avatarPortButton.Position = UDim2.new(1, -68, 0.5, -12)
    avatarPortButton.BackgroundColor3 = Color3.fromRGB(32, 52, 86)
    avatarPortButton.TextColor3 = WHITE
    avatarPortButton.Text = "Open"
    avatarPortButton.TextSize = 12
    avatarPortButton.Font = Enum.Font.GothamBold
    avatarPortButton.AutoButtonColor = true
    avatarPortButton.ZIndex = 10
    Instance.new("UICorner", avatarPortButton).CornerRadius = UDim.new(0, 6)
    local function toggleAvatarPort()
        avatarPortOpen = not avatarPortOpen
        avatarPortBody.Visible = avatarPortOpen
        avatarPortBody.Size = avatarPortOpen and UDim2.new(0,360,0,340) or UDim2.new(0,360,0,0)
        avatarPortBody.AutomaticSize = Enum.AutomaticSize.None
        avatarPortButton.Text = avatarPortOpen and "Close" or "Open"
    end
    avatarPortButton.MouseButton1Click:Connect(toggleAvatarPort)
    local avatarPortCategories = {
        {"Hair", "HairAccessory"}, {"Hats", "HatAccessory"},
        {"Face", "FaceAccessory"}, {"Shirts", "Shirt"},
        {"Pants", "Pants"}, {"Front", "FrontAccessory"},
        {"Back", "BackAccessory"}, {"Waist", "WaistAccessory"},
    }
    for _, category in ipairs(avatarPortCategories) do
        local row = mkRow(avatarPortBody, 30)
        row.ZIndex = 110
        mkLabel(row, category[1])
        local box = Instance.new("TextButton", row)
        box.Size = UDim2.new(0, 110, 0, 24)
        box.Position = UDim2.new(1, -120, 0.5, -12)
        box.BackgroundColor3 = Color3.fromRGB(24, 35, 58)
        box.TextColor3 = WHITE
        box.Text = "PICK"
        box.Font = Enum.Font.GothamBold
        box.AutoButtonColor = true
        box.TextSize = 12
        box.ZIndex = 10
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
        for _, child in ipairs(row:GetDescendants()) do
            if child:IsA("GuiObject") then child.ZIndex = 111 end
        end
        box.ZIndex = 112
        local enabled = (_G._VisibleAvatarPortEnabled and _G._VisibleAvatarPortEnabled[category[1]]) == true
        local toggle = Instance.new("TextButton", row)
        toggle.Size = UDim2.new(0, 42, 0, 24)
        toggle.Position = UDim2.new(1, -166, 0.5, -12)
        toggle.BackgroundColor3 = Color3.fromRGB(45, 55, 75)
        toggle.TextColor3 = WHITE
        toggle.Text = "OFF"
        toggle.TextSize = 10
        toggle.Font = Enum.Font.GothamBold
        toggle.ZIndex = 112
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 5)
        if enabled then
            toggle.Text = "ON"
            toggle.BackgroundColor3 = Color3.fromRGB(25, 150, 95)
            local saved = selectedByCategory[category[1]]
            if saved then task.defer(function() equipRominaStyle(saved.id, nil, saved.name) end) end
        end
        toggle.MouseButton1Click:Connect(function()
            enabled = not enabled
            toggle.Text = enabled and "ON" or "OFF"
            toggle.BackgroundColor3 = enabled and Color3.fromRGB(25, 150, 95) or Color3.fromRGB(45, 55, 75)
            _G._VisibleAvatarPortEnabled = _G._VisibleAvatarPortEnabled or {}
            _G._VisibleAvatarPortEnabled[category[1]] = enabled
            saveConfig()
            local saved = selectedByCategory[category[1]]
            if enabled and saved then
                if not equipRominaStyle(saved.id, nil, saved.name) then
                    pickerHint.Visible = true
                    pickerHint.Text = "Could not equip the selected " .. category[1] .. "."
                end
            elseif not enabled then
                removeRominaStyle(category[1], saved)
            end
        end)
        box.MouseButton1Click:Connect(function()
            pickerCategory = category
            pickerTitle.Text = "Pick " .. category[1]
            pickerHint.Text = "Search " .. category[1] .. " in the catalog.\nEnter a catalog ID below to select it."
            pickerFrame.Visible = true
        end)
        box.Activated:Connect(function()
            pickerCategory = category
            pickerTitle.Text = "Pick " .. category[1]
            pickerFrame.Visible = true
        end)
        pickerSearch.FocusLost:Connect(function(enter)
            if not enter then return end
            local id = tonumber(pickerSearch.Text)
            if not id then return end
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not (id and hum) then return end
            local ok, desc = pcall(function() return hum:GetAppliedDescription() end)
            if not ok or not desc then return end
            if category[2] == "HairAccessory" or category[2] == "HatAccessory" or category[2] == "FaceAccessory" or category[2] == "FrontAccessory" or category[2] == "BackAccessory" or category[2] == "WaistAccessory" then
                desc[category[2]] = tostring(id)
            else
                desc[category[2]] = id
            end
            -- Client-side ApplyDescription is restricted; keep this port
            -- ready for the local visual overlay path.
            _G._VisibleAvatarPortDescription = desc
            box.Text = tostring(id)
            pickerFrame.Visible = false
        end)
    end
    mkSectionLbl(pg,"AVATAR PRESETS")
    local deathspeakerOverlay = nil
    local deathspeakerFollow = nil
    local deathspeakerOriginalTransparency = {}
    local function clearDeathspeakerVisual()
        if deathspeakerFollow then pcall(function() deathspeakerFollow:Disconnect() end) end
        deathspeakerFollow = nil
        if deathspeakerOverlay then pcall(function() deathspeakerOverlay:Destroy() end) end
        deathspeakerOverlay = nil
        for part, value in pairs(deathspeakerOriginalTransparency) do
            if part and part.Parent then part.LocalTransparencyModifier = value end
        end
        deathspeakerOriginalTransparency = {}
    end
    local function showDeathspeakerVisual()
        clearDeathspeakerVisual()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not (char and hum) then return false end
        local ok, desc = pcall(function()
            return Players:GetHumanoidDescriptionFromOutfitIdAsync(131929437)
        end)
        if not ok or not desc then return false end
        local made, model = pcall(function()
            return Players:CreateHumanoidModelFromDescriptionAsync(desc, hum.RigType)
        end)
        if not made or not model then return false end
        model.Name = "VisibleDeathspeaker"
        model.Parent = workspace
        for _, original in ipairs(char:GetDescendants()) do
            if original:IsA("BasePart") and original.Name ~= "HumanoidRootPart" then
                deathspeakerOriginalTransparency[original] = original.LocalTransparencyModifier
                original.LocalTransparencyModifier = 1
            end
        end
        for _, obj in ipairs(model:GetDescendants()) do
            if obj:IsA("Humanoid") or obj:IsA("Animator") or obj:IsA("Script") or obj:IsA("LocalScript") then
                obj:Destroy()
            elseif obj:IsA("BasePart") then
                obj.Anchored = true
                obj.CanCollide = false
                obj.CanTouch = false
                obj.CanQuery = false
                obj.Massless = true
                if obj.Name == "HumanoidRootPart" then
                    obj.Transparency = 1
                    obj.LocalTransparencyModifier = 1
                end
            end
        end
        deathspeakerOverlay = model
        model:PivotTo(char:GetPivot())
        deathspeakerFollow = RunService.RenderStepped:Connect(function()
            if deathspeakerOverlay and deathspeakerOverlay.Parent and LP.Character then
                deathspeakerOverlay:PivotTo(LP.Character:GetPivot())
            end
        end)
        return true
    end
    mkToggle(pg,"Deathspeaker Preset",function(on)
        if on then
            if not showDeathspeakerVisual() then clearDeathspeakerVisual() end
        else
            clearDeathspeakerVisual()
        end
    end)
    mkSectionLbl(pg,"Visual")
    setAntiLagVisual=mkToggle(pg,"Anti Lag",function(on) if on then enableAntiLag() else disableAntiLag() end;saveConfig() end)
    setAntiDieVisual=mkToggle(pg,"Anti Die",function(on)
        antiDieEnabled = on == true
        if AntiDie then
            if on then AntiDie:toggle(true) else AntiDie:toggle(false) end
        end
        saveConfig()
    end)
    antiBatMode = (antiBatMode == "V2") and "V2" or "V1"
    setAntiBatVisual=mkToggleWithMode(pg,"Anti Bat",
        {"V1","V2"},
        (antiBatMode == "V2") and "V2" or "V1",
        function(on)
            if _G.AmbitiousAntiBat and _G.AmbitiousAntiBat.setEnabled then
                _G.AmbitiousAntiBat.setEnabled(on)
            else
                _G.AmbitiousAntiBatEnabled = on == true
                if on then startAntiBat() else stopAntiBat() end
            end
            saveConfig()
        end,
        function(mode)
            antiBatMode = (mode == "V2") and "V2" or "V1"
            if _G.AmbitiousAntiBatEnabled then
                if _G.AmbitiousAntiBat and _G.AmbitiousAntiBat.setEnabled then
                    _G.AmbitiousAntiBat.setEnabled(false)
                    task.wait(0.05)
                    _G.AmbitiousAntiBat.setEnabled(true)
                else
                    stopAntiBat(); startAntiBat()
                end
            end
            saveConfig()
        end
    )
    if setAntiBatVisual and _G.AmbitiousAntiBatEnabled then setAntiBatVisual(true) end

    setAntiBatV2SpeenVisual=mkToggle(pg,"Anti Bat V2 (Speen Body)",function(on)
        if on then startAntiBatV2Speen() else stopAntiBatV2Speen() end
        if mobBtnRefs and mobBtnRefs.antiBatV2 then mobBtnRefs.antiBatV2(antiBatV2SpeenEnabled) end
        saveConfig()
    end)
    if setAntiBatV2SpeenVisual then setAntiBatV2SpeenVisual(antiBatV2SpeenEnabled==true) end
    antiBatV2SpeenBox=mkBoxRow(pg,"Speen Body Speed",antiBatV2SpeenSpeed or 80,function(v)
        if v and v>0 and v<=500 then
            antiBatV2SpeenSpeed=v
            saveConfig()
        end
    end)

    setBodyLockVisual=mkToggle(pg,"Body Lock",function(on)
        if _G._VisibleSetBodyLock then _G._VisibleSetBodyLock(on) else bodyLockEnabled = on == true end
        saveConfig()
    end)
    if setBodyLockVisual then setBodyLockVisual(bodyLockEnabled==true) end
    setMedusaDelayVisual=mkToggle(pg,"Medusa Steal Delay",function(on)
        medusaStealDelayEnabled = on == true
        saveConfig()
    end)
    if setMedusaDelayVisual then setMedusaDelayVisual(medusaStealDelayEnabled~=false) end

    if setAntiDieVisual then setAntiDieVisual(antiDieEnabled==true) end
    setPlayerEspVisual=mkToggle(pg,"Player ESP",function(on)
        if on then startPlayerEsp() else stopPlayerEsp() end
        saveConfig()
    end)
    setNoCamCollisionVisual=mkToggle(pg,"No Cam Collision",function(on)
        noCamCollisionEnabled = on == true
        pcall(function()
            LP.DevCameraOcclusionMode = on and Enum.DevCameraOcclusionMode.Invisicam or Enum.DevCameraOcclusionMode.Zoom
        end)
        saveConfig()
    end)
    if setNoCamCollisionVisual then setNoCamCollisionVisual(noCamCollisionEnabled==true) end
    if noCamCollisionEnabled then
        pcall(function() LP.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam end)
    end
    setXRaySuiteVisual=mkToggle(pg,"X-Ray (Plot + Brainrot + Tools)",function(on)
        if type(setXRaySuite)=="function" then setXRaySuite(on) end
        saveConfig()
    end)
    if setXRaySuiteVisual and xraySuiteEnabled then setXRaySuiteVisual(true) end
    mkSectionLbl(pg,"Charter / Anims")
    do
        local row=mkRow(pg,34);mkLabel(row,"Animation Studio")
        local openBtn=Instance.new("TextButton",row)
        openBtn.Size=UDim2.new(0,58,0,22);openBtn.Position=UDim2.new(1,-66,0.5,-11)
        openBtn.BackgroundColor3=PINK3;openBtn.BorderSizePixel=0
        openBtn.Text="Open";openBtn.TextColor3=WHITE
        openBtn.Font=Enum.Font.GothamBold;openBtn.TextSize=10
        openBtn.AutoButtonColor=false;openBtn.ZIndex=10
        Instance.new("UICorner",openBtn).CornerRadius=UDim.new(0,6)
        openBtn.Activated:Connect(function()
            if _anyKeyListening then return end
            if animUI and animUI.open then animUI.open() end
        end)
    end
    setAnimPackVisual=mkToggle(pg,"Anim Pack On",function(on)
        animPackEnabled = on == true
        if animPackEnabled then
            if not animPack or animPack == "NONE" then animPack = "Catwalk Glam" end
            if type(applyAnimPack)=="function" then pcall(applyAnimPack, animPack) end
        else
            if type(stopAnimPack)=="function" then pcall(stopAnimPack) end
        end
        pcall(saveConfig)
    end)
    if setAnimPackVisual then setAnimPackVisual(animPackEnabled==true) end
    setHeadlessVisual=mkToggle(pg,"Headless",function(on)
        headlessEnabled = on == true
        if type(applyHeadlessToChar)=="function" then pcall(applyHeadlessToChar, LP.Character, headlessEnabled) end
        pcall(saveConfig)
    end)
    if setHeadlessVisual then setHeadlessVisual(headlessEnabled==true) end
    setKorbloxVisual=mkToggle(pg,"Korblox",function(on)
        korbloxEnabled = on == true
        if type(applyKorbloxToChar)=="function" then pcall(applyKorbloxToChar, LP.Character, korbloxEnabled) end
        pcall(saveConfig)
    end)
    if setKorbloxVisual then setKorbloxVisual(korbloxEnabled==true) end

    kawatanSkinEnabled = false
    kawatanSkinColor = kawatanSkinColor or "PURPLE"
    kawatanBodyType = kawatanBodyType or "OFF"
    local SKIN_COLORS = {
        PURPLE = Color3.fromRGB(140, 70, 220),
        RED = Color3.fromRGB(220, 50, 70),
        BLUE = Color3.fromRGB(50, 120, 255),
        GALAXY = Color3.fromRGB(80, 40, 160),
    }
    local function applyKawatanSkin(char)
        if not kawatanSkinEnabled then return end
        char = char or LP.Character
        if not char then return end
        local col = SKIN_COLORS[kawatanSkinColor] or SKIN_COLORS.PURPLE
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
                pcall(function() d.Color = col end)
            end
        end
    end
    local function applyKawatanBody(char)
        char = char or LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local function setScale(name, val)
            local n = hum:FindFirstChild(name)
            if n and n:IsA("NumberValue") then n.Value = val end
        end
        if kawatanBodyType == "OFF" then
            return
        elseif kawatanBodyType == "CLASSIC" then
            setScale("BodyTypeScale", 0)
            setScale("BodyProportionScale", 0)
            setScale("BodyHeightScale", 1)
            setScale("BodyWidthScale", 1)
            setScale("BodyDepthScale", 1)
            setScale("HeadScale", 1)
            pcall(function()
                local d = hum:GetAppliedDescription()
                d.BodyTypeScale = 0
                d.BodyProportionScale = 0
                hum:ApplyDescription(d)
            end)
        elseif kawatanBodyType == "WOMAN" then
            setScale("BodyTypeScale", 1)
            setScale("BodyProportionScale", 1)
            pcall(function()
                local d = hum:GetAppliedDescription()
                d.BodyTypeScale = 1
                d.BodyProportionScale = 1
                hum:ApplyDescription(d)
            end)
            task.spawn(function()
                pcall(function()
                    local IS = game:GetService("InsertService")
                    local m = IS:LoadAsset(239)
                    if m and char then
                        for _, ch in ipairs(m:GetChildren()) do
                            if ch:IsA("Folder") or ch:IsA("Model") then
                                for _, p in ipairs(ch:GetDescendants()) do
                                    if p:IsA("CharacterMesh") or p:IsA("Shirt") or p:IsA("Pants") then
                                        pcall(function() p.Parent = char end)
                                    end
                                end
                            end
                        end
                        m:Destroy()
                    end
                end)
            end)
        end
    end
    _G._VisibleApplyKawatanLooks = function(char)
        applyKawatanSkin(char)
        applyKawatanBody(char)
    end
    LP.CharacterAdded:Connect(function(c)
        task.delay(0.6, function()
            if _G._VisibleApplyKawatanLooks then
                _G._VisibleApplyKawatanLooks(c)
            else
                applyKawatanSkin(c)
                applyKawatanBody(c)
            end
        end)
    end)

    local KAWATAN_SKINS = {
        PURPLE = { hats = "1744060292,439945661,1125510,1029025", hair = "", clothing = {7424637509, 7689651773}, acc = {1744060292,439945661,1125510,1029025,11748356,8465506143,11444217173}, col = Color3.fromRGB(140,70,220) },
        BLUE = { hats = "74891470", hair = "16630147,6346833550,6594911228,6594919952,6823338112,7097747842", clothing = {18423061209,18423154566}, acc = {74891470,16630147,6346833550,6594911228,6594919952,6823338112,7097747842}, col = Color3.fromRGB(50,120,255) },
        RED = { hats = "215718515,439945661", hair = "7183785281", clothing = {15998365201,7689651773}, acc = {215718515,439945661,7183785281}, col = Color3.fromRGB(220,50,70) },
        BLACK = { hats = "10159600649,439946249,17798262442,92482095662016", hair = "139101716417676", clothing = {18766106994,13925390578}, acc = {10159600649,439946249,17798262442,92482095662016,139101716417676,12490213797}, col = Color3.fromRGB(30,30,36) },
        GREEN = { hats = "553970961,1744060292", hair = "93268856876777", clothing = {9478068776,6348682339}, acc = {553970961,1744060292,93268856876777}, col = Color3.fromRGB(40,180,80) },
        WHITE = { hats = "74891470,215718515,439945661,1016143686,1744060292,10159600649", hair = "126447390530523", clothing = {}, acc = {74891470,215718515,439945661,1016143686,1744060292,10159600649}, col = Color3.fromRGB(230,230,235) },
    }
    applyKawatanSkin = function(char)
        if not kawatanSkinEnabled then return end
        char = char or LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local set = KAWATAN_SKINS[kawatanSkinColor] or KAWATAN_SKINS.PURPLE
        pcall(function()
            local desc = hum:GetAppliedDescription()
            desc.HatAccessory = set.hats or ""
            desc.HairAccessory = set.hair or ""
            if set.clothing[1] then desc.Shirt = set.clothing[1] end
            if set.clothing[2] then desc.Pants = set.clothing[2] end
            hum:ApplyDescription(desc)
        end)
        -- body recolor removed — Vanta uses real accessories, not neon body tint

        local IS = game:GetService("InsertService")
        _G._VisibleApplyKawatanLooks = function(c)
            applyKawatanSkin(c)
            applyKawatanBody(c)
        end
        task.spawn(function()
            for _, id in ipairs(set.acc or {}) do
                pcall(function()
                    local m = IS:LoadAsset(id)
                    if m then
                        for _, ch in ipairs(m:GetChildren()) do
                            if ch:IsA("Accessory") or ch:IsA("Shirt") or ch:IsA("Pants") then
                                ch.Parent = char
                            end
                        end
                        m:Destroy()
                    end
                end)
            end
        end)
    end

    do
        local row=mkRow(pg,34);mkLabel(row,"Sky Themes")
        local openBtn=Instance.new("TextButton",row)
        openBtn.Size=UDim2.new(0,58,0,22);openBtn.Position=UDim2.new(1,-66,0.5,-11)
        openBtn.BackgroundColor3=PINK3;openBtn.BorderSizePixel=0
        openBtn.Text="Open";openBtn.TextColor3=WHITE
        openBtn.Font=Enum.Font.GothamBold;openBtn.TextSize=10
        openBtn.AutoButtonColor=false;openBtn.ZIndex=10
        Instance.new("UICorner",openBtn).CornerRadius=UDim.new(0,6)
        openBtn.Activated:Connect(function()
            if _anyKeyListening then return end
            if skyUI and skyUI.open then skyUI.open() end
        end)
    end

    do
        local row = mkRow(pg, 30)
        mkLabel(row, "FOV (70-180)")
        local fovInput = Instance.new("TextBox", row)
        fovInput.Size = UDim2.new(0, 58, 0, 22)
        fovInput.Position = UDim2.new(1, -66, 0.5, -11)
        fovInput.BackgroundColor3 = INP
        fovInput.BorderSizePixel = 0
        fovInput.Text = tostring(fovValue)
        fovInput.TextColor3 = PINK
        fovInput.Font = Enum.Font.GothamBold
        fovInput.TextSize = 11
        fovInput.ClearTextOnFocus = false
        fovInput.ZIndex = 11
        Instance.new("UICorner", fovInput).CornerRadius = UDim.new(0, 5)
        local fovStroke = Instance.new("UIStroke", fovInput)
        fovStroke.Color = ROW_BORDER; fovStroke.Thickness = 1; fovStroke.Transparency = 0.5
        fovInput.FocusLost:Connect(function()
            local n = tonumber(fovInput.Text)
            if n and n >= 70 and n <= 180 then
                fovValue = math.floor(n)
                fovInput.Text = tostring(fovValue)
                pcall(function() workspace.CurrentCamera.FieldOfView = fovValue end)
            else
                fovInput.Text = tostring(fovValue)
            end
            pcall(saveConfig)
        end)
    end

    -- Backgrounds modal - ONLY BG 4 remains
    local BG_PRESETS = {
        {id = "93489483341327", name = "BG 4"},
    }

    local function makeCureModal(name, title, w, h)
        local dim = Instance.new("TextButton", gui)
        dim.Name = name .. "Dim"
        dim.Size = UDim2.fromScale(1, 1)
        dim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        dim.BackgroundTransparency = 0.55
        dim.BorderSizePixel = 0
        dim.Text = ""
        dim.AutoButtonColor = false
        dim.Visible = false
        dim.ZIndex = 180

        local m = Instance.new("Frame", gui)
        m.Name = name
        m.Size = UDim2.fromOffset(w, h)
        m.AnchorPoint = Vector2.new(0.5, 0.5)
        m.Position = UDim2.fromScale(0.5, 0.5)
        m.BackgroundColor3 = BG
        m.BackgroundTransparency = 0
        m.BorderSizePixel = 0
        m.Visible = false
        m.ZIndex = 200
        m.ClipsDescendants = true
        m.Active = true
        Instance.new("UICorner", m).CornerRadius = UDim.new(0, 16)
        local mStroke = Instance.new("UIStroke", m)
        mStroke.Color = ROW_BORDER
        mStroke.Thickness = 1.2
        mStroke.Transparency = 0.25

        local topLine = Instance.new("Frame", m)
        topLine.Size = UDim2.new(0.5, 0, 0, 2)
        topLine.Position = UDim2.new(0.25, 0, 0, 0)
        topLine.BackgroundColor3 = PINK
        topLine.BorderSizePixel = 0
        topLine.ZIndex = 210
        Instance.new("UICorner", topLine).CornerRadius = UDim.new(0, 2)

        local header = Instance.new("Frame", m)
        header.Size = UDim2.new(1, 0, 0, 44)
        header.BackgroundTransparency = 1
        header.ZIndex = 201
        header.Active = true

        local titleLbl = Instance.new("TextLabel", header)
        titleLbl.Position = UDim2.fromOffset(16, 12)
        titleLbl.Size = UDim2.new(1, -56, 0, 20)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = title
        titleLbl.TextColor3 = WHITE
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = 14
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.ZIndex = 202

        local closeBtn = Instance.new("TextButton", header)
        closeBtn.Size = UDim2.fromOffset(26, 26)
        closeBtn.Position = UDim2.new(1, -36, 0.5, -13)
        closeBtn.BackgroundColor3 = PINK3
        closeBtn.BorderSizePixel = 0
        closeBtn.Text = "X"
        closeBtn.TextColor3 = WHITE
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 12
        closeBtn.ZIndex = 210
        closeBtn.AutoButtonColor = false
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 7)

        local body = Instance.new("ScrollingFrame", m)
        body.Name = "Body"
        body.Size = UDim2.new(1, -16, 1, -52)
        body.Position = UDim2.fromOffset(8, 46)
        body.BackgroundTransparency = 1
        body.BorderSizePixel = 0
        body.ScrollBarThickness = 3
        body.ScrollBarImageColor3 = PINK3
        body.CanvasSize = UDim2.fromOffset(0, 0)
        body.AutomaticCanvasSize = Enum.AutomaticSize.Y
        body.ZIndex = 201
        local bodyPad = Instance.new("UIPadding", body)
        bodyPad.PaddingTop = UDim.new(0, 4)
        bodyPad.PaddingBottom = UDim.new(0, 10)
        bodyPad.PaddingLeft = UDim.new(0, 2)
        bodyPad.PaddingRight = UDim.new(0, 4)
        local bodyLay = Instance.new("UIListLayout", body)
        bodyLay.Padding = UDim.new(0, 8)
        bodyLay.SortOrder = Enum.SortOrder.LayoutOrder

        local function openFn()
            dim.Visible = true
            m.Visible = true
            m.Size = UDim2.fromOffset(math.floor(w * 0.92), math.floor(h * 0.92))
            TweenService:Create(m, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Size = UDim2.fromOffset(w, h)}):Play()
        end
        local function closeFn()
            dim.Visible = false
            m.Visible = false
        end
        closeBtn.MouseButton1Click:Connect(closeFn)

        local dn, ds, sp = false, nil, nil
        header.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dn = true; ds = i.Position; sp = m.Position
                i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dn = false end end)
            end
        end)
        trackConn(UIS.InputChanged:Connect(function(i)
            if dn and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                m.Position = UDim2.new(sp.X.Scale, sp.X.Offset + (i.Position.X - ds.X), sp.Y.Scale, sp.Y.Offset + (i.Position.Y - ds.Y))
            end
        end))

        return {m = m, body = body, open = openFn, close = closeFn, dim = dim}
    end

    -- Animation Studio

    animUI = makeCureModal("K7AnimPackModal", "Animation Studio", 300, 400)
    do
        local packHdr = Instance.new("TextLabel", animUI.body)
        packHdr.Size = UDim2.new(1, -4, 0, 14)
        packHdr.BackgroundTransparency = 1
        packHdr.Text = "PACK LIBRARY"
        packHdr.TextColor3 = Color3.fromRGB(150, 180, 220)
        packHdr.Font = Enum.Font.GothamBold
        packHdr.TextSize = 10
        packHdr.TextXAlignment = Enum.TextXAlignment.Left
        packHdr.LayoutOrder = 1
        packHdr.ZIndex = 202

        local animPacks = {"NONE"}
        for name in pairs(PACKS or {}) do
            if name ~= "CUSTOM" and name ~= "NONE" then table.insert(animPacks, name) end
        end
        table.sort(animPacks, function(a,b)
            if a == "NONE" then return true end
            if b == "NONE" then return false end
            return a < b
        end)
        table.insert(animPacks, "CUSTOM")

        local animSelected = 0
        for i, name in ipairs(animPacks) do
            if animPackEnabled and name == animPack then
                animSelected = i
                break
            end
        end
        local animRows = {}

        local animStatus = Instance.new("Frame", animUI.body)
        animStatus.Size = UDim2.new(1, -4, 0, 44)
        animStatus.BackgroundColor3 = Color3.fromRGB(10, 15, 26)
        animStatus.BackgroundTransparency = 0.18
        animStatus.BorderSizePixel = 0
        animStatus.LayoutOrder = 2
        animStatus.ZIndex = 202
        Instance.new("UICorner", animStatus).CornerRadius = UDim.new(0, 10)
        local statusStroke = Instance.new("UIStroke", animStatus)
        statusStroke.Color = PINK
        statusStroke.Thickness = 1
        statusStroke.Transparency = 0.24

        local curLbl = Instance.new("TextLabel", animStatus)
        curLbl.Position = UDim2.fromOffset(12, 5)
        curLbl.Size = UDim2.new(1, -24, 0, 13)
        curLbl.BackgroundTransparency = 1
        curLbl.Text = "CURRENT PACK"
        curLbl.Font = Enum.Font.GothamBold
        curLbl.TextSize = 8
        curLbl.TextColor3 = Color3.fromRGB(150, 180, 220)
        curLbl.TextXAlignment = Enum.TextXAlignment.Left
        curLbl.ZIndex = 203

        local animStatusText = Instance.new("TextLabel", animStatus)
        animStatusText.Position = UDim2.fromOffset(12, 18)
        animStatusText.Size = UDim2.new(1, -24, 0, 20)
        animStatusText.BackgroundTransparency = 1
        animStatusText.Text = (animSelected > 0 and animPacks[animSelected]) or "None selected"
        animStatusText.Font = Enum.Font.GothamBold
        animStatusText.TextSize = 12
        animStatusText.TextColor3 = WHITE
        animStatusText.TextXAlignment = Enum.TextXAlignment.Left
        animStatusText.ZIndex = 203

        local animSearchWrap = Instance.new("Frame", animUI.body)
        animSearchWrap.Size = UDim2.new(1, -4, 0, 36)
        animSearchWrap.BackgroundColor3 = Color3.fromRGB(8, 12, 22)
        animSearchWrap.BackgroundTransparency = 0.16
        animSearchWrap.BorderSizePixel = 0
        animSearchWrap.LayoutOrder = 3
        animSearchWrap.ZIndex = 202
        Instance.new("UICorner", animSearchWrap).CornerRadius = UDim.new(0, 9)
        local searchStroke = Instance.new("UIStroke", animSearchWrap)
        searchStroke.Color = ROW_BORDER
        searchStroke.Thickness = 1
        searchStroke.Transparency = 0.38

        local findLbl = Instance.new("TextLabel", animSearchWrap)
        findLbl.Position = UDim2.fromOffset(11, 0)
        findLbl.Size = UDim2.fromOffset(48, 36)
        findLbl.BackgroundTransparency = 1
        findLbl.Text = "FIND"
        findLbl.Font = Enum.Font.GothamBold
        findLbl.TextSize = 9
        findLbl.TextColor3 = Color3.fromRGB(150, 180, 220)
        findLbl.ZIndex = 203

        local animSearch = Instance.new("TextBox", animSearchWrap)
        animSearch.Position = UDim2.fromOffset(54, 4)
        animSearch.Size = UDim2.new(1, -60, 0, 28)
        animSearch.BackgroundTransparency = 1
        animSearch.BorderSizePixel = 0
        animSearch.ClearTextOnFocus = false
        animSearch.PlaceholderText = "Search animation packs..."
        animSearch.PlaceholderColor3 = Color3.fromRGB(120, 155, 205)
        animSearch.Text = ""
        animSearch.TextColor3 = WHITE
        animSearch.TextXAlignment = Enum.TextXAlignment.Left
        animSearch.Font = Enum.Font.GothamMedium
        animSearch.TextSize = 11
        animSearch.ZIndex = 204

        local function refreshAnim()
            for i, row in ipairs(animRows) do
                local on = (i == animSelected)
                row.BackgroundColor3 = on and Color3.fromRGB(20, 32, 52) or Color3.fromRGB(10, 15, 26)
                row.BackgroundTransparency = on and 0.06 or 0.18
                local st = row:FindFirstChildOfClass("UIStroke")
                if st then
                    st.Color = on and PINK or ROW_BORDER
                    st.Transparency = on and 0.05 or 0.4
                end
                local tag = row:FindFirstChild("OnTag")
                if tag then tag.Visible = on end
            end
            animStatusText.Text = (animSelected > 0 and animPacks[animSelected]) or "None selected"
        end

        for i, name in ipairs(animPacks) do
            local row = Instance.new("TextButton", animUI.body)
            row.Size = UDim2.new(1, -4, 0, 36)
            row.BackgroundColor3 = Color3.fromRGB(10, 15, 26)
            row.BackgroundTransparency = 0.18
            row.BorderSizePixel = 0
            row.Text = ""
            row.AutoButtonColor = false
            row.LayoutOrder = i + 3
            row.ZIndex = 202
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 9)
            local st = Instance.new("UIStroke", row)
            st.Color = ROW_BORDER
            st.Thickness = 1
            st.Transparency = 0.4

            local nameLbl = Instance.new("TextLabel", row)
            nameLbl.Position = UDim2.fromOffset(12, 0)
            nameLbl.Size = UDim2.new(1, -50, 1, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = name
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 12
            nameLbl.TextColor3 = WHITE
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.ZIndex = 203

            local tag = Instance.new("TextLabel", row)
            tag.Name = "OnTag"
            tag.Size = UDim2.fromOffset(28, 16)
            tag.Position = UDim2.new(1, -36, 0.5, -8)
            tag.BackgroundTransparency = 1
            tag.Text = "ON"
            tag.TextColor3 = PINK
            tag.Font = Enum.Font.GothamBlack
            tag.TextSize = 10
            tag.Visible = false
            tag.ZIndex = 204

            row.MouseButton1Click:Connect(function()
                animSelected = i
                refreshAnim()
                animPack = name
                if name == "NONE" then
                    animPackEnabled = false
                    if setAnimPackVisual then setAnimPackVisual(false) end
                    if type(stopAnimPack) == "function" then pcall(stopAnimPack) end
                else
                    animPackEnabled = true
                    if setAnimPackVisual then setAnimPackVisual(true) end
                    if type(applyAnimPack) == "function" then pcall(applyAnimPack, animPack) end
                end
                pcall(saveConfig)
            end)
            row.MouseEnter:Connect(function()
                if animSelected ~= i then
                    TweenService:Create(row, TweenInfo.new(0.16), {
                        BackgroundColor3 = Color3.fromRGB(18, 28, 44),
                        BackgroundTransparency = 0.04
                    }):Play()
                end
            end)
            row.MouseLeave:Connect(function()
                if animSelected ~= i then
                    TweenService:Create(row, TweenInfo.new(0.18), {
                        BackgroundColor3 = Color3.fromRGB(10, 15, 26),
                        BackgroundTransparency = 0.18
                    }):Play()
                end
            end)
            animRows[i] = row
        end

        animSearch:GetPropertyChangedSignal("Text"):Connect(function()
            local query = animSearch.Text:lower():gsub("^%s+", ""):gsub("%s+$", "")
            for i, row in ipairs(animRows) do
                row.Visible = query == "" or animPacks[i]:lower():find(query, 1, true) ~= nil
            end
        end)
        refreshAnim()

        local customHdr = Instance.new("TextLabel", animUI.body)
        customHdr.Size = UDim2.new(1, -4, 0, 14)
        customHdr.BackgroundTransparency = 1
        customHdr.Text = "CUSTOM IDS (select CUSTOM pack)"
        customHdr.TextColor3 = Color3.fromRGB(150, 180, 220)
        customHdr.Font = Enum.Font.GothamBold
        customHdr.TextSize = 10
        customHdr.TextXAlignment = Enum.TextXAlignment.Left
        customHdr.LayoutOrder = 200
        customHdr.ZIndex = 202
        for si, slot in ipairs(_G.AmbitiousCustomAnimSlots or {"idle","walk","run","jump","fall","climb"}) do
            local row = Instance.new("Frame", animUI.body)
            row.Size = UDim2.new(1, -4, 0, 28)
            row.BackgroundColor3 = Color3.fromRGB(10, 15, 26)
            row.BackgroundTransparency = 0.2
            row.BorderSizePixel = 0
            row.LayoutOrder = 200 + si
            row.ZIndex = 202
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
            local lbl = Instance.new("TextLabel", row)
            lbl.Size = UDim2.new(0, 50, 1, 0)
            lbl.Position = UDim2.fromOffset(8, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = string.upper(slot)
            lbl.TextColor3 = WHITE
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 10
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 203
            local box = Instance.new("TextBox", row)
            box.Size = UDim2.new(1, -66, 0, 22)
            box.Position = UDim2.new(0, 58, 0.5, -11)
            box.BackgroundColor3 = Color3.fromRGB(20, 32, 52)
            box.BorderSizePixel = 0
            box.Text = tostring((_G.AmbitiousCustomAnimIds and _G.AmbitiousCustomAnimIds[slot]) or "")
            box.PlaceholderText = "asset id"
            box.TextColor3 = PINK
            box.Font = Enum.Font.Code
            box.TextSize = 11
            box.ClearTextOnFocus = false
            box.ZIndex = 203
            Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
            box.FocusLost:Connect(function()
                local n = tostring(box.Text or ""):gsub("%D", "")
                _G.AmbitiousCustomAnimIds = _G.AmbitiousCustomAnimIds or {}
                _G.AmbitiousCustomAnimIds[slot] = n
                box.Text = n
                if animPack == "CUSTOM" and type(applyAnimPack) == "function" then
                    pcall(applyAnimPack, "CUSTOM")
                end
                pcall(saveConfig)
            end)
        end
    end

    skyUI = makeCureModal("K7SkyThemeModal", "Sky Themes", 300, 420)
    do
        local packHdr = Instance.new("TextLabel", skyUI.body)
        packHdr.Size = UDim2.new(1, -4, 0, 14)
        packHdr.BackgroundTransparency = 1
        packHdr.Text = "SKY LIBRARY"
        packHdr.TextColor3 = Color3.fromRGB(150, 180, 220)
        packHdr.Font = Enum.Font.GothamBold
        packHdr.TextSize = 10
        packHdr.TextXAlignment = Enum.TextXAlignment.Left
        packHdr.LayoutOrder = 1
        packHdr.ZIndex = 202

        local skyStatus = Instance.new("Frame", skyUI.body)
        skyStatus.Size = UDim2.new(1, -4, 0, 44)
        skyStatus.BackgroundColor3 = Color3.fromRGB(10, 15, 26)
        skyStatus.BackgroundTransparency = 0.18
        skyStatus.BorderSizePixel = 0
        skyStatus.LayoutOrder = 2
        skyStatus.ZIndex = 202
        Instance.new("UICorner", skyStatus).CornerRadius = UDim.new(0, 10)
        local statusStroke = Instance.new("UIStroke", skyStatus)
        statusStroke.Color = PINK
        statusStroke.Thickness = 1
        statusStroke.Transparency = 0.24

        local curLbl = Instance.new("TextLabel", skyStatus)
        curLbl.Position = UDim2.fromOffset(12, 5)
        curLbl.Size = UDim2.new(1, -24, 0, 13)
        curLbl.BackgroundTransparency = 1
        curLbl.Text = "CURRENT THEME"
        curLbl.Font = Enum.Font.GothamBold
        curLbl.TextSize = 8
        curLbl.TextColor3 = Color3.fromRGB(150, 180, 220)
        curLbl.TextXAlignment = Enum.TextXAlignment.Left
        curLbl.ZIndex = 203

        local skyStatusText = Instance.new("TextLabel", skyStatus)
        skyStatusText.Position = UDim2.fromOffset(12, 18)
        skyStatusText.Size = UDim2.new(1, -24, 0, 20)
        skyStatusText.BackgroundTransparency = 1
        skyStatusText.Text = currentSkyTheme or "Off"
        skyStatusText.Font = Enum.Font.GothamBold
        skyStatusText.TextSize = 12
        skyStatusText.TextColor3 = WHITE
        skyStatusText.TextXAlignment = Enum.TextXAlignment.Left
        skyStatusText.ZIndex = 203

        local skySearch = Instance.new("TextBox", skyUI.body)
        skySearch.Size = UDim2.new(1, -4, 0, 28)
        skySearch.BackgroundColor3 = Color3.fromRGB(20, 32, 52)
        skySearch.BorderSizePixel = 0
        skySearch.PlaceholderText = "Search themes..."
        skySearch.Text = ""
        skySearch.TextColor3 = WHITE
        skySearch.PlaceholderColor3 = Color3.fromRGB(120, 155, 205)
        skySearch.Font = Enum.Font.Gotham
        skySearch.TextSize = 12
        skySearch.ClearTextOnFocus = false
        skySearch.LayoutOrder = 3
        skySearch.ZIndex = 202
        Instance.new("UICorner", skySearch).CornerRadius = UDim.new(0, 8)

        local skyList = Instance.new("Frame", skyUI.body)
        skyList.Size = UDim2.new(1, -4, 0, 0)
        skyList.AutomaticSize = Enum.AutomaticSize.Y
        skyList.BackgroundTransparency = 1
        skyList.LayoutOrder = 4
        skyList.ZIndex = 202
        local listLayout = Instance.new("UIListLayout", skyList)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 4)

        local skyRows = {}
        local function refreshSky()
            skyStatusText.Text = currentSkyTheme or "Off"
            for i, name in ipairs(SkyOrder) do
                local row = skyRows[i]
                if not row then continue end
                local on = (name == currentSkyTheme)
                local tag = row:FindFirstChild("OnTag")
                if tag then tag.Visible = on end
                row.BackgroundColor3 = on and Color3.fromRGB(20, 32, 52) or Color3.fromRGB(10, 15, 26)
                row.BackgroundTransparency = on and 0.04 or 0.18
            end
        end

        for i, name in ipairs(SkyOrder) do
            local row = Instance.new("TextButton", skyList)
            row.Size = UDim2.new(1, 0, 0, 34)
            row.BackgroundColor3 = Color3.fromRGB(10, 15, 26)
            row.BackgroundTransparency = 0.18
            row.BorderSizePixel = 0
            row.Text = ""
            row.AutoButtonColor = false
            row.LayoutOrder = i
            row.ZIndex = 202
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

            local nameLbl = Instance.new("TextLabel", row)
            nameLbl.Position = UDim2.fromOffset(12, 0)
            nameLbl.Size = UDim2.new(1, -50, 1, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = name
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 12
            nameLbl.TextColor3 = WHITE
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.ZIndex = 203

            local tag = Instance.new("TextLabel", row)
            tag.Name = "OnTag"
            tag.Size = UDim2.fromOffset(28, 16)
            tag.Position = UDim2.new(1, -36, 0.5, -8)
            tag.BackgroundTransparency = 1
            tag.Text = "ON"
            tag.TextColor3 = PINK
            tag.Font = Enum.Font.GothamBlack
            tag.TextSize = 10
            tag.Visible = false
            tag.ZIndex = 204

            row.MouseButton1Click:Connect(function()
                currentSkyTheme = name
                K7ApplyCustomSky(name)
                refreshSky()
                pcall(saveConfig)
            end)
            row.MouseEnter:Connect(function()
                if name ~= currentSkyTheme then
                    TweenService:Create(row, TweenInfo.new(0.16), {
                        BackgroundColor3 = Color3.fromRGB(18, 28, 44),
                        BackgroundTransparency = 0.04
                    }):Play()
                end
            end)
            row.MouseLeave:Connect(function()
                if name ~= currentSkyTheme then
                    TweenService:Create(row, TweenInfo.new(0.18), {
                        BackgroundColor3 = Color3.fromRGB(10, 15, 26),
                        BackgroundTransparency = 0.18
                    }):Play()
                end
            end)
            skyRows[i] = row
        end

        skySearch:GetPropertyChangedSignal("Text"):Connect(function()
            local query = skySearch.Text:lower():gsub("^%s+", ""):gsub("%s+$", "")
            for i, row in ipairs(skyRows) do
                row.Visible = query == "" or SkyOrder[i]:lower():find(query, 1, true) ~= nil
            end
        end)
        refreshSky()
    end

    local bgUI = makeCureModal("K7BgModal", "Backgrounds", 280, 220)

    local grid = Instance.new("Frame", bgUI.body)
    grid.Size = UDim2.new(1, -4, 0, 0)
    grid.AutomaticSize = Enum.AutomaticSize.Y
    grid.BackgroundTransparency = 1
    grid.LayoutOrder = 1
    grid.ZIndex = 202
    local gridLay = Instance.new("UIGridLayout", grid)
    gridLay.CellSize = UDim2.fromOffset(84, 72)
    gridLay.CellPadding = UDim2.fromOffset(8, 8)
    gridLay.SortOrder = Enum.SortOrder.LayoutOrder
    gridLay.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local bgCards = {}
    for i, pr in ipairs(BG_PRESETS) do
        local cell = Instance.new("TextButton", grid)
        cell.BackgroundColor3 = ROW_BG
        cell.BorderSizePixel = 0
        cell.Text = ""
        cell.AutoButtonColor = false
        cell.LayoutOrder = i
        cell.ZIndex = 203
        Instance.new("UICorner", cell).CornerRadius = UDim.new(0, 10)
        local st = Instance.new("UIStroke", cell)
        st.Color = ROW_BORDER
        st.Thickness = 1.2
        st.Transparency = 0.4

        if pr.id ~= "" then
            local img = Instance.new("ImageLabel", cell)
            img.Size = UDim2.new(1, -6, 1, -22)
            img.Position = UDim2.fromOffset(3, 3)
            img.BackgroundColor3 = Color3.fromRGB(10, 15, 26)
            img.BorderSizePixel = 0
            img.Image = "rbxassetid://" .. pr.id
            img.ScaleType = Enum.ScaleType.Crop
            img.ZIndex = 204
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, 8)
            pcall(function()
                game:GetService("ContentProvider"):PreloadAsync({img.Image})
            end)
        else
            local none = Instance.new("TextLabel", cell)
            none.Size = UDim2.new(1, 0, 1, -18)
            none.BackgroundTransparency = 1
            none.Text = "NONE"
            none.TextColor3 = GRAY
            none.Font = Enum.Font.GothamBold
            none.TextSize = 11
            none.TextXAlignment = Enum.TextXAlignment.Center
            none.TextYAlignment = Enum.TextYAlignment.Center
            none.ZIndex = 204
        end

        local nameLbl = Instance.new("TextLabel", cell)
        nameLbl.AnchorPoint = Vector2.new(0.5, 1)
        nameLbl.Position = UDim2.new(0.5, 0, 1, -2)
        nameLbl.Size = UDim2.new(1, -4, 0, 16)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = pr.name
        nameLbl.TextColor3 = GRAY
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 10
        nameLbl.TextXAlignment = Enum.TextXAlignment.Center
        nameLbl.ZIndex = 205

        cell.MouseButton1Click:Connect(function()
            applyCustomBg(pr.id, bgOpacity)
            for _, other in pairs(bgCards) do
                other.stroke.Color = ROW_BORDER
                other.stroke.Transparency = 0.4
            end
            st.Color = PINK
            st.Transparency = 0.05
            pcall(saveConfig)
        end)
        bgCards[i] = {btn = cell, stroke = st, id = pr.id}
        if pr.id == selectedBgId then
            st.Color = PINK
            st.Transparency = 0.05
        end
    end
    if selectedBgId == "" or selectedBgId == "0" then
        selectedBgId = "93489483341327"
    end
    pcall(function() applyCustomBg(selectedBgId, bgOpacity) end)
    for _, entry in pairs(bgCards) do
        if entry.id == selectedBgId then
            entry.stroke.Color = PINK
            entry.stroke.Transparency = 0.05
        end
    end

    -- Tabs Layout modal

    local layUI = makeCureModal("K7TabsLayoutModal", "Tabs Layout", 280, 340)
    local layoutDefs = {
        {id = "Top", name = "Top Bar", desc = "Tabs in one bar across the top"},
        {id = "Sidebar", name = "Sidebar", desc = "Vertical strip on the left"},
        {id = "Bottom", name = "Bottom Bar", desc = "Clean bar along the bottom"},
        {id = "None", name = "No Tabs", desc = "Hide tabs — one scrollable list"},
    }
    local layoutRows = {}

    local function drawLayoutPreview(parent, id)
        local box = Instance.new("Frame", parent)
        box.Size = UDim2.fromOffset(64, 48)
        box.Position = UDim2.fromOffset(12, 10)
        box.BackgroundColor3 = Color3.fromRGB(8, 12, 22)
        box.BorderSizePixel = 0
        box.ZIndex = 210
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
        local title = Instance.new("Frame", box)
        title.Size = UDim2.new(1, 0, 0, 8)
        title.BackgroundColor3 = Color3.fromRGB(20, 32, 52)
        title.BorderSizePixel = 0
        title.ZIndex = 211
        Instance.new("UICorner", title).CornerRadius = UDim.new(0, 6)
        local tabs = Instance.new("Frame", box)
        tabs.BackgroundColor3 = PINK
        tabs.BorderSizePixel = 0
        tabs.ZIndex = 212
        Instance.new("UICorner", tabs).CornerRadius = UDim.new(0, 3)
        if id == "Bottom" then
            tabs.Size = UDim2.new(0.7, 0, 0, 5)
            tabs.Position = UDim2.new(0.15, 0, 1, -7)
        elseif id == "Top" then
            tabs.Size = UDim2.new(0.7, 0, 0, 5)
            tabs.Position = UDim2.new(0.15, 0, 0, 10)
        elseif id == "Sidebar" then
            tabs.Size = UDim2.new(0, 6, 0.55, 0)
            tabs.Position = UDim2.fromOffset(3, 14)
        else
            tabs.Size = UDim2.new(0.8, 0, 0, 22)
            tabs.Position = UDim2.new(0.1, 0, 0, 14)
            tabs.BackgroundTransparency = 0.55
        end
    end

    local function refreshLayoutSelection()
        for id, entry in pairs(layoutRows) do
            local active = (id == tabLayoutMode)
            if entry.stroke then
                entry.stroke.Color = active and PINK or ROW_BORDER
                entry.stroke.Transparency = active and 0.05 or 0.3
            end
        end
    end

    for i, L in ipairs(layoutDefs) do
        local row = Instance.new("TextButton", layUI.body)
        row.Size = UDim2.new(1, -4, 0, 56)
        row.BackgroundColor3 = ROW_BG
        row.BorderSizePixel = 0
        row.Text = ""
        row.AutoButtonColor = false
        row.LayoutOrder = i
        row.ZIndex = 202
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)
        local st = Instance.new("UIStroke", row)
        st.Color = ROW_BORDER
        st.Thickness = 1.15
        st.Transparency = 0.3
        drawLayoutPreview(row, L.id)
        local nameLbl = Instance.new("TextLabel", row)
        nameLbl.Position = UDim2.fromOffset(90, 14)
        nameLbl.Size = UDim2.new(1, -110, 0, 18)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = L.name
        nameLbl.TextColor3 = WHITE
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 13
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.ZIndex = 210
        local descLbl = Instance.new("TextLabel", row)
        descLbl.Position = UDim2.fromOffset(90, 34)
        descLbl.Size = UDim2.new(1, -110, 0, 16)
        descLbl.BackgroundTransparency = 1
        descLbl.Text = L.desc
        descLbl.TextColor3 = GRAY
        descLbl.Font = Enum.Font.Gotham
        descLbl.TextSize = 10
        descLbl.TextXAlignment = Enum.TextXAlignment.Left
        descLbl.ZIndex = 210
        layoutRows[L.id] = {btn = row, stroke = st}
        row.MouseButton1Click:Connect(function()
            applyTabLayout(L.id)
            refreshLayoutSelection()
            pcall(saveConfig)
            if layUI and layUI.close then layUI.close() end
        end)
        row.MouseEnter:Connect(function()
            if L.id ~= tabLayoutMode then
                st.Color = PINK
                st.Transparency = 0.2
            end
        end)
        row.MouseLeave:Connect(function()
            refreshLayoutSelection()
        end)
    end
    refreshLayoutSelection()

    -- Music Studio (Keep Song)
    musicUI = makeCureModal("K7MusicModal", "Music Studio", 300, 420)
    do
        local packHdr = Instance.new("TextLabel", musicUI.body)
        packHdr.Size = UDim2.new(1, -4, 0, 14)
        packHdr.BackgroundTransparency = 1
        packHdr.Text = "SONG LIBRARY"
        packHdr.TextColor3 = Color3.fromRGB(150, 180, 220)
        packHdr.Font = Enum.Font.GothamBold
        packHdr.TextSize = 10
        packHdr.TextXAlignment = Enum.TextXAlignment.Left
        packHdr.LayoutOrder = 1
        packHdr.ZIndex = 202

        local songNames = KEEP_MUSIC_NAMES or {}
        local songSelected = math.clamp(tonumber(keepMusicIndex) or 1, 1, math.max(1, #songNames))
        local songRows = {}

        local songStatus = Instance.new("Frame", musicUI.body)
        songStatus.Size = UDim2.new(1, -4, 0, 44)
        songStatus.BackgroundColor3 = Color3.fromRGB(10, 15, 26)
        songStatus.BackgroundTransparency = 0.18
        songStatus.BorderSizePixel = 0
        songStatus.LayoutOrder = 2
        songStatus.ZIndex = 202
        Instance.new("UICorner", songStatus).CornerRadius = UDim.new(0, 10)
        local statusStroke = Instance.new("UIStroke", songStatus)
        statusStroke.Color = PINK
        statusStroke.Thickness = 1
        statusStroke.Transparency = 0.24

        local curLbl = Instance.new("TextLabel", songStatus)
        curLbl.Position = UDim2.fromOffset(12, 5)
        curLbl.Size = UDim2.new(1, -24, 0, 13)
        curLbl.BackgroundTransparency = 1
        curLbl.Text = "CURRENT SONG"
        curLbl.Font = Enum.Font.GothamBold
        curLbl.TextSize = 8
        curLbl.TextColor3 = Color3.fromRGB(150, 180, 220)
        curLbl.TextXAlignment = Enum.TextXAlignment.Left
        curLbl.ZIndex = 203

        local songStatusText = Instance.new("TextLabel", songStatus)
        songStatusText.Position = UDim2.fromOffset(12, 18)
        songStatusText.Size = UDim2.new(1, -24, 0, 20)
        songStatusText.BackgroundTransparency = 1
        songStatusText.Text = (songSelected > 0 and songNames[songSelected]) or "None selected"
        songStatusText.Font = Enum.Font.GothamBold
        songStatusText.TextSize = 12
        songStatusText.TextColor3 = WHITE
        songStatusText.TextXAlignment = Enum.TextXAlignment.Left
        songStatusText.ZIndex = 203

        local searchWrap = Instance.new("Frame", musicUI.body)
        searchWrap.Size = UDim2.new(1, -4, 0, 36)
        searchWrap.BackgroundColor3 = Color3.fromRGB(8, 12, 22)
        searchWrap.BackgroundTransparency = 0.16
        searchWrap.BorderSizePixel = 0
        searchWrap.LayoutOrder = 3
        searchWrap.ZIndex = 202
        Instance.new("UICorner", searchWrap).CornerRadius = UDim.new(0, 9)
        local searchStroke = Instance.new("UIStroke", searchWrap)
        searchStroke.Color = ROW_BORDER
        searchStroke.Thickness = 1
        searchStroke.Transparency = 0.38

        local findLbl = Instance.new("TextLabel", searchWrap)
        findLbl.Position = UDim2.fromOffset(11, 0)
        findLbl.Size = UDim2.fromOffset(48, 36)
        findLbl.BackgroundTransparency = 1
        findLbl.Text = "FIND"
        findLbl.Font = Enum.Font.GothamBold
        findLbl.TextSize = 9
        findLbl.TextColor3 = Color3.fromRGB(150, 180, 220)
        findLbl.ZIndex = 203

        local songSearch = Instance.new("TextBox", searchWrap)
        songSearch.Position = UDim2.fromOffset(54, 4)
        songSearch.Size = UDim2.new(1, -60, 0, 28)
        songSearch.BackgroundTransparency = 1
        songSearch.BorderSizePixel = 0
        songSearch.ClearTextOnFocus = false
        songSearch.PlaceholderText = "Search songs..."
        songSearch.PlaceholderColor3 = Color3.fromRGB(120, 155, 205)
        songSearch.Text = ""
        songSearch.TextColor3 = WHITE
        songSearch.TextXAlignment = Enum.TextXAlignment.Left
        songSearch.Font = Enum.Font.GothamMedium
        songSearch.TextSize = 11
        songSearch.ZIndex = 204

        local function refreshSongRows()
            for i, row in ipairs(songRows) do
                local on = (i == songSelected)
                row.BackgroundColor3 = on and Color3.fromRGB(20, 32, 52) or Color3.fromRGB(10, 15, 26)
                row.BackgroundTransparency = on and 0.06 or 0.18
                local st = row:FindFirstChildOfClass("UIStroke")
                if st then
                    st.Color = on and PINK or ROW_BORDER
                    st.Transparency = on and 0.05 or 0.4
                end
                local tag = row:FindFirstChild("OnTag")
                if tag then tag.Visible = on end
            end
            songStatusText.Text = (songSelected > 0 and songNames[songSelected]) or "None selected"
        end

        for i, name in ipairs(songNames) do
            local row = Instance.new("TextButton", musicUI.body)
            row.Size = UDim2.new(1, -4, 0, 36)
            row.BackgroundColor3 = Color3.fromRGB(10, 15, 26)
            row.BackgroundTransparency = 0.18
            row.BorderSizePixel = 0
            row.Text = ""
            row.AutoButtonColor = false
            row.LayoutOrder = i + 3
            row.ZIndex = 202
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 9)
            local st = Instance.new("UIStroke", row)
            st.Color = ROW_BORDER
            st.Thickness = 1
            st.Transparency = 0.4

            local nameLbl = Instance.new("TextLabel", row)
            nameLbl.Position = UDim2.fromOffset(12, 0)
            nameLbl.Size = UDim2.new(1, -90, 1, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = name
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 12
            nameLbl.TextColor3 = WHITE
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.ZIndex = 203

            local previewBtn = Instance.new("TextButton", row)
            previewBtn.Size = UDim2.fromOffset(44, 22)
            previewBtn.Position = UDim2.new(1, -86, 0.5, -11)
            previewBtn.BackgroundColor3 = Color3.fromRGB(20, 32, 52)
            previewBtn.BorderSizePixel = 0
            previewBtn.Text = "▶"
            previewBtn.TextColor3 = WHITE
            previewBtn.Font = Enum.Font.GothamBold
            previewBtn.TextSize = 11
            previewBtn.AutoButtonColor = false
            previewBtn.ZIndex = 204
            Instance.new("UICorner", previewBtn).CornerRadius = UDim.new(0, 6)
            previewBtn.Activated:Connect(function()
                playPreview(i)
            end)

            local tag = Instance.new("TextLabel", row)
            tag.Name = "OnTag"
            tag.Size = UDim2.fromOffset(28, 16)
            tag.Position = UDim2.new(1, -36, 0.5, -8)
            tag.BackgroundTransparency = 1
            tag.Text = "ON"
            tag.TextColor3 = PINK
            tag.Font = Enum.Font.GothamBlack
            tag.TextSize = 10
            tag.Visible = false
            tag.ZIndex = 204

            row.MouseButton1Click:Connect(function()
                songSelected = i
                keepMusicIndex = i
                refreshSongRows()
                if keepMusicEnabled then
                    startKeepMusic(keepMusicIndex)
                end
                pcall(saveConfig)
            end)
            row.MouseEnter:Connect(function()
                if songSelected ~= i then
                    TweenService:Create(row, TweenInfo.new(0.16), {
                        BackgroundColor3 = Color3.fromRGB(18, 28, 44),
                        BackgroundTransparency = 0.04
                    }):Play()
                end
            end)
            row.MouseLeave:Connect(function()
                if songSelected ~= i then
                    TweenService:Create(row, TweenInfo.new(0.18), {
                        BackgroundColor3 = Color3.fromRGB(10, 15, 26),
                        BackgroundTransparency = 0.18
                    }):Play()
                end
            end)
            songRows[i] = row
        end

        songSearch:GetPropertyChangedSignal("Text"):Connect(function()
            local query = songSearch.Text:lower():gsub("^%s+", ""):gsub("%s+$", "")
            for i, row in ipairs(songRows) do
                row.Visible = query == "" or (songNames[i] and songNames[i]:lower():find(query, 1, true) ~= nil)
            end
        end)
        refreshSongRows()
    end

    -- Settings tab
    pg=tabPages["Settings"]
    mkSectionLbl(pg,"Settings")
    setE01Visual=mkToggle(pg,"E01 Warning",function(on)
        e01WarningEnabled = on == true
        if not on and _G._VisibleE01Stop then pcall(_G._VisibleE01Stop) end
        saveConfig()
    end)
    if setE01Visual then setE01Visual(e01WarningEnabled~=false) end
    setOppSpeedVisual=mkToggle(pg,"Opponent Speed",function(on)
        opponentSpeedEnabled = on == true
        saveConfig()
    end)
    if setOppSpeedVisual then setOppSpeedVisual(opponentSpeedEnabled~=false) end

    setKeepMusicVisual = mkToggle(pg, "Keep Song On", function(on)
        if on then
            startKeepMusic(keepMusicIndex or 1)
        else
            stopKeepMusic()
            stopPreview()
        end
        pcall(saveConfig)
    end)
    if setKeepMusicVisual then setKeepMusicVisual(keepMusicEnabled == true) end

    do
        local row = mkRow(pg, 34)
        mkLabel(row, "Music Studio")
        local openBtn = Instance.new("TextButton", row)
        openBtn.Size = UDim2.new(0, 58, 0, 22)
        openBtn.Position = UDim2.new(1, -66, 0.5, -11)
        openBtn.BackgroundColor3 = PINK3
        openBtn.BorderSizePixel = 0
        openBtn.Text = "Open"
        openBtn.TextColor3 = WHITE
        openBtn.Font = Enum.Font.GothamBold
        openBtn.TextSize = 10
        openBtn.AutoButtonColor = false
        openBtn.ZIndex = 10
        Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 6)
        openBtn.Activated:Connect(function()
            if _anyKeyListening then return end
            if musicUI and musicUI.open then musicUI.open() end
        end)
    end

    do
        local row = mkRow(pg, 34)
        mkLabel(row, "Backgrounds")
        local openBtn = Instance.new("TextButton", row)
        openBtn.Size = UDim2.new(0, 58, 0, 22)
        openBtn.Position = UDim2.new(1, -66, 0.5, -11)
        openBtn.BackgroundColor3 = PINK3
        openBtn.BorderSizePixel = 0
        openBtn.Text = "Open"
        openBtn.TextColor3 = WHITE
        openBtn.Font = Enum.Font.GothamBold
        openBtn.TextSize = 10
        openBtn.AutoButtonColor = false
        openBtn.ZIndex = 10
        Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 6)
        openBtn.Activated:Connect(function()
            if bgUI and bgUI.open then bgUI.open() end
        end)
    end


    do
        local row = mkRow(pg, 34)
        mkLabel(row, "Tabs Layout")
        local openBtn = Instance.new("TextButton", row)
        openBtn.Size = UDim2.new(0, 58, 0, 22)
        openBtn.Position = UDim2.new(1, -66, 0.5, -11)
        openBtn.BackgroundColor3 = PINK3
        openBtn.BorderSizePixel = 0
        openBtn.Text = "Open"
        openBtn.TextColor3 = WHITE
        openBtn.Font = Enum.Font.GothamBold
        openBtn.TextSize = 10
        openBtn.AutoButtonColor = false
        openBtn.ZIndex = 10
        Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 6)
        openBtn.Activated:Connect(function()
            refreshLayoutSelection()
            if layUI and layUI.open then layUI.open() end
        end)
    end

    setIntroVisual=mkToggle(pg,"Show Intro",function(on)
        introEnabled = on == true
        pcall(function()
            if getgenv then
                getgenv()._K7IntroEnabled = introEnabled
                if type(getgenv()._K7DuelsCfg)~="table" then getgenv()._K7DuelsCfg = {} end
                getgenv()._K7DuelsCfg.introEnabled = introEnabled
            end
        end)
        saveConfig()
    end)
    if setIntroVisual then setIntroVisual(introEnabled==true) end
    if setNoCamCollisionVisual then setNoCamCollisionVisual(noCamCollisionEnabled==true) end
    if noCamCollisionEnabled then pcall(function() LP.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam end) end
    setLockVisual=mkToggle(pg,"Lock UI",function(on) uiLocked=on==true;saveConfig() end)
    if setLockVisual then setLockVisual(uiLocked==true) end
    setMobLockVisual=mkToggle(pg,"Lock Mobile Btns",function(on)
        mobileButtonsLocked=on==true
        if mobileButtonsLocked then
            activeMobDrag=nil
        end
        saveConfig()
    end)
    if setMobLockVisual then setMobLockVisual(mobileButtonsLocked==true) end
    do
        local row=mkRow(pg,34);mkLabel(row,"UI Scale")
        local scaleBox=Instance.new("TextBox",row)
        scaleBox.Size=UDim2.new(0,58,0,22);scaleBox.Position=UDim2.new(1,-66,0.5,-11)
        scaleBox.BackgroundColor3=INP;scaleBox.BorderSizePixel=0
        scaleBox.Text=string.format("%.2f", tonumber(uiScale) or 0.80)
        scaleBox.TextColor3=PINK
        scaleBox.Font=Enum.Font.GothamBold;scaleBox.TextSize=10;scaleBox.ClearTextOnFocus=false;scaleBox.ZIndex=9
        Instance.new("UICorner",scaleBox).CornerRadius=UDim.new(0,5)
        local scaleStroke=Instance.new("UIStroke",scaleBox)
        scaleStroke.Color=ROW_BORDER;scaleStroke.Thickness=1;scaleStroke.Transparency=0.5
        scaleBox.FocusLost:Connect(function()
            local n=tonumber(scaleBox.Text)
            if n and n>=0.5 and n<=2 then
                if type(_G._K7ApplyMainUiScale)=="function" then
                    _G._K7ApplyMainUiScale(n)
                else
                    uiScale=n
                    if mainFrame then
                        local sc=mainFrame:FindFirstChild("MainUIScale")
                        if sc then sc.Scale=n end
                    end
                end
                scaleBox.Text=string.format("%.2f", uiScale)
                saveConfig()
            else
                scaleBox.Text=string.format("%.2f", tonumber(uiScale) or 0.80)
            end
        end)
    end

    setMobVisual=mkToggle(pg,"Mobile Buttons",function(on) mobileButtonsEnabled=on;if on then buildMobileButtons() else destroyMobileButtons() end;saveConfig() end)
    if mobileButtonsEnabled then setMobVisual(true) end
    do
        local row=mkRow(pg,30);mkLabel(row,"Btn Size")
        local sizeBox=Instance.new("TextBox",row)
        sizeBox.Size=UDim2.new(0,58,0,22);sizeBox.Position=UDim2.new(1,-66,0.5,-11)
        sizeBox.BackgroundColor3=INP;sizeBox.BorderSizePixel=0
        sizeBox.Text=tostring(mobileButtonsSize);sizeBox.TextColor3=PINK
        sizeBox.Font=Enum.Font.GothamBold;sizeBox.TextSize=10;sizeBox.ClearTextOnFocus=false;sizeBox.ZIndex=9
        Instance.new("UICorner",sizeBox).CornerRadius=UDim.new(0,5)
        sizeBox.FocusLost:Connect(function()
            local n=tonumber(sizeBox.Text)
            if n and n>=40 and n<=150 then mobileButtonsSize=n;if mobileButtonsEnabled then buildMobileButtons() end;saveConfig()
            else sizeBox.Text=tostring(mobileButtonsSize) end
        end)
    end
    do
        local row=mkRow(pg,30);mkLabel(row,"Steal Bar Size %")
        local sbBox=Instance.new("TextBox",row)
        sbBox.Size=UDim2.new(0,58,0,22);sbBox.Position=UDim2.new(1,-66,0.5,-11)
        sbBox.BackgroundColor3=INP;sbBox.BorderSizePixel=0
        sbBox.Text=tostring(math.floor((tonumber(stealBarScale) or 1)*100+0.5));sbBox.TextColor3=PINK
        sbBox.Font=Enum.Font.GothamBold;sbBox.TextSize=10;sbBox.ClearTextOnFocus=false;sbBox.ZIndex=9
        Instance.new("UICorner",sbBox).CornerRadius=UDim.new(0,5)
        sbBox.FocusLost:Connect(function()
            local n=tonumber(sbBox.Text)
            if n and n>=50 and n<=120 then
                stealBarScale = n / 100
                sbBox.Text = tostring(math.floor(n+0.5))
                pcall(function()
                    local bar = stealBarFrame
                    if bar and bar.Parent then
                        local sc = bar:FindFirstChild("StealBarScale")
                        if not sc then
                            sc = Instance.new("UIScale")
                            sc.Name = "StealBarScale"
                            sc.Parent = bar
                        end
                        sc.Scale = stealBarScale
                    elseif type(createStealBar)=="function" then
                        createStealBar()
                    end
                end)
                saveConfig()
            else
                sbBox.Text=tostring(math.floor((tonumber(stealBarScale) or 1)*100+0.5))
            end
        end)
    end
    do
        local row=mkRow(pg,30);mkLabel(row,"Reset Btn Pos")
        local resetPosBtn=Instance.new("TextButton",row)
        resetPosBtn.Size=UDim2.new(0,58,0,22);resetPosBtn.Position=UDim2.new(1,-66,0.5,-11)
        resetPosBtn.BackgroundColor3=PINK3;resetPosBtn.BorderSizePixel=0
        resetPosBtn.Text="Reset";resetPosBtn.TextColor3=WHITE
        resetPosBtn.Font=Enum.Font.GothamBold;resetPosBtn.TextSize=9;resetPosBtn.ZIndex=9
        Instance.new("UICorner",resetPosBtn).CornerRadius=UDim.new(0,5)
        resetPosBtn.Activated:Connect(function()
            pcall(function() if writefile then writefile(MOB_POS_FILE,"{}") end end)
            pcall(function()
                local raw=readfile("k7duels.json")
                if raw and writefile then
                    local cfg=HS:JSONDecode(raw)
                    if type(cfg)=="table" then cfg.btnPositions={}; writefile("k7duels.json",HS:JSONEncode(cfg)) end
                end
            end)
            forceDefaultBtnPos=true
            if mobileButtonsEnabled then buildMobileButtons() end
            forceDefaultBtnPos=false
            pcall(saveBtnPositions)
        end)
    end
    do
        local row=mkRow(pg,30);mkLabel(row,"Reset Steal Bar")
        local resetStealBtn=Instance.new("TextButton",row)
        resetStealBtn.Size=UDim2.new(0,58,0,22);resetStealBtn.Position=UDim2.new(1,-66,0.5,-11)
        resetStealBtn.BackgroundColor3=PINK3;resetStealBtn.BorderSizePixel=0
        resetStealBtn.Text="Reset";resetStealBtn.TextColor3=WHITE
        resetStealBtn.Font=Enum.Font.GothamBold;resetStealBtn.TextSize=9;resetStealBtn.ZIndex=9
        Instance.new("UICorner",resetStealBtn).CornerRadius=UDim.new(0,5)
        resetStealBtn.Activated:Connect(function()
            stealBarPos = nil
            pcall(function()
                local bar = stealBarFrame
                if not bar or not bar.Parent then
                    local sg = nil
                    if _gethui then
                        local h = _gethui()
                        sg = h and (h:FindFirstChild("K7InfoBar") or h:FindFirstChild("K7StealBar"))
                    end
                    if not sg then
                        local cg = game:GetService("CoreGui")
                        sg = cg:FindFirstChild("K7InfoBar") or cg:FindFirstChild("K7StealBar")
                    end
                    if not sg and LP then
                        local pg = LP:FindFirstChild("PlayerGui")
                        if pg then sg = pg:FindFirstChild("K7InfoBar") or pg:FindFirstChild("K7StealBar") end
                    end
                    if sg then bar = sg:FindFirstChild("K7StealBarFrame") or sg end
                end
                if bar then
                    bar.Position = UDim2.new(0.5, -160, 0, 28)
                end
            end)
            pcall(saveConfig)
        end)
    end

    -- Keybinds
    local kbPage = tabPages["Keybinds"]
    mkSectionLbl(kbPage,"Keybinds (PC + Gamepad)")
    mkKBRow(kbPage,"Hide GUI",KB.GuiHide,function() saveConfig() end)
    mkKBRow(kbPage,"Carry Speed",KB.SpeedToggle,function() saveConfig() end)
    mkKBRow(kbPage,"Lagger Mode",KB.LaggerToggle,function() saveConfig() end)
    mkKBRow(kbPage,"Lagger Carry",KB.LaggerCarry,function() saveConfig() end)
    mkKBRow(kbPage,"Auto Bat",KB.AutoBat,function() saveConfig() end)
    mkKBRow(kbPage,"TP Bat",KB.TPBat,function() saveConfig() end)
    mkKBRow(kbPage,"Auto Left",KB.AutoLeft,function() saveConfig() end)
    mkKBRow(kbPage,"Auto Right",KB.AutoRight,function() saveConfig() end)
    mkKBRow(kbPage,"Drop Brainrot",KB.DropBrainrot,function() saveConfig() end)
    mkKBRow(kbPage,"TP Down",KB.TPFloor,function() saveConfig() end)
    mkKBRow(kbPage,"Instant Reset",KB.InstantReset,function() saveConfig() end)

    trackConn(UIS.InputBegan:Connect(function(input,gpe)
        if _anyKeyListening then return end
        if input.UserInputType==Enum.UserInputType.Keyboard then if gpe or UIS:GetFocusedTextBox() then return end elseif not isGamepadInput(input) then return end
        if not isBindableInput(input) then return end
        local kc=input.KeyCode
        if kbMatch(KB.LaggerToggle,kc) then toggleLaggerMode();saveConfig()
        elseif kbMatch(KB.LaggerCarry,kc) then toggleLaggerCarryMode();saveConfig()
        elseif kbMatch(KB.SpeedToggle,kc) then toggleCarryMode();saveConfig()
        elseif kbMatch(KB.DropBrainrot,kc) then runDrop()
        elseif kbMatch(KB.TPFloor,kc) then runTPFloor()
        elseif kbMatch(KB.AutoLeft,kc) then
            autoLeftEnabled=not autoLeftEnabled
            if autoLeftEnabled then
                if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                if safeModeTryStart and not safeModeTryStart() then return end;startAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(true) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(true) end
            else stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
        elseif kbMatch(KB.AutoRight,kc) then
            autoRightEnabled=not autoRightEnabled
            if autoRightEnabled then
                if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoBatEnabled then stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
                if safeModeTryStart and not safeModeTryStart() then return end;startAutoRight();if autoRightSetVisual then autoRightSetVisual(true) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(true) end
            else stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
        elseif kbMatch(KB.AutoBat,kc) then
            if not autoBatEnabled then
                if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft();if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end end
                if autoRightEnabled then autoRightEnabled=false;stopAutoRight();if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end end
                queueAutoBatStart()
            else stopBatAimbot();if autoBatSetVisual then autoBatSetVisual(false) end;if mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end end
        elseif kbMatch(KB.TPBat,kc) then
            local on
            if type(toggleVisibleTpBat) == "function" then
                on = toggleVisibleTpBat()
            elseif _G.toggleVisibleTpBat then
                on = _G.toggleVisibleTpBat()
            end
            if setTpBatVisual then pcall(setTpBatVisual, on == true) end
            saveConfig()
        elseif kbMatch(KB.GuiHide,kc) then
            if mainFrame.Visible then mainFrame.Visible=false;miniBtn.Visible=true
            else mainFrame.Visible=true;miniBtn.Visible=false end
        elseif kbMatch(KB.InstantReset,kc) then
            InstantReset()
        end
    end))
end

_savedCfg=nil
local function loadConfigKeys()
    local cfg = nil
    local diskCfg = nil
    do
        local raw = nil
        pcall(function() if isfile and isfile("k7duels.json") then raw = readfile("k7duels.json") end end)
        if not raw then pcall(function() if isfile and isfile("K7DuelsConfig.json") then raw = readfile("K7DuelsConfig.json") end end) end
        if not raw then pcall(function() raw = readfile("k7duels.json") end) end
        if raw then
            local ok, decoded = pcall(function() return HS:JSONDecode(raw) end)
            if ok and type(decoded)=="table" then diskCfg = decoded end
        end
    end
    local sessionCfg = nil
    pcall(function()
        if getgenv and type(getgenv()._K7DuelsCfg)=="table" then sessionCfg = getgenv()._K7DuelsCfg end
    end)
    if diskCfg and sessionCfg then
        cfg = {}
        for k,v in pairs(diskCfg) do cfg[k]=v end
        for k,v in pairs(sessionCfg) do cfg[k]=v end
    else cfg = sessionCfg or diskCfg end
    if not cfg then return end
    _savedCfg = cfg
    currentGuiTheme = "Azure"
    local function lk(e,d)
        if type(e)~="table" then return end
        if type(d)~="table" then return end
        if d.kb and Enum.KeyCode[d.kb] then e.kb=Enum.KeyCode[d.kb] else e.kb=nil end
        if d.gp and Enum.KeyCode[d.gp] then e.gp=Enum.KeyCode[d.gp] else e.gp=nil end
    end
    lk(KB.DropBrainrot,cfg.dropBrainrotKey);lk(KB.AutoLeft,cfg.autoLeftKey);lk(KB.AutoRight,cfg.autoRightKey)
    lk(KB.AutoBat,cfg.autoBatKey);lk(KB.TPBat,cfg.tpBatKey);lk(KB.LaggerToggle,cfg.laggerToggleKey);lk(KB.LaggerCarry,cfg.laggerCarryKey);lk(KB.TPFloor,cfg.tpFloorKey)
    lk(KB.GuiHide,cfg.guiHideKey);lk(KB.SpeedToggle,cfg.speedToggleKey)
    lk(KB.AntiDesync,cfg.antiDesyncKey)
    lk(KB.InstantReset,cfg.instantResetKey)
    if cfg.normalSpeed then NS=cfg.normalSpeed end;if cfg.carrySpeed then CS=cfg.carrySpeed end
    if cfg.laggerSpeed then LAGGER_SPEED=cfg.laggerSpeed end;if cfg.laggerCarrySpeed then LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end
    if cfg.grabRadius then Steal.StealRadius=cfg.grabRadius end;if cfg.stealDuration then Steal.StealDuration=cfg.stealDuration end
    if cfg.autoGrabSetDelayRadius~=nil then autoGrabSetDelayRadius=tonumber(cfg.autoGrabSetDelayRadius) or autoGrabSetDelayRadius end
    if cfg.autoGrabStopTime then autoGrabStopTime=tonumber(cfg.autoGrabStopTime) or autoGrabStopTime end
    if cfg.autoGrabStopEnabled~=nil then autoGrabStopEnabled=cfg.autoGrabStopEnabled==true end
    if cfg.stealMode then Steal.StealMode=(cfg.stealMode=="semi") and "semi" or "normal" end
    if cfg.autoTPHeight then autoTPHeight=cfg.autoTPHeight end
    if cfg.mirrorTPDown~=nil then mirrorTPDownEnabled=cfg.mirrorTPDown==true end
    if cfg.autoSwing~=nil then autoSwingEnabled=cfg.autoSwing==true end
    if cfg.guiTransparencyEnabled~=nil then guiTransparencyEnabled=cfg.guiTransparencyEnabled end
    if cfg.mobileButtonsEnabled~=nil then mobileButtonsEnabled=cfg.mobileButtonsEnabled end
    if cfg.uiLocked~=nil then uiLocked=cfg.uiLocked==true end
    if cfg.mobileButtonsLocked~=nil then mobileButtonsLocked=cfg.mobileButtonsLocked==true end
    if cfg.mobileButtonsSize~=nil then mobileButtonsSize=cfg.mobileButtonsSize end
    if cfg.stealBarScale~=nil then local s=tonumber(cfg.stealBarScale); if s and s>=0.5 and s<=1.2 then stealBarScale=s end end
    if cfg.circleButtonsEnabled~=nil then circleButtonsEnabled=cfg.circleButtonsEnabled==true end
    antiKickEnabled = false
    safeModeEnabled = false
    if cfg.antiDie~=nil then antiDieEnabled=cfg.antiDie==true end
    if type(cfg.animPack)=="string" then animPack=cfg.animPack end
    if type(cfg.stealBarPos)=="table" and cfg.stealBarPos.sx then
        stealBarPos = {sx=cfg.stealBarPos.sx, ox=cfg.stealBarPos.ox, sy=cfg.stealBarPos.sy, oy=cfg.stealBarPos.oy}
    end
    if cfg.animPackEnabled~=nil then animPackEnabled=cfg.animPackEnabled==true end
    if cfg.headlessEnabled~=nil then headlessEnabled=cfg.headlessEnabled==true end
    if cfg.korbloxEnabled~=nil then korbloxEnabled=cfg.korbloxEnabled==true end
    if type(cfg.visibleAvatarEnabled)=="table" then _G._VisibleAvatarPortEnabled=cfg.visibleAvatarEnabled end
    if type(cfg.visibleAvatarSelected)=="table" then _G._VisibleAvatarPortSelectedByCategory=cfg.visibleAvatarSelected end
    if cfg.playerEsp~=nil then playerEspEnabled=cfg.playerEsp==true end
    if cfg.carrySpeedActive~=nil then carrySpeedActive=cfg.carrySpeedActive end
    if cfg.laggerModeEnabled~=nil then laggerModeEnabled=cfg.laggerModeEnabled end
    if cfg.laggerCarryActive~=nil then laggerCarryActive=cfg.laggerCarryActive end
    if cfg.infJumpMode then InfJump.mode = cfg.infJumpMode end

    if cfg.tpBatVersion == "V1" or cfg.tpBatVersion == "V2" or cfg.tpBatVersion == "V3" or cfg.tpBatVersion == "Cam" then
        tpBatVersion = cfg.tpBatVersion
        local engineVer = (tpBatVersion == "Cam") and "V1" or tpBatVersion
        if _G.setVisibleTpBatVersion then _G.setVisibleTpBatVersion(engineVer) end
        if _G._VisibleTPBat then _G._VisibleTPBat.version = engineVer end
        pcall(function()
            if getgenv then
                getgenv()._K7DuelsCfg = getgenv()._K7DuelsCfg or {}
                getgenv()._K7DuelsCfg.tpBatVersion = tpBatVersion
            end
        end)
    end
    if cfg.aimbotMode == "Bypass V2" or cfg.aimbotMode == "Bypass" or cfg.aimbotMode == "Default" then
        aimbotMode = cfg.aimbotMode
    end
    if cfg.tpBatCameraLock ~= nil then
        if _G._AmbitiousSetTPBatCameraLock then
            _G._AmbitiousSetTPBatCameraLock(cfg.tpBatCameraLock == true)
        elseif _G._VisibleTPBat then
            _G._VisibleTPBat.cameraLock = cfg.tpBatCameraLock == true
        end
    end
    if cfg.antiRagdollMode == "V1" or cfg.antiRagdollMode == "V2" then
        antiRagdollMode = cfg.antiRagdollMode
    elseif cfg.antiRagdollMode == "No Splatter" then
        antiRagdollMode = "V2"
    elseif cfg.antiRagdollMode == "Splatter" then
        antiRagdollMode = "V1"
    end

    if cfg.xraySuite ~= nil then
        xraySuiteEnabled = cfg.xraySuite == true
        if xraySuiteEnabled and type(setXRaySuite)=="function" then
            task.defer(function() setXRaySuite(true) end)
        end
    end

    if cfg.e01Warning ~= nil then e01WarningEnabled = cfg.e01Warning == true end
    if cfg.kawatanSkin ~= nil then kawatanSkinEnabled = cfg.kawatanSkin == true end
    if cfg.kawatanSkinColor == "PURPLE" or cfg.kawatanSkinColor == "RED" or cfg.kawatanSkinColor == "BLUE" or cfg.kawatanSkinColor == "GALAXY" then
        kawatanSkinColor = cfg.kawatanSkinColor
    end
    if cfg.kawatanBodyType == "OFF" or cfg.kawatanBodyType == "WOMAN" or cfg.kawatanBodyType == "CLASSIC" then
        kawatanBodyType = cfg.kawatanBodyType
    end
    
    if cfg.antiBatV2SpeenEnabled ~= nil then antiBatV2SpeenEnabled = cfg.antiBatV2SpeenEnabled == true end
    if cfg.antiBatV2SpeenSpeed then antiBatV2SpeenSpeed = tonumber(cfg.antiBatV2SpeenSpeed) or antiBatV2SpeenSpeed end

    if cfg.antiBatMode == "V1" or cfg.antiBatMode == "V2" then antiBatMode = cfg.antiBatMode end
    if cfg.antiBat ~= nil then
        _G.AmbitiousAntiBatEnabled = cfg.antiBat == true
        if _G.AmbitiousAntiBat and _G.AmbitiousAntiBat.setEnabled then
            pcall(_G.AmbitiousAntiBat.setEnabled, _G.AmbitiousAntiBatEnabled)
        end
    end
    if cfg.batCounterMode == "V1" or cfg.batCounterMode == "V2" then
        batCounterMode = cfg.batCounterMode
    end
    if cfg.stealStopPercent then
        SemiSteal.CONFIG.STOP_PERCENT = math.clamp(tonumber(cfg.stealStopPercent) or 75, 1, 100)
        SemiSteal.CONFIG.USE_STOP_PERCENT = true
    end
    if cfg.stealDelayRadius then
        SemiSteal.CONFIG.DELAY_RADIUS = tonumber(cfg.stealDelayRadius) or 8
        autoGrabSetDelayRadius = SemiSteal.CONFIG.DELAY_RADIUS
    end

    if cfg.optimizerMode == "Normal" or cfg.optimizerMode == "Ultra" then
        optimizerMode = cfg.optimizerMode
    end
    if cfg.optimizerEnabled ~= nil then
        optimizerEnabled = cfg.optimizerEnabled == true
    end

    if cfg.fovValue then fovValue=cfg.fovValue;for idx,v in ipairs(fovOptions) do if v==fovValue then fovIndex=idx end end end
    if cfg.chromeImageVisible~=nil then _G._K7Duels_bgImageVisible=cfg.chromeImageVisible==true end
    perButtonDragEnabled=true
    if cfg.autoMoveSwing~=nil then autoMoveSwingEnabled=cfg.autoMoveSwing==true end
    if cfg.autoMoveSwingInterval then autoMoveSwingInterval=cfg.autoMoveSwingInterval end
    if cfg.skyTheme then currentSkyTheme=cfg.skyTheme;K7ApplyCustomSky(currentSkyTheme) end
    if type(cfg.btnPositions)=="table" and next(cfg.btnPositions)~=nil and writefile then
        pcall(function() writefile(MOB_POS_FILE,HS:JSONEncode(cfg.btnPositions)) end)
    end
    ragdollGuiEnabled=true
    if cfg.noCamCollision ~= nil then noCamCollisionEnabled = cfg.noCamCollision == true end
    -- Force VX7 ragdoll timers always on (no UI)
    ragdollGuiEnabled = true
    enemyRagdollTimerEnabled = true
    if _G._VisibleRagdollTimer then
        pcall(function() _G._VisibleRagdollTimer.SetPlayerEnabled(true) end)
        pcall(function() _G._VisibleRagdollTimer.SetEnemyEnabled(true) end)
    end
    if cfg.introEnabled ~= nil then introEnabled = cfg.introEnabled == true end
    if cfg.selectedIntroMusic~=nil then selectedIntroMusic=math.clamp(tonumber(cfg.selectedIntroMusic) or 1, 1, 10) end
    if cfg.keepMusicIndex~=nil then keepMusicIndex=math.clamp(tonumber(cfg.keepMusicIndex) or 1, 1, math.max(1, #KEEP_MUSIC_SONGS)) end
    if cfg.keepMusicEnabled~=nil then keepMusicEnabled=cfg.keepMusicEnabled==true end
    if cfg.aimbotSpeed then AIMBOT_SPEED=tonumber(cfg.aimbotSpeed) or AIMBOT_SPEED end
    if cfg.autoSwitchSpeedEnabled ~= nil then autoSwitchSpeedEnabled = cfg.autoSwitchSpeedEnabled == true end
    if type(cfg.tabLayoutMode) == "string" then
        local m = cfg.tabLayoutMode
        if m == "Top" or m == "Sidebar" or m == "Bottom" or m == "None" then
            tabLayoutMode = m
        end
    end
    if cfg.speedCycleMode == "V1" or cfg.speedCycleMode == "V2" then
        speedCycleMode = cfg.speedCycleMode
    end
    do
        local s = tonumber(cfg.uiScale)
        if s and s >= 0.5 and s <= 2 then
            uiScale = s
        end
    end
    do
        local bgId = cfg.selectedBgId
        if type(bgId) == "string" and bgId ~= "" and bgId ~= "0" then
            pcall(function()
                if getgenv then getgenv()._K7SelectedBgId = bgId end
                _G._K7SelectedBgId = bgId
            end)
        end
        local op = tonumber(cfg.bgOpacity)
        if op and op > 0 and op <= 1 then
            pcall(function()
                if getgenv then getgenv()._K7BgOpacity = op end
                _G._K7BgOpacity = op
            end)
        end
    end
end

local function loadConfigState()
    local cfg=_savedCfg;if not cfg then return end
    if type(cfg.visibleAvatarEnabled)=="table" then _G._VisibleAvatarPortEnabled=cfg.visibleAvatarEnabled end
    if type(cfg.visibleAvatarSelected)=="table" then _G._VisibleAvatarPortSelectedByCategory=cfg.visibleAvatarSelected end
    task.delay(0.8, function()
        if _G._VisibleAvatarPortRestore then pcall(_G._VisibleAvatarPortRestore) end
    end)
    if setIntroVisual then setIntroVisual(introEnabled==true) end
    if setKeepMusicVisual then setKeepMusicVisual(keepMusicEnabled==true) end
    if keepMusicEnabled then
        task.spawn(function()
            task.wait(1.5)
            if keepMusicEnabled then startKeepMusic(keepMusicIndex or 1) end
        end)
    end
    if normalBox then normalBox.Text=tostring(NS) end;if carryBox then carryBox.Text=tostring(CS) end
    if radInput then radInput.Text=tostring(Steal.StealRadius) end;if durationBox then durationBox.Text=tostring(Steal.StealDuration) end
    if delayRadBox then delayRadBox.Text=tostring(autoGrabSetDelayRadius) end
    if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED) end
    if laggerCarryBox then laggerCarryBox.Text=tostring(LAGGER_CARRY_SPEED) end
    if autoTPHeightBox then autoTPHeightBox.Text=tostring(autoTPHeight) end
    task.spawn(function()
        task.wait(0.15)
        if cfg.antiRagdoll then antiRagdollEnabled=true;if setAntiRagVisual then setAntiRagVisual(true) end;startAntiRagdoll() end
        pcall(startAntiFling)
        if cfg.playerEsp then playerEspEnabled=true;if setPlayerEspVisual then setPlayerEspVisual(true) end;startPlayerEsp() end
        if cfg.autoStealEnabled then Steal.AutoStealEnabled=true;if setInstaGrab then setInstaGrab(true) end;pcall(startAutoSteal) end
        if cfg.infiniteJump then
            InfJump.enabled = true
            if setInfJumpVisual then setInfJumpVisual(true) end
            if InfJump.mode == "hold" then startHoldMode() end
        end
        if cfg.medusaCounter then medusaCounterEnabled=true;if setMedusaVisual then setMedusaVisual(true) end;setupMedusa(LP.Character) end
        if cfg.antiBatV2SpeenEnabled then
            antiBatV2SpeenEnabled = true
            if setAntiBatV2SpeenVisual then setAntiBatV2SpeenVisual(true) end
            task.defer(function() pcall(startAntiBatV2Speen) end)
        end
        if cfg.batCounter then batCounterEnabled=true;if setBatCounterVisual then setBatCounterVisual(true) end;startBatCounter() end
        refreshSpeedModeLabel()
        if cfg.autoTPEnabled then autoTPEnabled=true;if setAutoTPVisual then setAutoTPVisual(true) end;startAutoTP() end
        if cfg.mirrorTPDown then mirrorTPDownEnabled=true;if setMirrorTPVisual then setMirrorTPVisual(true) end end
        if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
        if cfg.aimbotSpeed then AIMBOT_SPEED=tonumber(cfg.aimbotSpeed) or AIMBOT_SPEED end
        autoBatEnabled = false
        autoLeftEnabled = false
        autoRightEnabled = false
        if cfg.unwalkEnabled then unwalkEnabled=true;if setUnwalkVisual then setUnwalkVisual(true) end;task.spawn(function() task.wait(0.5);startUnwalk() end) end
        if cfg.antiLag then enableAntiLag();if setAntiLagVisual then setAntiLagVisual(true) end end
        if cfg.antiDie then antiDieEnabled=true;if setAntiDieVisual then setAntiDieVisual(true) end;if AntiDie then AntiDie:toggle(true) end end
        if circleButtonsEnabled and setCircleBtnsVisual then setCircleBtnsVisual(true) end
        if cfg.skyTheme then K7ApplyCustomSky(cfg.skyTheme) end
    end)
end

local _okInit, _errInit = pcall(function()
    loadConfigKeys()
    buildGui()
    if mobileButtonsEnabled then buildMobileButtons() end
    task.spawn(function()
        task.wait(0.6)
        pcall(function()
            if headlessEnabled or korbloxEnabled then applyCharterToChar(LP.Character) end
            if animPackEnabled and animPack and animPack ~= "NONE" then applyAnimPack(animPack) end
        end)
    end)
    loadConfigState()
    K7ApplyCustomSky(currentSkyTheme)
end)
if not _okInit then
    warn("[Visible Hub] init failed:", tostring(_errInit))
    pcall(function()
        if getgenv then getgenv()._K7DuelsRunning = false end
    end)
end

task.spawn(function()
    while not game:IsLoaded() do task.wait(0.1) end
    pcall(function()
        if getgenv then
            if type(getgenv()._K7DuelsCfg)=="table" and getgenv()._K7DuelsCfg.introEnabled ~= nil then
                introEnabled = getgenv()._K7DuelsCfg.introEnabled == true
            elseif getgenv()._K7IntroEnabled ~= nil then
                introEnabled = getgenv()._K7IntroEnabled == true
            end
        end
    end)
    if introEnabled then
        local SoundService = game:GetService("SoundService")
        local introSong = Instance.new("Sound", SoundService)
        introSong.Name = "IntroSong"
        introSong.SoundId = "rbxassetid://96888529539074"
        introSong.Volume = 0.55
        introSong.TimePosition = 14
        introSong:Play()
        task.delay(15, function()
            if introSong then introSong:Stop(); introSong:Destroy() end
        end)
    end
end)