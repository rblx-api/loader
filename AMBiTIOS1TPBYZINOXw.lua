-- =====================================================================
-- AMBITIOS TP - ALL IN ONE SCRIPT (SLOTS ESP + AUTO GRAB + INF JUMP + CARPET SPEED + BASE OWNER ESP)
-- =====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Clean up previous UI if it exists
if CoreGui:FindFirstChild("AMBITIOS_TP") then
    CoreGui.AMBITIOS_TP:Destroy()
end

-- ================= CONFIGURATION: AUTO GRAB =================
local GrabConfig = {
    AutoStealEnabled = false,
    HoldMin = 1.3,
    HoldMax = 2.6,
    EntryDelay = 0.3,
    Cooldown = 0.05,
    StealRange = 10,
    PrimeRange = 80,
}

local Packages = ReplicatedStorage:WaitForChild("Packages")
local Datas = ReplicatedStorage:WaitForChild("Datas")
local AnimalsData = require(Datas:WaitForChild("Animals"))
local PlotsWorkspace = workspace:WaitForChild("Plots")

local SyncRemotes = (function()
    local folder = Packages:WaitForChild("Synchronizer")
    return {
        ChannelFolder = folder:WaitForChild("Channel"),
        RouteRemote = folder:WaitForChild("CommunicationRoute"),
        RequestData = folder:FindFirstChild("RequestData"),
    }
end)()

local PlotAnimalSync = { Caches = {}, Connections = {} }

local function SplitSyncPath(path)
    if typeof(path) == "table" then return path end
    local out = {}
    for part in string.gmatch(tostring(path), "[^%.]+") do
        table.insert(out, tonumber(part) or part)
    end
    return out
end

local function ResolveSyncPath(path, root)
    local current = root
    local parent, key = nil, nil
    for _, part in ipairs(SplitSyncPath(path)) do
        parent = current
        key = part
        current = current and current[part] or nil
    end
    return current, parent, key
end

local function ApplyPlotSyncDiff(channelName, packet)
    local cache = PlotAnimalSync.Caches[channelName]
    if typeof(cache) ~= "table" then return end
    local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
    local current, parent, key = ResolveSyncPath(path, cache)
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

local function AttachPlotChannel(remote)
    if PlotAnimalSync.Connections[remote] then return end
    local channelName = tostring(remote.Name)
    if not PlotsWorkspace:FindFirstChild(channelName) then return end
    if SyncRemotes.RequestData and PlotAnimalSync.Caches[channelName] == nil then
        local ok, data = pcall(function() return SyncRemotes.RequestData:InvokeServer(channelName) end)
        PlotAnimalSync.Caches[channelName] = (ok and typeof(data) == "table") and data or {}
    elseif PlotAnimalSync.Caches[channelName] == nil then
        PlotAnimalSync.Caches[channelName] = {}
    end
    PlotAnimalSync.Connections[remote] = remote.OnClientEvent:Connect(function(queue)
        for _, packet in ipairs(queue) do ApplyPlotSyncDiff(channelName, packet) end
    end)
end

local function DetachPlotChannel(channelName)
    for remote, conn in pairs(PlotAnimalSync.Connections) do
        if tostring(remote.Name) == tostring(channelName) then
            conn:Disconnect()
            PlotAnimalSync.Connections[remote] = nil
            PlotAnimalSync.Caches[tostring(channelName)] = nil
            break
        end
    end
end

for _, child in ipairs(SyncRemotes.ChannelFolder:GetChildren()) do
    if child:IsA("RemoteEvent") then AttachPlotChannel(child) end
end
SyncRemotes.ChannelFolder.ChildAdded:Connect(function(child)
    if child:IsA("RemoteEvent") then AttachPlotChannel(child) end
end)

local function GetPlotChannelData(plotName) return PlotAnimalSync.Caches[plotName] end

local AllAnimalsCache = {}
local PromptMemoryCache = {}
local InternalStealCache = {}
local StealConnection = nil

