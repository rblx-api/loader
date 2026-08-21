repeat task.wait() until game:IsLoaded()

local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local UIS           = game:GetService("UserInputService")
local TweenService  = game:GetService("TweenService")
local HttpService   = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local Stats         = game:GetService("Stats")
local LP = Players.LocalPlayer

local FileName = "KzsHubConfig_" .. LP.UserId .. ".json"
local DefaultConfig = {
    normalSpeed      = 60, carrySpeed     = 30,
    normalSpeed2     = 45, carrySpeed2   = 22,
    normalSpeed3     = 38, carrySpeed3   = 19,
    useThirdSpeedSet = false,
    laggerSpeed1     = 17,
    laggerSpeed2     = 11,
    laggerLevel      = 0,
    speedType        = "normal",
    autoCarryEnabled = false,
    autoBatToggled   = false,
    infJumpEnabled   = false, infJumpMode = "manual",
    antiRagdollV1Enabled = false,
    antiRagdollV2Enabled = false,
    antiRagdollActiveVersion = 0,
    fpsBoostEnabled  = false,
    medusaCounterEnabled = false,
    animEnabled      = false, unwalkEnabled = false,
    autoTpDownEnabled = false, autoTpDownY = 6,
    autoLeftEnabled  = false, autoRightEnabled = false,
    autoStealEnabled = false, grabRadius = 80, stealDuration = 2.6,
    keyAutoLeft  = "Unknown", keyAutoRight = "Unknown",
    keyDropBR    = "Unknown", keyTpDown = "Unknown", keyAutoBat = "Unknown",
    keySpeedToggle = "Unknown",
    keyAutoTpDown = "Unknown",
    keyInstaReset = "Unknown",
    keySpeed2 = "Unknown",
    keySpeed3 = "Unknown",
    keyLagger = "Unknown",
    keyBatAim2 = "Unknown",
    keyTpBat = "Unknown",
    skyEnabled      = false, skyColorIndex = 1,
    stretchRezEnabled = false,
    batCounterEnabled = false,
    mbButtonScale = 1.0,
    waypointESPEnabled = false,
    controllerEnabled = false, controllerBinds = {},
    guiLocked = false,
    mobileLocked = false,
    useSecondSpeedSet = false,
    aimbot2Speed = 45,
    medusaResetEnabled = false,
    batAim2Enabled = false,
    batAim2Mode = "normal",
    dropEnabled = false,
    antiPlayerCollision = false,
    hitbuxEnabled = false,
    bodyLockEnabled = false,
    bodyLockRange = 40,
    bypassToggled = false,
    bypassMode = 1,
    bypassSpeed = 55,
    -- Musica toggles individuales
    musicSabanaBlanca = false,
    musicHoraCero = false,
    musicBeretta = false,
    musicNuts = false,
    musicMisery = false,
}

local Config = {}
local SaveCooldown = false

local function LoadConfig()
    if isfile and isfile(FileName) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(FileName)) end)
        if ok and type(data) == "table" then
            for key, value in pairs(DefaultConfig) do
                Config[key] = data[key] ~= nil and data[key] or value
            end
        else
            Config = table.clone(DefaultConfig)
        end
    else
        Config = table.clone(DefaultConfig)
    end
end

local function SaveConfig()
    pcall(function() writefile(FileName, HttpService:JSONEncode(Config)) end)
end

local function AutoSave()
    if SaveCooldown then return end
    SaveCooldown = true
    task.delay(1, function() SaveConfig(); SaveCooldown = false end)
end

local function SetSetting(key, value)
    if Config[key] == value then return end
    Config[key] = value
    AutoSave()
end

LoadConfig()

local State = {
    normalSpeed      = Config.normalSpeed,
    carrySpeed       = Config.carrySpeed,
    laggerSpeed1     = Config.laggerSpeed1,
    laggerSpeed2     = Config.laggerSpeed2,
    laggerLevel      = Config.laggerLevel,
    normalSpeed2     = Config.normalSpeed2,
    carrySpeed2      = Config.carrySpeed2,
    normalSpeed3     = Config.normalSpeed3,
    carrySpeed3      = Config.carrySpeed3,
    useThirdSpeedSet = Config.useThirdSpeedSet or false,
    speedType        = Config.speedType,
    autoCarryEnabled = Config.autoCarryEnabled or false,
    autoBatToggled   = Config.autoBatToggled,
    infJumpEnabled   = Config.infJumpEnabled,
    infJumpMode      = Config.infJumpMode,
    antiRagdollV1Enabled = Config.antiRagdollV1Enabled or false,
    antiRagdollV2Enabled = Config.antiRagdollV2Enabled or false,
    antiRagdollActiveVersion = Config.antiRagdollActiveVersion or 0,
    fpsBoostEnabled  = Config.fpsBoostEnabled,
    guiVisible       = true,
    medusaLastUsed   = 0, medusaDebounce = false,
    medusaCounterEnabled = Config.medusaCounterEnabled,
    dropBrainrotActive = false,
    autoTpDownEnabled = Config.autoTpDownEnabled,
    autoTpDownY      = Config.autoTpDownY,
    autoLeftEnabled  = false,
    autoRightEnabled = false,
    autoLeftPhase    = 1, autoRightPhase = 1,
    lastMoveDir      = Vector3.zero,
    animEnabled      = Config.animEnabled,
    unwalkEnabled    = Config.unwalkEnabled,
    _tpInProgress    = false,
    keyAutoLeft  = Enum.KeyCode[Config.keyAutoLeft] or Enum.KeyCode.Unknown,
    keyAutoRight = Enum.KeyCode[Config.keyAutoRight] or Enum.KeyCode.Unknown,
    keyDropBR    = Enum.KeyCode[Config.keyDropBR] or Enum.KeyCode.Unknown,
    keyTpDown    = Enum.KeyCode[Config.keyTpDown] or Enum.KeyCode.Unknown,
    keyAutoBat   = Enum.KeyCode[Config.keyAutoBat] or Enum.KeyCode.Unknown,
    keySpeedToggle = Enum.KeyCode[Config.keySpeedToggle] or Enum.KeyCode.Unknown,
    keyAutoTpDown = Enum.KeyCode[Config.keyAutoTpDown] or Enum.KeyCode.Unknown,
    keyInstaReset = Enum.KeyCode[Config.keyInstaReset] or Enum.KeyCode.Unknown,
    keySpeed2 = Enum.KeyCode[Config.keySpeed2] or Enum.KeyCode.Unknown,
    keySpeed3 = Enum.KeyCode[Config.keySpeed3] or Enum.KeyCode.Unknown,
    keyLagger = Enum.KeyCode[Config.keyLagger] or Enum.KeyCode.Unknown,
    keyBatAim2 = Enum.KeyCode[Config.keyBatAim2] or Enum.KeyCode.Unknown,
    keyTpBat = Enum.KeyCode[Config.keyTpBat] or Enum.KeyCode.Unknown,
    skyEnabled = Config.skyEnabled,
    skyColorIndex = Config.skyColorIndex,
    stretchRezEnabled = Config.stretchRezEnabled,
    batCounterEnabled = Config.batCounterEnabled,
    batCounterDebounce = false,
    waypointESPEnabled = Config.waypointESPEnabled,
    controllerEnabled = Config.controllerEnabled,
    controllerBinds = Config.controllerBinds,
    guiLocked = Config.guiLocked,
    mobileLocked = Config.mobileLocked,
    antiPlayerCollision = Config.antiPlayerCollision or false,
    useSecondSpeedSet = Config.useSecondSpeedSet or false,
    aimbot2Speed = Config.aimbot2Speed or 45,
    medusaResetEnabled = Config.medusaResetEnabled,
    hitbuxEnabled = Config.hitbuxEnabled or false,
    bodyLockEnabled = Config.bodyLockEnabled or false,
    bodyLockRange = Config.bodyLockRange or 40,
    bypassToggled = Config.bypassToggled or false,
    bypassMode = Config.bypassMode or 1,
    bypassSpeed = Config.bypassSpeed or 55,
    -- Music toggles
    musicSabanaBlanca = Config.musicSabanaBlanca or false,
    musicHoraCero = Config.musicHoraCero or false,
    musicBeretta = Config.musicBeretta or false,
    musicNuts = Config.musicNuts or false,
    musicMisery = Config.musicMisery or false,
}

STEAL_RADIUS = Config.grabRadius or 80
STEAL_DURATION = Config.stealDuration or 2.6

-- ============================================================
-- SISTEMA DE MÚSICA (TOGGLES INDIVIDUALES)
-- ============================================================

local CoreGui = game:GetService("CoreGui")
local starterGui = game:GetService("StarterGui")

local function getAssetFunction()
    local assetFunc = getcustomasset or getsynasset
    if type(assetFunc) ~= "function" then
        pcall(function()
            if getgenv then
                local env = getgenv()
                if env and type(env.getcustomasset) == "function" then assetFunc = env.getcustomasset end
            end
        end)
    end
    return assetFunc
end

local function fileExists(path)
    local exists = false
    pcall(function() exists = isfile(path) == true end)
    return exists
end

local function downloadFile(url, path)
    local writer = writefile
    if type(writer) ~= "function" then
        pcall(function()
            if getgenv then
                local env = getgenv()
                if env and type(env.writefile) == "function" then writer = env.writefile end
            end
        end)
    end
    if type(writer) ~= "function" then
        return false, "writefile no disponible"
    end

    local requestFunction = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)
    local data

    if type(requestFunction) == "function" then
        local ok, response = pcall(requestFunction, {
            Url = url,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
                ["Accept"] = "audio/mpeg,audio/*;q=0.9,*/*;q=0.8"
            }
        })
        if ok and type(response) == "table" then
            local body = response.Body or response.body
            if body and type(body) == "string" and #body > 2048 then
                data = body
            end
        end
    end

    if not data then
        local ok, result = pcall(function()
            return game:HttpGet(url, true)
        end)
        if ok and type(result) == "string" and #result > 2048 then
            data = result
        end
    end

    if not data then
        return false, "No se pudo descargar el archivo"
    end

    local ok, err = pcall(writer, path, data)
    if not ok then return false, tostring(err) end
    return true
end

local musicSounds = {}
local musicSettters = {}

local function createMusicToggle(songKey, displayName, url, fileName, configKey)
    local sound = nil
    local isPlaying = false
    local assetId = nil

    local function getSoundPath()
        return fileName
    end

    local function ensureSound()
        if sound and sound.Parent then
            return true
        end

        local assetFunc = getAssetFunction()
        if type(assetFunc) ~= "function" then
            return false
        end

        if not fileExists(fileName) then
            return false
        end

        local ok, asset = pcall(assetFunc, fileName)
        if not ok or type(asset) ~= "string" or asset == "" then
            return false
        end

        assetId = asset
        sound = Instance.new("Sound")
        sound.Name = "NOXTRIX_" .. songKey
        sound.SoundId = asset
        sound.Looped = true
        sound.Volume = 1
        sound.Parent = CoreGui or game:GetService("SoundService") or workspace
        return true
    end

    local function play()
        if isPlaying then return end
        if not ensureSound() then
            task.spawn(function()
                if not fileExists(fileName) then
                    downloadFile(url, fileName)
                end
                if ensureSound() and sound then
                    pcall(function() sound:Play() end)
                    isPlaying = true
                end
            end)
            return
        end
        if sound then
            pcall(function() sound:Play() end)
            isPlaying = true
        end
    end

    local function stop()
        if sound then
            pcall(function() sound:Stop() end)
        end
        isPlaying = false
    end

    local function toggle(on)
        if on then
            -- Detener todas las demás canciones
            for key, s in pairs(musicSounds) do
                if key ~= songKey and s.isPlaying then
                    s.stop()
                    if musicSettters[key] then
                        musicSettters[key](false)
                    end
                end
            end
            play()
        else
            stop()
        end
    end

    musicSounds[songKey] = {
        play = play,
        stop = stop,
        toggle = toggle,
        isPlaying = function() return isPlaying end,
        sound = function() return sound end,
    }

    return musicSounds[songKey]
end

-- ============================================================
-- DEFINICIÓN DE LAS 5 CANCIONES
-- ============================================================
local SONG_LIST = {
    {
        key = "SabanaBlanca",
        display = "Sábanas blancas",
        url = "https://files.catbox.moe/53obn8.mp3",
        fileName = "NOXTRIX_SabanaBlanca.mp3",
        configKey = "musicSabanaBlanca"
    },
    {
        key = "HoraCero",
        display = "Hora cero",
        url = "https://files.catbox.moe/y167x9.mp3",
        fileName = "NOXTRIX_HoraCero.mp3",
        configKey = "musicHoraCero"
    },
    {
        key = "Beretta",
        display = "Beretta",
        url = "https://files.catbox.moe/hjeh0w.mp3",
        fileName = "NOXTRIX_Beretta.mp3",
        configKey = "musicBeretta"
    },
    {
        key = "Nuts",
        display = "Nuts",
        url = "https://files.catbox.moe/3z4qw1.mp3",
        fileName = "NOXTRIX_Nuts.mp3",
        configKey = "musicNuts"
    },
    {
        key = "Misery",
        display = "Misery",
        url = "https://files.catbox.moe/dozymx.mp3",
        fileName = "NOXTRIX_Misery.mp3",
        configKey = "musicMisery"
    },
}

-- Inicializar cada canción con su estado guardado
for _, song in ipairs(SONG_LIST) do
    local musicObj = createMusicToggle(
        song.key,
        song.display,
        song.url,
        song.fileName,
        song.configKey
    )

    -- Si estaba activa en la configuración, reproducirla
    local wasOn = Config[song.configKey] == true
    if wasOn then
        task.spawn(function()
            task.wait(0.2)
            musicObj.toggle(true)
            if musicSettters[song.key] then
                musicSettters[song.key](true)
            end
        end)
    end
end

-- ============================================================
-- FUNCIONES DE UTILIDAD PARA LA GUI
-- ============================================================

local function activateAntiDie(char)
    char = char or LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then
        hum = char:WaitForChild("Humanoid", 5)
    end
    if not hum then return end

    pcall(function()
        hum.BreakJointsOnDeath = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)

    if hum:GetAttribute("KzAntiDieHooked") then return end
    hum:SetAttribute("KzAntiDieHooked", true)

    hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health <= 0 then
            pcall(function() hum.Health = hum.MaxHealth end)
        end
    end)

    hum.Died:Connect(function()
        task.wait()
        pcall(function()
            local newHum = Instance.new("Humanoid")
            newHum.Name = "ReplacedHumanoid"
            newHum.Parent = char
            if workspace.CurrentCamera then
                workspace.CurrentCamera.CameraSubject = newHum
            end
            if hum and hum.Parent then hum:Destroy() end
            task.defer(function()
                activateAntiDie(char)
            end)
        end)
    end)
end

task.spawn(function()
    if LP.Character then
        activateAntiDie(LP.Character)
    end
end)
LP.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    activateAntiDie(char)
end)

-- ============================================================
-- RESTO DEL SCRIPT (funcionalidades originales)
-- ============================================================

local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"

pcall(function()
    if hookfunction and newcclosure then
        local oldFire
        oldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
            if not cursedResetRemote and typeof(self) == "Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3) == "RE/" then
                cursedResetRemote = self
            end
            return oldFire(self, ...)
        end))
    end
end)

task.spawn(function()
    task.wait(2)
    if cursedResetRemote then return end
    for _, desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then
            cursedResetRemote = desc
            break
        end
    end
end)

function cursedInstaReset()
    if not cursedResetRemote then
        for _, desc in ipairs(game:GetDescendants()) do
            if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then
                cursedResetRemote = desc
                break
            end
        end
    end
    if not cursedResetRemote then return end

    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid and humanoid.Health <= 0 then
        pcall(function()
            cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon")
        end)
        return
    end

    local resetDetected = false
    local conns = {}

    if humanoid then
        table.insert(conns, humanoid.Died:Connect(function()
            resetDetected = true
        end))
        table.insert(conns, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= 0 then resetDetected = true end
        end))
    end
    if character then
        table.insert(conns, character.AncestryChanged:Connect(function(_, parent)
            if not parent then resetDetected = true end
        end))
    end

    task.spawn(function()
        for _ = 1, 50 do
            if resetDetected then break end
            pcall(function()
                cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon")
            end)
            task.wait()
        end
        for _, conn in ipairs(conns) do
            pcall(function() conn:Disconnect() end)
        end
    end)
end

local Hitbux = {}
local HITBUX_COLOR = Color3.fromRGB(0, 180, 255)
local hitbuxRenderConn = nil
local hitbuxData = {}

local function applyGlowToCharacter(player, char)
    if not char then return end
    if not hitbuxData[player] then return end
    if hitbuxData[player].Glow then
        pcall(function() hitbuxData[player].Glow:Destroy() end)
        hitbuxData[player].Glow = nil
    end
    task.wait(0.2)
    local glow = Instance.new("Highlight")
    glow.Name = "HitbuxGlow"
    glow.FillColor = HITBUX_COLOR
    glow.FillTransparency = 0.35
    glow.OutlineColor = HITBUX_COLOR
    glow.OutlineTransparency = 0.1
    glow.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    glow.Adornee = char
    glow.Parent = char
    hitbuxData[player].Glow = glow
end

local function setupPlayerHitbux(player)
    if player == LP then return end
    if hitbuxData[player] then return end
    local line = Drawing.new("Line")
    line.Color = HITBUX_COLOR
    line.Thickness = 1.5
    line.Transparency = 0.7
    line.Visible = false
    hitbuxData[player] = { Line = line, Glow = nil }
    if player.Character then
        applyGlowToCharacter(player, player.Character)
    end
    player.CharacterAdded:Connect(function(char)
        applyGlowToCharacter(player, char)
    end)
end

local function startHitbux()
    if hitbuxRenderConn then return end
    for _, v in ipairs(Players:GetPlayers()) do
        setupPlayerHitbux(v)
    end
    Players.PlayerAdded:Connect(setupPlayerHitbux)
    Players.PlayerRemoving:Connect(function(player)
        if hitbuxData[player] then
            if hitbuxData[player].Line then
                pcall(function() hitbuxData[player].Line:Remove() end)
            end
            if hitbuxData[player].Glow then
                pcall(function() hitbuxData[player].Glow:Destroy() end)
            end
            hitbuxData[player] = nil
        end
    end)
    hitbuxRenderConn = RunService.RenderStepped:Connect(function()
        local myChar = LP.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then
            for _, data in pairs(hitbuxData) do
                if data.Line then data.Line.Visible = false end
            end
            return
        end
        local myPos, visible1 = workspace.CurrentCamera:WorldToViewportPoint(myHrp.Position)
        if not visible1 then
            for _, data in pairs(hitbuxData) do
                if data.Line then data.Line.Visible = false end
            end
            return
        end
        for player, data in pairs(hitbuxData) do
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local targetPos, visible2 = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                if visible2 then
                    data.Line.Visible = true
                    data.Line.From = Vector2.new(myPos.X, myPos.Y)
                    data.Line.To = Vector2.new(targetPos.X, targetPos.Y)
                else
                    data.Line.Visible = false
                end
            else
                data.Line.Visible = false
            end
        end
    end)
end

local function stopHitbux()
    if hitbuxRenderConn then
        hitbuxRenderConn:Disconnect()
        hitbuxRenderConn = nil
    end
    for player, data in pairs(hitbuxData) do
        if data.Line then
            pcall(function() data.Line:Remove() end)
        end
        if data.Glow then
            pcall(function() data.Glow:Destroy() end)
        end
    end
    hitbuxData = {}
end

bodyLockEnabled   = false
bodyLockRange     = 40
_bodyLockConn     = nil
bodyLockSetVisual = nil

function _bodyLockGetTarget()
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local closest, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            local ph = p.Character:FindFirstChildOfClass("Humanoid")
            if tr and ph and ph.Health > 0 then
                local d = (hrp.Position - tr.Position).Magnitude
                if d < bestDist then bestDist = d; closest = tr end
            end
        end
    end
    return closest
end

function _bodyLockTick()
    local char = LP.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local hum  = char:FindFirstChildOfClass("Humanoid"); if not hum then return end

    if hum.FloorMaterial == Enum.Material.Air then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end

    local target = _bodyLockGetTarget()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end

    if (target.Position - root.Position).Magnitude > bodyLockRange then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end

    if hum.AutoRotate then hum.AutoRotate = false end

    local vel  = target.AssemblyLinearVelocity
    local pt   = math.clamp(vel.Magnitude / 150, 0.05, 0.2)
    local pred = target.Position + vel * pt
    local toP  = pred - root.Position

    if toP.Magnitude > 0.1 then
        local goalCF = CFrame.lookAt(root.Position, pred)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = math.clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
    end
end

function startBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect() end
    _bodyLockConn = RunService.RenderStepped:Connect(function()
        if not bodyLockEnabled then return end
        _bodyLockTick()
    end)
end

function stopBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect(); _bodyLockConn = nil end
    local c    = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyAngularVelocity = Vector3.zero end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
end

function toggleBodyLock()
    bodyLockEnabled = not bodyLockEnabled
    if bodyLockEnabled then
        startBodyLock()
    else
        stopBodyLock()
    end
    State.bodyLockEnabled = bodyLockEnabled
    SetSetting("bodyLockEnabled", bodyLockEnabled)
    if bodyLockSetVisual then bodyLockSetVisual(bodyLockEnabled) end
end

local antiRagV1Conn = nil
local antiRagV2 = { Connection = nil, ResetCooldown = 0 }

