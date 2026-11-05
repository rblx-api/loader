local introSongIds, currentIntroSongIndex, Players, RunService, UserInputService, TweenService, Lighting, HttpService, Workspace
local localPlayer, currentCamera, getTime, clamp, floor, huge, sqrt, newVector3, zeroVector, newCFrame
local lookAtCFrame, getPlayersCached, waitForCharacterReady, carryController, colorThemes, outfits, currentOutfitIndex, outfitSelectorLabel
local customTool3DAssets, bat3DSkinEnabled, medusa3DSkinEnabled, customBat3DSkin, customMedusa3DSkin, customTool3DSkinCards, setBat3DSkinVisual, setMedusa3DSkinVisual, refreshCustomTool3DSkins, customSoundsEnabled, rainbowToolsEnabled, setCustomSoundsVisual, setRainbowToolsVisual
local velocityHookedRoots, registerVelocityRoot, installVelocityReadHook, isHumanoidRagdolled, applyMovementVelocity, applyAnimationPack, disableAnimationPack, autoStealConnection, autoStealState, autoStealBusy
local getAutoStealVariantName, getAutoStealVariantIndex, teleportDown, antiRagdollController, antiRagdollV2State, enableAntiRagdollV2, disableAntiRagdollV2, antiDie, reapplyAntiDie, antiFlingShield
local showRagdollCountdown
local contentPages
local RH_Style, mainTabIndex, mainTabSetter, musicPlayerVolume, musicPlayerLoop, musicPlayerIndex, applyMusicPlayerConfig, batV2Version, batV2VersionSelector, batV2SpeedBox, applyBatV2VersionProfile
    mainTabIndex = 1
    musicPlayerVolume, musicPlayerLoop, musicPlayerIndex = 0.75, false, 1
    batV2Version = "Version 2"
    local customSkyEnabled, customSkyOriginalState, customSkyOriginalObjects, customSkyInstance, customSkyFloorPart, applyRevHubCustomSky, setCustomSkyVisual, mikuSkyEnabled, mikuSkyObject, mikuSkyThread, mikuStoredSkies, startMikuSky, stopMikuSky, setMikuSkyVisual
    local specialSkyMode, customSkyPreset, specialSkySelector, setSpecialSkyMode
    local SPECIAL_SKY_OPTIONS
    local savedProgressBarLocked, setStealBarLockVisual
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
        backgroundIndex = 6
        backgroundImageTransparency = 0.08
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
                    if self.speedToggled then
                        return "CARRY", self.carrySpeed
                    end
                    return "NORMAL", self.normalSpeed
                end
                return "NORMAL", self.normalSpeed
            end,
        }
        do
            local function destroyLV()
                if carryController._lvBoost and carryController._lvBoost.Parent then
                    pcall(function()
                        carryController._lvBoost:Destroy()
                    end)
                end
                if carryController._lvAtt and carryController._lvAtt.Parent then
                    pcall(function()
                        carryController._lvAtt:Destroy()
                    end)
                end
                carryController._lvBoost = nil
                carryController._lvAtt = nil
            end
            local function setupLV(parent)
                if carryController._lvBoost and carryController._lvBoost.Parent == parent then
                    return
                end
                destroyLV()
                local attachment = Instance.new("Attachment")
                attachment.Parent = parent
                local linearVelocity = Instance.new("LinearVelocity")
                linearVelocity.Name = "CarryBoostLV"
                linearVelocity.Attachment0 = attachment
                linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
                linearVelocity.PrimaryTangentAxis = newVector3(1, 0, 0)
                linearVelocity.SecondaryTangentAxis = newVector3(0, 0, 1)
                linearVelocity.MaxForce = carryController._maxForce
                linearVelocity.PlaneVelocity = Vector2.zero
                linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
                linearVelocity.Parent = parent
                carryController._lvAtt = attachment
                carryController._lvBoost = linearVelocity
                pcall(function()
                    parent:SetNetworkOwner(localPlayer)
                end)
            end
            carryController.scanSoftStealAnimals = function(self)
                self._softStealAnimals = {}
                local plots = Workspace:FindFirstChild("Plots")
                if not plots then
                    return
                end
                for _, child in ipairs(plots:GetChildren()) do
                    if child:IsA("Model") then
                        local animalPodiums = child:FindFirstChild("AnimalPodiums")
                        if animalPodiums then
                            for _, child2 in ipairs(animalPodiums:GetChildren()) do
                                if child2:IsA("Model") then
                                    local base = child2:FindFirstChild("Base")
                                    base = base and base:FindFirstChild("Spawn")
                                    if base then
                                        table.insert(self._softStealAnimals, {
                                            plot = child.Name,
                                            slot = child2.Name,
                                            worldPosition = base.Position,
                                            uid = child.Name .. "_" .. child2.Name,
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
            end
            carryController.startSoftStealScanner = function(callback)
                if callback._softStealScanner then
                    return
                end
                callback._softStealScanning = true
                callback:scanSoftStealAnimals()
                callback._softStealScanner = RunService.Heartbeat:Connect(function()
                    if not callback._softStealScanning then
                        return
                    end
                    callback:scanSoftStealAnimals()
                end)
            end
            carryController.stopSoftStealScanner = function(self)
                self._softStealScanning = false
                if self._softStealScanner then
                    self._softStealScanner:Disconnect()
                    self._softStealScanner = nil
                end
            end
            carryController.getNearestSoftStealAnimal = function(self, radius)
                local character = localPlayer.Character
                if character then
                    character = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
                end
                if not character then
                    return nil, huge
                end
                local softStealAnimals = self._softStealAnimals
                local position = character.Position
                local bestDistance = huge
                local animals = nil
                for i = 1, #softStealAnimals do
                    local rootPart = softStealAnimals[i]
                    if rootPart.worldPosition then
                        local dx = position.X - rootPart.worldPosition.X
                        local dy = position.Y - rootPart.worldPosition.Y
                        local dz = position.Z - rootPart.worldPosition.Z
                        local distance = sqrt(dx * dx + dy * dy + dz * dz)
                        if distance < bestDistance then
                            bestDistance = distance
                            animals = rootPart
                        end
                    end
                end
                if radius and bestDistance > radius then
                    return nil, bestDistance
                end
                return animals, bestDistance
            end
            carryController.updateMovement = function(self, deltaTime)
                local character = localPlayer.Character
                if not character then
                    return
                end
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoidRootPart or not humanoid then
                    return
                end
                local speed = self:getActiveSpeed()
                local moveDirection = humanoid.MoveDirection
                local moving = moveDirection.Magnitude > 0.1
                local unit = nil
                if moving then
                    if not self._rayParams then
                        self._rayParams = raycastParams()
                        self._rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        self._rayFilter = {}
                        self._rayFilterTime = 0
                    end
                    local now = getTime()
                    if now - self._rayFilterTime > 1 then
                        self._rayFilterTime = now
                        local rayFilter = self._rayFilter
                        while #rayFilter > 0 do
                            rayFilter[#rayFilter] = nil
                        end
                        rayFilter[1] = character
                        local plist = getPlayersCached()
                        for i = 1, #plist do
                            local p = plist[i]
                            if p.Character then
                                rayFilter[#rayFilter + 1] = p.Character
                            end
                        end
                        self._rayParams.FilterDescendantsInstances = rayFilter
                    else
                        local rayFilter = self._rayFilter
                        local found = false
                        for i = 1, #rayFilter do
                            if rayFilter[i] == character then
                                found = true
                                break
                            end
                        end
                        if not found then
                            rayFilter[1] = character
                            self._rayParams.FilterDescendantsInstances = rayFilter
                        end
                    end
                    local unit2 = newVector3(moveDirection.X, 0, moveDirection.Z).Unit
                    local rayParams = self._rayParams
                    local hit =
                        Workspace:Raycast(humanoidRootPart.Position + newVector3(0, 1, 0), unit2 * 2.5, rayParams)
                    local canCollide = hit and hit.Instance and hit.Instance.CanCollide
                    unit = nil
                    if canCollide then
                        local nf = newVector3(hit.Normal.X, 0, hit.Normal.Z)
                        unit = nil
                        if nf.Magnitude > 0.7 then
                            unit = nf.Unit
                        end
                    end
                end
                local hVelocity =
                    newVector3(humanoidRootPart.AssemblyLinearVelocity.X, 0, humanoidRootPart.AssemblyLinearVelocity.Z)
                local blocked = unit ~= nil or moving and hVelocity.Magnitude < 2
                if blocked then
                    for _, child in ipairs(character:GetChildren()) do
                        if child:IsA("Model") then
                            for _, descendant in ipairs(child:GetDescendants()) do
                                if descendant:IsA("BasePart") and descendant.CanCollide then
                                    descendant.CanCollide = false
                                end
                            end
                        end
                    end
                    for _, name in ipairs({
                        "Carrying",
                        "IsCarrying",
                        "Grabbed",
                        "Holding",
                        "StealHold",
                        "HasGrab",
                    }) do
                        local instance = character:FindFirstChild(name)
                        if
                            instance
                            and instance:IsA("ObjectValue")
                            and instance.Value
                            and instance.Value:IsA("Model")
                        then
                            for _, descendant in ipairs(instance.Value:GetDescendants()) do
                                if descendant:IsA("BasePart") and descendant.CanCollide then
                                    descendant.CanCollide = false
                                end
                            end
                        end
                    end
                end
                local state = humanoid:GetState()
                if
                    not (
                        state == Enum.HumanoidStateType.Physics
                        or state == Enum.HumanoidStateType.Ragdoll
                        or state == Enum.HumanoidStateType.FallingDown
                        or self._dropInProgress
                        or self._batAimbotToggled
                    )
                then
                    if not carryController._lvBoost or carryController._lvBoost.Parent ~= humanoidRootPart then
                        setupLV(humanoidRootPart)
                    end
                    local lvBoost = carryController._lvBoost
                    if lvBoost then
                        if not lvBoost.Enabled then
                            lvBoost.Enabled = true
                        end
                        if 0.1 < moveDirection.Magnitude then
                            local unit2 = newVector3(moveDirection.X, 0, moveDirection.Z).Unit
                            if unit then
                                local wanted = unit2 * speed
                                local along = wanted - unit * wanted:Dot(unit)
                                if along.Magnitude < 0.5 then
                                    lvBoost.PlaneVelocity = Vector2.zero
                                else
                                    lvBoost.PlaneVelocity = Vector2.new(along.X, along.Z)
                                end
                            else
                                lvBoost.PlaneVelocity = Vector2.new(unit2.X * speed, unit2.Z * speed)
                            end
                        else
                            lvBoost.PlaneVelocity = Vector2.zero
                        end
                        if blocked then
                            self._blockedTime = self._blockedTime + (deltaTime or 0.016)
                        else
                            self._blockedTime = 0
                        end
                        if self._blockedTime > 0.35 then
                            if lvBoost.MaxForce ~= self._freeForce then
                                lvBoost.MaxForce = self._freeForce
                            end
                        elseif lvBoost.MaxForce ~= self._maxForce then
                            lvBoost.MaxForce = self._maxForce
                        end
                    end
                elseif carryController._lvBoost then
                    carryController._lvBoost.PlaneVelocity = Vector2.zero
                    if carryController._lvBoost.Enabled then
                        carryController._lvBoost.Enabled = false
                    end
                end
            end
            carryController.start = function(deltaTime236)
                if deltaTime236._heartbeatConn then
                    return
                end
                deltaTime236._heartbeatConn = RunService.Heartbeat:Connect(function(deltaTime)
                    deltaTime236:updateMovement(deltaTime)
                end)
                if deltaTime236.softStealEnabled then
                    deltaTime236:startSoftStealScanner()
                end
                print("[CarrySystem] Activado")
            end
            carryController.stop = function(self)
                if self._heartbeatConn then
                    self._heartbeatConn:Disconnect()
                    self._heartbeatConn = nil
                end
                self:stopSoftStealScanner()
                destroyLV()
                self.softStealLatched = false
                print("[CarrySystem] Desactivado")
            end
        end
    end
    carryController.setNormalSpeed = function(self, value)
        self.normalSpeed = clamp(value, 1, 500)
    end
    carryController.setCarrySpeed = function(self, value)
        self.carrySpeed = clamp(value, 1, 500)
    end
    carryController.setLaggerSpeed = function(self, value)
        self.laggerSpeed = clamp(value, 0.1, 500)
    end
    carryController.setLaggerCarrySpeed = function(self, value)
        self.laggerCarrySpeed = clamp(value, 0.1, 500)
    end
    carryController.setSoftStealSpeed = function(self, value)
        self.softStealSpeed = clamp(value, 1, 500)
    end
    carryController.setSoftStealRadius = function(self, value)
        self.softStealRadius = clamp(value, 1, 200)
    end
    carryController.toggleCarryMode = function(self)
        self.speedToggled = not self.speedToggled
    end
    carryController.setLaggerMode = function(self, mode)
        if mode == 0 then
            self.laggerMode = 0
        elseif mode == 1 then
            self.laggerMode = 1
        elseif mode == 2 then
            self.laggerMode = 2
        end
    end
    carryController.toggleLaggerMode = function(self)
        if self.laggerMode == 0 then
            self.laggerMode = 1
        elseif self.laggerMode == 1 then
            self.laggerMode = 2
        else
            self.laggerMode = 0
        end
    end
    carryController.setSoftStealEnabled = function(self, softStealEnabled)
        self.softStealEnabled = softStealEnabled
        if softStealEnabled then
            self:startSoftStealScanner()
        else
            self:stopSoftStealScanner()
            self.softStealLatched = false
        end
    end
    carryController.toggleSoftSteal = function(self)
        self:setSoftStealEnabled(not self.softStealEnabled)
    end
    carryController.isRunning = function(self)
        return self._heartbeatConn ~= nil
    end
    carryController.getCurrentSpeed = function(self)
        return self:getActiveSpeed()
    end
    colorThemes = {
        Gris = Color3.fromRGB(30, 30, 35),
    }
    currentColorTheme = "Gris"
    selectedColor = colorThemes["Gris"]
    getThemeColor = function()
        return selectedColor
    end
    do
        local object = 0
        local object266 = nil
        applyColorTheme = function(themeName)
            local color = colorThemes[themeName]
            if not color then
                return
            end
            currentColorTheme = themeName
            selectedColor = color
            updateAllUIThemeColors(color)
            saveAllSettings()
        end
        updateAllUIThemeColors = function(color)
            local time = getTime()
            if color == object266 and time - object < 0.1 then
                return
            end
            object = time
            object266 = color
            if progressFill then
                progressFill.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
                progressFill.BackgroundTransparency = 0.32
                local fillStroke = progressFill:FindFirstChild("FillStroke")
                if fillStroke then
                    fillStroke.Color = Color3.fromRGB(210, 210, 220)
                end
                local uiGradient = progressFill:FindFirstChildOfClass("UIGradient")
                if uiGradient then
                    local data = {}
                    local object = ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 170, 170))
                    local object282 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 140, 140))
                    data[1] = object
                    data[2] = object282
                    data[3] = ColorSequenceKeypoint.new(1, Color3.fromRGB(105, 105, 105))
                    uiGradient.Color = ColorSequence.new(data)
                end
            end
            if pbFrame then
                local textLabel = pbFrame:FindFirstChild("FPSNeon")
                if textLabel then
                    textLabel.TextColor3 = Color3.fromRGB(210, 210, 220)
                end
                if progressPingLabel then
                    progressPingLabel.TextColor3 = Color3.fromRGB(210, 210, 220)
                end
                if progressRadLbl then
                    progressRadLbl.TextColor3 = Color3.fromRGB(210, 210, 220)
                end
                if progressPct then
                    progressPct.TextColor3 = Color3.fromRGB(235, 235, 240)
                end
            end
            local function searchAndUpdateText(parent)
                for _, descendant in ipairs(parent:GetDescendants()) do
                    if descendant:IsA("TextLabel") then
                        if
                            descendant.Text:find("Spd:")
                            or descendant.Name == "FictionHubSpeedIndicator"
                            or descendant.Text:find("FPS")
                            or descendant.Text:find("speed")
                        then
                            descendant.TextColor3 = Color3.fromRGB(210, 210, 220)
                        end
                    end
                    if descendant:IsA("UIStroke") then
                        if
                            descendant.Color == Color3.fromRGB(95, 95, 105)
                            or descendant.Color == Color3.fromRGB(180, 180, 190)
                        then
                            descendant.Color = color
                        end
                    end
                end
            end
            if gui then
                searchAndUpdateText(gui)
            end
            if tpBatFloatingButton then
                local object = batDesyncTpEnabled
                paintFloatingBtn(tpBatFloatingButton, object)
            end
            if batV2FloatingButton then
                local object = autoBatV2Enabled
                paintFloatingBtn(batV2FloatingButton, object)
            end
            local data = tabButtons or {}
            for _, label in ipairs(data) do
                if
                    label.TextColor3 == Color3.fromRGB(180, 180, 190)
                    or label.TextColor3 == Color3.fromRGB(95, 95, 105)
                then
                    label.TextColor3 = color
                end
            end
            for _, entry in pairs(espHighlightCache) do
                if entry then
                    entry.FillColor = color
                    entry.OutlineColor = color
                end
            end
            for _, entry304 in pairs(espTracerCache) do
                if entry304 then
                    for _, entry in ipairs(entry304) do
                        if entry then
                            entry.Color = color
                        end
                    end
                end
            end
            for _, entry309 in pairs(espBillboardCache) do
                if entry309 then
                    local imageLabel = entry309:FindFirstChildOfClass("ImageLabel")
                    if imageLabel then
                        local uIStroke = imageLabel:FindFirstChildOfClass("UIStroke")
                        if uIStroke then
                            uIStroke.Color = color
                        end
                    end
                end
            end
            if main then
                local titleFrame = main:FindFirstChild("TitleFrame")
                if titleFrame then
                    for _, descendant in ipairs(titleFrame:GetDescendants()) do
                        if
                            descendant:IsA("UIStroke")
                            and (
                                descendant.Color == Color3.fromRGB(95, 95, 105)
                                or descendant.Color == Color3.fromRGB(180, 180, 190)
                            )
                        then
                            descendant.Color = color
                        end
                    end
                end
            end
            if miniBtn then
                miniBtn.TextColor3 = Color3.fromRGB(210, 210, 220)
            end
            local playerGui = localPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                local ragCountdownBillboard = playerGui:FindFirstChild("RagCountdownBillboard")
                if ragCountdownBillboard then
                    local textLabel = ragCountdownBillboard:FindFirstChildOfClass("TextLabel")
                    if textLabel then
                        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        local uiGradient = textLabel:FindFirstChildOfClass("UIGradient")
                        if uiGradient then
                            local gradientKeypoints = {}
                            local gradientStart = ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 210))
                            local gradientHighlightStart = ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1))
                            local gradientHighlightEnd = ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1))
                            local gradientEnd = ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1))
                            gradientKeypoints[1] = gradientStart
                            gradientKeypoints[2] = gradientHighlightStart
                            gradientKeypoints[3] = gradientHighlightEnd
                            gradientKeypoints[4] = gradientEnd
                            gradientKeypoints[5] = ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 210))
                            uiGradient.Color = ColorSequence.new(gradientKeypoints)
                        end
                    end
                end
            end
            if MobilePanel then
                for _, child in ipairs(MobilePanel:GetChildren()) do
                    if child:IsA("TextButton") and child:FindFirstChild("BtnGrad") then
                        paintFloatingBtn(child, child:GetAttribute("MobActive") == true)
                    end
                end
            end
            if RH_Style and gui then pcall(function() RH_Style.refresh(gui, color, "MK") end) end
        end
    end
    local getAutoStealDuration, getPlotsRoot
    do
        local outfitAssets = {
            V1 = {
                shirt = 123181702116947,
                pants = 93330291631062,
                hair = 140188532534398,
            },
            V2 = {
                shirt = 101796619834594,
                pants = 18975891159,
                hair = 115520061093937,
            },
            V3 = {
                shirt = 6361021759,
                pants = 5414143509,
                hair = 8349240186,
            },
        }
        local function toAssetUrl(assetId)
            return "http://www.roblox.com/asset/?id=" .. tostring(assetId)
        end
        local function applyNoOutfit(character)
            local character = character or localPlayer.Character
            if not character then
                return
            end
            for _, child in ipairs(character:GetChildren()) do
                if child.Name:sub(1, 12) == "LocalOutfit_" then
                    pcall(function()
                        child:Destroy()
                    end)
                end
            end
            local oldAcc = character:FindFirstChild("AuFfitAccessory")
            if oldAcc then
                pcall(function()
                    oldAcc:Destroy()
                end)
            end
            local oldKorblox = character:FindFirstChild("Korblox_RightLeg")
            if oldKorblox then
                pcall(function()
                    oldKorblox:Destroy()
                end)
            end
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
                    pcall(function()
                        child:Destroy()
                    end)
                end
            end
            local head = character:FindFirstChild("Head")
            if head then
                head.Transparency = 0
                head.CanCollide = true
                head.LocalTransparencyModifier = 0
                local face = head:FindFirstChild("face")
                if face then
                    face.Transparency = 0
                end
                local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh")
                if specialMesh then
                    pcall(function()
                        specialMesh:Destroy()
                    end)
                end
            end
            pcall(function()
                local neck = character:FindFirstChild("Neck")
                if neck then
                    neck.Enabled = true
                end
            end)
            for _, partName in ipairs({
                "RightUpperLeg",
                "RightLowerLeg",
                "RightFoot",
            }) do
                local limb = character:FindFirstChild(partName)
                if limb then
                    limb.Transparency = 0
                end
            end
            local shirt = character:FindFirstChildWhichIsA("Shirt")
            if shirt then
                pcall(function()
                    shirt:Destroy()
                end)
            end
            local pants = character:FindFirstChildWhichIsA("Pants")
            if pants then
                pcall(function()
                    pants:Destroy()
                end)
            end
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Accessory") then
                    local h = child:FindFirstChild("Handle")
                    if h then
                        h.Transparency = 0
                    end
                end
            end
        end
        outfits = {}
        local outfitV1 = {
            accessory = 10159600649,
            offset = newVector3(0, 1, -0.2),
            shirt = "http://www.roblox.com/asset/?id=9683332638",
            pants = "http://www.roblox.com/asset/?id=93182020184041",
            headMesh = "http://www.roblox.com/asset/?id=134079402",
            headTexture = "http://www.roblox.com/asset/?id=133940918 ",
            korblox = "none",
            label = "Outfit 1",
            headlessKorblox = true,
        }
        local outfitV2 = {
            accessory = 1744060292,
            offset = newVector3(0, 1.3, -0.2),
            shirt = "http://www.roblox.com/asset/?id=9683332638",
            pants = "http://www.roblox.com/asset/?id=93182020184041",
            headMesh = "http://www.roblox.com/asset/?id=134079402",
            headTexture = "http://www.roblox.com/asset/?id=133940918 ",
            korblox = "none",
            label = "Outfit 2",
            headlessKorblox = true,
        }
        local outfitV3 = {
            accessory = 121097973925756,
            offset = newVector3(0, 0.9, 0),
            shirt = toAssetUrl(outfitAssets.V1.shirt),
            pants = toAssetUrl(outfitAssets.V1.pants),
            headMesh = "http://www.roblox.com/asset/?id=134079402",
            headTexture = "http://www.roblox.com/asset/?id=133940918",
            korblox = "none",
            label = "Eclipse V1",
            headlessKorblox = true,
        }
        local outfitV4 = {
            accessory = 10159600649,
            offset = newVector3(0, 1, -0.2),
            shirt = toAssetUrl(outfitAssets.V2.shirt),
            pants = toAssetUrl(outfitAssets.V2.pants),
            headMesh = "http://www.roblox.com/asset/?id=134079402",
            headTexture = "http://www.roblox.com/asset/?id=133940918",
            korblox = "none",
            label = "Eclipse V2",
            headlessKorblox = true,
        }
        local outfitV5 = {
            accessory = 10159600649,
            offset = newVector3(0, 0.9, -0.2),
            shirt = toAssetUrl(outfitAssets.V3.shirt),
            pants = toAssetUrl(outfitAssets.V3.pants),
            headMesh = "http://www.roblox.com/asset/?id=134079402",
            headTexture = "http://www.roblox.com/asset/?id=133940918",
            korblox = "none",
            label = "Eclipse V3",
            headlessKorblox = true,
        }
        outfits[1] = outfitV1
        outfits[2] = outfitV2
        outfits[3] = outfitV3
        outfits[4] = outfitV4
        outfits[5] = outfitV5
        outfits[6] = {
            label = "NO",
            customApply = applyNoOutfit,
        }
    end
    currentOutfitIndex = 1
    outfitSelectorLabel = nil
    BACKGROUND_IMAGES = {
        {label = "BG 1", id = "rbxassetid://111938659419739"},
        {label = "BG 2", id = "rbxassetid://120846140387092"},
        {label = "BG 3", id = "rbxassetid://124141498575881"},
        {label = "BG 4", id = "rbxassetid://134550584218036"},
        {label = "BG 5", id = "rbxassetid://111623129376390"},
        {label = "BG 6", id = "rbxassetid://133765467551361", scaleType = Enum.ScaleType.Crop},
    }
    backgroundSelectorLabel = nil
    backgroundImage = nil
    backgroundImagePB = nil
    applyBackground = function(index)
        backgroundIndex = clamp(index or 1, 1, #BACKGROUND_IMAGES)
        local background = BACKGROUND_IMAGES[backgroundIndex]
        if not background then
            return
        end
        local id = background.id or ""
        local transparency = background.id and math.min(backgroundImageTransparency, 0.12) or 1
        if backgroundImage and backgroundImage.Parent then
            backgroundImage.Image = id
            backgroundImage.ScaleType = background.scaleType or Enum.ScaleType.Stretch
            backgroundImage.ImageTransparency = transparency
        end
        if backgroundImagePB and backgroundImagePB.Parent then
            backgroundImagePB.Image = id
            backgroundImagePB.ScaleType = background.scaleType or Enum.ScaleType.Stretch
            backgroundImagePB.ImageTransparency = id ~= "" and math.min(transparency + 0.15, 1) or 1
        end
        if backgroundSelectorLabel then
            backgroundSelectorLabel.Text = background.label
        end
    end
    do
        local function loadAvatarAsset(assetId)
            local ok, result = pcall(function()
                return game:GetObjects("rbxassetid://" .. tostring(assetId))
            end)
            if ok and typeof(result) == "table" and #result > 0 then
                return result
            end
            local ok2, result2 = pcall(function()
                return game:GetService("InsertService"):LoadAsset(assetId)
            end)
            if ok2 and result2 then
                return {
                    result2,
                }
            end
            return nil
        end
        local function applyHeadlessKorblox(parent)
            if not parent then
                return
            end
            pcall(function()
                localPlayer.CharacterAvatarType = Enum.AvatarType.R6
            end)
            local head = parent:FindFirstChild("Head")
            if head then
                head.Transparency = 1
                head.CanCollide = false
                head.LocalTransparencyModifier = 1
                local face = head:FindFirstChild("face")
                if face then
                    face.Transparency = 1
                end
            end
            pcall(function()
                local neck = parent:FindFirstChild("Neck")
                if neck then
                    neck.Enabled = false
                end
            end)
            for _, child in pairs(parent:GetChildren()) do
                if child:IsA("Accessory") then
                    local weld = child:FindFirstChildWhichIsA("Weld")
                        or child:FindFirstChildWhichIsA("WeldConstraint")
                        or child:FindFirstChildWhichIsA("Motor6D")
                    if weld then
                        local part0 = weld.Part0
                        local part1 = weld.Part1
                        if part0 and part0.Name == "Head" or part1 and part1.Name == "Head" then
                            child.Parent = nil
                        end
                    end
                end
            end
            local rightLegConfig = {
                id = "rbxassetid://139607718",
                targetBodyPart = "RightUpperLeg",
                partsToHide = {
                    "RightUpperLeg",
                    "RightLowerLeg",
                    "RightFoot",
                },
                scale = newVector3(1, 1, 1),
                offset = newCFrame(0, 0, 0),
            }
            local targetPart = parent:FindFirstChild(rightLegConfig.targetBodyPart)
            if targetPart then
                local oldAsset = parent:FindFirstChild("Korblox_RightLeg")
                if oldAsset then
                    oldAsset:Destroy()
                end
                for _, partName in ipairs(rightLegConfig.partsToHide) do
                    local limb = parent:FindFirstChild(partName)
                    if limb and limb:IsA("BasePart") then
                        limb.Transparency = 1
                    end
                end
                local ok, result = pcall(function()
                    return game:GetObjects(rightLegConfig.id)
                end)
                if ok and result and #result > 0 then
                    local assetModel = result[1]
                    assetModel.Name = "Korblox_RightLeg"
                    local isBasePart = assetModel:IsA("BasePart") and assetModel
                        or assetModel:FindFirstChildWhichIsA("BasePart", true)
                    if isBasePart then
                        isBasePart.Size = isBasePart.Size * rightLegConfig.scale
                        isBasePart.CanCollide = false
                        isBasePart.CFrame = targetPart.CFrame * rightLegConfig.offset
                        local weld = Instance.new("WeldConstraint")
                        weld.Part0 = targetPart
                        weld.Part1 = isBasePart
                        weld.Parent = isBasePart
                        assetModel.Parent = parent
                    end
                end
            end
        end
        applyOutfitByIndex = function(index)
            local config = outfits[index]
            if not config then
                return
            end
            local character = localPlayer.Character
            if not character then
                return
            end
            if config.customApply then
                config.customApply(character)
                if outfitSelectorLabel then
                    outfitSelectorLabel.Text = config.label
                end
                return
            end
            character:WaitForChild("Head", 5)
            local head = character:FindFirstChild("Head")
            if not head then
                return
            end
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
                    pcall(function()
                        child:Destroy()
                    end)
                end
            end
            local done = false
            if head:IsA("MeshPart") then
                done = pcall(function()
                    head.MeshId = config.headMesh
                    if config.headTexture then
                        head.TextureID = config.headTexture
                    end
                end)
            end
            if not done then
                local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
                specialMesh.Parent = head
                specialMesh.MeshType = Enum.MeshType.FileMesh
                specialMesh.MeshId = config.headMesh
                specialMesh.TextureId = config.headTexture or ""
            end
            if config.shirt then
                local shirt = character:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
                shirt.Name = "Shirt"
                shirt.ShirtTemplate = config.shirt
                shirt.Parent = character
            end
            if config.pants then
                local pants = character:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
                pants.Name = "Pants"
                pants.PantsTemplate = config.pants
                pants.Parent = character
            end
            local auFfitAccessory = character:FindFirstChild("AuFfitAccessory")
            if auFfitAccessory then
                auFfitAccessory:Destroy()
            end
            if config.accessory and head then
                local objs = loadAvatarAsset(config.accessory)
                if objs then
                    local basePart = nil
                    for _, o in ipairs(objs) do
                        if o:IsA("BasePart") then
                            basePart = o
                            break
                        else
                            basePart = o:FindFirstChildWhichIsA("BasePart", true)
                            if not basePart then
                                basePart = nil
                                continue
                            end
                        end
                        break
                    end
                    if basePart then
                        local clone = basePart:Clone()
                        clone.Name = "AuFfitAccessory"
                        clone.CanCollide = false
                        clone.Anchored = false
                        clone.Massless = true
                        clone.Parent = character
                        local weld = Instance.new("Weld")
                        weld.Part0 = head
                        weld.Part1 = clone
                        weld.C0 = newCFrame(config.offset)
                        weld.Parent = clone
                    end
                    for _, o in ipairs(objs) do
                        pcall(function()
                            o:Destroy()
                        end)
                    end
                end
            end
            if config.headlessKorblox then
                applyHeadlessKorblox(character)
            elseif character then
                local head2 = character:FindFirstChild("Head")
                if head2 then
                    head2.Transparency = 0
                    head2.CanCollide = true
                    head2.LocalTransparencyModifier = 0
                    local face = head2:FindFirstChild("face")
                    if face then
                        face.Transparency = 0
                    end
                end
                pcall(function()
                    local neck = character:FindFirstChild("Neck")
                    if neck then
                        neck.Enabled = true
                    end
                end)
                for _, partName in ipairs({
                    "RightUpperLeg",
                    "RightLowerLeg",
                    "RightFoot",
                }) do
                    local limb = character:FindFirstChild(partName)
                    if limb then
                        limb.Transparency = 0
                    end
                end
                local korbloxRightLeg = character:FindFirstChild("Korblox_RightLeg")
                if korbloxRightLeg then
                    korbloxRightLeg:Destroy()
                end
            end
            if outfitSelectorLabel then
                outfitSelectorLabel.Text = config.label
            end
        end
    end
    speedMode = false
    antiRagdollMode = "off"
    antiDieEnabled = false
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
    dropMode = 1
    antiLagEnabled = false
    removeAccessoriesEnabled = false
    stretchEnabled = false
    stretchFOV = 120
    uiLocked = true
    editModeEnabled = false
    uiScaleValue = 70
    espEnabled = false
    antiKickEnabled = false
    setSafeModeVisual = nil
    mirrorTPDownEnabled = false
    mirrorTPDownSetVisual = nil
    infJumpEnabled = false
    infJumpMode = "HOLD"
    bodyLockEnabled = false
    bodyLockRange = 20
    bodyLockRangeBox = nil
    _bodyLockConn = nil
    _blSuppressCount = 0
    _blWasEnabled = false
    _blRestoreTimer = nil
    _blSmoothRestore = false
    savedProgressBarPos = nil
    savedProgressBarLocked = false
    savedButtonPositions = {}
    savedMobilePanelPos = nil
    tpBatFloatingPos = nil
    batV2FloatingPos = nil
    instaResetFloatingPos = nil
    instaResetFloatingButton = nil
    neonWeatherEnabled = false
    skyTheme = "Off"
    specialSkyMode = "Off"
    customSkyPreset = "Reze"
    customSkyEnabled = false
    mikuSkyEnabled = false
    mikuSkyObject = nil
    mikuSkyThread = nil
    mikuStoredSkies = {}
    customSkyOriginalState = nil
    customSkyOriginalObjects = {}
    customSkyInstance = nil
    customSkyFloorPart = nil
    skySelectorLabel = nil
    _originalLighting = nil
    setNeonWeatherVisual = nil
    currentAnimPack = "Off"
    originalTryardAnims = nil
    tryardHeartbeatConn = nil
    animSelectorLabel = nil
    autoBatV2Enabled = false
    autoBatV2SetVisual = nil
    selectedAimbotMode = "Normal"
    autoSwingEnabled = false
    _G.AceAntiBypassAimbotSpeed = _G.AceAntiBypassAimbotSpeed or 60
    _G.AceAntiBypassLaggerAimbotSpeed = _G.AceAntiBypassLaggerAimbotSpeed or 40
    _G.AceAntiBypassAimbotOn = _G.AceAntiBypassAimbotOn or false
    _G.AceNormalAimbotOn = _G.AceNormalAimbotOn or false
    _G.AceCurrentSpeedMode = _G.AceCurrentSpeedMode or "Normal"
    _G.AceAntiBypassAimbot = _G.AceAntiBypassAimbot or {
        conn = nil,
        swingCooldown = false,
        prevAutoRotate = nil,
    }
    _G.AceAntiBypassSlapList = _G.AceAntiBypassSlapList
        or {
            "Bat",
            "Slap",
            "Iron Slap",
            "Gold Slap",
            "Diamond Slap",
            "Emerald Slap",
            "Ruby Slap",
            "Dark Matter Slap",
            "Flame Slap",
            "Nuclear Slap",
            "Galaxy Slap",
            "Glitched Slap",
        }
    _G.AceSafeModeTryStart = _G.AceSafeModeTryStart or _G.AmbitiousSafeModeTryStart
    _G.AceStopAutoTPForAction = _G.AceStopAutoTPForAction
        or function()
            if batDesyncTpEnabled and type(stopBatDesyncTp) == "function" then
                stopBatDesyncTp()
            end
        end
    _G.AceStopNormalAimbot = _G.AceStopNormalAimbot
        or function()
            local wasAutoBatEnabled = autoBatEnabled
            if wasAutoBatEnabled then
                wasAutoBatEnabled = type(disableAutoBat) == "function"
            end
            if wasAutoBatEnabled then
                disableAutoBat()
            end
        end
    useCarrySystem = false
    lastMoveDir = zeroVector
    tpBatVersion = 1
    tpBatVersionLabel = nil
    tpBatVersionPill = nil
    tpBatDistanceBox = nil
    _G.__tpBatV2Distance = 8
    game:GetService("CoreGui")
    customTool3DAssets = {
        DiamondSword = {
            cat = "Bat", label = "Diamond Sword",
            mesh = "rbxassetid://8827558932", tex = "rbxassetid://8827558969",
            scale = Vector3.new(0.2, 0.2, 0.2),
            c0 = CFrame.new(-0.05, -0.1, -0.12) * CFrame.Angles(math.rad(90), math.rad(180), math.rad(300)),
            view = 4.9,
        },
        Katana = {
            cat = "Bat", label = "Katana",
            mesh = "rbxassetid://13528902482", tex = "rbxassetid://13528902373",
            scale = Vector3.new(1.4, 1.4, 1.4),
            c0 = CFrame.new(0, 0.6, 0) * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180)),
            view = 6.6,
        },
        Skull = {
            cat = "Medusa", label = "Skull",
            mesh = "rbxassetid://2050312704", tex = "rbxassetid://2050313393",
            scale = Vector3.new(1, 1, 1),
            c0 = CFrame.new(0, 0.65, -0.4) * CFrame.Angles(math.rad(330), 0, 0),
            view = 4.2,
        },
        GoldenDesertEagle = {
            cat = "Medusa", label = "Golden Desert Eagle",
            mesh = "rbxassetid://430251413", tex = "rbxassetid://435840335",
            scale = Vector3.new(0.01, 0.01, 0.01),
            c0 = CFrame.new(0, 0, -0.8) * CFrame.Angles(math.rad(330), math.rad(180), 0),
            view = 3.0,
        },
    }
    bat3DSkinEnabled = false
    medusa3DSkinEnabled = false
    customBat3DSkin = "DiamondSword"
    customMedusa3DSkin = "GoldenDesertEagle"
    customTool3DSkinCards = {}
    local originalToolAppearance = setmetatable({}, {__mode = "k"})

    local function getCustomToolCategory(tool)
        if not tool or not tool:IsA("Tool") then
            return nil
        end
        local name = tool.Name:lower()
        if name:find("bat") or name:find("slap") then
            return "Bat"
        end
        if name:find("medusa") or name:find("head") or name:find("stone") then
            return "Medusa"
        end
        return nil
    end

    local function saveOriginalToolAppearance(handle)
        if not handle or originalToolAppearance[handle] then
            return
        end
        local snapshot = {handleTransparency = handle.Transparency, properties = {}}
        for _, object in ipairs(handle:GetDescendants()) do
            if object.Name ~= "RevHub3DReplica" then
                if object:IsA("BasePart") or object:IsA("Decal") then
                    table.insert(snapshot.properties, {object = object, property = "Transparency", value = object.Transparency})
                elseif object:IsA("SpecialMesh") or object:IsA("BlockMesh") or object:IsA("CylinderMesh") then
                    table.insert(snapshot.properties, {object = object, property = "Scale", value = object.Scale})
                end
            end
        end
        originalToolAppearance[handle] = snapshot
    end

    local function restoreCustomToolAppearance(handle)
        if not handle then
            return
        end
        local replica = handle:FindFirstChild("RevHub3DReplica")
        if replica then
            pcall(function() replica:Destroy() end)
        end
        local snapshot = originalToolAppearance[handle]
        if not snapshot then
            return
        end
        pcall(function() handle.Transparency = snapshot.handleTransparency end)
        for _, entry in ipairs(snapshot.properties) do
            if entry.object and entry.object.Parent then
                pcall(function() entry.object[entry.property] = entry.value end)
            end
        end
        originalToolAppearance[handle] = nil
    end

    local function applyCustomTool3DSkin(handle, category, skinKey)
        local data = customTool3DAssets[skinKey]
        if not handle or not data or data.cat ~= category then
            return
        end
        local existing = handle:FindFirstChild("RevHub3DReplica")
        if existing and existing:GetAttribute("SkinKey") == skinKey then
            return
        end
        if existing then
            pcall(function() existing:Destroy() end)
        end
        saveOriginalToolAppearance(handle)
        pcall(function()
            handle.Transparency = 1
            for _, object in ipairs(handle:GetDescendants()) do
                if object.Name ~= "RevHub3DReplica" then
                    if object:IsA("BasePart") or object:IsA("Decal") then
                        object.Transparency = 1
                    elseif object:IsA("SpecialMesh") or object:IsA("BlockMesh") or object:IsA("CylinderMesh") then
                        object.Scale = Vector3.zero
                    end
                end
            end
        end)
        local replica = Instance.new("Part")
        replica.Name = "RevHub3DReplica"
        replica.Size = Vector3.new(1, 1, 1)
        replica.Anchored = false
        replica.CanCollide = false
        replica.CanQuery = false
        replica.CanTouch = false
        replica.Massless = true
        replica.Transparency = 0
        replica:SetAttribute("SkinKey", skinKey)
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = data.mesh
        mesh.TextureId = data.tex or ""
        mesh.Scale = data.scale
        mesh.Parent = replica
        replica.CFrame = handle.CFrame * (data.c0 or CFrame.new())
        replica.Parent = handle
        local weld = Instance.new("Weld")
        weld.Part0 = handle
        weld.Part1 = replica
        weld.C0 = data.c0 or CFrame.new()
        weld.Parent = replica
    end

    refreshCustomTool3DSkins = function()
        local roots = {}
        if localPlayer.Character then
            table.insert(roots, localPlayer.Character)
        end
        local backpack = localPlayer:FindFirstChildOfClass("Backpack")
        if backpack then
            table.insert(roots, backpack)
        end
        for _, root in ipairs(roots) do
            if root then
                for _, tool in ipairs(root:GetChildren()) do
                    local category = getCustomToolCategory(tool)
                    if category then
                        local enabled
                        local skinKey
                        if category == "Bat" then
                            enabled = bat3DSkinEnabled
                            skinKey = customBat3DSkin
                        else
                            enabled = medusa3DSkinEnabled
                            skinKey = customMedusa3DSkin
                        end
                        local handle = tool:FindFirstChild("Handle")
                        if handle and handle:IsA("BasePart") then
                            if enabled then
                                applyCustomTool3DSkin(handle, category, skinKey)
                            else
                                restoreCustomToolAppearance(handle)
                            end
                        end
                    end
                end
            end
        end
    end

    task.spawn(function()
        while true do
            task.wait(0.65)
            if bat3DSkinEnabled or medusa3DSkinEnabled then
                pcall(refreshCustomTool3DSkins)
            end
        end
    end)
-- CUSTOM SONG (debajo de Medusa 3D)
-- ############################################################
-- ##                    CUSTOM SOUNDS                       ##
-- ##   Bat -> katana slash      Medusa -> gunshot           ##
-- ##   Indipendente da Custom Tools: funziona anche da solo ##
-- ############################################################
do
    local function customSongMatch(inst)
        if not inst or not inst:IsA("Tool") then return nil end
        local name = tostring(inst.Name or ""):lower()
        if name:find("medusa", 1, true) then
            return {key = "Medusa"}
        end
        if name:find("bat", 1, true) or name:find("slap", 1, true) then
            return {key = "Bat"}
        end
        return nil
    end
    local SOUNDS = {
        Bat    = { id = "rbxassetid://5713085119", skip = 0.2 },
        Medusa = { id = "rbxassetid://3102797479", doublePlay = true, delay = 0.5 },
    }

    -- Un Sound puo' essere agganciato UNA volta sola: senza questo le
    -- connessioni si accumulavano a ogni re-equip (memory leak).
    local hooked = setmetatable({}, { __mode = "k" })

    local enabled       = false
    local tracked       = setmetatable({}, { __mode = "k" })  -- [tool] = { sound, data, conns, muted }
    local watchers      = setmetatable({}, { __mode = "k" })
    local pendingHandle = setmetatable({}, { __mode = "k" })
    local teardown

    local function playCustom(entry)
        local cs = entry.sound
        if not cs or not cs.Parent then return end
        local d = entry.data

        -- cancella un eventuale secondo colpo ancora in coda
        if entry.timer then
            pcall(task.cancel, entry.timer)
            entry.timer = nil
        end

        pcall(function()
            cs:Stop()
            cs.TimePosition = d.skip or 0
            cs.Volume = 1
            cs:Play()
        end)

        if d.doublePlay and d.delay then
            entry.timer = task.delay(d.delay, function()
                entry.timer = nil
                if not enabled then return end
                if cs and cs.Parent then
                    pcall(function()
                        cs:Stop()
                        cs.TimePosition = d.skip or 0
                        cs.Volume = 1
                        cs:Play()
                    end)
                end
            end)
        end
    end

    -- Silenzia il suono originale e fa partire quello custom
    local function hookSound(entry, snd)
        if not snd:IsA("Sound") then return end
        if snd.Name == "CustomSound" then return end
        if hooked[snd] then return end          -- gia' agganciato: niente doppioni
        if entry.muted[snd] ~= nil then return end

        entry.muted[snd] = snd.Volume
        hooked[snd] = true

        local function trigger()
            if not enabled then return end
            if snd.Playing or snd.TimePosition > 0 then
                pcall(function()
                    snd.Volume = 0
                    snd:Stop()
                end)
                playCustom(entry)
            end
        end

        local c1 = snd:GetPropertyChangedSignal("Playing"):Connect(trigger)
        local c2 = snd:GetPropertyChangedSignal("TimePosition"):Connect(trigger)
        table.insert(entry.conns, c1)
        table.insert(entry.conns, c2)

        -- il Sound viene distrutto: si liberano subito le connessioni
        local c3
        c3 = snd.AncestryChanged:Connect(function(_, parent)
            if parent then return end
            pcall(function() c1:Disconnect() end)
            pcall(function() c2:Disconnect() end)
            pcall(function() c3:Disconnect() end)
            hooked[snd] = nil
            entry.muted[snd] = nil
            if entry.timer then
                pcall(task.cancel, entry.timer)
                entry.timer = nil
            end
        end)
        table.insert(entry.conns, c3)

        if snd.Playing then trigger() end
    end

    local function setupTool(tool)
        if tracked[tool] then return end

        local item = customSongMatch(tool)
        if not item then return end
        local data = SOUNDS[item.key]
        if not data then return end

        local handle = tool:FindFirstChild("Handle")
        if not handle then
            if pendingHandle[tool] then return end
            local c
            c = tool.ChildAdded:Connect(function(child)
                if child.Name == "Handle" then
                    pcall(function() c:Disconnect() end)
                    pendingHandle[tool] = nil
                    if enabled then setupTool(tool) end
                end
            end)
            pendingHandle[tool] = c
            return
        end

        local old = handle:FindFirstChild("CustomSound")
        if old then pcall(function() old:Destroy() end) end

        local cs = Instance.new("Sound")
        cs.Name        = "CustomSound"
        cs.SoundId     = data.id
        cs.Volume      = 1
        cs.Looped      = false
        cs.RollOffMode = Enum.RollOffMode.Inverse
        cs.MaxDistance = 1000
        cs.MinDistance = 1000
        cs.Parent      = handle

        local entry = { sound = cs, data = data, conns = {}, muted = {} }
        tracked[tool] = entry

        for _, d in ipairs(tool:GetDescendants()) do hookSound(entry, d) end

        table.insert(entry.conns, tool.DescendantAdded:Connect(function(d)
            if tracked[tool] then hookSound(entry, d) end
        end))
        table.insert(entry.conns, tool.AncestryChanged:Connect(function(_, parent)
            if not parent then teardown(tool) end
        end))
    end

    function teardown(tool)
        local entry = tracked[tool]
        if not entry then return end
        if entry.timer then
            pcall(task.cancel, entry.timer)
            entry.timer = nil
        end
        for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end
        if entry.sound then pcall(function() entry.sound:Destroy() end) end
        for snd, vol in pairs(entry.muted) do
            hooked[snd] = nil
            if snd and snd.Parent then pcall(function() snd.Volume = vol end) end
        end
        tracked[tool] = nil
    end

    local function tryRegister(inst)
        if not enabled then return end
        if inst:IsA("Tool") and customSongMatch(inst) then setupTool(inst) end
    end

    local function unwatch(container)
        local conns = watchers[container]
        if not conns then return end
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        watchers[container] = nil
    end

    local function watch(container)
        if not container or watchers[container] then return end
        watchers[container] = { container.ChildAdded:Connect(tryRegister) }
        for _, child in ipairs(container:GetChildren()) do tryRegister(child) end
    end

    local function watchAll()
        watch(localPlayer:FindFirstChildOfClass("Backpack"))
        watch(localPlayer.Character)
    end

    localPlayer.ChildAdded:Connect(function(child)
        if enabled and child:IsA("Backpack") then watch(child) end
    end)

    localPlayer.CharacterAdded:Connect(function(char)
        for tool in pairs(tracked) do teardown(tool) end
        for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
        table.clear(pendingHandle)
        for container in pairs(watchers) do unwatch(container) end
        if not enabled then return end
        watch(char)
        task.defer(function()
            if enabled then watchAll() end
        end)
    end)


    _G.AmbitiousCustomSounds = {
        setEnabled = function(on)
            on = on and true or false
            enabled = on
            _G.AmbitiousCustomSoundsEnabled = on
            if on then
                watchAll()
            else
                for tool in pairs(tracked) do teardown(tool) end
                for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
                table.clear(pendingHandle)
                for container in pairs(watchers) do unwatch(container) end
            end
        end,
        isEnabled = function() return enabled end,
    }
end

-- RAINBOW TOOLS (debajo de Custom Song)
do
--============================================================
-- RAINBOW TOOLS - Standalone
-- Pinta Bat/Slap Bat/Medusa con efecto arcoíris animado
--============================================================
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP         = Players.LocalPlayer

--============================================================
-- CT_Trans: gestor de transparencias compartido
-- (necesario para no chocar con otros módulos)
--============================================================
local CT_Trans = {}
do
    local PRIORITY = { "custom", "rainbow", "transparent" }
    local baseline = setmetatable({}, { __mode = "k" })
    local claims   = setmetatable({}, { __mode = "k" })
    local guards   = setmetatable({}, { __mode = "k" })

    function CT_Trans.getBaseline(part)
        local b = baseline[part]
        if b ~= nil then return b end
        local ok, val = pcall(function() return part.Transparency end)
        if not ok then return nil end
        baseline[part] = val
        return val
    end

    local function wantedValue(part)
        local c = claims[part]
        if not c then return nil end
        for _, who in ipairs(PRIORITY) do
            if c[who] ~= nil then return c[who] end
        end
        return nil
    end

    local function setIfDifferent(part, v)
        local ok, cur = pcall(function() return part.Transparency end)
        if ok and cur ~= nil and math.abs(cur - v) <= 0.001 then return end
        pcall(function() part.Transparency = v end)
    end

    local function resolve(part)
        local v = wantedValue(part)
        if v ~= nil then
            setIfDifferent(part, v)
            return
        end
        local b = baseline[part]
        if b ~= nil then setIfDifferent(part, b) end
    end

    local function armGuard(part)
        if guards[part] then return end
        local ok, conn = pcall(function()
            return part:GetPropertyChangedSignal("Transparency"):Connect(function()
                local v = wantedValue(part)
                if v == nil then return end
                local ok2, cur = pcall(function() return part.Transparency end)
                if ok2 and cur ~= nil and math.abs(cur - v) > 0.001 then
                    pcall(function() part.Transparency = v end)
                end
            end)
        end)
        if ok and conn then guards[part] = conn end
    end

    local function disarmGuard(part)
        local conn = guards[part]
        if conn then
            pcall(function() conn:Disconnect() end)
            guards[part] = nil
        end
    end

    function CT_Trans.claim(part, who, value)
        if not part then return end
        if CT_Trans.getBaseline(part) == nil then return end
        local c = claims[part]
        if not c then c = {}; claims[part] = c end
        c[who] = value
        armGuard(part)
        resolve(part)
    end

    function CT_Trans.release(part, who)
        if not part then return end
        local c = claims[part]
        if not c then return end
        c[who] = nil
        if next(c) == nil then
            claims[part] = nil
            disarmGuard(part)
        end
        if part.Parent then resolve(part) end
    end
end

--============================================================
-- MATCHER de items
--============================================================
local CT_ITEMS = {
    { key = "Bat",    match = function(n) n = n:lower() return n:find("bat") ~= nil or n:find("slap") ~= nil end },
    { key = "Medusa", match = function(n) return n:lower():find("medusa") ~= nil end },
}

local function ctMatchItem(inst)
    if not (inst:IsA("Tool") or inst:IsA("Model") or inst:IsA("Accessory") or inst:IsA("BasePart")) then
        return nil
    end
    for _, item in ipairs(CT_ITEMS) do
        if item.match(inst.Name) then return item end
    end
    return nil
end

--============================================================
-- RAINBOW TOOLS
--============================================================
local SPEED       = 0.35
local SPREAD      = 0.035
local UPDATE_STEP = 1 / 40

local enabled  = false
local tracked  = setmetatable({}, { __mode = "k" })
local watchers = setmetatable({}, { __mode = "k" })
local unregister

local function classify(d)
    if d:IsA("MeshPart") then
        return { obj = d, kind = "part", props = { "Color", "Material", "TextureID" }, clearTexture = "TextureID" }
    elseif d:IsA("BasePart") then
        return { obj = d, kind = "part", props = { "Color", "Material" } }
    elseif d:IsA("SurfaceAppearance") then
        return { obj = d, kind = "surface", props = { "Parent" } }
    elseif d:IsA("Decal") or d:IsA("Texture") then
        return { obj = d, kind = "decal", props = {} }
    elseif d:IsA("SpecialMesh") then
        return { obj = d, kind = "vector", prop = "VertexColor", props = { "VertexColor", "TextureId" }, clearTexture = "TextureId" }
    elseif d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then
        return { obj = d, kind = "sequence", prop = "Color", props = { "Color" } }
    elseif d:IsA("PointLight") or d:IsA("SpotLight") or d:IsA("SurfaceLight") then
        return { obj = d, kind = "color", prop = "Color", props = { "Color" } }
    elseif d:IsA("Highlight") then
        return { obj = d, kind = "color", prop = "FillColor", props = { "FillColor" } }
    end
    return nil
end

local function snapshot(node)
    node.original = {}
    for _, prop in ipairs(node.props) do
        local ok, val = pcall(function() return node.obj[prop] end)
        if ok then node.original[prop] = val end
    end
end

local function restoreNode(node)
    if node.kind == "decal" then CT_Trans.release(node.obj, "rainbow") end
    if not node.original then return end
    for prop, val in pairs(node.original) do
        pcall(function() node.obj[prop] = val end)
    end
end

local function applyOnce(node)
    if node.kind == "surface" then
        pcall(function() node.obj.Parent = nil end)
    elseif node.kind == "decal" then
        CT_Trans.claim(node.obj, "rainbow", 1)
    elseif node.clearTexture then
        pcall(function() node.obj[node.clearTexture] = "" end)
    end
end

local function addNode(entry, d)
    local node = classify(d)
    if not node then return end
    snapshot(node)
    applyOnce(node)
    if node.kind == "part" then
        table.insert(entry.parts, node)
    elseif node.kind == "surface" or node.kind == "decal" then
        table.insert(entry.statics, node)
    else
        table.insert(entry.effects, node)
    end
end

local function register(root)
    if tracked[root] then return end
    local entry = { parts = {}, effects = {}, statics = {}, conns = {} }
    tracked[root] = entry

    for _, d in ipairs(root:GetDescendants()) do addNode(entry, d) end
    if root:IsA("BasePart") then addNode(entry, root) end

    table.insert(entry.conns, root.DescendantAdded:Connect(function(d)
        addNode(entry, d)
    end))
    table.insert(entry.conns, root.AncestryChanged:Connect(function(_, parent)
        if not parent then unregister(root, false) end
    end))
end

function unregister(root, doRestore)
    local entry = tracked[root]
    if not entry then return end
    for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end
    if doRestore then
        for _, node in ipairs(entry.parts)   do restoreNode(node) end
        for _, node in ipairs(entry.effects) do restoreNode(node) end
        for _, node in ipairs(entry.statics) do restoreNode(node) end
    end
    tracked[root] = nil
end

local function tryRegister(inst)
    if not enabled then return end
    if ctMatchItem(inst) then register(inst) end
end

local function unwatch(container)
    local conns = watchers[container]
    if not conns then return end
    for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    watchers[container] = nil
end

local function watch(container)
    if not container or watchers[container] then return end
    watchers[container] = { container.ChildAdded:Connect(tryRegister) }
    for _, child in ipairs(container:GetChildren()) do tryRegister(child) end
end

local function watchAll()
    watch(LP:FindFirstChildOfClass("Backpack"))
    watch(LP.Character)
end

LP.ChildAdded:Connect(function(child)
    if enabled and child:IsA("Backpack") then watch(child) end
end)

LP.CharacterAdded:Connect(function(char)
    for root in pairs(tracked) do unregister(root, false) end
    for container in pairs(watchers) do unwatch(container) end
    if not enabled then return end
    watch(char)
    task.defer(function()
        if enabled then watchAll() end
    end)
end)

local acc = 0
RunService.Heartbeat:Connect(function(dt)
    if not enabled then return end
    if next(tracked) == nil then return end
    acc = acc + dt
    if acc < UPDATE_STEP then return end
    acc = 0

    local baseHue = (tick() * SPEED) % 1

    for _, entry in pairs(tracked) do
        for i, node in ipairs(entry.parts) do
            local part = node.obj
            if part.Parent then
                pcall(function()
                    part.Color = Color3.fromHSV((baseHue + (i - 1) * SPREAD) % 1, 1, 1)
                end)
            end
        end
        for i, node in ipairs(entry.effects) do
            if node.obj.Parent then
                local col = Color3.fromHSV((baseHue + (i - 1) * SPREAD) % 1, 1, 1)
                if node.kind == "sequence" then
                    pcall(function() node.obj[node.prop] = ColorSequence.new(col) end)
                elseif node.kind == "vector" then
                    pcall(function() node.obj[node.prop] = Vector3.new(col.R, col.G, col.B) end)
                else
                    pcall(function() node.obj[node.prop] = col end)
                end
            end
        end
    end
end)

--============================================================
-- API pública
--============================================================
_G.AmbitiousRainbowTools = {
    setEnabled = function(on)
        on = on and true or false
        enabled = on
        _G.AmbitiousRainbowToolsEnabled = on
        if on then
            watchAll()
        else
            for root in pairs(tracked) do unregister(root, true) end
            for container in pairs(watchers) do unwatch(container) end
        end
    end,
    isEnabled = function() return enabled end,
}
print("[Rainbow Tools] Listo")
end
    _G.AmbitiousNormalInfJump = _G.AmbitiousNormalInfJump
        or {
            holdPressed = false,
            holdActive = false,
            controllerActive = false,
            mobilePressed = false,
            mobileActive = false,
            hooked = {},
        }
    _G._jumpEnsureProxy = function()
        local character = localPlayer.Character
        if not character then
            return nil
        end
        return character:FindFirstChild("HumanoidRootPart")
    end
    _G.AmbitiousApplyNormalInfJumpBoost = function(value)
        if not infJumpEnabled then
            return
        end
        local character = localPlayer.Character
        if not character then
            return
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            return
        end
        local rootPart = _G._jumpEnsureProxy()
        if not rootPart then
            return
        end
        local velocity = rootPart.Velocity
        rootPart.Velocity = newVector3(velocity.X, value or 50, velocity.Z)
    end
    _G.AmbitiousStopNormalInfJumpHoldState = function()
        local ambitiousNormalInfJump = _G.AmbitiousNormalInfJump
        ambitiousNormalInfJump.holdPressed = false
        ambitiousNormalInfJump.holdActive = false
        ambitiousNormalInfJump.controllerActive = false
        ambitiousNormalInfJump.mobilePressed = false
        ambitiousNormalInfJump.mobileActive = false
    end
    UserInputService.JumpRequest:Connect(function()
        _G.AmbitiousApplyNormalInfJumpBoost(50)
    end)
    UserInputService.InputBegan:Connect(function(input)
        if UserInputService:GetFocusedTextBox() then
            return
        end
        local ambitiousNormalInfJump = _G.AmbitiousNormalInfJump
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
            if infJumpMode == "MANUAL" then
                return
            end
            ambitiousNormalInfJump.holdPressed = true
            task.delay(0.12, function()
                if _G.AmbitiousNormalInfJump.holdPressed and infJumpEnabled then
                    _G.AmbitiousNormalInfJump.holdActive = true
                    _G.AmbitiousApplyNormalInfJumpBoost(50)
                end
            end)
        elseif input.KeyCode == Enum.KeyCode.ButtonA and input.UserInputType.Name:match("^Gamepad") then
            if infJumpMode ~= "MANUAL" then
                ambitiousNormalInfJump.controllerActive = true
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        local ambitiousNormalInfJump = _G.AmbitiousNormalInfJump
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
            ambitiousNormalInfJump.holdPressed = false
            ambitiousNormalInfJump.holdActive = false
        end
        if input.KeyCode == Enum.KeyCode.ButtonA and input.UserInputType.Name:match("^Gamepad") then
            ambitiousNormalInfJump.controllerActive = false
        end
    end)
    _G.AmbitiousHookNormalInfMobileJumpButton = function(callback)
        local ambitiousNormalInfJump = _G.AmbitiousNormalInfJump
        if
            not callback
            or callback.Name ~= "JumpButton"
            or not callback:IsA("GuiButton")
            or ambitiousNormalInfJump.hooked[callback]
        then
            return
        end
        ambitiousNormalInfJump.hooked[callback] = true
        callback.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Touch or not infJumpEnabled then
                return
            end
            if infJumpMode == "MANUAL" then
                return
            end
            ambitiousNormalInfJump.mobilePressed = true
            task.delay(0.12, function()
                if ambitiousNormalInfJump.mobilePressed and infJumpEnabled then
                    ambitiousNormalInfJump.mobileActive = true
                    _G.AmbitiousApplyNormalInfJumpBoost(50)
                end
            end)
        end)
        callback.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                ambitiousNormalInfJump.mobilePressed = false
                ambitiousNormalInfJump.mobileActive = false
            end
        end)
    end
    do
        local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
        if playerGui then
            for _, descendant in ipairs(playerGui:GetDescendants()) do
                _G.AmbitiousHookNormalInfMobileJumpButton(descendant)
            end
            playerGui.DescendantAdded:Connect(function(descendant)
                task.defer(_G.AmbitiousHookNormalInfMobileJumpButton, descendant)
            end)
        end
    end
    RunService.Heartbeat:Connect(function()
        local ambitiousNormalInfJump = _G.AmbitiousNormalInfJump
        local isActive = infJumpEnabled and infJumpMode == "HOLD"
        if isActive then
            isActive = ambitiousNormalInfJump.holdActive
                or ambitiousNormalInfJump.mobileActive
                or ambitiousNormalInfJump.controllerActive
        end
        if isActive then
            _G.AmbitiousApplyNormalInfJumpBoost(50)
        end
    end)
    _G.setInfJumpInternal = function(value)
        infJumpEnabled = value and true or false
        if not infJumpEnabled then
            _G.AmbitiousStopNormalInfJumpHoldState()
            local character = localPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                pcall(function()
                    humanoidRootPart.Velocity = zeroVector
                end)
            end
        end
    end
    InfiniteJump = {
        start = function()
            _G.setInfJumpInternal(true)
        end,
        stop = function()
            _G.setInfJumpInternal(false)
        end,
        isRunning = function()
            return infJumpEnabled == true
        end,
        setJumpPower = function() end,
    }
    getActiveMoveSpeed = function()
        if laggerCarryToggled then
            return LAGGER_CARRY_SPEED
        end
        if laggerToggled then
            return LAGGER_SPEED
        end
        if speedMode then
            return CS
        end
        return NS
    end
    do
        local data = {}
        velocityHookedRoots = {}
        registerVelocityRoot = function(character)
            data = {}
            if not character then
                return
            end
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
            if humanoidRootPart then
                data[humanoidRootPart] = true
            end
            return humanoidRootPart
        end
        local isActive = nil
        installVelocityReadHook = function(humanoidRootPart)
            if not humanoidRootPart or velocityHookedRoots[humanoidRootPart] then
                return
            end
            if isActive == false then
                return
            end
            if isActive == nil then
                isActive = type(getrawmetatable) == "function"
                    and type(setreadonly) == "function"
                    and type(newcclosure) == "function"
                    and type(checkcaller) == "function"
            end
            if not isActive then
                return
            end
            velocityHookedRoots[humanoidRootPart] = true
            if
                not pcall(function()
                    local mt = getrawmetatable(humanoidRootPart)
                    if not mt then
                        return
                    end
                    setreadonly(mt, false)
                    local value = rawget(mt, "__index")
                    mt.__index = newcclosure(function(self, key)
                        if
                            not checkcaller()
                            and data[self]
                            and (key == "AssemblyLinearVelocity" or key == "Velocity")
                        then
                            local real
                            if type(value) == "function" then
                                real = value(self, key)
                            else
                                real = nil
                                if type(value) == "table" then
                                    real = value[key]
                                end
                            end
                            if real and real.Magnitude > 20 then
                                return real.Unit * 20
                            end
                            return real
                        end
                        if type(value) == "function" then
                            return value(self, key)
                        end
                        if type(value) == "table" then
                            return value[key]
                        end
                    end)
                    setreadonly(mt, true)
                end)
            then
                isActive = false
            end
        end
    end
    do
        local saveOriginalAnimations
        if localPlayer.Character then
            local object = registerVelocityRoot(localPlayer.Character)
            installVelocityReadHook(object)
        end
        isHumanoidRagdolled = function(humanoid)
            if not humanoid then
                return true
            end
            local state = humanoid:GetState()
            return humanoid.PlatformStand
                or state == Enum.HumanoidStateType.Physics
                or state == Enum.HumanoidStateType.Ragdoll
                or state == Enum.HumanoidStateType.FallingDown
        end
        applyMovementVelocity = function(direction, speed, humanoidRootPart)
            if not humanoidRootPart or not humanoidRootPart.Parent then
                return
            end
            if autoBatV2Enabled or batDesyncTpEnabled or autoBatEnabled then
                return
            end
            if direction and direction.Magnitude > 0.05 then
                pcall(function()
                    if humanoidRootPart.SetNetworkOwner then
                        humanoidRootPart:SetNetworkOwner(localPlayer)
                    end
                end)
                local unit = direction.Unit
                humanoidRootPart.AssemblyLinearVelocity =
                    newVector3(unit.X * speed, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * speed)
            else
                humanoidRootPart.AssemblyLinearVelocity = newVector3(0, humanoidRootPart.AssemblyLinearVelocity.Y, 0)
            end
        end
        getAutoPathSpeed = function()
            if laggerCarryToggled or laggerToggled then
                return LAGGER_SPEED
            end
            return NS
        end
        ANIM_PACKS = {
            Zombie = {
                idle1 = "rbxassetid://616158929",
                idle2 = "rbxassetid://616160636",
                walk = "rbxassetid://616168032",
                run = "rbxassetid://616163682",
                jump = "rbxassetid://616161997",
                fall = "rbxassetid://616157476",
                climb = "rbxassetid://616156119",
                swim = "rbxassetid://616165109",
                swimidle = "rbxassetid://616166655",
            },
            Ninja = {
                idle1 = "rbxassetid://656117400",
                idle2 = "rbxassetid://656117400",
                walk = "rbxassetid://656121766",
                run = "rbxassetid://656118852",
                jump = "rbxassetid://656117878",
                fall = "rbxassetid://656115606",
                climb = "rbxassetid://656114359",
                swim = "rbxassetid://656117400",
                swimidle = "rbxassetid://656117400",
            },
            Knight = {
                idle1 = "rbxassetid://657595757",
                idle2 = "rbxassetid://657595757",
                walk = "rbxassetid://657552124",
                run = "rbxassetid://657564596",
                jump = "rbxassetid://658409194",
                fall = "rbxassetid://657600338",
                climb = "rbxassetid://658360781",
                swim = "rbxassetid://657595757",
                swimidle = "rbxassetid://657595757",
            },
            Elder = {
                idle1 = "rbxassetid://845397899",
                idle2 = "rbxassetid://845397899",
                walk = "rbxassetid://845403856",
                run = "rbxassetid://845386501",
                jump = "rbxassetid://845398858",
                fall = "rbxassetid://845397673",
                climb = "rbxassetid://845392038",
                swim = "rbxassetid://845397899",
                swimidle = "rbxassetid://845397899",
            },
            ["Levitate"] = {
                idle1 = "rbxassetid://616006778",
                idle2 = "rbxassetid://616006778",
                walk = "rbxassetid://616013216",
                run = "rbxassetid://616013216",
                jump = "rbxassetid://616008936",
                fall = "rbxassetid://616005863",
                climb = "rbxassetid://616003713",
                swim = "rbxassetid://616006778",
                swimidle = "rbxassetid://616006778",
            },
            Astronaut = {
                idle1 = "rbxassetid://891621366",
                idle2 = "rbxassetid://891621366",
                walk = "rbxassetid://891636393",
                run = "rbxassetid://891636393",
                jump = "rbxassetid://891627522",
                fall = "rbxassetid://891617961",
                climb = "rbxassetid://891609353",
                swim = "rbxassetid://891621366",
                swimidle = "rbxassetid://891621366",
            },
            Pirate = {
                idle1 = "rbxassetid://750781874",
                idle2 = "rbxassetid://750781874",
                walk = "rbxassetid://750785693",
                run = "rbxassetid://750783738",
                jump = "rbxassetid://750782230",
                fall = "rbxassetid://750780242",
                climb = "rbxassetid://750779899",
                swim = "rbxassetid://750781874",
                swimidle = "rbxassetid://750781874",
            },
            Toy = {
                idle1 = "rbxassetid://782841498",
                idle2 = "rbxassetid://782841498",
                walk = "rbxassetid://782843345",
                run = "rbxassetid://782842708",
                jump = "rbxassetid://782847020",
                fall = "rbxassetid://782846423",
                climb = "rbxassetid://782843869",
                swim = "rbxassetid://782841498",
                swimidle = "rbxassetid://782841498",
            },
            Vampire = {
                idle1 = "rbxassetid://1083445855",
                idle2 = "rbxassetid://1083445855",
                walk = "rbxassetid://1083473930",
                run = "rbxassetid://1083462077",
                jump = "rbxassetid://1083455352",
                fall = "rbxassetid://1083443587",
                climb = "rbxassetid://1083439238",
                swim = "rbxassetid://1083445855",
                swimidle = "rbxassetid://1083445855",
            },
            Werewolf = {
                idle1 = "rbxassetid://1083195517",
                idle2 = "rbxassetid://1083195517",
                walk = "rbxassetid://1083178339",
                run = "rbxassetid://1083216690",
                jump = "rbxassetid://1083218792",
                fall = "rbxassetid://1083189019",
                climb = "rbxassetid://1083182000",
                swim = "rbxassetid://1083195517",
                swimidle = "rbxassetid://1083195517",
            },
            Rthro = {
                idle1 = "rbxassetid://2510196951",
                idle2 = "rbxassetid://2510196951",
                walk = "rbxassetid://2510202577",
                run = "rbxassetid://2510198475",
                jump = "rbxassetid://2510197830",
                fall = "rbxassetid://2510195892",
                climb = "rbxassetid://2510192778",
                swim = "rbxassetid://2510196951",
                swimidle = "rbxassetid://2510196951",
            },
            Stylish = {
                idle1 = "rbxassetid://616136790",
                idle2 = "rbxassetid://616136790",
                walk = "rbxassetid://616146177",
                run = "rbxassetid://616140816",
                jump = "rbxassetid://616139451",
                fall = "rbxassetid://616134815",
                climb = "rbxassetid://616133594",
                swim = "rbxassetid://616136790",
                swimidle = "rbxassetid://616136790",
            },
        }
        ANIM_PACK_ORDER = {
            {
                "Off",
                "Off",
            },
            {
                "Zombie",
                "Zombie",
            },
            {
                "Ninja",
                "Ninja",
            },
            {
                "Knight",
                "Knight",
            },
            {
                "Elder",
                "Elder",
            },
            {
                "Levitate",
                "Levitate",
            },
            {
                "Astronaut",
                "Astronaut",
            },
            {
                "Pirate",
                "Pirate",
            },
            {
                "Toy",
                "Toy",
            },
            {
                "Vampire",
                "Vampire",
            },
            {
                "Werewolf",
                "Werewolf",
            },
            {
                "Rthro",
                "Rthro",
            },
            {
                "Stylish",
                "Stylish",
            },
        }
        do
            local function isPackAnimation(id)
                for _, pack in pairs(ANIM_PACKS) do
                    for _, entry in pairs(pack) do
                        if entry == id then
                            return true
                        end
                    end
                end
                return false
            end
            saveOriginalAnimations = function(character)
                local animate = character:FindFirstChild("Animate")
                if not animate then
                    return
                end
                local function g(object)
                    return object and object.AnimationId or nil
                end
                local ids = {
                    idle1 = g(animate.idle and animate.idle.Animation1),
                    idle2 = g(animate.idle and animate.idle.Animation2),
                    walk = g(animate.walk and animate.walk.WalkAnim),
                    run = g(animate.run and animate.run.RunAnim),
                    jump = g(animate.jump and animate.jump.JumpAnim),
                    fall = g(animate.fall and animate.fall.FallAnim),
                    climb = g(animate.climb and animate.climb.ClimbAnim),
                    swim = g(animate.swim and animate.swim.Swim),
                    swimidle = g(animate.swimidle and animate.swimidle.SwimIdle),
                }
                if not isPackAnimation(ids.walk) then
                    originalTryardAnims = ids
                end
            end
        end
        do
            local function applyAnimationPack811(text)
                currentAnimPack = text
                if animSelectorLabel then
                    animSelectorLabel.Text = text
                end
                if text == "Off" then
                    if originalTryardAnims and localPlayer.Character then
                        local animate = localPlayer.Character:FindFirstChild("Animate")
                        if animate then
                            local function s(object, animationId)
                                if object then
                                    object.AnimationId = animationId
                                end
                            end
                            s(animate.idle and animate.idle.Animation1, originalTryardAnims.idle1)
                            s(animate.idle and animate.idle.Animation2, originalTryardAnims.idle2)
                            s(animate.walk and animate.walk.WalkAnim, originalTryardAnims.walk)
                            s(animate.run and animate.run.RunAnim, originalTryardAnims.run)
                            s(animate.jump and animate.jump.JumpAnim, originalTryardAnims.jump)
                            s(animate.fall and animate.fall.FallAnim, originalTryardAnims.fall)
                            s(animate.climb and animate.climb.ClimbAnim, originalTryardAnims.climb)
                            s(animate.swim and animate.swim.Swim, originalTryardAnims.swim)
                            s(animate.swimidle and animate.swimidle.SwimIdle, originalTryardAnims.swimidle)
                        end
                    end
                    if tryardHeartbeatConn then
                        tryardHeartbeatConn:Disconnect()
                        tryardHeartbeatConn = nil
                    end
                    return
                end
                local pack = ANIM_PACKS[text]
                if not pack then
                    return
                end
                if tryardHeartbeatConn then
                    tryardHeartbeatConn:Disconnect()
                end
                tryardHeartbeatConn = RunService.Heartbeat:Connect(function()
                    local character = localPlayer.Character
                    if not character then
                        return
                    end
                    local animate = character:FindFirstChild("Animate")
                    if not animate then
                        return
                    end
                    local function s(object, animationId)
                        if object then
                            object.AnimationId = animationId
                        end
                    end
                    s(animate.idle and animate.idle.Animation1, pack.idle1)
                    s(animate.idle and animate.idle.Animation2, pack.idle2)
                    s(animate.walk and animate.walk.WalkAnim, pack.walk)
                    s(animate.run and animate.run.RunAnim, pack.run)
                    s(animate.jump and animate.jump.JumpAnim, pack.jump)
                    s(animate.fall and animate.fall.FallAnim, pack.fall)
                    s(animate.climb and animate.climb.ClimbAnim, pack.climb)
                    s(animate.swim and animate.swim.Swim, pack.swim)
                    s(animate.swimidle and animate.swimidle.SwimIdle, pack.swimidle)
                end)
            end
            applyAnimationPack = function(animPack)
                local character = localPlayer.Character
                if character then
                    saveOriginalAnimations(character)
                    applyAnimationPack811(animPack)
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        for _, entry in ipairs(humanoid:GetPlayingAnimationTracks()) do
                            entry:Stop(0)
                        end
                        humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end
                else
                    applyAnimationPack811(animPack)
                end
                currentAnimPack = animPack
            end
            disableAnimationPack = function()
                currentAnimPack = "Off"
                if animSelectorLabel then
                    animSelectorLabel.Text = "Off"
                end
                applyAnimationPack811("Off")
            end
        end
    end
    DEFAULT_KB = {
        DropBrainrot = {
            kb = Enum.KeyCode.J,
            gp = nil,
        },
        AutoLeft = {
            kb = Enum.KeyCode.Z,
            gp = nil,
        },
        AutoRight = {
            kb = Enum.KeyCode.C,
            gp = nil,
        },
        AutoBat = {
            kb = Enum.KeyCode.E,
            gp = nil,
        },
        TPFloor = {
            kb = Enum.KeyCode.F,
            gp = nil,
        },
        GuiHide = {
            kb = Enum.KeyCode.LeftControl,
            gp = nil,
        },
        CarryToggle = {
            kb = Enum.KeyCode.Q,
            gp = nil,
        },
        LaggerMode = {
            kb = Enum.KeyCode.R,
            gp = nil,
        },
        TPBat = {
            kb = Enum.KeyCode.X,
            gp = nil,
        },
        BatV2 = {
            kb = Enum.KeyCode.V,
            gp = nil,
        },
        InstaReset = {
            kb = Enum.KeyCode.H,
            gp = nil,
        },
    }
    KB = {
        DropBrainrot = {
            kb = DEFAULT_KB.DropBrainrot.kb,
            gp = DEFAULT_KB.DropBrainrot.gp,
        },
        AutoLeft = {
            kb = DEFAULT_KB.AutoLeft.kb,
            gp = DEFAULT_KB.AutoLeft.gp,
        },
        AutoRight = {
            kb = DEFAULT_KB.AutoRight.kb,
            gp = DEFAULT_KB.AutoRight.gp,
        },
        AutoBat = {
            kb = DEFAULT_KB.AutoBat.kb,
            gp = DEFAULT_KB.AutoBat.gp,
        },
        TPFloor = {
            kb = DEFAULT_KB.TPFloor.kb,
            gp = DEFAULT_KB.TPFloor.gp,
        },
        GuiHide = {
            kb = DEFAULT_KB.GuiHide.kb,
            gp = DEFAULT_KB.GuiHide.gp,
        },
        CarryToggle = {
            kb = DEFAULT_KB.CarryToggle.kb,
            gp = DEFAULT_KB.CarryToggle.gp,
        },
        LaggerMode = {
            kb = DEFAULT_KB.LaggerMode.kb,
            gp = DEFAULT_KB.LaggerMode.gp,
        },
        TPBat = {
            kb = DEFAULT_KB.TPBat.kb,
            gp = DEFAULT_KB.TPBat.gp,
        },
        BatV2 = {
            kb = DEFAULT_KB.BatV2.kb,
            gp = DEFAULT_KB.BatV2.gp,
        },
        InstaReset = {
            kb = DEFAULT_KB.InstaReset.kb,
            gp = DEFAULT_KB.InstaReset.gp,
        },
    }
    _isResetting = false
    _lastSavedJSON = nil
    _isLoading = false
    CONFIG = {
        AUTO_STEAL_ENABLED = false,
        STEAL_RANGE = 61,
    }
    workspace:WaitForChild("Plots")
    autoStealConnection = nil
    autoStealState = {
        AutoStealEnabled = false,
        StealRadius = CONFIG.STEAL_RANGE,
        StealDuration = 1.3,
        StealDelay = 0.25,
        Data = {},
    }
    autoStealBusy = false
    autoStealVariant = 1
    AUTO_STEAL_VARIANT_NAMES = {
        "Normal",
        "Semi",
        "Semi Normal",
    }
    getAutoStealVariantName = function(value)
        return AUTO_STEAL_VARIANT_NAMES[clamp(tonumber(value) or 1, 1, #AUTO_STEAL_VARIANT_NAMES)]
    end
    getAutoStealVariantIndex = function(value)
        for i, entry in ipairs(AUTO_STEAL_VARIANT_NAMES) do
            if entry == tostring(value) then
                return i
            end
        end
        return 1
    end
    getAutoStealDuration = function()
        local stealDuration = autoStealState and autoStealState.StealDuration or 1.3
        if autoStealVariant == 2 then
            return stealDuration * 0.8
        end
        if autoStealVariant == 3 then
            return stealDuration * 0.9
        end
        return stealDuration * 0.73
    end
    do
        local instance = nil
        local value = 0
        getPlotsRoot = function()
            local now = getTime()
            if instance and now - value < 2 and instance.Parent then
                return instance
            end
            instance = workspace:FindFirstChild("Plots")
            value = now
            return instance
        end
    end
    do
        local findNearestPrompt
        do
            local function isMyPlotByName(plotName)
                local plotsRoot = getPlotsRoot()
                if not plotsRoot then
                    return false
                end
                local plot = plotsRoot:FindFirstChild(plotName)
                if not plot then
                    return false
                end
                local sign = plot:FindFirstChild("PlotSign")
                if sign then
                    local yourBase = sign:FindFirstChild("YourBase")
                    if yourBase and yourBase:IsA("BillboardGui") then
                        return yourBase.Enabled == true
                    end
                end
                return false
            end
            findNearestPrompt = function()
                local character = localPlayer.Character
                if not character then
                    return nil, nil
                end
                local root = character:FindFirstChild("HumanoidRootPart")
                if not root then
                    return nil, nil
                end
                local plotsRoot = getPlotsRoot()
                if not plotsRoot then
                    return nil, nil
                end
                local nearestPrompt = nil
                local nearestDistance = huge
                local name = nil
                local position = root.Position
                for _, child in ipairs(plotsRoot:GetChildren()) do
                    if not isMyPlotByName(child.Name) then
                        local pods = child:FindFirstChild("AnimalPodiums")
                        if pods then
                            for _, child2 in ipairs(pods:GetChildren()) do
                                pcall(function()
                                    local spawn_ = child2:FindFirstChild("Base")
                                    spawn_ = spawn_ and spawn_:FindFirstChild("Spawn")
                                    if spawn_ then
                                        local position2 = spawn_.Position
                                        local dx = position2.X - position.X
                                        local dy = position2.Y - position.Y
                                        local dz = position2.Z - position.Z
                                        local distance = sqrt(dx * dx + dy * dy + dz * dz)
                                        if distance < nearestDistance and distance <= autoStealState.StealRadius then
                                            local promptAttachment = spawn_:FindFirstChild("PromptAttachment")
                                            if promptAttachment then
                                                for _, child3 in ipairs(promptAttachment:GetChildren()) do
                                                    if
                                                        child3:IsA("ProximityPrompt")
                                                        and child3.ActionText
                                                        and child3.ActionText:find("Steal")
                                                    then
                                                        nearestPrompt = child3
                                                        nearestDistance = distance
                                                        name = child2.Name
                                                        break
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end)
                            end
                        end
                    end
                end
                return nearestPrompt, name
            end
        end
        local executeSteal = nil
        executeSteal = function(prompt, podName)
            if autoStealBusy then
                return
            end
            if math.random(30) == 1 then
                for k in pairs(autoStealState.Data) do
                    if not k.Parent then
                        autoStealState.Data[k] = nil
                    end
                end
            end
            if not autoStealState.Data[prompt] then
                autoStealState.Data[prompt] = {
                    hold = {},
                    trigger = {},
                    ready = true,
                }
                pcall(function()
                    if getconnections then
                        for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                            if c.Function then
                                table.insert(autoStealState.Data[prompt].hold, c.Function)
                            end
                        end
                        for _, c in ipairs(getconnections(prompt.Triggered)) do
                            if c.Function then
                                table.insert(autoStealState.Data[prompt].trigger, c.Function)
                            end
                        end
                    end
                end)
            end
            local object885 = autoStealState.Data[prompt]
            if not object885.ready then
                return
            end
            object885.ready = false
            autoStealBusy = true
            if progressFill then
                progressFill.Size = UDim2.new(0, 0, 1, 0)
            end
            if progressPct then
                progressPct.Text = "0%"
            end
            task.spawn(function()
                for _, f in ipairs(object885.hold) do
                    task.spawn(f)
                end
                local startTime = getTime()
                local stealDuration = autoStealState.StealDuration
                local promptFired = getAutoStealDuration()
                while true do
                    if autoStealBusy and autoStealState.AutoStealEnabled then
                        local elapsed = getTime() - startTime
                        if not (promptFired <= elapsed) then
                            local progress = clamp(elapsed / stealDuration, 0, 1)
                            if progressFill then
                                progressFill.Size = UDim2.new(progress, 0, 1, 0)
                            end
                            if progressPct then
                                progressPct.Text = floor(progress * 100) .. "%"
                            end
                            if not (not prompt.Parent or not prompt.Parent.Parent) then
                                local character = localPlayer.Character
                                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                                if
                                    not (
                                        humanoidRootPart
                                        and (humanoidRootPart.Position - prompt.Parent.Parent.Position).Magnitude
                                            > autoStealState.StealRadius
                                    )
                                then
                                    task.wait()
                                    continue
                                end
                            end
                        end
                    end
                    break
                end
                local stopProgress = clamp(promptFired / stealDuration, 0, 1)
                if progressFill then
                    progressFill.Size = UDim2.new(stopProgress, 0, 1, 0)
                end
                if progressPct then
                    progressPct.Text = floor(stopProgress * 100) .. "%"
                end
                local phase2Timeout = math.max(2.99 - promptFired - math.max(stealDuration - promptFired, 0), 0.05)
                local phase2Start = getTime()
                local exitTo = nil
                while true do
                    if autoStealBusy and autoStealState.AutoStealEnabled then
                        if getTime() - phase2Start >= phase2Timeout then
                            exitTo = 2
                            break
                        elseif not prompt.Parent or not prompt.Parent.Parent then
                            exitTo = 3
                            break
                        else
                            local character = localPlayer.Character
                            character = character and character:FindFirstChild("HumanoidRootPart")
                            if character then
                                local magnitude = (character.Position - prompt.Parent.Parent.Position).Magnitude
                                if magnitude <= 9 then
                                    exitTo = 1
                                    break
                                elseif not (magnitude > autoStealState.StealRadius) then
                                    task.wait()
                                    continue
                                end
                            else
                                task.wait()
                                continue
                            end
                        end
                    else
                        exitTo = 1
                        break
                    end
                    break
                end
                if exitTo == 1 then
                    if autoStealBusy and autoStealState.AutoStealEnabled then
                        local fillStart = getTime()
                        local fillDuration = math.max(stealDuration - promptFired, 0.05)
                        while true do
                            local fp = clamp((getTime() - fillStart) / fillDuration, 0, 1)
                            local totalProgress = stopProgress + fp * (1 - stopProgress)
                            if progressFill then
                                progressFill.Size = UDim2.new(totalProgress, 0, 1, 0)
                            end
                            if progressPct then
                                progressPct.Text = floor(totalProgress * 100) .. "%"
                            end
                            if not (fp >= 1 and true) then
                                task.wait()
                                continue
                            end
                            break
                        end
                        pcall(function()
                            for _, f in ipairs(object885.trigger) do
                                task.spawn(f)
                            end
                            local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                            if remote and podName then
                                remote:FireServer(podName)
                            end
                            if prompt then
                                prompt:Fire()
                            end
                        end)
                    end
                    if progressFill then
                        progressFill.Size = UDim2.new(0, 0, 1, 0)
                    end
                    if progressPct then
                        progressPct.Text = "0%"
                    end
                    object885.ready = true
                    autoStealBusy = false
                    return
                end
                if exitTo == 2 then
                    if progressFill then
                        progressFill.Size = UDim2.new(0, 0, 1, 0)
                    end
                    if progressPct then
                        progressPct.Text = "0%"
                    end
                    object885.ready = true
                    autoStealBusy = false
                    task.wait()
                    local elapsed, progress = findNearestPrompt()
                    if elapsed then
                        executeSteal(elapsed, progress)
                    end
                    return
                end
                if exitTo == 3 then
                    autoStealBusy = false
                    if progressFill then
                        progressFill.Size = UDim2.new(0, 0, 1, 0)
                    end
                    if progressPct then
                        progressPct.Text = "0%"
                    end
                    object885.ready = true
                    return
                end
                autoStealBusy = false
                if progressFill then
                    progressFill.Size = UDim2.new(0, 0, 1, 0)
                end
                if progressPct then
                    progressPct.Text = "0%"
                end
                object885.ready = true
            end)
        end
        startAutoSteal = function()
            if autoStealConnection then
                local connected = false
                pcall(function()
                    connected = autoStealConnection.Connected == true
                end)
                if connected then
                    autoStealState.StealRadius = CONFIG.STEAL_RANGE
                    autoStealState.AutoStealEnabled = true
                    CONFIG.AUTO_STEAL_ENABLED = true
                    return true
                end
                pcall(function()
                    autoStealConnection:Disconnect()
                end)
                autoStealConnection = nil
            end
            autoStealState.StealRadius = CONFIG.STEAL_RANGE
            autoStealState.AutoStealEnabled = true
            CONFIG.AUTO_STEAL_ENABLED = true
            autoStealConnection = RunService.Heartbeat:Connect(function()
                if not autoStealState.AutoStealEnabled or autoStealBusy then
                    return
                end
                local p, n = findNearestPrompt()
                if p then
                    executeSteal(p, n)
                end
            end)
            return true
        end
    end
    stopAutoSteal = function()
        if autoStealConnection then
            autoStealConnection:Disconnect()
            autoStealConnection = nil
        end
        autoStealBusy = false
        autoStealState.AutoStealEnabled = false
        CONFIG.AUTO_STEAL_ENABLED = false
        if progressFill then
            TweenService:Create(progressFill, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 0, 1, 0),
            }):Play()
        end
        if progressPct then
            progressPct.Text = "0%"
        end
    end
    medusaDebounce = false
    medusaLastUsed = 0
    dropActive = false
    lastDropTime = 0
    lastMoveDir = newVector3(0, 0, 0)
    origFOV = nil
    fovEnabled = false
    fovValue = 70
    customFovConn = nil
    setFovVisual = nil
    fovSliderSet = nil
    _anyKeyListening = false
    _aimbotConn = nil
    _prevAutoRotate = nil
    tpBatConn = nil
    tpBatPrevAutoRotate = nil
    tpBatHitCD = false
    TP_BAT_SWING_CD = 0.08
    tpBatFloatingButton = nil
    batV2FloatingButton = nil
    enemySpeedConn = nil
    movementLoop = nil
    steppedConn = nil
    alConn = nil
    arConn = nil
    infJumpConn = nil
    stretchConn = nil
    stretchFovConn = nil
    medusaResetConns = {}
    dropConnections = {}
    enemySpeedLabels = {}
    Conns = {
        autoSteal = nil,
        batCounter = nil,
        anchor = {},
        progress = nil,
        autoLeft = nil,
        autoRight = nil,
    }
    keyButtonRefs = {}
    progressFill = nil
    progressPct = nil
    progressRadLbl = nil
    progressPingLabel = nil
    pbFrame = nil
    speedLabel = nil
    modeValLbl = nil
    normalBox = nil
    carryBox = nil
    laggerBox = nil
    lagger2Box = nil
    radInput = nil
    batSpeedBox = nil
    uiScaleBox = nil
    modeSelectBtn = nil
    dropModeBtnRef = nil
    setJumpToggleState = nil
    autoBatSetVisual = nil
    autoLeftSetVisual = nil
    autoRightSetVisual = nil
    setBatCounterVisual = nil
    setMedusaVisual = nil
    setAntiRagVisual = nil
    setJumpVisual = nil
    setUnwalkVisual = nil
    setAntiLagVisual = nil
    setLockUIVisual = nil
    setInstaGrab = nil
    setAntiDieVisual = nil
    setEditModeVisual = nil
    setESPVIsual = nil
    mobSetAutoBat = nil
    mobSetAutoLeft = nil
    mobSetAutoRight = nil
    mobSetDropBR = nil
    mobSetTpDown = nil
    mobSetCarry = nil
    mobSetLagger1 = nil
    mobSetLagger2 = nil
    mobSetFloat = nil
    autoBatV2SetVisual = nil
    miniBtn = nil
    main = nil
    gui = nil
    MobilePanel = nil
    instaResetFloatingButton = nil
    showGui = nil
    hideGui = nil
    mainUIScale = nil
    animSelectorLabel = nil
    pbScale = nil
    tabButtons = nil
    carrySystemToggleSetter = nil
    autoStealVariantLabel = nil
    carrySysNormalBox = nil
    carrySysCarryBox = nil
    carrySysLaggerBox = nil
    carrySysLaggerCarryBox = nil
    carrySysSoftStealSpeedBox = nil
    carrySysSoftStealRadiusBox = nil
    setSafeModeVisual = nil
    mirrorTPDownSetVisual = nil
    infJumpSetVisual = nil
    infJumpModeSetVisual = nil
    noPlayerCollisionEnabled = false
    setNoPlayerCollisionVisual = nil
    noCamCollisionEnabled = false
    setNoCamCollisionVisual = nil
    GAMEPAD_KEYS = {
        [Enum.KeyCode.ButtonA] = true,
        [Enum.KeyCode.ButtonB] = true,
        [Enum.KeyCode.ButtonX] = true,
        [Enum.KeyCode.ButtonY] = true,
        [Enum.KeyCode.ButtonL1] = true,
        [Enum.KeyCode.ButtonR1] = true,
        [Enum.KeyCode.ButtonL2] = true,
        [Enum.KeyCode.ButtonR2] = true,
        [Enum.KeyCode.ButtonL3] = true,
        [Enum.KeyCode.ButtonR3] = true,
        [Enum.KeyCode.ButtonStart] = true,
        [Enum.KeyCode.ButtonSelect] = true,
        [Enum.KeyCode.DPadUp] = true,
        [Enum.KeyCode.DPadDown] = true,
        [Enum.KeyCode.DPadLeft] = true,
        [Enum.KeyCode.DPadRight] = true,
    }
    MOVE_KEYS = {
        [Enum.KeyCode.W] = true,
        [Enum.KeyCode.A] = true,
        [Enum.KeyCode.S] = true,
        [Enum.KeyCode.D] = true,
        [Enum.KeyCode.Up] = true,
        [Enum.KeyCode.Left] = true,
        [Enum.KeyCode.Down] = true,
        [Enum.KeyCode.Right] = true,
    }
    BAT_COUNTER_SLAP_LIST = {
        "Bat",
        "Slap",
        "Iron Slap",
        "Gold Slap",
        "Diamond Slap",
        "Emerald Slap",
        "Ruby Slap",
        "Dark Matter Slap",
        "Flame Slap",
        "Nuclear Slap",
        "Galaxy Slap",
        "Glitched Slap",
    }
    AP = {
        L1 = newVector3(-476.48, -6.28, 92.73),
        L2 = newVector3(-483.12, -4.95, 94.8),
        L_FACE = newVector3(-482.25, -4.96, 92.09),
        R1 = newVector3(-476.16, -6.52, 25.62),
        R2 = newVector3(-483.06, -5.03, 25.48),
        R_FACE = newVector3(-482.06, -6.93, 35.47),
    }
    isGamepadInput = function(input)
        return input and input.UserInputType and input.UserInputType.Name:match("^Gamepad") ~= nil
    end
    isBindableInput = function(input)
        if not input or input.KeyCode == Enum.KeyCode.Unknown then
            return false
        end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            return true
        end
        return isGamepadInput(input) and GAMEPAD_KEYS[input.KeyCode] == true
    end
    kbMatch = function(entry, kc)
        return kc and (kc == entry.kb or entry.gp and kc == entry.gp)
    end
    resetProgressBar = function()
        if progressPct then
            progressPct.Text = "0%"
        end
        if progressFill then
            progressFill.Size = UDim2.new(0, 0, 1, 0)
        end
    end
    teleportDown = function()
        pcall(function()
            local character = localPlayer.Character
            if not character then
                return
            end
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then
                return
            end
            local cFrame = humanoidRootPart.CFrame
            humanoidRootPart.CFrame = newCFrame(humanoidRootPart.Position.X, -7, humanoidRootPart.Position.Z)
                * CFrame.Angles(0, select(2, cFrame:ToEulerAnglesYXZ()), 0)
            humanoidRootPart.Velocity = zeroVector
        end)
    end
    do
        local trackedPlayerHeights = {}
        local lastMirrorTeleportTime = 0
        local function hasActiveTeleportAimbot()
            return _G.AmbitiousNormalAimbotOn == true
                or _G.AmbitiousBatAimbotV2On == true
                or _G.AmbitiousTPBatOn == true
                or _G.AlvaroTP and _G.AlvaroTP.on == true
                or autoBatEnabled == true
                or autoBatV2Enabled == true
                or batDesyncTpEnabled == true
        end
        local function mirrorTeleportDown()
            local character = localPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            character = character and character:FindFirstChildOfClass("Humanoid")
            if not humanoidRootPart or not character or character.Health <= 0 then
                return
            end
            local now = getTime()
            if now - lastMirrorTeleportTime < 0.05 then
                return
            end
            lastMirrorTeleportTime = now
            local pitch, yaw = humanoidRootPart.CFrame:ToEulerAnglesYXZ()
            humanoidRootPart.CFrame = newCFrame(humanoidRootPart.Position.X, -7, humanoidRootPart.Position.Z)
                * CFrame.Angles(0, yaw, 0)
            humanoidRootPart.Velocity = zeroVector
            pcall(function()
                humanoidRootPart.AssemblyLinearVelocity = zeroVector
            end)
        end
        RunService.Heartbeat:Connect(function()
            if not mirrorTPDownEnabled or not hasActiveTeleportAimbot() then
                table.clear(trackedPlayerHeights)
                return
            end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        local y = humanoidRootPart.Position.Y
                        local previousHeight = trackedPlayerHeights[player.UserId]
                        if previousHeight and previousHeight - y >= 3 then
                            pcall(mirrorTeleportDown)
                            table.clear(trackedPlayerHeights)
                            return
                        end
                        trackedPlayerHeights[player.UserId] = y
                    end
                end
            end
        end)
        _G.AmbitiousSetMirrorTPDown = function(enabled)
            mirrorTPDownEnabled = enabled == true
            if not mirrorTPDownEnabled then
                table.clear(trackedPlayerHeights)
            end
            if mirrorTPDownSetVisual then
                mirrorTPDownSetVisual(mirrorTPDownEnabled)
            end
            pcall(saveAllSettings)
        end
    end
end
_G.AmbitiousSafeModeGetCountdownLabel = function()
    local ok, result = pcall(function()
        return localPlayer.PlayerGui
            and localPlayer.PlayerGui:FindFirstChild("DuelsMachineTopFrame")
            and localPlayer.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
            and localPlayer.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
            and localPlayer.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("TextLabel")
    end)
    return ok and result or nil
end
_G.AmbitiousSafeModeCountdownNumber = function(value)
    local text = tostring(value or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
    if text == "GO" or text == "START" or text == "READY" then
        return true
    end
    local num = tonumber(text)
    return num ~= nil and num >= 0 and num <= 10
end
_G.AmbitiousSafeModeCountdownValue = function()
    local textLabel = _G.AmbitiousSafeModeGetCountdownLabel()
    if not textLabel then
        return nil
    end
    local text = tostring(textLabel.Text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
    if text == "GO" or text == "START" or text == "READY" then
        return 0
    end
    local num = tonumber(text)
    if num ~= nil and num >= 0 and num <= 10 then
        return num
    end
    return nil
end
_G.AmbitiousSafeModeInDuelCountdown = function()
    local textLabel = _G.AmbitiousSafeModeGetCountdownLabel()
    return textLabel and _G.AmbitiousSafeModeCountdownNumber(textLabel.Text) or false
end
_G.AmbitiousSafeModeBlockedTools = {
    bat = true,
    slap = true,
    sword = true,
    gun = true,
    pistol = true,
    rifle = true,
    medusa = true,
    hammer = true,
    axe = true,
    knife = true,
    katana = true,
    blade = true,
    fist = true,
}
_G.AmbitiousSafeModeIsCarryableTool = function(callback)
    if not callback or not callback:IsA("Tool") then
        return false
    end
    local lowercaseText = callback.Name:lower()
    for k in pairs(_G.AmbitiousSafeModeBlockedTools) do
        if lowercaseText:find(k, 1, true) then
            return false
        end
    end
    return true
end
_G.AmbitiousSafeModeHoldingBrainrot = function()
    local ok, result = pcall(function()
        return localPlayer:GetAttribute("Stealing")
    end)
    if ok and result == true then
        return true
    end
    local ok2, result2 = pcall(function()
        return localPlayer:GetAttribute("Stealing")
    end)
    if ok2 and result2 == true then
        return true
    end
    local character = localPlayer.Character
    if not character then
        return false
    end
    local ok3, result3 = pcall(function()
        return character:GetAttribute("Stealing")
    end)
    if ok3 and result3 == true then
        return true
    end
    for _, entry in ipairs({
        "Carrying",
        "IsCarrying",
        "Grabbed",
        "Holding",
        "StealHold",
        "HasGrab",
    }) do
        local instance = character:FindFirstChild(entry, true)
        if instance then
            if instance:IsA("BoolValue") and instance.Value then
                return true
            end
            if instance:IsA("ObjectValue") and instance.Value then
                return true
            end
            if instance:IsA("StringValue") and instance.Value ~= "" then
                return true
            end
        end
    end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            local lowercaseText = child.Name:lower()
            if
                lowercaseText:find("brainrot")
                or lowercaseText:find("animal")
                or lowercaseText:find("carry")
                or lowercaseText:find("grab")
                or lowercaseText:find("steal")
                or lowercaseText:find("hold")
            then
                return true
            end
        end
    end
    return false
end
_G.AmbitiousSafeModeIsLocked = function()
    if not antiKickEnabled then
        return false
    end
    return _G.AmbitiousSafeModeInDuelCountdown() or _G.AmbitiousSafeModeHoldingBrainrot()
end
_G.AmbitiousSafeModeForceStop = function(value)
    local object = autoBatEnabled and disableAutoBat
    local isEnabled = false
    if object then
        disableAutoBat()
        isEnabled = true
    end
    if autoBatV2Enabled and disableBatV2 then
        disableBatV2()
        isEnabled = true
    end
    if batDesyncTpEnabled and stopBatDesyncTp then
        stopBatDesyncTp()
        isEnabled = true
    end
    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then
            autoLeftSetVisual(false)
        end
        stopAutoLeft()
        isEnabled = true
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then
            autoRightSetVisual(false)
        end
        stopAutoRight()
        isEnabled = true
    end
    if isEnabled then
        print("[SafeMode]", value or "LOCK")
    end
end
_G.AmbitiousSafeModeTryStart = function()
    if _G.AmbitiousSafeModeIsLocked and _G.AmbitiousSafeModeIsLocked() then
        _G.AmbitiousSafeModeForceStop("SAFE MODE LOCK")
        return false
    end
    return true
end
_G.AmbitiousSafeModeMonitorStarted = _G.AmbitiousSafeModeMonitorStarted or false
if not _G.AmbitiousSafeModeMonitorStarted then
    _G.AmbitiousSafeModeMonitorStarted = true
    RunService.Heartbeat:Connect(function()
        if antiKickEnabled and _G.AmbitiousSafeModeIsLocked and _G.AmbitiousSafeModeIsLocked() then
            _G.AmbitiousSafeModeForceStop("SAFE MODE LOCK")
        end
    end)
end
antiRagdollController = {}
antiRagdollController.__index = antiRagdollController
do
    local data = {
        active = false,
        isBoosting = false,
        cachedChar = nil,
        ragdollConnections = {},
        _lastBoostTime = 0,
    }
    local function getActiveMoveSpeed()
        if laggerCarryToggled then
            return LAGGER_CARRY_SPEED
        end
        if laggerToggled then
            return LAGGER_SPEED
        end
        if speedMode then
            return CS
        end
        return NS
    end
    local function disconnectAllV1()
        for _, ragdollConnection in ipairs(data.ragdollConnections) do
            pcall(function()
                ragdollConnection:Disconnect()
            end)
        end
        data.ragdollConnections = {}
    end
    local function cacheCharacterV1()
        local character = localPlayer.Character
        if not character then
            return false
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not humanoidRootPart then
            return false
        end
        data.cachedChar = {
            character = character,
            humanoid = humanoid,
            root = humanoidRootPart,
        }
        return true
    end
    local function isRagdolledV1()
        if not data.cachedChar or not data.cachedChar.humanoid then
            return false
        end
        local humanoid = data.cachedChar.humanoid
        if not humanoid.Parent then
            return false
        end
        return ({
            [Enum.HumanoidStateType.Physics] = true,
            [Enum.HumanoidStateType.Ragdoll] = true,
            [Enum.HumanoidStateType.FallingDown] = true,
        })[humanoid:GetState()] or false
    end
    local function forceExitRagdollV1()
        if not data.cachedChar or not data.cachedChar.humanoid or not data.cachedChar.root then
            return
        end
        local humanoid = data.cachedChar.humanoid
        local root = data.cachedChar.root
        if not humanoid.Parent or not root.Parent then
            return
        end
        pcall(function()
            localPlayer:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
        end)
        for _, descendant in ipairs(data.cachedChar.character:GetDescendants()) do
            local isBallSocketConstraint = descendant:IsA("BallSocketConstraint")
            local pos
            if isBallSocketConstraint then
                pos = isBallSocketConstraint
            else
                pos = descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")
            end
            if pos then
                pcall(function()
                    descendant:Destroy()
                end)
            end
        end
        local activeMoveSpeed = getActiveMoveSpeed()
        if not data.isBoosting then
            data.isBoosting = true
            data._lastBoostTime = getTime()
        end
        pcall(function()
            humanoid.WalkSpeed = activeMoveSpeed
        end)
        if humanoid.Health > 0 then
            pcall(function()
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
        pcall(function()
            root.Anchored = false
        end)
    end
    local function heartbeatLoopV1()
        while data.active do
            task.wait(0.05)
            if isRagdolledV1() then
                forceExitRagdollV1()
            elseif data.isBoosting then
                if getTime() - (data._lastBoostTime or 0) > 0.35 or not isRagdolledV1() then
                    data.isBoosting = false
                    if data.cachedChar and data.cachedChar.humanoid then
                        pcall(function()
                            data.cachedChar.humanoid.WalkSpeed = getActiveMoveSpeed()
                        end)
                    end
                end
            end
        end
    end
    antiRagdollController.start = function()
        if data.active then
            return
        end
        antiRagdollController.stop()
        if not cacheCharacterV1() then
            warn("[AntiRagdollV1] No se pudo cachear el personaje")
            return
        end
        data.active = true
        data.isBoosting = false
        local connection2 = RunService.RenderStepped:Connect(function()
            local currentCamera2 = workspace.CurrentCamera
            if currentCamera2 and data.cachedChar and data.cachedChar.humanoid then
                currentCamera2.CameraSubject = data.cachedChar.humanoid
            end
        end)
        table.insert(data.ragdollConnections, connection2)
        local connection3 = localPlayer.CharacterAdded:Connect(function()
            data.isBoosting = false
            task.wait(0.5)
            cacheCharacterV1()
        end)
        table.insert(data.ragdollConnections, connection3)
        task.spawn(heartbeatLoopV1)
        print("[AntiRagdollV1] Activado")
    end
    antiRagdollController.stop = function()
        data.active = false
        if data.isBoosting and data.cachedChar and data.cachedChar.humanoid then
            pcall(function()
                data.cachedChar.humanoid.WalkSpeed = getActiveMoveSpeed()
            end)
        end
        data.isBoosting = false
        disconnectAllV1()
        data.cachedChar = nil
        print("[AntiRagdollV1] Desactivado")
    end
    antiRagdollController.isRunning = function()
        return data.active
    end
end
antiRagdollV2State = {
    Enabled = false,
    Connection = nil,
    ResetCooldown = 0,
}
enableAntiRagdollV2 = function()
    if antiRagdollV2State.Connection then
        return
    end
    antiRagdollV2State.Enabled = true
    antiRagdollV2State.Connection = RunService.Heartbeat:Connect(function()
        if not antiRagdollV2State.Enabled then
            return
        end
        local character = localPlayer.Character
        if not character then
            return
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not humanoidRootPart then
            return
        end
        local isActive = humanoid.Health <= 0
        if not isActive then
            local dead = Enum.HumanoidStateType.Dead
            isActive = humanoid:GetState() == dead
        end
        if isActive then
            return
        end
        local state = humanoid:GetState()
        local time = getTime()
        if
            state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
        then
            if time - antiRagdollV2State.ResetCooldown > 0.15 then
                antiRagdollV2State.ResetCooldown = time
                pcall(function()
                    local gettingUp = Enum.HumanoidStateType.GettingUp
                    if humanoid:GetState() == gettingUp then
                        return
                    end
                    local isActive = humanoid.Health <= 0
                    if not isActive then
                        local dead = Enum.HumanoidStateType.Dead
                        isActive = humanoid:GetState() == dead
                    end
                    if isActive then
                        return
                    end
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    humanoidRootPart.Velocity = zeroVector
                    humanoidRootPart.RotVelocity = zeroVector
                    humanoidRootPart.AssemblyLinearVelocity = zeroVector
                    humanoidRootPart.AssemblyAngularVelocity = zeroVector
                    for _, descendant in ipairs(character:GetDescendants()) do
                        if descendant:IsA("Motor6D") then
                            descendant.Enabled = true
                        end
                        if descendant:IsA("Constraint") then
                            descendant.Enabled = true
                        end
                    end
                    workspace.CurrentCamera.CameraSubject = humanoid
                    local playerModule = localPlayer.PlayerScripts:FindFirstChild("PlayerModule")
                    if playerModule then
                        local controlModule = require(playerModule:FindFirstChild("ControlModule"))
                        if controlModule then
                            controlModule:Enable()
                        end
                    end
                    humanoid.AutoRotate = true
                    humanoid.PlatformStand = false
                    humanoid.Sit = false
                end)
            end
        end
    end)
end
disableAntiRagdollV2 = function()
    antiRagdollV2State.Enabled = false
    if antiRagdollV2State.Connection then
        antiRagdollV2State.Connection:Disconnect()
        antiRagdollV2State.Connection = nil
    end
    antiRagdollV2State.ResetCooldown = 0
end
setAntiRagdollMode = function(mode)
    if antiRagdollController.isRunning() then
        antiRagdollController.stop()
    end
    if antiRagdollV2State.Enabled then
        disableAntiRagdollV2()
    end
    antiRagdollMode = mode
    if mode == "v1" then
        antiRagdollController.start()
    elseif mode == "v2" then
        enableAntiRagdollV2()
    end
    if _G.updateAntiRagdollUI then
        _G.updateAntiRagdollUI(mode)
    end
    saveAllSettings()
end
antiDie = {
    enabled = false,
    heartConn = nil,
    deathConns = {},
    charConn = nil,
    humanoid = nil,
}
do
    local function stopDropBrainrot()
        for _, deathConnection in ipairs(antiDie.deathConns) do
            pcall(function()
                deathConnection:Disconnect()
            end)
        end
        antiDie.deathConns = {}
        if antiDie.heartConn then
            pcall(function()
                antiDie.heartConn:Disconnect()
            end)
            antiDie.heartConn = nil
        end
    end
    local function protectCharacterFromDeath(character)
        if not character then
            return
        end
        local humanoid = character:WaitForChild("Humanoid", 5)
        if not humanoid then
            return
        end
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        pcall(function()
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            humanoid.BreakJointsOnDeath = false
        end)
        antiDie.humanoid = humanoid
        table.insert(
            antiDie.deathConns,
            humanoid.StateChanged:Connect(function(old, new)
                if not antiDie.enabled then
                    return
                end
                if new == Enum.HumanoidStateType.Dead then
                    humanoid.Health = math.huge
                    pcall(function()
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    end)
                end
            end)
        )
        table.insert(
            antiDie.deathConns,
            humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if antiDie.enabled and humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = math.huge
                end
            end)
        )
        if antiDie.heartConn then
            pcall(function()
                antiDie.heartConn:Disconnect()
            end)
        end
        antiDie.heartConn = RunService.Heartbeat:Connect(function()
            if antiDie.enabled and humanoid and humanoid.Parent and humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = math.huge
            end
        end)
    end
    reapplyAntiDie = function(character)
        if not antiDie.enabled then
            return
        end
        protectCharacterFromDeath(character or localPlayer.Character)
    end
    antiDie.start = function()
        antiDie.enabled = true
        stopDropBrainrot()
        protectCharacterFromDeath(localPlayer.Character)
        if antiDie.charConn then
            pcall(function()
                antiDie.charConn:Disconnect()
            end)
        end
        antiDie.charConn = localPlayer.CharacterAdded:Connect(function(character)
            if not antiDie.enabled then
                return
            end
            task.wait(0.1)
            stopDropBrainrot()
            protectCharacterFromDeath(character)
        end)
        print("[AntiDie] Activado (Envy logic)")
    end
    antiDie.stop = function()
        antiDie.enabled = false
        stopDropBrainrot()
        if antiDie.charConn then
            pcall(function()
                antiDie.charConn:Disconnect()
            end)
            antiDie.charConn = nil
        end
        local character = localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            pcall(function()
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                humanoid.MaxHealth = 100
                humanoid.Health = 100
            end)
        end
        antiDie.humanoid = nil
        print("[AntiDie] Desactivado")
    end
end
_G.AntiDie = antiDie
antiFlingShield = {
    enabled = false,
    loop = nil,
    velocityThreshold = 80,
}
do
    local function stabilizeRoot(root)
        if not root or not root.Parent then
            return
        end
        if batDesyncTpEnabled then
            return
        end
        local assemblyLinearVelocity = nil
        if
            not pcall(function()
                assemblyLinearVelocity = root.AssemblyLinearVelocity
            end) or typeof(assemblyLinearVelocity) ~= "Vector3"
        then
            assemblyLinearVelocity = function()
                return root.Velocity
            end
            local ok
            ok, assemblyLinearVelocity = pcall(assemblyLinearVelocity)
            if not ok or typeof(assemblyLinearVelocity) ~= "Vector3" then
                return
            end
        end
        if assemblyLinearVelocity.Magnitude <= antiFlingShield.velocityThreshold then
            return
        end
        local stabilized = newVector3(0, assemblyLinearVelocity.Y, 0)
        pcall(function()
            root.AssemblyLinearVelocity = stabilized
        end)
        pcall(function()
            root.AssemblyAngularVelocity = zeroVector
        end)
        pcall(function()
            root.Velocity = stabilized
        end)
        pcall(function()
            root.RotVelocity = zeroVector
        end)
    end
    antiFlingShield.start = function()
        antiFlingShield.enabled = true
        if antiFlingShield.loop then
            antiFlingShield.loop:Disconnect()
        end
        antiFlingShield.loop = RunService.Heartbeat:Connect(function()
            if not antiFlingShield.enabled then
                return
            end
            local character = localPlayer.Character
            stabilizeRoot(character and character:FindFirstChild("HumanoidRootPart"))
        end)
        print("[AntiFlingShield] Activado (interno)")
    end
end
antiFlingShield.stop = function()
    antiFlingShield.enabled = false
    if antiFlingShield.loop then
        antiFlingShield.loop:Disconnect()
        antiFlingShield.loop = nil
    end
    print("[AntiFlingShield] Desactivado (interno)")
end
_G.AntiFlingShield = antiFlingShield
do
    local isEnabled = false
    local function getRagBillboard()
        local character = localPlayer.Character
        if not character then
            return nil, nil
        end
        local head = character:FindFirstChild("Head")
        if not head then
            return nil, nil
        end
        local playerGui = localPlayer.PlayerGui
        local ragCountdownBillboard = playerGui:FindFirstChild("RagCountdownBillboard")
        if ragCountdownBillboard then
            ragCountdownBillboard:Destroy()
        end
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "RagCountdownBillboard"
        billboardGui.Size = UDim2.new(0, 84, 0, 42)
        billboardGui.StudsOffset = newVector3(0, 7, 0)
        billboardGui.AlwaysOnTop = true
        billboardGui.Adornee = head
        billboardGui.Parent = playerGui
        local rootPart = Instance.new("TextLabel")
        rootPart.Size = UDim2.new(1, 0, 1, 0)
        rootPart.AnchorPoint = Vector2.new(0.5, 0.5)
        rootPart.Position = UDim2.new(0.5, 0, 0.5, 0)
        rootPart.BackgroundTransparency = 1
        rootPart.Font = Enum.Font.GothamBlack
        rootPart.TextScaled = true
        rootPart.TextColor3 = Color3.fromRGB(255, 255, 255)
        rootPart.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        rootPart.TextStrokeTransparency = 1
        rootPart.Text = ""
        rootPart.Parent = billboardGui
        local uiGradient = Instance.new("UIGradient", rootPart)
        local data = {}
        local object = ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 210))
        local object1133 = ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1))
        local object1134 = ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1))
        local object1135 = ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1))
        data[1] = object
        data[2] = object1133
        data[3] = object1134
        data[4] = object1135
        data[5] = ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 210))
        uiGradient.Color = ColorSequence.new(data)
        uiGradient.Rotation = 45
        uiGradient.Offset = Vector2.new(0, 0)
        return billboardGui, rootPart
    end
    local function ragPunch(label, text)
        if not (label and label.Parent) then
            return
        end
        label.Text = text
    end
    showRagdollCountdown = function()
        if isEnabled then
            return
        end
        isEnabled = true
        task.spawn(function()
            local ragBillboard, object = getRagBillboard()
            if not ragBillboard then
                isEnabled = false
                return
            end
            local value = 2.5
            while value > 0 and ragBillboard.Parent do
                ragPunch(object, string.format("%.1f", value))
                task.wait(0.1)
                value -= 0.1
            end
            if ragBillboard and ragBillboard.Parent then
                ragPunch(object, "READY!")
                task.wait(0.5)
                if ragBillboard and ragBillboard.Parent then
                    ragBillboard:Destroy()
                end
            end
            isEnabled = false
        end)
    end
end
local isActive
do
    local snowVS
    do
        local connection2, clearESP, updateESP
        do
            local isActive = false
            RunService.Heartbeat:Connect(function()
                local character = localPlayer.Character
                if not character then
                    isActive = false
                    return
                end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoid or humanoid.Health <= 0 then
                    isActive = false
                    return
                end
                local state = humanoid:GetState()
                local isActive1155 = state == Enum.HumanoidStateType.Physics
                    or state == Enum.HumanoidStateType.Ragdoll
                    or state == Enum.HumanoidStateType.FallingDown
                if isActive1155 and not isActive then
                    isActive = true
                    showRagdollCountdown()
                elseif not isActive1155 then
                    isActive = false
                end
            end)
        end
        do
            local data = {}
            local data1157 = {}
            local data1158 = {}
            connection2 = nil
            local value = 0
            profileImageCache = {}
            clearESP = function()
                for k in pairs(data) do
                    pcall(function()
                        data[k]:Destroy()
                    end)
                end
                for k in pairs(data1157) do
                    pcall(function()
                        data1157[k]:Destroy()
                    end)
                end
                for k in pairs(data1158) do
                    for _, ln in ipairs(data1158[k]) do
                        pcall(function()
                            ln.Visible = false
                            ln:Remove()
                        end)
                    end
                end
                data = {}
                data1157 = {}
                data1158 = {}
            end
            local function makeESPTracers()
                if not (Drawing and type(Drawing.new) == "function") then
                    return nil
                end
                local color = getThemeColor()
                local line = Drawing.new("Line")
                line.Color = color
                line.Thickness = 2.2
                line.Transparency = 0.9
                line.Visible = false
                local mid = Drawing.new("Line")
                mid.Color = color
                mid.Thickness = 1.2
                mid.Transparency = 0.74
                mid.Visible = false
                local line2 = Drawing.new("Line")
                line2.Color = color
                line2.Thickness = 0.6
                line2.Transparency = 0.1
                line2.Visible = false
                return {
                    line,
                    mid,
                    line2,
                }
            end
            updateESP = function()
                local now = getTime()
                if now - value < 0.05 then
                    return
                end
                value = now
                if not espEnabled then
                    clearESP()
                    return
                end
                local character = localPlayer.Character
                character = character and character:FindFirstChild("HumanoidRootPart")
                if not character then
                    return
                end
                local myScreenPosition, myOnScreen = currentCamera:WorldToViewportPoint(character.Position)
                local vector22 = Vector2.new(myScreenPosition.X, myScreenPosition.Y)
                local currentPlayers = getPlayersCached()
                local plrSet = {}
                for _, p in ipairs(currentPlayers) do
                    plrSet[p] = true
                end
                for k in pairs(data) do
                    if not plrSet[k] then
                        pcall(function()
                            data[k]:Destroy()
                        end)
                        data[k] = nil
                    end
                end
                for k in pairs(data1157) do
                    if not plrSet[k] then
                        pcall(function()
                            data1157[k]:Destroy()
                        end)
                        data1157[k] = nil
                    end
                end
                for k in pairs(data1158) do
                    if not plrSet[k] then
                        for _, ln in ipairs(data1158[k]) do
                            pcall(function()
                                ln.Visible = false
                                ln:Remove()
                            end)
                        end
                        data1158[k] = nil
                    end
                end
                local color = getThemeColor()
                for _, player in ipairs(currentPlayers) do
                    if player ~= localPlayer then
                        local character2 = player.Character
                        if not character2 then
                            if data[player] then
                                pcall(function()
                                    data[player]:Destroy()
                                end)
                                data[player] = nil
                            end
                            if data1157[player] then
                                pcall(function()
                                    data1157[player]:Destroy()
                                end)
                                data1157[player] = nil
                            end
                            if data1158[player] then
                                for _, ln in ipairs(data1158[player]) do
                                    pcall(function()
                                        ln.Visible = false
                                    end)
                                end
                            end
                        else
                            local humanoidRootPart = character2:FindFirstChild("HumanoidRootPart")
                            local head = character2:FindFirstChild("Head")
                            local humanoid = character2:FindFirstChildOfClass("Humanoid")
                            if humanoidRootPart and head and humanoid and humanoid.Health > 0 then
                                local highlight = data[player]
                                if not highlight or not highlight.Parent or highlight.Parent ~= character2 then
                                    if highlight then
                                        pcall(function()
                                            highlight:Destroy()
                                        end)
                                    end
                                    highlight = Instance.new("Highlight")
                                    highlight.Name = "FictionHubESP"
                                    highlight.FillColor = color
                                    highlight.FillTransparency = 0.72
                                    highlight.OutlineColor = color
                                    highlight.OutlineTransparency = 0.05
                                    highlight.Adornee = character2
                                    highlight.Parent = character2
                                    data[player] = highlight
                                end
                                local billboardGui = data1157[player]
                                if not billboardGui or not billboardGui.Parent then
                                    if billboardGui then
                                        pcall(function()
                                            billboardGui:Destroy()
                                        end)
                                    end
                                    billboardGui = Instance.new("BillboardGui")
                                    billboardGui.Name = "ProfilePic"
                                    billboardGui.Size = UDim2.new(0, 56, 0, 56)
                                    billboardGui.StudsOffset = newVector3(0, 3.8, 0)
                                    billboardGui.Adornee = head
                                    billboardGui.AlwaysOnTop = true
                                    billboardGui.Parent = head
                                    local img = Instance.new("ImageLabel", billboardGui)
                                    img.Size = UDim2.new(1, -6, 1, -6)
                                    img.Position = UDim2.new(0, 3, 0, 3)
                                    img.BackgroundTransparency = 1
                                    img.Image = "rbxassetid://0"
                                    img.ScaleType = Enum.ScaleType.Fit
                                    Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)
                                    local uiStroke = Instance.new("UIStroke", img)
                                    uiStroke.Color = color
                                    uiStroke.Thickness = 1.5
                                    data1157[player] = billboardGui
                                    task.spawn(function()
                                        local userId = player.UserId
                                        local image = profileImageCache[userId]
                                        if not image then
                                            local ok
                                            ok, image = pcall(function()
                                                return Players:GetUserThumbnailAsync(
                                                    userId,
                                                    Enum.ThumbnailType.HeadShot,
                                                    Enum.ThumbnailSize.Size420x420
                                                )
                                            end)
                                            if ok and image and image ~= "" then
                                                profileImageCache[userId] = image
                                            else
                                                image = "rbxassetid://0"
                                            end
                                        end
                                        if img then
                                            img.Image = image
                                        end
                                    end)
                                else
                                    if billboardGui.Adornee ~= head then
                                        billboardGui.Adornee = head
                                    end
                                    billboardGui.Enabled = true
                                end
                                local lines = data1158[player]
                                if not lines then
                                    lines = makeESPTracers()
                                    data1158[player] = lines or {}
                                end
                                if lines and #lines > 0 then
                                    local position, onScreen =
                                        currentCamera:WorldToViewportPoint(humanoidRootPart.Position)
                                    if onScreen and position.Z > 0 and myOnScreen then
                                        local vector23 = Vector2.new(position.X, position.Y)
                                        for _, ln in ipairs(lines) do
                                            ln.From = vector22
                                            ln.To = vector23
                                            ln.Visible = true
                                        end
                                    else
                                        for _, ln in ipairs(lines) do
                                            ln.Visible = false
                                        end
                                    end
                                end
                            else
                                if data[player] then
                                    pcall(function()
                                        data[player]:Destroy()
                                    end)
                                    data[player] = nil
                                end
                                if data1157[player] then
                                    pcall(function()
                                        data1157[player]:Destroy()
                                    end)
                                    data1157[player] = nil
                                end
                                if data1158[player] then
                                    for _, ln in ipairs(data1158[player]) do
                                        pcall(function()
                                            ln.Visible = false
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        do
            local function startESPLoop()
                if connection2 then
                    connection2:Disconnect()
                end
                connection2 = RunService.RenderStepped:Connect(updateESP)
            end
            local function stopEnemySpeed()
                if connection2 then
                    connection2:Disconnect()
                    connection2 = nil
                end
                clearESP()
            end
            toggleESP = function(on)
                espEnabled = on
                if on then
                    startESPLoop()
                else
                    stopEnemySpeed()
                end
                if setESPVIsual then
                    setESPVIsual(on)
                end
            end
        end
    end
    do
        local value = 0
        updateEnemySpeedLabels = function()
            value += 1
            if value < 6 then
                return
            end
            value = 0
            local color = getThemeColor()
            local players = getPlayersCached()
            for i = 1, #players do
                local player = players[i]
                if player ~= localPlayer then
                    local character = player.Character
                    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    if humanoidRootPart and humanoid and humanoid.Health > 0 then
                        local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
                        local speed = sqrt(
                            assemblyLinearVelocity.X * assemblyLinearVelocity.X
                                + assemblyLinearVelocity.Z * assemblyLinearVelocity.Z
                        )
                        local label = enemySpeedLabels[player]
                        if not label then
                            local head = character:FindFirstChild("Head")
                            if head then
                                local billboardGui = Instance.new("BillboardGui")
                                billboardGui.Size = UDim2.new(0, 100, 0, 25)
                                billboardGui.StudsOffset = newVector3(0, 5.5, 0)
                                billboardGui.AlwaysOnTop = true
                                billboardGui.Name = "EnemySpeedGui"
                                billboardGui.Parent = head
                                label = Instance.new("TextLabel", billboardGui)
                                label.Size = UDim2.new(1, 0, 1, 0)
                                label.BackgroundTransparency = 1
                                label.TextColor3 = color
                                label.Font = Enum.Font.GothamBold
                                label.TextScaled = true
                                label.TextStrokeTransparency = 1
                                label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                enemySpeedLabels[player] = label
                            end
                        elseif label.Parent and label.Parent.Parent ~= character then
                            local head = character:FindFirstChild("Head")
                            if head then
                                label.Parent.Parent = head
                            end
                        end
                        if label then
                            label.Text = string.format("%.1f", speed)
                            if label.TextColor3 ~= color then
                                label.TextColor3 = color
                            end
                        end
                    else
                        local label = enemySpeedLabels[player]
                        if label and label.Parent and label.Parent.Parent then
                            label.Parent.Parent = nil
                        end
                        enemySpeedLabels[player] = nil
                    end
                end
            end
        end
    end
    startEnemySpeed = function()
        if enemySpeedConn then
            enemySpeedConn:Disconnect()
        end
        enemySpeedConn = RunService.Heartbeat:Connect(updateEnemySpeedLabels)
    end
    stopEnemySpeed = function()
        if enemySpeedConn then
            enemySpeedConn:Disconnect()
            enemySpeedConn = nil
        end
    end
    do
        local function findNearestPlayer()
            local character = localPlayer.Character
            if character then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if not rootPart then
                    return nil
                end
                local position = rootPart.Position
                local playersCached = getPlayersCached()
                local closestDistance = huge
                local closestPlayer = nil
                for i = 1, #playersCached do
                    local player = playersCached[i]
                    if player ~= localPlayer then
                        local character2 = player.Character
                        if character2 then
                            local rootPart = character2:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                local humanoid = character2:FindFirstChildOfClass("Humanoid")
                                if humanoid and humanoid.Health > 0 then
                                    local deltaX = rootPart.Position.X - position.X
                                    local deltaY = rootPart.Position.Y - position.Y
                                    local deltaZ = rootPart.Position.Z - position.Z
                                    local distance = deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ
                                    if distance < closestDistance then
                                        closestDistance = distance
                                        closestPlayer = rootPart
                                    end
                                end
                            end
                        end
                    end
                end
                return closestPlayer
            end
            return nil
        end
        local function bodyLockTick()
            local character = localPlayer.Character
            if not character then
                return
            end
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then
                return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then
                return
            end
            local rootPart = findNearestPlayer()
            if not rootPart then
                if not humanoid.AutoRotate then
                    humanoid.AutoRotate = true
                end
                return
            end
            if bodyLockRange < (rootPart.Position - humanoidRootPart.Position).Magnitude then
                if not humanoid.AutoRotate then
                    humanoid.AutoRotate = true
                end
                return
            end
            if humanoid.AutoRotate then
                humanoid.AutoRotate = false
            end
            local assemblyLinearVelocity = rootPart.AssemblyLinearVelocity
            local vector = rootPart.Position
                + assemblyLinearVelocity * clamp(assemblyLinearVelocity.Magnitude / 80, 0.08, 0.35)
            local parent = rootPart.Parent and rootPart.Parent:FindFirstChild("Head")
            parent = parent and parent.Position.Y or rootPart.Position.Y
            local y = humanoidRootPart.Position.Y
            local hipHeight = humanoid.HipHeight or 0
            local z = vector.Z
            local vector1217 =
                newVector3(vector.X, humanoidRootPart.Position.Y + clamp((parent - y + hipHeight) * 0.15, -1.5, 1.5), z)
            if 0.1 < (vector1217 - humanoidRootPart.Position).Magnitude then
                local object = lookAtCFrame(humanoidRootPart.Position, vector1217)
                local _, object1265 = (humanoidRootPart.CFrame:Inverse() * object):ToEulerAnglesXYZ()
                humanoidRootPart.AssemblyAngularVelocity =
                    humanoidRootPart.CFrame:VectorToWorldSpace(newVector3(0, clamp(object1265, -2.5, 2.5) * 42, 0))
            end
        end
        startBodyLock = function()
            if _bodyLockConn then
                _bodyLockConn:Disconnect()
            end
            local acc = 0
            _bodyLockConn = RunService.Heartbeat:Connect(function(deltaTime)
                if not bodyLockEnabled then
                    return
                end
                if _blSuppressCount > 0 then
                    return
                end
                acc += deltaTime
                if acc < 0.033 then
                    return
                end
                acc = 0
                bodyLockTick()
            end)
        end
    end
    stopBodyLock = function()
        if _bodyLockConn then
            _bodyLockConn:Disconnect()
            _bodyLockConn = nil
        end
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.AssemblyAngularVelocity = zeroVector
            humanoidRootPart.AssemblyLinearVelocity =
                newVector3(humanoidRootPart.AssemblyLinearVelocity.X, -0.1, humanoidRootPart.AssemblyLinearVelocity.Z)
        end
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = true
        end
    end
    _suppressBodyLock = function()
        _blSuppressCount = _blSuppressCount + 1
        if _blSuppressCount == 1 and bodyLockEnabled then
            _blWasEnabled = true
            stopBodyLock()
            if bodyLockSetVisual then
                bodyLockSetVisual(false)
            end
            if _blRestoreTimer then
                task.cancel(_blRestoreTimer)
                _blRestoreTimer = nil
            end
            _blSmoothRestore = false
        end
    end
    _unsuppressBodyLock = function(delayed)
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
                    if bodyLockSetVisual then
                        bodyLockSetVisual(true)
                    end
                    task.delay(0.5, function()
                        _blSmoothRestore = false
                    end)
                end
            end
            if delayed then
                _blRestoreTimer = task.delay(1, restore)
            else
                restore()
            end
        end
    end
    setupSpeedIndicator = function(callback)
        local head = callback:WaitForChild("Head", 5)
        if not head then
            return
        end
        local fictionHubSpeedIndicator = head:FindFirstChild("FictionHubSpeedIndicator")
        if fictionHubSpeedIndicator then
            fictionHubSpeedIndicator:Destroy()
        end
        local billboardGui = Instance.new("BillboardGui", head)
        billboardGui.Name = "FictionHubSpeedIndicator"
        billboardGui.Size = UDim2.new(0, 240, 0, 46)
        billboardGui.StudsOffset = newVector3(0, 2.35, 0)
        billboardGui.AlwaysOnTop = true
        billboardGui.LightInfluence = 0
        speedLabel = Instance.new("TextLabel", billboardGui)
        speedLabel.Name = "Speed"
        speedLabel.Size = UDim2.new(1, 0, 0, 24)
        speedLabel.Position = UDim2.new(0, 0, 0, 0)
        speedLabel.BackgroundTransparency = 1
        speedLabel.Text = "Spd: 0.0"
        speedLabel.TextColor3 = Color3.fromRGB(85, 255, 85)
        speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        speedLabel.TextStrokeTransparency = 0.08
        speedLabel.Font = Enum.Font.GothamBlack
        speedLabel.TextSize = 18
        speedLabel.TextXAlignment = Enum.TextXAlignment.Center
        speedLabel.ZIndex = 10
    end
    do
        local clone = nil
        startUnwalk = function()
            local character = localPlayer.Character
            if not character then
                return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                for _, deltaTime in ipairs(humanoid:GetPlayingAnimationTracks()) do
                    pcall(function()
                        deltaTime:Stop()
                    end)
                end
            end
            local animate = character:FindFirstChild("Animate")
            if animate then
                clone = animate:Clone()
                animate:Destroy()
            end
        end
        stopUnwalk = function()
            local character = localPlayer.Character
            if character then
                if not character:FindFirstChild("Animate") then
                    local starterCharacterScripts = game:GetService("StarterPlayer")
                        :FindFirstChildOfClass("StarterCharacterScripts")
                    starterCharacterScripts = starterCharacterScripts
                        and starterCharacterScripts:FindFirstChild("Animate")
                    if starterCharacterScripts then
                        starterCharacterScripts:Clone().Parent = character
                    elseif clone then
                        clone:Clone().Parent = character
                    end
                end
            end
            clone = nil
        end
    end
    refreshSpeedModeLabel = function()
        if modeValLbl then
            if laggerCarryToggled then
                modeValLbl.Text = "Lagger Carry"
            elseif laggerToggled then
                modeValLbl.Text = "Lagger"
            elseif speedMode then
                modeValLbl.Text = "Carry"
            else
                modeValLbl.Text = "Normal"
            end
        end
        if laggerCarryToggled then
            _G.AceCurrentSpeedMode = "Lagger Carry"
        elseif laggerToggled then
            _G.AceCurrentSpeedMode = "Lagger"
        elseif speedMode then
            _G.AceCurrentSpeedMode = "Carry"
        else
            _G.AceCurrentSpeedMode = "Normal"
        end
        if setCarryModeVisual then
            setCarryModeVisual(speedMode)
        end
        if setLaggerModeVisual then
            setLaggerModeVisual(laggerToggled)
        end
        if setLaggerCarryVisual then
            setLaggerCarryVisual(laggerCarryToggled)
        end
        if carryController then
            carryController.speedToggled = speedMode
            if laggerCarryToggled then
                carryController:setLaggerMode(2)
            elseif laggerToggled then
                carryController:setLaggerMode(1)
            else
                carryController:setLaggerMode(0)
            end
        end
    end
    resetMovementState = function()
        refreshSpeedModeLabel()
        if mobSetCarry then
            mobSetCarry(speedMode)
        end
        if setLaggerModeVisual then
            setLaggerModeVisual(laggerToggled)
        end
        if setLaggerCarryVisual then
            setLaggerCarryVisual(laggerCarryToggled)
        end
        if carryController then
            carryController.speedToggled = speedMode
            if laggerCarryToggled then
                carryController:setLaggerMode(2)
            elseif laggerToggled then
                carryController:setLaggerMode(1)
            else
                carryController:setLaggerMode(0)
            end
        end
    end
    toggleCarryMode = function()
        if laggerToggled or laggerCarryToggled then
            laggerToggled = false
            laggerCarryToggled = false
            speedMode = true
        else
            speedMode = not speedMode
        end
        resetMovementState()
    end
    toggleLaggerMode = function()
        if laggerCarryToggled then
            laggerCarryToggled = false
        end
        speedMode = false
        laggerToggled = not laggerToggled
        resetMovementState()
    end
    toggleLaggerCarryMode = function()
        if laggerToggled then
            laggerToggled = false
        end
        speedMode = false
        laggerCarryToggled = not laggerCarryToggled
        resetMovementState()
    end
    toggleLaggerCycle = function()
        if speedMode then
            speedMode = false
            laggerToggled = true
            laggerCarryToggled = false
        elseif laggerToggled then
            speedMode = false
            laggerToggled = false
            laggerCarryToggled = true
        else
            speedMode = true
            laggerToggled = false
            laggerCarryToggled = false
        end
        resetMovementState()
    end
    stopAutoLeft = function()
        if alConn then
            alConn:Disconnect()
            alConn = nil
        end
        alPhase = 1
        local character = localPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:Move(zeroVector, false)
            end
        end
        if autoLeftSetVisual then
            autoLeftSetVisual(false)
        end
        if mobSetAutoLeft then
            mobSetAutoLeft(false)
        end
        _unsuppressBodyLock(true)
    end
    startAutoLeft = function()
        if not _G.AmbitiousSafeModeTryStart() then
            autoLeftEnabled = false
            if autoLeftSetVisual then
                autoLeftSetVisual(false)
            end
            return
        end
        if autoRightEnabled then
            autoRightEnabled = false
            stopAutoRight()
            if autoRightSetVisual then
                autoRightSetVisual(false)
            end
            if mobSetAutoRight then
                mobSetAutoRight(false)
            end
        end
        disableAllAimbots()
        _suppressBodyLock()
        if alConn then
            alConn:Disconnect()
        end
        alPhase = 1
        alConn = RunService.Heartbeat:Connect(function()
            if not autoLeftEnabled then
                return
            end
            local character = localPlayer.Character
            if not character then
                return
            end
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoidRootPart or not humanoid then
                return
            end
            local object = NS
            if alPhase == 1 then
                local position = humanoidRootPart.Position
                if (newVector3(AP.L1.X, humanoidRootPart.Position.Y, AP.L1.Z) - position).Magnitude < 1 then
                    alPhase = 2
                    local vector = AP.L2 - humanoidRootPart.Position
                    local unit = newVector3(vector.X, 0, vector.Z).Unit
                    humanoid:Move(unit, false)
                    humanoidRootPart.AssemblyLinearVelocity =
                        newVector3(unit.X * object, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * object)
                    return
                end
                local vector = AP.L1 - humanoidRootPart.Position
                local unit = newVector3(vector.X, 0, vector.Z).Unit
                humanoid:Move(unit, false)
                humanoidRootPart.AssemblyLinearVelocity =
                    newVector3(unit.X * object, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * object)
            elseif alPhase == 2 then
                local position = humanoidRootPart.Position
                if (newVector3(AP.L2.X, humanoidRootPart.Position.Y, AP.L2.Z) - position).Magnitude < 1 then
                    humanoid:Move(zeroVector, false)
                    humanoidRootPart.AssemblyLinearVelocity = zeroVector
                    autoLeftEnabled = false
                    if alConn then
                        alConn:Disconnect()
                        alConn = nil
                    end
                    alPhase = 1
                    if autoLeftSetVisual then
                        autoLeftSetVisual(false)
                    end
                    if mobSetAutoLeft then
                        mobSetAutoLeft(false)
                    end
                    _unsuppressBodyLock(true)
                    local vector = newVector3(AP.L_FACE.X, humanoidRootPart.Position.Y, AP.L_FACE.Z)
                    if (vector - humanoidRootPart.Position).Magnitude > 0.01 then
                        humanoidRootPart.CFrame = newCFrame(humanoidRootPart.Position, vector)
                    end
                    return
                end
                local vector = AP.L2 - humanoidRootPart.Position
                local unit = newVector3(vector.X, 0, vector.Z).Unit
                humanoid:Move(unit, false)
                humanoidRootPart.AssemblyLinearVelocity =
                    newVector3(unit.X * object, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * object)
            end
        end)
    end
    stopAutoRight = function()
        if arConn then
            arConn:Disconnect()
            arConn = nil
        end
        arPhase = 1
        local character = localPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:Move(zeroVector, false)
            end
        end
        if autoRightSetVisual then
            autoRightSetVisual(false)
        end
        if mobSetAutoRight then
            mobSetAutoRight(false)
        end
        _unsuppressBodyLock(true)
    end
    startAutoRight = function()
        if not _G.AmbitiousSafeModeTryStart() then
            autoRightEnabled = false
            if autoRightSetVisual then
                autoRightSetVisual(false)
            end
            return
        end
        if autoLeftEnabled then
            autoLeftEnabled = false
            stopAutoLeft()
            if autoLeftSetVisual then
                autoLeftSetVisual(false)
            end
            if mobSetAutoLeft then
                mobSetAutoLeft(false)
            end
        end
        disableAllAimbots()
        _suppressBodyLock()
        if arConn then
            arConn:Disconnect()
        end
        arPhase = 1
        arConn = RunService.Heartbeat:Connect(function()
            if not autoRightEnabled then
                return
            end
            local character = localPlayer.Character
            if not character then
                return
            end
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoidRootPart or not humanoid then
                return
            end
            local object = NS
            if arPhase == 1 then
                local position = humanoidRootPart.Position
                if (newVector3(AP.R1.X, humanoidRootPart.Position.Y, AP.R1.Z) - position).Magnitude < 1 then
                    arPhase = 2
                    local vector = AP.R2 - humanoidRootPart.Position
                    local unit = newVector3(vector.X, 0, vector.Z).Unit
                    humanoid:Move(unit, false)
                    humanoidRootPart.AssemblyLinearVelocity =
                        newVector3(unit.X * object, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * object)
                    return
                end
                local vector = AP.R1 - humanoidRootPart.Position
                local unit = newVector3(vector.X, 0, vector.Z).Unit
                humanoid:Move(unit, false)
                humanoidRootPart.AssemblyLinearVelocity =
                    newVector3(unit.X * object, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * object)
            elseif arPhase == 2 then
                local position = humanoidRootPart.Position
                if (newVector3(AP.R2.X, humanoidRootPart.Position.Y, AP.R2.Z) - position).Magnitude < 1 then
                    humanoid:Move(zeroVector, false)
                    humanoidRootPart.AssemblyLinearVelocity = zeroVector
                    autoRightEnabled = false
                    if arConn then
                        arConn:Disconnect()
                        arConn = nil
                    end
                    arPhase = 1
                    if autoRightSetVisual then
                        autoRightSetVisual(false)
                    end
                    if mobSetAutoRight then
                        mobSetAutoRight(false)
                    end
                    _unsuppressBodyLock(true)
                    local vector = newVector3(AP.R_FACE.X, humanoidRootPart.Position.Y, AP.R_FACE.Z)
                    if (vector - humanoidRootPart.Position).Magnitude > 0.01 then
                        humanoidRootPart.CFrame = newCFrame(humanoidRootPart.Position, vector)
                    end
                    return
                end
                local vector = AP.R2 - humanoidRootPart.Position
                local unit = newVector3(vector.X, 0, vector.Z).Unit
                humanoid:Move(unit, false)
                humanoidRootPart.AssemblyLinearVelocity =
                    newVector3(unit.X * object, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * object)
            end
        end)
    end
    getClosestTarget = function()
        local character = localPlayer.Character
        if not character then
            return nil
        end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil
        end
        local position = humanoidRootPart.Position
        local playersCached = getPlayersCached()
        local object1342 = huge
        local object1343 = nil
        for i = 1, #playersCached do
            local player = playersCached[i]
            if player ~= localPlayer then
                local character2 = player.Character
                if character2 then
                    local rootPart = character2:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local humanoid = character2:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            local value = rootPart.Position.X - position.X
                            local value1350 = rootPart.Position.Y - position.Y
                            local value1351 = rootPart.Position.Z - position.Z
                            local object13421307 = value * value + value1350 * value1350 + value1351 * value1351
                            if object13421307 < object1342 then
                                object1342 = object13421307
                                object1343 = rootPart
                            end
                        end
                    end
                end
            end
        end
        return object1343
    end
    trySwing = function()
        pcall(function()
            local character = localPlayer.Character
            if not character then
                return
            end
            local tool = character:FindFirstChildOfClass("Tool")
            if tool and not isBatTool(tool) then
                return
            end
            local bat = findBat()
            if bat then
                if bat.Parent ~= character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        pcall(function()
                            humanoid:EquipTool(bat)
                        end)
                    end
                end
                pcall(function()
                    bat:Activate()
                end)
            end
        end)
    end
    stopAimbotAdapt = function()
        if _aimbotConn then
            pcall(function()
                _aimbotConn:Disconnect()
            end)
            _aimbotConn = nil
        end
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = _prevAutoRotate == nil and true or _prevAutoRotate
            humanoid.PlatformStand = false
            pcall(function()
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end
        if humanoidRootPart then
            humanoidRootPart.AssemblyLinearVelocity = newVector3(0, -0.1, 0)
            humanoidRootPart.AssemblyAngularVelocity = zeroVector
        end
        _prevAutoRotate = nil
        lastMoveDir = zeroVector
        _unsuppressBodyLock(true)
    end
    startAimbotAdapt = function()
        if _aimbotConn then
            return
        end
        _suppressBodyLock()
        local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if _prevAutoRotate == nil then
                _prevAutoRotate = humanoid.AutoRotate
            end
            humanoid.AutoRotate = false
        end
        _aimbotConn = RunService.RenderStepped:Connect(function()
            if not autoBatEnabled then
                return
            end
            local character = localPlayer.Character
            if not character then
                return
            end
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid2 = character:FindFirstChildOfClass("Humanoid")
            if not rootPart or not humanoid2 then
                return
            end
            if not character:FindFirstChildOfClass("Tool") then
                local bat = findBat()
                if bat then
                    pcall(function()
                        humanoid2:EquipTool(bat)
                    end)
                end
            end
            local rootPart1370 = getClosestTarget()
            if not rootPart1370 then
                return
            end
            local assemblyLinearVelocity = rootPart1370.AssemblyLinearVelocity
            local position = rootPart.Position
            local position2 = rootPart1370.Position
            local vector = position2 + assemblyLinearVelocity * 0.14 + rootPart1370.CFrame.LookVector * 0.3 - position
            local vector1375 = newVector3(vector.X, 0, vector.Z)
            local unit
            if 0 < vector1375.Magnitude then
                unit = vector1375.Unit
            else
                unit = newVector3(0, 0, 0)
            end
            local value1378 = (position2.Y + 3.7 - position.Y) * 19.5 + assemblyLinearVelocity.Y * 0.8
            local value13781333
            if humanoid2.FloorMaterial == Enum.Material.Air then
                value13781333 = value1378
            else
                value13781333 = math.max(value1378, 13)
            end
            local value1379 = unit.Z * BAT_AIMBOT_SPEED
            rootPart.AssemblyLinearVelocity = rootPart.AssemblyLinearVelocity:Lerp(
                newVector3(unit.X * BAT_AIMBOT_SPEED, clamp(value13781333, -70, 110), value1379),
                0.2
            )
            local value1380 = position2
                + assemblyLinearVelocity * clamp(assemblyLinearVelocity.Magnitude / 150, 0.05, 0.2)
            if (value1380 - position).Magnitude > 0.1 then
                local object = lookAtCFrame(position, value1380)
                local object1382, object1383, object1384 = (rootPart.CFrame:Inverse() * object):ToEulerAnglesXYZ()
                rootPart.AssemblyAngularVelocity = rootPart.CFrame:VectorToWorldSpace(
                    newVector3(
                        clamp(object1382, -2.5, 2.5) * 42,
                        clamp(object1383, -2.5, 2.5) * 42,
                        clamp(object1384, -2.5, 2.5) * 42
                    )
                )
            end
            if (rootPart.Position - rootPart1370.Position).Magnitude <= 8 then
                trySwing()
            end
        end)
    end
    disableAutoBat = function()
        autoBatEnabled = false
        if autoBatSetVisual then
            autoBatSetVisual(false)
        end
        if mobSetAutoBat then
            mobSetAutoBat(false)
        end
        stopAimbotAdapt()
    end
    enableAutoBat = function()
        if not _G.AmbitiousSafeModeTryStart() then
            autoBatEnabled = false
            if autoBatSetVisual then
                autoBatSetVisual(false)
            end
            return
        end
        if autoLeftEnabled then
            autoLeftEnabled = false
            if autoLeftSetVisual then
                autoLeftSetVisual(false)
            end
            stopAutoLeft()
        end
        if autoRightEnabled then
            autoRightEnabled = false
            if autoRightSetVisual then
                autoRightSetVisual(false)
            end
            stopAutoRight()
        end
        if batDesyncTpEnabled then
            toggleBatDesyncTp()
        end
        if autoBatV2Enabled then
            disableBatV2()
        end
        autoBatEnabled = true
        if autoBatSetVisual then
            autoBatSetVisual(true)
        end
        if mobSetAutoBat then
            mobSetAutoBat(true)
        end
        startAimbotAdapt()
    end
    BAT_V2_SPEED = tonumber(BAT_V2_SPEED) or tonumber(_G.AceAntiBypassAimbotSpeed) or 55
    _G.AceAntiBypassAimbotSpeed = BAT_V2_SPEED
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
        batBypass.Z = batBypass.Z
            or {
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
        batBypass.ZCFG = batBypass.ZCFG
            or {
                FOLLOW_SPEED = BAT_V2_SPEED,
                ACTIVATE_DISTANCE = BAT_V2_HIT_DIST,
                MIN_FOLLOW_DISTANCE = 1,
                PREDICTION_TIME = 0.22,
                PREDICT_AHEAD = BAT_V2_LEAD_STUDS,
                MAX_VELOCITY_CHANGE = 150,
                VELOCITY_SMOOTHING = 0.2,
                MAX_HORIZONTAL_VELOCITY = 80,
                SERVER_TICKRATE = 0.016666666666666666,
                MIN_PING_COMPENSATION = 0.03,
                MAX_PING_COMPENSATION = 0.25,
                ACCELERATION_PREDICTION_WEIGHT = 0.3,
                DIRECTION_CHANGE_DETECTION_TIME = 0.12,
                QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
                GRAVITY = 196.2,
                AIR_CONTROL_FACTOR = 0.8,
                MIN_AIRBORNE_TIME = 0.08,
            }
        applyBatV2VersionProfile = function()
            local cfg = batBypass.ZCFG
            if not cfg then return end
            local profile = batV2Version == "Version 1"
                and {PREDICTION_TIME = 0.14, PREDICT_AHEAD = 1.5, MAX_VELOCITY_CHANGE = 110, VELOCITY_SMOOTHING = 0.16}
                or {PREDICTION_TIME = 0.22, PREDICT_AHEAD = 3, MAX_VELOCITY_CHANGE = 150, VELOCITY_SMOOTHING = 0.2}
            for key, value in pairs(profile) do cfg[key] = value end
            cfg.FOLLOW_SPEED = math.clamp(tonumber(BAT_V2_SPEED) or 55, 1, 500)
            cfg.ACTIVATE_DISTANCE = math.clamp(tonumber(BAT_V2_HIT_DIST) or 13, 1, 100)
        end
        applyBatV2VersionProfile()
        local function averageVectors(vectors)
            if #vectors == 0 then
                return Vector3.zero
            end
            local sum = Vector3.zero
            for _, entry in ipairs(vectors) do
                sum += entry
            end
            return sum / #vectors
        end
        local function pushBounded(history, entry, maxEntries)
            table.insert(history, entry)
            if #history > maxEntries then
                table.remove(history, 1)
            end
        end
        batBypass.FindBat = function()
            local character = localPlayer.Character
            if not character then
                return nil
            end
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                local lowercaseText = tool.Name:lower()
                if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
                    return tool
                end
            end
            local backpack = localPlayer:FindFirstChildOfClass("Backpack")
            if backpack then
                for _, child in ipairs(backpack:GetChildren()) do
                    if child:IsA("Tool") then
                        local lowercaseText = child.Name:lower()
                        if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
                            return child
                        end
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
            local closestDistance = math.huge
            local closestPlayer = nil
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoidRootPart and humanoid and humanoid.Health > 0 then
                        local magnitude = (rootPart.Position - humanoidRootPart.Position).Magnitude
                        if magnitude < closestDistance then
                            closestDistance = magnitude
                            closestPlayer = player
                        end
                    end
                end
            end
            return closestPlayer
        end
        local function applyAngularAim(rootPart, direction)
            if direction.Magnitude < 0.01 then
                return
            end
            local crossVector = rootPart.CFrame.LookVector:Cross(direction.Unit)
            local angle = math.asin(math.clamp(crossVector.Magnitude, -1, 1))
            rootPart.AssemblyAngularVelocity = crossVector.Magnitude > 0.1 and crossVector.Unit * angle * 80
                or Vector3.zero
        end
        local function updatePing()
            local ok, result = pcall(function()
                return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            local z = batBypass.Z
            if ok and type(result) == "number" then
                z.realPingMs = math.floor(result)
            end
            z.currentPing = math.clamp(
                z.realPingMs / 1000,
                batBypass.ZCFG.MIN_PING_COMPENSATION,
                batBypass.ZCFG.MAX_PING_COMPENSATION
            )
        end
        batBypass.PingLoopStarted = batBypass.PingLoopStarted or false
        if not batBypass.PingLoopStarted then
            batBypass.PingLoopStarted = true
            task.spawn(function()
                while true do
                    pcall(updatePing)
                    task.wait(0.5)
                end
            end)
        end
        batBypass.StartBodyLock = function() end
        batBypass.StopBodyLock = function() end
        batBypass.Stop = function()
            local z = batBypass.Z
            batBypass.Enabled = false
            if batBypass.Connection then
                batBypass.Connection:Disconnect()
                batBypass.Connection = nil
            end
            local character = localPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            character = character and character:FindFirstChild("HumanoidRootPart")
            if humanoid then
                humanoid.AutoRotate = true
            end
            if character then
                character.AssemblyAngularVelocity = Vector3.zero
            end
            resetPredictionState()
            z.lastActivationTime = 0
        end
        batBypass.Start = function()
            if batBypass.Connection then
                return
            end
            local character = localPlayer.Character
            local humanoid1387 = character and character:FindFirstChildOfClass("Humanoid")
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if not humanoid1387 or not rootPart then
                return
            end
            batBypass.Enabled = true
            humanoid1387.AutoRotate = false
            local tool = batBypass.FindBat()
            if tool and tool.Parent ~= character then
                pcall(function()
                    humanoid1387:EquipTool(tool)
                end)
            end
            batBypass.Connection = RunService.RenderStepped:Connect(function(deltaTime)
                if not batBypass.Enabled then
                    batBypass.Stop()
                    return
                end
                local z = batBypass.Z
                local zcfg = batBypass.ZCFG
                if _G.AceGetAntiBypassAimbotSpeed then
                    zcfg.FOLLOW_SPEED = _G.AceGetAntiBypassAimbotSpeed()
                end
                local character2 = localPlayer.Character
                local rootPart1394 = character2 and character2:FindFirstChild("HumanoidRootPart")
                local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")
                if not rootPart1394 or not humanoid or humanoid.Health <= 0 then
                    return
                end
                humanoid.AutoRotate = false
                rootPart = rootPart1394
                humanoid1387 = humanoid
                tool = character2:FindFirstChildOfClass("Tool") or batBypass.FindBat()
                if tool and tool.Parent ~= character2 then
                    pcall(humanoid.EquipTool, humanoid, tool)
                end
                z.targetPlayer = findClosestPlayer(rootPart)
                local character3 = z.targetPlayer and z.targetPlayer.Character
                local rootPart1442 = character3 and character3:FindFirstChild("HumanoidRootPart")
                character3 = character3 and character3:FindFirstChildOfClass("Humanoid")
                if not rootPart1442 or not character3 or character3.Health <= 0 then
                    resetPredictionState()
                    return
                end
                local position = rootPart1442.Position
                local sampleDeltaTime = math.max(deltaTime, 0.0041666666666666666)
                if z.lastTargetPos then
                    local targetVelocity = (position - z.lastTargetPos) / sampleDeltaTime
                    local vector = targetVelocity - z.targetVelocity
                    if zcfg.MAX_VELOCITY_CHANGE < vector.Magnitude then
                        targetVelocity = z.targetVelocity + vector.Unit * zcfg.MAX_VELOCITY_CHANGE
                    end
                    local vector3 = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
                    if vector3.Magnitude > zcfg.MAX_HORIZONTAL_VELOCITY then
                        local vector = vector3.Unit * zcfg.MAX_HORIZONTAL_VELOCITY
                        targetVelocity = Vector3.new(vector.X, targetVelocity.Y, vector.Z)
                    end
                    pushBounded(z.accelerationHistory, (targetVelocity - z.targetVelocity) / sampleDeltaTime, 4)
                    pushBounded(z.velocityHistory, targetVelocity, 8)
                    z.targetVelocity = targetVelocity
                    z.smoothedVelocity = z.smoothedVelocity:Lerp(targetVelocity, zcfg.VELOCITY_SMOOTHING)
                end
                z.lastTargetPos = position
                local isAirborne = character3.FloorMaterial == Enum.Material.Air
                z.airborneTime = isAirborne and z.airborneTime + sampleDeltaTime or 0
                if isAirborne and z.airborneTime >= zcfg.MIN_AIRBORNE_TIME then
                    pushBounded(z.aerialVelocityHistory, z.targetVelocity, 6)
                elseif not isAirborne then
                    z.aerialVelocityHistory = {}
                end
                local smoothedVelocity = z.smoothedVelocity
                if isAirborne and #z.aerialVelocityHistory > 0 then
                    local vector = averageVectors(z.aerialVelocityHistory)
                    smoothedVelocity = Vector3.new(vector.X, z.targetVelocity.Y, vector.Z) * zcfg.AIR_CONTROL_FACTOR
                end
                local changedDirectionQuickly = false
                local vector3 = Vector3.new(z.targetVelocity.X, 0, z.targetVelocity.Z)
                if vector3.Magnitude > 5 then
                    local unit = vector3.Unit
                    if z.previousDirection and z.previousDirection:Dot(unit) < 0.5 then
                        local lastDirectionChangeTime = z.lastDirectionChangeTime
                        changedDirectionQuickly = tick() - lastDirectionChangeTime
                            < zcfg.DIRECTION_CHANGE_DETECTION_TIME
                        z.lastDirectionChangeTime = tick()
                    end
                    z.previousDirection = unit
                end
                local predictionTime = z.currentPing + zcfg.SERVER_TICKRATE
                if changedDirectionQuickly then
                    predictionTime *= zcfg.QUICK_DIRECTION_CHANGE_MULTIPLIER
                end
                local accelerationPredictionWeight = zcfg.ACCELERATION_PREDICTION_WEIGHT
                local predictedPosition = position
                    + smoothedVelocity * predictionTime
                    + averageVectors(z.accelerationHistory)
                        * accelerationPredictionWeight
                        * predictionTime
                        * predictionTime
                        * 0.5
                local leadTime = zcfg.PREDICTION_TIME * 1.1
                local leadPosition
                if isAirborne then
                    leadPosition = predictedPosition
                        + smoothedVelocity * leadTime
                        + Vector3.new(0, -0.5 * zcfg.GRAVITY * leadTime * leadTime, 0)
                else
                    leadPosition = predictedPosition + smoothedVelocity * leadTime
                end
                local vector4 = Vector3.new(smoothedVelocity.X, 0, smoothedVelocity.Z)
                if vector4.Magnitude > 1 then
                    leadPosition += vector4.Unit * zcfg.PREDICT_AHEAD
                end
                local targetDirection = leadPosition - rootPart.Position
                applyAngularAim(rootPart, targetDirection)
                local withinActivationRange = (position - rootPart.Position).Magnitude <= zcfg.ACTIVATE_DISTANCE
                if withinActivationRange then
                    local lastActivationTime = z.lastActivationTime
                    withinActivationRange = tick() - lastActivationTime >= 0.3
                end
                if withinActivationRange then
                    if tool then
                        pcall(tool.Activate, tool)
                    end
                    z.lastActivationTime = tick()
                end
                if zcfg.MIN_FOLLOW_DISTANCE < targetDirection.Magnitude then
                    rootPart.AssemblyLinearVelocity = targetDirection.Unit * zcfg.FOLLOW_SPEED
                else
                    rootPart.AssemblyLinearVelocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y * 0.5, 0)
                end
            end)
        end
        batBypass.Toggle = function()
            if batBypass.Enabled then
                batBypass.Stop()
            else
                batBypass.Start()
            end
        end
    end
    local desyncLoopRunning, networkSpamThread, startCharacterRecoveryLoop, stopCharacterRecoveryLoop, setOutgoingBandwidthLimit, sendBlockListPayload
    do
        local function saveAimbotSettings()
            if type(saveAllSettings) == "function" then
                pcall(saveAllSettings)
            end
        end
        local function refreshSpeedModeLabel()
            if laggerCarryToggled then
                return "Lagger Carry"
            end
            if laggerToggled then
                return "Lagger"
            end
            if speedMode then
                return "Carry"
            end
            return "Normal"
        end
        _G.AceGetAntiBypassAimbotSpeed = function()
            local speedModeName = refreshSpeedModeLabel()
            if speedModeName == "Lagger" or speedModeName == "Lagger Carry" then
                return tonumber(_G.AceAntiBypassLaggerAimbotSpeed) or 40
            end
            return tonumber(_G.AceAntiBypassAimbotSpeed) or 60
        end
        _G.AceRefreshAimbotVisual = function()
            if _G.AceAimbotSetVisual then
                _G.AceAimbotSetVisual(_G.AceAntiBypassAimbotOn == true)
            end
        end
        _G.AceStartAntiBypassAimbot = function()
            if _G.AceSafeModeTryStart and not _G.AceSafeModeTryStart() then
                return false
            end
            if _G.AceStopAutoTPForAction then
                _G.AceStopAutoTPForAction()
            end
            if _G.AceStopNormalAimbot then
                _G.AceStopNormalAimbot()
            end
            selectedAimbotMode = "Bat Bypass"
            _G.AceAntiBypassAimbotOn = true
            snowVS.BatBypass.ZCFG.FOLLOW_SPEED = _G.AceGetAntiBypassAimbotSpeed()
            snowVS.BatBypass.Start()
            if _G.AceRefreshAimbotVisual then
                _G.AceRefreshAimbotVisual()
            end
            saveAimbotSettings()
            return true
        end
        _G.AceStopAntiBypassAimbot = function(updateVisual)
            snowVS.BatBypass.Stop()
            _G.AceAntiBypassAimbotOn = false
            if updateVisual ~= false and _G.AceRefreshAimbotVisual then
                _G.AceRefreshAimbotVisual()
            end
            saveAimbotSettings()
        end
        _G.AceToggleSelectedAimbot = function()
            if selectedAimbotMode == "Bat Bypass" then
                if _G.AceAntiBypassAimbotOn then
                    _G.AceStopAntiBypassAimbot()
                else
                    _G.AceStartAntiBypassAimbot()
                end
            end
            if _G.AceRefreshAimbotVisual then
                _G.AceRefreshAimbotVisual()
            end
            saveAimbotSettings()
        end
    end
    do
        local object, object1476
        _G.AceAntiBypassStart = _G.AceStartAntiBypassAimbot
        _G.AceAntiBypassStop = _G.AceStopAntiBypassAimbot
        enableBatV2 = function()
            selectedAimbotMode = "Bat Bypass"
            if _G.AceStartAntiBypassAimbot() ~= false then
                if applyBatV2VersionProfile then pcall(applyBatV2VersionProfile) end
                autoBatV2Enabled = true
                if autoBatV2SetVisual then
                    autoBatV2SetVisual(true)
                end
                if batV2FloatingButton then
                    local frame = batV2FloatingButton
                    if frame then
                        paintFloatingBtn(frame, true)
                    end
                end
            end
        end
        disableBatV2 = function()
            _G.AceStopAntiBypassAimbot()
            autoBatV2Enabled = false
            if autoBatV2SetVisual then
                autoBatV2SetVisual(false)
            end
            if batV2FloatingButton then
                local frame = batV2FloatingButton
                if frame then
                    paintFloatingBtn(frame, false)
                end
            end
        end
        toggleBatV2 = function()
            if autoBatV2Enabled then
                disableBatV2()
            else
                enableBatV2()
            end
        end
        _G.AceAntiBypassSaveToConfig = function(value)
            local vector = value or {}
            vector.selectedAimbotMode = selectedAimbotMode
            vector.ANTI_BYPASS_AIMBOT_SPEED = _G.AceAntiBypassAimbotSpeed
            vector.ANTI_BYPASS_LAGGER_AIMBOT_SPEED = _G.AceAntiBypassLaggerAimbotSpeed
            vector.antiBypassAimbotEnabled = _G.AceAntiBypassAimbotOn == true
            return vector
        end
        _G.AceAntiBypassLoadFromConfig = function(vector)
            if type(vector) ~= "table" then
                return
            end
            selectedAimbotMode = vector.selectedAimbotMode or selectedAimbotMode
            if selectedAimbotMode == "Anti Bypass" then
                selectedAimbotMode = "Bat Bypass"
            end
            if selectedAimbotMode ~= "Bat Bypass" then
                selectedAimbotMode = "Normal"
            end
            _G.AceAntiBypassAimbotSpeed = tonumber(vector.ANTI_BYPASS_AIMBOT_SPEED) or _G.AceAntiBypassAimbotSpeed or 60
            if
                vector.ANTI_BYPASS_LAGGER_AIMBOT_SPEED == nil
                or tonumber(vector.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) == 58
            then
                _G.AceAntiBypassLaggerAimbotSpeed = 40
            else
                _G.AceAntiBypassLaggerAimbotSpeed = tonumber(vector.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) or 40
            end
            _G.AceAntiBypassAimbotOn = vector.antiBypassAimbotEnabled == true
        end
        batDesyncTpEnabled = false
        batDesyncTpConn = nil
        batDesyncTpSetVisual = nil
        isActive = false
        _G.AlvaroTP = _G.AlvaroTP
            or {
                conn = nil,
                on = false,
                h = nil,
                hrp = nil,
                hittingCooldown = false,
                _charConn = nil,
            }
        desyncLoopRunning = false
        do
            local recoveryThread = nil
            networkSpamThread = nil
            object = nil
            object1476 = nil
            startCharacterRecoveryLoop = function()
                if recoveryThread then
                    return
                end
                recoveryThread = task.spawn(function()
                    while batDesyncTpEnabled do
                        pcall(function()
                            local character = localPlayer.Character
                            if not character then
                                task.wait(0.1)
                                return
                            end
                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            if humanoid then
                                if humanoid.Health <= 0 then
                                    humanoid.Health = humanoid.MaxHealth
                                end
                                if humanoid.PlatformStand then
                                    humanoid.PlatformStand = false
                                end
                                if humanoid.Sit then
                                    humanoid.Sit = false
                                end
                                local state = humanoid:GetState()
                                if
                                    state == Enum.HumanoidStateType.Physics
                                    or state == Enum.HumanoidStateType.Ragdoll
                                    or state == Enum.HumanoidStateType.FallingDown
                                then
                                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                                end
                            end
                            if humanoidRootPart and sethiddenproperty then
                                pcall(sethiddenproperty, humanoidRootPart, "PhysicsRepRootPart", nil)
                            end
                            if character then
                                for _, descendant in ipairs(character:GetDescendants()) do
                                    if descendant:IsA("BasePart") then
                                        descendant.CanCollide = false
                                    end
                                end
                            end
                        end)
                        task.wait(0.05)
                    end
                    recoveryThread = nil
                end)
            end
            stopCharacterRecoveryLoop = function()
                if recoveryThread then
                    pcall(task.cancel, recoveryThread)
                    recoveryThread = nil
                end
            end
        end
        do
            local function createNestedPayload()
                if object then
                    return object
                end
                local payloadRoot = {}
                local payloadCursor = payloadRoot
                for i = 1, 12 do
                    local nestedTable = {}
                    payloadCursor[1] = nestedTable
                    payloadCursor = nestedTable
                end
                object = payloadRoot
                return payloadRoot
            end
            local function createBlockListPayload()
                if object1476 then
                    return object1476
                end
                local nestedPayload = createNestedPayload()
                local blockListPayload = table.create(800)
                for i = 1, 300 do
                    blockListPayload[i] = nestedPayload
                end
                object1476 = blockListPayload
                return blockListPayload
            end
            setOutgoingBandwidthLimit = function(limit)
                pcall(function()
                    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(limit)
                end)
            end
            sendBlockListPayload = function()
                pcall(function()
                    local playersService = game:GetService("Players")
                    if playersService and playersService:FindFirstChild("SetPlayerBlockList") then
                        playersService.SetPlayerBlockList:FireServer(createBlockListPayload())
                    end
                end)
            end
        end
    end
    do
        local function startNetworkSpamLoop()
            if not networkSpamThread then
                networkSpamThread = task.spawn(function()
                    task.wait(0.05)
                    while batDesyncTpEnabled do
                        setOutgoingBandwidthLimit(12000)
                        sendBlockListPayload()
                        task.wait(0.15)
                    end
                    setOutgoingBandwidthLimit(0)
                    networkSpamThread = nil
                end)
                return
            end
            return
        end
        local function stopNetworkSpamLoop()
            if networkSpamThread then
                pcall(task.cancel, networkSpamThread)
                networkSpamThread = nil
            end
            setOutgoingBandwidthLimit(0)
        end
        local function findAndEquipBat()
            local character = localPlayer.Character
            if not character then
                return nil
            end
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Tool") then
                    local lowercaseText = child.Name:lower()
                    if lowercaseText:find("bat") or lowercaseText:find("slap") then
                        return child
                    end
                end
            end
            local backpack = localPlayer:FindFirstChild("Backpack")
            if not backpack then
                return nil
            end
            for _, child in ipairs(backpack:GetChildren()) do
                if child:IsA("Tool") then
                    local lowercaseText = child.Name:lower()
                    if lowercaseText:find("bat") or lowercaseText:find("slap") then
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            pcall(function()
                                humanoid:EquipTool(child)
                            end)
                        end
                        return child
                    end
                end
            end
            return nil
        end
        local function tryHitBatDesync()
            if desyncLoopRunning then
                return
            end
            desyncLoopRunning = true
            pcall(function()
                local bat = findAndEquipBat()
                if not bat then
                    return
                end
                bat:Activate()
                local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")
                if remoteEvent then
                    remoteEvent:FireServer()
                end
            end)
            task.delay(0.08, function()
                desyncLoopRunning = false
            end)
        end
        local function findNearestOpponent(rootPart)
            local huge2 = math.huge
            local closestPlayer = nil
            for _, player in ipairs(Players:GetPlayers()) do
                local character = player ~= localPlayer and player.Character
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                character = character and character:FindFirstChildOfClass("Humanoid")
                if humanoidRootPart and character and character.Health > 0 then
                    local magnitude = (rootPart.Position - humanoidRootPart.Position).Magnitude
                    if magnitude < huge2 then
                        huge2 = magnitude
                        closestPlayer = player
                    end
                end
            end
            return closestPlayer, huge2
        end
        local function teleportToTarget(callback, rootPart)
            pcall(function()
                if callback.SetNetworkOwner then
                    callback:SetNetworkOwner(nil)
                end
            end)
            task.wait()
            callback.CFrame = newCFrame(rootPart.Position + newVector3(0, 2.5, 0))
            callback.AssemblyLinearVelocity = rootPart.AssemblyLinearVelocity
            pcall(function()
                if callback.SetNetworkOwner then
                    callback:SetNetworkOwner(localPlayer)
                end
            end)
        end
        local function updateBatDesyncTeleport()
            if not batDesyncTpEnabled then
                return
            end
            local character = localPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not humanoidRootPart or not humanoid then
                return
            end
            local remoteEvent = humanoid:FindFirstChildOfClass("RemoteEvent")
            if remoteEvent then
                pcall(function()
                    for _, entry in ipairs(remoteEvent:GetPlayingAnimationTracks()) do
                        entry:Stop()
                    end
                end)
            end
            local instance = findAndEquipBat()
            if instance and instance.Parent ~= character then
                pcall(function()
                    humanoid:EquipTool(instance)
                end)
            end
            local player, distance = findNearestOpponent(humanoidRootPart)
            if not player or distance > 100 then
                return
            end
            local character2 = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not character2 then
                return
            end
            teleportToTarget(humanoidRootPart, character2)
            local currentCamera2 = workspace.CurrentCamera
            if currentCamera2 then
                currentCamera2.CFrame = newCFrame(currentCamera2.CFrame.Position, character2.Position)
            end
            tryHitBatDesync()
            pcall(function()
                for _, descendant in ipairs(character:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        descendant.CanCollide = false
                    end
                end
            end)
        end
        startAlvaroTP = function()
            if batDesyncTpConn then
                batDesyncTpConn:Disconnect()
                batDesyncTpConn = nil
            end
            batDesyncTpEnabled = true
            _G.AlvaroTP.on = true
            _G.AlvaroTP.conn = nil
            desyncLoopRunning = false
            local character = localPlayer.Character
            if character then
                _G.AlvaroTP.h = character:FindFirstChildOfClass("Humanoid")
                _G.AlvaroTP.hrp = character:FindFirstChild("HumanoidRootPart")
            end
            batDesyncTpConn = RunService.Heartbeat:Connect(updateBatDesyncTeleport)
            _G.AlvaroTP.conn = batDesyncTpConn
            startCharacterRecoveryLoop()
            startNetworkSpamLoop()
            if batDesyncTpSetVisual then
                batDesyncTpSetVisual(true)
            end
            updateTpBatButtonWithAntiDie(true)
        end
        stopAlvaroTP = function()
            batDesyncTpEnabled = false
            _G.AlvaroTP.on = false
            if batDesyncTpConn then
                batDesyncTpConn:Disconnect()
                batDesyncTpConn = nil
            end
            _G.AlvaroTP.conn = nil
            _G.AlvaroTP.hittingCooldown = false
            desyncLoopRunning = false
            stopCharacterRecoveryLoop()
            stopNetworkSpamLoop()
            local hrp = _G.AlvaroTP.hrp
            if hrp and hrp.Parent then
                pcall(function()
                    if hrp.SetNetworkOwner then
                        hrp:SetNetworkOwner(localPlayer)
                    end
                end)
            end
            if batDesyncTpSetVisual then
                batDesyncTpSetVisual(false)
            end
            updateTpBatButtonWithAntiDie(false)
        end
    end
end
local restoreLightingState, applyNeonWeather, makeDraggable
toggleAlvaroTP = function()
    if batDesyncTpEnabled then
        stopAlvaroTP()
    else
        startAlvaroTP()
    end
end
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end
    if _G.AlvaroTP.on then
        if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
            pcall(function()
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end)
        end
    end
end)
if _G.AlvaroTP._charConn then
    pcall(function()
        _G.AlvaroTP._charConn:Disconnect()
    end)
    _G.AlvaroTP._charConn = nil
end
do
    local function updateAlvaroCharacterReferences(character)
        task.wait(0.15)
        _G.AlvaroTP.h = character and character:FindFirstChildOfClass("Humanoid") or nil
        _G.AlvaroTP.hrp = character and character:FindFirstChild("HumanoidRootPart") or nil
        if batDesyncTpEnabled and not batDesyncTpConn then
            startAlvaroTP()
        end
    end
    _G.AlvaroTP._charConn = localPlayer.CharacterAdded:Connect(function(character)
        pcall(function()
            updateAlvaroCharacterReferences(character)
        end)
    end)
    if localPlayer.Character then
        task.spawn(function()
            pcall(function()
                updateAlvaroCharacterReferences(localPlayer.Character)
            end)
        end)
    end
end
startBatDesyncTp = function()
    if not _G.AmbitiousSafeModeTryStart() then
        return
    end
    if not unwalkEnabled then
        startUnwalk()
        unwalkEnabled = true
        isActive = true
        if setUnwalkVisual then
            setUnwalkVisual(true)
        end
    end
    startAlvaroTP()
end
stopBatDesyncTp = function()
    stopAlvaroTP()
    if isActive then
        stopUnwalk()
        unwalkEnabled = false
        isActive = false
        if setUnwalkVisual then
            setUnwalkVisual(false)
        end
    end
end
toggleBatDesyncTp = function()
    if batDesyncTpEnabled then
        stopBatDesyncTp()
    else
        disableAllAimbots()
        if autoLeftEnabled then
            autoLeftEnabled = false
            stopAutoLeft()
            if autoLeftSetVisual then
                autoLeftSetVisual(false)
            end
            if mobSetAutoLeft then
                mobSetAutoLeft(false)
            end
        end
        if autoRightEnabled then
            autoRightEnabled = false
            stopAutoRight()
            if autoRightSetVisual then
                autoRightSetVisual(false)
            end
            if mobSetAutoRight then
                mobSetAutoRight(false)
            end
        end
        startBatDesyncTp()
    end
    saveAllSettings()
end
setTPBatVersion = function() end
updateTpBatButtonWithAntiDie = function(value)
    if batDesyncTpSetVisual then
        batDesyncTpSetVisual(value)
    end
end
_G.AlvaroTPBat = {
    toggle = toggleAlvaroTP,
    start = startAlvaroTP,
    stop = stopAlvaroTP,
    getStatus = function()
        return _G.AlvaroTP.on
    end,
}
findBat = function()
    local character = localPlayer.Character
    if not character then
        return nil
    end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local deltaTime = character:FindFirstChild(name)
        if deltaTime and deltaTime:IsA("Tool") then
            return deltaTime
        end
    end
    local backpack = localPlayer:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
            local deltaTime = backpack:FindFirstChild(name)
            if deltaTime and deltaTime:IsA("Tool") then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    pcall(function()
                        humanoid:EquipTool(deltaTime)
                    end)
                end
                return deltaTime
            end
        end
    end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
            return child
        end
    end
    return nil
end
isBatTool = function(tool)
    if not tool then
        return false
    end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        if tool.Name == name then
            return true
        end
    end
    return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end
findBatForCounter = function()
    local character = localPlayer.Character
    if not character then
        return nil
    end
    local backpack = localPlayer:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local tool = character:FindFirstChild(name) or backpack and backpack:FindFirstChild(name)
        if tool then
            return tool
        end
    end
    for _, child in ipairs(character:GetChildren()) do
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
swingBatForCounter = function(bat, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= character and humanoid then
        pcall(function()
            humanoid:EquipTool(bat)
        end)
        task.wait(0.05)
    end
    local remoteEvent = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remoteEvent and remoteEvent:IsA("RemoteEvent") then
        pcall(function()
            remoteEvent:FireServer()
        end)
        task.wait(0.1)
        pcall(function()
            remoteEvent:FireServer()
        end)
    else
        pcall(function()
            bat:Activate()
        end)
        task.wait(0.1)
        pcall(function()
            bat:Activate()
        end)
    end
end
batCounterDebounce = false
stopBatCounter = function()
    if Conns.batCounter then
        Conns.batCounter:Disconnect()
        Conns.batCounter = nil
    end
    batCounterDebounce = false
end
startBatCounter = function()
    if Conns.batCounter then
        return
    end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then
            return
        end
        if not batCounterDebounce then
            local character = localPlayer.Character
            if not character then
                return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then
                return
            end
            local state = humanoid:GetState()
            if
                state == Enum.HumanoidStateType.Physics
                or state == Enum.HumanoidStateType.Ragdoll
                or state == Enum.HumanoidStateType.FallingDown
            then
                batCounterDebounce = true
                _suppressBodyLock()
                task.spawn(function()
                    task.wait(0.15)
                    local batForCounter = findBatForCounter()
                    if batForCounter then
                        swingBatForCounter(batForCounter, character)
                    end
                    task.wait(0.3)
                    batCounterDebounce = false
                    _unsuppressBodyLock(true)
                end)
            end
            return
        end
        return
    end)
end
findMedusa = function()
    local character = localPlayer.Character
    if not character then
        return nil
    end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then
            local n = child.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then
                return child
            end
        end
    end
    local backpack = localPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                local n = child.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then
                    return child
                end
            end
        end
    end
    return nil
end
useMedusaCounter = function()
    if medusaDebounce then
        return
    end
    local object = medusaLastUsed
    if getTime() - object < MEDUSA_COOLDOWN then
        return
    end
    local character = localPlayer.Character
    if not character then
        return
    end
    medusaDebounce = true
    local medusa = findMedusa()
    if not medusa then
        medusaDebounce = false
        return
    end
    if medusa.Parent ~= character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:EquipTool(medusa)
        end
    end
    pcall(function()
        medusa:Activate()
    end)
    medusaLastUsed = getTime()
    medusaDebounce = false
end
onAnchorChanged = function(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then
            useMedusaCounter()
        end
    end)
end
setupMedusaCounter = function(part)
    for _, connection in pairs(Conns.anchor) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    Conns.anchor = {}
    if not part or not medusaCounterEnabled then
        return
    end
    for _, descendant in ipairs(part:GetDescendants()) do
        if descendant:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(descendant))
        end
    end
    table.insert(
        Conns.anchor,
        part.DescendantAdded:Connect(function(descendant)
            if descendant:IsA("BasePart") then
                table.insert(Conns.anchor, onAnchorChanged(descendant))
            end
        end)
    )
end
stopMedusaCounter = function()
    for _, connection in pairs(Conns.anchor) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    Conns.anchor = {}
end
do
    local connection2 = nil
    stopDropBrainrot = function()
        dropActive = false
        if connection2 then
            connection2:Disconnect()
            connection2 = nil
        end
        for _, deltaTime in ipairs(dropConnections) do
            if type(deltaTime) == "thread" then
                pcall(task.cancel, deltaTime)
            elseif type(deltaTime) == "RBXScriptConnection" then
                pcall(deltaTime.Disconnect, deltaTime)
            end
        end
        dropConnections = {}
        local character = localPlayer.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.AssemblyLinearVelocity = zeroVector
            end
        end
        if dropBrainrotSetVisual then
            dropBrainrotSetVisual(false)
        end
        if mobSetDropBR then
            mobSetDropBR(false)
        end
    end
    runDropBrainrot = function()
        if dropActive then
            return
        end
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        character = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoidRootPart or not character then
            return
        end
        if dropMode == 1 then
            local speedH = 0
            if humanoidRootPart then
                local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
                speedH = newVector3(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude
            end
            local cooldown = speedH > 5 and 0.6 or 0.25
            local object = lastDropTime
            if getTime() - object < cooldown then
                return
            end
            lastDropTime = getTime()
            dropActive = true
            if dropBrainrotSetVisual then
                dropBrainrotSetVisual(true)
            end
            if mobSetDropBR then
                mobSetDropBR(true)
            end
            local wasAutoBat = false
            if autoBatEnabled then
                wasAutoBat = true
                disableAutoBat()
                if autoBatSetVisual then
                    autoBatSetVisual(false)
                end
                if mobSetAutoBat then
                    mobSetAutoBat(false)
                end
            end
            local function finishDrop(threadRef)
                if threadRef and dropConnections then
                    for i = #dropConnections, 1, -1 do
                        if dropConnections[i] == threadRef then
                            table.remove(dropConnections, i)
                            break
                        end
                    end
                end
                dropActive = false
                local character2 = localPlayer.Character
                if character2 then
                    local r = character2:FindFirstChild("HumanoidRootPart")
                    local humanoid = character2:FindFirstChildOfClass("Humanoid")
                    if r then
                        r.AssemblyLinearVelocity = zeroVector
                        r.AssemblyAngularVelocity = zeroVector
                        if r.Position.Y < -100 then
                            r.CFrame = newCFrame(r.Position.X, 5, r.Position.Z)
                        end
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterDescendantsInstances = {
                            character2,
                        }
                        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                        local hit = workspace:Raycast(r.Position, newVector3(0, -2000, 0), raycastParams)
                        if hit then
                            r.CFrame = newCFrame(
                                r.Position.X,
                                hit.Position.Y + (humanoid and humanoid.HipHeight or 2) + r.Size.Y / 2,
                                r.Position.Z
                            )
                        end
                        if humanoid and humanoid.Health > 0 then
                            humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        end
                    end
                end
                if wasAutoBat then
                    enableAutoBat()
                    if autoBatSetVisual then
                        autoBatSetVisual(true)
                    end
                    if mobSetAutoBat then
                        mobSetAutoBat(true)
                    end
                end
                if dropBrainrotSetVisual then
                    dropBrainrotSetVisual(false)
                end
                if mobSetDropBR then
                    mobSetDropBR(false)
                end
            end
            local thread = nil
            thread = task.spawn(function()
                local startTime = getTime()
                while true do
                    local c = dropActive
                    if c then
                        c = getTime() - startTime < 0.3
                    end
                    if c then
                        RunService.Heartbeat:Wait()
                        local character2 = localPlayer.Character
                        character2 = character2 and character2:FindFirstChild("HumanoidRootPart")
                        if character2 then
                            local velocity = newVector3(0, character2.AssemblyLinearVelocity.Y, 0)
                            character2.AssemblyLinearVelocity = velocity * 10000 + newVector3(0, 10000, 0)
                            RunService.RenderStepped:Wait()
                            if character2 and character2.Parent then
                                character2.AssemblyLinearVelocity = velocity
                            end
                            RunService.Stepped:Wait()
                            if character2 and character2.Parent then
                                character2.AssemblyLinearVelocity = velocity + newVector3(0, 0.1, 0)
                            end
                            continue
                        end
                    end
                    break
                end
                finishDrop(thread)
            end)
            table.insert(dropConnections, thread)
            task.delay(0.35, function()
                if dropActive then
                    finishDrop(thread)
                end
            end)
            return
        end
        dropActive = true
        if dropBrainrotSetVisual then
            dropBrainrotSetVisual(true)
        end
        if mobSetDropBR then
            mobSetDropBR(true)
        end
        local t0 = getTime()
        if connection2 then
            connection2:Disconnect()
        end
        connection2 = RunService.Heartbeat:Connect(function()
            local character2 = localPlayer.Character
            local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart2 then
                if connection2 then
                    connection2:Disconnect()
                    connection2 = nil
                end
                dropActive = false
                if dropBrainrotSetVisual then
                    dropBrainrotSetVisual(false)
                end
                if mobSetDropBR then
                    mobSetDropBR(false)
                end
                return
            end
            if not dropActive then
                if connection2 then
                    connection2:Disconnect()
                    connection2 = nil
                end
                if dropBrainrotSetVisual then
                    dropBrainrotSetVisual(false)
                end
                if mobSetDropBR then
                    mobSetDropBR(false)
                end
                return
            end
            if getTime() - t0 >= 0.22 then
                if connection2 then
                    connection2:Disconnect()
                    connection2 = nil
                end
                pcall(function()
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {
                        character2,
                    }
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                    local hit = workspace:Raycast(humanoidRootPart2.Position, newVector3(0, -2000, 0), raycastParams)
                    if hit then
                        local humanoid = character2:FindFirstChildOfClass("Humanoid")
                        humanoidRootPart2.CFrame = newCFrame(
                            humanoidRootPart2.Position.X,
                            hit.Position.Y + (humanoid and humanoid.HipHeight or 2) + humanoidRootPart2.Size.Y / 2,
                            humanoidRootPart2.Position.Z
                        )
                        humanoidRootPart2.AssemblyLinearVelocity = zeroVector
                        humanoidRootPart2.AssemblyAngularVelocity = zeroVector
                    end
                    if hum2 and hum2.Health > 0 then
                        hum2:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end)
                dropActive = false
                if dropBrainrotSetVisual then
                    dropBrainrotSetVisual(false)
                end
                if mobSetDropBR then
                    mobSetDropBR(false)
                end
                return
            end
            local assemblyLinearVelocity = humanoidRootPart2.AssemblyLinearVelocity
            humanoidRootPart2.AssemblyLinearVelocity =
                newVector3(assemblyLinearVelocity.X, 160, assemblyLinearVelocity.Z)
        end)
    end
end
executeDropWithToggle = function(setVisual)
    if dropActive then
        return
    end
    task.spawn(function()
        if setVisual then
            setVisual(true)
        end
        runDropBrainrot()
        while dropActive do
            task.wait()
        end
        task.wait(0.1)
        if setVisual then
            setVisual(false)
        end
    end)
end
do
    local function optimizeInstanceForAntiLag(callback)
        pcall(function()
            if callback:GetAttribute("_AmbitiousHubSky") ~= nil then
                return
            end
            if callback:IsA("Sky") or callback:IsA("Atmosphere") or callback:IsA("Clouds") then
                return
            end
            if skyTheme ~= "Off" and callback.Parent == Lighting then
                if
                    callback:IsA("BlurEffect")
                    or callback:IsA("SunRaysEffect")
                    or callback:IsA("ColorCorrectionEffect")
                    or callback:IsA("BloomEffect")
                    or callback:IsA("DepthOfFieldEffect")
                    or callback:IsA("BrightnessEffect")
                    or callback:IsA("DitheringEffect")
                then
                    return
                end
            end
            if callback:IsA("Accessory") or callback:IsA("Hat") then
                local character = localPlayer.Character
                if character and callback:IsDescendantOf(character) then
                    return
                end
                callback:Destroy()
            elseif callback:IsA("BasePart") then
                callback.Material = Enum.Material.Plastic
                callback.Reflectance = 0
                callback.CastShadow = false
                callback.TopSurface = Enum.SurfaceType.Smooth
                callback.BottomSurface = Enum.SurfaceType.Smooth
                callback.FrontSurface = Enum.SurfaceType.Smooth
                callback.BackSurface = Enum.SurfaceType.Smooth
                callback.LeftSurface = Enum.SurfaceType.Smooth
                callback.RightSurface = Enum.SurfaceType.Smooth
                for _, child in ipairs(callback:GetChildren()) do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        child.Transparency = 0.5
                    end
                end
            elseif callback:IsA("Decal") or callback:IsA("Texture") then
                callback.Transparency = 0.5
            elseif
                callback:IsA("ParticleEmitter")
                or callback:IsA("Trail")
                or callback:IsA("Beam")
                or callback:IsA("Fire")
                or callback:IsA("Smoke")
                or callback:IsA("Sparkles")
            then
                callback.Enabled = false
            elseif callback:IsA("PointLight") or callback:IsA("SpotLight") or callback:IsA("SurfaceLight") then
                callback.Enabled = false
            elseif callback:IsA("SelectionBox") and callback.Name ~= "AmbitiousHubESP" then
                pcall(function()
                    callback:Destroy()
                end)
            end
        end)
    end
    enableAntiLag = function()
        antiLagEnabled = true
        removeAccessoriesEnabled = true
        _G._AmbitiousDefLightBrightness = _G._AmbitiousDefLightBrightness or Lighting.Brightness
        _G._AmbitiousDefLightClock = _G._AmbitiousDefLightClock or Lighting.ClockTime
        _G._AmbitiousDefLightAmbient = _G._AmbitiousDefLightAmbient or Lighting.OutdoorAmbient
        pcall(function()
            settings().Rendering.QualityLevel = 1
            local disabled = Enum.MeshPartDetailLevel.Disabled
            settings().Rendering.MeshPartDetailLevel = disabled
        end)
        if skyTheme == "Off" then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 1e10
            Lighting.FogStart = 0
            Lighting.Brightness = 1
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            Lighting.ShadowSoftness = 0
            Lighting.ExposureCompensation = 0
            pcall(function()
                Lighting.Technology = Enum.Technology.Compatibility
                return
            end)
            for _, child in pairs(Lighting:GetChildren()) do
                pcall(function()
                    if child:GetAttribute("_AmbitiousVivid") then
                        return
                    end
                    if
                        child:IsA("BlurEffect")
                        or child:IsA("SunRaysEffect")
                        or child:IsA("ColorCorrectionEffect")
                        or child:IsA("BloomEffect")
                        or child:IsA("DepthOfFieldEffect")
                        or child:IsA("BrightnessEffect")
                        or child:IsA("DitheringEffect")
                    then
                        child.Enabled = false
                    end
                end)
            end
        end
        for _, descendant in ipairs(workspace:GetDescendants()) do
            optimizeInstanceForAntiLag(descendant)
        end
        for _, descendant in pairs(workspace:GetDescendants()) do
            pcall(function()
                if descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false
                elseif descendant:IsA("Decal") then
                    descendant.Transparency = 1
                elseif descendant:IsA("BasePart") then
                    local character = localPlayer.Character
                    if character and descendant:IsDescendantOf(character) then
                        return
                    end
                    descendant.Material = Enum.Material.Plastic
                    descendant.Reflectance = 0
                    descendant.CastShadow = false
                    descendant.TopSurface = Enum.SurfaceType.Smooth
                    descendant.BottomSurface = Enum.SurfaceType.Smooth
                    descendant.FrontSurface = Enum.SurfaceType.Smooth
                    descendant.BackSurface = Enum.SurfaceType.Smooth
                    descendant.LeftSurface = Enum.SurfaceType.Smooth
                    descendant.RightSurface = Enum.SurfaceType.Smooth
                end
            end)
        end
        pcall(function()
            workspace.Terrain.WaterWaveSize = 0
            workspace.Terrain.WaterWaveSpeed = 0
            workspace.Terrain.WaterReflectance = 0
            workspace.Terrain.WaterTransparency = 0
            workspace.Terrain.Decoration = false
        end)
        if antiLagDescConn then
            antiLagDescConn:Disconnect()
        end
        antiLagDescConn = workspace.DescendantAdded:Connect(function(descendant)
            if descendant:GetAttribute("_AmbitiousHubSky") then
                return
            end
            if descendant:IsA("Sky") or descendant:IsA("Atmosphere") or descendant:IsA("Clouds") then
                return
            end
            if removeAccessoriesEnabled then
                optimizeInstanceForAntiLag(descendant)
            end
        end)
    end
end
disableAntiLag = function()
    antiLagEnabled = false
    removeAccessoriesEnabled = false
    if antiLagDescConn then
        antiLagDescConn:Disconnect()
        antiLagDescConn = nil
    end
    if skyTheme == "Off" then
        pcall(function()
            if _G._AmbitiousDefLightBrightness then
                Lighting.Brightness = _G._AmbitiousDefLightBrightness
            end
            if _G._AmbitiousDefLightClock then
                Lighting.ClockTime = _G._AmbitiousDefLightClock
            end
            if _G._AmbitiousDefLightAmbient then
                Lighting.OutdoorAmbient = _G._AmbitiousDefLightAmbient
            end
            Lighting.ExposureCompensation = 0
            Lighting.GlobalShadows = true
        end)
    end
end
CUSTOM_FOV_BIND = "FictionHubCustomFOV"
enableCustomFov = function()
    local currentCamera2 = workspace.CurrentCamera
    if currentCamera2 and origFOV == nil then
        origFOV = currentCamera2.FieldOfView
    end
    fovEnabled = true
    if currentCamera2 then
        pcall(function()
            currentCamera2.FieldOfViewMode = Enum.FieldOfViewMode.Diagonal
        end)
        pcall(function()
            currentCamera2.FieldOfView = fovValue
        end)
    end
    if customFovConn then
        customFovConn:Disconnect()
        customFovConn = nil
    end
    pcall(function()
        RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND)
    end)
    local prio = 200
    pcall(function()
        prio = Enum.RenderPriority.Camera.Value + 10
    end)
    if
        not pcall(function()
            RunService:BindToRenderStep(CUSTOM_FOV_BIND, prio, function()
                if not fovEnabled then
                    return
                end
                local currentCamera3 = workspace.CurrentCamera
                if currentCamera3 and currentCamera3.FieldOfView ~= fovValue then
                    currentCamera3.FieldOfView = fovValue
                end
            end)
        end)
    then
        customFovConn = RunService.RenderStepped:Connect(function()
            if not fovEnabled then
                if customFovConn then
                    customFovConn:Disconnect()
                    customFovConn = nil
                end
                return
            end
            local currentCamera3 = workspace.CurrentCamera
            if currentCamera3 then
                currentCamera3.FieldOfView = fovValue
            end
        end)
    end
end
disableCustomFov = function()
    fovEnabled = false
    pcall(function()
        RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND)
    end)
    if customFovConn then
        customFovConn:Disconnect()
        customFovConn = nil
    end
    local currentCamera2 = workspace.CurrentCamera
    if currentCamera2 then
        pcall(function()
            currentCamera2.FieldOfViewMode = Enum.FieldOfViewMode.Vertical
        end)
        pcall(function()
            currentCamera2.FieldOfView = origFOV or 70
        end)
    end
end
applyStretchFOV = function(fieldOfView)
    local currentCamera2 = workspace.CurrentCamera
    if currentCamera2 then
        pcall(function()
            currentCamera2.FieldOfView = fieldOfView
        end)
    end
end
enableStretch = function()
    if stretchConn then
        return
    end
    stretchEnabled = true
    local currentCamera2 = workspace.CurrentCamera
    if not currentCamera2 then
        return
    end
    origFOV = currentCamera2.FieldOfView or 70
    applyStretchFOV(stretchFOV)
    stretchConn = RunService.RenderStepped:Connect(function()
        if not stretchEnabled then
            stretchConn:Disconnect()
            stretchConn = nil
            return
        end
        local currentCamera3 = workspace.CurrentCamera
        if currentCamera3 then
            currentCamera3.CFrame = currentCamera3.CFrame * newCFrame(0, 0, 0, 1, 0, 0, 0, 0.7, 0, 0, 0, 1)
        end
    end)
    if stretchFovConn then
        stretchFovConn:Disconnect()
    end
    stretchFovConn = RunService.RenderStepped:Connect(function()
        if stretchEnabled then
            applyStretchFOV(stretchFOV)
        else
            stretchFovConn:Disconnect()
            stretchFovConn = nil
        end
    end)
end
disableStretch = function()
    stretchEnabled = false
    if stretchConn then
        stretchConn:Disconnect()
        stretchConn = nil
    end
    if stretchFovConn then
        stretchFovConn:Disconnect()
        stretchFovConn = nil
    end
    local currentCamera2 = workspace.CurrentCamera
    if currentCamera2 then
        pcall(function()
            currentCamera2.FieldOfView = origFOV or 70
        end)
    end
end
do
    local function saveLightingState()
        if _originalLighting then
            return
        end
        _originalLighting = {
            Brightness = Lighting.Brightness,
            ClockTime = Lighting.ClockTime,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            GlobalShadows = Lighting.GlobalShadows,
            FogEnd = Lighting.FogEnd,
            FogStart = Lighting.FogStart,
            FogColor = Lighting.FogColor,
            Ambient = Lighting.Ambient,
            ColorCorrection = nil,
            Bloom = nil,
        }
        for _, child in ipairs(Lighting:GetChildren()) do
            if child:IsA("ColorCorrectionEffect") then
                _originalLighting.ColorCorrection = {
                    Enabled = child.Enabled,
                    Brightness = child.Brightness,
                    Contrast = child.Contrast,
                    Saturation = child.Saturation,
                    TintColor = child.TintColor,
                }
            elseif child:IsA("BloomEffect") then
                _originalLighting.Bloom = {
                    Enabled = child.Enabled,
                    Intensity = child.Intensity,
                    Size = child.Size,
                    Threshold = child.Threshold,
                }
            end
        end
    end
    restoreLightingState = function()
        if not _originalLighting then
            return
        end
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
            local colorCorrectionEffect = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
            if colorCorrectionEffect then
                colorCorrectionEffect.Enabled = old.ColorCorrection.Enabled
                colorCorrectionEffect.Brightness = old.ColorCorrection.Brightness
                colorCorrectionEffect.Contrast = old.ColorCorrection.Contrast
                colorCorrectionEffect.Saturation = old.ColorCorrection.Saturation
                colorCorrectionEffect.TintColor = old.ColorCorrection.TintColor
            end
        end
        if old.Bloom then
            local bloomEffect = Lighting:FindFirstChildOfClass("BloomEffect")
            if bloomEffect then
                bloomEffect.Enabled = old.Bloom.Enabled
                bloomEffect.Intensity = old.Bloom.Intensity
                bloomEffect.Size = old.Bloom.Size
                bloomEffect.Threshold = old.Bloom.Threshold
            end
        end
    end
    SKY_PRESETS_LIST = {
        "Off",
        "Night",
        "Aurora",
        "Sunset",
        "Galaxy",
        "Cyber",
        "Sakura",
        "Pink Night",
        "Blood Moon",
        "Emerald Dawn",
        "Volcanic",
        "Arctic",
        "Midnight Ocean",
        "Vaporwave",
        "Toxic",
        "Solar Eclipse",
        "Hellscape",
        "Heaven",
        "Storm",
        "Sunrise",
        "Deep Space",
        "Lavender Dream",
        "Inferno",
        "Mint Sky",
    }
    SKY_PRESETS = {
        Off = {
            kind = "off",
        },
        Night = {
            clock = 22,
            brightness = 2,
            ambient = {
                110,
                100,
                130,
            },
            outAmb = {
                120,
                110,
                140,
            },
            sky = {
                stars = 4000,
                moon = 18,
                sun = 0,
                moonTex = true,
            },
            atm = {
                dens = 0.45,
                color = {
                    120,
                    60,
                    180,
                },
                decay = {
                    60,
                    20,
                    100,
                },
                glare = 0.5,
                haze = 1.2,
            },
        },
        Aurora = {
            clock = 14,
            brightness = 3,
            ambient = {
                150,
                120,
                150,
            },
            outAmb = {
                160,
                130,
                150,
            },
            atm = {
                dens = 0.55,
                color = {
                    85,
                    80,
                    200,
                },
                decay = {
                    255,
                    20,
                    150,
                },
                glare = 2.5,
                haze = 3,
            },
            clouds = {
                cover = 0.7,
                dens = 0.7,
                color = {
                    85,
                    240,
                    250,
                },
            },
        },
        Sunset = {
            clock = 17.2,
            brightness = 2.5,
            ambient = {
                170,
                120,
                100,
            },
            outAmb = {
                180,
                130,
                110,
            },
            sky = {
                stars = 0,
                sun = 25,
                moon = 0,
            },
            atm = {
                dens = 0.5,
                color = {
                    255,
                    130,
                    60,
                },
                decay = {
                    255,
                    80,
                    30,
                },
                glare = 2,
                haze = 2.5,
            },
            clouds = {
                cover = 0.55,
                dens = 0.55,
                color = {
                    255,
                    200,
                    140,
                },
            },
        },
        Galaxy = {
            clock = 0,
            brightness = 1.5,
            ambient = {
                70,
                60,
                100,
            },
            outAmb = {
                80,
                70,
                110,
            },
            sky = {
                stars = 10000,
                moon = 30,
                sun = 0,
            },
            atm = {
                dens = 0.15,
                color = {
                    40,
                    20,
                    80,
                },
                decay = {
                    20,
                    10,
                    50,
                },
                glare = 0.3,
                haze = 0.5,
            },
        },
        Cyber = {
            clock = 21,
            brightness = 2.2,
            ambient = {
                90,
                130,
                170,
            },
            outAmb = {
                100,
                140,
                180,
            },
            sky = {
                stars = 2000,
                moon = 12,
            },
            atm = {
                dens = 0.4,
                color = {
                    0,
                    200,
                    255,
                },
                decay = {
                    150,
                    0,
                    255,
                },
                glare = 2,
                haze = 2,
            },
            clouds = {
                cover = 0.4,
                dens = 0.6,
                color = {
                    100,
                    200,
                    85,
                },
            },
        },
        Sakura = {
            clock = 11,
            brightness = 3.5,
            ambient = {
                170,
                150,
                160,
            },
            outAmb = {
                180,
                160,
                170,
            },
            sky = {
                sun = 8,
            },
            atm = {
                dens = 0.3,
                color = {
                    85,
                    200,
                    220,
                },
                decay = {
                    255,
                    170,
                    200,
                },
                glare = 1,
                haze = 1.5,
            },
            clouds = {
                cover = 0.6,
                dens = 0.4,
                color = {
                    255,
                    250,
                    252,
                },
            },
        },
        ["Pink Night"] = {
            clock = 23,
            brightness = 2.2,
            ambient = {
                120,
                60,
                110,
            },
            outAmb = {
                140,
                70,
                120,
            },
            sky = {
                stars = 5000,
                moon = 22,
                sun = 0,
                moonTex = true,
            },
            atm = {
                dens = 0.5,
                color = {
                    85,
                    80,
                    180,
                },
                decay = {
                    140,
                    30,
                    100,
                },
                glare = 0.7,
                haze = 1.4,
            },
            clouds = {
                cover = 0.3,
                dens = 0.5,
                color = {
                    180,
                    90,
                    150,
                },
            },
        },
        ["Blood Moon"] = {
            clock = 22.5,
            brightness = 1.8,
            ambient = {
                130,
                70,
                70,
            },
            outAmb = {
                150,
                80,
                80,
            },
            sky = {
                stars = 1500,
                moon = 28,
                sun = 0,
                moonTex = true,
            },
            atm = {
                dens = 0.45,
                color = {
                    220,
                    80,
                    80,
                },
                decay = {
                    120,
                    40,
                    40,
                },
                glare = 1,
                haze = 1.5,
            },
            clouds = {
                cover = 0.45,
                dens = 0.55,
                color = {
                    120,
                    60,
                    60,
                },
            },
        },
        ["Emerald Dawn"] = {
            clock = 6.5,
            brightness = 2.8,
            ambient = {
                130,
                170,
                140,
            },
            outAmb = {
                140,
                180,
                150,
            },
            sky = {
                sun = 18,
                moon = 0,
                stars = 0,
            },
            atm = {
                dens = 0.4,
                color = {
                    80,
                    200,
                    140,
                },
                decay = {
                    40,
                    150,
                    90,
                },
                glare = 1.8,
                haze = 2.2,
            },
            clouds = {
                cover = 0.5,
                dens = 0.5,
                color = {
                    200,
                    255,
                    220,
                },
            },
        },
        Volcanic = {
            clock = 19,
            brightness = 2.2,
            ambient = {
                180,
                110,
                80,
            },
            outAmb = {
                200,
                120,
                90,
            },
            sky = {
                stars = 200,
                sun = 12,
                moon = 0,
            },
            atm = {
                dens = 0.55,
                color = {
                    255,
                    110,
                    60,
                },
                decay = {
                    180,
                    70,
                    40,
                },
                glare = 2,
                haze = 2.2,
            },
            clouds = {
                cover = 0.65,
                dens = 0.7,
                color = {
                    120,
                    70,
                    50,
                },
            },
        },
        Arctic = {
            clock = 9,
            brightness = 3.2,
            ambient = {
                200,
                220,
                235,
            },
            outAmb = {
                210,
                230,
                245,
            },
            sky = {
                sun = 10,
                stars = 0,
                moon = 0,
            },
            atm = {
                dens = 0.3,
                color = {
                    180,
                    220,
                    255,
                },
                decay = {
                    140,
                    200,
                    240,
                },
                glare = 1.5,
                haze = 1.8,
            },
            clouds = {
                cover = 0.7,
                dens = 0.6,
                color = {
                    250,
                    253,
                    85,
                },
            },
        },
        ["Midnight Ocean"] = {
            clock = 1.5,
            brightness = 1.7,
            ambient = {
                60,
                90,
                130,
            },
            outAmb = {
                70,
                100,
                140,
            },
            sky = {
                stars = 6000,
                moon = 24,
                sun = 0,
                moonTex = true,
            },
            atm = {
                dens = 0.5,
                color = {
                    20,
                    60,
                    140,
                },
                decay = {
                    10,
                    30,
                    90,
                },
                glare = 0.6,
                haze = 1.5,
            },
        },
        Vaporwave = {
            clock = 19.5,
            brightness = 2.4,
            ambient = {
                180,
                120,
                200,
            },
            outAmb = {
                190,
                130,
                210,
            },
            sky = {
                stars = 1000,
                moon = 14,
            },
            atm = {
                dens = 0.45,
                color = {
                    255,
                    100,
                    220,
                },
                decay = {
                    120,
                    60,
                    255,
                },
                glare = 2.2,
                haze = 2.4,
            },
            clouds = {
                cover = 0.55,
                dens = 0.55,
                color = {
                    200,
                    150,
                    85,
                },
            },
        },
        Toxic = {
            clock = 13,
            brightness = 2.5,
            ambient = {
                140,
                180,
                80,
            },
            outAmb = {
                150,
                190,
                90,
            },
            atm = {
                dens = 0.45,
                color = {
                    100,
                    220,
                    40,
                },
                decay = {
                    60,
                    150,
                    20,
                },
                glare = 1.5,
                haze = 1.8,
            },
            clouds = {
                cover = 0.55,
                dens = 0.55,
                color = {
                    180,
                    255,
                    120,
                },
            },
        },
        ["Solar Eclipse"] = {
            clock = 12,
            brightness = 1.2,
            ambient = {
                70,
                60,
                80,
            },
            outAmb = {
                80,
                70,
                90,
            },
            sky = {
                stars = 3500,
                sun = 22,
                moon = 0,
            },
            atm = {
                dens = 0.4,
                color = {
                    255,
                    180,
                    90,
                },
                decay = {
                    50,
                    40,
                    60,
                },
                glare = 2,
                haze = 1.5,
            },
        },
        Hellscape = {
            clock = 18,
            brightness = 2.2,
            ambient = {
                200,
                100,
                80,
            },
            outAmb = {
                220,
                110,
                90,
            },
            sky = {
                stars = 100,
                sun = 30,
                moon = 0,
            },
            atm = {
                dens = 0.6,
                color = {
                    255,
                    90,
                    60,
                },
                decay = {
                    140,
                    50,
                    40,
                },
                glare = 2.2,
                haze = 2.4,
            },
            clouds = {
                cover = 0.8,
                dens = 0.8,
                color = {
                    90,
                    50,
                    40,
                },
            },
        },
        Heaven = {
            clock = 12,
            brightness = 4,
            ambient = {
                240,
                240,
                210,
            },
            outAmb = {
                250,
                245,
                220,
            },
            sky = {
                sun = 16,
                moon = 0,
                stars = 0,
            },
            atm = {
                dens = 0.25,
                color = {
                    255,
                    250,
                    220,
                },
                decay = {
                    85,
                    240,
                    200,
                },
                glare = 3,
                haze = 1.5,
            },
            clouds = {
                cover = 0.85,
                dens = 0.5,
                color = {
                    255,
                    255,
                    255,
                },
            },
        },
        Storm = {
            clock = 15,
            brightness = 1.6,
            ambient = {
                105,
                105,
                125,
            },
            outAmb = {
                115,
                115,
                135,
            },
            sky = {
                stars = 0,
                sun = 6,
                moon = 0,
            },
            atm = {
                dens = 0.55,
                color = {
                    90,
                    100,
                    130,
                },
                decay = {
                    55,
                    65,
                    90,
                },
                glare = 0.5,
                haze = 2.2,
            },
            clouds = {
                cover = 0.85,
                dens = 0.5,
                color = {
                    70,
                    75,
                    90,
                },
            },
        },
        Sunrise = {
            clock = 6.2,
            brightness = 2.8,
            ambient = {
                220,
                180,
                130,
            },
            outAmb = {
                230,
                190,
                140,
            },
            sky = {
                sun = 22,
                stars = 0,
                moon = 0,
            },
            atm = {
                dens = 0.45,
                color = {
                    255,
                    180,
                    100,
                },
                decay = {
                    255,
                    140,
                    80,
                },
                glare = 2.4,
                haze = 2.2,
            },
            clouds = {
                cover = 0.4,
                dens = 0.4,
                color = {
                    85,
                    220,
                    180,
                },
            },
        },
        ["Deep Space"] = {
            clock = 0,
            brightness = 1,
            ambient = {
                30,
                25,
                50,
            },
            outAmb = {
                40,
                35,
                60,
            },
            sky = {
                stars = 15000,
                moon = 0,
                sun = 0,
            },
            atm = {
                dens = 0.05,
                color = {
                    15,
                    5,
                    40,
                },
                decay = {
                    5,
                    0,
                    20,
                },
                glare = 0.2,
                haze = 0.3,
            },
        },
        ["Lavender Dream"] = {
            clock = 18.5,
            brightness = 2.6,
            ambient = {
                180,
                160,
                220,
            },
            outAmb = {
                190,
                170,
                230,
            },
            sky = {
                stars = 800,
                moon = 16,
                sun = 0,
            },
            atm = {
                dens = 0.4,
                color = {
                    200,
                    160,
                    255,
                },
                decay = {
                    160,
                    120,
                    220,
                },
                glare = 1.4,
                haze = 1.8,
            },
            clouds = {
                cover = 0.55,
                dens = 0.5,
                color = {
                    220,
                    200,
                    85,
                },
            },
        },
        Inferno = {
            clock = 17.5,
            brightness = 2.4,
            ambient = {
                220,
                140,
                90,
            },
            outAmb = {
                240,
                150,
                100,
            },
            sky = {
                sun = 26,
                moon = 0,
                stars = 0,
            },
            atm = {
                dens = 0.5,
                color = {
                    255,
                    130,
                    70,
                },
                decay = {
                    200,
                    80,
                    40,
                },
                glare = 2.2,
                haze = 2.2,
            },
            clouds = {
                cover = 0.6,
                dens = 0.6,
                color = {
                    200,
                    110,
                    80,
                },
            },
        },
        ["Mint Sky"] = {
            clock = 10,
            brightness = 3.2,
            ambient = {
                180,
                230,
                210,
            },
            outAmb = {
                190,
                240,
                220,
            },
            sky = {
                sun = 10,
            },
            atm = {
                dens = 0.32,
                color = {
                    150,
                    255,
                    210,
                },
                decay = {
                    100,
                    220,
                    180,
                },
                glare = 1.6,
                haze = 1.6,
            },
            clouds = {
                cover = 0.55,
                dens = 0.45,
                color = {
                    240,
                    85,
                    250,
                },
            },
        },
    }
    local function vC3(deltaTime)
        return Color3.fromRGB(deltaTime[1], deltaTime[2], deltaTime[3])
    end
    _v4mpClearSky = function()
        for _, child in ipairs(Lighting:GetChildren()) do
            if child:GetAttribute("_AdaptDuelsSky") then
                pcall(function()
                    child:Destroy()
                end)
            end
        end
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            for _, child in ipairs(terrain:GetChildren()) do
                if child:GetAttribute("_AdaptDuelsSky") then
                    pcall(function()
                        child:Destroy()
                    end)
                end
            end
        end
    end
    applyCustomSky = function(mode)
        _v4mpClearSky()
        local preset = SKY_PRESETS[mode]
        if not preset or preset.kind == "off" then
            Lighting.ClockTime = 14
            Lighting.Brightness = 2
            Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
            Lighting.Ambient = Color3.fromRGB(127, 127, 127)
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = true
            skyTheme = "Off"
            return
        end
        Lighting.FogStart = 0
        Lighting.FogEnd = 100000
        Lighting.FogColor = Color3.fromRGB(200, 200, 200)
        Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
        Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
        Lighting.GlobalShadows = true
        Lighting.ClockTime = preset.clock or 14
        Lighting.Brightness = preset.brightness or 2
        if preset.outAmb then
            Lighting.OutdoorAmbient = vC3(preset.outAmb)
        end
        if preset.ambient then
            Lighting.Ambient = vC3(preset.ambient)
        end
        if preset.sky then
            local sky = Instance.new("Sky")
            sky:SetAttribute("_AdaptDuelsSky", true)
            if preset.sky.stars then
                sky.StarCount = preset.sky.stars
            end
            if preset.sky.moon then
                sky.MoonAngularSize = preset.sky.moon
            end
            if preset.sky.sun then
                sky.SunAngularSize = preset.sky.sun
            end
            if preset.sky.moonTex then
                sky.MoonTextureId = "rbxasset://sky/moon.jpg"
            end
            sky.Parent = Lighting
        end
        if preset.atm then
            local atm = Instance.new("Atmosphere")
            atm:SetAttribute("_AdaptDuelsSky", true)
            atm.Density = preset.atm.dens or 0.3
            atm.Color = vC3(preset.atm.color)
            atm.Decay = vC3(preset.atm.decay)
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
            clouds.Color = vC3(preset.clouds.color)
            clouds.Parent = terrain
        end
        skyTheme = mode
    end
    local function applyRevHubCustomSkyTextures(sky)
        if not sky then return end
        if customSkyPreset == "Photo" then
            local image = "rbxassetid://133765467551361"
            sky.SkyboxBk, sky.SkyboxDn, sky.SkyboxFt = image, image, image
            sky.SkyboxLf, sky.SkyboxRt, sky.SkyboxUp = image, image, image
        else
            sky.SkyboxBk = "rbxassetid://84987301811489"
            sky.SkyboxDn = "rbxassetid://79494086933869"
            sky.SkyboxFt = "rbxassetid://84987301811489"
            sky.SkyboxLf = "rbxassetid://84987301811489"
            sky.SkyboxRt = "rbxassetid://84987301811489"
            sky.SkyboxUp = "rbxassetid://79494086933869"
        end
    end
    local function createRevHubCustomSkyInstance()
        local sky = Instance.new("Sky")
        sky.Name = "RevHubCustomSky"
        sky:SetAttribute("_RevHubCustomSky", true)
        applyRevHubCustomSkyTextures(sky)
        sky.CelestialBodiesShown = false
        sky.SunAngularSize = 0
        sky.MoonAngularSize = 0
        sky.StarCount = 0
        return sky
    end
    local function applyRevHubCustomSkyLighting()
        Lighting.Ambient = Color3.fromRGB(70, 70, 80)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GeographicLatitude = 0
        Lighting.FogEnd = 100000
    end
    local customSkyWeatherEffects = {}
    local customSkyWeatherConnections = {}
    local customSkyWeatherLockConnection = nil
    local customSkyLockedLighting = nil
    local function neutralizeWeatherEffect(effect)
        if not customSkyEnabled or not effect then
            return
        end
        if effect:IsA("Sky") then
            if effect == customSkyInstance then
                return
            end
            local alreadySaved = false
            for _, savedSky in ipairs(customSkyOriginalObjects) do
                if savedSky == effect then
                    alreadySaved = true
                    break
                end
            end
            if not alreadySaved then
                table.insert(customSkyOriginalObjects, effect)
            end
            pcall(function() effect.Parent = nil end)
        elseif effect:IsA("Atmosphere") then
            if not customSkyWeatherEffects[effect] then
                customSkyWeatherEffects[effect] = {
                    className = "Atmosphere",
                    Density = effect.Density,
                    Offset = effect.Offset,
                    Color = effect.Color,
                    Decay = effect.Decay,
                    Glare = effect.Glare,
                    Haze = effect.Haze,
                }
            end
            pcall(function()
                effect.Density = 0
                effect.Offset = 0
                effect.Color = Color3.fromRGB(255, 255, 255)
                effect.Decay = Color3.fromRGB(255, 255, 255)
                effect.Glare = 0
                effect.Haze = 0
            end)
        elseif effect:IsA("Clouds") then
            if not customSkyWeatherEffects[effect] then
                customSkyWeatherEffects[effect] = {
                    className = "Clouds",
                    Cover = effect.Cover,
                    Density = effect.Density,
                    Color = effect.Color,
                }
            end
            pcall(function()
                effect.Cover = 0
                effect.Density = 0
                effect.Color = Color3.fromRGB(255, 255, 255)
            end)
        elseif effect:IsA("ColorCorrectionEffect") then
            if not customSkyWeatherEffects[effect] then
                customSkyWeatherEffects[effect] = {
                    className = "ColorCorrectionEffect",
                    Enabled = effect.Enabled,
                    Brightness = effect.Brightness,
                    Contrast = effect.Contrast,
                    Saturation = effect.Saturation,
                    TintColor = effect.TintColor,
                }
            end
            pcall(function()
                effect.Enabled = false
            end)
        elseif effect:IsA("SunRaysEffect") then
            if not customSkyWeatherEffects[effect] then
                customSkyWeatherEffects[effect] = {
                    className = "SunRaysEffect",
                    Enabled = effect.Enabled,
                    Intensity = effect.Intensity,
                    Spread = effect.Spread,
                }
            end
            pcall(function()
                effect.Enabled = false
            end)
        end
    end
    local function enforceRevHubCustomSky()
        if not customSkyEnabled then
            return
        end
        if not customSkyInstance or customSkyInstance.Parent ~= Lighting then
            local replacement = createRevHubCustomSkyInstance()
            customSkyInstance = replacement
            replacement.Parent = Lighting
        end
        pcall(function()
            applyRevHubCustomSkyTextures(customSkyInstance)
            customSkyInstance.CelestialBodiesShown = false
            customSkyInstance.SunAngularSize = 0
            customSkyInstance.MoonAngularSize = 0
            customSkyInstance.StarCount = 0
            Lighting.FogStart = 0
            Lighting.FogEnd = 100000
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)
            if customSkyLockedLighting then
                Lighting.ClockTime = customSkyLockedLighting.ClockTime
                Lighting.Brightness = customSkyLockedLighting.Brightness
                Lighting.Ambient = customSkyLockedLighting.Ambient
                Lighting.OutdoorAmbient = customSkyLockedLighting.OutdoorAmbient
                Lighting.GeographicLatitude = customSkyLockedLighting.GeographicLatitude
            end
        end)
        for _, effect in ipairs(Lighting:GetChildren()) do
            neutralizeWeatherEffect(effect)
        end
        local terrain = Workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            for _, effect in ipairs(terrain:GetChildren()) do
                neutralizeWeatherEffect(effect)
            end
        end
    end
    local function startRevHubCustomSkyLock()
        for _, connection in ipairs(customSkyWeatherConnections) do
            pcall(function() connection:Disconnect() end)
        end
        table.clear(customSkyWeatherConnections)
        table.insert(customSkyWeatherConnections, Lighting.ChildAdded:Connect(neutralizeWeatherEffect))
        table.insert(customSkyWeatherConnections, Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
            if customSkyEnabled then
                task.defer(enforceRevHubCustomSky)
            end
        end))
        local terrain = Workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            table.insert(customSkyWeatherConnections, terrain.ChildAdded:Connect(neutralizeWeatherEffect))
        end
        if customSkyWeatherLockConnection then
            customSkyWeatherLockConnection:Disconnect()
        end
        local elapsed = 0
        customSkyWeatherLockConnection = RunService.Heartbeat:Connect(function(dt)
            if not customSkyEnabled then
                return
            end
            elapsed += dt
            if elapsed >= 0.5 then
                elapsed = 0
                enforceRevHubCustomSky()
            end
        end)
        enforceRevHubCustomSky()
    end
    local function stopRevHubCustomSkyLock()
        if customSkyWeatherLockConnection then
            customSkyWeatherLockConnection:Disconnect()
            customSkyWeatherLockConnection = nil
        end
        for _, connection in ipairs(customSkyWeatherConnections) do
            pcall(function() connection:Disconnect() end)
        end
        table.clear(customSkyWeatherConnections)
        for effect, old in pairs(customSkyWeatherEffects) do
            if effect and effect.Parent then
                pcall(function()
                    if old.className == "Atmosphere" then
                        effect.Density = old.Density
                        effect.Offset = old.Offset
                        effect.Color = old.Color
                        effect.Decay = old.Decay
                        effect.Glare = old.Glare
                        effect.Haze = old.Haze
                    elseif old.className == "Clouds" then
                        effect.Cover = old.Cover
                        effect.Density = old.Density
                        effect.Color = old.Color
                    elseif old.className == "ColorCorrectionEffect" then
                        effect.Enabled = old.Enabled
                        effect.Brightness = old.Brightness
                        effect.Contrast = old.Contrast
                        effect.Saturation = old.Saturation
                        effect.TintColor = old.TintColor
                    elseif old.className == "SunRaysEffect" then
                        effect.Enabled = old.Enabled
                        effect.Intensity = old.Intensity
                        effect.Spread = old.Spread
                    end
                end)
            end
        end
        table.clear(customSkyWeatherEffects)
    end
    applyRevHubCustomSky = function(enabled, preserveLighting)
        if enabled then
            if customSkyEnabled and customSkyInstance and customSkyInstance.Parent == Lighting then
                return true
            end
            if neonWeatherEnabled then
                neonWeatherEnabled = false
                if type(toggleNeonWeather) == "function" then
                    pcall(toggleNeonWeather, false)
                end
                if setNeonWeatherVisual then
                    pcall(setNeonWeatherVisual, false)
                end
            end
            customSkyOriginalState = {
                Ambient = Lighting.Ambient,
                OutdoorAmbient = Lighting.OutdoorAmbient,
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                GeographicLatitude = Lighting.GeographicLatitude,
                FogEnd = Lighting.FogEnd,
                FogStart = Lighting.FogStart,
                FogColor = Lighting.FogColor,
            }
            customSkyOriginalObjects = {}
            for _, child in ipairs(Lighting:GetChildren()) do
                if child:IsA("Sky") then
                    table.insert(customSkyOriginalObjects, child)
                    child.Parent = nil
                end
            end
            local sky = createRevHubCustomSkyInstance()
            customSkyInstance = sky
            sky.Parent = Lighting
            if not preserveLighting then
                applyRevHubCustomSkyLighting()
            end
            local oldBlackFloor = Workspace:FindFirstChild("RevHubBlackFloor")
            if oldBlackFloor and oldBlackFloor:IsA("BasePart") then
                pcall(function() oldBlackFloor:Destroy() end)
            end
            customSkyFloorPart = nil
            customSkyEnabled = true
            customSkyLockedLighting = {
                ClockTime = Lighting.ClockTime,
                Brightness = Lighting.Brightness,
                Ambient = Lighting.Ambient,
                OutdoorAmbient = Lighting.OutdoorAmbient,
                GeographicLatitude = Lighting.GeographicLatitude,
            }
            startRevHubCustomSkyLock()
            return true
        end

        customSkyEnabled = false
        stopRevHubCustomSkyLock()
        customSkyLockedLighting = nil
        if customSkyInstance then
            pcall(function() customSkyInstance:Destroy() end)
            customSkyInstance = nil
        end
        if customSkyFloorPart then
            pcall(function() customSkyFloorPart:Destroy() end)
            customSkyFloorPart = nil
        end
        for _, originalSky in ipairs(customSkyOriginalObjects or {}) do
            if originalSky and originalSky.Parent == nil then
                pcall(function() originalSky.Parent = Lighting end)
            end
        end
        local old = customSkyOriginalState
        if old then
            pcall(function()
                Lighting.Ambient = old.Ambient
                Lighting.OutdoorAmbient = old.OutdoorAmbient
                Lighting.Brightness = old.Brightness
                Lighting.ClockTime = old.ClockTime
                Lighting.GeographicLatitude = old.GeographicLatitude
                Lighting.FogEnd = old.FogEnd
                Lighting.FogStart = old.FogStart
                Lighting.FogColor = old.FogColor
            end)
        end
        customSkyOriginalState = nil
        customSkyOriginalObjects = {}
        return true
    end
    local MIKU_SKY_FRAMES = {
        "rbxassetid://21076888", "rbxassetid://21076945", "rbxassetid://21077007",
        "rbxassetid://21077125", "rbxassetid://21077227", "rbxassetid://21077345",
        "rbxassetid://21077227", "rbxassetid://21077125", "rbxassetid://21077007",
        "rbxassetid://21076945",
    }
    local mikuSkyWeatherConnections = {}
    local mikuSkyWeatherEffects = {}
    local mikuSkyLockConnection = nil
    local mikuSkyOriginalLighting = nil
    local mikuSkyFrameIndex = 1

    local function applyMikuSkyFrame(sky, asset)
        if not sky or not sky.Parent then return end
        sky.SkyboxBk, sky.SkyboxDn, sky.SkyboxFt = asset, asset, asset
        sky.SkyboxLf, sky.SkyboxRt, sky.SkyboxUp = asset, asset, asset
        sky.CelestialBodiesShown = false
    end

    local function neutralizeMikuSkyEffect(effect)
        if not mikuSkyEnabled or not effect then return end
        if effect:IsA("Sky") then
            if effect == mikuSkyObject then return end
            local known = false
            for _, savedSky in ipairs(mikuStoredSkies) do
                if savedSky == effect then known = true break end
            end
            if not known then table.insert(mikuStoredSkies, effect) end
            pcall(function() effect.Parent = nil end)
        elseif effect:IsA("Atmosphere") then
            if not mikuSkyWeatherEffects[effect] then
                mikuSkyWeatherEffects[effect] = {
                    className = "Atmosphere", Density = effect.Density, Offset = effect.Offset,
                    Color = effect.Color, Decay = effect.Decay, Glare = effect.Glare, Haze = effect.Haze,
                }
            end
            pcall(function()
                effect.Density, effect.Offset = 0, 0
                effect.Color, effect.Decay = Color3.new(1, 1, 1), Color3.new(1, 1, 1)
                effect.Glare, effect.Haze = 0, 0
            end)
        elseif effect:IsA("Clouds") then
            if not mikuSkyWeatherEffects[effect] then
                mikuSkyWeatherEffects[effect] = {
                    className = "Clouds", Cover = effect.Cover, Density = effect.Density, Color = effect.Color,
                }
            end
            pcall(function()
                effect.Cover, effect.Density, effect.Color = 0, 0, Color3.new(1, 1, 1)
            end)
        elseif effect:IsA("ColorCorrectionEffect") then
            if not mikuSkyWeatherEffects[effect] then
                mikuSkyWeatherEffects[effect] = {
                    className = "ColorCorrectionEffect", Enabled = effect.Enabled,
                    Brightness = effect.Brightness, Contrast = effect.Contrast,
                    Saturation = effect.Saturation, TintColor = effect.TintColor,
                }
            end
            pcall(function() effect.Enabled = false end)
        elseif effect:IsA("SunRaysEffect") then
            if not mikuSkyWeatherEffects[effect] then
                mikuSkyWeatherEffects[effect] = {
                    className = "SunRaysEffect", Enabled = effect.Enabled,
                    Intensity = effect.Intensity, Spread = effect.Spread,
                }
            end
            pcall(function() effect.Enabled = false end)
        end
    end

    local function ensureMikuSkyObject()
        if not mikuSkyObject or mikuSkyObject.Parent ~= Lighting then
            local replacement = Instance.new("Sky")
            replacement.Name = "RevHubMikuSky"
            mikuSkyObject = replacement
            replacement.Parent = Lighting
        end
        applyMikuSkyFrame(mikuSkyObject, MIKU_SKY_FRAMES[mikuSkyFrameIndex])
    end

    local function enforceMikuSkyEnvironment()
        if not mikuSkyEnabled then return end
        pcall(function()
            local themePreset = skyTheme ~= "Off" and SKY_PRESETS[skyTheme] or nil
            if themePreset then
                Lighting.ClockTime = themePreset.clock or 14
                Lighting.Brightness = themePreset.brightness or 2
                Lighting.Ambient = themePreset.ambient and vC3(themePreset.ambient) or Color3.fromRGB(185, 185, 195)
                Lighting.OutdoorAmbient = themePreset.outAmb and vC3(themePreset.outAmb) or Color3.fromRGB(185, 185, 195)
                Lighting.GlobalShadows = true
            else
                Lighting.ClockTime = 14
                Lighting.Brightness = 2
                Lighting.Ambient = Color3.fromRGB(185, 185, 195)
                Lighting.OutdoorAmbient = Color3.fromRGB(185, 185, 195)
                Lighting.GlobalShadows = false
            end
            Lighting.GeographicLatitude = 0
            Lighting.FogStart = 0
            Lighting.FogEnd = 100000
            Lighting.FogColor = Color3.new(1, 1, 1)
        end)
        ensureMikuSkyObject()
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect ~= mikuSkyObject then neutralizeMikuSkyEffect(effect) end
        end
        local terrain = Workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            for _, effect in ipairs(terrain:GetChildren()) do neutralizeMikuSkyEffect(effect) end
        end
    end

    local function restoreMikuSkyEnvironment()
        for _, connection in ipairs(mikuSkyWeatherConnections) do
            pcall(function() connection:Disconnect() end)
        end
        table.clear(mikuSkyWeatherConnections)
        if mikuSkyLockConnection then
            pcall(function() mikuSkyLockConnection:Disconnect() end)
            mikuSkyLockConnection = nil
        end
        for effect, old in pairs(mikuSkyWeatherEffects) do
            pcall(function()
                if old.className == "Atmosphere" then
                    effect.Density, effect.Offset = old.Density, old.Offset
                    effect.Color, effect.Decay = old.Color, old.Decay
                    effect.Glare, effect.Haze = old.Glare, old.Haze
                elseif old.className == "Clouds" then
                    effect.Cover, effect.Density, effect.Color = old.Cover, old.Density, old.Color
                elseif old.className == "ColorCorrectionEffect" then
                    effect.Enabled, effect.Brightness = old.Enabled, old.Brightness
                    effect.Contrast, effect.Saturation, effect.TintColor = old.Contrast, old.Saturation, old.TintColor
                elseif old.className == "SunRaysEffect" then
                    effect.Enabled, effect.Intensity, effect.Spread = old.Enabled, old.Intensity, old.Spread
                end
            end)
        end
        table.clear(mikuSkyWeatherEffects)
        local old = mikuSkyOriginalLighting
        if old then
            pcall(function()
                Lighting.ClockTime, Lighting.Brightness = old.ClockTime, old.Brightness
                Lighting.Ambient, Lighting.OutdoorAmbient = old.Ambient, old.OutdoorAmbient
                Lighting.GeographicLatitude = old.GeographicLatitude
                Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor = old.FogStart, old.FogEnd, old.FogColor
                Lighting.GlobalShadows = old.GlobalShadows
            end)
            mikuSkyOriginalLighting = nil
        end
    end

    stopMikuSky = function()
        mikuSkyEnabled = false
        if mikuSkyThread then
            pcall(task.cancel, mikuSkyThread)
            mikuSkyThread = nil
        end
        restoreMikuSkyEnvironment()
        if mikuSkyObject then
            pcall(function() mikuSkyObject:Destroy() end)
            mikuSkyObject = nil
        end
        local stray = Lighting:FindFirstChild("RevHubMikuSky")
        if stray and stray:IsA("Sky") then pcall(function() stray:Destroy() end) end
        for _, savedSky in ipairs(mikuStoredSkies or {}) do
            if savedSky and savedSky.Parent == nil then
                pcall(function() savedSky.Parent = Lighting end)
            end
        end
        mikuStoredSkies = {}
    end

    startMikuSky = function()
        if mikuSkyThread then
            mikuSkyEnabled = true
            return true
        end
        mikuSkyEnabled = true
        if neonWeatherEnabled then
            neonWeatherEnabled = false
            if type(toggleNeonWeather) == "function" then pcall(toggleNeonWeather, false) end
            if setNeonWeatherVisual then pcall(setNeonWeatherVisual, false) end
        end
        mikuStoredSkies = {}
        mikuSkyWeatherEffects = {}
        mikuSkyOriginalLighting = {
            ClockTime = Lighting.ClockTime, Brightness = Lighting.Brightness,
            Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
            GeographicLatitude = Lighting.GeographicLatitude, FogStart = Lighting.FogStart,
            FogEnd = Lighting.FogEnd, FogColor = Lighting.FogColor, GlobalShadows = Lighting.GlobalShadows,
        }
        table.insert(mikuSkyWeatherConnections, Lighting.ChildAdded:Connect(neutralizeMikuSkyEffect))
        table.insert(mikuSkyWeatherConnections, Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
            if mikuSkyEnabled and Lighting.ClockTime ~= 14 then task.defer(enforceMikuSkyEnvironment) end
        end))
        for _, child in ipairs(Lighting:GetChildren()) do neutralizeMikuSkyEffect(child) end
        local terrain = Workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            table.insert(mikuSkyWeatherConnections, terrain.ChildAdded:Connect(neutralizeMikuSkyEffect))
            for _, child in ipairs(terrain:GetChildren()) do neutralizeMikuSkyEffect(child) end
        end
        mikuSkyFrameIndex = 1
        local sky = Instance.new("Sky")
        sky.Name = "RevHubMikuSky"
        mikuSkyObject = sky
        sky.Parent = Lighting
        applyMikuSkyFrame(sky, MIKU_SKY_FRAMES[mikuSkyFrameIndex])
        enforceMikuSkyEnvironment()
        local elapsed = 0
        mikuSkyLockConnection = RunService.Heartbeat:Connect(function(dt)
            if not mikuSkyEnabled then return end
            elapsed += dt
            if elapsed >= 0.5 then
                elapsed = 0
                enforceMikuSkyEnvironment()
            end
        end)
        mikuSkyThread = task.spawn(function()
            while mikuSkyEnabled do
                ensureMikuSkyObject()
                mikuSkyFrameIndex = mikuSkyFrameIndex % #MIKU_SKY_FRAMES + 1
                task.wait(0.1)
            end
            mikuSkyThread = nil
        end)
        return true
    end
    SPECIAL_SKY_OPTIONS = {"Off", "Miku", "Reze", "Calzosky"}
    local function normalizeSpecialSkyMode(mode)
        if mode == "Foto" or mode == "Photo" then return "Calzosky" end
        for _, option in ipairs(SPECIAL_SKY_OPTIONS) do
            if mode == option then return option end
        end
        return "Off"
    end
    setSpecialSkyMode = function(mode, shouldSave)
        mode = normalizeSpecialSkyMode(mode)
        local hadMiku = mikuSkyEnabled or specialSkyMode == "Miku"
        local hadCustom = customSkyEnabled or specialSkyMode == "Reze" or specialSkyMode == "Calzosky"
        if hadMiku then pcall(stopMikuSky) end
        if hadCustom then pcall(applyRevHubCustomSky, false) end
        mikuSkyEnabled = false
        customSkyEnabled = false
        specialSkyMode = "Off"

        if mode == "Miku" then
            local ok, started = pcall(startMikuSky)
            if ok and started then
                specialSkyMode = "Miku"
            else
                pcall(stopMikuSky)
                mikuSkyEnabled = false
            end
        elseif mode == "Reze" or mode == "Calzosky" then
            customSkyPreset = mode == "Calzosky" and "Photo" or "Reze"
            local keepSkyThemeLighting = skyTheme ~= "Off"
            local ok, applied = pcall(applyRevHubCustomSky, true, keepSkyThemeLighting)
            if ok and applied then
                specialSkyMode = mode
            else
                pcall(applyRevHubCustomSky, false)
                customSkyEnabled = false
            end
        end

        if specialSkySelector then specialSkySelector.Text = specialSkyMode end
        if shouldSave and not _isLoading and type(saveAllSettings) == "function" then
            pcall(saveAllSettings)
        end
        return specialSkyMode == mode
    end

    local customSkyRepairQueued = false
    Lighting.ChildRemoved:Connect(function(child)
        if child ~= customSkyInstance or not customSkyEnabled or customSkyRepairQueued then
            return
        end
        customSkyRepairQueued = true
        task.defer(function()
            customSkyRepairQueued = false
            if not customSkyEnabled or customSkyInstance ~= child then
                return
            end
            local replacement = createRevHubCustomSkyInstance()
            customSkyInstance = replacement
            replacement.Parent = Lighting
            enforceRevHubCustomSky()
        end)
    end)
    applyNeonWeather = function()
        if not neonWeatherEnabled then
            restoreLightingState()
            return
        end
        if not _originalLighting then
            saveLightingState()
        end
        Lighting.Brightness = 2.2
        Lighting.ClockTime = 20
        Lighting.OutdoorAmbient = Color3.fromRGB(60, 80, 120)
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 300
        Lighting.FogStart = 0
        Lighting.FogColor = Color3.fromRGB(60, 120, 200)
        Lighting.Ambient = Color3.fromRGB(60, 90, 140)
        local colorCorrectionEffect = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if not colorCorrectionEffect then
            colorCorrectionEffect = Instance.new("ColorCorrectionEffect")
            colorCorrectionEffect.Parent = Lighting
        end
        colorCorrectionEffect.Enabled = true
        colorCorrectionEffect.Brightness = 0.1
        colorCorrectionEffect.Contrast = 0.08
        colorCorrectionEffect.Saturation = 0.08
        colorCorrectionEffect.TintColor = Color3.fromRGB(200, 200, 210)
        local bloomEffect = Lighting:FindFirstChildOfClass("BloomEffect")
        if not bloomEffect then
            local bloomEffect2 = Instance.new("BloomEffect")
            bloomEffect2.Parent = Lighting
            bloomEffect = bloomEffect2
        end
        bloomEffect.Enabled = true
        bloomEffect.Intensity = 0.4
        bloomEffect.Size = 20
        bloomEffect.Threshold = 0.9
    end
end
do
    local noPlayerCollisionState, isNoPlayerCollisionRunning, trackCollisionPart, restoreCollisionPart, enforceCharacterNoCollision, watchCharacterCollision, handleAddedWorkspacePart
    toggleNeonWeather = function(state)
        if state == nil then
            neonWeatherEnabled = not neonWeatherEnabled
        else
            neonWeatherEnabled = state
        end
        applyNeonWeather()
        if setNeonWeatherVisual then
            setNeonWeatherVisual(neonWeatherEnabled)
        end
    end
    paintFloatingBtn = function(button, active)
        if not button then return end
        local btnGrad = button:FindFirstChild("BtnGrad")
        local textLabel = button:FindFirstChild("TextLabel")
        local uiStroke = button:FindFirstChildOfClass("UIStroke")
        button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        if btnGrad then
            btnGrad.Rotation = 0
            if active then
                btnGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 140, 140)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 140, 140)),
                })
            else
                btnGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 10)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(75, 75, 75)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 10)),
                })
            end
        end
        if textLabel then
            textLabel.TextColor3 = active and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        end
        if uiStroke then
            uiStroke.Color = active and Color3.fromRGB(220, 220, 220) or Color3.fromRGB(60, 60, 60)
            uiStroke.Thickness = 2
            uiStroke.Transparency = 0
        end
    end
    applyFloatingButtonScale = function()
        for _, uiScale in ipairs(_floatingUIScales) do
            if uiScale and uiScale.Parent then
                uiScale.Scale = floatingButtonScale
            end
        end
    end
    makeDraggable = function(rootPart, ignoreGlobalUiLock)
        local dragging = false
        local dragStartPosition = nil
        local initialGuiPosition = nil
        local dragInput = nil
        local dragConnection = nil
        local function dragBlocked()
            return (uiLocked and not ignoreGlobalUiLock) or rootPart:GetAttribute("StealBarLocked") == true
        end
        local function overLocalLockButton(input)
            if not ignoreGlobalUiLock then return false end
            local lockButton = rootPart:FindFirstChild("StealBarLock")
            if not lockButton or not lockButton.Visible then return false end
            local point, pos, size = input.Position, lockButton.AbsolutePosition, lockButton.AbsoluteSize
            return point.X >= pos.X and point.X <= pos.X + size.X
                and point.Y >= pos.Y and point.Y <= pos.Y + size.Y
        end
        local function finishDrag()
            dragging = false
            dragInput = nil
            if dragConnection then
                dragConnection:Disconnect()
                dragConnection = nil
            end
            pcall(saveAllSettings)
        end
        rootPart.InputBegan:Connect(function(input)
            if dragBlocked() or overLocalLockButton(input) then
                return
            end
            if _isDraggingButton then
                return
            end
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStartPosition = input.Position
                initialGuiPosition = rootPart.Position
                if dragConnection then dragConnection:Disconnect() end
                dragConnection = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then finishDrag() end
                end)
            end
        end)
        rootPart.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                finishDrag()
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                finishDrag()
            end
        end)
        rootPart.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                if dragBlocked() then
                    finishDrag()
                    return
                end
                if _isDraggingButton then return end
                if not dragStartPosition or not initialGuiPosition then return end
                rootPart.Position = UDim2.new(
                    initialGuiPosition.X.Scale,
                    initialGuiPosition.X.Offset + input.Position.X - dragStartPosition.X,
                    initialGuiPosition.Y.Scale,
                    initialGuiPosition.Y.Offset + input.Position.Y - dragStartPosition.Y
                )
            end
        end)
    end
    setupMovementAndIndicators = function(character)
        if steppedConn then
            steppedConn:Disconnect()
            steppedConn = nil
        end
        if movementLoop then
            movementLoop:Disconnect()
            movementLoop = nil
        end
        local ccAcc = 0
        steppedConn = RunService.Heartbeat:Connect(function(deltaTime)
            ccAcc += deltaTime
            if ccAcc < 0.05 then
                return
            end
            ccAcc = 0
            local plist = getPlayersCached()
            for i = 1, #plist do
                local p = plist[i]
                if p ~= localPlayer then
                    local character = p.Character
                    if character then
                        local children = character:GetChildren()
                        for i2 = 1, #children do
                            local part = children[i2]
                            if part:IsA("BasePart") and part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end
        end)
        movementLoop = RunService.RenderStepped:Connect(function()
            local character = localPlayer.Character
            if not character then
                return
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoid or not humanoidRootPart then
                return
            end
            if
                not autoBatEnabled
                and not autoLeftEnabled
                and not autoRightEnabled
                and not autoBatV2Enabled
                and not batDesyncTpEnabled
                and not useCarrySystem
            then
                if isHumanoidRagdolled(humanoid) then
                    lastMoveDir = zeroVector
                else
                    local moveDirection = humanoid.MoveDirection
                    local spd = getActiveMoveSpeed()
                    if moveDirection.Magnitude > 0 then
                        lastMoveDir = moveDirection
                    else
                        moveDirection = nil
                        if lastMoveDir.Magnitude > 0 then
                            local direction = nil
                            for k in pairs(MOVE_KEYS) do
                                if UserInputService:IsKeyDown(k) then
                                    direction = lastMoveDir
                                    break
                                else
                                    direction = nil
                                end
                            end
                            moveDirection = direction
                        end
                    end
                    applyMovementVelocity(moveDirection, spd, humanoidRootPart)
                end
            end
            if speedLabel then
                local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
                local s = sqrt(
                    assemblyLinearVelocity.X * assemblyLinearVelocity.X
                        + assemblyLinearVelocity.Z * assemblyLinearVelocity.Z
                )
                if s < 0.05 then
                    s = 0
                end
                speedLabel.Text = string.format("%.1f speed", s)
            end
        end)
        setupSpeedIndicator(character)
        startEnemySpeed()
    end
    toggleLockUI = function(state)
        if state == nil then
            uiLocked = not uiLocked
        else
            uiLocked = state
        end
        if uiLocked and editModeEnabled then
            editModeEnabled = false
            if setEditModeVisual then
                setEditModeVisual(false)
            end
        end
        if setLockUIVisual then
            setLockUIVisual(uiLocked)
        end
    end
    toggleEditMode = function(state)
        if state == nil then
            state = not editModeEnabled
        end
        if state and uiLocked then
            state = false
        end
        editModeEnabled = state
        if setEditModeVisual then
            setEditModeVisual(state)
        end
    end
    disableAllAimbots = function()
        if autoBatEnabled then
            disableAutoBat()
            if autoBatSetVisual then
                autoBatSetVisual(false)
            end
            if mobSetAutoBat then
                mobSetAutoBat(false)
            end
        end
        if batDesyncTpEnabled then
            stopBatDesyncTp()
        end
        if autoBatV2Enabled then
            disableBatV2()
            if autoBatV2SetVisual then
                autoBatV2SetVisual(false)
            end
            if batV2FloatingButton then
                local btnFrame = batV2FloatingButton
                if btnFrame then
                    paintFloatingBtn(btnFrame, false)
                end
            end
        end
        return
    end
    stopAllBackgroundTasks = function()
        if movementLoop then
            movementLoop:Disconnect()
            movementLoop = nil
        end
        if steppedConn then
            steppedConn:Disconnect()
            steppedConn = nil
        end
        stopEnemySpeed()
        if stretchEnabled then
            disableStretch()
        end
        if stretchConn then
            stretchConn:Disconnect()
            stretchConn = nil
        end
        if stretchFovConn then
            stretchFovConn:Disconnect()
            stretchFovConn = nil
        end
        if antiRagdollController.isRunning() then
            antiRagdollController.stop()
        end
        if antiRagdollV2State.Enabled then
            disableAntiRagdollV2()
        end
        if antiDieEnabled then
            antiDie.stop()
        end
        if antiFlingEnabled then
            antiFlingShield.stop()
        end
        stopBatCounter()
        stopBatCounterV2()
        stopMedusaCounter()
        stopAutoSteal()
        disableAutoBat()
        if batDesyncTpEnabled then
            stopBatDesyncTp()
        end
        if autoBatV2Enabled then
            disableBatV2()
        end
        stopAutoLeft()
        stopAutoRight()
        if unwalkEnabled and not isActive then
            stopUnwalk()
        end
        if antiLagEnabled then
            disableAntiLag()
        end
        if espEnabled then
            toggleESP(false)
        end
        if dropActive then
            stopDropBrainrot()
        end
        if bodyLockEnabled then
            stopBodyLock()
        end
        _blSuppressCount = 0
        _blWasEnabled = false
        if _blRestoreTimer then
            pcall(task.cancel, _blRestoreTimer)
            _blRestoreTimer = nil
        end
        if _bodyLockConn then
            _bodyLockConn:Disconnect()
            _bodyLockConn = nil
        end
        for _, deltaTime in ipairs(dropConnections) do
            if type(deltaTime) == "thread" then
                pcall(task.cancel, deltaTime)
            elseif type(deltaTime) == "RBXScriptConnection" then
                pcall(deltaTime.Disconnect, deltaTime)
            end
        end
        dropConnections = {}
        dropActive = false
        alPhase = 1
        arPhase = 1
        lastDropTime = 0
        medusaDebounce = false
        medusaLastUsed = 0
    end
    _G.NoPlayerCollisionState = _G.NoPlayerCollisionState or {}
    noPlayerCollisionState = _G.NoPlayerCollisionState
    noPlayerCollisionState.connections = noPlayerCollisionState.connections or {}
    noPlayerCollisionState.parts = noPlayerCollisionState.parts or {}
    noPlayerCollisionState.charConns = noPlayerCollisionState.charConns or {}
    noPlayerCollisionState.running = noPlayerCollisionState.running or false
    isNoPlayerCollisionRunning = function()
        return noPlayerCollisionState.running == true
    end
    trackCollisionPart = function(callback, value)
        if not callback or not callback:IsA("BasePart") then
            return
        end
        if noPlayerCollisionState.parts[callback] then
            return
        end
        local data = {
            cc = callback.CanCollide,
            ct = callback.CanTouch,
        }
        noPlayerCollisionState.parts[callback] = data
        pcall(function()
            callback.CanCollide = false
        end)
        if value then
            pcall(function()
                callback.CanTouch = false
            end)
        end
        data.conn = callback:GetPropertyChangedSignal("CanCollide"):Connect(function()
            if not isNoPlayerCollisionRunning() then
                return
            end
            if callback.CanCollide then
                pcall(function()
                    callback.CanCollide = false
                end)
            end
        end)
        data.destroy = callback.AncestryChanged:Connect(function()
            if callback:IsDescendantOf(game) then
                return
            end
            if data.conn then
                pcall(function()
                    data.conn:Disconnect()
                end)
            end
            if data.destroy then
                pcall(function()
                    data.destroy:Disconnect()
                end)
            end
            noPlayerCollisionState.parts[callback] = nil
        end)
    end
    restoreCollisionPart = function(instance)
        local object = noPlayerCollisionState.parts[instance]
        if not object then
            return
        end
        if object.conn then
            pcall(function()
                object.conn:Disconnect()
            end)
        end
        if object.destroy then
            pcall(function()
                object.destroy:Disconnect()
            end)
        end
        noPlayerCollisionState.parts[instance] = nil
        if instance and instance.Parent then
            pcall(function()
                instance.CanCollide = object.cc
            end)
            pcall(function()
                instance.CanTouch = object.ct
            end)
        end
    end
    enforceCharacterNoCollision = function(callback, value)
        if not callback then
            return
        end
        for _, descendant in ipairs(callback:GetDescendants()) do
            if descendant:IsA("BasePart") and noPlayerCollisionState.parts[descendant] then
                if not (value and descendant.Name == "HumanoidRootPart") then
                    if descendant.CanCollide then
                        pcall(function()
                            descendant.CanCollide = false
                        end)
                    end
                end
            end
        end
    end
    do
        local function watchHumanoidCollisionState(callback, instance, value)
            if not noPlayerCollisionState.charConns[instance] then
                noPlayerCollisionState.charConns[instance] = {}
            end
            table.insert(
                noPlayerCollisionState.charConns[instance],
                callback.StateChanged:Connect(function()
                    if not isNoPlayerCollisionRunning() then
                        return
                    end
                    task.defer(function()
                        if isNoPlayerCollisionRunning() and instance.Parent then
                            enforceCharacterNoCollision(instance, value)
                        end
                    end)
                end)
            )
            table.insert(
                noPlayerCollisionState.charConns[instance],
                callback:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
                    if not isNoPlayerCollisionRunning() then
                        return
                    end
                    task.defer(function()
                        if isNoPlayerCollisionRunning() and instance.Parent then
                            enforceCharacterNoCollision(instance, value)
                        end
                    end)
                end)
            )
        end
        watchCharacterCollision = function(callback, value)
            if not callback then
                return
            end
            if noPlayerCollisionState.charConns[callback] then
                return
            end
            noPlayerCollisionState.charConns[callback] = {}
            local function trackCharacterDescendant(descendant)
                if not isNoPlayerCollisionRunning() then
                    return
                end
                if not descendant:IsA("BasePart") then
                    return
                end
                if value and descendant.Name == "HumanoidRootPart" then
                    return
                end
                trackCollisionPart(descendant, not value)
            end
            for _, descendant in ipairs(callback:GetDescendants()) do
                trackCharacterDescendant(descendant)
            end
            table.insert(
                noPlayerCollisionState.charConns[callback],
                callback.DescendantAdded:Connect(trackCharacterDescendant)
            )
            local humanoid = callback:FindFirstChildOfClass("Humanoid")
            if not humanoid then
                local connection2 = nil
                connection2 = callback.ChildAdded:Connect(function(child)
                    if child:IsA("Humanoid") then
                        connection2:Disconnect()
                        watchHumanoidCollisionState(child, callback, value)
                    end
                end)
                table.insert(noPlayerCollisionState.charConns[callback], connection2)
            else
                watchHumanoidCollisionState(humanoid, callback, value)
            end
            table.insert(
                noPlayerCollisionState.charConns[callback],
                callback.AncestryChanged:Connect(function(child, parent)
                    if parent == nil then
                        local data = noPlayerCollisionState.charConns[callback] or {}
                        for _, connection in ipairs(data) do
                            pcall(function()
                                connection:Disconnect()
                            end)
                        end
                        noPlayerCollisionState.charConns[callback] = nil
                    end
                end)
            )
        end
    end
    do
        local function belongsToOtherPlayer(value)
            local assemblyRootPart = value.AssemblyRootPart
            if not assemblyRootPart then
                return false
            end
            local model = assemblyRootPart:FindFirstAncestorOfClass("Model")
            if not model then
                return false
            end
            local playerFromCharacter = Players:GetPlayerFromCharacter(model)
            return playerFromCharacter ~= nil and playerFromCharacter ~= localPlayer
        end
        handleAddedWorkspacePart = function(descendant)
            if not isNoPlayerCollisionRunning() then
                return
            end
            if not descendant:IsA("BasePart") then
                return
            end
            if noPlayerCollisionState.parts[descendant] then
                return
            end
            task.defer(function()
                if not isNoPlayerCollisionRunning() then
                    return
                end
                if not descendant.Parent then
                    return
                end
                if belongsToOtherPlayer(descendant) then
                    trackCollisionPart(descendant, true)
                end
            end)
        end
    end
    do
        local function startNoPlayerCollision()
            if noPlayerCollisionState.running then
                return
            end
            noPlayerCollisionState.running = true
            local connections = noPlayerCollisionState.connections or {}
            for _, connection2 in ipairs(connections) do
                pcall(function()
                    connection2:Disconnect()
                end)
            end
            noPlayerCollisionState.connections = {}
            local function addCollisionConnection(value)
                table.insert(noPlayerCollisionState.connections, value)
            end
            local function watchPlayerCollision(player)
                if player == localPlayer then
                    return
                end
                if player.Character then
                    watchCharacterCollision(player.Character, false)
                end
                addCollisionConnection(player.CharacterAdded:Connect(function(character)
                    if isNoPlayerCollisionRunning() then
                        watchCharacterCollision(character, false)
                    end
                end))
            end
            for _, player in ipairs(Players:GetPlayers()) do
                watchPlayerCollision(player)
            end
            addCollisionConnection(Players.PlayerAdded:Connect(watchPlayerCollision))
            if localPlayer.Character then
                watchCharacterCollision(localPlayer.Character, true)
            end
            addCollisionConnection(localPlayer.CharacterAdded:Connect(function(character)
                if isNoPlayerCollisionRunning() then
                    watchCharacterCollision(character, true)
                end
            end))
            for _, child in ipairs(Workspace:GetChildren()) do
                handleAddedWorkspacePart(child)
            end
            addCollisionConnection(Workspace.DescendantAdded:Connect(handleAddedWorkspacePart))
            local value = 0
            addCollisionConnection(RunService.Heartbeat:Connect(function(deltaTime)
                if not isNoPlayerCollisionRunning() then
                    return
                end
                value += deltaTime or 0
                if value < 1 then
                    return
                end
                value = 0
                for _, player in ipairs(Players:GetPlayers()) do
                    local character = player.Character
                    if character then
                        local isActive = player == localPlayer
                        enforceCharacterNoCollision(character, isActive)
                        for _, descendant in ipairs(character:GetDescendants()) do
                            if descendant:IsA("BasePart") and not noPlayerCollisionState.parts[descendant] then
                                if not (isActive and descendant.Name == "HumanoidRootPart") then
                                    trackCollisionPart(descendant, not isActive)
                                end
                            end
                        end
                    end
                end
            end))
        end
        local function stopNoPlayerCollision()
            if not noPlayerCollisionState.running then
                return
            end
            noPlayerCollisionState.running = false
            local connections = noPlayerCollisionState.connections or {}
            for _, connection2 in ipairs(connections) do
                pcall(function()
                    connection2:Disconnect()
                end)
            end
            noPlayerCollisionState.connections = {}
            for k, charConn in pairs(noPlayerCollisionState.charConns) do
                for _, connection in ipairs(charConn) do
                    pcall(function()
                        connection:Disconnect()
                    end)
                end
                noPlayerCollisionState.charConns[k] = nil
            end
            for k in pairs(noPlayerCollisionState.parts) do
                restoreCollisionPart(k)
            end
            noPlayerCollisionState.parts = {}
        end
        _G.SetNoPlayerCollision = function(value)
            local noPlayerCollisionEnabled1809 = value and true or false
            noPlayerCollisionEnabled = noPlayerCollisionEnabled1809
            if noPlayerCollisionEnabled1809 then
                startNoPlayerCollision()
            else
                stopNoPlayerCollision()
            end
        end
    end
end
setNoPlayerCollision = function(noPlayerCollision)
    local noPlayerCollisionEnabled1811 = noPlayerCollision and true or false
    noPlayerCollisionEnabled = noPlayerCollisionEnabled1811
    if noPlayerCollisionEnabled1811 then
        if _G.SetNoPlayerCollision then
            _G.SetNoPlayerCollision(true)
        end
    elseif _G.SetNoPlayerCollision then
        _G.SetNoPlayerCollision(false)
    end
end
_G._NoCamCollision = _G._NoCamCollision
    or {
        targetZoom = 10,
        currentZoom = 10,
        zoomConn = nil,
        watchConns = {},
        resync = true,
    }
enableNoCamCollision = function()
    noCamCollisionEnabled = true
    local noCamCollision = _G._NoCamCollision
    local currentCamera2 = workspace.CurrentCamera
    noCamCollision.targetZoom = math.clamp(10, localPlayer.CameraMinZoomDistance, localPlayer.CameraMaxZoomDistance)
    noCamCollision.currentZoom = noCamCollision.targetZoom
    noCamCollision.resync = true
    if noCamCollision.zoomConn then
        noCamCollision.zoomConn:Disconnect()
    end
    noCamCollision.zoomConn = UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if not noCamCollisionEnabled then
            return
        end
        if gameProcessed then
            return
        end
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            noCamCollision.targetZoom = math.clamp(
                noCamCollision.targetZoom - input.Position.Z * 4,
                localPlayer.CameraMinZoomDistance,
                localPlayer.CameraMaxZoomDistance
            )
        end
    end)
    local watchConns = noCamCollision.watchConns or {}
    for _, watchConn in ipairs(watchConns) do
        pcall(function()
            watchConn:Disconnect()
        end)
    end
    noCamCollision.watchConns = {}
    local function markCameraForResync()
        noCamCollision.resync = true
    end
    table.insert(
        noCamCollision.watchConns,
        localPlayer:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(markCameraForResync)
    )
    table.insert(
        noCamCollision.watchConns,
        localPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(markCameraForResync)
    )
    table.insert(
        noCamCollision.watchConns,
        workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(markCameraForResync)
    )
    table.insert(noCamCollision.watchConns, localPlayer.CharacterAdded:Connect(markCameraForResync))
    if currentCamera2 then
        table.insert(
            noCamCollision.watchConns,
            currentCamera2:GetPropertyChangedSignal("CameraType"):Connect(markCameraForResync)
        )
        table.insert(
            noCamCollision.watchConns,
            currentCamera2:GetPropertyChangedSignal("CameraSubject"):Connect(markCameraForResync)
        )
    end
    pcall(function()
        RunService:UnbindFromRenderStep("FictionNoCamCollision")
    end)
    RunService:BindToRenderStep("FictionNoCamCollision", Enum.RenderPriority.Camera.Value + 1, function(value)
        if not noCamCollisionEnabled then
            return
        end
        local currentCamera3 = workspace.CurrentCamera
        if not currentCamera3 then
            return
        end
        if currentCamera3.CameraType == Enum.CameraType.Scriptable then
            noCamCollision.resync = true
            return
        end
        if currentCamera3.CameraSubject == nil then
            noCamCollision.resync = true
            return
        end
        local character = localPlayer.Character
        if not (character and character:FindFirstChild("HumanoidRootPart")) then
            noCamCollision.resync = true
            return
        end
        local cameraMinZoomDistance = localPlayer.CameraMinZoomDistance
        local cameraMaxZoomDistance = localPlayer.CameraMaxZoomDistance
        if cameraMaxZoomDistance <= 1 then
            noCamCollision.resync = true
            return
        end
        local magnitude = (currentCamera3.CFrame.Position - currentCamera3.Focus.Position).Magnitude
        if magnitude < 0.6 then
            noCamCollision.resync = true
            return
        end
        if noCamCollision.resync or magnitude > noCamCollision.currentZoom + 0.5 then
            noCamCollision.targetZoom = math.clamp(magnitude, cameraMinZoomDistance, cameraMaxZoomDistance)
            noCamCollision.currentZoom = noCamCollision.targetZoom
            noCamCollision.resync = false
        end
        noCamCollision.targetZoom = math.clamp(noCamCollision.targetZoom, cameraMinZoomDistance, cameraMaxZoomDistance)
        noCamCollision.currentZoom = noCamCollision.currentZoom
            + (noCamCollision.targetZoom - noCamCollision.currentZoom) * math.min(value * 15, 1)
        currentCamera3.CFrame = currentCamera3.Focus
            * currentCamera3.CFrame.Rotation
            * newCFrame(0, 0, noCamCollision.currentZoom)
    end)
end
disableNoCamCollision = function()
    noCamCollisionEnabled = false
    pcall(function()
        RunService:UnbindFromRenderStep("FictionNoCamCollision")
    end)
    if _G._NoCamCollision.zoomConn then
        _G._NoCamCollision.zoomConn:Disconnect()
        _G._NoCamCollision.zoomConn = nil
    end
    local watchConns = _G._NoCamCollision.watchConns or {}
    for _, watchConn in ipairs(watchConns) do
        pcall(function()
            watchConn:Disconnect()
        end)
    end
    _G._NoCamCollision.watchConns = {}
end
buildConfigTable = function()
    local config = {
        normalSpeed = NS,
        carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED,
        laggerSpeed2 = LAGGER_CARRY_SPEED,
        stealRadius = CONFIG.STEAL_RANGE,
        antiRagdollMode = antiRagdollMode,
        antiDieEnabled = antiDieEnabled,
        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
        medusaCounter = medusaCounterEnabled,
        batCounter = batCounterEnabled,
        batCounterV2 = batCounterV2Enabled,
        laggerToggled = laggerToggled,
        laggerCarryToggled = laggerCarryToggled,
        carryMode = speedMode,
        batAimbotSpeed = BAT_AIMBOT_SPEED,
        dropMode = dropMode,
        stretchEnabled = stretchEnabled,
        stretchFOV = stretchFOV,
        fovEnabled = fovEnabled,
        fovValue = fovValue,
        uiScale = uiScaleValue,
        mainTab = mainTabIndex or 1,
        musicPlayerVolume = musicPlayerVolume or 0.75,
        musicPlayerLoop = musicPlayerLoop == true,
        musicPlayerIndex = musicPlayerIndex or 1,
        animPack = currentAnimPack,
        espEnabled = espEnabled,
        antiLag = antiLagEnabled,
        tpBatEnabled = batDesyncTpEnabled,
        neonWeather = neonWeatherEnabled,
        skyTheme = skyTheme,
        specialSkyMode = specialSkyMode or "Off",
        customSkyEnabled = customSkyEnabled == true,
        mikuSkyEnabled = mikuSkyEnabled == true,
        autoBatV2Enabled = autoBatV2Enabled,
        batV2Version = batV2Version or "Version 2",
        batV2Profile = batV2Version or "Version 2",
        BAT_V2_VERSION = batV2Version or "Version 2",
        batV2Speed = tonumber(BAT_V2_SPEED) or tonumber(_G.AceAntiBypassAimbotSpeed) or 55,
        selectedAimbotMode = selectedAimbotMode,
        ANTI_BYPASS_AIMBOT_SPEED = _G.AceAntiBypassAimbotSpeed,
        ANTI_BYPASS_LAGGER_AIMBOT_SPEED = _G.AceAntiBypassLaggerAimbotSpeed,
        antiBypassAimbotEnabled = _G.AceAntiBypassAimbotOn == true,
        bat3DSkinEnabled = bat3DSkinEnabled,
        medusa3DSkinEnabled = medusa3DSkinEnabled,
        customSoundsEnabled = customSoundsEnabled == true,
        rainbowToolsEnabled = rainbowToolsEnabled == true,
        customBat3DSkin = customBat3DSkin,
        customMedusa3DSkin = customMedusa3DSkin,
        cleanHubSongIndex = currentIntroSongIndex,
        cleanHubAutoTPDown = CleanHubAutoTPDown,
        cleanHubAutoTPDownHeight = CleanHubAutoTPDownHeight,
        cleanHubShowE01Warning = CleanHubShowE01Warning,
        unwalk = unwalkEnabled,
        holdJumpEnabled = infJumpEnabled,
        holdJumpMode = infJumpMode,
        mirrorTPDown = mirrorTPDownEnabled,
        safeMode = antiKickEnabled,
        noPlayerCollision = noPlayerCollisionEnabled == true,
        noCamCollision = noCamCollisionEnabled == true,
        hideMobileButtons = _G.AmbitiousHideMobileButtons == true,
        mobileButtonPositions = savedButtonPositions,
        dropBrainrotKey = {
            kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name,
            gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name,
        },
        autoLeftKey = {
            kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name,
            gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name,
        },
        autoRightKey = {
            kb = KB.AutoRight.kb and KB.AutoRight.kb.Name,
            gp = KB.AutoRight.gp and KB.AutoRight.gp.Name,
        },
        autoBatKey = {
            kb = KB.AutoBat.kb and KB.AutoBat.kb.Name,
            gp = KB.AutoBat.gp and KB.AutoBat.gp.Name,
        },
        tpFloorKey = {
            kb = KB.TPFloor.kb and KB.TPFloor.kb.Name,
            gp = KB.TPFloor.gp and KB.TPFloor.gp.Name,
        },
        carryToggleKey = {
            kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name,
            gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name,
        },
        laggerModeKey = {
            kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name,
            gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name,
        },
        tpBatKey = {
            kb = KB.TPBat.kb and KB.TPBat.kb.Name,
            gp = KB.TPBat.gp and KB.TPBat.gp.Name,
        },
        batV2Key = {
            kb = KB.BatV2.kb and KB.BatV2.kb.Name,
            gp = KB.BatV2.gp and KB.BatV2.gp.Name,
        },
        instaResetKey = {
            kb = KB.InstaReset.kb and KB.InstaReset.kb.Name,
            gp = KB.InstaReset.gp and KB.InstaReset.gp.Name,
        },
        tpBatFloatingPos = tpBatFloatingPos,
        batV2FloatingPos = batV2FloatingPos,
        instaResetFloatingPos = instaResetFloatingPos,
        bodyLockEnabled = bodyLockEnabled,
        bodyLockRange = bodyLockRange,
        progressBarPos = savedProgressBarPos,
        progressBarScale = progressBarScale,
        progressBarLocked = savedProgressBarLocked == true,
        lockUI = uiLocked,
        editMode = editModeEnabled,
        floatingButtonScale = floatingButtonScale,
        outfitIndex = currentOutfitIndex,
        backgroundIndex = backgroundIndex,
        calzoskyBackgroundVersion = 1,
        backgroundImageTransparency = backgroundImageTransparency,
        themeColor = currentColorTheme,
        useCarrySystem = useCarrySystem,
        autoStealVariant = autoStealVariant,
        carrySysNormal = carryController.normalSpeed,
        carrySysCarry = carryController.carrySpeed,
        carrySysLagger = carryController.laggerSpeed,
        carrySysLaggerCarry = carryController.laggerCarrySpeed,
        carrySysSoftStealSpeed = carryController.softStealSpeed,
        carrySysSoftStealRadius = carryController.softStealRadius,
    }
    if pbFrame then
        config.progressBarPos = {
            XScale = pbFrame.Position.X.Scale,
            XOffset = pbFrame.Position.X.Offset,
            YScale = pbFrame.Position.Y.Scale,
            YOffset = pbFrame.Position.Y.Offset,
        }
    end
    return config
end
saveAllSettings = function()
    if _isResetting then
        return true
    end
    local config = buildConfigTable()
    local json = HttpService:JSONEncode(config)
    if json == _lastSavedJSON then
        return true
    end
    local ok = pcall(function()
        writefile(CONFIG_FILE, json)
    end)
    if ok then
        _lastSavedJSON = json
    end
    return ok
end
local function persistBatV2Version()
    if _isResetting or type(writefile) ~= "function" then return false end
    local ok, err = pcall(function()
        local config = buildConfigTable()
        config.batV2Version = batV2Version or "Version 2"
        config.batV2Profile = config.batV2Version
        config.BAT_V2_VERSION = config.batV2Version
        local json = HttpService:JSONEncode(config)
        writefile(CONFIG_FILE, json)
        if type(readfile) == "function" then
            local verify = HttpService:JSONDecode(readfile(CONFIG_FILE))
            local savedVersion = verify.batV2Version or verify.batV2Profile or verify.BAT_V2_VERSION
            if savedVersion ~= config.batV2Version then
                error("La verificación de FictionHub.json no coincide")
            end
        end
        _lastSavedJSON = json
    end)
    if not ok then
        warn("[Calzosky Hub] No se pudo verificar el guardado de Bat V2: " .. tostring(err))
    end
    return ok
end
loadAllSettings = function()
    if not isfile or not isfile(CONFIG_FILE) then
        return false
    end
    local ok, result = pcall(function()
        return HttpService:JSONDecode(readfile(CONFIG_FILE))
    end)
    if not ok or not result then
        return false
    end
    _isLoading = true
    NS = result.normalSpeed or NS
    CS = result.carrySpeed or CS
    LAGGER_SPEED = result.laggerSpeed1 or LAGGER_SPEED
    LAGGER_CARRY_SPEED = result.laggerSpeed2 or LAGGER_CARRY_SPEED
    CONFIG.STEAL_RANGE = result.stealRadius or CONFIG.STEAL_RANGE
    if radInput then
        radInput.Text = tostring(CONFIG.STEAL_RANGE)
    end
    uiLocked = result.lockUI or true
    editModeEnabled = result.editMode or false
    if result.antiRagdollMode then
        antiRagdollMode = result.antiRagdollMode
    else
        antiRagdollMode = result.antiRagdoll and "v2" or "off"
    end
    antiDieEnabled = result.antiDieEnabled or false
    antiFlingEnabled = result.antiFlingEnabled or false
    CONFIG.AUTO_STEAL_ENABLED = result.autoSteal or false
    medusaCounterEnabled = result.medusaCounter or false
    batCounterEnabled = result.batCounter or false
    batCounterV2Enabled = result.batCounterV2 or false
    unwalkEnabled = result.unwalk or false
    antiLagEnabled = result.antiLag or false
    laggerToggled = result.laggerToggled or false
    speedMode = result.carryMode or false
    laggerCarryToggled = result.laggerCarryToggled or false
    uiScaleValue = 70
    mainTabIndex = math.clamp(math.floor(tonumber(result.mainTab) or 1), 1, 5)
    musicPlayerVolume = math.clamp(tonumber(result.musicPlayerVolume) or 0.75, 0, 1)
    musicPlayerLoop = result.musicPlayerLoop == true
    musicPlayerIndex = math.max(1, math.floor(tonumber(result.musicPlayerIndex) or 1))
    if mainUIScale then
        mainUIScale.Scale = uiScaleValue / 100
    end
    progressBarScale = result.progressBarScale or 1
    if pbScale then
        pbScale.Scale = progressBarScale
    end
    espEnabled = result.espEnabled or false
    if espEnabled then
        toggleESP(true)
    else
        toggleESP(false)
    end
    currentColorTheme = "Gris"
    selectedColor = colorThemes["Gris"]
    _G.AceAntiBypassLoadFromConfig(result)
    local savedBatV2Version = result.batV2Version or result.batV2Profile or result.BAT_V2_VERSION
    batV2Version = savedBatV2Version == "Version 1" and "Version 1" or "Version 2"
    BAT_V2_SPEED = math.clamp(tonumber(result.batV2Speed) or tonumber(_G.AceAntiBypassAimbotSpeed) or tonumber(BAT_V2_SPEED) or 55, 1, 500)
    _G.AceAntiBypassAimbotSpeed = BAT_V2_SPEED
    if applyBatV2VersionProfile then pcall(applyBatV2VersionProfile) end
    if batV2VersionSelector then batV2VersionSelector.Text = batV2Version end
    if batV2SpeedBox then batV2SpeedBox.Text = tostring(BAT_V2_SPEED) end
    autoBatV2Enabled = _G.AceAntiBypassAimbotOn == true
    if autoBatV2Enabled then
        task.defer(function()
            enableBatV2()
            if autoBatV2SetVisual then
                autoBatV2SetVisual(true)
            end
        end)
    elseif autoBatV2SetVisual then
        autoBatV2SetVisual(false)
    end
    bat3DSkinEnabled = result.bat3DSkinEnabled == true
    medusa3DSkinEnabled = result.medusa3DSkinEnabled == true
    customSoundsEnabled = result.customSoundsEnabled == true
    rainbowToolsEnabled = result.rainbowToolsEnabled == true
    if _G.AmbitiousCustomSounds then
        pcall(_G.AmbitiousCustomSounds.setEnabled, customSoundsEnabled)
    end
    if _G.AmbitiousRainbowTools then
        pcall(_G.AmbitiousRainbowTools.setEnabled, rainbowToolsEnabled)
    end
    if type(result.customBat3DSkin) == "string" then
        local data = customTool3DAssets[result.customBat3DSkin]
        if data and data.cat == "Bat" then
            customBat3DSkin = result.customBat3DSkin
        end
    end
    if type(result.customMedusa3DSkin) == "string" then
        local data = customTool3DAssets[result.customMedusa3DSkin]
        if data and data.cat == "Medusa" then
            customMedusa3DSkin = result.customMedusa3DSkin
        end
    end
    if type(result.cleanHubSongIndex) == "number" then
        local value = #introSongIds
        currentIntroSongIndex = math.clamp(math.floor(result.cleanHubSongIndex), 1, value)
    end
    CleanHubAutoTPDown = result.cleanHubAutoTPDown == true
    CleanHubAutoTPDownHeight = math.clamp(tonumber(result.cleanHubAutoTPDownHeight) or CleanHubAutoTPDownHeight, 0, 500)
    CleanHubShowE01Warning = result.cleanHubShowE01Warning == true
    if CleanHubAutoTPDownSetVisual then
        CleanHubAutoTPDownSetVisual(CleanHubAutoTPDown)
    end
    if CleanHubShowE01WarningSetVisual then
        CleanHubShowE01WarningSetVisual(CleanHubShowE01Warning)
    end
    tpBatVersion = 1
    _G.__tpBatV2Distance = 8
    infJumpEnabled = result.holdJumpEnabled == true
    infJumpMode = result.holdJumpMode == "MANUAL" and "MANUAL" or "HOLD"
    mirrorTPDownEnabled = result.mirrorTPDown == true
    antiKickEnabled = result.safeMode == true
    noPlayerCollisionEnabled = result.noPlayerCollision == true
    noCamCollisionEnabled = result.noCamCollision == true
    if noPlayerCollisionEnabled then
        if _G.SetNoPlayerCollision then
            _G.SetNoPlayerCollision(true)
        end
    end
    if noCamCollisionEnabled then
        enableNoCamCollision()
    end
    if setNoPlayerCollisionVisual then
        setNoPlayerCollisionVisual(noPlayerCollisionEnabled)
    end
    if setNoCamCollisionVisual then
        setNoCamCollisionVisual(noCamCollisionEnabled)
    end
    _G.AmbitiousHideMobileButtons = result.hideMobileButtons == true
    _G.AmbitiousMobileHideList = {}
    if result.tpBatEnabled then
        task.defer(function()
            startBatDesyncTp()
            if batDesyncTpSetVisual then
                batDesyncTpSetVisual(true)
            end
        end)
    elseif batDesyncTpSetVisual then
        batDesyncTpSetVisual(false)
    end
    skyTheme = type(result.skyTheme) == "string" and result.skyTheme or "Off"
    if not SKY_PRESETS[skyTheme] then
        skyTheme = "Off"
    end
    local loadedSpecialSkyMode = result.specialSkyMode
    if loadedSpecialSkyMode == "Photo" or loadedSpecialSkyMode == "Foto" then loadedSpecialSkyMode = "Calzosky" end
    if loadedSpecialSkyMode ~= "Off" and loadedSpecialSkyMode ~= "Miku" and loadedSpecialSkyMode ~= "Reze" and loadedSpecialSkyMode ~= "Calzosky" then
        if result.customSkyEnabled == true then
            loadedSpecialSkyMode = "Reze"
        elseif result.mikuSkyEnabled == true then
            loadedSpecialSkyMode = "Miku"
        else
            loadedSpecialSkyMode = "Off"
        end
    end
    specialSkyMode = "Off"
    customSkyEnabled = false
    mikuSkyEnabled = false
    neonWeatherEnabled = result.neonWeather == true and loadedSpecialSkyMode == "Off"
    if neonWeatherEnabled then
        task.defer(function()
            toggleNeonWeather(true)
        end)
    else
        toggleNeonWeather(false)
    end
    pcall(applyCustomSky, skyTheme)
    setSpecialSkyMode(loadedSpecialSkyMode, false)
    if specialSkySelector then
        specialSkySelector.Text = specialSkyMode
    end
    if skySelectorLabel then
        skySelectorLabel.Text = skyTheme
    end
    if result.animPack and ANIM_PACKS[result.animPack] then
        applyAnimationPack(result.animPack)
    else
        currentAnimPack = "Off"
        disableAnimationPack()
    end
    local function lk(e, d)
        if not d then
            return
        end
        if d.kb and Enum.KeyCode[d.kb] then
            e.kb = Enum.KeyCode[d.kb]
        end
        if d.gp and Enum.KeyCode[d.gp] then
            e.gp = Enum.KeyCode[d.gp]
        end
    end
    lk(KB.DropBrainrot, result.dropBrainrotKey)
    lk(KB.AutoLeft, result.autoLeftKey)
    lk(KB.AutoRight, result.autoRightKey)
    lk(KB.AutoBat, result.autoBatKey)
    lk(KB.TPFloor, result.tpFloorKey)
    lk(KB.CarryToggle, result.carryToggleKey)
    lk(KB.LaggerMode, result.laggerModeKey)
    lk(KB.TPBat, result.tpBatKey)
    lk(KB.BatV2, result.batV2Key)
    lk(KB.InstaReset, result.instaResetKey)
    if result.mobileButtonPositions then
        savedButtonPositions = result.mobileButtonPositions
    end
    if result.mobilePanelPos then
        savedMobilePanelPos = result.mobilePanelPos
    end
    if result.tpBatFloatingPos then
        tpBatFloatingPos = result.tpBatFloatingPos
    end
    if result.batV2FloatingPos then
        batV2FloatingPos = result.batV2FloatingPos
    end
    if result.instaResetFloatingPos then
        instaResetFloatingPos = result.instaResetFloatingPos
    end
    if result.progressBarPos then
        savedProgressBarPos = result.progressBarPos
    end
    savedProgressBarLocked = result.progressBarLocked == true
    if setStealBarLockVisual then
        setStealBarLockVisual(savedProgressBarLocked)
    elseif pbFrame then
        pbFrame:SetAttribute("StealBarLocked", savedProgressBarLocked)
    end
    if result.bodyLockEnabled ~= nil then
        bodyLockEnabled = result.bodyLockEnabled
        if bodyLockEnabled then
            task.defer(function()
                if bodyLockSetVisual then
                    bodyLockSetVisual(true)
                end
                startBodyLock()
            end)
        end
    end
    if result.bodyLockRange then
        bodyLockRange = result.bodyLockRange
        if bodyLockRangeBox then
            bodyLockRangeBox.Text = tostring(bodyLockRange)
        end
    end
    dropMode = result.dropMode or 1
    stretchEnabled = result.stretchEnabled or false
    fovValue = result.fovValue or 70
    fovEnabled = result.fovEnabled or false
    if fovSliderSet then
        fovSliderSet(fovValue)
    end
    if fovEnabled then
        enableCustomFov()
    end
    if setFovVisual then
        setFovVisual(fovEnabled)
    end
    stretchFOV = result.stretchFOV or 120
    BAT_AIMBOT_SPEED = result.batAimbotSpeed or BAT_AIMBOT_SPEED
    floatingButtonScale = result.floatingButtonScale or 1
    if result.outfitIndex and result.outfitIndex >= 1 and result.outfitIndex <= #outfits then
        currentOutfitIndex = result.outfitIndex
        task.defer(function()
            pcall(function()
                applyOutfitByIndex(currentOutfitIndex)
            end)
            if outfitSelectorLabel then
                outfitSelectorLabel.Text = outfits[currentOutfitIndex].label
            end
        end)
    end
    if tonumber(result.calzoskyBackgroundVersion) ~= 1 then
        backgroundIndex = #BACKGROUND_IMAGES
    elseif result.backgroundIndex ~= nil then
        local loadedBackgroundIndex = tonumber(result.backgroundIndex)
        if loadedBackgroundIndex then
            backgroundIndex = clamp(floor(loadedBackgroundIndex), 1, #BACKGROUND_IMAGES)
        end
    end
    if result.backgroundImageTransparency ~= nil then
        backgroundImageTransparency = clamp(result.backgroundImageTransparency, 0, 0.12)
    end
    useCarrySystem = result.useCarrySystem or false
    autoStealVariant = clamp(tonumber(result.autoStealVariant) or 1, 1, 3)
    if autoStealVariantLabel then
        autoStealVariantLabel.Text = getAutoStealVariantName(autoStealVariant)
    end
    carryController.normalSpeed = result.carrySysNormal or NS
    carryController.carrySpeed = result.carrySysCarry or CS
    carryController.laggerSpeed = result.carrySysLagger or LAGGER_SPEED
    carryController.laggerCarrySpeed = result.carrySysLaggerCarry or LAGGER_CARRY_SPEED
    carryController.softStealSpeed = result.carrySysSoftStealSpeed or 30
    carryController.softStealRadius = result.carrySysSoftStealRadius or 10
    if useCarrySystem then
        carryController:start()
        carryController.speedToggled = speedMode
        if laggerCarryToggled then
            carryController:setLaggerMode(2)
        elseif laggerToggled then
            carryController:setLaggerMode(1)
        else
            carryController:setLaggerMode(0)
        end
    else
        carryController:stop()
    end
    autoBatEnabled = false
    autoLeftEnabled = false
    autoRightEnabled = false
    if dropModeBtnRef then
        dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop"
    end
    refreshSpeedModeLabel()
    if unwalkEnabled then
        task.defer(function()
            startUnwalk()
            if setUnwalkVisual then
                setUnwalkVisual(true)
            end
        end)
    elseif setUnwalkVisual then
        setUnwalkVisual(false)
    end
    _lastSavedJSON = HttpService:JSONEncode(buildConfigTable())
    _isLoading = false
    return true
end
forceResetUI = function()
    if normalBox then
        normalBox.Text = tostring(NS)
    end
    if carryBox then
        carryBox.Text = tostring(CS)
    end
    if radInput then
        radInput.Text = tostring(CONFIG.STEAL_RANGE)
    end
    if laggerBox then
        laggerBox.Text = tostring(LAGGER_SPEED)
    end
    if lagger2Box then
        lagger2Box.Text = tostring(LAGGER_CARRY_SPEED)
    end
    if batSpeedBox then
        batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED)
    end
    if uiScaleBox then
        uiScaleBox.Text = tostring(uiScaleValue)
    end
    if dropModeBtnRef then
        dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop"
    end
    if bodyLockRangeBox then
        bodyLockRangeBox.Text = tostring(bodyLockRange)
    end
    if carrySysNormalBox then
        carrySysNormalBox.Text = tostring(carryController.normalSpeed)
    end
    if carrySysCarryBox then
        carrySysCarryBox.Text = tostring(carryController.carrySpeed)
    end
    if carrySysLaggerBox then
        carrySysLaggerBox.Text = tostring(carryController.laggerSpeed)
    end
    if carrySysLaggerCarryBox then
        carrySysLaggerCarryBox.Text = tostring(carryController.laggerCarrySpeed)
    end
    if carrySysSoftStealSpeedBox then
        carrySysSoftStealSpeedBox.Text = tostring(carryController.softStealSpeed)
    end
    if carrySysSoftStealRadiusBox then
        carrySysSoftStealRadiusBox.Text = tostring(carryController.softStealRadius)
    end
    if carrySystemToggleSetter then
        carrySystemToggleSetter(useCarrySystem)
    end
    local function setVisualSafely(callback, visible)
        if callback then
            callback(visible)
        end
    end
    setVisualSafely(autoBatSetVisual, false)
    setVisualSafely(autoLeftSetVisual, false)
    setVisualSafely(autoRightSetVisual, false)
    setVisualSafely(setBatCounterVisual, false)
    setVisualSafely(setBatCounterV2Visual, false)
    setVisualSafely(setMedusaVisual, false)
    setVisualSafely(setUnwalkVisual, false)
    setVisualSafely(setAntiLagVisual, false)
    setVisualSafely(setLockUIVisual, false)
    setVisualSafely(setEditModeVisual, false)
    setVisualSafely(setInstaGrab, false)
    setVisualSafely(batDesyncTpSetVisual, false)
    setVisualSafely(setESPVIsual, false)
    setVisualSafely(bodyLockSetVisual, false)
    setVisualSafely(setNeonWeatherVisual, false)
    setVisualSafely(autoBatV2SetVisual, false)
    setVisualSafely(setAntiDieVisual, false)
    setVisualSafely(setBat3DSkinVisual, false)
    setVisualSafely(setMedusa3DSkinVisual, false)
    customSoundsEnabled = false
    rainbowToolsEnabled = false
    if _G.AmbitiousCustomSounds then pcall(_G.AmbitiousCustomSounds.setEnabled, false) end
    if _G.AmbitiousRainbowTools then pcall(_G.AmbitiousRainbowTools.setEnabled, false) end
    setVisualSafely(setCustomSoundsVisual, false)
    setVisualSafely(setRainbowToolsVisual, false)
    setVisualSafely(setSafeModeVisual, false)
    setVisualSafely(mirrorTPDownSetVisual, false)
    setVisualSafely(infJumpSetVisual, false)
    setVisualSafely(infJumpModeSetVisual, nil)
    noPlayerCollisionEnabled = false
    noCamCollisionEnabled = false
    if _G.SetNoPlayerCollision then
        _G.SetNoPlayerCollision(false)
    end
    disableNoCamCollision()
    setVisualSafely(setNoPlayerCollisionVisual, false)
    setVisualSafely(setNoCamCollisionVisual, false)
    if _G.stretchToggleSetter then
        _G.stretchToggleSetter(false)
    end
    setVisualSafely(mobSetAutoBat, false)
    setVisualSafely(mobSetAutoLeft, false)
    setVisualSafely(mobSetAutoRight, false)
    setVisualSafely(mobSetDropBR, false)
    setVisualSafely(mobSetTpDown, false)
    setVisualSafely(mobSetCarry, false)
    setVisualSafely(mobSetLagger1, false)
    setVisualSafely(mobSetLagger2, false)
    if _G.__RivalHubFloat and _G.__RivalHubFloat.running then
        pcall(_G.__RivalHubFloat.disable)
    end
    setVisualSafely(mobSetFloat, false)
    autoStealVariant = 1
    if autoStealVariantLabel then
        autoStealVariantLabel.Text = getAutoStealVariantName(1)
    end
    tpBatVersion = 1
    _G.__tpBatV2Distance = 8
    bat3DSkinEnabled = false
    medusa3DSkinEnabled = false
    customBat3DSkin = "DiamondSword"
    customMedusa3DSkin = "GoldenDesertEagle"
    if customTool3DSkinCards.Bat then
        customTool3DSkinCards.Bat.setSkin(customBat3DSkin)
    end
    if customTool3DSkinCards.Medusa then
        customTool3DSkinCards.Medusa.setSkin(customMedusa3DSkin)
    end
    pcall(refreshCustomTool3DSkins)
    refreshSpeedModeLabel()
    updateProgressBarVisibility()
    savedProgressBarLocked = false
    if setStealBarLockVisual then setStealBarLockVisual(false) end
    disableAntiLag()
    if mikuSkyEnabled then pcall(stopMikuSky) end
    mikuSkyEnabled = false
    setVisualSafely(setMikuSkyVisual, false)
    uiScaleValue = 70
    if mainUIScale then mainUIScale.Scale = 0.7 end
    if uiScaleBox then uiScaleBox.Text = "70" end
    customSkyEnabled = false
    pcall(applyRevHubCustomSky, false)
    setVisualSafely(setCustomSkyVisual, false)
    toggleNeonWeather(false)
    skyTheme = "Off"
    specialSkyMode = "Off"
    customSkyPreset = "Reze"
    if specialSkySelector then specialSkySelector.Text = "Off" end
    pcall(applyCustomSky, "Off")
    if skySelectorLabel then
        skySelectorLabel.Text = "Off"
    end
    disableBatV2()
    if antiDieEnabled then
        antiDie.stop()
        antiDieEnabled = false
    end
    if antiFlingEnabled then
        antiFlingShield.stop()
        antiFlingEnabled = false
    end
    for _, entry1857 in ipairs(keyButtonRefs) do
        local entry = entry1857.entry
        entry1857.btn.Text = entry.gp and entry.gp.Name or entry.kb and entry.kb.Name or "None"
    end
    currentColorTheme = "Gris"
    selectedColor = colorThemes["Gris"]
    updateAllUIThemeColors(selectedColor)
    backgroundIndex = #BACKGROUND_IMAGES
    if backgroundImage then
        applyBackground(backgroundIndex)
    end
    if contentPages and contentPages.Visual then
        for _, child in ipairs(contentPages.Visual:GetChildren()) do
            if child:IsA("Frame") and child:FindFirstChild("BackgroundPreview") then
                local previewImage = child.BackgroundPreview:FindFirstChild("PreviewImage")
                local previewPlaceholder = child.BackgroundPreview:FindFirstChild("PreviewPlaceholder")
                local resetBackground = BACKGROUND_IMAGES[backgroundIndex]
                if previewImage then
                    previewImage.Image = resetBackground and resetBackground.id or ""
                end
                if previewPlaceholder then
                    previewPlaceholder.Visible = not resetBackground or not resetBackground.id or resetBackground.id == ""
                end
                break
            end
        end
    end
    if miniBtn then
        miniBtn.TextColor3 = Color3.fromRGB(210, 210, 220)
    end
    local playerGui = localPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        local ragCountdownBillboard = playerGui:FindFirstChild("RagCountdownBillboard")
        if ragCountdownBillboard then
            local textLabel = ragCountdownBillboard:FindFirstChildOfClass("TextLabel")
            if textLabel then
                textLabel.TextColor3 = Color3.fromRGB(85, 85, 255)
            end
        end
    end
    if MobilePanel then
        for _, child in ipairs(MobilePanel:GetChildren()) do
            if child:IsA("TextButton") and child:FindFirstChild("BtnGrad") then
                paintFloatingBtn(child, child:GetAttribute("MobActive") == true)
            end
        end
    end
    saveAllSettings()
end
resetFloatingPositions = function()
    savedButtonPositions = {}
    if MobilePanel then
        for _, button in ipairs(MobilePanel:GetChildren()) do
            if button:IsA("TextButton") then
                local x, y = getDefaultButtonPosition(button.Name)
                button.Position = UDim2.new(1, x, 1, y)
            end
        end
    end
    tpBatFloatingPos = nil
    batV2FloatingPos = nil
    instaResetFloatingPos = nil
    savedMobilePanelPos = nil
    if pbFrame then
        pbFrame.Position = UDim2.new(0.5, -160, 0.85, 0)
        savedProgressBarPos = nil
    end
    saveAllSettings()
end
updateProgressBarVisibility = function()
    if pbFrame then
        pbFrame.Visible = CONFIG.AUTO_STEAL_ENABLED
    end
end
applyShimmerToText = function(object, speed)
    local value = speed or 0.8
    local color = getThemeColor()
    local uiGradient = Instance.new("UIGradient", object)
    local data = {}
    local object = ColorSequenceKeypoint.new(0, color)
    local object1953 = ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200, 200, 200))
    local object1954 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 85))
    local object1955 = ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200, 200, 200))
    data[1] = object
    data[2] = object1953
    data[3] = object1954
    data[4] = object1955
    data[5] = ColorSequenceKeypoint.new(1, color)
    uiGradient.Color = ColorSequence.new(data)
    uiGradient.Rotation = 45
    uiGradient.Offset = Vector2.new(0, 0)
    task.spawn(function()
        local deltaTime = 0
        while uiGradient and uiGradient.Parent do
            deltaTime += 0.02
            uiGradient.Offset = Vector2.new(math.sin(deltaTime * value) * 0.4, 0)
            task.wait(0.04)
        end
    end)
    return uiGradient
end
getDefaultButtonPosition = function(btnName)
    local layout = {
        TPBat = {1, 1}, BatNormal = {2, 1}, AutoBat = {2, 1}, AutoRight = {3, 1},
        BatV2 = {1, 2}, DropBR = {2, 2}, AutoLeft = {3, 2}, Reset = {1, 3},
        InstaReset = {1, 3}, Carry = {2, 3}, TpDown = {3, 3}, Lagger1 = {2, 4},
        Lagger2 = {3, 4},
    }
    local cell = layout[btnName] or {1, 1}
    local size, gap, marginX, marginY = 55, 6, 10, 150
    local xOffset = -marginX - ((3 - cell[1]) * (size + gap)) - size
    local yOffset = -marginY - ((4 - cell[2]) * (size + gap)) - size
    return xOffset, yOffset
end
_G.AmbitiousHideMobileButtons = _G.AmbitiousHideMobileButtons == true
_G.AmbitiousMobileHideList = {}
_G.AmbitiousMobileHideIncluded = function(_)
    return true
end
_G.AmbitiousApplyMobileButtonsHidden = function()
    local hideAll = _G.AmbitiousHideMobileButtons == true
    local nameToKey = {
        TPBat = "tpBat", BatNormal = "aimbot", BatV2 = "batV2", Reset = "instaReset",
        AutoRight = "autoRight", AutoLeft = "autoLeft", DropBR = "drop", TpDown = "tp",
        Carry = "carry", Lagger1 = "laggerNormal", Lagger2 = "laggerCarry",
    }
    local parents = {game:GetService("CoreGui"), localPlayer and localPlayer:FindFirstChildOfClass("PlayerGui")}
    for _, parent in ipairs(parents) do
        if parent then
            local panel = parent:FindFirstChild("FictionHubMobilePanel")
            if panel then
                for _, button in ipairs(panel:GetChildren()) do
                    if button:IsA("TextButton") then
                        local key = nameToKey[button.Name] or button.Name
                        button.Visible = not (hideAll and _G.AmbitiousMobileHideIncluded(key))
                    end
                end
            end
            for _, entry in ipairs({{"TpBatButton", "tpBat"}, {"BatV2Button", "batV2"}, {"InstaResetButton", "instaReset"}}) do
                local oldGui = parent:FindFirstChild(entry[1])
                if oldGui and oldGui:IsA("ScreenGui") then
                    oldGui.Enabled = not (hideAll and _G.AmbitiousMobileHideIncluded(entry[2]))
                end
            end
        end
    end
end
do
    local data = {
        {
            key = "drop",
            label = "Drop BR",
        },
        {
            key = "autoPlay",
            label = "Auto Play",
        },
        {
            key = "tpBat",
            label = "TP Bat",
        },
        {
            key = "aimbot",
            label = "Bat Aimbot",
        },
        {
            key = "batV2",
            label = "Bat Bypass",
        },
        {
            key = "instaReset",
            label = "Insta Reset",
        },
        {
            key = "antiTPBat",
            label = "Anti TP Bat",
        },
        {
            key = "float",
            label = "Float",
        },
        {
            key = "tp",
            label = "TP Down",
        },
        {
            key = "carry",
            label = "Carry Speed",
        },
        {
            key = "laggerNormal",
            label = "Lagger Normal",
        },
        {
            key = "laggerCarry",
            label = "Lagger Carry",
        },
    }
    print("[IR] 1. inicio")
    if _G.InstaResetLoaded then
        print("[IR] ya cargado")
    else
        local isActive, thread, object, isActive1979, isActive1980, cFrame, object1982, instaResetFast
        _G.InstaResetLoaded = true
        isActive = false
        thread = nil
        object = nil
        do
            local isEnabled = false
            isActive1979 = false
            isActive1980 = false
            cFrame = nil
            object1982 = 0
            print("[IR] 2. servicios OK, LP =", localPlayer and localPlayer.Name)
            instaResetFast = function()
                if isActive then
                    return
                end
                isActive = true
                isEnabled = false
                isActive1979 = false
                isActive1980 = false
                local character = localPlayer.Character
                if not character then
                    isActive = false
                    return
                end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoid then
                    isActive = false
                    return
                end
                local currentCamera2 = workspace.CurrentCamera
                if currentCamera2 then
                    cFrame = currentCamera2.CFrame
                    isActive1980 = true
                    currentCamera2.CFrame = cFrame
                end
                object = character
                local isRespawning = false
                thread = task.spawn(function()
                    local attempts = 0
                    local hipHeight = humanoid.HipHeight
                    while true do
                        if
                            character
                            and character.Parent
                            and humanoid
                            and humanoid.Health > 0
                            and not isRespawning
                            and not isActive1979
                        then
                            if localPlayer.Character ~= character then
                                isRespawning = true
                                break
                            else
                                pcall(function()
                                    humanoid.HipHeight = 1e30
                                    humanoid.AutoRotate = true
                                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                                    if rootPart then
                                        rootPart.CanCollide = false
                                    end
                                    for _, child in ipairs(character:GetChildren()) do
                                        if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
                                            child.CanCollide = false
                                        end
                                    end
                                end)
                                if
                                    not character
                                    or not character.Parent
                                    or not humanoid
                                    or humanoid.Health <= 0
                                    or localPlayer.Character ~= character
                                then
                                    isEnabled = true
                                    break
                                else
                                    attempts += 1
                                    if not (attempts >= 40) then
                                        task.wait(0.05)
                                        continue
                                    end
                                end
                            end
                        end
                        break
                    end
                    if not isEnabled then
                        if character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning then
                            pcall(function()
                                humanoid.Health = 0
                            end)
                            task.wait(0.1)
                            if not character.Parent or humanoid.Health <= 0 then
                                isEnabled = true
                            end
                        end
                    end
                    if not isEnabled and character and character.Parent and humanoid then
                        pcall(function()
                            humanoid.HipHeight = hipHeight
                            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                            if humanoidRootPart then
                                humanoidRootPart.CanCollide = true
                            end
                            for _, child in ipairs(character:GetChildren()) do
                                if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
                                    child.CanCollide = true
                                end
                            end
                        end)
                    end
                    isActive1980 = false
                    isActive = false
                    thread = nil
                    object = nil
                    isActive1979 = false
                end)
            end
        end
        do
            local function instaReset()
                local now2 = os.clock()
                if now2 - object1982 < 0.75 then
                    return
                end
                object1982 = now2
                instaResetFast()
            end
            print("[IR] 3. función lista")
            localPlayer.CharacterAdded:Connect(function()
                isActive1979 = true
                if thread then
                    pcall(task.cancel, thread)
                    thread = nil
                end
                isActive = false
                object = nil
                isActive1980 = false
            end)
            task.spawn(function()
                while true do
                    task.wait(0.016)
                    local currentCamera2 = workspace.CurrentCamera
                    if isActive1980 and cFrame and currentCamera2 then
                        currentCamera2.CFrame = cFrame
                    end
                end
            end)
            print("[IR] 4. loop cámara iniciado")
            _G.InstaReset = {
                Trigger = instaReset,
            }
        end
    end
    RH_Style = {
        ink = Color3.fromRGB(11, 12, 16),
        panel = Color3.fromRGB(23, 25, 32),
        raised = Color3.fromRGB(32, 36, 46),
        border = Color3.fromRGB(65, 70, 83),
        text = Color3.fromRGB(239, 241, 247),
        muted = Color3.fromRGB(155, 161, 179),
        silver = Color3.fromRGB(211, 219, 237),
        finished = false,
        gated = {},
        wired = setmetatable({}, {__mode = "k"}),
    }

    function RH_Style.make(class, props, parent)
        local object = Instance.new(class)
        for key, value in pairs(props or {}) do object[key] = value end
        object.Parent = parent
        return object
    end

    function RH_Style.corner(parent, radius)
        local c = parent:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", parent)
        c.CornerRadius = UDim.new(0, radius)
        return c
    end

    function RH_Style.stroke(parent, color, transparency, width)
        local s = parent:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke", parent)
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Color, s.Transparency, s.Thickness = color, transparency or 0, width or 1
        return s
    end

    function RH_Style.gradient(parent, name, top, bottom)
        local g = parent:FindFirstChild(name) or Instance.new("UIGradient", parent)
        g.Name, g.Rotation = name, 90
        g.Color = ColorSequence.new(top, bottom)
        return g
    end

    function RH_Style.tween(object, duration, props, easing)
        if not object or not object.Parent then return end
        local motion = game:GetService("TweenService"):Create(object,
            TweenInfo.new(duration, easing or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
        motion:Play()
        return motion
    end

    function RH_Style.gate(layer)
        if RH_Style.finished or not layer.Enabled then return end
        RH_Style.gated[layer] = true
        layer.Enabled = false
    end

    function RH_Style.finish()
        if RH_Style.finished then return end
        RH_Style.finished = true
        RH_Style.audioSealed = true
        if RH_Style.loadedConnection then RH_Style.loadedConnection:Disconnect(); RH_Style.loadedConnection = nil end
        local sound = RH_Style.introSound
        RH_Style.introSound = nil
        if sound then
            pcall(function() sound:Stop(); sound:Destroy() end)
        end
        if RH_Style.introConnection then RH_Style.introConnection:Disconnect(); RH_Style.introConnection = nil end
        if RH_Style.skipConnection then RH_Style.skipConnection:Disconnect(); RH_Style.skipConnection = nil end
        for layer in pairs(RH_Style.gated) do
            if layer.Parent then layer.Enabled = true end
        end
        table.clear(RH_Style.gated)
        local root = RH_Style.introRoot
        RH_Style.introRoot = nil
        if root and root.Parent then root:Destroy() end
    end

    function RH_Style.bindButton(button)
        if RH_Style.wired[button] then return end
        RH_Style.wired[button] = true
        button.AutoButtonColor = false
        button.MouseEnter:Connect(function()
            if button.Parent and button.BackgroundTransparency < 0.99 then
                RH_Style.tween(button, 0.16, {BackgroundColor3 = RH_Style.raised:Lerp(RH_Style.silver, 0.08)})
            end
        end)
        button.MouseLeave:Connect(function()
            if button.Parent and button.BackgroundTransparency < 0.99 then
                RH_Style.tween(button, 0.2, {BackgroundColor3 = RH_Style.raised})
            end
        end)
    end

    function RH_Style.fitRow(row)
        local label = row:FindFirstChild("RowLabel")
        if not label or label.Size.Y.Scale ~= 1 then return end
        local xs, xo = 1, -12
        for _, control in ipairs(row:GetChildren()) do
            if control ~= label and control:IsA("GuiObject") and control.Visible
                and control.Position.X.Scale >= 0.5 then
                local s = control.Position.X.Scale - control.AnchorPoint.X * control.Size.X.Scale
                local o = control.Position.X.Offset - control.AnchorPoint.X * control.Size.X.Offset
                if s < xs or (s == xs and o < xo) then xs, xo = s, o end
            end
        end
        label.Size = UDim2.new(xs, xo - 24, 1, 0)
    end

    function RH_Style.refresh(root, accent, preset)
        if not root then return end
        accent = accent or RH_Style.silver
        local fill = RH_Style.panel
        for _, o in ipairs(root:GetDescendants()) do
            local n = o.Name
            if o:IsA("Frame") then
                if n == "ReferenceStyleShade" then
                    o.BackgroundColor3, o.BackgroundTransparency = Color3.new(1, 1, 1), 0.12
                    RH_Style.gradient(o, "SurfaceLight", Color3.fromRGB(29, 32, 41), Color3.fromRGB(12, 13, 18))
                elseif n == "TabBar" then
                    o.BackgroundColor3, o.BackgroundTransparency = RH_Style.ink, 0.05
                    RH_Style.stroke(o, RH_Style.border, 0.55, 1)
                elseif n == "MenuRow" then
                    local active = o:GetAttribute("ToggleOn") == true
                    o.BackgroundColor3 = active and fill:Lerp(accent, 0.065) or fill
                    o.BackgroundTransparency = 0.06
                    local stroke = o:FindFirstChild("RowStroke")
                    if stroke then
                        stroke.Color = active and accent:Lerp(RH_Style.border, 0.46) or RH_Style.border
                        stroke.Thickness, stroke.Transparency = 1, active and 0.2 or 0.54
                    end
                    local track = o:FindFirstChild("Track")
                    local knob = track and track:FindFirstChild("Knob")
                    if knob then
                        track.BackgroundColor3 = active and fill:Lerp(accent, 0.1) or RH_Style.ink
                        knob.BackgroundColor3 = active and accent or RH_Style.raised
                        RH_Style.stroke(track, active and accent or RH_Style.border, 0.3, 1)
                        RH_Style.stroke(knob, active and accent or RH_Style.border, 0.05, 1)
                        local mark = knob:FindFirstChild("StateMark")
                        if mark then mark.BackgroundColor3, mark.Rotation = active and RH_Style.ink or RH_Style.muted, active and 90 or 0 end
                    end
                    local gleam = o:FindFirstChild("RowGleam")
                    if not gleam then
                        gleam = RH_Style.make("Frame", {
                            Name = "RowGleam", Size = UDim2.new(1, -24, 0, 1), Position = UDim2.fromOffset(12, 1),
                            BackgroundColor3 = accent, BackgroundTransparency = 0.93, BorderSizePixel = 0, ZIndex = o.ZIndex + 1,
                        }, o)
                        local fade = RH_Style.gradient(gleam, "EdgeLight", Color3.new(1, 1, 1), Color3.new(1, 1, 1))
                        fade.Rotation = 0
                        fade.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.35, 0.2), NumberSequenceKeypoint.new(1, 1)})
                    end
                    gleam.BackgroundColor3 = accent
                    RH_Style.fitRow(o)
                elseif n == "CLEMusicLibrary" then
                    o.BackgroundColor3, o.BackgroundTransparency = RH_Style.ink, 0
                    RH_Style.stroke(o, RH_Style.border, 0.2, 1)
                elseif n == "SectAccent" or n == "SectLine" or n:match("^ActivationDash")
                    or n == "SizeSliderFill" or n == "SizeSliderHandle" or n == "HeaderHairline" then
                    o.BackgroundColor3 = accent
                end
            elseif o:IsA("TextLabel") then
                if n == "RowLabel" then o.TextColor3, o.TextStrokeTransparency = RH_Style.text, 1
                elseif n == "SectionTitle" then o.TextColor3 = RH_Style.text:Lerp(RH_Style.muted, 0.4)
                elseif n == "RailTitle" or n == "HeaderTag" then o.TextColor3 = RH_Style.muted
                elseif n == "SelectorValue" then o.TextColor3 = accent
                end
            elseif o:IsA("TextButton") then
                local tabStroke = o:FindFirstChild("TabStroke")
                if tabStroke then
                    local active = o:FindFirstChild("Underline") and o.Underline.Visible
                    o.BackgroundColor3 = active and RH_Style.panel:Lerp(RH_Style.silver, 0.12) or RH_Style.panel
                    o.BackgroundTransparency = active and 0.05 or 0.62
                    o.TextColor3 = active and RH_Style.text or RH_Style.muted
                    tabStroke.Color, tabStroke.Transparency = active and RH_Style.silver or RH_Style.border, active and 0.2 or 0.62
                    local icon = o:FindFirstChild("NavIcon")
                    RH_Style.paintIcon(icon, active and RH_Style.silver or RH_Style.muted, active and 0 or 0.12)
                elseif o.Name ~= "MinimizedFrame" and (o:FindFirstAncestor("MenuRow") or o:FindFirstAncestor("CLEMusicLibrary")) and o.BackgroundTransparency < 0.99 then
                    o.BackgroundColor3, o.BackgroundTransparency = RH_Style.raised, 0
                    o.TextColor3 = RH_Style.text
                    RH_Style.stroke(o, RH_Style.border, 0.45, 1)
                    RH_Style.bindButton(o)
                end
            elseif o:IsA("ScrollingFrame") and n == "TrackList" then
                o.BackgroundColor3, o.ScrollBarImageColor3 = RH_Style.panel, accent
            elseif o:IsA("TextBox") and o:FindFirstAncestor("MenuRow") then
                o.BackgroundColor3, o.BackgroundTransparency = RH_Style.ink, 0.06
                o.TextColor3 = RH_Style.text
                o.PlaceholderColor3 = RH_Style.muted
                local stroke = o:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color, stroke.Transparency = RH_Style.border, 0.3 end
            elseif o:IsA("UIStroke") then
                if n == "MenuOuterStroke" then
                    o.Color, o.Transparency, o.Thickness = accent:Lerp(RH_Style.border, 0.58), 0.25, 1
                elseif n == "AvatarHalo" then o.Color, o.Transparency, o.Thickness = accent, 0.5, 1
                end
            elseif o:IsA("UIGradient") then
                if n == "RowGrad" or n == "TabBgGrad" then
                    o.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(222, 227, 238))
                    o.Transparency = NumberSequence.new(0)
                elseif n == "AnimatedTagGlow" then
                    o.Color, o.Offset = ColorSequence.new(Color3.new(1, 1, 1)), Vector2.zero
                end
            end
        end
    end

    function RH_Style.header(header)
        local top = RH_Style.make("Frame", {
            Name = "HeaderHairline", Size = UDim2.new(1, -34, 0, 1), Position = UDim2.fromOffset(17, 109),
            BackgroundColor3 = RH_Style.silver, BackgroundTransparency = 0.75, BorderSizePixel = 0, ZIndex = 9,
        }, header)
        local line = RH_Style.gradient(top, "HairlineFade", RH_Style.silver, RH_Style.silver)
        line.Rotation = 0
        line.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1)})
    end


    function RH_Style.navIcon(parent, kind, position)
        local make = RH_Style.make
        local root = make("Frame", {
            Name = "NavIcon", Size = UDim2.fromOffset(24, 24), AnchorPoint = Vector2.new(0.5, 0),
            Position = position or UDim2.new(0.5, 0, 0, 3), BackgroundTransparency = 1, BorderSizePixel = 0,
            ZIndex = math.max(parent.ZIndex + 1, 12),
        }, parent)
        local z = root.ZIndex + 1
        local function bar(x, y, w, h, angle, radius)
            local o = make("Frame", {
                Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(w, h),
                AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = RH_Style.muted,
                BorderSizePixel = 0, Rotation = angle or 0, ZIndex = z,
            }, root)
            o:SetAttribute("IconInk", true)
            if radius then RH_Style.corner(o, radius) end
            return o
        end
        local function outline(x, y, w, h, radius)
            local o = bar(x, y, w, h, 0, radius)
            o.BackgroundTransparency = 1
            o:SetAttribute("IconInk", false)
            local stroke = RH_Style.stroke(o, RH_Style.muted, 0, 1.5)
            stroke:SetAttribute("IconInk", true)
            return o
        end
        if kind == "Speed" then
            bar(13, 6, 13, 2, -28, 1); bar(11, 12, 18, 2, -28, 1); bar(10, 18, 13, 2, -28, 1)
        elseif kind == "Combat" then
            bar(12, 11, 21, 2, -45, 1); bar(12, 11, 21, 2, 45, 1)
            bar(6, 17, 7, 2, 45, 1); bar(18, 17, 7, 2, -45, 1)
        elseif kind == "Visual" then
            outline(12, 12, 22, 14, 7); bar(12, 12, 6, 6, 0, 3)
        elseif kind == "Config" then
            for i = 1, 3 do
                local y = 5 + (i - 1) * 7
                bar(12, y, 20, 1.5, 0, 1)
                bar(i == 2 and 16 or 8, y, 4, 5, 0, 1)
            end
        elseif kind == "Keybinds" then
            outline(12, 12, 23, 16, 3)
            for y = 8, 12, 4 do for x = 6, 18, 4 do bar(x, y, 2, 2, 0, 0.5) end end
            bar(12, 16, 10, 1.5, 0, 1)
        elseif kind == "Extra" then
            for _, p in ipairs({{7, 7}, {17, 7}, {7, 17}, {17, 17}}) do outline(p[1], p[2], 6, 6, 1.5) end
        elseif kind == "Music" then
            bar(9, 11, 1.8, 14, 0, 1); bar(18, 9, 1.8, 14, 0, 1)
            bar(13.5, 4, 10.5, 2, -12, 1)
            bar(6.5, 18, 6, 4, -18, 2); bar(15.5, 16, 6, 4, -18, 2)
        elseif kind == "Lock" then
            local shackle = outline(12, 8, 10, 11, 5)
            shackle.Name = "LockShackle"
            local body = bar(12, 15, 15, 11, 0, 3)
            body.Name = "LockBody"
            local keyhole = make("Frame", {
                Size = UDim2.fromOffset(2, 4), Position = UDim2.fromOffset(11, 14),
                BorderSizePixel = 0, BackgroundColor3 = RH_Style.ink, ZIndex = z + 1,
            }, root)
            RH_Style.corner(keyhole, 1)
        end
        return root
    end

    function RH_Style.paintIcon(root, color, opacity)
        if not root then return end
        for _, o in ipairs(root:GetDescendants()) do
            if o:GetAttribute("IconInk") then
                if o:IsA("Frame") then o.BackgroundColor3, o.BackgroundTransparency = color, opacity or 0
                elseif o:IsA("UIStroke") then o.Color, o.Transparency = color, opacity or 0 end
            end
        end
    end
    function RH_Style.prepareAudio()

        RH_Style.audioPending = true

        task.spawn(function()

            local ok, err = pcall(function()

                local env = type(getgenv) == "function" and getgenv() or _G

                local assetFn = getcustomasset or getsynasset or (syn and (syn.getcustomasset or syn.getsynasset)) or env.getcustomasset or env.getsynasset

                local write = writefile or env.writefile

                local exists = isfile or env.isfile

                if type(assetFn) ~= "function" or type(write) ~= "function" then

                    error("El executor no permite el MP3 de la intro")

                end

                local file = "RevHubIntro_JessePinkman.mp3"

                local cached = false

                if type(exists) == "function" then

                    local readOK, value = pcall(exists, file)

                    cached = readOK and value == true

                end

                if not cached then

                    local url = "https://file.garden/algLafWA1jk8WMfK/Jesse%20Pinkman_spotdown.org.mp3"

                    local body

                    local req = request or http_request or (syn and syn.request) or (fluxus and fluxus.request) or env.request

                    if type(req) == "function" then

                        pcall(function()

                            local response = req({Url = url, Method = "GET"})

                            local code = response and tonumber(response.StatusCode or response.status_code or response.Status)

                            if response and (not code or code >= 200 and code < 300) then body = response.Body or response.body end

                        end)

                    end

                    if RH_Style.finished or RH_Style.audioSealed then return end

                    if type(body) ~= "string" or #body < 512 then body = game:HttpGet(url, true) end

                    if RH_Style.finished or RH_Style.audioSealed then return end

                    local head = type(body) == "string" and body:sub(1, 256):lower() or ""

                    if type(body) ~= "string" or #body < 512 or head:find("<html", 1, true) or head:find("<!doctype", 1, true) then

                        error("No se pudo descargar la musica de Candy")

                    end

                    if write(file, body) == false then error("No se pudo preparar el audio") end

                end

                if RH_Style.finished or RH_Style.audioSealed then return end

                local asset = assetFn(file)

                if type(asset) ~= "string" or asset == "" then error("MP3 no compatible") end

                if RH_Style.finished or RH_Style.audioSealed then return end

                local sound = RH_Style.make("Sound", {

                    Name = "RevHubIntroMusic", SoundId = asset, TimePosition = 11,

                    Volume = 0, Looped = false, PlayOnRemove = false,

                }, game:GetService("SoundService"))

                RH_Style.introSound = sound

                local function ready()

                    if RH_Style.finished or RH_Style.audioSealed then return end

                    if sound.IsLoaded then RH_Style.audioReady = true; RH_Style.audioPending = false end

                end

                RH_Style.loadedConnection = sound.Loaded:Connect(ready)

                ready()

                if not RH_Style.audioReady then

                    pcall(function() game:GetService("ContentProvider"):PreloadAsync({sound}) end)

                    ready()

                end

            end)

            if not ok and not RH_Style.finished and not RH_Style.audioSealed then

                RH_Style.audioPending = false

                warn("[Calzosky Hub] Audio: " .. tostring(err))

            end

        end)

    end



    function RH_Style.playAudio()

        RH_Style.audioSealed = true

        local sound = RH_Style.introSound

        if not sound or not sound.Parent then return end

        if not RH_Style.audioReady then sound:Destroy(); RH_Style.introSound = nil; return end

        local ok = pcall(function()

            sound.TimePosition = 11

            sound:Play()

            sound.TimePosition = 11

        end)

        if ok then

            RH_Style.tween(sound, 0.25, {Volume = 0.72})

        else

            sound:Destroy()

            RH_Style.introSound = nil

        end

    end



    function RH_Style.intro()

        local player = game:GetService("Players").LocalPlayer

        if not player then RH_Style.finish(); return end

        local pg = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui", 8)

        if not pg or RH_Style.finished then RH_Style.finish(); return end

        if type(_G.__RevHubPresentationFinish) == "function" then pcall(_G.__RevHubPresentationFinish) end

        _G.__RevHubPresentationFinish = RH_Style.finish

        local make = RH_Style.make

        local root = make("ScreenGui", {

            Name = "RevHubPresentation", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 1000001,

            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

        }, pg)

        RH_Style.introRoot = root

        root.Destroying:Connect(RH_Style.finish)

        local stage = make("Frame", {

            Name = "CrystalStage", Size = UDim2.fromOffset(640, 340), AnchorPoint = Vector2.new(0.5, 0.5),

            Position = UDim2.fromScale(0.5, 0.46), BackgroundTransparency = 1, BorderSizePixel = 0,

        }, root)

        local camera = workspace.CurrentCamera

        local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)

        local stageScale = make("UIScale", {Scale = math.clamp(math.min((viewport.X - 32) / 640, (viewport.Y - 30) / 340), 0.2, 1.12)}, stage)

        local hero = make("Frame", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,

            Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5)}, stage)

        local heroScale = make("UIScale", {Scale = 1}, hero)

        local function ink(x, y, w, h, angle, depth)

            local o = make("Frame", {

                Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(w, h), AnchorPoint = Vector2.new(0.5, 0.5),

                BackgroundColor3 = RH_Style.silver, BackgroundTransparency = 1, BorderSizePixel = 0,

                Rotation = angle or 0, ZIndex = depth or 2,

            }, hero)

            RH_Style.corner(o, 2)

            return o

        end

        local function caption(text, y, size, color, width)

            return make("TextLabel", {

                Size = UDim2.fromOffset(width or 520, 26), AnchorPoint = Vector2.new(0.5, 0.5),

                Position = UDim2.fromOffset(320, y), BackgroundTransparency = 1, Text = text,

                Font = Enum.Font.GothamMedium, TextSize = size, TextColor3 = color or RH_Style.text,

                TextTransparency = 1, TextStrokeTransparency = 1, ZIndex = 8,

            }, hero)

        end

        local crest = caption("CALZOSKY", 164, 64, RH_Style.text, 480)

        crest.Font = Enum.Font.GothamBlack

        local crestScale = make("UIScale", {Scale = 0.8}, crest)

        local crestLight = RH_Style.gradient(crest, "ChromeCrest", Color3.new(1, 1, 1), Color3.fromRGB(115, 129, 155))

        local eyebrow = caption("C A L Z O S K Y   H U B", 66, 11, RH_Style.silver)

        local welcome = caption("BIENVENIDO, @" .. player.Name, 252, 12, RH_Style.text)

        local signature = caption("C A L Z O S K Y   /   H U B", 284, 9, RH_Style.muted)

        local hair1, hair2 = ink(143, 252, 62, 1, 0, 5), ink(497, 252, 62, 1, 0, 5)

        local letters, pieces, orbits, comets, waves = {}, {}, {}, {}, {}

        local seed = Random.new(714)

        local title, widths = "CALZOSKY HUB", {48, 48, 48, 48, 48, 48, 48, 48, 24, 48, 48, 48}

        local total = 0

        for _, width in ipairs(widths) do total += width end

        local x = (640 - total) / 2

        for i = 1, #title do

            local ch, width = title:sub(i, i), widths[i]

            if ch ~= " " then

                local letter = make("TextLabel", {

                    Name = "Letter" .. i, Size = UDim2.fromOffset(width + 12, 102), AnchorPoint = Vector2.new(0.5, 0.5),

                    Position = UDim2.fromOffset(x + width / 2, 166), BackgroundTransparency = 1,

                    Text = ch, TextColor3 = Color3.new(1, 1, 1), TextTransparency = 1,

                    TextStrokeColor3 = Color3.fromRGB(9, 11, 18), TextStrokeTransparency = 1,

                    Font = Enum.Font.GothamBlack, TextSize = 66, ZIndex = 7,

                }, hero)

                local sheen = RH_Style.gradient(letter, "Platinum", Color3.new(1, 1, 1), Color3.fromRGB(128, 143, 166))

                sheen.Color = ColorSequence.new({

                    ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 149, 179)), ColorSequenceKeypoint.new(0.28, Color3.new(1, 1, 1)),

                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(213, 223, 242)), ColorSequenceKeypoint.new(0.64, Color3.new(1, 1, 1)),

                    ColorSequenceKeypoint.new(1, Color3.fromRGB(105, 121, 149)),

                })

                table.insert(letters, {object = letter, sheen = sheen, x = x + width / 2, y = 166, i = i})

            end

            x += width

        end

        local function point(angle, rx, ry, tilt)

            local a, b = math.cos(angle) * rx, math.sin(angle) * ry

            return 320 + a * math.cos(tilt) - b * math.sin(tilt), 166 + a * math.sin(tilt) + b * math.cos(tilt)

        end

        for orbit = 1, 2 do

            local radiusX, radiusY = 252 + orbit * 6, 73 + orbit * 10

            local tilt = math.rad(orbit == 1 and -17 or 17)

            local segments = {}

            for j = 1, 44 do

                local a = (j - 1) / 44 * math.pi * 2

                local b = j / 44 * math.pi * 2

                local x1, y1 = point(a, radiusX, radiusY, tilt)

                local x2, y2 = point(b, radiusX, radiusY, tilt)

                local segment = ink((x1 + x2) / 2, (y1 + y2) / 2,

                    math.sqrt((x2 - x1)^2 + (y2 - y1)^2) + 1, 1, math.deg(math.atan2(y2 - y1, x2 - x1)), 1)

                table.insert(segments, {object = segment, angle = a})

            end

            table.insert(orbits, {segments = segments, direction = orbit == 1 and -1 or 1})

        end

        for i = 1, 26 do

            local a = i / 26 * math.pi * 2

            local px, py = point(a, seed:NextNumber(190, 293), seed:NextNumber(98, 142), 0)

            local piece = ink(320, 166, seed:NextInteger(3, 7), seed:NextInteger(9, 23), math.deg(a) + 28, 3)

            table.insert(pieces, {object = piece, x = px, y = py, phase = i * 0.67, angle = a})

        end

        for i = 1, 4 do

            local c = ink(320, 166, 45, 1.5, 0, 4)

            local fade = RH_Style.gradient(c, "Tail", Color3.new(1, 1, 1), Color3.new(1, 1, 1))

            fade.Rotation = 0

            fade.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.82, 0.25), NumberSequenceKeypoint.new(1, 0)})

            table.insert(comets, {object = c, phase = i * math.pi / 2})

        end

        for i = 1, 2 do

            local w = make("Frame", {

                Name = "ImpactRing", Size = UDim2.fromOffset(280, 280), AnchorPoint = Vector2.new(0.5, 0.5),

                Position = UDim2.fromOffset(320, 166), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2,

            }, hero)

            RH_Style.corner(w, 140)

            local stroke = RH_Style.stroke(w, RH_Style.silver, 1, 1)

            local scale = make("UIScale", {Scale = 0.1}, w)

            table.insert(waves, {stroke = stroke, scale = scale, offset = (i - 1) * 0.24})

        end

        local slash1, slash2 = ink(320, 166, 390, 1, -27, 4), ink(320, 166, 390, 1, 27, 4)

        for _, slash in ipairs({slash1, slash2}) do

            local fade = RH_Style.gradient(slash, "BladeLight", Color3.new(1, 1, 1), Color3.new(1, 1, 1))

            fade.Rotation = 0

            fade.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1)})

        end

        local hint = make("TextButton", {

            Name = "SkipIntro", Size = UDim2.fromOffset(230, 32), AnchorPoint = Vector2.new(0.5, 0.5),

            Position = UDim2.fromScale(0.5, 0.91), BackgroundTransparency = 1, AutoButtonColor = false,

            Text = "DOBLE TOQUE PARA OMITIR", TextSize = 9, TextColor3 = RH_Style.text,

            TextTransparency = 1, Font = Enum.Font.GothamMedium, ZIndex = 12,

        }, root)

        local lastTap = -1

        RH_Style.skipConnection = game:GetService("UserInputService").InputBegan:Connect(function(input)

            if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

            local now = os.clock()

            if now - lastTap < 0.5 then RH_Style.finish() else lastTap = now end

        end)



        RH_Style.tween(crest, 0.4, {TextTransparency = 0.08})

        RH_Style.prepareAudio()

        local deadline = os.clock() + 5

        while not RH_Style.finished and RH_Style.audioPending and os.clock() < deadline do task.wait(0.05) end

        if RH_Style.finished then return end

        RH_Style.playAudio()

        local began, energy = os.clock(), 0

        local function smooth(value) value = math.clamp(value, 0, 1); return value * value * (3 - 2 * value) end

        local function back(value)

            value = math.clamp(value, 0, 1) - 1

            return 1 + 2.70158 * value^3 + 1.70158 * value^2

        end

        RH_Style.introConnection = game:GetService("RunService").RenderStepped:Connect(function(dt)

            if RH_Style.finished or not root.Parent then RH_Style.finish(); return end

            local t = os.clock() - began

            local outro = smooth((t - 7.6) / 0.8)

            local appear = smooth((t - 0.6) / 1.2)

            local sound = RH_Style.introSound

            local loudness = sound and sound.PlaybackLoudness or 0

            local target = math.clamp((tonumber(loudness) or 0) / 500, 0, 1)

            energy += (target - energy) * math.min((dt or 1/60) * 12, 1)

            heroScale.Scale = 1 + energy * 0.025 + outro * 0.07

            crest.TextTransparency = math.clamp(smooth((t - 0.45) / 0.65) + outro, 0, 1)

            crestScale.Scale = 0.8 + smooth(t / 1.1) * 0.32

            crest.Rotation = -10 * (1 - smooth(t / 0.8))

            crestLight.Offset = Vector2.new(math.sin(t * 1.6) * 0.25, 0)

            for _, d in ipairs(letters) do

                local progress = math.clamp((t - 0.62 - d.i * 0.052) / 0.86, 0, 1)

                local land = back(progress)

                local side = d.i < 4 and -1 or 1

                d.object.Position = UDim2.fromOffset(d.x + side * (1 - land) * 175,

                    d.y + math.sin(d.i * 2) * (1 - land) * 58 + math.sin(t * 1.4 + d.i) * 1.2 * progress - outro * 22)

                d.object.Rotation = side * (1 - land) * 23

                d.object.TextTransparency = math.clamp(1 - smooth(progress * 1.7) + outro, 0, 1)

                d.object.TextStrokeTransparency = math.clamp(0.55 + outro, 0, 1)

                d.sheen.Offset = Vector2.new(0, math.sin(t * 0.8 - d.i * 0.13) * 0.14)

            end

            for _, orbit in ipairs(orbits) do

                for _, d in ipairs(orbit.segments) do

                    local gleam = (0.5 + 0.5 * math.cos(d.angle - t * 0.75 * orbit.direction))^7

                    local visible = appear * (0.1 + gleam * 0.58) * (1 - outro)

                    d.object.BackgroundTransparency = 1 - visible

                end

            end

            local burst = back((t - 1.4) / 1.0)

            for _, d in ipairs(pieces) do

                local orbit = math.sin(t * 1.1 + d.phase)

                d.object.Position = UDim2.fromOffset(320 + (d.x - 320) * burst + orbit * 4,

                    166 + (d.y - 166) * burst + math.cos(t + d.phase) * 4)

                d.object.Rotation = math.deg(d.angle) + 35 + t * 4

                d.object.BackgroundTransparency = 1 - smooth((t - 1.4) / 0.45) * (0.24 + math.max(orbit, 0) * 0.25) * (1 - outro)

            end

            for _, d in ipairs(comets) do

                local a = t * 0.72 + d.phase

                local px, py = point(a, 258, 83, math.rad(-17))

                local nx, ny = point(a + 0.015, 258, 83, math.rad(-17))

                d.object.Position = UDim2.fromOffset(px, py)

                d.object.Rotation = math.deg(math.atan2(ny - py, nx - px))

                d.object.BackgroundTransparency = 1 - appear * 0.6 * (1 - outro)

            end

            for _, d in ipairs(waves) do

                local p = math.clamp((t - 1.7 - d.offset) / 0.9, 0, 1)

                d.scale.Scale = 0.1 + p * 2.3

                d.stroke.Transparency = p == 0 and 1 or math.clamp(0.42 + p * 0.58 + outro, 0, 1)

            end

            local flare = math.max(0, 1 - math.abs(t - 1.8) / 0.26)

            slash1.BackgroundTransparency, slash2.BackgroundTransparency = 1 - flare * 0.75, 1 - flare * 0.75

            local details = smooth((t - 1.7) / 0.8) * (1 - outro)

            eyebrow.TextTransparency, welcome.TextTransparency = 1 - details * 0.84, 1 - details * 0.9

            signature.TextTransparency = 1 - details * 0.6

            hair1.BackgroundTransparency, hair2.BackgroundTransparency = 1 - details * 0.4, 1 - details * 0.4

            hint.TextTransparency = 1 - smooth((t - 0.5) / 0.6) * 0.5 * (1 - outro)

            if t >= 8.45 then RH_Style.finish() end

        end)

        local function waitUntil(deadline)

            while not RH_Style.finished and os.clock() < deadline do task.wait(0.03) end

        end

        waitUntil(os.clock() + 7.5)

        if RH_Style.finished then return end

        if RH_Style.introSound then RH_Style.tween(RH_Style.introSound, 0.8, {Volume = 0}) end

        waitUntil(os.clock() + 1)

        RH_Style.finish()

    end

    buildGui = function()
        local color = Color3.fromRGB(225, 225, 230)
        local color2 = Color3.fromRGB(10, 10, 12)
        local color3 = Color3.fromRGB(65, 68, 74)
        local color4 = Color3.fromRGB(255, 255, 255)
        local color5 = Color3.fromRGB(18, 20, 24)
        local textColor3 = color
        local autoSaveQueued = false
        local function queueAutoSave()
            if _isLoading or _isResetting or autoSaveQueued then
                return
            end
            autoSaveQueued = true
            task.delay(0.3, function()
                autoSaveQueued = false
                if not _isLoading and not _isResetting and type(saveAllSettings) == "function" then
                    pcall(saveAllSettings)
                end
            end)
        end
        for _, guiParent in ipairs({game:GetService("CoreGui"), localPlayer:FindFirstChildOfClass("PlayerGui")}) do
            if guiParent then
                for _, guiName in ipairs({"FictionHub", "BigSquareMenu", "FloatingButtons", "FictionHubMobilePanel", "TpBatButton", "BatV2Button", "InstaResetButton"}) do
                    local oldGui = guiParent:FindFirstChild(guiName)
                    if oldGui then
                        pcall(function() oldGui:Destroy() end)
                    end
                end
            end
        end

        gui = Instance.new("ScreenGui")
        gui.Name = "FictionHub"
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 2147483647
        gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function()
            if syn and syn.protect_gui then syn.protect_gui(gui) end
        end)
        local parentOk = pcall(function() gui.Parent = game:GetService("CoreGui") end)
        if not parentOk or not gui.Parent then
            gui.Parent = localPlayer:WaitForChild("PlayerGui")
        end

        main = Instance.new("Frame")
        main.Name = "Main"
        main.AnchorPoint = Vector2.new(0, 0.5)
        main.Size = UDim2.fromOffset(330, 560)
        main.Position = UDim2.new(0, 20, 0.5, 0)
        main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        main.BackgroundTransparency = 0.05
        main.BorderSizePixel = 0
        main.ZIndex = 100
        main.Active = true
        main.ClipsDescendants = true
        main.Visible = false
        main.Parent = gui
        Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
        local mainStroke = Instance.new("UIStroke", main)
        mainStroke.Color = Color3.fromRGB(35, 35, 35)
        mainStroke.Thickness = 1.4
        mainStroke.Transparency = 0.68
        mainUIScale = Instance.new("UIScale", main)
        mainUIScale.Scale = uiScaleValue / 100

        backgroundImage = Instance.new("ImageLabel")
        backgroundImage.Name = "BackgroundImage"
        backgroundImage.Size = UDim2.fromScale(1, 1)
        backgroundImage.Position = UDim2.fromScale(0, 0)
        backgroundImage.BackgroundTransparency = 1
        backgroundImage.BorderSizePixel = 0
        backgroundImage.Image = ""
        backgroundImage.ScaleType = Enum.ScaleType.Stretch
        backgroundImage.ImageTransparency = 1
        backgroundImage.ZIndex = 1
        backgroundImage.Parent = main
        Instance.new("UICorner", backgroundImage).CornerRadius = UDim.new(0, 14)

        local topBar = Instance.new("Frame")
        topBar.Name = "TopBar"
        topBar.Size = UDim2.new(1, 0, 0, 112)
        topBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        topBar.BackgroundTransparency = 0.28
        topBar.BorderSizePixel = 0
        topBar.ZIndex = 2
        topBar.Parent = main
        Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 14)
        local bottomMask = Instance.new("Frame")
        bottomMask.Name = "BottomMask"
        bottomMask.Size = UDim2.new(1, 0, 0, 14)
        bottomMask.Position = UDim2.new(0, 0, 1, -14)
        bottomMask.BackgroundColor3 = topBar.BackgroundColor3
        bottomMask.BackgroundTransparency = topBar.BackgroundTransparency
        bottomMask.BorderSizePixel = 0
        bottomMask.ZIndex = 2
        bottomMask.Parent = topBar
        local topLine = Instance.new("Frame")
        topLine.Name = "BottomLine"
        topLine.Size = UDim2.new(1, 0, 0, 1)
        topLine.Position = UDim2.new(0, 0, 1, -1)
        topLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        topLine.BorderSizePixel = 0
        topLine.ZIndex = 3
        topLine.Parent = topBar

        local logo = Instance.new("ImageLabel")
        logo.Name = "Logo"
        logo.Size = UDim2.new(0, 130, 0, 40)
        logo.Position = UDim2.new(0, 16, 0, 24)
        logo.BackgroundTransparency = 1
        logo.Image = "rbxassetid://140374748745094"
        logo.ScaleType = Enum.ScaleType.Fit
        logo.ZIndex = 10
        logo.Parent = topBar
        logo.Visible = true
        local headerTitle = Instance.new("TextLabel")
        headerTitle.Name = "MKTitle"
        headerTitle.Size = UDim2.new(1, -72, 0, 34)
        headerTitle.Position = UDim2.new(0, 16, 0, 24)
        headerTitle.BackgroundTransparency = 1
        headerTitle.Text = ""
        headerTitle.Visible = false
        headerTitle.TextColor3 = RH_Style.text
        headerTitle.Font = Enum.Font.GothamBlack
        headerTitle.TextSize = 23
        headerTitle.TextXAlignment = Enum.TextXAlignment.Left
        headerTitle.ZIndex = 10
        headerTitle.Parent = topBar
        local headerTag = Instance.new("TextLabel")
        headerTag.Name = "HeaderTag"
        headerTag.Size = UDim2.new(1, -82, 0, 16)
        headerTag.Position = UDim2.new(0, 18, 0, 62)
        headerTag.BackgroundTransparency = 1
        headerTag.Text = ""
        headerTag.Visible = false
        headerTag.TextColor3 = RH_Style.muted
        headerTag.Font = Enum.Font.GothamMedium
        headerTag.TextSize = 9
        headerTag.TextXAlignment = Enum.TextXAlignment.Left
        headerTag.ZIndex = 10
        headerTag.Parent = topBar
        RH_Style.header(main)

        local closeX = Instance.new("TextButton")
        closeX.Name = "CloseX"
        closeX.Size = UDim2.fromOffset(20, 22)
        closeX.Position = UDim2.new(1, -22, 0, 6)
        closeX.BackgroundTransparency = 1
        closeX.BorderSizePixel = 0
        closeX.Text = "-"
        closeX.TextColor3 = color4
        closeX.TextSize = 12
        closeX.Font = Enum.Font.GothamMedium
        closeX.AutoButtonColor = false
        closeX.ZIndex = 110
        closeX.Parent = topBar

        miniBtn = Instance.new("TextButton")
        miniBtn.Name = "RevHubButton"
        miniBtn.Size = UDim2.new(0, 140, 0, 46)
        miniBtn.Position = UDim2.new(0, 14, 0, 56)
        miniBtn.BackgroundTransparency = 1
        miniBtn.BorderSizePixel = 0
        miniBtn.Text = ""
        miniBtn.AutoButtonColor = false
        miniBtn.Visible = true
        miniBtn.ZIndex = 60
        miniBtn.ClipsDescendants = true
        miniBtn.Parent = gui

        local buttonFrame = Instance.new("Frame")
        buttonFrame.Name = "CalzoskyHubButton"
        buttonFrame.Size = UDim2.new(1, 0, 1, 0)
        buttonFrame.Position = UDim2.new(0, 0, 0, 0)
        buttonFrame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        buttonFrame.BorderSizePixel = 0
        buttonFrame.Active = false
        buttonFrame.ZIndex = 61
        buttonFrame.Parent = miniBtn
        Instance.new("UICorner", buttonFrame).CornerRadius = UDim.new(0, 10)

        local miniLogo = Instance.new("ImageLabel")
        miniLogo.Name = "LogoImage"
        miniLogo.Size = UDim2.new(0, 120, 0, 36)
        miniLogo.Position = UDim2.new(0.5, -60, 0.5, -18)
        miniLogo.BackgroundTransparency = 1
        miniLogo.Image = "rbxassetid://140374748745094"
        miniLogo.ScaleType = Enum.ScaleType.Fit
        miniLogo.Active = false
        miniLogo.ZIndex = 62
        miniLogo.Parent = buttonFrame

        local mainOriginalPos = main.Position
        local animScale = Instance.new("UIScale", main)
        animScale.Scale = 1
        local openTween, closeTween, scaleTween
        showGui = function()
            if not main then return end
            if openTween then openTween:Cancel(); openTween = nil end
            if closeTween then closeTween:Cancel(); closeTween = nil end
            if scaleTween then scaleTween:Cancel(); scaleTween = nil end
            main.Visible = true
            if miniBtn then miniBtn.Visible = false end
            main.Position = UDim2.new(mainOriginalPos.X.Scale, mainOriginalPos.X.Offset - 60,
                mainOriginalPos.Y.Scale, mainOriginalPos.Y.Offset)
            animScale.Scale = 0.5
            local info = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            openTween = TweenService:Create(main, info, {Position = mainOriginalPos})
            scaleTween = TweenService:Create(animScale, info, {Scale = 1})
            local thisTween = openTween
            thisTween.Completed:Connect(function(state)
                if state == Enum.PlaybackState.Completed and openTween == thisTween then
                    openTween, scaleTween = nil, nil
                end
            end)
            openTween:Play()
            scaleTween:Play()
        end
        hideGui = function()
            if not main or not main.Visible then return end
            if openTween then openTween:Cancel(); openTween = nil end
            if closeTween then closeTween:Cancel(); closeTween = nil end
            if scaleTween then scaleTween:Cancel(); scaleTween = nil end
            local targetPos = UDim2.new(mainOriginalPos.X.Scale, mainOriginalPos.X.Offset - 60,
                mainOriginalPos.Y.Scale, mainOriginalPos.Y.Offset)
            local info = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            closeTween = TweenService:Create(main, info, {Position = targetPos})
            scaleTween = TweenService:Create(animScale, info, {Scale = 0.5})
            local thisTween = closeTween
            thisTween.Completed:Connect(function(state)
                if state == Enum.PlaybackState.Completed and closeTween == thisTween then
                    main.Visible = false
                    if miniBtn then miniBtn.Visible = true end
                    closeTween, scaleTween = nil, nil
                end
            end)
            closeTween:Play()
            scaleTween:Play()
        end
        closeX.Activated:Connect(hideGui)
        miniBtn.Activated:Connect(showGui)

        local body = Instance.new("Frame")
        body.Name = "Body"
        body.Size = UDim2.new(1, 0, 1, -112)
        body.Position = UDim2.fromOffset(0, 112)
        body.BackgroundTransparency = 1
        body.ZIndex = 2
        body.Parent = main

        local contentArea = Instance.new("Frame")
        contentArea.Name = "ContentArea"
        contentArea.Size = UDim2.new(1, -80, 1, -10)
        contentArea.Position = UDim2.fromOffset(74, 5)
        contentArea.BackgroundColor3 = RH_Style.ink
        contentArea.BackgroundTransparency = 0.22
        contentArea.BorderSizePixel = 0
        contentArea.ClipsDescendants = true
        contentArea.ZIndex = 3
        contentArea.Parent = body
        Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 10)
        local contentStroke = Instance.new("UIStroke", contentArea)
        contentStroke.Color = Color3.fromRGB(40, 40, 40)
        contentStroke.Thickness = 1
        contentStroke.Transparency = 0.72

        local tabsFrame = Instance.new("Frame")
        tabsFrame.Name = "TabBar"
        tabsFrame.Position = UDim2.new(0, 8, 0, 120)
        tabsFrame.Size = UDim2.new(0, 58, 1, -130)
        tabsFrame.BackgroundColor3 = RH_Style.ink
        tabsFrame.BackgroundTransparency = 0.06
        tabsFrame.BorderSizePixel = 0
        tabsFrame.ClipsDescendants = true
        tabsFrame.ZIndex = 104
        tabsFrame.Parent = main
        Instance.new("UICorner", tabsFrame).CornerRadius = UDim.new(0, 13)
        local railStroke = Instance.new("UIStroke", tabsFrame)
        railStroke.Name = "RailStroke"
        railStroke.Color = RH_Style.border
        railStroke.Transparency = 0.38
        railStroke.Thickness = 1
        local tabsLayout = Instance.new("UIListLayout")
        tabsLayout.FillDirection = Enum.FillDirection.Vertical
        tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        tabsLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        tabsLayout.Padding = UDim.new(0, 6)
        tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabsLayout.Parent = tabsFrame
        local railTitle = Instance.new("TextLabel")
        railTitle.Name = "RailTitle"
        railTitle.LayoutOrder = -1
        railTitle.Size = UDim2.new(1, -8, 0, 28)
        railTitle.BackgroundTransparency = 1
        railTitle.Text = "CALZOSKY"
        railTitle.TextColor3 = RH_Style.muted
        railTitle.Font = Enum.Font.GothamBlack
        railTitle.TextSize = 8
        railTitle.ZIndex = 106
        railTitle.Parent = tabsFrame

        local sections = {
            {name = "Speed", title = "MOVEMENT"},
            {name = "Custom", title = "COMBAT"},
            {name = "Visual", title = "APPEARANCE"},
            {name = "Settings", title = "CONFIG"},
            {name = "Keybinds", title = "KEYBINDS"},
        }
        tabButtons = {}
        local data2022 = {}
        for i, section in ipairs(sections) do
            local page = Instance.new("ScrollingFrame")
            page.Name = section.name
            page.Size = UDim2.fromScale(1, 1)
            page.BackgroundTransparency = 1
            page.BorderSizePixel = 0
            page.ScrollBarThickness = 2
            page.ScrollBarImageColor3 = Color3.fromRGB(210, 212, 218)
            page.ScrollBarImageTransparency = 0.35
            page.AutomaticCanvasSize = Enum.AutomaticSize.Y
            page.CanvasSize = UDim2.new()
            page.ScrollingDirection = Enum.ScrollingDirection.Y
            page.Visible = false
            page.ZIndex = 4
            page.Parent = contentArea
            local pageLayout = Instance.new("UIListLayout", page)
            pageLayout.Padding = UDim.new(0, 6)
            pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
            local pagePad = Instance.new("UIPadding", page)
            pagePad.PaddingLeft = UDim.new(0, 10)
            pagePad.PaddingRight = UDim.new(0, 10)
            pagePad.PaddingTop = UDim.new(0, 8)
            pagePad.PaddingBottom = UDim.new(0, 10)
            local heading = Instance.new("Frame")
            heading.Name = "SectionHeading"
            heading.Size = UDim2.new(1, 0, 0, 24)
            heading.BackgroundTransparency = 1
            heading.LayoutOrder = 1
            heading.ZIndex = 5
            heading.Parent = page
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Name = "SectionLabel"
            sectionLabel.Size = UDim2.new(1, -14, 1, 0)
            sectionLabel.Position = UDim2.fromOffset(8, 0)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = section.title
            sectionLabel.TextColor3 = Color3.fromRGB(190, 192, 198)
            sectionLabel.Font = Enum.Font.GothamBold
            sectionLabel.TextSize = 9
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.ZIndex = 6
            sectionLabel.Parent = heading
            local sectionLine = Instance.new("Frame")
            sectionLine.Name = "SectionLine"
            sectionLine.Size = UDim2.new(1, -4, 0, 1)
            sectionLine.Position = UDim2.new(0, 2, 1, -1)
            sectionLine.BackgroundColor3 = Color3.fromRGB(90, 90, 96)
            sectionLine.BackgroundTransparency = 0.55
            sectionLine.BorderSizePixel = 0
            sectionLine.ZIndex = 5
            sectionLine.Parent = heading
            data2022[section.name] = page

            local btn = Instance.new("TextButton")
            btn.Name = section.name
            btn.LayoutOrder = i
            btn.Size = UDim2.new(1, -8, 0, 48)
            btn.BackgroundColor3 = RH_Style.panel
            btn.BackgroundTransparency = 0.7
            btn.BorderSizePixel = 0
            btn.Text = string.upper(section.name)
            btn.TextColor3 = RH_Style.muted
            btn.TextSize = 8
            btn.TextWrapped = true
            btn.TextYAlignment = Enum.TextYAlignment.Bottom
            btn.Font = Enum.Font.GothamBold
            btn.AutoButtonColor = false
            btn.ZIndex = 106
            btn.Parent = tabsFrame
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 9)
            local tabPadding = Instance.new("UIPadding", btn)
            tabPadding.PaddingBottom = UDim.new(0, 5)
            local tabGradient = Instance.new("UIGradient", btn)
            tabGradient.Name = "TabBgGrad"
            tabGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(222, 227, 238))
            tabGradient.Rotation = 0
            local tabStroke = Instance.new("UIStroke", btn)
            tabStroke.Name = "TabStroke"
            tabStroke.Color = RH_Style.border
            tabStroke.Thickness = 1
            tabStroke.Transparency = 0.58
            local iconKind = section.name == "Custom" and "Combat"
                or (section.name == "Settings" and "Config" or section.name)
            local navIcon = RH_Style.navIcon(btn, iconKind, UDim2.new(0.5, 0, 0, 2))
            RH_Style.paintIcon(navIcon, RH_Style.muted, 0)
            local underline = Instance.new("Frame", btn)
            underline.Name = "Underline"
            underline.Size = UDim2.new(0, 3, 0, 23)
            underline.Position = UDim2.new(0, 2, 0.5, 0)
            underline.AnchorPoint = Vector2.new(0, 0.5)
            underline.BackgroundColor3 = RH_Style.silver
            underline.BackgroundTransparency = 0
            underline.BorderSizePixel = 0
            underline.Visible = false
            underline.ZIndex = 109
            Instance.new("UICorner", underline).CornerRadius = UDim.new(1, 0)
            table.insert(tabButtons, btn)
        end
        contentPages = data2022
        local function setActiveTab(selectedIndex)
            selectedIndex = math.clamp(math.floor(tonumber(selectedIndex) or 1), 1, #sections)
            local changed = mainTabIndex ~= selectedIndex
            mainTabIndex = selectedIndex
            if changed then queueAutoSave() end
            for i, btn in ipairs(tabButtons) do
                local active = i == selectedIndex
                data2022[sections[i].name].Visible = active
                local underline = btn:FindFirstChild("Underline")
                if underline then underline.Visible = active end
                local stroke = btn:FindFirstChild("TabStroke")
                if stroke then
                    stroke.Color = active and RH_Style.silver or RH_Style.border
                    stroke.Transparency = active and 0.2 or 0.62
                end
                local icon = btn:FindFirstChild("NavIcon")
                RH_Style.paintIcon(icon, active and RH_Style.silver or RH_Style.muted, 0)
                btn.TextColor3 = active and RH_Style.text or RH_Style.muted
                btn.BackgroundColor3 = active and RH_Style.panel:Lerp(RH_Style.silver, 0.12) or RH_Style.panel
                btn.BackgroundTransparency = active and 0.05 or 0.62
            end
        end
        mainTabSetter = setActiveTab
        for i, btn in ipairs(tabButtons) do
            btn.Activated:Connect(function() setActiveTab(i) end)
        end
        setActiveTab(mainTabIndex or 1)
        local data2034 = {}
        for _, page in pairs(data2022) do data2034[page] = 2 end
        local function nextLayoutOrder(page)
            if not data2034[page] then
                data2034[page] = 0
            end
            data2034[page] = data2034[page] + 1
            return data2034[page]
        end
        local function createFrame(page, txt)
            local f = Instance.new("Frame", page)
            f.Size = UDim2.new(1, 0, 0, 26)
            f.BackgroundTransparency = 1
            f.BorderSizePixel = 0
            f.LayoutOrder = nextLayoutOrder(page)
            f.ZIndex = 7
            local l = Instance.new("TextLabel", f)
            l.Size = UDim2.new(1, -16, 1, 0)
            l.Position = UDim2.new(0, 8, 0, 0)
            l.BackgroundTransparency = 1
            l.Text = txt:upper()
            l.TextColor3 = Color3.fromRGB(230, 230, 235)
            l.Font = Enum.Font.SciFi
            l.TextSize = 15
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.TextStrokeColor3 = Color3.fromRGB(60, 60, 60)
            l.TextStrokeTransparency = 1
            l.ZIndex = 8
            local line = Instance.new("Frame", f)
            line.Size = UDim2.new(1, -24, 0, 1.5)
            line.Position = UDim2.new(0, 12, 1, -4)
            line.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
            line.BackgroundTransparency = 0.6
            line.BorderSizePixel = 0
            line.ZIndex = 8
            return f
        end
        local function createFrame2(value, value2045)
            local frame = Instance.new("Frame", value)
            frame.Size = UDim2.new(1, -4, 0, value2045 or 38)
            frame.BackgroundColor3 = color2
            frame.BackgroundTransparency = 0.7
            frame.BorderSizePixel = 0
            frame.LayoutOrder = nextLayoutOrder(value)
            frame.ZIndex = 7
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
            local uiStroke = Instance.new("UIStroke", frame)
            uiStroke.Color = color3
            uiStroke.Thickness = 1
            uiStroke.Transparency = 0.5
            frame.MouseEnter:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.1), {
                    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                }):Play()
            end)
            frame.MouseLeave:Connect(function()
                local data = {
                    BackgroundColor3 = color2,
                }
                TweenService:Create(frame, TweenInfo.new(0.1), data):Play()
            end)
            return frame
        end
        local function mkLabel(row, text)
            local l = Instance.new("TextLabel", row)
            l.Name = "RowLabel"
            l.Size = UDim2.new(0.55, 0, 1, 0)
            l.Position = UDim2.new(0, 10, 0, 0)
            l.BackgroundTransparency = 1
            l.Text = text
            l.TextColor3 = Color3.fromRGB(240, 235, 240)
            l.Font = Enum.Font.GothamBold
            l.TextSize = 11
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.TextTruncate = Enum.TextTruncate.AtEnd
            l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            l.TextStrokeTransparency = 1
            l.ZIndex = 8
            return l
        end
        local function mkPill(row, offset)
            local pill = Instance.new("Frame", row)
            pill.Name = "Track"
            pill.Size = UDim2.new(0, 34, 0, 18)
            pill.AnchorPoint = Vector2.new(0.5, 0.5)
            pill.Position = UDim2.new(1, -(offset or 48), 0.5, 0)
            pill.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
            pill.BackgroundTransparency = 0.1
            pill.BorderSizePixel = 0
            pill.ZIndex = 8
            Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 9)
            local uiStroke = Instance.new("UIStroke", pill)
            uiStroke.Color = color3
            uiStroke.Thickness = 1
            uiStroke.Transparency = 0.45
            uiStroke.Name = "PillStroke"
            local dot = Instance.new("Frame", pill)
            dot.Name = "Knob"
            dot.Size = UDim2.new(0, 13, 0, 13)
            dot.AnchorPoint = Vector2.new(0, 0)
            dot.Position = UDim2.new(0, 3, 0.5, -6)
            dot.BackgroundColor3 = Color3.fromRGB(225, 225, 230)
            dot.BorderSizePixel = 0
            dot.ZIndex = 9
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
            local shine = Instance.new("Frame", dot)
            shine.Name = "Shine"
            shine.Size = UDim2.new(1, -4, 0, 4)
            shine.Position = UDim2.new(0, 2, 0, 2)
            shine.BackgroundColor3 = color4
            shine.BackgroundTransparency = 0.72
            shine.BorderSizePixel = 0
            shine.ZIndex = 10
            Instance.new("UICorner", shine).CornerRadius = UDim.new(0, 4)
            return pill, dot
        end
        local function animPill(pill, dot, on)
            local uiStroke = pill:FindFirstChildOfClass("UIStroke")
            local themeColor = getThemeColor()
            local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(dot, tweenInfo, {
                Position = on and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
                BackgroundColor3 = on and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(225, 225, 230),
            }):Play()
            TweenService:Create(pill, tweenInfo, {
                BackgroundColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(18, 18, 22),
                BackgroundTransparency = on and 0 or 0.1,
            }):Play()
            if uiStroke then
                TweenService:Create(uiStroke, tweenInfo, {
                    Color = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(65, 68, 74),
                    Transparency = on and 0.05 or 0.35,
                    Thickness = on and 1.5 or 1,
                }):Play()
            end
        end
        local function mkSlider(row, minV, maxV, default, cb)
            local track = Instance.new("Frame", row)
            track.Size = UDim2.new(0, 118, 0, 4)
            track.Position = UDim2.new(1, -162, 0.5, -2)
            track.BackgroundColor3 = color5
            track.BackgroundTransparency = 0.3
            track.BorderSizePixel = 0
            track.ZIndex = 8
            Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
            local fill = Instance.new("Frame", track)
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = getThemeColor()
            fill.BorderSizePixel = 0
            fill.ZIndex = 9
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
            local knob = Instance.new("Frame", track)
            knob.Size = UDim2.new(0, 13, 0, 13)
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Position = UDim2.new(0, 0, 0.5, 0)
            knob.BackgroundColor3 = color4
            knob.BorderSizePixel = 0
            knob.ZIndex = 11
            Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
            local uiStroke = Instance.new("UIStroke", knob)
            uiStroke.Color = getThemeColor()
            uiStroke.Thickness = 2
            local valLabel = Instance.new("TextLabel", row)
            valLabel.Size = UDim2.new(0, 34, 0, 20)
            valLabel.Position = UDim2.new(1, -38, 0.5, -10)
            valLabel.BackgroundTransparency = 1
            valLabel.Text = tostring(default)
            valLabel.TextColor3 = color4
            valLabel.Font = Enum.Font.GothamBold
            valLabel.TextSize = 11
            valLabel.TextXAlignment = Enum.TextXAlignment.Right
            valLabel.ZIndex = 9
            local hit = Instance.new("TextButton", row)
            hit.Size = UDim2.new(0, 134, 0, 26)
            hit.Position = UDim2.new(1, -170, 0.5, -13)
            hit.BackgroundTransparency = 1
            hit.Text = ""
            hit.AutoButtonColor = false
            hit.ZIndex = 12
            local current = default
            local function render(a)
                local object = clamp(a, 0, 1)
                fill.Size = UDim2.new(object, 0, 1, 0)
                knob.Position = UDim2.new(object, 0, 0.5, 0)
                fill.BackgroundColor3 = getThemeColor()
                uiStroke.Color = getThemeColor()
            end
            local function applyFromX(px)
                local x = track.AbsolutePosition.X
                local x2 = track.AbsoluteSize.X
                if x2 <= 0 then
                    x2 = 118
                end
                if x <= 0 then
                    return
                end
                local a = clamp((px - x) / x2, 0, 1)
                local object = floor(minV + (maxV - minV) * a + 0.5)
                current = object
                valLabel.Text = tostring(object)
                render(a)
                if cb then
                    pcall(cb, object)
                end
                queueAutoSave()
            end
            local dragging = false
            hit.InputBegan:Connect(function(input)
                if
                    input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch
                then
                    dragging = true
                    _isDraggingButton = true
                    applyFromX(input.Position.X)
                end
            end)
            hit.InputEnded:Connect(function(input)
                if
                    input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch
                then
                    dragging = false
                    _isDraggingButton = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if not dragging then
                    return
                end
                if
                    input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch
                then
                    applyFromX(input.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if not dragging then
                    return
                end
                if
                    input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch
                then
                    dragging = false
                    _isDraggingButton = false
                end
            end)
            local function setValue(value)
                local object = clamp(tonumber(value) or minV, minV, maxV)
                current = object
                valLabel.Text = tostring(object)
                render((object - minV) / (maxV - minV))
            end
            setValue(default)
            return setValue
        end
        local function mkToggle(page, txt, cb)
            local row = createFrame2(page, 38)
            mkLabel(row, txt)
            local pill, dot = mkPill(row, 48)
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
                if editModeEnabled and not uiLocked then
                    pcall(cb, not on)
                else
                    on = not on
                    sv(on)
                    pcall(cb, on)
                end
                queueAutoSave()
            end)
            return sv
        end
        local function createTextBox(parent, default, w, xOff, cb)
            local textBox = Instance.new("TextBox", parent)
            w = w or 50
            local xo = math.max(xOff or 56, w + 12)
            textBox.Size = UDim2.new(0, w, 0, 24)
            textBox.Position = UDim2.new(1, -xo, 0.5, -12)
            textBox.BackgroundColor3 = color5
            textBox.BackgroundTransparency = 0.7
            textBox.BorderSizePixel = 0
            textBox.Text = tostring(default)
            textBox.TextColor3 = color4
            textBox.Font = Enum.Font.GothamBold
            textBox.TextSize = 11
            textBox.ClearTextOnFocus = false
            textBox.ZIndex = 8
            Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)
            local uiStroke = Instance.new("UIStroke", textBox)
            uiStroke.Color = color3
            uiStroke.Thickness = 1.2
            uiStroke.Transparency = 0.25
            textBox.Focused:Connect(function()
                TweenService:Create(uiStroke, TweenInfo.new(0.12), {
                    Color = getThemeColor(),
                    Transparency = 0,
                }):Play()
            end)
            textBox.FocusLost:Connect(function()
                local data = {
                    Color = color3,
                    Transparency = 0.25,
                }
                TweenService:Create(uiStroke, TweenInfo.new(0.12), data):Play()
                if cb then
                    local num = tonumber(textBox.Text)
                    if num then
                        pcall(cb, num)
                    else
                        textBox.Text = tostring(default)
                    end
                end
                queueAutoSave()
            end)
            return textBox
        end
        local function createTextButton(parent, kbEntry)
            local button = Instance.new("TextButton", parent)
            button.Size = UDim2.new(0, 80, 0, 24)
            button.Position = UDim2.new(1, -88, 0.5, -12)
            button.BackgroundColor3 = color5
            button.BackgroundTransparency = 0.5
            button.BorderSizePixel = 0
            local function getLabel()
                return kbEntry.gp and kbEntry.gp.Name or kbEntry.kb and kbEntry.kb.Name or "None"
            end
            button.Text = getLabel()
            button.TextColor3 = color4
            button.Font = Enum.Font.GothamBold
            button.TextSize = 9
            button.ZIndex = 8
            button.AutoButtonColor = false
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
            local bs = Instance.new("UIStroke", button)
            bs.Color = color3
            bs.Thickness = 1
            local li = false
            local connection2 = nil
            local text = button.Text
            local listenStart = 0
            button.Activated:Connect(function()
                if li then
                    li = false
                    _anyKeyListening = false
                    if connection2 then
                        connection2:Disconnect()
                        connection2 = nil
                    end
                    button.Text = text
                    button.TextColor3 = color4
                    return
                end
                text = button.Text
                li = true
                _anyKeyListening = true
                listenStart = getTime()
                button.Text = "..."
                button.TextColor3 = color4
                connection2 = UserInputService.InputBegan:Connect(function(input)
                    if not li then
                        return
                    end
                    if input.KeyCode == Enum.KeyCode.Escape then
                        li = false
                        _anyKeyListening = false
                        if connection2 then
                            connection2:Disconnect()
                            connection2 = nil
                        end
                        button.Text = text
                        button.TextColor3 = color4
                        return
                    end
                    local isGp = isGamepadInput(input)
                    if isGp and getTime() - listenStart < 0.15 then
                        return
                    end
                    if not isBindableInput(input) then
                        return
                    end
                    button.Text = input.KeyCode.Name
                    text = input.KeyCode.Name
                    button.TextColor3 = color4
                    li = false
                    _anyKeyListening = false
                    if connection2 then
                        connection2:Disconnect()
                        connection2 = nil
                    end
                    if isGp then
                        kbEntry.gp = input.KeyCode
                        kbEntry.kb = nil
                    else
                        kbEntry.kb = input.KeyCode
                        kbEntry.gp = nil
                    end
                    queueAutoSave()
                end)
            end)
            table.insert(keyButtonRefs, {
                btn = button,
                entry = kbEntry,
            })
            return button
        end
        local function createCarouselSelector(parent, currentValue, options, onChanged)
            local frame = Instance.new("Frame", parent)
            frame.Name = "CarouselSelector"
            frame.AnchorPoint = Vector2.new(1, 0.5)
            frame.Size = UDim2.new(0, 126, 0, 28)
            frame.Position = UDim2.new(1, -8, 0.5, 0)
            frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            frame.BackgroundTransparency = 0.12
            frame.BorderSizePixel = 0
            frame.Active = true
            frame.ZIndex = 8
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
            local rowLabel = parent:FindFirstChild("RowLabel")
            if rowLabel and rowLabel:IsA("TextLabel") then
                rowLabel.Size = UDim2.new(0.34, 0, 1, 0)
            end
            local stroke = Instance.new("UIStroke", frame)
            stroke.Color = Color3.fromRGB(76, 76, 82)
            stroke.Thickness = 1
            stroke.Transparency = 0.35

            local function createArrow(name, symbol, position)
                local button = Instance.new("TextButton", frame)
                button.Name = name
                button.Size = UDim2.fromOffset(20, 20)
                button.Position = position
                button.AnchorPoint = Vector2.new(0, 0.5)
                button.BackgroundColor3 = Color3.fromRGB(50, 50, 54)
                button.BackgroundTransparency = 0
                button.BorderSizePixel = 0
                button.Text = symbol
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.TextSize = 14
                button.Font = Enum.Font.GothamBold
                button.AutoButtonColor = false
                button.ZIndex = 10
                Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
                button.MouseEnter:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.1), {
                        BackgroundColor3 = Color3.fromRGB(70, 70, 74),
                    }):Play()
                end)
                button.MouseLeave:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.1), {
                        BackgroundColor3 = Color3.fromRGB(50, 50, 54),
                    }):Play()
                end)
                return button
            end

            local leftButton = createArrow("Previous", "<", UDim2.new(0, 4, 0.5, 0))
            local rightButton = createArrow("Next", ">", UDim2.new(1, -24, 0.5, 0))

            local textLabel = Instance.new("TextLabel", frame)
            textLabel.Name = "Value"
            textLabel.Size = UDim2.new(1, -52, 1, 0)
            textLabel.Position = UDim2.new(0, 26, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = tostring(currentValue)
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.Font = Enum.Font.Gotham
            textLabel.TextSize = 11
            textLabel.TextXAlignment = Enum.TextXAlignment.Center
            textLabel.TextYAlignment = Enum.TextYAlignment.Center
            textLabel.TextTruncate = Enum.TextTruncate.AtEnd
            textLabel.ZIndex = 9

            local selectedIndex = 1
            for i, entry in ipairs(options) do
                if tostring(entry) == tostring(currentValue) then
                    selectedIndex = i
                    break
                end
            end

            local function animateLabel(text)
                textLabel.Text = tostring(text)
                textLabel.TextTransparency = 0.35
                TweenService:Create(textLabel, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextTransparency = 0,
                }):Play()
            end

            local function changeSelection(direction)
                if #options == 0 then
                    return
                end
                selectedIndex = ((selectedIndex - 1 + direction) % #options) + 1
                local selectedValue = options[selectedIndex]
                animateLabel(selectedValue)
                if onChanged then
                    pcall(onChanged, selectedValue, selectedIndex)
                end
                queueAutoSave()
            end

            leftButton.Activated:Connect(function()
                changeSelection(-1)
            end)
            rightButton.Activated:Connect(function()
                changeSelection(1)
            end)
            frame.MouseEnter:Connect(function()
                TweenService:Create(stroke, TweenInfo.new(0.12), {
                    Color = Color3.fromRGB(190, 190, 195),
                    Transparency = 0.08,
                }):Play()
            end)
            frame.MouseLeave:Connect(function()
                TweenService:Create(stroke, TweenInfo.new(0.12), {
                    Color = Color3.fromRGB(76, 76, 82),
                    Transparency = 0.35,
                }):Play()
            end)

            local proxy = {}
            setmetatable(proxy, {
                __index = function(_, key)
                    return textLabel[key]
                end,
                __newindex = function(_, key, value)
                    if key == "Text" then
                        local text = tostring(value)
                        for i, entry in ipairs(options) do
                            if tostring(entry) == text then
                                selectedIndex = i
                                break
                            end
                        end
                        textLabel.Text = text
                        textLabel.TextTransparency = 0
                    else
                        textLabel[key] = value
                    end
                end,
            })
            return proxy
        end
        local function createTool3DSkinCard(parent, title, category, getEnabled, onEnabledChanged, getSkin, onSkinChanged)
            local row = createFrame2(parent, 80)
            local viewport = Instance.new("ViewportFrame", row)
            viewport.Name = category .. "3DPreview"
            viewport.Size = UDim2.fromOffset(56, 56)
            viewport.Position = UDim2.new(0, 12, 0.5, -28)
            viewport.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
            viewport.BackgroundTransparency = 0
            viewport.BorderSizePixel = 0
            viewport.ZIndex = 9
            Instance.new("UICorner", viewport).CornerRadius = UDim.new(0, 8)
            local viewportStroke = Instance.new("UIStroke", viewport)
            viewportStroke.Color = Color3.fromRGB(76, 76, 82)
            viewportStroke.Thickness = 1
            viewportStroke.Transparency = 0.35

            local world = Instance.new("WorldModel")
            world.Parent = viewport
            local camera = Instance.new("Camera")
            camera.FieldOfView = 42
            camera.Parent = viewport
            viewport.CurrentCamera = camera

            local titleLabel = Instance.new("TextLabel", row)
            titleLabel.Name = "Title"
            titleLabel.Size = UDim2.new(0, 78, 0, 18)
            titleLabel.Position = UDim2.new(0, 78, 0, 6)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = title
            titleLabel.TextColor3 = Color3.fromRGB(245, 245, 248)
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextSize = 11
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
            titleLabel.ZIndex = 9

            local enabledLabel = Instance.new("TextLabel", row)
            enabledLabel.Name = "EnabledState"
            enabledLabel.Size = UDim2.new(0, 32, 0, 14)
            enabledLabel.Position = UDim2.new(1, -105, 0, 7)
            enabledLabel.BackgroundTransparency = 1
            enabledLabel.Font = Enum.Font.GothamBold
            enabledLabel.TextSize = 9
            enabledLabel.TextXAlignment = Enum.TextXAlignment.Center
            enabledLabel.ZIndex = 9

            local modelLabel = Instance.new("TextLabel", row)
            modelLabel.Name = "ModelName"
            modelLabel.Size = UDim2.new(0, 130, 0, 18)
            modelLabel.Position = UDim2.new(0, 78, 0, 27)
            modelLabel.BackgroundTransparency = 1
            modelLabel.TextColor3 = Color3.fromRGB(195, 195, 202)
            modelLabel.Font = Enum.Font.Gotham
            modelLabel.TextSize = 10
            modelLabel.TextXAlignment = Enum.TextXAlignment.Left
            modelLabel.TextTruncate = Enum.TextTruncate.AtEnd
            modelLabel.ZIndex = 9

            local function makeArrow(name, symbol, x)
                local button = Instance.new("TextButton", row)
                button.Name = name
                button.Size = UDim2.fromOffset(28, 20)
                button.Position = UDim2.new(0, x, 0, 52)
                button.BackgroundColor3 = Color3.fromRGB(42, 42, 46)
                button.BorderSizePixel = 0
                button.Text = symbol
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.TextSize = 13
                button.Font = Enum.Font.GothamBold
                button.AutoButtonColor = false
                button.ZIndex = 10
                Instance.new("UICorner", button).CornerRadius = UDim.new(0, 5)
                button.MouseEnter:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.1), {
                        BackgroundColor3 = Color3.fromRGB(68, 68, 72),
                    }):Play()
                end)
                button.MouseLeave:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.1), {
                        BackgroundColor3 = Color3.fromRGB(42, 42, 46),
                    }):Play()
                end)
                return button
            end
            local previousButton = makeArrow("PreviousSkin", "<", 78)
            local nextButton = makeArrow("NextSkin", ">", 110)

            local enabled, selectedKey = getEnabled() == true, getSkin()
            local pill, dot = mkPill(row, 46)
            local toggleButton = Instance.new("TextButton", pill)
            toggleButton.Name = "Toggle3D"
            toggleButton.Size = UDim2.new(1, 0, 1, 0)
            toggleButton.BackgroundTransparency = 1
            toggleButton.Text = ""
            toggleButton.AutoButtonColor = false
            toggleButton.ZIndex = 11

            local function setEnabledVisual(value)
                enabled = value == true
                animPill(pill, dot, enabled)
                enabledLabel.Text = enabled and "ON" or "OFF"
                enabledLabel.TextColor3 = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(145, 145, 152)
            end

            local keys = {}
            for key, data in pairs(customTool3DAssets) do
                if data.cat == category then
                    table.insert(keys, key)
                end
            end
            table.sort(keys)
            local spinConnection = nil

            local function showModel(key)
                local data = customTool3DAssets[key]
                if not data or data.cat ~= category then
                    key = keys[1]
                    data = customTool3DAssets[key]
                end
                if not data then
                    modelLabel.Text = "No model"
                    return
                end
                selectedKey = key
                modelLabel.Text = data.label or key
                if spinConnection then
                    spinConnection:Disconnect()
                    spinConnection = nil
                end
                for _, child in ipairs(world:GetChildren()) do
                    child:Destroy()
                end
                local part = Instance.new("Part")
                part.Name = "PreviewModel"
                part.Size = Vector3.new(1, 1, 1)
                part.Anchored = true
                part.CanCollide = false
                part.CanQuery = false
                part.CanTouch = false
                part.Parent = world
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = data.mesh
                mesh.TextureId = data.tex or ""
                mesh.Scale = data.scale
                mesh.Parent = part
                camera.CFrame = CFrame.new(Vector3.new(0, 0.35, data.view or 5), Vector3.new(0, 0, 0))
                local angle = 0
                spinConnection = RunService.RenderStepped:Connect(function(deltaTime)
                    if not part.Parent or not row.Parent then
                        if spinConnection then
                            spinConnection:Disconnect()
                            spinConnection = nil
                        end
                        return
                    end
                    angle += (deltaTime or 0) * 1.35
                    part.CFrame = CFrame.Angles(0, angle, 0)
                end)
            end

            local function changeSkin(direction)
                if #keys == 0 then
                    return
                end
                local index = 1
                for i, key in ipairs(keys) do
                    if key == selectedKey then
                        index = i
                        break
                    end
                end
                index = ((index - 1 + direction) % #keys) + 1
                showModel(keys[index])
                if onSkinChanged then
                    pcall(onSkinChanged, selectedKey)
                end
                pcall(refreshCustomTool3DSkins)
                queueAutoSave()
            end

            previousButton.Activated:Connect(function()
                changeSkin(-1)
            end)
            nextButton.Activated:Connect(function()
                changeSkin(1)
            end)
            toggleButton.Activated:Connect(function()
                setEnabledVisual(not enabled)
                if onEnabledChanged then
                    pcall(onEnabledChanged, enabled)
                end
                pcall(refreshCustomTool3DSkins)
                queueAutoSave()
            end)

            showModel(selectedKey)
            setEnabledVisual(enabled)
            row.AncestryChanged:Connect(function(_, newParent)
                if not newParent and spinConnection then
                    spinConnection:Disconnect()
                    spinConnection = nil
                end
            end)

            return {
                setEnabled = setEnabledVisual,
                setSkin = function(key)
                    local data = customTool3DAssets[key]
                    if data and data.cat == category then
                        showModel(key)
                    end
                end,
            }
        end

        local function createActionRow(parent, labelText, buttonText)
            local frame2 = createFrame2(parent, 36)
            mkLabel(frame2, labelText)
            createTextButton(frame2, buttonText)
        end
        local speed = data2022.Speed
        createFrame(speed, "Base Speeds")
        local frame2 = createFrame2(speed, 38)
        mkLabel(frame2, "Normal Speed")
        normalBox = createTextBox(frame2, NS, 50, 56, function(nS)
            if nS > 0 and nS <= 500 then
                NS = nS
            end
            return
        end)
        local frame22118 = createFrame2(speed, 38)
        mkLabel(frame22118, "Carry Speed")
        carryBox = createTextBox(frame22118, CS, 50, 56, function(cS)
            if cS > 0 and cS <= 500 then
                CS = cS
            end
        end)
        local frame22120 = createFrame2(speed, 38)
        mkLabel(frame22120, "Lagger Normal")
        laggerBox = createTextBox(frame22120, LAGGER_SPEED, 50, 56, function(lAGGERSPEED)
            if lAGGERSPEED > 0 and lAGGERSPEED <= 500 then
                LAGGER_SPEED = lAGGERSPEED
            end
        end)
        local frame22122 = createFrame2(speed, 38)
        mkLabel(frame22122, "Lagger Carry")
        lagger2Box = createTextBox(frame22122, LAGGER_CARRY_SPEED, 50, 56, function(lAGGERCARRYSPEED)
            if lAGGERCARRYSPEED > 0 and lAGGERCARRYSPEED <= 500 then
                LAGGER_CARRY_SPEED = lAGGERCARRYSPEED
            end
        end)
        local frame22124 = createFrame2(speed, 38)
        mkLabel(frame22124, "Current Mode")
        local text
        if laggerCarryToggled then
            text = "Lagger Carry"
        elseif laggerToggled then
            text = "Lagger"
        else
            text = "Normal"
            if speedMode then
                text = "Carry"
            end
        end
        modeValLbl = createCarouselSelector(frame22124, text, {
            "Normal",
            "Carry",
            "Lagger",
            "Lagger Carry",
        }, function(value)
            speedMode = false
            laggerToggled = false
            laggerCarryToggled = false
            if value == "Carry" then
                speedMode = true
            elseif value == "Lagger" then
                laggerToggled = true
            elseif value == "Lagger Carry" then
                laggerCarryToggled = true
            end
            resetMovementState()
            if mobSetCarry then
                mobSetCarry(speedMode)
            end
            if mobSetLagger1 then
                mobSetLagger1(laggerToggled)
            end
            if mobSetLagger2 then
                mobSetLagger2(laggerCarryToggled)
            end
        end)
        createFrame(speed, "Auto Carry System")
        carrySystemToggleSetter = mkToggle(speed, "Auto Carry", function(useCarrySystem2127)
            useCarrySystem = useCarrySystem2127
            if useCarrySystem2127 then
                carryController:start()
                carryController.speedToggled = speedMode
                if laggerCarryToggled then
                    carryController:setLaggerMode(2)
                elseif laggerToggled then
                    carryController:setLaggerMode(1)
                else
                    carryController:setLaggerMode(0)
                end
                carryController:setSoftStealEnabled(true)
            else
                carryController:stop()
                carryController:setSoftStealEnabled(false)
            end
            saveAllSettings()
        end)
        local frame22128 = createFrame2(speed, 38)
        mkLabel(frame22128, "Normal Speed")
        carrySysNormalBox = createTextBox(frame22128, carryController.normalSpeed, 50, 56, function(value)
            if value > 0 and value <= 500 then
                carryController:setNormalSpeed(value)
                saveAllSettings()
            end
        end)
        local frame22130 = createFrame2(speed, 38)
        mkLabel(frame22130, "Carry Speed")
        carrySysCarryBox = createTextBox(frame22130, carryController.carrySpeed, 50, 56, function(value)
            if value > 0 and value <= 500 then
                carryController:setCarrySpeed(value)
                saveAllSettings()
            end
        end)
        local frame22132 = createFrame2(speed, 38)
        mkLabel(frame22132, "Lagger Speed")
        carrySysLaggerBox = createTextBox(frame22132, carryController.laggerSpeed, 50, 56, function(value)
            if value > 0 and value <= 500 then
                carryController:setLaggerSpeed(value)
                saveAllSettings()
            end
        end)
        local frame22134 = createFrame2(speed, 38)
        mkLabel(frame22134, "Lagger Carry Spd")
        carrySysLaggerCarryBox = createTextBox(frame22134, carryController.laggerCarrySpeed, 50, 56, function(value)
            if value > 0 and value <= 500 then
                carryController:setLaggerCarrySpeed(value)
                saveAllSettings()
            end
        end)
        local frame22136 = createFrame2(speed, 38)
        mkLabel(frame22136, "Soft Steal Speed")
        carrySysSoftStealSpeedBox = createTextBox(frame22136, carryController.softStealSpeed, 50, 56, function(value)
            if value > 0 and value <= 500 then
                carryController:setSoftStealSpeed(value)
                saveAllSettings()
            end
        end)
        local frame22138 = createFrame2(speed, 38)
        mkLabel(frame22138, "Soft Steal Radius")
        carrySysSoftStealRadiusBox = createTextBox(frame22138, carryController.softStealRadius, 50, 56, function(value)
            if value > 0 then
                carryController:setSoftStealRadius(value)
                saveAllSettings()
            end
        end)
        createFrame(speed, "Auto Movement")
        autoLeftSetVisual = mkToggle(speed, "Auto Left", function(on)
            autoLeftEnabled = on
            if on then
                startAutoLeft()
            else
                stopAutoLeft()
            end
            if mobSetAutoLeft then
                mobSetAutoLeft(on)
            end
        end)
        autoRightSetVisual = mkToggle(speed, "Auto Right", function(on)
            autoRightEnabled = on
            if on then
                startAutoRight()
            else
                stopAutoRight()
            end
            if mobSetAutoRight then
                mobSetAutoRight(on)
            end
        end)
        createFrame(speed, "Teleport")
        local frame22142 = createFrame2(speed, 38)
        mkLabel(frame22142, "TP Down")
        local label = Instance.new("TextButton", frame22142)
        label.Size = UDim2.new(0.58, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = ""
        label.AutoButtonColor = false
        label.ZIndex = 8
        label.MouseButton1Click:Connect(function()
            teleportDown()
        end)
        local textLabel = Instance.new("TextLabel", frame22142)
        textLabel.Size = UDim2.new(0, 70, 1, 0)
        textLabel.Position = UDim2.new(1, -78, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = "ACTIVATE"
        textLabel.TextColor3 = Color3.fromRGB(230, 230, 240)
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 9
        textLabel.TextXAlignment = Enum.TextXAlignment.Right
        textLabel.ZIndex = 8
        CleanHubAutoTPDownSetVisual = mkToggle(speed, "Auto TP Down", function(cleanHubAutoTPDown)
            CleanHubAutoTPDown = cleanHubAutoTPDown
            saveAllSettings()
        end)
        local frame22146 = createFrame2(speed, 38)
        mkLabel(frame22146, "TP Down Height")
        createTextBox(frame22146, CleanHubAutoTPDownHeight, 50, 56, function(value)
            CleanHubAutoTPDownHeight = math.clamp(value, 0, 500)
            saveAllSettings()
        end)
        mirrorTPDownSetVisual = mkToggle(speed, "Mirror TP Down", function(value)
            _G.AmbitiousSetMirrorTPDown(value)
        end)
        infJumpSetVisual = mkToggle(speed, "Hold Jump", function(value)
            _G.setInfJumpInternal(value)
            saveAllSettings()
        end)
        local frame22150 = createFrame2(speed, 38)
        mkLabel(frame22150, "Jump Mode")
        infJumpModeSetVisual = createCarouselSelector(frame22150, infJumpMode, {
            "HOLD",
            "MANUAL",
        }, function(infJumpMode2151)
            if infJumpMode2151 ~= "MANUAL" then
                infJumpMode2151 = "HOLD"
            end
            infJumpMode = infJumpMode2151
            if infJumpMode == "MANUAL" then
                _G.AmbitiousStopNormalInfJumpHoldState()
            end
            saveAllSettings()
        end)
        local custom = data2022.Custom
        createFrame(custom, "Aimbots")
        autoBatSetVisual = mkToggle(custom, "Auto Bat", function(on)
            if on then
                enableAutoBat()
            else
                disableAutoBat()
            end
            if mobSetAutoBat then
                mobSetAutoBat(on)
            end
        end)
        local frame22154 = createFrame2(custom, 38)
        mkLabel(frame22154, "Bat Aimbot Speed")
        batSpeedBox = createTextBox(frame22154, BAT_AIMBOT_SPEED, 50, 56, function(bATAIMBOTSPEED)
            if bATAIMBOTSPEED > 0 and bATAIMBOTSPEED <= 200 then
                BAT_AIMBOT_SPEED = bATAIMBOTSPEED
            end
        end)
        batDesyncTpSetVisual = mkToggle(custom, "TP BAT", function(on)
            if on then
                if not batDesyncTpEnabled then
                    toggleBatDesyncTp()
                end
            elseif batDesyncTpEnabled then
                toggleBatDesyncTp()
            end
        end)
        if batDesyncTpSetVisual then
            batDesyncTpSetVisual(batDesyncTpEnabled)
        end
        autoBatV2SetVisual = mkToggle(custom, "Bat Bypass", function(on)
            if on then
                enableBatV2()
            else
                disableBatV2()
            end
        end)
        if autoBatV2SetVisual then
            autoBatV2SetVisual(autoBatV2Enabled)
        end
        _G.AceAimbotSetVisual = autoBatV2SetVisual
        do
            local versionRow = createFrame2(custom, 38)
            mkLabel(versionRow, "Bat V2 Version")
            batV2VersionSelector = createCarouselSelector(versionRow, batV2Version, {"Version 1", "Version 2"}, function(value)
                batV2Version = value == "Version 1" and "Version 1" or "Version 2"
                if applyBatV2VersionProfile then pcall(applyBatV2VersionProfile) end
                persistBatV2Version()
            end)
        end
        do
            local speedRow = createFrame2(custom, 38)
            mkLabel(speedRow, "Bat V2 Speed")
            batV2SpeedBox = createTextBox(speedRow, BAT_V2_SPEED, 50, 56, function(value)
                if type(value) == "number" then
                    BAT_V2_SPEED = math.clamp(value, 1, 500)
                    _G.AceAntiBypassAimbotSpeed = BAT_V2_SPEED
                    if applyBatV2VersionProfile then applyBatV2VersionProfile() end
                    saveAllSettings()
                end
            end)
        end
        createFrame(custom, "Counters")
        setBatCounterVisual = mkToggle(custom, "Bat Counter", function(on)
            batCounterEnabled = on
            if on then
                startBatCounter()
            else
                stopBatCounter()
            end
        end)
        setBatCounterV2Visual = mkToggle(custom, "Bat Counter V2", function(on)
            batCounterV2Enabled = on
            if on then
                startBatCounterV2()
            else
                stopBatCounterV2()
            end
        end)
        setMedusaVisual = mkToggle(custom, "Medusa Counter", function(on)
            medusaCounterEnabled = on
            if on then
                if localPlayer.Character then
                    setupMedusaCounter(localPlayer.Character)
                else
                    stopMedusaCounter()
                end
            else
                stopMedusaCounter()
            end
            if setMedusaVisual then
                setMedusaVisual(on)
            end
        end)
        createFrame(custom, "Defense")
        bodyLockSetVisual = mkToggle(custom, "Body Lock", function(on)
            bodyLockEnabled = on
            if on then
                if _blSuppressCount == 0 then
                    startBodyLock()
                end
            else
                stopBodyLock()
            end
        end)
        local frame22163 = createFrame2(custom, 38)
        mkLabel(frame22163, "Body Lock Range")
        bodyLockRangeBox = createTextBox(frame22163, bodyLockRange, 50, 56, function(value)
            if value and value > 0 then
                bodyLockRange = clamp(floor(value), 5, 200)
                if bodyLockRangeBox then
                    bodyLockRangeBox.Text = tostring(bodyLockRange)
                end
            end
        end)
        setSafeModeVisual = mkToggle(custom, "Safe Mode", function(on)
            antiKickEnabled = on
            if on and _G.AmbitiousSafeModeForceStop then
                _G.AmbitiousSafeModeForceStop("SAFE MODE")
            end
            saveAllSettings()
        end)
        setNoPlayerCollisionVisual = mkToggle(custom, "No Player Collision", function(on)
            setNoPlayerCollision(on)
            saveAllSettings()
        end)
        if setNoPlayerCollisionVisual then
            setNoPlayerCollisionVisual(noPlayerCollisionEnabled)
        end
        createFrame(custom, "Survival")
        local frame22167 = createFrame2(custom, 38)
        mkLabel(frame22167, "Anti Ragdoll")
        local text2232
        if antiRagdollMode == "v1" then
            text2232 = "V1"
        else
            text2232 = "Off"
            if antiRagdollMode == "v2" then
                text2232 = "V2"
            end
        end
        local label2171 = createCarouselSelector(frame22167, text2232, {
            "Off",
            "V1",
            "V2",
        }, function(callback)
            local lowercaseText = callback:lower()
            setAntiRagdollMode(lowercaseText)
        end)
        _G.updateAntiRagdollUI = function(value)
            local text = "Off"
            if value == "v1" then
                text = "V1"
            elseif value == "v2" then
                text = "V2"
            end
            if label2171 then
                label2171.Text = text
            end
        end
        _G.updateAntiRagdollUI(antiRagdollMode)
        setUnwalkVisual = mkToggle(custom, "Unwalk", function(on)
            unwalkEnabled = on
            if on then
                startUnwalk()
            else
                stopUnwalk()
            end
            saveAllSettings()
        end)
        setAntiDieVisual = mkToggle(custom, "Anti Die", function(on)
            antiDieEnabled = on
            if on then
                antiDie.start()
            else
                antiDie.stop()
            end
            saveAllSettings()
        end)
        if setAntiDieVisual then
            setAntiDieVisual(antiDieEnabled)
        end
        createFrame(custom, "Drop")
        dropBrainrotSetVisual = mkToggle(custom, "Drop Brainrot", function(on)
            if on then
                executeDropWithToggle(function(value)
                    dropBrainrotSetVisual(value)
                    if mobSetDropBR then
                        mobSetDropBR(value)
                    end
                end)
            end
        end)
        setDropVisual = dropBrainrotSetVisual
        local frame22179 = createFrame2(custom, 38)
        mkLabel(frame22179, "Drop Mode")
        dropModeBtnRef = createCarouselSelector(frame22179, dropMode == 1 and "Fling" or "Jump Drop", {
            "Fling",
            "Jump Drop",
        }, function(direction)
            if dropActive then
                stopDropBrainrot()
            end
            dropMode = direction == "Fling" and 1 or 2
        end)
        local visual = data2022.Visual
        createFrame(visual, "Interface")
        setEditModeVisual = mkToggle(visual, "Edit Button", function(on)
            toggleEditMode(on)
            if on and uiLocked then
                editModeEnabled = false
                setEditModeVisual(false)
            end
        end)
        if setEditModeVisual then
            setEditModeVisual(editModeEnabled)
        end
        setLockUIVisual = mkToggle(visual, "Lock UI", function(on)
            toggleLockUI(on)
            if on and editModeEnabled then
                editModeEnabled = false
                if setEditModeVisual then
                    setEditModeVisual(false)
                end
            end
        end)
        setESPVIsual = mkToggle(visual, "Player ESP", function(on)
            toggleESP(on)
        end)
        createFrame(visual, "Camera")
        setFovVisual = mkToggle(visual, "FOV", function(on)
            if on then
                enableCustomFov()
            else
                disableCustomFov()
            end
        end)
        if setFovVisual then
            setFovVisual(fovEnabled)
        end
        local frame22186 = createFrame2(visual, 38)
        mkLabel(frame22186, "FOV Value")
        fovSliderSet = mkSlider(frame22186, 20, 120, fovValue, function(fovValue2187)
            fovValue = fovValue2187
            if not fovEnabled then
                enableCustomFov()
                if setFovVisual then
                    setFovVisual(true)
                end
            end
            local currentCamera2 = workspace.CurrentCamera
            if currentCamera2 then
                pcall(function()
                    currentCamera2.FieldOfView = fovValue
                end)
            end
            return
        end)
        setNoCamCollisionVisual = mkToggle(visual, "No Cam Collision", function(on)
            if on then
                enableNoCamCollision()
            else
                disableNoCamCollision()
            end
            saveAllSettings()
        end)
        if setNoCamCollisionVisual then
            setNoCamCollisionVisual(noCamCollisionEnabled)
        end
        local frame22190 = createFrame2(visual, 38)
        mkLabel(frame22190, "Stretch Rez")
        local object2255, object2256 = mkPill(frame22190, 48)
        local object2257 = false
        local function stretchToggleSetter(s)
            object2257 = s
            animPill(object2255, object2256, s)
            if s then
                enableStretch()
            else
                disableStretch()
            end
            stretchEnabled = s
        end
        local label2196 = Instance.new("TextButton", object2255)
        label2196.Size = UDim2.new(1, 0, 1, 0)
        label2196.BackgroundTransparency = 1
        label2196.Text = ""
        label2196.AutoButtonColor = false
        label2196.ZIndex = 10
        label2196.MouseButton1Click:Connect(function()
            stretchToggleSetter(not object2257)
        end)
        _G.stretchToggleSetter = stretchToggleSetter
        createFrame(visual, "Performance")
        setAntiLagVisual = mkToggle(visual, "Anti Lag", function(on)
            if on then
                enableAntiLag()
            else
                disableAntiLag()
            end
        end)
        CleanHubShowE01WarningSetVisual = mkToggle(visual, "Show E01 Warning", function(on)
            CleanHubShowE01Warning = on
            saveAllSettings()
        end)
        createFrame(visual, "Environment")
        local frame22199 = createFrame2(visual, 38)
        mkLabel(frame22199, "Sky Theme")
        skySelectorLabel = createCarouselSelector(frame22199, skyTheme, SKY_PRESETS_LIST, function(skyTheme2200)
            local activeSpecialMode = specialSkyMode or "Off"
            if activeSpecialMode ~= "Off" then
                setSpecialSkyMode("Off", false)
            end
            skyTheme = skyTheme2200
            pcall(applyCustomSky, skyTheme2200)
            if activeSpecialMode ~= "Off" then
                setSpecialSkyMode(activeSpecialMode, false)
            end
            pcall(saveAllSettings)
        end)
        local specialSkyRow = createFrame2(visual, 38)
        mkLabel(specialSkyRow, "Sky")
        specialSkySelector = createCarouselSelector(specialSkyRow, specialSkyMode, SPECIAL_SKY_OPTIONS, function(mode)
            setSpecialSkyMode(mode, true)
        end)
        createFrame(visual, "Audio")
        local musicPlayerRow = createFrame2(visual, 38)
        mkLabel(musicPlayerRow, "Music Player")
        local openMusicButton = Instance.new("TextButton", musicPlayerRow)
        openMusicButton.Name = "OpenMusicPlayer"
        openMusicButton.Size = UDim2.fromOffset(66, 24)
        openMusicButton.AnchorPoint = Vector2.new(1, 0.5)
        openMusicButton.Position = UDim2.new(1, -8, 0.5, 0)
        openMusicButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        openMusicButton.BackgroundTransparency = 0.1
        openMusicButton.BorderSizePixel = 0
        openMusicButton.Text = "OPEN"
        openMusicButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        openMusicButton.Font = Enum.Font.GothamBold
        openMusicButton.TextSize = 10
        openMusicButton.AutoButtonColor = false
        openMusicButton.ZIndex = 9
        Instance.new("UICorner", openMusicButton).CornerRadius = UDim.new(0, 7)
        local openMusicStroke = Instance.new("UIStroke", openMusicButton)
        openMusicStroke.Color = Color3.fromRGB(115, 115, 122)
        openMusicStroke.Thickness = 1
        openMusicStroke.Transparency = 0.25
        openMusicButton.Activated:Connect(function()
            local playerApi = _G.RevHubMusicPlayer
            if playerApi and playerApi.toggle then
                playerApi.toggle(openMusicButton)
            end
        end)
        createFrame(visual, "Personalización")
        local bat3DSkinCard = createTool3DSkinCard(
            visual,
            "Bat 3D",
            "Bat",
            function() return bat3DSkinEnabled end,
            function(enabled)
                bat3DSkinEnabled = enabled
                pcall(refreshCustomTool3DSkins)
            end,
            function() return customBat3DSkin end,
            function(skinKey)
                customBat3DSkin = skinKey
                pcall(refreshCustomTool3DSkins)
            end
        )
        customTool3DSkinCards.Bat = bat3DSkinCard
        setBat3DSkinVisual = bat3DSkinCard.setEnabled

        local medusa3DSkinCard = createTool3DSkinCard(
            visual,
            "Medusa 3D",
            "Medusa",
            function() return medusa3DSkinEnabled end,
            function(enabled)
                medusa3DSkinEnabled = enabled
                pcall(refreshCustomTool3DSkins)
            end,
            function() return customMedusa3DSkin end,
            function(skinKey)
                customMedusa3DSkin = skinKey
                pcall(refreshCustomTool3DSkins)
            end
        )
        customTool3DSkinCards.Medusa = medusa3DSkinCard
        setMedusa3DSkinVisual = medusa3DSkinCard.setEnabled

        setCustomSoundsVisual = mkToggle(visual, "Custom Song", function(on)
            customSoundsEnabled = on == true
            if _G.AmbitiousCustomSounds then
                pcall(_G.AmbitiousCustomSounds.setEnabled, customSoundsEnabled)
            end
        end)
        setRainbowToolsVisual = mkToggle(visual, "Rainbow Tools", function(on)
            rainbowToolsEnabled = on == true
            if _G.AmbitiousRainbowTools then
                pcall(_G.AmbitiousRainbowTools.setEnabled, rainbowToolsEnabled)
            end
        end)

        local frame22206 = createFrame2(visual, 38)
        mkLabel(frame22206, "Anim Pack")
        local data2271 = {}
        for _, entry in ipairs(ANIM_PACK_ORDER) do
            table.insert(data2271, entry[2])
        end
        animSelectorLabel = createCarouselSelector(frame22206, currentAnimPack, data2271, function(value)
            if value == "Off" then
                disableAnimationPack()
            else
                applyAnimationPack(value)
            end
        end)
        local frame22211 = createFrame2(visual, 38)
        mkLabel(frame22211, "Outfit")
        local data2276 = {}
        for _, entry2214 in ipairs(outfits) do
            table.insert(data2276, entry2214.label)
        end
        outfitSelectorLabel = createCarouselSelector(
            frame22211,
            outfits[currentOutfitIndex].label,
            data2276,
            function(value)
                for i, entry in ipairs(outfits) do
                    if entry.label == value then
                        currentOutfitIndex = i
                        pcall(function()
                            applyOutfitByIndex(currentOutfitIndex)
                        end)
                        saveAllSettings()
                        break
                    end
                end
            end
        )
        local frame22218 = createFrame2(visual, 56)
        local rootPart2219 = Instance.new("Frame", frame22218)
        rootPart2219.Name = "BackgroundPreview"
        rootPart2219.Size = UDim2.new(0, 56, 0, 44)
        rootPart2219.Position = UDim2.new(0, 8, 0.5, -22)
        rootPart2219.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
        rootPart2219.BackgroundTransparency = 0.15
        rootPart2219.BorderSizePixel = 0
        rootPart2219.ClipsDescendants = true
        rootPart2219.ZIndex = 8
        Instance.new("UICorner", rootPart2219).CornerRadius = UDim.new(0, 8)
        local uiStroke = Instance.new("UIStroke", rootPart2219)
        uiStroke.Color = color3
        uiStroke.Thickness = 1.2
        uiStroke.Transparency = 0.55
        local rootPart2221 = Instance.new("ImageLabel", rootPart2219)
        rootPart2221.Name = "PreviewImage"
        rootPart2221.Size = UDim2.new(1, 0, 1, 0)
        rootPart2221.Position = UDim2.new(0, 0, 0, 0)
        rootPart2221.BackgroundTransparency = 1
        rootPart2221.Image = ""
        rootPart2221.ScaleType = Enum.ScaleType.Crop
        rootPart2221.ZIndex = 9
        Instance.new("UICorner", rootPart2221).CornerRadius = UDim.new(0, 8)
        local label2222 = Instance.new("TextLabel", rootPart2219)
        label2222.Name = "PreviewPlaceholder"
        label2222.Size = UDim2.new(1, 0, 1, 0)
        label2222.BackgroundTransparency = 1
        label2222.Text = "OFF"
        label2222.TextColor3 = Color3.fromRGB(160, 160, 170)
        label2222.Font = Enum.Font.GothamBlack
        label2222.TextSize = 12
        label2222.ZIndex = 10
        local function updateBackgroundPreview(index)
            local background = BACKGROUND_IMAGES[index]
            if not background or not background.id or background.id == "" then
                rootPart2221.Image = ""
                label2222.Visible = true
                uiStroke.Color = color3
            else
                rootPart2221.Image = background.id
                label2222.Visible = false
                uiStroke.Color = getThemeColor()
            end
        end
        local function pulseBackgroundPreview()
            rootPart2219.Size = UDim2.new(0, 56, 0, 44)
            TweenService:Create(rootPart2219, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
                Size = UDim2.new(0, 60, 0, 47),
            }):Play()
            task.delay(0.15, function()
                TweenService:Create(rootPart2219, TweenInfo.new(0.15), {
                    Size = UDim2.new(0, 56, 0, 44),
                }):Play()
            end)
        end
        rootPart2219.MouseEnter:Connect(function()
            TweenService:Create(uiStroke, TweenInfo.new(0.12), {
                Color = getThemeColor(),
                Transparency = 0.05,
            }):Play()
        end)
        rootPart2219.MouseLeave:Connect(function()
            local background = BACKGROUND_IMAGES[backgroundIndex]
            local hasNoImage = not background or not background.id or background.id == ""
            TweenService:Create(uiStroke, TweenInfo.new(0.12), {
                Color = hasNoImage and color3 or getThemeColor(),
                Transparency = hasNoImage and 0.55 or 0.2,
            }):Play()
        end)
        local data2293 = {}
        for _, entry2231 in ipairs(BACKGROUND_IMAGES) do
            table.insert(data2293, entry2231.label)
        end
        backgroundSelectorLabel = createCarouselSelector(
            frame22218,
            BACKGROUND_IMAGES[backgroundIndex].label,
            data2293,
            function(value)
                for i, entry in ipairs(BACKGROUND_IMAGES) do
                    if entry.label == value then
                        applyBackground(i)
                        updateBackgroundPreview(i)
                        pulseBackgroundPreview()
                        saveAllSettings()
                        break
                    end
                end
            end
        )
        updateBackgroundPreview(backgroundIndex)
        local settings_ = data2022.Settings
        createFrame(settings_, "Intro")
        local frame22237 = createFrame2(settings_, 38)
        mkLabel(frame22237, "Intro Song")
        local data2302 = {}
        for i = 1, #introSongIds do
            data2302[i] = "Song " .. i
        end
        createCarouselSelector(frame22237, "Song " .. currentIntroSongIndex, data2302, function(callback)
            currentIntroSongIndex = math.clamp(tonumber(callback:match("%d+")) or 1, 1, #introSongIds)
            saveAllSettings()
        end)
        createFrame(settings_, "Auto Steal")
        setInstaGrab = mkToggle(settings_, "Auto Steal", function(autoStealEnabled)
            CONFIG.AUTO_STEAL_ENABLED = autoStealEnabled
            if autoStealEnabled then
                pcall(startAutoSteal)
            else
                stopAutoSteal()
            end
            updateProgressBarVisibility()
        end)
        local frame22242 = createFrame2(settings_, 38)
        mkLabel(frame22242, "Steal Radius")
        radInput = createTextBox(frame22242, CONFIG.STEAL_RANGE, 50, 56, function(value)
            if value and value >= 5 and value <= 300 then
                CONFIG.STEAL_RANGE = floor(value + 0.5)
                autoStealState.StealRadius = CONFIG.STEAL_RANGE
                radInput.Text = tostring(CONFIG.STEAL_RANGE)
                saveAllSettings()
            end
        end)
        local frame22244 = createFrame2(settings_, 38)
        mkLabel(frame22244, "Steal Version")
        local object2309 = AUTO_STEAL_VARIANT_NAMES
        autoStealVariantLabel = createCarouselSelector(
            frame22244,
            getAutoStealVariantName(autoStealVariant),
            object2309,
            function(value)
                autoStealVariant = getAutoStealVariantIndex(value)
                saveAllSettings()
            end
        )
        createFrame(settings_, "UI Settings")
        local frame22247 = createFrame2(settings_, 38)
        mkLabel(frame22247, "UI Scale")
        uiScaleBox = createTextBox(frame22247, 70, 50, 56, function()
            uiScaleValue = 70
            if mainUIScale then mainUIScale.Scale = 0.7 end
            if uiScaleBox then uiScaleBox.Text = "70" end
            saveAllSettings()
        end)
        uiScaleBox.TextEditable = false
        local frame22250 = createFrame2(settings_, 38)
        mkLabel(frame22250, "Float Scale")
        createTextBox(frame22250, floor(floatingButtonScale * 100), 50, 56, function(value)
            floatingButtonScale = clamp(value, 50, 200) / 100
            applyFloatingButtonScale()
            saveAllSettings()
        end)
        local frame22252 = createFrame2(settings_, 38)
        mkLabel(frame22252, "Steal Bar Scale")
        createTextBox(frame22252, floor(progressBarScale * 100), 50, 56, function(value)
            progressBarScale = clamp(value, 50, 200) / 100
            if pbScale then
                pbScale.Scale = progressBarScale
            end
            saveAllSettings()
        end)
        createFrame(settings_, "Mobile Buttons")
        local frame22254 = createFrame2(settings_, 38)
        mkLabel(frame22254, "Hide Mobile Buttons")
        local object2322, object2323 = mkPill(frame22254, 48)
        local ambitiousHideMobileButtons = _G.AmbitiousHideMobileButtons == true
        local function updateMobileButtonsPill(hidden)
            ambitiousHideMobileButtons = hidden
            animPill(object2322, object2323, hidden)
        end
        updateMobileButtonsPill(ambitiousHideMobileButtons)
        local label2260 = Instance.new("TextButton", object2322)
        label2260.Size = UDim2.new(1, 0, 1, 0)
        label2260.BackgroundTransparency = 1
        label2260.Text = ""
        label2260.AutoButtonColor = false
        label2260.ZIndex = 10
        label2260.MouseButton1Click:Connect(function()
            ambitiousHideMobileButtons = not ambitiousHideMobileButtons
            _G.AmbitiousHideMobileButtons = ambitiousHideMobileButtons
            updateMobileButtonsPill(ambitiousHideMobileButtons)
            _G.AmbitiousApplyMobileButtonsHidden()
            saveAllSettings()
        end)
        createFrame(settings_, "Config Management")
        local frame22278 = createFrame2(settings_, 44)
        frame22278.Size = UDim2.new(1, 0, 0, 44)
        local rootPart2279 = Instance.new("TextButton", frame22278)
        rootPart2279.Size = UDim2.new(1, -20, 0.82, 0)
        rootPart2279.Position = UDim2.new(0, 10, 0.09, 0)
        rootPart2279.BackgroundColor3 = Color3.fromRGB(85, 255, 255)
        rootPart2279.BorderSizePixel = 0
        rootPart2279.Text = ""
        rootPart2279.AutoButtonColor = false
        rootPart2279.ZIndex = 8
        Instance.new("UICorner", rootPart2279).CornerRadius = UDim.new(1, 0)
        local uiGradient = Instance.new("UIGradient", rootPart2279)
        uiGradient.Rotation = 90
        local data2349 = {}
        local object2350 = ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 120, 130))
        local object2351 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 60, 70))
        data2349[1] = object2350
        data2349[2] = object2351
        data2349[3] = ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 26))
        uiGradient.Color = ColorSequence.new(data2349)
        local uiStroke2 = Instance.new("UIStroke", rootPart2279)
        uiStroke2.Color = Color3.fromRGB(200, 200, 215)
        uiStroke2.Thickness = 1.5
        uiStroke2.Transparency = 0.55
        local label2285 = Instance.new("TextLabel", rootPart2279)
        label2285.Size = UDim2.new(1, 0, 1, 0)
        label2285.BackgroundTransparency = 1
        label2285.Text = "SAVE CONFIG"
        label2285.TextColor3 = Color3.fromRGB(85, 255, 85)
        label2285.Font = Enum.Font.GothamBlack
        label2285.TextSize = 13
        label2285.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label2285.TextStrokeTransparency = 0.55
        label2285.ZIndex = 9
        rootPart2279.MouseEnter:Connect(function()
            TweenService:Create(rootPart2279, TweenInfo.new(0.14, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -12, 0.92, 0),
                Position = UDim2.new(0, 6, 0.04, 0),
            }):Play()
            TweenService:Create(uiStroke2, TweenInfo.new(0.14), {
                Transparency = 0.05,
            }):Play()
        end)
        rootPart2279.MouseLeave:Connect(function()
            TweenService:Create(rootPart2279, TweenInfo.new(0.14, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -20, 0.82, 0),
                Position = UDim2.new(0, 10, 0.09, 0),
            }):Play()
            TweenService:Create(uiStroke2, TweenInfo.new(0.14), {
                Transparency = 0.35,
            }):Play()
        end)
        rootPart2279.MouseButton1Click:Connect(function()
            label2285.Text = saveAllSettings() and "SAVED ✓" or "ERROR"
            task.delay(1.2, function()
                if label2285 and label2285.Parent then
                    label2285.Text = "SAVE CONFIG"
                end
            end)
        end)
        local frame22286 = createFrame2(settings_, 44)
        frame22286.Size = UDim2.new(1, 0, 0, 44)
        local rootPart2287 = Instance.new("TextButton", frame22286)
        rootPart2287.Size = UDim2.new(1, -20, 0.82, 0)
        rootPart2287.Position = UDim2.new(0, 10, 0.09, 0)
        rootPart2287.BackgroundColor3 = Color3.fromRGB(85, 255, 255)
        rootPart2287.BorderSizePixel = 0
        rootPart2287.Text = ""
        rootPart2287.AutoButtonColor = false
        rootPart2287.ZIndex = 8
        Instance.new("UICorner", rootPart2287).CornerRadius = UDim.new(1, 0)
        local uiGradient2 = Instance.new("UIGradient", rootPart2287)
        uiGradient2.Rotation = 90
        local data2361 = {}
        local object2362 = ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 90, 110))
        local object2363 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(45, 55, 75))
        data2361[1] = object2362
        data2361[2] = object2363
        data2361[3] = ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 22, 32))
        uiGradient2.Color = ColorSequence.new(data2361)
        local uiStroke3 = Instance.new("UIStroke", rootPart2287)
        uiStroke3.Color = Color3.fromRGB(150, 175, 210)
        uiStroke3.Thickness = 1.5
        uiStroke3.Transparency = 0.35
        local label2293 = Instance.new("TextLabel", rootPart2287)
        label2293.Size = UDim2.new(1, 0, 1, 0)
        label2293.BackgroundTransparency = 1
        label2293.Text = "RESET POSITIONS"
        label2293.TextColor3 = Color3.fromRGB(85, 255, 255)
        label2293.Font = Enum.Font.GothamBlack
        label2293.TextSize = 13
        label2293.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label2293.TextStrokeTransparency = 0.55
        label2293.ZIndex = 9
        rootPart2287.MouseEnter:Connect(function()
            TweenService:Create(rootPart2287, TweenInfo.new(0.14, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -12, 0.92, 0),
                Position = UDim2.new(0, 6, 0.04, 0),
            }):Play()
            TweenService:Create(uiStroke3, TweenInfo.new(0.14), {
                Transparency = 0.05,
            }):Play()
        end)
        rootPart2287.MouseLeave:Connect(function()
            TweenService:Create(rootPart2287, TweenInfo.new(0.14, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -20, 0.82, 0),
                Position = UDim2.new(0, 10, 0.09, 0),
            }):Play()
            TweenService:Create(uiStroke3, TweenInfo.new(0.14), {
                Transparency = 0.35,
            }):Play()
        end)
        local isEnabled = false
        rootPart2287.MouseButton1Click:Connect(function()
            if isEnabled then
                return
            end
            isEnabled = true
            resetFloatingPositions()
            label2293.Text = "RESET ✓"
            task.delay(1.2, function()
                if label2293 and label2293.Parent then
                    label2293.Text = "RESET POSITIONS"
                    isEnabled = false
                end
            end)
        end)
        local frame22295 = createFrame2(settings_, 44)
        frame22295.Size = UDim2.new(1, 0, 0, 44)
        local rootPart2296 = Instance.new("TextButton", frame22295)
        rootPart2296.Size = UDim2.new(1, -20, 0.82, 0)
        rootPart2296.Position = UDim2.new(0, 10, 0.09, 0)
        rootPart2296.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        rootPart2296.BorderSizePixel = 0
        rootPart2296.Text = ""
        rootPart2296.AutoButtonColor = false
        rootPart2296.ZIndex = 8
        Instance.new("UICorner", rootPart2296).CornerRadius = UDim.new(1, 0)
        local uiGradient3 = Instance.new("UIGradient", rootPart2296)
        uiGradient3.Rotation = 90
        local data2374 = {}
        local object2375 = ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 45, 80))
        local object2376 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 25, 55))
        data2374[1] = object2375
        data2374[2] = object2376
        data2374[3] = ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 10, 30))
        uiGradient3.Color = ColorSequence.new(data2374)
        local uiStroke4 = Instance.new("UIStroke", rootPart2296)
        uiStroke4.Color = Color3.fromRGB(255, 130, 170)
        uiStroke4.Thickness = 1.5
        uiStroke4.Transparency = 0.35
        local label2302 = Instance.new("TextLabel", rootPart2296)
        label2302.Size = UDim2.new(1, 0, 1, 0)
        label2302.BackgroundTransparency = 1
        label2302.Text = "DELETE SETTINGS"
        label2302.TextColor3 = Color3.fromRGB(255, 255, 255)
        label2302.Font = Enum.Font.GothamBlack
        label2302.TextSize = 13
        label2302.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label2302.TextStrokeTransparency = 0.55
        label2302.ZIndex = 9
        rootPart2296.MouseEnter:Connect(function()
            TweenService:Create(rootPart2296, TweenInfo.new(0.14, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -12, 0.92, 0),
                Position = UDim2.new(0, 6, 0.04, 0),
            }):Play()
            TweenService:Create(uiStroke4, TweenInfo.new(0.14), {
                Transparency = 0.05,
            }):Play()
        end)
        rootPart2296.MouseLeave:Connect(function()
            TweenService:Create(rootPart2296, TweenInfo.new(0.14, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -20, 0.82, 0),
                Position = UDim2.new(0, 10, 0.09, 0),
            }):Play()
            TweenService:Create(uiStroke4, TweenInfo.new(0.14), {
                Transparency = 0.35,
            }):Play()
        end)
        local value2384 = 0
        local isEnabled2385 = false
        rootPart2296.MouseButton1Click:Connect(function()
            if isEnabled2385 then
                return
            end
            if value2384 == 0 then
                value2384 = 1
                label2302.Text = "CONFIRM?"
                local object = uiGradient3
                local data = {}
                local object2389 = ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 70, 100))
                local object2390 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 40, 70))
                data[1] = object2389
                data[2] = object2390
                data[3] = ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 15, 40))
                object.Color = ColorSequence.new(data)
                task.delay(2, function()
                    if rootPart2296 and rootPart2296.Parent and value2384 == 1 then
                        value2384 = 0
                        label2302.Text = "DELETE SETTINGS"
                        local object = uiGradient3
                        local data = {}
                        local object2397 = ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 45, 80))
                        local object2398 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 25, 55))
                        data[1] = object2397
                        data[2] = object2398
                        data[3] = ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 10, 30))
                        object.Color = ColorSequence.new(data)
                    end
                end)
            elseif value2384 == 1 then
                isEnabled2385 = true
                label2302.Text = pcall(resetToFactoryDefaults) and "DELETED ✓" or "ERROR"
                value2384 = 0
                task.delay(1.5, function()
                    if label2302 and label2302.Parent then
                        label2302.Text = "DELETE SETTINGS"
                        local object = uiGradient3
                        local data = {}
                        local object2406 = ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 45, 80))
                        local object2407 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 25, 55))
                        data[1] = object2406
                        data[2] = object2407
                        data[3] = ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 10, 30))
                        object.Color = ColorSequence.new(data)
                        isEnabled2385 = false
                    end
                end)
            end
        end)
        local keybinds = data2022.Keybinds
        createFrame(keybinds, "Keybinds")
        createActionRow(keybinds, "Carry Mode", KB.CarryToggle)
        createActionRow(keybinds, "Lagger Mode", KB.LaggerMode)
        createActionRow(keybinds, "Auto Left", KB.AutoLeft)
        createActionRow(keybinds, "Auto Right", KB.AutoRight)
        createActionRow(keybinds, "Auto Bat", KB.AutoBat)
        createActionRow(keybinds, "TP BAT", KB.TPBat)
        createActionRow(keybinds, "Bat Bypass", KB.BatV2)
        createActionRow(keybinds, "Insta Reset", KB.InstaReset)
        createActionRow(keybinds, "TP Down", KB.TPFloor)
        createActionRow(keybinds, "Drop Brainrot", KB.DropBrainrot)
        createActionRow(keybinds, "Hide GUI", KB.GuiHide)
        local vector2318 = Instance.new("Frame", keybinds)
        vector2318.Size = UDim2.new(1, 0, 0, 16)
        vector2318.BackgroundTransparency = 1
        vector2318.LayoutOrder = nextLayoutOrder(keybinds)
        vector2318.ZIndex = 7
        pbFrame = Instance.new("Frame", gui)
        pbFrame.Name = "MustHubStealBar"
        pbFrame.Size = UDim2.new(0, 320, 0, 40)
        pbFrame.Position = UDim2.new(0.5, -160, 0.85, 0)
        pbFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        pbFrame.BackgroundTransparency = 0
        pbFrame.BorderSizePixel = 0
        pbFrame.Active = true
        pbFrame.ClipsDescendants = true
        pbFrame.Visible = CONFIG.AUTO_STEAL_ENABLED
        pbFrame.ZIndex = 70
        Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 15)
        local barMetalGradient = Instance.new("UIGradient", pbFrame)
        barMetalGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 220, 220)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 160, 160)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100)),
        })
        barMetalGradient.Rotation = 90
        local barStroke = Instance.new("UIStroke", pbFrame)
        barStroke.Color = Color3.fromRGB(80, 80, 80)
        barStroke.Thickness = 2
        barStroke.Transparency = 0.2

        backgroundImagePB = Instance.new("ImageLabel", pbFrame)
        backgroundImagePB.Name = "BackgroundImagePB"
        backgroundImagePB.Size = UDim2.new(1, 0, 1, 0)
        backgroundImagePB.Position = UDim2.new(0, 0, 0, 0)
        backgroundImagePB.BackgroundTransparency = 1
        backgroundImagePB.BorderSizePixel = 0
        local initialBackground = BACKGROUND_IMAGES[backgroundIndex]
        backgroundImagePB.Image = initialBackground and initialBackground.id or ""
        backgroundImagePB.ScaleType = Enum.ScaleType.Crop
        backgroundImagePB.ImageTransparency = 1
        backgroundImagePB.Visible = false
        backgroundImagePB.ZIndex = 70
        Instance.new("UICorner", backgroundImagePB).CornerRadius = UDim.new(0, 15)

        pbScale = Instance.new("UIScale", pbFrame)
        pbScale.Scale = progressBarScale
        if savedProgressBarPos then
            pbFrame.Position = UDim2.new(
                savedProgressBarPos.XScale or 0.5,
                savedProgressBarPos.XOffset or -160,
                savedProgressBarPos.YScale or 0.85,
                savedProgressBarPos.YOffset or 0
            )
        end

        progressFill = Instance.new("Frame", pbFrame)
        progressFill.Name = "Fill"
        progressFill.Size = UDim2.new(0, 0, 1, 0)
        progressFill.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
        progressFill.BackgroundTransparency = 0.32
        progressFill.BorderSizePixel = 0
        progressFill.ZIndex = 71
        progressFill.ClipsDescendants = true
        Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 15)
        local progressGradient = Instance.new("UIGradient", progressFill)
        progressGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 170, 170)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(105, 105, 105)),
        })
        progressGradient.Rotation = 90

        local progressEndCap = Instance.new("Frame", progressFill)
        progressEndCap.Name = "ProgressEndCap"
        progressEndCap.AnchorPoint = Vector2.new(1, 0)
        progressEndCap.Position = UDim2.new(1, 0, 0, 0)
        progressEndCap.Size = UDim2.new(0, 4, 1, 0)
        progressEndCap.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        progressEndCap.BorderSizePixel = 0
        progressEndCap.ZIndex = 72
        progressEndCap.Visible = false
        progressFill:GetPropertyChangedSignal("Size"):Connect(function()
            progressEndCap.Visible = progressFill.Size.X.Scale > 0.002 or progressFill.Size.X.Offset > 0
        end)

        progressPct = Instance.new("TextLabel", pbFrame)
        progressPct.Name = "ProgressPercent"
        progressPct.Size = UDim2.new(1, -120, 1, 0)
        progressPct.Position = UDim2.new(0, 0, 0, 0)
        progressPct.BackgroundTransparency = 1
        progressPct.Text = "0%"
        progressPct.TextColor3 = Color3.fromRGB(10, 10, 10)
        progressPct.Font = Enum.Font.GothamBlack
        progressPct.TextSize = 20
        progressPct.TextXAlignment = Enum.TextXAlignment.Center
        progressPct.TextYAlignment = Enum.TextYAlignment.Center
        progressPct.ZIndex = 73

        local statsContainer = Instance.new("Frame", pbFrame)
        statsContainer.Name = "StatsContainer"
        statsContainer.Size = UDim2.new(0, 60, 0, 24)
        statsContainer.Position = UDim2.new(1, -100, 0.5, -12)
        statsContainer.BackgroundTransparency = 1
        statsContainer.ZIndex = 73

        fpsNeon = Instance.new("TextLabel", statsContainer)
        fpsNeon.Name = "FPSText"
        fpsNeon.Size = UDim2.new(1, 0, 0.5, 0)
        fpsNeon.Position = UDim2.new(0, 0, 0, 0)
        fpsNeon.BackgroundTransparency = 1
        fpsNeon.Text = "FPS: 0"
        fpsNeon.TextColor3 = Color3.fromRGB(10, 10, 10)
        fpsNeon.Font = Enum.Font.Code
        fpsNeon.TextSize = 12
        fpsNeon.TextXAlignment = Enum.TextXAlignment.Left
        fpsNeon.ZIndex = 74

        progressPingLabel = Instance.new("TextLabel", statsContainer)
        progressPingLabel.Name = "MSText"
        progressPingLabel.Size = UDim2.new(1, 0, 0.5, 0)
        progressPingLabel.Position = UDim2.new(0, 0, 0.5, 0)
        progressPingLabel.BackgroundTransparency = 1
        progressPingLabel.Text = "MS: 0"
        progressPingLabel.TextColor3 = Color3.fromRGB(10, 10, 10)
        progressPingLabel.Font = Enum.Font.Code
        progressPingLabel.TextSize = 12
        progressPingLabel.TextXAlignment = Enum.TextXAlignment.Left
        progressPingLabel.ZIndex = 74

        local barDivider = Instance.new("Frame", pbFrame)
        barDivider.Name = "Divider"
        barDivider.Size = UDim2.new(0, 2, 0.7, 0)
        barDivider.Position = UDim2.new(1, -110, 0.15, 0)
        barDivider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        barDivider.BorderSizePixel = 0
        barDivider.ZIndex = 74

        local lockBg = Instance.new("TextButton", pbFrame)
        lockBg.Name = "StealBarLock"
        lockBg.Size = UDim2.new(0, 28, 0, 28)
        lockBg.Position = UDim2.new(1, -35, 0.5, -14)
        lockBg.BackgroundColor3 = Color3.fromRGB(80, 70, 50)
        lockBg.BorderSizePixel = 0
        lockBg.Text = ""
        lockBg.AutoButtonColor = false
        lockBg.Active = true
        lockBg.ZIndex = 75
        Instance.new("UICorner", lockBg).CornerRadius = UDim.new(0, 6)

        local lockIcon = Instance.new("TextLabel", lockBg)
        lockIcon.Name = "LockIcon"
        lockIcon.Size = UDim2.new(1, 0, 1, 0)
        lockIcon.BackgroundTransparency = 1
        lockIcon.Text = "🔓"
        lockIcon.TextColor3 = Color3.fromRGB(255, 180, 50)
        lockIcon.TextSize = 16
        lockIcon.Active = false
        lockIcon.ZIndex = 76

        setStealBarLockVisual = function(value)
            local locked = value == true
            savedProgressBarLocked = locked
            if pbFrame then pbFrame:SetAttribute("StealBarLocked", locked) end
            if lockIcon and lockIcon.Parent then
                lockIcon.Text = locked and "🔒" or "🔓"
                lockIcon.TextColor3 = locked and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 180, 50)
            end
            if lockBg and lockBg.Parent then
                lockBg.BackgroundColor3 = locked and Color3.fromRGB(120, 40, 40) or Color3.fromRGB(80, 70, 50)
            end
            return locked
        end
        setStealBarLockVisual(savedProgressBarLocked)
        lockBg.Activated:Connect(function()
            setStealBarLockVisual(not (pbFrame:GetAttribute("StealBarLocked") == true))
            pcall(saveAllSettings)
        end)

        _G.MustHubStealBarOnly = {
            setProgress = function(value, duration)
                local normalized = clamp(tonumber(value) or 0, 0, 1)
                if progressFill then
                    TweenService:Create(progressFill, TweenInfo.new(clamp(tonumber(duration) or 0.3, 0, 2)), {
                        Size = UDim2.new(normalized, 0, 1, 0),
                    }):Play()
                end
                if progressPct then
                    progressPct.Text = floor(normalized * 100) .. "%"
                end
            end,
            setVisible = function(value)
                if pbFrame then
                    pbFrame.Visible = value == true
                end
            end,
            setRadius = function(value)
                local radius = tonumber(value)
                if radius then
                    CONFIG.STEAL_RANGE = clamp(radius, 5, 300)
                    autoStealState.StealRadius = CONFIG.STEAL_RANGE
                end
                if progressRadLbl then
                    progressRadLbl.Text = "Radius: " .. tostring(CONFIG.STEAL_RANGE)
                end
            end,
            setLocked = function(value)
                if setStealBarLockVisual then
                    setStealBarLockVisual(value)
                elseif pbFrame then
                    pbFrame:SetAttribute("StealBarLocked", value == true)
                end
                pcall(saveAllSettings)
            end,
        }
        makeDraggable(pbFrame, true)
        task.spawn(function()
            local lastFrame = getTime()
            local fpsSamples = {}
            local fpsAvg = 60
            RunService.RenderStepped:Connect(function()
                local now = getTime()
                local deltaTime = now - lastFrame
                lastFrame = now
                if 0 < deltaTime then
                    table.insert(fpsSamples, 1 / deltaTime)
                    if #fpsSamples > 30 then
                        table.remove(fpsSamples, 1)
                    end
                    local sum = 0
                    for _, entry in ipairs(fpsSamples) do
                        sum += entry
                    end
                    fpsAvg = sum / #fpsSamples
                end
            end)
            while true do
                local ping = 0
                pcall(function()
                    ping = localPlayer:GetNetworkPing() * 1000
                end)
                if fpsNeon then
                    fpsNeon.Text = string.format("FPS: %d", floor(fpsAvg + 0.5))
                end
                if progressPingLabel then
                    progressPingLabel.Text = string.format("MS: %d", floor(ping + 0.5))
                end
                if progressRadLbl and CONFIG then
                    progressRadLbl.Text = "Radius: " .. tostring(CONFIG.STEAL_RANGE)
                end
                task.wait(0.5)
            end
        end)
        makeDraggable(main)
    end
end
--  FLOAT (portado de Lust Hub)
--=========================================================
do
    local old = rawget(_G, "__RivalHubFloat")
    if type(old) == "table" then
        local wasOn = old.running == true or old.conn ~= nil
        old.running = false
        old.cycleToken = (old.cycleToken or 0) + 1
        if old.thread then pcall(task.cancel, old.thread); old.thread = nil end
        if old.conn then pcall(function() old.conn:Disconnect() end); old.conn = nil end
        if wasOn and type(old.groundTP) == "function" then pcall(old.groundTP) end
    end
end

_G.__RivalHubFloat = {
    RISE = 17, RATE = 55, CYCLE = 2.5, PAUSE = 0.5, SAMPLE = 0.08, PIT_MARGIN = 15,
    conn = nil, thread = nil, running = false, locked = false,
    targetY = nil, baseY = nil, baseGround = nil,
    safeValid = false, safeX = 0, safeZ = 0, safeY = 0,
    cycleToken = 0, _params = nil,
}

function _G.__RivalHubFloat.getHRP()
    local c = localPlayer.Character
    if not c then return nil, nil end
    return c:FindFirstChild("HumanoidRootPart"), c:FindFirstChildOfClass("Humanoid")
end

function _G.__RivalHubFloat.arm()
    if _G.__CrystalAntiDieSource then pcall(_G.__CrystalAntiDieSource, "float", true) end
end
function _G.__RivalHubFloat.release()
    if _G.__CrystalAntiDieSource then pcall(_G.__CrystalAntiDieSource, "float", false) end
end

function _G.__RivalHubFloat.findGround(char, hrp)
    local FLOAT = _G.__RivalHubFloat
    local params = FLOAT._params
    if not params then
        params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.IgnoreWater = true
        pcall(function() params.RespectCanCollide = true end)
        FLOAT._params = params
    end
    local filter = { char }
    local plist = getPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= localPlayer and plr.Character then filter[#filter + 1] = plr.Character end
    end
    local half = hrp.Size.Y * 0.5
    if half <= 0 then half = 1 end
    local origin = hrp.Position
    local startY = origin.Y - half - 0.1
    for _ = 1, 6 do
        params.FilterDescendantsInstances = filter
        local res = Workspace:Raycast(Vector3.new(origin.X, startY, origin.Z), Vector3.new(0, -1000, 0), params)
        if not res then return nil, half end
        local part = res.Instance
        if part and part:IsA("BasePart") and part.CanCollide then
            local model = part:FindFirstAncestorOfClass("Model")
            if not (model and model:FindFirstChildOfClass("Humanoid")) then
                return res.Position.Y, half
            end
        end
        if part then filter[#filter + 1] = part end
        startY = res.Position.Y - 0.05
    end
    return nil, half
end

function _G.__RivalHubFloat.isSafeGround(g)
    local FLOAT = _G.__RivalHubFloat
    if not g then return false end
    if FLOAT.baseGround and g < FLOAT.baseGround - FLOAT.PIT_MARGIN then return false end
    return true
end

function _G.__RivalHubFloat.groundTP()
    local FLOAT = _G.__RivalHubFloat
    local char = localPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    local pos = hrp.Position
    local x, z = pos.X, pos.Z
    local groundY, half
    pcall(function() groundY, half = FLOAT.findGround(char, hrp) end)

    local relocated = false
    if not FLOAT.isSafeGround(groundY) and FLOAT.safeValid then
        x, z, groundY = FLOAT.safeX, FLOAT.safeZ, FLOAT.safeY
        relocated = true
    end

    local targetY
    if groundY then
        half = half or math.max(hrp.Size.Y * 0.5, 1)
        local off = half * 3
        if hum.RigType ~= Enum.HumanoidRigType.R6 then
            off = half + (hum.HipHeight or (half * 2))
        end
        if off ~= off or off < 1 or off > 12 then off = half * 3 end
        targetY = groundY + off + 0.15
    elseif FLOAT.baseY then
        targetY = FLOAT.baseY
    end

    if targetY and targetY == targetY and targetY > -400 then
        pcall(function()
            if not relocated and pos.Y - targetY < 0.5 then
                hrp.AssemblyLinearVelocity = Vector3.zero
                return
            end
            hrp.CFrame = CFrame.new(x, targetY, z) * hrp.CFrame.Rotation
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end

function _G.__RivalHubFloat.startLoop()
    local FLOAT = _G.__RivalHubFloat
    if FLOAT.conn then return end
    FLOAT.locked = false
    FLOAT.targetY = nil

    local char0 = localPlayer.Character
    local root0 = char0 and char0:FindFirstChild("HumanoidRootPart")
    local hum0 = char0 and char0:FindFirstChildOfClass("Humanoid")
    if hum0 then
        pcall(function() hum0:ChangeState(Enum.HumanoidStateType.Freefall) end)
    end

    FLOAT.safeValid = false
    FLOAT.baseGround = nil
    if char0 and root0 then
        local ok, g = pcall(FLOAT.findGround, char0, root0)
        if ok and g then
            FLOAT.baseGround = g
            FLOAT.safeX, FLOAT.safeZ, FLOAT.safeY = root0.Position.X, root0.Position.Z, g
            FLOAT.safeValid = true
        end
    end

    local cChar, cRoot, cHum = nil, nil, nil
    local sampleT = 0
    FLOAT.conn = RunService.Heartbeat:Connect(function(dt)
        local char = localPlayer.Character
        if char ~= cChar or not cRoot or not cRoot.Parent then
            cChar = char
            cRoot = char and char:FindFirstChild("HumanoidRootPart") or nil
            cHum  = char and char:FindFirstChildOfClass("Humanoid") or nil
        end
        if not cRoot or not cHum or cHum.Health <= 0 then return end

        local cf  = cRoot.CFrame
        local pos = cf.Position
        local vel = cRoot.AssemblyLinearVelocity

        sampleT = sampleT + dt
        if sampleT >= FLOAT.SAMPLE then
            sampleT = 0
            local ok, g = pcall(FLOAT.findGround, cChar, cRoot)
            if ok and FLOAT.isSafeGround(g) then
                FLOAT.safeX, FLOAT.safeZ, FLOAT.safeY = pos.X, pos.Z, g
                FLOAT.safeValid = true
            elseif ok and FLOAT.safeValid then
                pos = Vector3.new(FLOAT.safeX, pos.Y, FLOAT.safeZ)
                vel = Vector3.new(0, vel.Y, 0)
            end
        end

        if not FLOAT.targetY then
            FLOAT.baseY   = pos.Y
            FLOAT.targetY = pos.Y + FLOAT.RISE
        end
        local y = FLOAT.targetY
        if not FLOAT.locked then
            y = math.min(pos.Y + FLOAT.RATE * dt, FLOAT.targetY)
            if y >= FLOAT.targetY then FLOAT.locked = true end
        end
        cRoot.CFrame = CFrame.new(pos.X, y, pos.Z) * cf.Rotation
        cRoot.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
    end)
end

function _G.__RivalHubFloat.stopLoop(tpDown)
    local FLOAT = _G.__RivalHubFloat
    if FLOAT.conn then
        pcall(function() FLOAT.conn:Disconnect() end)
        FLOAT.conn = nil
    end
    if tpDown then pcall(FLOAT.groundTP) end
end

function _G.__RivalHubFloat.waitGrounded(timeout)
    local FLOAT = _G.__RivalHubFloat
    local deadline = os.clock() + (timeout or 3)
    while os.clock() < deadline do
        if not FLOAT.running then return end
        local hrp, hum = FLOAT.getHRP()
        if not hrp or not hum then return end
        if hum.Health <= 0 then return end
        if hum.FloorMaterial ~= Enum.Material.Air then
            task.wait(FLOAT.PAUSE)
            return
        end
        RunService.Heartbeat:Wait()
    end
end

function _G.__RivalHubFloat.spawnCycle()
    local FLOAT = _G.__RivalHubFloat
    if FLOAT.thread then pcall(task.cancel, FLOAT.thread); FLOAT.thread = nil end
    FLOAT.cycleToken = FLOAT.cycleToken + 1
    local token = FLOAT.cycleToken
    FLOAT.thread = task.spawn(function()
        while FLOAT.running and FLOAT.cycleToken == token do
            task.wait(FLOAT.CYCLE)
            if not FLOAT.running or FLOAT.cycleToken ~= token then break end
            FLOAT.stopLoop(true)
            FLOAT.waitGrounded(3)
            if not FLOAT.running or FLOAT.cycleToken ~= token then break end
            FLOAT.startLoop()
        end
    end)
end

function _G.__RivalHubFloat.enable()
    local FLOAT = _G.__RivalHubFloat
    if FLOAT.running then return end
    FLOAT.running = true
    FLOAT.arm()
    FLOAT.startLoop()
    FLOAT.spawnCycle()
end

function _G.__RivalHubFloat.disable()
    local FLOAT = _G.__RivalHubFloat
    if not FLOAT.running then return end
    FLOAT.running = false
    FLOAT.cycleToken = FLOAT.cycleToken + 1
    if FLOAT.thread then pcall(task.cancel, FLOAT.thread); FLOAT.thread = nil end
    FLOAT.stopLoop(true)
    FLOAT.safeValid = false
    FLOAT.baseGround = nil
    FLOAT.release()
end

function _G.__RivalHubFloatToggle()
    local F = _G.__RivalHubFloat
    if F.running then F.disable() else F.enable() end
    if _G.__RivalHubFloatSetVisual then pcall(_G.__RivalHubFloatSetVisual, F.running) end
    if mobSetFloat then pcall(mobSetFloat, F.running) end
end

function _G.__RivalHubFloatIsRunning()
    return _G.__RivalHubFloat.running == true
end

do
    local isActive, object, isPlayerRagdolled, hasAnimationalEquipped, findNearbyArmedPlayer, tryHitBatCounterV2
    createMobilePanel = function()
        local oldParents = {game:GetService("CoreGui"), localPlayer:FindFirstChildOfClass("PlayerGui")}
        for _, guiParent in ipairs(oldParents) do
            if guiParent then
                for _, guiName in ipairs({"FictionHubMobilePanel", "TpBatButton", "BatV2Button", "InstaResetButton", "FloatingButtons"}) do
                    local oldGui = guiParent:FindFirstChild(guiName)
                    if oldGui then pcall(function() oldGui:Destroy() end) end
                end
            end
        end
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "FictionHubMobilePanel"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.DisplayOrder = 45
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function()
            if syn and syn.protect_gui then syn.protect_gui(screenGui) end
        end)
        local parentOk = pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
        if not parentOk or not screenGui.Parent then
            screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
        end

        local BTN_SIZE = 55
        local BTN_GAP = 6
        local MARGIN_X = 10
        local MARGIN_Y = 150
        local buttons = {}
        local buttonsData = {
            {name = "TPBat", label = "TP\nBAT", col = 1, row = 1},
            {name = "BatNormal", label = "BAT\nNORMAL", col = 2, row = 1},
            {name = "AutoRight", label = "AUTO\nRIGHT", col = 3, row = 1},
            {name = "BatV2", label = "BAT\nV2", col = 1, row = 2},
            {name = "DropBR", label = "DROP\nBR", col = 2, row = 2},
            {name = "AutoLeft", label = "AUTO\nLEFT", col = 3, row = 2},
            {name = "Reset", label = "RESET", col = 1, row = 3},
            {name = "Float", label = "FLOAT", col = 1, row = 4, positionKey = "RevFloat"},
            {name = "Carry", label = "CARRY\nSPD", col = 2, row = 3},
            {name = "TpDown", label = "TP\nDOWN", col = 3, row = 3},
            {name = "Lagger1", label = "NORMAL\nLAGGER", col = 2, row = 4},
            {name = "Lagger2", label = "CARRY\nLAGGER", col = 3, row = 4},
        }
        local function defaultPosition(col, row)
            local xOffset = -MARGIN_X - ((3 - col) * (BTN_SIZE + BTN_GAP)) - BTN_SIZE
            local yOffset = -MARGIN_Y - ((4 - row) * (BTN_SIZE + BTN_GAP)) - BTN_SIZE
            return UDim2.new(1, xOffset, 1, yOffset)
        end
        local function setVisual(button, state)
            button:SetAttribute("MobActive", state == true)
            paintFloatingBtn(button, state == true)
        end
        local function activateAction(name, setActive, active)
            if name == "Float" then
                if _G.__RivalHubFloatToggle then _G.__RivalHubFloatToggle() end
                setActive(_G.__RivalHubFloatIsRunning and _G.__RivalHubFloatIsRunning() or false)
            elseif name == "TPBat" then
                toggleBatDesyncTp()
                setActive(batDesyncTpEnabled)
            elseif name == "BatNormal" then
                if autoBatEnabled then disableAutoBat() else enableAutoBat() end
                setActive(autoBatEnabled)
                if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end
            elseif name == "BatV2" then
                toggleBatV2()
                setActive(autoBatV2Enabled)
                if autoBatV2SetVisual then autoBatV2SetVisual(autoBatV2Enabled) end
            elseif name == "DropBR" then
                if autoBatEnabled then return end
                setActive(true)
                executeDropWithToggle(function(value)
                    if dropBrainrotSetVisual then dropBrainrotSetVisual(value) end
                end)
                task.delay(0.3, function() setActive(false) end)
            elseif name == "AutoLeft" then
                autoLeftEnabled = not autoLeftEnabled
                setActive(autoLeftEnabled)
                if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
                if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
            elseif name == "AutoRight" then
                autoRightEnabled = not autoRightEnabled
                setActive(autoRightEnabled)
                if autoRightEnabled then startAutoRight() else stopAutoRight() end
                if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
            elseif name == "TpDown" then
                teleportDown()
                setActive(true)
                task.delay(0.2, function() setActive(false) end)
            elseif name == "Reset" then
                setActive(true)
                if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end
                task.delay(0.3, function() setActive(false) end)
            elseif name == "Carry" then
                if not speedMode then
                    speedMode = true
                    laggerToggled = false
                    laggerCarryToggled = false
                    setActive(true)
                    if buttons.Lagger1 then buttons.Lagger1.setActive(false) end
                    if buttons.Lagger2 then buttons.Lagger2.setActive(false) end
                else
                    speedMode = false
                    setActive(false)
                end
                refreshSpeedModeLabel()
            elseif name == "Lagger1" then
                if speedMode then
                    speedMode = false
                    if mobSetCarry then mobSetCarry(false) end
                end
                if not laggerToggled then
                    laggerToggled = true
                    laggerCarryToggled = false
                    setActive(true)
                    if buttons.Lagger2 then buttons.Lagger2.setActive(false) end
                else
                    laggerToggled = false
                    setActive(false)
                end
                refreshSpeedModeLabel()
            elseif name == "Lagger2" then
                if speedMode then
                    speedMode = false
                    if mobSetCarry then mobSetCarry(false) end
                end
                if not laggerCarryToggled then
                    laggerCarryToggled = true
                    laggerToggled = false
                    setActive(true)
                    if buttons.Lagger1 then buttons.Lagger1.setActive(false) end
                else
                    laggerCarryToggled = false
                    setActive(false)
                end
                refreshSpeedModeLabel()
            end
        end

        for _, data in ipairs(buttonsData) do
            local button = Instance.new("TextButton")
            button.Name = data.name
            button.Size = UDim2.fromOffset(BTN_SIZE, BTN_SIZE)
            button.Position = defaultPosition(data.col, data.row)
            local positionKey = data.positionKey or data.name
            local saved = savedButtonPositions and savedButtonPositions[positionKey]
            if saved and saved.XScale ~= nil and saved.YScale ~= nil then
                button.Position = UDim2.new(saved.XScale, saved.X or saved.XOffset or 0, saved.YScale, saved.Y or saved.YOffset or 0)
            end
            button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            button.BorderSizePixel = 0
            button.Text = ""
            button.AutoButtonColor = false
            button.Active = true
            button.ZIndex = 45
            button.Parent = screenGui
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 16)
            local gradient = Instance.new("UIGradient", button)
            gradient.Name = "BtnGrad"
            gradient.Rotation = 0
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 10)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(75, 75, 75)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 10)),
            })
            local stroke = Instance.new("UIStroke", button)
            stroke.Name = "NormalStroke"
            stroke.Color = Color3.fromRGB(60, 60, 60)
            stroke.Thickness = 2
            stroke.Transparency = 0
            local label = Instance.new("TextLabel")
            label.Name = "TextLabel"
            label.Size = UDim2.fromScale(1, 1)
            label.BackgroundTransparency = 1
            label.Text = data.label
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.Font = Enum.Font.GothamBold
            label.TextSize = 10
            label.TextXAlignment = Enum.TextXAlignment.Center
            label.TextYAlignment = Enum.TextYAlignment.Center
            label.ZIndex = 46
            label.Parent = button
            local uiScale = Instance.new("UIScale", button)
            uiScale.Scale = floatingButtonScale
            table.insert(_floatingUIScales, uiScale)

            local active = false
            local function setActive(state)
                active = state == true
                setVisual(button, active)
            end
            setActive(false)
            buttons[data.name] = {btn = button, setActive = setActive, label = label}

            local dragging = false
            local moved = false
            local startPoint
            local startPosition
            button.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    moved = false
                    startPoint = input.Position
                    startPosition = button.Position
                    _isDraggingButton = true
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if not dragging then return end
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    local delta = input.Position - startPoint
                    if delta.Magnitude > 5 and editModeEnabled and not uiLocked then
                        moved = true
                        button.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
                    end
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if not dragging then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if not moved then
                        activateAction(data.name, setActive, active)
                    elseif editModeEnabled and not uiLocked then
                        savedButtonPositions[positionKey] = {
                            X = button.Position.X.Offset,
                            Y = button.Position.Y.Offset,
                            XScale = button.Position.X.Scale,
                            YScale = button.Position.Y.Scale,
                        }
                        pcall(saveAllSettings)
                    end
                    dragging = false
                    moved = false
                    startPoint = nil
                    startPosition = nil
                    _isDraggingButton = false
                end
            end)
        end

        buttons.AutoBat = buttons.BatNormal
        buttons.InstaReset = buttons.Reset
        mobSetAutoBat = buttons.BatNormal and buttons.BatNormal.setActive
        mobSetAutoLeft = buttons.AutoLeft and buttons.AutoLeft.setActive
        mobSetAutoRight = buttons.AutoRight and buttons.AutoRight.setActive
        mobSetDropBR = buttons.DropBR and buttons.DropBR.setActive
        mobSetTpDown = buttons.TpDown and buttons.TpDown.setActive
        mobSetCarry = buttons.Carry and buttons.Carry.setActive
        mobSetLagger1 = buttons.Lagger1 and buttons.Lagger1.setActive
        mobSetLagger2 = buttons.Lagger2 and buttons.Lagger2.setActive
        mobSetFloat = buttons.Float and buttons.Float.setActive
        batDesyncTpSetVisual = buttons.TPBat and buttons.TPBat.setActive
        tpBatFloatingButton = buttons.TPBat and buttons.TPBat.btn
        batV2FloatingButton = buttons.BatV2 and buttons.BatV2.btn
        instaResetFloatingButton = buttons.Reset and buttons.Reset.btn
        if buttons.BatNormal then buttons.BatNormal.setActive(autoBatEnabled) end
        if buttons.AutoLeft then buttons.AutoLeft.setActive(autoLeftEnabled) end
        if buttons.AutoRight then buttons.AutoRight.setActive(autoRightEnabled) end
        if buttons.BatV2 then buttons.BatV2.setActive(autoBatV2Enabled) end
        if buttons.TPBat then buttons.TPBat.setActive(batDesyncTpEnabled) end
        if buttons.Carry then buttons.Carry.setActive(speedMode) end
        if buttons.Lagger1 then buttons.Lagger1.setActive(laggerToggled) end
        if buttons.Lagger2 then buttons.Lagger2.setActive(laggerCarryToggled) end
        if buttons.Float then
            buttons.Float.setActive(_G.__RivalHubFloatIsRunning and _G.__RivalHubFloatIsRunning() or false)
        end
        _G.AmbitiousApplyMobileButtonsHidden()
        return screenGui
    end
    batCounterV2Enabled = false
    batCounterV2Debounce = false
    batCounterV2Conn = nil
    batCounterV2HitCooldown = false
    BAT_COUNTER_V2_SWING_CD = 0.08
    setBatCounterV2Visual = nil
    isActive = false
    object = 0
    isPlayerRagdolled = function(player)
        if not player or not player.Character then
            return false
        end
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            return false
        end
        local state = humanoid:GetState()
        return state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
    end
    hasAnimationalEquipped = function(player)
        if not player or not player.Character then
            return false
        end
        for _, child in ipairs(player.Character:GetChildren()) do
            if child:IsA("Tool") then
                if child:FindFirstChild("Handle") or child.Name:find("Animal") or child.Name:find("Pet") then
                    return true
                end
            end
        end
        return false
    end
    findNearbyArmedPlayer = function()
        local character = localPlayer.Character
        if not character then
            return nil
        end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil
        end
        local object = huge
        local object2607 = nil
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                if hasAnimationalEquipped(player) then
                    local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoidRootPart2 and humanoid and humanoid.Health > 0 then
                        local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude
                        if magnitude < 12 and magnitude < object then
                            object = magnitude
                            object2607 = player
                        end
                    end
                end
            end
        end
        return object2607
    end
    do
        local function getBatV2Counter()
            local character = localPlayer.Character
            if not character then
                return nil
            end
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Tool") then
                    local name = child.Name:lower()
                    if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then
                        return child
                    end
                end
            end
            local backpack = localPlayer:FindFirstChild("Backpack")
            if backpack then
                for _, child in ipairs(backpack:GetChildren()) do
                    if child:IsA("Tool") then
                        local name = child.Name:lower()
                        if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then
                            child.Parent = character
                            return child
                        end
                    end
                end
            end
            if backpack then
                for _, child in ipairs(backpack:GetChildren()) do
                    if child:IsA("Tool") then
                        child.Parent = character
                        return child
                    end
                end
            end
            return nil
        end
        tryHitBatCounterV2 = function()
            if batCounterV2HitCooldown then
                return
            end
            batCounterV2HitCooldown = true
            pcall(function()
                local bat = getBatV2Counter()
                if bat then
                    bat:Activate()
                    local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")
                    if remoteEvent then
                        remoteEvent:FireServer()
                    end
                end
            end)
            task.delay(BAT_COUNTER_V2_SWING_CD, function()
                batCounterV2HitCooldown = false
            end)
        end
    end
    do
        local function executeBatCounterV2()
            local now = getTime()
            if now - object < 0.01 then
                return
            end
            if batCounterV2Debounce then
                return
            end
            batCounterV2Debounce = true
            object = now
            local attacker = findNearbyArmedPlayer()
            if not attacker then
                batCounterV2Debounce = false
                return
            end
            if isPlayerRagdolled(attacker) then
                batCounterV2Debounce = false
                return
            end
            if not hasAnimationalEquipped(attacker) then
                batCounterV2Debounce = false
                return
            end
            isActive = batDesyncTpEnabled
            if not batDesyncTpEnabled then
                startBatDesyncTp()
                if batDesyncTpSetVisual then
                    batDesyncTpSetVisual(true)
                end
            end
            local function doCounterHit()
                local character = localPlayer.Character
                if not character then
                    return
                end
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then
                    return
                end
                local character2 = attacker.Character
                if not character2 then
                    return
                end
                local humanoidRootPart2 = character2:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart2 then
                    return
                end
                if not hasAnimationalEquipped(attacker) then
                    batCounterV2Debounce = false
                    return
                end
                if sethiddenproperty then
                    sethiddenproperty(humanoidRootPart, "PhysicsRepRootPart", humanoidRootPart2)
                end
                local targetPosition = humanoidRootPart2.Position + newVector3(0, 2.5, 0)
                if (humanoidRootPart.Position - targetPosition).Magnitude > 8 then
                    humanoidRootPart.CFrame = newCFrame(targetPosition)
                end
                tryHitBatCounterV2()
                task.delay(0.05, function()
                    tryHitBatCounterV2()
                end)
                task.delay(0.1, function()
                    tryHitBatCounterV2()
                end)
            end
            doCounterHit()
            task.delay(0.2, function()
                if not isActive and batDesyncTpEnabled then
                    stopBatDesyncTp()
                    if batDesyncTpSetVisual then
                        batDesyncTpSetVisual(false)
                    end
                end
                batCounterV2Debounce = false
            end)
        end
        stopBatCounterV2 = function()
            if batCounterV2Conn then
                batCounterV2Conn:Disconnect()
                batCounterV2Conn = nil
            end
            batCounterV2Debounce = false
            batCounterV2HitCooldown = false
        end
        startBatCounterV2 = function()
            if batCounterV2Conn then
                return
            end
            batCounterV2Conn = RunService.Heartbeat:Connect(function()
                if not batCounterV2Enabled then
                    return
                end
                if batCounterV2Debounce then
                    return
                end
                local character = localPlayer.Character
                if not character then
                    return
                end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoid or humanoid.Health <= 0 then
                    return
                end
                local state = humanoid:GetState()
                if
                    state == Enum.HumanoidStateType.Physics
                    or state == Enum.HumanoidStateType.Ragdoll
                    or state == Enum.HumanoidStateType.FallingDown
                    or state == Enum.HumanoidStateType.GettingUp
                    or state == Enum.HumanoidStateType.Stunned
                then
                    local object = findNearbyArmedPlayer()
                    if object then
                        if not isPlayerRagdolled(object) then
                            if hasAnimationalEquipped(object) then
                                executeBatCounterV2()
                            end
                        end
                    end
                end
            end)
        end
    end
end
toggleBatCounterV2 = function()
    batCounterV2Enabled = not batCounterV2Enabled
    if batCounterV2Enabled then
        startBatCounterV2()
    else
        stopBatCounterV2()
    end
    return batCounterV2Enabled
end
updateUIFromLoaded = function()
    task.wait()
    if normalBox then
        normalBox.Text = tostring(NS)
    end
    if carryBox then
        carryBox.Text = tostring(CS)
    end
    if radInput then
        radInput.Text = tostring(CONFIG.STEAL_RANGE)
    end
    if laggerBox then
        laggerBox.Text = tostring(LAGGER_SPEED)
    end
    if lagger2Box then
        lagger2Box.Text = tostring(LAGGER_CARRY_SPEED)
    end
    if batSpeedBox then
        batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED)
    end
    if uiScaleBox then
        uiScaleBox.Text = tostring(uiScaleValue)
    end
    if dropModeBtnRef then
        dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop"
    end
    if bodyLockRangeBox then
        bodyLockRangeBox.Text = tostring(bodyLockRange)
    end
    if carrySysNormalBox then
        carrySysNormalBox.Text = tostring(carryController.normalSpeed)
    end
    if carrySysCarryBox then
        carrySysCarryBox.Text = tostring(carryController.carrySpeed)
    end
    if carrySysLaggerBox then
        carrySysLaggerBox.Text = tostring(carryController.laggerSpeed)
    end
    if carrySysLaggerCarryBox then
        carrySysLaggerCarryBox.Text = tostring(carryController.laggerCarrySpeed)
    end
    if carrySysSoftStealSpeedBox then
        carrySysSoftStealSpeedBox.Text = tostring(carryController.softStealSpeed)
    end
    if carrySysSoftStealRadiusBox then
        carrySysSoftStealRadiusBox.Text = tostring(carryController.softStealRadius)
    end
    if carrySystemToggleSetter then
        carrySystemToggleSetter(useCarrySystem)
    end
    if autoStealVariantLabel then
        autoStealVariantLabel.Text = getAutoStealVariantName(autoStealVariant or 1)
    end
    refreshSpeedModeLabel()
    if infJumpSetVisual then
        infJumpSetVisual(infJumpEnabled)
    end
    if infJumpModeSetVisual then
        infJumpModeSetVisual.Text = infJumpMode
    end
    if mirrorTPDownSetVisual then
        mirrorTPDownSetVisual(mirrorTPDownEnabled)
    end
    if setSafeModeVisual then
        setSafeModeVisual(antiKickEnabled)
    end
    if setNoPlayerCollisionVisual then
        setNoPlayerCollisionVisual(noPlayerCollisionEnabled)
    end
    if setNoCamCollisionVisual then
        setNoCamCollisionVisual(noCamCollisionEnabled)
    end
    for _, entry2522 in ipairs(keyButtonRefs) do
        local entry = entry2522.entry
        entry2522.btn.Text = entry.gp and entry.gp.Name or entry.kb and entry.kb.Name or "None"
    end
    if savedProgressBarPos and pbFrame then
        pbFrame.Position = UDim2.new(
            savedProgressBarPos.XScale or 0.5,
            savedProgressBarPos.XOffset or -100,
            savedProgressBarPos.YScale or 1,
            savedProgressBarPos.YOffset or -60
        )
    end
    applyFloatingButtonScale()
    if uiLocked and setLockUIVisual then
        setLockUIVisual(true)
    end
    if editModeEnabled and setEditModeVisual then
        setEditModeVisual(true)
    end
    if _G.updateAntiRagdollUI then
        _G.updateAntiRagdollUI(antiRagdollMode)
    end
    if antiRagdollMode == "v1" then
        antiRagdollController.start()
    elseif antiRagdollMode == "v2" then
        enableAntiRagdollV2()
    end
    if antiDieEnabled then
        if setAntiDieVisual then
            setAntiDieVisual(true)
        end
        antiDie.start()
    elseif setAntiDieVisual then
        setAntiDieVisual(false)
    end
    if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then
        setInstaGrab(true)
        pcall(startAutoSteal)
    end
    if medusaCounterEnabled then
        if setMedusaVisual then
            setMedusaVisual(true)
        end
        if localPlayer.Character then
            setupMedusaCounter(localPlayer.Character)
        end
    else
        if setMedusaVisual then
            setMedusaVisual(false)
        end
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
        task.spawn(function()
            task.wait(0.5)
            startUnwalk()
        end)
    end
    if antiLagEnabled then
        if setAntiLagVisual then
            setAntiLagVisual(true)
        end
        enableAntiLag()
    else
        if setAntiLagVisual then
            setAntiLagVisual(false)
        end
        disableAntiLag()
    end
    if espEnabled then
        toggleESP(true)
        if setESPVIsual then
            setESPVIsual(true)
        end
    else
        toggleESP(false)
        if setESPVIsual then
            setESPVIsual(false)
        end
    end
    if batDesyncTpEnabled then
        if batDesyncTpSetVisual then
            batDesyncTpSetVisual(true)
        end
        if not _G.AlvaroTP.on then
            startBatDesyncTp()
        end
        updateTpBatButtonWithAntiDie(true)
    else
        if batDesyncTpSetVisual then
            batDesyncTpSetVisual(false)
        end
        updateTpBatButtonWithAntiDie(false)
    end
    if autoBatV2Enabled then
        if autoBatV2SetVisual then
            autoBatV2SetVisual(true)
        end
        if batV2FloatingButton then
            local frame = batV2FloatingButton
            if frame then
                paintFloatingBtn(frame, true)
            end
        end
    else
        if autoBatV2SetVisual then
            autoBatV2SetVisual(false)
        end
        if batV2FloatingButton then
            local frame = batV2FloatingButton
            if frame then
                paintFloatingBtn(frame, false)
            end
        end
    end
    if neonWeatherEnabled then
        applyNeonWeather()
        if setNeonWeatherVisual then
            setNeonWeatherVisual(true)
        end
    else
        restoreLightingState()
        if setNeonWeatherVisual then
            setNeonWeatherVisual(false)
        end
    end
    if stretchEnabled then
        enableStretch()
        if _G.stretchToggleSetter then
            _G.stretchToggleSetter(true)
        end
    elseif _G.stretchToggleSetter then
        _G.stretchToggleSetter(false)
    end
    if setFovVisual then
        setFovVisual(fovEnabled)
    end
    if fovSliderSet then
        fovSliderSet(fovValue)
    end
    if mobSetAutoBat then
        mobSetAutoBat(autoBatEnabled)
    end
    if mobSetAutoLeft then
        mobSetAutoLeft(autoLeftEnabled)
    end
    if mobSetAutoRight then
        mobSetAutoRight(autoRightEnabled)
    end
    if mobSetCarry then
        mobSetCarry(speedMode)
    end
    if mobSetLagger1 then
        mobSetLagger1(laggerToggled)
    end
    if mobSetLagger2 then
        mobSetLagger2(laggerCarryToggled)
    end
    if bodyLockEnabled and bodyLockSetVisual then
        if _blSuppressCount == 0 then
            bodyLockSetVisual(true)
            startBodyLock()
        else
            bodyLockSetVisual(false)
        end
    end
    if customTool3DSkinCards.Bat then
        customTool3DSkinCards.Bat.setEnabled(bat3DSkinEnabled)
        customTool3DSkinCards.Bat.setSkin(customBat3DSkin)
    end
    if customTool3DSkinCards.Medusa then
        customTool3DSkinCards.Medusa.setEnabled(medusa3DSkinEnabled)
        customTool3DSkinCards.Medusa.setSkin(customMedusa3DSkin)
    end
    if setCustomSoundsVisual then setCustomSoundsVisual(customSoundsEnabled == true) end
    if setRainbowToolsVisual then setRainbowToolsVisual(rainbowToolsEnabled == true) end
    pcall(refreshCustomTool3DSkins)
    updateProgressBarVisibility()
    startEnemySpeed()
    toggleLockUI(uiLocked)
    pcall(function()
        applyOutfitByIndex(currentOutfitIndex)
    end)
    if outfitSelectorLabel then
        outfitSelectorLabel.Text = outfits[currentOutfitIndex].label
    end
    if backgroundImage then
        applyBackground(backgroundIndex)
    end
    if contentPages and contentPages.Visual then
        for _, child in ipairs(contentPages.Visual:GetChildren()) do
            if child:IsA("Frame") and child:FindFirstChild("BackgroundPreview") then
                local backgroundPreview = child.BackgroundPreview
                local previewImage = backgroundPreview:FindFirstChild("PreviewImage")
                local previewPlaceholder = backgroundPreview:FindFirstChild("PreviewPlaceholder")
                local object = BACKGROUND_IMAGES[backgroundIndex]
                if previewImage then
                    if object and object.id and object.id ~= "" then
                        previewImage.Image = object.id
                        if previewPlaceholder then
                            previewPlaceholder.Visible = false
                        end
                    else
                        previewImage.Image = ""
                        if previewPlaceholder then
                            previewPlaceholder.Visible = true
                        end
                    end
                end
                break
            end
        end
    end
    if MobilePanel and savedButtonPositions then
        for _, button in ipairs(MobilePanel:GetChildren()) do
            if button:IsA("TextButton") then
                local positionKey = button.Name == "Float" and "RevFloat" or button.Name
                local vector = savedButtonPositions[positionKey]
                if vector and vector.XScale ~= nil and vector.YScale ~= nil then
                    button.Position = UDim2.new(vector.XScale, vector.X or vector.XOffset or 0, vector.YScale, vector.Y or vector.YOffset or 0)
                end
            end
        end
    end
    pcall(function() RH_Style.refresh(gui, getThemeColor(), "MK") end)
end
CleanHubAutoTPDown = false
CleanHubAutoTPDownHeight = 20
CleanHubShowE01Warning = false
CleanHubAutoTPLastAt = 0
CleanHubE01StartedAt = nil
CleanHubE01Gui = nil
RunService.Heartbeat:Connect(function()
    if not CleanHubAutoTPDown then
        return
    end
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    character = character and character:FindFirstChildOfClass("Humanoid")
    local shouldTeleportDown = rootPart
        and character
        and character.FloorMaterial == Enum.Material.Air
        and rootPart.Position.Y >= CleanHubAutoTPDownHeight
    if shouldTeleportDown then
        local lastTeleportTime = CleanHubAutoTPLastAt
        shouldTeleportDown = tick() - lastTeleportTime >= 0.35
    end
    if shouldTeleportDown then
        CleanHubAutoTPLastAt = tick()
        teleportDown()
    end
end)
do
    local function isCarryingTarget()
        local character = localPlayer.Character
        if not character then
            return false
        end
        for _, child in ipairs(character:GetChildren()) do
            local lowercaseText = child.Name:lower()
            if
                lowercaseText:find("brain", 1, true)
                or lowercaseText:find("animal", 1, true)
                or lowercaseText:find("carry", 1, true)
                or lowercaseText:find("steal", 1, true)
            then
                return true
            end
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        return humanoid and humanoid.WalkSpeed > 0 and humanoid.WalkSpeed <= 25 and humanoid.WalkSpeed ~= 16
    end
    RunService.Heartbeat:Connect(function()
        if not CleanHubShowE01Warning or not isCarryingTarget() then
            if CleanHubE01Gui then
                CleanHubE01Gui.Enabled = false
            end
            CleanHubE01StartedAt = nil
            return
        end
        CleanHubE01StartedAt = CleanHubE01StartedAt or tick()
        local object = CleanHubE01StartedAt
        local value = math.clamp((tick() - object) / 2.6, 0, 1)
        if not CleanHubE01Gui then
            CleanHubE01Gui = Instance.new("ScreenGui")
            CleanHubE01Gui.Name = "CleanHubE01Warning"
            CleanHubE01Gui.ResetOnSpawn = false
            CleanHubE01Gui.IgnoreGuiInset = true
            CleanHubE01Gui.Parent = localPlayer:WaitForChild("PlayerGui")
            local frame = Instance.new("Frame", CleanHubE01Gui)
            frame.Name = "Bar"
            frame.AnchorPoint = Vector2.new(0.5, 0)
            frame.Position = UDim2.new(0.5, 0, 0, 18)
            frame.Size = UDim2.new(0, 300, 0, 36)
            frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            frame.BackgroundTransparency = 0.34
            frame.BorderSizePixel = 0
            frame.ClipsDescendants = true
            Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
            local rootPart = Instance.new("Frame", frame)
            rootPart.Name = "Track"
            rootPart.Position = UDim2.new(0, 3, 0, 3)
            rootPart.Size = UDim2.new(1, -6, 1, -6)
            rootPart.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            rootPart.BackgroundTransparency = 0.48
            rootPart.BorderSizePixel = 0
            rootPart.ClipsDescendants = true
            Instance.new("UICorner", rootPart).CornerRadius = UDim.new(1, 0)
            local frame2558 = Instance.new("Frame", rootPart)
            frame2558.Name = "Fill"
            frame2558.Size = UDim2.new(0, 0, 1, 0)
            frame2558.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
            frame2558.BackgroundTransparency = 0.48
            frame2558.BorderSizePixel = 0
            Instance.new("UICorner", frame2558).CornerRadius = UDim.new(1, 0)
            local textLabel = Instance.new("TextLabel", frame)
            textLabel.Name = "Label"
            textLabel.Size = UDim2.new(1, -16, 1, 0)
            textLabel.Position = UDim2.new(0, 8, 0, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Font = Enum.Font.GothamBlack
            textLabel.TextSize = 14
            textLabel.TextStrokeTransparency = 0.18
            textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            textLabel.ZIndex = 2
        end
        CleanHubE01Gui.Enabled = true
        local warningReady = value >= 1
        CleanHubE01Gui.Bar.Label.Text = warningReady and "STEAL" or "DONT STEAL"
        CleanHubE01Gui.Bar.Label.TextColor3 = warningReady and Color3.fromRGB(85, 255, 125)
            or Color3.fromRGB(85, 75, 85)
        CleanHubE01Gui.Bar.Track.Fill.Size = UDim2.new(value, 0, 1, 0)
    end)
end
local function createRevHubMusicPlayer(hostGui)
-- ============================================================
--  🎵 SUREHUB VIDEOGRABADORA V6 🎵
--  Tema negro - Sin imagen de fondo
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer

-- ============================================================
--  CANCIONES
-- ============================================================
local songs = {
    { title = "Doble presión Babyloc",            url = "https://files.catbox.moe/8pitzi.mp3", file = "surehub_doblepresion.mp3", soundName = "Surehub_DoblePresion" },
    { title = "Nadie Ta frío Laja",               url = "https://files.catbox.moe/ecc674.mp3", file = "surehub_nadietafrio.mp3", soundName = "Surehub_NadieTaFrio" },
    { title = "Otra amiga laja",                  url = "https://files.catbox.moe/l0qu4g.mp3",  file = "surehub_otraamiga.mp3",   soundName = "Surehub_OtraAmiga" },
    { title = "Cuántos Gramos Laja X Hades66",    url = "https://files.catbox.moe/uyapzl.mp3", file = "surehub_cuantosgramos.mp3", soundName = "Surehub_CuantosGramos" },
    { title = "Playa Babylocc",                   url = "https://files.catbox.moe/lb93h5.mp3", file = "surehub_playa.mp3",       soundName = "Surehub_Playa" },
    { title = "Moonlight XXXTENTACION",           url = "https://file.garden/amx-it5EVlEYRoDf/XXXTENTACION%20-%20MOONLIGHT%20(OFFICIAL%20MUSIC%20VIDEO).mp3", file = "surehub_moonlight.mp3", soundName = "Surehub_Moonlight" },
    { title = "Nevada YoungBoy",                  url = "https://files.catbox.moe/ysko1d.mp3", file = "surehub_nevada.mp3",      soundName = "Surehub_Nevada" },
    { title = "Make No Sense YoungBoy",           url = "https://file.garden/amx-it5EVlEYRoDf/YoungBoy%20Never%20Broke%20Again%20-%20Make%20No%20Sense%20%5BOfficial%20Music%20Video%5D.mp3", file = "surehub_makenosense.mp3", soundName = "Surehub_MakeNoSense" },
    { title = "Alaska Victor Mendivil y Hades66", url = "https://files.catbox.moe/1x4aqg.mp3", file = "surehub_alaska.mp3",      soundName = "Surehub_Alaska" },
    { title = "NIGHT AFTER NIGHT BABYLOCC",       url = "https://files.catbox.moe/wodxeu.mp3", file = "surehub_nightafternight.mp3", soundName = "Surehub_NightAfterNight" },
    { title = "LAGUNAS — Peso Pluma, Jasiel Nuñez", url = "https://file.garden/algLafWA1jk8WMfK/LAGUNAS_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_01_Lagunas.mp3", soundName = "RevHubBless01LAGUNAS" },
    { title = "Misery Slowed + Reverb — A7AX", url = "https://file.garden/algLafWA1jk8WMfK/Misery%20-%20Remix%20Slowed%2BReverb_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_02_Misery.mp3", soundName = "RevHubBless02MiserySlowedReverb" },
    { title = "Tusa — KAROL G, Nicki Minaj", url = "https://file.garden/algLafWA1jk8WMfK/Tusa_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_03_Tusa.mp3", soundName = "RevHubBless03Tusa" },
    { title = "Orula — Victor Mendivil", url = "https://files.catbox.moe/v20ko9.mp3", file = "revhub_bless_FearHubJukebox_04_Orula.mp3", soundName = "RevHubBless04Orula" },
    { title = "X.O.X.O — Pedro Calderón, D' La Crem", url = "https://files.catbox.moe/jghp0f.mp3", file = "revhub_bless_M4LWAREJukebox_05_XOXO.mp3", soundName = "RevHubBless05XOXO" },
    { title = "Beretta — El De Las R's", url = "https://file.garden/algLafWA1jk8WMfK/Beretta%20-%20video%20oficial(MP3_160K).mp3", file = "revhub_bless_FearHubJukebox_06_Beretta.mp3", soundName = "RevHubBless06Beretta", startAt = 11 },
    { title = "Took Her To The O — King Von", url = "https://file.garden/algLafWA1jk8WMfK/King%20Von%20-%20Took%20Her%20To%20The%20O%20(Lyrics)(MP3_160K).mp3", file = "revhub_bless_FearHubJukebox_07_TookHerToTheO.mp3", soundName = "RevHubBless07TookHerToTheO" },
    { title = "LAJA - NADIE TA FRIO — LAJA", url = "https://file.garden/algLafWA1jk8WMfK/LAJA%20-%20NADIE%20TA%20FRIO%20(Letra)(MP3_160K).mp3", file = "revhub_bless_FearHubJukebox_08_Laja.mp3", soundName = "RevHubBless08LAJANADIETAFRIO" },
    { title = "HORA CERO — Myke Towers", url = "https://file.garden/algLafWA1jk8WMfK/Myke%20Towers%20-%20HORA%20CERO%20(Lyrics)(MP3_160K).mp3", file = "revhub_bless_FearHubJukebox_09_HoraCero.mp3", soundName = "RevHubBless09HORACERO" },
    { title = "Bling Bling — Grupo Marca Registrada, Octavio Cuadras", url = "https://file.garden/algLafWA1jk8WMfK/Bling%20Bling_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_10_BlingBling.mp3", soundName = "RevHubBless10BlingBling" },
    { title = "Lucid Dreams (Clean) — Juice WRLD", url = "https://file.garden/algLafWA1jk8WMfK/Lucid%20Dreams%20-%20Clean%20-%20Juice%20WRLD(MP3_160K).mp3", file = "revhub_bless_FearHubJukebox_11_LucidDreams.mp3", soundName = "RevHubBless11LucidDreamsClean" },
    { title = "Un Pacto — Victor Mendivil, El Padrinito Toys", url = "https://file.garden/algLafWA1jk8WMfK/Un%20Pacto_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_12_UnPacto.mp3", soundName = "RevHubBless12UnPacto" },
    { title = "La diabla — Xavi", url = "https://file.garden/algLafWA1jk8WMfK/La%20Diabla_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_13_LaDiabla.mp3", soundName = "RevHubBless13Ladiabla" },
    { title = "Kamikaze — Natanael Cano, Uriel Gaxiola, Ganggy, Victor Mendivil", url = "https://file.garden/algLafWA1jk8WMfK/Kamikaze%20(feat.%20Victor%20Mendivil)_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_14_Kamikaze.mp3", soundName = "RevHubBless14Kamikaze" },
    { title = "Triple lavada — Esau Ortiz, Luis R Conriquez, Oscar Maydon, Alemán, Victor Mendivil", url = "https://file.garden/algLafWA1jk8WMfK/Triple%20Lavada%20%28feat.%20Victor%20Mendivil%29%20-%20Remix_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_15_TripleLavada_v3.mp3", soundName = "RevHubBless15Triplelavada" },
    { title = "Dopamina — Peso Pluma, Tito Double P", url = "https://file.garden/algLafWA1jk8WMfK/dopamina_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_16_Dopamina.mp3", soundName = "RevHubBless16Dopamina" },
    { title = "You — Tiagz, Victor Mendivil", url = "https://file.garden/algLafWA1jk8WMfK/You_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_17_You.mp3", soundName = "RevHubBless17You" },
    { title = "PRESIDENTE — Gabito Ballesteros, Natanael Cano, Luis R Conriquez, Neton Vega", url = "https://file.garden/algLafWA1jk8WMfK/PRESIDENTE_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_18_Presidente.mp3", soundName = "RevHubBless18PRESIDENTE" },
    { title = "El Drip — Natanael Cano", url = "https://file.garden/algLafWA1jk8WMfK/El%20Drip_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_19_ElDrip.mp3", soundName = "RevHubBless19ElDrip" },
    { title = "Por Mi Zona — La Santa Grifa", url = "https://file.garden/algLafWA1jk8WMfK/Por%20Mi%20Zona_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_20_PorMiZona.mp3", soundName = "RevHubBless20PorMiZona" },
    { title = "Cachondos Session #1 — Kevin AMF, Victor Mendivil, Dani Flow, Sebastian Esquivel, Eugenio Esquivel, Tiagz, Los Esquivel", url = "https://file.garden/algLafWA1jk8WMfK/Cachondos%20Session%20%231%20(feat.%20Sebastian%20Esquivel%2C%20Eugenio%20Esquivel%2C%20Tiagz%20%26%20Los%20Esquivel)_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_21_CachondosSession1.mp3", soundName = "RevHubBless21CachondosSession1" },
    { title = "Jacobo Grinberg — Victor Mendivil", url = "https://file.garden/algLafWA1jk8WMfK/Jacobo%20Grinberg_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_22_JacoboGrinberg.mp3", soundName = "RevHubBless22JacoboGrinberg" },
    { title = "Punta Cana — Victor Mendivil, Kevin AMF", url = "https://file.garden/algLafWA1jk8WMfK/Punta%20Cana_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_23_PuntaCana.mp3", soundName = "RevHubBless23PuntaCana" },
    { title = "King of Watches — Omar Camacho", url = "https://file.garden/algLafWA1jk8WMfK/King%20of%20Watches_spotdown.org%202.mp3", file = "revhub_bless_FearHubJukebox_24_KingOfWatchesOmar.mp3", soundName = "RevHubBless24KingofWatches" },
    { title = "King of Watches — Victor Mendivil, Neton Vega", url = "https://file.garden/algLafWA1jk8WMfK/King%20of%20Watches_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_31_KingOfWatchesVictor.mp3", soundName = "RevHubBless25KingofWatches" },
    { title = "Don Dimadon — Remp, Oscar Maydon, Victor Mendivil, Sintapia", url = "https://file.garden/algLafWA1jk8WMfK/Don%20Dimadon_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_25_DonDimadon.mp3", soundName = "RevHubBless26DonDimadon" },
    { title = "Singapur (Remix) — El Alfa, Chencho Corleone, Farruko, Justin Quiles, Myke Towers", url = "https://file.garden/algLafWA1jk8WMfK/Singapur%20(Remix)_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_26_SingapurRemix.mp3", soundName = "RevHubBless27SingapurRemix" },
    { title = "Without Me — Eminem", url = "https://file.garden/algLafWA1jk8WMfK/Without%20Me_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_27_WithoutMe.mp3", soundName = "RevHubBless28WithoutMe" },
    { title = "3 AM — Jimmy Guzman, Omar Camacho", url = "https://file.garden/algLafWA1jk8WMfK/3%20AM_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_28_3AM.mp3", soundName = "RevHubBless293AM" },
    { title = "STARGAZING — Travis Scott", url = "https://file.garden/algLafWA1jk8WMfK/STARGAZING_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_29_Stargazing.mp3", soundName = "RevHubBless30STARGAZING" },
    { title = "Gané — Victor Mendivil, Gabito Ballesteros", url = "https://file.garden/algLafWA1jk8WMfK/Gane%CC%81_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_30_Gane.mp3", soundName = "RevHubBless31Gan" },
    { title = "Te Lo Doy — Tiagz, El Malilla, El Bogueto", url = "https://file.garden/algLafWA1jk8WMfK/Te%20Lo%20Doy_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_32_TeLoDoy.mp3", soundName = "RevHubBless32TeLoDoy" },
    { title = "Gramos — Jimmy Guzman", url = "https://file.garden/algLafWA1jk8WMfK/Gramos_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_33_Gramos.mp3", soundName = "RevHubBless33Gramos" },
    { title = "GOET — Victor Mendivil", url = "https://file.garden/algLafWA1jk8WMfK/GOET_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_34_GOET.mp3", soundName = "RevHubBless34GOET" },
    { title = "Mercenarios — Capo, Victor Mendivil", url = "https://file.garden/algLafWA1jk8WMfK/Mercenarios_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_35_Mercenarios.mp3", soundName = "RevHubBless35Mercenarios" },
    { title = "Emparejé — Russo, Luis R Conriquez", url = "https://file.garden/algLafWA1jk8WMfK/Empareje%CC%81_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_36_Empareje.mp3", soundName = "RevHubBless36Emparej" },
    { title = "squabble up — Kendrick Lamar", url = "https://file.garden/algLafWA1jk8WMfK/squabble%20up_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_37_SquabbleUp.mp3", soundName = "RevHubBless37squabbleup" },
    { title = "ROSA PASTEL — Peso Pluma, Jasiel Nuñez", url = "https://file.garden/algLafWA1jk8WMfK/ROSA%20PASTEL_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_38_RosaPastel.mp3", soundName = "RevHubBless38ROSAPASTEL" },
    { title = "LUNA — Peso Pluma, Junior H", url = "https://file.garden/algLafWA1jk8WMfK/LUNA_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_39_Luna.mp3", soundName = "RevHubBless39LUNA" },
    { title = "NUEVA VIDA — Peso Pluma", url = "https://file.garden/algLafWA1jk8WMfK/NUEVA%20VIDA_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_40_NuevaVida.mp3", soundName = "RevHubBless40NUEVAVIDA" },
    { title = "Juan Martha — La Original Banda El Limón de Salvador Lizárraga, Julio Preciado", url = "https://file.garden/algLafWA1jk8WMfK/Juan%20Martha_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_41_JuanMartha.mp3", soundName = "RevHubBless41JuanMartha" },
    { title = "Rojo Vivo — Jesus Parra", url = "https://file.garden/algLafWA1jk8WMfK/Rojo%20Vivo_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_42_RojoVivo.mp3", soundName = "RevHubBless42RojoVivo" },
    { title = "Vuelvo Mejor - Remix — NTG, Arcángel", url = "https://file.garden/algLafWA1jk8WMfK/Vuelvo%20Mejor%20-%20Remix_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_43_VuelvoMejorRemix.mp3", soundName = "RevHubBless43VuelvoMejorRemix" },
    { title = "DEMBOW BÉLICO — Tito Double P, Joel De La P, Luis R Conriquez", url = "https://file.garden/algLafWA1jk8WMfK/DEMBOW%20BE%CC%81LICO_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_44_DembowBelico.mp3", soundName = "RevHubBless44DEMBOWBLICO" },
    { title = "No Nací Para Caerle Bien — La Santa Grifa", url = "https://file.garden/algLafWA1jk8WMfK/No%20Naci%CC%81%20Para%20Caerle%20Bien_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_45_NoNaciParaCaerleBien.mp3", soundName = "RevHubBless45NoNacParaCaerleBien" },
    { title = "Alaska — Victor Mendivil, Hades66", url = "https://file.garden/algLafWA1jk8WMfK/Alaska_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_46_Alaska.mp3", soundName = "RevHubBless46Alaska" },
    { title = "Tony Montana — Victor Mendivil, Yng Lvcas", url = "https://file.garden/algLafWA1jk8WMfK/Tony%20Montana_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_47_TonyMontana.mp3", soundName = "RevHubBless47TonyMontana" },
    { title = "Amnesia — La Santa Grifa", url = "https://file.garden/algLafWA1jk8WMfK/Amnesia_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_48_Amnesia.mp3", soundName = "RevHubBless48Amnesia" },
    { title = "Mal Ejemplo — La Santa Grifa", url = "https://file.garden/algLafWA1jk8WMfK/Mal%20Ejemplo_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_49_MalEjemplo.mp3", soundName = "RevHubBless49MalEjemplo" },
    { title = "Cholo 2 — Victor Mendivil, Eladio Carrion", url = "https://file.garden/algLafWA1jk8WMfK/Cholo%202_spotdown.org.mp3", file = "revhub_bless_FearHubJukebox_50_Cholo2.mp3", soundName = "RevHubBless50Cholo2" },
    { title = "OLIVIA LA FLAKA — Natanael Cano, Tito Double P, Victor Mendivil, Ovi", url = "https://file.garden/algLafWA1jk8WMfK/SpotiDownloader.com%20-%20OLIVIA%20LA%20FLAKA%20-%20Natanael%20Cano.mp3", file = "revhub_bless_FearHubJukebox_51_OliviaLaFlaka.mp3", soundName = "RevHubBless51OLIVIALAFLAKA" },
    { title = "redrum — 21 Savage", url = "https://file.garden/algLafWA1jk8WMfK/redrum_spotdown.org%202.mp3", file = "revhub_bless_Bless_Redrum.mp3", soundName = "RevHubBless52redrum" },
    { title = "Paris Hilton — $HUPE, Victor Mendivil", url = "https://file.garden/algLafWA1jk8WMfK/Paris%20Hilton_spotdown.org.mp3", file = "revhub_bless_Bless_ParisHilton.mp3", soundName = "RevHubBless53ParisHilton" },
    { title = "Dandy Hats — El Rabbanito", url = "https://file.garden/algLafWA1jk8WMfK/Dandy%20Hats_spotdown.org.mp3", file = "revhub_bless_Bless_DandyHats.mp3", soundName = "RevHubBless54DandyHats" },
    { title = "Mi Terre CLN — Fuerza Regida, Juanpa Salazar", url = "https://file.garden/algLafWA1jk8WMfK/Mi%20Terre%20CLN_spotdown.org.mp3", file = "revhub_bless_Bless_MiTerreCLN.mp3", soundName = "RevHubBless55MiTerreCLN" },
    { title = "Michael Myers Halloween Theme (Piano Version)", url = "https://file.garden/algLafWA1jk8WMfK/Michael%20Myers%20Halloween%20Theme%20Song%20(Piano%20Version)_spotdown.org.mp3", file = "revhub_bless_halloween_theme.mp3", soundName = "RevHubBlessHalloween1" },
    { title = "Tuff Song", url = "https://files.catbox.moe/rvf2vy.mp3", file = "revhub_mk_cle_duels_tuffsong.mp3", soundName = "RevHubMK01TuffSong" },
    { title = "orula", url = "https://files.catbox.moe/v20ko9.mp3", file = "revhub_mk_cle_duels_orula.mp3", soundName = "RevHubMK02orula" },
    { title = "X.O.X.O", url = "https://files.catbox.moe/jghp0f.mp3", file = "revhub_mk_cle_duels_xoxo.mp3", soundName = "RevHubMK03XOXO" },
    { title = "beretta", url = "https://file.garden/algLafWA1jk8WMfK/Beretta%20-%20video%20oficial(MP3_160K).mp3", file = "revhub_mk_cle_duels_beretta.mp3", soundName = "RevHubMK04beretta", startAt = 10 },
    { title = "to the O", url = "https://file.garden/algLafWA1jk8WMfK/King%20Von%20-%20Took%20Her%20To%20The%20O%20(Lyrics)(MP3_160K).mp3", file = "revhub_mk_cle_duels_to_the_o.mp3", soundName = "RevHubMK05totheO" },
    { title = "LAJA", url = "https://file.garden/algLafWA1jk8WMfK/LAJA%20-%20NADIE%20TA%20FRIO%20(Letra)(MP3_160K).mp3", file = "revhub_mk_cle_duels_laja.mp3", soundName = "RevHubMK06LAJA" },
    { title = "HORA 0", url = "https://file.garden/algLafWA1jk8WMfK/Myke%20Towers%20-%20HORA%20CERO%20(Lyrics)(MP3_160K).mp3", file = "revhub_mk_cle_duels_hora_0.mp3", soundName = "RevHubMK07HORA0" },
    { title = "Lucid Dreams", url = "https://file.garden/algLafWA1jk8WMfK/Lucid%20Dreams%20-%20Clean%20-%20Juice%20WRLD(MP3_160K).mp3", file = "revhub_mk_cle_duels_lucid_dreams.mp3", soundName = "RevHubMK08LucidDreams" },
    { title = "El corrido del 30", url = "https://files.catbox.moe/pf9kd9.mp3", file = "revhub_mk_blackstar_corrido_del_30.mp3", soundName = "RevHubMK09Elcorridodel30" },
    { title = "WARE", url = "https://files.catbox.moe/p2pp91.mp3", file = "revhub_mk_blackstar_ware.mp3", soundName = "RevHubMK10WARE" },
    { title = "El Hijo del 7", url = "https://files.catbox.moe/wpbab3.mp3", file = "revhub_mk_blackstar_el_hijo_del_7.mp3", soundName = "RevHubMK11ElHijodel7" },
    { title = "WOW", url = "https://files.catbox.moe/14rdtj.mp3", file = "revhub_mk_blackstar_wow.mp3", soundName = "RevHubMK12WOW" },
    { title = "el de la R", url = "https://files.catbox.moe/u67vx5.mp3", file = "revhub_mk_blackstar_el_de_la_r.mp3", soundName = "RevHubMK13eldelaR" },
    { title = "EL CHIRICUAZO", url = "https://files.catbox.moe/va3lhi.mp3", file = "revhub_mk_blackstar_el_chiricuazo.mp3", soundName = "RevHubMK14ELCHIRICUAZO" },
    { title = "El Maestro", url = "https://files.catbox.moe/bmjsah.mp3", file = "revhub_mk_blackstar_el_maestro.mp3", soundName = "RevHubMK15ElMaestro" },
    { title = "Seteadora", url = "https://files.catbox.moe/94olvv.mp3", file = "revhub_mk_blackstar_seteadora.mp3", soundName = "RevHubMK16Seteadora" },
    { title = "El Ondeado V2", url = "https://files.catbox.moe/4lqp91.mp3", file = "revhub_mk_blackstar_el_ondeado_v2.mp3", soundName = "RevHubMK17ElOndeadoV2" },
    { title = "Audio FC8602B80B", assetId = "rbxassetid://FC8602B80B", soundName = "RevHubMK18AudioFC8602B80B" },
    { title = "Audio 723CEF61B0", assetId = "rbxassetid://723CEF61B0", soundName = "RevHubMK19Audio723CEF61B0" },
    { title = "Intro MK — Jesse Pinkman", url = "https://file.garden/algLafWA1jk8WMfK/Jesse%20Pinkman_spotdown.org.mp3", file = "RevHubIntro_JessePinkman.mp3", soundName = "RevHubMKIntro1", startAt = 11 },
}

-- ============================================================
--  UTILIDADES
-- ============================================================
local assetFunction = getcustomasset or getsynasset
local songParent = CoreGui

local function fileExists(path)
    if type(isfile) ~= "function" then return false end
    local ok, e = pcall(isfile, path)
    return ok and e == true
end

local function validAudio(data)
    if type(data) ~= "string" or #data < 2048 then return false end
    local h = data:sub(1, 256):lower()
    return not (h:find("<html", 1, true) or h:find("<!doctype", 1, true)
        or h:find("access denied", 1, true) or h:find("not found", 1, true)
        or h:find("error", 1, true))
end

local function downloadAudio(url, path)
    if type(writefile) ~= "function" then return false, "writefile no disponible" end
    local data, lastErr
    local req = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)
    if type(req) == "function" then
        local ok, resp = pcall(req, { Url = url, Method = "GET", Headers = { ["User-Agent"] = "Mozilla/5.0" } })
        if ok and type(resp) == "table" then
            local code = tonumber(resp.StatusCode or resp.Status or resp.status_code) or 0
            local body = resp.Body or resp.body
            if (code == 0 or (code >= 200 and code < 300)) and validAudio(body) then data = body
            else lastErr = "HTTP " .. tostring(code) end
        elseif not ok then lastErr = tostring(resp) end
    end
    if not data then
        local ok, res = pcall(function() return game:HttpGet(url, true) end)
        if ok and validAudio(res) then data = res
        elseif not ok then lastErr = tostring(res)
        elseif not lastErr then lastErr = "MP3 inválido" end
    end
    if not data then return false, lastErr or "descarga fallida" end
    local ok, err = pcall(writefile, path, data)
    if not ok then return false, tostring(err) end
    return true
end

-- ============================================================
--  ESTADO
-- ============================================================
local Player = { sounds = {}, endedConnections = {}, currentIndex = nil, isPlaying = false, isPaused = false, volume = musicPlayerVolume or 0.75, loop = musicPlayerLoop == true, playbackToken = 0, advancingToken = nil }

local function createSoundInstance(song)
    local assetId = type(song.assetId) == "string" and song.assetId or nil
    if not assetId then
        if type(assetFunction) ~= "function" or type(song.file) ~= "string" then return nil end
        local ok, resolvedAssetId = pcall(assetFunction, song.file)
        if not ok or type(resolvedAssetId) ~= "string" or resolvedAssetId == "" then return nil end
        assetId = resolvedAssetId
    end
    if Player.sounds[song.soundName] then
        pcall(function() Player.sounds[song.soundName]:Destroy() end)
    end
    local snd = Instance.new("Sound")
    snd.Name = song.soundName
    snd.SoundId = assetId
    snd.Volume = Player.volume
    snd.Looped = Player.loop
    snd.Parent = songParent
    Player.sounds[song.soundName] = snd
    return snd
end

local function prepareSong(song, cb)
    if Player.sounds[song.soundName] and Player.sounds[song.soundName].Parent then
        if cb then cb(true) end
        return
    end
    createSoundInstance(song)
    if not Player.sounds[song.soundName] then
        local ok = type(song.url) == "string" and type(song.file) == "string"
            and downloadAudio(song.url, song.file) or false
        if not ok then
            if cb then cb(false) end
            return
        end
        if not createSoundInstance(song) then
            if cb then cb(false) end
            return
        end
    end
    if cb then cb(true) end
end

local function stopAll()
    Player.playbackToken += 1
    Player.advancingToken = nil
    for sound, connection in pairs(Player.endedConnections) do
        pcall(function() connection:Disconnect() end)
        Player.endedConnections[sound] = nil
    end
    for _, s in pairs(Player.sounds) do
        pcall(function() s:Stop(); s.TimePosition = 0 end)
    end
    Player.isPlaying = false
    Player.isPaused = false
end

local UI = {}

local nextSong
local function advanceEndedSong(index, token)
    if Player.currentIndex ~= index or Player.playbackToken ~= token
        or Player.loop or Player.isPaused or not Player.isPlaying
        or Player.advancingToken == token then
        return
    end
    Player.advancingToken = token
    Player.isPlaying = false
    if UI.updatePlayIcon then UI.updatePlayIcon(false) end
    task.defer(function()
        if Player.currentIndex == index and Player.playbackToken == token
            and not Player.loop and not Player.isPaused and Player.advancingToken == token
            and nextSong then
            nextSong()
        end
    end)
end

local function playSong(index)
    if index < 1 or index > #songs then return end
    local song = songs[index]
    stopAll()
    Player.currentIndex = index
    local playToken = Player.playbackToken
    if UI.updateTitle then UI.updateTitle(index, song) end
    prepareSong(song, function(ok)
        if not ok or Player.playbackToken ~= playToken or Player.currentIndex ~= index then return end
        local snd = Player.sounds[song.soundName]
        if snd then
            snd.TimePosition = 0
            snd.Looped = Player.loop
            local endedConnection = Player.endedConnections[snd]
            if endedConnection then pcall(function() endedConnection:Disconnect() end) end
            Player.endedConnections[snd] = snd.Ended:Connect(function()
                advanceEndedSong(index, playToken)
            end)
            snd:Play()
            local startAt = math.max(0, tonumber(song.startAt) or 0)
            if startAt > 0 then
                task.spawn(function()
                    local deadline = os.clock() + 3
                    while snd.Parent and not snd.IsLoaded and os.clock() < deadline do task.wait(0.05) end
                    if snd.Parent and Player.currentIndex == index and Player.playbackToken == playToken then
                        pcall(function() snd.TimePosition = startAt end)
                    end
                end)
            end
            Player.isPlaying = true
            Player.isPaused = false
            Player.advancingToken = nil
            musicPlayerIndex = index
            if type(saveAllSettings) == "function" then pcall(saveAllSettings) end
            if UI.updatePlayIcon then UI.updatePlayIcon(true) end
        end
    end)
end

local function pauseSong()
    if not Player.currentIndex then return end
    local snd = Player.sounds[songs[Player.currentIndex].soundName]
    if snd and snd.IsPlaying then
        snd:Pause()
        Player.isPaused = true
        Player.isPlaying = false
        if UI.updatePlayIcon then UI.updatePlayIcon(false) end
    end
end

local function resumeSong()
    if not Player.currentIndex then return end
    local snd = Player.sounds[songs[Player.currentIndex].soundName]
    if snd and not snd.IsPlaying then
        snd:Resume()
        Player.isPaused = false
        Player.isPlaying = true
        if UI.updatePlayIcon then UI.updatePlayIcon(true) end
    end
end

local function togglePlayPause()
    if Player.isPlaying then pauseSong()
    elseif Player.isPaused then resumeSong()
    elseif Player.currentIndex then playSong(Player.currentIndex)
    else playSong(1) end
end

nextSong = function()
    if not Player.currentIndex then playSong(1); return end
    local n = Player.currentIndex + 1
    if n > #songs then n = 1 end
    playSong(n)
end

local function prevSong()
    if not Player.currentIndex then playSong(1); return end
    local p = Player.currentIndex - 1
    if p < 1 then p = #songs end
    playSong(p)
end

local function setVolume(v)
    Player.volume = math.clamp(v, 0, 1)
    musicPlayerVolume = Player.volume
    for _, s in pairs(Player.sounds) do
        pcall(function() s.Volume = Player.volume end)
    end
    if type(saveAllSettings) == "function" then pcall(saveAllSettings) end
end

local function setLoop(state)
    Player.loop = state == true
    musicPlayerLoop = Player.loop
    if Player.currentIndex then
        local snd = Player.sounds[songs[Player.currentIndex].soundName]
        if snd then snd.Looped = Player.loop end
    end
    if type(saveAllSettings) == "function" then pcall(saveAllSettings) end
end

-- ============================================================
--  UI  (TEMA NEGRO)
-- ============================================================
local gui = hostGui
local overlay, ctrlBar, listPanel
local openTrigger = nil
local outsideConnection = nil
local autoNextConnection = nil

-- Paleta negra
local BLACK       = Color3.fromRGB(0, 0, 0)
local BLACK_SOFT  = Color3.fromRGB(18, 18, 18)
local BLACK_MID   = Color3.fromRGB(30, 30, 30)
local BORDER      = Color3.fromRGB(60, 60, 60)
local WHITE       = Color3.fromRGB(255, 255, 255)
local GRAY        = Color3.fromRGB(200, 200, 200)

local function buildUI()
    -- OVERLAY (fondo negro, SIN imagen)
    overlay = Instance.new("Frame", gui)
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(0, 400, 0, 70)
    overlay.Position = UDim2.new(0.5, -200, 0.72, 0)
    overlay.BackgroundColor3 = BLACK_SOFT
    overlay.BackgroundTransparency = 0.1
    overlay.BorderSizePixel = 0
    overlay.Visible = false
    overlay.ZIndex = 50
    overlay.ClipsDescendants = true
    Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, 35)

    local ovStroke = Instance.new("UIStroke", overlay)
    ovStroke.Color = BORDER
    ovStroke.Thickness = 1.8
    ovStroke.Transparency = 0.2
    ovStroke.ZIndex = 60

    -- FLECHA IZQUIERDA
    local leftArrow = Instance.new("TextButton", overlay)
    leftArrow.Size = UDim2.new(0, 52, 0, 52)
    leftArrow.Position = UDim2.new(0, 9, 0.5, -26)
    leftArrow.BackgroundColor3 = BLACK_MID
    leftArrow.BackgroundTransparency = 0.15
    leftArrow.BorderSizePixel = 0
    leftArrow.Text = "◀"
    leftArrow.TextColor3 = WHITE
    leftArrow.Font = Enum.Font.GothamBlack
    leftArrow.TextSize = 22
    leftArrow.AutoButtonColor = false
    leftArrow.Active = true
    leftArrow.ZIndex = 55
    Instance.new("UICorner", leftArrow).CornerRadius = UDim.new(1, 0)
    local laStroke = Instance.new("UIStroke", leftArrow)
    laStroke.Color = BORDER
    laStroke.Thickness = 1.5
    laStroke.Transparency = 0.3

    leftArrow.MouseEnter:Connect(function()
        TS:Create(leftArrow, TweenInfo.new(0.12), { BackgroundColor3 = BLACK, BackgroundTransparency = 0 }):Play()
    end)
    leftArrow.MouseLeave:Connect(function()
        TS:Create(leftArrow, TweenInfo.new(0.12), { BackgroundColor3 = BLACK_MID, BackgroundTransparency = 0.15 }):Play()
    end)
    leftArrow.MouseButton1Click:Connect(function() prevSong() end)

    -- FLECHA DERECHA
    local rightArrow = Instance.new("TextButton", overlay)
    rightArrow.Size = UDim2.new(0, 52, 0, 52)
    rightArrow.Position = UDim2.new(1, -61, 0.5, -26)
    rightArrow.BackgroundColor3 = BLACK_MID
    rightArrow.BackgroundTransparency = 0.15
    rightArrow.BorderSizePixel = 0
    rightArrow.Text = "▶"
    rightArrow.TextColor3 = WHITE
    rightArrow.Font = Enum.Font.GothamBlack
    rightArrow.TextSize = 22
    rightArrow.AutoButtonColor = false
    rightArrow.Active = true
    rightArrow.ZIndex = 55
    Instance.new("UICorner", rightArrow).CornerRadius = UDim.new(1, 0)
    local raStroke = Instance.new("UIStroke", rightArrow)
    raStroke.Color = BORDER
    raStroke.Thickness = 1.5
    raStroke.Transparency = 0.3

    rightArrow.MouseEnter:Connect(function()
        TS:Create(rightArrow, TweenInfo.new(0.12), { BackgroundColor3 = BLACK, BackgroundTransparency = 0 }):Play()
    end)
    rightArrow.MouseLeave:Connect(function()
        TS:Create(rightArrow, TweenInfo.new(0.12), { BackgroundColor3 = BLACK_MID, BackgroundTransparency = 0.15 }):Play()
    end)
    rightArrow.MouseButton1Click:Connect(function() nextSong() end)

    -- INFO CENTRAL
    local centerInfo = Instance.new("Frame", overlay)
    centerInfo.Size = UDim2.new(1, -130, 1, 0)
    centerInfo.Position = UDim2.new(0, 65, 0, 0)
    centerInfo.BackgroundTransparency = 1
    centerInfo.ZIndex = 56

    local titleLbl = Instance.new("TextLabel", centerInfo)
    titleLbl.Name = "Title"
    titleLbl.Size = UDim2.new(1, -6, 0, 28)
    titleLbl.Position = UDim2.new(0, 3, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "Selecciona una canción"
    titleLbl.TextColor3 = WHITE
    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextSize = 15
    titleLbl.TextWrapped = true
    titleLbl.TextXAlignment = Enum.TextXAlignment.Center
    titleLbl.TextYAlignment = Enum.TextYAlignment.Center
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    titleLbl.TextStrokeTransparency = 0.4
    titleLbl.TextStrokeColor3 = BLACK
    titleLbl.ZIndex = 57

    local counterLbl = Instance.new("TextLabel", centerInfo)
    counterLbl.Name = "Counter"
    counterLbl.Size = UDim2.new(1, 0, 0, 14)
    counterLbl.Position = UDim2.new(0, 0, 1, -18)
    counterLbl.BackgroundTransparency = 1
    counterLbl.Text = "— / " .. #songs
    counterLbl.TextColor3 = GRAY
    counterLbl.Font = Enum.Font.GothamBold
    counterLbl.TextSize = 10
    counterLbl.TextStrokeTransparency = 0.5
    counterLbl.TextStrokeColor3 = BLACK
    counterLbl.ZIndex = 57

    -- BARRA DE CONTROLES
    ctrlBar = Instance.new("Frame", gui)
    ctrlBar.Name = "CtrlBar"
    ctrlBar.Size = UDim2.new(0, 400, 0, 34)
    ctrlBar.Position = UDim2.new(0.5, -200, 0.72, 78)
    ctrlBar.BackgroundColor3 = BLACK_SOFT
    ctrlBar.BackgroundTransparency = 0.1
    ctrlBar.BorderSizePixel = 0
    ctrlBar.Visible = false
    ctrlBar.ZIndex = 50
    Instance.new("UICorner", ctrlBar).CornerRadius = UDim.new(0, 12)
    local cbStroke = Instance.new("UIStroke", ctrlBar)
    cbStroke.Color = BORDER
    cbStroke.Thickness = 1.3
    cbStroke.Transparency = 0.3

    local cbLayout = Instance.new("UIListLayout", ctrlBar)
    cbLayout.FillDirection = Enum.FillDirection.Horizontal
    cbLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    cbLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    cbLayout.Padding = UDim.new(0, 4)

    local function mkCtrlBtn(txt, w, cb)
        local b = Instance.new("TextButton", ctrlBar)
        b.Size = UDim2.new(0, w, 0, 26)
        b.BackgroundColor3 = BLACK_MID
        b.BorderSizePixel = 0
        b.Text = txt
        b.TextColor3 = WHITE
        b.Font = Enum.Font.GothamBold
        b.TextSize = 11
        b.AutoButtonColor = false
        b.Active = true
        b.ZIndex = 55
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
        local s = Instance.new("UIStroke", b)
        s.Color = BORDER
        s.Thickness = 1
        s.Transparency = 0.4
        b.MouseEnter:Connect(function()
            TS:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = BLACK }):Play()
        end)
        b.MouseLeave:Connect(function()
            TS:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = BLACK_MID }):Play()
        end)
        b.MouseButton1Click:Connect(cb)
        return b
    end

    local playPauseBtn = mkCtrlBtn("▶", 34, function() togglePlayPause() end)
    local loopBtn
    local function updateLoopVisual(state)
        if not loopBtn then return end
        state = state == nil and Player.loop or state
        loopBtn.BackgroundColor3 = state and WHITE or BLACK_MID
        loopBtn.TextColor3 = state and BLACK or WHITE
    end
    UI.updateLoopVisual = updateLoopVisual
    loopBtn = mkCtrlBtn("🔁", 34, function()
        setLoop(not Player.loop)
        updateLoopVisual()
    end)
    updateLoopVisual()
    mkCtrlBtn("🔉", 34, function() setVolume(Player.volume - 0.1) end)
    mkCtrlBtn("🔊", 34, function() setVolume(Player.volume + 0.1) end)
    mkCtrlBtn("📋", 34, function()
        UI.listPanel.Visible = not UI.listPanel.Visible
    end)
    mkCtrlBtn("✖", 34, function()
        if UI.close then UI.close() end
    end)

    -- PANEL DE LISTA
    listPanel = Instance.new("Frame", gui)
    listPanel.Name = "ListPanel"
    listPanel.Size = UDim2.new(0, 400, 0, 280)
    listPanel.Position = UDim2.new(0.5, -200, 0.72, -290)
    listPanel.BackgroundColor3 = BLACK_SOFT
    listPanel.BackgroundTransparency = 0.05
    listPanel.BorderSizePixel = 0
    listPanel.Visible = false
    listPanel.ZIndex = 50
    Instance.new("UICorner", listPanel).CornerRadius = UDim.new(0, 14)
    local lpStroke = Instance.new("UIStroke", listPanel)
    lpStroke.Color = BORDER
    lpStroke.Thickness = 1.3
    lpStroke.Transparency = 0.2

    local listTitle = Instance.new("TextLabel", listPanel)
    listTitle.Size = UDim2.new(1, -20, 0, 26)
    listTitle.Position = UDim2.new(0, 10, 0, 5)
    listTitle.BackgroundTransparency = 1
    listTitle.Text = "📋 PLAYLIST"
    listTitle.TextColor3 = WHITE
    listTitle.Font = Enum.Font.GothamBlack
    listTitle.TextSize = 12
    listTitle.TextXAlignment = Enum.TextXAlignment.Left
    listTitle.ZIndex = 55

    local scroll = Instance.new("ScrollingFrame", listPanel)
    scroll.Size = UDim2.new(1, -20, 1, -42)
    scroll.Position = UDim2.new(0, 10, 0, 36)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 6
    scroll.ScrollBarImageColor3 = BORDER
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ZIndex = 55

    local sLay = Instance.new("UIListLayout", scroll)
    sLay.Padding = UDim.new(0, 4)
    sLay.SortOrder = Enum.SortOrder.LayoutOrder

    local songBtns = {}
    for i, song in ipairs(songs) do
        local item = Instance.new("TextButton", scroll)
        item.Size = UDim2.new(1, -6, 0, 26)
        item.BackgroundColor3 = BLACK_MID
        item.BorderSizePixel = 0
        item.Text = string.format("%02d.  %s", i, song.title)
        item.TextColor3 = GRAY
        item.Font = Enum.Font.GothamMedium
        item.TextSize = 11
        item.TextXAlignment = Enum.TextXAlignment.Left
        item.TextTruncate = Enum.TextTruncate.AtEnd
        item.LayoutOrder = i
        item.ZIndex = 56
        item.Active = true
        Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)
        item.MouseEnter:Connect(function()
            if Player.currentIndex ~= i then
                TS:Create(item, TweenInfo.new(0.1), { BackgroundColor3 = BLACK }):Play()
            end
        end)
        item.MouseLeave:Connect(function()
            if Player.currentIndex ~= i then
                TS:Create(item, TweenInfo.new(0.1), { BackgroundColor3 = BLACK_MID }):Play()
            end
        end)
        item.MouseButton1Click:Connect(function() playSong(i) end)
        songBtns[i] = item
    end

    -- REFS
    UI.overlay = overlay
    UI.ctrlBar = ctrlBar
    UI.listPanel = listPanel
    UI.titleLbl = titleLbl
    UI.counterLbl = counterLbl
    UI.songBtns = songBtns
    UI.playPauseBtn = playPauseBtn

    UI.updateTitle = function(index, song)
        titleLbl.Text = song.title
        counterLbl.Text = string.format("%d / %d", index, #songs)
        titleLbl.TextSize = 17
        TS:Create(titleLbl, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { TextSize = 15 }):Play()
        for i, item in ipairs(songBtns) do
            if i == index then
                item.BackgroundColor3 = WHITE
                item.TextColor3 = BLACK
            else
                item.BackgroundColor3 = BLACK_MID
                item.TextColor3 = GRAY
            end
        end
    end

    UI.updatePlayIcon = function(playing)
        playPauseBtn.Text = playing and "⏸" or "▶"
    end

    -- API de apertura/cierre desde el botón Open de Calzosky Hub.
    local isOpen = false

    local function pointInside(guiObject, point)
        if not guiObject or not guiObject.Parent or not guiObject.Visible then return false end
        local ancestor = guiObject.Parent
        while ancestor and ancestor ~= gui do
            if ancestor:IsA("GuiObject") and not ancestor.Visible then return false end
            ancestor = ancestor.Parent
        end
        local pos = guiObject.AbsolutePosition
        local size = guiObject.AbsoluteSize
        return point.X >= pos.X and point.X <= pos.X + size.X
            and point.Y >= pos.Y and point.Y <= pos.Y + size.Y
    end

    local function openOverlay()
        isOpen = true
        overlay.Visible = true
        ctrlBar.Visible = true
        overlay.Size = UDim2.new(0, 120, 0, 30)
        TS:Create(overlay, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 400, 0, 70)
        }):Play()
    end

    local function closeOverlay()
        isOpen = false
        listPanel.Visible = false
        TS:Create(overlay, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 120, 0, 30)
        }):Play()
        task.delay(0.18, function()
            if not isOpen then
                overlay.Visible = false
                ctrlBar.Visible = false
            end
        end)
    end

    UI.open = openOverlay
    UI.close = closeOverlay
    UI.toggle = function(triggerButton)
        if triggerButton then openTrigger = triggerButton end
        if isOpen then closeOverlay() else openOverlay() end
    end
    UI.isOpen = function() return isOpen end

    outsideConnection = UIS.InputBegan:Connect(function(input)
        if not isOpen then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        local point = Vector2.new(input.Position.X, input.Position.Y)
        if pointInside(overlay, point) or pointInside(ctrlBar, point)
            or (listPanel.Visible and pointInside(listPanel, point))
            or pointInside(openTrigger, point) then
            return
        end
        closeOverlay()
    end)
end

-- ============================================================
--  LOOP AUTO-SIGUIENTE
-- ============================================================
autoNextConnection = RunService.RenderStepped:Connect(function()
    if not Player.currentIndex then return end
    local song = songs[Player.currentIndex]
    local snd = Player.sounds[song.soundName]
    if not snd or not snd.Parent then return end
    if not snd.IsPlaying and not Player.isPaused and not Player.loop and snd.TimeLength > 0
       and snd.TimePosition >= snd.TimeLength - 0.15 then
        advanceEndedSong(Player.currentIndex, Player.playbackToken)
    end
end)

-- ============================================================
--  INIT
-- ============================================================
buildUI()
applyMusicPlayerConfig = function()
    Player.volume = math.clamp(tonumber(musicPlayerVolume) or 0.75, 0, 1)
    Player.loop = musicPlayerLoop == true
    for _, sound in pairs(Player.sounds) do
        pcall(function()
            sound.Volume = Player.volume
            sound.Looped = Player.loop
        end)
    end
    local index = math.clamp(math.floor(tonumber(musicPlayerIndex) or 1), 1, #songs)
    musicPlayerIndex = index
    Player.currentIndex = index
    if UI.updateTitle then UI.updateTitle(index, songs[index]) end
    if UI.updateLoopVisual then UI.updateLoopVisual(Player.loop) end
    if UI.updatePlayIcon then UI.updatePlayIcon(false) end
end
for _, popupRoot in ipairs({overlay, ctrlBar, listPanel}) do
    popupRoot.Active = true
    popupRoot.ZIndex += 200
    for _, descendant in ipairs(popupRoot:GetDescendants()) do
        if descendant:IsA("GuiObject") then
            descendant.ZIndex += 200
        end
    end
end

task.spawn(function()
    for _, song in ipairs(songs) do
        if fileExists(song.file) then createSoundInstance(song) end
    end
end)

UI.destroy = function()
    if outsideConnection then
        pcall(function() outsideConnection:Disconnect() end)
        outsideConnection = nil
    end
    if autoNextConnection then
        pcall(function() autoNextConnection:Disconnect() end)
        autoNextConnection = nil
    end
    pcall(stopAll)
    for _, sound in pairs(Player.sounds) do
        pcall(function() sound:Destroy() end)
    end
    for _, object in ipairs({overlay, ctrlBar, listPanel}) do
        if object and object.Parent then pcall(function() object:Destroy() end) end
    end
end

print("Surehub music player integrado y listo.")
return UI
end

local introOK, introError = pcall(function() RH_Style.intro() end)
if not introOK then
    pcall(function() RH_Style.finish() end)
    warn("[Calzosky Hub] Intro: " .. tostring(introError))
end
buildGui()
if _G.RevHubMusicPlayer and _G.RevHubMusicPlayer.destroy then
    pcall(_G.RevHubMusicPlayer.destroy)
end
_G.RevHubMusicPlayer = createRevHubMusicPlayer(gui)
MobilePanel = createMobilePanel()
tpBatFloatingButton = MobilePanel and MobilePanel:FindFirstChild("TPBat") or nil
batV2FloatingButton = MobilePanel and MobilePanel:FindFirstChild("BatV2") or nil
instaResetFloatingButton = MobilePanel and MobilePanel:FindFirstChild("Reset") or nil
do
    local function createLastPositionTracker()
        local trackerPlayersService = game:GetService("Players")
        local trackerRunService = game:GetService("RunService")
        local trackerWorkspace = game:GetService("Workspace")
        local trackerPlayer = trackerPlayersService.LocalPlayer
        local color = Color3.fromRGB(180, 180, 190)
        Color3.fromRGB(170, 170, 180)
        local color2 = Color3.fromRGB(230, 230, 235)
        local color3 = Color3.fromRGB(230, 230, 235)
        local color4 = Color3.fromRGB(30, 30, 35)
        local color5 = Color3.fromRGB(200, 200, 210)
        local mapMinX = -536.2
        local mapMaxX = -422
        local mapMinY = -10
        local mapMinZ = -71.8
        local trackerState = {
            marker = nil,
            markerLocked = false,
            markerTarget = nil,
            samples = {},
            conn = nil,
            acc = 0,
        }
        local function isValidVector(position)
            return position ~= nil
                and position.X == position.X
                and position.Y == position.Y
                and position.Z == position.Z
                and math.abs(position.X) < 10000000
                and math.abs(position.Y) < 10000000
                and math.abs(position.Z) < 10000000
        end
        local function isInsideMapBounds(position)
            if not position then
                return false
            end
            return position.X >= mapMinX
                and position.X <= mapMaxX
                and position.Y >= mapMinY
                and position.Y <= 75
                and position.Z >= mapMinZ
                and position.Z <= 192.9
        end
        local function getHistoricalSample(targetState, currentTime)
            if not targetState or not targetState.history or #targetState.history == 0 then
                return nil
            end
            local cutoffTime = currentTime - 0.2
            local sample = nil
            for _, historyEntry in ipairs(targetState.history) do
                if historyEntry.time <= cutoffTime then
                    sample = historyEntry
                    continue
                end
                break
            end
            return sample or targetState.history[1]
        end
        local function hideLastPositionMarker()
            trackerState.markerLocked = false
            local marker = trackerState.marker
            if not marker then
                return
            end
            pcall(function()
                marker.Transparency = 1
                local alwaysOnTopSphere = marker:FindFirstChild("AlwaysOnTopSphere")
                if alwaysOnTopSphere then
                    alwaysOnTopSphere.Visible = false
                end
                local lastPositionHighlight = marker:FindFirstChild("LastPositionHighlight")
                if lastPositionHighlight then
                    lastPositionHighlight.Enabled = false
                end
                local lastPositionLabel = marker:FindFirstChild("LastPositionLabel")
                if lastPositionLabel then
                    lastPositionLabel.Enabled = false
                end
            end)
        end
        local function showLastPositionMarker(rootPart)
            if trackerState.markerLocked then
                return
            end
            if not rootPart or not isInsideMapBounds(rootPart.Position) then
                return
            end
            local rotation = rootPart.Rotation
            local cFrame = CFrame.new(rootPart.Position.X, -7, rootPart.Position.Z) * rotation
            local marker = trackerState.marker
            if not marker or not marker.Parent then
                marker = Instance.new("Part")
                marker.Name = "CleanHubLastPosition"
                marker.Shape = Enum.PartType.Ball
                marker.Size = Vector3.new(3, 3, 3)
                marker.Color = color
                marker.Material = Enum.Material.Neon
                marker.Anchored = true
                marker.CanCollide = false
                marker.CanTouch = false
                marker.CanQuery = false
                marker.CastShadow = false
                marker.Parent = trackerWorkspace
                local sphereHandleAdornment = Instance.new("SphereHandleAdornment")
                sphereHandleAdornment.Name = "AlwaysOnTopSphere"
                sphereHandleAdornment.Adornee = marker
                sphereHandleAdornment.Radius = 1.55
                sphereHandleAdornment.Color3 = color5
                sphereHandleAdornment.Transparency = 0.05
                sphereHandleAdornment.AlwaysOnTop = true
                sphereHandleAdornment.Visible = true
                sphereHandleAdornment.ZIndex = 10
                sphereHandleAdornment.Parent = marker
                local highlight = Instance.new("Highlight")
                highlight.Name = "LastPositionHighlight"
                highlight.Adornee = marker
                highlight.FillColor = color
                highlight.FillTransparency = 0.15
                highlight.OutlineColor = color2
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Enabled = true
                highlight.Parent = marker
                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Name = "LastPositionLabel"
                billboardGui.Size = UDim2.new(0, 110, 0, 20)
                billboardGui.StudsOffset = Vector3.new(0, 2.1, 0)
                billboardGui.AlwaysOnTop = true
                billboardGui.Adornee = marker
                billboardGui.Parent = marker
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.fromScale(1, 1)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = "ultima posicion"
                textLabel.TextColor3 = color3
                textLabel.TextStrokeColor3 = color4
                textLabel.TextStrokeTransparency = 0.25
                textLabel.TextSize = 11
                textLabel.Font = Enum.Font.GothamMedium
                textLabel.Parent = billboardGui
                trackerState.marker = marker
            end
            marker.Transparency = 0
            local alwaysOnTopSphere = marker:FindFirstChild("AlwaysOnTopSphere")
            if alwaysOnTopSphere then
                alwaysOnTopSphere.Visible = true
            end
            local lastPositionHighlight = marker:FindFirstChild("LastPositionHighlight")
            if lastPositionHighlight then
                lastPositionHighlight.Enabled = true
            end
            local lastPositionLabel = marker:FindFirstChild("LastPositionLabel")
            if lastPositionLabel then
                lastPositionLabel.Enabled = true
            end
            marker.CFrame = cFrame
            trackerState.markerLocked = true
        end
        local function isValidTargetPlayer(player)
            if not player or player.Parent ~= trackerPlayersService or not player.Character then
                return false
            end
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if
                not humanoidRootPart
                or not humanoid
                or humanoid.Health <= 0
                or not isValidVector(humanoidRootPart.Position)
            then
                return false
            end
            return isInsideMapBounds(humanoidRootPart.Position)
        end
        local function updateTargetTracking()
            local character = trackerPlayer.Character
            character = character and character:FindFirstChild("HumanoidRootPart")
            if not character then
                return
            end
            local markerTarget = trackerState.markerTarget
            if markerTarget and markerTarget.Parent == trackerPlayersService then
                local character2 = markerTarget.Character
                local humanoidRootPart = character2 and character2:FindFirstChild("HumanoidRootPart")
                character2 = character2 and character2:FindFirstChildOfClass("Humanoid")
                local rootPart = trackerState.samples[markerTarget] or {}
                trackerState.samples[markerTarget] = rootPart
                if
                    humanoidRootPart
                    and character2
                    and character2.Health > 0
                    and isValidVector(humanoidRootPart.Position)
                then
                    if isInsideMapBounds(humanoidRootPart.Position) then
                        local now2 = tick()
                        if trackerState.markerLocked then
                            rootPart.history = {}
                        end
                        rootPart.history = rootPart.history or {}
                        table.insert(rootPart.history, {
                            time = now2,
                            safePosition = humanoidRootPart.Position,
                            safeCFrame = humanoidRootPart.CFrame,
                        })
                        while rootPart.history[1] and now2 - rootPart.history[1].time > 0.45 do
                            table.remove(rootPart.history, 1)
                        end
                        rootPart.safePosition = humanoidRootPart.Position
                        rootPart.safeCFrame = humanoidRootPart.CFrame
                        hideLastPositionMarker()
                    else
                        local rootPart2738 = getHistoricalSample(rootPart, tick())
                        showLastPositionMarker(rootPart2738 and rootPart2738.safeCFrame or rootPart.safeCFrame)
                    end
                end
                if not (character2 and character2.Health <= 0 or not humanoidRootPart and not rootPart.safeCFrame) then
                    return
                end
                trackerState.markerTarget = nil
                hideLastPositionMarker()
            end
            local huge2 = math.huge
            local player2740 = nil
            for _, player in ipairs(trackerPlayersService:GetPlayers()) do
                if player ~= trackerPlayer and isValidTargetPlayer(player) then
                    local position = character.Position
                    local magnitude = (player.Character:FindFirstChild("HumanoidRootPart").Position - position).Magnitude
                    if magnitude < huge2 then
                        huge2 = magnitude
                        player2740 = player
                    end
                end
            end
            if player2740 then
                trackerState.markerTarget = player2740
                local rootPart = player2740.Character:FindFirstChild("HumanoidRootPart")
                trackerState.samples[player2740] = {
                    safePosition = rootPart.Position,
                    safeCFrame = rootPart.CFrame,
                    history = {
                        {
                            time = tick(),
                            safePosition = rootPart.Position,
                            safeCFrame = rootPart.CFrame,
                        },
                    },
                }
            end
        end
        local rootPart
        rootPart = {
            GetMarkerCFrame = function()
                local marker = trackerState.marker
                if trackerState.markerLocked and marker and marker.Parent and marker.Transparency < 1 then
                    local markerTarget = trackerState.markerTarget
                    local humanoidRootPart = markerTarget
                        and markerTarget.Character
                        and markerTarget.Character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart and isInsideMapBounds(humanoidRootPart.Position) then
                        hideLastPositionMarker()
                        return nil
                    end
                    return marker.CFrame
                end
                return nil
            end,
            ForceMarker = function(markerTarget, rootPart2751)
                if markerTarget and markerTarget.Parent == trackerPlayersService then
                    trackerState.markerTarget = markerTarget
                end
                markerTarget = markerTarget and trackerState.samples[markerTarget]
                local rootPart2752 = getHistoricalSample(markerTarget, tick())
                markerTarget = rootPart2752 and rootPart2752.safeCFrame or markerTarget and markerTarget.safeCFrame
                if not (not markerTarget and rootPart2751 and isInsideMapBounds(rootPart2751.Position)) then
                    rootPart2751 = markerTarget
                end
                if rootPart2751 then
                    showLastPositionMarker(rootPart2751)
                end
                return rootPart.GetMarkerCFrame()
            end,
            SetTarget = function(markerTarget)
                if markerTarget and markerTarget ~= trackerPlayer and markerTarget.Parent == trackerPlayersService then
                    trackerState.markerTarget = markerTarget
                end
            end,
            Clear = function()
                trackerState.markerTarget = nil
                hideLastPositionMarker()
            end,
            Destroy = function()
                rootPart.Stop()
                if trackerState.marker and trackerState.marker.Parent then
                    pcall(function()
                        trackerState.marker:Destroy()
                    end)
                end
                trackerState.marker = nil
            end,
            Start = function()
                if trackerState.conn then
                    return trackerState.conn
                end
                trackerState.conn = trackerRunService.Heartbeat:Connect(function(deltaTime)
                    trackerState.acc = trackerState.acc + (deltaTime or 0)
                    if trackerState.acc < 0.016666666666666666 then
                        return
                    end
                    trackerState.acc = trackerState.acc % 0.016666666666666666
                    updateTargetTracking()
                end)
                return trackerState.conn
            end,
            Stop = function()
                if trackerState.conn then
                    trackerState.conn:Disconnect()
                    trackerState.conn = nil
                end
            end,
            IsInsideMap = isInsideMapBounds,
        }
        return rootPart
    end
    local cleanHubLastPosMarker = createLastPositionTracker()
    _G.CleanHubLastPosMarker = cleanHubLastPosMarker
    cleanHubLastPosMarker.Start()
end
if loadAllSettings() then
    updateUIFromLoaded()
    if BACKGROUND_IMAGES[backgroundIndex] then
        applyBackground(backgroundIndex)
    end
end
if mainTabSetter then mainTabSetter(mainTabIndex or 1) end
if applyMusicPlayerConfig then applyMusicPlayerConfig() end
if useCarrySystem then
    carryController:start()
    carryController.speedToggled = speedMode
    if laggerCarryToggled then
        carryController:setLaggerMode(2)
    elseif laggerToggled then
        carryController:setLaggerMode(1)
    else
        carryController:setLaggerMode(0)
    end
    carryController:setSoftStealEnabled(true)
end
if localPlayer.Character then
    task.wait(0.1)
    if waitForCharacterReady(localPlayer.Character, 5) then
        setupMovementAndIndicators(localPlayer.Character)
        if currentAnimPack ~= "Off" then
            applyAnimationPack(currentAnimPack)
        end
        pcall(function()
            applyOutfitByIndex(currentOutfitIndex)
        end)
        pcall(refreshCustomTool3DSkins)
    end
end
do
    local value = 0
    localPlayer.CharacterAdded:Connect(function(character)
        value += 1
        local object = value
        if autoStealConnection then
            autoStealConnection:Disconnect()
            autoStealConnection = nil
        end
        autoStealBusy = false
        stopAutoLeft()
        stopAutoRight()
        stopBatCounter()
        stopBatCounterV2()
        stopMedusaCounter()
        if not isActive then
            stopUnwalk()
        end
        stopDropBrainrot()
        if autoBatEnabled then
            disableAutoBat()
        end
        if batDesyncTpEnabled then
            stopBatDesyncTp()
        end
        if autoBatV2Enabled then
            disableBatV2()
        end
        if bodyLockEnabled then
            stopBodyLock()
        end
        local value2760 = getTime() + 5
        while
            not character.Parent
            or not character:FindFirstChild("HumanoidRootPart")
            or not character:FindFirstChildOfClass("Humanoid")
        do
            if value2760 < getTime() then
                return
            end
            if object ~= value then
                return
            end
            task.wait(0.05)
        end
        velocityHookedRoots = {}
        local object2761 = registerVelocityRoot(character)
        installVelocityReadHook(object2761)
        setupMovementAndIndicators(character)
        if antiRagdollMode == "v1" then
            antiRagdollController.start()
        elseif antiRagdollMode == "v2" then
            enableAntiRagdollV2()
        end
        if antiDie.enabled then
            task.defer(function()
                reapplyAntiDie(character)
            end)
        end
        if CONFIG.AUTO_STEAL_ENABLED then
            pcall(startAutoSteal)
        end
        if batDesyncTpEnabled then
            task.defer(startBatDesyncTp)
        end
        if autoBatV2Enabled then
            task.defer(enableBatV2)
        end
        if bodyLockEnabled and _blSuppressCount == 0 then
            startBodyLock()
        end
        if medusaCounterEnabled then
            setupMedusaCounter(character)
            if setMedusaVisual then
                setMedusaVisual(true)
            end
        else
            stopMedusaCounter()
            if setMedusaVisual then
                setMedusaVisual(false)
            end
        end
        if batCounterEnabled then
            startBatCounter()
        end
        if batCounterV2Enabled then
            startBatCounterV2()
        end
        if unwalkEnabled and not isActive then
            startUnwalk()
        end
        if currentAnimPack ~= "Off" then
            task.wait(0.3)
            applyAnimationPack(currentAnimPack)
        end
        updateProgressBarVisibility()
        refreshSpeedModeLabel()
        pcall(function()
            applyOutfitByIndex(currentOutfitIndex)
        end)
        if outfitSelectorLabel then
            outfitSelectorLabel.Text = outfits[currentOutfitIndex].label
        end
        pcall(refreshCustomTool3DSkins)
    end)
end
do
    local value = 0
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if _anyKeyListening then
            return
        end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if gameProcessed or UserInputService:GetFocusedTextBox() then
                return
            end
        elseif not isGamepadInput(input) then
            return
        end
        if not isBindableInput(input) then
            return
        end
        local keyCode = input.KeyCode
        if not keyCode then
            return
        end
        if kbMatch(KB.LaggerMode, keyCode) then
            if getTime() - value >= 0.3 then
                value = getTime()
                toggleLaggerCycle()
            end
            return
        end
        if kbMatch(KB.CarryToggle, keyCode) then
            toggleCarryMode()
            return
        end
        if kbMatch(KB.DropBrainrot, keyCode) then
            if not dropActive then
                if dropBrainrotSetVisual then
                    dropBrainrotSetVisual(true)
                end
                executeDropWithToggle(dropBrainrotSetVisual)
            end
            return
        end
        if kbMatch(KB.TPFloor, keyCode) then
            teleportDown()
            return
        end
        if kbMatch(KB.InstaReset, keyCode) then
            if _G.InstaReset and _G.InstaReset.Trigger then
                _G.InstaReset.Trigger()
            end
            return
        end
        if kbMatch(KB.AutoLeft, keyCode) then
            autoLeftEnabled = not autoLeftEnabled
            if autoLeftEnabled then
                startAutoLeft()
            else
                stopAutoLeft()
            end
            if autoLeftSetVisual then
                autoLeftSetVisual(autoLeftEnabled)
            end
            if mobSetAutoLeft then
                mobSetAutoLeft(autoLeftEnabled)
            end
            return
        end
        if kbMatch(KB.AutoRight, keyCode) then
            autoRightEnabled = not autoRightEnabled
            if autoRightEnabled then
                startAutoRight()
            else
                stopAutoRight()
            end
            if autoRightSetVisual then
                autoRightSetVisual(autoRightEnabled)
            end
            if mobSetAutoRight then
                mobSetAutoRight(autoRightEnabled)
            end
            return
        end
        if kbMatch(KB.AutoBat, keyCode) then
            if not autoBatEnabled then
                enableAutoBat()
                if autoBatSetVisual then
                    autoBatSetVisual(true)
                end
                if mobSetAutoBat then
                    mobSetAutoBat(true)
                end
            else
                disableAutoBat()
                if autoBatSetVisual then
                    autoBatSetVisual(false)
                end
                if mobSetAutoBat then
                    mobSetAutoBat(false)
                end
            end
            return
        end
        if kbMatch(KB.TPBat, keyCode) then
            toggleBatDesyncTp()
            if batDesyncTpSetVisual then
                batDesyncTpSetVisual(batDesyncTpEnabled)
            end
            return
        end
        if kbMatch(KB.BatV2, keyCode) then
            toggleBatV2()
            if autoBatV2SetVisual then
                autoBatV2SetVisual(autoBatV2Enabled)
            end
            if batV2FloatingButton then
                local btnFrame = batV2FloatingButton
                if btnFrame then
                    paintFloatingBtn(btnFrame, autoBatV2Enabled)
                end
            end
            return
        end
        if kbMatch(KB.GuiHide, keyCode) then
            if main then
                if main.Visible then
                    hideGui()
                else
                    showGui()
                end
            end
            return
        end
    end)
end
return