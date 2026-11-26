local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local HttpService       = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting          = game:GetService("Lighting")

local LP = Players.LocalPlayer

local SAVE_FILE = "Vx7Hub.json"

local saveSettings, loadSettings

local AntiBeeDisco = {
    running = false,
    connections = {},
    badLightingNames = { Blue = true, DiscoEffect = true, BeeBlur = true, ColorCorrection = true },
}

AntiBeeDisco.nuke = function(obj)
    if not obj or not obj.Parent then return end
    if AntiBeeDisco.badLightingNames[obj.Name] then
        pcall(function() obj:Destroy() end)
    end
end

AntiBeeDisco.disconnectAll = function()
    for _, conn in ipairs(AntiBeeDisco.connections) do
        if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
    end
    AntiBeeDisco.connections = {}
end

AntiBeeDisco.protectControls = function()
end

AntiBeeDisco.restoreControls = function()
end

AntiBeeDisco.blockBuzzingSound = function()
    pcall(function()
        local beeScript = LP.PlayerScripts:FindFirstChild("Bee", true)
        if beeScript then
            local buzzing = beeScript:FindFirstChild("Buzzing")
            if buzzing and buzzing:IsA("Sound") then
                buzzing:Stop()
                buzzing.Volume = 0
            end
        end
    end)
end

AntiBeeDisco.Enable = function()
    if AntiBeeDisco.running then return end
    AntiBeeDisco.running = true
    for _, inst in ipairs(Lighting:GetDescendants()) do
        AntiBeeDisco.nuke(inst)
    end
    table.insert(AntiBeeDisco.connections, Lighting.DescendantAdded:Connect(function(obj)
        if not AntiBeeDisco.running then return end
        AntiBeeDisco.nuke(obj)
    end))
    AntiBeeDisco.protectControls()
    table.insert(AntiBeeDisco.connections, RunService.Heartbeat:Connect(function()
        if not AntiBeeDisco.running then return end
        AntiBeeDisco.blockBuzzingSound()
    end))
end

AntiBeeDisco.Disable = function()
    if not AntiBeeDisco.running then return end
    AntiBeeDisco.running = false
    AntiBeeDisco.restoreControls()
    AntiBeeDisco.disconnectAll()
end

local State = {
    antiSentryEnabled  = false,
    aldEnabled         = false,
    silentAimEnabled   = false,
    spamPaint          = false,
    spamLaser          = false,
    counterLaser       = false,
    mineESPEnabled     = false,
    antiBeeDisco       = false,
}

local Keybinds = {
    tpBest        = Enum.KeyCode.Unknown,
    antiSentry    = Enum.KeyCode.Unknown,
    ald           = Enum.KeyCode.Unknown,
    silentAim     = Enum.KeyCode.Unknown,
    spamPaint     = Enum.KeyCode.Unknown,
    spamLaser     = Enum.KeyCode.Unknown,
    counterLaser  = Enum.KeyCode.Unknown,
}

local _keyLabelRefs = {}
local _toggleSetFns = {}

local frame           = nil
local miniPill        = nil
local pendingFramePos = nil
local pendingPillPos  = nil
local pillPlaced      = false
local lastLiveSave    = 0

local function getChar()  return LP.Character end
local function getHum()   local c=getChar(); return c and c:FindFirstChildOfClass("Humanoid") end
local function getHRP()   local c=getChar(); return c and c:FindFirstChild("HumanoidRootPart") end

local cachedMouse   = nil

pcall(function()
    local pkg = ReplicatedStorage:WaitForChild("Packages", 5)
    local pm = pkg and pkg:FindFirstChild("PlayerMouse")
    if pm then cachedMouse = require(pm) end
end)

local SAB = { hooked = setmetatable({}, { __mode = "k" }), watched = setmetatable({}, { __mode = "k" }), conns = {}, lastPre = 0, pre = nil, loopOn = false }

local function saBestEnemy()
    local char = getChar()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local cam = workspace.CurrentCamera
    if not root or not cam then return nil end
    local best, score = nil, math.huge
    local camPos, camDir = cam.CFrame.Position, cam.CFrame.LookVector
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local r = plr.Character:FindFirstChild("HumanoidRootPart")
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health > 0 then
                local d = (r.Position - root.Position).Magnitude
                if d <= 100 then
                    local to = r.Position - camPos
                    if to.Magnitude > 0.01 then
                        local ang = math.deg(math.acos(math.clamp(camDir:Dot(to.Unit), -1, 1)))
                        local sc = d + (ang > 200 and 1000 or 0)
                        if sc < score then score, best = sc, r end
                    end
                end
            end
        end
    end
    return best
end

local function saOverrideMouse()
    if not State.silentAimEnabled then return end
    local pm = cachedMouse
    if not pm then return end
    local e = nil
    if SAB.pre and SAB.pre.Parent and tick() - SAB.lastPre < 0.15 then
        e = SAB.pre
    else
        e = saBestEnemy()
    end
    if e and e.Parent then
        local vel = e.AssemblyLinearVelocity or Vector3.zero
        pcall(function()
            pm.Hit = CFrame.new(e.Position + vel * 0.1)
            pm.Target = e
        end)
    end
end

local function saHookTool(tool)
    if not tool or SAB.hooked[tool] then return end
    SAB.hooked[tool] = true
    table.insert(SAB.conns, tool.Activated:Connect(saOverrideMouse))
    table.insert(SAB.conns, tool.Equipped:Connect(function()
        task.wait(0.1)
        local pm = cachedMouse
        if pm and State.silentAimEnabled then
            local old = pm.Button1Down
            pm.Button1Down = function(...)
                saOverrideMouse()
                if old then return old(...) end
            end
        end
    end))
end

local function saWatch(parent)
    if not parent or SAB.watched[parent] then return end
    SAB.watched[parent] = true
    for _, c in ipairs(parent:GetChildren()) do
        if c:IsA("Tool") and (c.Name == "Laser Cape" or c.Name == "Web Slinger" or c.Name == "Paintball Gun") then
            saHookTool(c)
        end
    end
    table.insert(SAB.conns, parent.ChildAdded:Connect(function(c)
        task.wait(0.05)
        if c:IsA("Tool") and (c.Name == "Laser Cape" or c.Name == "Web Slinger" or c.Name == "Paintball Gun") then
            saHookTool(c)
        end
    end))
end

local function saEnsureLoop()
    if SAB.loopOn then return end
    SAB.loopOn = true
    RunService.RenderStepped:Connect(function()
        if not State.silentAimEnabled then return end
        if tick() - SAB.lastPre > 0.1 then
            SAB.lastPre = tick()
            SAB.pre = saBestEnemy()
        end
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            saOverrideMouse()
        end
    end)
end

local function saCleanupTools()
    for _, c in pairs(SAB.conns) do pcall(function() c:Disconnect() end) end
    SAB.conns = {}
    SAB.hooked = setmetatable({}, { __mode = "k" })
    SAB.watched = setmetatable({}, { __mode = "k" })
end

local function saSetupTools()
    saCleanupTools()
    if not State.silentAimEnabled then return end
    local char = getChar()
    if char then pcall(saWatch, char) end
    pcall(saWatch, LP:FindFirstChildOfClass("Backpack"))
    saEnsureLoop()
end

local spamPaintConn = nil
local spamLaserConn = nil

local function startSpamPaint()
    if spamPaintConn then return end
    local lastFire = 0
    spamPaintConn = RunService.Heartbeat:Connect(function()
        if not State.spamPaint then return end
        local now = tick()
        if now - lastFire < 0.15 then return end
        lastFire = now
        local char = getChar()
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and tool.Name == "Paintball Gun" then
            pcall(function() tool:Activate() end)
        end
    end)
end

local function stopSpamPaint()
    if spamPaintConn then spamPaintConn:Disconnect(); spamPaintConn = nil end
end

local function startSpamLaser()
    if spamLaserConn then return end
    spamLaserConn = RunService.Heartbeat:Connect(function()
        if not State.spamLaser then return end
        local char = getChar()
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and tool.Name == "Laser Cape" then
            pcall(function() tool:Activate() end)
        end
    end)
end

local function stopSpamLaser()
    if spamLaserConn then spamLaserConn:Disconnect(); spamLaserConn = nil end
end


local COUNTER_TOOL_NAMES = {
    laser  = { "Laser Cape", "LaserCape", "laser cape" },
}

local function findCounterTool(names)
    local char = getChar()
    local bp = LP:FindFirstChildOfClass("Backpack")
    for _, nm in ipairs(names) do
        if char then
            local t = char:FindFirstChild(nm)
            if t and t:IsA("Tool") then return t end
        end
        if bp then
            local t = bp:FindFirstChild(nm)
            if t and t:IsA("Tool") then return t end
        end
    end
    return nil
end

local counterConn = nil
local counterWasStealing = false
local counterHitsLeft = 0
local COUNTER_HIT_DELAY = 0

local function startCounter()
    if counterConn then return end
    counterWasStealing = false
    counterHitsLeft = 0
    counterConn = RunService.Heartbeat:Connect(function()
        if not State.counterLaser then return end
        local char = getChar()
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local isStealing = LP:GetAttribute("Stealing") == true
        if isStealing then
            counterWasStealing = true
            counterHitsLeft = 0
            return
        end
        if counterWasStealing and not isStealing then
            counterWasStealing = false
            counterHitsLeft = 2
        end
        if counterHitsLeft > 0 then
            local tool = findCounterTool(COUNTER_TOOL_NAMES.laser)
            if tool and tool.Parent ~= char then
                pcall(function() hum:EquipTool(tool) end)
            end
            if tool then
                counterHitsLeft = counterHitsLeft - 1
                pcall(function() tool:Activate() end)
                if counterHitsLeft <= 0 then
                    task.delay(0.1, function()
                        if hum and hum.Parent then pcall(function() hum:UnequipTools() end) end
                    end)
                end
            end
        end
    end)
end

local function stopCounter()
    if counterConn then counterConn:Disconnect(); counterConn = nil end
    counterWasStealing = false
    counterHitsLeft = 0
end

local function setCounter(which)
    State.counterLaser = (which == "laser")
    if State.counterLaser then
        startCounter()
    else
        stopCounter()
        local char = getChar()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:UnequipTools() end) end
    end
    saveSettings()
end

local _tpBestActive = false
local _tpCancel     = false

local function bpParseValue(text)
    text = tostring(text or ""):gsub("%s","")
    local num, suffix = text:match("([%d%.]+)([KkMmBbTt]?)")
    if not num then return 0 end
    num = tonumber(num) or 0
    local m = {K=1e3,M=1e6,B=1e9,T=1e12}
    return num * (m[(suffix or ""):upper()] or 1)
end


local function getPlotOwner_TP(plot)
    local ok, owner = pcall(function()
        local sign = plot:FindFirstChild("PlotSign")
        local sg = sign and sign:FindFirstChild("SurfaceGui")
        local fr = sg and sg:FindFirstChild("Frame")
        local label = fr and fr:FindFirstChild("TextLabel")
        if not label or label.Text == "Empty Base" then return nil end
        return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
    end)
    if ok then return owner end
    return nil