function startAntiRagdollV1()
    if antiRagV1Conn then return end
    antiRagV1Conn = RunService.Heartbeat:Connect(function()
        if not State.antiRagdollV1Enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not (hum and root) then return end
        local s = hum:GetState()
        local ragdolled = (s == Enum.HumanoidStateType.Physics or
                           s == Enum.HumanoidStateType.Ragdoll or
                           s == Enum.HumanoidStateType.FallingDown)
        local endTime = LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then ragdolled = true end
        if ragdolled then
            pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("BallSocketConstraint") or (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                    d:Destroy()
                end
            end
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled == false then obj.Enabled = true end
            end
            if hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Running) end
            workspace.CurrentCamera.CameraSubject = hum
            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

function stopAntiRagdollV1()
    if antiRagV1Conn then
        antiRagV1Conn:Disconnect()
        antiRagV1Conn = nil
    end
end

function startAntiRagdollV2()
    if antiRagV2.Connection then return end
    antiRagV2.Connection = RunService.Heartbeat:Connect(function()
        if not State.antiRagdollV2Enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end

        local state = hum:GetState()
        local now = tick()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            if now - antiRagV2.ResetCooldown > 0.15 then
                antiRagV2.ResetCooldown = now
                pcall(function()
                    if hum:GetState() == Enum.HumanoidStateType.GettingUp then return end
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    root.Velocity = Vector3.zero
                    root.RotVelocity = Vector3.zero
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    for _, obj in ipairs(char:GetDescendants()) do
                        if obj:IsA("Motor6D") then obj.Enabled = true end
                        if obj:IsA("Constraint") then obj.Enabled = true end
                    end
                    workspace.CurrentCamera.CameraSubject = hum
                    local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
                    if PM then
                        local CM = require(PM:FindFirstChild("ControlModule"))
                        if CM then CM:Enable() end
                    end
                    hum.AutoRotate = true
                    hum.PlatformStand = false
                    hum.Sit = false
                end)
            end
        end
    end)
end

function stopAntiRagdollV2()
    if antiRagV2.Connection then
        antiRagV2.Connection:Disconnect()
        antiRagV2.Connection = nil
    end
    antiRagV2.ResetCooldown = 0
end

function setAntiRagdollVersion(version)
    if version == 1 then
        State.antiRagdollV1Enabled = true
        State.antiRagdollV2Enabled = false
        State.antiRagdollActiveVersion = 1
        stopAntiRagdollV2()
        startAntiRagdollV1()
    elseif version == 2 then
        State.antiRagdollV1Enabled = false
        State.antiRagdollV2Enabled = true
        State.antiRagdollActiveVersion = 2
        stopAntiRagdollV1()
        startAntiRagdollV2()
    else
        State.antiRagdollV1Enabled = false
        State.antiRagdollV2Enabled = false
        State.antiRagdollActiveVersion = 0
        stopAntiRagdollV1()
        stopAntiRagdollV2()
    end
    SetSetting("antiRagdollV1Enabled", State.antiRagdollV1Enabled)
    SetSetting("antiRagdollV2Enabled", State.antiRagdollV2Enabled)
    SetSetting("antiRagdollActiveVersion", State.antiRagdollActiveVersion)
end

task.spawn(function()
    if _G.StealBar_Running then return end
    _G.StealBar_Running = true

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")

    local player = Players.LocalPlayer
    local plots = workspace:WaitForChild("Plots")

    local CONFIG = {
        AUTO_STEAL_ENABLED = false,
        HOLD_MIN = 1.3,
        HOLD_MAX = (type(Config.stealDuration) == "number" and Config.stealDuration) or 2.6,
        ENTRY_DELAY = 0.3,
        COOLDOWN = 0.05,
        STEAL_RANGE = 9,
        PRIME_RANGE = (type(Config.grabRadius) == "number" and Config.grabRadius) or 80,
    }

    local AnimalsData = {}
    local syncRemotes = nil
    local plotAnimalSync = {caches = {}, connections = {}}
    local allAnimalsCache = {}
    local PromptMemoryCache = {}
    local InternalStealCache = {}
    local stealConnection = nil

    StealState = {
        active = false,
        startTime = 0,
        phase = "idle",
        label = "",
        lastResult = "",
        lastResultTime = 0,
        totalSteals = 0,
        failedSteals = 0
    }

    local stealBarFrame = nil
    local uiLocked = false
    local progressFill = nil
    local stateLabel = nil
    local stateBadge = nil
    local stateDot = nil
    local pctLbl = nil
    local fillGrad = nil
    local fpsLabel = nil

    local fpsReal = 60
    local msReal = 16
    local frameCount = 0
    local fpsTimer = tick()

    local PALETTE = {
        Background = Color3.fromRGB(16, 16, 22),
        CardBackground = Color3.fromRGB(24, 24, 34),
        BarBackground = Color3.fromRGB(26, 26, 38),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(150, 155, 175),
        Border = Color3.fromRGB(0, 180, 255),
        Idle = Color3.fromRGB(0, 180, 255),
        TargetInRange = Color3.fromRGB(59, 130, 246),
        Stealing = Color3.fromRGB(245, 158, 11),
        Success = Color3.fromRGB(16, 185, 129),
        Failed = Color3.fromRGB(239, 68, 68),
        IdleGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 200))
        }),
        TargetGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(59, 130, 246)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(29, 78, 216))
        }),
        StealGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(245, 158, 11)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 255))
        }),
        SuccessGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 185, 129)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 150, 105))
        }),
        FailedGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(239, 68, 68)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(153, 27, 27))
        })
    }

    local function updateStateUI(stateName, color, gradient)
        if not stateLabel or not stateBadge or not fillGrad or not stateDot then return end
        stateLabel.Text = stateName
        stateLabel.TextColor3 = color
        TweenService:Create(stateBadge, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundColor3 = color
        }):Play()
        TweenService:Create(stateDot, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundColor3 = color
        }):Play()
        fillGrad.Color = gradient
    end

    local function setProgressSmooth(targetPct, duration)
        if not progressFill then return end
        duration = duration or 0.12
        TweenService:Create(progressFill, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(math.clamp(targetPct, 0, 1), 0, 1, 0)
        }):Play()
        if pctLbl then
            pctLbl.Text = math.floor(targetPct * 100) .. "%"
        end
    end

    local function initializeAutoStealSync()
        local ok = pcall(function()
            local Packages = ReplicatedStorage:WaitForChild("Packages", 10)
            local Datas = ReplicatedStorage:WaitForChild("Datas", 10)
            if not Packages or not Datas then return end
            AnimalsData = require(Datas:WaitForChild("Animals"))
            local folder = Packages:WaitForChild("Synchronizer")
            syncRemotes = {
                channelFolder = folder:WaitForChild("Channel"),
                routeRemote = folder:WaitForChild("CommunicationRoute"),
                requestData = folder:FindFirstChild("RequestData")
            }
        end)
        return ok and syncRemotes ~= nil
    end

    local function splitSyncPath(path)
        if typeof(path) == "table" then return path end
        local out = {}
        for part in string.gmatch(tostring(path), "[^%.]+") do
            table.insert(out, tonumber(part) or part)
        end
        return out
    end

    local function resolveSyncPath(path, root)
        local current = root
        local parent = nil
        local key = nil
        for _, part in ipairs(splitSyncPath(path)) do
            parent = current
            key = part
            current = current and current[part] or nil
        end
        return current, parent, key
    end

    local function applyPlotSyncDiff(channelName, packet)
        local cache = plotAnimalSync.caches[channelName]
        if typeof(cache) ~= "table" then return end
        local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
        local current, parent, key = resolveSyncPath(path, cache)
        if action == "Changed" then
            if parent ~= nil then parent[key] = a end
        elseif action == "ArrayInsert" then
            if current ~= nil then table.insert(current, b, a) end
        elseif action == "ArrayRemoved" then
            if current ~= nil then table.remove(current, b) end
        elseif action == "DictionaryInsert" then
            if current ~= nil then current[b] = a end
        elseif action == "DictionaryRemoved" then
            if current ~= nil then current[b] = nil end
        end
    end

    local function attachPlotChannel(remote)
        if not syncRemotes or plotAnimalSync.connections[remote] then return end
        local channelName = tostring(remote.Name)
        if not plots:FindFirstChild(channelName) then return end
        if syncRemotes.requestData and plotAnimalSync.caches[channelName] == nil then
            local ok, data = pcall(function() return syncRemotes.requestData:InvokeServer(channelName) end)
            plotAnimalSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
        elseif plotAnimalSync.caches[channelName] == nil then
            plotAnimalSync.caches[channelName] = {}
        end
        plotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
            for _, packet in ipairs(queue) do
                applyPlotSyncDiff(channelName, packet)
            end
        end)
    end

    local function detachPlotChannel(channelName)
        for remote, conn in pairs(plotAnimalSync.connections) do
            if tostring(remote.Name) == tostring(channelName) then
                conn:Disconnect()
                plotAnimalSync.connections[remote] = nil
                plotAnimalSync.caches[tostring(channelName)] = nil
                break
            end
        end
    end

    local function startAutoStealSync()
        if not initializeAutoStealSync() then return false end
        for _, child in ipairs(syncRemotes.channelFolder:GetChildren()) do
            if child:IsA("RemoteEvent") then attachPlotChannel(child) end
        end
        syncRemotes.channelFolder.ChildAdded:Connect(function(child)
            if child:IsA("RemoteEvent") then attachPlotChannel(child) end
        end)
        syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
            for _, action in ipairs(actions) do
                local kind, channelName = action[1], tostring(action[2])
                if not plots:FindFirstChild(channelName) then continue end
                if kind == "ListenerAdded" then
                    local remote = syncRemotes.channelFolder:FindFirstChild(channelName)
                    if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote) end
                elseif kind == "ListenerRemoved" then
                    detachPlotChannel(channelName)
                end
            end
        end)
        return true
    end

    local function getPlotChannelData(plotName)
        return plotAnimalSync.caches[plotName]
    end

    local function getPlotOwner(plot)
        local sign = plot:FindFirstChild("PlotSign")
        local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
        local label = frame and frame:FindFirstChild("TextLabel")
        if not label or label.Text == "Empty Base" then return nil end
        return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
    end

    local function isMyBaseAnimal(animalData)
        if not animalData or not animalData.plot then return false end
        local plot = plots:FindFirstChild(animalData.plot)
        if not plot then return false end
        return getPlotOwner(plot) == player.DisplayName
    end

    local function getAnimalPosition(animalData)
        local plot = plots:FindFirstChild(animalData.plot)
        if not plot then return nil end
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if not podiums then return nil end
        local podium = podiums:FindFirstChild(animalData.slot)
        if not podium then return nil end
        return podium:GetPivot().Position
    end

    local function findProximityPromptForAnimal(animalData)
        if not animalData then return nil end
        local cached = PromptMemoryCache[animalData.uid]
        if cached and cached.Parent then return cached end
        local plot = plots:FindFirstChild(animalData.plot)
        if not plot then return nil end
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if not podiums then return nil end
        local podium = podiums:FindFirstChild(animalData.slot)
        if not podium then return nil end
        local base = podium:FindFirstChild("Base")
        if not base then return nil end
        local spawn = base:FindFirstChild("Spawn")
        if not spawn then return nil end
        local attach = spawn:FindFirstChild("PromptAttachment")
        if not attach then return nil end
        for _, p in ipairs(attach:GetChildren()) do
            if p:IsA("ProximityPrompt") then
                PromptMemoryCache[animalData.uid] = p
                return p
            end
        end
        return nil
    end

    local function distToAnimal(animalData)
        local character = player.Character
        if not character then return math.huge end
        local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
        if not hrp then return math.huge end
        local pos = getAnimalPosition(animalData)
        if not pos then return math.huge end
        return (hrp.Position - pos).Magnitude
    end

    local function pickClosest()
        local character = player.Character
        if not character then return nil end
        local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
        if not hrp then return nil end
        local best, bestDist = nil, math.huge
        for _, animalData in ipairs(allAnimalsCache) do
            if isMyBaseAnimal(animalData) then continue end
            local pos = getAnimalPosition(animalData)
            if not pos then continue end
            local dist = (hrp.Position - pos).Magnitude
            if dist > CONFIG.PRIME_RANGE then continue end
            if dist < bestDist then
                bestDist = dist
                best = animalData
            end
        end
        return best
    end

    local function buildStealCallbacks(prompt)
        if InternalStealCache[prompt] then return end
        local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
        local ok1, conns1 = false, nil
        if getconnections then ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan) end
        if ok1 and type(conns1) == "table" then
            for _, conn in ipairs(conns1) do
                if type(conn.Function) == "function" then
                    table.insert(data.holdCallbacks, conn.Function)
                end
            end
        end
        local ok2, conns2 = false, nil
        if getconnections then ok2, conns2 = pcall(getconnections, prompt.Triggered) end
        if ok2 and type(conns2) == "table" then
            for _, conn in ipairs(conns2) do
                if type(conn.Function) == "function" then
                    table.insert(data.triggerCallbacks, conn.Function)
                end
            end
        end
        if (#data.holdCallbacks > 0) or (#data.triggerCallbacks > 0) then
            InternalStealCache[prompt] = data
        end
    end

    local function executeStealAsync(prompt, animalData)
        local data = InternalStealCache[prompt]
        if not data or not data.ready then return false end
        data.ready = false
        local label = animalData.name or "Animal"
        StealState.active = true
        StealState.startTime = tick()
        StealState.phase = "stealing"
        StealState.label = label
        updateStateUI("STEALING", PALETTE.Stealing, PALETTE.StealGrad)

        task.spawn(function()
            for _, fn in ipairs(data.holdCallbacks) do
                task.spawn(fn)
            end
            task.wait(CONFIG.HOLD_MIN)
            StealState.phase = "waitingRange"

            local alreadyInRange = distToAnimal(animalData) <= CONFIG.STEAL_RANGE
            local fired = false
            while true do
                local elapsed = tick() - StealState.startTime
                if elapsed > CONFIG.HOLD_MAX then break end
                if not prompt.Parent then break end
                if distToAnimal(animalData) <= CONFIG.STEAL_RANGE then
                    if not alreadyInRange then task.wait(CONFIG.ENTRY_DELAY) end
                    for _, fn in ipairs(data.triggerCallbacks) do
                        task.spawn(fn)
                    end
                    fired = true
                    break
                end
                task.wait()
            end

            if fired then
                StealState.totalSteals = StealState.totalSteals + 1
                StealState.lastResult = "Stole " .. label
                StealState.phase = "success"
                StealState.lastResultTime = tick()
                updateStateUI("SUCCESS", PALETTE.Success, PALETTE.SuccessGrad)
                setProgressSmooth(1, 0.12)
            else
                StealState.failedSteals = StealState.failedSteals + 1
                StealState.lastResult = "Missed window: " .. label
                StealState.phase = "failed"
                StealState.lastResultTime = tick()
                updateStateUI("FAILED", PALETTE.Failed, PALETTE.FailedGrad)
                setProgressSmooth(1, 0.12)
            end

            StealState.active = false
            task.wait(CONFIG.COOLDOWN)
            data.ready = true

            task.wait(1.5)
            if not StealState.active then
                StealState.phase = "idle"
                updateStateUI("IDLE", PALETTE.Idle, PALETTE.IdleGrad)
                setProgressSmooth(0, 0.2)
            end
        end)
        return true
    end

    local function attemptSteal(prompt, animalData)
        if not prompt or not prompt.Parent then return false end
        buildStealCallbacks(prompt)
        if not InternalStealCache[prompt] then return false end
        return executeStealAsync(prompt, animalData)
    end

    local function scanAllPlots()
        local newCache = {}
        for _, plot in ipairs(plots:GetChildren()) do
            local cache = getPlotChannelData(plot.Name)
            if not cache then continue end
            local animalList = cache.AnimalList
            if typeof(animalList) ~= "table" then continue end
            for slot, animalData in pairs(animalList) do
                if type(animalData) == "table" then
                    local animalName = animalData.Index
                    local animalInfo = AnimalsData[animalName]
                    if not animalInfo then continue end
                    table.insert(newCache, {
                        name = animalInfo.DisplayName or animalName,
                        plot = plot.Name,
                        slot = tostring(slot),
                        uid = plot.Name .. "_" .. tostring(slot)
                    })
                end
            end
        end
        allAnimalsCache = newCache
        return #allAnimalsCache
    end

    local function startAutoSteal()
        if stealConnection then return end
        stealConnection = RunService.Heartbeat:Connect(function()
            if not CONFIG.AUTO_STEAL_ENABLED then return end
            if StealState.active then return end
            local target = pickClosest()
            if not target then return end
            local prompt = PromptMemoryCache[target.uid]
            if not prompt or not prompt.Parent then
                prompt = findProximityPromptForAnimal(target)
            end
            if prompt then
                attemptSteal(prompt, target)
            end
        end)
    end

    local function stopAutoSteal()
        if not stealConnection then return end
        stealConnection:Disconnect()
        stealConnection = nil
        StealState.active = false
        StealState.phase = "idle"
        updateStateUI("IDLE", PALETTE.Idle, PALETTE.IdleGrad)
    end

    local function createStealBar()
        for _, n in ipairs({"CandyHubStealBar", "CandyStealBar"}) do
            local old = CoreGui:FindFirstChild(n)
            if old then old:Destroy() end
            local pgui = player:FindFirstChild("PlayerGui")
            if pgui then
                local o = pgui:FindFirstChild(n)
                if o then o:Destroy() end
            end
        end

        local SB_W, SB_H = 280, 54

        local stealGui = Instance.new("ScreenGui")
        stealGui.Name = "CandyHubStealBar"
        stealGui.ResetOnSpawn = false
        stealGui.IgnoreGuiInset = true
        stealGui.DisplayOrder = 100

        pcall(function()
            if syn and syn.protect_gui then
                syn.protect_gui(stealGui)
            end
        end)

        if not pcall(function()
            stealGui.Parent = CoreGui
        end) then
            stealGui.Parent = player:WaitForChild("PlayerGui")
        end

        stealBarFrame = Instance.new("Frame", stealGui)
        stealBarFrame.Size = UDim2.new(0, SB_W, 0, SB_H)
        stealBarFrame.Position = UDim2.new(0.5, -SB_W / 2, 0.05, 0)
        stealBarFrame.BackgroundColor3 = PALETTE.Background
        stealBarFrame.BackgroundTransparency = 0.05
        stealBarFrame.BorderSizePixel = 0
        stealBarFrame.ZIndex = 20

        Instance.new("UICorner", stealBarFrame).CornerRadius = UDim.new(0, 16)

        local mainStroke = Instance.new("UIStroke", stealBarFrame)
        mainStroke.Thickness = 1
        mainStroke.Color = PALETTE.Border
        mainStroke.Transparency = 0.4

        local topRow = Instance.new("Frame", stealBarFrame)
        topRow.Size = UDim2.new(1, -28, 0, 20)
        topRow.Position = UDim2.new(0, 14, 0, 10)
        topRow.BackgroundTransparency = 1
        topRow.ZIndex = 22

        stateBadge = Instance.new("Frame", topRow)
        stateBadge.Size = UDim2.new(0, 115, 1, 0)
        stateBadge.Position = UDim2.new(0, 0, 0, 0)
        stateBadge.BackgroundColor3 = PALETTE.Idle
        stateBadge.BackgroundTransparency = 0.9
        stateBadge.BorderSizePixel = 0
        stateBadge.ZIndex = 23
        Instance.new("UICorner", stateBadge).CornerRadius = UDim.new(0, 8)

        stateDot = Instance.new("Frame", stateBadge)
        stateDot.Size = UDim2.new(0, 6, 0, 6)
        stateDot.Position = UDim2.new(0, 8, 0.5, -3)
        stateDot.BackgroundColor3 = PALETTE.Idle
        stateDot.BorderSizePixel = 0
        stateDot.ZIndex = 25
        Instance.new("UICorner", stateDot).CornerRadius = UDim.new(1, 0)

        stateLabel = Instance.new("TextLabel", stateBadge)
        stateLabel.Size = UDim2.new(1, -18, 1, 0)
        stateLabel.Position = UDim2.new(0, 18, 0, 0)
        stateLabel.BackgroundTransparency = 1
        stateLabel.Text = "IDLE"
        stateLabel.TextColor3 = PALETTE.Idle
        stateLabel.Font = Enum.Font.GothamBold
        stateLabel.TextSize = 10
        stateLabel.TextXAlignment = Enum.TextXAlignment.Left
        stateLabel.ZIndex = 24

        local fpsBadge = Instance.new("Frame", topRow)
        fpsBadge.Size = UDim2.new(0, 115, 1, 0)
        fpsBadge.Position = UDim2.new(1, -115, 0, 0)
        fpsBadge.BackgroundColor3 = PALETTE.CardBackground
        fpsBadge.BackgroundTransparency = 0.5
        fpsBadge.BorderSizePixel = 0
        fpsBadge.ZIndex = 23
        Instance.new("UICorner", fpsBadge).CornerRadius = UDim.new(0, 8)

        fpsLabel = Instance.new("TextLabel", fpsBadge)
        fpsLabel.Size = UDim2.new(1, 0, 1, 0)
        fpsLabel.BackgroundTransparency = 1
        fpsLabel.Text = "60 FPS • 16 ms"
        fpsLabel.TextColor3 = PALETTE.TextMuted
        fpsLabel.Font = Enum.Font.GothamMedium
        fpsLabel.TextSize = 10
        fpsLabel.ZIndex = 24

        local barTrack = Instance.new("Frame", stealBarFrame)
        barTrack.Size = UDim2.new(1, -28, 0, 22)
        barTrack.Position = UDim2.new(0, 14, 1, -30)
        barTrack.BackgroundColor3 = PALETTE.BarBackground
        barTrack.BorderSizePixel = 0
        barTrack.ZIndex = 22
        barTrack.ClipsDescendants = true
        Instance.new("UICorner", barTrack).CornerRadius = UDim.new(0, 10)

        progressFill = Instance.new("Frame", barTrack)
        progressFill.Size = UDim2.new(0, 0, 1, 0)
        progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        progressFill.BorderSizePixel = 0
        progressFill.ZIndex = 23
        Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 10)

        fillGrad = Instance.new("UIGradient", progressFill)
        fillGrad.Color = PALETTE.IdleGrad

        pctLbl = Instance.new("TextLabel", barTrack)
        pctLbl.Size = UDim2.new(1, 0, 1, 0)
        pctLbl.BackgroundTransparency = 1
        pctLbl.Text = "0%"
        pctLbl.TextColor3 = PALETTE.TextPrimary
        pctLbl.Font = Enum.Font.GothamBold
        pctLbl.TextSize = 11
        pctLbl.ZIndex = 25

        RunService.RenderStepped:Connect(function()
            frameCount = frameCount + 1
            if tick() - fpsTimer >= 0.5 then
                local elapsed = tick() - fpsTimer
                fpsReal = math.floor(frameCount / elapsed)
                msReal = math.floor((elapsed / frameCount) * 1000)
                frameCount = 0
                fpsTimer = tick()
                if fpsLabel then
                    fpsLabel.Text = string.format("%d FPS • %d ms", fpsReal, msReal)
                    if fpsReal >= 50 then
                        fpsLabel.TextColor3 = Color3.fromRGB(16, 185, 129)
                    elseif fpsReal >= 30 then
                        fpsLabel.TextColor3 = Color3.fromRGB(245, 158, 11)
                    else
                        fpsLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
                    end
                end
            end
        end)

        task.spawn(function()
            while progressFill and progressFill.Parent do
                local now = tick()
                if StealState.active then
                    local pct = math.clamp((now - StealState.startTime) / CONFIG.HOLD_MAX, 0, 1)
                    progressFill.Size = UDim2.new(pct, 0, 1, 0)
                    pctLbl.Text = math.floor(pct * 100) .. "%"
                elseif StealState.phase == "success" or StealState.phase == "failed" then
                    progressFill.Size = UDim2.new(1, 0, 1, 0)
                    pctLbl.Text = "100%"
                elseif not CONFIG.AUTO_STEAL_ENABLED then

                    progressFill.Size = UDim2.new(0, 0, 1, 0)
                    pctLbl.Text = "0%"
                    if StealState.phase == "idle" then
                        updateStateUI("IDLE", PALETTE.Idle, PALETTE.IdleGrad)
                    end
                else
                    local target = pickClosest()
                    if target then
                        local dist = distToAnimal(target)
                        if dist <= CONFIG.PRIME_RANGE then
                            local denom = math.max(CONFIG.PRIME_RANGE - CONFIG.STEAL_RANGE, 0.01)
                            local rawPct = 1 - ((dist - CONFIG.STEAL_RANGE) / denom)
                            local pct = math.clamp(rawPct, 0.05, 1)
                            progressFill.Size = UDim2.new(pct, 0, 1, 0)
                            pctLbl.Text = math.floor(pct * 100) .. "%"
                            if StealState.phase == "idle" then
                                updateStateUI("IN RANGE", PALETTE.TargetInRange, PALETTE.TargetGrad)
                            end
                        else
                            progressFill.Size = UDim2.new(0, 0, 1, 0)
                            pctLbl.Text = "0%"
                            if StealState.phase == "idle" then
                                updateStateUI("IDLE", PALETTE.Idle, PALETTE.IdleGrad)
                            end
                        end
                    else
                        progressFill.Size = UDim2.new(0, 0, 1, 0)
                        pctLbl.Text = "0%"
                        if StealState.phase == "idle" then
                            updateStateUI("IDLE", PALETTE.Idle, PALETTE.IdleGrad)
                        end
                    end
                end
                task.wait(0.016)
            end
        end)

        stealBarFrame.AncestryChanged:Connect(function(_, parent)
            if not parent then
                task.wait(0.1)
                createStealBar()
            end
        end)

        local dragStart, dragStartPos, dragging = nil, nil, false

        stealBarFrame.InputBegan:Connect(function(input)
            if uiLocked or State.guiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                dragStartPos = stealBarFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if uiLocked or State.guiLocked then
                dragging = false
                return
            end
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                TweenService:Create(stealBarFrame, TweenInfo.new(0.04, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(
                        dragStartPos.X.Scale,
                        dragStartPos.X.Offset + delta.X,
                        dragStartPos.Y.Scale,
                        dragStartPos.Y.Offset + delta.Y
                    )
                }):Play()
            end
        end)


        task.spawn(function()
            while stealBarFrame and stealBarFrame.Parent do
                uiLocked = State.guiLocked == true
                task.wait(0.25)
            end
        end)
    end

    createStealBar()

    task.spawn(function()
        if startAutoStealSync() then
            scanAllPlots()
            while task.wait(5) do
                scanAllPlots()
            end
        end
    end)


    _G.StealBar = {
        start = function()
            CONFIG.AUTO_STEAL_ENABLED = true
            startAutoSteal()
        end,
        stop = function()
            CONFIG.AUTO_STEAL_ENABLED = false
            stopAutoSteal()
        end,
        isStealing = function() return StealState.active end,
        setRadius = function(radius)
            radius = tonumber(radius) or CONFIG.PRIME_RANGE
            CONFIG.PRIME_RANGE = radius
            CONFIG.STEAL_RANGE = math.min(9, math.max(0.5, radius))
            STEAL_RADIUS = radius
        end,
        setHoldMax = function(v)
            v = tonumber(v) or CONFIG.HOLD_MAX
            CONFIG.HOLD_MAX = math.clamp(v, 0.5, 10)
            STEAL_DURATION = CONFIG.HOLD_MAX
        end,
        setEnabled = function(on)
            CONFIG.AUTO_STEAL_ENABLED = on and true or false
            if on then startAutoSteal() else stopAutoSteal() end
        end,
        setLocked = function(locked)
            uiLocked = locked and true or false
        end,
        getConfig = function() return CONFIG end,
    }


    if Config.autoStealEnabled then
        CONFIG.AUTO_STEAL_ENABLED = true
        task.spawn(function()
            task.wait(0.5)
            startAutoSteal()
        end)
    end
end)

local AUTO_BAT_SPEED = 58
local AUTO_BAT_VERT_SPEED = 52
local AUTO_BAT_DIST = -2.8
local AUTO_BAT_HEIGHT = 4.75
local AUTO_BAT_V_OFF = 1
local AUTO_BAT_TURN_SPEED = 285
local AUTO_BAT_MAX_TURN_RATE = 28

local autoBatEnabled = false
local autoSwingEnabled = true
local autoBatEquippedThisRun = false
local _autoBatTarget = nil
local _autoBatLastScan = 0
local aimbotConnection = nil

local BAT_COUNTER_SLAP_LIST = {"Bat", "BaseballBat", "Club", "Stick"}

_G.BatAimbot2 = {}
_G.originalAutoBatStop = nil
_G.originalAutoBatSyncUI = function() end
_G.tpBatToggleSetters = {}
_G.tpBatModeActive = false

local function findBatForCounter()
    local c = LP.Character
    if not c then return nil end
    local bp = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
    for _, ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
    end
    if bp then
        for _, ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
        end
    end
    return nil
end

local function swingBatForCounter(bat, char)
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= char then
        if hum2 then pcall(function() hum2:EquipTool(bat) end) end
        task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        task.wait(0.15)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.15)
        pcall(function() bat:Activate() end)
    end
end

local AutoStealEnabled = Config.autoStealEnabled or false
local setInstaGrab
local function setAutoStealEnabled(on)
    AutoStealEnabled = on
    Config.autoStealEnabled = on
    AutoSave()
    if on then
        if _G.StealBar then _G.StealBar.start() end
    else
        if _G.StealBar then _G.StealBar.stop() end
    end
    if setInstaGrab then setInstaGrab(on) end
end

local _isStealingAttr = false
pcall(function()
    LP:GetAttributeChangedSignal("Stealing"):Connect(function()
        _isStealingAttr = (LP:GetAttribute("Stealing") == true)
    end)
    task.spawn(function()
        task.wait(1)
        _isStealingAttr = (LP:GetAttribute("Stealing") == true)
    end)
end)

local function isPlayerStealing()
    return _isStealingAttr or (LP:GetAttribute("Stealing") == true)
end



local _pausedBySteal = {
    autoLeft = false,
    autoRight = false,
    batV2 = false,
    tpBat = false,
    autoBat = false,
}
pcall(function()
    LP:GetAttributeChangedSignal("Stealing"):Connect(function()
        local stealing = (LP:GetAttribute("Stealing") == true)
        _isStealingAttr = stealing
        if stealing then
            if State.autoLeftEnabled or (Conns and Conns.autoLeft) then
                _pausedBySteal.autoLeft = true
                pcall(function()
                    if Conns and Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end
                end)
            end
            if State.autoRightEnabled or (Conns and Conns.autoRight) then
                _pausedBySteal.autoRight = true
                pcall(function()
                    if Conns and Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end
                end)
            end
            pcall(function()
                if _G.BatAimbot2 and _G.BatAimbot2.isActive and _G.BatAimbot2.isActive() then
                    _pausedBySteal.batV2 = true
                    _G.BatAimbot2.stop()
                end
            end)
            pcall(function()
                if _G.tpBatModeActive then
                    _pausedBySteal.tpBat = true
                    if _G.stopTpBat then _G.stopTpBat() end
                end
            end)
            if autoBatEnabled then
                _pausedBySteal.autoBat = true
                pcall(function() if stopBatAimbot then stopBatAimbot() end end)
            end
        else
            task.defer(function()
                task.wait(0.1)
                if isPlayerStealing() then return end
                if (_pausedBySteal.autoLeft or State.autoLeftEnabled) and State.autoLeftEnabled then
                    _pausedBySteal.autoLeft = false
                    pcall(function()
                        local fn = _G._startAutoLeft or startAutoLeft
                        if fn then fn() end
                    end)
                    pcall(function() if setAutoLeft then setAutoLeft(true) end end)
                    pcall(function() if setMB_AL then setMB_AL(true) end end)
                end
                if (_pausedBySteal.autoRight or State.autoRightEnabled) and State.autoRightEnabled then
                    _pausedBySteal.autoRight = false
                    pcall(function()
                        local fn = _G._startAutoRight or startAutoRight
                        if fn then fn() end
                    end)
                    pcall(function() if setAutoRight then setAutoRight(true) end end)
                    pcall(function() if setMB_AR then setMB_AR(true) end end)
                end
                if _pausedBySteal.batV2 then
                    _pausedBySteal.batV2 = false
                    pcall(function() if _G.BatAimbot2 and _G.BatAimbot2.start then _G.BatAimbot2.start() end end)
                end
                if _pausedBySteal.tpBat then
                    _pausedBySteal.tpBat = false
                    pcall(function() if _G.setTpBatMode then _G.setTpBatMode(true) end end)
                end
                if _pausedBySteal.autoBat then
                    _pausedBySteal.autoBat = false
                    pcall(function() if startBatAimbot then startBatAimbot() end end)
                end
            end)
        end
    end)
end)

local function getCurrentSpeed()
    if State.laggerLevel > 0 then
        if State.laggerLevel == 1 then
            return State.laggerSpeed1
        else
            return State.laggerSpeed2
        end
    else
        local useCarry = false
        if State.autoCarryEnabled then
            useCarry = isPlayerStealing()
        else
            useCarry = (State.speedType == "carry")
        end
        if State.useThirdSpeedSet then
            return useCarry and State.carrySpeed3 or State.normalSpeed3
        elseif State.useSecondSpeedSet then
            return useCarry and State.carrySpeed2 or State.normalSpeed2
        else
            return useCarry and State.carrySpeed or State.normalSpeed
        end
    end
end

local function getAdjustedSpeed(visual)
    local isStealing = isPlayerStealing()
    if isStealing then
        if visual >= 20 then
            return visual + 4
        else
            return visual - 4
        end
    else
        if visual >= 34 then
            return visual + 4
        else
            return visual - 4
        end
    end
end

local function getOrCreateSpeedVectorForce(root)
    if not root or not root.Parent then return nil end
    local att = root:FindFirstChild("SpeedAttachment")
    if not att then
        att = Instance.new("Attachment")
        att.Name = "SpeedAttachment"
        att.Parent = root
    end
    local vf = root:FindFirstChild("SpeedVectorForce")
    if not vf then
        vf = Instance.new("VectorForce")
        vf.Name = "SpeedVectorForce"
        vf.Attachment0 = att
        vf.RelativeTo = Enum.ActuatorRelativeTo.World
        vf.ApplyAtCenterOfMass = true
        vf.Enabled = false
        vf.Force = Vector3.zero
        vf.Parent = root
    end
    return vf
end

local function clearSpeedVectorForce(root)
    if not root then return end
    local vf = root:FindFirstChild("SpeedVectorForce")
    if vf then
        vf.Force = Vector3.zero
        vf.Enabled = false
    end
end

local function getAutoMoveSpeed()
    if State.useThirdSpeedSet then
        return State.normalSpeed3
    elseif State.useSecondSpeedSet then
        return State.normalSpeed2
    else
        return State.normalSpeed
    end
end

local function getOrCreateLinearVelocity(root)
    if not root or not root.Parent then return nil end
    local att = root:FindFirstChild("RootAttachment")
    if not att then
        att = Instance.new("Attachment")
        att.Name = "RootAttachment"
        att.Parent = root
    end
    local lv = root:FindFirstChild("KzLinearVelocity")
    if not lv then
        lv = Instance.new("LinearVelocity")
        lv.Name = "KzLinearVelocity"
        lv.Attachment0 = att
        lv.MaxForce = 1e9
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.ForceLimitsEnabled = false
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        lv.Parent = root
    end
    return lv
end

local function setLinearVelocity(root, vel)
    local lv = getOrCreateLinearVelocity(root)
    if lv then
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        lv.VectorVelocity = vel
        lv.Enabled = true
    end
end

local LOOK_POWER = 55
local LOOK_MAX_ANG_VEL = 12
local LOOK_DEADZONE = 0.08
local function lookAtWithLinearVelocity(root, targetPos, moveSpeed)
    if not root or not targetPos then return end
    local char = root.Parent
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local delta = targetPos - root.Position
    local flat = Vector3.new(delta.X, 0, delta.Z)
    if flat.Magnitude < 0.15 then
        root.AssemblyAngularVelocity = Vector3.new(0, root.AssemblyAngularVelocity.Y * 0.5, 0)
        return
    end
    local direction = flat.Unit
    if hum then hum.AutoRotate = false end

    local targetYaw = math.atan2(direction.X, direction.Z)
    local look = root.CFrame.LookVector
    local currentYaw = math.atan2(look.X, look.Z)

    local angleDiff = targetYaw - currentYaw
    if angleDiff > math.pi then angleDiff = angleDiff - (math.pi * 2) end
    if angleDiff < -math.pi then angleDiff = angleDiff + (math.pi * 2) end

    if math.abs(angleDiff) < LOOK_DEADZONE then
        local curY = root.AssemblyAngularVelocity.Y
        root.AssemblyAngularVelocity = Vector3.new(0, curY * 0.35, 0)
        return
    end

    local angVel = angleDiff * LOOK_POWER
    if angVel > LOOK_MAX_ANG_VEL then angVel = LOOK_MAX_ANG_VEL end
    if angVel < -LOOK_MAX_ANG_VEL then angVel = -LOOK_MAX_ANG_VEL end

    local blended = root.AssemblyAngularVelocity.Y * 0.25 + angVel * 0.75
    root.AssemblyAngularVelocity = Vector3.new(0, blended, 0)
end

local function clearLookRotation(root)
    if not root then return end
    root.AssemblyAngularVelocity = Vector3.zero
    local hum = root.Parent and root.Parent:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
end

local function setLinearVelocityXZ(root, x, z)
    if not root then return end
    pcall(function() clearSpeedVectorForce(root) end)
    local lv = getOrCreateLinearVelocity(root)
    if not lv then return end
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    lv.PrimaryTangentAxis = Vector3.new(1, 0, 0)
    lv.SecondaryTangentAxis = Vector3.new(0, 0, 1)
    lv.PlaneVelocity = Vector2.new(x, z)
    lv.Enabled = true
end

local function clearLinearVelocity(root)
    if not root then return end
    local lv = root:FindFirstChild("KzLinearVelocity")
    if lv then
        pcall(function()
            lv.Enabled = false
            lv.VectorVelocity = Vector3.zero
            if lv.VelocityConstraintMode == Enum.VelocityConstraintMode.Plane then
                lv.PlaneVelocity = Vector2.zero
            end
        end)
    end
end

local function hardStopMovement(root, hum)
    if root then
        pcall(function() clearLinearVelocity(root) end)
        pcall(function() clearSpeedVectorForce(root) end)
        pcall(function()
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    end
    if hum then
        pcall(function()
            hum:Move(Vector3.zero, false)
            if not autoBatEnabled
                and not (_G.BatAimbot2 and _G.BatAimbot2.isActive and _G.BatAimbot2.isActive())
                and not _G.tpBatModeActive then
                hum.AutoRotate = true
            end
        end)
    end
    State.lastMoveDir = Vector3.zero
end

local function isRagdolledState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
        or st == Enum.HumanoidStateType.GettingUp
        or hum.PlatformStand == true
        or hum.Health <= 0
end

setFloat = function() end
State.dropEnabled = false
local dropConns = {}

function toggleDropGlitch(state)
    if state then
        State.dropEnabled = true

        if #dropConns == 0 then
            local colConn = RunService.Stepped:Connect(function()
                if not State.dropEnabled then return end
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then
                        for _, part in ipairs(p.Character:GetChildren()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end
                    end
                end
            end)
            table.insert(dropConns, colConn)

            task.spawn(function()
                while State.dropEnabled do
                    RunService.Heartbeat:Wait()
                    local c = LP.Character
                    local root = c and c:FindFirstChild("HumanoidRootPart")
                    if not root then continue end
                    local vel = root.Velocity
                    root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                    RunService.RenderStepped:Wait()
                    if root and root.Parent then root.Velocity = vel end
                    RunService.Stepped:Wait()
                    if root and root.Parent then root.Velocity = vel + Vector3.new(0, 0.1, 0) end
                end
            end)
        end
    else
        State.dropEnabled = false
        for _, c in ipairs(dropConns) do
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end
        dropConns = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
        local c = LP.Character
        local root = c and c:FindFirstChild("HumanoidRootPart")
        if root then root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z) end
    end
end

local dropBurstCooldown = false
function runDropBrainrot()
    if dropBurstCooldown then return end
    dropBurstCooldown = true
    task.spawn(function()
        local character = LP.Character
        if not character then
            dropBurstCooldown = false
            return
        end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            dropBurstCooldown = false
            return
        end
        local totalMass = 0
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                totalMass = totalMass + part:GetMass()
            end
        end
        if totalMass <= 0 then totalMass = 1 end
        local attachment = Instance.new("Attachment")
        attachment.Parent = hrp
        local vectorForce = Instance.new("VectorForce")
        vectorForce.Attachment0 = attachment
        vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
        local fuerzaSubida = totalMass * (workspace.Gravity + 3000)
        vectorForce.Force = Vector3.new(0, fuerzaSubida, 0)
        vectorForce.Parent = hrp
        task.wait(0.15)
        if vectorForce and vectorForce.Parent then vectorForce:Destroy() end
        if attachment and attachment.Parent then attachment:Destroy() end
        if hrp and hrp.Parent then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {character}
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            local resultadoRaycast = workspace:Raycast(hrp.Position, Vector3.new(0, -1000, 0), raycastParams)
            if resultadoRaycast then
                hrp.CFrame = CFrame.new(resultadoRaycast.Position + Vector3.new(0, 3, 0))
                hrp.Velocity = Vector3.zero
            end
        end
        task.wait(0.15)
        dropBurstCooldown = false
    end)
end

function syncDropButtons()
end

local POS = {
    L1 = Vector3.new(-476.48,-6.28,92.73), L2 = Vector3.new(-483.12,-4.95,94.80),
    R1 = Vector3.new(-476.16,-6.52,25.62), R2 = Vector3.new(-483.04,-5.09,23.14),
}
local AP_L_FACE = Vector3.new(-482.25,-4.96,92.09)
local AP_R_FACE = Vector3.new(-482.06,-6.93,35.47)

local Conns = { autoSteal=nil, antiRag=nil, autoLeft=nil, autoRight=nil, anchor={}, float=nil, batCounter=nil, fpsBoostMonitor=nil }
local h, hrp, speedLbl
local setMB_AL, setMB_AR, setMB_AB, setMB_CS, setMB_LC, setMB_BR, setMB_TD, setMB_AT
local dropRowSetters = {}
local floatingBtnRefs = {}
local mbButtonFrames = {}
local mbGroup, QW, QH
local setAutoBat, setAutoLeft, setAutoRight, setAutoTpDown
local modeValLbl, normalBox, carryBox, lagger1Box, lagger2Box, progressRadLbl

local stretchRezConn = nil
function enableStretchRez()
    State.stretchRezEnabled = true; workspace.CurrentCamera.FieldOfView = 120
    if stretchRezConn then stretchRezConn:Disconnect() end
    stretchRezConn = RunService.RenderStepped:Connect(function()
        if not State.stretchRezEnabled then stretchRezConn:Disconnect(); stretchRezConn = nil; return end
        workspace.CurrentCamera.FieldOfView = 120
    end)
end
function disableStretchRez()
    State.stretchRezEnabled = false
    if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn = nil end
    workspace.CurrentCamera.FieldOfView = 70
end

local _skyOriginals = nil
local SKY_THEMES = {
    {name="Midnight Abyss", dot=Color3.fromRGB(20,20,50), lt={Brightness=0.35,ClockTime=0.5,Ambient=Color3.fromRGB(25,25,45),OutdoorAmbient=Color3.fromRGB(20,20,40),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=-0.03,Contrast=0.15,Saturation=-0.2,TintColor=Color3.fromRGB(190,195,255)}, atm={Density=0.22,Color=Color3.fromRGB(50,55,90),Decay=Color3.fromRGB(30,35,60),Offset=0.12,Glare=0,Haze=0.5}},
    {name="Violet",         dot=Color3.fromRGB(120,40,200), lt={Brightness=0.6,ClockTime=19.5,Ambient=Color3.fromRGB(55,15,90),OutdoorAmbient=Color3.fromRGB(45,12,80),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=-0.05,Contrast=0.25,Saturation=0.6,TintColor=Color3.fromRGB(210,160,255)}, atm={Density=0.35,Color=Color3.fromRGB(100,40,180),Decay=Color3.fromRGB(60,15,120),Offset=0.2,Glare=0.1,Haze=1}},
    {name="Blue",           dot=Color3.fromRGB(40,120,220), lt={Brightness=2.5,ClockTime=12,Ambient=Color3.fromRGB(100,140,200),OutdoorAmbient=Color3.fromRGB(120,160,220),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=0.05,Contrast=0.1,Saturation=0.5,TintColor=Color3.fromRGB(160,200,255)}, atm={Density=0.2,Color=Color3.fromRGB(80,160,255),Decay=Color3.fromRGB(40,100,200),Offset=0.05,Glare=0.5,Haze=2}},
    {name="Red",            dot=Color3.fromRGB(180,20,20), lt={Brightness=0.4,ClockTime=22,Ambient=Color3.fromRGB(80,8,8),OutdoorAmbient=Color3.fromRGB(70,5,5),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=-0.1,Contrast=0.35,Saturation=0.8,TintColor=Color3.fromRGB(255,140,130)}, atm={Density=0.45,Color=Color3.fromRGB(180,30,20),Decay=Color3.fromRGB(120,10,10),Offset=0.25,Glare=0.05,Haze=3}},
    {name="Orange",         dot=Color3.fromRGB(230,110,20), lt={Brightness=1.5,ClockTime=18.2,Ambient=Color3.fromRGB(200,90,20),OutdoorAmbient=Color3.fromRGB(220,110,30),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=0.02,Contrast=0.2,Saturation=0.7,TintColor=Color3.fromRGB(255,210,140)}, atm={Density=0.4,Color=Color3.fromRGB(255,140,50),Decay=Color3.fromRGB(200,80,20),Offset=0.3,Glare=0.3,Haze=4}},
    {name="Emerald",        dot=Color3.fromRGB(20,140,60), lt={Brightness=0.3,ClockTime=21,Ambient=Color3.fromRGB(8,55,20),OutdoorAmbient=Color3.fromRGB(6,45,15),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=-0.12,Contrast=0.3,Saturation=0.7,TintColor=Color3.fromRGB(140,255,170)}, atm={Density=0.5,Color=Color3.fromRGB(20,100,40),Decay=Color3.fromRGB(10,60,20),Offset=0.2,Glare=0,Haze=2}},
    {name="Cosmic Void",    dot=Color3.fromRGB(8,8,14), lt={Brightness=0.2,ClockTime=1.2,Ambient=Color3.fromRGB(12,12,20),OutdoorAmbient=Color3.fromRGB(10,10,18),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=-0.05,Contrast=0.3,Saturation=-0.4,TintColor=Color3.fromRGB(210,210,255)}, atm={Density=0.08,Color=Color3.fromRGB(18,20,35),Decay=Color3.fromRGB(12,14,25),Offset=0.03,Glare=0.02,Haze=0.2}},
    {name="Molten Core",    dot=Color3.fromRGB(200,80,10), lt={Brightness=0.8,ClockTime=20.5,Ambient=Color3.fromRGB(120,45,8),OutdoorAmbient=Color3.fromRGB(100,35,5),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=0.0,Contrast=0.4,Saturation=0.9,TintColor=Color3.fromRGB(255,180,100)}, atm={Density=0.55,Color=Color3.fromRGB(200,70,15),Decay=Color3.fromRGB(150,40,5),Offset=0.35,Glare=0.1,Haze=5}},
    {name="Cyber Neon",     dot=Color3.fromRGB(60,60,180), lt={Brightness=0.5,ClockTime=21.5,Ambient=Color3.fromRGB(20,20,80),OutdoorAmbient=Color3.fromRGB(15,15,70),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=-0.05,Contrast=0.3,Saturation=0.8,TintColor=Color3.fromRGB(160,160,255)}, atm={Density=0.3,Color=Color3.fromRGB(50,50,200),Decay=Color3.fromRGB(20,20,140),Offset=0.1,Glare=0.15,Haze=1.5}},
    {name="Galaxy",         dot=Color3.fromRGB(130,60,180), lt={Brightness=1.2,ClockTime=19.8,Ambient=Color3.fromRGB(80,40,120),OutdoorAmbient=Color3.fromRGB(70,35,110),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=0.08,Contrast=0.2,Saturation=0.6,TintColor=Color3.fromRGB(230,180,255)}, atm={Density=0.4,Color=Color3.fromRGB(140,80,200),Decay=Color3.fromRGB(90,45,150),Offset=0.12,Glare=0.3,Haze=1.5}},
}

function applyFPSBoost()
    if not State.fpsBoostEnabled then return end

    pcall(function() setfpscap(1e9) end)
    pcall(function() sethiddenproperty(game, "RenderFidelity", Enum.RenderFidelity.Performance) end)
    pcall(function() sethiddenproperty(game, "RenderQuality", 0) end)
    pcall(function() sethiddenproperty(game, "TextureQuality", Enum.TextureQuality.Performance) end)

    pcall(function() sethiddenproperty(game:GetService("Lighting"), "GlobalShadows", false) end)

    local Lighting = game:GetService("Lighting")
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("ColorCorrectionEffect") then
            v:Destroy()
        end
    end

    pcall(function() sethiddenproperty(Lighting, "Technology", Enum.Technology.Legacy) end)

    Lighting.FogStart = 9e9
    Lighting.FogEnd = 9e9

    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        pcall(function() sethiddenproperty(terrain, "Decoration", false) end)
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 1
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        for _, dec in pairs(terrain:GetDescendants()) do
            if dec:IsA("Decal") or dec:IsA("Texture") or dec:IsA("TerrainDetail") then
                dec:Destroy()
            end
        end
    end

    local function optimizePart(part)
        pcall(function()
            if part:IsA("BasePart") then
                part.CastShadow = false
                part.Material = Enum.Material.Plastic
                part.Reflectance = 0
                if part:IsA("MeshPart") then
                    part.RenderFidelity = Enum.RenderFidelity.Performance
                    part.DoubleSided = false
                end
            elseif part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = 1
            elseif part:IsA("ParticleEmitter") or part:IsA("Trail") or part:IsA("Beam") or part:IsA("Fire") or
                   part:IsA("Smoke") or part:IsA("Sparkles") or part:IsA("Explosion") then
                part.Enabled = false
            elseif part:IsA("Clothing") or part:IsA("Shirt") or part:IsA("Pants") then
                part:Destroy()
            elseif part:IsA("SpecialMesh") then
                part.TextureId = ""
            elseif part:IsA("SurfaceAppearance") then
                part:Destroy()
            end
        end)
    end

    for _, obj in pairs(workspace:GetDescendants()) do
        optimizePart(obj)
    end

    for _, light in pairs(workspace:GetDescendants()) do
        if light:IsA("Light") then
            light.Shadows = false
            if light:IsA("PointLight") or light:IsA("SpotLight") then
                light.Enabled = false
            end
        end
    end

    local function stripCharacter(char)
        if not char then return end

        if char == LP.Character then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                    part.Material = Enum.Material.Plastic
                    part.Reflectance = 0
                    if part:IsA("MeshPart") then
                        part.RenderFidelity = Enum.RenderFidelity.Performance
                    end
                end
            end
            return
        end

        for _, acc in pairs(char:GetChildren()) do
            if acc:IsA("Accessory") or acc:IsA("Clothing") then
                acc:Destroy()
            end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local shirt = hum:FindFirstChild("Shirt")
            if shirt then shirt:Destroy() end
            local pants = hum:FindFirstChild("Pants")
            if pants then pants:Destroy() end
            local tshirt = hum:FindFirstChild("TShirt")
            if tshirt then tshirt:Destroy() end
            local bodyColors = char:FindFirstChild("BodyColors")
            if bodyColors then bodyColors:Destroy() end
        end

        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if hum2 then
            hum2.AutoRotate = false
            hum2.PlatformStand = true
            hum2.WalkSpeed = 0
            hum2.JumpPower = 0
            local animate = char:FindFirstChild("Animate")
            if animate then animate:Destroy() end
            for _, child in pairs(char:GetChildren()) do
                if child:IsA("LocalScript") or child:IsA("Script") then
                    if child.Name:lower():find("anim") or child.Name:lower():find("move") then
                        child.Disabled = true
                    end
                end
            end
        end

        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CastShadow = false
                part.Material = Enum.Material.Plastic
                part.Reflectance = 0
                if part:IsA("MeshPart") then
                    part.RenderFidelity = Enum.RenderFidelity.Performance
                end
            end
        end
    end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then
            local char = plr.Character
            if char then
                stripCharacter(char)
            end
        end
    end

    if Conns.fpsBoostMonitor then Conns.fpsBoostMonitor:Disconnect() end
    Conns.fpsBoostMonitor = game:GetService("Players").PlayerAdded:Connect(function(plr)
        if plr == LP then return end
        plr.CharacterAdded:Connect(function(char)
            if State.fpsBoostEnabled then
                stripCharacter(char)
            end
        end)
        if plr.Character and State.fpsBoostEnabled then
            stripCharacter(plr.Character)
        end
    end)

    local newObjectConn
    newObjectConn = workspace.DescendantAdded:Connect(function(obj)
        if not State.fpsBoostEnabled then
            newObjectConn:Disconnect()
            return
        end
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("Light") then
            obj.Shadows = false
        elseif obj:IsA("BasePart") then
            obj.CastShadow = false
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            if obj:IsA("MeshPart") then
                obj.RenderFidelity = Enum.RenderFidelity.Performance
            end
        end
    end)
end

function saveOriginalLighting()
    if _skyOriginals then return end
    local L = game:GetService("Lighting")
    _skyOriginals = {Brightness=L.Brightness, Ambient=L.Ambient, OutdoorAmbient=L.OutdoorAmbient, TimeOfDay=L.TimeOfDay, ClockTime=L.ClockTime, FogEnd=L.FogEnd, GlobalShadows=L.GlobalShadows}
end
function clearAllSkyEffects()
    local L = game:GetService("Lighting")
    for _,v in pairs(L:GetChildren()) do if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds") or v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") then v:Destroy() end end
