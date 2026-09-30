local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local LP = Players.LocalPlayer

_G._VexulLoadingConfig = false

local State = {
    normalSpeed = 60, carrySpeed = 30, laggerSpeed = 13, laggerCarrySpeed = 13,
    speedType = "normal",
    laggerActive = false, laggerCarryActive = false,
    autoBatToggled = false,
    hittingCooldown = false, infJumpEnabled = false,
    antiRagdollEnabled = false, fpsBoostEnabled = false,
    guiVisible = true,
    isStealing = false, stealStartTime = nil, lastStealTick = 0,
    medusaLastUsed = 0, medusaDebounce = false, medusaCounterEnabled = false,
    dropBrainrotActive = false,
    autoTpDownEnabled = false, autoTpDownY = 20,
    autoLeftEnabled = false, autoRightEnabled = false,
    unwalkEnabled = false,
    autoLeftPhase = 1, autoRightPhase = 1,
    _tpInProgress = false,
    lastMoveDir = Vector3.new(0,0,0),
    infJumpMode = "manual",
    introEnabled  = false,
    cubeScale     = 100,
    buttonSize    = 58,
    centerButtonSize = 44,
    musicIndex    = 1,
    customToolsEnabled = false,
    customBatSkin = "DiamondSword",
    customMedusaSkin = "GoldenDesertEagle",
    rainbowToolsEnabled = false,
    avatarChanger = {},
    animPackIndex = 1,
    skyTheme = "Off",
    customAnimIds = { idle = "", walk = "", run = "", jump = "", fall = "", climb = "" },
    headlessEnabled = false,
    korbloxEnabled = false,
    stretchRezEnabled = false,
    customSongEnabled = false,
    rainbowJoystickEnabled = false,
    musicPlayerEnabled = false,
    musicPlayerVolume = 1,
    musicPlayerSpeed = 1,
    musicPlayerIndex = 1,
    musicAutoPlayNext = false,
    musicShuffleEnabled = false,
    musicLoopEnabled = false,
    uiLocked = false,
    buttonsLocked = false,
    tpBatOn = false,
    batV2On = false,
}
local introActive = false
local ToggleRegistry = {}

local INTRO_MUSIC_OPTIONS = {
    {name="Song 1", url="https://files.catbox.moe/4inuat.mp3", file="VexulIntro1.mp3"},
    {name="Song 2", url="https://files.catbox.moe/nyyijv.mp3", file="VexulIntro2.mp3"},
    {name="Song 3", url="https://files.catbox.moe/bumu1r.mp3", file="VexulIntro3.mp3"},
    {name="Song 4", url="https://files.catbox.moe/fvms23.mp3", file="VexulIntro4.mp3"},
    {name="Song 5", url="https://files.catbox.moe/jkbi33.mp3", file="VexulIntro5.mp3"},
}

local MUSIC_PLAYER_OPTIONS = {
    {name="Gelato", url="https://files.catbox.moe/sospih.mp3", file="VexulMusic1.mp3"},
    {name="Meant To Be", url="https://files.catbox.moe/smt6l8.mp3", file="VexulMusic2.mp3"},
    {name="Beccaria San Vittore RMX", url="https://files.catbox.moe/2r8auq.mp3", file="VexulMusic3.mp3"},
    {name="The Box", url="https://files.catbox.moe/yumqjl.mp3", file="VexulMusic4.mp3"},
    {name="Mu Ammar Gheddafi RMX", url="https://files.catbox.moe/qcuden.mp3", file="VexulMusic5.mp3"},
    {name="Marocchino RMX", url="https://files.catbox.moe/iyav31.mp3", file="VexulMusic6.mp3"},
    {name="Gotham Mashup", url="https://files.catbox.moe/7eof36.mp3", file="VexulMusic7.mp3"},
    {name="Goosebumps", url="https://files.catbox.moe/6wqcck.mp3", file="VexulMusic8.mp3"},
    {name="Houdini", url="https://files.catbox.moe/gsuxur.mp3", file="VexulMusic9.mp3"},
    {name="Magnolia", url="https://files.catbox.moe/ursllw.mp3", file="VexulMusic10.mp3"},
}

local AutoSteal = {
    Enabled = false, Radius = 20, Duration = 1.3,
    IsStealing = false, Data = {},
    ProgressFill = nil, ProgressText = nil, ProgressRadLbl = nil,
}

_G._VexulAllBtnContainers = _G._VexulAllBtnContainers or {}
_G._VexulRGBBars = _G._VexulRGBBars or {}

local function isMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots"); if not plots then return false end
    local plot = plots:FindFirstChild(plotName); if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end end
    return false
end

local function findNearestPrompt()
    local char = LP.Character; local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local plots = workspace:FindFirstChild("Plots"); if not plots then return nil end
    local bestPrompt, bestDist, bestName = nil, math.huge, nil
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local podiums = plot:FindFirstChild("AnimalPodiums"); if not podiums then continue end
        for _, pod in ipairs(podiums:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base"); local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local dist = (spawn.Position - root.Position).Magnitude
                    if dist < bestDist and dist <= AutoSteal.Radius then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then for _, child in ipairs(att:GetChildren()) do
                            if child:IsA("ProximityPrompt") then bestPrompt, bestDist, bestName = child, dist, pod.Name; break end
                        end end
                    end
                end
            end)
        end
    end
    return bestPrompt, bestDist, bestName
end

local function executeSteal(prompt)
    if AutoSteal.IsStealing then return end
    if not AutoSteal.Data[prompt] then
        AutoSteal.Data[prompt] = {hold={}, trigger={}, ready=true}
        pcall(function()
            if getconnections then
                for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(AutoSteal.Data[prompt].hold, c.Function) end end
                for _,c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(AutoSteal.Data[prompt].trigger, c.Function) end end
            end
        end)
    end
    local data = AutoSteal.Data[prompt]; if not data.ready then return end
    data.ready = false; AutoSteal.IsStealing = true
    local startTime = tick(); local conn
    conn = RunService.Heartbeat:Connect(function()
        if not AutoSteal.IsStealing then conn:Disconnect(); return end
        local prog = math.clamp((tick()-startTime)/AutoSteal.Duration,0,1)
        if AutoSteal.ProgressFill then AutoSteal.ProgressFill.Size = UDim2.new(prog,0,1,0) end
        if AutoSteal.ProgressText then AutoSteal.ProgressText.Text = math.floor(prog*100).."%" end
    end)
    task.spawn(function()
        for _,f in ipairs(data.hold) do task.spawn(f) end
        task.wait(AutoSteal.Duration)
        for _,f in ipairs(data.trigger) do task.spawn(f) end
        AutoSteal.IsStealing = false; data.ready = true
        task.wait(0.6)
        if not AutoSteal.IsStealing and AutoSteal.ProgressFill then
            TweenService:Create(AutoSteal.ProgressFill, TweenInfo.new(0.4), {Size=UDim2.new(0,0,1,0)}):Play()
        end
        if AutoSteal.ProgressText then AutoSteal.ProgressText.Text = "0%" end
    end)
end

local autoStealConnection = nil
local function startAutoSteal()
    if autoStealConnection then return end
    autoStealConnection = RunService.Heartbeat:Connect(function()
        if AutoSteal.Enabled and not AutoSteal.IsStealing then
            local p = findNearestPrompt(); if p then executeSteal(p) end
        end
    end)
end
local function stopAutoSteal()
    if autoStealConnection then autoStealConnection:Disconnect(); autoStealConnection = nil end
    AutoSteal.IsStealing = false
    for _,v in pairs(AutoSteal.Data) do if v.ready ~= nil then v.ready = true end end
end

local MOVE_KEYS = {[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
local POS = {L1=Vector3.new(-476.48,-6.28,92.73),L2=Vector3.new(-483.12,-4.95,94.80),R1=Vector3.new(-476.16,-6.52,25.62),R2=Vector3.new(-483.04,-5.09,23.14)}
local Conns = {autoSteal=nil,antiRag=nil,autoLeft=nil,autoRight=nil,unwalk=nil,anchor={},progress=nil}

local h, hrp
local setAutoLeft, setAutoRight, stopAutoLeft, stopAutoRight, startAutoLeft, startAutoRight
local setInstaGrab, setAutoBat, setInfJump, setAntiRag, setFps, setMedusaCounter, setAutoTpDown
local setUnwalk
local setupMedusaCounter, stopMedusaCounter, startAntiRagdoll, stopAntiRagdoll
local applyFPSBoost
local modeValLbl, normalBox, carryBox, laggerBox, carryLaggerBox
local setSpeedToggleUI, setLaggerToggleUI, setLaggerCarryUI
local progressRadLbl, setMenuDropBR, setMenuTpDown
local radiusBox
local setPlayIntro, uiScaleBox, introMusicLbl, autoTpDownYBox, buttonSizeBox, centerButtonSizeBox
local allCubeContainers = {}

local M = {}
M.CustomToolAssets = {
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

M.CustomAnimSlots = { "idle", "walk", "run", "jump", "fall", "climb" }
M.CustomAnimLabels = { idle = "IDLE", walk = "WALK", run = "RUN", jump = "JUMP", fall = "FALL", climb = "CLIMB" }
M._customWatchdog = M._customWatchdog or { tracked = {}, conns = {}, running = false }

function M._skinKeyForTool(tool)
    if not tool then return nil, nil end
    local n = tool.Name:lower()
    if n:find("bat") or n:find("slap") then return "Bat", State.customBatSkin end
    if n:find("medusa") or n:find("head") or n:find("stone") then return "Medusa", State.customMedusaSkin end
    return nil, nil
end

function M.applyCustomToolSkinToHandle(handle, skinKey)
    if not handle or not skinKey then return end
    local data = M.CustomToolAssets[skinKey]
    if not data then return end
    local existing = handle:FindFirstChild("VexulLocalReplica")
    if existing then
        local mesh = existing:FindFirstChildOfClass("SpecialMesh")
        if mesh and mesh.MeshId == data.mesh then return end
        existing:Destroy()
    end
    for _, d in ipairs(handle:GetDescendants()) do
        if d:IsA("MeshPart") or d:IsA("SpecialMesh") or d:IsA("Decal") then
            pcall(function()
                if d:IsA("BasePart") then d.Transparency = 1 end
                if d:IsA("Decal") then d.Transparency = 1 end
                if d:IsA("SpecialMesh") then d.Scale = Vector3.zero end
            end)
        end
    end
    if handle:IsA("BasePart") then handle.Transparency = 1 end
    local part = Instance.new("Part")
    part.Name = "VexulLocalReplica"
    part.Size = Vector3.new(1,1,1)
    part.Anchored = false
    part.CanCollide = false
    part.CanQuery = false
    part.CanTouch = false
    part.Massless = true
    part.Transparency = 0
    part.Parent = handle
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = data.mesh
    mesh.TextureId = data.tex or ""
    mesh.Scale = data.scale
    mesh.Parent = part
    local weld = Instance.new("Weld")
    weld.Part0 = handle
    weld.Part1 = part
    weld.C0 = data.c0 or CFrame.new()
    weld.Parent = part
end

function M.refreshCustomToolSkins()
    if not State.customToolsEnabled then return end
    local char = LP.Character
    local bp = LP:FindFirstChild("Backpack")
    local tools = {}
    if char then for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then table.insert(tools, t) end end end
    if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then table.insert(tools, t) end end end
    for _, tool in ipairs(tools) do
        local cat, key = M._skinKeyForTool(tool)
        if cat and key then
            local handle = tool:FindFirstChild("Handle")
            if handle then pcall(M.applyCustomToolSkinToHandle, handle, key) end
            M._customWatchdog.tracked[tool] = true
        end
    end
end

function M.clearCustomToolSkins()
    local char = LP.Character
    local bp = LP:FindFirstChild("Backpack")
    local roots = {}
    if char then table.insert(roots, char) end
    if bp then table.insert(roots, bp) end
    for _, root in ipairs(roots) do
        for _, tool in ipairs(root:GetChildren()) do
            if tool:IsA("Tool") then
                local handle = tool:FindFirstChild("Handle")
                if handle then
                    local rep = handle:FindFirstChild("VexulLocalReplica")
                    if rep then rep:Destroy() end
                    if handle:IsA("BasePart") then handle.Transparency = 0 end
                    for _, d in ipairs(handle:GetDescendants()) do
                        pcall(function()
                            if d:IsA("BasePart") then d.Transparency = 0 end
                            if d:IsA("Decal") then d.Transparency = 0 end
                        end)
                    end
                end
            end
        end
    end
    M._customWatchdog.tracked = {}
end

function M._customToolWatchdogStart()
    local W = M._customWatchdog
    if W.running then return end
    W.running = true
    local function watchContainer(container)
        if not container then return end
        if W.conns[container] then return end
        W.conns[container] = container.ChildAdded:Connect(function(child)
            if not State.customToolsEnabled then return end
            if child:IsA("Tool") then
                task.defer(function()
                    if not State.customToolsEnabled then return end
                    local cat, key = M._skinKeyForTool(child)
                    if cat and key then
                        local handle = child:FindFirstChild("Handle") or child:WaitForChild("Handle", 2)
                        if handle then
                            pcall(M.applyCustomToolSkinToHandle, handle, key)
                            W.tracked[child] = true
                        end
                    end
                end)
            end
        end)
    end
    watchContainer(LP:FindFirstChildOfClass("Backpack"))
    watchContainer(LP.Character)
    task.spawn(function()
        while W.running do
            task.wait(0.4)
            if not State.customToolsEnabled then
                W.running = false
                break
            end
            for tool in pairs(W.tracked) do
                if not tool.Parent then
                    W.tracked[tool] = nil
                else
                    local cat, key = M._skinKeyForTool(tool)
                    if cat and key then
                        local handle = tool:FindFirstChild("Handle")
                        if handle then pcall(M.applyCustomToolSkinToHandle, handle, key) end
                    end
                end
            end
            local char = LP.Character
            local bp = LP:FindFirstChildOfClass("Backpack")
            for _, root in ipairs({char, bp}) do
                if root then
                    for _, tool in ipairs(root:GetChildren()) do
                        if tool:IsA("Tool") then
                            local cat, key = M._skinKeyForTool(tool)
                            if cat and key then
                                local handle = tool:FindFirstChild("Handle")
                                if handle then pcall(M.applyCustomToolSkinToHandle, handle, key) end
                                W.tracked[tool] = true
                            end
                        end
                    end
                end
            end
        end
        for _, c in pairs(W.conns) do pcall(function() c:Disconnect() end) end
        W.conns = {}
    end)
end

function M._customToolWatchdogStop()
    local W = M._customWatchdog
    W.running = false
    for _, c in pairs(W.conns) do pcall(function() c:Disconnect() end) end
    W.conns = {}
    W.tracked = {}
end

M.RainbowTools = { enabled = false, tracked = {}, watchers = {} }
do
    local RB = M.RainbowTools
    local SPEED       = 0.35
    local SPREAD      = 0.035
    local UPDATE_STEP = 1 / 40

    local function classify(d)
        if d:IsA("MeshPart") then
            return { obj = d, kind = "part", props = {"Color","Material","TextureID"}, clearTexture = "TextureID" }
        elseif d:IsA("BasePart") then
            return { obj = d, kind = "part", props = {"Color","Material"} }
        elseif d:IsA("SurfaceAppearance") then
            return { obj = d, kind = "surface", props = {"Parent"} }
        elseif d:IsA("Decal") or d:IsA("Texture") then
            return { obj = d, kind = "decal", props = {} }
        elseif d:IsA("SpecialMesh") then
            return { obj = d, kind = "vector", prop = "VertexColor",
                     props = {"VertexColor","TextureId"}, clearTexture = "TextureId" }
        elseif d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then
            return { obj = d, kind = "sequence", prop = "Color", props = {"Color"} }
        elseif d:IsA("PointLight") or d:IsA("SpotLight") or d:IsA("SurfaceLight") then
            return { obj = d, kind = "color", prop = "Color", props = {"Color"} }
        elseif d:IsA("Highlight") then
            return { obj = d, kind = "color", prop = "FillColor", props = {"FillColor"} }
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
        if not node.original then return end
        for prop, val in pairs(node.original) do
            pcall(function() node.obj[prop] = val end)
        end
    end

    local function applyOnce(node)
        if node.kind == "surface" then
            pcall(function() node.obj.Parent = nil end)
        elseif node.kind == "decal" then
            pcall(function() node.obj.Transparency = 1 end)
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
        if RB.tracked[root] then return end
        local entry = { parts = {}, effects = {}, statics = {}, conns = {} }
        RB.tracked[root] = entry
        for _, d in ipairs(root:GetDescendants()) do addNode(entry, d) end
        if root:IsA("BasePart") then addNode(entry, root) end
        table.insert(entry.conns, root.DescendantAdded:Connect(function(d) addNode(entry, d) end))
        table.insert(entry.conns, root.AncestryChanged:Connect(function(_, parent)
            if not parent then
                local e = RB.tracked[root]
                if e then
                    for _, c in ipairs(e.conns) do pcall(function() c:Disconnect() end) end
                    RB.tracked[root] = nil
                end
            end
        end))
    end

    local function tryRegister(inst)
        if not RB.enabled then return end
        local n = inst.Name:lower()
        if inst:IsA("Tool") and (n:find("bat") or n:find("slap") or n:find("medusa")
           or n:find("head") or n:find("stone")) then
            register(inst)
        end
    end

    local function watch(container)
        if not container or RB.watchers[container] then return end
        RB.watchers[container] = container.ChildAdded:Connect(tryRegister)
        for _, child in ipairs(container:GetChildren()) do tryRegister(child) end
    end

    local function watchAll()
        watch(LP:FindFirstChildOfClass("Backpack"))
        watch(LP.Character)
    end

    LP.ChildAdded:Connect(function(child)
        if RB.enabled and child:IsA("Backpack") then watch(child) end
    end)
    LP.CharacterAdded:Connect(function(char)
        for root in pairs(RB.tracked) do
            local e = RB.tracked[root]
            if e then for _, c in ipairs(e.conns) do pcall(function() c:Disconnect() end) end end
            RB.tracked[root] = nil
        end
        for container in pairs(RB.watchers) do
            pcall(function() RB.watchers[container]:Disconnect() end)
            RB.watchers[container] = nil
        end
        if not RB.enabled then return end
        watch(char)
        task.defer(function() if RB.enabled then watchAll() end end)
    end)

    local acc = 0
    RunService.Heartbeat:Connect(function(dt)
        if not RB.enabled or next(RB.tracked) == nil then return end
        acc = acc + dt
        if acc < UPDATE_STEP then return end
        acc = 0
        local baseHue = (tick() * SPEED) % 1
        for _, entry in pairs(RB.tracked) do
            for i, node in ipairs(entry.parts) do
                if node.obj.Parent then
                    pcall(function() node.obj.Color = Color3.fromHSV((baseHue + (i-1)*SPREAD) % 1, 1, 1) end)
                end
            end
            for i, node in ipairs(entry.effects) do
                if node.obj.Parent then
                    local col = Color3.fromHSV((baseHue + (i-1)*SPREAD) % 1, 1, 1)
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

    function M.setRainbowTools(on)
        on = on and true or false
        RB.enabled = on
        State.rainbowToolsEnabled = on
        if on then watchAll()
        else
            for root in pairs(RB.tracked) do
                local e = RB.tracked[root]
                if e then
                    for _, c in ipairs(e.conns) do pcall(function() c:Disconnect() end) end
                    for _, node in ipairs(e.parts)   do restoreNode(node) end
                    for _, node in ipairs(e.effects) do restoreNode(node) end
                    for _, node in ipairs(e.statics) do restoreNode(node) end
                end
                RB.tracked[root] = nil
            end
        end
    end
end

M.AnimPacks = M.AnimPacks or {}
do
    local AP = M.AnimPacks
    AP.PACKS = {
        [1] = nil,
        [2] = { idle = "rbxassetid://619542203", walk = "rbxassetid://619544080", run  = "rbxassetid://619543231", jump = "rbxassetid://619542888", fall = "rbxassetid://619541867" },
        [3] = { idle = "rbxassetid://754637456", walk = "rbxassetid://754636298", run  = "rbxassetid://754635032", jump = "rbxassetid://754637084", fall = "rbxassetid://754636589" },
        [4] = { idle = "rbxassetid://1113742618", walk = "rbxassetid://1113741192", run  = "rbxassetid://1113740510", jump = "rbxassetid://1113742359", fall = "rbxassetid://1113742092" },
        [5] = { idle = "rbxassetid://126354114956642", walk = "rbxassetid://106810508343012", run  = "rbxassetid://124765145869332", jump = "rbxassetid://115715495289805", fall = "rbxassetid://93993406355955" },
        [6] = { idle = "rbxassetid://619535834", walk = "rbxassetid://619537468", run  = "rbxassetid://619536621", jump = "rbxassetid://619536283", fall = "rbxassetid://619535616" },
    }
    AP.enabled = false
    AP.conns = {}
    AP.tracks = {}
    AP.currentAnim = "idle"
    AP.charConn = nil

    local function loadTrack(animator, id)
        local animation = Instance.new("Animation")
        local success, result = pcall(function()
            local objects = game:GetObjects(id)
            for _, obj in pairs(objects) do
                if obj:IsA("Animation") then return obj.AnimationId end
                local deep = obj:FindFirstChildWhichIsA("Animation", true)
                if deep then return deep.AnimationId end
            end
        end)
        animation.AnimationId = (success and result) and result or id
        return animator:LoadAnimation(animation)
    end

    function AP.stopAll()
        for _, track in pairs(AP.tracks) do pcall(function() track:Stop(0) end) end
        AP.tracks = {}
        for _, c in ipairs(AP.conns) do pcall(function() c:Disconnect() end) end
        AP.conns = {}
    end

    function AP.startSystem(char)
        AP.stopAll()
        if not AP.enabled then return end
        local pack = AP.PACKS[State.animPackIndex]
        if not pack then return end
        local humanoid = char:WaitForChild("Humanoid")
        local animator = humanoid:WaitForChild("Animator")
        local Animate = char:FindFirstChild("Animate")
        if Animate then Animate.Disabled = true end
        task.wait(0.1)
        for _, t in pairs(animator:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
        for name, id in pairs(pack) do
            local track = loadTrack(animator, id)
            track.Looped = (name == "idle" or name == "walk" or name == "run" or name == "fall")
            if name == "idle" then track.Priority = Enum.AnimationPriority.Idle
            elseif name == "walk" or name == "run" then track.Priority = Enum.AnimationPriority.Movement
            else track.Priority = Enum.AnimationPriority.Action end
            AP.tracks[name] = track
        end
        local function playAnim(name, forceRestart)
            if not AP.enabled then return end
            if not AP.tracks[name] then return end
            if AP.currentAnim == name and not forceRestart then return end
            if AP.tracks[AP.currentAnim] and AP.currentAnim ~= name then
                pcall(function() AP.tracks[AP.currentAnim]:Stop(0.15) end)
            end
            AP.currentAnim = name
            if forceRestart then AP.tracks[name]:Stop() end
            AP.tracks[name]:Play(0.15)
        end
        table.insert(AP.conns, humanoid.Running:Connect(function(speed)
            if not AP.enabled then return end
            local state = humanoid:GetState()
            if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then return end
            if speed > 14 then playAnim("run") elseif speed > 0.5 then playAnim("walk") else playAnim("idle") end
        end))
        table.insert(AP.conns, humanoid.Jumping:Connect(function(active)
            if not AP.enabled or not active then return end
            playAnim("jump", true)
        end))
        table.insert(AP.conns, humanoid.FreeFalling:Connect(function(active)
            if not AP.enabled or not active then return end
            playAnim("fall")
        end))
        table.insert(AP.conns, humanoid.StateChanged:Connect(function(_, newState)
            if not AP.enabled then return end
            if newState == Enum.HumanoidStateType.Landed then
                if humanoid.MoveDirection.Magnitude > 0 then
                    if humanoid.WalkSpeed > 14 then playAnim("run") else playAnim("walk") end
                else playAnim("idle") end
            end
        end))
        AP.currentAnim = "idle"
        if AP.tracks.idle then AP.tracks.idle:Play(0.15) end
    end

    function AP.restoreDefault()
        AP.stopAll()
        local char = LP.Character
        if char then
            local Animate = char:FindFirstChild("Animate")
            if Animate then Animate.Disabled = false end
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                local animator = humanoid:FindFirstChild("Animator")
                if animator then
                    for _, t in pairs(animator:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
                end
            end
        end
    end

    function AP.setPack(index, skipSave)
        index = math.clamp(tonumber(index) or 1, 1, 6)
        State.animPackIndex = index
        if index == 1 then
            AP.enabled = false
            AP.restoreDefault()
        else
            AP.enabled = true
            local char = LP.Character
            if char then task.spawn(function() AP.startSystem(char) end) end
        end
        if _G._VexulApplyAnimPackVisual then pcall(_G._VexulApplyAnimPackVisual, index) end
        if not skipSave and type(autoSaveConfig) == "function" then pcall(autoSaveConfig) end
        return index
    end

    if not AP.charConn then
        AP.charConn = LP.CharacterAdded:Connect(function(newChar)
            task.wait(0.3)
            if AP.enabled and State.animPackIndex ~= 1 then
                task.spawn(function() AP.startSystem(newChar) end)
            end
        end)
    end
end

M.SkyTheme = M.SkyTheme or {}
do
    local ST = M.SkyTheme
    ST.PRESETS_LIST = {
        "Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night",
        "Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse",
        "Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky",
        "Clear Sky","Golden Hour","Moonlight","Cotton Candy","Monochrome","Rainbow",
        "Ultraviolet","Blue Hour","Nebula","Thunderhead","Fuchsia Dawn",
        "Ice Cavern","Crimson Dusk","Neon Rain","Copper Sky","Pearl Rose",
        "Red Giant","Moonfall","Ashfall","Marshlight","Abyss",
        "Timelapse","Lightning","Pulsar","Ionosphere","Midnight Sun",
        "Polar Night","Infrared","Sepia","Chrome","Supernova",
        "Mars","Titan","Dreamcore","Ember Night"
    }
    ST.PRESET_COLORS = {
        ["Off"]={120,120,120},["Night"]={120,60,180},["Aurora"]={150,90,200},["Sunset"]={255,140,60},
        ["Galaxy"]={40,20,90},["Cyber"]={0,200,255},["Sakura"]={255,180,205},["Pink Night"]={255,80,180},
        ["Blood Moon"]={200,40,40},["Emerald Dawn"]={80,200,140},["Volcanic"]={220,90,30},["Arctic"]={170,215,255},
        ["Midnight Ocean"]={30,80,160},["Vaporwave"]={255,100,220},["Toxic"]={150,210,90},["Solar Eclipse"]={255,150,40},
        ["Hellscape"]={210,50,20},["Heaven"]={255,250,225},["Storm"]={90,95,115},["Sunrise"]={255,180,100},
        ["Deep Space"]={20,10,45},["Lavender Dream"]={190,160,255},["Inferno"]={225,100,40},["Mint Sky"]={165,250,215},
        ["Clear Sky"]={110,190,255},["Golden Hour"]={255,190,110},["Moonlight"]={170,190,225},["Cotton Candy"]={255,180,225},
        ["Monochrome"]={152,152,152},["Rainbow"]={255,90,120},["Ultraviolet"]={150,40,240},["Blue Hour"]={80,120,190},
        ["Nebula"]={190,70,205},["Thunderhead"]={130,145,215},["Fuchsia Dawn"]={255,45,160},["Ice Cavern"]={150,215,240},
        ["Crimson Dusk"]={200,50,80},["Neon Rain"]={0,230,210},["Copper Sky"]={200,115,60},["Pearl Rose"]={255,215,228},
        ["Red Giant"]={215,75,45},["Moonfall"]={185,200,235},["Ashfall"]={112,104,98},["Marshlight"]={96,150,105},
        ["Abyss"]={15,70,80},["Timelapse"]={255,160,90},["Lightning"]={200,215,255},["Pulsar"]={120,160,255},
        ["Ionosphere"]={90,235,175},["Midnight Sun"]={255,205,120},["Polar Night"]={60,80,130},["Infrared"]={255,60,60},
        ["Sepia"]={190,150,100},["Chrome"]={190,200,215},["Supernova"]={255,245,220},["Mars"]={215,150,105},
        ["Titan"]={200,140,60},["Dreamcore"]={215,190,255},["Ember Night"]={235,110,45},
    }
    ST.PRESETS = {
        ["Off"]={kind="off"},
        ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
        ["Aurora"]={clock=14,brightness=2.2,ambient={140,130,150},outAmb={150,140,160},atm={dens=0.35,color={220,140,200},decay={200,120,160},glare=1.2,haze=1.6}},
        ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5}},
        ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
        ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2}},
        ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5}},
        ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4}},
        ["Blood Moon"]={clock=22.5,brightness=1.4,ambient={120,50,50},outAmb={130,60,60},atm={dens=0.5,color={180,50,50},decay={100,30,30},glare=0.9,haze=1.5}},
        ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2}},
        ["Volcanic"]={clock=19,brightness=1.6,ambient={170,90,50},outAmb={180,100,60},atm={dens=0.55,color={200,80,30},decay={150,50,20},glare=1.5,haze=2.0}},
        ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8}},
        ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
        ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4}},
        ["Toxic"]={clock=13,brightness=2.2,ambient={145,170,110},outAmb={155,180,120},atm={dens=0.4,color={130,200,90},decay={90,160,60},glare=1.2,haze=1.8}},
        ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
        ["Hellscape"]={clock=18,brightness=1.4,ambient={170,70,40},outAmb={180,80,50},atm={dens=0.5,color={200,50,20},decay={110,30,10},glare=1.8,haze=2.5}},
        ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5}},
        ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3}},
        ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2}},
        ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
        ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8}},
        ["Inferno"]={clock=17.5,brightness=1.8,ambient={200,100,50},outAmb={210,110,60},atm={dens=0.5,color={220,100,40},decay={180,70,20},glare=2.0,haze=2.4}},
        ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6}},
        ["Clear Sky"]={clock=13.5,brightness=3,ambient={180,200,220},outAmb={190,210,230},atm={dens=0.28,color={140,200,255},decay={90,160,230},glare=1.4,haze=1.4}},
        ["Golden Hour"]={clock=16.6,brightness=2.2,ambient={195,168,132},outAmb={205,178,142},atm={dens=0.36,color={240,195,140},decay={205,150,95},glare=1.3,haze=1.6}},
        ["Moonlight"]={clock=23.5,brightness=1.8,ambient={140,150,175},outAmb={150,160,185},atm={dens=0.4,color={170,190,225},decay={60,75,110},glare=0.8,haze=1.4}},
        ["Cotton Candy"]={clock=18,brightness=3,ambient={225,190,225},outAmb={235,200,235},atm={dens=0.35,color={255,180,225},decay={160,200,255},glare=1.6,haze=1.8}},
        ["Monochrome"]={clock=13,brightness=1.9,ambient={148,148,148},outAmb={158,158,158},atm={dens=0.5,color={125,125,125},decay={178,178,178},glare=0,haze=2.4}},
        ["Rainbow"]={clock=17.4,brightness=2.6,ambient={200,185,215},outAmb={210,195,225},atm={dens=0.3,color={130,70,255},decay={255,120,50},glare=1.8,haze=3},rainbow=true},
    }
    local function c3(t) return Color3.fromRGB(t[1], t[2], t[3]) end
    local function clearSky()
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:GetAttribute("_VexulSky") then pcall(function() v:Destroy() end) end
        end
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            for _, v in ipairs(terrain:GetChildren()) do
                if v:GetAttribute("_VexulSky") then pcall(function() v:Destroy() end) end
            end
        end
    end
    ST.conns = {}
    local function clearConns()
        for _, c in ipairs(ST.conns) do pcall(function() c:Disconnect() end) end
        ST.conns = {}
    end
    function ST.apply(mode, skipSave)
        State.skyTheme = mode or "Off"
        clearSky()
        clearConns()
        if mode == "Off" or not ST.PRESETS[mode] then
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            Lighting.FogColor = Color3.fromRGB(192,192,192)
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = true
            if not skipSave and type(autoSaveConfig)=="function" then autoSaveConfig() end
            return
        end
        local preset = ST.PRESETS[mode]
        local function createObjects()
            clearSky()
            if preset.atm then
                local atm = Instance.new("Atmosphere")
                atm:SetAttribute("_VexulSky", true)
                atm.Density = preset.atm.dens or 0.3
                atm.Color = c3(preset.atm.color or {200,200,200})
                atm.Decay = c3(preset.atm.decay or {100,100,100})
                atm.Glare = preset.atm.glare or 1
                atm.Haze = preset.atm.haze or 1
                atm.Parent = Lighting
            end
        end
        if preset.clock then Lighting.ClockTime = preset.clock end
        if preset.brightness then Lighting.Brightness = preset.brightness end
        if preset.ambient then Lighting.Ambient = c3(preset.ambient) end
        if preset.outAmb then Lighting.OutdoorAmbient = c3(preset.outAmb) end
        createObjects()
        local function onForeignAdded(obj)
            if State.skyTheme == "Off" then return end
            if obj:GetAttribute("_VexulSky") then return end
            if obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") then
                pcall(function() obj:Destroy() end)
                task.defer(createObjects)
            end
        end
        table.insert(ST.conns, Lighting.DescendantAdded:Connect(onForeignAdded))
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then table.insert(ST.conns, terrain.DescendantAdded:Connect(onForeignAdded)) end
        if not skipSave and type(autoSaveConfig)=="function" then autoSaveConfig() end
    end