end

local function isOwnPlotByOwner_TP(plot)
    local owner = getPlotOwner_TP(plot)
    if not owner then return false end
    return owner == LP.DisplayName or owner == LP.Name
end

local _saTP = nil
local function getSharedAnimals_TP()
    if not _saTP then
        pcall(function() _saTP = require(ReplicatedStorage.Shared.Animals) end)
    end
    return _saTP
end

local _ownPlotTP = nil
local function getOwnPlotTP()
    if _ownPlotTP and _ownPlotTP.Parent then return _ownPlotTP end
    _ownPlotTP = nil
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        if isOwnPlotByOwner_TP(plot) then
            _ownPlotTP = plot
            return _ownPlotTP
        end
    end
    return nil
end


local tpBestCache = { pos = nil, name = nil, plot = nil, gen = -1, t = 0 }

local function tpFindAnimalPos(plotName, animalName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local function modelPos(m)
        local ok, pp = pcall(function()
            if m.PrimaryPart then return m.PrimaryPart.Position end
            local b = m:FindFirstChildWhichIsA("BasePart", true)
            if b then return b.Position end
            return m:GetPivot().Position
        end)
        if ok then return pp end
        return nil
    end
    local plot = plots:FindFirstChild(plotName)
    if plot then
        for _, d in ipairs(plot:GetDescendants()) do
            if d:IsA("Model") and d.Name == animalName then
                local pos = modelPos(d)
                if pos then return pos end
            end
        end
    end
    for _, d in ipairs(plots:GetDescendants()) do
        if d:IsA("Model") and d.Name == animalName then
            local okA, pn = pcall(function() return d:GetAttribute("PlotName") end)
            if okA and pn == plotName then
                local pos = modelPos(d)
                if pos then return pos end
            end
        end
    end
    return nil
end

local _tpRefreshing = false
local function tpRefreshBest()
    if _tpRefreshing then return end
    _tpRefreshing = true
    task.spawn(function()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then _tpRefreshing = false return end
        local syncFolder = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Synchronizer")
        local requestData = syncFolder and syncFolder:FindFirstChild("RequestData")
        if not requestData then _tpRefreshing = false return end

        local infos = {}
        for _, plot in ipairs(plots:GetChildren()) do
            local owner = getPlotOwner_TP(plot)
            if not owner then continue end
            if owner == LP.DisplayName or owner == LP.Name then continue end
            local plr = nil
            for _, p in ipairs(Players:GetPlayers()) do
                if p.DisplayName == owner then plr = p break end
            end
            if not plr or plr == LP then continue end
            table.insert(infos, { name = plot.Name, owner = owner, plr = plr })
        end

        local results, done = {}, 0
        for i, inf in ipairs(infos) do
            task.spawn(function()
                local ok, data = pcall(function() return requestData:InvokeServer(inf.name) end)
                results[i] = { ok = ok, data = data, info = inf }
                done += 1
            end)
        end
        local t0 = tick()
        while done < #infos and tick() - t0 < 8 do task.wait() end
        local gBest, gGen, gPlot = nil, -1, nil
        local sa = getSharedAnimals_TP()
        for _, r in ipairs(results) do
            if not r or not r.ok or type(r.data) ~= "table" then continue end
            local al = r.data.AnimalList
            if type(al) ~= "table" then continue end
            for _, ad in pairs(al) do
                if type(ad) ~= "table" or not ad.Index then continue end
                local mut = (ad.Mutation and ad.Mutation ~= "" and ad.Mutation ~= "None") and ad.Mutation or nil
                local tier = nil
                if type(ad.Tier) == "string" and ad.Tier ~= "" then tier = ad.Tier
                elseif type(ad.Traits) == "table" then tier = ad.Traits[1]
                elseif type(ad.Trait) == "string" and ad.Trait ~= "" then tier = ad.Trait end
                local gen = 0
                if sa and sa.CalculateGeneration then
                    local ok2, v = pcall(function() return sa:CalculateGeneration(ad.Index, mut, tier) end)
                    if ok2 and v then gen = v end
                end
                if gen > gGen then
                    gGen = gen
                    gBest = ad.Index
                    gPlot = r.info.name
                end
            end
        end
        if gBest and gPlot then
            local pos = tpFindAnimalPos(gPlot, gBest)
            if pos then
                tpBestCache.pos = pos
                tpBestCache.name = gBest
                tpBestCache.plot = gPlot
                tpBestCache.gen = gGen
                tpBestCache.t = tick()
            end
        end
        _tpRefreshing = false
    end)
end


task.spawn(function()
    task.wait(1)
    tpRefreshBest()
    while true do
        task.wait(4)
        pcall(tpRefreshBest)
    end
end)
pcall(function()
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        local lastTrig = 0
        plots.DescendantAdded:Connect(function()
            if tick() - lastTrig > 3 then
                lastTrig = tick()
                task.spawn(function() task.wait(1) pcall(tpRefreshBest) end)
            end
        end)
    end
end)

local function scanBestPet()

    if tpBestCache.pos and tick() - tpBestCache.t < 30 then
        return tpBestCache.pos
    end

    local ownPlot = getOwnPlotTP()
    local debris = workspace:FindFirstChild("Debris")
    if not debris then return nil end
    local best = { value = -1, pos = nil }
    for _, tmpl in ipairs(debris:GetChildren()) do
        if tmpl.Name == "FastOverheadTemplate" then
            local sg = tmpl:FindFirstChildOfClass("SurfaceGui")
            if sg then
                local gen = sg:FindFirstChild("Generation", true)
                if gen and gen:IsA("TextLabel") then
                    local txt = gen.Text or ""
                    if txt ~= "" and (txt:find("/s") or txt:find("K") or txt:find("M") or txt:find("B") or txt:find("T")) then
                        local val = bpParseValue(txt)
                        if val > best.value then
                            local ap = sg.Adornee
                            if ap and ap:IsA("BasePart") then

                                local skip = false
                                if ownPlot then
                                    local ok, res = pcall(function() return ap:IsDescendantOf(ownPlot) end)
                                    if ok and res then skip = true end
                                end
                                if not skip then
                                    best.value = val
                                    best.pos   = ap.Position
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return best.pos
end


local TP_SPEED = 230
local ARRIVE = 3
local MAX_CLIMB = 60


local isEnabled = false
local customSpeed = 45
pcall(function()
    local c = LP.Character
    if not c then return end
    local r = c:WaitForChild("HumanoidRootPart", 5)
    if r then
        attachment = Instance.new("Attachment")
        attachment.Name = "MineESP_Attachment"
        attachment.Parent = r
        linearVelocity = Instance.new("LinearVelocity")
        linearVelocity.Name = "MineESP_LinearVelocity"
        linearVelocity.Attachment0 = attachment

        linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
        linearVelocity.PrimaryTangentAxis = Vector3.new(1,0,0)
        linearVelocity.SecondaryTangentAxis = Vector3.new(0,0,1)
        linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
        linearVelocity.MaxForce = 90000
        linearVelocity.VectorVelocity = Vector3.zero
        linearVelocity.Parent = r
    end
end)






local function spoofedVZero()
    if linearVelocity then
        pcall(function()
            linearVelocity.PlaneVelocity = Vector2.zero
            linearVelocity.VectorVelocity = Vector3.zero
            linearVelocity.MaxForce = 0
        end)
    end
    local r = getHRP and getHRP() or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
    if r then pcall(function() r.AssemblyLinearVelocity = Vector3.zero r.AssemblyAngularVelocity = Vector3.zero end) end
end


do
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    RunService.RenderStepped:Connect(function()
        if not root or not root.Parent or not hum or not hum.Parent then return end
        if not customSpeed then customSpeed = 45 end
        if not isEnabled then
            if linearVelocity then
                linearVelocity.MaxForce = 0
                pcall(function()
                    linearVelocity.PlaneVelocity = Vector2.zero
                    linearVelocity.VectorVelocity = Vector3.zero
                end)
            end
            return
        end
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0.1 then
            if linearVelocity then linearVelocity.MaxForce = math.max(5000, customSpeed * 150) end
            if linearVelocity and linearVelocity.Parent == root then

                linearVelocity.Enabled = true
                linearVelocity.PlaneVelocity = Vector2.new(moveDir.X * customSpeed, moveDir.Z * customSpeed)
            end
        else

            if linearVelocity then
                linearVelocity.MaxForce = 0
                pcall(function()
                    linearVelocity.PlaneVelocity = Vector2.zero
                    linearVelocity.VectorVelocity = Vector3.zero
                end)
            end
        end
    end)
    LP.CharacterAdded:Connect(function(newChar)
        char = newChar
        root = char:WaitForChild("HumanoidRootPart")
        hum = char:WaitForChild("Humanoid")
        pcall(function() if attachment then attachment:Destroy() end if linearVelocity then linearVelocity:Destroy() end end)
        attachment = Instance.new("Attachment")
        attachment.Name = "MineESP_Attachment"
        attachment.Parent = root
        linearVelocity = Instance.new("LinearVelocity")
        linearVelocity.Name = "MineESP_LinearVelocity"
        linearVelocity.Attachment0 = attachment
        linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
        linearVelocity.PrimaryTangentAxis = Vector3.new(1,0,0)
        linearVelocity.SecondaryTangentAxis = Vector3.new(0,0,1)
        linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
        linearVelocity.MaxForce = isEnabled and 90000 or 0
        linearVelocity.VectorVelocity = Vector3.zero
        linearVelocity.Parent = root
    end)
end


local CARPET_NAMES = { "Flying Carpet", "Carpet", "Cloud", "Witch's Broom", "Cupid's Wings", "Santa's Sleigh", "Magic Carpet", "Waverider" }
local GRAPPLE_NAMES = { "Grapple Hook", "Grappling Hook", "Grapple", "Hook", "Web Slinger", "Grapple Gun", "GrappleHook" }

local function findTool(name)
    if not LP then return nil end
    local char = getChar()
    local bp = LP:FindFirstChild("Backpack")
    if char then
        local t = char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    if bp then
        local t = bp:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    return nil
end

local function findAnyTool()
    if not LP then return nil end
    local char = getChar()
    local bp = LP:FindFirstChild("Backpack")
    if char then
        for _, c in ipairs(char:GetChildren()) do
            if c:IsA("Tool") then return c end
        end
    end
    if bp then
        for _, c in ipairs(bp:GetChildren()) do
            if c:IsA("Tool") then return c end
        end
    end
    return nil
end

local function equipCarpet()
    if not LP then return nil end
    local char = getChar()
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    for _, n in ipairs(CARPET_NAMES) do
        local t = findTool(n)
        if t and t:IsA("Tool") then
            if t.Parent ~= char then pcall(function() hum:EquipTool(t) end) end
            return n
        end
    end
    local t = findAnyTool()
    if t and t:IsA("Tool") then
        if t.Parent ~= char then pcall(function() hum:EquipTool(t) end) end
        return t.Name
    end
    return nil
end

local function fireGrapple(destino)
    if not LP then return end
    local char = getChar(); if not char then return end
    local bp = LP:FindFirstChildOfClass("Backpack")
    local tool = nil
    for _, n in ipairs(GRAPPLE_NAMES) do
        tool = char:FindFirstChild(n) or (bp and bp:FindFirstChild(n))
        if tool then break end
    end
    if not tool then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if tool.Parent ~= char then
        pcall(function() hum:EquipTool(tool) end)
        task.wait(0.05)
    end
    pcall(function() tool:Activate() end)
end

local _DIRS = { Vector3.new(1,0,0), Vector3.new(-1,0,0), Vector3.new(0,0,1), Vector3.new(0,0,-1) }
local _SKIP_NAME = {
    ["DeliveryHitbox"]=true, ["StealHitbox"]=true, ["LaserHitbox"]=true,
    ["AnimalTarget"]=true, ["Multiplier"]=true, ["Laser"]=true, ["Hitbox"]=true,
    ["Spawn"]=true, ["MainRoot"]=true, ["SecondFloor"]=true, ["ThirdFloor"]=true, ["Slope"]=true
}

local function _blocks(inst)
    if not inst then return false end
    if _SKIP_NAME[inst.Name] then return false end
    if inst.CanCollide then return true end
    local s = inst.Size
    if s and math.max(s.X * s.Y, s.X * s.Z, s.Y * s.Z) > 150 then return true end
    return false
end

local function _block(origin, target)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    local o = origin
    for _ = 1, 16 do
        rp.FilterDescendantsInstances = skip
        local d = target - o
        if d.Magnitude < 0.05 then return nil end
        local res = workspace:Raycast(o, d, rp)
        if not res then return nil end
        if _blocks(res.Instance) then return res end
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

local function _clearWide(a, b)
    if not _clear(a, b) then return false end
    local d = Vector3.new(b.X - a.X, 0, b.Z - a.Z)
    if d.Magnitude < 0.1 then return true end
    local p = Vector3.new(-d.Z, 0, d.X).Unit * 6
    return _clear(a + p, b + p) and _clear(a - p, b - p)
end

local function _pullWide(pts)
    if #pts <= 2 then return pts end
    local out = { pts[1] }
    local i = 1
    while i < #pts do
        local j = #pts
        while j > i + 1 and not _clearWide(out[#out], pts[j]) do j = j - 1 end
        out[#out + 1] = pts[j]
        i = j
    end
    return out
end

local PathfindingService = game:GetService("PathfindingService")

local function computeRoute(fromPos, toPos, facingDir)
    if _clear(fromPos, toPos) then return { toPos } end
    local entry = facingDir and (toPos - facingDir * 14) or toPos
    local groundTo = Vector3.new(entry.X, fromPos.Y, entry.Z)
    local path = PathfindingService:CreatePath({
        AgentRadius = 8, AgentHeight = 5, AgentCanJump = true, AgentJumpHeight = 10, AgentMaxSlope = 89,
    })
    local FLOAT = 3
    local nav = { fromPos }
    local ok = pcall(function()
        path:ComputeAsync(Vector3.new(fromPos.X, fromPos.Y, fromPos.Z), groundTo)
    end)
    if ok and path.Status == Enum.PathStatus.Success then
        local last = fromPos
        for _, wp in ipairs(path:GetWaypoints()) do
            if (wp.Position - last).Magnitude >= 8 then
                nav[#nav + 1] = wp.Position + Vector3.new(0, FLOAT, 0)
                last = wp.Position
            end
        end
    end
    nav[#nav + 1] = entry + Vector3.new(0, FLOAT, 0)
    local route = _pullWide(nav)
    route[#route + 1] = toPos
    return route
end

local function velMoveThrough(waypoints, speedOverride, allowJump)
    local hrp = getHRP()
    if not hrp or not hrp.Parent or #waypoints == 0 then return end
    local _runSpeed = speedOverride or TP_SPEED
    local wpIdx = 1
    local done = false
    local conn
    local function finish()
        if done then return end
        done = true
        if hrp and hrp.Parent then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
        if conn then conn:Disconnect() end
    end
    local lastDist, stall = math.huge, 0
    conn = RunService.Heartbeat:Connect(function()
        if not hrp or not hrp.Parent or done or _tpCancel then
            if conn then conn:Disconnect() end
            return
        end
        equipCarpet()
        local target = waypoints[wpIdx]
        local diff = target - hrp.Position
        local mag = diff.Magnitude
        if mag < ARRIVE then
            wpIdx = wpIdx + 1
            if wpIdx > #waypoints then finish() return end
            lastDist, stall = math.huge, 0
            target = waypoints[wpIdx]
            diff = target - hrp.Position
            mag = diff.Magnitude
        end
        if mag > lastDist - 0.05 then stall = stall + 1 else stall = 0 end
        lastDist = mag
        if stall >= 18 then finish() return end
        if mag >= 0.1 then
            local dir = diff.Unit
            if allowJump and diff.Y > 5 and wpIdx < #waypoints then
                local hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if hum then
                    local st = hum:GetState()
                    if st ~= Enum.HumanoidStateType.Jumping and st ~= Enum.HumanoidStateType.Freefall then
                        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() hum.Jump = true end)
                    end
                end
            end
            local _sp = _runSpeed
            local _vy = dir.Y * _sp
            if _vy > MAX_CLIMB then _vy = MAX_CLIMB end
            hrp.AssemblyLinearVelocity = Vector3.new(dir.X * _sp, _vy, dir.Z * _sp)
        end
    end)
    local totalDist = 0
    local prev = hrp.Position
    for _, wp in ipairs(waypoints) do
        totalDist = totalDist + (prev - wp).Magnitude
        prev = wp
    end
    local timeout = totalDist / math.min(200, _runSpeed) + 2
    local elapsed = 0
    while not done and elapsed < timeout and not _tpCancel do
        task.wait(0.05)
        elapsed = elapsed + 0.05
    end
    if not done then finish() end
    spoofedVZero()
end

local function runTPBest()
    if _tpBestActive then
        _tpCancel = true
        pcall(function()
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
            if hum then hum:UnequipTools() end
        end)
        _tpBestActive = false
        return
    end
    local petPos = scanBestPet()
    if not petPos then return end
    _tpBestActive = true
    _tpCancel     = false

    local char, hrp, hum
    local _t0 = os.clock()
    repeat
        char = LP.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        hum = char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum then break end
        RunService.Heartbeat:Wait()
    until os.clock() - _t0 > 3
    if not hrp or not hum then _tpBestActive = false; _tpCancel = false; return end
    pcall(function() hrp.Anchored = false end)


    char = LP.Character
    hrp = char and char:FindFirstChild("HumanoidRootPart")
    hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        local grapple = char and char:FindFirstChild("Grapple Hook")
        if not grapple then
            local bp = LP:FindFirstChildOfClass("Backpack")
            grapple = bp and bp:FindFirstChild("Grapple Hook")
            if grapple then
                pcall(function() hum:EquipTool(grapple) end)
            end
        end
    end

    char = LP.Character
    hrp = char and char:FindFirstChild("HumanoidRootPart")
    hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp then _tpBestActive = false; _tpCancel = false; return end
    pcall(function() hrp.Anchored = false end)

    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.new(0, 50, 0)
    end)
    task.wait(0.15)

    fireGrapple(petPos)
    task.wait(0.12)

    local h = petPos.Y
    local targetY = hrp.Position.Y
    if h > 23.15 then targetY = 21
    elseif h >= 11 and h <= 23.15 then targetY = 14.5
    elseif h >= -6.9 and h <= 8.9 then targetY = -4
    elseif h > 8.9 and h < 11 then targetY = 14.5
    else targetY = h + 2 end
    local _to = Vector3.new(petPos.X, targetY, petPos.Z)

    local _route = computeRoute(hrp.Position, _to, nil)
    if not _route or #_route == 0 then _route = { _to } end
    velMoveThrough(_route, TP_SPEED, true)

    if _tpCancel then
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum:UnequipTools() end
        end)
        _tpBestActive = false
        _tpCancel = false
        return
    end

    if hrp and hrp.Parent then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end

    pcall(function()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:UnequipTools() end
    end)

    _tpBestActive = false
    _tpCancel     = false
end


local _Workspace = game:GetService("Workspace")
local turretConns        = {}
local turretLoopRunning  = false
local turretAttackBusy   = setmetatable({}, { __mode = "k" })
local turretAttackQueued = setmetatable({}, { __mode = "k" })
local turretAttackCD     = setmetatable({}, { __mode = "k" })
local turretAttackActive = false
local RETRY_DELAY        = 0.3

local function isEnemyTurret(obj)
    if not obj or not obj:IsA("BasePart") then return false end
    local ownerId = obj.Name:match("^Sentry_(%d+)$")
        or obj.Name:match("^CandySentry_(%d+)$")
        or obj.Name:match("^Candy_Sentry_(%d+)$")
    return ownerId ~= nil and ownerId ~= tostring(LP.UserId)
end

local function setTurretNoClip(turret)
    if not isEnemyTurret(turret) then return end
    pcall(function() turret.CanCollide = false end)
end

local function getTurretTimeLabel(turret)
    if not turret or not turret.Parent then return nil end
    local sf  = turret:FindFirstChild("SetupFrame")
    local mf  = sf and sf:FindFirstChild("MainFrame")
    local lbl = mf and mf:FindFirstChild("Time")
    if lbl and lbl:IsA("TextLabel") then return lbl end
    return nil
end

local function shouldAttackTurret(turret)
    if not LP then return false end
    if LP:GetAttribute("Stealing") == true then return false end
    if not isEnemyTurret(turret) then return false end
    setTurretNoClip(turret)
    local lbl = getTurretTimeLabel(turret)
    if not lbl then return false end
    local ok, text = pcall(function() return lbl.Text end)
    if not ok then return false end
    text = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
    return text ~= "" and string.find(text, "^%d+s!$") ~= nil
end

local function bringTurretInFront(turret, hrp)
    if not turret or not hrp then return end
    local fwd = hrp.CFrame.LookVector
    local pos = hrp.Position + fwd * 4 + Vector3.new(0, 1.2, 0)
    local cf  = CFrame.lookAt(pos, pos + fwd)
    pcall(function()
        hrp.Velocity = Vector3.zero
        turret.RotVelocity = Vector3.zero
    end)
    pcall(function() turret.CFrame = cf end)
end

local function attackTurret(turret)
    local now = os.clock()
    if turretAttackBusy[turret] or turretAttackQueued[turret]
    or turretAttackActive or not shouldAttackTurret(turret) then return end
    if (turretAttackCD[turret] or 0) > now then return end
    turretAttackQueued[turret] = true
    turretAttackCD[turret]     = now + RETRY_DELAY
    task.spawn(function()
        turretAttackQueued[turret] = nil
        if turretAttackActive or turretAttackBusy[turret]
        or not shouldAttackTurret(turret) then return end
        turretAttackActive       = true
        turretAttackBusy[turret] = true
        pcall(function()
            local attempts = 0
            while attempts < 12 and State.antiSentryEnabled do
                if not turret or not turret.Parent or not shouldAttackTurret(turret) then break end
                local char = getChar()
                local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                local hum  = char and char:FindFirstChildOfClass("Humanoid")
                if not hrp or not hum or hum.Health <= 0 then break end
                local okD, dist = pcall(function() return (turret.Position - hrp.Position).Magnitude end)
                if okD and dist > 220 then break end
                setTurretNoClip(turret)
                bringTurretInFront(turret, hrp)
                if not turret or not turret.Parent or not shouldAttackTurret(turret) then break end
                local bp  = LP:FindFirstChildOfClass("Backpack")
                local bat = char:FindFirstChild("Bat") or (bp and bp:FindFirstChild("Bat"))
                if bat and bat.Parent ~= char then
                    pcall(function() hum:EquipTool(bat) end)
                end
                bat = char:FindFirstChild("Bat") or bat
                if bat then pcall(function() bat:Activate() end) end
                task.wait(0.03)
                if turret and turret.Parent and shouldAttackTurret(turret) then
                    setTurretNoClip(turret)
                    bringTurretInFront(turret, hrp)
                end
                attempts = attempts + 1
                task.wait(0.09)
            end
        end)
        turretAttackBusy[turret] = nil
        turretAttackActive       = false
    end)
end

local function antiSentryDisconnectAll()
    for _, c in ipairs(turretConns) do pcall(function() c:Disconnect() end) end
    turretConns = {}
end

local function startAntiSentry()
    antiSentryDisconnectAll()
    table.insert(turretConns, _Workspace.DescendantAdded:Connect(function(obj)
        if isEnemyTurret(obj) then setTurretNoClip(obj) end
        if State.antiSentryEnabled and shouldAttackTurret(obj) then
            task.defer(attackTurret, obj)
        end
    end))
    if not turretLoopRunning then
        turretLoopRunning = true
        task.spawn(function()
            while State.antiSentryEnabled do
                task.wait(0.4)
                if not State.antiSentryEnabled then break end
                for _, obj in ipairs(_Workspace:GetChildren()) do
                    if isEnemyTurret(obj) then setTurretNoClip(obj) end
                    if State.antiSentryEnabled and shouldAttackTurret(obj) then attackTurret(obj) end
                end
            end
            turretLoopRunning = false
        end)
    end
end

local function stopAntiSentry()
    antiSentryDisconnectAll()
end

local ALD_DETECT_RANGE = 999
local ALD_SPEED_LIMIT  = 8
local ALD_FIRE_RATE    = 0

local aldConn       = nil
local aldLastFire   = 0
local aldFiring     = false

local ANIMAL_NAMES = {
    ["Dog"] = true, ["Cat"] = true, ["Bunny"] = true,
    ["Cow"] = true, ["Pig"] = true, ["Sheep"] = true,
    ["Horse"] = true, ["Chicken"] = true, ["Duck"] = true,
    ["Bear"] = true, ["Fox"] = true, ["Wolf"] = true,
    ["Deer"] = true, ["Rabbit"] = true, ["Turtle"] = true,
    ["Lion"] = true, ["Tiger"] = true, ["Elephant"] = true,
    ["Monkey"] = true, ["Panda"] = true, ["frog"] = true,
    ["Golden"] = true, ["Rainbow"] = true, ["Dragon"] = true,
    ["Unicorn"] = true, ["Phoenix"] = true,
}

local function aldHasAnimalInHands(player)
    local char = player.Character
    local bp = player:FindFirstChildOfClass("Backpack")

    if char then
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Tool") and ANIMAL_NAMES[obj.Name] then return true end
        end
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Accessory") and ANIMAL_NAMES[obj.Name] then return true end
        end
    end

    if bp then
        for _, obj in ipairs(bp:GetDescendants()) do
            if obj:IsA("Tool") and ANIMAL_NAMES[obj.Name] then return true end
        end
    end

    for _, obj in ipairs(player:GetChildren()) do
        if obj:IsA("Tool") and ANIMAL_NAMES[obj.Name] then return true end
    end

    return false
end

local function aldIsStealing(player)
    if player:GetAttribute("Stealing") == true then return true end
    local char = player.Character; if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    if hum.WalkSpeed < ALD_SPEED_LIMIT then return true end
    return false
end

local function aldFindThreat()
    if LP:GetAttribute("Stealing") == true then return nil end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            if aldHasAnimalInHands(player) or aldIsStealing(player) then
                return player
            end
        end
    end
    return nil
end

local function aldEquipAndFire()
    local char = getChar(); if not char then return end
    local bp   = LP:FindFirstChildOfClass("Backpack")
    local tool = char:FindFirstChild("Laser Cape") or (bp and bp:FindFirstChild("Laser Cape"))
    if not tool then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if tool.Parent ~= char then
        pcall(function() hum:EquipTool(tool) end)
        task.wait(0.05)
    end
    pcall(function() tool:Activate() end)
end

local function aldUnequip()
    local char = getChar(); if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then pcall(function() hum:UnequipTools() end) end
end

local function startALD()
    if aldConn then return end
    local wasFiring = false
    aldConn = RunService.Heartbeat:Connect(function()
        if not State.aldEnabled then
            if aldFiring then aldUnequip(); aldFiring = false; wasFiring = false end
            return
        end
        local threat = aldFindThreat()
        if threat then
            aldFiring = true
            wasFiring = true
            task.spawn(aldEquipAndFire)
        else
            if wasFiring then
                aldUnequip()
                wasFiring = false
            end
            aldFiring = false
        end
    end)
end

local function stopALD()
    if aldConn then aldConn:Disconnect(); aldConn = nil end
    if aldFiring then aldUnequip() end
    aldFiring = false; aldLastFire = 0
end

local mineESPData = {}
local mineESPThread = nil
local mineESPRunning = false
local mineESPFadeConn = nil
local TEX_MINE = "rbxassetid://11987521"

local function getMineAdornee(obj)
    if obj:IsA("Model") then
        return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true) or obj
    end
    return obj
end

local function isMinePart(obj)
    local n = obj.Name:lower()
    local isMine = n:find("tripmine") ~= nil or (n:find("subspace") and n:find("mine"))
    local isPart = obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("MeshPart") or obj:IsA("UnionOperation")
    return isMine and isPart
end

local function isOwnMine(obj, ownerName)

    if ownerName and ownerName ~= "Unknown" then
        local clean = tostring(ownerName):gsub("^%s+", ""):gsub("%s+$", "")
        if clean == LP.Name or clean == LP.DisplayName then return true end
    end

    local okN, objName = pcall(function() return obj.Name end)
    if okN and type(objName) == "string" then
        if objName:find(tostring(LP.UserId), 1, true) then return true end
        if LP.Name ~= "" and objName:find(LP.Name, 1, true) then return true end
        if LP.DisplayName ~= "" and LP.DisplayName ~= LP.Name and objName:find(LP.DisplayName, 1, true) then return true end
    end

    local okA, attrs = pcall(function() return obj:GetAttributes() end)
    if okA and type(attrs) == "table" then
        for _, v in pairs(attrs) do
            if v == LP.UserId or v == LP.Name or v == LP.DisplayName then return true end
            if type(v) == "string" and v:find(tostring(LP.UserId), 1, true) then return true end
        end
    end

    local okV, ownerVal = pcall(function()
        return obj:FindFirstChild("Owner") or obj:FindFirstChild("Creator") or obj:FindFirstChild("Placer")
    end)
    if okV and ownerVal then
        local ok2, val = pcall(function()
            if ownerVal:IsA("ObjectValue") then return ownerVal.Value end
            if ownerVal:IsA("StringValue") or ownerVal:IsA("IntValue") then return ownerVal.Value end
            return nil
        end)
        if ok2 and val ~= nil then
            if val == LP or val == LP.UserId or val == LP.Name or val == LP.DisplayName then return true end
        end
    end
    return false
end

local function refreshMineESP()
    if not State.mineESPEnabled then return end
    local tools = workspace:FindFirstChild("ToolsAdds")
        or workspace:FindFirstChild("ToolAdds")
        or workspace:FindFirstChild("Tools")
    if not tools then
        for _, d in ipairs(workspace:GetChildren()) do
            if d:IsA("Folder") and d.Name:lower():find("tool") then tools = d; break end
        end
    end
    if not tools then return end
    local currentMines = {}
    for _, obj in ipairs(tools:GetChildren()) do
        if isMinePart(obj) then
            local ownerName = obj.Name:match("Subspace%s*Tripmine%s*(.+)") or obj.Name:match("SubspaceTripmine(.+)") or obj.Name:match("[Mm]ine(.+)") or "Unknown"
            if ownerName == "" then ownerName = "Unknown" end
            ownerName = tostring(ownerName):gsub("^%s+", ""):gsub("%s+$", "")

            if isOwnMine(obj, ownerName) then
                if mineESPData[obj] then
                    local old = mineESPData[obj]
                    pcall(function() old.hl:Destroy() end)
                    pcall(function() old.box:Destroy() end)
                    pcall(function() if old.line then old.line:Destroy() end end)
                    pcall(function() if old.tip then old.tip:Destroy() end end)
                    pcall(function() if old.bb then old.bb:Destroy() end end)
                    mineESPData[obj] = nil
                end
            else
                currentMines[obj] = true
                if not mineESPData[obj] then
                local adornee = getMineAdornee(obj)

                local hl = Instance.new("Highlight")
                hl.Name = "MineESP_HL"
                hl.Adornee = obj
                hl.FillColor = Color3.fromRGB(245,245,247)
                hl.FillTransparency = 0.82
                hl.OutlineColor = Color3.fromRGB(167,142,255)
                hl.OutlineTransparency = 0
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = obj

                local box = Instance.new("SelectionBox")
                box.Name = "MineESP_Box"
                box.Adornee = obj
                box.Color3 = Color3.fromRGB(245,245,247)
                box.LineThickness = 0.025
                box.SurfaceTransparency = 1
                box.Parent = obj

                local linePart, tipPart, bb, bg, title, sub2, sub3
                pcall(function()
                    local h = 2
                    local center = Vector3.new(0,0,0)
                    if adornee:IsA("BasePart") then h = adornee.Size.Y center = adornee.Position
                    elseif obj:IsA("Model") then h = obj:GetExtentsSize().Y center = obj:GetPivot().Position end
                    local lineH = 1.8
                    local top = center + Vector3.new(0, h/2, 0)
                    local lineCenter = top + Vector3.new(0, lineH/2 + 0.15, 0)
                    linePart = Instance.new("Part")
                    linePart.Name = "MineESP_Line"
                    linePart.Size = Vector3.new(0.06, lineH, 0.06)
                    linePart.Color = Color3.new(1,1,1)
                    linePart.Material = Enum.Material.Neon
                    linePart.Anchored = true
                    linePart.CanCollide = false
                    linePart.CanQuery = false
                    linePart.CFrame = CFrame.new(lineCenter)
                    linePart.Parent = workspace
                    local tipPos = lineCenter + Vector3.new(0, lineH/2 + 0.6, 0)
                    tipPart = Instance.new("Part")
                    tipPart.Name = "MineESP_Tip"
                    tipPart.Size = Vector3.new(0.1,0.1,0.1)
                    tipPart.Transparency = 1
                    tipPart.Anchored = true
                    tipPart.CanCollide = false
                    tipPart.CFrame = CFrame.new(tipPos)
                    tipPart.Parent = workspace
                    bb = Instance.new("BillboardGui")
                    bb.Name = "MineESP_BB"
                    bb.Adornee = tipPart
                    bb.Size = UDim2.fromOffset(210, 48)
                    bb.AlwaysOnTop = true
                    bb.MaxDistance = 800
                    bb.LightInfluence = 0
                    bb.Parent = tipPart
                    bg = Instance.new("Frame", bb)
                    bg.Name = "BG"
                    bg.Size = UDim2.new(1,0,1,0)
                    bg.BackgroundColor3 = Color3.fromRGB(18,18,20)
                    bg.BackgroundTransparency = 0.06
                    Instance.new("UICorner", bg).CornerRadius = UDim.new(0,9)
                    local st = Instance.new("UIStroke", bg) st.Color = Color3.fromRGB(72,72,74) st.Thickness = 1
                    local imgBox = Instance.new("Frame", bg)
                    imgBox.Name = "ImgBox"
                    imgBox.Size = UDim2.new(0,34,0,34)
                    imgBox.Position = UDim2.new(0,7,0.5,-17)
                    imgBox.BackgroundColor3 = Color3.fromRGB(32,32,34)
                    Instance.new("UICorner", imgBox).CornerRadius = UDim.new(0,7)
                    Instance.new("UIStroke", imgBox).Color = Color3.fromRGB(72,72,74)
                    local img = Instance.new("ImageLabel", imgBox)
                    img.Name = "Preview"
                    img.Size = UDim2.new(1,-6,1,-6)
                    img.Position = UDim2.new(0,3,0,3)
                    img.BackgroundTransparency = 1
                    img.Image = TEX_MINE
                    img.ScaleType = Enum.ScaleType.Fit
                    Instance.new("UICorner", img).CornerRadius = UDim.new(0,5)
                    title = Instance.new("TextLabel", bg)
                    title.Name = "Title"
                    title.Size = UDim2.new(1,-52,0,13)
                    title.Position = UDim2.new(0,48,0,6)
                    title.BackgroundTransparency = 1
                    title.Text = "MINE"
                    title.Font = Enum.Font.GothamBlack
                    title.TextSize = 12
                    title.TextColor3 = Color3.fromRGB(167,142,255)
                    title.TextXAlignment = Enum.TextXAlignment.Left
                    sub2 = Instance.new("TextLabel", bg)
                    sub2.Name = "Sub2"
                    sub2.Size = UDim2.new(1,-52,0,11)
                    sub2.Position = UDim2.new(0,48,0,20)
                    sub2.BackgroundTransparency = 1
                    sub2.Text = ownerName .. "'s Mine"
                    sub2.Font = Enum.Font.GothamBold
                    sub2.TextSize = 10
                    sub2.TextColor3 = Color3.fromRGB(245,245,247)
                    sub2.TextXAlignment = Enum.TextXAlignment.Left
                    sub2.TextTruncate = Enum.TextTruncate.AtEnd
                    sub3 = Instance.new("TextLabel", bg)
                    sub3.Name = "Sub3"
                    sub3.Size = UDim2.new(1,-52,0,9)
                    sub3.Position = UDim2.new(0,48,0,32)
                    sub3.BackgroundTransparency = 1
                    sub3.Text = "● ACTIVA • PROXIMIDAD"
                    sub3.Font = Enum.Font.GothamBold
                    sub3.TextSize = 8
                    sub3.TextColor3 = Color3.fromRGB(255,90,90)
                    sub3.TextXAlignment = Enum.TextXAlignment.Left
                end)

                pcall(function()
                    local cam = workspace.CurrentCamera
                    if cam and tipPart and bg and title then
                        local dist = (cam.CFrame.Position - tipPart.Position).Magnitude
                        local t = math.clamp((dist - 28)/24, 0, 1)
                        title.TextTransparency = t title.TextStrokeTransparency = t
                        sub2.TextTransparency = t sub2.TextStrokeTransparency = t
                        sub3.TextTransparency = t
                        bg.BackgroundTransparency = 0.06 + t*0.28
                        local w = 48 + (210-48)*(1-t)
                        bb.Size = UDim2.fromOffset(w, 48)
                        local imgBox = bg:FindFirstChild("ImgBox")
                        if imgBox then imgBox.Position = t>0.75 and UDim2.new(0.5,-17,0.5,-17) or UDim2.new(0,7,0.5,-17) end
                    end
                end)
                mineESPData[obj] = {hl=hl, box=box, line=linePart, tip=tipPart, bb=bb, bg=bg, title=title, sub2=sub2, sub3=sub3}
                end
            end
        end
    end
    for mineObj, data in pairs(mineESPData) do
        if not currentMines[mineObj] or not mineObj.Parent then
            pcall(function() data.hl:Destroy() end)
            pcall(function() data.box:Destroy() end)
            pcall(function() if data.line then data.line:Destroy() end end)
            pcall(function() if data.tip then data.tip:Destroy() end end)
            pcall(function() if data.bb then data.bb:Destroy() end end)
            mineESPData[mineObj] = nil
        end
    end
end

local function startMineESP()
    if mineESPRunning then return end
    mineESPRunning = true
    mineESPThread = task.spawn(function()
        while mineESPRunning and State.mineESPEnabled do
            pcall(refreshMineESP)
            task.wait(1)
        end
        mineESPRunning = false
    end)
    if mineESPFadeConn then pcall(function() mineESPFadeConn:Disconnect() end) end
    mineESPFadeConn = RunService.Heartbeat:Connect(function()
        if not State.mineESPEnabled then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local camPos = cam.CFrame.Position
        for _, data in pairs(mineESPData) do
            local tip = data.tip
            local bg = data.bg
            local title = data.title
            local s2 = data.sub2
            local s3 = data.sub3
            local bb = data.bb
            if tip and bg and title and bb then
                local dist = (camPos - tip.Position).Magnitude
                local t = math.clamp((dist - 28)/24, 0, 1)
                pcall(function()
                    title.TextTransparency = t
                    title.TextStrokeTransparency = t
                    s2.TextTransparency = t
                    s2.TextStrokeTransparency = t
                    s3.TextTransparency = t
                    bg.BackgroundTransparency = 0.06 + t*0.28
                    bg:FindFirstChildOfClass("UIStroke").Transparency = t*0.65
                    local w = 48 + (210-48)*(1-t)
                    bb.Size = UDim2.fromOffset(w, 48)
                    local imgBox = bg:FindFirstChild("ImgBox")
                    if imgBox then imgBox.Position = t>0.75 and UDim2.new(0.5,-17,0.5,-17) or UDim2.new(0,7,0.5,-17) end
                end)
            end
        end
    end)
end

local function stopMineESP()
    mineESPRunning = false
    mineESPThread = nil
    if mineESPFadeConn then pcall(function() mineESPFadeConn:Disconnect() end) mineESPFadeConn=nil end
    for mineObj, data in pairs(mineESPData) do
        pcall(function() data.hl:Destroy() end)
        pcall(function() data.box:Destroy() end)
        pcall(function() if data.line then data.line:Destroy() end end)
        pcall(function() if data.tip then data.tip:Destroy() end end)
        pcall(function() if data.bb then data.bb:Destroy() end end)
    end
    mineESPData = {}
end

local function prettyKey(kc)
    local s = tostring(kc):gsub("Enum.KeyCode.", "")
    return s
end

local _listeningFor = nil

local function setListeningFor(keyName)
    _listeningFor = keyName
    if _keyLabelRefs[keyName] then
        _keyLabelRefs[keyName].Text = "..."
        _keyLabelRefs[keyName].TextColor3 = Color3.fromRGB(235, 235, 240)
    end
end

saveSettings = function()
    local data = {
        antiSentryEnabled = State.antiSentryEnabled,
        aldEnabled        = State.aldEnabled,
        silentAimEnabled  = State.silentAimEnabled,
        spamPaint         = State.spamPaint,
        spamLaser         = State.spamLaser,
        counterLaser      = State.counterLaser,
        mineESPEnabled    = State.mineESPEnabled,
        antiBeeDisco      = State.antiBeeDisco,
        kb_tpBest         = tostring(Keybinds.tpBest),
        kb_antiSentry     = tostring(Keybinds.antiSentry),
        kb_ald            = tostring(Keybinds.ald),
        kb_silentAim      = tostring(Keybinds.silentAim),
        kb_spamPaint      = tostring(Keybinds.spamPaint),
        kb_spamLaser      = tostring(Keybinds.spamLaser),
        kb_counterLaser   = tostring(Keybinds.counterLaser),
        framePos = frame and {
            frame.Position.X.Scale, frame.Position.X.Offset,
            frame.Position.Y.Scale, frame.Position.Y.Offset,
        } or nil,
        pillPos = miniPill and {
            miniPill.Position.X.Scale, miniPill.Position.X.Offset,
            miniPill.Position.Y.Scale, miniPill.Position.Y.Offset,
        } or nil,
    }
    pcall(writefile, SAVE_FILE, HttpService:JSONEncode(data))
end

loadSettings = function()
    local ok, raw = pcall(readfile, SAVE_FILE)
    if not ok or not raw or raw == "" then return end
    local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
    if not ok2 or type(data) ~= "table" then return end

    local bools = { "antiSentryEnabled", "aldEnabled", "silentAimEnabled", "spamPaint", "spamLaser", "counterLaser", "mineESPEnabled", "antiBeeDisco" }
    for _, k in ipairs(bools) do
        if type(data[k]) == "boolean" then State[k] = data[k] end
    end

    local kbMap = {
        kb_tpBest        = "tpBest",
        kb_antiSentry    = "antiSentry",
        kb_ald           = "ald",
        kb_silentAim     = "silentAim",
        kb_spamPaint     = "spamPaint",
        kb_spamLaser     = "spamLaser",
        kb_counterLaser  = "counterLaser",
    }
    for saveKey, bindKey in pairs(kbMap) do
        if type(data[saveKey]) == "string" then
            local stripped = data[saveKey]:gsub("Enum%.KeyCode%.", "")
            local success, val = pcall(function() return Enum.KeyCode[stripped] end)
            if success and val then Keybinds[bindKey] = val end
        end
    end

    if type(data.framePos) == "table" and #data.framePos == 4 then
        pendingFramePos = UDim2.new(data.framePos[1], data.framePos[2], data.framePos[3], data.framePos[4])
    end
    if type(data.pillPos) == "table" and #data.pillPos == 4 then
        pendingPillPos = UDim2.new(data.pillPos[1], data.pillPos[2], data.pillPos[3], data.pillPos[4])
    end
end

local PAL = {
    base      = Color3.fromRGB(6,   6,   8),
    baseTop   = Color3.fromRGB(30,  30,  37),
    headerBg  = Color3.fromRGB(13,  13,  16),
    card      = Color3.fromRGB(19,  19,  23),
    cardOn    = Color3.fromRGB(34,  34,  42),
    row       = Color3.fromRGB(11,  11,  14),
    stroke    = Color3.fromRGB(72,  72,  84),
    strokeOn  = Color3.fromRGB(245, 245, 250),
    textHi    = Color3.fromRGB(250, 250, 253),
    textMid   = Color3.fromRGB(165, 165, 176),
    textLow   = Color3.fromRGB(100, 100, 112),
    accent    = Color3.fromRGB(255, 255, 255),
    off       = Color3.fromRGB(43,  43,  53),
}

local function boxSheen(parent)
    local s = Instance.new("Frame", parent)
    s.Size = UDim2.new(1, -12, 0, 1); s.Position = UDim2.new(0, 6, 0, 0)
    s.BackgroundColor3 = PAL.accent; s.BorderSizePixel = 0
    s.BackgroundTransparency = 0.8
    local g = Instance.new("UIGradient", s)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150,150,160)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(255,255,255)),
    })