end
function applySky(idx)
    idx = math.clamp(idx,1,#SKY_THEMES)
    local theme = SKY_THEMES[idx]
    pcall(function()
        local L = game:GetService("Lighting")
        saveOriginalLighting()
        clearAllSkyEffects()
        local lt=theme.lt; L.Brightness=lt.Brightness; L.ClockTime=lt.ClockTime; L.Ambient=lt.Ambient; L.OutdoorAmbient=lt.OutdoorAmbient; L.FogEnd=lt.FogEnd; L.GlobalShadows=lt.GlobalShadows
        local cc=Instance.new("ColorCorrectionEffect",L); cc.Name="NovaSkyCC"; cc.Brightness=theme.cc.Brightness; cc.Contrast=theme.cc.Contrast; cc.Saturation=theme.cc.Saturation; cc.TintColor=theme.cc.TintColor
        local atm=Instance.new("Atmosphere",L); atm.Name="NovaSkyAtm"; atm.Density=theme.atm.Density; atm.Color=theme.atm.Color; atm.Decay=theme.atm.Decay; atm.Offset=theme.atm.Offset; atm.Glare=theme.atm.Glare; atm.Haze=theme.atm.Haze
    end)
end
function enableSky(idx)
    State.skyEnabled = true; applySky(idx or State.skyColorIndex)
    SetSetting("skyEnabled",true); SetSetting("skyColorIndex",State.skyColorIndex)
end
function disableSky()
    State.skyEnabled = false
    pcall(function()
        local L=game:GetService("Lighting"); clearAllSkyEffects()
        if _skyOriginals then L.Brightness=_skyOriginals.Brightness; L.Ambient=_skyOriginals.Ambient; L.OutdoorAmbient=_skyOriginals.OutdoorAmbient; L.TimeOfDay=_skyOriginals.TimeOfDay; L.ClockTime=_skyOriginals.ClockTime; L.FogEnd=_skyOriginals.FogEnd; L.GlobalShadows=_skyOriginals.GlobalShadows end
    end)
    SetSetting("skyEnabled",false)
end

local waypointMarker = nil; local waypointConn = nil
function getWaypointTarget()
    if State.autoLeftEnabled then
        if State.autoLeftPhase == 1 then return POS.L1 end
        if State.autoLeftPhase == 2 then return POS.L2 end
    end
    if State.autoRightEnabled then
        if State.autoRightPhase == 1 then return POS.R1 end
        if State.autoRightPhase == 2 then return POS.R2 end
    end
    return nil
end
function createWaypointMarker()
    if waypointMarker then return end
    local marker = Instance.new("Part"); marker.Name="KzWaypoint"; marker.Size=Vector3.new(2.5,2.5,2.5); marker.Shape=Enum.PartType.Ball; marker.Anchored=true; marker.CanCollide=false; marker.CastShadow=false; marker.Material=Enum.Material.Neon; marker.Color=Color3.fromRGB(0, 180, 255); marker.Transparency=0.15; marker.Parent=workspace
    local bb=Instance.new("BillboardGui",marker); bb.Size=UDim2.new(0,90,0,22); bb.StudsOffset=Vector3.new(0,2.8,0); bb.AlwaysOnTop=true; bb.Adornee=marker
    local label=Instance.new("TextLabel",bb); label.Size=UDim2.new(1,0,1,0); label.BackgroundTransparency=1; label.Text="WAYPOINT"; label.TextColor3=Color3.fromRGB(255,255,255); label.TextStrokeColor3=Color3.fromRGB(0,0,0); label.TextStrokeTransparency=0.4; label.Font=Enum.Font.GothamBold; label.TextSize=13; label.TextScaled=true
    waypointMarker=marker
end
function removeWaypointMarker() if waypointMarker then pcall(function() waypointMarker:Destroy() end); waypointMarker=nil end end
function startWaypointESP()
    if waypointConn then waypointConn:Disconnect() end
    createWaypointMarker()
    waypointConn = RunService.Heartbeat:Connect(function()
        if not State.waypointESPEnabled then removeWaypointMarker(); if waypointConn then waypointConn:Disconnect(); waypointConn=nil end; return end
        local target = getWaypointTarget()
        if target then
            if not waypointMarker then createWaypointMarker() end
            waypointMarker.Position = target; waypointMarker.Transparency = 0.15
        else
            if waypointMarker then waypointMarker.Transparency = 1 end
        end
    end)
end
function stopWaypointESP() State.waypointESPEnabled=false; if waypointConn then waypointConn:Disconnect(); waypointConn=nil end; removeWaypointMarker() end

local _respawnLock = false
local function fullMovementCleanup(char)
    _respawnLock = true
    pcall(function()
        if Conns and Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft = nil end
        if Conns and Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight = nil end
    end)
    State.autoLeftPhase = 1
    State.autoRightPhase = 1
    _pausedBySteal.autoLeft = false
    _pausedBySteal.autoRight = false
    local c = char or LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if root then
            pcall(function() clearLinearVelocity(root) end)
            pcall(function() clearSpeedVectorForce(root) end)
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.Velocity = Vector3.zero
            end)
            for _, name in ipairs({"KzLinearVelocity", "SpeedVectorForce", "InfJumpVelocity", "SpeedAttachment", "RootAttachment", "InfJumpAttachment"}) do
                local obj = root:FindFirstChild(name)
                if obj then pcall(function() obj:Destroy() end) end
            end
        end
        if hum2 then
            pcall(function()
                hum2:Move(Vector3.zero, false)
                hum2.AutoRotate = true
                hum2.PlatformStand = false
            end)
        end
    end
    task.delay(0.4, function() _respawnLock = false end)
end

local startAutoLeft, stopAutoLeft, startAutoRight, stopAutoRight
startAutoLeft = function()
    if _respawnLock then return end
    if isPlayerStealing() then
        _pausedBySteal.autoLeft = true
        return
    end
    local c0 = LP.Character
    local h0 = c0 and c0:FindFirstChildOfClass("Humanoid")
    if not (c0 and h0 and h0.Health > 0) then return end
    if Conns.autoLeft then Conns.autoLeft:Disconnect() end
    State.autoLeftPhase = 1
    Conns.autoLeft = RunService.Heartbeat:Connect(function()
        if not State.autoLeftEnabled then return end
        if _respawnLock then return end
        if isPlayerStealing() then
            _pausedBySteal.autoLeft = true
            if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end
            return
        end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum2 then return end
        local spd = getAutoMoveSpeed()
        pcall(function() clearSpeedVectorForce(root) end)
        local function goXZ(tgtPos, isFinal)
            local d = Vector3.new(tgtPos.X - root.Position.X, 0, tgtPos.Z - root.Position.Z)
            local dist = d.Magnitude
            if dist < 0.05 then return 0 end
            local mv = d.Unit
            local useSpd = spd
            if isFinal and dist < 3 then
                useSpd = math.clamp(math.max(dist * 10, 10), 10, spd)
            end
            hum2:Move(mv, false)
            setLinearVelocityXZ(root, mv.X * useSpd, mv.Z * useSpd)
            return dist
        end
        if State.autoLeftPhase == 1 then
            local tgt = POS.L1
            local dist = (Vector3.new(tgt.X,root.Position.Y,tgt.Z)-root.Position).Magnitude
            if dist < 1.5 then
                State.autoLeftPhase = 2
                goXZ(POS.L2, true)
            else
                goXZ(POS.L1, false)
            end
        else
            local tgt = POS.L2
            local dist = (Vector3.new(tgt.X,root.Position.Y,tgt.Z)-root.Position).Magnitude
            if dist < 1.25 then
                hum2:Move(Vector3.zero,false)
                clearLinearVelocity(root)
                if (AP_L_FACE-root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, Vector3.new(AP_L_FACE.X,root.Position.Y,AP_L_FACE.Z))
                end
                State.autoLeftEnabled = false
                Conns.autoLeft:Disconnect(); Conns.autoLeft=nil
                State.autoLeftPhase=1
                if setAutoLeft then setAutoLeft(false) end
                if setMB_AL then setMB_AL(false) end
                return
            end
            goXZ(POS.L2, true)
        end
    end)
end
stopAutoLeft = function()
    if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end
    State.autoLeftPhase = 1
    local char = LP.Character
    if char then
        hardStopMovement(char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid"))
    end
end

startAutoRight = function()
    if _respawnLock then return end
    if isPlayerStealing() then
        _pausedBySteal.autoRight = true
        return
    end
    local c0 = LP.Character
    local h0 = c0 and c0:FindFirstChildOfClass("Humanoid")
    if not (c0 and h0 and h0.Health > 0) then return end
    if Conns.autoRight then Conns.autoRight:Disconnect() end
    State.autoRightPhase = 1
    Conns.autoRight = RunService.Heartbeat:Connect(function()
        if not State.autoRightEnabled then return end
        if _respawnLock then return end
        if isPlayerStealing() then
            _pausedBySteal.autoRight = true
            if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end
            return
        end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum2 then return end
        local spd = getAutoMoveSpeed()
        pcall(function() clearSpeedVectorForce(root) end)
        local function goXZ(tgtPos, isFinal)
            local d = Vector3.new(tgtPos.X - root.Position.X, 0, tgtPos.Z - root.Position.Z)
            local dist = d.Magnitude
            if dist < 0.05 then return 0 end
            local mv = d.Unit
            local useSpd = spd
            if isFinal and dist < 3 then
                useSpd = math.clamp(math.max(dist * 10, 10), 10, spd)
            end
            hum2:Move(mv, false)
            setLinearVelocityXZ(root, mv.X * useSpd, mv.Z * useSpd)
            return dist
        end
        if State.autoRightPhase == 1 then
            local tgt = POS.R1
            local dist = (Vector3.new(tgt.X,root.Position.Y,tgt.Z)-root.Position).Magnitude
            if dist < 1.5 then
                State.autoRightPhase = 2
                goXZ(POS.R2, true)
            else
                goXZ(POS.R1, false)
            end
        else
            local tgt = POS.R2
            if (Vector3.new(tgt.X,root.Position.Y,tgt.Z)-root.Position).Magnitude < 1.25 then
                hum2:Move(Vector3.zero,false)
                clearLinearVelocity(root)
                if (AP_R_FACE-root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, Vector3.new(AP_R_FACE.X,root.Position.Y,AP_R_FACE.Z))
                end
                State.autoRightEnabled = false
                Conns.autoRight:Disconnect(); Conns.autoRight=nil
                State.autoRightPhase=1
                if setAutoRight then setAutoRight(false) end
                if setMB_AR then setMB_AR(false) end
                return
            end
            goXZ(POS.R2, true)
        end
    end)
end
stopAutoRight = function()
    if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end
    State.autoRightPhase = 1
    local char = LP.Character
    if char then
        hardStopMovement(char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid"))
    end
end
_G._startAutoLeft = startAutoLeft
if not _G.AutoLR_ResumeWatch then
    _G.AutoLR_ResumeWatch = true
    task.spawn(function()
        while true do
            task.wait(0.25)
            if _respawnLock or isPlayerStealing() then
            else
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not (char and hum and root and hum.Health > 0) then
                else
                    if State.autoLeftEnabled and not (Conns and Conns.autoLeft) then
                        pcall(function() local fn = _G._startAutoLeft or startAutoLeft; if fn then fn() end end)
                    end
                    if State.autoRightEnabled and not (Conns and Conns.autoRight) then
                        pcall(function() local fn = _G._startAutoRight or startAutoRight; if fn then fn() end end)
                    end
                end
            end
        end
    end)
end
_G._startAutoRight = startAutoRight
_G._stopAutoLeft = stopAutoLeft
_G._stopAutoRight = stopAutoRight

function createAntiRagdollButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "InternalAntiRagdoll"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false

    local success, _ = pcall(function()
        screenGui.Parent = CoreGui
    end)

    if not success then
        screenGui.Parent = LP:WaitForChild("PlayerGui")
    end

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 160, 0, 35)
    toggleButton.Position = UDim2.new(0, 10, 0, 50)
    toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.RobotoMono
    toggleButton.TextSize = 14
    toggleButton.Text = "ANTIRAGDOLL: OFF"
    toggleButton.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 4)
    uiCorner.Parent = toggleButton

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(0, 180, 255)
    uiStroke.Thickness = 1
    uiStroke.Transparency = 0.7
    uiStroke.Parent = toggleButton

    local dragging = false
    local dragStart, startPos = nil, nil
    toggleButton.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = toggleButton.Position
        end
    end)
    toggleButton.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            toggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                              startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    toggleButton.MouseButton1Click:Connect(function()
        if State.antiRagdollActiveVersion == 0 then
            setAntiRagdollVersion(1)
        else
            setAntiRagdollVersion(0)
        end
        local isOn = State.antiRagdollActiveVersion ~= 0
        toggleButton.Text = isOn and "ANTIRAGDOLL: ON" or "ANTIRAGDOLL: OFF"
        toggleButton.TextColor3 = isOn and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(255, 255, 255)
        uiStroke.Color = isOn and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(255, 0, 0)
    end)

    local isOn = State.antiRagdollActiveVersion ~= 0
    toggleButton.Text = isOn and "ANTIRAGDOLL: ON" or "ANTIRAGDOLL: OFF"
    toggleButton.TextColor3 = isOn and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(255, 255, 255)
    uiStroke.Color = isOn and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(255, 0, 0)
end

task.spawn(createAntiRagdollButton)

local setupMedusaCounter, stopMedusaCounter
function findMedusa()
    local char = LP.Character; if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and tool.Name:lower():find("medusa") then return tool end end
    local bp = LP:FindFirstChild("Backpack"); if bp then for _, tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") and tool.Name:lower():find("medusa") then return tool end end end
    return nil
end
function useMedusaCounter()
    if State.medusaDebounce then return end
    if tick()-State.medusaLastUsed < 25 then return end
    local char = LP.Character; if not char then return end
    State.medusaDebounce = true
    local med = findMedusa()
    if not med then State.medusaDebounce=false; return end
    if med.Parent ~= char then local hum2=char:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end)
    State.medusaLastUsed = tick()
    State.medusaDebounce = false
end
function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency == 1 and State.medusaCounterEnabled then useMedusaCounter() end
    end)
end
setupMedusaCounter = function(char)
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end end))
end
stopMedusaCounter = function() for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end; Conns.anchor={} end

function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
            return tool
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                return tool
            end
        end
    end
    return nil
end

function getClosestTarget()
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
    return closest
end

function swingCurrentBat()
    if not autoSwingEnabled then return end
    if isPlayerStealing() then return end
    local bat = findBat()
    if bat and bat.Parent == LP.Character and bat:IsA("Tool") then
        pcall(function() bat:Activate() end)
    end
end

function startBatAimbot()
    if isPlayerStealing() then
        _pausedBySteal.autoBat = true
        autoBatEnabled = false
        return
    end
    if aimbotConnection then aimbotConnection:Disconnect() end
    autoBatEnabled = true

    if State.autoLeftEnabled then
        State.autoLeftEnabled = false
        stopAutoLeft()
        if setAutoLeft then setAutoLeft(false) end
        if setMB_AL then setMB_AL(false) end
        SetSetting("autoLeftEnabled", false)
    end
    if State.autoRightEnabled then
        State.autoRightEnabled = false
        stopAutoRight()
        if setAutoRight then setAutoRight(false) end
        if setMB_AR then setMB_AR(false) end
        SetSetting("autoRightEnabled", false)
    end

    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end

    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        if isPlayerStealing() then
            _pausedBySteal.autoBat = true
            pcall(function() if stopBatAimbot then stopBatAimbot() end end)
            return
        end

        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        local target = getClosestTarget()
        if not target then
            swingCurrentBat()
            return
        end

        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14
        predictPos = predictPos + target.CFrame.LookVector * 0.3

        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z).Unit

        local chaseSpeed = 58
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)

        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        setLinearVelocity(root, desiredVel)

        local speed3 = targetVel.Magnitude
        local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos

        setLinearVelocity(root, desiredVel)
        if toPredict.Magnitude > 0.1 then
            lookAtWithLinearVelocity(root, predictedPos, chaseSpeed)
        end

        swingCurrentBat()
    end)
end

function stopBatAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
    autoBatEnabled = false
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if root then
        clearLookRotation(root)
    end
    hardStopMovement(root, hum)
end

function resetAutoBatMotion()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hrp then
        clearLinearVelocity(hrp)
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    if hum then hum.AutoRotate = true end
end

function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not State.batCounterEnabled then return end
        if State.batCounterDebounce then return end
        local char = LP.Character
        if not char then return end
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if not hum2 then return end
        local st = hum2:GetState()
        local isRagdolled = st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
        if isRagdolled then
            State.batCounterDebounce = true
            task.spawn(function()
                local bat = findBatForCounter()
                if bat then swingBatForCounter(bat, char) end
                task.wait(0.5)
                State.batCounterDebounce = false
            end)
        end
    end)
end

function stopBatCounter()
    if Conns.batCounter then
        Conns.batCounter:Disconnect()
        Conns.batCounter = nil
    end
    State.batCounterDebounce = false
end

local Anims = {
    idle1="rbxassetid://656117400",
    idle2="rbxassetid://656118341",
    walk="rbxassetid://656121766",
    run="rbxassetid://656118852",
    jump="rbxassetid://109996626521204",
    fall="rbxassetid://656115606",
    climb="rbxassetid://656114359",
    swim="rbxassetid://656119721",
    swimidle="rbxassetid://656121397",
}

task.spawn(function() pcall(function() ContentProvider:PreloadAsync({Anims.idle1,Anims.idle2,Anims.walk,Anims.run,Anims.jump,Anims.fall,Anims.climb,Anims.swim,Anims.swimidle}) end) end)
local animHeartbeatConn, savedAnimate, originalAnims = nil, nil, nil
function isPackAnim(id) if not id then return false end; for _,v in pairs(Anims) do if v==id then return true end end; return false end
function saveOriginalAnims(char)
    local animate=char:FindFirstChild("Animate"); if not animate then return end
    local function g(obj) return obj and obj.AnimationId or nil end
    local ids={idle1=g(animate.idle and animate.idle.Animation1),idle2=g(animate.idle and animate.idle.Animation2),walk=g(animate.walk and animate.walk.WalkAnim),run=g(animate.run and animate.run.RunAnim),jump=g(animate.jump and animate.jump.JumpAnim),fall=g(animate.fall and animate.fall.FallAnim),climb=g(animate.climb and animate.climb.ClimbAnim),swim=g(animate.swim and animate.swim.Swim),swimidle=g(animate.swimidle and animate.swimidle.SwimIdle)}
    if not isPackAnim(ids.walk) then originalAnims=ids end
end
function applyAnimPack(char)
    local animate=char:FindFirstChild("Animate"); if not animate then return end
    local function s(obj,id) if obj then obj.AnimationId=id end end
    s(animate.idle and animate.idle.Animation1,Anims.idle1); s(animate.idle and animate.idle.Animation2,Anims.idle2); s(animate.walk and animate.walk.WalkAnim,Anims.walk); s(animate.run and animate.run.RunAnim,Anims.run); s(animate.jump and animate.jump.JumpAnim,Anims.jump); s(animate.fall and animate.fall.FallAnim,Anims.fall); s(animate.climb and animate.climb.ClimbAnim,Anims.climb); s(animate.swim and animate.swim.Swim,Anims.swim); s(animate.swimidle and animate.swimidle.SwimIdle,Anims.swimidle)
end
function restoreOriginalAnims(char)
    if not originalAnims then return end
    local animate=char:FindFirstChild("Animate"); if not animate then return end
    local function s(obj,id) if obj and id then obj.AnimationId=id end end
    s(animate.idle and animate.idle.Animation1,originalAnims.idle1); s(animate.idle and animate.idle.Animation2,originalAnims.idle2); s(animate.walk and animate.walk.WalkAnim,originalAnims.walk); s(animate.run and animate.run.RunAnim,originalAnims.run); s(animate.jump and animate.jump.JumpAnim,originalAnims.jump); s(animate.fall and animate.fall.FallAnim,originalAnims.fall); s(animate.climb and animate.climb.ClimbAnim,originalAnims.climb); s(animate.swim and animate.swim.Swim,originalAnims.swim); s(animate.swimidle and animate.swimidle.SwimIdle,originalAnims.swimidle)
    local hum2=char:FindFirstChildOfClass("Humanoid"); if hum2 then for _,track in ipairs(hum2:GetPlayingAnimationTracks()) do track:Stop(0) end; hum2:ChangeState(Enum.HumanoidStateType.Running) end
end
function startAnimToggle()
    if animHeartbeatConn then animHeartbeatConn:Disconnect(); animHeartbeatConn=nil end
    local char=LP.Character
    if char then saveOriginalAnims(char); applyAnimPack(char); local hum2=char:FindFirstChildOfClass("Humanoid"); if hum2 then for _,track in ipairs(hum2:GetPlayingAnimationTracks()) do track:Stop(0) end; hum2:ChangeState(Enum.HumanoidStateType.Running) end end
    animHeartbeatConn=RunService.Heartbeat:Connect(function() if not State.animEnabled then return end; local c=LP.Character; if c then applyAnimPack(c) end end)
end
function stopAnimToggle() if animHeartbeatConn then animHeartbeatConn:Disconnect(); animHeartbeatConn=nil end; local char=LP.Character; if char then restoreOriginalAnims(char) end end

function startUnwalk()
    if State.unwalkEnabled then return end
    State.unwalkEnabled=true
    local c=LP.Character; if not c then return end
    local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then for _,t in ipairs(hum2:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate"); if anim then savedAnimate=anim:Clone(); anim:Destroy() end
end
function stopUnwalk()
    if not State.unwalkEnabled then return end
    State.unwalkEnabled=false
    local c=LP.Character
    if c and savedAnimate then savedAnimate.Parent=c; savedAnimate.Disabled=false; savedAnimate=nil end
    task.spawn(function() task.wait(0.15); local char=LP.Character; if not char then return end; if State.animEnabled then saveOriginalAnims(char); applyAnimPack(char) else restoreOriginalAnims(char) end end)
end

function tpToGround()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z)
        * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
end

local _autoTPConn = nil; local _autoTPActive = false
function startAutoTP()
    if _autoTPConn then task.cancel(_autoTPConn); _autoTPConn=nil end
    _autoTPActive = true
    _autoTPConn = task.spawn(function()
        while _autoTPActive do
            task.wait(0.1)
            if not _autoTPActive then break end
            if not State.autoLeftEnabled and not State.autoRightEnabled then
                local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if root and root.Position.Y > State.autoTpDownY then
                    local rp = RaycastParams.new(); rp.FilterDescendantsInstances={LP.Character}; rp.FilterType=Enum.RaycastFilterType.Exclude
                    local rr = workspace:Raycast(root.Position, Vector3.new(0,-5000,0), rp)
                    if rr then
                        root.CFrame = CFrame.new(root.Position.X, rr.Position.Y + root.Size.Y/2 + 0.1, root.Position.Z)
                    end
                end
            end
        end
    end)
end
function stopAutoTP() _autoTPActive=false; if _autoTPConn then task.cancel(_autoTPConn); _autoTPConn=nil end end

local GP_ACT = {}
local gpLastFire = {}
local GP_DEBOUNCE = 0.25
local gpEnabled = false

function saveGPBinds()
    local t = {}
    for _, act in ipairs(GP_ACT) do if act.key then t[act.id] = act.key.Name end end
    Config.controllerBinds = t
    AutoSave()
end

function xboxName(kc)
    local map = {
        [Enum.KeyCode.ButtonA]="A",
        [Enum.KeyCode.ButtonB]="B",
        [Enum.KeyCode.ButtonX]="X",
        [Enum.KeyCode.ButtonY]="Y",
        [Enum.KeyCode.ButtonL1]="LB",
        [Enum.KeyCode.ButtonR1]="RB",
        [Enum.KeyCode.ButtonL2]="LT",
        [Enum.KeyCode.ButtonR2]="RT",
        [Enum.KeyCode.ButtonL3]="LS",
        [Enum.KeyCode.ButtonR3]="RS",
        [Enum.KeyCode.ButtonSelect]="View",
        [Enum.KeyCode.ButtonStart]="Menu",
        [Enum.KeyCode.DPadUp]="D-Up",
        [Enum.KeyCode.DPadDown]="D-Down",
        [Enum.KeyCode.DPadLeft]="D-Left",
        [Enum.KeyCode.DPadRight]="D-Right",
    }
    return map[kc] or (kc and kc.Name) or "None"
end

function loadGPKey(id, default)
    local saved = Config.controllerBinds[id]
    if saved then
        local ok, kc = pcall(function() return Enum.KeyCode[saved] end)
        if ok and kc and kc ~= Enum.KeyCode.Unknown then return kc end
    end
    return default
end

GP_ACT = {
    {id="TPDown",      label="TP Down",      key=loadGPKey("TPDown",      Enum.KeyCode.ButtonR2)},
    {id="CarryMode",   label="Carry Mode",   key=loadGPKey("CarryMode",   Enum.KeyCode.ButtonL2)},
    {id="AutoLeft",    label="Auto Left",    key=loadGPKey("AutoLeft",    Enum.KeyCode.ButtonR1)},
    {id="AutoRight",   label="Auto Right",   key=loadGPKey("AutoRight",   Enum.KeyCode.ButtonL1)},
    {id="Drop",        label="Drop BR",      key=loadGPKey("Drop",        Enum.KeyCode.ButtonY)},
    {id="LaggerSpeed", label="Lagger Speed", key=loadGPKey("LaggerSpeed", Enum.KeyCode.ButtonA)},
    {id="AutoBat",     label="Auto Bat",     key=loadGPKey("AutoBat",     Enum.KeyCode.DPadUp)},
    {id="Speed2",      label="Speed 2",      key=loadGPKey("Speed2",      Enum.KeyCode.Unknown)},
    {id="Speed3",      label="Speed 3",      key=loadGPKey("Speed3",      Enum.KeyCode.Unknown)},
    {id="BatAim2",     label="Bat v2",       key=loadGPKey("BatAim2",     Enum.KeyCode.Unknown)},
    {id="TpBat",       label="TP Bat",       key=loadGPKey("TpBat",       Enum.KeyCode.Unknown)},
    {id="InstaReset",  label="Insta Reset",  key=loadGPKey("InstaReset",  Enum.KeyCode.Unknown)},
}

function doAutoLeft()
    if _G.stopTpBat then _G.stopTpBat() end
    State.autoLeftEnabled = not State.autoLeftEnabled
    if State.autoLeftEnabled then
        if State.autoRightEnabled then stopAutoRight(); if setAutoRight then setAutoRight(false) end; if setMB_AR then setMB_AR(false) end end
        if State.autoBatToggled then stopBatAimbot(); if setAutoBat then setAutoBat(false) end; if setMB_AB then setMB_AB(false) end end
        startAutoLeft()
    else
        stopAutoLeft()
    end
    if setAutoLeft then setAutoLeft(State.autoLeftEnabled) end
    if setMB_AL then setMB_AL(State.autoLeftEnabled) end
    SetSetting("autoLeftEnabled", State.autoLeftEnabled)
end

function doAutoRight()
    if _G.stopTpBat then _G.stopTpBat() end
    State.autoRightEnabled = not State.autoRightEnabled
    if State.autoRightEnabled then
        if State.autoLeftEnabled then stopAutoLeft(); if setAutoLeft then setAutoLeft(false) end; if setMB_AL then setMB_AL(false) end end
        if State.autoBatToggled then stopBatAimbot(); if setAutoBat then setAutoBat(false) end; if setMB_AB then setMB_AB(false) end end
        startAutoRight()
    else
        stopAutoRight()
    end
    if setAutoRight then setAutoRight(State.autoRightEnabled) end
    if setMB_AR then setMB_AR(State.autoRightEnabled) end
    SetSetting("autoRightEnabled", State.autoRightEnabled)
