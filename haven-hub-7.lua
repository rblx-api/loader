-- official phantom semi tp source 
-- revamped by @atlanta.rar
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local AnimalsData = {}
do
    local success, result = pcall(function()
        return require(ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Animals"))
    end)
    if success then AnimalsData = result end
end
local allAnimalsCache = {}
local PromptMemoryCache = {}
local InternalStealCache = {}
local semiInstantActive = false
local giantPotionEnabled = false
local currentKeybind = Enum.KeyCode.F
local listeningForKey = false
local keybindJustSet = false
local speedBoostEnabled = false
local speedBoostConn = nil
local BOOST_SPEED = 28
local espEnabled = false
local espConnections = {}
local allowEspEnabled = false
local allowEspConnections = {}
local baseLockEspEnabled = false
local baseLockEspInstances = {}
local baseLockEspConn = nil
local antiSentryEnabled = false
local antiSentryConn = nil
local antiSentryTarget = nil
local SENTRY_DETECTION_DISTANCE = 60
local SENTRY_PULL_DISTANCE = -5
local xrayEnabled = false
local xrayOriginalTrans = {}
local xrayDescAddedConn = nil
local autoKickEnabled = false
local autoKickConnections = {}
local CONFIG_FILE = "PhantomSemiTP_Config.json"
local savedConfig = {}
local function loadConfig()
    pcall(function()
        if isfile(CONFIG_FILE) then
            local raw = readfile(CONFIG_FILE)
            savedConfig = HttpService:JSONDecode(raw)
        end
    end)
end
loadConfig()
local function isMyBase(plotName)
    local plot = workspace.Plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yourBase = sign:FindFirstChild("YourBase")
        if yourBase and yourBase:IsA("BillboardGui") then return yourBase.Enabled == true end
    end
    return false
end
local function enableSpeedBoost()
    if speedBoostConn then speedBoostConn:Disconnect() end
    speedBoostConn = RunService.Heartbeat:Connect(function()
        if not LocalPlayer.Character then return end
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            local flatDir = Vector3.new(moveDir.X, 0, moveDir.Z).Unit
            hrp.Velocity = Vector3.new(
                flatDir.X * BOOST_SPEED,
                hrp.Velocity.Y,
                flatDir.Z * BOOST_SPEED
            )
        end
    end)
end
local function disableSpeedBoost()
    if speedBoostConn then
        speedBoostConn:Disconnect()
        speedBoostConn = nil
    end
end
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.3)
    if speedBoostEnabled then enableSpeedBoost() end
end)
local function createESP(plr)
    if plr == LocalPlayer then return end
    if not plr.Character then return end
    local char = plr.Character
    if char:FindFirstChild("PhantomSemiTP_ESP_Hitbox") then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not (hrp and head) then return end
    local hitbox = Instance.new("BoxHandleAdornment")
    hitbox.Name = "PhantomSemiTP_ESP_Hitbox"
    hitbox.Adornee = hrp
    hitbox.Size = Vector3.new(4, 6, 2)
    hitbox.Color3 = Color3.fromRGB(128, 0, 128)
    hitbox.Transparency = 0.6
    hitbox.ZIndex = 10
    hitbox.AlwaysOnTop = true
    hitbox.Parent = char
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PhantomSemiTP_ESP_Name"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = char
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = plr.DisplayName or plr.Name
    label.TextColor3 = Color3.fromRGB(255, 0, 255)
    label.Font = Enum.Font.Arcade
    label.TextScaled = true
    label.TextStrokeTransparency = 0.7
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Parent = billboard
end
local function removeESP(plr)
    if not plr.Character then return end
    local hitbox = plr.Character:FindFirstChild("PhantomSemiTP_ESP_Hitbox")
    local nameGui = plr.Character:FindFirstChild("PhantomSemiTP_ESP_Name")
    if hitbox then hitbox:Destroy() end
    if nameGui then nameGui:Destroy() end
end
local function enableESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if plr.Character then createESP(plr) end
            local conn = plr.CharacterAdded:Connect(function()
                task.wait(0.1)
                if espEnabled then createESP(plr) end
            end)
            table.insert(espConnections, conn)
        end
    end
    local playerAddedConn = Players.PlayerAdded:Connect(function(plr)
        if plr == LocalPlayer then return end
        local charAddedConn = plr.CharacterAdded:Connect(function()
            task.wait(0.1)
            if espEnabled then createESP(plr) end
        end)
        table.insert(espConnections, charAddedConn)
    end)
    table.insert(espConnections, playerAddedConn)
end
local function disableESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        removeESP(plr)
    end
    for _, conn in ipairs(espConnections) do
        if conn and conn.Connected then conn:Disconnect() end
    end
    espConnections = {}
end
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.1)
    if espEnabled then enableESP() end
end)
local COLOR_ALLOWED = Color3.fromRGB(0, 255, 100)
local COLOR_DISALLOWED = Color3.fromRGB(255, 50, 50)
local function updateAllowPrompt(prompt)
    local parent = prompt.Parent
    if not parent or not parent:IsA("BasePart") then return end
    local objT = string.lower(prompt.ObjectText or "")
    local actT = string.lower(prompt.ActionText or "")
    local combined = objT .. " " .. actT
    if not string.find(combined, "friend") then
        if parent:FindFirstChild("FriendInd") then parent.FriendInd:Destroy() end
        return
    end
    local bb = parent:FindFirstChild("FriendInd")
    if not bb then
        bb = Instance.new("BillboardGui")
        bb.Name = "FriendInd"
        bb.Size = UDim2.new(0, 160, 0, 45)
        bb.AlwaysOnTop = true
        bb.ExtentsOffset = Vector3.new(0, 3, 0)
        bb.Parent = parent
        local lbl = Instance.new("TextLabel")
        lbl.Name = "StatusLabel"
        lbl.Parent = bb
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.LuckiestGuy
        lbl.TextSize = 22
        lbl.TextStrokeTransparency = 0.4
        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    end
    local lbl = bb:FindFirstChild("StatusLabel")
    local isCurrentlyAllowed = string.find(combined, "disallow")
    if isCurrentlyAllowed then
        lbl.Text = "✅ ALLOWED"
        lbl.TextColor3 = COLOR_ALLOWED
    else
        lbl.Text = "❌ DISALLOWED"
        lbl.TextColor3 = COLOR_DISALLOWED
    end
end
local function setupAllowPrompt(p)
    updateAllowPrompt(p)
    local c1 = p:GetPropertyChangedSignal("ObjectText"):Connect(function() updateAllowPrompt(p) end)
    local c2 = p:GetPropertyChangedSignal("ActionText"):Connect(function() updateAllowPrompt(p) end)
    table.insert(allowEspConnections, c1)
    table.insert(allowEspConnections, c2)