local StealState = {
    Active = false, StartTime = 0, Phase = "idle", Label = "",
    LastResult = "", LastResultTime = 0, TotalSteals = 0, FailedSteals = 0,
}

local function GetPlotOwner(plot)
    local sign = plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

local function IsMyBaseAnimal(animalData)
    if not animalData or not animalData.plot then return false end
    local plot = PlotsWorkspace:FindFirstChild(animalData.plot)
    if not plot then return false end
    return GetPlotOwner(plot) == LocalPlayer.DisplayName
end

local function FindProximityPromptForAnimal(animalData)
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

local function GetAnimalPosition(animalData)
    local plot = workspace.Plots:FindFirstChild(animalData.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    return podium:GetPivot().Position
end

local function DistToAnimal(animalData)
    local character = LocalPlayer.Character
    if not character then return math.huge end
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    if not hrp then return math.huge end
    local pos = GetAnimalPosition(animalData)
    if not pos then return math.huge end
    return (hrp.Position - pos).Magnitude
end

local function PickClosestAnimal()
    local character = LocalPlayer.Character
    if not character then return nil end
    local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    if not hrp then return nil end

    local best, bestDist = nil, math.huge
    for _, animalData in ipairs(AllAnimalsCache) do
        if IsMyBaseAnimal(animalData) then continue end
        local pos = GetAnimalPosition(animalData)
        if not pos then continue end
        local dist = (hrp.Position - pos).Magnitude
        if dist > GrabConfig.PrimeRange then continue end
        if dist < bestDist then
            bestDist = dist
            best = animalData
        end
    end
    return best
end

local function BuildStealCallbacks(prompt)
    local internalData = InternalStealCache[prompt]
    if internalData then return end
    local data = { HoldCallbacks = {}, TriggerCallbacks = {}, Ready = true }
    local ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(conns1) == "table" then
        for _, conn in ipairs(conns1) do
            if type(conn.Function) == "function" then table.insert(data.HoldCallbacks, conn.Function) end
        end
    end
    local ok2, conns2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(conns2) == "table" then
        for _, conn in ipairs(conns2) do
            if type(conn.Function) == "function" then table.insert(data.TriggerCallbacks, conn.Function) end
        end
    end
    if (#data.HoldCallbacks > 0) or (#data.TriggerCallbacks > 0) then
        InternalStealCache[prompt] = data
    end
end

local function ExecuteStealAsync(prompt, animalData)
    local data = InternalStealCache[prompt]
    if not data or not data.Ready then return false end
    data.Ready = false

    local label = animalData.name or "Animal"
    StealState.Active = true
    StealState.StartTime = tick()
    StealState.Phase = "holding"
    StealState.Label = label

    task.spawn(function()
        for _, fn in ipairs(data.HoldCallbacks) do task.spawn(fn) end
        task.wait(GrabConfig.HoldMin)
        StealState.Phase = "waitingRange"

        local alreadyInRange = DistToAnimal(animalData) <= GrabConfig.StealRange
        local fired = false
        while true do
            local elapsed = tick() - StealState.StartTime
            if elapsed > GrabConfig.HoldMax or not prompt.Parent then break end
            if DistToAnimal(animalData) <= GrabConfig.StealRange then
                if not alreadyInRange then task.wait(GrabConfig.EntryDelay) end
                for _, fn in ipairs(data.TriggerCallbacks) do task.spawn(fn) end
                fired = true
                break
            end
            task.wait()
        end

        if fired then
            StealState.TotalSteals = StealState.TotalSteals + 1
            StealState.LastResult = "Stole " .. label
        else
            StealState.FailedSteals = StealState.FailedSteals + 1
            StealState.LastResult = "Missed window: " .. label
        end

        StealState.Active = false
        StealState.Phase = "idle"
        StealState.LastResultTime = tick()

        task.wait(GrabConfig.Cooldown)
        data.Ready = true
    end)
    return true
end

local function AttemptSteal(prompt, animalData)
    if not prompt or not prompt.Parent then return false end
    BuildStealCallbacks(prompt)
    if not InternalStealCache[prompt] then return false end
    return ExecuteStealAsync(prompt, animalData)
end

local function ScanAllPlots()
    local newCache = {}
    for _, plot in ipairs(PlotsWorkspace:GetChildren()) do
        local cache = GetPlotChannelData(plot.Name)
        if cache and typeof(cache.AnimalList) == "table" then
            for slot, animalData in pairs(cache.AnimalList) do
                if type(animalData) == "table" then
                    local animalName = animalData.Index
                    local animalInfo = AnimalsData[animalName]
                    if animalInfo then
                        table.insert(newCache, {
                            name = animalInfo.DisplayName or animalName,
                            plot = plot.Name,
                            slot = tostring(slot),
                            uid = plot.Name .. "_" .. tostring(slot),
                        })
                    end
                end
            end
        end
    end
    AllAnimalsCache = newCache
    return #AllAnimalsCache
end

local function StartAutoSteal()
    if StealConnection then return end
    StealConnection = RunService.Heartbeat:Connect(function()
        if not GrabConfig.AutoStealEnabled or StealState.Active then return end
        local target = PickClosestAnimal()
        if not target then return end
        local prompt = PromptMemoryCache[target.uid]
        if not prompt or not prompt.Parent then
            prompt = FindProximityPromptForAnimal(target)
        end
        if prompt then AttemptSteal(prompt, target) end
    end)
end

local function StopAutoSteal()
    if StealConnection then
        StealConnection:Disconnect()
        StealConnection = nil
    end
end

task.spawn(function()
    while task.wait(5) do ScanAllPlots() end
end)
ScanAllPlots()

-- ================= GRAPHICAL USER INTERFACE (UI) =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AMBITIOS_TP"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = (gethui and gethui()) or CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 510) -- Mărit pentru a cuprinde toate cele 5 butoane
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 30, 55)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 150, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local BgImage = Instance.new("ImageLabel")
BgImage.Name = "BackgroundImage"
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = "rbxassetid://99487883661505"
BgImage.ImageTransparency = 0.6
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.Parent = MainFrame

local BgCorner = Instance.new("UICorner")
BgCorner.CornerRadius = UDim.new(0, 10)
BgCorner.Parent = BgImage

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "AMBITIOS TP"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Parent = MainFrame

local Container = Instance.new("Frame")
Container.Size = UDim2.new(0.9, 0, 0.9, 0)
Container.Position = UDim2.new(0.05, 0, 0.15, 0)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

local function CreateButton(name, defaultText)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 45, 80)
    Frame.BackgroundTransparency = 0.3
    Frame.Parent = Container

    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 6)
    FrameCorner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.3, 0, 0.7, 0)
    Btn.Position = UDim2.new(0.65, 0, 0.15, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    Btn.Text = defaultText
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.Parent = Frame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = Btn

    return Btn
end

-- ================= LOGIC: SLOTS ESP (BLUE) =================
local EspActive = false

local function EnableSlotsESP()
    if _G.__PodiumESPCleanup then pcall(_G.__PodiumESPCleanup) end
    local BlueColor = Color3.fromRGB(0, 150, 255)
    local Config = { FloorColor = { BlueColor, BlueColor, BlueColor }, Collide = true, ShowNumbers = true }
    local FillTransparency, InnerTransparency = 0.55, 0.42

    local Template = {
        { 18.500,  1.531, -14.476,  90}, { 18.500,  1.531,  -6.976,  90}, { 18.500,  1.531,   0.524,  90},
        { 18.500,  1.531,   8.024,  90}, { 18.500,  1.531,  15.524,  90},
        {-18.536,  1.531,  15.524, -90}, {-18.536,  1.531,   8.024, -90}, {-18.536,  1.531,   0.524, -90},
        {-18.536,  1.531,  -6.976, -90}, {-18.536,  1.531, -14.476, -90},
        { 18.500, 19.531, -14.476,  90}, { 18.500, 19.531,  -6.976,  90}, { 18.500, 19.531,   0.524,  90},
        { 18.500, 19.531,   8.024,  90}, { 18.500, 19.531,  15.524,  90},
        {-18.380, 19.531, -14.452, -90}, {-18.380, 19.531,  -6.952, -90}, {-18.380, 19.531,   0.548, -90},
        { 18.500, 36.531, -12.476,  90}, { 18.500, 36.531,  -4.976,  90}, { 18.500, 36.531,   2.524,  90},
        { 18.500, 36.531,  10.024,  90}, { 18.500, 36.531,  17.524,  90},
        {-18.472, 36.531, -12.501, -90}, {-18.471, 36.531,  -5.001, -90}, {-18.471, 36.531,   2.499, -90},
        {-18.471, 36.531,   9.999, -90}, {-18.471, 36.531,  17.499, -90},
    }

    local OuterSize = Vector3.new(6, 0.25, 6)
    local InnerSize = Vector3.new(4, 0.25, 4)
    local InnerUp = 0.25
    local Markers, Fills, Connections = {}, {}, {}
    local CollideParts, LabelAnchors, LabelsByPlot = {}, {}, {}
    local CurrentPlot, Alive = nil, true

    local function KeepMarker(x) table.insert(Markers, x) x.Parent = ScreenGui return x end

    local function ClearESP()
        for _, m in ipairs(Markers) do pcall(function() m:Destroy() end) end
        table.clear(Markers) table.clear(Fills)
        for _, p in ipairs(CollideParts) do pcall(function() p:Destroy() end) end
        table.clear(CollideParts)
        for _, p in ipairs(LabelAnchors) do pcall(function() p:Destroy() end) end
        table.clear(LabelAnchors) table.clear(LabelsByPlot)
        CurrentPlot = nil
    end

    local function CreateBox(adornee, cf, size, color, trans, isFill)
        local a = Instance.new("BoxHandleAdornment")
        a.Adornee = adornee a.Size = size a.CFrame = cf a.Color3 = color a.Transparency = trans a.AlwaysOnTop = false a.ZIndex = 0
        KeepMarker(a)
        if isFill then table.insert(Fills, { a = a, base = trans }) end
        return a
    end

    local function MakeAnchor(worldCF)
        local a = Instance.new("Part")
        a.Anchored = true a.CanCollide = false a.Transparency = 1 a.Size = Vector3.new(0.1, 0.1, 0.1) a.CFrame = worldCF a.Parent = workspace.CurrentCamera
        table.insert(LabelAnchors, a)
        return a
    end

    local function CreateLabel(plot, adornee, slotNum, color)
        if not Config.ShowNumbers then return end
        local bg = Instance.new("BillboardGui")
        bg.Adornee = adornee bg.Size = UDim2.new(2.2, 20, 1.35, 12) bg.StudsOffset = Vector3.new(0, 3.2, 0) bg.AlwaysOnTop = true bg.Enabled = false

        local panel = Instance.new("Frame")
        panel.Size = UDim2.new(1, 0, 1, 0) panel.BackgroundColor3 = Color3.fromRGB(8, 8, 12) panel.BackgroundTransparency = 0.55 panel.Parent = bg

        local stroke = Instance.new("UIStroke") stroke.Color = color stroke.Thickness = 2 stroke.Parent = panel

        local num = Instance.new("TextLabel")
        num.Size = UDim2.new(1, 0, 1, 0) num.BackgroundTransparency = 1 num.Text = tostring(slotNum) num.Font = Enum.Font.GothamBlack num.TextScaled = true num.TextColor3 = Color3.fromRGB(255, 255, 255) num.Parent = panel

        KeepMarker(bg)
        if not LabelsByPlot[plot] then LabelsByPlot[plot] = {} end
        table.insert(LabelsByPlot[plot], bg)
    end

    local function BuildESP()
        if not Alive then return end
        ClearESP()
        for _, plot in ipairs(PlotsWorkspace:GetChildren()) do
            local root = plot:FindFirstChild("MainRoot")
            if root then
                for i = 1, #Template do
                    local e = Template[i]
                    local cf = CFrame.new(e[1], e[2], e[3]) * CFrame.Angles(0, math.rad(e[4]), 0)
                    local worldCF = root.CFrame * cf
                    local anchor = MakeAnchor(worldCF)
                    CreateBox(anchor, CFrame.new(), OuterSize, BlueColor, FillTransparency, true)
                    CreateBox(anchor, CFrame.new(0, InnerUp, 0), InnerSize, BlueColor, InnerTransparency, true)
                    CreateLabel(plot, anchor, i, BlueColor)
                end
            end
        end
    end

    BuildESP()

    table.insert(Connections, RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local pos = char.HumanoidRootPart.Position
        local best, bestDist = nil, math.huge
        for _, plot in ipairs(PlotsWorkspace:GetChildren()) do
            local root = plot:FindFirstChild("MainRoot")
            if root then
                local d = (root.Position - pos).Magnitude
                if d < bestDist then best = plot bestDist = d end
            end
        end
        local newPlot = (bestDist <= 100) and best or nil
        if newPlot ~= CurrentPlot then
            CurrentPlot = newPlot
            for plot, list in pairs(LabelsByPlot) do
                for _, bg in ipairs(list) do
                    if bg and bg.Parent then bg.Enabled = (plot == CurrentPlot) end
                end
            end
        end
    end))

    _G.__PodiumESPCleanup = function()
        Alive = false
        for _, c in ipairs(Connections) do pcall(function() c:Disconnect() end) end
        ClearESP()
        _G.__PodiumESPCleanup = nil
    end