end

function doCarryMode()
    if _G.stopTpBat then _G.stopTpBat() end
    if State.laggerLevel > 0 then
        State.laggerLevel = 0
        SetSetting("laggerLevel", 0)
        refreshUIToggles()
        if setMB_LC then setMB_LC() end
    end
    State.speedType = (State.speedType == "carry") and "normal" or "carry"
    SetSetting("speedType", State.speedType)
    if modeValLbl then modeValLbl.Text = State.speedType == "carry" and "Carry" or "Normal" end
    if setMB_CS then setMB_CS(State.speedType == "carry") end
end

function doLaggerSpeed()
    if _G.stopTpBat then _G.stopTpBat() end
    if State.laggerLevel == 0 then
        State.laggerLevel = 1
    elseif State.laggerLevel == 1 then
        State.laggerLevel = 2
    else
        State.laggerLevel = 1
    end
    State.speedType = "normal"

    if State.laggerLevel == 0 then
        if setMB_CS then setMB_CS(State.speedType == "carry") end
    else
        if setMB_CS then setMB_CS(false) end
    end

    SetSetting("laggerLevel", State.laggerLevel)
    SetSetting("speedType", State.speedType)
    refreshUIToggles()

    if setMB_LC then setMB_LC() end

    for _, child in ipairs(pageMain:GetChildren()) do
        if child:IsA("Frame") then
            local laggerBtn = child:FindFirstChildWhichIsA("TextButton")
            if laggerBtn and laggerBtn.Text:match("^L%d?$") then
                if State.laggerLevel == 0 then
                    laggerBtn.Text = "L"
                    laggerBtn.BackgroundColor3 = PITCH_BLACK
                elseif State.laggerLevel == 1 then
                    laggerBtn.Text = "L1"
                    laggerBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                else
                    laggerBtn.Text = "L2"
                    laggerBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                end
                break
            end
        end
    end
end

function doAutoBat()
    if _G.stopTpBat then _G.stopTpBat() end
    State.autoBatToggled = not State.autoBatToggled
    if State.autoBatToggled then
        startBatAimbot()
    else
        stopBatAimbot()
    end
    if setAutoBat then setAutoBat(State.autoBatToggled) end
    if setMB_AB then setMB_AB(State.autoBatToggled) end
    SetSetting("autoBatToggled", State.autoBatToggled)
end

function updateSpeedFloatButtons()
    for _, child in ipairs(gui:GetChildren()) do
        if child:IsA("TextButton") and child.Name == "Speed2FloatingButton" then
            if State.useSecondSpeedSet then
                child.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
                child.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                child.BackgroundColor3 = Q_OFF
                child.TextColor3 = Q_TEXT
            end
        end
        if child:IsA("TextButton") and child.Name == "Speed3FloatingButton" then
            if State.useThirdSpeedSet then
                child.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
                child.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                child.BackgroundColor3 = Q_OFF
                child.TextColor3 = Q_TEXT
            end
        end
    end
end

function startControllerSupport()
    gpEnabled = State.controllerEnabled
    if not gpEnabled then return end

    local dispatch = {
        TPDown = function() tpToGround() end,
        CarryMode = doCarryMode,
        AutoLeft = doAutoLeft,
        AutoRight = doAutoRight,
        Drop = function() runDropBrainrot() end,
        LaggerSpeed = doLaggerSpeed,
        AutoBat = doAutoBat,
        Speed2 = function()
            if State.useSecondSpeedSet then
                State.useSecondSpeedSet = false
                SetSetting("useSecondSpeedSet", false)
                for _, child in ipairs(gui:GetChildren()) do
                    if child:IsA("TextButton") and child.Name == "Mode2FloatingButton" then
                        child.Text = "Speed 2"
                        child.TextColor3 = ACCENT
                        child.BackgroundColor3 = PITCH_BLACK
                        local stroke = child:FindFirstChildWhichIsA("UIStroke")
                        if stroke then stroke.Color = DARK_ACC end
                    end
                end
            else
                if State.useThirdSpeedSet then
                    State.useThirdSpeedSet = false
                    SetSetting("useThirdSpeedSet", false)
                    for _, child in ipairs(gui:GetChildren()) do
                        if child:IsA("TextButton") and child.Name == "Mode3FloatingButton" then
                            child.Text = "Speed 3"
                            child.TextColor3 = ACCENT
                            child.BackgroundColor3 = PITCH_BLACK
                            local stroke = child:FindFirstChildWhichIsA("UIStroke")
                            if stroke then stroke.Color = DARK_ACC end
                        end
                    end
                end
                State.useSecondSpeedSet = true
                SetSetting("useSecondSpeedSet", true)
                for _, child in ipairs(gui:GetChildren()) do
                    if child:IsA("TextButton") and child.Name == "Mode2FloatingButton" then
                        child.Text = "Speed 2"
                        child.TextColor3 = C_WHITE
                        child.BackgroundColor3 = ACCENT
                        local stroke = child:FindFirstChildWhichIsA("UIStroke")
                        if stroke then stroke.Color = ACCENT end
                    end
                end
            end
            refreshUIToggles()
            updateSpeedFloatButtons()
            if _G.setSpeed2Toggle then _G.setSpeed2Toggle(State.useSecondSpeedSet) end
        end,
        Speed3 = function()
            if State.useThirdSpeedSet then
                State.useThirdSpeedSet = false
                SetSetting("useThirdSpeedSet", false)
                for _, child in ipairs(gui:GetChildren()) do
                    if child:IsA("TextButton") and child.Name == "Mode3FloatingButton" then
                        child.Text = "Speed 3"
                        child.TextColor3 = ACCENT
                        child.BackgroundColor3 = PITCH_BLACK
                        local stroke = child:FindFirstChildWhichIsA("UIStroke")
                        if stroke then stroke.Color = DARK_ACC end
                    end
                end
            else
                if State.useSecondSpeedSet then
                    State.useSecondSpeedSet = false
                    SetSetting("useSecondSpeedSet", false)
                    for _, child in ipairs(gui:GetChildren()) do
                        if child:IsA("TextButton") and child.Name == "Mode2FloatingButton" then
                            child.Text = "Speed 2"
                            child.TextColor3 = ACCENT
                            child.BackgroundColor3 = PITCH_BLACK
                            local stroke = child:FindFirstChildWhichIsA("UIStroke")
                            if stroke then stroke.Color = DARK_ACC end
                        end
                    end
                end
                State.useThirdSpeedSet = true
                SetSetting("useThirdSpeedSet", true)
                for _, child in ipairs(gui:GetChildren()) do
                    if child:IsA("TextButton") and child.Name == "Mode3FloatingButton" then
                        child.Text = "Speed 3"
                        child.TextColor3 = C_WHITE
                        child.BackgroundColor3 = ACCENT
                        local stroke = child:FindFirstChildWhichIsA("UIStroke")
                        if stroke then stroke.Color = ACCENT end
                    end
                end
            end
            refreshUIToggles()
            updateSpeedFloatButtons()
            if _G.setSpeed3Toggle then _G.setSpeed3Toggle(State.useThirdSpeedSet) end
        end,
        BatAim2 = function()
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("TextButton") and child.Name == "BatAimButton" then
                    child:Click()
                    break
                end
            end
        end,
        TpBat = function()
            _G.setTpBatMode(not _G.tpBatModeActive)
        end,
        InstaReset = function()
            cursedInstaReset()
        end,
    }

    UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.Gamepad1 then return end
        if not gpEnabled then return end
        local kc = inp.KeyCode
        local now = tick()
        for _, act in ipairs(GP_ACT) do
            if act.key == kc then
                local last = gpLastFire[act.id] or 0
                if now - last < GP_DEBOUNCE then return end
                gpLastFire[act.id] = now
                local fn = dispatch[act.id]
                if fn then pcall(fn) end
                return
            end
        end
    end)
end
local _guiChunk = (function()

local DARK_ACC = Color3.fromRGB(0, 80, 200)
local ACCENT = Color3.fromRGB(0, 180, 255)
local PITCH_BLACK = Color3.fromRGB(8, 8, 10)
local OFF_BG = Color3.fromRGB(14, 14, 16)
local C_ROW = Color3.fromRGB(16, 16, 22)
local C_ROW_HOV = Color3.fromRGB(32, 32, 42)
local C_ON_BG = Color3.fromRGB(0, 180, 255)
local C_OFF_BG = Color3.fromRGB(14, 14, 18)
local C_WHITE = Color3.fromRGB(245, 245, 250)
local C_DIM = Color3.fromRGB(130, 130, 140)

local TRANSPARENCY_BG = 0.68
local TRANSPARENCY_ROW = 0.42
local TRANSPARENCY_PILL = 0.35

local CONTENT_WIDTH = 310
local W,H,CORNER = CONTENT_WIDTH + 28, 430, 18

local gui=Instance.new("ScreenGui"); gui.Name="KzsHubGUI"; gui.ResetOnSpawn=false; gui.DisplayOrder=10; gui.IgnoreGuiInset=true
pcall(function() gui.Parent=game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent=LP:WaitForChild("PlayerGui") end

function makeDraggable(inputObject, moveObject, lockedFn)
    local dragging,dragInput,dragStart,startPos=false
    inputObject.InputBegan:Connect(function(inp)
        if lockedFn and lockedFn() then return end
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=inp.Position; startPos=moveObject.Position
            inp.Changed:Connect(function() if inp.UserInputState==Enum.InputUserState.End then dragging=false end end)
        end
    end)
    inputObject.InputChanged:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then dragInput=inp end end)
    UIS.InputChanged:Connect(function(inp)
        if inp==dragInput and dragging then
            local delta=inp.Position-dragStart
            moveObject.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
end

local main=Instance.new("Frame",gui); main.Name="Main"; main.Size=UDim2.new(0,W,0,H); main.Position=UDim2.new(1,-W-20,0,80)
main.BackgroundColor3=Color3.fromRGB(10,10,12); main.BackgroundTransparency=1
main.BorderSizePixel=0; main.Active=false
main.ClipsDescendants=true
local mainCorner=Instance.new("UICorner",main); mainCorner.CornerRadius=UDim.new(0,CORNER)
local mainStroke=Instance.new("UIStroke",main); mainStroke.Color=ACCENT; mainStroke.Thickness=1.8; mainStroke.Transparency=0.2

local bgImage = Instance.new("ImageLabel", main)
bgImage.Name = "BgImage"
bgImage.Size = UDim2.new(1,0,1,0)
bgImage.Position = UDim2.new(0,0,0,0)
bgImage.BackgroundColor3 = Color3.fromRGB(10,10,12)
bgImage.BackgroundTransparency = 0
bgImage.Image = "rbxassetid://94968913053217"
bgImage.ImageTransparency = 0
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ZIndex = 0
Instance.new("UICorner",bgImage).CornerRadius=UDim.new(0,CORNER)

local TOP_H = 58
local topbar=Instance.new("Frame",main); topbar.Size=UDim2.new(1,0,0,TOP_H); topbar.BackgroundColor3=PITCH_BLACK; topbar.BackgroundTransparency=0.55
topbar.BorderSizePixel=0; topbar.Active=true
Instance.new("UICorner",topbar).CornerRadius=UDim.new(0,CORNER)
local topDiv=Instance.new("Frame",topbar); topDiv.Size=UDim2.new(1,0,0,1); topDiv.Position=UDim2.new(0,0,1,-1); topDiv.BackgroundColor3=ACCENT; topDiv.BackgroundTransparency=0.4
local titleLbl=Instance.new("TextLabel",topbar); titleLbl.Size=UDim2.new(0,150,0,22); titleLbl.Position=UDim2.new(0,12,0,2); titleLbl.BackgroundTransparency=1; titleLbl.Text="NOXTRIXHUB"; titleLbl.TextColor3=ACCENT; titleLbl.Font=Enum.Font.GothamBlack; titleLbl.TextSize=14; titleLbl.TextXAlignment=Enum.TextXAlignment.Left
local minBtn=Instance.new("TextButton",topbar); minBtn.Size=UDim2.new(0,22,0,22); minBtn.Position=UDim2.new(1,-30,0,4); minBtn.BackgroundColor3=Color3.fromRGB(24,24,28); minBtn.BackgroundTransparency=0.35
minBtn.BorderSizePixel=0; minBtn.Text="-"; minBtn.TextColor3=C_WHITE; minBtn.Font=Enum.Font.GothamBlack; minBtn.TextSize=12
Instance.new("UICorner",minBtn).CornerRadius=UDim.new(0,6); local minStroke=Instance.new("UIStroke",minBtn); minStroke.Color=DARK_ACC; minStroke.Thickness=1
minBtn.MouseEnter:Connect(function() TweenService:Create(minBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(50,50,58)}):Play() end)
minBtn.MouseLeave:Connect(function() TweenService:Create(minBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(24,24,28)}):Play() end)

local tabBar=Instance.new("Frame",topbar)
tabBar.Size=UDim2.new(1,-16,0,24)
tabBar.Position=UDim2.new(0,8,0,28)
tabBar.BackgroundTransparency=1
tabBar.BorderSizePixel=0
local tabLayout=Instance.new("UIListLayout",tabBar)
tabLayout.FillDirection=Enum.FillDirection.Horizontal
tabLayout.Padding=UDim.new(0,4)
tabLayout.HorizontalAlignment=Enum.HorizontalAlignment.Left
tabLayout.SortOrder=Enum.SortOrder.LayoutOrder

makeDraggable(topbar, main, function() return State.guiLocked end)

local contentArea=Instance.new("Frame",main); contentArea.Name="ContentArea"; contentArea.Size=UDim2.new(1,0,1,-TOP_H); contentArea.Position=UDim2.new(0,0,0,TOP_H); contentArea.BackgroundColor3=Color3.fromRGB(12,12,14); contentArea.BackgroundTransparency=0.55
contentArea.BorderSizePixel=0; contentArea.ClipsDescendants=true
local caCorner=Instance.new("UICorner",contentArea); caCorner.CornerRadius=UDim.new(0,10)

local function createPage(name)
    local sf=Instance.new("ScrollingFrame",contentArea)
    sf.Name="Page_"..name
    sf.Size=UDim2.new(1,0,1,0)
    sf.BackgroundTransparency=1
    sf.BorderSizePixel=0
    sf.ScrollBarThickness=3
    sf.ScrollBarImageColor3=ACCENT
    sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
    sf.CanvasSize=UDim2.new(0,0,0,0)
    sf.Visible=false
    local lay=Instance.new("UIListLayout",sf); lay.SortOrder=Enum.SortOrder.LayoutOrder; lay.Padding=UDim.new(0,3)
    local pd=Instance.new("UIPadding",sf); pd.PaddingLeft=UDim.new(0,6); pd.PaddingRight=UDim.new(0,6); pd.PaddingTop=UDim.new(0,6); pd.PaddingBottom=UDim.new(0,8)
    return sf
end

local pageMain=createPage("Main")
local pageMechanics=createPage("Mechanics")
local pageExtras=createPage("Extras")
local pageMusic=createPage("Music")
local pageKeybinds=createPage("Keybinds")

local pageOther=pageMechanics
local pageConfig=pageKeybinds
pageMain.Visible=true
local scroll=pageMain
_G.KzsScroll = function() return scroll end
_G.KzsPages = {
    Main=pageMain,
    Mechanics=pageMechanics,
    Extras=pageExtras,
    Music=pageMusic,
    Keybinds=pageKeybinds,
    Other=pageMechanics,
    Config=pageKeybinds,
}

local ALL_PAGES = {pageMain, pageMechanics, pageExtras, pageMusic, pageKeybinds}
local PAGE_NAMES = {"Main","Mechanics","Extras","Music","Keybinds"}

local tabBtns={}
local currentTab = "Main"
local function setTab(name)
    currentTab = name
    pageMain.Visible=(name=="Main")
    pageMechanics.Visible=(name=="Mechanics")
    pageExtras.Visible=(name=="Extras")
    pageMusic.Visible=(name=="Music")
    pageKeybinds.Visible=(name=="Keybinds")
    for n,btn in pairs(tabBtns) do

        if n==name then
            btn.BackgroundColor3=ACCENT
            btn.TextColor3=C_WHITE
            local s=btn:FindFirstChildOfClass("UIStroke"); if s then s.Color=ACCENT; s.Transparency=0.15 end
        else
            btn.BackgroundColor3=Color3.fromRGB(18,18,22)
            btn.TextColor3=C_DIM
            local s=btn:FindFirstChildOfClass("UIStroke"); if s then s.Color=DARK_ACC; s.Transparency=0.45 end
        end
    end
end

local function makeTab(name, order)
    local b=Instance.new("TextButton",tabBar)
    b.Name="Tab_"..name
    b.Size=UDim2.new(0,58,0,22)
    b.BackgroundColor3=(name=="Main") and ACCENT or Color3.fromRGB(18,18,22)
    b.BorderSizePixel=0
    b.Text=name
    b.TextColor3=(name=="Main") and C_WHITE or C_DIM
    b.Font=Enum.Font.GothamBold
    b.TextSize=9
    b.AutoButtonColor=false
    b.LayoutOrder=order
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
    local st=Instance.new("UIStroke",b); st.Color=(name=="Main") and ACCENT or DARK_ACC; st.Thickness=1; st.Transparency=(name=="Main") and 0.15 or 0.45
    b.MouseButton1Click:Connect(function()
        setTab(name)
    end)
    b.MouseEnter:Connect(function()
        if currentTab == name then return end
        b.BackgroundColor3 = Color3.fromRGB(32,32,38)
    end)
    b.MouseLeave:Connect(function()
        if currentTab == name then
            b.BackgroundColor3 = ACCENT
            b.TextColor3 = C_WHITE
        else
            b.BackgroundColor3 = Color3.fromRGB(18,18,22)
            b.TextColor3 = C_DIM
        end
    end)
    tabBtns[name]=b
    return b
end
makeTab("Main",1)
makeTab("Mechanics",2)
makeTab("Extras",3)
makeTab("Music",4)
makeTab("Keybinds",5)

local function forEachPageChild(fn)
    for _, pg in ipairs(ALL_PAGES) do
        for _, child in ipairs(pg:GetChildren()) do
            fn(child)
        end
    end
end

local mini=Instance.new("TextButton",gui); mini.Name="Mini"; mini.Size=UDim2.new(0,120,0,30); mini.Position=UDim2.new(1,-140,0,80); mini.BackgroundColor3=PITCH_BLACK; mini.BackgroundTransparency=0.6
mini.BorderSizePixel=0; mini.Text="NOXTRIXHUB"; mini.TextColor3=ACCENT; mini.Font=Enum.Font.GothamBlack; mini.TextSize=12; mini.Visible=false
Instance.new("UICorner",mini).CornerRadius=UDim.new(0,6); Instance.new("UIStroke",mini).Color=DARK_ACC
makeDraggable(mini, mini, function() return State.guiLocked end)
mini.MouseEnter:Connect(function() TweenService:Create(mini,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(32,32,32)}):Play() end)
mini.MouseLeave:Connect(function() TweenService:Create(mini,TweenInfo.new(0.1),{BackgroundColor3=PITCH_BLACK}):Play() end)

function showGui() main.Visible=true; mini.Visible=false; State.guiVisible=true end
function hideGui() main.Visible=false; mini.Visible=true; State.guiVisible=false end
minBtn.MouseButton1Click:Connect(hideGui); mini.MouseButton1Click:Connect(showGui)

function savePos(frame,file) pcall(function() writefile(file,string.format("%.3f,%.1f,%.3f,%.1f",frame.Position.X.Scale,frame.Position.X.Offset,frame.Position.Y.Scale,frame.Position.Y.Offset)) end) end
function loadPos(frame,file) local str; pcall(function() str=readfile(file) end); if str and str~="" then local p={}; for part in string.gmatch(str,"[^,]+") do table.insert(p,tonumber(part)) end; if #p>=4 then frame.Position=UDim2.new(p[1],p[2],p[3],p[4]) end end end
function loadMainPosition() loadPos(main,"KzsHubMainPos.txt") end
function loadMiniPosition() loadPos(mini,"KzsHubMiniPos.txt") end
local lastMainSave=0; main:GetPropertyChangedSignal("Position"):Connect(function() if tick()-lastMainSave>0.5 then lastMainSave=tick(); savePos(main,"KzsHubMainPos.txt") end end)
local lastMiniSave=0; mini:GetPropertyChangedSignal("Position"):Connect(function() if tick()-lastMiniSave>0.5 then lastMiniSave=tick(); savePos(mini,"KzsHubMiniPos.txt") end end)

local keybindChipRefs={}
function makeSectionLabel(text,parent)
    local wrap=Instance.new("Frame",parent)
    wrap.Size=UDim2.new(1,0,0,22)
    wrap.BackgroundColor3=Color3.fromRGB(20,20,28)
    wrap.BackgroundTransparency=0.35
    wrap.BorderSizePixel=0
    wrap.LayoutOrder=#parent:GetChildren()+1
    Instance.new("UICorner",wrap).CornerRadius=UDim.new(0,8)
    local accent=Instance.new("Frame",wrap)
    accent.Size=UDim2.new(0,3,1,-6)
    accent.Position=UDim2.new(0,4,0,3)
    accent.BackgroundColor3=ACCENT
    accent.BorderSizePixel=0
    Instance.new("UICorner",accent).CornerRadius=UDim.new(1,0)
    local lbl=Instance.new("TextLabel",wrap)
    lbl.Size=UDim2.new(1,-14,1,0)
    lbl.Position=UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency=1
    lbl.Text=text
    lbl.TextColor3=ACCENT
    lbl.Font=Enum.Font.GothamBlack
    lbl.TextSize=11
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    local stroke=Instance.new("UIStroke",wrap)
    stroke.Color=ACCENT
    stroke.Thickness=1
    stroke.Transparency=0.7
end

function makeGap(parent,height)
    local f=Instance.new("Frame",parent); f.Size=UDim2.new(1,0,0,height or 2); f.BackgroundTransparency=1; f.BorderSizePixel=0; f.LayoutOrder=#parent:GetChildren()+1
end

function makeInputRow(label,defaultValue,onChange,parent)
    local row=Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,28); row.BackgroundColor3=C_ROW; row.BackgroundTransparency=TRANSPARENCY_ROW; row.BorderSizePixel=0; row.LayoutOrder=#parent:GetChildren()+1;
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,10)
    local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(0.55,0,1,0); lbl.Position=UDim2.new(0,5,0,0); lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=ACCENT; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=8; lbl.TextXAlignment=Enum.TextXAlignment.Left
    local box=Instance.new("TextBox",row); box.Size=UDim2.new(0,50,0,20); box.Position=UDim2.new(1,-56,0.5,-10); box.BackgroundColor3=PITCH_BLACK; box.BackgroundTransparency=0.3; box.BorderSizePixel=0; box.Text=tostring(defaultValue); box.TextColor3=ACCENT; box.Font=Enum.Font.GothamBold; box.TextSize=9; box.ClearTextOnFocus=true
    Instance.new("UICorner",box).CornerRadius=UDim.new(0,3); local stroke=Instance.new("UIStroke",box); stroke.Color=DARK_ACC
    box.Focused:Connect(function() TweenService:Create(stroke,TweenInfo.new(0.15),{Color=ACCENT}):Play() end)
    box.FocusLost:Connect(function()
        TweenService:Create(stroke,TweenInfo.new(0.15),{Color=DARK_ACC}):Play()
        local num = tonumber(box.Text)
        if num then
            local final = math.clamp(num, 0, 500)
            box.Text = tostring(final)
            if onChange then onChange(final) end
            AutoSave()
        else
            box.Text = tostring(defaultValue)
        end
    end)
    row.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C_ROW_HOV}):Play() end)
    row.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C_ROW}):Play() end)
    return box
end

function makeToggleRow(label,defaultValue,onToggle,parent,keybindStateKey)
    local row=Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,28); row.BackgroundColor3=C_ROW; row.BackgroundTransparency=TRANSPARENCY_ROW; row.BorderSizePixel=0; row.LayoutOrder=#parent:GetChildren()+1;
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,10)
    local lblW=keybindStateKey and 0.48 or 0.65
    local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(lblW,0,1,0); lbl.Position=UDim2.new(0,5,0,0); lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=ACCENT; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=8; lbl.TextXAlignment=Enum.TextXAlignment.Left
    if keybindStateKey then
        local currentKey=State[keybindStateKey]; local keyName=(currentKey and currentKey~=Enum.KeyCode.Unknown) and currentKey.Name or "-"
        local chip=Instance.new("TextButton",row); chip.Size=UDim2.new(0,36,0,14); chip.Position=UDim2.new(1,-90,0.5,-7); chip.BackgroundColor3=PITCH_BLACK; chip.BackgroundTransparency=0.3; chip.BorderSizePixel=0; chip.Text=keyName; chip.TextColor3=Color3.fromRGB(180,180,180); chip.Font=Enum.Font.GothamBold; chip.TextSize=7; chip.AutoButtonColor=false; chip.ZIndex=6
        Instance.new("UICorner",chip).CornerRadius=UDim.new(0,3); local cStroke=Instance.new("UIStroke",chip); cStroke.Color=Color3.fromRGB(55,55,55); cStroke.Thickness=1
        keybindChipRefs[keybindStateKey]=chip
        local listening=false; local lConn=nil
        local function stopListen(key)
            listening=false; if lConn then lConn:Disconnect(); lConn=nil end
            TweenService:Create(cStroke,TweenInfo.new(0.12),{Color=Color3.fromRGB(55,55,55)}):Play(); chip.TextColor3=Color3.fromRGB(180,180,180)
            if key then State[keybindStateKey]=key; chip.Text=key.Name; SetSetting(keybindStateKey, key.Name); AutoSave()
            else local k=State[keybindStateKey]; chip.Text=(k and k~=Enum.KeyCode.Unknown) and k.Name or "-" end
        end
        chip.MouseButton1Click:Connect(function()
            if listening then stopListen(nil); return end
            listening=true; chip.Text="..."; chip.TextColor3=C_WHITE; TweenService:Create(cStroke,TweenInfo.new(0.12),{Color=ACCENT}):Play()
            lConn=UIS.InputBegan:Connect(function(inp,gp) if not listening then return end; if inp.UserInputType==Enum.UserInputType.Keyboard then if inp.KeyCode==Enum.KeyCode.Escape then stopListen(nil); return end; stopListen(inp.KeyCode) end end)
        end)
    end
    local pill=Instance.new("Frame",row); pill.Size=UDim2.new(0,32,0,14); pill.Position=UDim2.new(1,-38,0.5,-7); pill.BackgroundColor3=defaultValue and C_ON_BG or C_OFF_BG; pill.BackgroundTransparency=TRANSPARENCY_PILL; pill.BorderSizePixel=0; pill.ZIndex=5;
    Instance.new("UICorner",pill).CornerRadius=UDim.new(0,10)
    local pStroke=Instance.new("UIStroke",pill); pStroke.Color=defaultValue and ACCENT or DARK_ACC; pStroke.Thickness=1
    local dot=Instance.new("Frame",pill); dot.Size=UDim2.new(0,10,0,10); dot.Position=defaultValue and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,2,0.5,-5); dot.BackgroundColor3=defaultValue and C_WHITE or C_DIM; dot.BorderSizePixel=0; dot.ZIndex=6; Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
    local isOn=defaultValue
    local function setV(on)
        isOn=on
        TweenService:Create(pill,TweenInfo.new(0.18),{BackgroundColor3=on and C_ON_BG or C_OFF_BG}):Play()
        TweenService:Create(pStroke,TweenInfo.new(0.18),{Color=on and ACCENT or DARK_ACC}):Play()
        TweenService:Create(dot,TweenInfo.new(0.18,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,2,0.5,-5),BackgroundColor3=on and C_WHITE or C_DIM}):Play()
    end
    local btn=Instance.new("TextButton",row); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""; btn.ZIndex=3
    btn.MouseButton1Click:Connect(function() isOn=not isOn; setV(isOn); if onToggle then onToggle(isOn) end; AutoSave() end)
    row.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C_ROW_HOV}):Play() end)
    row.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C_ROW}):Play() end)
    return setV
end

function makeDropActionRow(label, parent)
    local row=Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,26); row.BackgroundColor3=C_ROW; row.BackgroundTransparency=TRANSPARENCY_ROW; row.BorderSizePixel=0; row.LayoutOrder=#parent:GetChildren()+1;
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,10)
    local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(0.65,0,1,0); lbl.Position=UDim2.new(0,5,0,0); lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=ACCENT; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=8; lbl.TextXAlignment=Enum.TextXAlignment.Left
    local actionBtn=Instance.new("TextButton",row); actionBtn.Size=UDim2.new(0,40,0,18); actionBtn.Position=UDim2.new(1,-48,0.5,-9); actionBtn.BackgroundColor3=PITCH_BLACK; actionBtn.BackgroundTransparency=0.3; actionBtn.BorderSizePixel=0; actionBtn.Text="BURST"; actionBtn.TextColor3=ACCENT; actionBtn.Font=Enum.Font.GothamBold; actionBtn.TextSize=7; actionBtn.ZIndex=5
    Instance.new("UICorner",actionBtn).CornerRadius=UDim.new(0,3); Instance.new("UIStroke",actionBtn).Color=DARK_ACC
    actionBtn.MouseButton1Click:Connect(function()
        if _G.stopTpBat then _G.stopTpBat() end
        runDropBrainrot()
        TweenService:Create(actionBtn,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(0, 100, 200)}):Play()
        task.delay(0.12, function()
            TweenService:Create(actionBtn,TweenInfo.new(0.08),{BackgroundColor3=PITCH_BLACK}):Play()
        end)
    end)
    row.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C_ROW_HOV}):Play() end)
    row.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C_ROW}):Play() end)
    return actionBtn
end

function makeSkyDropdown(parent, selectedIndex, onSelect)
    local frame = Instance.new("Frame", parent); frame.Size = UDim2.new(1,0,0,20); frame.BackgroundColor3 = C_ROW; frame.BackgroundTransparency=TRANSPARENCY_ROW; frame.BorderSizePixel = 0; frame.LayoutOrder = #parent:GetChildren()+1
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)
    local lbl = Instance.new("TextLabel", frame); lbl.Size = UDim2.new(0,60,1,0); lbl.Position = UDim2.new(0,5,0,0); lbl.BackgroundTransparency=1; lbl.Text=SKY_THEMES[selectedIndex].name; lbl.TextColor3=ACCENT; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=8; lbl.TextXAlignment=Enum.TextXAlignment.Left
    local arrow = Instance.new("TextButton", frame); arrow.Size=UDim2.new(0,15,1,0); arrow.Position=UDim2.new(1,-20,0,0); arrow.BackgroundTransparency=1; arrow.Text="v"; arrow.TextColor3=ACCENT; arrow.Font=Enum.Font.GothamBold; arrow.TextSize=7; arrow.ZIndex=10
    local dropFrame = Instance.new("Frame", gui); dropFrame.Name="SkyDropdown"; dropFrame.BackgroundColor3=Color3.fromRGB(16,16,16); dropFrame.BackgroundTransparency=0.8; dropFrame.BorderSizePixel=0; dropFrame.ClipsDescendants=false; dropFrame.Visible=false; dropFrame.ZIndex=99
    Instance.new("UICorner",dropFrame).CornerRadius=UDim.new(0,4)
    local dropLayout=Instance.new("UIListLayout",dropFrame); dropLayout.SortOrder=Enum.SortOrder.LayoutOrder; dropLayout.Padding=UDim.new(0,1)
    local dropPad=Instance.new("UIPadding",dropFrame); dropPad.PaddingTop=UDim.new(0,2); dropPad.PaddingBottom=UDim.new(0,2); dropPad.PaddingLeft=UDim.new(0,2); dropPad.PaddingRight=UDim.new(0,2)
    for i, theme in ipairs(SKY_THEMES) do
        local row=Instance.new("TextButton",dropFrame); row.Size=UDim2.new(1,0,0,18); row.BackgroundColor3=(i==selectedIndex) and Color3.fromRGB(35,35,40) or Color3.fromRGB(16,16,16); row.BackgroundTransparency=0.6; row.BorderSizePixel=0; row.LayoutOrder=i; row.ZIndex=100; row.Text=""; row.AutoButtonColor=false
        local dot=Instance.new("Frame",row); dot.Size=UDim2.new(0,8,0,8); dot.Position=UDim2.new(0,5,0.5,-4); dot.BackgroundColor3=theme.dot; dot.BorderSizePixel=0; dot.ZIndex=101; Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
        local nameLbl=Instance.new("TextLabel",row); nameLbl.Size=UDim2.new(1,-22,1,0); nameLbl.Position=UDim2.new(0,18,0,0); nameLbl.BackgroundTransparency=1; nameLbl.Text=theme.name; nameLbl.TextColor3=(i==selectedIndex) and C_WHITE or C_DIM; nameLbl.Font=Enum.Font.GothamBold; nameLbl.TextSize=6; nameLbl.TextXAlignment=Enum.TextXAlignment.Left; nameLbl.ZIndex=101
        local capturedIdx=i
        row.MouseButton1Click:Connect(function()
            lbl.Text=theme.name; dropFrame.Visible=false
            for j, child in ipairs(dropFrame:GetChildren()) do if child:IsA("TextButton") then child.BackgroundColor3=(j==capturedIdx) and Color3.fromRGB(35,35,40) or Color3.fromRGB(16,16,16); child:FindFirstChildOfClass("TextLabel").TextColor3=(j==capturedIdx) and C_WHITE or C_DIM end end
            if onSelect then onSelect(capturedIdx) end
        end)
    end
    dropFrame.Size=UDim2.new(0, CONTENT_WIDTH-8, 0, #SKY_THEMES*19+4)
    arrow.MouseButton1Click:Connect(function()
        if dropFrame.Visible then dropFrame.Visible=false; return end
        local absPos=frame.AbsolutePosition; local absSize=frame.AbsoluteSize
        dropFrame.Position=UDim2.new(0, absPos.X, 0, absPos.Y+absSize.Y+2)
        dropFrame.Visible=true
    end)
    UIS.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 and dropFrame.Visible then dropFrame.Visible=false end end)
    return function(idx) lbl.Text=SKY_THEMES[idx].name end
end

local mbScaleFactor = 1.0
local applyMBScale

local currentCat = ("Speed")
function refreshUIToggles()
    if State.laggerLevel > 0 then
        modeValLbl.Text = "Lagger " .. State.laggerLevel
    else
        modeValLbl.Text = (State.speedType == "normal" and "Normal" or "Carry")
    end