end

local saveDebounce = false
function autoSaveConfig()
    if saveDebounce then return end
    if _G._VexulLoadingConfig then return end
    saveDebounce = true
    task.delay(0.3, function()
        local avatarChangerOut = {}
        if type(State.avatarChanger) == "table" then
            for k, v in pairs(State.avatarChanger) do
                if type(k) == "string" and type(v) == "table" then
                    avatarChangerOut[k] = {
                        enabled = v.enabled == true,
                        savedId = tonumber(v.savedId),
                        savedName = tostring(v.savedName or ""),
                    }
                end
            end
        end
        local cfg = {
            normalSpeed=State.normalSpeed, carrySpeed=State.carrySpeed,
            laggerSpeed=State.laggerSpeed, laggerCarrySpeed=State.laggerCarrySpeed,
            speedType=State.speedType, laggerActive=State.laggerActive, laggerCarryActive=State.laggerCarryActive,
            autoStealEnabled=AutoSteal.Enabled, grabRadius=AutoSteal.Radius,
            infJump=State.infJumpEnabled, antiRagdoll=State.antiRagdollEnabled,
            fpsBoost=State.fpsBoostEnabled, medusaCounter=State.medusaCounterEnabled,
            autoTpDown=State.autoTpDownEnabled, autoTpDownY=State.autoTpDownY,
            unwalkEnabled=State.unwalkEnabled,
            infJumpMode=State.infJumpMode,
            introEnabled=State.introEnabled,
            cubeScale=State.cubeScale,
            buttonSize=State.buttonSize,
            centerButtonSize=State.centerButtonSize,
            musicIndex=State.musicIndex,
            customToolsEnabled=State.customToolsEnabled,
            customBatSkin=State.customBatSkin,
            customMedusaSkin=State.customMedusaSkin,
            rainbowToolsEnabled=State.rainbowToolsEnabled,
            animPackIndex=State.animPackIndex,
            skyTheme=State.skyTheme,
            avatarChanger=avatarChangerOut,
            headlessEnabled=State.headlessEnabled,
            korbloxEnabled=State.korbloxEnabled,
            stretchRezEnabled=State.stretchRezEnabled,
            customSongEnabled=State.customSongEnabled,
            rainbowJoystickEnabled=State.rainbowJoystickEnabled,
            musicPlayerEnabled=State.musicPlayerEnabled,
            musicPlayerVolume=State.musicPlayerVolume,
            musicPlayerSpeed=State.musicPlayerSpeed,
            musicPlayerIndex=State.musicPlayerIndex,
            musicAutoPlayNext=State.musicAutoPlayNext,
            musicShuffleEnabled=State.musicShuffleEnabled,
            musicLoopEnabled=State.musicLoopEnabled,
            uiLocked=State.uiLocked,
            buttonsLocked=State.buttonsLocked,
            tpBatOn=State.tpBatOn,
            batV2On=State.batV2On,
        }
        pcall(function() writefile("VexulHubConfig.json", HttpService:JSONEncode(cfg)) end)
        saveDebounce = false
    end)
end

local MobileButtons = {Visible=true, Locked=false, Frame=nil, Containers={}, Buttons={}}

local function refreshUIToggles()
    if setSpeedToggleUI then setSpeedToggleUI(State.speedType=="carry") end
    if setLaggerToggleUI then setLaggerToggleUI(State.laggerActive) end
    if setLaggerCarryUI then setLaggerCarryUI(State.laggerCarryActive) end
    if modeValLbl then
        if State.laggerCarryActive then modeValLbl.Text="Lagger Carry"
        elseif State.laggerActive then modeValLbl.Text="Lagger"
        else modeValLbl.Text=(State.speedType=="normal") and "Normal" or "Carry" end
    end
end

local function deactivateAllSpeedModes()
    if State.speedType=="carry" then State.speedType="normal"
        if MobileButtons.Buttons.carrySpeed then MobileButtons.Buttons.carrySpeed(false) end end
    if State.laggerActive then State.laggerActive=false; AutoSteal.Enabled=false
        if setInstaGrab then setInstaGrab(false) end; stopAutoSteal()
        if MobileButtons.Buttons.lagger then MobileButtons.Buttons.lagger(false) end end
    if State.laggerCarryActive then State.laggerCarryActive=false; AutoSteal.Enabled=false
        if setInstaGrab then setInstaGrab(false) end; stopAutoSteal()
        if MobileButtons.Buttons.laggerCarry then MobileButtons.Buttons.laggerCarry(false) end end
end

local function getCurrentSpeed()
    if State.laggerCarryActive or State.laggerActive then return State.laggerCarrySpeed end
    return State.speedType=="normal" and State.normalSpeed or State.carrySpeed
end
local function getAutoMoveSpeed()
    if State.laggerCarryActive then return State.normalSpeed
    elseif State.laggerActive then return State.laggerSpeed
    else return State.normalSpeed end
end

local function tpToGround()
    local char=LP.Character; if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local rot=root.CFrame.Rotation; local rp=RaycastParams.new()
    rp.FilterType=Enum.RaycastFilterType.Exclude; rp.FilterDescendantsInstances={char}
    local rr=workspace:Raycast(root.Position,Vector3.new(0,-500,0),rp)
    if rr then root.CFrame=CFrame.new(rr.Position+Vector3.new(0,3,0))*rot
    else root.CFrame=CFrame.new(root.Position+Vector3.new(0,-20,0))*rot end
end

