-- ==========================================
-- MUST HUB - COMPLETO + ANTIS ZENONETOP
-- ==========================================

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UIS               = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")
local HttpService       = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local LP                = Players.LocalPlayer
local PlayerGui         = LP:WaitForChild("PlayerGui")

local SaveFolder = "MustHub_Config"
local LockFile = SaveFolder .. "/LockUI_State.txt"
local ConfigFile = SaveFolder .. "/Config.json"
local PosFile = SaveFolder .. "/ButtonPositions.json"
local VisibleFile = SaveFolder .. "/ButtonVisibility.json"

pcall(function() if makefolder and not isfolder(SaveFolder) then makefolder(SaveFolder) end end)

local SpeedConfig = { Normal = 60, Carry = 30, Custom = 30, Lagger = 15 }
local State = {
    uiLocked = false,
    tpPanelEnabled = false,
    ragdollTimerEnabled = false,
    autoAntiTrapEnabled = false,
    trapESPEnabled = false,
    autoStealEnabled = false,
    innerStealBarEnabled = true,
    keys = {}
}

local ZenoAnti = {
    gummy = false,
    boogie = false,
    paint = false,
    bee = false,
    kick = false,
    ragdoll = false,
    ragdollMode = "V1",
}

pcall(function()
    if isfile and isfile(LockFile) then if readfile(LockFile) == "true" then State.uiLocked = true end end
    if isfile and isfile(ConfigFile) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
        if ok and data then
            if data.Normal then SpeedConfig.Normal = data.Normal end
            if data.Carry then SpeedConfig.Carry = data.Carry end
            if data.Custom then SpeedConfig.Custom = data.Custom end
            if data.Lagger then SpeedConfig.Lagger = data.Lagger end
            if type(data.tpPanelEnabled) == "boolean" then State.tpPanelEnabled = data.tpPanelEnabled end
            if type(data.ragdollTimerEnabled) == "boolean" then State.ragdollTimerEnabled = data.ragdollTimerEnabled end
            if type(data.autoAntiTrapEnabled) == "boolean" then State.autoAntiTrapEnabled = data.autoAntiTrapEnabled end
            if type(data.trapESPEnabled) == "boolean" then State.trapESPEnabled = data.trapESPEnabled end
            if type(data.autoStealEnabled) == "boolean" then State.autoStealEnabled = data.autoStealEnabled end
            if type(data.innerStealBarEnabled) == "boolean" then State.innerStealBarEnabled = data.innerStealBarEnabled end
            if type(data.stealRadius) == "number" then Steal_Radius_Saved = data.stealRadius end
            if type(data.zenoAnti) == "table" then
                if type(data.zenoAnti.gummy) == "boolean" then ZenoAnti.gummy = data.zenoAnti.gummy end
                if type(data.zenoAnti.boogie) == "boolean" then ZenoAnti.boogie = data.zenoAnti.boogie end
                if type(data.zenoAnti.paint) == "boolean" then ZenoAnti.paint = data.zenoAnti.paint end
                if type(data.zenoAnti.bee) == "boolean" then ZenoAnti.bee = data.zenoAnti.bee end
                if type(data.zenoAnti.kick) == "boolean" then ZenoAnti.kick = data.zenoAnti.kick end
                if type(data.zenoAnti.ragdoll) == "boolean" then ZenoAnti.ragdoll = data.zenoAnti.ragdoll end
                if type(data.zenoAnti.ragdollMode) == "string" then ZenoAnti.ragdollMode = data.zenoAnti.ragdollMode end
            end
            if type(data.keys) == "table" then
                for k, v in pairs(data.keys) do if Enum.KeyCode[v] then State.keys[k] = Enum.KeyCode[v] end end
            end
        end
    end
end)

local SavedPositions = {}
pcall(function() if isfile and isfile(PosFile) then local ok,d = pcall(function() return HttpService:JSONDecode(readfile(PosFile)) end) if ok and d then SavedPositions = d end end end)

local ButtonVisibility = {}
pcall(function() if isfile and isfile(VisibleFile) then local ok,d = pcall(function() return HttpService:JSONDecode(readfile(VisibleFile)) end) if ok and d then ButtonVisibility = d end end end)

local function SaveConfig()
    pcall(function()
        if writefile then
            local d = {
                Normal = SpeedConfig.Normal,
                Carry = SpeedConfig.Carry,
                Custom = SpeedConfig.Custom,
                Lagger = SpeedConfig.Lagger,
                tpPanelEnabled = State.tpPanelEnabled,
                ragdollTimerEnabled = State.ragdollTimerEnabled,
                autoAntiTrapEnabled = State.autoAntiTrapEnabled,
                trapESPEnabled = State.trapESPEnabled,
                autoStealEnabled = State.autoStealEnabled,
                innerStealBarEnabled = State.innerStealBarEnabled,
                stealRadius = Steal and Steal.StealRadius or 61,
                zenoAnti = {
                    gummy = ZenoAnti and ZenoAnti.gummy or false,
                    boogie = ZenoAnti and ZenoAnti.boogie or false,
                    paint = ZenoAnti and ZenoAnti.paint or false,
                    bee = ZenoAnti and ZenoAnti.bee or false,
                    kick = ZenoAnti and ZenoAnti.kick or false,
                    ragdoll = ZenoAnti and ZenoAnti.ragdoll or false,
                    ragdollMode = ZenoAnti and ZenoAnti.ragdollMode or "V1",
                },
                keys = {}
            }
            for k, v in pairs(State.keys) do d.keys[k] = v.Name end
            writefile(ConfigFile, HttpService:JSONEncode(d))
        end
    end)
end
local function SavePositions() pcall(function() if writefile then writefile(PosFile, HttpService:JSONEncode(SavedPositions)) end end) end
local function SaveVisibility() pcall(function() if writefile then writefile(VisibleFile, HttpService:JSONEncode(ButtonVisibility)) end end) end

-- ============================================================
-- AUTOSTEAL Y/OUT
-- ============================================================
local Steal = {
    AutoStealEnabled = false,
    StealRadius = 61,
    StealDuration = 1.3,
    StealDelay = 0.25,
    Data = {}
}
if Steal_Radius_Saved then Steal.StealRadius = Steal_Radius_Saved end
local isStealing = false
local autoGrabSetDelayRadius = 9
local autoGrabStopTime = 0.96
local autoGrabStopEnabled = true
local Conns = { autoSteal = nil }
local progressFill = nil
local progressPct = nil
local progressRadLbl = nil
local InnerBarCallbacks = { setProgress = nil, setRadius = nil }

local function isMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
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
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil, nil end
    local nearestPrompt, nearestDist, nearestName = nil, math.huge, nil
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local dist = (spawn.Position - root.Position).Magnitude
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
    if InnerBarCallbacks.setProgress then InnerBarCallbacks.setProgress(0) end

    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end
        local startTime = tick()
        local duration = Steal.StealDuration
        local promptFired = false
        if autoGrabStopEnabled then
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = tick() - startTime
                if elapsed >= autoGrabStopTime then break end
                if progressFill then progressFill.Size = UDim2.new(math.clamp(elapsed / duration, 0, 1), 0, 1, 0) end
                if progressPct then progressPct.Text = math.floor(math.clamp(elapsed / duration, 0, 1) * 100) .. "%" end
                if InnerBarCallbacks.setProgress then InnerBarCallbacks.setProgress(math.clamp(elapsed / duration, 0, 1)) end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
                task.wait()
            end
            local stopProgress = math.clamp(autoGrabStopTime / duration, 0, 1)
            if progressFill then progressFill.Size = UDim2.new(stopProgress, 0, 1, 0) end
            if progressPct then progressPct.Text = math.floor(stopProgress * 100) .. "%" end
            if InnerBarCallbacks.setProgress then InnerBarCallbacks.setProgress(stopProgress) end
            local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
            local phase2Start = tick()
            while isStealing and Steal.AutoStealEnabled do
                if tick() - phase2Start >= phase2Timeout then
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    if InnerBarCallbacks.setProgress then InnerBarCallbacks.setProgress(0) end
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
                    if InnerBarCallbacks.setProgress then InnerBarCallbacks.setProgress(0) end
                    data.ready = true
                    return
                end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                    if dist <= autoGrabSetDelayRadius then break
                    elseif dist > Steal.StealRadius then
                        isStealing = false
                        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                        if progressPct then progressPct.Text = "0%" end
                        if InnerBarCallbacks.setProgress then InnerBarCallbacks.setProgress(0) end
                        data.ready = true
                        return
                    end
                end
                task.wait()
            end
            if isStealing and Steal.AutoStealEnabled then
                local fillStart = tick()
                local fillDuration = math.max(duration - autoGrabStopTime, 0.05)
                while true do
                    local fp = math.clamp((tick() - fillStart) / fillDuration, 0, 1)
                    if progressFill then progressFill.Size = UDim2.new(stopProgress + fp * (1 - stopProgress), 0, 1, 0) end
                    if progressPct then progressPct.Text = math.floor((stopProgress + fp * (1 - stopProgress)) * 100) .. "%" end
                    if InnerBarCallbacks.setProgress then InnerBarCallbacks.setProgress(stopProgress + fp * (1 - stopProgress)) end
                    if fp >= 1 and not promptFired then
                        promptFired = true
                        pcall(function()
                            for _, f in ipairs(data.trigger) do task.spawn(f) end
                            local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                            if remote and podName then remote:FireServer(podName) end
                            if prompt then prompt:Fire() end
                        end)
                        break
                    end
                    task.wait()
                end
            end
        else
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = tick() - startTime
                local progress = math.clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = math.floor(progress * 100) .. "%" end
                if InnerBarCallbacks.setProgress then InnerBarCallbacks.setProgress(progress) end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
                if elapsed >= duration and not promptFired then
                    promptFired = true
                    pcall(function()
                        for _, f in ipairs(data.trigger) do task.spawn(f) end
                        local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                        if remote and podName then remote:FireServer(podName) end
                        if prompt then prompt:Fire() end
                    end)
                    break
                end
                task.wait()
            end
        end
        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
        if progressPct then progressPct.Text = "0%" end
        if InnerBarCallbacks.setProgress then InnerBarCallbacks.setProgress(0) end
        data.ready = true
        isStealing = false
    end)
end

local function startAutoSteal()
    if Conns.autoSteal then return end
    Conns.autoSteal = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
end

local function stopAutoSteal()
    if Conns.autoSteal then
        Conns.autoSteal:Disconnect()
        Conns.autoSteal = nil
    end
    isStealing = false
    if progressFill then
        TweenService:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
    end
    if progressPct then progressPct.Text = "0%" end
    if InnerBarCallbacks.setProgress then InnerBarCallbacks.setProgress(0) end
end

-- ============================================================
-- ITEMS Y FUNCIONES
-- ============================================================
local NOMBRE_SENTRY = "All Seeing Sentry"
local NOMBRE_BEEHIVE = "BeeHive"
local NOMBRE_SUBSPACE = "Subspace Mine"
local NOMBRE_TRAP = "Trap"
local NOMBRE_BOOGIE = "Boogie Bomb"
local NOMBRE_GIANT = "Giant Potion"
local NOMBRE_BLACKHOLE = "Blackhole Bomb"
local NOMBRE_CANDY_SENTRY = "Candy Sentry"
local TIEMPO_ITEM = 0.2

local function usarItem(nombreHerramienta)
    local character = LP.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local backpack = LP:FindFirstChild("Backpack")
    local tool = (backpack and backpack:FindFirstChild(nombreHerramienta)) or character:FindFirstChild(nombreHerramienta)
    if not tool then return end
    humanoid:EquipTool(tool)
    task.wait(0.1)
    pcall(function() tool:Activate() end)
    task.wait(TIEMPO_ITEM)
    humanoid:UnequipTools()
    task.wait(0.1)
end

-- ============================================================
-- AUTO ANTI TRAP
-- ============================================================
local FLY_TOOL_NAME = "Flying Carpet"
local RADIO_HORIZONTAL = 0.5
local RADIO_VERTICAL = 5
local COOLDOWN = 0.2
local REESCANEO = 5
local TIEMPO_DESEQUIPAR = 0.2

local traps = {}
local _autoAntiTrapConn = nil
local _autoAntiTrapLastEscape = 0

local function registrarTrap(obj)
    for _, t in ipairs(traps) do if t == obj then return end end
    table.insert(traps, obj)
end

local function escanearTraps()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("trap") and (obj:IsA("Model") or obj:IsA("BasePart")) then
            registrarTrap(obj)
        end
    end
end

local function getTrapPosition(obj)
    if obj:IsA("Model") then
        local ok, pivot = pcall(function() return obj:GetPivot().Position end)
        if ok then return pivot end
        local part = obj:FindFirstChildWhichIsA("BasePart")
        return part and part.Position
    elseif obj:IsA("BasePart") then
        return obj.Position
    end
    return nil
end

local function getTrapSize(obj)
    if obj:IsA("Model") then
        local ok, ext = pcall(function() return obj:GetExtentsSize() end)
        return ok and ext or Vector3.new(4, 4, 4)
    elseif obj:IsA("BasePart") then
        return obj.Size
    end
    return Vector3.new(4, 4, 4)
end