end

function buildFullGUI()
    for _, pg in ipairs(ALL_PAGES) do
        for _, child in ipairs(pg:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then child:Destroy() end
        end
    end
    scroll = pageMain
    setTab("Main")

    makeSectionLabel("Speeds", scroll)

    local set1Label = Instance.new("TextLabel", scroll)
    set1Label.Size = UDim2.new(1,0,0,14)
    set1Label.BackgroundTransparency = 1
    set1Label.Text = "Mode 1"
    set1Label.TextColor3 = ACCENT
    set1Label.Font = Enum.Font.GothamBold
    set1Label.TextSize = 7
    set1Label.TextXAlignment = Enum.TextXAlignment.Center
    set1Label.LayoutOrder = #scroll:GetChildren()+1

    normalBox = makeInputRow("Normal", State.normalSpeed, function(v) State.normalSpeed=v; SetSetting("normalSpeed",v) end, scroll)
    carryBox  = makeInputRow("Carry",  State.carrySpeed,  function(v) State.carrySpeed=v;  SetSetting("carrySpeed",v) end, scroll)

    local set2Label = Instance.new("TextLabel", scroll)
    set2Label.Size = UDim2.new(1,0,0,14)
    set2Label.BackgroundTransparency = 1
    set2Label.Text = "Mode 2"
    set2Label.TextColor3 = ACCENT
    set2Label.Font = Enum.Font.GothamBold
    set2Label.TextSize = 7
    set2Label.TextXAlignment = Enum.TextXAlignment.Center
    set2Label.LayoutOrder = #scroll:GetChildren()+1

    local normalBox2 = makeInputRow("Normal 2", State.normalSpeed2, function(v) State.normalSpeed2=v; SetSetting("normalSpeed2",v) end, scroll)
    local carryBox2  = makeInputRow("Carry 2",  State.carrySpeed2,  function(v) State.carrySpeed2=v;  SetSetting("carrySpeed2",v) end, scroll)

    local set3Label = Instance.new("TextLabel", scroll)
    set3Label.Size = UDim2.new(1,0,0,14)
    set3Label.BackgroundTransparency = 1
    set3Label.Text = "Mode 3"
    set3Label.TextColor3 = ACCENT
    set3Label.Font = Enum.Font.GothamBold
    set3Label.TextSize = 7
    set3Label.TextXAlignment = Enum.TextXAlignment.Center
    set3Label.LayoutOrder = #scroll:GetChildren()+1

    local normalBox3 = makeInputRow("Normal 3", State.normalSpeed3, function(v)
        State.normalSpeed3 = math.clamp(v, 0, 500)
        SetSetting("normalSpeed3", State.normalSpeed3)
    end, scroll)
    local carryBox3  = makeInputRow("Carry 3",  State.carrySpeed3,  function(v)
        State.carrySpeed3 = math.clamp(v, 0, 500)
        SetSetting("carrySpeed3", State.carrySpeed3)
    end, scroll)

    makeGap(scroll,2)

    makeGap(scroll,2)
    makeGap(scroll,4)

    makeSectionLabel("Lagger Speeds", scroll)

    lagger1Box = makeInputRow("Lagger 1", State.laggerSpeed1, function(v)
        State.laggerSpeed1 = math.clamp(v, 1, 200)
        SetSetting("laggerSpeed1", State.laggerSpeed1)
    end, scroll)

    lagger2Box = makeInputRow("Lagger 2", State.laggerSpeed2, function(v)
        State.laggerSpeed2 = math.clamp(v, 1, 200)
        SetSetting("laggerSpeed2", State.laggerSpeed2)
    end, scroll)
    do
        local row = Instance.new("Frame", scroll)
        row.Size = UDim2.new(1,0,0,26)
        row.BackgroundColor3 = C_ROW
        row.BackgroundTransparency = TRANSPARENCY_ROW
        row.BorderSizePixel = 0
        row.LayoutOrder = #scroll:GetChildren()+1
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,10)
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.55,0,1,0)
        lbl.Position = UDim2.new(0,5,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Lagger Key"
        lbl.TextColor3 = ACCENT
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 8
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local currentKey = State.keyLagger
        local keyName = (currentKey and currentKey ~= Enum.KeyCode.Unknown) and currentKey.Name or "-"
        local chip = Instance.new("TextButton", row)
        chip.Size = UDim2.new(0, 70, 0, 18)
        chip.Position = UDim2.new(1, -78, 0.5, -9)
        chip.BackgroundColor3 = PITCH_BLACK
        chip.Text = keyName
        chip.TextColor3 = ACCENT
        chip.Font = Enum.Font.GothamBold
        chip.TextSize = 9
        chip.AutoButtonColor = false
        Instance.new("UICorner", chip).CornerRadius = UDim.new(0,6)
        keybindChipRefs["keyLagger"] = chip
        chip.MouseButton1Click:Connect(function()
            chip.Text = "..."
            local conn
            conn = UIS.InputBegan:Connect(function(inp, gp)
                if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
                local key = inp.KeyCode
                if key == Enum.KeyCode.Escape then
                    local k = State.keyLagger
                    chip.Text = (k and k ~= Enum.KeyCode.Unknown) and k.Name or "-"
                    conn:Disconnect()
                    return
                end
                State.keyLagger = key
                chip.Text = key.Name
                SetSetting("keyLagger", key.Name)
                AutoSave()
                conn:Disconnect()
            end)
        end)
    end

    makeGap(scroll,2)

    local modeRow = Instance.new("Frame", scroll); modeRow.Size = UDim2.new(1,0,0,26); modeRow.BackgroundColor3 = C_ROW; modeRow.BackgroundTransparency=TRANSPARENCY_ROW; modeRow.LayoutOrder = #scroll:GetChildren()+1; Instance.new("UICorner",modeRow).CornerRadius=UDim.new(0,10)
    local modeLbl = Instance.new("TextLabel", modeRow); modeLbl.Size=UDim2.new(0.4,0,1,0); modeLbl.Position=UDim2.new(0,5,0,0); modeLbl.BackgroundTransparency=1; modeLbl.Text="Mode"; modeLbl.TextColor3=ACCENT; modeLbl.Font=Enum.Font.GothamBold; modeLbl.TextSize=8
    modeValLbl = Instance.new("TextLabel", modeRow); modeValLbl.Size=UDim2.new(0.6,-5,1,0); modeValLbl.Position=UDim2.new(0.4,0,0,0); modeValLbl.BackgroundTransparency=1
    if State.laggerLevel > 0 then
        modeValLbl.Text = "Lagger " .. State.laggerLevel
    else
        modeValLbl.Text = (State.speedType=="normal" and "Normal" or "Carry")
    end
    modeValLbl.TextColor3=ACCENT; modeValLbl.Font=Enum.Font.GothamBold; modeValLbl.TextSize=8; modeValLbl.TextXAlignment=Enum.TextXAlignment.Right
    local btnW,btnH=44,16
    local normalBtn=Instance.new("TextButton",modeRow); normalBtn.Size=UDim2.new(0,btnW,0,btnH); normalBtn.Position=UDim2.new(0.4,0,0.5,-btnH/2-1); normalBtn.BackgroundColor3=PITCH_BLACK; normalBtn.BackgroundTransparency=0.3; normalBtn.Text="N"; normalBtn.TextColor3=ACCENT; normalBtn.Font=Enum.Font.GothamBold; normalBtn.TextSize=7; Instance.new("UICorner",normalBtn).CornerRadius=UDim.new(0,3)
    local carryBtn=Instance.new("TextButton",modeRow); carryBtn.Size=UDim2.new(0,btnW,0,btnH); carryBtn.Position=UDim2.new(0.4,btnW+2,0.5,-btnH/2-1); carryBtn.BackgroundColor3=PITCH_BLACK; carryBtn.BackgroundTransparency=0.3; carryBtn.Text="C"; carryBtn.TextColor3=ACCENT; carryBtn.Font=Enum.Font.GothamBold; carryBtn.TextSize=7; Instance.new("UICorner",carryBtn).CornerRadius=UDim.new(0,3)
    _G._carryModeBtn = carryBtn
    carryBtn.Visible = not State.autoCarryEnabled
    local laggerBtn=Instance.new("TextButton",modeRow); laggerBtn.Size=UDim2.new(0,btnW,0,btnH); laggerBtn.Position=UDim2.new(0.4,(btnW+2)*2,0.5,-btnH/2-1); laggerBtn.BackgroundColor3=(State.laggerLevel > 0) and Color3.fromRGB(70, 70, 70) or PITCH_BLACK; laggerBtn.BackgroundTransparency=0.3
    laggerBtn.Text = (State.laggerLevel == 0 and "L") or (State.laggerLevel == 1 and "L1") or "L2"
    laggerBtn.TextColor3=ACCENT; laggerBtn.Font=Enum.Font.GothamBold; laggerBtn.TextSize=7; Instance.new("UICorner",laggerBtn).CornerRadius=UDim.new(0,3)

    local function updateMode()
        if State.laggerLevel > 0 then
            modeValLbl.Text = "Lagger " .. State.laggerLevel
            laggerBtn.Text = (State.laggerLevel == 1 and "L1") or "L2"
            laggerBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        else
            modeValLbl.Text = (State.speedType == "normal" and "Normal" or "Carry")
            laggerBtn.Text = "L"
            laggerBtn.BackgroundColor3 = PITCH_BLACK
        end
    end
    local function cycleLagger()
        if _G.stopTpBat then _G.stopTpBat() end
        if State.laggerLevel == 0 then
            State.laggerLevel = 1
        elseif State.laggerLevel == 1 then
            State.laggerLevel = 2
        else
            State.laggerLevel = 1
        end
        State.speedType = "normal"

        if State.laggerLevel == 0 then
            if setMB_CS then setMB_CS(State.speedType == "carry") end
        else
            if setMB_CS then setMB_CS(false) end
        end

        SetSetting("laggerLevel", State.laggerLevel)
        SetSetting("speedType", State.speedType)
        updateMode()
        refreshUIToggles()

        if setMB_LC then setMB_LC() end
    end

    normalBtn.MouseButton1Click:Connect(function()
        if _G.stopTpBat then _G.stopTpBat() end
        if State.laggerLevel > 0 then
            State.laggerLevel = 0
            SetSetting("laggerLevel", 0)
            updateMode()
            refreshUIToggles()
            if setMB_LC then setMB_LC() end
        end
        State.speedType = "normal"
        updateMode()
        SetSetting("speedType", "normal")
        if setMB_CS then setMB_CS(false) end
    end)

    carryBtn.MouseButton1Click:Connect(function()
        if _G.stopTpBat then _G.stopTpBat() end
        if State.laggerLevel > 0 then
            State.laggerLevel = 0
            SetSetting("laggerLevel", 0)
            updateMode()
            refreshUIToggles()
            if setMB_LC then setMB_LC() end
        end
        State.speedType = "carry"
        updateMode()
        SetSetting("speedType", "carry")
        if setMB_CS then setMB_CS(true) end
    end)

    laggerBtn.MouseButton1Click:Connect(cycleLagger)

    makeGap(scroll,4)

    makeToggleRow("Auto Carry", State.autoCarryEnabled, function(on)
        State.autoCarryEnabled = on
        SetSetting("autoCarryEnabled", on)
        if _G._carryModeBtn then
            _G._carryModeBtn.Visible = not on
        end
        if on then
            if State.speedType == "carry" then
                State.speedType = "normal"
                SetSetting("speedType", "normal")
                if modeValLbl then modeValLbl.Text = "Normal" end
                if setMB_CS then setMB_CS(false) end
            end
        end
        if updateMode then pcall(updateMode) end
    end, scroll)

    scroll = pageMechanics

    makeSectionLabel("Mechanics", scroll)

    setInstaGrab = makeToggleRow("Auto Steal", AutoStealEnabled, function(on)
        setAutoStealEnabled(on)
    end, scroll)
    setInstaGrab(AutoStealEnabled)

    makeInputRow("Hold Max", STEAL_DURATION, function(v)
        v = math.clamp(tonumber(v) or 2.6, 0.5, 10)
        STEAL_DURATION = v
        SetSetting("stealDuration", v)
        if _G.StealBar and _G.StealBar.setHoldMax then
            _G.StealBar.setHoldMax(v)
        end
    end, scroll)

    makeInputRow("Prime Range", STEAL_RADIUS, function(v)
        v = math.clamp(tonumber(v) or 80, 1, 300)
        STEAL_RADIUS = v
        SetSetting("grabRadius", v)
        if _G.StealBar and _G.StealBar.setRadius then
            _G.StealBar.setRadius(v)
        end
    end, scroll)

    makeToggleRow("Anti Player Collision", State.antiPlayerCollision, function(on)
        State.antiPlayerCollision = on
        SetSetting("antiPlayerCollision", on)
        if on then startAntiPlayerCollision() else stopAntiPlayerCollision() end
    end, scroll)


    makeToggleRow("Inf Jump", State.infJumpEnabled, function(on) State.infJumpEnabled=on; SetSetting("infJumpEnabled",on) end, scroll)
    local jmRow=Instance.new("Frame",scroll)
    jmRow.Size=UDim2.new(1,0,0,26); jmRow.BackgroundColor3=C_ROW; jmRow.BackgroundTransparency=TRANSPARENCY_ROW; jmRow.BorderSizePixel=0
    jmRow.LayoutOrder=#scroll:GetChildren()+1
    Instance.new("UICorner",jmRow).CornerRadius=UDim.new(0,10)
    local jmLbl=Instance.new("TextLabel",jmRow)
    jmLbl.Size=UDim2.new(0,62,1,0); jmLbl.Position=UDim2.new(0,5,0,0)
    jmLbl.BackgroundTransparency=1; jmLbl.Text="Jump Mode"
    jmLbl.TextColor3=ACCENT; jmLbl.Font=Enum.Font.GothamBold; jmLbl.TextSize=8
    local manualBtn=Instance.new("TextButton",jmRow)
    manualBtn.Size=UDim2.new(0,50,0,18); manualBtn.Position=UDim2.new(0,68,0.5,-9)
    manualBtn.BackgroundColor3=State.infJumpMode=="manual" and C_ON_BG or PITCH_BLACK; manualBtn.BackgroundTransparency=0.3
    manualBtn.Text="Manual"; manualBtn.TextColor3=ACCENT; manualBtn.Font=Enum.Font.GothamBold; manualBtn.TextSize=7
    Instance.new("UICorner",manualBtn).CornerRadius=UDim.new(0,3)
    local holdBtn2=Instance.new("TextButton",jmRow)
    holdBtn2.Size=UDim2.new(0,50,0,18); holdBtn2.Position=UDim2.new(0,122,0.5,-9)
    holdBtn2.BackgroundColor3=State.infJumpMode=="hold" and C_ON_BG or PITCH_BLACK; holdBtn2.BackgroundTransparency=0.3
    holdBtn2.Text="Hold"; holdBtn2.TextColor3=ACCENT; holdBtn2.Font=Enum.Font.GothamBold; holdBtn2.TextSize=7
    Instance.new("UICorner",holdBtn2).CornerRadius=UDim.new(0,3)
    local function updateJM()
        manualBtn.BackgroundColor3=State.infJumpMode=="manual" and C_ON_BG or PITCH_BLACK
        holdBtn2.BackgroundColor3=State.infJumpMode=="hold" and C_ON_BG or PITCH_BLACK
    end
    manualBtn.MouseButton1Click:Connect(function() State.infJumpMode="manual"; updateJM(); SetSetting("infJumpMode","manual") end)
    holdBtn2.MouseButton1Click:Connect(function() State.infJumpMode="hold"; updateJM(); SetSetting("infJumpMode","hold") end)

    makeGap(scroll,2)

    local tpBatSetterMech = makeToggleRow("TP Bat", _G.tpBatModeActive or false, function(on)
        if _G.setTpBatMode then
            _G.setTpBatMode(on)
        end
    end, scroll)
    table.insert(_G.tpBatToggleSetters, tpBatSetterMech)
    makeGap(scroll,2)

    local antiRagRow = Instance.new("Frame", scroll)
    antiRagRow.Size = UDim2.new(1,0,0,26)
    antiRagRow.BackgroundColor3 = C_ROW
    antiRagRow.BackgroundTransparency = TRANSPARENCY_ROW
    antiRagRow.BorderSizePixel = 0
    antiRagRow.LayoutOrder = #scroll:GetChildren()+1
    Instance.new("UICorner", antiRagRow).CornerRadius = UDim.new(0,10)

    local lbl = Instance.new("TextLabel", antiRagRow)
    lbl.Size = UDim2.new(0.35,0,1,0)
    lbl.Position = UDim2.new(0,5,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Anti Ragdoll"
    lbl.TextColor3 = ACCENT
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 8
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local pill = Instance.new("Frame", antiRagRow)
    pill.Size = UDim2.new(0,32,0,14)
    pill.Position = UDim2.new(0.5, -30, 0.5, -7)
    pill.BackgroundColor3 = (State.antiRagdollActiveVersion ~= 0) and C_ON_BG or C_OFF_BG
    pill.BackgroundTransparency = TRANSPARENCY_PILL
    pill.BorderSizePixel = 0
    pill.ZIndex = 5
    Instance.new("UICorner", pill).CornerRadius = UDim.new(0,10)
    local pStroke = Instance.new("UIStroke", pill)
    pStroke.Color = (State.antiRagdollActiveVersion ~= 0) and ACCENT or DARK_ACC
    pStroke.Thickness = 1
    local dot = Instance.new("Frame", pill)
    dot.Size = UDim2.new(0,10,0,10)
    dot.Position = (State.antiRagdollActiveVersion ~= 0) and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,2,0.5,-5)
    dot.BackgroundColor3 = (State.antiRagdollActiveVersion ~= 0) and C_WHITE or C_DIM
    dot.BorderSizePixel = 0
    dot.ZIndex = 6
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

    local function updateAntiRagUI(version)
        local isOn = version ~= 0
        pill.BackgroundColor3 = isOn and C_ON_BG or C_OFF_BG
        pStroke.Color = isOn and ACCENT or DARK_ACC
        dot.Position = isOn and UDim2.new(1,-13,0.5,-5) or UDim2.new(0,2,0.5,-5)
        dot.BackgroundColor3 = isOn and C_WHITE or C_DIM
        for _, child in ipairs(antiRagRow:GetChildren()) do
            if child:IsA("TextButton") then
                if child.Text == "V1" then
                    if version == 1 then
                        child.BackgroundColor3 = ACCENT
                        child.BackgroundTransparency = 0.3
                        child.TextColor3 = C_WHITE
                    else
                        child.BackgroundColor3 = Color3.fromRGB(30,30,30)
                        child.BackgroundTransparency = 0.3
                        child.TextColor3 = C_DIM
                    end
                elseif child.Text == "V2" then
                    if version == 2 then
                        child.BackgroundColor3 = ACCENT
                        child.BackgroundTransparency = 0.3
                        child.TextColor3 = C_WHITE
                    else
                        child.BackgroundColor3 = Color3.fromRGB(30,30,30)
                        child.BackgroundTransparency = 0.3
                        child.TextColor3 = C_DIM
                    end
                end
            end
        end
        task.spawn(function()
            local sg = game:GetService("CoreGui"):FindFirstChild("InternalAntiRagdoll")
            if not sg then sg = LP.PlayerGui:FindFirstChild("InternalAntiRagdoll") end
            if sg then
                local btn = sg:FindFirstChildWhichIsA("TextButton")
                if btn then
                    if isOn then
                        btn.Text = "ANTIRAGDOLL: ON"
                        btn.TextColor3 = Color3.fromRGB(0, 180, 255)
                        local stroke = btn:FindFirstChildWhichIsA("UIStroke")
                        if stroke then stroke.Color = Color3.fromRGB(0, 180, 255) end
                    else
                        btn.Text = "ANTIRAGDOLL: OFF"
                        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        local stroke = btn:FindFirstChildWhichIsA("UIStroke")
                        if stroke then stroke.Color = Color3.fromRGB(255, 0, 0) end
                    end
                end
            end
        end)
    end

    local btnPill = Instance.new("TextButton", antiRagRow)
    btnPill.Size = UDim2.new(0,32,0,14)
    btnPill.Position = pill.Position
    btnPill.BackgroundTransparency = 1
    btnPill.Text = ""
    btnPill.ZIndex = 7
    btnPill.MouseButton1Click:Connect(function()
        if State.antiRagdollActiveVersion == 0 then
            local newVersion = 1
            if State.antiRagdollV1Enabled then newVersion = 1
            elseif State.antiRagdollV2Enabled then newVersion = 2 end
            setAntiRagdollVersion(newVersion)
        else
            setAntiRagdollVersion(0)
        end
        updateAntiRagUI(State.antiRagdollActiveVersion)
    end)

    local function makeVersionBtn(text, version)
        local btn = Instance.new("TextButton", antiRagRow)
        btn.Size = UDim2.new(0,24,0,16)
        btn.Position = UDim2.new(1, -(version == 1 and 56 or 30), 0.5, -8)
        local isActive = (State.antiRagdollActiveVersion == version)
        btn.BackgroundColor3 = isActive and ACCENT or Color3.fromRGB(30,30,30)
        btn.BackgroundTransparency = 0.3
        btn.Text = text
        btn.TextColor3 = isActive and C_WHITE or C_DIM
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 7
        btn.BorderSizePixel = 0
        btn.ZIndex = 5
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,3)
        if not isActive then
            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = DARK_ACC
            stroke.Thickness = 1
        end
        btn.MouseButton1Click:Connect(function()
            if State.antiRagdollActiveVersion == version then
                setAntiRagdollVersion(0)
            else
                setAntiRagdollVersion(version)
            end
            updateAntiRagUI(State.antiRagdollActiveVersion)
        end)
        return btn
    end

    local v1Btn = makeVersionBtn("V1", 1)
    local v2Btn = makeVersionBtn("V2", 2)
    updateAntiRagUI(State.antiRagdollActiveVersion)

    makeToggleRow("FPS Boost", State.fpsBoostEnabled, function(on)
        State.fpsBoostEnabled = on
        if on then
            applyFPSBoost()
        else
            if Conns.fpsBoostMonitor then
                Conns.fpsBoostMonitor:Disconnect()
                Conns.fpsBoostMonitor = nil
            end
            if not State.skyEnabled then
                pcall(function()
                    local L = game:GetService("Lighting")
                    if _skyOriginals then
                        L.Brightness = _skyOriginals.Brightness
                        L.Ambient = _skyOriginals.Ambient
                        L.OutdoorAmbient = _skyOriginals.OutdoorAmbient
                        L.TimeOfDay = _skyOriginals.TimeOfDay
                        L.ClockTime = _skyOriginals.ClockTime
                        L.FogEnd = _skyOriginals.FogEnd
                        L.GlobalShadows = _skyOriginals.GlobalShadows
                    end
                end)
            end
        end
        SetSetting("fpsBoostEnabled", State.fpsBoostEnabled)
    end, scroll)
    makeToggleRow("Medusa Counter", State.medusaCounterEnabled, function(on) State.medusaCounterEnabled=on; if on then setupMedusaCounter(LP.Character) else stopMedusaCounter() end; SetSetting("medusaCounterEnabled",on) end, scroll)
    makeToggleRow("Bat Counter", State.batCounterEnabled, function(on)
        State.batCounterEnabled=on
        if on then startBatCounter() else stopBatCounter() end
        SetSetting("batCounterEnabled",on)
    end, scroll)
    makeToggleRow("Anim Pack", State.animEnabled, function(on) State.animEnabled=on; if on then startAnimToggle() else stopAnimToggle() end; SetSetting("animEnabled",on) end, scroll)
    makeToggleRow("Unwalk", State.unwalkEnabled, function(on) if on then startUnwalk() else stopUnwalk() end; SetSetting("unwalkEnabled",on) end, scroll)
    makeToggleRow("Hitbux", State.hitbuxEnabled, function(on)
        State.hitbuxEnabled = on
        SetSetting("hitbuxEnabled", on)
        if on then
            startHitbux()
        else
            stopHitbux()
        end
    end, scroll)

    makeInputRow("Body Range", bodyLockRange, function(v)
        bodyLockRange = math.clamp(v, 5, 100)
        State.bodyLockRange = bodyLockRange
        SetSetting("bodyLockRange", bodyLockRange)
    end, scroll)

    local bodyLockSetter = makeToggleRow("Melee Aimbot", State.bodyLockEnabled, function(on)
        State.bodyLockEnabled = on
        bodyLockEnabled = on
        SetSetting("bodyLockEnabled", on)
        if on then
            startBodyLock()
        else
            stopBodyLock()
        end
    end, scroll)
    bodyLockSetVisual = bodyLockSetter

    makeGap(scroll,6)

    makeSectionLabel("Teleport / Utility", scroll)
    makeDropActionRow("Drop BR", scroll)
    makeInputRow("Tp Height", State.autoTpDownY, function(v) State.autoTpDownY=v; SetSetting("autoTpDownY",v) end, scroll)

    makeGap(scroll,6)

    makeSectionLabel("Visuals", scroll)
    if State.skyEnabled then
        makeSkyDropdown(scroll, State.skyColorIndex, function(idx)
            State.skyColorIndex=idx
            SetSetting("skyColorIndex",idx)
            applySky(idx)
        end)
    end
    makeToggleRow("Stretch Rez", State.stretchRezEnabled, function(on) if on then enableStretchRez() else disableStretchRez() end; SetSetting("stretchRezEnabled",on) end, scroll)
    makeToggleRow("Waypoint ESP", State.waypointESPEnabled, function(on) State.waypointESPEnabled=on; if on then startWaypointESP() else stopWaypointESP() end; SetSetting("waypointESPEnabled",on) end, scroll)
    local galaxyRow = Instance.new("Frame", scroll)
    galaxyRow.Size = UDim2.new(1,0,0,26)
    galaxyRow.BackgroundColor3 = C_ROW
    galaxyRow.BackgroundTransparency = TRANSPARENCY_ROW
    galaxyRow.BorderSizePixel = 0
    galaxyRow.LayoutOrder = #scroll:GetChildren()+1
    Instance.new("UICorner", galaxyRow).CornerRadius = UDim.new(0,10)
    local galaxyLbl = Instance.new("TextLabel", galaxyRow)
    galaxyLbl.Size = UDim2.new(0.65,0,1,0)
    galaxyLbl.Position = UDim2.new(0,5,0,0)
    galaxyLbl.BackgroundTransparency = 1
    galaxyLbl.Text = "Galaxy Effect"
    galaxyLbl.TextColor3 = ACCENT
    galaxyLbl.Font = Enum.Font.GothamBold
    galaxyLbl.TextSize = 8
    local galaxyBtn = Instance.new("TextButton", galaxyRow)
    galaxyBtn.Size = UDim2.new(0,32,0,14)
    galaxyBtn.Position = UDim2.new(1,-38,0.5,-7)
    galaxyBtn.BackgroundColor3 = C_OFF_BG
    galaxyBtn.BackgroundTransparency = TRANSPARENCY_PILL
    galaxyBtn.BorderSizePixel = 0
    galaxyBtn.Text = "ON"
    galaxyBtn.TextColor3 = C_DIM
    galaxyBtn.Font = Enum.Font.GothamBold
    galaxyBtn.TextSize = 7
    Instance.new("UICorner", galaxyBtn).CornerRadius = UDim.new(0,7)
    local galaxyStroke = Instance.new("UIStroke", galaxyBtn)
    galaxyStroke.Color = DARK_ACC
    galaxyStroke.Thickness = 1
    local galaxyActive = false

    local function syncGalaxyUI(active)
        if active then
            galaxyBtn.Text = "ON"
            galaxyBtn.BackgroundColor3 = C_ON_BG
            galaxyBtn.TextColor3 = C_WHITE
            galaxyStroke.Color = ACCENT
        else
            galaxyBtn.Text = "OFF"
            galaxyBtn.BackgroundColor3 = C_OFF_BG
            galaxyBtn.TextColor3 = C_DIM
            galaxyStroke.Color = DARK_ACC
        end
        galaxyActive = active
    end

    galaxyBtn.MouseButton1Click:Connect(function()
        if galaxyActive then
            disableSky()
            syncGalaxyUI(false)
        else
            local galaxyIdx = #SKY_THEMES
            State.skyColorIndex = galaxyIdx
            enableSky(galaxyIdx)
            syncGalaxyUI(true)
        end
        SetSetting("skyEnabled", State.skyEnabled)
        SetSetting("skyColorIndex", State.skyColorIndex)
    end)

    if State.skyEnabled and State.skyColorIndex == #SKY_THEMES then
        syncGalaxyUI(true)
    else
        syncGalaxyUI(false)
    end

    makeGap(scroll,4)

    -- ============================================================
    -- MUSIC TOGGLES INDIVIDUALES (5 canciones)
    -- ============================================================
    scroll = pageMusic
    makeSectionLabel("Music", scroll)

    for _, song in ipairs(SONG_LIST) do
        local stateKey = song.configKey
        local defaultOn = State[stateKey] == true

        local setter = makeToggleRow(
            song.display,
            defaultOn,
            function(on)
                State[stateKey] = on
                SetSetting(stateKey, on)

                local musicObj = musicSounds[song.key]
                if musicObj then
                    musicObj.toggle(on)
                end

                if on then
                    -- Detener todas las demás canciones
                    for _, otherSong in ipairs(SONG_LIST) do
                        if otherSong.key ~= song.key then
                            local otherStateKey = otherSong.configKey
                            if State[otherStateKey] then
                                State[otherStateKey] = false
                                SetSetting(otherStateKey, false)
                                if musicSettters[otherSong.key] then
                                    musicSettters[otherSong.key](false)
                                end
                            end
                        end
                    end
                end
            end,
            scroll
        )

        musicSettters[song.key] = setter
    end

    -- ============================================================

    scroll = pageKeybinds
    makeSectionLabel("Controller", scroll)
    makeToggleRow("Controller", State.controllerEnabled, function(on)
        State.controllerEnabled = on; SetSetting("controllerEnabled", on)
        if on then startControllerSupport() end
    end, scroll)
    if State.controllerEnabled then
        for _, act in ipairs(GP_ACT) do
            local c = Instance.new("Frame", scroll); c.Size = UDim2.new(1,0,0,26); c.BackgroundColor3 = C_ROW; c.BackgroundTransparency=TRANSPARENCY_ROW; c.BorderSizePixel = 0; c.LayoutOrder = #scroll:GetChildren()+1; Instance.new("UICorner", c).CornerRadius = UDim.new(0,10)
            local lbl2 = Instance.new("TextLabel", c); lbl2.Size = UDim2.new(0.5, 0, 1, 0); lbl2.Position = UDim2.new(0, 5, 0, 0); lbl2.BackgroundTransparency = 1; lbl2.Text = act.label; lbl2.TextColor3 = ACCENT; lbl2.Font = Enum.Font.GothamBold; lbl2.TextSize = 8; lbl2.TextXAlignment = Enum.TextXAlignment.Left
            local curBtn = Instance.new("TextButton", c); curBtn.Size = UDim2.new(0, 58, 0, 18); curBtn.Position = UDim2.new(1, -64, 0.5, -9); curBtn.BackgroundColor3 = PITCH_BLACK; curBtn.BackgroundTransparency = 0.3; curBtn.BorderSizePixel = 0; curBtn.Text = xboxName(act.key); curBtn.TextColor3 = C_DIM; curBtn.Font = Enum.Font.GothamBold; curBtn.TextSize = 7; Instance.new("UICorner", curBtn).CornerRadius = UDim.new(0, 3)
            local cStroke = Instance.new("UIStroke", curBtn); cStroke.Color = Color3.fromRGB(60,60,60); cStroke.Thickness = 1
            local listening = false; local listenConn = nil
            curBtn.MouseButton1Click:Connect(function()
                if listening then
                    listening = false; if listenConn then listenConn:Disconnect(); listenConn = nil end
                    curBtn.Text = xboxName(act.key); TweenService:Create(cStroke, TweenInfo.new(0.1), {Color = Color3.fromRGB(60,60,60)}):Play(); return
                end
                listening = true; curBtn.Text = "..."; TweenService:Create(cStroke, TweenInfo.new(0.1), {Color = ACCENT}):Play()
                listenConn = UIS.InputBegan:Connect(function(inp, gpe)
                    if not listening then return end
                    if inp.UserInputType ~= Enum.UserInputType.Gamepad1 then return end
                    local newKey = inp.KeyCode
                    if newKey == Enum.KeyCode.Thumbstick1 or newKey == Enum.KeyCode.Thumbstick2 or newKey == Enum.KeyCode.Unknown then return end
                    act.key = newKey; curBtn.Text = xboxName(newKey); listening = false
                    if listenConn then listenConn:Disconnect(); listenConn = nil end
                    saveGPBinds(); TweenService:Create(cStroke, TweenInfo.new(0.1), {Color = Color3.fromRGB(60,60,60)}):Play()
                end)
            end)
        end
    end

    makeSectionLabel("Keybinds", scroll)
    setAutoBat = makeToggleRow("Auto Bat", State.autoBatToggled, function(on)
        if _G.stopTpBat then _G.stopTpBat() end
        State.autoBatToggled=on
        if on then startBatAimbot() else stopBatAimbot() end
        SetSetting("autoBatToggled",on)
        if setMB_AB then setMB_AB(on) end
        if on and _G.BatAimbot2 and _G.BatAimbot2.stop then
            _G.BatAimbot2.stop()
            if _G.BatAimbot2.update then _G.BatAimbot2.update() end
        end
    end, scroll, "keyAutoBat")
    setAutoBat(State.autoBatToggled)
    _G.originalAutoBatSyncUI = function(active)
        setAutoBat(active)
        if setMB_AB then setMB_AB(active) end
    end

    makeGap(scroll, 2)

    local batV2Setter = makeToggleRow("Bat v2", false, function(on)
        if _G.stopTpBat then _G.stopTpBat() end
        for _, child in ipairs(gui:GetChildren()) do
            if child:IsA("TextButton") and child.Name == "BatAimButton" then
                local isActive = child.TextColor3 == Color3.fromRGB(255, 255, 255)
                if on and not isActive then
                    child:Click()
                elseif not on and isActive then
                    child:Click()
                end
                break
            end
        end
    end, scroll, "keyBatAim2")
    _G.batV2SetterRef = batV2Setter
    task.spawn(function()
        local btn = gui:FindFirstChild("BatAimButton")
        if btn then
            local isActive = btn.TextColor3 == Color3.fromRGB(255, 255, 255)
            batV2Setter(isActive)
        end
    end)

    makeGap(scroll, 2)

    local tpBatKeySetter = makeToggleRow("TP Bat", _G.tpBatModeActive, function(on)
        _G.setTpBatMode(on)
    end, scroll, "keyTpBat")
    table.insert(_G.tpBatToggleSetters, tpBatKeySetter)

    makeGap(scroll, 2)
    setAutoLeft = makeToggleRow("Auto Left", State.autoLeftEnabled, function(on)
        if _G.stopTpBat then _G.stopTpBat() end
        State.autoLeftEnabled=on
        if on then
            if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if setAutoRight then setAutoRight(false) end; if setMB_AR then setMB_AR(false) end end
            if State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if setAutoBat then setAutoBat(false) end; if setMB_AB then setMB_AB(false) end end
            startAutoLeft()
        else stopAutoLeft() end
        SetSetting("autoLeftEnabled",on); if setMB_AL then setMB_AL(on) end
    end, scroll, "keyAutoLeft")
    setAutoLeft(State.autoLeftEnabled)

    setAutoRight = makeToggleRow("Auto Right", State.autoRightEnabled, function(on)
        if _G.stopTpBat then _G.stopTpBat() end
        State.autoRightEnabled=on
        if on then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if setAutoLeft then setAutoLeft(false) end; if setMB_AL then setMB_AL(false) end end
            if State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if setAutoBat then setAutoBat(false) end; if setMB_AB then setMB_AB(false) end end
            startAutoRight()
        else stopAutoRight() end
        SetSetting("autoRightEnabled",on); if setMB_AR then setMB_AR(on) end
    end, scroll, "keyAutoRight")
    setAutoRight(State.autoRightEnabled)

    makeGap(scroll, 2)
    makeToggleRow("TP Down", false, function(on) if on then tpToGround() end end, scroll, "keyTpDown")

    setAutoTpDown = makeToggleRow("Auto TP", State.autoTpDownEnabled, function(on)
        if _G.stopTpBat then _G.stopTpBat() end
        State.autoTpDownEnabled=on; if on then startAutoTP() else stopAutoTP() end
        SetSetting("autoTpDownEnabled",on); if setMB_AT then setMB_AT(on) end
    end, scroll, "keyAutoTpDown")
    setAutoTpDown(State.autoTpDownEnabled)

    makeGap(scroll, 2)
    makeToggleRow("Carry", State.speedType == "carry", function(on)
        if _G.stopTpBat then _G.stopTpBat() end
        if State.laggerLevel > 0 then
            State.laggerLevel = 0
            SetSetting("laggerLevel", 0)
            refreshUIToggles()
            if setMB_LC then setMB_LC() end
        end
        State.speedType = on and "carry" or "normal"
        if modeValLbl then modeValLbl.Text = State.speedType == "carry" and "Carry" or "Normal" end
        SetSetting("speedType", State.speedType)
        if setMB_CS then setMB_CS(on) end
    end, scroll, "keySpeedToggle")

    local instaResetRow = Instance.new("Frame", scroll)
    instaResetRow.Size = UDim2.new(1,0,0,26)
    instaResetRow.BackgroundColor3 = C_ROW
    instaResetRow.BackgroundTransparency = TRANSPARENCY_ROW
    instaResetRow.BorderSizePixel = 0
    instaResetRow.LayoutOrder = #scroll:GetChildren()+1
    Instance.new("UICorner", instaResetRow).CornerRadius = UDim.new(0,10)

    local lbl = Instance.new("TextLabel", instaResetRow)
    lbl.Size = UDim2.new(0.45,0,1,0)
    lbl.Position = UDim2.new(0,5,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Insta Reset"
    lbl.TextColor3 = ACCENT
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 8
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local currentKey = State.keyInstaReset
    local keyName = (currentKey and currentKey ~= Enum.KeyCode.Unknown) and currentKey.Name or "-"
    local chip = Instance.new("TextButton", instaResetRow)
    chip.Size = UDim2.new(0,36,0,14)
    chip.Position = UDim2.new(1,-90,0.5,-7)
    chip.BackgroundColor3 = PITCH_BLACK
    chip.BackgroundTransparency = 0.3
    chip.BorderSizePixel = 0
    chip.Text = keyName
    chip.TextColor3 = Color3.fromRGB(180,180,180)
    chip.Font = Enum.Font.GothamBold
    chip.TextSize = 7
    chip.AutoButtonColor = false
    chip.ZIndex = 6
    Instance.new("UICorner", chip).CornerRadius = UDim.new(0,3)
    local cStroke = Instance.new("UIStroke", chip)
    cStroke.Color = Color3.fromRGB(55,55,55)
    cStroke.Thickness = 1
    keybindChipRefs["keyInstaReset"] = chip

    local listening = false
    local lConn = nil
    local function stopListen(key)
        listening = false
        if lConn then lConn:Disconnect(); lConn = nil end
        TweenService:Create(cStroke, TweenInfo.new(0.12), {Color = Color3.fromRGB(55,55,55)}):Play()
        chip.TextColor3 = Color3.fromRGB(180,180,180)
        if key then
            State.keyInstaReset = key
            chip.Text = key.Name
            SetSetting("keyInstaReset", key.Name)
            AutoSave()
        else
            local k = State.keyInstaReset
            chip.Text = (k and k ~= Enum.KeyCode.Unknown) and k.Name or "-"
        end
    end

    chip.MouseButton1Click:Connect(function()
        if listening then stopListen(nil); return end
        listening = true
        chip.Text = "..."
        chip.TextColor3 = C_WHITE
        TweenService:Create(cStroke, TweenInfo.new(0.12), {Color = ACCENT}):Play()
        lConn = UIS.InputBegan:Connect(function(inp,gp)
            if not listening then return end
            if inp.UserInputType == Enum.UserInputType.Keyboard then
                if inp.KeyCode == Enum.KeyCode.Escape then stopListen(nil); return end
                stopListen(inp.KeyCode)
            end
        end)
    end)

    local actionBtn = Instance.new("TextButton", instaResetRow)
    actionBtn.Size = UDim2.new(0,48,0,18)
    actionBtn.Position = UDim2.new(1,-48,0.5,-9)
    actionBtn.BackgroundColor3 = PITCH_BLACK
    actionBtn.BackgroundTransparency = 0.3
    actionBtn.BorderSizePixel = 0
    actionBtn.Text = "BURST"
    actionBtn.TextColor3 = ACCENT
    actionBtn.Font = Enum.Font.GothamBold
    actionBtn.TextSize = 7
    actionBtn.ZIndex = 5
    Instance.new("UICorner", actionBtn).CornerRadius = UDim.new(0,3)
    Instance.new("UIStroke", actionBtn).Color = DARK_ACC

    actionBtn.MouseButton1Click:Connect(function()
        cursedInstaReset()
        TweenService:Create(actionBtn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(0, 100, 200)}):Play()
        task.delay(0.12, function()
            TweenService:Create(actionBtn, TweenInfo.new(0.08), {BackgroundColor3 = PITCH_BLACK}):Play()
        end)
    end)

    instaResetRow.MouseEnter:Connect(function()
        TweenService:Create(instaResetRow, TweenInfo.new(0.1), {BackgroundColor3 = C_ROW_HOV}):Play()
    end)
    instaResetRow.MouseLeave:Connect(function()
        TweenService:Create(instaResetRow, TweenInfo.new(0.1), {BackgroundColor3 = C_ROW}):Play()
    end)

    local speed2ToggleSetter = makeToggleRow("Speed 2", State.useSecondSpeedSet, function(on)
        if _G.stopTpBat then _G.stopTpBat() end
        if on then
            if State.useThirdSpeedSet then
                State.useThirdSpeedSet = false
                SetSetting("useThirdSpeedSet", false)
                for _, child in ipairs(gui:GetChildren()) do
                    if child:IsA("TextButton") and child.Name == "Mode3FloatingButton" then
                        child.Text = "Speed 3"
                        child.TextColor3 = ACCENT
                        child.BackgroundColor3 = PITCH_BLACK
                        local stroke = child:FindFirstChildWhichIsA("UIStroke")
                        if stroke then stroke.Color = DARK_ACC end
                    end
                end
                pcall(function()
                    for _, child in ipairs(pageMain:GetChildren()) do
                        if child:IsA("Frame") then
                            local label = child:FindFirstChildOfClass("TextLabel")
                            if label and label.Text == "Speed 3" then
                                for _, c in ipairs(child:GetChildren()) do
                                    if c:IsA("Frame") and c ~= label then
                                        local dot = nil
                                        for _, d in ipairs(c:GetChildren()) do
                                            if d:IsA("Frame") then dot = d; break end
                                        end
                                        TweenService:Create(c, TweenInfo.new(0.18), {
                                            BackgroundColor3 = C_OFF_BG
                                        }):Play()
                                        local pStroke = c:FindFirstChildWhichIsA("UIStroke")
                                        if pStroke then
                                            TweenService:Create(pStroke, TweenInfo.new(0.18), {
                                                Color = DARK_ACC
                                            }):Play()
                                        end
                                        if dot then
                                            TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
                                                Position = UDim2.new(0, 2, 0.5, -5),
                                                BackgroundColor3 = C_DIM
                                            }):Play()
                                        end
                                        break
                                    end
                                end
                                break
                            end
                        end
                    end
                end)
            end
            State.useSecondSpeedSet = true
            SetSetting("useSecondSpeedSet", true)
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("TextButton") and child.Name == "Mode2FloatingButton" then
                    child.Text = "Speed 2"
                    child.TextColor3 = C_WHITE
                    child.BackgroundColor3 = ACCENT
                    local stroke = child:FindFirstChildWhichIsA("UIStroke")
                    if stroke then stroke.Color = ACCENT end
                end
            end
        else
            State.useSecondSpeedSet = false
            SetSetting("useSecondSpeedSet", false)
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("TextButton") and child.Name == "Mode2FloatingButton" then
                    child.Text = "Speed 2"
                    child.TextColor3 = ACCENT
                    child.BackgroundColor3 = PITCH_BLACK
                    local stroke = child:FindFirstChildWhichIsA("UIStroke")
                    if stroke then stroke.Color = DARK_ACC end
                end
            end
        end
        refreshUIToggles()
        updateSpeedFloatButtons()
    end, scroll, "keySpeed2")
    _G.setSpeed2Toggle = speed2ToggleSetter

    local speed3ToggleSetter = makeToggleRow("Speed 3", State.useThirdSpeedSet, function(on)
        if _G.stopTpBat then _G.stopTpBat() end
        if on then
            if State.useSecondSpeedSet then
                State.useSecondSpeedSet = false
                SetSetting("useSecondSpeedSet", false)
                for _, child in ipairs(gui:GetChildren()) do
                    if child:IsA("TextButton") and child.Name == "Mode2FloatingButton" then
                        child.Text = "Speed 2"
                        child.TextColor3 = ACCENT
                        child.BackgroundColor3 = PITCH_BLACK
                        local stroke = child:FindFirstChildWhichIsA("UIStroke")
                        if stroke then stroke.Color = DARK_ACC end
                    end
                end
                pcall(function()
                    for _, child in ipairs(pageMain:GetChildren()) do
                        if child:IsA("Frame") then
                            local label = child:FindFirstChildOfClass("TextLabel")
                            if label and label.Text == "Speed 2" then
                                for _, c in ipairs(child:GetChildren()) do
                                    if c:IsA("Frame") and c ~= label then
                                        local dot = nil
                                        for _, d in ipairs(c:GetChildren()) do
                                            if d:IsA("Frame") then dot = d; break end
                                        end
                                        TweenService:Create(c, TweenInfo.new(0.18), {
                                            BackgroundColor3 = C_OFF_BG
                                        }):Play()
                                        local pStroke = c:FindFirstChildWhichIsA("UIStroke")
                                        if pStroke then
                                            TweenService:Create(pStroke, TweenInfo.new(0.18), {
                                                Color = DARK_ACC
                                            }):Play()
                                        end
                                        if dot then
                                            TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
                                                Position = UDim2.new(0, 2, 0.5, -5),
                                                BackgroundColor3 = C_DIM
                                            }):Play()
                                        end
                                        break
                                    end
                                end
                                break
                            end
                        end
                    end
                end)
            end
            State.useThirdSpeedSet = true
            SetSetting("useThirdSpeedSet", true)
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("TextButton") and child.Name == "Mode3FloatingButton" then
                    child.Text = "Speed 3"
                    child.TextColor3 = C_WHITE
                    child.BackgroundColor3 = ACCENT
                    local stroke = child:FindFirstChildWhichIsA("UIStroke")
                    if stroke then stroke.Color = ACCENT end
                end
            end
        else
            State.useThirdSpeedSet = false
            SetSetting("useThirdSpeedSet", false)
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("TextButton") and child.Name == "Mode3FloatingButton" then
                    child.Text = "Speed 3"
                    child.TextColor3 = ACCENT
                    child.BackgroundColor3 = PITCH_BLACK
                    local stroke = child:FindFirstChildWhichIsA("UIStroke")
                    if stroke then stroke.Color = DARK_ACC end
                end
            end
        end
        refreshUIToggles()
        updateSpeedFloatButtons()
    end, scroll, "keySpeed3")
    _G.setSpeed3Toggle = speed3ToggleSetter


    scroll = pageExtras
    makeSectionLabel("System", scroll)
    makeToggleRow("Lock GUI", State.guiLocked, function(on)
        State.guiLocked=on
        SetSetting("guiLocked",on)
        if _G.StealBar and _G.StealBar.setLocked then
            _G.StealBar.setLocked(on)
        end
    end, scroll)
    makeToggleRow("Lock Buttons", State.mobileLocked, function(on) State.mobileLocked=on; SetSetting("mobileLocked",on) end, scroll)
    makeGap(scroll,6)
    local scaleRow = Instance.new("Frame", scroll)
    scaleRow.Size = UDim2.new(1,0,0,30); scaleRow.BackgroundColor3=C_ROW; scaleRow.BackgroundTransparency=TRANSPARENCY_ROW
    scaleRow.BorderSizePixel=0; scaleRow.LayoutOrder=#scroll:GetChildren()+1
    Instance.new("UICorner",scaleRow).CornerRadius=UDim.new(0,10)
    local scaleLbl = Instance.new("TextLabel", scaleRow)
    scaleLbl.Size=UDim2.new(0.35,0,1,0); scaleLbl.Position=UDim2.new(0,5,0,0)
    scaleLbl.BackgroundTransparency=1; scaleLbl.Text="Scale"
    scaleLbl.TextColor3=ACCENT; scaleLbl.Font=Enum.Font.GothamBold; scaleLbl.TextSize=8
    scaleLbl.TextXAlignment=Enum.TextXAlignment.Left
    local scaleValLbl = Instance.new("TextLabel", scaleRow)
    scaleValLbl.Size=UDim2.new(0.18,0,1,0); scaleValLbl.Position=UDim2.new(0.35,0,0,0)
    scaleValLbl.BackgroundTransparency=1; scaleValLbl.Text=string.format("%.1f",mbScaleFactor)
    scaleValLbl.TextColor3=C_WHITE; scaleValLbl.Font=Enum.Font.GothamBold; scaleValLbl.TextSize=9
    scaleValLbl.TextXAlignment=Enum.TextXAlignment.Center
    local minusBtn = Instance.new("TextButton", scaleRow)
    minusBtn.Size=UDim2.new(0,22,0,20); minusBtn.Position=UDim2.new(0.53,0,0.5,-10)
    minusBtn.BackgroundColor3=PITCH_BLACK; minusBtn.BackgroundTransparency=0.3; minusBtn.BorderSizePixel=0
    minusBtn.Text="-"; minusBtn.TextColor3=ACCENT
    minusBtn.Font=Enum.Font.GothamBold; minusBtn.TextSize=12
    Instance.new("UICorner",minusBtn).CornerRadius=UDim.new(0,4)
    Instance.new("UIStroke",minusBtn).Color=DARK_ACC
    local plusBtn = Instance.new("TextButton", scaleRow)
    plusBtn.Size=UDim2.new(0,22,0,20); plusBtn.Position=UDim2.new(0.53,26,0.5,-10)
    plusBtn.BackgroundColor3=PITCH_BLACK; plusBtn.BackgroundTransparency=0.3; plusBtn.BorderSizePixel=0
    plusBtn.Text="+"; plusBtn.TextColor3=ACCENT
    plusBtn.Font=Enum.Font.GothamBold; plusBtn.TextSize=12
    Instance.new("UICorner",plusBtn).CornerRadius=UDim.new(0,4)
    Instance.new("UIStroke",plusBtn).Color=DARK_ACC
    local function updateScale(v)
        applyMBScale(v)
        scaleValLbl.Text = string.format("%.1f", mbScaleFactor)
        SetSetting("mbButtonScale", mbScaleFactor)
    end
    minusBtn.MouseButton1Click:Connect(function()
        updateScale(mbScaleFactor - 0.1)
    end)
    plusBtn.MouseButton1Click:Connect(function()
        updateScale(mbScaleFactor + 0.1)
    end)

    makeSectionLabel("Config", scroll)
    local saveRow = Instance.new("Frame", scroll)
    saveRow.Size = UDim2.new(1,0,0,28); saveRow.BackgroundColor3=Color3.fromRGB(18,18,18); saveRow.BackgroundTransparency=0.8
    saveRow.BorderSizePixel=0; saveRow.LayoutOrder=#scroll:GetChildren()+1
    Instance.new("UICorner",saveRow).CornerRadius=UDim.new(0,10)
    Instance.new("UIStroke",saveRow).Color=Color3.fromRGB(55,55,55)
    local saveBtn = Instance.new("TextButton", saveRow)
    saveBtn.Size=UDim2.new(1,0,1,0); saveBtn.BackgroundTransparency=1
    saveBtn.Text="SAVE CONFIG"; saveBtn.TextColor3=ACCENT
    saveBtn.Font=Enum.Font.GothamBold; saveBtn.TextSize=9
    saveBtn.MouseButton1Click:Connect(function()
        SaveConfig()
        saveBtn.Text="SAVED!"
        task.delay(1.5, function() saveBtn.Text="SAVE CONFIG" end)
    end)
    makeGap(scroll,3)
    local resetRow = Instance.new("Frame", scroll)
    resetRow.Size = UDim2.new(1,0,0,28); resetRow.BackgroundColor3=Color3.fromRGB(40,10,10); resetRow.BackgroundTransparency=0.8
    resetRow.BorderSizePixel=0; resetRow.LayoutOrder=#scroll:GetChildren()+1
    Instance.new("UICorner",resetRow).CornerRadius=UDim.new(0,10)
    Instance.new("UIStroke",resetRow).Color=Color3.fromRGB(120,20,20)
    local resetBtn = Instance.new("TextButton", resetRow)
    resetBtn.Size=UDim2.new(1,0,1,0); resetBtn.BackgroundTransparency=1
    resetBtn.Text="RESET CONFIG"; resetBtn.TextColor3=Color3.fromRGB(220,80,80)
    resetBtn.Font=Enum.Font.GothamBold; resetBtn.TextSize=9
    resetBtn.MouseButton1Click:Connect(function()
        resetBtn.Text="RESET!"; resetBtn.TextColor3=C_WHITE
        task.delay(1.5, function()
            resetBtn.Text="RESET CONFIG"
            resetBtn.TextColor3=Color3.fromRGB(220,80,80)
        end)
        local ok, errMsg = pcall(function()
        State.normalSpeed=60; State.carrySpeed=30;
        State.normalSpeed2=120; State.carrySpeed2=60
        State.normalSpeed3=120; State.carrySpeed3=60
        State.useThirdSpeedSet=false
        State.laggerSpeed1=13; State.laggerSpeed2=25
        State.laggerLevel=0
        State.speedType="normal"
        State.useSecondSpeedSet=false
        State.autoBatToggled=false; State.infJumpEnabled=false; State.infJumpMode="manual"
        State.antiRagdollV1Enabled=false; State.antiRagdollV2Enabled=false; State.antiRagdollActiveVersion=0
        setAntiRagdollVersion(0)
        State.fpsBoostEnabled=false; if Conns.fpsBoostMonitor then Conns.fpsBoostMonitor:Disconnect(); Conns.fpsBoostMonitor = nil end
        State.medusaCounterEnabled=false; State.animEnabled=false; State.unwalkEnabled=false
        State.autoTpDownEnabled=false; State.autoTpDownY=6
        State.autoLeftEnabled=false; State.autoRightEnabled=false
        State.skyEnabled=false; State.skyColorIndex=1
        State.floatEnabled=false; State.floatHeight=9.5
        State.stretchRezEnabled=false;
        State.batCounterEnabled=false; State.waypointESPEnabled=false
        State.controllerEnabled=false; State.guiLocked=false; State.mobileLocked=false
        State.keyAutoLeft=Enum.KeyCode.Unknown; State.keyAutoRight=Enum.KeyCode.Unknown
        State.keyDropBR=Enum.KeyCode.Unknown; State.keyTpDown=Enum.KeyCode.Unknown
        State.keyAutoBat=Enum.KeyCode.Unknown; State.keySpeedToggle=Enum.KeyCode.Unknown
        State.keyAutoTpDown=Enum.KeyCode.Unknown
        State.keyInstaReset=Enum.KeyCode.Unknown
        State.keySpeed2=Enum.KeyCode.Unknown
        State.keySpeed3=Enum.KeyCode.Unknown
        State.keyLagger=Enum.KeyCode.Unknown
        State.keyBatAim2=Enum.KeyCode.Unknown
        State.keyTpBat=Enum.KeyCode.Unknown
        State.hitbuxEnabled=false
        State.bodyLockEnabled=false; State.bodyLockRange=40; bodyLockRange=40
        bodyLockEnabled = false
        State.dropEnabled = false
        State.antiPlayerCollision=false
        pcall(function() stopAntiPlayerCollision() end)
        State.bypassToggled = false
        State.bypassMode = 1
        State.bypassSpeed = 55
        toggleDropGlitch(false)
        stopAutoLeft(); stopAutoRight(); stopAntiRagdollV1(); stopAntiRagdollV2()
        stopAnimToggle(); stopUnwalk(); stopBatAimbot(); stopBatCounter()
        if _G.StealBar then _G.StealBar.stop() end; stopFloat(); stopWaypointESP()
        if _G.BatAimbot2 then
            if _G.BatAimbot2.stop then _G.BatAimbot2.stop() end
            if _G.BatAimbot2.update then _G.BatAimbot2.update() end
        end
        State.batAim2Enabled = false; State.batAim2Mode = "normal"
        if State.stretchRezEnabled then disableStretchRez() end
        if State.hitbuxEnabled then stopHitbux() end
        stopBodyLock()
        if bodyLockSetVisual then bodyLockSetVisual(false) end
        State.lajaMusicEnabled = false
        for _, song in ipairs(SONG_LIST) do
            State[song.configKey] = false
            if musicSounds[song.key] then
                musicSounds[song.key].stop()
            end
            if musicSettters[song.key] then
                musicSettters[song.key](false)
            end
        end
        for k,v in pairs(DefaultConfig) do Config[k]=v end
        SaveConfig()
        for k,chip in pairs(keybindChipRefs) do chip.Text="-" end
        if setMB_AL then setMB_AL(false) end; if setMB_AR then setMB_AR(false) end
        if setMB_AB then setMB_AB(false) end; if setMB_CS then setMB_CS(false) end
        if setMB_LC then setMB_LC() end; if setMB_AT then setMB_AT(false) end
        syncDropButtons()
        updateScale(1.0)
        buildFullGUI()
        end)
        if not ok then warn("[RESET CONFIG] error while resetting settings: "..tostring(errMsg)) end

        local okPos, posErr = pcall(function()
            mbGroup.Position = UDim2.new(0,10, 0.5,-QH/2-8)
            for _, entry in ipairs(mbButtonFrames) do
                entry.frame.Position = entry.defaultPos
                pcall(function() if isfile and isfile(entry.posFile) then delfile(entry.posFile) end end)
            end
            for _, entry in ipairs(floatingBtnRefs) do
                entry.frame.Position = entry.defaultPos
                pcall(function() if isfile and isfile(entry.posFile) then delfile(entry.posFile) end end)
            end
            pcall(function() if isfile and isfile("KzsHubMBPos.txt") then delfile("KzsHubMBPos.txt") end end)
            local batAimBtn = gui:FindFirstChild("BatAimButton")
            if batAimBtn then batAimBtn.Position = UDim2.new(0,10, 0.82,0) end
            pcall(function() if isfile and isfile("KzsHubBatAimPos.txt") then delfile("KzsHubBatAimPos.txt") end end)
            local instaResetBtn = gui:FindFirstChild("InstaResetButton")
            if instaResetBtn then instaResetBtn.Position = UDim2.new(0,10, 0.75,0) end
            pcall(function() if isfile and isfile("KzsHubResetPos.txt") then delfile("KzsHubResetPos.txt") end end)
            pcall(function() if isfile and isfile("KzsHubSpeed2Pos.txt") then delfile("KzsHubSpeed2Pos.txt") end end)
            pcall(function() if isfile and isfile("KzsHubSpeed3Pos.txt") then delfile("KzsHubSpeed3Pos.txt") end end)
        end)
        if not okPos then warn("[RESET CONFIG] error while resetting button positions: "..tostring(posErr)) end
    end)