end
local function enableAllowESP()
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("ProximityPrompt") then setupAllowPrompt(o) end
    end
    local descConn = workspace.DescendantAdded:Connect(function(o)
        if o:IsA("ProximityPrompt") then
            task.wait(0.2)
            if allowEspEnabled then setupAllowPrompt(o) end
        end
    end)
    table.insert(allowEspConnections, descConn)
end
local function disableAllowESP()
    for _, conn in ipairs(allowEspConnections) do
        if conn and conn.Connected then conn:Disconnect() end
    end
    allowEspConnections = {}
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") then
            local ind = o:FindFirstChild("FriendInd")
            if ind then ind:Destroy() end
        end
    end
end
local function createBaseLockESP(plot, mainPart)
    if baseLockEspInstances[plot.Name] then
        baseLockEspInstances[plot.Name]:Destroy()
    end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PhantomSemiTP_BaseLock_" .. plot.Name
    billboard.Size = UDim2.new(0, 50, 0, 25)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = mainPart
    billboard.MaxDistance = 1000
    billboard.Parent = plot
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.Arcade
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Parent = billboard
    baseLockEspInstances[plot.Name] = billboard
    return billboard
end
local function updateBaseLockESP()
    local plotsFolder = workspace:FindFirstChild("Plots")
    if not plotsFolder then return end
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        local purchases = plot:FindFirstChild("Purchases")
        local plotBlock = purchases and purchases:FindFirstChild("PlotBlock")
        local mainPart = plotBlock and plotBlock:FindFirstChild("Main")
        local billboard = baseLockEspInstances[plot.Name]
        local timeLabel = mainPart
            and mainPart:FindFirstChild("BillboardGui")
            and mainPart.BillboardGui:FindFirstChild("RemainingTime")
        if timeLabel and mainPart then
            billboard = billboard or createBaseLockESP(plot, mainPart)
            local label = billboard:FindFirstChildWhichIsA("TextLabel")
            if label then label.Text = timeLabel.Text end
        elseif billboard then
            billboard:Destroy()
            baseLockEspInstances[plot.Name] = nil
        end
    end
end
local function enableBaseLockESP()
    if baseLockEspConn then baseLockEspConn:Disconnect() end
    baseLockEspConn = RunService.RenderStepped:Connect(updateBaseLockESP)
end
local function disableBaseLockESP()
    if baseLockEspConn then
        baseLockEspConn:Disconnect()
        baseLockEspConn = nil
    end
    for name, billboard in pairs(baseLockEspInstances) do
        if billboard and billboard.Parent then billboard:Destroy() end
    end
    baseLockEspInstances = {}
end
local function findSentryTarget()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local rootPos = char.HumanoidRootPart.Position
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name:find("Sentry") and not obj.Name:lower():find("bullet") then
            local ownerId = obj.Name:match("Sentry_(%d+)")
            if ownerId and tonumber(ownerId) == LocalPlayer.UserId then
                continue
            end
            local part = obj:IsA("BasePart") and obj
                or obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"))
            if part and (rootPos - part.Position).Magnitude <= SENTRY_DETECTION_DISTANCE then
                return obj
            end
        end
    end
    return nil