end

-- ================= LOGIC: INF JUMP + ANTI-RAGDOLL =================
local InfinityJumpEnabled = false
local AntiRagdollActive = false
local InfJumpConnections = {}

local function CheckIsRagdoll(humanoid)
    local state = humanoid:GetState()
    return state == Enum.HumanoidStateType.Physics 
        or state == Enum.HumanoidStateType.Ragdoll 
        or state == Enum.HumanoidStateType.FallingDown
end

local function CleanRagdollState(character, humanoid)
    for _, obj in pairs(character:GetDescendants()) do
        if obj:IsA("BallSocketConstraint") or obj:IsA("NoCollisionConstraint") or obj:IsA("HingeConstraint") then
            obj:Destroy()
        elseif obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
            obj:Destroy()
        elseif obj:IsA("Motor6D") then
            obj.Enabled = true
        end
    end
    local animator = humanoid:FindFirstChild("Animator")
    if animator then
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            local name = track.Animation and track.Animation.Name:lower() or ""
            if name:find("rag") or name:find("fall") or name:find("hurt") or name:find("down") then
                track:Stop(0)
            end
        end
    end
end

local function EnablePlayerControls()
    pcall(function()
        local ps = LocalPlayer:FindFirstChild("PlayerScripts")
        if ps then
            local pm = ps:FindFirstChild("PlayerModule")
            if pm then require(pm):GetControls():Enable() end
        end
    end)