local function runDropBrainrot()
    if State.dropBrainrotActive then return end
    State.dropBrainrotActive = true
    task.spawn(function()
        local colConn = RunService.Stepped:Connect(function()
            if not State.dropBrainrotActive then return end
            for _,p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    for _,part in ipairs(p.Character:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end
        end)
        task.spawn(function()
            while State.dropBrainrotActive do
                RunService.Heartbeat:Wait()
                local c = LP.Character; local root = c and c:FindFirstChild("HumanoidRootPart")
                if not root then continue end
                local vel = root.Velocity
                root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if root and root.Parent then root.Velocity = vel end
                RunService.Stepped:Wait()
                if root and root.Parent then root.Velocity = vel + Vector3.new(0, 0.1, 0) end
            end
        end)
        task.wait(0.15)
        State.dropBrainrotActive = false
        colConn:Disconnect()
    end)
end

local introSongCache = {}
local introSongDownloading = {}
local introPreviewSound = nil
local introPlaybackSound = nil

local function cacheIntroSong(option, allowDownload)
    if not option or not option.url or option.url == "" then return nil end
    if not (writefile and getcustomasset) then return nil end
    local fileName = option.file or ("VexulIntro_" .. tostring(option.name or "song") .. ".mp3")
    local function loadExisting()
        if introSongCache[fileName] then return introSongCache[fileName] end
        local hasFile = false
        pcall(function() hasFile = isfile and isfile(fileName) end)
        if hasFile then
            local ok = pcall(function() introSongCache[fileName] = getcustomasset(fileName) end)
            if ok and introSongCache[fileName] then return introSongCache[fileName] end
        end
        return nil
    end
    local cached = loadExisting()
    if cached then return cached end
    if allowDownload == false then return nil end
    if introSongDownloading[fileName] then
        local waitStart = tick()
        while introSongDownloading[fileName] and tick() - waitStart < 12 do task.wait(0.05) end
        cached = loadExisting()
        if cached then return cached end
    end
    introSongDownloading[fileName] = true
    local ok = pcall(function()
        local data = game:HttpGet(option.url)
        if data and #data > 0 then
            writefile(fileName, data)
            introSongCache[fileName] = getcustomasset(fileName)
        end
    end)
    introSongDownloading[fileName] = nil
    if ok and introSongCache[fileName] then return introSongCache[fileName] end
    return loadExisting()
end

local function stopIntroPlayback()
    if introPlaybackSound then
        local sound = introPlaybackSound
        introPlaybackSound = nil
        TweenService:Create(sound, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {Volume = 0}):Play()
        task.delay(1.6, function()
            pcall(function() if sound and sound.Parent then sound:Stop(); sound:Destroy() end end)
        end)
    end
end

local function playIntroSequence()
    local _TS = TweenService
    local _SS = SoundService
    local _PG = LP:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VexulHubIntro"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 999
    screenGui.Parent = _PG
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.9,0,0.25,0)
    title.Position = UDim2.new(0.05,0,0.35,0)
    title.BackgroundTransparency = 1
    title.Text = "VEXUL HUB"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.TextTransparency = 1
    title.TextScaled = true
    title.Font = Enum.Font.GothamBlack
    title.TextStrokeTransparency = 0.3
    title.TextStrokeColor3 = Color3.new(0,0,0)
    title.Parent = screenGui

    local idx = math.clamp(State.musicIndex or 1, 1, #INTRO_MUSIC_OPTIONS)
    local opt = INTRO_MUSIC_OPTIONS[idx]
    local soundId = cacheIntroSong(opt, true)
    local sound = nil
    if soundId then
        sound = Instance.new("Sound")
        sound.SoundId = soundId
        sound.Volume = 0.75
        sound.Looped = false
        sound.Parent = _SS
        sound:Play()
        introPlaybackSound = sound
    end

    _TS:Create(title, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
    task.wait(5)
    _TS:Create(title, TweenInfo.new(1.1, Enum.EasingStyle.Quint), {TextTransparency = 1}):Play()
    task.wait(1.3)
    screenGui:Destroy()
    stopIntroPlayback()
end

M.MusicPlayer = M.MusicPlayer or {}
do
    local MP = M.MusicPlayer
    MP.cache = {}
    MP.downloading = {}
    MP.sound = nil
    MP.token = 0
    MP.gui = nil

    local function cacheSong(option, allowDownload)
        if not option or not option.url or option.url == "" then return nil end
        if not (writefile and getcustomasset) then return nil end
        local fileName = option.file or ("VexulMusic_" .. tostring(option.name or "song") .. ".mp3")
        local function loadExisting()
            if MP.cache[fileName] then return MP.cache[fileName] end
            local hasFile = false
            pcall(function() hasFile = isfile and isfile(fileName) end)
            if hasFile then
                local ok = pcall(function() MP.cache[fileName] = getcustomasset(fileName) end)
                if ok and MP.cache[fileName] then return MP.cache[fileName] end
            end
            return nil
        end
        local cached = loadExisting()
        if cached then return cached end
        if allowDownload == false then return nil end
        if MP.downloading[fileName] then
            local waitStart = tick()
            while MP.downloading[fileName] and tick() - waitStart < 15 do task.wait(0.05) end
            cached = loadExisting()
            if cached then return cached end
        end
        MP.downloading[fileName] = true
        local ok = pcall(function()
            local data = game:HttpGet(option.url)
            if data and #data > 0 then
                writefile(fileName, data)
                MP.cache[fileName] = getcustomasset(fileName)
            end
        end)
        MP.downloading[fileName] = nil
        if ok and MP.cache[fileName] then return MP.cache[fileName] end
        return loadExisting()
    end

    local function _fmt(t)
        t = math.max(0, math.floor(tonumber(t) or 0))
        return string.format("%d:%02d", math.floor(t/60), t%60)
    end

    function MP.getSongName()
        local opt = MUSIC_PLAYER_OPTIONS[State.musicPlayerIndex]
        return opt and opt.name or "No Song"
    end

    function MP.stop(fade)
        MP.token = MP.token + 1
        local s = MP.sound
        MP.sound = nil
        if s then
            if fade == false then
                pcall(function() s:Stop(); s:Destroy() end)
            else
                TweenService:Create(s, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {Volume = 0}):Play()
                task.delay(1.6, function()
                    pcall(function() if s and s.Parent then s:Stop(); s:Destroy() end end)
                end)
            end
        end
    end

    function MP.play(index)
        index = tonumber(index) or State.musicPlayerIndex
        local total = #MUSIC_PLAYER_OPTIONS
        if total <= 0 then return end
        if index < 1 then index = total end
        if index > total then index = 1 end
        if not MUSIC_PLAYER_OPTIONS[index] then return end
        State.musicPlayerIndex = index
        MP.stop(true)
        local token = MP.token
        task.spawn(function()
            local opt = MUSIC_PLAYER_OPTIONS[index]
            local sid = cacheSong(opt, true)
            if not sid then return end
            if token ~= MP.token then return end
            local sound = Instance.new("Sound")
            sound.Name = "VexulMusicPlayer_" .. tostring(token)
            sound.SoundId = sid
            sound.Volume = State.musicPlayerVolume
            sound.PlaybackSpeed = State.musicPlayerSpeed
            sound.Looped = false
            sound.Parent = SoundService
            MP.sound = sound
            local loadStart = tick()
            while sound and sound.Parent and not sound.IsLoaded and tick() - loadStart < 15 do task.wait(0.05) end
            if token ~= MP.token then
                pcall(function() sound:Destroy() end); return
            end
            pcall(function() sound:Play() end)
            if MP.refreshUI then pcall(MP.refreshUI) end

            sound.Ended:Connect(function()
                if token ~= MP.token then return end
                if State.musicLoopEnabled then
                    MP.play(State.musicPlayerIndex)
                elseif State.musicShuffleEnabled then
                    local r = math.random(1, #MUSIC_PLAYER_OPTIONS)
                    MP.play(r)
                elseif State.musicAutoPlayNext then
                    MP.play(State.musicPlayerIndex + 1)
                else
                    MP.stop(false)
                end
            end)
        end)
    end

    function MP.togglePlay()
        local s = MP.sound
        if not s or not s.Parent then
            MP.play(State.musicPlayerIndex)
            return
        end
        if s.IsPlaying then
            pcall(function() s:Pause() end)
        else
            pcall(function() s:Resume() end)
        end
        if MP.refreshUI then pcall(MP.refreshUI) end
    end

    function MP.next()
        if State.musicShuffleEnabled then
            MP.play(math.random(1, #MUSIC_PLAYER_OPTIONS))
        else
            MP.play(State.musicPlayerIndex + 1)
        end
        autoSaveConfig()
    end

    function MP.prev()
        if State.musicShuffleEnabled then
            MP.play(math.random(1, #MUSIC_PLAYER_OPTIONS))
        else
            MP.play(State.musicPlayerIndex - 1)
        end
        autoSaveConfig()
    end

    function MP.seek(delta)
        local s = MP.sound
        if not s or not s.Parent then return end
        local len = s.TimeLength or 0
        local sp = tonumber(State.musicPlayerSpeed) or 1
        if sp <= 0 then sp = 1 end
        local newPos = s.TimePosition + ((tonumber(delta) or 0) * sp)
        if newPos < 0 then newPos = 0 end
        if len > 0 and newPos > (len - 0.2) then newPos = math.max(len - 0.2, 0) end
        pcall(function() s.TimePosition = newPos end)
        if MP.refreshUI then pcall(MP.refreshUI) end
    end

    function MP.setVolume(v)
        v = math.clamp(math.floor((tonumber(v) or 1) * 100 + 0.5) / 100, 0, 2)
        State.musicPlayerVolume = v
        local s = MP.sound
        if s and s.Parent then pcall(function() s.Volume = v end) end
        autoSaveConfig()
        if MP.refreshUI then pcall(MP.refreshUI) end
    end

    function MP.setSpeed(v)
        v = math.clamp(math.floor((tonumber(v) or 1) * 10 + 0.5) / 10, 0.1, 2)
        State.musicPlayerSpeed = v
        local s = MP.sound
        if s and s.Parent then pcall(function() s.PlaybackSpeed = v end) end
        autoSaveConfig()
        if MP.refreshUI then pcall(MP.refreshUI) end
    end

    function MP.setEnabled(on)
        State.musicPlayerEnabled = on
        if not on then MP.stop(true) end
        autoSaveConfig()
    end

    function MP.openUI()
        if MP.gui and MP.gui.Parent then
            MP.gui:Destroy()
            MP.gui = nil
            MP.refreshUI = nil
            return
        end
        local PG = LP:WaitForChild("PlayerGui")
        local gui = Instance.new("ScreenGui")
        gui.Name = "VexulMusicPlayer"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 9999
        gui.Parent = PG
        MP.gui = gui

        local backdrop = Instance.new("Frame", gui)
        backdrop.Size = UDim2.new(1,0,1,0)
        backdrop.BackgroundColor3 = Color3.fromRGB(0,0,0)
        backdrop.BackgroundTransparency = 0.5
        backdrop.BorderSizePixel = 0

        local POPUP_W, POPUP_H = 340, 418
        local frame = Instance.new("Frame", gui)
        frame.Name = "Frame"
        frame.Size = UDim2.new(0, POPUP_W, 0, POPUP_H)
        frame.Position = UDim2.new(0.5, -POPUP_W/2, 0.5, -POPUP_H/2)
        frame.BackgroundColor3 = Color3.fromRGB(10,10,12)
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
        local fSt = Instance.new("UIStroke", frame)
        fSt.Color = Color3.fromRGB(90,90,105); fSt.Thickness = 1.2; fSt.Transparency = 0.3

        local titleBar = Instance.new("Frame", frame)
        titleBar.Size = UDim2.new(1,0,0,48)
        titleBar.BackgroundColor3 = Color3.fromRGB(14,14,17)
        titleBar.BackgroundTransparency = 0.1
        titleBar.BorderSizePixel = 0
        Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 16)

        local titleLabel = Instance.new("TextLabel", titleBar)
        titleLabel.Size = UDim2.new(1,-60,1,0)
        titleLabel.Position = UDim2.new(0,16,0,0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = "MUSIC PLAYER"
        titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
        titleLabel.Font = Enum.Font.GothamBlack
        titleLabel.TextSize = 14
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left

        local closeBtn = Instance.new("TextButton", titleBar)
        closeBtn.Size = UDim2.new(0,32,0,32)
        closeBtn.Position = UDim2.new(1,-40,0,8)
        closeBtn.BackgroundColor3 = Color3.fromRGB(25,25,28)
        closeBtn.BorderSizePixel = 0
        closeBtn.Text = "X"; closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
        closeBtn.Font = Enum.Font.GothamBlack; closeBtn.TextSize = 13
        closeBtn.AutoButtonColor = false
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
        closeBtn.MouseButton1Click:Connect(function()
            if MP.gui then MP.gui:Destroy(); MP.gui = nil; MP.refreshUI = nil end
        end)

        local nameLbl = Instance.new("TextLabel", frame)
        nameLbl.Name = "SongName"
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = MP.getSongName()
        nameLbl.TextColor3 = Color3.fromRGB(255,255,255)
        nameLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        nameLbl.TextStrokeTransparency = 0.35
        nameLbl.Font = Enum.Font.GothamBlack
        nameLbl.TextSize = 16
        nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        nameLbl.TextXAlignment = Enum.TextXAlignment.Center
        nameLbl.Position = UDim2.new(0,14,0,56)
        nameLbl.Size = UDim2.new(1,-28,0,26)

        local counterLbl = Instance.new("TextLabel", frame)
        counterLbl.Name = "TrackCounter"
        counterLbl.BackgroundTransparency = 1
        counterLbl.Text = ""
        counterLbl.TextColor3 = Color3.fromRGB(150,150,168)
        counterLbl.Font = Enum.Font.GothamBold
        counterLbl.TextSize = 10
        counterLbl.TextXAlignment = Enum.TextXAlignment.Center
        counterLbl.Position = UDim2.new(0,14,0,83)
        counterLbl.Size = UDim2.new(1,-28,0,14)

        local barBg = Instance.new("Frame", frame)
        barBg.BackgroundColor3 = Color3.fromRGB(26,26,32)
        barBg.BorderSizePixel = 0
        barBg.Size = UDim2.new(1,-28,0,6)
        barBg.Position = UDim2.new(0,14,0,105)
        Instance.new("UICorner", barBg).CornerRadius = UDim.new(1,0)

        local barFill = Instance.new("Frame", barBg)
        barFill.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
        barFill.BorderSizePixel = 0
        barFill.Size = UDim2.new(0,0,1,0)
        Instance.new("UICorner", barFill).CornerRadius = UDim.new(1,0)

        local curLbl = Instance.new("TextLabel", frame)
        curLbl.BackgroundTransparency = 1
        curLbl.Text = "0:00"
        curLbl.TextColor3 = Color3.fromRGB(150,150,168)
        curLbl.Font = Enum.Font.GothamBold
        curLbl.TextSize = 10
        curLbl.TextXAlignment = Enum.TextXAlignment.Left
        curLbl.Position = UDim2.new(0,14,0,114)
        curLbl.Size = UDim2.new(0,60,0,14)

        local totLbl = Instance.new("TextLabel", frame)
        totLbl.BackgroundTransparency = 1
        totLbl.Text = "0:00"
        totLbl.TextColor3 = Color3.fromRGB(150,150,168)
        totLbl.Font = Enum.Font.GothamBold
        totLbl.TextSize = 10
        totLbl.TextXAlignment = Enum.TextXAlignment.Right
        totLbl.Position = UDim2.new(1,-74,0,114)
        totLbl.Size = UDim2.new(0,60,0,14)

        local ctrl = Instance.new("Frame", frame)
        ctrl.BackgroundTransparency = 1
        ctrl.Size = UDim2.new(1,-24,0,50)
        ctrl.Position = UDim2.new(0,12,0,136)

        local function smallBtn(parent, name, text, size, pos, ts)
            local b = Instance.new("TextButton", parent)
            b.Name = name
            b.BackgroundColor3 = Color3.fromRGB(8,8,14)
            b.BackgroundTransparency = 0.05
            b.BorderSizePixel = 0
            b.Text = text
            b.TextColor3 = Color3.fromRGB(245,245,255)
            b.TextSize = ts or 13
            b.Font = Enum.Font.GothamBlack
            b.AutoButtonColor = false
            b.Size = size; b.Position = pos
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
            local st = Instance.new("UIStroke", b)
            st.Color = Color3.fromRGB(90,90,105); st.Thickness = 1; st.Transparency = 0.5
            return b
        end

        local prevBtn = smallBtn(ctrl, "Prev", "<", UDim2.new(0,42,0,38), UDim2.new(0,0,0,6), 15)
        local back10 = smallBtn(ctrl, "Back10", "<< 10", UDim2.new(0,48,0,40), UDim2.new(0.5,-84,0,5), 11)
        local fwd10  = smallBtn(ctrl, "Fwd10", "10 >>", UDim2.new(0,48,0,40), UDim2.new(0.5,36,0,5), 11)
        local nextBtn = smallBtn(ctrl, "Next", ">", UDim2.new(0,42,0,38), UDim2.new(1,-42,0,6), 15)

        local playHolder = Instance.new("Frame", ctrl)
        playHolder.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
        playHolder.BorderSizePixel = 0
        playHolder.Size = UDim2.new(0,58,0,46)
        playHolder.Position = UDim2.new(0.5,-29,0,2)
        playHolder.ClipsDescendants = true
        Instance.new("UICorner", playHolder).CornerRadius = UDim.new(0, 14)
        local phSt = Instance.new("UIStroke", playHolder)
        phSt.Color = Color3.fromRGB(147, 197, 253); phSt.Thickness = 1.5; phSt.Transparency = 0.15

        local playBtn = Instance.new("TextButton", playHolder)
        playBtn.BackgroundTransparency = 1
        playBtn.BorderSizePixel = 0
        playBtn.Text = "PLAY"
        playBtn.TextColor3 = Color3.fromRGB(255,255,255)
        playBtn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        playBtn.TextStrokeTransparency = 0.3
        playBtn.TextSize = 11
        playBtn.Font = Enum.Font.GothamBlack
        playBtn.AutoButtonColor = false
        playBtn.Size = UDim2.new(1,0,1,0)

        prevBtn.MouseButton1Click:Connect(function() MP.prev() end)
        nextBtn.MouseButton1Click:Connect(function() MP.next() end)
        back10.MouseButton1Click:Connect(function() MP.seek(-10) end)
        fwd10.MouseButton1Click:Connect(function() MP.seek(10) end)
        playBtn.MouseButton1Click:Connect(function() MP.togglePlay() end)

        local function makeToggle(label, getVal, setVal, yPos)
            local f = Instance.new("Frame", frame)
            f.BackgroundColor3 = Color3.fromRGB(18,18,22)
            f.BackgroundTransparency = 0.1
            f.BorderSizePixel = 0
            f.Size = UDim2.new(1,-24,0,36)
            f.Position = UDim2.new(0,12,0,yPos)
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 9)
            local fs = Instance.new("UIStroke", f)
            fs.Color = Color3.fromRGB(90,90,105); fs.Thickness = 1; fs.Transparency = 0.45

            local lbl = Instance.new("TextLabel", f)
            lbl.BackgroundTransparency = 1
            lbl.Text = label
            lbl.TextColor3 = Color3.fromRGB(245,245,255)
            lbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            lbl.TextStrokeTransparency = 0.35
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Position = UDim2.new(0,12,0,0)
            lbl.Size = UDim2.new(1,-92,1,0)

            local pillBg = Instance.new("Frame", f)
            pillBg.BackgroundColor3 = Color3.fromRGB(8,8,14)
            pillBg.BorderSizePixel = 0
            pillBg.Size = UDim2.new(0,60,0,24)
            pillBg.Position = UDim2.new(1,-72,0.5,-12)
            Instance.new("UICorner", pillBg).CornerRadius = UDim.new(0, 12)
            local pbs = Instance.new("UIStroke", pillBg)
            pbs.Color = Color3.fromRGB(90,90,105); pbs.Thickness = 1; pbs.Transparency = 0.5

            local pill = Instance.new("TextButton", f)
            pill.BackgroundTransparency = 1
            pill.BorderSizePixel = 0
            pill.Text = "OFF"
            pill.TextColor3 = Color3.fromRGB(180,180,180)
            pill.Font = Enum.Font.GothamBlack
            pill.TextSize = 11
            pill.AutoButtonColor = false
            pill.Size = UDim2.new(0,60,0,24)
            pill.Position = UDim2.new(1,-72,0.5,-12)

            local function apply(v)
                if v then
                    pill.Text = "ON"
                    pill.TextColor3 = Color3.fromRGB(255,255,255)
                    pillBg.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
                    pbs.Color = Color3.fromRGB(147, 197, 253)
                    pbs.Transparency = 0.15
                else
                    pill.Text = "OFF"
                    pill.TextColor3 = Color3.fromRGB(180,180,180)
                    pillBg.BackgroundColor3 = Color3.fromRGB(8,8,14)
                    pbs.Color = Color3.fromRGB(90,90,105)
                    pbs.Transparency = 0.5
                end
            end
            apply(getVal() == true)
            pill.MouseButton1Click:Connect(function()
                local nv = not (getVal() == true)
                setVal(nv)
                apply(nv)
            end)
            return apply
        end

        local applyAuto = makeToggle("Auto Play Next",
            function() return State.musicAutoPlayNext end,
            function(v) State.musicAutoPlayNext = v; autoSaveConfig() end, 194)

        local applyShuffle = makeToggle("Shuffle",
            function() return State.musicShuffleEnabled end,
            function(v) State.musicShuffleEnabled = v; autoSaveConfig() end, 236)

        local applyLoop = makeToggle("Loop",
            function() return State.musicLoopEnabled end,
            function(v) State.musicLoopEnabled = v; autoSaveConfig() end, 278)

        local volFrame = Instance.new("Frame", frame)
        volFrame.BackgroundColor3 = Color3.fromRGB(18,18,22)
        volFrame.BackgroundTransparency = 0.1
        volFrame.BorderSizePixel = 0
        volFrame.Size = UDim2.new(1,-24,0,36)
        volFrame.Position = UDim2.new(0,12,1,-90)
        Instance.new("UICorner", volFrame).CornerRadius = UDim.new(0, 9)
        local vfs = Instance.new("UIStroke", volFrame)
        vfs.Color = Color3.fromRGB(90,90,105); vfs.Thickness = 1; vfs.Transparency = 0.45

        local volLbl = Instance.new("TextLabel", volFrame)
        volLbl.BackgroundTransparency = 1
        volLbl.Text = "Volume"
        volLbl.TextColor3 = Color3.fromRGB(245,245,255)
        volLbl.Font = Enum.Font.GothamBold
        volLbl.TextSize = 12
        volLbl.TextXAlignment = Enum.TextXAlignment.Left
        volLbl.Position = UDim2.new(0,12,0,0)
        volLbl.Size = UDim2.new(1,-140,1,0)

        local volDown = smallBtn(volFrame, "VolDown", "<", UDim2.new(0,26,0,24), UDim2.new(1,-120,0.5,-12), 13)
        local volValue = Instance.new("TextLabel", volFrame)
        volValue.BackgroundColor3 = Color3.fromRGB(8,8,14)
        volValue.BorderSizePixel = 0
        volValue.Text = string.format("%.2f", State.musicPlayerVolume)
        volValue.TextColor3 = Color3.fromRGB(255,255,255)
        volValue.Font = Enum.Font.GothamBlack
        volValue.TextSize = 12
        volValue.TextXAlignment = Enum.TextXAlignment.Center
        volValue.Size = UDim2.new(0,46,0,24)
        volValue.Position = UDim2.new(1,-88,0.5,-12)
        Instance.new("UICorner", volValue).CornerRadius = UDim.new(0, 7)
        local volUp = smallBtn(volFrame, "VolUp", ">", UDim2.new(0,26,0,24), UDim2.new(1,-36,0.5,-12), 13)

        volDown.MouseButton1Click:Connect(function() MP.setVolume(State.musicPlayerVolume - 0.05) end)
        volUp.MouseButton1Click:Connect(function() MP.setVolume(State.musicPlayerVolume + 0.05) end)

        local spdFrame = Instance.new("Frame", frame)
        spdFrame.BackgroundColor3 = Color3.fromRGB(18,18,22)
        spdFrame.BackgroundTransparency = 0.1
        spdFrame.BorderSizePixel = 0
        spdFrame.Size = UDim2.new(1,-24,0,36)
        spdFrame.Position = UDim2.new(0,12,1,-48)
        Instance.new("UICorner", spdFrame).CornerRadius = UDim.new(0, 9)
        local sfs = Instance.new("UIStroke", spdFrame)
        sfs.Color = Color3.fromRGB(90,90,105); sfs.Thickness = 1; sfs.Transparency = 0.45

        local spdLbl = Instance.new("TextLabel", spdFrame)
        spdLbl.BackgroundTransparency = 1
        spdLbl.Text = "Speed"
        spdLbl.TextColor3 = Color3.fromRGB(245,245,255)
        spdLbl.Font = Enum.Font.GothamBold
        spdLbl.TextSize = 12
        spdLbl.TextXAlignment = Enum.TextXAlignment.Left
        spdLbl.Position = UDim2.new(0,12,0,0)
        spdLbl.Size = UDim2.new(1,-140,1,0)

        local spdDown = smallBtn(spdFrame, "SpdDown", "<", UDim2.new(0,26,0,24), UDim2.new(1,-120,0.5,-12), 13)
        local spdValue = Instance.new("TextLabel", spdFrame)
        spdValue.BackgroundColor3 = Color3.fromRGB(8,8,14)
        spdValue.BorderSizePixel = 0
        spdValue.Text = string.format("%.1fx", State.musicPlayerSpeed)
        spdValue.TextColor3 = Color3.fromRGB(255,255,255)
        spdValue.Font = Enum.Font.GothamBlack
        spdValue.TextSize = 12
        spdValue.TextXAlignment = Enum.TextXAlignment.Center
        spdValue.Size = UDim2.new(0,46,0,24)
        spdValue.Position = UDim2.new(1,-88,0.5,-12)
        Instance.new("UICorner", spdValue).CornerRadius = UDim.new(0, 7)
        local spdUp = smallBtn(spdFrame, "SpdUp", ">", UDim2.new(0,26,0,24), UDim2.new(1,-36,0.5,-12), 13)

        spdDown.MouseButton1Click:Connect(function() MP.setSpeed(State.musicPlayerSpeed - 0.1) end)
        spdUp.MouseButton1Click:Connect(function() MP.setSpeed(State.musicPlayerSpeed + 0.1) end)

        local function refresh()
            if not (MP.gui and MP.gui.Parent) then return end
            nameLbl.Text = MP.getSongName()
            counterLbl.Text = "TRACK " .. tostring(State.musicPlayerIndex) .. " / " .. tostring(#MUSIC_PLAYER_OPTIONS)
            volValue.Text = string.format("%.2f", State.musicPlayerVolume)
            spdValue.Text = string.format("%.1fx", State.musicPlayerSpeed)
            applyAuto(State.musicAutoPlayNext == true)
            applyShuffle(State.musicShuffleEnabled == true)
            applyLoop(State.musicLoopEnabled == true)
            local s = MP.sound
            local alive = s and s.Parent
            playBtn.Text = (alive and s.IsPlaying) and "PAUSE" or "PLAY"
            if alive then
                local sp = tonumber(State.musicPlayerSpeed) or 1
                if sp <= 0 then sp = 1 end
                local len = (s.TimeLength or 0) / sp
                local pos = (s.TimePosition or 0) / sp
                if len > 0 then
                    barFill.Size = UDim2.new(math.clamp(pos / len, 0, 1), 0, 1, 0)
                    curLbl.Text = _fmt(pos)
                    totLbl.Text = _fmt(len)
                else
                    barFill.Size = UDim2.new(0, 0, 1, 0)
                    curLbl.Text = "0:00"; totLbl.Text = "--:--"
                end
            else
                barFill.Size = UDim2.new(0, 0, 1, 0)
                curLbl.Text = "0:00"; totLbl.Text = "0:00"
            end
        end
        MP.refreshUI = refresh
        refresh()

        task.spawn(function()
            while MP.gui and MP.gui.Parent do
                pcall(refresh)
                task.wait(0.2)
            end
        end)

        backdrop.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
               or input.UserInputType == Enum.UserInputType.Touch then
                if MP.gui then MP.gui:Destroy(); MP.gui = nil; MP.refreshUI = nil end
            end
        end)

        frame.Size = UDim2.new(0,0,0,0)
        frame.Position = UDim2.new(0.5,0,0.5,0)
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, POPUP_W, 0, POPUP_H),
            Position = UDim2.new(0.5, -POPUP_W/2, 0.5, -POPUP_H/2)
        }):Play()
    end
end

local headlessConnections = {}
local function applyHeadlessToCharacter(character, enable)
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    if enable then
        head.Transparency = 1
        head.CanCollide = false
        local face = head:FindFirstChild("face")
        if face then face:Destroy() end
        local mesh = head:FindFirstChild("HeadlessMesh") or Instance.new("SpecialMesh")
        mesh.Name = "HeadlessMesh"
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://1095708"
        mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
        mesh.Parent = head
        local transConn = head:GetPropertyChangedSignal("Transparency"):Connect(function()
            if head.Transparency ~= 1 then head.Transparency = 1 end
        end)
        table.insert(headlessConnections, transConn)
        local childConn = head.ChildAdded:Connect(function(child)
            if child.Name == "face" and child:IsA("Decal") then child:Destroy() end
        end)
        table.insert(headlessConnections, childConn)
    else
        head.Transparency = 0
        head.CanCollide = true
        local mesh = head:FindFirstChild("HeadlessMesh")
        if mesh then mesh:Destroy() end
    end
end

local korbloxConnections = {}
local function applyKorbloxToCharacter(character, enable)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if enable then
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = character:FindFirstChild("Right Leg")
            if not rightLeg then return end
            rightLeg.Color = Color3.fromRGB(64, 64, 64)
            for _, child in ipairs(rightLeg:GetChildren()) do
                if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") then child:Destroy() end
            end
            local mesh = rightLeg:FindFirstChild("KorbloxMesh") or Instance.new("SpecialMesh")
            mesh.Name = "KorbloxMesh"
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = "rbxassetid://101851696"
            mesh.TextureId = "rbxassetid://101851254"
            mesh.Scale = Vector3.new(1, 1, 1)
            mesh.Parent = rightLeg
            local colorConn = rightLeg:GetPropertyChangedSignal("Color"):Connect(function()
                if rightLeg.Color ~= Color3.fromRGB(64, 64, 64) then rightLeg.Color = Color3.fromRGB(64, 64, 64) end
            end)
            table.insert(korbloxConnections, colorConn)
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = character:FindFirstChild("RightUpperLeg")
            if not rightUpperLeg then return end
            rightUpperLeg.Transparency = 1
            local rightLowerLeg = character:FindFirstChild("RightLowerLeg")
            local rightFoot = character:FindFirstChild("RightFoot")
            if rightLowerLeg then rightLowerLeg.Transparency = 1 end
            if rightFoot then rightFoot.Transparency = 1 end
            local korbloxLeg = character:FindFirstChild("KorbloxLeg")
            if not korbloxLeg then
                korbloxLeg = Instance.new("Part")
                korbloxLeg.Name = "KorbloxLeg"
                korbloxLeg.Size = Vector3.new(1, 2, 1)
                korbloxLeg.Anchored = false
                korbloxLeg.CanCollide = false
                korbloxLeg.Color = Color3.fromRGB(64, 64, 64)
                korbloxLeg.Parent = character
                local mesh = Instance.new("SpecialMesh")
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = "rbxassetid://101851696"
                mesh.TextureId = "rbxassetid://101851254"
                mesh.Scale = Vector3.new(1, 1, 1)
                mesh.Parent = korbloxLeg
                local weld = Instance.new("Weld")
                weld.Part0 = rightUpperLeg
                weld.Part1 = korbloxLeg
                weld.C0 = CFrame.new(0, -0.45, 0)
                weld.Parent = korbloxLeg
            end
        end
    else
        if humanoid.RigType == Enum.HumanoidRigType.R6 then
            local rightLeg = character:FindFirstChild("Right Leg")
            if rightLeg then
                rightLeg.Color = Color3.fromRGB(255, 255, 0)
                local mesh = rightLeg:FindFirstChild("KorbloxMesh")
                if mesh then mesh:Destroy() end
            end
        elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
            local rightUpperLeg = character:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then rightUpperLeg.Transparency = 0 end
            local rightLowerLeg = character:FindFirstChild("RightLowerLeg")
            if rightLowerLeg then rightLowerLeg.Transparency = 0 end
            local rightFoot = character:FindFirstChild("RightFoot")
            if rightFoot then rightFoot.Transparency = 0 end
            local korbloxLeg = character:FindFirstChild("KorbloxLeg")
            if korbloxLeg then korbloxLeg:Destroy() end
        end
    end
end

local stretchConn = nil
local function startStretch()
    if stretchConn then return end
    local stretchCFrame = CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.45, 0, 0, 0, 1)
    stretchConn = RunService.RenderStepped:Connect(function()
        if not State.stretchRezEnabled then return end
        local c = workspace.CurrentCamera
        if c then c.CFrame = c.CFrame * stretchCFrame end
    end)
end
local function stopStretch()
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
end

local CUSTOM_SOUNDS = {
    Bat    = { id = "rbxassetid://5713085119", skip = 0.2 },
    Medusa = { id = "rbxassetid://3102797479", doublePlay = true, delay = 0.5 },
}

local customSongHooked = setmetatable({}, {__mode = "k"})

local function _customSongForTool(tool)
    if not tool or not tool:IsA("Tool") then return nil end
    local n = tool.Name:lower()
    if n:find("bat") or n:find("slap") then return CUSTOM_SOUNDS.Bat end
    if n:find("medusa") or n:find("head") or n:find("stone") then return CUSTOM_SOUNDS.Medusa end
    return nil
end

local function _hookSoundForCustom(entry, snd)
    if not snd:IsA("Sound") then return end
    if snd.Name == "VexulCustomSound" then return end
    if customSongHooked[snd] then return end
    if entry.muted[snd] ~= nil then return end

    entry.muted[snd] = snd.Volume
    customSongHooked[snd] = true

    local function trigger()
        if not State.customSongEnabled then return end
        if snd.Playing or snd.TimePosition > 0 then
            pcall(function()
                snd.Volume = 0
                snd:Stop()
            end)
            local cs = entry.sound
            if cs and cs.Parent then
                local d = entry.data
                if entry.timer then pcall(task.cancel, entry.timer); entry.timer = nil end
                pcall(function()
                    cs:Stop()
                    cs.TimePosition = d.skip or 0
                    cs.Volume = 1
                    cs:Play()
                end)
                if d.doublePlay and d.delay then
                    entry.timer = task.delay(d.delay, function()
                        entry.timer = nil
                        if not State.customSongEnabled then return end
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
        end
    end

    local c1 = snd:GetPropertyChangedSignal("Playing"):Connect(trigger)
    local c2 = snd:GetPropertyChangedSignal("TimePosition"):Connect(trigger)
    table.insert(entry.conns, c1)
    table.insert(entry.conns, c2)

    local c3
    c3 = snd.AncestryChanged:Connect(function(_, parent)
        if parent then return end
        pcall(function() c1:Disconnect() end)
        pcall(function() c2:Disconnect() end)
        pcall(function() c3:Disconnect() end)
        customSongHooked[snd] = nil
        entry.muted[snd] = nil
        if entry.timer then pcall(task.cancel, entry.timer); entry.timer = nil end
    end)
    table.insert(entry.conns, c3)

    if snd.Playing then trigger() end
end

local customSongTracked = setmetatable({}, {__mode = "k"})

local function setupCustomSongForTool(tool)
    if not tool or not tool:IsA("Tool") then return end
    if customSongTracked[tool] then return end
    local data = _customSongForTool(tool)
    if not data then return end
    local handle = tool:FindFirstChild("Handle")
    if not handle then return end

    local old = handle:FindFirstChild("VexulCustomSound")
    if old then pcall(function() old:Destroy() end) end

    local cs = Instance.new("Sound")
    cs.Name        = "VexulCustomSound"
    cs.SoundId     = data.id
    cs.Volume      = 1
    cs.Looped      = false
    cs.RollOffMode = Enum.RollOffMode.Inverse
    cs.MaxDistance = 1000
    cs.MinDistance = 1000
    cs.Parent      = handle

    local entry = { sound = cs, data = data, conns = {}, muted = {} }
    customSongTracked[tool] = entry

    for _, d in ipairs(tool:GetDescendants()) do _hookSoundForCustom(entry, d) end

    table.insert(entry.conns, tool.DescendantAdded:Connect(function(d)
        if customSongTracked[tool] then _hookSoundForCustom(entry, d) end
    end))
    table.insert(entry.conns, tool.AncestryChanged:Connect(function(_, parent)
        if not parent then
            local e = customSongTracked[tool]
            if e then
                if e.timer then pcall(task.cancel, e.timer); e.timer = nil end
                for _, conn in ipairs(e.conns) do pcall(function() conn:Disconnect() end) end
                if e.sound then pcall(function() e.sound:Destroy() end) end
                for snd, vol in pairs(e.muted) do
                    customSongHooked[snd] = nil
                    if snd and snd.Parent then pcall(function() snd.Volume = vol end) end
                end
            end
            customSongTracked[tool] = nil
        end
    end))
end

local function scanCustomSong()
    if not State.customSongEnabled then return end
    local char = LP.Character
    local bp = LP:FindFirstChildOfClass("Backpack")
    for _, root in ipairs({char, bp}) do
        if root then
            for _, tool in ipairs(root:GetChildren()) do
                if tool:IsA("Tool") then setupCustomSongForTool(tool) end
            end
        end
    end
end

local function clearCustomSong()
    for tool, entry in pairs(customSongTracked) do
        if entry.timer then pcall(task.cancel, entry.timer); entry.timer = nil end
        for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end
        if entry.sound then pcall(function() entry.sound:Destroy() end) end
        for snd, vol in pairs(entry.muted) do
            customSongHooked[snd] = nil
            if snd and snd.Parent then pcall(function() snd.Volume = vol end) end
        end
    end
    customSongTracked = setmetatable({}, {__mode = "k"})
    local char = LP.Character
    local bp = LP:FindFirstChildOfClass("Backpack")
    for _, root in ipairs({char, bp}) do
        if root then
            for _, tool in ipairs(root:GetChildren()) do
                if tool:IsA("Tool") then
                    local handle = tool:FindFirstChild("Handle")
                    if handle then
                        local s = handle:FindFirstChild("VexulCustomSound")
                        if s then s:Destroy() end
                    end
                end
            end
        end
    end
end

local customSongBagConn = nil
local customSongCharConn = nil

local function startCustomSongWatchers()
    if not customSongBagConn then
        customSongBagConn = LP.ChildAdded:Connect(function(child)
            if State.customSongEnabled and child:IsA("Backpack") then
                task.wait(0.3); scanCustomSong()
            end
        end)
    end
    if not customSongCharConn then
        customSongCharConn = LP.CharacterAdded:Connect(function()
            task.wait(0.5); scanCustomSong()
        end)
    end
end

local function stopCustomSongWatchers()
    if customSongBagConn then customSongBagConn:Disconnect(); customSongBagConn = nil end
    if customSongCharConn then customSongCharConn:Disconnect(); customSongCharConn = nil end
end

local RJ = {conns = {}, render = nil, targets = {}}
local function rjStop()
    for _, c in ipairs(RJ.conns) do pcall(function() c:Disconnect() end) end
    RJ.conns = {}
    if RJ.render then pcall(function() RJ.render:Disconnect() end); RJ.render = nil end
    for obj, info in pairs(RJ.targets) do
        if obj and obj.Parent then
            pcall(function() obj[info.prop] = info.orig end)
        end
    end
    RJ.targets = {}
end
local function rjAdd(obj, prop)
    if not obj or RJ.targets[obj] then return end
    RJ.targets[obj] = {prop = prop, orig = obj[prop]}
end
local function rjScan()
    local pg = LP:FindFirstChild("PlayerGui")
    if not pg then return end
    local touch = pg:FindFirstChild("TouchGui")
    if not touch then return end
    for _, v in ipairs(touch:GetDescendants()) do
        local n = v.Name:lower()
        if (v:IsA("ImageLabel") or v:IsA("ImageButton")) and (n:find("thumbstick") or n:find("stick")) then
            rjAdd(v, "ImageColor3")
        elseif v:IsA("Frame") and (n:find("thumbstick") or n:find("stick")) then
            rjAdd(v, "BackgroundColor3")
        end
    end
    local tcf = touch:FindFirstChild("TouchControlFrame")
    if tcf then
        for _, v in ipairs(tcf:GetDescendants()) do
            if v:IsA("ImageButton") then
                rjAdd(v, "ImageColor3")
                for _, d in ipairs(v:GetDescendants()) do
                    if d:IsA("ImageLabel") then rjAdd(d, "ImageColor3") end
                end
                break
            end
        end
    end
end
local function rjStart()
    rjStop()
    rjScan()
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then
        table.insert(RJ.conns, pg.ChildAdded:Connect(function(ch)
            if ch.Name == "TouchGui" and State.rainbowJoystickEnabled then
                task.wait(0.2); if State.rainbowJoystickEnabled then rjScan() end
            end
        end))
        local touch = pg:FindFirstChild("TouchGui")
        if touch then
            table.insert(RJ.conns, touch.DescendantAdded:Connect(function()
                task.wait(0.2); if State.rainbowJoystickEnabled then rjScan() end
            end))
        end
    end
    RJ.render = RunService.RenderStepped:Connect(function()
        local t = tick() * 2
        local color = Color3.new(
            math.sin(t) * 0.5 + 0.5,
            math.sin(t + 2) * 0.5 + 0.5,
            math.sin(t + 4) * 0.5 + 0.5
        )
        for obj, info in pairs(RJ.targets) do
            if obj and obj.Parent then
                obj[info.prop] = color
            else
                RJ.targets[obj] = nil
            end
        end
    end)
end

local function makeDraggable(frame, saveKey, lockFlagGetter)
    local dragging = false
    local dragStart, startPos
    local isLocked = lockFlagGetter or function() return State.uiLocked == true end
    frame.InputBegan:Connect(function(input)
        if isLocked() then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if not dragging then return end
        if isLocked() then dragging = false; return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
           or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            if dragging and saveKey then
                pcall(function()
                    local data = {
                        XScale = frame.Position.X.Scale, XOffset = frame.Position.X.Offset,
                        YScale = frame.Position.Y.Scale, YOffset = frame.Position.Y.Offset,
                    }
                    writefile(saveKey, HttpService:JSONEncode(data))
                end)
            end
            dragging = false
        end
    end)
end

local function loadDraggablePosition(frame, saveKey)
    if not (isfile and readfile and isfile(saveKey)) then return end
    pcall(function()
        local data = HttpService:JSONDecode(readfile(saveKey))
        if data then
            frame.Position = UDim2.new(data.XScale, data.XOffset, data.YScale, data.YOffset)
        end
    end)
end

function _G._VexulApplyButtonSize(size)
    size = math.clamp(tonumber(size) or 58, 30, 120)
    State.buttonSize = size
    for _, entry in ipairs(_G._VexulAllBtnContainers) do
        local container = entry.container
        if container and container.Parent and entry.kind == "mobile" then
            pcall(function()
                container.Size = UDim2.new(0, size, 0, size)
                if container:IsA("TextButton") then
                    container.TextSize = math.max(7, math.floor(size * 0.20 + 0.5))
                end
            end)
        end
    end
end

function _G._VexulApplyCenterButtonSize(size)
    size = math.clamp(tonumber(size) or 44, 24, 100)
    State.centerButtonSize = size
    for _, entry in ipairs(_G._VexulAllBtnContainers) do
        local container = entry.container
        if container and container.Parent and entry.kind == "center" then
            pcall(function()
                container.Size = UDim2.new(0, size, 0, size)
                if container:IsA("TextButton") then
                    container.TextSize = math.max(7, math.floor(size * 0.20 + 0.5))
                end
            end)
        end
    end
end

-- ============================================================
-- ANIMACIÓN: LÍNEA BLANCA RECORRIENDO EL BOTÓN DE IZQ A DERECHA
-- ============================================================
task.spawn(function()
    while true do
        task.wait(0.016)
        local bars = _G._VexulRGBBars
        if bars then
            local t = tick()
            for btn, data in pairs(bars) do
                if data and data.bar and data.bar.Parent and btn.Parent then
                    -- Cycle de -1 a +1 (izquierda a derecha)
                    local cycle = ((t * 0.7 + (data.offset or 0)) % 1) * 2 - 1
                    data.bar.Position = UDim2.new(cycle, 0, 0, 0)
                end
            end
        end
    end
end)

-- ============================================================
-- MOBILE PANEL
-- ============================================================
local function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "VexulHubButtons"
    panel.Parent = LP:WaitForChild("PlayerGui")
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local BTN_W = State.buttonSize or 58
    local BTN_H = State.buttonSize or 58
    local GAP = 12
    local COL1_X = -(BTN_W + GAP + BTN_W + 10 + 20)
    local COL2_X = -(BTN_W + 10 + 20)
    local BASE_Y = 0.24 + 0.04
    local ROW_Y = {
        -((BTN_H*4 + GAP*3)/2),
        -((BTN_H*4 + GAP*3)/2) + (BTN_H + GAP),
        -((BTN_H*4 + GAP*3)/2) + (BTN_H + GAP)*2,
        -((BTN_H*4 + GAP*3)/2) + (BTN_H + GAP)*3,
    }

    local C_ACTIVE_BG   = Color3.fromRGB(12, 45, 110)   -- azul marino oscuro
    local C_INACTIVE_BG = Color3.fromRGB(20, 20, 26)
    local C_ACTIVE_TX   = Color3.fromRGB(255, 255, 255)
    local C_INACTIVE_TX = Color3.fromRGB(240, 240, 245)
    local C_HOVER_BG    = Color3.fromRGB(40, 40, 50)
    local C_ACCENT      = Color3.fromRGB(96, 165, 250)

    local function makeMobileBtn(name, label, defaultPos, saveKey, onClick, isToggle)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.Position = defaultPos
        btn.BackgroundColor3 = C_INACTIVE_BG
        btn.BorderSizePixel = 0
        btn.Text = label
        btn.TextColor3 = C_INACTIVE_TX
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = math.max(7, math.floor(BTN_W * 0.20))
        btn.TextWrapped = true
        btn.AutoButtonColor = false
        btn.ZIndex = 2
        btn.ClipsDescendants = true
        btn.Parent = panel

        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = C_ACCENT
        bs.Thickness = 1
        bs.Transparency = 0.4

        -- Línea blanca que recorre TODO el botón (ancho 25%, alto 100%)
        local rgbBar = Instance.new("Frame", btn)
        rgbBar.Name = "VexulRGBBar"
        rgbBar.Size = UDim2.new(0.25, 0, 1, 0)       -- ancho = 25% del botón
        rgbBar.Position = UDim2.new(-1, 0, 0, 0)     -- empieza fuera por la izquierda
        rgbBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        rgbBar.BackgroundTransparency = 0.35
        rgbBar.BorderSizePixel = 0
        rgbBar.ZIndex = 21
        rgbBar.Visible = false

        -- Gradiente horizontal para que los bordes se difuminen
        local rgbGrad = Instance.new("UIGradient", rgbBar)
        rgbGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0,   1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1,   1),
        })
        rgbGrad.Rotation = 0

        _G._VexulRGBBars[btn] = { bar = rgbBar, offset = math.random() * 100 / 100 }

        pcall(function()
            if isfile and readfile and isfile(saveKey) then
                local data = HttpService:JSONDecode(readfile(saveKey))
                if data and data.XScale ~= nil and data.YScale ~= nil then
                    btn.Position = UDim2.new(data.XScale, data.XOffset or 0, data.YScale, data.YOffset or 0)
                end
            end
        end)

        local isOn = false
        local function setActive(state)
            isOn = state
            local bg = state and C_ACTIVE_BG or C_INACTIVE_BG
            local tx = state and C_ACTIVE_TX or C_INACTIVE_TX
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = bg}):Play()
            TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = tx}):Play()
            TweenService:Create(bs, TweenInfo.new(0.15), {Transparency = state and 0.1 or 0.4}):Play()
            rgbBar.Visible = state
        end

        btn.MouseEnter:Connect(function()
            if not isOn then
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = C_HOVER_BG}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if not isOn then
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = C_INACTIVE_BG}):Play()
            end
        end)

        local didDrag = false
        btn.MouseButton1Click:Connect(function()
            if didDrag then return end
            if isToggle then
                local newState = not isOn
                setActive(newState)
                if onClick then pcall(onClick, setActive, newState) end
            else
                setActive(true)
                if onClick then pcall(onClick) end
                task.delay(0.2, function() setActive(false) end)
            end
        end)

        local _dragging = false
        local _dragStart, _startPos, _dragInput
        btn.InputBegan:Connect(function(input)
            if State.buttonsLocked == true then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1
               or input.UserInputType == Enum.UserInputType.Touch then
                _dragging = true
                didDrag = false
                _dragStart = input.Position
                _startPos = btn.Position
            end
        end)
        btn.InputChanged:Connect(function(input)
            if not _dragging then return end
            if State.buttonsLocked == true then _dragging = false; return end
            if input.UserInputType == Enum.UserInputType.MouseMovement
               or input.UserInputType == Enum.UserInputType.Touch then
                _dragInput = input
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not _dragging then return end
            if State.buttonsLocked == true then _dragging = false; return end
            if input == _dragInput or input.UserInputType == Enum.UserInputType.MouseMovement
               or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - _dragStart
                if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then
                    didDrag = true
                end
                btn.Position = UDim2.new(
                    _startPos.X.Scale, _startPos.X.Offset + delta.X,
                    _startPos.Y.Scale, _startPos.Y.Offset + delta.Y
                )
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
               or input.UserInputType == Enum.UserInputType.Touch then
                if _dragging then
                    pcall(function()
                        local pos = btn.Position
                        writefile(saveKey, HttpService:JSONEncode({
                            XScale = pos.X.Scale, XOffset = pos.X.Offset,
                            YScale = pos.Y.Scale, YOffset = pos.Y.Offset,
                        }))
                    end)
                end
                _dragging = false
                task.delay(0.1, function() didDrag = false end)
            end
        end)

        btn.Visible = MobileButtons.Visible
        table.insert(MobileButtons.Containers, btn)
        table.insert(allCubeContainers, btn)
        table.insert(_G._VexulAllBtnContainers, {container = btn, label = label, kind = "mobile"})
        return btn, setActive
    end

    local dropBRBtn, setDropBR = makeMobileBtn("BtnDropBR", "DROP\nBR", UDim2.new(1, COL1_X, BASE_Y, ROW_Y[1]), "VexulBtn_dropbr.txt",
        function(setActive)
            runDropBrainrot()
            if setMenuDropBR then setMenuDropBR(true) end
            task.delay(0.5, function()
                if setMenuDropBR then setMenuDropBR(false) end
                setActive(false)
            end)
        end, true)

    local autoLeftBtn, setAutoLeftMB = makeMobileBtn("BtnAutoLeft", "AUTO\nLEFT", UDim2.new(1, COL2_X, BASE_Y, ROW_Y[1]), "VexulBtn_autoleft.txt",
        function(setActive, on)
            if on then
                if State.autoRightEnabled then
                    State.autoRightEnabled = false
                    if stopAutoRight then stopAutoRight() end
                    if setAutoRight then setAutoRight(false) end
                    if MobileButtons.Buttons.autoRight then MobileButtons.Buttons.autoRight(false) end
                end
                State.autoLeftEnabled = true
                if setAutoLeft then setAutoLeft(true) end
                startAutoLeft()
            else
                State.autoLeftEnabled = false
                if setAutoLeft then setAutoLeft(false) end
                stopAutoLeft()
            end
            autoSaveConfig()
        end, true)

    local autoBatBtn, setAutoBatMB = makeMobileBtn("BtnAutoBat", "BAT\nAIMBOT", UDim2.new(1, COL1_X, BASE_Y, ROW_Y[2]), "VexulBtn_autobat.txt",
        function(setActive, on)
            State.autoBatToggled = on
            if on then
                if State.autoLeftEnabled then
                    State.autoLeftEnabled = false
                    if stopAutoLeft then stopAutoLeft() end
                    if setAutoLeft then setAutoLeft(false) end
                    if MobileButtons.Buttons.autoLeft then MobileButtons.Buttons.autoLeft(false) end
                end
                if State.autoRightEnabled then
                    State.autoRightEnabled = false
                    if stopAutoRight then stopAutoRight() end
                    if setAutoRight then setAutoRight(false) end
                    if MobileButtons.Buttons.autoRight then MobileButtons.Buttons.autoRight(false) end
                end
            end
            if setAutoBat then setAutoBat(State.autoBatToggled) end
            autoSaveConfig()
        end, true)

    local autoRightBtn, setAutoRightMB = makeMobileBtn("BtnAutoRight", "AUTO\nRIGHT", UDim2.new(1, COL2_X, BASE_Y, ROW_Y[2]), "VexulBtn_autoright.txt",
        function(setActive, on)
            if on then
                if State.autoLeftEnabled then
                    State.autoLeftEnabled = false
                    if stopAutoLeft then stopAutoLeft() end
                    if setAutoLeft then setAutoLeft(false) end
                    if MobileButtons.Buttons.autoLeft then MobileButtons.Buttons.autoLeft(false) end
                end
                State.autoRightEnabled = true
                if setAutoRight then setAutoRight(true) end
                startAutoRight()
            else
                State.autoRightEnabled = false
                if setAutoRight then setAutoRight(false) end
                stopAutoRight()
            end
            autoSaveConfig()
        end, true)

    -- TP DOWN (se apaga siempre tras ejecutarse)
    local tpDownBtn, setTpDownMB = makeMobileBtn("BtnTpDown", "TP\nDOWN", UDim2.new(1, COL1_X, BASE_Y, ROW_Y[3]), "VexulBtn_tpdown.txt",
        function(setActive)
            tpToGround()
            if setMenuTpDown then setMenuTpDown(true) end
            task.delay(0.5, function()
                if setMenuTpDown then setMenuTpDown(false) end
                setActive(false)
            end)
        end, true)

    -- CARRY SPEED (se activa correctamente)
    local carrySpeedBtn, setCarrySpeedMB = makeMobileBtn("BtnCarrySpd", "CARRY\nSPD", UDim2.new(1, COL2_X, BASE_Y, ROW_Y[3]), "VexulBtn_carryspd.txt",
        function(setActive, on)
            if on then
                deactivateAllSpeedModes()
                State.speedType = "carry"
                refreshUIToggles()
                autoSaveConfig()
                setActive(true)
            else
                if State.speedType == "carry" then
                    State.speedType = "normal"
                    refreshUIToggles()
                    autoSaveConfig()
                end
                setActive(false)
            end
        end, true)

    local laggerCarryBtn, setLaggerCarryMB = makeMobileBtn("BtnLaggerCarry", "LAGGER\nCARRY", UDim2.new(1, COL1_X, BASE_Y, ROW_Y[4]), "VexulBtn_laggercarry.txt",
        function(setActive, on)
            if on then
                deactivateAllSpeedModes()
                State.laggerCarryActive = true
                AutoSteal.Enabled = true
                if setInstaGrab then setInstaGrab(true) end
                pcall(startAutoSteal)
                refreshUIToggles()
                autoSaveConfig()
                setActive(true)
            else
                if State.laggerCarryActive then
                    State.laggerCarryActive = false
                    AutoSteal.Enabled = false
                    if setInstaGrab then setInstaGrab(false) end
                    stopAutoSteal()
                    refreshUIToggles()
                    autoSaveConfig()
                end
                setActive(false)
            end
        end, true)

    local laggerBtn, setLaggerMB = makeMobileBtn("BtnLaggerMode", "LAGGER\nMODE", UDim2.new(1, COL2_X, BASE_Y, ROW_Y[4]), "VexulBtn_laggermode.txt",
        function(setActive, on)
            if on then
                deactivateAllSpeedModes()
                State.laggerActive = true
                AutoSteal.Enabled = true
                if setInstaGrab then setInstaGrab(true) end
                startAutoSteal()
                refreshUIToggles()
                autoSaveConfig()
                setActive(true)
            else
                if State.laggerActive then
                    State.laggerActive = false
                    AutoSteal.Enabled = false
                    if setInstaGrab then setInstaGrab(false) end
                    stopAutoSteal()
                    refreshUIToggles()
                    autoSaveConfig()
                end
                setActive(false)
            end
        end, true)

    MobileButtons.Buttons = {
        autoLeft    = setAutoLeftMB,
        autoRight   = setAutoRightMB,
        autoBat     = setAutoBatMB,
        carrySpeed  = setCarrySpeedMB,
        lagger      = setLaggerMB,
        dropBR      = setDropBR,
        tpDown      = setTpDownMB,
        laggerCarry = setLaggerCarryMB,
    }

    task.spawn(function()
        task.wait(0.1)
        if setCarrySpeedMB  then setCarrySpeedMB(State.speedType == "carry")        end
        if setLaggerMB      then setLaggerMB(State.laggerActive)                    end
        if setLaggerCarryMB then setLaggerCarryMB(State.laggerCarryActive)          end
        if setAutoBatMB     then setAutoBatMB(State.autoBatToggled)                 end
        if setAutoLeftMB    then setAutoLeftMB(State.autoLeftEnabled)               end
        if setAutoRightMB   then setAutoRightMB(State.autoRightEnabled)             end
    end)

    return panel