end
local function moveSentryTarget(obj)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    for _, part in pairs(obj:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    local root = char.HumanoidRootPart
    local cf = root.CFrame * CFrame.new(0, 0, SENTRY_PULL_DISTANCE)
    if obj:IsA("BasePart") then
        obj.CFrame = cf
    elseif obj:IsA("Model") then
        local main = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
        if main then main.CFrame = cf end
    end
end
local function attackSentry()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local weapon = LocalPlayer.Backpack:FindFirstChild("Bat") or char:FindFirstChild("Bat")
    if not weapon then return end
    if weapon.Parent == LocalPlayer.Backpack then
        hum:EquipTool(weapon)
        task.wait(0.1)
    end
    local handle = weapon:FindFirstChild("Handle")
    if handle then handle.CanCollide = false end
    pcall(function() weapon:Activate() end)
    for _, r in pairs(weapon:GetDescendants()) do
        if r:IsA("RemoteEvent") then pcall(function() r:FireServer() end) end
    end
end
local function enableAntiSentry()
    if antiSentryConn then antiSentryConn:Disconnect() end
    antiSentryTarget = nil
    antiSentryConn = RunService.Heartbeat:Connect(function()
        if not antiSentryEnabled then return end
        if antiSentryTarget and antiSentryTarget.Parent == workspace then
            moveSentryTarget(antiSentryTarget)
            attackSentry()
        else
            antiSentryTarget = findSentryTarget()
        end
    end)
end
local function disableAntiSentry()
    if antiSentryConn then
        antiSentryConn:Disconnect()
        antiSentryConn = nil
    end
    antiSentryTarget = nil
end
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if antiSentryEnabled then enableAntiSentry() end
end)
local function applyXrayToObj(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
        obj:Destroy()
    elseif obj:IsA("BasePart") then
        obj.Material = Enum.Material.Plastic
        if obj.Anchored and (obj.Name:lower():find("base") or (obj.Parent and obj.Parent.Name:lower():find("base"))) then
            if not xrayOriginalTrans[obj] then
                xrayOriginalTrans[obj] = obj.LocalTransparencyModifier
            end
            obj.LocalTransparencyModifier = 0.5
        end
    end
end
local function enableXRay()
    xrayEnabled = true
    for _, obj in ipairs(workspace:GetDescendants()) do
        applyXrayToObj(obj)
    end
    if xrayDescAddedConn then xrayDescAddedConn:Disconnect() end
    xrayDescAddedConn = workspace.DescendantAdded:Connect(function(obj)
        if xrayEnabled then applyXrayToObj(obj) end
    end)
end
local function disableXRay()
    xrayEnabled = false
    if xrayDescAddedConn then
        xrayDescAddedConn:Disconnect()
        xrayDescAddedConn = nil
    end
    for part, value in pairs(xrayOriginalTrans) do
        if part and part.Parent then
            pcall(function() part.LocalTransparencyModifier = value end)
        end
    end
    xrayOriginalTrans = {}
end
local AUTO_KICK_KEYWORD = "you stole"
local AUTO_KICK_MESSAGE = "You stole brainrot!"
local function hasStealKeyword(text)
    if typeof(text) ~= "string" then return false end
    return string.find(string.lower(text), AUTO_KICK_KEYWORD) ~= nil
end
local function kickPlayerAfterSteal()
    pcall(function() LocalPlayer:Kick(AUTO_KICK_MESSAGE) end)
end
local function watchTextObject(obj)
    if not autoKickEnabled then return end
    if hasStealKeyword(obj.Text) then
        kickPlayerAfterSteal()
        return
    end
    local conn = obj:GetPropertyChangedSignal("Text"):Connect(function()
        if autoKickEnabled and hasStealKeyword(obj.Text) then
            kickPlayerAfterSteal()
        end
    end)
    table.insert(autoKickConnections, conn)
end
local function setupAutoKickGuiWatcher(gui)
    local descConn = gui.DescendantAdded:Connect(function(desc)
        if not autoKickEnabled then return end
        if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
            watchTextObject(desc)
        end
    end)
    table.insert(autoKickConnections, descConn)
end
local function enableAutoKick()
    for _, obj in ipairs(PlayerGui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            watchTextObject(obj)
        end
    end
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        setupAutoKickGuiWatcher(gui)
    end
    local childConn = PlayerGui.ChildAdded:Connect(function(gui)
        if not autoKickEnabled then return end
        setupAutoKickGuiWatcher(gui)
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                watchTextObject(obj)
            end
        end
    end)
    table.insert(autoKickConnections, childConn)
end
local function disableAutoKick()
    for _, conn in ipairs(autoKickConnections) do
        if conn and conn.Connected then conn:Disconnect() end
    end
    autoKickConnections = {}
end
local BASE_LEFT_SIGN_POS  = Vector3.new(-342.43927001953125, 10.464665412902832, 6.106575012207031)
local BASE_RIGHT_SIGN_POS = Vector3.new(-342.43939208984375, 10.398869514465332, 113.10681915283203)
local BASE_DETECT_DIST = 20
local LEFT_FIRST_TP  = Vector3.new(-358.2, -7.1, 7.3)
local LEFT_SECOND_TP = Vector3.new(-359.2, -7.1, 113.9)
local LEFT_THIRD_TP  = Vector3.new(-335.8, -5.2, 101.0)
local LEFT_LAST_TP   = Vector3.new(-352.6, -7.1, 75.4)
local RIGHT_FIRST_TP  = Vector3.new(-347.99346923828125, 0.6147812008857727, 113.73497009277344)
local RIGHT_SECOND_TP = Vector3.new(-347.1276550292969, 0.4199885427951813, 6.275444507598877)
local RIGHT_THIRD_TP  = Vector3.new(-336.80865478515625, -5.101069927215576, 17.750465393066406)
local RIGHT_LAST_TP   = Vector3.new(-355.8482666015625, -7.000002384185791, 42.20612716674805)
local currentBaseSide = "?"
local function getMyPlot()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and isMyBase(plot.Name) then return plot end
    end
    return nil
end
local function detectBaseSide()
    local myPlot = getMyPlot()
    if not myPlot then currentBaseSide = "?"; return end
    local sign = myPlot:FindFirstChild("PlotSign")
    if not sign then currentBaseSide = "?"; return end
    local signPos = sign.Position
    local dL = (signPos - BASE_LEFT_SIGN_POS).Magnitude
    local dR = (signPos - BASE_RIGHT_SIGN_POS).Magnitude
    if dL <= BASE_DETECT_DIST then currentBaseSide = "Left"
    elseif dR <= BASE_DETECT_DIST then currentBaseSide = "Right"
    else currentBaseSide = "?" end
end
task.spawn(function() while true do task.wait(2); pcall(detectBaseSide) end end)
local function scanSinglePlot(plot)
    if not plot or not plot:IsA("Model") then return end
    if isMyBase(plot.Name) then return end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return end
    for _, podium in ipairs(podiums:GetChildren()) do
        if podium:IsA("Model") and podium:FindFirstChild("Base") then
            local animalName = "Unknown"
            local spawn = podium.Base:FindFirstChild("Spawn")
            if spawn then
                for _, child in ipairs(spawn:GetChildren()) do
                    if child:IsA("Model") and child.Name ~= "PromptAttachment" then
                        animalName = child.Name
                        local info = AnimalsData[animalName]
                        if info and info.DisplayName then animalName = info.DisplayName end
                        break
                    end
                end
            end
            local uid = plot.Name .. "_" .. podium.Name
            for i = #allAnimalsCache, 1, -1 do
                if allAnimalsCache[i].uid == uid then table.remove(allAnimalsCache, i) end
            end
            table.insert(allAnimalsCache, {
                name = animalName, plot = plot.Name, slot = podium.Name,
                worldPosition = podium:GetPivot().Position, uid = uid,
            })
        end
    end
end
local function initializeScanner()
    task.wait(2)
    local plots = workspace:WaitForChild("Plots", 10)
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then scanSinglePlot(plot) end
    end
    plots.ChildAdded:Connect(function(plot) if plot:IsA("Model") then task.wait(0.5); scanSinglePlot(plot) end end)
    plots.ChildRemoved:Connect(function(plot)
        for i = #allAnimalsCache, 1, -1 do
            if allAnimalsCache[i].plot == plot.Name then table.remove(allAnimalsCache, i) end
        end
    end)
    local function watchPlot(plot)
        if not plot or not plot:IsA("Model") then return end
        local podiums = plot:WaitForChild("AnimalPodiums", 5)
        if not podiums then return end
        podiums.ChildAdded:Connect(function() task.wait(0.3); scanSinglePlot(plot) end)
        podiums.ChildRemoved:Connect(function(podium)
            local uid = plot.Name .. "_" .. podium.Name
            for i = #allAnimalsCache, 1, -1 do
                if allAnimalsCache[i].uid == uid then table.remove(allAnimalsCache, i); PromptMemoryCache[uid] = nil end
            end
        end)
        for _, podium in ipairs(podiums:GetChildren()) do
            if podium:IsA("Model") and podium:FindFirstChild("Base") then
                local spawnFolder = podium.Base:FindFirstChild("Spawn")
                if spawnFolder then
                    spawnFolder.ChildAdded:Connect(function() task.wait(0.1); scanSinglePlot(plot) end)
                    spawnFolder.ChildRemoved:Connect(function() task.wait(0.1); scanSinglePlot(plot) end)
                end
            end
        end
    end
    for _, plot in ipairs(plots:GetChildren()) do task.spawn(watchPlot, plot) end
    plots.ChildAdded:Connect(function(plot) task.spawn(watchPlot, plot) end)
end
local function findProximityPromptForAnimal(animalData)
    if not animalData then return nil end
    local cached = PromptMemoryCache[animalData.uid]
    if cached and cached.Parent then return cached end
    local plot = workspace.Plots:FindFirstChild(animalData.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    local base = podium:FindFirstChild("Base")
    if not base then return nil end
    local spn = base:FindFirstChild("Spawn")
    if not spn then return nil end
    local attach = spn:FindFirstChild("PromptAttachment")
    if not attach then return nil end
    for _, p in ipairs(attach:GetChildren()) do
        if p:IsA("ProximityPrompt") then PromptMemoryCache[animalData.uid] = p; return p end
    end
    return nil
end
local function buildStealCallbacks(prompt)
    if InternalStealCache[prompt] then return end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    local ok1, c1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(c1) == "table" then
        for _, c in ipairs(c1) do if type(c.Function) == "function" then table.insert(data.holdCallbacks, c.Function) end end
    end
    local ok2, c2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(c2) == "table" then
        for _, c in ipairs(c2) do if type(c.Function) == "function" then table.insert(data.triggerCallbacks, c.Function) end end
    end
    if (#data.holdCallbacks > 0) or (#data.triggerCallbacks > 0) then InternalStealCache[prompt] = data end
end
local function getNearestAnimalFromPos(pos)
    local nearest, minDist = nil, math.huge
    for _, ad in ipairs(allAnimalsCache) do
        if not isMyBase(ad.plot) and ad.worldPosition then
            local d = (pos - ad.worldPosition).Magnitude
            if d < minDist then minDist = d; nearest = ad end
        end
    end
    return nearest
end
local function isOwnPlot(obj)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    for _, plot in ipairs(plots:GetChildren()) do
        local isOwned = false
        if plot.Name == LocalPlayer.Name then
            isOwned = true
        else
            local ownerVal = plot:FindFirstChild("Owner")
            if ownerVal and ownerVal.Value == LocalPlayer.Name then
                isOwned = true
            end
        end
        if isOwned and obj:IsDescendantOf(plot) then
            return true
        end
    end
    return false
end
local function isNearOtherPlayer(part, yLevel, Y_THRESHOLD)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local yDiff = math.abs(hrp.Position.Y - yLevel)
                local dist = (hrp.Position - part.Position).Magnitude
                if yDiff <= Y_THRESHOLD and dist <= 60 then
                    return true
                end
            end
        end
    end
    return false
end
local function triggerUnlockFloor1()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local yLevel = -2
    local maxY = 19
    local Y_THRESHOLD = 5
    local bestPromptSameLevel = nil
    local shortestDistSameLevel = math.huge
    local bestPromptFallback = nil
    local shortestDistFallback = math.huge
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    for _, obj in ipairs(plots:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Enabled then
            if not isOwnPlot(obj) then
                local part = obj.Parent
                if part and part:IsA("BasePart") then
                    if part.Position.Y <= maxY then
                        local distance = (hrp.Position - part.Position).Magnitude
                        local yDifference = math.abs(yLevel - part.Position.Y)
                        local nearOther = isNearOtherPlayer(part, yLevel, Y_THRESHOLD)
                        if yDifference <= Y_THRESHOLD then
                            if nearOther then
                                if distance < shortestDistSameLevel then
                                    shortestDistSameLevel = distance
                                    bestPromptSameLevel = obj
                                end
                            elseif bestPromptSameLevel == nil and distance < shortestDistFallback then
                                shortestDistFallback = distance
                                bestPromptFallback = obj
                            end
                        end
                    end
                end
            end
        end
    end
    local targetPrompt = bestPromptSameLevel or bestPromptFallback
    if targetPrompt then
        local originalDist = targetPrompt.MaxActivationDistance
        targetPrompt.MaxActivationDistance = 9999
        if fireproximityprompt then
            fireproximityprompt(targetPrompt)
        else
            targetPrompt:InputBegan(Enum.UserInputType.MouseButton1)
            task.wait(0.05)
            targetPrompt:InputEnded(Enum.UserInputType.MouseButton1)
        end
        task.delay(0.2, function()
            targetPrompt.MaxActivationDistance = originalDist
        end)
    end
end
if PlayerGui:FindFirstChild("PhantomSemiTP_Halfway") then
    PlayerGui:FindFirstChild("PhantomSemiTP_Halfway"):Destroy()
end
local function makeDraggable(topbar, frame)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end
local obj1 = Instance.new("ScreenGui")
obj1.Name = "PhantomSemiTP_Halfway"
obj1.Enabled = true
obj1.ResetOnSpawn = false
obj1.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
obj1.DisplayOrder = 0
obj1.IgnoreGuiInset = false
obj1.Parent = PlayerGui
local obj2 = Instance.new("Frame")
obj2.Name = "MainFrame"
obj2.Visible = true
obj2.Position = UDim2.new(0.85, -135, 0.5, -200)
obj2.Size = UDim2.new(0, 270, 0, 400)
obj2.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
obj2.BackgroundTransparency = 0
obj2.BorderSizePixel = 0
obj2.ClipsDescendants = true
obj2.Parent = obj1
local obj3 = Instance.new("UICorner")
obj3.CornerRadius = UDim.new(0, 10)
obj3.Parent = obj2
local obj4 = Instance.new("UIStroke")
obj4.Color = Color3.fromRGB(255, 255, 255)
obj4.Thickness = 1.5
obj4.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
obj4.LineJoinMode = Enum.LineJoinMode.Round
obj4.Parent = obj2
local obj5 = Instance.new("UIGradient")
obj5.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
obj5.Rotation = 858
obj5.Parent = obj4
local obj6 = Instance.new("Frame")
obj6.Name = "TitleBar"
obj6.Position = UDim2.new(0, 10, 0, 5)
obj6.Size = UDim2.new(1, -20, 0, 40)
obj6.BackgroundTransparency = 1
obj6.BorderSizePixel = 0
obj6.Parent = obj2
makeDraggable(obj6, obj2)
local obj7 = Instance.new("TextLabel")
obj7.Text = "👻 Phantom Semi TP"
obj7.TextColor3 = Color3.fromRGB(255, 255, 255)
obj7.TextSize = 18
obj7.Font = Enum.Font.GothamBold
obj7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
obj7.TextXAlignment = Enum.TextXAlignment.Left
obj7.TextYAlignment = Enum.TextYAlignment.Center
obj7.Position = UDim2.new(0, 0, 0, 0)
obj7.Size = UDim2.new(0.5, 0, 1, 0)
obj7.BackgroundTransparency = 1
obj7.BorderSizePixel = 0
obj7.Parent = obj6
local obj8 = Instance.new("TextButton")
obj8.Text = "−"
obj8.TextColor3 = Color3.fromRGB(255, 255, 255)
obj8.TextSize = 20
obj8.Font = Enum.Font.GothamBold
obj8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
obj8.Position = UDim2.new(1, -35, 0, 5)
obj8.Size = UDim2.new(0, 30, 0, 30)
obj8.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
obj8.BorderSizePixel = 0
obj8.AutoButtonColor = true
obj8.Parent = obj6
local obj9 = Instance.new("UICorner")
obj9.CornerRadius = UDim.new(0, 8)
obj9.Parent = obj8
local obj86 = Instance.new("Frame")
obj86.Name = "TabBar"
obj86.Position = UDim2.new(0, 20, 0, 45)
obj86.Size = UDim2.new(1, -40, 0, 45)
obj86.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
obj86.BorderSizePixel = 0
obj86.Parent = obj2
local obj87 = Instance.new("UICorner")
obj87.CornerRadius = UDim.new(0, 20)
obj87.Parent = obj86
local obj88 = Instance.new("TextButton")
obj88.Text = "STEAL"
obj88.TextColor3 = Color3.fromRGB(255, 255, 255)
obj88.TextSize = 15
obj88.Font = Enum.Font.GothamBold
obj88.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
obj88.Position = UDim2.new(0, 0, 0, 0)
obj88.Size = UDim2.new(0.5, -5, 0, 45)
obj88.BackgroundTransparency = 1
obj88.BorderSizePixel = 0
obj88.AutoButtonColor = true
obj88.Parent = obj86
local obj89 = Instance.new("Frame")
obj89.Name = "Underline"
obj89.Position = UDim2.new(0.1, 0, 1, -2)
obj89.Size = UDim2.new(0.8, 0, 0, 2)
obj89.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
obj89.BorderSizePixel = 0
obj89.Visible = true
obj89.Parent = obj88
local obj90 = Instance.new("TextButton")
obj90.Text = "MISC"
obj90.TextColor3 = Color3.fromRGB(160, 160, 160)
obj90.TextSize = 15
obj90.Font = Enum.Font.GothamBold
obj90.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
obj90.Position = UDim2.new(0.5, 5, 0, 0)
obj90.Size = UDim2.new(0.5, -5, 0, 45)
obj90.BackgroundTransparency = 1
obj90.BorderSizePixel = 0
obj90.AutoButtonColor = true
obj90.Parent = obj86
local obj91 = Instance.new("Frame")
obj91.Name = "Underline"
obj91.Position = UDim2.new(0.1, 0, 1, -2)
obj91.Size = UDim2.new(0.8, 0, 0, 2)
obj91.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
obj91.BorderSizePixel = 0
obj91.Visible = false
obj91.Parent = obj90
local obj10 = Instance.new("Frame")
obj10.Name = "ContentArea"
obj10.Position = UDim2.new(0, 10, 0, 95)
obj10.Size = UDim2.new(1, -20, 1, -100)
obj10.BackgroundTransparency = 1
obj10.BorderSizePixel = 0
obj10.ClipsDescendants = true
obj10.Parent = obj2
local function createToggleRow(parent, yPos, title, description, defaultOn, callback)
    local row = Instance.new("Frame")
    row.Position = UDim2.new(0, 5, 0, yPos)
    row.Size = UDim2.new(1, -10, 0, 52)
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.Parent = parent
    local lbl = Instance.new("TextLabel")
    lbl.Text = title
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamBold
    lbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Position = UDim2.new(0, 0, 0, 8)
    lbl.Size = UDim2.new(0.65, 0, 0, 17)
    lbl.BackgroundTransparency = 1
    lbl.Parent = row
    local desc = Instance.new("TextLabel")
    desc.Text = description
    desc.TextColor3 = Color3.fromRGB(130, 130, 130)
    desc.TextSize = 10
    desc.Font = Enum.Font.Gotham
    desc.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Position = UDim2.new(0, 0, 0, 28)
    desc.Size = UDim2.new(0.65, 0, 0, 12)
    desc.BackgroundTransparency = 1
    desc.Parent = row
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Position = UDim2.new(1, -48, 0, 13)
    toggleBtn.Size = UDim2.new(0, 48, 0, 26)
    toggleBtn.BackgroundColor3 = defaultOn and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(35, 35, 35)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = row
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBtn
    local circle = Instance.new("Frame")
    circle.Position = defaultOn and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.BackgroundColor3 = defaultOn and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
    circle.BorderSizePixel = 0
    circle.Parent = toggleBtn
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle
    local isOn = defaultOn or false
    toggleBtn.MouseButton1Click:Connect(function()
        isOn = not isOn
        local goalTrack = isOn and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(35, 35, 35)
        local goalPos = isOn and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        local goalColor = isOn and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = goalTrack}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = goalPos, BackgroundColor3 = goalColor}):Play()
        if callback then callback(isOn) end
    end)
    if defaultOn and callback then
        task.defer(function() callback(true) end)
    end
    return row, toggleBtn, isOn
end
local function createKeybindRow(parent, yPos, title, defaultKey)
    local row = Instance.new("Frame")
    row.Position = UDim2.new(0, 5, 0, yPos)
    row.Size = UDim2.new(1, -10, 0, 46)
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.Parent = parent
    local lbl = Instance.new("TextLabel")
    lbl.Text = title
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextSize = 13
    lbl.Font = Enum.Font.GothamBold
    lbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Parent = row
    local keyBtn = Instance.new("TextButton")
    keyBtn.Text = ""
    keyBtn.AutoButtonColor = false
    keyBtn.Position = UDim2.new(1, -60, 0.5, -16)
    keyBtn.Size = UDim2.new(0, 60, 0, 32)
    keyBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    keyBtn.BorderSizePixel = 0
    keyBtn.Parent = row
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 13)
    keyCorner.Parent = keyBtn
    local keyStroke = Instance.new("UIStroke")
    keyStroke.Color = Color3.fromRGB(45, 45, 45)
    keyStroke.Thickness = 1
    keyStroke.Parent = keyBtn
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Text = defaultKey
    keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyLabel.TextSize = 13
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    keyLabel.Size = UDim2.new(1, 0, 1, 0)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Parent = keyBtn
    keyBtn.MouseButton1Click:Connect(function()
        if listeningForKey then return end
        listeningForKey = true
        keyLabel.Text = "..."
        TweenService:Create(keyStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(255, 255, 255)}):Play()
        local conn
        conn = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKeybind = input.KeyCode
                keyLabel.Text = input.KeyCode.Name
                TweenService:Create(keyStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(45, 45, 45)}):Play()
                listeningForKey = false
                keybindJustSet = true
                task.defer(function() keybindJustSet = false end)
                conn:Disconnect()
            end
        end)
    end)
    return row