local function encimaDeTrap(hrp, trap)
    local tpos = getTrapPosition(trap)
    if not tpos then return false end
    local size = getTrapSize(trap)
    local dx = hrp.Position.X - tpos.X
    local dz = hrp.Position.Z - tpos.Z
    local distH = math.sqrt(dx*dx + dz*dz)
    local dy = hrp.Position.Y - tpos.Y
    local radioH = math.max(size.X, size.Z) / 2 + RADIO_HORIZONTAL
    return distH <= radioH and dy >= -1 and dy <= (size.Y / 2 + RADIO_VERTICAL)
end

local function usarAlfombra()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local carpet = LP.Backpack:FindFirstChild(FLY_TOOL_NAME) or char:FindFirstChild(FLY_TOOL_NAME)
    if carpet and carpet:IsA("Tool") then
        hum:EquipTool(carpet)
        task.wait(0.02)
        carpet:Activate()
        task.spawn(function()
            task.wait(TIEMPO_DESEQUIPAR)
            local c = char:FindFirstChild(FLY_TOOL_NAME)
            if c and c:IsA("Tool") then hum:UnequipTools() end
        end)
        return true
    end
    return false
end

local function startAutoAntiTrap()
    if _autoAntiTrapConn then return end
    escanearTraps()
    Workspace.DescendantAdded:Connect(function(obj)
        if obj.Name:lower():find("trap") and (obj:IsA("Model") or obj:IsA("BasePart")) then
            task.wait(0.05)
            registrarTrap(obj)
        end
    end)
    task.spawn(function()
        while State.autoAntiTrapEnabled do
            task.wait(REESCANEO)
            escanearTraps()
        end
    end)
    _autoAntiTrapConn = RunService.Heartbeat:Connect(function()
        if not State.autoAntiTrapEnabled then return end
        if tick() - _autoAntiTrapLastEscape < COOLDOWN then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        local st = hum:GetState()
        if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.PlatformStanding then
            if usarAlfombra() then _autoAntiTrapLastEscape = tick() end
            return
        end
        for _, trap in ipairs(traps) do
            if trap and trap.Parent and encimaDeTrap(hrp, trap) then
                if usarAlfombra() then _autoAntiTrapLastEscape = tick() end
                break
            end
        end
    end)
end

local function stopAutoAntiTrap()
    if _autoAntiTrapConn then _autoAntiTrapConn:Disconnect(); _autoAntiTrapConn = nil end
    traps = {}
end

-- ============================================================
-- ESP DE TRAP
-- ============================================================
local _espTrapAddedConn = nil
local _espTrapRescanConn = nil
local _espEtiquetados = {}

local function marcarTrapESP(obj)
    if not obj or _espEtiquetados[obj] then return end
    _espEtiquetados[obj] = true

    local h = Instance.new("Highlight")
    h.Name = "TrapESP_Highlight"
    h.Adornee = obj
    h.FillColor = Color3.fromRGB(255, 0, 0)
    h.OutlineColor = Color3.fromRGB(255, 50, 50)
    h.FillTransparency = 0.35
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = obj

    local caja = Instance.new("BoxHandleAdornment")
    caja.Name = "TrapESP_Box"
    caja.Adornee = obj
    pcall(function()
        caja.Size = obj:IsA("Model") and obj:GetExtentsSize() or obj.Size
    end)
    caja.Color3 = Color3.fromRGB(255, 0, 0)
    caja.Transparency = 0.4
    caja.AlwaysOnTop = true
    caja.ZIndex = 5
    caja.Parent = obj

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TrapESP_Label"
    billboard.Adornee = obj
    billboard.Size = UDim2.new(0, 120, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = obj

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 60, 60)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.Text = "TRAP"
    label.Parent = billboard

    task.spawn(function()
        while obj.Parent and _espEtiquetados[obj] and State.trapESPEnabled do
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos
                pcall(function()
                    pos = obj:IsA("Model") and obj:GetPivot().Position or obj.Position
                end)
                if pos then
                    local dist = math.floor((hrp.Position - pos).Magnitude)
                    label.Text = "TRAP [" .. dist .. "m]"
                end
            end
            task.wait(0.2)
        end
    end)
end

local function escanearTrapESP()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("trap") and (obj:IsA("Model") or obj:IsA("BasePart")) then
            marcarTrapESP(obj)
        end
    end
end

local function startTrapESP()
    if _espTrapAddedConn then return end
    escanearTrapESP()
    _espTrapAddedConn = Workspace.DescendantAdded:Connect(function(obj)
        if not State.trapESPEnabled then return end
        if obj.Name:lower():find("trap") and (obj:IsA("Model") or obj:IsA("BasePart")) then
            task.wait(0.05)
            if State.trapESPEnabled then marcarTrapESP(obj) end
        end
    end)
    _espTrapRescanConn = task.spawn(function()
        while State.trapESPEnabled do
            task.wait(REESCANEO)
            if State.trapESPEnabled then escanearTrapESP() end
        end
    end)
end

local function stopTrapESP()
    if _espTrapAddedConn then _espTrapAddedConn:Disconnect(); _espTrapAddedConn = nil end
    if _espTrapRescanConn then task.cancel(_espTrapRescanConn); _espTrapRescanConn = nil end
    for obj in pairs(_espEtiquetados) do
        pcall(function()
            for _, child in ipairs(obj:GetChildren()) do
                if child.Name:find("TrapESP") then child:Destroy() end
            end
        end)
    end
    _espEtiquetados = {}
end

-- ============================================================
-- UI
-- ============================================================
local COLORS = {
    bg = Color3.fromRGB(10, 10, 12), row = Color3.fromRGB(18, 18, 20), stroke = Color3.fromRGB(60, 60, 65),
    white = Color3.fromRGB(255, 255, 255), textDim = Color3.fromRGB(150, 150, 155), toggleBg = Color3.fromRGB(40, 40, 45),
    knob = Color3.fromRGB(240, 240, 240), accent = Color3.fromRGB(255, 255, 255)
}

if CoreGui:FindFirstChild("MustHubDesign") then CoreGui.MustHubDesign:Destroy() end
local Gui = Instance.new("ScreenGui")
Gui.Name = "MustHubDesign"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.DisplayOrder = 999
Gui.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 300, 0, 380)
Main.Position = UDim2.new(0.5, -150, 0.5, -190)
Main.BackgroundColor3 = COLORS.bg
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = false
Main.Parent = Gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color = COLORS.stroke
mainStroke.Thickness = 1.5
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local BgImage = Instance.new("ImageLabel", Main)
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = "rbxassetid://134550584218036"
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.ZIndex = 1
Instance.new("UICorner", BgImage).CornerRadius = UDim.new(0, 16)

local BgOverlay = Instance.new("Frame", Main)
BgOverlay.Size = UDim2.new(1, 0, 1, 0)
BgOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BgOverlay.BackgroundTransparency = 0.4
BgOverlay.BorderSizePixel = 0
BgOverlay.ZIndex = 2
Instance.new("UICorner", BgOverlay).CornerRadius = UDim.new(0, 16)

local Header = Instance.new("Frame", Main)
Header.BackgroundTransparency = 1
Header.Size = UDim2.new(1, 0, 0, 50)
Header.ZIndex = 5

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(0, 10, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = COLORS.white
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.ZIndex = 10
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local LogoCircle = Instance.new("Frame", Header)
LogoCircle.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
LogoCircle.BorderSizePixel = 0
LogoCircle.Size = UDim2.new(0, 30, 0, 30)
LogoCircle.Position = UDim2.new(0, 40, 0.5, -15)
LogoCircle.ZIndex = 6
Instance.new("UICorner", LogoCircle).CornerRadius = UDim.new(1, 0)
local logoStroke = Instance.new("UIStroke", LogoCircle)
logoStroke.Color = COLORS.accent
logoStroke.Thickness = 1
logoStroke.Transparency = 0.2

local LogoImage = Instance.new("ImageLabel", LogoCircle)
LogoImage.Size = UDim2.new(1, -4, 1, -4)
LogoImage.Position = UDim2.new(0, 2, 0, 2)
LogoImage.BackgroundTransparency = 1
LogoImage.Image = "rbxassetid://124141498575881"
LogoImage.ScaleType = Enum.ScaleType.Fit
LogoImage.ZIndex = 7
Instance.new("UICorner", LogoImage).CornerRadius = UDim.new(1, 0)

local BrandText = Instance.new("TextLabel", Header)
BrandText.Size = UDim2.new(0, 100, 1, 0)
BrandText.Position = UDim2.new(0, 75, 0, 0)
BrandText.BackgroundTransparency = 1
BrandText.Text = "MUST HUB"
BrandText.TextColor3 = COLORS.white
BrandText.Font = Enum.Font.GothamBlack
BrandText.TextSize = 14
BrandText.TextXAlignment = Enum.TextXAlignment.Left
BrandText.ZIndex = 6

local ProfileFrame = Instance.new("Frame", Header)
ProfileFrame.BackgroundTransparency = 1
ProfileFrame.Size = UDim2.new(0, 100, 0, 34)
ProfileFrame.Position = UDim2.new(1, -110, 0.5, -17)
ProfileFrame.ZIndex = 6

local ProfileName = Instance.new("TextLabel", ProfileFrame)
ProfileName.Size = UDim2.new(1, -34, 0, 16)
ProfileName.BackgroundTransparency = 1
ProfileName.Text = LP.DisplayName or LP.Name
ProfileName.TextColor3 = COLORS.white
ProfileName.Font = Enum.Font.GothamBold
ProfileName.TextSize = 10
ProfileName.TextXAlignment = Enum.TextXAlignment.Right
ProfileName.TextTruncate = Enum.TextTruncate.AtEnd
ProfileName.ZIndex = 7

local ProfileHandle = Instance.new("TextLabel", ProfileFrame)
ProfileHandle.Size = UDim2.new(1, -34, 0, 14)
ProfileHandle.Position = UDim2.new(0, 0, 0, 17)
ProfileHandle.BackgroundTransparency = 1
ProfileHandle.Text = "@" .. LP.Name
ProfileHandle.TextColor3 = COLORS.textDim
ProfileHandle.Font = Enum.Font.GothamMedium
ProfileHandle.TextSize = 8
ProfileHandle.TextXAlignment = Enum.TextXAlignment.Right
ProfileHandle.ZIndex = 7

local Avatar = Instance.new("ImageLabel", ProfileFrame)
Avatar.Size = UDim2.new(0, 28, 0, 28)
Avatar.Position = UDim2.new(1, -28, 0.5, -14)
Avatar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Avatar.BorderSizePixel = 0
Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..LP.UserId.."&width=150&height=150&format=png"
Avatar.ZIndex = 7
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)
local avatarStroke = Instance.new("UIStroke", Avatar)
avatarStroke.Color = COLORS.accent
avatarStroke.Thickness = 1.5
avatarStroke.Transparency = 0.2

local Content = Instance.new("Frame", Main)
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 10, 0, 55)
Content.Size = UDim2.new(1, -20, 1, -115)
Content.ZIndex = 3

local TabBar = Instance.new("Frame", Main)
TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
TabBar.BorderSizePixel = 0
TabBar.Size = UDim2.new(1, -20, 0, 36)
TabBar.Position = UDim2.new(0, 10, 1, -44)
TabBar.ZIndex = 6
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)

local Tabs = Instance.new("Frame", TabBar)
Tabs.BackgroundTransparency = 1
Tabs.Size = UDim2.new(1, -6, 1, -6)
Tabs.Position = UDim2.new(0, 3, 0, 3)
Tabs.ZIndex = 7

local TabLayout = Instance.new("UIListLayout", Tabs)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 2)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

local pages = {}
local tabButtons = {}
local tabNames = {"MOVEMENT", "COMBAT", "VISUALS", "SETTINGS", "KEYBINDS", "PANELS"}

local function addPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Size = UDim2.new(1, 0, 1, 0)
    page.ZIndex = 3
    page.Visible = false
    page.Parent = Content
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    pages[name] = page
    return page
end

for i, name in ipairs(tabNames) do
    addPage(name)
    local btn = Instance.new("TextButton", Tabs)
    btn.Name = name
    btn.Size = UDim2.new(0.16, -1, 0, 26)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    btn.BackgroundTransparency = 0.4
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.LayoutOrder = i
    btn.TextColor3 = COLORS.textDim
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 8
    btn.AutoButtonColor = false
    btn.ZIndex = 8
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local st = Instance.new("UIStroke", btn)
    st.Color = COLORS.stroke
    st.Thickness = 1
    st.Transparency = 0.6
    tabButtons[name] = btn
    btn.MouseButton1Click:Connect(function()
        for pName, p in pairs(pages) do p.Visible = (pName == name) end
        for tName, b in pairs(tabButtons) do
            local on = (tName == name)
            b.TextColor3 = on and COLORS.white or COLORS.textDim
            b.BackgroundColor3 = on and Color3.fromRGB(35, 35, 40) or Color3.fromRGB(20, 20, 25)
            local stroke = b:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Transparency = on and 0.2 or 0.6 end
        end
    end)
end

local function CreateRow(parent, labelText, order)
    local row = Instance.new("Frame", parent)
    row.Name = labelText
    row.BackgroundColor3 = COLORS.row
    row.BackgroundTransparency = 0.15
    row.Size = UDim2.new(1, -4, 0, 32)
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ZIndex = 4
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", row)
    st.Color = COLORS.stroke
    st.Thickness = 1
    st.Transparency = 0.4
    local label = Instance.new("TextLabel", row)
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = COLORS.white
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(1, -100, 1, 0)
    label.ZIndex = 5
    return row
end