end

for _,name in pairs({"JispiHubGUI","VexulHubGUI","USTHubGUI"}) do
    local old=game:GetService("CoreGui"):FindFirstChild(name); if old then old:Destroy() end
    local old2=LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild(name); if old2 then old2:Destroy() end
end

local C_BG         = Color3.fromRGB(10,10,10)
local C_SIDEBAR_BG = Color3.fromRGB(18,18,18)
local C_HEADER_BG  = Color3.fromRGB(14,14,14)
local C_WHITE      = Color3.fromRGB(255,255,255)
local C_BLACK      = Color3.fromRGB(0,0,0)
local C_DIM        = Color3.fromRGB(100,100,100)
local C_ROW_BG     = Color3.fromRGB(22,22,22)
local C_ELEM_BG    = Color3.fromRGB(0,0,0)
local C_ELEM_BOR   = Color3.fromRGB(40,40,40)
local C_ON_BG      = Color3.fromRGB(255,255,255)
local C_OFF_BG     = Color3.fromRGB(30,30,30)
local C_DOT_ON     = Color3.fromRGB(0,0,0)
local C_DOT_OFF    = Color3.fromRGB(80,80,80)
local C_STR_OFF    = Color3.fromRGB(50,50,50)
local C_NAV_ACTIVE_BG     = Color3.fromRGB(40,40,40)
local C_NAV_ACTIVE_TEXT   = Color3.fromRGB(255,255,255)
local C_NAV_INACTIVE_TEXT = Color3.fromRGB(130,130,130)

local closeBtnRef=nil; local miniBtn=nil

local gui=Instance.new("ScreenGui")
gui.Name="VexulHubGUI"; gui.ResetOnSpawn=false; gui.DisplayOrder=100
gui.IgnoreGuiInset=true; gui.Enabled=false; gui.Parent=LP:WaitForChild("PlayerGui")

local stealProgressGui=Instance.new("ScreenGui")
stealProgressGui.Name="AngelStealProgress"; stealProgressGui.ResetOnSpawn=false; stealProgressGui.DisplayOrder=15
stealProgressGui.IgnoreGuiInset=true; stealProgressGui.Enabled=false; stealProgressGui.Parent=LP:WaitForChild("PlayerGui")

local stealProgressBar=Instance.new("Frame",stealProgressGui)
stealProgressBar.Name = "StealBar"
stealProgressBar.Size=UDim2.new(0,240,0,52)
stealProgressBar.Position=UDim2.new(0.5,-120,0.75,-26)
stealProgressBar.BackgroundColor3=Color3.fromRGB(12,12,12)
stealProgressBar.BackgroundTransparency=0
stealProgressBar.BorderSizePixel=0
stealProgressBar.ZIndex=5
stealProgressBar.Active = true
Instance.new("UICorner",stealProgressBar).CornerRadius=UDim.new(0,16)

local pctLbl=Instance.new("TextLabel",stealProgressBar)
pctLbl.Name = "PercentLbl"
pctLbl.Size=UDim2.new(0.4,0,0,24)
pctLbl.Position=UDim2.new(0,12,0,5)
pctLbl.BackgroundTransparency=1
pctLbl.Text="0%"
pctLbl.TextColor3=C_WHITE
pctLbl.Font=Enum.Font.GothamBlack
pctLbl.TextSize=20
pctLbl.TextXAlignment=Enum.TextXAlignment.Left
pctLbl.ZIndex=6

local radLbl=Instance.new("TextLabel",stealProgressBar)
radLbl.Name = "RadLbl"
radLbl.Size=UDim2.new(0.6,-12,0,24)
radLbl.Position=UDim2.new(0.4,0,0,5)
radLbl.BackgroundTransparency=1
radLbl.Text="Radius: 20"
radLbl.TextColor3=C_WHITE
radLbl.Font=Enum.Font.GothamBlack
radLbl.TextSize=18
radLbl.TextXAlignment=Enum.TextXAlignment.Right
radLbl.ZIndex=6
progressRadLbl = radLbl

local barTrack=Instance.new("Frame",stealProgressBar)
barTrack.Name = "BarTrack"
barTrack.Size=UDim2.new(1,-24,0,10)
barTrack.Position=UDim2.new(0,12,0,35)
barTrack.BackgroundColor3=Color3.fromRGB(28,28,28)
barTrack.BorderSizePixel=0
barTrack.ZIndex=6
Instance.new("UICorner",barTrack).CornerRadius=UDim.new(0,5)

local barFill=Instance.new("Frame",barTrack)
barFill.Name = "BarFill"
barFill.Size=UDim2.new(0,0,1,0)
barFill.BackgroundColor3=C_WHITE
barFill.BorderSizePixel=0
barFill.ZIndex=7
Instance.new("UICorner",barFill).CornerRadius=UDim.new(0,5)
AutoSteal.ProgressFill=barFill
AutoSteal.ProgressText=pctLbl

makeDraggable(stealProgressBar, "VexulStealBarPos.txt", function() return State.uiLocked == true end)
loadDraggablePosition(stealProgressBar, "VexulStealBarPos.txt")

task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            if radLbl and AutoSteal then
                radLbl.Text = "Radius: " .. tostring(AutoSteal.Radius)
            end
        end)
    end
end)

local MAIN_W   = 310
local SIDEBAR_W= 96
local CONTENT_W= MAIN_W - SIDEBAR_W
local MAIN_H   = 360

local main=Instance.new("Frame",gui)
main.Name="Main"; main.Size=UDim2.new(0,MAIN_W,0,MAIN_H); main.Position=UDim2.new(0.5,-155,0.5,-180)
main.BackgroundColor3=C_BG; main.BorderSizePixel=0; main.Active=true; main.ClipsDescendants=true; main.ZIndex=10
Instance.new("UICorner",main).CornerRadius=UDim.new(0,8)
local mainStroke=Instance.new("UIStroke",main); mainStroke.Color=Color3.fromRGB(35,35,35); mainStroke.Thickness=1