end
local function createActionButton(parent, yPos, text)
    local btn = Instance.new("TextButton")
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.Size = UDim2.new(1, -10, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.BorderSizePixel = 0
    btn.Parent = parent
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 19)
    btnCorner.Parent = btn
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(40, 40, 40)
    btnStroke.Thickness = 1
    btnStroke.Parent = btn
    local btnLabel = Instance.new("TextLabel")
    btnLabel.Text = text
    btnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnLabel.TextSize = 14
    btnLabel.Font = Enum.Font.GothamBold
    btnLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    btnLabel.Size = UDim2.new(1, 0, 1, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Parent = btn
    return btn
end
local obj11 = Instance.new("ScrollingFrame")
obj11.Name = "StealPage"
obj11.Visible = true
obj11.Position = UDim2.new(0, 0, 0, 0)
obj11.Size = UDim2.new(1, 0, 1, 0)
obj11.CanvasSize = UDim2.new(0, 0, 0, 280)
obj11.ScrollBarThickness = 4
obj11.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
obj11.ScrollingDirection = Enum.ScrollingDirection.XY
obj11.BackgroundTransparency = 1
obj11.BorderSizePixel = 0
obj11.ClipsDescendants = true
obj11.Parent = obj10
createToggleRow(obj11, 0, "Activate", "Performs desync and maintains flags", false, function(on)
    if on then
        task.spawn(function()
            pcall(function()
                setfflag('GameNetPVHeaderRotationalVelocityZeroCutoffExponent', '-5000')
                setfflag('LargeReplicatorWrite5', 'true')
                setfflag('LargeReplicatorEnabled9', 'true')
                setfflag('AngularVelociryLimit', '360')
                setfflag('TimestepArbiterVelocityCriteriaThresholdTwoDt', '2147483646')
                setfflag('S2PhysicsSenderRate', '15000')
                setfflag('DisableDPIScale', 'true')
                setfflag('MaxDataPacketPerSend', '2147483647')
                setfflag('ServerMaxBandwith', '52')
                setfflag('PhysicsSenderMaxBandwidthBps', '20000')
                setfflag('MaxTimestepMultiplierBuoyancy', '2147483647')
                setfflag('SimOwnedNOUCountThresholdMillionth', '2147483647')
                setfflag('MaxMissedWorldStepsRemembered', '-2147483648')
                setfflag('CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth', '1')
                setfflag('StreamJobNOUVolumeLengthCap', '2147483647')
                setfflag('DebugSendDistInSteps', '-2147483648')
                setfflag('MaxTimestepMultiplierAcceleration', '2147483647')
                setfflag('LargeReplicatorRead5', 'true')
                setfflag('SimExplicitlyCappedTimestepMultiplier', '2147483646')
                setfflag('GameNetDontSendRedundantNumTimes', '1')
                setfflag('CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent', '1')
                setfflag('CheckPVCachedRotVelThresholdPercent', '10')
                setfflag('LargeReplicatorSerializeRead3', 'true')
                setfflag('ReplicationFocusNouExtentsSizeCutoffForPauseStuds', '2147483647')
                setfflag('NextGenReplicatorEnabledWrite4', 'true')
                setfflag('CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth', '1')
                setfflag('GameNetDontSendRedundantDeltaPositionMillionth', '1')
                setfflag('InterpolationFrameVelocityThresholdMillionth', '5')
                setfflag('StreamJobNOUVolumeCap', '2147483647')
                setfflag('InterpolationFrameRotVelocityThresholdMillionth', '5')
                setfflag('WorldStepMax', '30')
                setfflag('TimestepArbiterHumanoidLinearVelThreshold', '1')
                setfflag('InterpolationFramePositionThresholdMillionth', '5')
                setfflag('TimestepArbiterHumanoidTurningVelThreshold', '1')
                setfflag('MaxTimestepMultiplierContstraint', '2147483647')
                setfflag('GameNetPVHeaderLinearVelocityZeroCutoffExponent', '-5000')
                setfflag('CheckPVCachedVelThresholdPercent', '10')
                setfflag('TimestepArbiterOmegaThou', '1073741823')
                setfflag('MaxAcceptableUpdateDelay', '1')
                setfflag('LargeReplicatorSerializeWrite4', 'true')
            end)
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildWhichIsA("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Dead) end
                char:ClearAllChildren()
                local fake = Instance.new("Model"); fake.Parent = workspace; LocalPlayer.Character = fake
            end
        end)
    end
end) 
createToggleRow(obj11, 57, "Use Potion on Steal", "Activates Giant Potion during steal", false, function(on)
    giantPotionEnabled = on
end)
createToggleRow(obj11, 114, "Speed Boost", "Increases movement speed", false, function(on)
    speedBoostEnabled = on
    if on then enableSpeedBoost() else disableSpeedBoost() end
end)
createKeybindRow(obj11, 171, "Instant Steal Keybind", "F")
local unlockBaseBtn = createActionButton(obj11, 222, "Unlock Base")
unlockBaseBtn.MouseButton1Click:Connect(function()
    task.spawn(triggerUnlockFloor1)
end)
local obj43 = Instance.new("ScrollingFrame")
obj43.Name = "MiscPage"
obj43.Visible = false
obj43.Position = UDim2.new(0, 0, 0, 0)
obj43.Size = UDim2.new(1, 0, 1, 0)
obj43.CanvasSize = UDim2.new(0, 0, 0, 340)
obj43.ScrollBarThickness = 4
obj43.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
obj43.ScrollingDirection = Enum.ScrollingDirection.XY
obj43.BackgroundTransparency = 1
obj43.BorderSizePixel = 0
obj43.ClipsDescendants = true
obj43.Parent = obj10
createToggleRow(obj43, 0, "Auto Kick After Steal", "Automatically kicks after successful steal", false, function(on)
    autoKickEnabled = on
    if on then enableAutoKick() else disableAutoKick() end
end)
createToggleRow(obj43, 57, "Anti Sentry", "Destroys nearby enemy sentries", false, function(on)
    antiSentryEnabled = on
    if on then enableAntiSentry() else disableAntiSentry() end
end)
createToggleRow(obj43, 114, "Allow ESP", "Shows allow/disallow status on bases", false, function(on)
    allowEspEnabled = on
    if on then enableAllowESP() else disableAllowESP() end
end)
createToggleRow(obj43, 171, "Player ESP", "Shows player hitboxes and names", false, function(on)
    espEnabled = on
    if on then enableESP() else disableESP() end
end)
createToggleRow(obj43, 228, "Base Lock ESP", "Shows base protection timers", false, function(on)
    baseLockEspEnabled = on
    if on then enableBaseLockESP() else disableBaseLockESP() end
end)
createToggleRow(obj43, 285, "X-Ray Base", "Makes bases transparent", false, function(on)
    xrayEnabled = on
    if on then enableXRay() else disableXRay() end
end)
obj88.MouseButton1Click:Connect(function()
    obj11.Visible = true
    obj43.Visible = false
    obj88.TextColor3 = Color3.fromRGB(255, 255, 255)
    obj90.TextColor3 = Color3.fromRGB(160, 160, 160)
    obj89.Visible = true
    obj91.Visible = false
end)
obj90.MouseButton1Click:Connect(function()
    obj11.Visible = false
    obj43.Visible = true
    obj88.TextColor3 = Color3.fromRGB(160, 160, 160)
    obj90.TextColor3 = Color3.fromRGB(255, 255, 255)
    obj89.Visible = false
    obj91.Visible = true
end)
local minimized = false
local expandedSize = UDim2.new(0, 270, 0, 400)
local minimizedSize = UDim2.new(0, 270, 0, 50)
obj8.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(obj2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = minimizedSize}):Play()
        obj8.Text = "+"
    else
        TweenService:Create(obj2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = expandedSize}):Play()
        obj8.Text = "−"
    end