end

buildFullGUI()

local QS, QG = 48, 4
local QR = 16
local Q_OFF = Color3.fromRGB(12,12,14)
local Q_ON  = Color3.fromRGB(0, 180, 255)
local Q_BORDER = Color3.fromRGB(0, 180, 255)
local Q_BORDER_ON = Color3.fromRGB(0, 180, 255)
local Q_TEXT = Color3.fromRGB(0, 180, 255)
QW, QH = QS*2+QG, QS*4+QG*3
mbGroup = Instance.new("Frame", gui)
mbGroup.Name = "MobileButtons"
mbGroup.Size = UDim2.new(0, QW+80, 0, QH+80)
mbGroup.Position = UDim2.new(0,10, 0.5,-QH/2-8)
mbGroup.BackgroundTransparency = 1
mbGroup.BorderSizePixel = 0
mbGroup.Active = false
mbGroup.ZIndex = 100

function attachFrameDrag(inputSrc, frame, defaultPos, posFile)
    local dragging, dragStart, startPos = false, nil, nil
    inputSrc.InputBegan:Connect(function(inp)
        if State.mobileLocked then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.MouseButton2 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = frame.Position
        end
    end)
    inputSrc.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.MouseButton2 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if not dragging then return end
        if State.mobileLocked then dragging = false; return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)
    local lastSave = 0
    frame:GetPropertyChangedSignal("Position"):Connect(function()
        if tick()-lastSave > 0.5 then lastSave = tick(); savePos(frame, posFile) end
    end)
    pcall(function() loadPos(frame, posFile) end)
    mbButtonFrames[#mbButtonFrames+1] = { frame = frame, defaultPos = defaultPos, posFile = posFile }
end

applyMBScale = function(factor)
    mbScaleFactor = math.clamp(factor, 0.5, 2.0)
    local newQS = math.floor(48 * mbScaleFactor)
    local newQG = math.floor(4  * mbScaleFactor)
    local newQW = newQS*2+newQG
    local newQH = newQS*4+newQG*3
    mbGroup.Size = UDim2.new(0, newQW+16, 0, newQH+16)
    local idx = 0
    for _, child in ipairs(mbGroup:GetChildren()) do
        if child:IsA("Frame") then
            local col = idx % 2
            local row2 = math.floor(idx / 2)
            child.Size = UDim2.new(0, newQS, 0, newQS)
            child.Position = UDim2.new(0, 8+col*(newQS+newQG), 0, 8+row2*(newQS+newQG))
            idx = idx + 1
        end
    end
    for _, entry in ipairs(mbButtonFrames) do
        pcall(function() loadPos(entry.frame, entry.posFile) end)
    end
end

function makeMobileBtn(label, col, row, isToggle, onAction)
    local relX=8+col*(QS+QG); local relY=8+row*(QS+QG)
    local frame=Instance.new("Frame",mbGroup); frame.Size=UDim2.new(0,QS,0,QS); frame.Position=UDim2.new(0,relX,0,relY); frame.BackgroundColor3=Q_OFF; frame.BackgroundTransparency=0
    frame.BorderSizePixel=0; frame.Active=true; frame.ZIndex=102
    Instance.new("UICorner",frame).CornerRadius=UDim.new(0,QR)
    local btn=Instance.new("TextButton",frame); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=label; btn.TextColor3=Q_TEXT; btn.Font=Enum.Font.GothamBold; btn.TextSize=9; btn.TextWrapped=true; btn.LineHeight=1.2; btn.BorderSizePixel=0; btn.AutoButtonColor=false; btn.ZIndex=103
    local isOn=false
    btn.MouseButton1Click:Connect(function()
        if isToggle then
            if _G.stopTpBat then _G.stopTpBat() end
            isOn=not isOn
            TweenService:Create(frame,TweenInfo.new(0.15),{BackgroundColor3=isOn and Q_ON or Q_OFF}):Play()
            TweenService:Create(btn,TweenInfo.new(0.15),{TextColor3=isOn and C_WHITE or Q_TEXT}):Play()
            if onAction then onAction(isOn) end
        else
            if _G.stopTpBat then _G.stopTpBat() end
            TweenService:Create(frame,TweenInfo.new(0.08),{BackgroundColor3=Q_ON}):Play()
            TweenService:Create(btn,TweenInfo.new(0.08),{TextColor3=C_WHITE}):Play()
            task.delay(0.25,function()
                TweenService:Create(frame,TweenInfo.new(0.15),{BackgroundColor3=Q_OFF}):Play()
                TweenService:Create(btn,TweenInfo.new(0.15),{TextColor3=Q_TEXT}):Play()
            end)
            if onAction then onAction() end
        end
    end)
    local function setter(s)
        isOn=s
        TweenService:Create(frame,TweenInfo.new(0.15),{BackgroundColor3=s and Q_ON or Q_OFF}):Play()
        TweenService:Create(btn,TweenInfo.new(0.15),{TextColor3=s and C_WHITE or Q_TEXT}):Play()
    end
    local defaultPos = UDim2.new(0,relX,0,relY)
    local posFile = "KzsHubMB_"..label:gsub("%s","").."Pos.txt"
    attachFrameDrag(btn, frame, defaultPos, posFile)
    return setter
end

setMB_BR = makeMobileBtn("DROP\nBR", 0,0,false, function() runDropBrainrot() end)
setMB_AL = makeMobileBtn("AUTO\nLEFT", 1,0,true,function(on)
    State.autoLeftEnabled=on
    if on then
        if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if setMB_AR then setMB_AR(false) end; if setAutoRight then setAutoRight(false) end end
        if State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if setMB_AB then setMB_AB(false) end; if setAutoBat then setAutoBat(false) end end
        startAutoLeft()
    else stopAutoLeft() end
    SetSetting("autoLeftEnabled",on); if setAutoLeft then setAutoLeft(on) end
end)
setMB_AB = makeMobileBtn("BAT", 0,1,true,function(on)
    State.autoBatToggled=on
    if on then
        if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if setMB_AL then setMB_AL(false) end; if setAutoLeft then setAutoLeft(false) end end
        if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if setMB_AR then setMB_AR(false) end; if setAutoRight then setAutoRight(false) end end
        startBatAimbot()
    else stopBatAimbot() end
    SetSetting("autoBatToggled",on); if setAutoBat then setAutoBat(on) end
end)
setMB_AR = makeMobileBtn("AUTO\nRIGHT", 1,1,true,function(on)
    State.autoRightEnabled=on
    if on then
        if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if setMB_AL then setMB_AL(false) end; if setAutoLeft then setAutoLeft(false) end end
        if State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if setMB_AB then setMB_AB(false) end; if setAutoBat then setAutoBat(false) end end
        startAutoRight()
    else stopAutoRight() end
    SetSetting("autoRightEnabled",on); if setAutoRight then setAutoRight(on) end
end)
setMB_TD = makeMobileBtn("TP\nDOWN", 0,2,false,function() tpToGround() end)
setMB_CS = makeMobileBtn("CARRY", 1,2,true,function(on)
    if State.laggerLevel > 0 then
        State.laggerLevel = 0
        SetSetting("laggerLevel", 0)
        refreshUIToggles()
        if setMB_LC then setMB_LC() end
    end
    if on then State.speedType="carry"
    else State.speedType="normal" end
    SetSetting("speedType",State.speedType); refreshUIToggles()
end)

setMB_LC = function()
    local col = 0
    local row = 3
    local relX = 8 + col * (QS + QG)
    local relY = 8 + row * (QS + QG)

    local frame = Instance.new("Frame", mbGroup)
    frame.Size = UDim2.new(0, QS, 0, QS)
    frame.Position = UDim2.new(0, relX, 0, relY)
    frame.BackgroundColor3 = Q_OFF
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.ZIndex = 102
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, QR)

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = "LAGGER"
    btn.TextColor3 = Q_TEXT
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.TextWrapped = true
    btn.LineHeight = 1.2
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.ZIndex = 103

    local function updateButtonAppearance()
        if State.laggerLevel == 0 then
            frame.BackgroundColor3 = Q_OFF
            btn.TextColor3 = Q_TEXT
            btn.Text = "LAGGER"
        elseif State.laggerLevel == 1 then
            frame.BackgroundColor3 = Q_ON
            btn.TextColor3 = C_WHITE
            btn.Text = "1"
        else
            frame.BackgroundColor3 = Q_ON
            btn.TextColor3 = C_WHITE
            btn.Text = "2"
        end
    end

    btn.MouseButton1Click:Connect(function()
        if _G.stopTpBat then _G.stopTpBat() end
        if State.laggerLevel == 0 then
            State.laggerLevel = 1
        elseif State.laggerLevel == 1 then
            State.laggerLevel = 2
        else
            State.laggerLevel = 1
        end
        State.speedType = "normal"

        if State.laggerLevel == 0 then
            if setMB_CS then setMB_CS(State.speedType == "carry") end
        else
            if setMB_CS then setMB_CS(false) end
        end

        SetSetting("laggerLevel", State.laggerLevel)
        SetSetting("speedType", State.speedType)
        refreshUIToggles()

        updateButtonAppearance()

        for _, child in ipairs(pageMain:GetChildren()) do
            if child:IsA("Frame") then
                local laggerBtn = child:FindFirstChildWhichIsA("TextButton")
                if laggerBtn and laggerBtn.Text:match("^L%d?$") then
                    if State.laggerLevel == 0 then
                        laggerBtn.Text = "L"
                        laggerBtn.BackgroundColor3 = PITCH_BLACK
                    elseif State.laggerLevel == 1 then
                        laggerBtn.Text = "L1"
                        laggerBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    else
                        laggerBtn.Text = "L2"
                        laggerBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    end
                    break
                end
            end
        end
    end)

    updateButtonAppearance()
    attachFrameDrag(btn, frame, UDim2.new(0,relX,0,relY), "KzsHubMB_LAGGERPos.txt")

    return function()
        updateButtonAppearance()
    end