local function CreateToggle(parent, labelText, default, order, callback)
    local row = CreateRow(parent, labelText, order)
    local track = Instance.new("Frame", row)
    track.Name = "Track"
    track.BackgroundColor3 = default and COLORS.knob or COLORS.toggleBg
    track.Size = UDim2.new(0, 32, 0, 16)
    track.Position = UDim2.new(1, -44, 0.5, -8)
    track.BorderSizePixel = 0
    track.ZIndex = 5
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local st = Instance.new("UIStroke", track)
    st.Color = default and COLORS.white or COLORS.stroke
    st.Thickness = 1
    st.Transparency = 0.3
    local knob = Instance.new("Frame", track)
    knob.Name = "Knob"
    knob.BackgroundColor3 = default and Color3.fromRGB(20, 20, 20) or COLORS.knob
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    knob.BorderSizePixel = 0
    knob.ZIndex = 6
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local click = Instance.new("TextButton", row)
    click.Size = UDim2.new(1, 0, 1, 0)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.ZIndex = 7
    local state = default
    click.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(track, TweenInfo.new(0.15), {BackgroundColor3 = state and COLORS.knob or COLORS.toggleBg}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
            BackgroundColor3 = state and Color3.fromRGB(20, 20, 20) or COLORS.knob
        }):Play()
        TweenService:Create(st, TweenInfo.new(0.15), {Color = state and COLORS.white or COLORS.stroke}):Play()
        if callback then callback(state) end
    end)
    local api = {}
    function api.setVisual(newState)
        if newState == state then return end
        state = newState
        TweenService:Create(track, TweenInfo.new(0.15), {BackgroundColor3 = state and COLORS.knob or COLORS.toggleBg}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
            BackgroundColor3 = state and Color3.fromRGB(20, 20, 20) or COLORS.knob
        }):Play()
        TweenService:Create(st, TweenInfo.new(0.15), {Color = state and COLORS.white or COLORS.stroke}):Play()
    end
    function api.setState(newState, fireCallback)
        api.setVisual(newState)
        if fireCallback and callback then callback(newState) end
    end
    return api
end

local function CreateInputRow(parent, labelText, defaultValue, order, callback)
    local row = CreateRow(parent, labelText, order)
    local box = Instance.new("TextBox", row)
    box.Size = UDim2.new(0, 60, 0, 22)
    box.Position = UDim2.new(1, -70, 0.5, -11)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    box.BorderSizePixel = 0
    box.Text = tostring(defaultValue)
    box.TextColor3 = COLORS.white
    box.Font = Enum.Font.GothamBold
    box.TextSize = 10
    box.ZIndex = 6
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
    local st = Instance.new("UIStroke", box)
    st.Color = COLORS.stroke
    st.Thickness = 1
    st.Transparency = 0.4
    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then callback(val); SaveConfig() else box.Text = tostring(defaultValue) end
    end)
    return box
end

local function CreateActionRow(parent, labelText, buttonText, order, callback)
    local row = CreateRow(parent, labelText, order)
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, 70, 0, 22)
    btn.Position = UDim2.new(1, -80, 0.5, -11)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 0
    btn.Text = buttonText
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 10
    btn.ZIndex = 6
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)
    return btn
end

local function CreateSeparator(parent, text, order)
    local sep = Instance.new("Frame", parent)
    sep.Name = "Sep_" .. text
    sep.BackgroundTransparency = 1
    sep.Size = UDim2.new(1, -4, 0, 22)
    sep.LayoutOrder = order
    sep.ZIndex = 4
    local ll = Instance.new("Frame", sep)
    ll.BackgroundColor3 = COLORS.stroke; ll.BackgroundTransparency = 0.3; ll.BorderSizePixel = 0
    ll.Size = UDim2.new(0.32, 0, 0, 1); ll.Position = UDim2.new(0, 0, 0.5, -0.5); ll.ZIndex = 4
    local rl = Instance.new("Frame", sep)
    rl.BackgroundColor3 = COLORS.stroke; rl.BackgroundTransparency = 0.3; rl.BorderSizePixel = 0
    rl.Size = UDim2.new(0.32, 0, 0, 1); rl.Position = UDim2.new(0.68, 0, 0.5, -0.5); rl.ZIndex = 4
    local lbl = Instance.new("TextLabel", sep)
    lbl.BackgroundTransparency = 1; lbl.Size = UDim2.new(0.36, 0, 1, 0); lbl.Position = UDim2.new(0.32, 0, 0, 0)
    lbl.Text = text; lbl.TextColor3 = COLORS.textDim; lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 9; lbl.TextXAlignment = Enum.TextXAlignment.Center; lbl.ZIndex = 5
end

-- ============================================================
-- COMBAT
-- ============================================================
local autoStealToggleApi = nil

local function setAutoStealState(state)
    Steal.AutoStealEnabled = state
    State.autoStealEnabled = state
    SaveConfig()
    if state then startAutoSteal() else stopAutoSteal() end
    pcall(function()
        if ToggleStates then ToggleStates["autosteal"] = state end
        local kryzen = PlayerGui:FindFirstChild("KryzenButtons")
        if kryzen then
            local holder = kryzen:FindFirstChild("MBH_autosteal")
            local btn = holder and holder:FindFirstChild("MB_autosteal")
            if btn then
                local st = btn:FindFirstChildOfClass("UIStroke")
                if st then
                    if state then st.Color = Color3.fromRGB(255,255,255); st.Thickness = 3; st.Transparency = 0
                    else st.Color = Color3.fromRGB(28,28,34); st.Thickness = 1.4; st.Transparency = 0.75 end
                end
            end
        end
    end)
end

CreateSeparator(pages["COMBAT"], "AUTO STEAL", 1)

autoStealToggleApi = CreateToggle(pages["COMBAT"], "AUTO STEAL", State.autoStealEnabled, 2, function(state)
    setAutoStealState(state)
end)

CreateInputRow(pages["COMBAT"], "Steal Radius", Steal.StealRadius, 3, function(val)
    Steal.StealRadius = math.clamp(val, 1, 500)
    if progressRadLbl then progressRadLbl.Text = string.format("Radius: %.2g", Steal.StealRadius) end
    if InnerBarCallbacks.setRadius then InnerBarCallbacks.setRadius(Steal.StealRadius) end
end)

local innerStealBar = nil
local innerStealFill = nil
local innerStealPct = nil
local innerStealRad = nil

local function createInnerStealBar()
    if innerStealBar then return end
    local row = Instance.new("Frame", pages["COMBAT"])
    row.Name = "InnerStealBar"
    row.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    row.BackgroundTransparency = 0.1
    row.Size = UDim2.new(1, -4, 0, 24)
    row.BorderSizePixel = 0
    row.LayoutOrder = 4
    row.ZIndex = 4
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", row)
    st.Color = COLORS.stroke
    st.Thickness = 1
    st.Transparency = 0.4

    local pct = Instance.new("TextLabel", row)
    pct.Size = UDim2.new(0, 40, 1, 0)
    pct.Position = UDim2.new(0, 8, 0, 0)
    pct.BackgroundTransparency = 1
    pct.Text = "0%"
    pct.TextColor3 = COLORS.white
    pct.Font = Enum.Font.GothamBlack
    pct.TextSize = 12
    pct.TextXAlignment = Enum.TextXAlignment.Left
    pct.ZIndex = 5

    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(1, -58, 0, 6)
    track.Position = UDim2.new(0, 50, 0.5, -3)
    track.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
    track.BorderSizePixel = 0
    track.ZIndex = 5
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(210, 210, 225)
    fill.BorderSizePixel = 0
    fill.ZIndex = 6
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    innerStealBar = row
    innerStealFill = fill
    innerStealPct = pct
    innerStealRad = nil

    InnerBarCallbacks.setProgress = function(v)
        if not innerStealFill then return end
        v = math.clamp(v, 0, 1)
        TweenService:Create(innerStealFill, TweenInfo.new(0.1), {Size = UDim2.new(v, 0, 1, 0)}):Play()
        innerStealPct.Text = math.floor(v * 100) .. "%"
    end
    InnerBarCallbacks.setRadius = function(r) end
end

local function destroyInnerStealBar()
    if innerStealBar then innerStealBar:Destroy(); innerStealBar = nil end
    innerStealFill = nil; innerStealPct = nil; innerStealRad = nil
    InnerBarCallbacks.setProgress = nil
    InnerBarCallbacks.setRadius = nil
end

if State.innerStealBarEnabled then
    task.defer(createInnerStealBar)
end

CreateSeparator(pages["COMBAT"], "TRAP", 5)

local autoAntiTrapToggleApi = CreateToggle(pages["COMBAT"], "AUTO ANTI TRAP", State.autoAntiTrapEnabled, 6, function(state)
    State.autoAntiTrapEnabled = state
    SaveConfig()
    if state then startAutoAntiTrap() else stopAutoAntiTrap() end
end)

local trapESPToggleApi = CreateToggle(pages["COMBAT"], "ESP TRAP", State.trapESPEnabled, 7, function(state)
    State.trapESPEnabled = state
    SaveConfig()
    if state then startTrapESP() else stopTrapESP() end
end)

-- ============================================================
-- MOVEMENT
-- ============================================================
CreateInputRow(pages["MOVEMENT"], "Normal Speed", SpeedConfig.Normal, 1, function(val) SpeedConfig.Normal = val end)
CreateInputRow(pages["MOVEMENT"], "Carry Speed", SpeedConfig.Carry, 2, function(val) SpeedConfig.Carry = val end)
CreateInputRow(pages["MOVEMENT"], "Custom Speed", SpeedConfig.Custom, 3, function(val) SpeedConfig.Custom = val end)
CreateInputRow(pages["MOVEMENT"], "Lagger Speed", SpeedConfig.Lagger, 4, function(val) SpeedConfig.Lagger = val end)

-- ============================================================
-- RAGDOLL TIMER
-- ============================================================
local _rtTimerActive = false
local _rtConn = nil
local _rtBillboard = nil
local _rtLabel = nil
local function setupRagTimerBillboard()
    if _rtBillboard then return end
    local char = LP.Character; if not char then return end
    local head = char:FindFirstChild("Head"); if not head then return end
    _rtBillboard = Instance.new("BillboardGui")
    _rtBillboard.Name = "MustHubRagTimer"; _rtBillboard.Size = UDim2.new(0, 100, 0, 50)
    _rtBillboard.StudsOffset = Vector3.new(0, 2.5, 0); _rtBillboard.AlwaysOnTop = true
    _rtBillboard.MaxDistance = 100; _rtBillboard.Adornee = head; _rtBillboard.Parent = head
    _rtLabel = Instance.new("TextLabel", _rtBillboard)
    _rtLabel.Size = UDim2.new(1, 0, 1, 0); _rtLabel.BackgroundTransparency = 1
    _rtLabel.Text = ""; _rtLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    _rtLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); _rtLabel.TextStrokeTransparency = 0
    _rtLabel.Font = Enum.Font.GothamBlack; _rtLabel.TextSize = 24
end
local function startRagTimerGui()
    if _rtTimerActive then return end
    _rtTimerActive = true
    task.spawn(function()
        local t = 3.0
        while t >= 0.0 do
            if not _rtLabel or not _rtLabel.Parent then break end
            _rtLabel.Text = string.format("%.1f", t)
            task.wait(0.1); t = math.round((t - 0.1) * 10) / 10
        end
        if _rtLabel and _rtLabel.Parent then _rtLabel.Text = "STEAL!" end
        repeat task.wait(0.1) until (function()
            local c = LP.Character; local hum = c and c:FindFirstChildOfClass("Humanoid")
            if not hum then return true end
            local st = hum:GetState()
            return st ~= Enum.HumanoidStateType.Physics and st ~= Enum.HumanoidStateType.Ragdoll and st ~= Enum.HumanoidStateType.FallingDown
        end)()
        if _rtLabel and _rtLabel.Parent then _rtLabel.Text = "" end
        _rtTimerActive = false
    end)
end
local function startRagTimerDetection()
    if _rtConn then _rtConn:Disconnect() end
    setupRagTimerBillboard()
    _rtConn = RunService.Heartbeat:Connect(function()
        if not State.ragdollTimerEnabled then return end
        local char = LP.Character; if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        local st = hum:GetState()
        if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
            if not _rtBillboard or not _rtBillboard.Parent then setupRagTimerBillboard() end
            startRagTimerGui()
        end
    end)
end
local function stopRagTimerDetection()
    if _rtConn then _rtConn:Disconnect(); _rtConn = nil end
    if _rtBillboard then _rtBillboard:Destroy(); _rtBillboard = nil end
    _rtTimerActive = false
end

CreateToggle(pages["VISUALS"], "Ragdoll Timer", State.ragdollTimerEnabled, 1, function(state)
    State.ragdollTimerEnabled = state; SaveConfig()
    if state then startRagTimerDetection() else stopRagTimerDetection() end
end)

CreateToggle(pages["SETTINGS"], "Lock UI", State.uiLocked, 1, function(state)
    State.uiLocked = state
    pcall(function() if writefile then writefile(LockFile, tostring(state)) end end)
end)

-- ============================================================
-- BOTONES MÓVILES
-- ============================================================
local BTN_SIZE = 50; local GAP = 8; local COL_SPACING = BTN_SIZE + GAP
local X3 = -(BTN_SIZE + 20); local X2 = -(BTN_SIZE * 2 + GAP + 20); local X1 = -(BTN_SIZE * 3 + GAP * 2 + 20)
local Y_ROW1 = -(COL_SPACING * 2.5); local Y_ROW2 = -(COL_SPACING * 1.5); local Y_ROW3 = -(COL_SPACING * 0.5)
local Y_ROW4 = (COL_SPACING * 0.5); local Y_ROW5 = (COL_SPACING * 1.5); local Y_ROW6 = (COL_SPACING * 2.5)