end

local function textShine(label, hi, lo)
    local g = Instance.new("UIGradient", label)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   hi or Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1,   lo or Color3.fromRGB(185,185,196)),
    })
end

local function makeAnimatedGradient(parent)
    local holder = Instance.new("Frame", parent)
    holder.Name                   = "AnimatedBG"
    holder.Size                   = UDim2.new(2, 0, 2, 0)
    holder.Position               = UDim2.new(-0.5, 0, -0.5, 0)
    holder.BackgroundTransparency = 0
    holder.BorderSizePixel        = 0
    local g = Instance.new("UIGradient", holder)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(20, 20, 20)),
        ColorSequenceKeypoint.new(0.20, Color3.fromRGB(240, 240, 240)),
        ColorSequenceKeypoint.new(0.40, Color3.fromRGB(80,  80,  80)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(10,  10,  10)),
        ColorSequenceKeypoint.new(0.70, Color3.fromRGB(80,  80,  80)),
        ColorSequenceKeypoint.new(0.85, Color3.fromRGB(240, 240, 240)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(20, 20, 20)),
    })
    g.Rotation = 45
    g.Offset   = Vector2.new(-0.5, -0.5)
    TweenService:Create(g,
        TweenInfo.new(7, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false),
        {Offset = Vector2.new(0.5, 0.5)}
    ):Play()
