-- Configuration globale par défaut orientée performance
if _G.StickyFrontTP == nil then _G.StickyFrontTP = false end
if _G.StickySideTP == nil then _G.StickySideTP = true end
if _G.StickySideTPRange == nil then _G.StickySideTPRange = 100 end
if _G.StickyCFrameGoTo == nil then _G.StickyCFrameGoTo = true end
_G.StickyNoCollide = true
if _G.StickyNoCollideConstraints == nil then _G.StickyNoCollideConstraints = true end
_G.StickyCFrameGoSpeed = tonumber(_G.StickyCFrameGoSpeed) or 35
if _G.StickyTPTrail == nil then _G.StickyTPTrail = false end
if _G.StickyHybridTP == nil then _G.StickyHybridTP = false end
_G._stp_tpKeyName = _G._stp_tpKeyName or "T"

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local RS         = game:GetService("ReplicatedStorage")
local TS         = game:GetService("TweenService")
local LP         = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- Optimisations de performances réseau et Luau
pcall(function() if setfpscap then setfpscap(9999) end end)
_G.StickyScanMode = "fast"
_G.StickyAutoTPPoll = 0.03

-- Chargement des modules de données du jeu
local AnimalsData, AnimalsShared
local function loadModules()
    if AnimalsData then return true end
    pcall(function()
        local Datas = RS:FindFirstChild("Datas") or RS:WaitForChild("Datas", 1.5)
        if Datas then
            local a = Datas:FindFirstChild("Animals") or Datas:WaitForChild("Animals", 1.5)
            if a then AnimalsData = require(a) end
        end
    end)
    return AnimalsData ~= nil
end

-- Synchroniseur pour récupérer les données des parcelles (Plots)
local _xchan2, _nextTry2 = nil, 0
local function _chans()
    local now = os.clock()
    if now < _nextTry2 and _xchan2 then return _xchan2 end
    pcall(function()
        local gc = getgc(true)
        for i = 1, #gc do
            local t = gc[i]
            if type(t) == "table" and rawget(t, "CacheTable") then
                _xchan2 = t
                break
            end
        end
    end)
    _nextTry2 = now + 0.1
    return _xchan2
end

local function getPlotChannel(plotName)
    local t = _chans()
    return t and t[plotName]
end

local function channelGet(channel, key)
    if not channel then return nil end
    local ct = rawget(channel, "CacheTable")
    if type(ct) == "table" and rawget(ct, key) ~= nil then return rawget(ct, key) end
    return nil
end

-- Algorithme de détection du MEILLEUR Brain rot (Max MPS)
local function scanForTP()
    local pets = {}
    if not loadModules() then return pets end
    local Plots = workspace:FindFirstChild("Plots")
    if not Plots then return pets end

    for _, plot in ipairs(Plots:GetChildren()) do
        local channel = getPlotChannel(plot.Name)
        if channel then
            local owner = channelGet(channel, "Owner")
            if owner and owner ~= LP.Name then
                local animalList = channelGet(channel, "AnimalList")
                if type(animalList) == "table" then
                    for slot, animalData in pairs(animalList) do
                        if type(animalData) == "table" and not animalData.conveyor then
                            local animalName = animalData.Index
                            local genValue = animalData.Generation or 0
                            
                            -- Fallback sur l'affichage visuel si la valeur n'est pas dans le flux réseau
                            if genValue == 0 then
                                local podiums = plot:FindFirstChild("AnimalPodiums")
                                local podium = podiums and podiums:FindFirstChild(tostring(slot))
                                if podium then
                                    for _, child in ipairs(podium:GetDescendants()) do
                                        if child:IsA("TextLabel") and child.Text:find("%/s") then
                                            local num, suf = child.Text:match("%$%s*([%d%.]+)%s*([KMBTQ]?)")
                                            if num then
                                                local mult = {K=1e3, M=1e6, B=1e9, T=1e12, Q=1e15}
                                                genValue = tonumber(num) * (mult[suf] or 1)
                                            end
                                        end
                                    end
                                end
                            end

                            -- Localisation visuelle de l'entité
                            local pos = nil
                            local podiums = plot:FindFirstChild("AnimalPodiums")
                            local podium = podiums and podiums:FindFirstChild(tostring(slot))
                            if podium then pos = podium:GetPivot().Position end

                            if pos and genValue > 0 then
                                table.insert(pets, {
                                    name = animalName,
                                    mps = genValue,
                                    position = pos,
                                    plot = plot.Name,
                                    slot = tostring(slot)
                                })
                            end
                        end
                    end
                end
            end
        end
    end

    -- Tri par MPS décroissant (Le premier élément de la liste = le meilleur)
    table.sort(pets, function(a, b) return a.mps > b.mps end)
    return pets