local DEFAULT_POSITIONS = {
    blackhole   = UDim2.new(1, X1, 0.5, Y_ROW1),
    candysentry = UDim2.new(1, X2, 0.5, Y_ROW1),
    sentry      = UDim2.new(1, X1, 0.5, Y_ROW2),
    beehive     = UDim2.new(1, X2, 0.5, Y_ROW2),
    subspace    = UDim2.new(1, X3, 0.5, Y_ROW2),
    trap        = UDim2.new(1, X1, 0.5, Y_ROW3),
    boogie      = UDim2.new(1, X2, 0.5, Y_ROW3),
    giant       = UDim2.new(1, X3, 0.5, Y_ROW3),
    drop        = UDim2.new(1, X1, 0.5, Y_ROW4),
    autosteal   = UDim2.new(1, X2, 0.5, Y_ROW4),
    antisentry  = UDim2.new(1, X3, 0.5, Y_ROW4),
    reset       = UDim2.new(1, X1, 0.5, Y_ROW5),
    tpdown      = UDim2.new(1, X2, 0.5, Y_ROW5),
    antitrap    = UDim2.new(1, X3, 0.5, Y_ROW5),
    carry       = UDim2.new(1, X1, 0.5, Y_ROW6),
    custom      = UDim2.new(1, X2, 0.5, Y_ROW6),
    lagger      = UDim2.new(1, X3, 0.5, Y_ROW6),
}

CreateActionRow(pages["SETTINGS"], "Button Positions", "RESET", 2, function()
    SavedPositions = {}
    pcall(function() if isfile and isfile(PosFile) and delfile then delfile(PosFile) end end)
    local kryzen = PlayerGui:FindFirstChild("KryzenButtons")
    if not kryzen then return end
    for key, pos in pairs(DEFAULT_POSITIONS) do
        local holder = kryzen:FindFirstChild("MBH_" .. key)
        if holder then
            TweenService:Create(holder, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = pos}):Play()
        end
    end
end)

if PlayerGui:FindFirstChild("KryzenButtons") then PlayerGui.KryzenButtons:Destroy() end
local mobileGui = Instance.new("ScreenGui")
mobileGui.Name = "KryzenButtons"; mobileGui.ResetOnSpawn = false; mobileGui.IgnoreGuiInset = true
mobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; mobileGui.DisplayOrder = 1000; mobileGui.Parent = PlayerGui

local function corner(obj, radius)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius or 8); c.Parent = obj; return c
end
local function addWhiteShimmer(parent, radius, zindex, period, base)
    local fx = Instance.new("Frame")
    fx.Name = "WhiteFX"; fx.BackgroundColor3 = Color3.fromRGB(255, 255, 255); fx.BorderSizePixel = 0; fx.Active = false
    fx.Size = UDim2.new(1, 0, 1, 0); fx.ZIndex = zindex or parent.ZIndex; fx.Parent = parent
    corner(fx, radius)
    local g = Instance.new("UIGradient")
    g.Rotation = 20
    g.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0.00, 1), NumberSequenceKeypoint.new(0.34, 1),
        NumberSequenceKeypoint.new(0.50, base or 0.86), NumberSequenceKeypoint.new(0.66, 1),
        NumberSequenceKeypoint.new(1.00, 1),
    })
    g.Offset = Vector2.new(-1, 0); g.Parent = fx
    task.spawn(function()
        task.wait(math.random() * 2)
        pcall(function()
            TweenService:Create(g, TweenInfo.new(period or 3.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, false), {Offset = Vector2.new(1, 0)}):Play()
        end)
    end)
    return fx
end
local function addGhostFX(parent, opts)
    if not parent then return nil end
    opts = opts or {}
    local old = parent:FindFirstChild("GhostFX"); if old then old:Destroy() end
    local count = opts.count or 3
    local minS = (opts.minSize or 8) * 1.1; local maxS = (opts.maxSize or 12) * 1.1
    local layer = Instance.new("Frame")
    layer.Name = "GhostFX"; layer.BackgroundTransparency = 1; layer.BorderSizePixel = 0; layer.Active = false
    layer.Size = UDim2.new(1, 0, 1, 0); layer.ZIndex = opts.zindex or ((parent.ZIndex or 1) + 10)
    layer.ClipsDescendants = true; layer.Parent = parent
    for _ = 1, count do
        local g = Instance.new("TextLabel")
        g.Name = "Ghost"; g.BackgroundTransparency = 1; g.BorderSizePixel = 0; g.Active = false
        g.Text = "\u{1F47B}"; g.Font = Enum.Font.Gotham; g.TextColor3 = Color3.fromRGB(255, 255, 255)
        g.TextTransparency = 1; g.TextStrokeColor3 = Color3.fromRGB(255, 255, 255); g.TextStrokeTransparency = 1
        g.TextXAlignment = Enum.TextXAlignment.Center; g.TextYAlignment = Enum.TextYAlignment.Center; g.ZIndex = layer.ZIndex; g.Parent = layer
        task.spawn(function()
            task.wait(math.random(0, 30) / 10)
            while g.Parent do
                local size = math.random(minS * 10, maxS * 10) / 10
                local x = (math.random(4, 88)) / 100; local y = (math.random(8, 80)) / 100
                local dx = (math.random(-14, 14)) / 100; local dy = (math.random(-22, 6)) / 100
                local life = math.random(24, 48) / 10
                g.TextSize = size; g.Size = UDim2.new(0, size + 8, 0, size + 8)
                g.Position = UDim2.new(x, 0, y, 0); g.Rotation = math.random(-18, 18)
                pcall(function()
                    TweenService:Create(g, TweenInfo.new(life, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                        Position = UDim2.new(x + dx, 0, y + dy, 0), Rotation = math.random(-25, 25),
                    }):Play()
                    TweenService:Create(g, TweenInfo.new(life * 0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0.1, TextStrokeTransparency = 0.6}):Play()
                end)
                task.wait(life * 0.5)
                pcall(function()
                    TweenService:Create(g, TweenInfo.new(life * 0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
                end)
                task.wait(life * 0.5 + math.random(1, 12) / 10)
            end
        end)
    end
    return layer
end
local function setActive(btn, state)
    if not btn then return end
    local st = btn:FindFirstChildOfClass("UIStroke")
    if st then
        if state then st.Color = Color3.fromRGB(255, 255, 255); st.Thickness = 3.0; st.Transparency = 0
        else st.Color = Color3.fromRGB(28, 28, 34); st.Thickness = 1.4; st.Transparency = 0.75 end
    end
end

local speedButtons = {}
local ActiveSpeedMode = "None"
local function setSpeedMode(modeName)
    ActiveSpeedMode = modeName
    for mName, btn in pairs(speedButtons) do
        local st = btn:FindFirstChildOfClass("UIStroke")
        if st then
            if mName == modeName then
                st.Color = Color3.fromRGB(255, 255, 255); st.Thickness = 3.0; st.Transparency = 0
            else
                st.Color = Color3.fromRGB(28, 28, 34); st.Thickness = 1.4; st.Transparency = 0.75
            end
        end    end
end

local ToggleStates = {}

local function makeButton(key, label, defaultPos, isToggleType, stateKey, onToggle)
    local holder = Instance.new("Frame")
    holder.Name = "MBH_" .. key; holder.Size = UDim2.new(0, 50, 0, 50)
    if SavedPositions[key] then
        holder.Position = UDim2.new(SavedPositions[key].X, SavedPositions[key].XO, SavedPositions[key].Y, SavedPositions[key].YO)
    else
        holder.Position = defaultPos
    end
    if ButtonVisibility[key] ~= nil then holder.Visible = ButtonVisibility[key] end
    holder.BackgroundTransparency = 1; holder.BorderSizePixel = 0; holder.ZIndex = 1000; holder.Active = true; holder.Parent = mobileGui

    local btn = Instance.new("TextButton", holder)
    btn.Name = "MB_" .. key; btn.Size = UDim2.new(1, 0, 1, 0); btn.Position = UDim2.new(0, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0); btn.BackgroundTransparency = 1; btn.BorderSizePixel = 0; btn.Text = label
    btn.TextColor3 = Color3.fromRGB(255,255,255); btn.Font = Enum.Font.GothamBold; btn.TextSize = 9; btn.TextWrapped = true
    btn.AutoButtonColor = false; btn.ZIndex = 1002; btn.Active = true
    corner(btn, 10)

    local noneBg = Instance.new("Frame", btn)
    noneBg.Name = "ButtonNoneBackground"; noneBg.Size = UDim2.new(1,0,1,0); noneBg.Position = UDim2.new(0,0,0,0)
    noneBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255); noneBg.BorderSizePixel = 0; noneBg.ZIndex = btn.ZIndex
    corner(noneBg, 10)

    local noneGrad = Instance.new("UIGradient", noneBg)
    noneGrad.Name = "ButtonNoneGradient"; noneGrad.Enabled = true; noneGrad.Rotation = 90
    noneGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(72, 72, 76)), ColorSequenceKeypoint.new(0.55, Color3.fromRGB(26, 26, 29)), ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 4, 6)),
    })

    addWhiteShimmer(btn, 10, btn.ZIndex, 2.6, 0.78)
    addGhostFX(btn, {count = 3, minSize = 8, maxSize = 12, zindex = btn.ZIndex + 20, radius = 10})

    local textOverlay = Instance.new("TextLabel", btn)
    textOverlay.Name = "MobileButtonText"; textOverlay.BackgroundTransparency = 1; textOverlay.Size = UDim2.new(1, -6, 1, -6); textOverlay.Position = UDim2.new(0, 3, 0, 3)
    textOverlay.Text = label; textOverlay.TextColor3 = Color3.fromRGB(255,255,255); textOverlay.TextStrokeColor3 = Color3.fromRGB(0,0,0); textOverlay.TextStrokeTransparency = 1
    textOverlay.Font = Enum.Font.GothamBold; textOverlay.TextSize = 9; textOverlay.TextWrapped = true; textOverlay.TextXAlignment = Enum.TextXAlignment.Center; textOverlay.TextYAlignment = Enum.TextYAlignment.Center
    textOverlay.ZIndex = btn.ZIndex + 1; btn.TextTransparency = 1

    local strokeObj = Instance.new("UIStroke", btn)
    strokeObj.Color = Color3.fromRGB(28, 28, 34); strokeObj.Thickness = 1.4; strokeObj.Transparency = 0.75; strokeObj.Enabled = true; strokeObj.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    if isToggleType and stateKey then speedButtons[stateKey] = btn end

    btn.MouseButton1Click:Connect(function()
        if isToggleType then
            if stateKey then
                if ActiveSpeedMode == stateKey then setSpeedMode("None") else setSpeedMode(stateKey) end
                if onToggle then onToggle() end
            else
                ToggleStates[key] = not ToggleStates[key]
                setActive(btn, ToggleStates[key] == true)
                if onToggle then onToggle(ToggleStates[key]) end
            end
        else
            setActive(btn, true)
            if onToggle then onToggle() end
            task.delay(0.2, function() setActive(btn, false) end)
        end
    end)

    local pressing, didDrag, pressPos, holderStart = false, false, nil, nil
    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            pressing = true; didDrag = false; pressPos = i.Position; holderStart = holder.Position
            TweenService:Create(btn, TweenInfo.new(0.08), {Position = UDim2.new(0, 0, 0, 3), Size = UDim2.new(1, 0, 1, -3)}):Play()
        end
    end)
    btn.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            pressing = false
            TweenService:Create(btn, TweenInfo.new(0.10), {Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 1, 0)}):Play()
            if didDrag then
                SavedPositions[key] = { X = holder.Position.X.Scale, XO = holder.Position.X.Offset, Y = holder.Position.Y.Scale, YO = holder.Position.Y.Offset }
                SavePositions()
            end
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not pressing then return end
        if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = i.Position - pressPos
        if math.abs(delta.X) > 6 or math.abs(delta.Y) > 6 then didDrag = true end
        if didDrag and not State.uiLocked then
            holder.Position = UDim2.new(holderStart.X.Scale, holderStart.X.Offset + delta.X, holderStart.Y.Scale, holderStart.Y.Offset + delta.Y)
        end
    end)

    setActive(btn, false)
    return btn, setActive
end