end

local function applyFlowGradient(parent)
    local g = Instance.new("UIGradient", parent)
    g.Rotation = 90
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(30, 30, 37)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(50, 50, 60)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(6, 6, 8)),
    })
end

local function refreshBindLabel(keyName)
    local lbl = _keyLabelRefs[keyName]
    if not lbl then return end
    local kc = Keybinds[keyName]
    if kc == nil or kc == Enum.KeyCode.Unknown then
        lbl.Text       = "NONE"
        lbl.TextColor3 = PAL.textLow
    else
        lbl.Text       = prettyKey(kc)
        lbl.TextColor3 = PAL.textHi
    end
end


local GUI_NAME = "VX7HUBGUI_" .. HttpService:GenerateGUID(false):sub(1,8)
for _, n in ipairs({ "veltrinaHubGUI", "VX7HUBGUI" }) do
    local old = LP.PlayerGui:FindFirstChild(n)
    if old and old.Name == n then old:Destroy() end
    local old2 = game:GetService("CoreGui"):FindFirstChild(n)
    if old2 and old2.Name == n then pcall(function() old2:Destroy() end) end
end
pcall(function()
    if _G.VX7_GUI and _G.VX7_GUI.Parent then _G.VX7_GUI:Destroy() end
end)
local screen = Instance.new("ScreenGui")
screen.Name           = GUI_NAME
screen.ResetOnSpawn   = false
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.IgnoreGuiInset = true
_G.VX7_GUI = screen
if gethui then
    local ok, h = pcall(gethui)
    if ok and h then screen.Parent = h else screen.Parent = LP:WaitForChild("PlayerGui") end