end

local function SetupAntiRagdoll(character)
    local humanoid = character:WaitForChild("Humanoid", 2)
    local hrp = character:WaitForChild("HumanoidRootPart", 2)
    if not humanoid or not hrp then return end
    
    local lastVel = Vector3.new(0, 0, 0)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    
    table.insert(InfJumpConnections, humanoid.StateChanged:Connect(function()
        if AntiRagdollActive and CheckIsRagdoll(humanoid) then
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            CleanRagdollState(character, humanoid)
            EnablePlayerControls()
            hrp.Anchored = false
        end
    end))
    
    table.insert(InfJumpConnections, RunService.Heartbeat:Connect(function()
        if AntiRagdollActive and CheckIsRagdoll(humanoid) then
            CleanRagdollState(character, humanoid)
            local vel = hrp.Velocity
            if (vel - lastVel).Magnitude > 40 and vel.Magnitude > 25 then
                hrp.Velocity = vel.Unit * 15
            end
            lastVel = vel
        end
    end))
    EnablePlayerControls()
end

local JumpForce = 50
local ClampFallSpeed = 80

table.insert(InfJumpConnections, RunService.Heartbeat:Connect(function()
    if not InfinityJumpEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and hrp.Velocity.Y < -ClampFallSpeed then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, -ClampFallSpeed, hrp.Velocity.Z)
    end
end))