makeButton("blackhole",   "BLACK\nHOLE",  DEFAULT_POSITIONS.blackhole,   false, nil, function() task.spawn(function() usarItem(NOMBRE_BLACKHOLE) end) end)
makeButton("candysentry", "CANDY\nSENTRY", DEFAULT_POSITIONS.candysentry, false, nil, function() task.spawn(function() usarItem(NOMBRE_CANDY_SENTRY) end) end)
makeButton("sentry",      "SENTRY",        DEFAULT_POSITIONS.sentry,      false, nil, function() task.spawn(function() usarItem(NOMBRE_SENTRY) end) end)
makeButton("beehive",     "BEEHIVE",       DEFAULT_POSITIONS.beehive,     false, nil, function() task.spawn(function() usarItem(NOMBRE_BEEHIVE) end) end)
makeButton("subspace",    "SUBSPACE",      DEFAULT_POSITIONS.subspace,    false, nil, function() task.spawn(function() usarItem(NOMBRE_SUBSPACE) end) end)
makeButton("trap",        "TRAP",          DEFAULT_POSITIONS.trap,        false, nil, function() task.spawn(function() usarItem(NOMBRE_TRAP) end) end)
makeButton("boogie",      "BOOGIE",        DEFAULT_POSITIONS.boogie,      false, nil, function() task.spawn(function() usarItem(NOMBRE_BOOGIE) end) end)
makeButton("giant",       "GIANT",         DEFAULT_POSITIONS.giant,       false, nil, function() task.spawn(function() usarItem(NOMBRE_GIANT) end) end)
makeButton("drop",        "DROP",          DEFAULT_POSITIONS.drop,        false)
makeButton("autosteal",   "AUTO\nSTEAL",   DEFAULT_POSITIONS.autosteal,   true, nil, function()
    local newState = ToggleStates["autosteal"] == true
    setAutoStealState(newState)
    if autoStealToggleApi then autoStealToggleApi.setVisual(newState) end
end)
makeButton("antisentry",  "ANTI\nSENTRY",  DEFAULT_POSITIONS.antisentry,  true, nil)
makeButton("reset",       "RESET",         DEFAULT_POSITIONS.reset,       false)
makeButton("tpdown",      "TP\nDOWN",      DEFAULT_POSITIONS.tpdown,      false, nil, function()
    local char = LP.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(hrp.Position.X, -7, hrp.Position.Z) end
end)
makeButton("antitrap",    "ANTI\nTRAP",    DEFAULT_POSITIONS.antitrap,    false, nil, function()
    State.autoAntiTrapEnabled = not State.autoAntiTrapEnabled
    SaveConfig()
    if autoAntiTrapToggleApi then autoAntiTrapToggleApi.setVisual(State.autoAntiTrapEnabled) end
    if State.autoAntiTrapEnabled then startAutoAntiTrap() else stopAutoAntiTrap() end
end)
makeButton("carry",       "CARRY",         DEFAULT_POSITIONS.carry,       true, "Carry")
makeButton("custom",      "CUSTOM",        DEFAULT_POSITIONS.custom,      true, "Custom")
makeButton("lagger",      "LAGGER",        DEFAULT_POSITIONS.lagger,      true, "Lagger")

local function TriggerButtonAction(id)
    local speedMap = {["carry"] = "Carry", ["custom"] = "Custom", ["lagger"] = "Lagger"}
    if speedMap[id] then
        if ActiveSpeedMode == speedMap[id] then setSpeedMode("None") else setSpeedMode(speedMap[id]) end
    elseif id == "sentry" then task.spawn(function() usarItem(NOMBRE_SENTRY) end)
    elseif id == "beehive" then task.spawn(function() usarItem(NOMBRE_BEEHIVE) end)
    elseif id == "subspace" then task.spawn(function() usarItem(NOMBRE_SUBSPACE) end)
    elseif id == "trap" then task.spawn(function() usarItem(NOMBRE_TRAP) end)
    elseif id == "boogie" then task.spawn(function() usarItem(NOMBRE_BOOGIE) end)
    elseif id == "giant" then task.spawn(function() usarItem(NOMBRE_GIANT) end)
    elseif id == "blackhole" then task.spawn(function() usarItem(NOMBRE_BLACKHOLE) end)
    elseif id == "candysentry" then task.spawn(function() usarItem(NOMBRE_CANDY_SENTRY) end)
    elseif id == "tpdown" then
        local char = LP.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(hrp.Position.X, -7, hrp.Position.Z) end
    elseif id == "antitrap" then
        State.autoAntiTrapEnabled = not State.autoAntiTrapEnabled
        SaveConfig()
        if autoAntiTrapToggleApi then autoAntiTrapToggleApi.setVisual(State.autoAntiTrapEnabled) end
        if State.autoAntiTrapEnabled then startAutoAntiTrap() else stopAutoAntiTrap() end
    end
end

UIS.InputBegan:Connect(function(input, gp)
    if gp or not input.UserInputType == Enum.UserInputType.Keyboard then return end
    for id, key in pairs(State.keys) do
        if key == input.KeyCode then TriggerButtonAction(id); break end
    end
end)

local lastMoveDir = Vector3.zero
RunService.RenderStepped:Connect(function()
    local char = LP.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    local currentSpeed = SpeedConfig.Normal
    if ActiveSpeedMode == "Carry" then currentSpeed = SpeedConfig.Carry
    elseif ActiveSpeedMode == "Custom" then currentSpeed = SpeedConfig.Custom
    elseif ActiveSpeedMode == "Lagger" then currentSpeed = SpeedConfig.Lagger end
    local lv = hrp:FindFirstChild("MustHubVelocity")
    if not lv then
        lv = Instance.new("LinearVelocity"); lv.Name = "MustHubVelocity"; lv.MaxForce = math.huge
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane; lv.PrimaryTangentAxis = Vector3.new(1, 0, 0); lv.SecondaryTangentAxis = Vector3.new(0, 0, 1)
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        local att = Instance.new("Attachment"); att.Name = "MustHubAttachment"; att.Parent = hrp
        lv.Attachment0 = att; lv.Parent = hrp
    end
    local md = hum.MoveDirection
    if md.Magnitude > 0 then
        lastMoveDir = md; lv.PlaneVelocity = Vector2.new(md.X * currentSpeed, md.Z * currentSpeed)
    else
        local anyHeld = false
        for _, key in ipairs({Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}) do
            if UIS:IsKeyDown(key) then anyHeld = true break end
        end
        if anyHeld and lastMoveDir.Magnitude > 0 then lv.PlaneVelocity = Vector2.new(lastMoveDir.X * currentSpeed, lastMoveDir.Z * currentSpeed)
        else lv.PlaneVelocity = Vector2.zero end
    end
end)

-- ============================================================
-- KEYBINDS
-- ============================================================
local keybindsPage = pages["KEYBINDS"]
local KeybindActions = {
    {id="sentry", label="Sentry"}, {id="beehive", label="BeeHive"}, {id="subspace", label="Subspace"},
    {id="trap", label="Trap"}, {id="boogie", label="Boogie"}, {id="giant", label="Giant"},
    {id="blackhole", label="Blackhole"}, {id="candysentry", label="Candy Sentry"},
    {id="drop", label="Drop"}, {id="autosteal", label="Auto Steal"}, {id="antisentry", label="Anti Sentry"},
    {id="reset", label="Reset"}, {id="tpdown", label="TP Down"}, {id="antitrap", label="Anti Trap"},
    {id="carry", label="Carry"}, {id="custom", label="Custom"}, {id="lagger", label="Lagger"}
}
local ActiveListeningKey = nil
for i, action in ipairs(KeybindActions) do
    local row = CreateRow(keybindsPage, action.label, i)
    local keyBox = Instance.new("TextButton", row)
    keyBox.Size = UDim2.new(0, 60, 0, 22); keyBox.Position = UDim2.new(1, -70, 0.5, -11)
    keyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35); keyBox.BorderSizePixel = 0; keyBox.TextColor3 = COLORS.white
    keyBox.Font = Enum.Font.GothamBold; keyBox.TextSize = 10; keyBox.ZIndex = 6
    Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 5)
    Instance.new("UIStroke", keyBox).Color = COLORS.stroke
    local function UpdateKeyText() local k = State.keys[action.id]; keyBox.Text = k and k.Name or "None" end
    UpdateKeyText()
    keyBox.MouseButton1Click:Connect(function()
        if ActiveListeningKey then ActiveListeningKey.Text = "None" end
        ActiveListeningKey = keyBox; keyBox.Text = "..."
    end)
end
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if not ActiveListeningKey then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local keyCode = input.KeyCode
        for _, action in ipairs(KeybindActions) do
            if ActiveListeningKey.Parent:FindFirstChild("Label").Text == action.label then
                if keyCode == Enum.KeyCode.Backspace or keyCode == Enum.KeyCode.Delete then State.keys[action.id] = nil
                else State.keys[action.id] = keyCode end
                break
            end
        end
        ActiveListeningKey.Text = keyCode and keyCode.Name or "None"; ActiveListeningKey = nil; SaveConfig()
    end
end)

CreateSeparator(keybindsPage, "BUTTONS", #KeybindActions + 1)
local ButtonToggleList = {
    {id="sentry", label="Sentry"}, {id="blackhole", label="Blackhole"}, {id="candysentry", label="Candy Sentry"},
    {id="beehive", label="BeeHive"}, {id="subspace", label="Subspace"}, {id="trap", label="Trap"},
    {id="boogie", label="Boogie"}, {id="giant", label="Giant"}, {id="antisentry", label="Anti Sentry"}, {id="antitrap", label="Anti Trap"},
}
for i, item in ipairs(ButtonToggleList) do
    local isVisible = true
    if ButtonVisibility[item.id] ~= nil then isVisible = ButtonVisibility[item.id] end
    CreateToggle(keybindsPage, item.label, isVisible, #KeybindActions + 1 + i, function(state)
        ButtonVisibility[item.id] = state
        SaveVisibility()
        local kryzen = PlayerGui:FindFirstChild("KryzenButtons")
        if kryzen then
            local holder = kryzen:FindFirstChild("MBH_" .. item.id)
            if holder then holder.Visible = state end
        end
    end)
end

pages["MOVEMENT"].Visible = true; tabButtons["MOVEMENT"].TextColor3 = COLORS.white
tabButtons["MOVEMENT"].BackgroundColor3 = Color3.fromRGB(35, 35, 40)
tabButtons["MOVEMENT"]:FindFirstChildOfClass("UIStroke").Transparency = 0.2

-- ============================================================
-- DRAG DEL MAIN FRAME
-- ============================================================
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if State.uiLocked then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if input.Position.Y < Main.AbsolutePosition.Y + 50 then dragging = true; dragStart = input.Position; startPos = Main.Position end
    end
end)
UIS.InputChanged:Connect(function(input)
    if State.uiLocked then return end
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local OpenBtn = Instance.new("TextButton", Gui)
OpenBtn.Size = UDim2.new(0, 110, 0, 36); OpenBtn.Position = UDim2.new(0, 20, 0.3, -18)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25); OpenBtn.BorderSizePixel = 0; OpenBtn.Text = "MUST HUB"
OpenBtn.TextColor3 = COLORS.white; OpenBtn.Font = Enum.Font.GothamBlack; OpenBtn.TextSize = 11; OpenBtn.Visible = false; OpenBtn.ZIndex = 100
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
local openGrad = Instance.new("UIGradient", OpenBtn); openGrad.Rotation = 90
openGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 18))})
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

-- ==========================================
-- BARRA DE STEAL EXTERNA
-- ==========================================
local StealBar = (function()
    local SG = Instance.new("ScreenGui")
    SG.Name = "MustHubStealBar"
    SG.ResetOnSpawn = false
    SG.IgnoreGuiInset = true
    SG.DisplayOrder = 500
    SG.Parent = PlayerGui

    local Bar = Instance.new("Frame", SG)
    Bar.Size = UDim2.new(0, 200, 0, 46)
    Bar.Position = UDim2.new(0.5, -100, 1, -60)
    Bar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Bar.BackgroundTransparency = 0.1
    Bar.BorderSizePixel = 0
    Bar.Active = true
    Bar.ZIndex = 300
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", Bar).Color = Color3.fromRGB(60, 60, 70)

    local bg = Instance.new("ImageLabel", Bar)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.Position = UDim2.new(0, 0, 0, 0)
    bg.BackgroundTransparency = 1
    bg.Image = "rbxassetid://111623129376390"
    bg.ScaleType = Enum.ScaleType.Crop
    bg.ImageTransparency = 0.35
    bg.ZIndex = 299
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)

    local pct = Instance.new("TextLabel", Bar)
    pct.Size = UDim2.new(0.4, 0, 0, 22)
    pct.Position = UDim2.new(0, 12, 0, 5)
    pct.BackgroundTransparency = 1
    pct.Text = "0%"
    pct.TextColor3 = Color3.new(1, 1, 1)
    pct.Font = Enum.Font.GothamBlack
    pct.TextSize = 14
    pct.TextXAlignment = Enum.TextXAlignment.Left
    pct.ZIndex = 301

    local rad = Instance.new("TextLabel", Bar)
    rad.Size = UDim2.new(0.58, 0, 0, 22)
    rad.Position = UDim2.new(0.42, 0, 0, 5)
    rad.BackgroundTransparency = 1
    rad.Text = "Radius: --"
    rad.TextColor3 = Color3.new(1, 1, 1)
    rad.Font = Enum.Font.GothamBold
    rad.TextSize = 12
    rad.TextXAlignment = Enum.TextXAlignment.Right
    rad.ZIndex = 301

    local fps = Instance.new("TextLabel", Bar)
    fps.Size = UDim2.new(0.5, 0, 0, 14)
    fps.Position = UDim2.new(0, 12, 0, 24)
    fps.BackgroundTransparency = 1
    fps.Text = "FPS: --"
    fps.TextColor3 = Color3.new(1, 1, 1)
    fps.Font = Enum.Font.GothamBold
    fps.TextSize = 11
    fps.TextXAlignment = Enum.TextXAlignment.Left
    fps.ZIndex = 301

    local ping = Instance.new("TextLabel", Bar)
    ping.Size = UDim2.new(0.5, -14, 0, 14)
    ping.Position = UDim2.new(0.5, 0, 0, 24)
    ping.BackgroundTransparency = 1
    ping.Text = "PING: --"
    ping.TextColor3 = Color3.new(1, 1, 1)
    ping.Font = Enum.Font.GothamBold
    ping.TextSize = 11
    ping.TextXAlignment = Enum.TextXAlignment.Right
    ping.ZIndex = 301

    local track = Instance.new("Frame", Bar)
    track.Size = UDim2.new(1, -20, 0, 2)
    track.Position = UDim2.new(0, 10, 1, -8)
    track.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
    track.BorderSizePixel = 0
    track.ZIndex = 301
    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 2)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(210, 210, 225)
    fill.BorderSizePixel = 0
    fill.ZIndex = 302
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 2)

    progressFill = fill
    progressPct = pct
    progressRadLbl = rad

    local dg, ds, dp = false, nil, nil
    Bar.InputBegan:Connect(function(i)
        if State.uiLocked then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dg = true; ds = i.Position; dp = Bar.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dg = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if not dg then return end
        if State.uiLocked then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            local d = i.Position - ds
            Bar.Position = UDim2.new(dp.X.Scale, dp.X.Offset + d.X, dp.Y.Scale, dp.Y.Offset + d.Y)
        end
    end)

    local ft, fc = tick(), 0
    RunService.RenderStepped:Connect(function()
        fc = fc + 1
        if tick() - ft >= 0.5 then
            fps.Text = "FPS: " .. math.round(fc / (tick() - ft))
            fc = 0; ft = tick()
            pcall(function() ping.Text = "PING: " .. math.round(LP:GetNetworkPing() * 1000) .. "ms" end)
        end
    end)

    task.spawn(function()
        while task.wait(1) do
            pcall(function() rad.Text = "Radius: " .. tostring(Steal.StealRadius) end)
        end
    end)

    local Api = {}
    function Api.setProgress(v, dur)
        v = math.clamp(v, 0, 1)
        TweenService:Create(fill, TweenInfo.new(dur or 0.3), {Size = UDim2.new(v, 0, 1, 0)}):Play()
        pct.Text = math.floor(v * 100) .. "%"
    end
    function Api.setVisible(v) Bar.Visible = v end
    function Api.setRadius(t) rad.Text = "Radius: " .. tostring(t) end
    return Api