else
    screen.Parent = LP:WaitForChild("PlayerGui")
end
if not screen.Parent then screen.Parent = LP:WaitForChild("PlayerGui") end

local viewport = workspace.CurrentCamera.ViewportSize
local guiScale = math.clamp(viewport.X / 430, 0.55, 1)

local function s(val)
    return math.floor(val * guiScale)
end

frame = Instance.new("CanvasGroup", screen)
frame.Size                   = UDim2.new(0, s(360), 0, s(430))
local MAIN_FRAME_SIZE = frame.Size
frame.Position               = UDim2.new(0.68, 0, 0.08, 0)
frame.BackgroundColor3       = PAL.base
frame.BorderSizePixel        = 0
frame.Active                 = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
frame.ClipsDescendants = true

makeAnimatedGradient(frame)

local outerGlow = Instance.new("UIStroke", frame)
outerGlow.Color        = Color3.fromRGB(36, 36, 44)
outerGlow.Thickness    = 1
outerGlow.Transparency = 0.15
outerGlow.Name         = "OuterGlow"

local innerLight = Instance.new("Frame", frame)
innerLight.Size                   = UDim2.new(1, 0, 1, 0)
innerLight.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
innerLight.BackgroundTransparency = 0.92
innerLight.BorderSizePixel        = 0
innerLight.Active                 = false
innerLight.ZIndex                 = 2
Instance.new("UICorner", innerLight).CornerRadius = UDim.new(0, 14)
local ilGrad = Instance.new("UIGradient", innerLight)
ilGrad.Rotation = 90
ilGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(170, 170, 182)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(110, 110, 122)),
})
ilGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,    0.5),
    NumberSequenceKeypoint.new(0.22, 0.85),
    NumberSequenceKeypoint.new(1,    1),
})