table.insert(InfJumpConnections, UserInputService.JumpRequest:Connect(function()
    if not InfinityJumpEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, JumpForce, hrp.Velocity.Z)
    end
end))

local function ToggleInfJump(state)
    InfinityJumpEnabled = state
    AntiRagdollActive = state
    if state then
        if LocalPlayer.Character then
            SetupAntiRagdoll(LocalPlayer.Character)
        end
    else
        for _, c in ipairs(InfJumpConnections) do
            pcall(function() c:Disconnect() end)
        end
        table.clear(InfJumpConnections)
    end
end

-- ================= CREATE MENU BUTTONS =================

-- Button 1: SLOTS ESP
local SlotsBtn = CreateButton("SLOTS ESP", "OFF")
SlotsBtn.MouseButton1Click:Connect(function()
    EspActive = not EspActive
    if EspActive then
        SlotsBtn.Text = "ON"
        SlotsBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        EnableSlotsESP()
    else
        SlotsBtn.Text = "OFF"
        SlotsBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        if _G.__PodiumESPCleanup then _G.__PodiumESPCleanup() end
    end
end)

-- Button 2: AUTO GRAB
local GrabBtn = CreateButton("AUTO GRAB", "OFF")
GrabBtn.MouseButton1Click:Connect(function()
    GrabConfig.AutoStealEnabled = not GrabConfig.AutoStealEnabled
    if GrabConfig.AutoStealEnabled then
        GrabBtn.Text = "ON"
        GrabBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        StartAutoSteal()
    else
        GrabBtn.Text = "OFF"
        GrabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        StopAutoSteal()
    end
end)