end)
local obj92 = Instance.new("Frame")
obj92.Name = "InstantStealTP"
obj92.Position = UDim2.new(0.5, 245, 0.5, -49)
obj92.Size = UDim2.new(0, 195, 0, 98)
obj92.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
obj92.BorderSizePixel = 0
obj92.ClipsDescendants = true
obj92.Parent = obj1
local obj93 = Instance.new("UICorner")
obj93.CornerRadius = UDim.new(0, 10)
obj93.Parent = obj92
local obj94 = Instance.new("UIStroke")
obj94.Color = Color3.fromRGB(255, 255, 255)
obj94.Thickness = 1.5
obj94.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
obj94.LineJoinMode = Enum.LineJoinMode.Round
obj94.Parent = obj92
local obj95 = Instance.new("UIGradient")
obj95.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
obj95.Rotation = 858
obj95.Parent = obj94
local obj96 = Instance.new("Frame")
obj96.Name = "Header"
obj96.Position = UDim2.new(0, 0, 0, 0)
obj96.Size = UDim2.new(1, 0, 0, 38)
obj96.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
obj96.BorderSizePixel = 0
obj96.Parent = obj92
local obj97 = Instance.new("UICorner")
obj97.CornerRadius = UDim.new(0, 10)
obj97.Parent = obj96
local obj98 = Instance.new("Frame")
obj98.Position = UDim2.new(0, 0, 1, -10)
obj98.Size = UDim2.new(1, 0, 0, 10)
obj98.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
obj98.BorderSizePixel = 0
obj98.Parent = obj96
local obj99 = Instance.new("TextLabel")
obj99.Text = "Instant Steal TP"
obj99.TextColor3 = Color3.fromRGB(255, 255, 255)
obj99.TextSize = 14
obj99.Font = Enum.Font.GothamBold
obj99.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
obj99.TextXAlignment = Enum.TextXAlignment.Left
obj99.Position = UDim2.new(0, 10, 0, 0)
obj99.Size = UDim2.new(1, -40, 1, 0)
obj99.BackgroundTransparency = 1
obj99.Parent = obj96
local obj100 = Instance.new("Frame")
obj100.Position = UDim2.new(0, 0, 1, 0)
obj100.Size = UDim2.new(1, 0, 0, 1)
obj100.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
obj100.BorderSizePixel = 0
obj100.Parent = obj96
local obj101 = Instance.new("TextButton")
obj101.Text = "−"
obj101.TextColor3 = Color3.fromRGB(255, 255, 255)
obj101.TextSize = 16
obj101.Font = Enum.Font.GothamBold
obj101.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
obj101.Position = UDim2.new(1, -32, 0, 7)
obj101.Size = UDim2.new(0, 24, 0, 24)
obj101.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
obj101.BorderSizePixel = 0
obj101.AutoButtonColor = true
obj101.Parent = obj96
local obj102 = Instance.new("UICorner")
obj102.CornerRadius = UDim.new(0, 6)
obj102.Parent = obj101
makeDraggable(obj96, obj92)
local obj103 = Instance.new("TextButton")
obj103.Text = ""
obj103.AutoButtonColor = false
obj103.Position = UDim2.new(0, 7, 0, 43)
obj103.Size = UDim2.new(1, -14, 0, 48)
obj103.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
obj103.BorderSizePixel = 0
obj103.Parent = obj92
local obj104 = Instance.new("UICorner")
obj104.CornerRadius = UDim.new(0, 8)
obj104.Parent = obj103
local obj105 = Instance.new("UIStroke")
obj105.Color = Color3.fromRGB(40, 40, 40)
obj105.Thickness = 1
obj105.Parent = obj103
local obj106 = Instance.new("TextLabel")
obj106.Text = "Teleport"
obj106.TextColor3 = Color3.fromRGB(255, 255, 255)
obj106.TextSize = 16
obj106.Font = Enum.Font.GothamBold
obj106.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
obj106.Size = UDim2.new(1, 0, 1, 0)
obj106.BackgroundTransparency = 1
obj106.Parent = obj103
local tpMinimized = false
local tpExpanded = UDim2.new(0, 195, 0, 98)
local tpMini = UDim2.new(0, 195, 0, 38)
obj101.MouseButton1Click:Connect(function()
    tpMinimized = not tpMinimized
    if tpMinimized then
        TweenService:Create(obj92, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = tpMini}):Play()
        obj101.Text = "+"
    else
        TweenService:Create(obj92, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = tpExpanded}):Play()
        obj101.Text = "−"
    end
