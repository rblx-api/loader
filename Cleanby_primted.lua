local introSongIds, currentIntroSongIndex, Players, RunService, UserInputService, TweenService, Lighting, HttpService, Workspace
local localPlayer, currentCamera, getTime, clamp, floor, huge, sqrt, newVector3, zeroVector, newCFrame
local lookAtCFrame, getPlayersCached, waitForCharacterReady, carryController, colorThemes, outfits, currentOutfitIndex, outfitSelectorLabel, katanaSkinController, minecraftBatSkinController
local velocityHookedRoots, registerVelocityRoot, installVelocityReadHook, isHumanoidRagdolled, applyMovementVelocity, applyAnimationPack, disableAnimationPack, autoStealConnection, autoStealState, autoStealBusy
local getAutoStealVariantName, getAutoStealVariantIndex, teleportDown, antiRagdollController, antiRagdollV2State, enableAntiRagdollV2, disableAntiRagdollV2, antiDie, reapplyAntiDie, antiFlingShield
local showRagdollCountdown
local PRINTED_BRANDING = "LEAKED BY discord.gg/printed"
local function addPrintedBranding(parent, position, size, textSize)
    if not parent then
        return nil
    end
    local existing = parent:FindFirstChild("PrintedBranding")
    if existing then
        return existing
    end
    local label = Instance.new("TextLabel")
    label.Name = "PrintedBranding"
    label.Parent = parent
    label.Size = size or UDim2.new(1, -16, 0, 16)
    label.Position = position or UDim2.new(0, 8, 1, -20)
    label.BackgroundTransparency = 1
    label.Text = PRINTED_BRANDING
    label.TextColor3 = Color3.fromRGB(210, 210, 220)
    label.TextTransparency = 0.08
    label.Font = Enum.Font.GothamBold
    label.TextSize = textSize or 10
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.65
    label.ZIndex = 999
    return label
end