-- Button 3: INF JUMP
local InfJumpBtn = CreateButton("INF JUMP", "OFF")
local InfActive = false
InfJumpBtn.MouseButton1Click:Connect(function()
    InfActive = not InfActive
    if InfActive then
        InfJumpBtn.Text = "ON"
        InfJumpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        ToggleInfJump(true)
    else
        InfJumpBtn.Text = "OFF"
        InfJumpBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        ToggleInfJump(false)
    end
end)

-- Button 4: CARPET SPEED
local CarpetSpeedBtn = CreateButton("CARPET SPEED", "OFF")
local CarpetActive = false
CarpetSpeedBtn.MouseButton1Click:Connect(function()
    CarpetActive = not CarpetActive
    if CarpetActive then
        CarpetSpeedBtn.Text = "ON"
        CarpetSpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        _G.StickyCarpetSpeed = true
        _G.StickyCarpetSpeedValue = 140
    else
        CarpetSpeedBtn.Text = "OFF"
        CarpetSpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        _G.StickyCarpetSpeed = false
        _G.StickyCarpetSpeedValue = 140
    end
end)

-- Button 5: BASE OWNER ESP NAME
local BaseOwnerBtn = CreateButton("BASE OWNER ESP", "OFF")
local BaseOwnerActive = false
BaseOwnerBtn.MouseButton1Click:Connect(function()
    BaseOwnerActive = not BaseOwnerActive
    if BaseOwnerActive then
        BaseOwnerBtn.Text = "ON"
        BaseOwnerBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        _G._xenMyBaseOwnerName = true
        if type(_G._xenMyBaseOwnerName) == "function" then
            pcall(_G._xenMyBaseOwnerName)
        end
    else
        BaseOwnerBtn.Text = "OFF"
        BaseOwnerBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        _G._xenMyBaseOwnerName = false
        if type(_G._xenMyBaseOwnerName) == "function" then
            pcall(function() _G._xenMyBaseOwnerName(false) end)
        end
    end
end)