local mainUIScale = Instance.new("UIScale", main)
mainUIScale.Name = "MainUIScale"
mainUIScale.Scale = 1.0

makeDraggable(main, "VexulMainPos.txt", function() return State.uiLocked == true end)
loadDraggablePosition(main, "VexulMainPos.txt")

local HEADER_H=44
local header=Instance.new("Frame",main)
header.Size=UDim2.new(1,0,0,HEADER_H); header.BackgroundColor3=C_HEADER_BG; header.BorderSizePixel=0; header.ZIndex=15
Instance.new("UICorner",header).CornerRadius=UDim.new(0,8)
local headerFill=Instance.new("Frame",header); headerFill.Size=UDim2.new(1,0,0,10); headerFill.Position=UDim2.new(0,0,1,-10); headerFill.BackgroundColor3=C_HEADER_BG; headerFill.BorderSizePixel=0; headerFill.ZIndex=14
local titleLbl=Instance.new("TextLabel",header); titleLbl.Size=UDim2.new(1,-50,1,0); titleLbl.Position=UDim2.new(0,14,0,0)
titleLbl.BackgroundTransparency=1; titleLbl.Text="VEXUL HUB"; titleLbl.TextColor3=C_WHITE; titleLbl.Font=Enum.Font.GothamBlack; titleLbl.TextSize=15; titleLbl.TextXAlignment=Enum.TextXAlignment.Left; titleLbl.ZIndex=16
local headerSep=Instance.new("Frame",main); headerSep.Size=UDim2.new(1,0,0,1); headerSep.Position=UDim2.new(0,0,0,HEADER_H); headerSep.BackgroundColor3=Color3.fromRGB(28,28,28); headerSep.BorderSizePixel=0; headerSep.ZIndex=15

local closeBtn=Instance.new("TextButton",main)
closeBtn.Name = "CloseMainBtn"
closeBtn.Size=UDim2.new(0,26,0,26)
closeBtn.Position=UDim2.new(1, -34, 0, 9)
closeBtn.BackgroundColor3=Color3.fromRGB(28,28,28); closeBtn.BorderSizePixel=0
closeBtn.Text="−"; closeBtn.TextColor3=Color3.fromRGB(160,160,160)
closeBtn.Font=Enum.Font.GothamBlack; closeBtn.TextSize=16
closeBtn.ZIndex=200; closeBtn.AutoButtonColor=false
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,4)
Instance.new("UIStroke",closeBtn).Color=Color3.fromRGB(45,45,45)
closeBtnRef=closeBtn
closeBtn.MouseButton1Click:Connect(function()
    main.Visible=false
    closeBtn.Visible=false
    if miniBtn then miniBtn.Visible=true end
end)

miniBtn=Instance.new("TextButton",gui)
miniBtn.Name="VexulMiniButton"; miniBtn.Size=UDim2.new(0,130,0,28)
miniBtn.Position=UDim2.new(0,8,0,66)
miniBtn.BackgroundColor3=C_BG; miniBtn.BackgroundTransparency=0; miniBtn.BorderSizePixel=0
miniBtn.Text="VEXUL HUB"; miniBtn.TextColor3=C_WHITE
miniBtn.Font=Enum.Font.GothamBlack; miniBtn.TextSize=11
miniBtn.AutoButtonColor=false; miniBtn.Visible=false; miniBtn.ZIndex=150
Instance.new("UICorner",miniBtn).CornerRadius=UDim.new(0,4)
Instance.new("UIStroke",miniBtn).Color=Color3.fromRGB(38,38,38)
miniBtn.MouseButton1Click:Connect(function()
    main.Visible=true; closeBtn.Visible=true; miniBtn.Visible=false
end)

makeDraggable(miniBtn, "VexulMiniBtnPos.txt", function() return State.uiLocked == true end)
loadDraggablePosition(miniBtn, "VexulMiniBtnPos.txt")

local sidebar=Instance.new("Frame",main)
sidebar.Name="Sidebar"; sidebar.Size=UDim2.new(0,SIDEBAR_W,1,-HEADER_H-1); sidebar.Position=UDim2.new(0,0,0,HEADER_H+1)
sidebar.BackgroundColor3=C_SIDEBAR_BG; sidebar.BorderSizePixel=0; sidebar.ZIndex=11
Instance.new("UICorner",sidebar).CornerRadius=UDim.new(0,8)
local sidebarFill=Instance.new("Frame",sidebar); sidebarFill.Size=UDim2.new(1,0,0,8); sidebarFill.Position=UDim2.new(0,0,0,0); sidebarFill.BackgroundColor3=C_SIDEBAR_BG; sidebarFill.BorderSizePixel=0; sidebarFill.ZIndex=10
local sidebarSep=Instance.new("Frame",main); sidebarSep.Size=UDim2.new(0,1,1,-HEADER_H-1); sidebarSep.Position=UDim2.new(0,SIDEBAR_W,0,HEADER_H+1); sidebarSep.BackgroundColor3=Color3.fromRGB(28,28,28); sidebarSep.BorderSizePixel=0; sidebarSep.ZIndex=12
local navLayout=Instance.new("UIListLayout",sidebar); navLayout.SortOrder=Enum.SortOrder.LayoutOrder; navLayout.Padding=UDim.new(0,4)
local navPad=Instance.new("UIPadding",sidebar); navPad.PaddingTop=UDim.new(0,8); navPad.PaddingLeft=UDim.new(0,6); navPad.PaddingRight=UDim.new(0,6)

local contentFrame=Instance.new("Frame",main)
contentFrame.Name="Content"; contentFrame.Size=UDim2.new(0,CONTENT_W,1,-HEADER_H-1); contentFrame.Position=UDim2.new(0,SIDEBAR_W+1,0,HEADER_H+1)
contentFrame.BackgroundTransparency=1; contentFrame.BorderSizePixel=0; contentFrame.ZIndex=11; contentFrame.ClipsDescendants=true

local sections={}; local activeSection=nil; local navButtons={}

local function createScrollFrame(parent)
    local scroll=Instance.new("ScrollingFrame",parent)
    scroll.Size=UDim2.new(1,0,1,0); scroll.Position=UDim2.new(0,0,0,0)
    scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0; scroll.ScrollBarThickness=2
    scroll.ScrollBarImageColor3=Color3.fromRGB(45,45,45); scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    scroll.CanvasSize=UDim2.new(0,0,0,0); scroll.ZIndex=12; scroll.Visible=false
    local layout=Instance.new("UIListLayout",scroll); layout.SortOrder=Enum.SortOrder.LayoutOrder; layout.Padding=UDim.new(0,0)
    local pad=Instance.new("UIPadding",scroll); pad.PaddingBottom=UDim.new(0,8); pad.PaddingTop=UDim.new(0,2); pad.PaddingLeft=UDim.new(0,6); pad.PaddingRight=UDim.new(0,6)
    return scroll
end

local function showSection(name)
    for sName, sData in pairs(sections) do sData.scroll.Visible=(sName==name) end
    activeSection=name
    for bName, btn in pairs(navButtons) do
        if bName==name then
            TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=C_NAV_ACTIVE_BG,BackgroundTransparency=0}):Play()
            btn.TextColor3=C_NAV_ACTIVE_TEXT
        else
            TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=C_SIDEBAR_BG,BackgroundTransparency=0}):Play()
            btn.TextColor3=C_NAV_INACTIVE_TEXT
        end
    end
end

local function addNavButton(name, label, order)
    local btn=Instance.new("TextButton",sidebar)
    btn.Name="Nav_"..name; btn.Size=UDim2.new(1,0,0,36)
    btn.BackgroundColor3=C_SIDEBAR_BG; btn.BackgroundTransparency=0; btn.BorderSizePixel=0
    btn.Text=label; btn.TextColor3=C_NAV_INACTIVE_TEXT
    btn.Font=Enum.Font.GothamBold; btn.TextSize=12; btn.AutoButtonColor=false; btn.ZIndex=13; btn.LayoutOrder=order
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
    btn.MouseButton1Click:Connect(function() showSection(name) end)
    navButtons[name]=btn
    local scroll=createScrollFrame(contentFrame)
    sections[name]={scroll=scroll}
    return scroll
end

local ROW_H = 40
local currentScroll=nil; local loCounter=0
local function LO() loCounter=loCounter+1; return loCounter end
local function setActiveScroll(scroll) currentScroll=scroll; loCounter=0 end

local function makeCardRow(h)
    local wrap=Instance.new("Frame",currentScroll); wrap.Size=UDim2.new(1,0,0,(h or ROW_H)+3)
    wrap.BackgroundTransparency=1; wrap.BorderSizePixel=0; wrap.LayoutOrder=LO()
    local card=Instance.new("Frame",wrap); card.Size=UDim2.new(1,0,1,-3); card.Position=UDim2.new(0,0,0,2)
    card.BackgroundColor3=C_ROW_BG; card.BorderSizePixel=0; card.ZIndex=12
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,10)
    local hoverFrame=Instance.new("Frame",card); hoverFrame.Size=UDim2.new(1,0,1,0)
    hoverFrame.BackgroundColor3=Color3.fromRGB(35,35,35); hoverFrame.BackgroundTransparency=1; hoverFrame.BorderSizePixel=0; hoverFrame.ZIndex=12
    Instance.new("UICorner",hoverFrame).CornerRadius=UDim.new(0,10)
    return wrap, card, hoverFrame
end

local function cardLabel(card, text)
    local lbl=Instance.new("TextLabel",card); lbl.Position=UDim2.new(0,14,0,0)
    lbl.Size=UDim2.new(0.55,0,1,0); lbl.BackgroundTransparency=1; lbl.Text=text
    lbl.TextColor3=C_WHITE; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=13
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=14
    return lbl
end

local function makePill(parent, defaultOn, xPos)
    local pillBg=Instance.new("Frame",parent)
    pillBg.Size=UDim2.new(0,46,0,24)
    if xPos then pillBg.Position=UDim2.new(1,xPos,0.5,-12) else pillBg.Position=UDim2.new(1,-58,0.5,-12) end
    pillBg.BackgroundColor3=defaultOn and C_ON_BG or C_OFF_BG; pillBg.BorderSizePixel=0; pillBg.ZIndex=15
    Instance.new("UICorner",pillBg).CornerRadius=UDim.new(1,0)
    local pStr=Instance.new("UIStroke",pillBg); pStr.Color=C_STR_OFF; pStr.Thickness=defaultOn and 0 or 1
    local dot=Instance.new("Frame",pillBg); dot.Size=UDim2.new(0,17,0,17)
    dot.Position=defaultOn and UDim2.new(1,-20,0.5,-8.5) or UDim2.new(0,3.5,0.5,-8.5)
    dot.BackgroundColor3=defaultOn and C_DOT_ON or C_DOT_OFF; dot.BorderSizePixel=0; dot.ZIndex=16
    Instance.new("UICorner",dot).CornerRadius=UDim.new(0,5)
    local function setV(on)
        TweenService:Create(pillBg,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{BackgroundColor3=on and C_ON_BG or C_OFF_BG}):Play()
        pStr.Thickness=on and 0 or 1
        TweenService:Create(dot,TweenInfo.new(0.18,Enum.EasingStyle.Back),{
            Position=on and UDim2.new(1,-20,0.5,-8.5) or UDim2.new(0,3.5,0.5,-8.5),
            BackgroundColor3=on and C_DOT_ON or C_DOT_OFF}):Play()
    end
    return pillBg, setV
end

local function makeInputBox(parent, default, onChange, xPos, noFloor)
    local box=Instance.new("TextBox",parent)
    box.Size=UDim2.new(0,62,0,26)
    if xPos then box.Position=UDim2.new(1,xPos,0.5,-13) else box.Position=UDim2.new(1,-74,0.5,-13) end
    box.BackgroundColor3=C_ELEM_BG; box.BorderSizePixel=0; box.Text=tostring(default)
    box.TextColor3=C_WHITE; box.Font=Enum.Font.GothamBold; box.TextSize=13
    box.ClearTextOnFocus=true; box.PlaceholderText="0"; box.ZIndex=15
    Instance.new("UICorner",box).CornerRadius=UDim.new(0,8)
    local bs=Instance.new("UIStroke",box); bs.Color=C_ELEM_BOR; bs.Thickness=1
    box.InputBegan:Connect(function(i) i:StopPropagation() end)
    box.FocusLost:Connect(function()
        local num=tonumber(box.Text)
        if num~=nil then
            local fv
            if noFloor then
                fv = math.clamp(num, 0, 500)
                local formatted = string.format("%.2f", fv)
                formatted = formatted:gsub("%.?0+$", "")
                box.Text = formatted
            else
                fv = math.floor(math.clamp(num, 0, 500))
                box.Text = tostring(fv)
            end
            if onChange then onChange(tostring(fv)) end; autoSaveConfig()
        else box.Text=tostring(default) end
    end)
    box.Active=true; box.Selectable=true
    return box
end

local function makeInputRow(label, default, onChange, noFloor)
    local wrap, card, hf = makeCardRow()
    cardLabel(card, label)
    local box = makeInputBox(card, default, onChange, nil, noFloor)
    return box
end

local function makeToggleRow(label, defaultOn, onToggle, registryKey)
    local wrap, card, hf = makeCardRow()
    cardLabel(card, label)
    local _, setV = makePill(card, defaultOn or false)
    local isOn = defaultOn or false
    local clickOverlay = Instance.new("TextButton", card)
    clickOverlay.Size=UDim2.new(1,0,1,0); clickOverlay.BackgroundTransparency=1; clickOverlay.Text=""
    clickOverlay.ZIndex=14; clickOverlay.AutoButtonColor=false
    clickOverlay.MouseButton1Click:Connect(function()
        isOn=not isOn; setV(isOn); if onToggle then pcall(onToggle, isOn) end; autoSaveConfig()
    end)
    if registryKey then
        ToggleRegistry[registryKey] = {
            setVisual = function(state)
                isOn = state and true or false
                setV(isOn)
            end,
            getValue = function() return isOn end,
            syncOnly = true,
        }
    end
    return setV
end

local function makeStatusRow(label, valTxt)
    local wrap, card, hf = makeCardRow(38)
    cardLabel(card, label)
    local val=Instance.new("TextLabel",card); val.Size=UDim2.new(0.5,-10,1,0)
    val.Position=UDim2.new(0.48,0,0,0); val.BackgroundTransparency=1; val.Text=valTxt
    val.TextColor3=C_DIM; val.Font=Enum.Font.GothamBold; val.TextSize=12
    val.TextXAlignment=Enum.TextXAlignment.Right; val.ZIndex=14
    return val
end

local function makeActionButtonRow(label, onClick)
    local wrap, card, hf = makeCardRow(38)
    local btn=Instance.new("TextButton",card)
    btn.Size=UDim2.new(1,-20,1,-8); btn.Position=UDim2.new(0,10,0,4)
    btn.BackgroundColor3=C_WHITE; btn.BorderSizePixel=0; btn.Text=label
    btn.TextColor3=C_BLACK; btn.Font=Enum.Font.GothamBold; btn.TextSize=12
    btn.AutoButtonColor=false; btn.ZIndex=15
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
    btn.MouseButton1Click:Connect(function() if onClick then onClick() end end)
    return btn
end

local function makeSkinPicker3D(title, cat, getKey, setKey)
    local wrap, card, hf = makeCardRow(88)
    local titleLbl = cardLabel(card, title)
    titleLbl.Size = UDim2.new(1,-16,0,16)
    titleLbl.Position = UDim2.new(0,14,0,4)

    local vp = Instance.new("ViewportFrame", card)
    vp.Size = UDim2.new(0,64,0,56); vp.Position = UDim2.new(0,14,0,24)
    vp.BackgroundColor3 = Color3.fromRGB(30,30,40); vp.BorderSizePixel = 0
    Instance.new("UICorner", vp).CornerRadius = UDim.new(0,8)
    vp.ZIndex = 15

    local world = Instance.new("WorldModel", vp)
    local cam = Instance.new("Camera", vp)
    vp.CurrentCamera = cam

    local nameLbl = Instance.new("TextLabel", card)
    nameLbl.Size = UDim2.new(1,-100,0,18); nameLbl.Position = UDim2.new(0,88,0,28)
    nameLbl.BackgroundTransparency = 1; nameLbl.TextColor3 = Color3.fromRGB(230,230,245)
    nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 12
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left; nameLbl.ZIndex = 15

    local prev = Instance.new("TextButton", card)
    prev.Size = UDim2.new(0,28,0,22); prev.Position = UDim2.new(0,88,0,52)
    prev.Text = "<"; prev.Font = Enum.Font.GothamBlack; prev.TextSize = 14
    prev.BackgroundColor3 = Color3.fromRGB(0,0,0); prev.TextColor3 = Color3.fromRGB(255,255,255)
    prev.BorderSizePixel = 0; prev.AutoButtonColor = false; prev.ZIndex = 16
    Instance.new("UICorner", prev).CornerRadius = UDim.new(0,6)

    local nxt = Instance.new("TextButton", card)
    nxt.Size = UDim2.new(0,28,0,22); nxt.Position = UDim2.new(0,122,0,52)
    nxt.Text = ">"; nxt.Font = Enum.Font.GothamBlack; nxt.TextSize = 14
    nxt.BackgroundColor3 = Color3.fromRGB(0,0,0); nxt.TextColor3 = Color3.fromRGB(255,255,255)
    nxt.BorderSizePixel = 0; nxt.AutoButtonColor = false; nxt.ZIndex = 16
    Instance.new("UICorner", nxt).CornerRadius = UDim.new(0,6)

    local keys = {}
    for k,v in pairs(M.CustomToolAssets) do if v.cat == cat then table.insert(keys, k) end end
    table.sort(keys)

    local spinConn = nil
    local function show(key)
        for _, ch in ipairs(world:GetChildren()) do ch:Destroy() end
        local data = M.CustomToolAssets[key]; if not data then return end
        nameLbl.Text = data.label or key
        local part = Instance.new("Part", world)
        part.Size = Vector3.new(1,1,1); part.Anchored = true; part.CanCollide = false
        local mesh = Instance.new("SpecialMesh", part)
        mesh.MeshType = Enum.MeshType.FileMesh; mesh.MeshId = data.mesh
        mesh.TextureId = data.tex or ""; mesh.Scale = data.scale
        local dist = data.view or 5
        cam.CFrame = CFrame.new(Vector3.new(0, 0.4, dist), Vector3.new(0,0,0))
        if spinConn then spinConn:Disconnect() end
        local ang = 0
        spinConn = RunService.RenderStepped:Connect(function(dt)
            if not part.Parent then spinConn:Disconnect(); return end
            ang = ang + dt * 1.4
            part.CFrame = CFrame.Angles(0, ang, 0)
        end)
    end

    local function cycle(dir)
        local cur = getKey()
        local idx = 1
        for i,k in ipairs(keys) do if k == cur then idx = i break end end
        idx = ((idx - 1 + dir) % #keys) + 1
        setKey(keys[idx])
        show(keys[idx])
        if State.customToolsEnabled then
            pcall(M.refreshCustomToolSkins)
            pcall(M._customToolWatchdogStart)
        end
        pcall(autoSaveConfig)
    end
    prev.MouseButton1Click:Connect(function() cycle(-1) end)
    nxt.MouseButton1Click:Connect(function() cycle(1) end)
    show(getKey())
end

local function makeAnimPackPicker()
    State.animPackIndex = math.clamp(tonumber(State.animPackIndex) or 1, 1, 6)
    local PACK_LABELS = {"NONE", "1", "2", "3", "4", "5"}
    local NUM_PACKS = #PACK_LABELS

    local holder = Instance.new("Frame")
    holder.Name = "Animation Pack Selector"
    holder.BackgroundColor3 = Color3.fromRGB(22,22,22)
    holder.BackgroundTransparency = 0.15
    holder.Size = UDim2.new(1, 0, 0, 42)
    holder.BorderSizePixel = 0
    holder.LayoutOrder = LO()
    holder.ZIndex = 12
    holder.ClipsDescendants = true
    holder.Parent = currentScroll
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 10)
    local apStroke = Instance.new("UIStroke", holder)
    apStroke.Color = Color3.fromRGB(60,60,70); apStroke.Thickness = 1; apStroke.Transparency = 0.4

    local slide = Instance.new("Frame")
    slide.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
    slide.BackgroundTransparency = 0.1
    slide.AnchorPoint = Vector2.new(0.5, 0.5)
    slide.Size = UDim2.new(1/NUM_PACKS, -4, 1, -8)
    slide.Position = UDim2.new(0.5/NUM_PACKS, 0, 0.5, 0)
    slide.BorderSizePixel = 0; slide.ZIndex = 13; slide.Parent = holder
    Instance.new("UICorner", slide).CornerRadius = UDim.new(0, 8)
    local slideStroke = Instance.new("UIStroke", slide)
    slideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    slideStroke.Color = Color3.fromRGB(147, 197, 253); slideStroke.Thickness = 1.5; slideStroke.Transparency = 0.1

    local labels = {}
    local segW = 1 / NUM_PACKS
    for i, txt in ipairs(PACK_LABELS) do
        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1; lbl.Text = txt
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        lbl.TextStrokeTransparency = 0.2; lbl.TextSize = 11
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        lbl.AnchorPoint = Vector2.new(0.5, 0.5)
        lbl.Size = UDim2.new(segW, 0, 1, 0)
        lbl.Position = UDim2.new(segW * (i - 0.5), 0, 0.5, 0)
        lbl.ZIndex = 15; lbl.Parent = holder
        labels[i] = lbl

        local clickBtn = Instance.new("TextButton")
        clickBtn.BackgroundTransparency = 1; clickBtn.Text = ""
        clickBtn.AutoButtonColor = false
        clickBtn.AnchorPoint = Vector2.new(0.5, 0.5)
        clickBtn.Size = UDim2.new(segW, 0, 1, 0)
        clickBtn.Position = UDim2.new(segW * (i - 0.5), 0, 0.5, 0)
        clickBtn.ZIndex = 16; clickBtn.Parent = holder
        local idx = i
        clickBtn.MouseButton1Click:Connect(function()
            if M.AnimPacks and M.AnimPacks.setPack then
                M.AnimPacks.setPack(idx)
            else
                State.animPackIndex = idx
                autoSaveConfig()
            end
        end)
    end

    local function applyVisual(index)
        index = math.clamp(tonumber(index) or 1, 1, NUM_PACKS)
        TweenService:Create(slide, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(segW * (index - 0.5), 0, 0.5, 0),
            Size = UDim2.new(segW, -4, 1, -8),
        }):Play()
        for i, lbl in ipairs(labels) do
            local sel = (i == index)
            TweenService:Create(lbl, TweenInfo.new(0.14), {
                TextTransparency = sel and 0 or 0.22,
                TextStrokeTransparency = sel and 0.2 or 0.45,
            }):Play()
        end
    end
    applyVisual(State.animPackIndex or 1)
    _G._VexulApplyAnimPackVisual = applyVisual
end