end
setMB_LC = setMB_LC()
setMB_AT = makeMobileBtn("AUTO\nTP", 1,3,true,function(on)
    if _G.stopTpBat then _G.stopTpBat() end
    State.autoTpDownEnabled=on; if on then startAutoTP() else stopAutoTP() end
    SetSetting("autoTpDownEnabled",on); if setAutoTpDown then setAutoTpDown(on) end
end)

UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    local kc = inp.KeyCode

    if State.keyAutoLeft ~= Enum.KeyCode.Unknown and kc == State.keyAutoLeft then
        if _G.stopTpBat then _G.stopTpBat() end
        State.autoLeftEnabled = not State.autoLeftEnabled
        if State.autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if setAutoLeft then setAutoLeft(State.autoLeftEnabled) end
        if setMB_AL then setMB_AL(State.autoLeftEnabled) end
        SetSetting("autoLeftEnabled", State.autoLeftEnabled)
    end

    if State.keyAutoRight ~= Enum.KeyCode.Unknown and kc == State.keyAutoRight then
        if _G.stopTpBat then _G.stopTpBat() end
        State.autoRightEnabled = not State.autoRightEnabled
        if State.autoRightEnabled then startAutoRight() else stopAutoRight() end
        if setAutoRight then setAutoRight(State.autoRightEnabled) end
        if setMB_AR then setMB_AR(State.autoRightEnabled) end
        SetSetting("autoRightEnabled", State.autoRightEnabled)
    end

    if State.keyDropBR ~= Enum.KeyCode.Unknown and kc == State.keyDropBR then
        if _G.stopTpBat then _G.stopTpBat() end
        runDropBrainrot()
    end

    if State.keyTpDown ~= Enum.KeyCode.Unknown and kc == State.keyTpDown then
        if _G.stopTpBat then _G.stopTpBat() end
        tpToGround()
    end

    if State.keyAutoBat ~= Enum.KeyCode.Unknown and kc == State.keyAutoBat then
        if _G.stopTpBat then _G.stopTpBat() end
        State.autoBatToggled = not State.autoBatToggled
        if State.autoBatToggled then startBatAimbot() else stopBatAimbot() end
        if setAutoBat then setAutoBat(State.autoBatToggled) end
        if setMB_AB then setMB_AB(State.autoBatToggled) end
        SetSetting("autoBatToggled", State.autoBatToggled)
    end

    if State.keySpeedToggle ~= Enum.KeyCode.Unknown and kc == State.keySpeedToggle then
        if _G.stopTpBat then _G.stopTpBat() end
        if State.laggerLevel > 0 then
            State.laggerLevel = 0
            SetSetting("laggerLevel", 0)
            refreshUIToggles()
            if setMB_LC then setMB_LC() end
        end
        State.speedType = (State.speedType == "carry") and "normal" or "carry"
        if modeValLbl then modeValLbl.Text = State.speedType == "carry" and "Carry" or "Normal" end
        SetSetting("speedType", State.speedType)
        if setMB_CS then setMB_CS(State.speedType == "carry") end
    end

    if State.keyAutoTpDown ~= Enum.KeyCode.Unknown and kc == State.keyAutoTpDown then
        if _G.stopTpBat then _G.stopTpBat() end
        State.autoTpDownEnabled = not State.autoTpDownEnabled
        if State.autoTpDownEnabled then startAutoTP() else stopAutoTP() end
        SetSetting("autoTpDownEnabled", State.autoTpDownEnabled)
        if setMB_AT then setMB_AT(State.autoTpDownEnabled) end
    end

    if State.keyInstaReset ~= Enum.KeyCode.Unknown and kc == State.keyInstaReset then
        cursedInstaReset()
    end

    if State.keySpeed2 ~= Enum.KeyCode.Unknown and kc == State.keySpeed2 then
        if _G.stopTpBat then _G.stopTpBat() end
        if State.useSecondSpeedSet then
            State.useSecondSpeedSet = false
            SetSetting("useSecondSpeedSet", false)
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("TextButton") and child.Name == "Mode2FloatingButton" then
                    child.Text = "Speed 2"
                    child.TextColor3 = ACCENT
                    child.BackgroundColor3 = PITCH_BLACK
                    local stroke = child:FindFirstChildWhichIsA("UIStroke")
                    if stroke then stroke.Color = DARK_ACC end
                end
            end
        else
            if State.useThirdSpeedSet then
                State.useThirdSpeedSet = false
                SetSetting("useThirdSpeedSet", false)
                for _, child in ipairs(gui:GetChildren()) do
                    if child:IsA("TextButton") and child.Name == "Mode3FloatingButton" then
                        child.Text = "Speed 3"
                        child.TextColor3 = ACCENT
                        child.BackgroundColor3 = PITCH_BLACK
                        local stroke = child:FindFirstChildWhichIsA("UIStroke")
                        if stroke then stroke.Color = DARK_ACC end
                    end
                end
            end
            State.useSecondSpeedSet = true
            SetSetting("useSecondSpeedSet", true)
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("TextButton") and child.Name == "Mode2FloatingButton" then
                    child.Text = "Speed 2"
                    child.TextColor3 = C_WHITE
                    child.BackgroundColor3 = ACCENT
                    local stroke = child:FindFirstChildWhichIsA("UIStroke")
                    if stroke then stroke.Color = ACCENT end
                end
            end
        end
        refreshUIToggles()
        updateSpeedFloatButtons()
        if _G.setSpeed2Toggle then _G.setSpeed2Toggle(State.useSecondSpeedSet) end
    end

    if State.keySpeed3 ~= Enum.KeyCode.Unknown and kc == State.keySpeed3 then
        if _G.stopTpBat then _G.stopTpBat() end
        if State.useThirdSpeedSet then
            State.useThirdSpeedSet = false
            SetSetting("useThirdSpeedSet", false)
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("TextButton") and child.Name == "Mode3FloatingButton" then
                    child.Text = "Speed 3"
                    child.TextColor3 = ACCENT
                    child.BackgroundColor3 = PITCH_BLACK
                    local stroke = child:FindFirstChildWhichIsA("UIStroke")
                    if stroke then stroke.Color = DARK_ACC end
                end
            end
        else
            if State.useSecondSpeedSet then
                State.useSecondSpeedSet = false
                SetSetting("useSecondSpeedSet", false)
                for _, child in ipairs(gui:GetChildren()) do
                    if child:IsA("TextButton") and child.Name == "Mode2FloatingButton" then
                        child.Text = "Speed 2"
                        child.TextColor3 = ACCENT
                        child.BackgroundColor3 = PITCH_BLACK
                        local stroke = child:FindFirstChildWhichIsA("UIStroke")
                        if stroke then stroke.Color = DARK_ACC end
                    end
                end
            end
            State.useThirdSpeedSet = true
            SetSetting("useThirdSpeedSet", true)
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("TextButton") and child.Name == "Mode3FloatingButton" then
                    child.Text = "Speed 3"
                    child.TextColor3 = C_WHITE
                    child.BackgroundColor3 = ACCENT
                    local stroke = child:FindFirstChildWhichIsA("UIStroke")
                    if stroke then stroke.Color = ACCENT end
                end
            end
        end
        refreshUIToggles()
        updateSpeedFloatButtons()
        if _G.setSpeed3Toggle then _G.setSpeed3Toggle(State.useThirdSpeedSet) end
    end

    if State.keyBatAim2 ~= Enum.KeyCode.Unknown and kc == State.keyBatAim2 then
        if _G.stopTpBat then _G.stopTpBat() end
        for _, child in ipairs(gui:GetChildren()) do
            if child:IsA("TextButton") and child.Name == "BatAimButton" then
                child:Click()
                break
            end
        end
    end

    if State.keyTpBat ~= Enum.KeyCode.Unknown and kc == State.keyTpBat then
        _G.setTpBatMode(not _G.tpBatModeActive)
    end

    if State.keyLagger ~= Enum.KeyCode.Unknown and kc == State.keyLagger then
        if _G.stopTpBat then _G.stopTpBat() end
        if doLaggerSpeed then doLaggerSpeed() end
    end
end)

function setupChar(char)
    task.wait(0.1)
    originalAnims = nil
    h = char:WaitForChild("Humanoid", 5)
    hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not h or not hrp then return end

    local head = char:FindFirstChild("Head")
    if head then
        local oldBB = head:FindFirstChild("KzMobileBB")
        if oldBB then oldBB:Destroy() end

        local bb = Instance.new("BillboardGui", head)
        bb.Name = "KzMobileBB"
        bb.Size = UDim2.new(0, 150, 0, 50)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true

        speedLbl = Instance.new("TextLabel", bb)
        speedLbl.Name = "SpeedBillLbl"
        speedLbl.Size = UDim2.new(1, 0, 0, 24)
        speedLbl.Position = UDim2.new(0, 0, 0, 0)
        speedLbl.BackgroundTransparency = 1
        speedLbl.Text = "0.0"
        speedLbl.TextColor3 = ACCENT
        speedLbl.Font = Enum.Font.GothamBlack
        speedLbl.TextScaled = true
        speedLbl.TextStrokeTransparency = 0
        speedLbl.TextStrokeColor3 = Color3.new(0, 0, 0)

        local discordLbl = Instance.new("TextLabel", bb)
        discordLbl.Size = UDim2.new(1, 0, 0, 28)
        discordLbl.Position = UDim2.new(0, 0, 0, 26)
        discordLbl.BackgroundTransparency = 1
        discordLbl.Text = "NOXTRIXHUB ON TOP"
        discordLbl.TextColor3 = Color3.fromRGB(0, 180, 255)
        discordLbl.Font = Enum.Font.GothamBold
        discordLbl.TextScaled = true
        discordLbl.TextStrokeTransparency = 0.1
        discordLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    end

    if State.animEnabled then task.wait(0.3); saveOriginalAnims(char); applyAnimPack(char) end
    if State.unwalkEnabled then State.unwalkEnabled = false; task.wait(0.3); startUnwalk() end

    pcall(function() fullMovementCleanup(char) end)
    State.autoLeftPhase = 1
    State.autoRightPhase = 1
    task.delay(0.5, function()
        if not char or not char.Parent then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not (hum and root and hum.Health > 0) then return end
        if State.autoLeftEnabled then
            pcall(function()
                local fn = _G._startAutoLeft or startAutoLeft
                if fn then fn() end
            end)
        end
        if State.autoRightEnabled then
            pcall(function()
                local fn = _G._startAutoRight or startAutoRight
                if fn then fn() end
            end)
        end
    end)
end

LP.CharacterRemoving:Connect(function(char)
    pcall(function() fullMovementCleanup(char) end)
end)
LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

task.spawn(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            local function addBillboard(char)
                task.wait(0.2)
                local head = char:FindFirstChild("Head")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not head or not hrp then return end

                local oldBB = head:FindFirstChild("KzOtherBB")
                if oldBB then oldBB:Destroy() end

                local bb = Instance.new("BillboardGui", head)
                bb.Name = "KzOtherBB"
                bb.Size = UDim2.new(0, 100, 0, 30)
                bb.StudsOffset = Vector3.new(0, 3, 0)
                bb.AlwaysOnTop = true

                local speedLbl = Instance.new("TextLabel", bb)
                speedLbl.Size = UDim2.new(1, 0, 1, 0)
                speedLbl.BackgroundTransparency = 1
                speedLbl.Text = "0.0"
                speedLbl.TextColor3 = ACCENT
                speedLbl.Font = Enum.Font.GothamBlack
                speedLbl.TextScaled = true
                speedLbl.TextStrokeTransparency = 0
                speedLbl.TextStrokeColor3 = Color3.new(0, 0, 0)

                local conn = RunService.RenderStepped:Connect(function()
                    if not hrp or not hrp.Parent then
                        conn:Disconnect()
                        return
                    end
                    local hspd = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
                    speedLbl.Text = string.format("%.1f", hspd)
                end)
            end

            if player.Character then
                task.spawn(addBillboard, player.Character)
            end
            player.CharacterAdded:Connect(addBillboard)
        end
    end

    Players.PlayerAdded:Connect(function(player)
        if player == LP then return end
        local function addBillboard(char)
            task.wait(0.2)
            local head = char:FindFirstChild("Head")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not head or not hrp then return end

            local oldBB = head:FindFirstChild("KzOtherBB")
            if oldBB then oldBB:Destroy() end

            local bb = Instance.new("BillboardGui", head)
            bb.Name = "KzOtherBB"
            bb.Size = UDim2.new(0, 100, 0, 30)
            bb.StudsOffset = Vector3.new(0, 3, 0)
            bb.AlwaysOnTop = true

            local speedLbl = Instance.new("TextLabel", bb)
            speedLbl.Size = UDim2.new(1, 0, 1, 0)
            speedLbl.BackgroundTransparency = 1
            speedLbl.Text = "0.0"
            speedLbl.TextColor3 = ACCENT
            speedLbl.Font = Enum.Font.GothamBlack
            speedLbl.TextScaled = true
            speedLbl.TextStrokeTransparency = 0
            speedLbl.TextStrokeColor3 = Color3.new(0, 0, 0)

            local conn = RunService.RenderStepped:Connect(function()
                if not hrp or not hrp.Parent then
                    conn:Disconnect()
                    return
                end
                local hspd = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
                speedLbl.Text = string.format("%.1f", hspd)
            end)
        end

        if player.Character then
            task.spawn(addBillboard, player.Character)
        end
        player.CharacterAdded:Connect(addBillboard)
    end)
end)

local lastSpeedUpdate = 0
RunService.Heartbeat:Connect(function()
    if not (h and hrp) then return end
    if not h.Parent or not hrp.Parent then return end

    local skipSpeed = State.autoLeftEnabled or State.autoRightEnabled or autoBatEnabled
        or (_G.BatAimbot2 and _G.BatAimbot2.isActive and _G.BatAimbot2.isActive())
        or _G.tpBatModeActive

    if speedLbl and tick() - lastSpeedUpdate > 0.2 then
        local hspd = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z).Magnitude
        speedLbl.Text = string.format("%.1f", hspd)
        lastSpeedUpdate = tick()
    end

    if isRagdolledState(h) then
        clearSpeedVectorForce(hrp)
        if not skipSpeed then
            clearLinearVelocity(hrp)
            State.lastMoveDir = Vector3.zero
        end
        return
    end

    if skipSpeed then
        clearSpeedVectorForce(hrp)
        return
    end

    local vectorForce = getOrCreateSpeedVectorForce(hrp)
    if not vectorForce then return end

    local md = h.MoveDirection
    if md.Magnitude > 0.01 and h.Health > 0 then
        State.lastMoveDir = md
        local visualSpd = getCurrentSpeed()
        local internalSpeed = getAdjustedSpeed(visualSpd)

        local moveDir = md.Unit
        local targetVel = moveDir * internalSpeed
        local currentVel = hrp.AssemblyLinearVelocity

        local mass = hrp.AssemblyMass
        local responsiveness = 50

        local forceX = (targetVel.X - currentVel.X) * mass * responsiveness
        local forceZ = (targetVel.Z - currentVel.Z) * mass * responsiveness

        vectorForce.Force = Vector3.new(forceX, 0, forceZ)
        vectorForce.Enabled = true
    else
        vectorForce.Force = Vector3.zero
        vectorForce.Enabled = false
        State.lastMoveDir = Vector3.zero
        clearLinearVelocity(hrp)
        if math.abs(hrp.AssemblyAngularVelocity.Y) > 0.5 then
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
        if h and not h.AutoRotate then
            h.AutoRotate = true
        end
    end
end)

local _infJumpRayParams = RaycastParams.new()
_infJumpRayParams.FilterType = Enum.RaycastFilterType.Exclude
_infJumpRayParams.IgnoreWater = true

local function setupInfJumpPhysics(char)
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return nil end
    local att = hrp:FindFirstChild("InfJumpAttachment")
    if not att then
        att = Instance.new("Attachment")
        att.Name = "InfJumpAttachment"
        att.Parent = hrp
    end
    local lv = hrp:FindFirstChild("InfJumpVelocity")
    if not lv then
        lv = Instance.new("LinearVelocity")
        lv.Name = "InfJumpVelocity"
        lv.Attachment0 = att
        lv.MaxForce = 25000
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
        lv.LineDirection = Vector3.new(0, 1, 0)
        lv.LineVelocity = 0
        lv.Enabled = false
        lv.Parent = hrp
    end
    return lv
end

local function isCeilingAbove(char)
    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not head then return false end
    _infJumpRayParams.FilterDescendantsInstances = {char}
    local hit = workspace:Raycast(head.Position, Vector3.new(0, 2.5, 0), _infJumpRayParams)
    return hit ~= nil
end

local INF_JUMP_FORCE = 40
local INF_HOLD_SPEED = 50

RunService.Heartbeat:Connect(function()
    if not State.infJumpEnabled then return end
    local char = LP.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end
    local lv = hrp:FindFirstChild("InfJumpVelocity") or setupInfJumpPhysics(char)
    if not lv then return end

    if State.infJumpMode == "hold" then
        if humanoid.Jump and not isCeilingAbove(char) then
            lv.LineVelocity = INF_HOLD_SPEED
            lv.Enabled = true
        else
            if lv.Enabled then lv.Enabled = false end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if not State.infJumpEnabled then return end
    if State.infJumpMode ~= "manual" then return end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local lv = hrp:FindFirstChild("InfJumpVelocity") or setupInfJumpPhysics(char)
    if not lv then return end
    if isCeilingAbove(char) then return end
    lv.LineVelocity = INF_JUMP_FORCE
    lv.Enabled = true
    task.delay(0.12, function()
        if lv and lv.Parent then lv.Enabled = false end
    end)
end)

LP.CharacterAdded:Connect(function(char)
    task.defer(function() setupInfJumpPhysics(char) end)
end)
if LP.Character then task.defer(function() setupInfJumpPhysics(LP.Character) end) end

RunService.Heartbeat:Connect(function()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    local featureMove = State.autoLeftEnabled or State.autoRightEnabled or autoBatEnabled
        or (_G.BatAimbot2 and _G.BatAimbot2.isActive and _G.BatAimbot2.isActive())
        or _G.tpBatModeActive

    if isRagdolledState(hum) then
        if not featureMove then
            hardStopMovement(root, hum)
        else
            clearSpeedVectorForce(root)
        end
        return
    end

    local st = hum:GetState()
    if st == Enum.HumanoidStateType.Running or st == Enum.HumanoidStateType.Freefall or st == Enum.HumanoidStateType.Jumping then
        if hum.PlatformStand then hum.PlatformStand = false end
        if hum.Sit then hum.Sit = false end
    end

    if not featureMove then
        local lv = root:FindFirstChild("KzLinearVelocity")
        local md = hum.MoveDirection
        if lv and lv.Enabled then
            if md.Magnitude < 0.05 then
                clearLinearVelocity(root)
            elseif lv.VelocityConstraintMode == Enum.VelocityConstraintMode.Vector then
                local v = lv.VectorVelocity
                if v.Magnitude < 0.5 then
                    clearLinearVelocity(root)
                end
            end
        end
        local vf = root:FindFirstChild("SpeedVectorForce")
        if vf and vf.Enabled and md.Magnitude < 0.05 then
            vf.Force = Vector3.zero
            vf.Enabled = false
        end
        if md.Magnitude < 0.05 then
            local ang = root.AssemblyAngularVelocity
            if ang.Magnitude > 1 then
                root.AssemblyAngularVelocity = Vector3.zero
            end
            if not hum.AutoRotate then
                hum.AutoRotate = true
            end
        end
    end
end)

local antiPlayerCollisionConn = nil
local function startAntiPlayerCollision()
    if antiPlayerCollisionConn then return end
    antiPlayerCollisionConn = RunService.Stepped:Connect(function()
        if not State.antiPlayerCollision then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end
local function stopAntiPlayerCollision()
    if antiPlayerCollisionConn then
        antiPlayerCollisionConn:Disconnect()
        antiPlayerCollisionConn = nil
    end
end
if State.antiPlayerCollision then
    task.spawn(function() task.wait(0.3); startAntiPlayerCollision() end)
end

function loadConfigState()
    local hasFile=false; pcall(function() hasFile=isfile(FileName) end); if not hasFile then return end
    local ok, cfg = pcall(function() return HttpService:JSONDecode(readfile(FileName)) end); if not ok or not cfg then return end
    if type(cfg.normalSpeed)=="number" then State.normalSpeed=cfg.normalSpeed end
    if type(cfg.carrySpeed)=="number" then State.carrySpeed=cfg.carrySpeed end
    if type(cfg.normalSpeed2)=="number" then State.normalSpeed2=cfg.normalSpeed2 end
    if type(cfg.carrySpeed2)=="number" then State.carrySpeed2=cfg.carrySpeed2 end
    if type(cfg.normalSpeed3)=="number" then State.normalSpeed3=cfg.normalSpeed3 end
    if type(cfg.carrySpeed3)=="number" then State.carrySpeed3=cfg.carrySpeed3 end
    if cfg.useSecondSpeedSet and cfg.useThirdSpeedSet then
        State.useThirdSpeedSet = false
        SetSetting("useThirdSpeedSet", false)
        State.useSecondSpeedSet = true
    else
        if cfg.useSecondSpeedSet ~= nil then State.useSecondSpeedSet = cfg.useSecondSpeedSet end
        if cfg.useThirdSpeedSet ~= nil then State.useThirdSpeedSet = cfg.useThirdSpeedSet end
    end
    if type(cfg.laggerSpeed1)=="number" then State.laggerSpeed1=cfg.laggerSpeed1 end
    if type(cfg.laggerSpeed2)=="number" then State.laggerSpeed2=cfg.laggerSpeed2 end
    if type(cfg.laggerLevel)=="number" then State.laggerLevel=cfg.laggerLevel end
    if cfg.speedType=="normal" or cfg.speedType=="carry" then State.speedType=cfg.speedType end
    if type(cfg.autoCarryEnabled)=="boolean" then State.autoCarryEnabled=cfg.autoCarryEnabled end
    if type(cfg.grabRadius)=="number" then
        STEAL_RADIUS=cfg.grabRadius
        if _G.StealBar and _G.StealBar.setRadius then _G.StealBar.setRadius(STEAL_RADIUS) end
    end
    if type(cfg.stealDuration)=="number" then STEAL_DURATION=cfg.stealDuration end
    if cfg.autoStealEnabled then
        AutoStealEnabled=true
        if _G.StealBar then _G.StealBar.start() end
        if setInstaGrab then setInstaGrab(true) end
    end
    if cfg.infJumpEnabled then State.infJumpEnabled=true end
    if cfg.infJumpMode=="manual" or cfg.infJumpMode=="hold" then State.infJumpMode=cfg.infJumpMode end
    if type(cfg.antiRagdollV1Enabled)=="boolean" then State.antiRagdollV1Enabled=cfg.antiRagdollV1Enabled end
    if type(cfg.antiRagdollV2Enabled)=="boolean" then State.antiRagdollV2Enabled=cfg.antiRagdollV2Enabled end
    if type(cfg.antiRagdollActiveVersion)=="number" then State.antiRagdollActiveVersion=cfg.antiRagdollActiveVersion end
    if State.antiRagdollActiveVersion == 1 then
        startAntiRagdollV1()
    elseif State.antiRagdollActiveVersion == 2 then
        startAntiRagdollV2()
    end
    if cfg.fpsBoostEnabled then State.fpsBoostEnabled=true; applyFPSBoost() end
    if cfg.medusaCounterEnabled then State.medusaCounterEnabled=true; setupMedusaCounter(LP.Character) end
    if cfg.animEnabled then State.animEnabled=true; startAnimToggle() end
    if cfg.unwalkEnabled then task.spawn(function() task.wait(0.5); startUnwalk() end) end
    if type(cfg.autoBatToggled)=="boolean" then State.autoBatToggled=cfg.autoBatToggled end
    State.autoLeftEnabled = false
    State.autoRightEnabled = false
    if type(cfg.autoTpDownEnabled)=="boolean" then State.autoTpDownEnabled=cfg.autoTpDownEnabled end
    if type(cfg.autoTpDownY)=="number" then State.autoTpDownY=cfg.autoTpDownY end
    if cfg.dropEnabled ~= nil then State.dropEnabled = cfg.dropEnabled end
    if type(cfg.antiPlayerCollision)=="boolean" then
        State.antiPlayerCollision = cfg.antiPlayerCollision
        if State.antiPlayerCollision then task.spawn(function() task.wait(0.4); startAntiPlayerCollision() end) end
    end
    if type(cfg.aimbot2Speed)=="number" then State.aimbot2Speed=cfg.aimbot2Speed end
    if type(cfg.hitbuxEnabled)=="boolean" then State.hitbuxEnabled=cfg.hitbuxEnabled end
    if type(cfg.bodyLockEnabled)=="boolean" then
        State.bodyLockEnabled = cfg.bodyLockEnabled
        bodyLockEnabled = cfg.bodyLockEnabled
        if State.bodyLockEnabled then
            task.spawn(function()
                task.wait(0.5)
                startBodyLock()
            end)
        end
    end
    if type(cfg.bodyLockRange)=="number" then
        State.bodyLockRange = cfg.bodyLockRange
        bodyLockRange = cfg.bodyLockRange
    end
    if type(cfg.bypassToggled)=="boolean" then State.bypassToggled=cfg.bypassToggled end
    if type(cfg.bypassMode)=="number" and (cfg.bypassMode==1 or cfg.bypassMode==2) then State.bypassMode=cfg.bypassMode end
    if type(cfg.bypassSpeed)=="number" then State.bypassSpeed=cfg.bypassSpeed end
    for _, song in ipairs(SONG_LIST) do
        local stateKey = song.configKey
        if type(cfg[stateKey]) == "boolean" then
            State[stateKey] = cfg[stateKey]
            if State[stateKey] then
                task.spawn(function()
                    task.wait(0.2)
                    local musicObj = musicSounds[song.key]
                    if musicObj then
                        musicObj.toggle(true)
                    end
                end)
            end
        end
    end
    local function loadKey(cfgKey, stateKey)
        if type(cfg[cfgKey])=="string" and cfg[cfgKey]~="Unknown" then
            local ok2,kc=pcall(function() return Enum.KeyCode[cfg[cfgKey]] end)
            if ok2 and kc then State[stateKey]=kc; local chip=keybindChipRefs[stateKey]; if chip then chip.Text=kc.Name end end
        end
    end
    loadKey("keyAutoLeft","keyAutoLeft")
    loadKey("keyAutoRight","keyAutoRight")
    loadKey("keyDropBR","keyDropBR")
    loadKey("keyTpDown","keyTpDown")
    loadKey("keyAutoBat","keyAutoBat")
    loadKey("keySpeedToggle","keySpeedToggle")
    loadKey("keyAutoTpDown","keyAutoTpDown")
    loadKey("keyInstaReset","keyInstaReset")
    loadKey("keySpeed2","keySpeed2")
    loadKey("keySpeed3","keySpeed3")
    loadKey("keyLagger","keyLagger")
    loadKey("keyBatAim2","keyBatAim2")
    loadKey("keyTpBat","keyTpBat")
    if cfg.skyEnabled then State.skyEnabled=cfg.skyEnabled; if cfg.skyEnabled then task.spawn(function() task.wait(0.2); enableSky(cfg.skyColorIndex or 1) end) end end
    if cfg.skyColorIndex then State.skyColorIndex=cfg.skyColorIndex end
    if cfg.floatEnabled then State.floatEnabled=cfg.floatEnabled; if cfg.floatEnabled then task.spawn(function() task.wait(0.3); startFloat() end) end end
    if cfg.floatHeight then State.floatHeight=cfg.floatHeight end
    if cfg.stretchRezEnabled then State.stretchRezEnabled=cfg.stretchRezEnabled; if cfg.stretchRezEnabled then task.spawn(function() task.wait(0.3); enableStretchRez() end) end end
    if cfg.batCounterEnabled then State.batCounterEnabled=cfg.batCounterEnabled; if cfg.batCounterEnabled then task.spawn(function() task.wait(0.3); startBatCounter() end) end end
    if cfg.waypointESPEnabled then State.waypointESPEnabled=cfg.waypointESPEnabled; if cfg.waypointESPEnabled then task.spawn(function() task.wait(0.3); startWaypointESP() end) end end
    if cfg.controllerEnabled then State.controllerEnabled=cfg.controllerEnabled; if cfg.controllerEnabled then task.spawn(function() task.wait(0.3); startControllerSupport() end) end end
    if cfg.guiLocked ~= nil then State.guiLocked = cfg.guiLocked end
    if cfg.mobileLocked ~= nil then State.mobileLocked = cfg.mobileLocked end
    if type(cfg.mbButtonScale)=="number" then
        mbScaleFactor = cfg.mbButtonScale
        task.spawn(function() task.wait(0.4); applyMBScale(mbScaleFactor) end)
    end
    task.spawn(function()
        task.wait(0.6)
        if setMB_AL then setMB_AL(State.autoLeftEnabled) end; if setMB_AR then setMB_AR(State.autoRightEnabled) end; if setMB_AB then setMB_AB(State.autoBatToggled) end
        if setMB_CS then setMB_CS(State.speedType=="carry") end
        if setMB_LC then setMB_LC() end
        if setMB_AT then setMB_AT(State.autoTpDownEnabled) end
        if setInstaGrab then setInstaGrab(AutoStealEnabled) end
        syncDropButtons()
        if State.dropEnabled then toggleDropGlitch(true) end
        refreshUIToggles()
        if State.hitbuxEnabled then startHitbux() end
        if State.bodyLockEnabled then startBodyLock() end
        if State.bypassToggled then
            task.spawn(function()
                task.wait(0.3)
                local btn = gui:FindFirstChild("BatAimButton")
                if btn then
                    local isActive = btn.TextColor3 == Color3.fromRGB(255, 255, 255)
                    if not isActive then
                        btn:Click()
                    end
                end
            end)
        end
        updateSpeedFloatButtons()
        buildFullGUI()
    end)
end

loadMainPosition(); loadMiniPosition()
pcall(function() loadPos(mbGroup, "KzsHubMBPos.txt") end)
refreshUIToggles(); loadConfigState()

task.spawn(function()
    task.wait(0.7)
    local btn = Instance.new("TextButton")
    btn.Name = "Speed2FloatingButton"
    btn.Parent = gui
    btn.Size = UDim2.new(0, 100, 0, 26)
    btn.Position = UDim2.new(0, 10, 0.65, 0)
    btn.Text = "Speed 2"
    btn.BackgroundColor3 = Q_OFF
    btn.TextColor3 = Q_TEXT
    btn.BackgroundTransparency = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.TextWrapped = true
    btn.AutoButtonColor = false
    btn.ZIndex = 300

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, QR)
    corner.Parent = btn

    local function updateButton()
        if State.useSecondSpeedSet then
            btn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Q_OFF
            btn.TextColor3 = Q_TEXT
        end
    end

    btn.MouseButton1Click:Connect(function()
        if _G.stopTpBat then _G.stopTpBat() end
        if State.useSecondSpeedSet then
            State.useSecondSpeedSet = false
            SetSetting("useSecondSpeedSet", false)
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("TextButton") and child.Name == "Mode2FloatingButton" then
                    child.Text = "Speed 2"
                    child.TextColor3 = ACCENT
                    child.BackgroundColor3 = PITCH_BLACK
                    local stroke = child:FindFirstChildWhichIsA("UIStroke")
                    if stroke then stroke.Color = DARK_ACC end
                end
            end
            pcall(function()
                for _, child in ipairs(pageMain:GetChildren()) do
                    if child:IsA("Frame") then
                        local label = child:FindFirstChildOfClass("TextLabel")
                        if label and label.Text == "Speed 2" then
                            for _, c in ipairs(child:GetChildren()) do
                                if c:IsA("Frame") and c ~= label then
                                    local dot = nil
                                    for _, d in ipairs(c:GetChildren()) do
                                        if d:IsA("Frame") then dot = d; break end
                                    end
                                    TweenService:Create(c, TweenInfo.new(0.18), {
                                        BackgroundColor3 = C_OFF_BG
                                    }):Play()
                                    local pStroke = c:FindFirstChildWhichIsA("UIStroke")
                                    if pStroke then
                                        TweenService:Create(pStroke, TweenInfo.new(0.18), {
                                            Color = DARK_ACC
                                        }):Play()
                                    end
                                    if dot then
                                        TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
                                            Position = UDim2.new(0, 2, 0.5, -5),
                                            BackgroundColor3 = C_DIM
                                        }):Play()
                                    end
                                    break
                                end
                            end
                            break
                        end
                    end
                end
            end)
        else
            if State.useThirdSpeedSet then
                State.useThirdSpeedSet = false
                SetSetting("useThirdSpeedSet", false)
                for _, child in ipairs(gui:GetChildren()) do
                    if child:IsA("TextButton") and child.Name == "Mode3FloatingButton" then
                        child.Text = "Speed 3"
                        child.TextColor3 = ACCENT
                        child.BackgroundColor3 = PITCH_BLACK
                        local stroke = child:FindFirstChildWhichIsA("UIStroke")
                        if stroke then stroke.Color = DARK_ACC end
                    end
                    if child:IsA("TextButton") and child.Name == "Speed3FloatingButton" then
                        child.BackgroundColor3 = Q_OFF
                        child.TextColor3 = Q_TEXT
                    end
                end
                pcall(function()
                    for _, child in ipairs(pageMain:GetChildren()) do
                        if child:IsA("Frame") then
                            local label = child:FindFirstChildOfClass("TextLabel")
                            if label and label.Text == "Speed 3" then
                                for _, c in ipairs(child:GetChildren()) do
                                    if c:IsA("Frame") and c ~= label then
                                        local dot = nil
                                        for _, d in ipairs(c:GetChildren()) do
                                            if d:IsA("Frame") then dot = d; break end
                                        end
                                        TweenService:Create(c, TweenInfo.new(0.18), {
                                            BackgroundColor3 = C_OFF_BG
                                        }):Play()
                                        local pStroke = c:FindFirstChildWhichIsA("UIStroke")
                                        if pStroke then
                                            TweenService:Create(pStroke, TweenInfo.new(0.18), {
                                                Color = DARK_ACC
                                            }):Play()
                                        end
                                        if dot then
                                            TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
                                                Position = UDim2.new(0, 2, 0.5, -5),
                                                BackgroundColor3 = C_DIM
                                            }):Play()
                                        end
                                        break
                                    end
                                end
                                break
                            end
                        end
                    end
                end)
            end
            State.useSecondSpeedSet = true
            SetSetting("useSecondSpeedSet", true)
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("TextButton") and child.Name == "Mode2FloatingButton" then
                    child.Text = "Speed 2"
                    child.TextColor3 = C_WHITE
                    child.BackgroundColor3 = ACCENT
                    local stroke = child:FindFirstChildWhichIsA("UIStroke")
                    if stroke then stroke.Color = ACCENT end
                end
            end
        end
        refreshUIToggles()
        updateButton()
        updateSpeedFloatButtons()
        for _, child in ipairs(gui:GetChildren()) do
            if child:IsA("TextButton") and child.Name == "Speed3FloatingButton" then
                if State.useThirdSpeedSet then
                    child.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
                    child.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    child.BackgroundColor3 = Q_OFF
                    child.TextColor3 = Q_TEXT
                end
            end
        end
        if _G.setSpeed2Toggle then _G.setSpeed2Toggle(State.useSecondSpeedSet) end
    end)

    local dragging = false
    local dragStartPos = nil
    local dragStartMousePos = nil
    local activeTouch = nil
    local dragThreshold = 10

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if activeTouch and activeTouch ~= input then return end
            activeTouch = input
            dragStartPos = btn.Position
            dragStartMousePos = input.Position
            dragging = false
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input == activeTouch then
            dragging = false
            activeTouch = nil
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if State.mobileLocked then return end
        if activeTouch and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if input == activeTouch then
                local delta = input.Position - dragStartMousePos
                if not dragging and (math.abs(delta.X) > dragThreshold or math.abs(delta.Y) > dragThreshold) then
                    dragging = true
                end
                if dragging then
                    btn.Position = UDim2.new(
                        dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
                        dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
                    )
                end
            end
        end
    end)

    local lastSave = 0
    btn:GetPropertyChangedSignal("Position"):Connect(function()
        if tick() - lastSave > 0.5 then
            lastSave = tick()
            pcall(function()
                writefile("KzsHubSpeed2Pos.txt", string.format("%.3f,%.1f,%.3f,%.1f",
                    btn.Position.X.Scale, btn.Position.X.Offset,
                    btn.Position.Y.Scale, btn.Position.Y.Offset))
            end)
        end
    end)

    pcall(function()
        local data = readfile("KzsHubSpeed2Pos.txt")
        if data and data ~= "" then
            local parts = {}
            for v in string.gmatch(data, "[^,]+") do
                table.insert(parts, tonumber(v))
            end
            if #parts >= 4 then
                btn.Position = UDim2.new(parts[1], parts[2], parts[3], parts[4])
            end
        end
    end)

    btn.MouseEnter:Connect(function()
        if not State.mobileLocked then
            btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        end
    end)
    btn.MouseLeave:Connect(function()
        updateButton()
    end)

    updateButton()