end)()

_G.MustHubStealBar = StealBar

-- ==========================================
-- TP PANEL
-- ==========================================
local TPPanelGui = nil
local TPState = { base=nil, pet=nil, delayBase=0.15, delayPet=0.15, key=Enum.KeyCode.X, isTping=false, locked=false, minimized=false }
local savedPosX = 15; local savedPosY = 150
local CONFIG_FILE = "CalzoskyTp_Config.json"
local BG_IMAGE_3 = "rbxassetid://120846140387092"

pcall(function()
    if isfile and isfile(CONFIG_FILE) and readfile then
        local ok, cfg = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
        if ok and cfg then
            TPState.delayBase = tonumber(cfg.delayBase) or 0.15
            TPState.delayPet = tonumber(cfg.delayPet) or 0.15
            if cfg.key and Enum.KeyCode[cfg.key] then TPState.key = Enum.KeyCode[cfg.key] end
            TPState.minimized = cfg.minimized == true
            TPState.locked = cfg.locked == true
            if type(cfg.posX) == "number" then savedPosX = cfg.posX end
            if type(cfg.posY) == "number" then savedPosY = cfg.posY end
        end
    end
end)
local function _tpSaveCfg()
    local data = { delayBase = TPState.delayBase, delayPet = TPState.delayPet, key = TPState.key.Name, minimized = TPState.minimized, locked = TPState.locked, posX = savedPosX, posY = savedPosY }
    pcall(function() if writefile then writefile(CONFIG_FILE, HttpService:JSONEncode(data)) end end)
end
local TPMarkBase, TPMarkPet = nil, nil
local function _tpCreateMarker(pos, col)
    local p = Instance.new("Part"); p.Name = "CalzoskyTP_Marker"; p.Shape = Enum.PartType.Cylinder; p.Size = Vector3.new(0.35, 4, 4)
    p.CFrame = CFrame.new(pos + Vector3.new(0, 0.2, 0)) * CFrame.Angles(0, 0, math.rad(90)); p.Anchored = true; p.CanCollide = false
    p.Material = Enum.Material.Neon; p.Color = col; p.Transparency = 0.15; p.Parent = workspace
    local light = Instance.new("PointLight", p); light.Color = col; light.Brightness = 2; light.Range = 10
    return p
end
local function clearMarkersOnExit()
    if TPMarkBase then TPMarkBase:Destroy(); TPMarkBase = nil end
    if TPMarkPet then TPMarkPet:Destroy(); TPMarkPet = nil end
    TPState.base = nil; TPState.pet = nil
end
LP.CharacterRemoving:Connect(clearMarkersOnExit)
LP.AncestryChanged:Connect(function() if not LP:IsDescendantOf(game) then clearMarkersOnExit() end end)
LP.CharacterAdded:Connect(function(char) local hum = char:WaitForChild("Humanoid", 5); if hum then hum.Died:Connect(clearMarkersOnExit) end end)
local function _tpEquipFly(char)
    char = char or LP.Character; local hum = char and char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    for _, n in ipairs({"Flying Carpet", "Carpet", "Witch's Broom", "Cloud"}) do
        local t = char:FindFirstChild(n) or LP.Backpack:FindFirstChild(n)
        if t and t:IsA("Tool") then pcall(function() hum:EquipTool(t) end); return end
    end
end
local function _tpSmooth(hrp, pos)
    if not hrp or not pos then return end
    pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero; hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0)) end)
end
local function _tpChilli(hrp, targetPos, char)
    if not hrp or not targetPos then return end
    char = char or LP.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum or hum.Health <= 0 then return end
    pcall(function() hum.Health = hum.MaxHealth end); _tpEquipFly(char); task.wait(0.02)
    local t0 = tick(); while tick() - t0 < 0.08 do
        if not hrp or not hrp.Parent then return end
        pcall(function() local v = hrp.AssemblyLinearVelocity; hrp.AssemblyLinearVelocity = Vector3.new(v.X, 180, v.Z) end)
        RunService.Heartbeat:Wait()
    end
    local airY = targetPos.Y + 16
    pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero; hrp.CFrame = CFrame.new(targetPos.X, airY, targetPos.Z); hrp.AssemblyLinearVelocity = Vector3.new(0, -200, 0) end)
    local landY = targetPos.Y
    pcall(function()
        local rp = RaycastParams.new(); rp.FilterDescendantsInstances = {char}; rp.FilterType = Enum.RaycastFilterType.Exclude
        local hit = workspace:Raycast(Vector3.new(targetPos.X, airY + 5, targetPos.Z), Vector3.new(0, -400, 0), rp)
        if hit then landY = hit.Position.Y + (hum.HipHeight or 2) + (hrp.Size.Y / 2) end
    end)
    local landPos = Vector3.new(targetPos.X, landY, targetPos.Z); local fallT = tick()
    while tick() - fallT < 0.10 do
        if not hrp or not hrp.Parent or hrp.Position.Y <= landY + 6 then break end
        pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(0, -220, 0) end); RunService.Heartbeat:Wait()
    end
    pcall(function()
        hrp.CFrame = CFrame.new(landPos); hrp.AssemblyLinearVelocity = Vector3.zero; hrp.AssemblyAngularVelocity = Vector3.zero
        hum.Sit = false; hum.PlatformStand = false; hum.AutoRotate = true; hum.Health = hum.MaxHealth; hum:ChangeState(Enum.HumanoidStateType.Running)
    end)
end
_G.CalzoskySaveTPBase = function()
    local h = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not h then return end
    if TPMarkBase then TPMarkBase:Destroy(); TPMarkBase = nil end
    TPState.base = h.Position; TPMarkBase = _tpCreateMarker(TPState.base, Color3.fromRGB(255, 105, 180))
end
_G.CalzoskySaveTPPet = function()
    local h = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not h then return end
    if TPMarkPet then TPMarkPet:Destroy(); TPMarkPet = nil end
    TPState.pet = h.Position; TPMarkPet = _tpCreateMarker(TPState.pet, Color3.fromRGB(255, 140, 0))
end
_G.CalzoskyRunPanelTP = function()
    if TPState.isTping then return end
    if not TPState.base and not TPState.pet then return end
    task.spawn(function()
        local c0 = LP.Character; local hrp = c0 and c0:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        TPState.isTping = true
        pcall(function()
            if (TPState.base and not TPState.pet) or (TPState.pet and not TPState.base) then _tpChilli(hrp, TPState.base or TPState.pet, c0)
            else
                _tpEquipFly(c0); _tpSmooth(hrp, TPState.base); task.wait(tonumber(TPState.delayBase) or 0.15)
                c0 = LP.Character or c0; hrp = c0 and c0:FindFirstChild("HumanoidRootPart") or hrp
                if hrp and TPState.pet then _tpSmooth(hrp, TPState.pet) end
            end
        end)
        TPState.isTping = false
    end)
end