local function makeSkyThemePicker()
    local wrap, card, hf = makeCardRow(46)
    local lbl = cardLabel(card, "Sky Theme")
    lbl.Size = UDim2.new(0, 88, 1, 0)

    local valueLbl = Instance.new("TextButton", card)
    valueLbl.Size = UDim2.new(0,140,0,26); valueLbl.Position = UDim2.new(1,-148,0.5,-13)
    valueLbl.BackgroundColor3 = Color3.fromRGB(255,255,255); valueLbl.BorderSizePixel = 0
    valueLbl.Text = State.skyTheme or "Off"
    valueLbl.TextColor3 = Color3.fromRGB(0,0,0); valueLbl.Font = Enum.Font.GothamBold; valueLbl.TextSize = 12
    valueLbl.TextXAlignment = Enum.TextXAlignment.Center; valueLbl.ZIndex = 15; valueLbl.AutoButtonColor = false
    Instance.new("UICorner", valueLbl).CornerRadius = UDim.new(0,7)
    valueLbl.TextTruncate = Enum.TextTruncate.AtEnd

    _G._VexulSyncSkyLabel = function()
        valueLbl.Text = State.skyTheme or "Off"
    end

    local pickerGui = nil
    local function closePicker()
        if pickerGui and pickerGui.Parent then pickerGui:Destroy() end
        pickerGui = nil
    end

    valueLbl.MouseButton1Click:Connect(function()
        if pickerGui then closePicker(); return end

        pickerGui = Instance.new("ScreenGui")
        pickerGui.Name = "VexulSkyPicker"
        pickerGui.ResetOnSpawn = false
        pickerGui.IgnoreGuiInset = true
        pickerGui.DisplayOrder = 9999
        pickerGui.Parent = LP:WaitForChild("PlayerGui")

        local backdrop = Instance.new("Frame", pickerGui)
        backdrop.Size = UDim2.new(1,0,1,0)
        backdrop.BackgroundColor3 = Color3.fromRGB(0,0,0)
        backdrop.BackgroundTransparency = 0.5
        backdrop.BorderSizePixel = 0

        local frame = Instance.new("Frame", pickerGui)
        frame.Size = UDim2.new(0,380,0,520)
        frame.Position = UDim2.new(0.5,-190,0.5,-260)
        frame.BackgroundColor3 = Color3.fromRGB(8,8,10); frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

        local titleBar = Instance.new("Frame", frame)
        titleBar.Size = UDim2.new(1,0,0,48)
        titleBar.BackgroundColor3 = Color3.fromRGB(12,12,15); titleBar.BorderSizePixel = 0
        Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,16)

        local titleLbl = Instance.new("TextLabel", titleBar)
        titleLbl.Size = UDim2.new(1,-60,1,0); titleLbl.Position = UDim2.new(0,18,0,0)
        titleLbl.BackgroundTransparency = 1; titleLbl.Text = "SELECT SKY PRESET"
        titleLbl.TextColor3 = Color3.fromRGB(255,255,255); titleLbl.Font = Enum.Font.GothamBlack
        titleLbl.TextSize = 16; titleLbl.TextXAlignment = Enum.TextXAlignment.Left

        local closeBtn = Instance.new("TextButton", titleBar)
        closeBtn.Size = UDim2.new(0,36,0,36); closeBtn.Position = UDim2.new(1,-44,0,6)
        closeBtn.BackgroundColor3 = Color3.fromRGB(25,25,28); closeBtn.BorderSizePixel = 0
        closeBtn.Text = "X"; closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
        closeBtn.Font = Enum.Font.GothamBlack; closeBtn.TextSize = 14
        closeBtn.AutoButtonColor = false
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,10)
        closeBtn.Activated:Connect(closePicker)

        local scroll = Instance.new("ScrollingFrame", frame)
        scroll.Size = UDim2.new(1,-16,1,-64); scroll.Position = UDim2.new(0,8,0,56)
        scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 4; scroll.ScrollBarImageColor3 = Color3.fromRGB(80,80,90)
        scroll.CanvasSize = UDim2.new(0,0,0,0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

        local grid = Instance.new("UIGridLayout", scroll)
        grid.CellSize = UDim2.new(0,108,0,108)
        grid.CellPadding = UDim2.new(0,10,0,10)
        grid.FillDirection = Enum.FillDirection.Horizontal
        grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
        grid.SortOrder = Enum.SortOrder.LayoutOrder

        local pad = Instance.new("UIPadding", scroll)
        pad.PaddingLeft = UDim.new(0,8); pad.PaddingRight = UDim.new(0,8)
        pad.PaddingTop = UDim.new(0,8); pad.PaddingBottom = UDim.new(0,8)

        for i, presetName in ipairs(M.SkyTheme.PRESETS_LIST) do
            local presetBtn = Instance.new("TextButton", scroll)
            presetBtn.Size = UDim2.new(1,0,1,0)
            presetBtn.BackgroundColor3 = Color3.fromRGB(14,14,18)
            presetBtn.BorderSizePixel = 0; presetBtn.Text = ""
            presetBtn.AutoButtonColor = false
            presetBtn.LayoutOrder = i
            presetBtn.ClipsDescendants = true
            Instance.new("UICorner", presetBtn).CornerRadius = UDim.new(0,18)

            local colT = M.SkyTheme.PRESET_COLORS[presetName] or {128,128,128}
            local presetCol = Color3.fromRGB(colT[1], colT[2], colT[3])
            local isSelected = (State.skyTheme == presetName)

            local grad = Instance.new("UIGradient", presetBtn)
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, presetCol),
                ColorSequenceKeypoint.new(0.55, Color3.fromRGB(
                    math.floor(presetCol.R*110), math.floor(presetCol.G*110), math.floor(presetCol.B*110))),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,14)),
            })
            grad.Rotation = 90

            local st = Instance.new("UIStroke", presetBtn)
            st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            st.Color = isSelected and Color3.fromRGB(255,255,255) or presetCol
            st.Thickness = isSelected and 2.4 or 1.2
            st.Transparency = isSelected and 0 or 0.55

            local circle = Instance.new("Frame", presetBtn)
            circle.Size = UDim2.new(0,40,0,40); circle.Position = UDim2.new(0.5,-20,0,18)
            circle.BackgroundColor3 = presetCol; circle.BorderSizePixel = 0
            Instance.new("UICorner", circle).CornerRadius = UDim.new(0,12)

            local circleGrad = Instance.new("UIGradient", circle)
            if presetName == "Rainbow" then
                circleGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,   Color3.fromRGB(255,60,60)),
                    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255,180,40)),
                    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(90,220,90)),
                    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(60,200,255)),
                    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(120,110,255)),
                    ColorSequenceKeypoint.new(1,   Color3.fromRGB(230,90,220)),
                })
            else
                circleGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
                    ColorSequenceKeypoint.new(0.45, presetCol),
                    ColorSequenceKeypoint.new(1, presetCol),
                })
                circleGrad.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0,0.55),
                    NumberSequenceKeypoint.new(0.45,0),
                    NumberSequenceKeypoint.new(1,0),
                })
            end
            circleGrad.Rotation = 125

            local nameLbl = Instance.new("TextLabel", presetBtn)
            nameLbl.Size = UDim2.new(1,-8,0,24); nameLbl.Position = UDim2.new(0,4,1,-32)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = string.upper(presetName)
            nameLbl.TextColor3 = Color3.fromRGB(255,255,255)
            nameLbl.TextStrokeTransparency = 0.4
            nameLbl.Font = Enum.Font.GothamBlack; nameLbl.TextSize = 10
            nameLbl.TextWrapped = true

            presetBtn.Activated:Connect(function()
                State.skyTheme = presetName
                valueLbl.Text = presetName
                if M.SkyTheme and M.SkyTheme.apply then
                    pcall(M.SkyTheme.apply, presetName)
                end
                closePicker()
            end)
        end

        backdrop.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
               or input.UserInputType == Enum.UserInputType.Touch then
                closePicker()
            end
        end)
    end)
end

local speedScroll = addNavButton("Speed", "Speed", 1)
setActiveScroll(speedScroll)
normalBox = makeInputRow("Normal Speed", State.normalSpeed, function(v) local n=tonumber(v); if n and n>0 and n<=500 then State.normalSpeed=n end end, true)
carryBox = makeInputRow("Carry Speed", State.carrySpeed, function(v) local n=tonumber(v); if n and n>0 and n<=500 then State.carrySpeed=n end end, true)
laggerBox = makeInputRow("Lagger Speed", State.laggerSpeed, function(v) local n=tonumber(v); if n and n>0 and n<=500 then State.laggerSpeed=n end end, true)
carryLaggerBox = makeInputRow("Lagger Carry Speed", State.laggerCarrySpeed, function(v) local n=tonumber(v); if n and n>0 and n<=500 then State.laggerCarrySpeed=n end end, true)
modeValLbl = makeStatusRow("Mode", "Normal")

local mechScroll = addNavButton("Mechanics", "Mechanics", 2)
setActiveScroll(mechScroll)
setInstaGrab = makeToggleRow("Auto Grab", false, function(on) AutoSteal.Enabled=on; if on then startAutoSteal() else stopAutoSteal() end end)
radiusBox = makeInputRow("Steal Radius", AutoSteal.Radius, function(v) local n=tonumber(v); if n and n>=5 and n<=300 then AutoSteal.Radius=math.floor(n); if progressRadLbl then progressRadLbl.Text="Radius: "..AutoSteal.Radius end end end)
setInfJump = makeToggleRow("Infinite Jump", false, function(on) State.infJumpEnabled=on end)

do
    local setManual = makeToggleRow("Manual", State.infJumpMode=="manual", function(on)
        if on then State.infJumpMode="manual"; if _G._setHoldRow then _G._setHoldRow(false) end
        else State.infJumpMode="" end
        autoSaveConfig()
    end)
    _G._setManualRow = setManual
    local setHold = makeToggleRow("Hold", State.infJumpMode=="hold", function(on)
        if on then State.infJumpMode="hold"; if _G._setManualRow then _G._setManualRow(false) end
        else State.infJumpMode="" end
        autoSaveConfig()
    end)
    _G._setHoldRow = setHold
    _G._updateInfJumpModeUI = function()
        if _G._setManualRow then _G._setManualRow(State.infJumpMode=="manual") end
        if _G._setHoldRow then _G._setHoldRow(State.infJumpMode=="hold") end
    end
end

setAutoTpDown = makeToggleRow("Auto Tp Down", false, function(on) State.autoTpDownEnabled=on; autoSaveConfig() end)
autoTpDownYBox = makeInputRow("Y Trigger", State.autoTpDownY, function(v) local n=tonumber(v); if n then State.autoTpDownY=n; autoSaveConfig() end end)
setAntiRag = makeToggleRow("Anti Ragdoll", false, function(on) State.antiRagdollEnabled=on; if on then startAntiRagdoll() else stopAntiRagdoll() end end)
setMedusaCounter = makeToggleRow("Medusa Counter", false, function(on) State.medusaCounterEnabled=on; if on then setupMedusaCounter(LP.Character) else stopMedusaCounter() end end)
setUnwalk = makeToggleRow("Unwalk", false, function(on) State.unwalkEnabled=on; if on then startUnwalk() else stopUnwalk() end; autoSaveConfig() end)

local moveScroll = addNavButton("Movement", "Movement", 3)
setActiveScroll(moveScroll)
setMenuDropBR = makeToggleRow("Drop Brainrot", false, function(on) if on then runDropBrainrot(); task.delay(0.5,function() if setMenuDropBR then setMenuDropBR(false) end; if MobileButtons.Buttons and MobileButtons.Buttons.dropBR then MobileButtons.Buttons.dropBR(false) end end) end end)
setMenuTpDown = makeToggleRow("Tp Down", false, function(on) if on then tpToGround(); task.delay(0.5,function() if setMenuTpDown then setMenuTpDown(false) end; if MobileButtons.Buttons and MobileButtons.Buttons.tpDown then MobileButtons.Buttons.tpDown(false) end end) end end)
setAutoLeft = makeToggleRow("Auto Left", false, function(on)
    if on and State.autoRightEnabled then State.autoRightEnabled=false; if stopAutoRight then stopAutoRight() end; if setAutoRight then setAutoRight(false) end; if MobileButtons.Buttons.autoRight then MobileButtons.Buttons.autoRight(false) end end
    State.autoLeftEnabled=on; if MobileButtons.Buttons.autoLeft then MobileButtons.Buttons.autoLeft(on) end
    if on then startAutoLeft() else stopAutoLeft() end
end)
setAutoRight = makeToggleRow("Auto Right", false, function(on)
    if on and State.autoLeftEnabled then State.autoLeftEnabled=false; if stopAutoLeft then stopAutoLeft() end; if setAutoLeft then setAutoLeft(false) end; if MobileButtons.Buttons.autoLeft then MobileButtons.Buttons.autoLeft(false) end end
    State.autoRightEnabled=on; if MobileButtons.Buttons.autoRight then MobileButtons.Buttons.autoRight(on) end
    if on then startAutoRight() else stopAutoRight() end
end)

local batScroll = addNavButton("BatAimbot", "Bat Aimbot", 4)
setActiveScroll(batScroll)
setAutoBat = makeToggleRow("Auto Bat", false, function(on)
    State.autoBatToggled = on
    if on then
        if State.autoLeftEnabled then State.autoLeftEnabled=false; if stopAutoLeft then stopAutoLeft() end; if setAutoLeft then setAutoLeft(false) end; if MobileButtons.Buttons.autoLeft then MobileButtons.Buttons.autoLeft(false) end end
        if State.autoRightEnabled then State.autoRightEnabled=false; if stopAutoRight then stopAutoRight() end; if setAutoRight then setAutoRight(false) end; if MobileButtons.Buttons.autoRight then MobileButtons.Buttons.autoRight(false) end end
    end
    if MobileButtons.Buttons.autoBat then MobileButtons.Buttons.autoBat(on) end
end)

local visualScroll = addNavButton("Visual", "Visual", 5)
setActiveScroll(visualScroll)
setFps = makeToggleRow("FPS Boost", false, function(on) State.fpsBoostEnabled=on; if on then pcall(applyFPSBoost) end end)

makeToggleRow("Custom Tools", State.customToolsEnabled, function(on)
    State.customToolsEnabled = on
    if on then
        pcall(M.refreshCustomToolSkins)
        pcall(M._customToolWatchdogStart)
    else
        pcall(M._customToolWatchdogStop)
        pcall(M.clearCustomToolSkins)
    end
    autoSaveConfig()
end, "customToolsEnabled")

makeSkinPicker3D("Bat Skin 3D", "Bat",
    function() return State.customBatSkin or "DiamondSword" end,
    function(k) State.customBatSkin = k end)

makeSkinPicker3D("Medusa Skin 3D", "Medusa",
    function() return State.customMedusaSkin or "GoldenDesertEagle" end,
    function(k) State.customMedusaSkin = k end)

makeToggleRow("Rainbow Tools", State.rainbowToolsEnabled, function(on)
    M.setRainbowTools(on)
    autoSaveConfig()
end, "rainbowToolsEnabled")

makeToggleRow("Headless", State.headlessEnabled, function(on)
    State.headlessEnabled = on
    applyHeadlessToCharacter(LP.Character, on)
    if not State._headlessConn then
        State._headlessConn = LP.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            if State.headlessEnabled then applyHeadlessToCharacter(char, true) end
        end)
    end
    autoSaveConfig()
end, "headlessEnabled")

makeToggleRow("Korblox", State.korbloxEnabled, function(on)
    State.korbloxEnabled = on
    applyKorbloxToCharacter(LP.Character, on)
    if not State._korbloxConn then
        State._korbloxConn = LP.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            if State.korbloxEnabled then applyKorbloxToCharacter(char, true) end
        end)
    end
    autoSaveConfig()
end, "korbloxEnabled")

makeToggleRow("Stretch Rez", State.stretchRezEnabled, function(on)
    State.stretchRezEnabled = on
    if on then startStretch() else stopStretch() end
    autoSaveConfig()
end, "stretchRezEnabled")

makeToggleRow("Custom Song (Bat + Medusa)", State.customSongEnabled, function(on)
    State.customSongEnabled = on
    if on then
        scanCustomSong()
        startCustomSongWatchers()
    else
        stopCustomSongWatchers()
        clearCustomSong()
    end
    autoSaveConfig()
end, "customSongEnabled")

makeToggleRow("Rainbow Joystick", State.rainbowJoystickEnabled, function(on)
    State.rainbowJoystickEnabled = on
    if on then rjStart() else rjStop() end
    autoSaveConfig()
end, "rainbowJoystickEnabled")

makeAnimPackPicker()
makeSkyThemePicker()

do
    local AC_CATEGORIES = {
        { Name="Hair",     AssetTypes={Enum.AvatarAssetType.HairAccessory} },
        { Name="Hats",     AssetTypes={Enum.AvatarAssetType.Hat} },
        { Name="Face",     AssetTypes={Enum.AvatarAssetType.FaceAccessory} },
        { Name="Neck",     AssetTypes={Enum.AvatarAssetType.NeckAccessory} },
        { Name="Shoulder", AssetTypes={Enum.AvatarAssetType.ShoulderAccessory} },
        { Name="Front",    AssetTypes={Enum.AvatarAssetType.FrontAccessory} },
        { Name="Back",     AssetTypes={Enum.AvatarAssetType.BackAccessory} },
        { Name="Waist",    AssetTypes={Enum.AvatarAssetType.WaistAccessory} },
        { Name="Shirts",   AssetTypes={Enum.AvatarAssetType.Shirt} },
        { Name="Pants",    AssetTypes={Enum.AvatarAssetType.Pants} },
        { Name="T-Shirts", AssetTypes={Enum.AvatarAssetType.TShirt} },
        { Name="Jackets",  AssetTypes={Enum.AvatarAssetType.JacketAccessory} },
        { Name="Sweaters", AssetTypes={Enum.AvatarAssetType.SweaterAccessory} },
        { Name="Bottoms",  AssetTypes={Enum.AvatarAssetType.ShortsAccessory} },
    }
    for _, cat in ipairs(AC_CATEGORIES) do
        if not State.avatarChanger[cat.Name] then
            State.avatarChanger[cat.Name] = { enabled = false, savedId = nil, savedName = "" }
        end
    end
    local _acGen = 0
    local _acAssetCache = {}
    local function _acWaitCharReady(character, timeout)
        character = character or LP.Character
        if not character then return false end
        local deadline = os.clock() + (tonumber(timeout) or 5)
        while os.clock() < deadline do
            if not character.Parent then return false end
            if LP.Character and LP.Character ~= character then return false end
            if character:FindFirstChild("Head") and character:FindFirstChild("HumanoidRootPart")
               and character:FindFirstChildOfClass("Humanoid") then return true end
            task.wait(0.05)
        end
        return false
    end
    local function _acEquipItem(itemId, itemType, itemName, gen)
        if not itemId then return false end
        if gen == nil then gen = _acGen end
        local ok, applied = pcall(function()
            local objects
            local cached = _acAssetCache[itemId]
            if cached then objects = { cached:Clone() }
            else
                objects = game:GetObjects("rbxassetid://"..tostring(itemId))
                if objects and objects[1] then _acAssetCache[itemId] = objects[1]:Clone() end
            end
            if gen ~= _acGen then return false end
            local character = LP.Character
            if not character or not character.Parent then return false end
            if not _acWaitCharReady(character, 5) then return false end
            if gen ~= _acGen then return false end
            if not objects or #objects == 0 then return false end
            local item = objects[1]
            if item:IsA("Folder") or item:IsA("Model") then
                local core = item:FindFirstChildOfClass("Accessory")
                    or item:FindFirstChildOfClass("Shirt")
                    or item:FindFirstChildOfClass("Pants")
                    or item:FindFirstChildOfClass("ShirtGraphic")
                if core then item = core end
            end
            if item:IsA("Shirt") then
                for _, c in pairs(character:GetChildren()) do if c:IsA("Shirt") then c:Destroy() end end
                item.Name = "ACShirt"; item.Parent = character; return true
            elseif item:IsA("Pants") then
                for _, c in pairs(character:GetChildren()) do if c:IsA("Pants") then c:Destroy() end end
                item.Name = "ACPants"; item.Parent = character; return true
            elseif item:IsA("ShirtGraphic") then
                for _, c in pairs(character:GetChildren()) do if c:IsA("ShirtGraphic") then c:Destroy() end end
                item.Name = "ACTShirt"; item.Parent = character; return true
            end
            if item:IsA("Accessory") then
                local handle = item:FindFirstChild("Handle")
                if handle then
                    for _, c in pairs(character:GetChildren()) do
                        if c:IsA("Accessory") and (c.Name == itemName or c.Name == "AC"..itemName) then c:Destroy() end
                    end
                    local attachment = handle:FindFirstChildOfClass("Attachment")
                    local targetPart = character:FindFirstChild("Head")
                    local targetAttachment = nil
                    if attachment then
                        for _, bodyPart in pairs(character:GetChildren()) do
                            if bodyPart:IsA("BasePart") then
                                targetAttachment = bodyPart:FindFirstChild(attachment.Name)
                                if targetAttachment then targetPart = bodyPart; break end
                            end
                        end
                    end
                    if not targetPart then targetPart = character:FindFirstChild("HumanoidRootPart") end
                    if not targetPart then return false end
                    item.Name = "AC"..itemName; item.Parent = character
                    handle.CFrame = targetPart.CFrame
                    for _, j in pairs(handle:GetChildren()) do
                        if j:IsA("Weld") or j:IsA("ManualWeld") or j:IsA("WeldConstraint") then j:Destroy() end
                    end
                    local w = Instance.new("Weld")
                    w.Name = "ACManualWeld"; w.Part0 = handle; w.Part1 = targetPart
                    if attachment and targetAttachment then
                        w.C0 = attachment.CFrame; w.C1 = targetAttachment.CFrame
                    else w.C0 = CFrame.new(0, 0.5, 0) end
                    w.Parent = handle
                    return true
                end
            end
            return false
        end)
        return ok and applied == true
    end
    local function _acRemoveItem(itemType, itemName)
        local character = LP.Character
        if not character then return end
        pcall(function()
            if itemType == Enum.AvatarAssetType.Shirt then
                for _, c in pairs(character:GetChildren()) do
                    if c:IsA("Shirt") and (c.Name == "ACShirt" or c.Name == itemName) then c:Destroy() end
                end
            elseif itemType == Enum.AvatarAssetType.Pants then
                for _, c in pairs(character:GetChildren()) do
                    if c:IsA("Pants") and (c.Name == "ACPants" or c.Name == itemName) then c:Destroy() end
                end
            elseif itemType == Enum.AvatarAssetType.TShirt then
                for _, c in pairs(character:GetChildren()) do
                    if c:IsA("ShirtGraphic") and (c.Name == "ACTShirt" or c.Name == itemName) then c:Destroy() end
                end
            else
                for _, c in pairs(character:GetChildren()) do
                    if c:IsA("Accessory") and (c.Name == "AC"..itemName or c.Name == itemName) then c:Destroy() end
                end
            end
        end)
    end
    local function _acApplyAll(gen)
        if gen == nil then gen = _acGen end
        local character = LP.Character
        if not character then return end
        if not _acWaitCharReady(character, 10) then return end
        if gen ~= _acGen then return end
        for _, cat in ipairs(AC_CATEGORIES) do
            if gen ~= _acGen then return end
            local entry = State.avatarChanger[cat.Name]
            if entry and entry.enabled and entry.savedId then
                for attempt = 1, 3 do
                    if gen ~= _acGen then return end
                    if _acEquipItem(entry.savedId, cat.AssetTypes[1], entry.savedName, gen) then break end
                    task.wait(0.25 * attempt)
                end
                task.wait(0.05)
            end
        end
    end
    LP.CharacterAdded:Connect(function()
        _acGen = _acGen + 1
        local gen = _acGen
        task.spawn(function() _acApplyAll(gen) end)
    end)
    task.spawn(function() if LP.Character then _acApplyAll(_acGen) end end)
    local _acPickerGui = nil
    local _acPickerCat = nil
    local function _acClosePicker()
        if _acPickerGui and _acPickerGui.Parent then _acPickerGui:Destroy() end
        _acPickerGui = nil; _acPickerCat = nil
    end
    local function _acOpenPicker(catName, assetTypes)
        if _acPickerGui and _acPickerGui.Parent and _acPickerCat == catName then _acClosePicker(); return end
        _acClosePicker(); _acPickerCat = catName
        _acPickerGui = Instance.new("ScreenGui")
        _acPickerGui.Name = "VexulAvatarChanger"
        _acPickerGui.ResetOnSpawn = false
        _acPickerGui.IgnoreGuiInset = true
        _acPickerGui.DisplayOrder = 9998
        _acPickerGui.Parent = LP:WaitForChild("PlayerGui")
        local backdrop = Instance.new("Frame", _acPickerGui)
        backdrop.Size = UDim2.new(1,0,1,0)
        backdrop.BackgroundColor3 = Color3.fromRGB(0,0,0)
        backdrop.BackgroundTransparency = 0.45
        local pickerFrame = Instance.new("Frame", _acPickerGui)
        pickerFrame.Size = UDim2.new(0,370,0,510)
        pickerFrame.Position = UDim2.new(0.5,-185,0.5,-255)
        pickerFrame.BackgroundColor3 = Color3.fromRGB(8,8,10)
        Instance.new("UICorner", pickerFrame).CornerRadius = UDim.new(0,16)
        local titleBar = Instance.new("Frame", pickerFrame)
        titleBar.Size = UDim2.new(1,0,0,48)
        titleBar.BackgroundColor3 = Color3.fromRGB(12,12,15)
        Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,16)
        local titleLabel = Instance.new("TextLabel", titleBar)
        titleLabel.Size = UDim2.new(1,-60,1,0); titleLabel.Position = UDim2.new(0,18,0,0)
        titleLabel.BackgroundTransparency = 1; titleLabel.Text = catName.." Changer"
        titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
        titleLabel.Font = Enum.Font.GothamBlack; titleLabel.TextSize = 15
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        local closeBtn = Instance.new("TextButton", titleBar)
        closeBtn.Size = UDim2.new(0,36,0,36); closeBtn.Position = UDim2.new(1,-44,0,6)
        closeBtn.BackgroundColor3 = Color3.fromRGB(25,25,28)
        closeBtn.Text = "X"; closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
        closeBtn.Font = Enum.Font.GothamBlack; closeBtn.TextSize = 14
        closeBtn.AutoButtonColor = false
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,10)
        closeBtn.Activated:Connect(_acClosePicker)
        local searchBar = Instance.new("TextBox", pickerFrame)
        searchBar.Size = UDim2.new(1,-24,0,30); searchBar.Position = UDim2.new(0,12,0,55)
        searchBar.BackgroundColor3 = Color3.fromRGB(18,18,22)
        searchBar.PlaceholderText = "Search..."
        searchBar.PlaceholderColor3 = Color3.fromRGB(110,110,120)
        searchBar.Text = ""; searchBar.TextColor3 = Color3.fromRGB(245,245,255)
        searchBar.Font = Enum.Font.GothamSemibold; searchBar.TextSize = 12
        searchBar.ClearTextOnFocus = false
        Instance.new("UICorner", searchBar).CornerRadius = UDim.new(0,8)
        local scrollFrame = Instance.new("ScrollingFrame", pickerFrame)
        scrollFrame.Size = UDim2.new(1,-12,1,-100); scrollFrame.Position = UDim2.new(0,6,0,96)
        scrollFrame.BackgroundTransparency = 1; scrollFrame.BorderSizePixel = 0
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80,80,90)
        scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
        scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local grid = Instance.new("UIGridLayout", scrollFrame)
        grid.CellSize = UDim2.new(0,100,0,120)
        grid.CellPadding = UDim2.new(0,8,0,8)
        grid.FillDirection = Enum.FillDirection.Horizontal
        grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
        local itemOrder = 0; local page = nil; local loadingMore = false
        local function makeItemCard(item)
            itemOrder = itemOrder + 1
            local card = Instance.new("TextButton", scrollFrame)
            card.Size = UDim2.new(1,0,1,0)
            card.BackgroundColor3 = Color3.fromRGB(16,16,20)
            card.Text = ""; card.AutoButtonColor = false
            card.LayoutOrder = itemOrder
            Instance.new("UICorner", card).CornerRadius = UDim.new(0,10)
            local thumb = Instance.new("ImageLabel", card)
            thumb.Size = UDim2.new(1,-8,0,72); thumb.Position = UDim2.new(0,4,0,4)
            thumb.BackgroundColor3 = Color3.fromRGB(22,22,28)
            thumb.Image = "rbxthumb://type=Asset&id="..tostring(item.Id).."&w=150&h=150"
            thumb.ScaleType = Enum.ScaleType.Fit
            Instance.new("UICorner", thumb).CornerRadius = UDim.new(0,7)
            local nameLbl = Instance.new("TextLabel", card)
            nameLbl.Size = UDim2.new(1,-6,0,30); nameLbl.Position = UDim2.new(0,3,0,78)
            nameLbl.BackgroundTransparency = 1; nameLbl.Text = item.Name or "?"
            nameLbl.TextColor3 = Color3.fromRGB(225,225,235)
            nameLbl.Font = Enum.Font.GothamSemibold; nameLbl.TextSize = 9
            nameLbl.TextWrapped = true
            card.Activated:Connect(function()
                local ent = State.avatarChanger[catName]
                if not ent then return end
                if ent.enabled and ent.savedId and ent.savedName ~= "" then
                    _acRemoveItem(assetTypes[1], ent.savedName)
                end
                ent.savedId = item.Id; ent.savedName = item.Name or ""
                if ent.enabled then
                    local _id, _at, _nm = item.Id, assetTypes[1], item.Name or ""
                    task.spawn(function() _acEquipItem(_id, _at, _nm) end)
                end
                autoSaveConfig()
            end)
        end
        local function loadItems(keyword)
            for _, c in ipairs(scrollFrame:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            itemOrder = 0; page = nil; loadingMore = false
            task.spawn(function()
                local ok, pages = pcall(function()
                    local params = CatalogSearchParams.new()
                    params.AssetTypes = assetTypes
                    if keyword and keyword ~= "" then params.SearchKeyword = keyword end
                    return game:GetService("AvatarEditorService"):SearchCatalog(params)
                end)
                if not ok or not pages then return end
                page = pages
                for _, item in ipairs(pages:GetCurrentPage()) do makeItemCard(item) end
            end)
        end
        scrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            if loadingMore or not page then return end
            local posY = scrollFrame.CanvasPosition.Y
            local canvasH = scrollFrame.CanvasSize.Y.Offset
            local viewH = scrollFrame.AbsoluteSize.Y
            if canvasH > 0 and posY + viewH >= canvasH - 100 and not page.IsFinished then
                loadingMore = true
                task.spawn(function()
                    local ok = pcall(function() page:AdvanceToNextPageAsync() end)
                    if ok then
                        for _, item in ipairs(page:GetCurrentPage()) do makeItemCard(item) end
                    end
                    loadingMore = false
                end)
            end
        end)
        local debounce = nil
        searchBar:GetPropertyChangedSignal("Text"):Connect(function()
            if debounce then task.cancel(debounce) end
            debounce = task.delay(0.5, function() loadItems(searchBar.Text) end)
        end)
        backdrop.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
               or input.UserInputType == Enum.UserInputType.Touch then _acClosePicker() end
        end)
        loadItems("")
    end
    local wrap, card, hf = makeCardRow(42)
    local lbl = cardLabel(card, "Avatar Changer")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    local animArrow = Instance.new("TextButton", card)
    animArrow.Size = UDim2.new(0, 28, 0, 24); animArrow.Position = UDim2.new(1, -38, 0.5, -12)
    animArrow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    animArrow.Text = "\u{25B2}"; animArrow.TextColor3 = Color3.fromRGB(255,255,255)
    animArrow.TextSize = 14; animArrow.Font = Enum.Font.GothamBold
    animArrow.AutoButtonColor = false; animArrow.ZIndex = 15
    Instance.new("UICorner", animArrow).CornerRadius = UDim.new(0, 7)
    local TEND_H = 280
    local wrapBox = Instance.new("Frame", currentScroll)
    wrapBox.Size = UDim2.new(1, 0, 0, TEND_H + 4)
    wrapBox.BackgroundTransparency = 1
    wrapBox.LayoutOrder = LO()
    wrapBox.Visible = false
    local animHolder = Instance.new("ScrollingFrame", wrapBox)
    animHolder.Size = UDim2.new(1, 0, 1, -4); animHolder.Position = UDim2.new(0, 0, 0, 2)
    animHolder.BackgroundColor3 = C_ROW_BG
    animHolder.BorderSizePixel = 0; animHolder.ScrollBarThickness = 3
    animHolder.ScrollBarImageColor3 = Color3.fromRGB(70,70,80)
    animHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    animHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    animHolder.ZIndex = 12
    Instance.new("UICorner", animHolder).CornerRadius = UDim.new(0, 10)
    local animList = Instance.new("UIListLayout", animHolder)
    animList.SortOrder = Enum.SortOrder.LayoutOrder
    animList.Padding = UDim.new(0, 4)
    local animPad = Instance.new("UIPadding", animHolder)
    animPad.PaddingTop = UDim.new(0, 6); animPad.PaddingBottom = UDim.new(0, 6)
    animPad.PaddingLeft = UDim.new(0, 6); animPad.PaddingRight = UDim.new(0, 6)
    _G._VexulACVisualSetters = {}
    for i, cat in ipairs(AC_CATEGORIES) do
        local subWrap = Instance.new("Frame", animHolder)
        subWrap.Size = UDim2.new(1, 0, 0, 34)
        subWrap.BackgroundColor3 = Color3.fromRGB(18,18,18)
        subWrap.LayoutOrder = i; subWrap.ZIndex = 13
        Instance.new("UICorner", subWrap).CornerRadius = UDim.new(0, 8)
        local subLbl = Instance.new("TextLabel", subWrap)
        subLbl.Size = UDim2.new(1, -140, 1, 0); subLbl.Position = UDim2.new(0, 12, 0, 0)
        subLbl.BackgroundTransparency = 1; subLbl.Text = cat.Name
        subLbl.TextColor3 = Color3.fromRGB(220,220,220)
        subLbl.Font = Enum.Font.GothamBold; subLbl.TextSize = 12
        subLbl.TextXAlignment = Enum.TextXAlignment.Left; subLbl.ZIndex = 14
        subLbl.TextTruncate = Enum.TextTruncate.AtEnd
        local _, subSetV = makePill(subWrap, false, -110)
        local pillBtn = Instance.new("TextButton", subWrap)
        pillBtn.Size = UDim2.new(0, 46, 0, 24); pillBtn.Position = UDim2.new(1, -110, 0.5, -12)
        pillBtn.BackgroundTransparency = 1; pillBtn.Text = ""; pillBtn.ZIndex = 17; pillBtn.AutoButtonColor = false
        local pickBtn = Instance.new("TextButton", subWrap)
        pickBtn.Size = UDim2.new(0, 50, 0, 24); pickBtn.Position = UDim2.new(1, -58, 0.5, -12)
        pickBtn.BackgroundColor3 = C_WHITE; pickBtn.BorderSizePixel = 0
        pickBtn.Text = "PICK"; pickBtn.TextColor3 = C_BLACK
        pickBtn.Font = Enum.Font.GothamBold; pickBtn.TextSize = 10
        pickBtn.AutoButtonColor = false; pickBtn.ZIndex = 18
        Instance.new("UICorner", pickBtn).CornerRadius = UDim.new(0, 6)
        local catName = cat.Name; local catTypes = cat.AssetTypes
        local entry = State.avatarChanger[catName]
        subSetV(entry.enabled == true)
        _G._VexulACVisualSetters[catName] = subSetV
        pillBtn.Activated:Connect(function()
            local ent = State.avatarChanger[catName]
            ent.enabled = not ent.enabled
            subSetV(ent.enabled)
            if ent.enabled and ent.savedId then
                local _id, _at, _nm = ent.savedId, catTypes[1], ent.savedName
                task.spawn(function() _acEquipItem(_id, _at, _nm) end)
            elseif not ent.enabled and ent.savedId then
                _acRemoveItem(catTypes[1], ent.savedName)
            end
            autoSaveConfig()
        end)
        pickBtn.Activated:Connect(function() _acOpenPicker(catName, catTypes) end)
    end
    _G._VexulACApplyAll = function()
        local gen = _acGen + 1; _acGen = gen
        task.spawn(function() _acApplyAll(gen) end)
    end
    _G._VexulACSyncVisuals = function()
        for catName, setV in pairs(_G._VexulACVisualSetters or {}) do
            local ent = State.avatarChanger[catName]
            if ent then pcall(setV, ent.enabled == true) end
        end
    end
    local animExpanded = false
    animArrow.Activated:Connect(function()
        animExpanded = not animExpanded
        if animExpanded then
            wrapBox.Visible = true
            wrapBox.Size = UDim2.new(1, 0, 0, 0)
            TweenService:Create(wrapBox, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {Size = UDim2.new(1, 0, 0, TEND_H + 4)}):Play()
            animArrow.Text = "\u{25BC}"
        else
            local closeTween = TweenService:Create(wrapBox, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
                {Size = UDim2.new(1, 0, 0, 0)})
            closeTween.Completed:Connect(function()
                if not animExpanded then wrapBox.Visible = false end
            end)
            closeTween:Play()
            animArrow.Text = "\u{25B2}"
        end
    end)