local header = Instance.new("Frame", frame)
header.Size             = UDim2.new(1, 0, 0, s(46))
header.BackgroundColor3 = PAL.headerBg
header.BorderSizePixel  = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)
local headerFix = Instance.new("Frame", header)
headerFix.Size = UDim2.new(1,0,0,8); headerFix.Position = UDim2.new(0,0,1,-8)
headerFix.BackgroundColor3 = PAL.headerBg; headerFix.BorderSizePixel = 0
local function applyHeaderGrad(parent)
    local g = Instance.new("UIGradient", parent)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(9, 9, 11)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(36,36,45)),
    })
end
applyHeaderGrad(header)
applyHeaderGrad(headerFix)

local accentLine = Instance.new("Frame", frame)
accentLine.Size = UDim2.new(0.85,0,0,s(2)); accentLine.Position = UDim2.new(0.075,0,0,s(46))
accentLine.BackgroundColor3 = PAL.accent; accentLine.BorderSizePixel = 0
accentLine.BackgroundTransparency = 0.2
Instance.new("UIGradient", accentLine).Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(160,160,170)),
    ColorSequenceKeypoint.new(0.5, PAL.accent),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(160,160,170)),
})

local iconDot = Instance.new("Frame", header)
iconDot.Size = UDim2.new(0,s(8),0,s(8)); iconDot.Position = UDim2.new(0,s(16),0.5,-s(4))
iconDot.BackgroundColor3 = PAL.accent; iconDot.BorderSizePixel = 0
iconDot.BackgroundTransparency = 0.1
Instance.new("UICorner", iconDot).CornerRadius = UDim.new(1,0)
local dotGlow = Instance.new("UIStroke", iconDot)
dotGlow.Color = PAL.accent; dotGlow.Thickness = 2; dotGlow.Transparency = 0.65

local titleLabel = Instance.new("TextLabel", header)
titleLabel.Size = UDim2.new(1,-s(40),1,0); titleLabel.Position = UDim2.new(0,s(32),0,0)
titleLabel.BackgroundTransparency = 1; titleLabel.Text = "VX7 HUB  ALL GEARS"
titleLabel.TextColor3 = PAL.textHi; titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 19; titleLabel.TextXAlignment = Enum.TextXAlignment.Left
textShine(titleLabel, Color3.fromRGB(255,255,255), Color3.fromRGB(165,165,178))
local titleStroke = Instance.new("UIStroke", titleLabel)
titleStroke.Color = Color3.fromRGB(255,255,255)
titleStroke.Thickness = 0.8
titleStroke.Transparency = 0.82

local minBtn = Instance.new("TextButton", header)
minBtn.Size             = UDim2.new(0,s(22),0,s(22))
minBtn.Position         = UDim2.new(1,-s(32),0.5,-s(11))
minBtn.BackgroundColor3 = PAL.off
minBtn.Text             = ""
minBtn.BorderSizePixel  = 0
minBtn.AutoButtonColor  = false
minBtn.Active           = true
minBtn.ZIndex           = 6
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1,0)
local minStroke = Instance.new("UIStroke", minBtn)
minStroke.Color = PAL.stroke; minStroke.Thickness = 1
boxSheen(minBtn)
local minLbl = Instance.new("TextLabel", minBtn)
minLbl.Size = UDim2.new(1,0,1,0); minLbl.BackgroundTransparency = 1
minLbl.Text = "–"; minLbl.Font = Enum.Font.GothamBlack
minLbl.TextSize = 14; minLbl.TextColor3 = PAL.textHi
minLbl.ZIndex = 7
minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {BackgroundColor3 = PAL.cardOn}):Play()
end)
minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {BackgroundColor3 = PAL.off}):Play()
end)

local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1,0,1,-s(52)); scrollFrame.Position = UDim2.new(0,0,0,s(52))
scrollFrame.BackgroundTransparency = 1; scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3; scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(170,170,180)
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y; scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollFrame.CanvasPosition = Vector2.new(0, 0)

local function addSection(label, y)
    local sec = Instance.new("Frame", scrollFrame)
    sec.Size = UDim2.new(1,-s(32),0,s(22)); sec.Position = UDim2.new(0,s(16),0,y)
    sec.BackgroundTransparency = 1; sec.BorderSizePixel = 0
    local lbl = Instance.new("TextLabel", sec)
    lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
    lbl.Text = label; lbl.TextColor3 = PAL.textMid
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 10; lbl.TextXAlignment = Enum.TextXAlignment.Left
    textShine(lbl, Color3.fromRGB(238,238,244), Color3.fromRGB(128,128,140))
    local div = Instance.new("Frame", sec)
    div.Size = UDim2.new(1,0,0,1); div.Position = UDim2.new(0,0,1,-1)
    div.BackgroundColor3 = Color3.fromRGB(70,70,80); div.BorderSizePixel = 0
end