end)
local stealBarFillUp
local stealBarDrain
local function resetExecuteState()
    semiInstantActive = false
    obj106.Text = "Teleport"
    obj103.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
end
local function executeSemiInstant()
    if semiInstantActive then return end
    semiInstantActive = true
    obj103.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
    obj106.Text = "EXECUTING..."
    local char = LocalPlayer.Character
    if not char then resetExecuteState(); return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then resetExecuteState(); return end
    local FIRST_TP, SECOND_TP, THIRD_TP, LAST_TP
    if currentBaseSide == "Right" then
        FIRST_TP = RIGHT_FIRST_TP; SECOND_TP = RIGHT_SECOND_TP
        THIRD_TP = RIGHT_THIRD_TP; LAST_TP   = RIGHT_LAST_TP
    else
        FIRST_TP = LEFT_FIRST_TP; SECOND_TP = LEFT_SECOND_TP
        THIRD_TP = LEFT_THIRD_TP; LAST_TP   = LEFT_LAST_TP
    end
    local targetAnimal = getNearestAnimalFromPos(THIRD_TP)
    if not targetAnimal then resetExecuteState(); return end
    local prompt = PromptMemoryCache[targetAnimal.uid]
    if not prompt or not prompt.Parent then
        prompt = findProximityPromptForAnimal(targetAnimal)
    end
    if not prompt then resetExecuteState(); return end
    InternalStealCache[prompt] = nil
    buildStealCallbacks(prompt)
    local data = InternalStealCache[prompt]
    if not data or not data.ready then resetExecuteState(); return end
    data.ready = false
    local grabDuration = 1.3
    if prompt and prompt.HoldDuration then
        grabDuration = prompt.HoldDuration
    end
    local totalBarDuration = grabDuration + 0.8
    stealBarFillUp(totalBarDuration)
    if #data.holdCallbacks > 0 then
        for _, fn in ipairs(data.holdCallbacks) do
            task.spawn(fn)
        end
    end
    local holdStart = tick()
    task.wait(0.9)
    if not hrp or not hrp.Parent or not hum or not hum.Parent then
        stealBarDrain()
        data.ready = true
        resetExecuteState()
        return
    end
    local carpet = LocalPlayer.Backpack:FindFirstChild("Flying Carpet") or char:FindFirstChild("Flying Carpet")
    if carpet then
        hum:EquipTool(carpet)
    end
    if giantPotionEnabled then
        local potion = LocalPlayer.Backpack:FindFirstChild("Giant Potion")
        if potion then
            potion.Parent = char
        end
    end
    hrp.CFrame = CFrame.new(FIRST_TP)
    task.wait(0.15)
    if not hrp or not hrp.Parent then
        stealBarDrain()
        data.ready = true
        resetExecuteState()
        return
    end
    hrp.CFrame = CFrame.new(SECOND_TP)
    task.wait(0.15)
    if not hrp or not hrp.Parent then
        stealBarDrain()
        data.ready = true
        resetExecuteState()
        return
    end
    local lookDir
    if currentBaseSide == "Right" then
        lookDir = Vector3.new(0.00599244050681591, -0.3006192445755005, 0.9537254571914673)
        hrp.CFrame = CFrame.new(THIRD_TP) * CFrame.fromEulerAnglesYXZ(0, math.pi, 0)
    else
        lookDir = Vector3.new(-0.00599244050681591, -0.3006192445755005, -0.9537254571914673)
        hrp.CFrame = CFrame.new(THIRD_TP)
    end
    workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + lookDir)
    local remainingTime = grabDuration - (tick() - holdStart) - 0.03
    if remainingTime > 0 then
        task.wait(remainingTime)
    end
    if hrp and hrp.Parent then
        hrp.CFrame = CFrame.new(LAST_TP)
    end
    task.wait(0.03)
    if #data.triggerCallbacks > 0 then
        for _, fn in ipairs(data.triggerCallbacks) do
            task.spawn(fn)
        end
    end
    if giantPotionEnabled then
        pcall(mouse1click)
    end
    task.wait(0.1)
    data.ready = true
    stealBarDrain()
    task.wait(0.5)
    resetExecuteState()