end

local settingsScroll = addNavButton("Settings", "Settings", 6)
setActiveScroll(settingsScroll)
setPlayIntro = makeToggleRow("Play Intro", State.introEnabled, function(on) State.introEnabled = on; autoSaveConfig() end)
do
    local wrap, card, hf = makeCardRow()
    cardLabel(card, "Intro Music")
    local lbl = Instance.new("TextButton", card)
    lbl.Size = UDim2.new(0,80,0,26); lbl.Position = UDim2.new(1,-88,0.5,-13)
    lbl.BackgroundColor3 = Color3.fromRGB(255,255,255); lbl.BorderSizePixel = 0
    lbl.Text = (INTRO_MUSIC_OPTIONS[State.musicIndex] and INTRO_MUSIC_OPTIONS[State.musicIndex].name) or "Song 1"
    lbl.TextColor3 = Color3.fromRGB(0,0,0); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Center; lbl.ZIndex = 15; lbl.AutoButtonColor = false
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0,7)
    lbl.MouseButton1Click:Connect(function()
        State.musicIndex = (State.musicIndex % #INTRO_MUSIC_OPTIONS) + 1
        lbl.Text = (INTRO_MUSIC_OPTIONS[State.musicIndex] and INTRO_MUSIC_OPTIONS[State.musicIndex].name) or "Song 1"
        autoSaveConfig()
    end)
    introMusicLbl = lbl
end

uiScaleBox = makeInputRow("UI Scale (Menu)", State.cubeScale, function(v)
    local n = tonumber(v)
    if n and n >= 25 and n <= 300 then
        State.cubeScale = n
        mainUIScale.Scale = n / 100
        autoSaveConfig()
    end
end)

buttonSizeBox = makeInputRow("Button Size", State.buttonSize, function(v)
    local n = tonumber(v)
    if n and n >= 30 and n <= 120 then
        _G._VexulApplyButtonSize(n)
        autoSaveConfig()
    end
end)

centerButtonSizeBox = makeInputRow("Center Button Size", State.centerButtonSize, function(v)
    local n = tonumber(v)
    if n and n >= 20 and n <= 100 then
        _G._VexulApplyCenterButtonSize(n)
        autoSaveConfig()
    end
end)

makeToggleRow("Lock Menu", State.uiLocked, function(on) State.uiLocked = on; autoSaveConfig() end, "uiLocked")
makeToggleRow("Lock Buttons", State.buttonsLocked, function(on) State.buttonsLocked = on; autoSaveConfig() end, "buttonsLocked")

do
    local wrap, card, hf = makeCardRow(42)
    local lbl = cardLabel(card, "Music Player")
    lbl.Size = UDim2.new(1, -80, 1, 0)

    local pickHolder = Instance.new("Frame", card)
    pickHolder.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
    pickHolder.BackgroundTransparency = 0.28
    pickHolder.BorderSizePixel = 0
    pickHolder.Size = UDim2.new(0, 66, 0, 30)
    pickHolder.Position = UDim2.new(1, -73, 0.5, -15)
    pickHolder.ClipsDescendants = true
    pickHolder.ZIndex = 15
    Instance.new("UICorner", pickHolder).CornerRadius = UDim.new(0, 15)
    local phSt = Instance.new("UIStroke", pickHolder)
    phSt.Color = Color3.fromRGB(147, 197, 253); phSt.Thickness = 1.5; phSt.Transparency = 0.15

    local pickBtn = Instance.new("TextButton", pickHolder)
    pickBtn.BackgroundTransparency = 1
    pickBtn.Text = "PICK"
    pickBtn.TextColor3 = C_WHITE
    pickBtn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    pickBtn.TextStrokeTransparency = 0.3
    pickBtn.TextSize = 12
    pickBtn.Font = Enum.Font.GothamBlack
    pickBtn.TextXAlignment = Enum.TextXAlignment.Center
    pickBtn.Size = UDim2.new(1, 0, 1, 0)
    pickBtn.BorderSizePixel = 0
    pickBtn.ZIndex = 16
    pickBtn.AutoButtonColor = false

    pickBtn.MouseEnter:Connect(function()
        TweenService:Create(pickHolder, TweenInfo.new(0.12), {Size = UDim2.new(0, 72, 0, 32), Position = UDim2.new(1, -76, 0.5, -16)}):Play()
    end)
    pickBtn.MouseLeave:Connect(function()
        TweenService:Create(pickHolder, TweenInfo.new(0.12), {Size = UDim2.new(0, 66, 0, 30), Position = UDim2.new(1, -73, 0.5, -15)}):Play()
    end)

    pickBtn.MouseButton1Click:Connect(function()
        local ok, err = pcall(function()
            if M.MusicPlayer and M.MusicPlayer.openUI then
                M.MusicPlayer.openUI()
            end
        end)
        if not ok then
            warn("[Vexul] Music Player error: " .. tostring(err))
        end
    end)
end

makeActionButtonRow("Save Config", function()
    if autoTpDownYBox then
        local n = tonumber(autoTpDownYBox.Text)
        if n then State.autoTpDownY = n end
    end
    autoSaveConfig()
end)
makeActionButtonRow("Reset Cube Buttons", function()
    State.cubeScale = 100
    State.buttonSize = 58
    State.centerButtonSize = 44
    if uiScaleBox then uiScaleBox.Text = "100" end
    if buttonSizeBox then buttonSizeBox.Text = "58" end
    if centerButtonSizeBox then centerButtonSizeBox.Text = "44" end
    mainUIScale.Scale = 1.0
    _G._VexulApplyButtonSize(58)
    _G._VexulApplyCenterButtonSize(44)
    for _,key in ipairs({
        "VexulBtn_dropbr.txt","VexulBtn_autoleft.txt","VexulBtn_autobat.txt",
        "VexulBtn_autoright.txt","VexulBtn_tpdown.txt","VexulBtn_carryspd.txt",
        "VexulBtn_laggercarry.txt","VexulBtn_laggermode.txt"
    }) do pcall(function() writefile(key, "{}") end) end
    autoSaveConfig()
end)

do
    local fRow=Instance.new("Frame",currentScroll); fRow.Size=UDim2.new(1,0,0,20)
    fRow.BackgroundTransparency=1; fRow.BorderSizePixel=0; fRow.LayoutOrder=LO()
    local fLbl=Instance.new("TextLabel",fRow); fLbl.Size=UDim2.new(1,0,1,0)
    fLbl.BackgroundTransparency=1; fLbl.Text="angel hub  ·  v1.0"
    fLbl.TextColor3=Color3.fromRGB(40,40,40); fLbl.Font=Enum.Font.Gotham; fLbl.TextSize=10; fLbl.TextXAlignment=Enum.TextXAlignment.Center
end

showSection("Speed")

local function findMedusa()
    local char=LP.Character; if not char then return nil end
    for _,t in ipairs(char:GetChildren()) do if t:IsA("Tool") then local tn=t.Name:lower(); if tn:find("medusa") or tn:find("head") or tn:find("stone") then return t end end end
    local bp2=LP:FindFirstChild("Backpack"); if bp2 then for _,t in ipairs(bp2:GetChildren()) do if t:IsA("Tool") then local tn=t.Name:lower(); if tn:find("medusa") or tn:find("head") or tn:find("stone") then return t end end end end
    return nil
end
local function useMedusaCounter()
    if State.medusaDebounce then return end; if tick()-State.medusaLastUsed<25 then return end
    local char=LP.Character; if not char then return end
    State.medusaDebounce=true; local med=findMedusa(); if not med then State.medusaDebounce=false; return end
    if med.Parent~=char then local hum2=char:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end); State.medusaLastUsed=tick(); State.medusaDebounce=false
end
local function onAnchorChanged(part) return part:GetPropertyChangedSignal("Anchored"):Connect(function() if part.Anchored and part.Transparency==1 then useMedusaCounter() end end) end
setupMedusaCounter=function(char) stopMedusaCounter(); if not char then return end; for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end; table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end)) end
stopMedusaCounter=function() for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end; Conns.anchor={} end