end

-- Noyaux de Téléportations (Fling / CFrame / Instant)
local function setFlightVel(hrp, vel)
    if hrp and _G.Sticky_FlingTp == true and vel.Magnitude > 5 then
        local now = os.clock()
        hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, (now * 12) % (math.pi * 2), 0)
    end
    if hrp then hrp.AssemblyLinearVelocity = vel end
end

local function velMoveThrough(hrp, targetPos, speed)
    local runSpeed = speed or _G.TPVelocity or 400
    local done = false
    local conn
    
    conn = RunService.Heartbeat:Connect(function()
        if not hrp or not hrp.Parent or done then conn:Disconnect() return end
        local diff = targetPos - hrp.Position
        if diff.Magnitude < 4 then
            hrp.CFrame = CFrame.new(targetPos)
            done = true
            conn:Disconnect()
            return
        end
        setFlightVel(hrp, diff.Unit * runSpeed)
    end)
    
    while not done do task.wait() end
end

local isTeleporting = false
local function goToBrainrot(petPos, slot)
    if not petPos or isTeleporting then return end
    isTeleporting = true
    
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then isTeleporting = false return end

    -- Utilisation des outils de vol (Carpet/Waverider) configurés
    pcall(function()
        local tool = LP.Backpack:FindFirstChild(_G.StickyCarpetTool or "Waverider") or char:FindFirstChild(_G.StickyCarpetTool or "Waverider")
        if tool and tool.Parent ~= char then char:FindFirstChildOfClass("Humanoid"):EquipTool(tool) end
    end)

    local targetY = petPos.Y - 4
    local _to = Vector3.new(petPos.X, targetY, petPos.Z)

    if _G.StickyInstaTpBrainrot == true then
        -- Instant TP
        hrp.CFrame = CFrame.new(_to)
        hrp.AssemblyLinearVelocity = Vector3.zero
    else
        -- Velocity / Hybrid TP basé sur la vitesse configurée
        local currentSpeed = _G.StickyHybridTP and (_G.TPVelocity or 400) * 0.75 or (_G.TPVelocity or 400)
        velMoveThrough(hrp, _to, currentSpeed)
    end

    isTeleporting = false
end

local function teleportToBest()
    local targets = scanForTP()
    if #targets > 0 then
        local best = targets[1]
        goToBrainrot(best.position, best.slot)
    end
end

-- Système Auto-TP en boucle de fond
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.StickyAutoTP == true and not isTeleporting then
            pcall(teleportToBest)
        end
    end
end)

-- INTERFACE GRAPHIQUE (UI COMPACTE NETTOYÉE)
local host = (gethui and gethui()) or game:GetService("CoreGui")
pcall(function() if host:FindFirstChild("StickyTPMinimal") then host.StickyTPMinimal:Destroy() end end)

local sg = Instance.new("ScreenGui", host)
sg.Name = "StickyTPMinimal"
sg.ResetOnSpawn = false
sg.Enabled = true

local root = Instance.new("Frame", sg)
root.Size = UDim2.fromOffset(250, 260)
root.Position = UDim2.fromOffset(50, 150)
root.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", root).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", root)
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Thickness = 1

-- Header Draggable
local header = Instance.new("Frame", root)
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -10, 1, 0)
title.Position = UDim2.fromOffset(10, 0)
title.Text = "TELEPORT SYSTEM"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 11
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

-- Drag Logic
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = root.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
Instance.new("UICorner", actionBtn).CornerRadius = UDim.new(0, 5)
actionBtn.MouseButton1Click:Connect(function() pcall(teleportToBest) end)

-- Keybind d'exécution (T par défaut)
UIS.InputBegan:Connect(function(input, gp)
if gp then return end
if input.KeyCode.Name == (_G._stp_tpKeyName or "T") then
pcall(teleportToBest)
end
end)