local function OpenTPPanel()
    if TPPanelGui then TPPanelGui:Destroy() end
    local guiTP = Instance.new("ScreenGui"); guiTP.Name = "CalzoskyTpGui"; guiTP.ResetOnSpawn = false; guiTP.IgnoreGuiInset = true; guiTP.DisplayOrder = 80; guiTP.Parent = PlayerGui; TPPanelGui = guiTP
    local mainF = Instance.new("Frame", guiTP); mainF.Size = UDim2.new(0, 220, 0, 230); mainF.Position = UDim2.new(0, savedPosX, 0, savedPosY)
    mainF.BackgroundColor3 = Color3.fromRGB(14, 14, 20); mainF.BackgroundTransparency = 0.1; mainF.BorderSizePixel = 0; mainF.Active = true; mainF.ClipsDescendants = true; mainF.ZIndex = 10
    Instance.new("UICorner", mainF).CornerRadius = UDim.new(0, 10)
    local bgTP = Instance.new("ImageLabel", mainF); bgTP.Size = UDim2.new(1, 0, 1, 0); bgTP.BackgroundTransparency = 1; bgTP.Image = BG_IMAGE_3; bgTP.ScaleType = Enum.ScaleType.Crop; bgTP.ZIndex = 1
    Instance.new("UICorner", bgTP).CornerRadius = UDim.new(0, 10)
    local bgDark = Instance.new("Frame", mainF); bgDark.Size = UDim2.new(1, 0, 1, 0); bgDark.BackgroundColor3 = Color3.fromRGB(0, 0, 0); bgDark.BackgroundTransparency = 0.8; bgDark.BorderSizePixel = 0; bgDark.ZIndex = 2
    Instance.new("UICorner", bgDark).CornerRadius = UDim.new(0, 10)
    local ROW, PAD = 26, 6
    local function y(i) return 4 + (i - 1) * (ROW + 4) end
    local function applyNeonRedStyle(btn)
        btn.BackgroundTransparency = 1; btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0); btn.TextColor3 = Color3.new(1, 1, 1); btn.ZIndex = 15
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        local st = Instance.new("UIStroke", btn); st.Color = Color3.fromRGB(255, 0, 0); st.Thickness = 2
    end
    local lockBtn = Instance.new("TextButton", mainF); lockBtn.Size = UDim2.new(0, 30, 0, 20); lockBtn.Position = UDim2.new(0, PAD, 0, y(1))
    lockBtn.Text = TPState.locked and "🔒" or "🔓"; lockBtn.Font = Enum.Font.GothamBold; lockBtn.TextSize = 14; applyNeonRedStyle(lockBtn)
    local title = Instance.new("TextLabel", mainF); title.Size = UDim2.new(1, -160, 0, 20); title.Position = UDim2.new(0, 40, 0, y(1)); title.BackgroundTransparency = 1
    title.Text = "MUST TP"; title.TextColor3 = Color3.fromRGB(255, 0, 0); title.Font = Enum.Font.GothamBlack; title.TextSize = 12; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 15
    local closeBtnTP = Instance.new("TextButton", mainF); closeBtnTP.Size = UDim2.new(0, 22, 0, 20); closeBtnTP.Position = UDim2.new(1, -28, 0, y(1))
    closeBtnTP.Text = TPState.minimized and "+" or "−"; closeBtnTP.Font = Enum.Font.GothamBold; closeBtnTP.TextSize = 14; applyNeonRedStyle(closeBtnTP)
    local body = Instance.new("Frame", mainF); body.Size = UDim2.new(1, -12, 0, 160); body.Position = UDim2.new(0, PAD, 0, y(2)); body.BackgroundTransparency = 1; body.Visible = not TPState.minimized; body.ZIndex = 15
    local function mkBtnTP(text, row, col)
        local b = Instance.new("TextButton", body); b.Size = UDim2.new(1, 0, 0, ROW); b.Position = UDim2.new(0, 0, 0, (row - 1) * (ROW + 4))
        b.BackgroundColor3 = col; b.Text = text; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; b.TextSize = 10; b.ZIndex = 15
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6); return b
    end
    local function mkLabelTP(text, row)
        local l = Instance.new("TextLabel", body); l.Size = UDim2.new(1, -50, 0, ROW); l.Position = UDim2.new(0, 0, 0, (row - 1) * (ROW + 4))
        l.BackgroundTransparency = 1; l.Text = text; l.TextColor3 = Color3.fromRGB(220, 220, 240); l.Font = Enum.Font.Gotham; l.TextSize = 9; l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 15
        return l
    end
    local btnSaveBase = mkBtnTP("Save Base", 1, Color3.fromRGB(110, 70, 190))
    local btnSavePet = mkBtnTP("Save Pet", 2, Color3.fromRGB(210, 110, 40))
    local lblBase = mkLabelTP("Base: " .. string.format("%.2f", TPState.delayBase) .. "s", 3)
    local lblPet = mkLabelTP("Pet: " .. string.format("%.2f", TPState.delayPet) .. "s", 4)
    local function mkAdjTP(row, onMinus, onPlus)
        for i, s in ipairs({"-", "+"}) do
            local b = Instance.new("TextButton", body); b.Size = UDim2.new(0, 22, 0, 22)
            b.Position = UDim2.new(1, -48 + (i - 1) * 24, 0, (row - 1) * (ROW + 4) + 2)
            b.Text = s; b.Font = Enum.Font.GothamBold; b.TextSize = 12; applyNeonRedStyle(b)
            b.MouseButton1Click:Connect(s == "-" and onMinus or onPlus)
        end
    end
    mkAdjTP(3, function() TPState.delayBase = math.clamp(TPState.delayBase - 0.01, 0.01, 2); lblBase.Text = "Base: " .. string.format("%.2f", TPState.delayBase) .. "s"; _tpSaveCfg() end, function() TPState.delayBase = math.clamp(TPState.delayBase + 0.01, 0.01, 2); lblBase.Text = "Base: " .. string.format("%.2f", TPState.delayBase) .. "s"; _tpSaveCfg() end)
    mkAdjTP(4, function() TPState.delayPet = math.clamp(TPState.delayPet - 0.01, 0.01, 2); lblPet.Text = "Pet: " .. string.format("%.2f", TPState.delayPet) .. "s"; _tpSaveCfg() end, function() TPState.delayPet = math.clamp(TPState.delayPet + 0.01, 0.01, 2); lblPet.Text = "Pet: " .. string.format("%.2f", TPState.delayPet) .. "s"; _tpSaveCfg() end)
    local btnKeyTP = mkBtnTP("KEY: [" .. TPState.key.Name .. "]", 5, Color3.fromRGB(45, 45, 60))
    local settingKey = false
    btnKeyTP.MouseButton1Click:Connect(function() settingKey = true; btnKeyTP.Text = "Press a key..." end)
    local btnTp = Instance.new("TextButton", mainF); btnTp.Size = UDim2.new(0, 80, 0, 26); btnTp.Position = UDim2.new(0.5, -40, 1, -32); btnTp.Text = "TP [" .. TPState.key.Name .. "]"
    btnTp.Font = Enum.Font.GothamBlack; btnTp.TextSize = 12; applyNeonRedStyle(btnTp)
    if TPState.minimized then
        mainF.Size = UDim2.new(0, 190, 0, 70); btnTp.Position = UDim2.new(0, PAD, 0, 32); btnTp.Size = UDim2.new(1, -12, 0, 26); body.Visible = false
    end
    btnSaveBase.MouseButton1Click:Connect(function() _G.CalzoskySaveTPBase(); btnSaveBase.Text = "Saved"; task.delay(0.7, function() btnSaveBase.Text = "Save Base" end) end)
    btnSavePet.MouseButton1Click:Connect(function() _G.CalzoskySaveTPPet(); btnSavePet.Text = "Saved"; task.delay(0.7, function() btnSavePet.Text = "Save Pet" end) end)
    btnTp.MouseButton1Click:Connect(function() if not TPState.isTping and not settingKey then _G.CalzoskyRunPanelTP() end end)
    lockBtn.MouseButton1Click:Connect(function() TPState.locked = not TPState.locked; lockBtn.Text = TPState.locked and "🔒" or "🔓"; _tpSaveCfg() end)
    closeBtnTP.MouseButton1Click:Connect(function()
        TPState.minimized = not TPState.minimized; body.Visible = not TPState.minimized
        if TPState.minimized then TweenService:Create(mainF, TweenInfo.new(0.25), {Size = UDim2.new(0, 190, 0, 70)}):Play(); btnTp.Position = UDim2.new(0, PAD, 0, 32); btnTp.Size = UDim2.new(1, -12, 0, 26); closeBtnTP.Text = "+"
        else TweenService:Create(mainF, TweenInfo.new(0.25), {Size = UDim2.new(0, 220, 0, 230)}):Play(); btnTp.Position = UDim2.new(0.5, -40, 1, -32); btnTp.Size = UDim2.new(0, 80, 0, 26); closeBtnTP.Text = "−" end
        _tpSaveCfg()
    end)
    local draggingTP, dragStartTP, startPosTP
    mainF.InputBegan:Connect(function(input)
        if TPState.locked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingTP = true; dragStartTP = input.Position; startPosTP = mainF.Position end
    end)
    UIS.InputChanged:Connect(function(input)
        if not draggingTP or TPState.locked then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - dragStartTP; local newX = startPosTP.X.Offset + d.X; local newY = startPosTP.Y.Offset + d.Y
            local viewport = workspace.CurrentCamera.ViewportSize; local menuSize = mainF.AbsoluteSize
            newX = math.clamp(newX, 0, viewport.X - menuSize.X); newY = math.clamp(newY, 0, viewport.Y - menuSize.Y)
            mainF.Position = UDim2.new(0, newX, 0, newY); savedPosX = newX; savedPosY = newY
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then if draggingTP then draggingTP = false; _tpSaveCfg() end end
    end)
    UIS.InputBegan:Connect(function(input, gp)
        if gp then return end
        if settingKey and input.UserInputType == Enum.UserInputType.Keyboard then
            TPState.key = input.KeyCode; settingKey = false; btnKeyTP.Text = "KEY: [" .. TPState.key.Name .. "]"; btnTp.Text = "TP [" .. TPState.key.Name .. "]"; _tpSaveCfg(); return
        end
        if input.KeyCode == TPState.key then _G.CalzoskyRunPanelTP() end
    end)
end

CreateToggle(pages["PANELS"], "TP Panel", State.tpPanelEnabled, 1, function(state)
    State.tpPanelEnabled = state; SaveConfig()
    if state then OpenTPPanel() else if TPPanelGui then TPPanelGui:Destroy(); TPPanelGui = nil end end
end)

if State.tpPanelEnabled then task.defer(function() OpenTPPanel() end) end
if State.ragdollTimerEnabled then task.defer(function() startRagTimerDetection() end) end
if State.autoAntiTrapEnabled then task.defer(function() startAutoAntiTrap() end) end
if State.trapESPEnabled then task.defer(function() startTrapESP() end) end
if State.autoStealEnabled then
    task.defer(function()
        setAutoStealState(true)
        if autoStealToggleApi then autoStealToggleApi.setVisual(true) end
    end)
end

-- ============================================================
-- SECCIÓN ANTI (antis ZENONETOP — solo auto-save, sin auto-activar)
-- ============================================================

-- ---------- Anti Gummy / Boogie ----------
if not _G._ZenoAntiFXLoaded then
    _G._ZenoAntiFXLoaded = true
    task.spawn(function()
        local Lighting = game:GetService("Lighting")

        local function ResetTool(Char)
            if not Char then Char = LP.Character end
            if not Char then return end
            pcall(function()
                LP:SetAttribute("BlockTools", false)
                LP:SetAttribute("Web", false)
                Char:SetAttribute("BackpackReady", true)
            end)
        end

        local function ClearBoogieEffect()
            if not ZenoAnti.boogie then return end
            for _, V in pairs(Lighting:GetChildren()) do
                if V.Name == "DiscoEffect" then
                    pcall(function() V:Destroy() end)
                end
            end
            local Ctrl = ReplicatedStorage:FindFirstChild("Controllers")
            if Ctrl then
                local BC = Ctrl:FindFirstChild("BoogieBombController")
                if BC then
                    local B = BC:FindFirstChild("BOOM")
                    if B then pcall(function() B:Stop() end) end
                end
            end
        end

        RunService.Heartbeat:Connect(function()
            if ZenoAnti.gummy then pcall(ResetTool) end
            if ZenoAnti.boogie then pcall(ClearBoogieEffect) end
        end)

        pcall(function()
            Lighting.ChildAdded:Connect(function(child)
                if not child then return end
                if ZenoAnti.boogie and child.Name == "DiscoEffect" then
                    task.defer(function() pcall(function() child:Destroy() end) end)
                end
            end)
        end)

        LP.CharacterAdded:Connect(function(char)
            task.defer(function() pcall(ResetTool, char) end)
        end)
    end)
end

-- ---------- Anti Paintball ----------
if not _G._ZenoAntiPaintLoaded then
    _G._ZenoAntiPaintLoaded = true
    task.spawn(function()
        local function getMainHudGui()
            local pg = LP:FindFirstChild("PlayerGui")
            return pg and pg:FindFirstChild("Main")
        end
        local function isPaintballSplatGui(gui)
            if not gui or gui.Parent ~= getMainHudGui() then return false end
            if not (gui:IsA("ImageLabel") or gui:IsA("ImageButton")) then return false end
            if gui:GetAttribute("__ZenoPaintballIgnore") or gui:GetAttribute("__ZenoPaintballShrunk") then return false end
            return math.abs(gui.Rotation) > 0.01
        end
        local function shrinkPaintballSplat(gui)
            if not gui or gui:GetAttribute("__ZenoPaintballShrunk") then return end
            gui:SetAttribute("__ZenoPaintballShrunk", true)
            gui.Size = UDim2.fromOffset(6, 6)
        end
        local function sweep()
            if not ZenoAnti.paint then return end
            local main = getMainHudGui()
            if not main then return end
            for _, c in ipairs(main:GetChildren()) do
                if isPaintballSplatGui(c) then
                    pcall(shrinkPaintballSplat, c)
                end
            end
        end
        task.spawn(function()
            while true do
                task.wait(0.25)
                pcall(sweep)
            end
        end)
        pcall(function()
            local function hookMain(main)
                if not main or main:GetAttribute("_ZenoPaintHooked") then return end
                main:SetAttribute("_ZenoPaintHooked", true)
                main.ChildAdded:Connect(function(c)
                    task.defer(function()
                        if ZenoAnti.paint and isPaintballSplatGui(c) then
                            pcall(shrinkPaintballSplat, c)
                        end
                    end)
                end)
            end
            local pg = LP:FindFirstChild("PlayerGui")
            if pg then
                hookMain(pg:FindFirstChild("Main"))
                pg.ChildAdded:Connect(function(ch)
                    if ch.Name == "Main" then
                        task.defer(function() hookMain(ch) end)
                    end
                end)
            end
        end)
    end)
end

-- ---------- Anti Kick ----------
if not _G._ZenoAntiKickLoaded then
    _G._ZenoAntiKickLoaded = true
    pcall(function()
        if hookmetamethod and not _G._ZenoAntiKickHooked then
            _G._ZenoAntiKickHooked = true
            local old
            old = hookmetamethod(game, "__namecall", function(self, ...)
                local method = (getnamecallmethod and getnamecallmethod()) or ""
                if tostring(method) == "Kick" then
                    if self == LP or (typeof(self) == "Instance" and self:IsA("Player") and self == LP) then
                        return
                    end
                end
                return old(self, ...)
            end)
        end
    end)
    pcall(function()
        if hookfunction and not _G._ZenoKickFnHooked then
            _G._ZenoKickFnHooked = true
            local oldKick = LP.Kick
            if typeof(oldKick) == "function" then
                hookfunction(oldKick, function(self, ...) return end)
            end
        end
    end)
end

-- ---------- Anti Ragdoll (V1 Splatter / V2 No Splatter) ----------
local _zenoAntiRagConn = nil
local _zenoAntiRagCooldown = 0

local function zenoForceNoSplatterReset()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
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
        workspace.CurrentCamera.CameraSubject = hum
        local PM = LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("PlayerModule")
        if PM then
            local ok, CM = pcall(function() return require(PM:FindFirstChild("ControlModule")) end)
            if ok and CM and CM.Enable then pcall(function() CM:Enable() end) end
        end
        hum.AutoRotate = true
        hum.PlatformStand = false
        hum.Sit = false
    end)
end