end)

task.spawn(function()
    task.wait(0.8)
    local btn = Instance.new("TextButton")
    btn.Name = "Speed3FloatingButton"
    btn.Parent = gui
    btn.Size = UDim2.new(0, 100, 0, 26)
    btn.Position = UDim2.new(0, 10, 0.60, 0)
    btn.Text = "Speed 3"
    btn.BackgroundColor3 = Q_OFF
    btn.TextColor3 = Q_TEXT
    btn.BackgroundTransparency = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.TextWrapped = true
    btn.AutoButtonColor = false
    btn.ZIndex = 300

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, QR)
    corner.Parent = btn

    local function updateButton()
        if State.useThirdSpeedSet then
            btn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Q_OFF
            btn.TextColor3 = Q_TEXT
        end
    end

    btn.MouseButton1Click:Connect(function()
        if _G.stopTpBat then _G.stopTpBat() end
        if State.useThirdSpeedSet then
            State.useThirdSpeedSet = false
            SetSetting("useThirdSpeedSet", false)
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("TextButton") and child.Name == "Mode3FloatingButton" then
                    child.Text = "Speed 3"
                    child.TextColor3 = ACCENT
                    child.BackgroundColor3 = PITCH_BLACK
                    local stroke = child:FindFirstChildWhichIsA("UIStroke")
                    if stroke then stroke.Color = DARK_ACC end
                end
                if child:IsA("TextButton") and child.Name == "Speed2FloatingButton" then
                    child.BackgroundColor3 = Q_OFF
                    child.TextColor3 = Q_TEXT
                end
            end
            pcall(function()
                for _, child in ipairs(pageMain:GetChildren()) do
                    if child:IsA("Frame") then
                        local label = child:FindFirstChildOfClass("TextLabel")
                        if label and label.Text == "Speed 3" then
                            for _, c in ipairs(child:GetChildren()) do
                                if c:IsA("Frame") and c ~= label then
                                    local dot = nil
                                    for _, d in ipairs(c:GetChildren()) do
                                        if d:IsA("Frame") then dot = d; break end
                                    end
                                    TweenService:Create(c, TweenInfo.new(0.18), {
                                        BackgroundColor3 = C_OFF_BG
                                    }):Play()
                                    local pStroke = c:FindFirstChildWhichIsA("UIStroke")
                                    if pStroke then
                                        TweenService:Create(pStroke, TweenInfo.new(0.18), {
                                            Color = DARK_ACC
                                        }):Play()
                                    end
                                    if dot then
                                        TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
                                            Position = UDim2.new(0, 2, 0.5, -5),
                                            BackgroundColor3 = C_DIM
                                        }):Play()
                                    end
                                    break
                                end
                            end
                            break
                        end
                    end
                end
            end)
        else
            if State.useSecondSpeedSet then
                State.useSecondSpeedSet = false
                SetSetting("useSecondSpeedSet", false)
                for _, child in ipairs(gui:GetChildren()) do
                    if child:IsA("TextButton") and child.Name == "Mode2FloatingButton" then
                        child.Text = "Speed 2"
                        child.TextColor3 = ACCENT
                        child.BackgroundColor3 = PITCH_BLACK
                        local stroke = child:FindFirstChildWhichIsA("UIStroke")
                        if stroke then stroke.Color = DARK_ACC end
                    end
                    if child:IsA("TextButton") and child.Name == "Speed2FloatingButton" then
                        child.BackgroundColor3 = Q_OFF
                        child.TextColor3 = Q_TEXT
                    end
                end
                pcall(function()
                    for _, child in ipairs(pageMain:GetChildren()) do
                        if child:IsA("Frame") then
                            local label = child:FindFirstChildOfClass("TextLabel")
                            if label and label.Text == "Speed 2" then
                                for _, c in ipairs(child:GetChildren()) do
                                    if c:IsA("Frame") and c ~= label then
                                        local dot = nil
                                        for _, d in ipairs(c:GetChildren()) do
                                            if d:IsA("Frame") then dot = d; break end
                                        end
                                        TweenService:Create(c, TweenInfo.new(0.18), {
                                            BackgroundColor3 = C_OFF_BG
                                        }):Play()
                                        local pStroke = c:FindFirstChildWhichIsA("UIStroke")
                                        if pStroke then
                                            TweenService:Create(pStroke, TweenInfo.new(0.18), {
                                                Color = DARK_ACC
                                            }):Play()
                                        end
                                        if dot then
                                            TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
                                                Position = UDim2.new(0, 2, 0.5, -5),
                                                BackgroundColor3 = C_DIM
                                            }):Play()
                                        end
                                        break
                                    end
                                end
                                break
                            end
                        end
                    end
                end)
            end
            State.useThirdSpeedSet = true
            SetSetting("useThirdSpeedSet", true)
            for _, child in ipairs(gui:GetChildren()) do
                if child:IsA("TextButton") and child.Name == "Mode3FloatingButton" then
                    child.Text = "Speed 3"
                    child.TextColor3 = C_WHITE
                    child.BackgroundColor3 = ACCENT
                    local stroke = child:FindFirstChildWhichIsA("UIStroke")
                    if stroke then stroke.Color = ACCENT end
                end
            end
        end
        refreshUIToggles()
        updateButton()
        updateSpeedFloatButtons()
        for _, child in ipairs(gui:GetChildren()) do
            if child:IsA("TextButton") and child.Name == "Speed2FloatingButton" then
                if State.useSecondSpeedSet then
                    child.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
                    child.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    child.BackgroundColor3 = Q_OFF
                    child.TextColor3 = Q_TEXT
                end
            end
        end
        if _G.setSpeed3Toggle then _G.setSpeed3Toggle(State.useThirdSpeedSet) end
    end)

    local dragging = false
    local dragStartPos = nil
    local dragStartMousePos = nil
    local activeTouch = nil
    local dragThreshold = 10

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if activeTouch and activeTouch ~= input then return end
            activeTouch = input
            dragStartPos = btn.Position
            dragStartMousePos = input.Position
            dragging = false
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input == activeTouch then
            dragging = false
            activeTouch = nil
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if State.mobileLocked then return end
        if activeTouch and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if input == activeTouch then
                local delta = input.Position - dragStartMousePos
                if not dragging and (math.abs(delta.X) > dragThreshold or math.abs(delta.Y) > dragThreshold) then
                    dragging = true
                end
                if dragging then
                    btn.Position = UDim2.new(
                        dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
                        dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
                    )
                end
            end
        end
    end)

    local lastSave = 0
    btn:GetPropertyChangedSignal("Position"):Connect(function()
        if tick() - lastSave > 0.5 then
            lastSave = tick()
            pcall(function()
                writefile("KzsHubSpeed3Pos.txt", string.format("%.3f,%.1f,%.3f,%.1f",
                    btn.Position.X.Scale, btn.Position.X.Offset,
                    btn.Position.Y.Scale, btn.Position.Y.Offset))
            end)
        end
    end)

    pcall(function()
        local data = readfile("KzsHubSpeed3Pos.txt")
        if data and data ~= "" then
            local parts = {}
            for v in string.gmatch(data, "[^,]+") do
                table.insert(parts, tonumber(v))
            end
            if #parts >= 4 then
                btn.Position = UDim2.new(parts[1], parts[2], parts[3], parts[4])
            end
        end
    end)

    btn.MouseEnter:Connect(function()
        if not State.mobileLocked then
            btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        end
    end)
    btn.MouseLeave:Connect(function()
        updateButton()
    end)

    updateButton()
end)

task.spawn(function()
    task.wait(1)

    local FLOAT_SIZE = 64
    local button = Instance.new("TextButton")
    button.Name = "BatAimButton"
    button.Parent = gui
    button.Size = UDim2.new(0, FLOAT_SIZE, 0, FLOAT_SIZE)
    button.Position = UDim2.new(0, 10, 0.82, 0)
    button.Text = "Bat v2"
    button.TextColor3 = Q_TEXT
    button.BackgroundColor3 = Q_OFF
    button.BackgroundTransparency = 0
    button.Font = Enum.Font.GothamBold
    button.TextSize = 11
    button.TextWrapped = true
    button.AutoButtonColor = false
    button.ZIndex = 300

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, QR)
    uiCorner.Parent = button

    local dragging = false
    local dragStartPos = nil
    local dragStartMousePos = nil
    local clickStartTime = nil
    local activeTouch = nil
    local dragThreshold = 10

    local isActive = false
    local heartbeatConn = nil




    local LUST_BYPASS_AIMBOT_SPEED = 68
    local BAT_V2_FOLLOW_DIST = 0.85
    local BAT_V2_HEIGHT_OFFSET = 1.35
    local BAT_V2_HIT_DIST = 4.2
    local BAT_V2_SWING_COOLDOWN = 0.08

    local bypassHittingCooldown = false

    function findBatV2()
        local char = LP.Character
        if not char then return nil end
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                return tool
            end
        end
        local bp = LP:FindFirstChild("Backpack")
        if bp then
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                    return tool
                end
            end
        end
        return nil
    end

    function getClosestPlayerV2()
        local char = LP.Character
        if not char then return nil, math.huge end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return nil, math.huge end

        local closest, bestDist = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
                if targetRoot and targetHum and targetHum.Health > 0 then
                    local dist = (root.Position - targetRoot.Position).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        closest = player
                    end
                end
            end
        end
        return closest, bestDist
    end

    function tryHitBypassBat()
        if bypassHittingCooldown then return end
        bypassHittingCooldown = true

        pcall(function()
            local char = LP.Character
            if not char then return end

            local bat = findBatV2()
            if bat then
                if bat.Parent ~= char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:EquipTool(bat) end
                end

                local remote = bat:FindFirstChildOfClass("RemoteEvent")
                if remote then
                    remote:FireServer()
                else
                    bat:Activate()
                end
            end
        end)

        task.delay(BAT_V2_SWING_COOLDOWN, function()
            bypassHittingCooldown = false
        end)
    end

    function batV2Tick()
        if isPlayerStealing() then
            if isActive then stopBatAimbot2() end
            return
        end
        local char = LP.Character
        if not char then return end

        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid or humanoid.Health <= 0 then return end

        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown then
            return
        end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBatV2()
            if bat then humanoid:EquipTool(bat) end
        end

        local target, _ = getClosestPlayerV2()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local targetVel = targetRoot.AssemblyLinearVelocity
                local moveDir = targetVel.Magnitude > 0.1
                    and targetVel.Unit
                    or targetRoot.CFrame.LookVector

                local offset = moveDir * BAT_V2_FOLLOW_DIST
                    + Vector3.new(0, BAT_V2_HEIGHT_OFFSET, 0)
                local desiredPos = targetRoot.Position + offset

                local dirToTarget = desiredPos - root.Position
                if dirToTarget.Magnitude > 0.5 then
                    local moveVec = dirToTarget.Unit * LUST_BYPASS_AIMBOT_SPEED
                    setLinearVelocity(root, moveVec)
                    lookAtWithLinearVelocity(root, targetRoot.Position, LUST_BYPASS_AIMBOT_SPEED)
                else
                    local lv = getOrCreateLinearVelocity(root)
                    if lv then
                        local cur = lv.VectorVelocity
                        local slowed = cur * 0.9
                        if slowed.Magnitude < 1 then
                            setLinearVelocity(root, Vector3.zero)
                        else
                            setLinearVelocity(root, slowed)
                        end
                    end
                end

                if (root.Position - targetRoot.Position).Magnitude <= BAT_V2_HIT_DIST then
                    tryHitBypassBat()
                end
            end
        else
            clearLookRotation(root)
            local lv = getOrCreateLinearVelocity(root)
            if lv then
                local cur = lv.VectorVelocity
                local slowed = cur * 0.9
                if slowed.Magnitude < 1 then
                    clearLinearVelocity(root)
                else
                    setLinearVelocity(root, slowed)
                end
            end
        end
    end

    function startBatAimbot2()
        if isPlayerStealing() then
            isActive = false
            return
        end
        if _G.stopTpBat then _G.stopTpBat() end

        if isActive then return end

        if State.autoBatToggled then
            if _G.originalAutoBatStop then _G.originalAutoBatStop() end
            State.autoBatToggled = false
            if _G.originalAutoBatSyncUI then _G.originalAutoBatSyncUI(false) end
            SetSetting("autoBatToggled", false)
        end
        if State.autoLeftEnabled then
            State.autoLeftEnabled = false
            stopAutoLeft()
            if setAutoLeft then setAutoLeft(false) end
            if setMB_AL then setMB_AL(false) end
            SetSetting("autoLeftEnabled", false)
        end
        if State.autoRightEnabled then
            State.autoRightEnabled = false
            stopAutoRight()
            if setAutoRight then setAutoRight(false) end
            if setMB_AR then setMB_AR(false) end
            SetSetting("autoRightEnabled", false)
        end

        isActive = true
        State.bypassToggled = true
        SetSetting("bypassToggled", true)

        if heartbeatConn then heartbeatConn:Disconnect() end
        heartbeatConn = RunService.Heartbeat:Connect(function()
            if not isActive then return end
            pcall(batV2Tick)
        end)
        updateButtonUI()
    end

    function stopBatAimbot2()
        if not isActive then return end
        isActive = false
        State.bypassToggled = false
        SetSetting("bypassToggled", false)
        if heartbeatConn then
            heartbeatConn:Disconnect()
            heartbeatConn = nil
        end
        local c = LP.Character
        local myH = c and c:FindFirstChild("HumanoidRootPart")
        if myH then clearLinearVelocity(myH); clearLookRotation(myH) end
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.AutoRotate = true
            hum.PlatformStand = false
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        end
        bypassHittingCooldown = false
        updateButtonUI()
    end

    local function toggleAimbot()
        if isActive then
            stopBatAimbot2()
        else
            startBatAimbot2()
        end
    end

    _G.BatAimbot2.start = startBatAimbot2
    _G.BatAimbot2.stop = stopBatAimbot2
    _G.BatAimbot2.update = updateButtonUI
    _G.BatAimbot2.isActive = function() return isActive end

    local function isDragLocked()
        return State.mobileLocked == true
    end

    function updateButtonUI()
        if isActive then
            button.BackgroundColor3 = Q_ON
            button.TextColor3 = C_WHITE
            button.Text = "Bat v2"
        else
            button.BackgroundColor3 = Q_OFF
            button.TextColor3 = Q_TEXT
            button.Text = "Bat v2"
        end
        if _G.batV2SetterRef then
            _G.batV2SetterRef(isActive)
        end
    end

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if activeTouch and activeTouch ~= input then return end
            activeTouch = input
            clickStartTime = tick()
            dragStartPos = button.Position
            dragStartMousePos = input.Position
            dragging = false
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input == activeTouch then
            if not dragging and clickStartTime and (tick() - clickStartTime) < 0.3 then
                toggleAimbot()
            end
            dragging = false
            activeTouch = nil
            clickStartTime = nil
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if isDragLocked() then return end
        if activeTouch and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if input == activeTouch then
                local delta = input.Position - dragStartMousePos
                local distanceMoved = math.sqrt(delta.X^2 + delta.Y^2)
                if not dragging and distanceMoved > dragThreshold then
                    dragging = true
                end
                if dragging then
                    local newPosition = UDim2.new(
                        dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
                        dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
                    )
                    button.Position = newPosition
                end
            end
        end
    end)

    local lastSave = 0
    button:GetPropertyChangedSignal("Position"):Connect(function()
        if tick() - lastSave > 0.5 then
            lastSave = tick()
            pcall(function()
                writefile("KzsHubBatAimPos.txt", string.format("%.3f,%.1f,%.3f,%.1f",
                    button.Position.X.Scale, button.Position.X.Offset,
                    button.Position.Y.Scale, button.Position.Y.Offset))
            end)
        end
    end)

    pcall(function()
        local data = readfile("KzsHubBatAimPos.txt")
        if data and data ~= "" then
            local parts = {}
            for v in string.gmatch(data, "[^,]+") do
                table.insert(parts, tonumber(v))
            end
            if #parts >= 4 then
                button.Position = UDim2.new(parts[1], parts[2], parts[3], parts[4])
            end
        end
    end)

    button.MouseEnter:Connect(function()
        if not isDragLocked() then
            button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        end
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Q_OFF
        updateButtonUI()
    end)

    local oldAutoLeft = false
    local oldAutoRight = false
    task.spawn(function()
        while true do
            task.wait(0.1)
            if State.autoLeftEnabled ~= oldAutoLeft or State.autoRightEnabled ~= oldAutoRight then
                oldAutoLeft = State.autoLeftEnabled
                oldAutoRight = State.autoRightEnabled
                if (State.autoLeftEnabled or State.autoRightEnabled) and isActive then
                    stopBatAimbot2()
                end
            end
        end
    end)

    if Config.bypassToggled ~= nil then
        State.bypassToggled = Config.bypassToggled
    end
    State.bypassMode = 1
    SetSetting("bypassMode", 1)
    if Config.bypassSpeed ~= nil then
        State.bypassSpeed = Config.bypassSpeed
    end

    if State.bypassToggled then
        task.spawn(function() task.wait(0.2); startBatAimbot2() end)
    end
    updateButtonUI()
end)

task.spawn(function()
    task.wait(0.6)

    local FLOAT_SIZE = 64
    local tpBatButton = Instance.new("TextButton")
    tpBatButton.Name = "TpBatButton"
    tpBatButton.Parent = gui
    tpBatButton.Size = UDim2.new(0, FLOAT_SIZE, 0, FLOAT_SIZE)
    tpBatButton.Position = UDim2.new(0, 10, 0.70, 0)
    tpBatButton.Text = "TP Bat"
    tpBatButton.TextColor3 = Q_TEXT
    tpBatButton.BackgroundColor3 = Q_OFF
    tpBatButton.BackgroundTransparency = 0
    tpBatButton.Font = Enum.Font.GothamBold
    tpBatButton.TextSize = 11
    tpBatButton.TextWrapped = true
    tpBatButton.AutoButtonColor = false
    tpBatButton.ZIndex = 300

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, QR)
    uiCorner.Parent = tpBatButton

    local tpBatActive = false
    local tpBatHeartbeat = nil
    local tpBatHittingCooldown = false

    local function getBatTP()
        local char = LP.Character
        if not char then return nil end
        local tool = char:FindFirstChild("Bat")
        if tool then return tool end
        local bp = LP:FindFirstChild("Backpack")
        if bp then
            tool = bp:FindFirstChild("Bat")
            if tool then
                tool.Parent = char
                return tool
            end
        end
        return nil
    end

    local function tryHitBatTP()
        if tpBatHittingCooldown then return end
        tpBatHittingCooldown = true
        pcall(function()
            local bat = getBatTP()
            if bat then
                bat:Activate()
                local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then ev:FireServer() end
            end
        end)
        task.delay(0.08, function()
            tpBatHittingCooldown = false
        end)
    end

    local function getClosestPlayerTP()
        local char = LP.Character
        if not char then return nil, math.huge end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil, math.huge end
        local closest, minDist = nil, math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local torso = p.Character:FindFirstChild("HumanoidRootPart")
                if torso then
                    local d = (hrp.Position - torso.Position).Magnitude
                    if d < minDist then
                        minDist = d
                        closest = p
                    end
                end
            end
        end
        return closest, minDist
    end

    local function tpBatTick()
        if isPlayerStealing() then
            if tpBatActive and _G.stopTpBat then _G.stopTpBat() end
            return
        end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = getBatTP()
            if bat and hum then pcall(function() hum:EquipTool(bat) end) end
        end

        local target, dist = getClosestPlayerTP()
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local dest = targetPart.Position + Vector3.new(0, 1.0, 0)
                hrp.CFrame = CFrame.new(dest)

                lookAtWithLinearVelocity(hrp, targetPart.Position, 20)

                if hum.MoveDirection.Magnitude > 0 then
                    local vel = hrp.AssemblyLinearVelocity
                    setLinearVelocity(hrp, Vector3.new(vel.X * 50, 50, vel.Z * 50))
                    task.defer(function()
                        if hrp and hrp.Parent then
                            local v2 = hrp.AssemblyLinearVelocity
                            setLinearVelocity(hrp, v2 + Vector3.new(0, 0.05, 0))
                            lookAtWithLinearVelocity(hrp, targetPart.Position, 16)
                        end
                    end)
                end

                local cam = workspace.CurrentCamera
                if cam then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, targetPart.Position)
                end

                tryHitBatTP()
            end
        else
            clearLinearVelocity(hrp)
            clearLookRotation(hrp)
        end
    end

    local function startTpBat()
        if tpBatActive then return end

        if _G.BatAimbot2 and _G.BatAimbot2.stop then
            _G.BatAimbot2.stop()
        end

        tpBatActive = true
        _G.tpBatModeActive = true
        for _, setter in ipairs(_G.tpBatToggleSetters) do
            pcall(setter, true)
        end

        if tpBatHeartbeat then tpBatHeartbeat:Disconnect() end
        tpBatHeartbeat = RunService.Heartbeat:Connect(function()
            if not tpBatActive then return end
            pcall(tpBatTick)
        end)

        tpBatButton.BackgroundColor3 = Q_ON
        tpBatButton.TextColor3 = C_WHITE
    end

    _G.stopTpBat = function()
        if not tpBatActive then return end
        tpBatActive = false
        _G.tpBatModeActive = false
        for _, setter in ipairs(_G.tpBatToggleSetters) do
            pcall(setter, false)
        end
        if tpBatHeartbeat then
            tpBatHeartbeat:Disconnect()
            tpBatHeartbeat = nil
        end
        local char = LP.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                clearLinearVelocity(hrp)
                hrp.AssemblyAngularVelocity = Vector3.zero
                if sethiddenproperty then
                    pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", nil) end)
                end
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.AutoRotate = true end
        end
        tpBatButton.BackgroundColor3 = Q_OFF
        tpBatButton.TextColor3 = Q_TEXT
    end

    local function stopTpBat()
        _G.stopTpBat()
    end

    local function toggleTpBat()
        if tpBatActive then
            stopTpBat()
        else
            startTpBat()
        end
    end

    _G.setTpBatMode = function(on)
        if on and not tpBatActive then
            startTpBat()
        elseif not on and tpBatActive then
            stopTpBat()
        end
    end

    local dragging = false
    local dragStartPos = nil
    local dragStartMousePos = nil
    local clickStartTime = nil
    local activeTouch = nil
    local dragThreshold = 10

    local function isLocked()
        return State.mobileLocked == true
    end

    tpBatButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if activeTouch and activeTouch ~= input then return end
            activeTouch = input
            clickStartTime = tick()
            dragStartPos = tpBatButton.Position
            dragStartMousePos = input.Position
            dragging = false
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input == activeTouch then
            if not dragging and clickStartTime and (tick() - clickStartTime) < 0.3 then
                toggleTpBat()
            end
            dragging = false
            activeTouch = nil
            clickStartTime = nil
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if isLocked() then return end
        if activeTouch and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if input == activeTouch then
                local delta = input.Position - dragStartMousePos
                local distanceMoved = math.sqrt(delta.X^2 + delta.Y^2)
                if not dragging and distanceMoved > dragThreshold then
                    dragging = true
                end
                if dragging then
                    local newPosition = UDim2.new(
                        dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
                        dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
                    )
                    tpBatButton.Position = newPosition
                end
            end
        end
    end)

    local lastSave = 0
    tpBatButton:GetPropertyChangedSignal("Position"):Connect(function()
        if tick() - lastSave > 0.5 then
            lastSave = tick()
            pcall(function()
                writefile("KzsHubTpBatPos.txt", string.format("%.3f,%.1f,%.3f,%.1f",
                    tpBatButton.Position.X.Scale, tpBatButton.Position.X.Offset,
                    tpBatButton.Position.Y.Scale, tpBatButton.Position.Y.Offset))
            end)
        end
    end)

    pcall(function()
        local data = readfile("KzsHubTpBatPos.txt")
        if data and data ~= "" then
            local parts = {}
            for v in string.gmatch(data, "[^,]+") do
                table.insert(parts, tonumber(v))
            end
            if #parts >= 4 then
                tpBatButton.Position = UDim2.new(parts[1], parts[2], parts[3], parts[4])
            end
        end
    end)

    tpBatButton.MouseEnter:Connect(function()
        if not isLocked() then
            tpBatButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        end
    end)

    tpBatButton.MouseLeave:Connect(function()
        if not tpBatActive then
            tpBatButton.BackgroundColor3 = Q_OFF
        end
    end)

    if _G.tpBatModeActive then
        task.wait(0.2)
        startTpBat()
    end
end)

task.spawn(function()
    task.wait(0.5)

    local FLOAT_SIZE = 64
    local resetButton = Instance.new("TextButton")
    resetButton.Name = "InstaResetButton"
    resetButton.Parent = gui
    resetButton.Size = UDim2.new(0, FLOAT_SIZE, 0, FLOAT_SIZE)
    resetButton.Position = UDim2.new(0, 10, 0.75, 0)
    resetButton.Text = "RESET"
    resetButton.TextColor3 = Q_TEXT
    resetButton.BackgroundColor3 = Q_OFF
    resetButton.BackgroundTransparency = 0
    resetButton.Font = Enum.Font.GothamBold
    resetButton.TextSize = 10
    resetButton.TextWrapped = true
    resetButton.AutoButtonColor = false
    resetButton.ZIndex = 300

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, QR)
    uiCorner.Parent = resetButton

    local dragging = false
    local dragStartPos = nil
    local dragStartMousePos = nil
    local clickStartTime = nil
    local activeTouch = nil
    local dragThreshold = 10

    local function isLocked()
        return State.mobileLocked == true
    end

    resetButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if activeTouch and activeTouch ~= input then return end
            activeTouch = input
            clickStartTime = tick()
            dragStartPos = resetButton.Position
            dragStartMousePos = input.Position
            dragging = false
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input == activeTouch then
            if not dragging and clickStartTime and (tick() - clickStartTime) < 0.3 then
                cursedInstaReset()
                TweenService:Create(resetButton, TweenInfo.new(0.1), {BackgroundColor3 = Q_ON}):Play()
                TweenService:Create(resetButton, TweenInfo.new(0.1), {TextColor3 = C_WHITE}):Play()
                task.wait(0.1)
                TweenService:Create(resetButton, TweenInfo.new(0.1), {BackgroundColor3 = Q_OFF}):Play()
                TweenService:Create(resetButton, TweenInfo.new(0.1), {TextColor3 = Q_TEXT}):Play()
            end
            dragging = false
            activeTouch = nil
            clickStartTime = nil
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if isLocked() then return end
        if activeTouch and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if input == activeTouch then
                local delta = input.Position - dragStartMousePos
                local distanceMoved = math.sqrt(delta.X^2 + delta.Y^2)

                if not dragging and distanceMoved > dragThreshold then
                    dragging = true
                end

                if dragging then
                    local newPosition = UDim2.new(
                        dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
                        dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
                    )
                    resetButton.Position = newPosition
                end
            end
        end
    end)

    local lastSave = 0
    resetButton:GetPropertyChangedSignal("Position"):Connect(function()
        if tick() - lastSave > 0.5 then
            lastSave = tick()
            pcall(function()
                writefile("KzsHubResetPos.txt", string.format("%.3f,%.1f,%.3f,%.1f",
                    resetButton.Position.X.Scale, resetButton.Position.X.Offset,
                    resetButton.Position.Y.Scale, resetButton.Position.Y.Offset))
            end)
        end
    end)

    pcall(function()
        local data = readfile("KzsHubResetPos.txt")
        if data and data ~= "" then
            local parts = {}
            for v in string.gmatch(data, "[^,]+") do
                table.insert(parts, tonumber(v))
            end
            if #parts >= 4 then
                resetButton.Position = UDim2.new(parts[1], parts[2], parts[3], parts[4])
            end
        end
    end)

    resetButton.MouseEnter:Connect(function()
        if not isLocked() then
            resetButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
        end
    end)

    resetButton.MouseLeave:Connect(function()
        resetButton.BackgroundColor3 = Q_OFF
    end)
end)

end)();

local _billboardChunk = (function()

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.T then
        cursedInstaReset()
    end
end)

if _G.RagdollTimer_Running then return end
_G.RagdollTimer_Running = true

function setupBillboard(char)
    local head = char:FindFirstChild("Head")
    if not head then return nil end

    local bb = head:FindFirstChild("GreenDuelsBB")
    if not bb then
        bb = Instance.new("BillboardGui")
        bb.Name = "GreenDuelsBB"
        bb.Size = UDim2.new(0, 60, 0, 30)
        bb.StudsOffset = Vector3.new(0, 3.0, 0)
        bb.AlwaysOnTop = true
        bb.Parent = head
    end

    local timerLbl = bb:FindFirstChild("RagdollTimerLbl")
    if not timerLbl then
        timerLbl = Instance.new("TextLabel")
        timerLbl.Name = "RagdollTimerLbl"
        timerLbl.Size = UDim2.new(1, 0, 1, 0)
        timerLbl.Position = UDim2.new(0, 0, 0, 0)
        timerLbl.BackgroundTransparency = 1
        timerLbl.Text = ""
        timerLbl.TextColor3 = Color3.fromRGB(255, 50, 50)
        timerLbl.Font = Enum.Font.GothamBlack
        timerLbl.TextScaled = true
        timerLbl.TextStrokeTransparency = 0.1
        timerLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        timerLbl.Parent = bb
    end

    return timerLbl
end

local _rtTimerActive = false
local timerLblRef = nil

function startRagTimerGui()
    if _rtTimerActive then return end
    _rtTimerActive = true

    local char = LP.Character
    if not char then _rtTimerActive = false return end

    local lbl = setupBillboard(char)
    if not lbl then _rtTimerActive = false return end
    timerLblRef = lbl

    task.spawn(function()
        local t = 2.0
        while t >= 0.0 do
            if not timerLblRef or not timerLblRef.Parent then
                _rtTimerActive = false
                return
            end
            timerLblRef.Text = string.format("%.1f", t)
            timerLblRef.TextColor3 = Color3.fromRGB(255, 50, 50)
            task.wait(0.1)
            t = math.round((t - 0.1) * 10) / 10
        end

        if timerLblRef and timerLblRef.Parent then
            timerLblRef.Text = "STEAL!"
            timerLblRef.TextColor3 = Color3.fromRGB(255, 50, 50)
        end

        repeat
            task.wait(0.1)
            local c = LP.Character
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            if not hum then break end
            local st = hum:GetState()
            if st ~= Enum.HumanoidStateType.Physics and
               st ~= Enum.HumanoidStateType.Ragdoll and
               st ~= Enum.HumanoidStateType.FallingDown then
                break
            end
        until false

        if timerLblRef and timerLblRef.Parent then
            timerLblRef.Text = ""
        end
        _rtTimerActive = false
    end)
end

RunService.Heartbeat:Connect(function()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local st = hum:GetState()
    if st == Enum.HumanoidStateType.Physics or
       st == Enum.HumanoidStateType.Ragdoll or
       st == Enum.HumanoidStateType.FallingDown then
        startRagTimerGui()
    end
end)

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    setupBillboard(char)
end)

if LP.Character then
    task.wait(0.5)
    setupBillboard(LP.Character)
end
end)()