local function makeToolCard(cfg)
    local card = Instance.new("Frame", scrollFrame)
    card.Size = UDim2.new(1,-s(32),0,s(44)); card.Position = UDim2.new(0,s(16),0,cfg.y)
    card.BackgroundColor3 = PAL.card; card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,10)
    applyFlowGradient(card)
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = PAL.stroke; stroke.Thickness = 1.2; stroke.Transparency = 0.25

    boxSheen(card)

    local innerGlow = Instance.new("Frame", card)
    innerGlow.Size                   = UDim2.new(1, 0, 1, 0)
    innerGlow.BackgroundColor3       = PAL.accent
    innerGlow.BackgroundTransparency = 1
    innerGlow.BorderSizePixel        = 0
    Instance.new("UICorner", innerGlow).CornerRadius = UDim.new(0, 10)
    local igGrad = Instance.new("UIGradient", innerGlow)
    igGrad.Rotation = 90
    igGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 162)),
    })
    igGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.78),
        NumberSequenceKeypoint.new(0.6, 0.94),
        NumberSequenceKeypoint.new(1,   1),
    })

    local accentBar = Instance.new("Frame", card)
    accentBar.Size = UDim2.new(0,s(4),1,-s(16)); accentBar.Position = UDim2.new(0,s(6),0,s(8))
    accentBar.BackgroundColor3 = PAL.textLow; accentBar.BackgroundTransparency = 0.4
    accentBar.BorderSizePixel = 0
    Instance.new("UICorner", accentBar).CornerRadius = UDim.new(1,0)

    local ttl = Instance.new("TextLabel", card)
    ttl.Size = UDim2.new(1,-86,1,0); ttl.Position = UDim2.new(0,22,0,0)
    ttl.BackgroundTransparency = 1; ttl.Text = cfg.title
    ttl.TextColor3 = PAL.textHi; ttl.Font = Enum.Font.GothamBold
    ttl.TextSize = 11; ttl.TextXAlignment = Enum.TextXAlignment.Left
    textShine(ttl)

    local swTrack = Instance.new("Frame", card)
    swTrack.Size = UDim2.new(0,s(46),0,s(24)); swTrack.Position = UDim2.new(1,-s(56),0.5,-s(12))
    swTrack.BackgroundColor3 = PAL.off; swTrack.BorderSizePixel = 0
    Instance.new("UICorner", swTrack).CornerRadius = UDim.new(1,0)
    local swStroke = Instance.new("UIStroke", swTrack)
    swStroke.Color = Color3.fromRGB(56,56,66); swStroke.Thickness = 1

    local knob = Instance.new("Frame", swTrack)
    knob.Size = UDim2.new(0,s(18),0,s(18)); knob.Position = UDim2.new(0,s(3),0.5,-s(9))
    knob.BackgroundColor3 = PAL.textMid; knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.ZIndex = 5

    local stateKey = cfg.stateKey

    local function setVisual(on)
        local ti = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        TweenService:Create(card,   ti, {BackgroundColor3 = on and PAL.cardOn or PAL.card}):Play()
        TweenService:Create(stroke, ti, {Color = on and PAL.strokeOn or PAL.stroke,
                                         Transparency = on and 0.08 or 0.25}):Play()
        TweenService:Create(innerGlow, ti, {BackgroundTransparency = on and 0 or 1}):Play()
        TweenService:Create(accentBar, ti, {
            BackgroundColor3       = on and PAL.accent or PAL.textLow,
            BackgroundTransparency = on and 0 or 0.4,
        }):Play()
        TweenService:Create(swTrack, ti, {BackgroundColor3 = on and PAL.accent or PAL.off}):Play()
        TweenService:Create(swStroke, ti, {Color = on and PAL.accent or Color3.fromRGB(56,56,66)}):Play()
        TweenService:Create(knob, ti, {
            Position         = on and UDim2.new(1,-s(21),0.5,-s(9)) or UDim2.new(0,s(3),0.5,-s(9)),
            BackgroundColor3 = on and Color3.fromRGB(12,12,14) or PAL.textMid,
        }):Play()
    end

    if State[stateKey] then setVisual(true) end
    _toggleSetFns[stateKey] = setVisual

    btn.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {BackgroundColor3 = State[stateKey] and PAL.cardOn or Color3.fromRGB(30,30,37)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {BackgroundColor3 = State[stateKey] and PAL.cardOn or PAL.card}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        State[stateKey] = not State[stateKey]
        setVisual(State[stateKey])
        if cfg.onToggle then cfg.onToggle(State[stateKey]) end
        saveSettings()
    end)
end

local function addKeybind(label, keyName, y)
    local row = Instance.new("Frame", scrollFrame)
    row.Size = UDim2.new(1,-s(32),0,s(40)); row.Position = UDim2.new(0,s(16),0,y)
    row.BackgroundColor3 = PAL.row; row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,9)
    applyFlowGradient(row)
    local stroke = Instance.new("UIStroke", row)
    stroke.Color = Color3.fromRGB(58,58,68); stroke.Thickness = 1
    boxSheen(row)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0,s(130),1,0); lbl.Position = UDim2.new(0,s(12),0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = label
    lbl.TextColor3 = PAL.textMid; lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local keyWrap = Instance.new("Frame", row)
    keyWrap.Size = UDim2.new(0,s(82),0,s(26)); keyWrap.Position = UDim2.new(1,-s(90),0.5,-s(13))
    keyWrap.BackgroundColor3 = PAL.card; keyWrap.BorderSizePixel = 0
    Instance.new("UICorner", keyWrap).CornerRadius = UDim.new(0,7)
    local ks = Instance.new("UIStroke", keyWrap)
    ks.Color = PAL.stroke; ks.Thickness = 1.1
    boxSheen(keyWrap)
    local keyLbl = Instance.new("TextLabel", keyWrap)
    keyLbl.Size = UDim2.new(1,0,1,0); keyLbl.BackgroundTransparency = 1
    keyLbl.Font = Enum.Font.GothamBold
    keyLbl.TextSize = 11; keyLbl.ZIndex = 5
    _keyLabelRefs[keyName] = keyLbl
    refreshBindLabel(keyName)
    textShine(keyLbl)
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.ZIndex = 6
    btn.MouseEnter:Connect(function()
        TweenService:Create(ks,TweenInfo.new(0.15,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Color=PAL.accent}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if _listeningFor ~= keyName then
            TweenService:Create(ks,TweenInfo.new(0.15,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Color=PAL.stroke}):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function()
        if _listeningFor == keyName then
            _listeningFor = nil
            refreshBindLabel(keyName)
            TweenService:Create(ks,TweenInfo.new(0.15,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Color=PAL.stroke}):Play()
        else
            setListeningFor(keyName)
            TweenService:Create(ks,TweenInfo.new(0.15,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Color=PAL.accent}):Play()
        end
    end)
end

loadSettings()

local y = s(6)

addSection("—  COMBAT  —", y);                                y += s(28)

makeToolCard({
    stateKey = "antiSentryEnabled",
    title    = "ANTI SENTRY",
    y        = y,
    onToggle = function(on)
        if on then startAntiSentry() else stopAntiSentry() end
    end,
});                                                             y += s(52)

makeToolCard({
    stateKey = "aldEnabled",
    title    = "LASER DEFENDER",
    y        = y,
    onToggle = function(on)
        if on then startALD() else stopALD() end
    end,
});                                                             y += s(52)

makeToolCard({
    stateKey = "silentAimEnabled",
    title    = "SILENT AIM",
    y        = y,
    onToggle = function(on)
        saSetupTools()
    end,
});                                                             y += s(52)

y += s(4)
addSection("—  AUTO SPAM  —", y);                              y += s(28)

makeToolCard({
    stateKey = "spamLaser",
    title    = "AUTO SPAM LASER",
    y        = y,
    onToggle = function(on)
        if on then startSpamLaser() else stopSpamLaser() end
    end,
});                                                             y += s(52)

makeToolCard({
    stateKey = "spamPaint",
    title    = "AUTO SPAM PAINTBALL",
    y        = y,
    onToggle = function(on)
        if on then startSpamPaint() else stopSpamPaint() end
    end,
});                                                             y += s(52)

y += s(4)
addSection("—  COUNTER (when not stealing)  —", y);              y += s(28)

makeToolCard({
    stateKey = "counterLaser",
    title    = "COUNTER: LASER CAPE",
    y        = y,
    onToggle = function(on)
        if on then setCounter("laser") else setCounter(nil) end
    end,
});                                                             y += s(52)

y += s(4)
addSection("—  UTILS  —", y);                                  y += s(28)

makeToolCard({
    stateKey = "mineESPEnabled",
    title    = "MINE ESP",
    y        = y,
    onToggle = function(on)
        if on then startMineESP() else stopMineESP() end
    end,
});                                                             y += s(52)

makeToolCard({
    stateKey = "antiBeeDisco",
    title    = "ANTI BEE & DISCO",
    y        = y,
    onToggle = function(on)
        if on then AntiBeeDisco.Enable() else AntiBeeDisco.Disable() end
    end,
});                                                             y += s(52)

y += s(6)
addSection("—  TELEPORT  —", y);                               y += s(28)

do
    local row = Instance.new("Frame", scrollFrame)
    row.Size = UDim2.new(1,-s(32),0,s(42)); row.Position = UDim2.new(0,s(16),0,y)
    row.BackgroundColor3 = PAL.row; row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,9)
    applyFlowGradient(row)
    local stroke = Instance.new("UIStroke", row)
    stroke.Color = Color3.fromRGB(58,58,68); stroke.Thickness = 1
    boxSheen(row)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0,s(155),1,0); lbl.Position = UDim2.new(0,s(12),0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = "TP BEST PET"
    lbl.TextColor3 = PAL.textHi; lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local execBtn = Instance.new("TextButton", row)
    execBtn.Size = UDim2.new(0,s(56),0,s(24)); execBtn.Position = UDim2.new(1,-s(68),0.5,-s(12))
    execBtn.BackgroundColor3 = PAL.off; execBtn.BorderSizePixel = 0
    execBtn.Text = "TP"; execBtn.TextColor3 = PAL.textHi
    execBtn.Font = Enum.Font.GothamBold; execBtn.TextSize = 11; execBtn.ZIndex = 6
    Instance.new("UICorner", execBtn).CornerRadius = UDim.new(0,7)
    local tpTextGlow = Instance.new("UIStroke", execBtn)
    tpTextGlow.Color = Color3.fromRGB(255,255,255)
    tpTextGlow.Thickness = 0.7
    tpTextGlow.Transparency = 0.85
    local es = Instance.new("UIStroke", execBtn)
    es.Color = PAL.stroke; es.Thickness = 1.1
    execBtn.MouseButton1Click:Connect(function()
        task.spawn(runTPBest)
        local flash = TweenService:Create(execBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {BackgroundColor3 = PAL.accent, TextColor3 = Color3.fromRGB(12,12,14)})
        flash:Play()
        task.delay(0.35, function()
            if execBtn and execBtn.Parent then
                TweenService:Create(execBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                    {BackgroundColor3 = PAL.off, TextColor3 = PAL.textHi}):Play()
            end
        end)
    end)
end
y += s(50)

do
    local row = Instance.new("Frame", scrollFrame)
    row.Size = UDim2.new(1,-s(32),0,s(42)); row.Position = UDim2.new(0,s(16),0,y)
    row.BackgroundColor3 = PAL.row; row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,9)
    applyFlowGradient(row)
    local stroke = Instance.new("UIStroke", row)
    stroke.Color = Color3.fromRGB(58,58,68); stroke.Thickness = 1
    boxSheen(row)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0,s(160),1,0); lbl.Position = UDim2.new(0,s(12),0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = "TP BEST PET BIND"
    lbl.TextColor3 = PAL.textHi; lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left

    local keyWrap = Instance.new("Frame", row)
    keyWrap.Size = UDim2.new(0,s(82),0,s(26)); keyWrap.Position = UDim2.new(1,-s(90),0.5,-s(13))
    keyWrap.BackgroundColor3 = PAL.card; keyWrap.BorderSizePixel = 0
    Instance.new("UICorner", keyWrap).CornerRadius = UDim.new(0,7)
    local ks = Instance.new("UIStroke", keyWrap)
    ks.Color = PAL.stroke; ks.Thickness = 1.1
    boxSheen(keyWrap)
    local keyLbl = Instance.new("TextLabel", keyWrap)
    keyLbl.Size = UDim2.new(1,0,1,0); keyLbl.BackgroundTransparency = 1
    keyLbl.Font = Enum.Font.GothamBold
    keyLbl.TextSize = 11; keyLbl.ZIndex = 5
    _keyLabelRefs.tpBest = keyLbl
    refreshBindLabel("tpBest")
    textShine(keyLbl)

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.ZIndex = 6
    btn.MouseButton1Click:Connect(function()
        if _listeningFor == "tpBest" then
            _listeningFor = nil
            refreshBindLabel("tpBest")
        else
            setListeningFor("tpBest")
        end
    end)
end
y += s(50)

y += s(8)
scrollFrame.CanvasSize = UDim2.new(0,0,0,y+10)

local MINI_SIZE = UDim2.new(0, s(182), 0, s(56))

local function popShow(target, size)
    target.Visible = true
    target.Size = UDim2.new(size.X.Scale, math.floor(size.X.Offset*0.86), size.Y.Scale, math.floor(size.Y.Offset*0.86))
    TweenService:Create(target, TweenInfo.new(0.26, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = size}):Play()
end

local function popHide(target, onDone)
    local originalSize = target.Size
    local tw = TweenService:Create(target, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        {Size = UDim2.new(originalSize.X.Scale, math.floor(originalSize.X.Offset*0.86), originalSize.Y.Scale, math.floor(originalSize.Y.Offset*0.86))})
    tw.Completed:Connect(function()
        target.Visible = false
        target.Size = originalSize
        if onDone then onDone() end
    end)
    tw:Play()
end

miniPill = Instance.new("CanvasGroup", screen)
miniPill.Name             = "VX7HUBMini"
miniPill.Size             = MINI_SIZE
miniPill.Position         = frame.Position
miniPill.BackgroundColor3 = PAL.card
miniPill.BorderSizePixel  = 0
miniPill.Visible          = false
miniPill.Active           = true
miniPill.ClipsDescendants = true
Instance.new("UICorner", miniPill).CornerRadius = UDim.new(0, 16)
makeAnimatedGradient(miniPill)
local mpStroke = Instance.new("UIStroke", miniPill)
mpStroke.Color = Color3.fromRGB(36,36,44); mpStroke.Thickness = 1; mpStroke.Transparency = 0.15
boxSheen(miniPill)

local badge = Instance.new("Frame", miniPill)
badge.Size             = UDim2.new(0,s(40),0,s(40))
badge.Position         = UDim2.new(0,s(8),0.5,-s(20))
badge.BackgroundColor3 = PAL.base
badge.BorderSizePixel  = 0
Instance.new("UICorner", badge).CornerRadius = UDim.new(0,11)
local bGrad = Instance.new("UIGradient", badge)
bGrad.Rotation = 90
bGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(34,34,42)),
    ColorSequenceKeypoint.new(1, PAL.base),
})
local bStroke = Instance.new("UIStroke", badge)
bStroke.Color = PAL.stroke; bStroke.Thickness = 1
boxSheen(badge)
local bLbl = Instance.new("TextLabel", badge)
bLbl.Size = UDim2.new(1,0,1,0); bLbl.BackgroundTransparency = 1
bLbl.Text = "VX7"; bLbl.Font = Enum.Font.GothamBlack
bLbl.TextSize = 13; bLbl.TextColor3 = PAL.textHi
textShine(bLbl)