local function zenoStartAntiRagdoll()
    if _zenoAntiRagConn then return end
    _zenoAntiRagConn = RunService.Heartbeat:Connect(function()
        if not ZenoAnti.ragdoll then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health <= 0 then return end
        local state = hum:GetState()
        local ragdolled = (state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown)
        local mode = tostring(ZenoAnti.ragdollMode or "V1"):upper()

        if mode == "V2" or mode == "NO SPLATTER" then
            if ragdolled then
                local now = tick()
                if now - (_zenoAntiRagCooldown or 0) > 0.15 then
                    _zenoAntiRagCooldown = now
                    zenoForceNoSplatterReset()
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
            pcall(function()
                LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
            end)
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("BallSocketConstraint") or
                   (d:IsA("Attachment") and tostring(d.Name):find("RagdollAttachment")) then
                    d:Destroy()
                end
            end
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled == false then
                    obj.Enabled = true
                end
            end
            if hum.Health > 0 then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            pcall(function() workspace.CurrentCamera.CameraSubject = hum end)
            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

local function zenoStopAntiRagdoll()
    if _zenoAntiRagConn then
        pcall(function() _zenoAntiRagConn:Disconnect() end)
        _zenoAntiRagConn = nil
    end
    _zenoAntiRagCooldown = 0
end

-- ---------- Anti Bee & Disco ----------
local AntiBeeDisco = {
    enabled = false,
    connections = {},
    originalMoveFunction = nil,
    controlsProtected = false,
    badLightingNames = {
        Blue = true,
        DiscoEffect = true,
        BeeBlur = true,
        ColorCorrection = true,
        Blur = true,
    }
}

local function ab_removeBadLighting(obj)
    if not obj or not obj.Parent then return end
    if AntiBeeDisco.badLightingNames[obj.Name] then
        pcall(function() obj:Destroy() end)
        return
    end
    if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or
       obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or
       obj:IsA("DepthOfFieldEffect") or obj:IsA("Atmosphere") then
        pcall(function() obj:Destroy() end)
        return
    end
    if obj.Name and type(obj.Name) == "string" then
        local nameLower = string.lower(obj.Name)
        if nameLower:find("disco") or nameLower:find("bee") or nameLower:find("blur") then
            pcall(function() obj:Destroy() end)
        end
    end
end

local function ab_blockBeeSound()
    pcall(function()
        local playerScripts = LP:FindFirstChild("PlayerScripts")
        if playerScripts then
            local bee = playerScripts:FindFirstChild("Bee", true)
            if bee then
                local buzzing = bee:FindFirstChild("Buzzing")
                if buzzing and buzzing:IsA("Sound") then
                    buzzing:Stop()
                    buzzing.Volume = 0
                end
            end
        end
        for _, sound in ipairs(workspace:GetDescendants()) do
            if sound:IsA("Sound") and sound.Name and type(sound.Name) == "string" then
                local nameLower = string.lower(sound.Name)
                if nameLower:find("bee") or nameLower:find("buzz") then
                    sound:Stop()
                    sound.Volume = 0
                end
            end
        end
    end)
end

local function ab_protectControls()
    if AntiBeeDisco.controlsProtected then return end
    pcall(function()
        local playerScripts = LP:FindFirstChild("PlayerScripts")
        if not playerScripts then return end
        local playerModule = playerScripts:FindFirstChild("PlayerModule")
        if not playerModule then return end
        local controls = require(playerModule):GetControls()
        if not controls then return end
        if not AntiBeeDisco.originalMoveFunction then
            AntiBeeDisco.originalMoveFunction = controls.moveFunction
        end
        local function protectedMoveFunction(moveVector, cameraCFrame, isJumping)
            if AntiBeeDisco.originalMoveFunction then
                AntiBeeDisco.originalMoveFunction(moveVector, cameraCFrame, isJumping)
            end
        end
        table.insert(AntiBeeDisco.connections, RunService.Heartbeat:Connect(function()
            if not AntiBeeDisco.enabled then return end
            local now = os.clock()
            if now - (controls._lastProtectTick or 0) < 0.2 then return end
            controls._lastProtectTick = now
            if controls.moveFunction ~= protectedMoveFunction then
                controls.moveFunction = protectedMoveFunction
            end
        end))
        controls.moveFunction = protectedMoveFunction
        AntiBeeDisco.controlsProtected = true
    end)
end

local function ab_restoreControls()
    if not AntiBeeDisco.controlsProtected then return end
    pcall(function()
        local playerScripts = LP:FindFirstChild("PlayerScripts")
        if not playerScripts then return end
        local playerModule = playerScripts:FindFirstChild("PlayerModule")
        if not playerModule then return end
        local controls = require(playerModule):GetControls()
        if controls and AntiBeeDisco.originalMoveFunction then
            controls.moveFunction = AntiBeeDisco.originalMoveFunction
            AntiBeeDisco.controlsProtected = false
        end
    end)
end

local function ab_removeDiscoEffects()
    pcall(function()
        local lighting = game:GetService("Lighting")
        for _, child in ipairs(lighting:GetChildren()) do
            ab_removeBadLighting(child)
        end
        for _, child in ipairs(workspace:GetDescendants()) do
            if child:IsA("BasePart") and child.Name and type(child.Name) == "string" then
                local nameLower = string.lower(child.Name)
                if nameLower:find("disco") or nameLower:find("bee") or
                   nameLower:find("blue") or nameLower:find("flash") then
                    pcall(function()
                        child.Transparency = 1
                        child.CanCollide = false
                    end)
                end
            end
            if child:IsA("ParticleEmitter") and child.Name and type(child.Name) == "string" then
                local nameLower = string.lower(child.Name)
                if nameLower:find("disco") or nameLower:find("bee") or
                   nameLower:find("spark") or nameLower:find("flash") then
                    pcall(function() child.Enabled = false end)
                end
            end
        end
    end)
end

local function ab_removeBeeBlocks()
    pcall(function()
        for _, child in ipairs(workspace:GetDescendants()) do
            if child:IsA("BasePart") and child.Name and type(child.Name) == "string" then
                local nameLower = string.lower(child.Name)
                if nameLower:find("bee") or nameLower:find("honey") or
                   nameLower:find("crystal") or nameLower:find("glace") or
                   (nameLower:find("glass") and child.Material == Enum.Material.Glass) then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end)
end

local function ab_fixFOV()
    pcall(function()
        local camera = workspace.CurrentCamera
        if camera then
            if not camera:GetAttribute("OriginalFOV") then
                camera:SetAttribute("OriginalFOV", camera.FieldOfView)
            end
            local original = camera:GetAttribute("OriginalFOV") or 70
            if camera.FieldOfView ~= original then
                camera.FieldOfView = original
            end
        end
    end)
end

local function ab_enable()
    if AntiBeeDisco.enabled then return end
    AntiBeeDisco.enabled = true
    ab_removeDiscoEffects()
    ab_removeBeeBlocks()
    ab_blockBeeSound()
    ab_fixFOV()
    ab_protectControls()

    local lighting = game:GetService("Lighting")
    table.insert(AntiBeeDisco.connections, lighting.DescendantAdded:Connect(function(obj)
        if AntiBeeDisco.enabled then
            ab_removeBadLighting(obj)
        end
    end))

    local lastBuzzCheck = 0
    table.insert(AntiBeeDisco.connections, RunService.Heartbeat:Connect(function()
        if not AntiBeeDisco.enabled then return end
        local now = os.clock()
        if now - lastBuzzCheck < 0.5 then return end
        lastBuzzCheck = now
        ab_blockBeeSound()
        ab_removeDiscoEffects()
        ab_removeBeeBlocks()
        ab_fixFOV()
    end))

    table.insert(AntiBeeDisco.connections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        if AntiBeeDisco.enabled then ab_fixFOV() end
    end))

    table.insert(AntiBeeDisco.connections, LP.CharacterAdded:Connect(function()
        if AntiBeeDisco.enabled then
            task.wait(0.5)
            ab_protectControls()
            ab_removeDiscoEffects()
            ab_removeBeeBlocks()
        end
    end))
end

local function ab_disable()
    if not AntiBeeDisco.enabled then return end
    AntiBeeDisco.enabled = false
    for _, conn in ipairs(AntiBeeDisco.connections) do
        pcall(function() conn:Disconnect() end)
    end
    AntiBeeDisco.connections = {}
    ab_restoreControls()
end

local function ab_setEnabled(on)
    if on then ab_enable() else ab_disable() end
    ZenoAnti.bee = on and true or false
end

-- ============================================================
-- SECCIÓN ANTI EN COMBAT
-- ============================================================
CreateSeparator(pages["COMBAT"], "ANTI", 10)

local zenoAntiGummyToggle = CreateToggle(pages["COMBAT"], "ANTI GUMMY", ZenoAnti.gummy, 11, function(state)
    ZenoAnti.gummy = state
    SaveConfig()
end)

local zenoAntiBoogieToggle = CreateToggle(pages["COMBAT"], "ANTI BOOGIE", ZenoAnti.boogie, 12, function(state)
    ZenoAnti.boogie = state
    SaveConfig()
end)

local zenoAntiPaintToggle = CreateToggle(pages["COMBAT"], "ANTI PAINTBALL", ZenoAnti.paint, 13, function(state)
    ZenoAnti.paint = state
    SaveConfig()
end)

local zenoAntiBeeToggle = CreateToggle(pages["COMBAT"], "ANTI BEE", ZenoAnti.bee, 14, function(state)
    ab_setEnabled(state)
    SaveConfig()
end)

-- ANTI KICK (toggle, ya no forzado ON)
local zenoAntiKickToggle = CreateToggle(pages["COMBAT"], "ANTI KICK", ZenoAnti.kick, 15, function(state)
    ZenoAnti.kick = state
    SaveConfig()
end)

-- ANTI RAGDOLL: toggle + selector V1/V2 al lado
local zenoAntiRagToggle = nil
do
    local row = CreateRow(pages["COMBAT"], "ANTI RAGDOLL", 16)
    local lbl = row:FindFirstChild("Label")
    if lbl then
        lbl.Text = "ANTI RAGDOLL"
        lbl.Size = UDim2.new(1, -140, 1, 0)
    end

    local holder = Instance.new("Frame", row)
    holder.Size = UDim2.new(0, 70, 0, 22)
    holder.Position = UDim2.new(1, -122, 0.5, -11)
    holder.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    holder.BorderSizePixel = 0
    holder.ZIndex = 5
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 6)

    local b1 = Instance.new("TextButton", holder)
    b1.Size = UDim2.new(0.5, 0, 1, 0)
    b1.BackgroundColor3 = (ZenoAnti.ragdollMode == "V1") and COLORS.white or Color3.fromRGB(40, 40, 45)
    b1.Text = "V1"
    b1.TextColor3 = (ZenoAnti.ragdollMode == "V1") and Color3.fromRGB(20, 20, 20) or COLORS.white
    b1.Font = Enum.Font.GothamBold
    b1.TextSize = 10
    b1.ZIndex = 6
    Instance.new("UICorner", b1).CornerRadius = UDim.new(0, 6)

    local b2 = Instance.new("TextButton", holder)
    b2.Size = UDim2.new(0.5, 0, 1, 0)
    b2.Position = UDim2.new(0.5, 0, 0, 0)
    b2.BackgroundColor3 = (ZenoAnti.ragdollMode == "V2") and COLORS.white or Color3.fromRGB(40, 40, 45)
    b2.Text = "V2"
    b2.TextColor3 = (ZenoAnti.ragdollMode == "V2") and Color3.fromRGB(20, 20, 20) or COLORS.white
    b2.Font = Enum.Font.GothamBold
    b2.TextSize = 10
    b2.ZIndex = 6
    Instance.new("UICorner", b2).CornerRadius = UDim.new(0, 6)

    local function setMode(mode)
        ZenoAnti.ragdollMode = mode
        b1.BackgroundColor3 = (mode == "V1") and COLORS.white or Color3.fromRGB(40, 40, 45)
        b1.TextColor3 = (mode == "V1") and Color3.fromRGB(20, 20, 20) or COLORS.white
        b2.BackgroundColor3 = (mode == "V2") and COLORS.white or Color3.fromRGB(40, 40, 45)
        b2.TextColor3 = (mode == "V2") and Color3.fromRGB(20, 20, 20) or COLORS.white
        SaveConfig()
    end
    b1.MouseButton1Click:Connect(function() setMode("V1") end)
    b2.MouseButton1Click:Connect(function() setMode("V2") end)

    local track = Instance.new("Frame", row)
    track.Name = "Track"
    track.BackgroundColor3 = ZenoAnti.ragdoll and COLORS.knob or COLORS.toggleBg
    track.Size = UDim2.new(0, 32, 0, 16)
    track.Position = UDim2.new(1, -44, 0.5, -8)
    track.BorderSizePixel = 0
    track.ZIndex = 5
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local st = Instance.new("UIStroke", track)
    st.Color = ZenoAnti.ragdoll and COLORS.white or COLORS.stroke
    st.Thickness = 1
    st.Transparency = 0.3
    local knob = Instance.new("Frame", track)
    knob.Name = "Knob"
    knob.BackgroundColor3 = ZenoAnti.ragdoll and Color3.fromRGB(20, 20, 20) or COLORS.knob
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = ZenoAnti.ragdoll and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    knob.BorderSizePixel = 0
    knob.ZIndex = 6
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local click = Instance.new("TextButton", row)
    click.Size = UDim2.new(0, 44, 1, 0)
    click.Position = UDim2.new(1, -44, 0, 0)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.ZIndex = 7
    local state = ZenoAnti.ragdoll
    click.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(track, TweenInfo.new(0.15), {BackgroundColor3 = state and COLORS.knob or COLORS.toggleBg}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
            BackgroundColor3 = state and Color3.fromRGB(20, 20, 20) or COLORS.knob
        }):Play()
        TweenService:Create(st, TweenInfo.new(0.15), {Color = state and COLORS.white or COLORS.stroke}):Play()
        ZenoAnti.ragdoll = state
        if state then zenoStartAntiRagdoll() else zenoStopAntiRagdoll() end
        SaveConfig()
    end)
    zenoAntiRagToggle = { setVisual = function(v)
        state = v
        TweenService:Create(track, TweenInfo.new(0.15), {BackgroundColor3 = state and COLORS.knob or COLORS.toggleBg}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
            BackgroundColor3 = state and Color3.fromRGB(20, 20, 20) or COLORS.knob
        }):Play()
        TweenService:Create(st, TweenInfo.new(0.15), {Color = state and COLORS.white or COLORS.stroke}):Play()
    end }
end

-- Restaurar antis SOLO si estaban guardados como ON
if ZenoAnti.ragdoll then task.defer(zenoStartAntiRagdoll) end
if ZenoAnti.bee then task.defer(ab_enable) end

print("¡Must Hub cargado! + Antis ZENONETOP (Gummy/Boogie/Paintball/Bee/Kick/Ragdoll)")