end
obj103.MouseButton1Click:Connect(function()
    task.spawn(executeSemiInstant)
end)
obj103.MouseEnter:Connect(function()
    TweenService:Create(obj103, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    TweenService:Create(obj105, TweenInfo.new(0.15), {Color = Color3.fromRGB(80, 80, 80)}):Play()
end)
obj103.MouseLeave:Connect(function()
    TweenService:Create(obj103, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
    TweenService:Create(obj105, TweenInfo.new(0.15), {Color = Color3.fromRGB(40, 40, 40)}):Play()
end)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe or listeningForKey or keybindJustSet then return end
    if input.KeyCode == currentKeybind then task.spawn(executeSemiInstant) end
end)
task.spawn(initializeScanner)
task.spawn(function() task.wait(1); pcall(detectBaseSide) end)
local obj107 = Instance.new("Frame")
obj107.Name = "DiscordBar"
obj107.Position = UDim2.new(0.5, -120, 0, 10)
obj107.Size = UDim2.new(0, 240, 0, 34)
obj107.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
obj107.BorderSizePixel = 0
obj107.Parent = obj1
local obj108 = Instance.new("UICorner")
obj108.CornerRadius = UDim.new(0, 8)
obj108.Parent = obj107
local obj109 = Instance.new("UIStroke")
obj109.Color = Color3.fromRGB(255, 255, 255)
obj109.Thickness = 1.5
obj109.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
obj109.LineJoinMode = Enum.LineJoinMode.Round
obj109.Parent = obj107
local obj110 = Instance.new("UIGradient")
obj110.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
obj110.Rotation = 858
obj110.Parent = obj109
local obj111 = Instance.new("TextLabel")
obj111.Text = "Steal Progress"
obj111.TextColor3 = Color3.fromRGB(255, 255, 255)
obj111.TextSize = 12
obj111.Font = Enum.Font.GothamBold
obj111.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
obj111.TextXAlignment = Enum.TextXAlignment.Center
obj111.Position = UDim2.new(0, 7, 0, 3)
obj111.Size = UDim2.new(1, -14, 0, 13)
obj111.BackgroundTransparency = 1
obj111.Parent = obj107
local obj112 = Instance.new("Frame")
obj112.Position = UDim2.new(0, 7, 0, 18)
obj112.Size = UDim2.new(1, -14, 0, 1)
obj112.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
obj112.BorderSizePixel = 0
obj112.Parent = obj107
local obj113 = Instance.new("Frame")
obj113.Name = "ProgressBG"
obj113.Position = UDim2.new(0.03, 0, 1, -10)
obj113.Size = UDim2.new(0.94, 0, 0, 7)
obj113.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
obj113.BorderSizePixel = 0
obj113.Parent = obj107
local obj114 = Instance.new("UICorner")
obj114.CornerRadius = UDim.new(1, 0)
obj114.Parent = obj113
local obj115 = Instance.new("Frame")
obj115.Name = "ProgressFill"
obj115.Position = UDim2.new(0, 0, 0, 0)
obj115.Size = UDim2.new(0, 0, 1, 0)
obj115.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
obj115.BorderSizePixel = 0
obj115.Parent = obj113
local obj116 = Instance.new("UICorner")
obj116.CornerRadius = UDim.new(1, 0)
obj116.Parent = obj115
local obj117 = Instance.new("UIGradient")
obj117.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
obj117.Rotation = 858
obj117.Parent = obj115
do
    local gradients = {obj5, obj95, obj110, obj117}
    local speed = 0.35
    RunService.Heartbeat:Connect(function(dt)
        for _, g in ipairs(gradients) do
            if g and g.Parent then
                g.Rotation = (g.Rotation + dt * speed * 360) % 360
            end
        end
    end)
end
stealBarFillUp = function(dur)
    obj115.Size = UDim2.new(0, 0, 1, 0)
    TweenService:Create(obj115, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 1, 0)
    }):Play()
end
stealBarDrain = function()
    TweenService:Create(obj115, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play()
end