do
    local ReplicatedStorage
    do
        local introTweenService, introRunService, introPlayer, introTrack, introSongFileName, introSound, introHeartbeatConnection
        if _G.BloodHoundsRunning then
            return
        end
        _G.BloodHoundsRunning = true
        repeat
            task.wait()
        until game:IsLoaded()
        do
            local introPlayersService = game:GetService("Players")
            introTweenService = game:GetService("TweenService")
            introRunService = game:GetService("RunService")
            introPlayer = introPlayersService.LocalPlayer
        end
        introSongIds = {
            "https://files.catbox.moe/vbyghu.mp3",
            "https://files.catbox.moe/5g2wg1.mp3",
            "https://files.catbox.moe/r29x0i.mp3",
            "https://files.catbox.moe/n53amf.mp3",
            "https://files.catbox.moe/o4di3j.mp3",
            "https://files.catbox.moe/um4hgp.mp3",
            "https://files.catbox.moe/fiiu4a.mp3",
            "https://files.catbox.moe/mdjmee.mp3",
            "https://files.catbox.moe/2eysnf.mp3",
            "https://files.catbox.moe/d4uky5.mp3",
            "https://files.catbox.moe/8v5xra.mp3",
            "https://files.catbox.moe/aneanv.mp3",
            "https://files.catbox.moe/pm6lne.mp3",
            "https://files.catbox.moe/y4q5y3.mp3",
            "https://files.catbox.moe/pcdvty.mp3",
        }
        currentIntroSongIndex = 1
        pcall(function()
            if isfile and readfile and isfile("FictionHub.json") then
                local settingsData = game:GetService("HttpService"):JSONDecode(readfile("FictionHub.json"))
                if type(settingsData.cleanHubSongIndex) == "number" then
                    local songCount = #introSongIds
                    currentIntroSongIndex = math.clamp(math.floor(settingsData.cleanHubSongIndex), 1, songCount)
                end
            end
        end)
        introTrack = introSongIds[currentIntroSongIndex]
        introSongFileName = "cleanhub_intro_song_" .. currentIntroSongIndex .. ".mp3"
        introSound = nil
        introHeartbeatConnection = nil
        do
            local introGuiParents = {}
            local CoreGui = game:GetService("CoreGui")
            local playerGui = introPlayer and introPlayer:FindFirstChildOfClass("PlayerGui")
            introGuiParents[1] = CoreGui
            introGuiParents[2] = playerGui
            for _, guiParent in ipairs(introGuiParents) do
                guiParent = guiParent and guiParent:FindFirstChild("CleanLettersIntro")
                if guiParent then
                    guiParent:Destroy()
                end
            end
        end
        do
            local introGui, introClosed, closeIntro
            introGui = Instance.new("ScreenGui")
            introGui.Name = "CleanLettersIntro"
            introGui.IgnoreGuiInset = true
            introGui.ResetOnSpawn = false
            introGui.DisplayOrder = 100000
            introGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
            addPrintedBranding(introGui, UDim2.new(0, 0, 1, -42), UDim2.new(1, 0, 0, 22), 11)
            pcall(function()
                if syn and syn.protect_gui then
                    syn.protect_gui(introGui)
                end
            end)
            if not pcall(function()
                introGui.Parent = game:GetService("CoreGui")
            end) then
                introGui.Parent = introPlayer:WaitForChild("PlayerGui")
            end
            do
                local introLetters = {}
                local introAnimationStart = os.clock()
                local introRenderConnection = nil
                introClosed = false
                for i, imageAssetId in ipairs({
                    "rbxassetid://102527460927859",
                    "rbxassetid://115218770459100",
                    "rbxassetid://79239854929751",
                    "rbxassetid://132491364078344",
                    "rbxassetid://88405482927089",
                }) do
                    local imageLabel = Instance.new("ImageLabel", introGui)
                    imageLabel.Name = "CleanLetter_" .. i
                    imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                    imageLabel.Size = UDim2.fromOffset(72, 72)
                    imageLabel.Position = UDim2.new(0.5, (i - 3) * 40, 0.5, -18)
                    imageLabel.BackgroundTransparency = 1
                    imageLabel.Image = imageAssetId
                    imageLabel.ScaleType = Enum.ScaleType.Fit
                    imageLabel.ImageTransparency = 1
                    imageLabel.ZIndex = 3
                    introLetters[i] = {
                        image = imageLabel,
                        base = imageLabel.Position,
                        CleanHubIndex = i,
                    }
                    task.delay((i - 1) * 0.07, function()
                        if imageLabel.Parent then
                            introTweenService
                                :Create(
                                    imageLabel,
                                    TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                                    {
                                        ImageTransparency = 0,
                                    }
                                )
                                :Play()
                        end
                    end)
                end
                closeIntro = function()
                    if introClosed then
                        return
                    end
                    introClosed = true
                    if introRenderConnection then
                        introRenderConnection:Disconnect()
                    end
                    if introHeartbeatConnection then
                        introHeartbeatConnection:Disconnect()
                        introHeartbeatConnection = nil
                    end
                    if introSound then
                        pcall(function()
                            introSound:Stop()
                            introSound:Destroy()
                        end)
                    end
                    for _, letterEntry in ipairs(introLetters) do
                        if letterEntry.image.Parent then
                            introTweenService
                                :Create(letterEntry.image, TweenInfo.new(0.3), {
                                    ImageTransparency = 1,
                                })
                                :Play()
                        end
                    end
                    task.delay(0.34, function()
                        if introGui then
                            introGui:Destroy()
                        end
                    end)
                end
                introRenderConnection = introRunService.RenderStepped:Connect(function()
                    local elapsedTime = os.clock() - introAnimationStart
                    for _, letterEntry in ipairs(introLetters) do
                        local image = letterEntry.image
                        if image.Parent then
                            local animationPhase = elapsedTime * 2.5 + letterEntry.CleanHubIndex * 1.37
                            image.Position = letterEntry.base
                                + UDim2.fromOffset(math.sin(animationPhase) * 18, math.cos(animationPhase * 1.5) * 22)
                            image.Rotation = math.sin(animationPhase * 0.72) * 7
                        end
                    end
                end)
            end
            task.spawn(function()
                local function resolveAssetPath(filePath)
                    for _, entry in ipairs({
                        getcustomasset,
                        getsynasset,
                        getasset,
                    }) do
                        if typeof(entry) ~= "function" then
                            continue
                        end
                        local ok, result = pcall(function()
                            return entry(filePath)
                        end)
                        if ok and type(result) == "string" and result ~= "" then
                            return result
                        end
                    end
                    return nil
                end
                local soundAssetId = resolveAssetPath(introSongFileName)
                if not soundAssetId and isfile and isfile(introSongFileName) then
                    soundAssetId = resolveAssetPath(introSongFileName)
                end
                if not soundAssetId and writefile then
                    local ok, result = pcall(function()
                        return game:HttpGet(introTrack)
                    end)
                    if
                        ok
                        and type(result) == "string"
                        and #result > 100
                        and pcall(function()
                            writefile(introSongFileName, result)
                        end)
                    then
                        soundAssetId = resolveAssetPath(introSongFileName)
                    end
                end
                if introClosed or not soundAssetId then
                    return
                end
                introSound = Instance.new("Sound")
                introSound.Name = "CleanIntroSong"
                introSound.SoundId = soundAssetId
                introSound.Volume = 1
                introSound.Looped = false
                introSound.Parent = game:GetService("SoundService")
                introHeartbeatConnection = introSound.Ended:Connect(closeIntro)
                pcall(function()
                    introSound:Play()
                end)
            end)
            do
                local skipIntroButton = Instance.new("TextButton", introGui)
                skipIntroButton.Size = UDim2.fromScale(1, 1)
                skipIntroButton.BackgroundTransparency = 1
                skipIntroButton.Text = ""
                skipIntroButton.BorderSizePixel = 0
                skipIntroButton.AutoButtonColor = false
                skipIntroButton.ZIndex = 10
                skipIntroButton.Activated:Connect(closeIntro)
            end
            task.delay(10, closeIntro)
            while not introClosed do
                task.wait(0.05)
            end
        end
    end
    do
        local raycastParams
        task.wait(0.4)
        Players = game:GetService("Players")
        RunService = game:GetService("RunService")
        UserInputService = game:GetService("UserInputService")
        TweenService = game:GetService("TweenService")
        Lighting = game:GetService("Lighting")
        HttpService = game:GetService("HttpService")
        ReplicatedStorage = game:GetService("ReplicatedStorage")
        Workspace = game:GetService("Workspace")
        localPlayer = Players.LocalPlayer
        currentCamera = workspace.CurrentCamera
        getTime = tick
        clamp = math.clamp
        floor = math.floor
        huge = math.huge
        sqrt = math.sqrt
        newVector3 = Vector3.new
        zeroVector = Vector3.zero
        newCFrame = CFrame.new
        lookAtCFrame = CFrame.lookAt
        raycastParams = RaycastParams.new
        do
            local players = nil
            local playerCacheTime = 0
            getPlayersCached = function()
                local now = getTime()
                if players and now - playerCacheTime < 0.03 then
                    return players
                end
                players = Players:GetPlayers()
                playerCacheTime = now
                return players
            end
        end
        waitForCharacterReady = function(character, timeout)
            local waitDuration = timeout or 5
            local deadline = getTime() + waitDuration
            while
                not character
                or not character.Parent
                or not character:FindFirstChild("HumanoidRootPart")
                or not character:FindFirstChildOfClass("Humanoid")
            do
                if deadline < getTime() then
                    return false
                end
                task.wait(0.05)
            end
            return true
        end
        NS = 60
        CS = 29
        LAGGER_SPEED = 15
        LAGGER_CARRY_SPEED = 24.5
        MEDUSA_COOLDOWN = 25
        BAT_AIMBOT_SPEED = 58
        BYPASS_AIMBOT_SPEED = 60
        MOBILE_PANEL_WIDTH = 128
        MOBILE_PANEL_HEIGHT = 294
        CONFIG_FILE = "FictionHub.json"
        BAT_V2_HIT_DIST = 4.5
        _isDraggingButton = false
        backgroundIndex = 1
        backgroundImageTransparency = 0.55
        floatingButtonScale = 1
        progressBarScale = 1
        _floatingUIScales = {}
        carryController = {
            normalSpeed = NS,
            carrySpeed = CS,
            laggerSpeed = LAGGER_SPEED,
            laggerCarrySpeed = LAGGER_CARRY_SPEED,
            speedToggled = false,
            laggerMode = 0,
            softStealEnabled = false,
            softStealRadius = 10,
            softStealSpeed = 30,
            softStealLatched = false,
            _isCarrying = false,
            _lastCarryCheck = 0,
            _lvBoost = nil,
            _lvAtt = nil,
            _blockedTime = 0,
            _maxForce = 2200,
            _freeForce = 500,
            _heartbeatConn = nil,
            _softStealScanner = nil,
            _softStealAnimals = {},
            _softStealScanning = false,
            _state = nil,
            _dropInProgress = false,
            _batAimbotToggled = false,
            _rayParams = nil,
            _rayFilter = nil,
            _rayFilterTime = 0,
            isCarrying = function(self)
                local now = getTime()
                if now - (self._lastCarryCheck or 0) < 0.1 then
                    return self._isCarrying
                end
                self._lastCarryCheck = now
                local character = localPlayer.Character
                if not character then
                    self._isCarrying = false
                    return false
                end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local walkSpeed = humanoid and humanoid.WalkSpeed or 16
                local isCarrying = walkSpeed < 25 and walkSpeed > 0
                local ok, result = pcall(function()
                    return localPlayer:GetAttribute("Stealing")
                end)
                ok = ok and result == true
                local isEnabled = false
                if ok then
                    isEnabled = true
                end
                local ok2, result2 = pcall(function()
                    return character:GetAttribute("Stealing")
                end)
                if ok2 and result2 == true then
                    isEnabled = true
                end
                if not isEnabled then
                    for _, name in ipairs({
                        "Carrying",
                        "IsCarrying",
                        "Grabbed",
                        "Holding",
                        "StealHold",
                        "HasGrab",
                    }) do
                        local instance = character:FindFirstChild(name)
                        if instance then
                            if
                                instance:IsA("BoolValue") and instance.Value
                                or instance:IsA("ObjectValue") and instance.Value
                                or instance:IsA("StringValue") and instance.Value ~= ""
                            then
                                isEnabled = true
                                break
                            end
                        end
                    end
                end
                self._isCarrying = isCarrying or isEnabled
                return self._isCarrying
            end,
            getActiveSpeed = function(self)
                if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
                    return self.normalSpeed
                end
                if self.softStealEnabled then
                    local _, distance = self:getNearestSoftStealAnimal(self.softStealRadius)
                    if distance and distance <= self.softStealRadius then
                        self.softStealLatched = true
                        return self.softStealSpeed
                    end
                    if self.softStealLatched and self:isCarrying() then
                        return self.softStealSpeed
                    end
                    self.softStealLatched = false
                end
                if self.laggerMode == 1 then
                    return self.laggerSpeed
                end
                if self.laggerMode == 2 then
                    return self.laggerCarrySpeed
                end
                if self.speedToggled then
                    return self.carrySpeed
                end
                return self.normalSpeed
            end,
            getStatus = function(self)
                if not (self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled)) then
                    if self.softStealEnabled then
                        local _, distance = self:getNearestSoftStealAnimal(self.softStealRadius)
                        if
                            distance and distance <= self.softStealRadius
                            or self.softStealLatched and self:isCarrying()
                        then
                            return "AUTO CARRY", self.softStealSpeed
                        end
                    end
                    if self.laggerMode == 1 then
                        return "LAGGER", self.laggerSpeed
                    end
                    if self.laggerMode == 2 then
                        return "LAGGER CARRY", self.laggerCarrySpeed
                    end
                    if sel