local function killCharAnims(char)
    if not char then return end
    local animScript = char:FindFirstChild("Animate")
    if animScript then animScript.Disabled = true end
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if hum2 then
        local anim = hum2:FindFirstChildOfClass("Animator")
        if anim then
            for _, track in ipairs(anim:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end
        end
    end
end
local function startUnwalk()
    if Conns.unwalk then return end
    killCharAnims(LP.Character)
    Conns.unwalk = RunService.Heartbeat:Connect(function()
        local char = LP.Character; if not char then return end
        local animScript = char:FindFirstChild("Animate")
        if animScript and not animScript.Disabled then animScript.Disabled = true end
        local hum2 = char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local anim = hum2:FindFirstChildOfClass("Animator"); if not anim then return end
        for _, track in ipairs(anim:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end
    end)
end
local function stopUnwalk()
    if Conns.unwalk then Conns.unwalk:Disconnect(); Conns.unwalk = nil end
    local char = LP.Character
    if char then
        local animScript = char:FindFirstChild("Animate")
        if animScript then animScript.Disabled = false end
    end
end

startAutoLeft=function()
    if Conns.autoLeft then Conns.autoLeft:Disconnect() end; State.autoLeftPhase=1
    Conns.autoLeft=RunService.Heartbeat:Connect(function()
        if not State.autoLeftEnabled then return end
        local char=LP.Character; if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart"); local hum2=char:FindFirstChildOfClass("Humanoid")
        if not root or not hum2 then return end; local spd=getAutoMoveSpeed()
        if State.autoLeftPhase==1 then
            local tgt=Vector3.new(POS.L1.X,root.Position.Y,POS.L1.Z)
            if (tgt-root.Position).Magnitude<1 then State.autoLeftPhase=2; return end
            local d=(POS.L1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit
            hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoLeftPhase==2 then
            local tgt=Vector3.new(POS.L2.X,root.Position.Y,POS.L2.Z)
            if (tgt-root.Position).Magnitude<1 then
                hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.new(0,root.AssemblyLinearVelocity.Y,0)
                State.autoLeftEnabled=false; if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1
                if setAutoLeft then setAutoLeft(false) end; if MobileButtons.Buttons.autoLeft then MobileButtons.Buttons.autoLeft(false) end; return
            end
            local d=(POS.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit
            hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
stopAutoLeft=function()
    if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1
    local char=LP.Character; if char then local hum2=char:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end; local root=char:FindFirstChild("HumanoidRootPart"); if root then root.AssemblyLinearVelocity=Vector3.new(0,root.AssemblyLinearVelocity.Y,0) end end
    if MobileButtons.Buttons.autoLeft then MobileButtons.Buttons.autoLeft(false) end
end
startAutoRight=function()
    if Conns.autoRight then Conns.autoRight:Disconnect() end; State.autoRightPhase=1
    Conns.autoRight=RunService.Heartbeat:Connect(function()
        if not State.autoRightEnabled then return end
        local char=LP.Character; if not char then return end
        local root=char:FindFirstChild("HumanoidRootPart"); local hum2=char:FindFirstChildOfClass("Humanoid")
        if not root or not hum2 then return end; local spd=getAutoMoveSpeed()
        if State.autoRightPhase==1 then
            local tgt=Vector3.new(POS.R1.X,root.Position.Y,POS.R1.Z)
            if (tgt-root.Position).Magnitude<1 then State.autoRightPhase=2; return end
            local d=(POS.R1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit
            hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoRightPhase==2 then
            local tgt=Vector3.new(POS.R2.X,root.Position.Y,POS.R2.Z)
            if (tgt-root.Position).Magnitude<1 then
                hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.new(0,root.AssemblyLinearVelocity.Y,0)
                State.autoRightEnabled=false; if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1
                if setAutoRight then setAutoRight(false) end; if MobileButtons.Buttons.autoRight then MobileButtons.Buttons.autoRight(false) end; return
            end
            local d=(POS.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit
            hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
stopAutoRight=function()
    if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1
    local char=LP.Character; if char then local hum2=char:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end; local root=char:FindFirstChild("HumanoidRootPart"); if root then root.AssemblyLinearVelocity=Vector3.new(0,root.AssemblyLinearVelocity.Y,0) end end
    if MobileButtons.Buttons.autoRight then MobileButtons.Buttons.autoRight(false) end
end
startAntiRagdoll=function()
    if Conns.antiRag then return end
    Conns.antiRag=RunService.Heartbeat:Connect(function()
        local char=LP.Character; if not char then return end
        local hum2=char:FindFirstChildOfClass("Humanoid"); local root=char:FindFirstChild("HumanoidRootPart")
        if hum2 then local st=hum2:GetState(); if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then hum2:ChangeState(Enum.HumanoidStateType.Running); workspace.CurrentCamera.CameraSubject=hum2; pcall(function() local pm=LP.PlayerScripts:FindFirstChild("PlayerModule"); if pm then require(pm:FindFirstChild("ControlModule")):Enable() end end); if root then root.Velocity=Vector3.new(0,0,0); root.RotVelocity=Vector3.new(0,0,0) end end end
        for _,obj in ipairs(char:GetDescendants()) do if obj:IsA("Motor6D") and not obj.Enabled then obj.Enabled=true end end
    end)
end
stopAntiRagdoll=function() if Conns.antiRag then Conns.antiRag:Disconnect(); Conns.antiRag=nil end end
applyFPSBoost=function()
    pcall(function() setfpscap(999999999) end)
    local function processObj(v) pcall(function() if v:IsA("Model") then v.LevelOfDetail=Enum.ModelLevelOfDetail.Disabled; v.ModelStreamingMode=Enum.ModelStreamingMode.Nonatomic elseif v:IsA("MeshPart") then v.CastShadow=false; v.DoubleSided=false; v.RenderFidelity=Enum.RenderFidelity.Performance elseif v:IsA("BasePart") then v.CastShadow=false; v.Material=Enum.Material.Plastic; v.Reflectance=0 elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1 elseif v:IsA("SpecialMesh") then v.TextureId="" elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=false elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then v:Destroy() elseif v:IsA("Attachment") then v.Visible=false end end) end
    for _,v in pairs(workspace:GetDescendants()) do processObj(v) end
    pcall(function()
        local lighting=game:GetService("Lighting")
        for _,v in pairs(lighting:GetDescendants()) do pcall(function() if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds") or v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") then v:Destroy() end end) end
        pcall(function() sethiddenproperty(game:GetService("Lighting"),"Technology",Enum.Technology.Legacy) end)
        local l2=game:GetService("Lighting"); l2.GlobalShadows=false; l2.FogEnd=9e9; l2.Brightness=0
        local terrain=workspace:FindFirstChildOfClass("Terrain"); if terrain then pcall(function() sethiddenproperty(terrain,"Decoration",false) end); terrain.WaterReflectance=0; terrain.WaterTransparency=0.7; terrain.WaterWaveSize=0; terrain.WaterWaveSpeed=0 end
    end)
    workspace.DescendantAdded:Connect(function(v) if State.fpsBoostEnabled then task.spawn(processObj,v) end end)
end

local function getBat()
    local char=LP.Character; if not char then return nil end
    local tool=char:FindFirstChild("Bat"); if tool then return tool end
    local bp2=LP:FindFirstChild("Backpack"); if bp2 then tool=bp2:FindFirstChild("Bat"); if tool then tool.Parent=char; return tool end end
    return nil
end
local function tryHitBat()
    if State.hittingCooldown then return end; State.hittingCooldown=true
    pcall(function() local bat=getBat(); if bat then bat:Activate(); local ev=bat:FindFirstChildWhichIsA("RemoteEvent"); if ev then ev:FireServer() end end end)
    task.delay(0.08,function() State.hittingCooldown=false end)
end

local function loadConfig()
    local hasFile=false; pcall(function() hasFile=isfile("VexulHubConfig.json") end)
    if not hasFile then return end
    local ok,cfg=pcall(function() return HttpService:JSONDecode(readfile("VexulHubConfig.json")) end)
    if not ok or not cfg then return end

    _G._VexulLoadingConfig = true

    if cfg.normalSpeed and type(cfg.normalSpeed)=="number" then State.normalSpeed=cfg.normalSpeed; normalBox.Text=tostring(cfg.normalSpeed) end
    if cfg.carrySpeed and type(cfg.carrySpeed)=="number" then State.carrySpeed=cfg.carrySpeed; carryBox.Text=tostring(cfg.carrySpeed) end
    if cfg.laggerSpeed and type(cfg.laggerSpeed)=="number" then State.laggerSpeed=cfg.laggerSpeed; laggerBox.Text=tostring(cfg.laggerSpeed) end
    if cfg.laggerCarrySpeed and type(cfg.laggerCarrySpeed)=="number" then State.laggerCarrySpeed=cfg.laggerCarrySpeed; carryLaggerBox.Text=tostring(cfg.laggerCarrySpeed) end
    if cfg.speedType=="normal" or cfg.speedType=="carry" then State.speedType=cfg.speedType end
    if type(cfg.laggerActive)=="boolean" then State.laggerActive=cfg.laggerActive end
    if type(cfg.laggerCarryActive)=="boolean" then State.laggerCarryActive=cfg.laggerCarryActive end
    if cfg.grabRadius and type(cfg.grabRadius)=="number" then AutoSteal.Radius=cfg.grabRadius; radiusBox.Text=tostring(cfg.grabRadius); if progressRadLbl then progressRadLbl.Text="Radius: "..cfg.grabRadius end end
    if cfg.autoStealEnabled then AutoSteal.Enabled=true; setInstaGrab(true); pcall(startAutoSteal) end
    if cfg.infJump then State.infJumpEnabled=true; setInfJump(true) end
    if cfg.infJumpMode=="manual" or cfg.infJumpMode=="hold" then State.infJumpMode=cfg.infJumpMode; if _G._updateInfJumpModeUI then _G._updateInfJumpModeUI() end end
    if cfg.autoTpDown and type(cfg.autoTpDown)=="boolean" then State.autoTpDownEnabled=cfg.autoTpDown; if setAutoTpDown then setAutoTpDown(cfg.autoTpDown) end end
    if type(cfg.unwalkEnabled)=="boolean" then State.unwalkEnabled=cfg.unwalkEnabled; if setUnwalk then setUnwalk(cfg.unwalkEnabled) end; if cfg.unwalkEnabled then startUnwalk() end end
    if cfg.autoTpDownY and type(cfg.autoTpDownY)=="number" then
        State.autoTpDownY=cfg.autoTpDownY
        if autoTpDownYBox then autoTpDownYBox.Text=tostring(cfg.autoTpDownY) end
    end
    if cfg.antiRagdoll then State.antiRagdollEnabled=true; setAntiRag(true); startAntiRagdoll() end
    if cfg.fpsBoost then State.fpsBoostEnabled=true; setFps(true); applyFPSBoost() end
    if cfg.medusaCounter then State.medusaCounterEnabled=true; setMedusaCounter(true); setupMedusaCounter(LP.Character) end
    if type(cfg.autoBatToggled)=="boolean" then State.autoBatToggled=cfg.autoBatToggled end
    if type(cfg.autoLeftEnabled)=="boolean" then State.autoLeftEnabled=cfg.autoLeftEnabled end
    if type(cfg.autoRightEnabled)=="boolean" then State.autoRightEnabled=cfg.autoRightEnabled end
    if cfg.mobileVisible~=nil then MobileButtons.Visible=cfg.mobileVisible; for _,c in ipairs(MobileButtons.Containers) do c.Visible=MobileButtons.Visible end end
    if cfg.mobileLocked~=nil then MobileButtons.Locked=cfg.mobileLocked end
    if cfg.cubeScale and type(cfg.cubeScale)=="number" then
        State.cubeScale=cfg.cubeScale
        if uiScaleBox then uiScaleBox.Text=tostring(cfg.cubeScale) end
        mainUIScale.Scale = cfg.cubeScale / 100
    end
    if cfg.buttonSize and type(cfg.buttonSize)=="number" then
        State.buttonSize = math.clamp(cfg.buttonSize, 30, 120)
        if buttonSizeBox then buttonSizeBox.Text = tostring(State.buttonSize) end
        task.defer(function() _G._VexulApplyButtonSize(State.buttonSize) end)
    end
    if cfg.centerButtonSize and type(cfg.centerButtonSize)=="number" then
        State.centerButtonSize = math.clamp(cfg.centerButtonSize, 20, 100)
        if centerButtonSizeBox then centerButtonSizeBox.Text = tostring(State.centerButtonSize) end
        task.defer(function() _G._VexulApplyCenterButtonSize(State.centerButtonSize) end)
    end
    if cfg.musicIndex and type(cfg.musicIndex)=="number" then
        State.musicIndex = math.clamp(cfg.musicIndex, 1, #INTRO_MUSIC_OPTIONS)
        if introMusicLbl then introMusicLbl.Text = (INTRO_MUSIC_OPTIONS[State.musicIndex] and INTRO_MUSIC_OPTIONS[State.musicIndex].name) or "Song 1" end
    end
    if type(cfg.introEnabled)=="boolean" then
        State.introEnabled = cfg.introEnabled
        if setPlayIntro then setPlayIntro(State.introEnabled) end
    end

    if type(cfg.customToolsEnabled)=="boolean" then State.customToolsEnabled = cfg.customToolsEnabled end
    if cfg.customBatSkin then State.customBatSkin = cfg.customBatSkin end
    if cfg.customMedusaSkin then State.customMedusaSkin = cfg.customMedusaSkin end

    if cfg.rainbowToolsEnabled == true then
        State.rainbowToolsEnabled = true
        if M.setRainbowTools then pcall(M.setRainbowTools, true) end
    end

    if cfg.animPackIndex and type(cfg.animPackIndex) == "number" then
        State.animPackIndex = math.clamp(cfg.animPackIndex, 1, 6)
    end

    if type(cfg.skyTheme) == "string" and cfg.skyTheme ~= "" then
        State.skyTheme = cfg.skyTheme
    end

    if type(cfg.avatarChanger) == "table" then
        for k, v in pairs(cfg.avatarChanger) do
            if type(k) == "string" and type(v) == "table" then
                if not State.avatarChanger[k] then
                    State.avatarChanger[k] = { enabled = false, savedId = nil, savedName = "" }
                end
                State.avatarChanger[k].enabled = v.enabled == true
                State.avatarChanger[k].savedId = tonumber(v.savedId)
                State.avatarChanger[k].savedName = tostring(v.savedName or "")
            end
        end
    end

    if type(cfg.headlessEnabled) == "boolean" then
        State.headlessEnabled = cfg.headlessEnabled
        task.defer(function()
            task.wait(0.4)
            if State.headlessEnabled then applyHeadlessToCharacter(LP.Character, true) end
            if not State._headlessConn then
                State._headlessConn = LP.CharacterAdded:Connect(function(char)
                    task.wait(0.5)
                    if State.headlessEnabled then applyHeadlessToCharacter(char, true) end
                end)
            end
        end)
    end
    if type(cfg.korbloxEnabled) == "boolean" then
        State.korbloxEnabled = cfg.korbloxEnabled
        task.defer(function()
            task.wait(0.4)
            if State.korbloxEnabled then applyKorbloxToCharacter(LP.Character, true) end
            if not State._korbloxConn then
                State._korbloxConn = LP.CharacterAdded:Connect(function(char)
                    task.wait(0.5)
                    if State.korbloxEnabled then applyKorbloxToCharacter(char, true) end
                end)
            end
        end)
    end
    if type(cfg.stretchRezEnabled) == "boolean" then
        State.stretchRezEnabled = cfg.stretchRezEnabled
        task.defer(function()
            task.wait(0.4)
            if State.stretchRezEnabled then startStretch() else stopStretch() end
        end)
    end
    if type(cfg.customSongEnabled) == "boolean" then
        State.customSongEnabled = cfg.customSongEnabled
        task.defer(function()
            task.wait(0.5)
            if State.customSongEnabled then
                scanCustomSong()
                startCustomSongWatchers()
            end
        end)
    end

    if type(cfg.rainbowJoystickEnabled) == "boolean" then
        State.rainbowJoystickEnabled = cfg.rainbowJoystickEnabled
        task.defer(function()
            task.wait(0.5)
            if State.rainbowJoystickEnabled then rjStart() end
        end)
    end

    if type(cfg.musicPlayerEnabled) == "boolean" then State.musicPlayerEnabled = cfg.musicPlayerEnabled end
    if type(cfg.musicPlayerVolume) == "number" then State.musicPlayerVolume = cfg.musicPlayerVolume end
    if type(cfg.musicPlayerSpeed) == "number" then State.musicPlayerSpeed = cfg.musicPlayerSpeed end
    if type(cfg.musicPlayerIndex) == "number" then State.musicPlayerIndex = math.clamp(cfg.musicPlayerIndex, 1, #MUSIC_PLAYER_OPTIONS) end
    if type(cfg.musicAutoPlayNext) == "boolean" then State.musicAutoPlayNext = cfg.musicAutoPlayNext end
    if type(cfg.musicShuffleEnabled) == "boolean" then State.musicShuffleEnabled = cfg.musicShuffleEnabled end
    if type(cfg.musicLoopEnabled) == "boolean" then State.musicLoopEnabled = cfg.musicLoopEnabled end

    if type(cfg.uiLocked) == "boolean" then State.uiLocked = cfg.uiLocked end
    if type(cfg.buttonsLocked) == "boolean" then State.buttonsLocked = cfg.buttonsLocked end
    if type(cfg.tpBatOn) == "boolean" then State.tpBatOn = cfg.tpBatOn end
    if type(cfg.batV2On) == "boolean" then State.batV2On = cfg.batV2On end

    task.defer(function()
        task.wait(0.3)
        if M.AnimPacks then
            local AP = M.AnimPacks
            local idx = math.clamp(State.animPackIndex, 1, 6)
            if idx == 1 then
                AP.enabled = false
                AP.restoreDefault()
            else
                AP.enabled = true
                local char = LP.Character
                if char then task.spawn(function() AP.startSystem(char) end) end
            end
            if _G._VexulApplyAnimPackVisual then pcall(_G._VexulApplyAnimPackVisual, idx) end
        end
    end)

    task.defer(function()
        task.wait(0.4)
        if M.SkyTheme and M.SkyTheme.apply then
            local savedSky = State.skyTheme
            pcall(M.SkyTheme.apply, savedSky or "Off", true)
            State.skyTheme = savedSky
        end
        if _G._VexulSyncSkyLabel then pcall(_G._VexulSyncSkyLabel) end
    end)

    task.defer(function()
        task.wait(0.5)
        if State.customToolsEnabled then
            pcall(M.refreshCustomToolSkins)
            pcall(M._customToolWatchdogStart)
        end
    end)

    task.defer(function()
        task.wait(0.6)
        if _G._VexulACSyncVisuals then pcall(_G._VexulACSyncVisuals) end
        if _G._VexulACApplyAll then pcall(_G._VexulACApplyAll) end
    end)

    task.defer(function()
        task.wait(0.7)
        for key, entry in pairs(ToggleRegistry) do
            if entry.syncOnly and entry.setVisual then
                local val = State[key]
                if type(val) == "boolean" then
                    pcall(entry.setVisual, val)
                end
            end
        end
    end)

    task.spawn(function()
        task.wait(0.6)
        if MobileButtons.Buttons.carrySpeed then MobileButtons.Buttons.carrySpeed(State.speedType=="carry") end
        if MobileButtons.Buttons.lagger then MobileButtons.Buttons.lagger(State.laggerActive) end
        if MobileButtons.Buttons.laggerCarry then MobileButtons.Buttons.laggerCarry(State.laggerCarryActive) end
        if State.laggerActive then startAutoSteal() end
        if State.laggerCarryActive then startAutoSteal() end
    end)
    refreshUIToggles()

    task.delay(1.5, function() _G._VexulLoadingConfig = false end)
end

local cleanupReset=function()
    workspace.CurrentCamera.CameraSubject=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    workspace.CurrentCamera.CameraType=Enum.CameraType.Custom
    pcall(function() local hGui=LP.PlayerGui:FindFirstChild("Health"); if hGui then hGui.Enabled=true end end)
end
LP.CharacterAdded:Connect(function() task.wait(0.5); cleanupReset() end)

local function setupChar(char)
    while introActive do task.wait(0.1) end
    task.wait(0.1)
    h=char:WaitForChild("Humanoid",5); hrp=char:WaitForChild("HumanoidRootPart",5)
    if not h or not hrp then return end
    if State.antiRagdollEnabled and not Conns.antiRag then task.wait(0.5); startAntiRagdoll() end
    if State.medusaCounterEnabled then setupMedusaCounter(char) end
    task.wait(0.5)
    if State.customToolsEnabled then
        pcall(M.refreshCustomToolSkins)
        pcall(M._customToolWatchdogStart)
    end
    if State.headlessEnabled then applyHeadlessToCharacter(char, true) end
    if State.korbloxEnabled then applyKorbloxToCharacter(char, true) end
    if State.customSongEnabled then scanCustomSong() end
end
LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide=false end end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if not State.infJumpEnabled then return end; if State.infJumpMode~="manual" then return end
    local char=LP.Character; if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart"); if root then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
end)

RunService.Heartbeat:Connect(function()
    if not State.infJumpEnabled and not State.autoTpDownEnabled then return end
    local char=LP.Character; if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart"); if not root then return end
    if State.infJumpEnabled then
        local hum2=char:FindFirstChildOfClass("Humanoid")
        if State.infJumpMode=="hold" then
            local jumpHeld=UIS:IsKeyDown(Enum.KeyCode.Space) or (hum2 and hum2.Jump==true)
            if jumpHeld and root.Velocity.Y<30 then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
        end
        if root.Velocity.Y<-120 then root.Velocity=Vector3.new(root.Velocity.X,-120,root.Velocity.Z) end
    end
    if State.autoTpDownEnabled and not State.autoBatToggled then
        local curY=root.Position.Y
        if curY>=State.autoTpDownY then local rot=root.CFrame.Rotation; root.CFrame=CFrame.new(root.Position.X,-8.80,root.Position.Z)*rot end
    end
end)

RunService.RenderStepped:Connect(function()
    if not (h and hrp) then return end; if State._tpInProgress then return end
    if State.autoLeftEnabled or State.autoRightEnabled then return end
    local md=h.MoveDirection; local spd=getCurrentSpeed()
    if md.Magnitude>0 then State.lastMoveDir=md; hrp.Velocity=Vector3.new(md.X*spd,hrp.Velocity.Y,md.Z*spd)
    elseif State.antiRagdollEnabled and State.lastMoveDir.Magnitude>0 then
        local anyHeld=false; for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld=true; break end end
        if anyHeld then hrp.Velocity=Vector3.new(State.lastMoveDir.X*spd,hrp.Velocity.Y,State.lastMoveDir.Z*spd) end
    end
end)

local function getClosestPlayer()
    if not hrp then return nil,math.huge end; local cp,cd=nil,math.huge
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LP and p.Character then local tr=p.Character:FindFirstChild("HumanoidRootPart"); if tr then local d=(hrp.Position-tr.Position).Magnitude; if d<cd then cd=d; cp=p end end end
    end
    return cp,cd
end

RunService.Heartbeat:Connect(function()
    if not (State.autoBatToggled and h and hrp) then return end
    local target,dist=getClosestPlayer()
    if target and target.Character then local tr=target.Character:FindFirstChild("HumanoidRootPart"); if tr then local fp=tr.Position+tr.CFrame.LookVector*1.5; local dir=(fp-hrp.Position).Unit; hrp.Velocity=Vector3.new(dir.X*56.5,dir.Y*56.5,dir.Z*56.5); if dist<=5 then tryHitBat() end end end
end)

task.spawn(function() while task.wait(0.5) do pcall(function() if progressRadLbl then progressRadLbl.Text="Radius: "..AutoSteal.Radius end end) end end)

refreshUIToggles()

-- ============================================================
-- CREAR BOTONES CENTRALES
-- ============================================================
function createCenterButtons()
    local centerButtonsGui = Instance.new("ScreenGui")
    centerButtonsGui.Name = "VexulCenterButtons"
    centerButtonsGui.ResetOnSpawn = false
    centerButtonsGui.IgnoreGuiInset = true
    centerButtonsGui.DisplayOrder = 999
    centerButtonsGui.Parent = LP:WaitForChild("PlayerGui")

    local C_ACTIVE_BG   = Color3.fromRGB(12, 45, 110)
    local C_INACTIVE_BG = Color3.fromRGB(20, 20, 26)
    local C_ACTIVE_TX   = Color3.fromRGB(255, 255, 255)
    local C_INACTIVE_TX = Color3.fromRGB(240, 240, 245)
    local C_ACCENT      = Color3.fromRGB(96, 165, 250)
    local initSize = State.centerButtonSize or 44

    local function createSmallButton(name, label, defaultPos, saveKey, onClick, isToggle)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(0, initSize, 0, initSize)
        btn.Position = defaultPos
        btn.BackgroundColor3 = C_INACTIVE_BG
        btn.BorderSizePixel = 0
        btn.Text = label
        btn.TextColor3 = C_INACTIVE_TX
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = math.max(7, math.floor(initSize * 0.20))
        btn.TextWrapped = true
        btn.AutoButtonColor = false
        btn.ZIndex = 501
        btn.ClipsDescendants = true
        btn.Parent = centerButtonsGui
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = C_ACCENT; bs.Thickness = 1; bs.Transparency = 0.4

        local rgbBar = Instance.new("Frame", btn)
        rgbBar.Name = "VexulRGBBar"
        rgbBar.Size = UDim2.new(0.25, 0, 1, 0)
        rgbBar.Position = UDim2.new(-1, 0, 0, 0)
        rgbBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        rgbBar.BackgroundTransparency = 0.35
        rgbBar.BorderSizePixel = 0
        rgbBar.ZIndex = 521
        rgbBar.Visible = false

        local rgbGrad = Instance.new("UIGradient", rgbBar)
        rgbGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0,   1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1,   1),
        })
        rgbGrad.Rotation = 0

        _G._VexulRGBBars[btn] = { bar = rgbBar, offset = math.random() * 100 / 100 }

        pcall(function()
            if isfile and readfile and isfile(saveKey) then
                local data = HttpService:JSONDecode(readfile(saveKey))
                if data then
                    btn.Position = UDim2.new(data.XScale, data.XOffset, data.YScale, data.YOffset)
                end
            end
        end)

        local isOn = false
        local function setActive(state)
            isOn = state
            local bg = state and C_ACTIVE_BG or C_INACTIVE_BG
            local tx = state and C_ACTIVE_TX or C_INACTIVE_TX
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = bg}):Play()
            TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = tx}):Play()
            TweenService:Create(bs, TweenInfo.new(0.15), {Transparency = state and 0.1 or 0.4}):Play()
            rgbBar.Visible = state
        end

        btn.MouseEnter:Connect(function()
            if not isOn then
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if not isOn then
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = C_INACTIVE_BG}):Play()
            end
        end)

        local didDrag = false
        btn.MouseButton1Click:Connect(function()
            if didDrag then return end
            if isToggle then
                local newState = not isOn
                setActive(newState)
                if onClick then pcall(onClick, setActive, newState) end
            else
                setActive(true)
                if onClick then pcall(onClick) end
                task.delay(0.2, function() setActive(false) end)
            end
        end)

        local _dragging = false
        local _dragStart, _startPos, _dragInput
        btn.InputBegan:Connect(function(input)
            if State.buttonsLocked == true then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1
               or input.UserInputType == Enum.UserInputType.Touch then
                _dragging = true
                didDrag = false
                _dragStart = input.Position
                _startPos = btn.Position
            end
        end)
        btn.InputChanged:Connect(function(input)
            if not _dragging then return end
            if State.buttonsLocked == true then _dragging = false; return end
            if input.UserInputType == Enum.UserInputType.MouseMovement
               or input.UserInputType == Enum.UserInputType.Touch then
                _dragInput = input
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not _dragging then return end
            if State.buttonsLocked == true then _dragging = false; return end
            if input == _dragInput or input.UserInputType == Enum.UserInputType.MouseMovement
               or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - _dragStart
                if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then
                    didDrag = true
                end
                btn.Position = UDim2.new(
                    _startPos.X.Scale, _startPos.X.Offset + delta.X,
                    _startPos.Y.Scale, _startPos.Y.Offset + delta.Y
                )
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
               or input.UserInputType == Enum.UserInputType.Touch then
                if _dragging then
                    pcall(function()
                        local pos = btn.Position
                        writefile(saveKey, HttpService:JSONEncode({
                            XScale=pos.X.Scale, XOffset=pos.X.Offset,
                            YScale=pos.Y.Scale, YOffset=pos.Y.Offset,
                        }))
                    end)
                end
                _dragging = false
                task.delay(0.1, function() didDrag = false end)
            end
        end)

        table.insert(_G._VexulAllBtnContainers, {container = btn, label = label, kind = "center"})
        return btn, setActive
    end

    local tpBatBtn, setTpBatActive = createSmallButton("TpBatBtn", "TP\nBAT",
        UDim2.new(0.5, -74, 0.5, -22), "VexulCenterTpBatPos.txt",
        function(on)
            if on then
                local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    local bat = nil
                    local bp = LP:FindFirstChildOfClass("Backpack")
                    local char = LP.Character
                    if char then
                        for _, t in ipairs(char:GetChildren()) do
                            if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then
                                bat = t; break
                            end
                        end
                    end
                    if not bat and bp then
                        for _, t in ipairs(bp:GetChildren()) do
                            if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then
                                bat = t; break
                            end
                        end
                    end
                    if bat then
                        pcall(function() hum:EquipTool(bat) end)
                        task.delay(0.05, function()
                            pcall(function() bat:Activate() end)
                        end)
                    end
                end
                local myChar = LP.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    local closest, minDist = nil, math.huge
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character then
                            local tr = p.Character:FindFirstChild("HumanoidRootPart")
                            local ph = p.Character:FindFirstChildOfClass("Humanoid")
                            if tr and ph and ph.Health > 0 then
                                local d = (myRoot.Position - tr.Position).Magnitude
                                if d < minDist then minDist = d; closest = tr end
                            end
                        end
                    end
                    if closest then
                        myRoot.CFrame = CFrame.lookAt(myRoot.Position, Vector3.new(closest.Position.X, myRoot.Position.Y, closest.Position.Z))
                    end
                end
            end
        end, true)

    local batV2Btn, setBatV2Active = createSmallButton("BatV2Btn", "BAT\nV2",
        UDim2.new(0.5, -22, 0.5, -22), "VexulCenterBatV2Pos.txt",
        function(on)
            State.batV2On = on
            if on then
                if _G._VexulBatV2Conn then _G._VexulBatV2Conn:Disconnect() end
                _G._VexulBatV2Conn = RunService.Heartbeat:Connect(function()
                    if not State.batV2On then return end
                    local char = LP.Character
                    if not char then return end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if not root or not hum then return end
                    local closest, minDist = nil, math.huge
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character then
                            local tr = p.Character:FindFirstChild("HumanoidRootPart")
                            local ph = p.Character:FindFirstChildOfClass("Humanoid")
                            if tr and ph and ph.Health > 0 then
                                local d = (root.Position - tr.Position).Magnitude
                                if d < minDist then minDist = d; closest = tr end
                            end
                        end
                    end
                    if closest and minDist < 30 then
                        local dir = (closest.Position - root.Position).Unit
                        root.Velocity = Vector3.new(dir.X * 55, root.Velocity.Y, dir.Z * 55)
                        local bat = nil
                        for _, t in ipairs(char:GetChildren()) do
                            if t:IsA("Tool") then bat = t; break end
                        end
                        if not bat then
                            local bp = LP:FindFirstChildOfClass("Backpack")
                            if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then bat = t; hum:EquipTool(t); break end end end
                        end
                        if bat and minDist <= 5 then
                            pcall(function() bat:Activate() end)
                        end
                    end
                end)
            else
                if _G._VexulBatV2Conn then _G._VexulBatV2Conn:Disconnect(); _G._VexulBatV2Conn = nil end
                local char = LP.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then root.AssemblyLinearVelocity = Vector3.Zero end
            end
            autoSaveConfig()
        end, true)

    local resetBtn, setResetActive = createSmallButton("ResetBtn", "RESET",
        UDim2.new(0.5, 30, 0.5, -22), "VexulCenterResetPos.txt",
        function()
            if _G.AmbitiousInstantReset then
                pcall(_G.AmbitiousInstantReset)
            else
                local char = LP.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum.Health = 0 end
                end
            end
        end, false)

    task.defer(function()
        setTpBatActive(State.tpBatOn == true)
        setBatV2Active(State.batV2On == true)
    end)

    _G._VexulSyncCenterButtons = function()
        setTpBatActive(State.tpBatOn == true)
        setBatV2Active(State.batV2On == true)
    end
end

-- ============================================================
-- INICIO
-- ============================================================
task.spawn(function()
    loadConfig()
    if State.introEnabled then
        introActive = true
        playIntroSequence()
        introActive = false
        gui.Enabled = true
        stealProgressGui.Enabled = true
        createMobilePanel()
        createCenterButtons()
        main.Visible = true
        closeBtn.Visible = true
    else
        gui.Enabled = true
        stealProgressGui.Enabled = true
        task.wait(0.3)
        createMobilePanel()
        createCenterButtons()
        main.Visible = true
        closeBtn.Visible = true
    end
    task.wait(0.1)
    if _G._VexulApplyButtonSize then
        pcall(_G._VexulApplyButtonSize, State.buttonSize or 58)
    end
    if _G._VexulApplyCenterButtonSize then
        pcall(_G._VexulApplyCenterButtonSize, State.centerButtonSize or 44)
    end
end)