local mTitle = Instance.new("TextLabel", miniPill)
mTitle.Size = UDim2.new(1,-s(60),0,s(20)); mTitle.Position = UDim2.new(0,s(58),0,s(9))
mTitle.BackgroundTransparency = 1; mTitle.Text = "VX7 HUB"
mTitle.TextColor3 = PAL.textHi; mTitle.Font = Enum.Font.GothamBlack
mTitle.TextSize = 15; mTitle.TextXAlignment = Enum.TextXAlignment.Left
textShine(mTitle)

local mSub = Instance.new("TextLabel", miniPill)
mSub.Size = UDim2.new(1,-s(60),0,s(14)); mSub.Position = UDim2.new(0,s(58),0,s(31))
mSub.BackgroundTransparency = 1; mSub.Text = "ALL GEARS"
mSub.TextColor3 = PAL.textMid; mSub.Font = Enum.Font.GothamBold
mSub.TextSize = 10; mSub.TextXAlignment = Enum.TextXAlignment.Left

local miniOpen = Instance.new("TextButton", miniPill)
miniOpen.Size = UDim2.new(1,0,1,0)
miniOpen.BackgroundTransparency = 1
miniOpen.Text = ""
miniOpen.ZIndex = 5
miniOpen.Active = true

local mPressing = false
local mMoved    = false
local mDS, mSP

miniOpen.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        mPressing = true
        mMoved    = false
        mDS = i.Position
        mSP = miniPill.Position
    end
end)

UserInputService.InputChanged:Connect(function(i)
    if mPressing and (i.UserInputType == Enum.UserInputType.MouseMovement
    or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - mDS
        if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then
            mMoved = true
        end
        if mMoved then
            miniPill.Position = UDim2.new(mSP.X.Scale, mSP.X.Offset + d.X, mSP.Y.Scale, mSP.Y.Offset + d.Y)
            pillPlaced = true
            if tick() - lastLiveSave > 0.4 then
                lastLiveSave = tick()
                pcall(saveSettings)
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        if mPressing then
            if not mMoved then
                popHide(miniPill)
                popShow(frame, MAIN_FRAME_SIZE)
            end
            pcall(saveSettings)
        end
        mPressing = false
    end
end)

minBtn.MouseButton1Click:Connect(function()
    popHide(frame, function()
        if not pillPlaced then
            miniPill.Position = frame.Position
        end
        popShow(miniPill, MINI_SIZE)
        saveSettings()
    end)
end)

if pendingFramePos then frame.Position = pendingFramePos end
if pendingPillPos then
    miniPill.Position = pendingPillPos
    pillPlaced = true
end
if not pillPlaced then
    miniPill.Position = frame.Position
end

local lastCtrlToggle = 0

UserInputService.InputBegan:Connect(function(input, gpe)
    if _listeningFor then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local keyName = _listeningFor
            _listeningFor = nil
            if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Escape then
                Keybinds[keyName] = Enum.KeyCode.Unknown
            else
                Keybinds[keyName] = input.KeyCode
            end
            refreshBindLabel(keyName)
            saveSettings()
        end
        return
    end

    if gpe then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

    if input.KeyCode == Enum.KeyCode.LeftControl then
        local now = tick()
        if now - lastCtrlToggle < 0.3 then return end
        lastCtrlToggle = now

        if miniPill.Visible then
            mPressing = false
            popHide(miniPill)
            popShow(frame, MAIN_FRAME_SIZE)
        elseif frame.Visible then
            popHide(frame, function()
                if not pillPlaced then
                    miniPill.Position = frame.Position
                end
                popShow(miniPill, MINI_SIZE)
                saveSettings()
            end)
        else
            popShow(frame, MAIN_FRAME_SIZE)
        end
        pcall(saveSettings)
        return
    end

    if Keybinds.tpBest ~= Enum.KeyCode.Unknown and input.KeyCode == Keybinds.tpBest then
        task.spawn(runTPBest)
    end

    local function doKeybindToggle(stateKey, bindKey, startFn, stopFn)
        local kb = Keybinds[bindKey]
        if not kb or kb == Enum.KeyCode.Unknown then return end
        if input.KeyCode ~= kb then return end
        State[stateKey] = not State[stateKey]
        local on = State[stateKey]
        if _toggleSetFns[stateKey] then _toggleSetFns[stateKey](on) end
        if on then startFn() else stopFn() end
        saveSettings()
    end

    doKeybindToggle("antiSentryEnabled", "antiSentry", startAntiSentry, stopAntiSentry)
    doKeybindToggle("aldEnabled",        "ald",        startALD,        stopALD)
    doKeybindToggle("silentAimEnabled",  "silentAim",  saSetupTools,    saSetupTools)
    doKeybindToggle("spamLaser",         "spamLaser",  startSpamLaser,  stopSpamLaser)
    doKeybindToggle("spamPaint",         "spamPaint",  startSpamPaint,  stopSpamPaint)
    doKeybindToggle("counterLaser",      "counterLaser",  function() setCounter("laser") end,  function() setCounter(nil) end)
end)

local dragging, dragStart, startPos
header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = i.Position; startPos = frame.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
    or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
        if tick() - lastLiveSave > 0.4 then
            lastLiveSave = tick()
            pcall(saveSettings)
        end
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        if dragging then pcall(saveSettings) end
        dragging = false
    end
end)

LP.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    char:WaitForChild("Humanoid")
    task.wait(0.5)
    if State.antiSentryEnabled then stopAntiSentry(); startAntiSentry() end
    if State.aldEnabled        then stopALD();         startALD()        end
    if State.silentAimEnabled  then saSetupTools()                       end
    if State.spamLaser         then stopSpamLaser();   startSpamLaser()  end
    if State.spamPaint         then stopSpamPaint();   startSpamPaint()  end
    if State.counterLaser      then startCounter() end
    if State.mineESPEnabled    then stopMineESP();     startMineESP()    end
    if State.antiBeeDisco      then
        AntiBeeDisco.disconnectAll()
        AntiBeeDisco.Enable()
    end
end)

task.spawn(function()
    task.wait(0.5)
    if State.antiSentryEnabled then startAntiSentry() end
    if State.aldEnabled        then startALD()        end
    if State.silentAimEnabled  then saSetupTools()    end
    if State.spamLaser         then startSpamLaser()  end
    if State.spamPaint         then startSpamPaint()  end
    if State.counterLaser      then startCounter() end
    if State.mineESPEnabled    then startMineESP()    end
    if State.antiBeeDisco      then AntiBeeDisco.Enable() end
end)


pcall(function() if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = 70 end end)
task.spawn(function()
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        task.wait(0.05)
        pcall(function() if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = 70 end end)
    end)
end)
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            local cam = workspace.CurrentCamera
            if cam and math.abs(cam.FieldOfView - 70) > 0.5 then cam.FieldOfView = 70 end
        end)
    end
end)