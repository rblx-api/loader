-- STRIKE (Reconstruido y Simplificado)
-- strike duelo https://discord.gg/78Kbb4F9Xd
local _strikeNow = os.clock()
local _strikeExisting = false
pcall(function()
    local cg = game:GetService("CoreGui")
    _strikeExisting = cg:FindFirstChild("STRIKE") ~= nil
    if not _strikeExisting then
        local pl = game:GetService("Players").LocalPlayer
        local pg = pl and pl:FindFirstChildOfClass("PlayerGui")
        _strikeExisting = pg and pg:FindFirstChild("STRIKE") ~= nil or false
    end
end)
if _strikeExisting then
    _G.StrikeRunning = true
    return
end
if _G.__STRIKE_RUNTIME and _G.__STRIKE_RUNTIME.running then
    if (_strikeNow - (_G.__STRIKE_RUNTIME.started or 0)) < 30 then
        return
    end
    _G.__STRIKE_RUNTIME = nil
end

_G.__STRIKE_RUNTIME = { running = true, started = _strikeNow, phase = "boot" }
_G.StrikeRunning = true

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local TweenService = TS
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local AssetService = game:GetService("AssetService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer

local _tick = tick
local _clamp = math.clamp
local _floor = math.floor
local _huge = math.huge
local _sqrt = math.sqrt
local _V3new = Vector3.new
local _V3zero = Vector3.zero
local _CFnew = CFrame.new
local _CFlookAt = CFrame.lookAt
local _RayParams_new = RaycastParams.new

local _GetPlayersCached do
    local cache, cacheTime = nil, 0
    _GetPlayersCached = function()
        local now = _tick()
        if cache and now - cacheTime < 0.03 then
            return cache
        end
        cache = Players:GetPlayers()
        cacheTime = now
        return cache
    end
end

local function safeDisconnect(conn)
    if conn then
        pcall(function() conn:Disconnect() end)
    end
end

local function safeDestroy(obj)
    if obj then
        pcall(function() obj:Destroy() end)
    end
end

local function waitForCharReady(char, timeout)
    local deadline = _tick() + (timeout or 5)
    while (not char) or (not char.Parent) or (not char:FindFirstChild("HumanoidRootPart")) or (not char:FindFirstChildOfClass("Humanoid")) do
        if _tick() > deadline then return false end
        task.wait(0.05)
    end
    return true
end

-- ============================================================================
-- CUSTOM TOOL SKINS & SOUNDS (BAT / MEDUSA)
-- ============================================================================
if not _G.__CT_ENGINE_INJECTED then
    _G.__CT_ENGINE_INJECTED = true

    local function ctMatchItem(inst)
        if not (inst:IsA("Tool") or inst:IsA("Model") or inst:IsA("Accessory") or inst:IsA("BasePart")) then
            return nil
        end
        local n = inst.Name:lower()
        if n:find("bat", 1, true) or n:find("slap", 1, true) then
            return "Bat"
        elseif n:find("medusa", 1, true) then
            return "Medusa"
        end
        return nil
    end

    local function isReplicaStuff(d)
        return d.Name == "LocalReplica" or d:FindFirstAncestor("LocalReplica") ~= nil
    end

    local function createToolWatcher(onTool, onCleanup)
        local watchers = setmetatable({}, { __mode = "k" })
        local pendingHandle = setmetatable({}, { __mode = "k" })
        local enabled = false

        local function unwatch(container)
            local conn = watchers[container]
            if conn then
                safeDisconnect(conn)
                watchers[container] = nil
            end
        end

        local function tryRegister(inst)
            if not enabled or not inst:IsA("Tool") then return end
            if ctMatchItem(inst) then onTool(inst) end
        end

        local function watch(container)
            if not container or watchers[container] then return end
            watchers[container] = container.ChildAdded:Connect(tryRegister)
            for _, child in ipairs(container:GetChildren()) do
                tryRegister(child)
            end
        end

        local function watchAll()
            watch(LP:FindFirstChildOfClass("Backpack"))
            watch(LP.Character)
        end

        local function clearAll()
            for _, c in pairs(pendingHandle) do safeDisconnect(c) end
            table.clear(pendingHandle)
            for container in pairs(watchers) do unwatch(container) end
        end

        LP.ChildAdded:Connect(function(child)
            if enabled and child:IsA("Backpack") then watch(child) end
        end)

        LP.CharacterAdded:Connect(function(char)
            onCleanup()
            clearAll()
            if not enabled then return end
            watch(char)
            task.defer(function()
                if enabled then watchAll() end
            end)
        end)

        return {
            setEnabled = function(on) enabled = on == true end,
            isEnabled = function() return enabled end,
            watchAll = watchAll,
            clearAll = clearAll,
            waitHandle = function(tool, cb)
                if pendingHandle[tool] then return end
                local c
                c = tool.ChildAdded:Connect(function(child)
                    if child.Name == "Handle" then
                        safeDisconnect(c)
                        pendingHandle[tool] = nil
                        if enabled then cb(tool) end
                    end
                end)
                pendingHandle[tool] = c
            end,
            janitor = function()
                for tool, c in pairs(pendingHandle) do
                    if not tool.Parent then
                        safeDisconnect(c)
                        pendingHandle[tool] = nil
                    end
                end
                for container in pairs(watchers) do
                    if not container.Parent then unwatch(container) end
                end
            end,
        }
    end

    -- Transparencia controlada de las piezas originales del tool
    local CT_Trans = {}
    do
        local baseline = setmetatable({}, { __mode = "k" })
        local claimed = setmetatable({}, { __mode = "k" })
        local guards = setmetatable({}, { __mode = "k" })

        local function setIfDiff(part, v)
            local ok, cur = pcall(function() return part.Transparency end)
            if ok and cur ~= nil and math.abs(cur - v) > 0.001 then
                pcall(function() part.Transparency = v end)
            end
        end

        function CT_Trans.claim(part, value)
            if not part then return end
            if baseline[part] == nil then
                local ok, val = pcall(function() return part.Transparency end)
                if not ok then return end
                baseline[part] = val
            end
            claimed[part] = value
            if not guards[part] then
                local ok, conn = pcall(function()
                    return part:GetPropertyChangedSignal("Transparency"):Connect(function()
                        local v = claimed[part]
                        if v ~= nil then setIfDiff(part, v) end
                    end)
                end)
                if ok and conn then guards[part] = conn end
            end
            setIfDiff(part, value)
        end

        function CT_Trans.release(part)
            if not part then return end
            claimed[part] = nil
            if guards[part] then
                safeDisconnect(guards[part])
                guards[part] = nil
            end
            if part.Parent and baseline[part] ~= nil then
                setIfDiff(part, baseline[part])
            end
        end

        function CT_Trans.enforce()
            for part, v in pairs(claimed) do
                if part.Parent then setIfDiff(part, v) end
            end
        end
    end

    local ASSETS = {
        DiamondSword = { cat = "Bat", label = "Diamond Sword", mesh = "rbxassetid://8827558932", tex = "rbxassetid://8827558969", scale = _V3new(0.2, 0.2, 0.2), c0 = _CFnew(-0.05, -0.1, -0.12) * CFrame.Angles(math.rad(90), math.rad(180), 300) },
        Katana = { cat = "Bat", label = "Katana", mesh = "rbxassetid://13528902482", tex = "rbxassetid://13528902373", scale = _V3new(1.4, 1.4, 1.4), c0 = _CFnew(0, 0.6, 0) * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180)) },
        BatSkin = { cat = "Bat", label = "Bat Skin", procedural = true },
        BloodyKatana = { cat = "Bat", label = "Bloody Katana", assetId = 126653333198410, soundId = "rbxassetid://111808555599832", c0 = CFrame.new() },
        Skull = { cat = "Medusa", label = "Medusa 1", mesh = "rbxassetid://2050312704", tex = "rbxassetid://2050313393", scale = _V3new(1, 1, 1), c0 = _CFnew(0, 0.65, -0.4) * CFrame.Angles(math.rad(330), 0, 0) },
        GoldenDesertEagle = { cat = "Medusa", label = "Medusa 2", mesh = "rbxassetid://430251413", tex = "rbxassetid://435840335", scale = _V3new(0.01, 0.01, 0.01), c0 = _CFnew(0, 0, -0.8) * CFrame.Angles(math.rad(330), math.rad(180), 0) },
        EvilSkull = { cat = "Medusa", label = "Medusa 3", assetId = 7855324601, c0 = CFrame.Angles(0, math.rad(180), 0) },
        OminousSkull = { cat = "Medusa", label = "Medusa 4", assetId = 11983700343, c0 = CFrame.new() },
        SkullCone = { cat = "Medusa", label = "Medusa 5", assetId = 88582363429320, c0 = CFrame.Angles(0, math.rad(180), 0) },
    }
    _G.StrikeCustomToolAssets = ASSETS
    _G.StrikeCustomToolSkins = _G.StrikeCustomToolSkins or { Bat = "None", Medusa = "None" }
    _G.StrikeCustomToolsEnabled = true

    _G.StrikeBuildKatanaSkin = function(container, handle)
        local red = Color3.new(0.784314, 0, 0)
        local red2 = Color3.new(1, 0.392157, 0.392157)
        local gold = Color3.new(1, 0.72549, 0.196078)
        local specs = {
            { name = "Handle2", size = _V3new(0.22, 1.0, 0.22), off = _CFnew(0, -0.85, 0), color = Color3.new(0.04, 0.04, 0.045), mat = Enum.Material.Metal },
            { name = "SharpParts", size = _V3new(0.22, 3.35, 0.12), off = _CFnew(0, 1.05, 0), color = red2, mat = Enum.Material.Neon },
            { name = "WeaponPart", size = _V3new(0.3, 2.7, 0.08), off = _CFnew(0.08, 1.15, 0), color = red, mat = Enum.Material.Neon },
            { name = "NeonAccent", size = _V3new(0.75, 0.12, 0.42), off = _CFnew(0, -0.28, 0), color = gold, mat = Enum.Material.Neon },
        }
        local sharp
        for _, s in ipairs(specs) do
            local part = Instance.new("Part")
            part.Name, part.Size, part.Color, part.Material = s.name, s.size, s.color, s.mat
            part.TopSurface, part.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
            part.CanCollide, part.CanQuery, part.CanTouch, part.Massless = false, false, false, true
            if handle then
                part.Anchored = false
                part.CFrame = handle.CFrame * s.off
                part.Parent = container
                local w = Instance.new("Motor6D")
                w.Part0, w.Part1, w.C0, w.Parent = handle, part, s.off, part
            else
                part.Anchored = true
                part.CFrame = s.off
                part.Parent = container
            end
            if s.name == "SharpParts" then sharp = part end
        end
        if sharp then
            local topA = Instance.new("Attachment")
            topA.Name, topA.Position, topA.Parent = "FlowerSkin_ExtraRedVFX", _V3new(0, sharp.Size.Y * 0.5, 0), sharp
            local botA = Instance.new("Attachment")
            botA.Name, botA.Position, botA.Parent = "FlowerSkin_ExtraRedVFX_End", _V3new(0, -sharp.Size.Y * 0.5, 0), sharp
            local trail = Instance.new("Trail")
            trail.Name = "FlowerSkin_ExtraRedVFX"
            trail.Attachment0, trail.Attachment1 = topA, botA
            trail.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, red2), ColorSequenceKeypoint.new(1, Color3.new(0.54902, 0, 0)) })
            trail.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 1) })
            trail.Lifetime, trail.LightEmission, trail.Parent = 0.18, 0.55, sharp
            local pe = Instance.new("ParticleEmitter")
            pe.Name = "FlowerSkin_ExtraRedVFX"
            pe.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, red), ColorSequenceKeypoint.new(1, red2) })
            pe.LightEmission, pe.Rate = 0.55, 14
            pe.Lifetime, pe.Speed, pe.SpreadAngle = NumberRange.new(0.3, 0.45), NumberRange.new(0.2, 0.7), Vector2.new(12, 12)
            pe.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.08), NumberSequenceKeypoint.new(1, 0) })
            pe.Texture, pe.Parent = "rbxasset://textures/particles/sparkles_main.dds", sharp
        end
        return sharp
    end

    -- Tool Skins
    local function skinFor(cat)
        local key = _G.StrikeCustomToolSkins[cat]
        if key and key ~= "None" and key ~= "Off" and ASSETS[key] and ASSETS[key].cat == cat then
            return key
        end
        return nil
    end

    local assetTemplateCache = {}
    local function loadCustomAssetModel(assetId)
        assetId = tonumber(assetId)
        if not assetId then return nil end
        local cached = assetTemplateCache[assetId]
        if cached and cached.Parent then return cached:Clone() end
        local source = nil
        pcall(function()
            if game.GetObjects then
                local objs = game:GetObjects("rbxassetid://" .. tostring(assetId))
                if objs and objs[1] then source = objs[1] end
            end
        end)
        if not source then
            pcall(function() source = game:GetService("InsertService"):LoadAsset(assetId) end)
        end
        if not source then return nil end

        local model = Instance.new("Model")
        model.Name = "_STRIKECustomAssetTemplate"
        local primary = nil
        local function addPart(obj)
            if not obj or not obj:IsA("BasePart") then return end
            local ok, clone = pcall(function() return obj:Clone() end)
            if not ok or not clone then return end
            for _, d in ipairs(clone:GetDescendants()) do
                if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") or d:IsA("Weld") or d:IsA("WeldConstraint") or d:IsA("Motor6D") then
                    safeDestroy(d)
                end
            end
            clone.Anchored, clone.CanCollide, clone.CanTouch, clone.CanQuery, clone.Massless = true, false, false, false, true
            clone.Parent = model
            if not primary then primary = clone end
        end
        if source:IsA("BasePart") then
            addPart(source)
        else
            for _, d in ipairs(source:GetDescendants()) do
                if d:IsA("BasePart") then addPart(d) end
            end
        end
        safeDestroy(source)
        if not primary then
            safeDestroy(model)
            return nil
        end
        model.PrimaryPart = primary
        assetTemplateCache[assetId] = model
        return model:Clone()
    end

    local function buildReplica(handle, mode)
        local existing = handle:FindFirstChild("LocalReplica")
        if existing then existing:Destroy() end
        local data = mode and mode ~= "None" and mode ~= "Off" and ASSETS[mode] or nil
        if not data then return nil end

        if data.assetId then
            local src = loadCustomAssetModel(data.assetId)
            if not src then return nil end
            local m = Instance.new("Model")
            m.Name = "LocalReplica"
            local primary = src.PrimaryPart or src:FindFirstChildWhichIsA("BasePart", true)
            local clonedParts, mainPart = {}, nil
            for _, srcPart in ipairs(src:GetChildren()) do
                if srcPart:IsA("BasePart") then
                    local part = srcPart:Clone()
                    part.Anchored, part.CanCollide, part.CanTouch, part.CanQuery, part.Massless = false, false, false, false, true
                    part.Parent = m
                    clonedParts[#clonedParts + 1] = part
                    if primary and part.Name == primary.Name and not mainPart then mainPart = part end
                end
            end
            safeDestroy(src)
            mainPart = mainPart or clonedParts[1]
            if not mainPart then
                safeDestroy(m)
                return nil
            end
            mainPart.Name = "MainPart"
            local grip = data.c0 or CFrame.new()
            pcall(function() m:PivotTo(handle.CFrame * grip) end)
            for _, part in ipairs(clonedParts) do
                if part ~= mainPart then
                    local wc = Instance.new("WeldConstraint")
                    wc.Part0, wc.Part1, wc.Parent = mainPart, part, part
                end
            end
            local motor = Instance.new("Motor6D")
            motor.Name, motor.Part0, motor.Part1, motor.C0, motor.C1, motor.Parent = "_STRIKECustomAssetWeld", handle, mainPart, grip, CFrame.new(), mainPart
            m.Parent = handle
            return m
        end

        local m = Instance.new("Model")
        m.Name = "LocalReplica"
        if data.procedural then
            local anchor = Instance.new("Part")
            anchor.Name, anchor.Transparency, anchor.Size = "MainPart", 1, _V3new(0.1, 0.1, 0.1)
            anchor.CanCollide, anchor.CanQuery, anchor.CanTouch, anchor.Massless, anchor.Anchored = false, false, false, true, false
            anchor.CFrame, anchor.Parent = handle.CFrame, m
            local aw = Instance.new("Motor6D")
            aw.Part0, aw.Part1, aw.C0, aw.Parent = handle, anchor, CFrame.new(), anchor
            pcall(_G.StrikeBuildKatanaSkin, m, handle)
            m.Parent = handle
            return m
        end

        local p = Instance.new("Part")
        p.Name, p.Size, p.Transparency = "MainPart", _V3new(1, 1, 1), 0
        p.CanCollide, p.CanQuery, p.CanTouch, p.Massless, p.Anchored = false, false, false, true, false
        p.Parent = m
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType, mesh.MeshId, mesh.TextureId, mesh.Scale, mesh.Parent = Enum.MeshType.FileMesh, data.mesh, data.tex, data.scale, p
        local w = Instance.new("Motor6D")
        w.Part0, w.Part1, w.C0, w.Parent = handle, p, data.c0, p
        m.Parent = handle
        return m
    end

    local trackedTools = setmetatable({}, { __mode = "k" })
    local toolWatcher

    local function hideNode(entry, d)
        if not entry or not skinFor(entry.cat) or isReplicaStuff(d) then return end
        if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then
            entry.hidden[d] = true
            CT_Trans.claim(d, 1)
        end
    end

    local function teardownTool(tool)
        local entry = trackedTools[tool]
        if not entry then return end
        for _, conn in ipairs(entry.conns) do safeDisconnect(conn) end
        local handle = tool:FindFirstChild("Handle")
        if handle then safeDestroy(handle:FindFirstChild("LocalReplica")) end
        for obj in pairs(entry.hidden) do CT_Trans.release(obj) end
        trackedTools[tool] = nil
    end

    local function setupSkinTool(tool)
        if trackedTools[tool] then return end
        local handle = tool:FindFirstChild("Handle")
        if not handle then
            toolWatcher.waitHandle(tool, setupSkinTool)
            return
        end
        local cat = ctMatchItem(tool) or "Medusa"
        local entry = { hidden = {}, conns = {}, cat = cat }
        trackedTools[tool] = entry
        local mode = skinFor(cat)
        if mode then
            for _, d in ipairs(tool:GetDescendants()) do hideNode(entry, d) end
            buildReplica(handle, mode)
        end
        table.insert(entry.conns, tool.DescendantAdded:Connect(function(d)
            task.defer(function()
                if trackedTools[tool] then hideNode(entry, d) end
            end)
        end))
        table.insert(entry.conns, tool.AncestryChanged:Connect(function(_, parent)
            if not parent then teardownTool(tool) end
        end))
    end

    toolWatcher = createToolWatcher(setupSkinTool, function()
        for tool in pairs(trackedTools) do teardownTool(tool) end
    end)
    toolWatcher.setEnabled(true)

    local function integrityPass(deep)
        if not toolWatcher.isEnabled() then return end
        toolWatcher.watchAll()
        for tool, entry in pairs(trackedTools) do
            if not tool.Parent then
                teardownTool(tool)
            else
                local handle = tool:FindFirstChild("Handle")
                if handle then
                    local rep = handle:FindFirstChild("LocalReplica")
                    local mainPart = rep and rep:FindFirstChild("MainPart")
                    local motor = mainPart and mainPart:FindFirstChildOfClass("Motor6D")
                    local broken = (not rep) or (not mainPart) or (not motor) or motor.Part0 ~= handle
                    if broken then buildReplica(handle, skinFor(entry.cat)) end
                    if broken or deep then
                        for _, d in ipairs(tool:GetDescendants()) do hideNode(entry, d) end
                    end
                end
            end
        end
    end

    _G.StrikeCustomToolsRecheck = function() pcall(integrityPass, true) end
    _G.StrikeSetCustomToolSkin = function(cat, key)
        if cat ~= "Bat" and cat ~= "Medusa" then return end
        if key ~= "None" and (not ASSETS[key] or ASSETS[key].cat ~= cat) then return end
        _G.StrikeCustomToolSkins[cat] = key
        if cat == "Bat" and _G.StrikeCustomSounds and _G.StrikeCustomSounds.refresh then
            pcall(_G.StrikeCustomSounds.refresh)
        end
        for tool, entry in pairs(trackedTools) do
            if tool.Parent and entry.cat == cat then
                local handle = tool:FindFirstChild("Handle")
                if key == "None" then
                    if handle then safeDestroy(handle:FindFirstChild("LocalReplica")) end
                    for obj in pairs(entry.hidden) do CT_Trans.release(obj) end
                    entry.hidden = {}
                elseif handle then
                    for _, d in ipairs(tool:GetDescendants()) do hideNode(entry, d) end
                    pcall(buildReplica, handle, key)
                end
            end
        end
        if saveAllSettings then pcall(saveAllSettings) end
    end

    _G.StrikeCustomTools = {
        setEnabled = function(on)
            on = on and true or false
            toolWatcher.setEnabled(on)
            _G.StrikeCustomToolsEnabled = on
            if _G.StrikeCustomSounds and _G.StrikeCustomSounds.setEnabled then
                pcall(_G.StrikeCustomSounds.setEnabled, on)
            end
            if on then
                toolWatcher.watchAll()
                pcall(integrityPass, true)
            else
                for tool in pairs(trackedTools) do teardownTool(tool) end
                toolWatcher.clearAll()
            end
        end,
        isEnabled = function() return toolWatcher.isEnabled() end,
    }

    -- Tool Custom Sounds (usado por Bloody Katana)
    local SOUNDS = { Bat = { id = "rbxassetid://5713085119", skip = 0.2 } }
    local function activeBatSkinSound()
        local key = _G.StrikeCustomToolSkins and _G.StrikeCustomToolSkins.Bat
        local def = key and ASSETS[key]
        return def and def.soundId or nil
    end

    local hookedSounds = setmetatable({}, { __mode = "k" })
    local trackedSounds = setmetatable({}, { __mode = "k" })
    local soundWatcher

    local function teardownSound(tool)
        local entry = trackedSounds[tool]
        if not entry then return end
        for _, conn in ipairs(entry.conns) do safeDisconnect(conn) end
        safeDestroy(entry.sound)
        for snd, vol in pairs(entry.muted) do
            hookedSounds[snd] = nil
            if snd and snd.Parent then pcall(function() snd.Volume = vol end) end
        end
        trackedSounds[tool] = nil
    end

    local function hookSound(entry, snd)
        if not snd:IsA("Sound") or snd.Name == "CustomSound" or hookedSounds[snd] or entry.muted[snd] ~= nil then return end
        entry.muted[snd] = snd.Volume
        hookedSounds[snd] = true
        local function trigger()
            if not soundWatcher.isEnabled() then return end
            local skinSound = entry.key == "Bat" and activeBatSkinSound() or nil
            if entry.key == "Bat" and not skinSound then
                if snd.Volume == 0 then pcall(function() snd.Volume = entry.muted[snd] end) end
                if entry.sound and entry.sound.IsPlaying then pcall(function() entry.sound:Stop() end) end
                return
            end
            if snd.Playing or snd.TimePosition > 0 then
                pcall(function() snd.Volume = 0; snd:Stop() end)
                local cs = entry.sound
                if cs and cs.Parent then
                    local soundId = skinSound or entry.data.id
                    local skip = skinSound and 0 or (entry.data.skip or 0)
                    pcall(function()
                        if cs.SoundId ~= soundId then cs.SoundId = soundId end
                        cs:Stop(); cs.TimePosition = skip; cs.Volume = 1; cs:Play()
                    end)
                end
            end
        end
        local c1 = snd:GetPropertyChangedSignal("Playing"):Connect(trigger)
        local c2 = snd:GetPropertyChangedSignal("TimePosition"):Connect(trigger)
        local c3
        c3 = snd.AncestryChanged:Connect(function(_, parent)
            if parent then return end
            safeDisconnect(c1); safeDisconnect(c2); safeDisconnect(c3)
            hookedSounds[snd] = nil
            entry.muted[snd] = nil
        end)
        table.insert(entry.conns, c1); table.insert(entry.conns, c2); table.insert(entry.conns, c3)
        if snd.Playing then trigger() end
    end

    local function setupSoundTool(tool)
        if trackedSounds[tool] then return end
        local key = ctMatchItem(tool)
        local data = key and SOUNDS[key]
        if not data then return end
        local handle = tool:FindFirstChild("Handle")
        if not handle then
            soundWatcher.waitHandle(tool, setupSoundTool)
            return
        end
        safeDestroy(handle:FindFirstChild("CustomSound"))
        local cs = Instance.new("Sound")
        cs.Name, cs.SoundId, cs.Volume, cs.Looped = "CustomSound", data.id, 1, false
        cs.RollOffMode, cs.MaxDistance, cs.MinDistance, cs.Parent = Enum.RollOffMode.Inverse, 1000, 1000, handle
        local entry = { sound = cs, data = data, key = key, conns = {}, muted = {} }
        trackedSounds[tool] = entry
        for _, d in ipairs(tool:GetDescendants()) do hookSound(entry, d) end
        table.insert(entry.conns, tool.DescendantAdded:Connect(function(d)
            if trackedSounds[tool] then hookSound(entry, d) end
        end))
        table.insert(entry.conns, tool.AncestryChanged:Connect(function(_, parent)
            if not parent then teardownSound(tool) end
        end))
    end

    soundWatcher = createToolWatcher(setupSoundTool, function()
        for tool in pairs(trackedSounds) do teardownSound(tool) end
    end)

    _G.StrikeCustomSounds = {
        refresh = function()
            local hasSkinSound = activeBatSkinSound() ~= nil
            for _, entry in pairs(trackedSounds) do
                if entry.key == "Bat" then
                    if entry.sound then pcall(function() entry.sound:Stop() end) end
                    if not hasSkinSound then
                        for snd, vol in pairs(entry.muted) do
                            if snd and snd.Parent then pcall(function() snd.Volume = vol end) end
                        end
                    end
                end
            end
        end,
        setEnabled = function(on)
            on = on and true or false
            soundWatcher.setEnabled(on)
            _G.StrikeCustomSoundsEnabled = on
            if on then
                soundWatcher.watchAll()
            else
                for tool in pairs(trackedSounds) do teardownSound(tool) end
                soundWatcher.clearAll()
            end
        end,
        isEnabled = function() return soundWatcher.isEnabled() end,
    }

    task.spawn(function()
        local n = 0
        while _G.__STRIKE_RUNTIME and _G.__STRIKE_RUNTIME.running do
            task.wait(0.25)
            n = n + 1
            if toolWatcher.isEnabled() then
                pcall(CT_Trans.enforce)
                if (n % 2) == 0 then pcall(integrityPass, (n % 10) == 0) end
            end
            if (n % 40) == 0 then
                for tool in pairs(trackedTools) do if not tool.Parent then teardownTool(tool) end end
                for tool in pairs(trackedSounds) do if not tool.Parent then teardownSound(tool) end end
                pcall(toolWatcher.janitor)
                pcall(soundWatcher.janitor)
            end
        end
    end)

    LP.CharacterAdded:Connect(function()
        task.delay(0.6, function()
            if toolWatcher.isEnabled() then pcall(integrityPass, true) end
        end)
    end)
end

-- ============================================================================
-- VARIABLES GLOBALES DE ESTADO Y CONFIGURACIÓN
-- ============================================================================
NS = 60
CS = 29
LAGGER_SPEED = 40
LAGGER_CARRY_SPEED = 24
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 58
CONFIG_FILE = "Strike.json"
BAT_BYPASS_SPEED = 60
BAT_BYPASS_HIT_DIST = 13

_isDraggingButton = false
_activeFloatingDragOwner = nil
backgroundIndex = 1
backgroundImages = { "NONE", "108011173225450", "137118259044817", "85716848117450", "122706198510083", "131616908227665", "80401520132278" }
backgroundImageTransparency = 0
floatingButtonScale = 0.65
mobileButtonsHidden = false
_mobileBtnCorners, _mobileBtns, _floatingBtnCorners, _floatingUIScales = {}, {}, {}, {}
_mobilePanelContainer, mobileMainPanelGui = nil, nil
stealBarScale = 0.40

local COLOR_THEMES = {
    ["Gris"] = Color3.fromRGB(180, 180, 190),
    ["Morado"] = Color3.fromRGB(160, 100, 220),
    ["Azul"] = Color3.fromRGB(80, 150, 255),
    ["Rosado"] = Color3.fromRGB(255, 120, 180),
    ["Verde"] = Color3.fromRGB(80, 220, 120),
    ["Vainilla"] = Color3.fromRGB(212, 180, 135),
}
currentColorTheme = "Gris"
selectedColor = COLOR_THEMES["Gris"]
function getThemeColor() return selectedColor end

_G.__STRIKE_FEATURE_CONFIG = type(_G.__STRIKE_FEATURE_CONFIG) == "table" and _G.__STRIKE_FEATURE_CONFIG or {}
speedMode = false
antiRagdollMode = "off"
infiniteJumpEnabled = false
antiDieEnabled = false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
dropMode = 2
antiLagEnabled = false
stretchEnabled = false
stretchFOV = 120
uiLocked = false
uiScaleValue = 78
espEnabled = false
espBoxEnabled = false
espTrackerEnabled = false
ragdollCountdownEnabled = true
antiTpEspEnabled = false
antiFlingEnabled = false
StrikeShowE01Warning = false
StrikeE01StartedAt = nil
StrikeE01Gui = nil
savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil
tpBatFloatingPos = nil
batBypassFloatingPos = nil
instaResetFloatingPos = nil
instaResetFloatingButton = nil
skyTheme = "Off"
skySelectorLabel = nil
autoBatBypassEnabled = false
lastMoveDir = _V3zero

medusaDebounce = false
medusaLastUsed = 0
dropActive = false
lastDropTime = 0
origFOV = nil
fovEnabled = false
fovValue = 70
customFovConn = nil
setFovVisual = nil
fovSliderSet = nil
_anyKeyListening = false
_aimbotConn = nil
_prevAutoRotate = nil
tpBatFloatingButton = nil
batBypassFloatingButton = nil
enemySpeedConn = nil
movementLoop = nil
steppedConn = nil
alConn = nil
arConn = nil
stretchConn = nil
stretchFovConn = nil
antiLagDescConn = nil
dropConnections = {}
enemySpeedLabels = {}
Conns = { batCounter = nil, anchor = {} }
keyButtonRefs = {}
progressFill, progressPct, pbFrame, pbScale = nil, nil, nil, nil
speedLabel, modeValLbl = nil, nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, batBypassBox = nil, nil, nil, nil, nil, nil, nil
dropModeBtnRef, updateDropModeUI = nil, nil
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual = nil, nil, nil, nil, nil
setAntiLagVisual, setLockUIVisual, setInstaGrab = nil, nil, nil
setAntiDieVisual, setAntiFlingVisual, setAntiRagdollVisual, setInfiniteJumpVisual, setInfiniteJumpModeVisual = nil, nil, nil, nil, nil
setESPVIsual, setESPBoxVisual, setESPTrackerVisual, setRagdollCountdownVisual, setAntiTpEspVisual = nil, nil, nil, nil, nil
setCarryModeVisual, setLaggerModeVisual, setLaggerCarryVisual = nil, nil, nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2 = nil, nil, nil, nil, nil, nil, nil, nil
autoBatBypassSetVisual, updateBatBypassSphereTheme = nil, nil
batDesyncTpSetVisual, tpBatCamLockSetVisual = nil, nil
hideMobileBtnsSetVisual = nil
uiScaleStepperSet, floatScaleStepperSet, stealBarStepperSet = nil, nil, nil
miniBtn, main, gui, MobilePanel = nil, nil, nil, nil
showGui, hideGui, mainUIScale, _menuHomePos = nil, nil, nil, nil
animSelectorLabel, packAnimationSelectorLabel = nil, nil
animIndex, packAnimationIndex = 1, 1
currentAnimPack, currentPackAnimation = "OFF", "OFF"
applyAnimPackGlobal, applyPackAnimationGlobal = nil, nil
autoCarrySpeedEnabled, setAutoCarrySpeedVisual = false, nil
autoCarryEnemyBaseEnabled, autoCarryEnemyBaseRange = false, 30
setAutoCarryEnemyBaseVisual, autoCarryEnemyBaseRangeBox = nil, nil
carrySysSoftStealSpeedBox, carrySysSoftStealRadiusBox = nil, nil
StrikeShowE01WarningSetVisual = nil

local themeToggleRegistry = {}
local _lastThemeUpdate, _lastThemeColor = 0, nil

-- ============================================================================
-- DETECCIÓN COMPARTIDA DE ROBO / CARRY (Usada por Spin Bot y Auto Carry)
-- ============================================================================
local CARRY_VALUE_NAMES = { "Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab" }

local function isCarryingBrainrot(checkWalkSpeed)
    local char = LP.Character
    if not char then return false end
    local ok1, v1 = pcall(function() return LP:GetAttribute("Stealing") end)
    if ok1 and v1 == true then return true end
    local ok2, v2 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok2 and v2 == true then return true end
    for _, name in ipairs(CARRY_VALUE_NAMES) do
        local obj = char:FindFirstChild(name)
        if obj then
            if (obj:IsA("BoolValue") and obj.Value) or (obj:IsA("ObjectValue") and obj.Value) or (obj:IsA("StringValue") and obj.Value ~= "") then
                return true
            end
        end
    end
    if checkWalkSpeed then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local ws = hum and hum.WalkSpeed or 16
        if ws < 25 and ws > 0 then return true end
    else
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
                local n = child.Name:lower()
                if n:find("brainrot", 1, true) or n:find("animal", 1, true) or n:find("carry", 1, true) or n:find("grab", 1, true) or n:find("steal", 1, true) or n:find("hold", 1, true) then
                    return true
                end
            end
        end
    end
    return false
end

-- Interfaz ligera para mantener compatibilidad con Spin Bot, ProgressBar y Config
local CarrySystem = {
    normalSpeed = NS,
    carrySpeed = CS,
    laggerSpeed = LAGGER_SPEED,
    laggerCarrySpeed = LAGGER_CARRY_SPEED,
    softStealSpeed = 30,
    softStealRadius = 10,
    speedToggled = false,
    laggerMode = 0,
    _isCarrying = false,
    _lastCarryCheck = 0,
}
function CarrySystem:isCarrying()
    local now = _tick()
    if now - self._lastCarryCheck < 0.1 then return self._isCarrying end
    self._lastCarryCheck = now
    self._isCarrying = isCarryingBrainrot(true)
    return self._isCarrying
end
function CarrySystem:getStatus()
    if self.laggerMode == 1 then return "LAGGER", self.laggerSpeed end
    if self.laggerMode == 2 then return "LAGGER CARRY", self.laggerCarrySpeed end
    if self.speedToggled then return "CARRY", self.carrySpeed end
    return "NORMAL", self.normalSpeed
end
function CarrySystem:setSoftStealSpeed(v) self.softStealSpeed = _clamp(v, 1, 500) end
function CarrySystem:setSoftStealRadius(v) self.softStealRadius = _clamp(v, 1, 200) end

-- ============================================================================
-- TEMA DE COLORES GLOBAL
-- ============================================================================
function updateAllUIThemeColors(color)
    local now = _tick()
    if color == _lastThemeColor and now - _lastThemeUpdate < 0.1 then return end
    _lastThemeUpdate = now
    local prevCol = _lastThemeColor
    _lastThemeColor = color

    if speedLabel then speedLabel.TextColor3 = color end
    if progressFill then
        progressFill.BackgroundColor3 = color
        local grad = progressFill:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, color:Lerp(Color3.new(1, 1, 1), 0.5)),
                ColorSequenceKeypoint.new(0.5, color),
                ColorSequenceKeypoint.new(1, color:Lerp(Color3.new(0, 0, 0), 0.3)),
            })
        end
    end
    if pbFrame then
        local border = pbFrame:FindFirstChildOfClass("UIStroke")
        if border then border.Color = color end
    end
    if gui then
        for _, child in ipairs(gui:GetDescendants()) do
            if child:IsA("TextLabel") then
                if child.Name == "SectTitle" or child.Name == "StrikeSpeedIndicator" then
                    child.TextColor3 = color
                end
            elseif child:IsA("UIStroke") then
                if child.Color == Color3.fromRGB(180, 180, 190) or (prevCol and child.Color == prevCol) then
                    child.Color = color
                end
            elseif child:IsA("Frame") and child.Name == "Track" and child.BackgroundTransparency < 0.1 then
                child.BackgroundColor3 = color
            end
        end
    end
    if tpBatFloatingButton then paintFloatingBtn(tpBatFloatingButton:FindFirstChild("Frame"), batDesyncTpEnabled) end
    if batBypassFloatingButton then paintFloatingBtn(batBypassFloatingButton:FindFirstChild("Frame"), autoBatBypassEnabled) end
    if type(updateBatBypassSphereTheme) == "function" then pcall(updateBatBypassSphereTheme, color) end
    for _, line in pairs(espTrackerCache or {}) do
        if line then pcall(function() line.BackgroundColor3 = color end) end
    end
    for _, box in pairs(espBoxCache or {}) do
        if box then
            pcall(function()
                box.BackgroundColor3 = color
                local stroke = box:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color = color end
            end)
        end
    end
    local strikeTitle = main and main:FindFirstChild("StrikeTitle", true)
    if strikeTitle and strikeTitle:IsA("ImageLabel") then strikeTitle.ImageColor3 = color end
    local miniTitle = miniBtn and miniBtn:FindFirstChild("StrikeMiniImage", true)
    if miniTitle and miniTitle:IsA("ImageLabel") then miniTitle.ImageColor3 = color end
    if miniBtn then
        miniBtn.TextColor3 = color
        local grad = miniBtn:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, color),
                ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, color),
            })
        end
    end
    local pGui = LP:FindFirstChild("PlayerGui")
    local bb = pGui and pGui:FindFirstChild("RagCountdownBillboard")
    local lbl = bb and bb:FindFirstChildOfClass("TextLabel")
    if lbl then
        lbl.TextColor3 = color
        local grad = lbl:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, color),
                ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, color),
            })
        end
    end
    if _G._StrikeAntiTpEsp and _G._StrikeAntiTpEsp.SetColor then pcall(_G._StrikeAntiTpEsp.SetColor, color) end
    if MobilePanel then
        local btnContainer = MobilePanel:FindFirstChild("FloatingPanel") and MobilePanel.FloatingPanel:FindFirstChild("ButtonsContainer")
        if btnContainer then
            for _, btn in ipairs(btnContainer:GetChildren()) do
                if btn:IsA("TextButton") and btn:FindFirstChild("BtnGrad") then
                    paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true)
                end
            end
        end
    end
    for _, paintToggle in ipairs(themeToggleRegistry) do pcall(paintToggle) end
end

-- ============================================================================
-- ANTI E01 WARNING
-- ============================================================================
local function StrikeIsCarrying()
    local char = LP.Character
    if not char then return false end
    for _, child in ipairs(char:GetChildren()) do
        local name = child.Name:lower()
        if name:find("brain", 1, true) or name:find("animal", 1, true) or name:find("carry", 1, true) or name:find("steal", 1, true) then
            return true
        end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.WalkSpeed > 0 and hum.WalkSpeed <= 25 and hum.WalkSpeed ~= 16
end

local function StrikeCreateE01Gui()
    if StrikeE01Gui and StrikeE01Gui.Parent then return StrikeE01Gui end
    local playerGui = LP:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return nil end

    local sg = Instance.new("ScreenGui")
    sg.Name, sg.ResetOnSpawn, sg.IgnoreGuiInset, sg.DisplayOrder, sg.Parent = "StrikeE01Warning", false, true, 2000000000, playerGui

    local bar = Instance.new("Frame")
    bar.Name, bar.AnchorPoint, bar.Position, bar.Size = "Bar", Vector2.new(0.5, 0), UDim2.new(0.5, 0, 0, 24), UDim2.new(0, 320, 0, 58)
    bar.BackgroundColor3, bar.BackgroundTransparency, bar.BorderSizePixel, bar.ClipsDescendants, bar.Parent = Color3.new(0, 0, 0), 0.05, 0, true, sg
    Instance.new("UIScale", bar).Scale = 0.82
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 18)
    local stroke = Instance.new("UIStroke", bar)
    stroke.Color, stroke.Thickness, stroke.Transparency = Color3.fromRGB(45, 45, 45), 1, 0.2

    local fill = Instance.new("Frame", bar)
    fill.Name, fill.Size, fill.BackgroundColor3, fill.BackgroundTransparency, fill.BorderSizePixel, fill.ZIndex = "ProgressFill", UDim2.new(0, 0, 1, 0), Color3.fromRGB(255, 75, 85), 0.55, 0, 2
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 18)
    Instance.new("UIGradient", fill).Color = ColorSequence.new(Color3.fromRGB(255, 140, 60), Color3.fromRGB(255, 75, 85))

    local iconBox = Instance.new("Frame", bar)
    iconBox.Name, iconBox.AnchorPoint, iconBox.Position, iconBox.Size = "IconBox", Vector2.new(0, 0.5), UDim2.new(0, 10, 0.5, 0), UDim2.new(0, 40, 0, 40)
    iconBox.BackgroundColor3, iconBox.BorderSizePixel, iconBox.ZIndex = Color3.fromRGB(58, 58, 58), 0, 5
    Instance.new("UICorner", iconBox).CornerRadius = UDim.new(0, 11)

    local iconLabel = Instance.new("TextLabel", iconBox)
    iconLabel.Name, iconLabel.Size, iconLabel.BackgroundTransparency, iconLabel.Font, iconLabel.Text, iconLabel.TextSize = "Icon", UDim2.fromScale(1, 1), 1, Enum.Font.GothamBlack, "⚠️", 24
    iconLabel.TextColor3, iconLabel.ZIndex = Color3.fromRGB(255, 205, 40), 6

    local percent = Instance.new("TextLabel", bar)
    percent.Name, percent.AnchorPoint, percent.Position, percent.Size = "Percent", Vector2.new(1, 0.5), UDim2.new(1, -14, 0.5, 0), UDim2.new(0, 54, 1, 0)
    percent.BackgroundTransparency, percent.Font, percent.Text, percent.TextSize = 1, Enum.Font.GothamBold, "0%", 18
    percent.TextColor3, percent.TextXAlignment, percent.ZIndex = Color3.new(1, 1, 1), Enum.TextXAlignment.Right, 6

    local textFrame = Instance.new("Frame", bar)
    textFrame.Name, textFrame.AnchorPoint, textFrame.Position, textFrame.Size = "TextFrame", Vector2.new(0, 0.5), UDim2.new(0, 60, 0.5, 0), UDim2.new(1, -124, 0, 40)
    textFrame.BackgroundTransparency, textFrame.ZIndex = 1, 5

    local title = Instance.new("TextLabel", textFrame)
    title.Name, title.Size, title.BackgroundTransparency, title.Font, title.Text, title.TextSize = "Title", UDim2.new(1, 0, 0.5, 0), 1, Enum.Font.GothamBlack, "DONT STEAL", 15
    title.TextColor3, title.TextXAlignment, title.TextYAlignment, title.ZIndex = Color3.new(1, 1, 1), Enum.TextXAlignment.Left, Enum.TextYAlignment.Bottom, 6

    local sub = Instance.new("TextLabel", textFrame)
    sub.Name, sub.Position, sub.Size, sub.BackgroundTransparency, sub.Font, sub.Text, sub.TextSize = "Sub", UDim2.new(0, 0, 0.5, 2), UDim2.new(1, 0, 0.5, -2), 1, Enum.Font.Gotham, "WAIT BEFORE STEALING", 11
    sub.TextColor3, sub.TextXAlignment, sub.TextYAlignment, sub.ZIndex = Color3.fromRGB(175, 175, 175), Enum.TextXAlignment.Left, Enum.TextYAlignment.Top, 6

    StrikeE01Gui = sg
    return sg
end

RunService.Heartbeat:Connect(function()
    if not StrikeShowE01Warning or not StrikeIsCarrying() then
        if StrikeE01Gui then StrikeE01Gui.Enabled = false end
        StrikeE01StartedAt = nil
        return
    end
    StrikeE01StartedAt = StrikeE01StartedAt or _tick()
    local progress = _clamp((_tick() - StrikeE01StartedAt) / 2.6, 0, 1)
    local sg = StrikeCreateE01Gui()
    if not sg then return end
    sg.Enabled = true
    local finished = progress >= 1
    local bar = sg:FindFirstChild("Bar")
    if not bar then return end
    local textFrame = bar:FindFirstChild("TextFrame")
    local title = textFrame and textFrame:FindFirstChild("Title")
    local sub = textFrame and textFrame:FindFirstChild("Sub")
    local percent = bar:FindFirstChild("Percent")
    local iconLabel = bar:FindFirstChild("IconBox") and bar.IconBox:FindFirstChild("Icon")
    local fill = bar:FindFirstChild("ProgressFill")
    local green, white = Color3.fromRGB(85, 255, 125), Color3.new(1, 1, 1)

    if title then title.Text = finished and "STEAL" or "DONT STEAL"; title.TextColor3 = finished and green or white end
    if sub then sub.Text = finished and "YOU CAN STEAL NOW" or "WAIT BEFORE STEALING" end
    if percent then percent.Text = string.format("%d%%", _floor(progress * 100 + 0.5)); percent.TextColor3 = finished and green or white end
    if iconLabel then iconLabel.TextColor3 = finished and green or Color3.fromRGB(255, 205, 40) end
    if fill then fill.Size = UDim2.new(progress, 0, 1, 0); fill.BackgroundColor3 = finished and green or Color3.fromRGB(255, 75, 85) end
end)

-- ============================================================================
-- INFINITE JUMP
-- ============================================================================
local InfiniteJump = {
    enabled = false,
    mode = "hold",
    jumpPower = 55,
    minVelocity = 35,
    fallClamp = -120,
    jumpConn = nil,
    presimConn = nil,
}

function InfiniteJump.start()
    if InfiniteJump.enabled then return end
    InfiniteJump.enabled = true
    safeDisconnect(InfiniteJump.jumpConn)
    safeDisconnect(InfiniteJump.presimConn)
    InfiniteJump.jumpConn = UIS.JumpRequest:Connect(function()
        if not InfiniteJump.enabled then return end
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if root then
            pcall(function()
                local v = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = _V3new(v.X, InfiniteJump.jumpPower, v.Z)
            end)
        end
    end)
    InfiniteJump.presimConn = RunService.PreSimulation:Connect(function()
        if not InfiniteJump.enabled or InfiniteJump.mode ~= "hold" then return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        local held = UIS:IsKeyDown(Enum.KeyCode.Space) or UIS:IsKeyDown(Enum.KeyCode.ButtonA) or hum.Jump == true
        local v = root.AssemblyLinearVelocity
        if held then
            if v.Y < InfiniteJump.minVelocity then
                root.AssemblyLinearVelocity = _V3new(v.X, InfiniteJump.jumpPower, v.Z)
            end
        elseif v.Y < InfiniteJump.fallClamp then
            root.AssemblyLinearVelocity = _V3new(v.X, InfiniteJump.fallClamp, v.Z)
        end
    end)
end

function InfiniteJump.stop()
    InfiniteJump.enabled = false
    safeDisconnect(InfiniteJump.jumpConn); InfiniteJump.jumpConn = nil
    safeDisconnect(InfiniteJump.presimConn); InfiniteJump.presimConn = nil
end

function InfiniteJump.setMode(mode)
    InfiniteJump.mode = (mode == "manual") and "manual" or "hold"
end

-- ============================================================================
-- VELOCIDAD Y HOOK METATABLE
-- ============================================================================
function getActiveMoveSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED end
    if laggerToggled then return LAGGER_SPEED end
    if speedMode then return CS end
    return NS
end

local _velChecked, _hookedVelParts = {}, {}
local _hookVelSupported = nil

local function _setupVelChecked(char)
    _velChecked = {}
    local hrp = char and char:WaitForChild("HumanoidRootPart", 5)
    if hrp then _velChecked[hrp] = true end
    return hrp
end

local function _hookVelHRP(hrp)
    if not hrp or _hookedVelParts[hrp] or _hookVelSupported == false then return end
    if _hookVelSupported == nil then
        _hookVelSupported = (type(getrawmetatable) == "function") and (type(setreadonly) == "function") and (type(newcclosure) == "function") and (type(checkcaller) == "function")
    end
    if not _hookVelSupported then return end
    _hookedVelParts[hrp] = true
    local ok = pcall(function()
        local mt = getrawmetatable(hrp)
        if not mt then return end
        setreadonly(mt, false)
        local origIndex = rawget(mt, "__index")
        mt.__index = newcclosure(function(self, key)
            local real = type(origIndex) == "function" and origIndex(self, key) or (type(origIndex) == "table" and origIndex[key] or nil)
            if not checkcaller() and _velChecked[self] and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                if real and real.Magnitude > 20 then return real.Unit * 20 end
            end
            return real
        end)
        setreadonly(mt, true)
    end)
    if not ok then _hookVelSupported = false end
end
if LP.Character then _hookVelHRP(_setupVelChecked(LP.Character)) end

local function _isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
end

local function _applyVelocitySpeed(dir, speed, hrp)
    if not hrp or not hrp.Parent or autoBatBypassEnabled or batDesyncTpEnabled or autoBatEnabled then return end
    local vy = hrp.AssemblyLinearVelocity.Y
    if dir and dir.Magnitude > 0.05 then
        pcall(function() if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP) end end)
        local u = dir.Unit
        hrp.AssemblyLinearVelocity = _V3new(u.X * speed, vy, u.Z * speed)
    else
        hrp.AssemblyLinearVelocity = _V3new(0, vy, 0)
    end
end

-- ============================================================================
-- KEYBINDS
-- ============================================================================
local KB_NAMES = { "DropBrainrot", "AutoLeft", "AutoRight", "AutoBat", "TPFloor", "GuiHide", "CarryToggle", "LaggerMode", "TPBat", "BatBypass", "Carry", "LaggerCarry", "InstaReset" }
KB = {}
for _, name in ipairs(KB_NAMES) do KB[name] = { kb = nil, gp = nil } end

local GAMEPAD_KEYS = {
    [Enum.KeyCode.ButtonA] = true, [Enum.KeyCode.ButtonB] = true, [Enum.KeyCode.ButtonX] = true, [Enum.KeyCode.ButtonY] = true,
    [Enum.KeyCode.ButtonL1] = true, [Enum.KeyCode.ButtonR1] = true, [Enum.KeyCode.ButtonL2] = true, [Enum.KeyCode.ButtonR2] = true,
    [Enum.KeyCode.ButtonL3] = true, [Enum.KeyCode.ButtonR3] = true, [Enum.KeyCode.ButtonStart] = true, [Enum.KeyCode.ButtonSelect] = true,
    [Enum.KeyCode.DPadUp] = true, [Enum.KeyCode.DPadDown] = true, [Enum.KeyCode.DPadLeft] = true, [Enum.KeyCode.DPadRight] = true,
}
local MOVE_KEYS = {
    [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true, [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true, [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
}
local BAT_COUNTER_SLAP_LIST = { "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap" }
local AP = {
    L1 = _V3new(-476.48, -6.28, 92.73), L2 = _V3new(-483.12, -4.95, 94.80), L_FACE = _V3new(-482.25, -4.96, 92.09),
    R1 = _V3new(-476.16, -6.52, 25.62), R2 = _V3new(-483.06, -5.03, 25.48), R_FACE = _V3new(-482.06, -6.93, 35.47),
}

local function isGamepadInput(inp)
    return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
end

local function isBindableInput(inp)
    if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
    if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
    return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
end

local function kbMatch(entry, kc)
    return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
end

local function refreshKeybindButtonLabels()
    for _, ref in ipairs(keyButtonRefs) do
        if ref.btn and ref.entry then
            ref.btn.Text = (ref.entry.gp and ref.entry.gp.Name) or (ref.entry.kb and ref.entry.kb.Name) or "None"
        end
    end
end

local function assignUniqueKeybind(targetEntry, keyCode, isGp)
    for _, entry in pairs(KB) do
        if entry ~= targetEntry then
            if entry.kb == keyCode then entry.kb = nil end
            if entry.gp == keyCode then entry.gp = nil end
        end
    end
    targetEntry.kb, targetEntry.gp = nil, nil
    targetEntry[isGp and "gp" or "kb"] = keyCode
    refreshKeybindButtonLabels()
    pcall(saveAllSettings)
end

local function removeDuplicateLoadedKeybinds()
    local seen = {}
    for _, name in ipairs(KB_NAMES) do
        local entry = KB[name]
        if entry then
            for _, field in ipairs({ "kb", "gp" }) do
                local key = entry[field]
                if key then
                    if seen[key.Name] then entry[field] = nil else seen[key.Name] = true end
                end
            end
        end
    end
end

-- ============================================================================
-- AUTO STEAL
-- ============================================================================
_isResetting, _lastSavedJSON, _isLoading, _configReady = false, nil, false, false
CONFIG = { AUTO_STEAL_ENABLED = false, STEAL_RANGE = 61 }
local stealConnection, isStealing = nil, false
local Steal = { AutoStealEnabled = false, StealRadius = CONFIG.STEAL_RANGE, StealDuration = 1.3, Data = {} }
local autoGrabSetDelayRadius, autoGrabStopTime = 9, 0.96
local _plotsCache, _plotsCacheTime = nil, 0

local function getPlotsRoot()
    local now = _tick()
    if _plotsCache and now - _plotsCacheTime < 2 and _plotsCache.Parent then return _plotsCache end
    _plotsCache = Workspace:FindFirstChild("Plots")
    _plotsCacheTime = now
    return _plotsCache
end

local function isMyPlotByName(plotName)
    local root = getPlotsRoot()
    local plot = root and root:FindFirstChild(plotName)
    local sign = plot and plot:FindFirstChild("PlotSign")
    local yb = sign and sign:FindFirstChild("YourBase")
    return yb and yb:IsA("BillboardGui") and yb.Enabled == true or false
end

local function findNearestPrompt()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local plotsRoot = getPlotsRoot()
    if not root or not plotsRoot then return nil, nil end
    local nearestPrompt, nearestDist, nearestName = nil, _huge, nil
    local rpos = root.Position
    for _, plot in ipairs(plotsRoot:GetChildren()) do
        if not isMyPlotByName(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    pcall(function()
                        local spawn = pod:FindFirstChild("Base") and pod.Base:FindFirstChild("Spawn")
                        if spawn then
                            local dist = (spawn.Position - rpos).Magnitude
                            if dist < nearestDist and dist <= Steal.StealRadius then
                                local att = spawn:FindFirstChild("PromptAttachment")
                                if att then
                                    for _, child in ipairs(att:GetChildren()) do
                                        if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal", 1, true) then
                                            nearestPrompt, nearestDist, nearestName = child, dist, pod.Name
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
    return nearestPrompt, nearestName
end

local function setStealProgressUI(p)
    if progressFill then progressFill.Size = UDim2.new(p, 0, 1, 0) end
    if progressPct then progressPct.Text = _floor(p * 100) .. "%" end
end

local function fireStealPrompt(data, prompt, podName)
    pcall(function()
        for _, f in ipairs(data.trigger) do task.spawn(f) end
        local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
        if remote and podName then remote:FireServer(podName) end
        if prompt then prompt:Fire() end
    end)
end

local function executeSteal(prompt, podName)
    if isStealing then return end
    if math.random(30) == 1 then
        for p in pairs(Steal.Data) do if not p.Parent then Steal.Data[p] = nil end end
    end
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
    setStealProgressUI(0)

    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end
        local startTime = _tick()
        local duration = Steal.StealDuration

        local function outOfRangeOrGone()
            if not prompt.Parent or not prompt.Parent.Parent then return true end
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            return hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius
        end

        while isStealing and Steal.AutoStealEnabled do
            local elapsed = _tick() - startTime
            if elapsed >= autoGrabStopTime then break end
            setStealProgressUI(_clamp(elapsed / duration, 0, 1))
            if outOfRangeOrGone() then break end
            task.wait()
        end

        local stopProgress = _clamp(autoGrabStopTime / duration, 0, 1)
        setStealProgressUI(stopProgress)
        local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
        local phase2Start = _tick()

        while isStealing and Steal.AutoStealEnabled do
            if _tick() - phase2Start >= phase2Timeout then
                setStealProgressUI(0)
                data.ready = true
                isStealing = false
                task.wait()
                local np, nn = findNearestPrompt()
                if np then executeSteal(np, nn) end
                return
            end
            if outOfRangeOrGone() then
                isStealing = false
                setStealProgressUI(0)
                data.ready = true
                return
            end
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude <= autoGrabSetDelayRadius then
                break
            end
            task.wait()
        end

        if isStealing and Steal.AutoStealEnabled then
            local fillStart = _tick()
            local fillDuration = math.max(duration - autoGrabStopTime, 0.05)
            while true do
                local fp = _clamp((_tick() - fillStart) / fillDuration, 0, 1)
                setStealProgressUI(stopProgress + fp * (1 - stopProgress))
                if fp >= 1 then
                    fireStealPrompt(data, prompt, podName)
                    break
                end
                task.wait()
            end
        end

        setStealProgressUI(0)
        data.ready = true
        isStealing = false
    end)
end

function startAutoSteal()
    if stealConnection then
        local connected = false
        pcall(function() connected = stealConnection.Connected == true end)
        if connected then
            Steal.StealRadius = CONFIG.STEAL_RANGE
            Steal.AutoStealEnabled = true
            CONFIG.AUTO_STEAL_ENABLED = true
            return true
        end
        safeDisconnect(stealConnection); stealConnection = nil
    end
    Steal.StealRadius = CONFIG.STEAL_RANGE
    Steal.AutoStealEnabled = true
    CONFIG.AUTO_STEAL_ENABLED = true
    stealConnection = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
    return true
end

function stopAutoSteal()
    safeDisconnect(stealConnection); stealConnection = nil
    isStealing = false
    Steal.AutoStealEnabled = false
    CONFIG.AUTO_STEAL_ENABLED = false
    if progressFill then TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play() end
    if progressPct then progressPct.Text = "0%" end
end

-- ============================================================================
-- TP DOWN, ANTI-RAGDOLL (V1/V2), ANTI-DIE, ANTI-FLING, RAGDOLL COUNTDOWN
-- ============================================================================
local function doTpDown()
    pcall(function()
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        root.CFrame = _CFnew(root.Position.X, -7, root.Position.Z) * CFrame.Angles(0, select(2, root.CFrame:ToEulerAnglesYXZ()), 0)
        root.Velocity = _V3zero
    end)
end

-- AntiRagdoll V1
local AntiRagdollV1 = { active = false, isBoosting = false, cachedChar = nil, conns = {} }
local function isRagdollType(st)
    return st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
end

function AntiRagdollV1.isRunning() return AntiRagdollV1.active end

function AntiRagdollV1.stop()
    AntiRagdollV1.active = false
    if AntiRagdollV1.isBoosting and AntiRagdollV1.cachedChar and AntiRagdollV1.cachedChar.humanoid then
        AntiRagdollV1.cachedChar.humanoid.WalkSpeed = 16
    end
    AntiRagdollV1.isBoosting = false
    for _, conn in ipairs(AntiRagdollV1.conns) do safeDisconnect(conn) end
    AntiRagdollV1.conns = {}
    AntiRagdollV1.cachedChar = nil
end

local function cacheCharV1()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    AntiRagdollV1.cachedChar = { character = char, humanoid = hum, root = root }
    return true
end

function AntiRagdollV1.start()
    if AntiRagdollV1.active then return end
    AntiRagdollV1.stop()
    if not cacheCharV1() then return end
    AntiRagdollV1.active = true
    table.insert(AntiRagdollV1.conns, RunService.RenderStepped:Connect(function()
        local cam = Workspace.CurrentCamera
        if cam and AntiRagdollV1.cachedChar and AntiRagdollV1.cachedChar.humanoid then
            cam.CameraSubject = AntiRagdollV1.cachedChar.humanoid
        end
    end))
    table.insert(AntiRagdollV1.conns, LP.CharacterAdded:Connect(function()
        AntiRagdollV1.isBoosting = false
        task.wait(0.5)
        cacheCharV1()
    end))
    task.spawn(function()
        while AntiRagdollV1.active do
            task.wait()
            local c = AntiRagdollV1.cachedChar
            local rag = c and c.humanoid and isRagdollType(c.humanoid:GetState())
            if rag then
                pcall(function() LP:SetAttribute("RagdollEndTime", Workspace:GetServerTimeNow()) end)
                for _, d in ipairs(c.character:GetDescendants()) do
                    if d:IsA("BallSocketConstraint") or (d:IsA("Attachment") and d.Name:find("RagdollAttachment", 1, true)) then
                        d:Destroy()
                    end
                end
                if not AntiRagdollV1.isBoosting then
                    AntiRagdollV1.isBoosting = true
                    c.humanoid.WalkSpeed = 400
                end
                if c.humanoid.Health > 0 then c.humanoid:ChangeState(Enum.HumanoidStateType.Running) end
                c.root.Anchored = false
            elseif AntiRagdollV1.isBoosting and c and c.humanoid then
                AntiRagdollV1.isBoosting = false
                c.humanoid.WalkSpeed = 16
            end
        end
    end)
end

-- AntiRagdoll V2
local AntiRagdollV2 = { Enabled = false, Connection = nil, ResetCooldown = 0 }
local function stopAntiRagdollV2()
    AntiRagdollV2.Enabled = false
    safeDisconnect(AntiRagdollV2.Connection); AntiRagdollV2.Connection = nil
    AntiRagdollV2.ResetCooldown = 0
end

local function startAntiRagdollV2()
    if AntiRagdollV2.Connection then return end
    AntiRagdollV2.Enabled = true
    AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
        if not AntiRagdollV2.Enabled then return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
        local now = _tick()
        if isRagdollType(hum:GetState()) and now - AntiRagdollV2.ResetCooldown > 0.15 then
            AntiRagdollV2.ResetCooldown = now
            pcall(function()
                if hum:GetState() == Enum.HumanoidStateType.GettingUp or hum.Health <= 0 then return end
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                root.Velocity, root.RotVelocity = _V3zero, _V3zero
                root.AssemblyLinearVelocity, root.AssemblyAngularVelocity = _V3zero, _V3zero
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("Motor6D") or obj:IsA("Constraint") then obj.Enabled = true end
                end
                Workspace.CurrentCamera.CameraSubject = hum
                local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
                local CM = PM and require(PM:FindFirstChild("ControlModule"))
                if CM then CM:Enable() end
                hum.AutoRotate, hum.PlatformStand, hum.Sit = true, false, false
            end)
        end
    end)
end

function setAntiRagdollMode(mode)
    if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    if mode == "v1" or mode == "v2" then
        antiRagdollMode = mode
        if mode == "v1" then AntiRagdollV1.start() else startAntiRagdollV2() end
    else
        antiRagdollMode = "off"
    end
    if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollMode ~= "off") end
    if updateAntiRagdollModeUI then updateAntiRagdollModeUI(antiRagdollMode) end
    saveAllSettings()
end

-- Anti Die
local AntiDieModule = { enabled = false, healthConn = nil, diedConn = nil, charConn = nil, humanoid = nil, _reviving = false }
local function disconnectAntiDieHum()
    safeDisconnect(AntiDieModule.healthConn); AntiDieModule.healthConn = nil
    safeDisconnect(AntiDieModule.diedConn); AntiDieModule.diedConn = nil
    AntiDieModule.humanoid = nil
end

local function activateOnCharacter(char)
    if not AntiDieModule.enabled then return end
    char = char or LP.Character or LP.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
    if not hum or not AntiDieModule.enabled then return end
    disconnectAntiDieHum()
    AntiDieModule.humanoid = hum
    pcall(function()
        hum.BreakJointsOnDeath = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Dying, false)
    end)
    local function revive()
        if not AntiDieModule.enabled or not char.Parent or not hum.Parent or AntiDieModule._reviving then return end
        AntiDieModule._reviving = true
        pcall(function()
            hum.Health = hum.MaxHealth
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            if hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Running) end
        end)
        task.delay(0.2, function() AntiDieModule._reviving = false end)
    end
    AntiDieModule.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health <= 0 then revive() end
    end)
    AntiDieModule.diedConn = hum.Died:Connect(function()
        task.defer(revive)
    end)
end

function AntiDieModule.start()
    AntiDieModule.enabled = true
    safeDisconnect(AntiDieModule.charConn)
    AntiDieModule.charConn = LP.CharacterAdded:Connect(function(char)
        if AntiDieModule.enabled then task.defer(activateOnCharacter, char) end
    end)
    task.defer(activateOnCharacter, LP.Character)
end

function AntiDieModule.stop()
    AntiDieModule.enabled = false
    safeDisconnect(AntiDieModule.charConn); AntiDieModule.charConn = nil
    local hum = AntiDieModule.humanoid
    disconnectAntiDieHum()
    if hum and hum.Parent then
        pcall(function()
            hum.BreakJointsOnDeath = true
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end)
    end
end
_G.AntiDie = AntiDieModule

-- Anti Fling
local AntiFlingModule = { enabled = false, connection = nil, threshold = 80, spinThreshold = 40 }
function AntiFlingModule.start()
    AntiFlingModule.enabled = true
    safeDisconnect(AntiFlingModule.connection)
    AntiFlingModule.connection = RunService.Heartbeat:Connect(function()
        if not AntiFlingModule.enabled then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or (hum and (hum.Health <= 0 or hum.SeatPart)) then return end
        local vel = root.AssemblyLinearVelocity
        if _V3new(vel.X, 0, vel.Z).Magnitude > AntiFlingModule.threshold then
            pcall(function()
                root.AssemblyLinearVelocity = _V3new(0, vel.Y, 0)
                root.AssemblyAngularVelocity = _V3zero
            end)
        elseif root.AssemblyAngularVelocity.Magnitude > AntiFlingModule.spinThreshold then
            pcall(function() root.AssemblyAngularVelocity = _V3zero end)
        end
    end)
end

function AntiFlingModule.stop()
    AntiFlingModule.enabled = false
    safeDisconnect(AntiFlingModule.connection); AntiFlingModule.connection = nil
end
_G._StrikeAntiFling = AntiFlingModule

-- Ragdoll Countdown Billboard
do
    local _ragRunning, _wasRag = false, false
    local function startRagCountdown()
        if not ragdollCountdownEnabled or _ragRunning then return end
        _ragRunning = true
        task.spawn(function()
            local head = LP.Character and LP.Character:FindFirstChild("Head")
            local pGui = LP:FindFirstChild("PlayerGui")
            if not head or not pGui then _ragRunning = false; return end
            safeDestroy(pGui:FindFirstChild("RagCountdownBillboard"))
            local bb = Instance.new("BillboardGui")
            bb.Name, bb.Size, bb.StudsOffset, bb.AlwaysOnTop, bb.Adornee, bb.Parent = "RagCountdownBillboard", UDim2.new(0, 84, 0, 42), _V3new(0, 4.5, 0), true, head, pGui
            local lbl = Instance.new("TextLabel", bb)
            lbl.Size, lbl.AnchorPoint, lbl.Position, lbl.BackgroundTransparency = UDim2.fromScale(1, 1), Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5), 1
            lbl.Font, lbl.TextScaled, lbl.TextColor3, lbl.TextStrokeColor3, lbl.TextStrokeTransparency = Enum.Font.GothamBlack, true, getThemeColor(), Color3.new(0, 0, 0), 0
            local grad = Instance.new("UIGradient", lbl)
            grad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, getThemeColor()), ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, getThemeColor()) })
            grad.Rotation = 45

            local timeLeft = 2.5
            while timeLeft > 0 and bb.Parent do
                lbl.Text = string.format("%.1f", timeLeft)
                task.wait(0.1)
                timeLeft = timeLeft - 0.1
            end
            if bb.Parent then
                lbl.Text = "READY!"
                task.wait(0.5)
                safeDestroy(bb)
            end
            _ragRunning = false
        end)
    end
    RunService.Heartbeat:Connect(function()
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then _wasRag = false; return end
        local inRag = isRagdollType(hum:GetState())
        if inRag and not _wasRag then _wasRag = true; startRagCountdown() elseif not inRag then _wasRag = false end
    end)
end

-- ============================================================================
-- ESP & ANTI TP ESP & ENEMY SPEED
-- ============================================================================
espHighlightCache, espBoxCache, espTrackerCache = {}, {}, {}
local espNameCache, espConn, _espLastRun, _espGui, _espTrackerGui = {}, nil, 0, nil, nil

local function clearESP()
    for _, tbl in ipairs({ espHighlightCache, espBoxCache, espTrackerCache, espNameCache }) do
        for _, obj in pairs(tbl) do safeDestroy(obj) end
    end
    espHighlightCache, espBoxCache, espTrackerCache, espNameCache = {}, {}, {}, {}
end

local function getESPGui()
    if _espGui and _espGui.Parent then return _espGui end
    local pg = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
    if not pg then return nil end
    safeDestroy(pg:FindFirstChild("StrikeESP"))
    safeDestroy(pg:FindFirstChild("StrikeESPTracker"))
    _espGui = Instance.new("ScreenGui")
    _espGui.Name, _espGui.ResetOnSpawn, _espGui.IgnoreGuiInset, _espGui.DisplayOrder, _espGui.ZIndexBehavior, _espGui.Parent = "StrikeESP", false, true, -1000, Enum.ZIndexBehavior.Sibling, pg
    _espTrackerGui = Instance.new("ScreenGui")
    _espTrackerGui.Name, _espTrackerGui.ResetOnSpawn, _espTrackerGui.IgnoreGuiInset, _espTrackerGui.DisplayOrder, _espTrackerGui.ZIndexBehavior, _espTrackerGui.Parent = "StrikeESPTracker", false, true, -1100, Enum.ZIndexBehavior.Sibling, pg
    return _espGui
end

local function removeESPPlayer(plr)
    safeDestroy(espHighlightCache[plr]); espHighlightCache[plr] = nil
    safeDestroy(espBoxCache[plr]); espBoxCache[plr] = nil
    safeDestroy(espTrackerCache[plr]); espTrackerCache[plr] = nil
    safeDestroy(espNameCache[plr]); espNameCache[plr] = nil
end

local function ensureESPPlayer(plr)
    if plr == LP then return end
    local g = getESPGui()
    if not g then return end
    if not espBoxCache[plr] then
        local box = Instance.new("Frame", g)
        box.Name, box.BackgroundColor3, box.BackgroundTransparency, box.BorderSizePixel, box.Visible, box.ZIndex = "ESP_BOX_" .. plr.Name, Color3.new(1, 1, 1), 0.78, 0, false, 9999
        local st = Instance.new("UIStroke", box)
        st.Color, st.Thickness, st.ApplyStrokeMode = Color3.new(1, 1, 1), 1.6, Enum.ApplyStrokeMode.Border
        espBoxCache[plr] = box
    end
    if not espTrackerCache[plr] and _espTrackerGui then
        local line = Instance.new("Frame", _espTrackerGui)
        line.Name, line.AnchorPoint, line.BackgroundColor3, line.BackgroundTransparency, line.BorderSizePixel, line.Visible, line.ZIndex = "ESP_TRACKER_" .. plr.Name, Vector2.new(0.5, 0.5), Color3.new(1, 1, 1), 0.05, 0, false, 9998
        espTrackerCache[plr] = line
    end
    if not espNameCache[plr] then
        local lbl = Instance.new("TextLabel", g)
        lbl.Name, lbl.BackgroundTransparency, lbl.TextColor3, lbl.TextStrokeColor3, lbl.TextStrokeTransparency = "ESP_NAME_" .. plr.Name, 1, Color3.new(1, 1, 1), Color3.new(0, 0, 0), 0.35
        lbl.Font, lbl.TextSize, lbl.TextYAlignment, lbl.Visible, lbl.ZIndex = Enum.Font.GothamBold, 11, Enum.TextYAlignment.Bottom, false, 10000
        espNameCache[plr] = lbl
    end
    if plr.Character then
        local old = espHighlightCache[plr]
        if not old or old.Parent ~= plr.Character then
            safeDestroy(old)
            safeDestroy(plr.Character:FindFirstChild("StrikeESPHighlight"))
            local hl = Instance.new("Highlight", plr.Character)
            hl.Name, hl.FillColor, hl.OutlineColor = "StrikeESPHighlight", getThemeColor(), getThemeColor()
            hl.FillTransparency, hl.OutlineTransparency, hl.DepthMode, hl.Enabled, hl.Adornee = 0.58, 0, Enum.HighlightDepthMode.AlwaysOnTop, espEnabled, plr.Character
            espHighlightCache[plr] = hl
        end
    end
end

local function pointLine(line, x1, y1, x2, y2)
    if not line then return end
    local dx, dy = x2 - x1, y2 - y1
    line.Position = UDim2.fromOffset((x1 + x2) * 0.5, (y1 + y2) * 0.5)
    line.Size = UDim2.fromOffset(_sqrt(dx * dx + dy * dy), 1)
    line.Rotation = math.deg(math.atan2(dy, dx))
end

local function updateESP()
    local now = _tick()
    if now - _espLastRun < 0.03 then return end
    _espLastRun = now
    if not espEnabled then
        for _, hl in pairs(espHighlightCache) do if hl then hl.Enabled = false end end
        for _, box in pairs(espBoxCache) do if box then box.Visible = false end end
        for _, line in pairs(espTrackerCache) do if line then line.Visible = false end end
        for _, lbl in pairs(espNameCache) do if lbl then lbl.Visible = false end end
        return
    end
    if not getESPGui() then return end
    local cam = Workspace.CurrentCamera
    local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not cam or not myRoot then return end
    local myPoint, myOnScreen = cam:WorldToViewportPoint(myRoot.Position)
    local themeCol = getThemeColor()
    local seen = {}

    for _, plr in ipairs(_GetPlayersCached()) do
        if plr ~= LP then
            seen[plr] = true
            ensureESPPlayer(plr)
            local char = plr.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hl, box, tracker, nameLabel = espHighlightCache[plr], espBoxCache[plr], espTrackerCache[plr], espNameCache[plr]
            if not (root and head and hum and hum.Health > 0) then
                if hl then hl.Enabled = false end
                if box then box.Visible = false end
                if tracker then tracker.Visible = false end
                if nameLabel then nameLabel.Visible = false end
            else
                if hl then hl.FillColor, hl.OutlineColor, hl.Enabled = themeCol, themeCol, true end
                local top = cam:WorldToViewportPoint(root.Position + _V3new(0, 3.2, 0))
                local bottom = cam:WorldToViewportPoint(root.Position + _V3new(0, -3, 0))
                if top.Z > 0 and bottom.Z > 0 then
                    local height = math.abs(bottom.Y - top.Y)
                    local width = height * 0.55
                    local cx, cy = (top.X + bottom.X) * 0.5, (top.Y + bottom.Y) * 0.5
                    if box then
                        box.Position = UDim2.fromOffset(cx - width * 0.5, cy - height * 0.5)
                        box.Size = UDim2.fromOffset(width, height)
                        box.Visible = espBoxEnabled
                        local st = box:FindFirstChildOfClass("UIStroke")
                        if st then st.Color = themeCol end
                    end
                    if nameLabel then
                        nameLabel.Text = string.format("%s  Speed: %.1f", plr.DisplayName or plr.Name, root.AssemblyLinearVelocity.Magnitude)
                        nameLabel.Position = UDim2.fromOffset(cx - width * 0.75, cy - height * 0.5 - 18)
                        nameLabel.Size = UDim2.fromOffset(width * 1.5, 18)
                        nameLabel.Visible = espBoxEnabled
                    end
                    if tracker then
                        pointLine(tracker, myPoint.X, myPoint.Y, cx, cy)
                        tracker.Visible = espTrackerEnabled and myOnScreen
                        tracker.BackgroundColor3 = themeCol
                    end
                else
                    if box then box.Visible = false end
                    if nameLabel then nameLabel.Visible = false end
                    if tracker then
                        local off = cam:WorldToViewportPoint(root.Position)
                        local tx, ty = off.X, off.Y
                        if off.Z <= 0 then tx, ty = cam.ViewportSize.X - tx, cam.ViewportSize.Y - ty end
                        pointLine(tracker, cam.ViewportSize.X * 0.5, cam.ViewportSize.Y * 0.5, tx, ty)
                        tracker.Visible = espTrackerEnabled
                        tracker.BackgroundColor3 = themeCol
                    end
                end
            end
        end
    end
    for plr in pairs(espHighlightCache) do if not seen[plr] then removeESPPlayer(plr) end end
end

Players.PlayerAdded:Connect(function(plr)
    if espEnabled then task.defer(ensureESPPlayer, plr) end
end)
Players.PlayerRemoving:Connect(removeESPPlayer)

function toggleESP(on)
    espEnabled = on == true
    if espEnabled then
        if not espConn then espConn = RunService.RenderStepped:Connect(updateESP) end
        getESPGui()
    else
        safeDisconnect(espConn); espConn = nil
        clearESP()
    end
    if setESPVIsual then setESPVIsual(espEnabled) end
end

function toggleESPBox(on)
    espBoxEnabled = on == true
    if setESPBoxVisual then setESPBoxVisual(espBoxEnabled) end
    if type(saveAllSettings) == "function" then pcall(saveAllSettings) end
end

function toggleESPTracker(on)
    espTrackerEnabled = on == true
    if setESPTrackerVisual then setESPTrackerVisual(espTrackerEnabled) end
    if type(saveAllSettings) == "function" then pcall(saveAllSettings) end
end

function toggleRagdollCountdown(on)
    ragdollCountdownEnabled = on == true
    if not ragdollCountdownEnabled then
        local pg = LP:FindFirstChildOfClass("PlayerGui")
        safeDestroy(pg and pg:FindFirstChild("RagCountdownBillboard"))
    end
    if setRagdollCountdownVisual then setRagdollCountdownVisual(ragdollCountdownEnabled) end
end

-- Anti TP ESP
do
    local antiTpEsp = {
        Enabled = false,
        Settings = { Color = Color3.fromRGB(132, 70, 255), MaxDistance = 300, MaxAcceptedSpeed = 300, GhostShowDistance = 3, GhostHideDistance = 3 },
        Connections = {},
        Ghosts = {},
    }
    _G._StrikeAntiTpEsp = antiTpEsp
    safeDestroy(Workspace:FindFirstChild("StrikeAntiTpGhosts"))
    local antiTpFolder = Instance.new("Folder", Workspace)
    antiTpFolder.Name = "StrikeAntiTpGhosts"
    local observed = setmetatable({}, { __mode = "k" })
    local renderStates = setmetatable({}, { __mode = "k" })

    local function validVec(v)
        return typeof(v) == "Vector3" and v.X == v.X and v.Y == v.Y and v.Z == v.Z and math.abs(v.X) < 1e6 and math.abs(v.Y) < 1e6 and math.abs(v.Z) < 1e6
    end

    local function createGhost(name)
        local model = Instance.new("Model")
        model.Name = "StrikeGhost_" .. tostring(name)
        local function mkPart(sz)
            local p = Instance.new("Part", model)
            p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch, p.CastShadow = true, false, false, false, false
            p.Material, p.Size, p.Transparency = Enum.Material.Neon, sz, 0.35
            p.TopSurface, p.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
            return p
        end
        local ghost = {
            Model = model,
            Torso = mkPart(_V3new(2, 2, 1)), Head = mkPart(_V3new(1.2, 1.2, 1.2)),
            LeftArm = mkPart(_V3new(0.9, 2, 0.9)), RightArm = mkPart(_V3new(0.9, 2, 0.9)),
            LeftLeg = mkPart(_V3new(0.9, 2, 0.9)), RightLeg = mkPart(_V3new(0.9, 2, 0.9)),
        }
        local bb = Instance.new("BillboardGui", ghost.Head)
        bb.Size, bb.StudsOffset, bb.AlwaysOnTop = UDim2.new(0, 110, 0, 18), _V3new(0, 1.6, 0), true
        local lbl = Instance.new("TextLabel", bb)
        lbl.Size, lbl.BackgroundTransparency, lbl.Text, lbl.Font, lbl.TextSize, lbl.TextStrokeTransparency = UDim2.fromScale(1, 1), 1, tostring(name), Enum.Font.GothamBlack, 12, 0
        ghost.Label = lbl
        model.Parent = antiTpFolder
        return ghost
    end

    local function showGhost(player, pos, root)
        if not antiTpEsp.Enabled then return end
        local ghost = antiTpEsp.Ghosts[player]
        if not ghost then ghost = createGhost(player.Name); antiTpEsp.Ghosts[player] = ghost end
        if not ghost.Model.Parent then ghost.Model.Parent = antiTpFolder end
        ghost.Shown = true
        local yaw = 0
        pcall(function() local _, y = root.CFrame:ToEulerAnglesYXZ(); yaw = y end)
        local cf = _CFnew(pos) * CFrame.Angles(0, yaw, 0)
        ghost.Torso.CFrame = cf
        ghost.Head.CFrame = cf * _CFnew(0, 1.6, 0)
        ghost.LeftArm.CFrame = cf * _CFnew(-1.45, 0, 0)
        ghost.RightArm.CFrame = cf * _CFnew(1.45, 0, 0)
        ghost.LeftLeg.CFrame = cf * _CFnew(-0.55, -2, 0)
        ghost.RightLeg.CFrame = cf * _CFnew(0.55, -2, 0)
        local col = antiTpEsp.Settings.Color
        for _, ch in ipairs(ghost.Model:GetChildren()) do
            if ch:IsA("BasePart") then ch.Color = col end
        end
        ghost.Label.TextColor3 = col
    end

    local function hideGhost(player)
        local g = antiTpEsp.Ghosts[player]
        if g then g.Model.Parent = nil; g.Shown = false end
    end

    local hbAcc, rsAcc = 0, 0
    table.insert(antiTpEsp.Connections, RunService.Heartbeat:Connect(function(dt)
        if not antiTpEsp.Enabled then return end
        hbAcc = hbAcc + (dt or 0.016)
        if hbAcc < 1 / 30 then return end
        hbAcc = 0
        local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local now = os.clock()
        for _, player in ipairs(_GetPlayersCached()) do
            if player ~= LP then
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if root and hum and hum.Health > 0 then
                    local pos = root.Position
                    local dist = validVec(pos) and (myRoot.Position - pos).Magnitude or _huge
                    local valid = validVec(pos) and pos.Y > -30 and pos.Y < 350 and dist <= antiTpEsp.Settings.MaxDistance and root.AssemblyLinearVelocity.Magnitude <= 180 and root.AssemblyAngularVelocity.Magnitude <= 45
                    local st = observed[player]
                    if not st or st.Character ~= char then
                        st = { Character = char, Locked = false, CandidateCount = 0 }
                        observed[player] = st
                    end
                    if validVec(pos) and st.LastObserved and (pos - st.LastObserved).Magnitude >= 8 then st.Locked = true end
                    if not valid then
                        st.Locked, st.Candidate, st.CandidateAt, st.CandidateCount = true, nil, nil, 0
                    elseif not st.Locked then
                        if st.Candidate and (pos - st.Candidate).Magnitude <= 7 then
                            st.Candidate = st.Candidate:Lerp(pos, 0.35)
                            st.CandidateCount = st.CandidateCount + 1
                            if st.CandidateCount >= 4 and (now - (st.CandidateAt or now)) >= 0.1 then
                                st.Position, st.PositionAt, st.Confirmed = st.Candidate, now, true
                            end
                        else
                            st.Candidate, st.CandidateAt, st.CandidateCount = pos, now, 1
                        end
                    end
                    if validVec(pos) then st.LastObserved = pos end
                end
            end
        end
    end))

    table.insert(antiTpEsp.Connections, RunService.RenderStepped:Connect(function(dt)
        if not antiTpEsp.Enabled then return end
        rsAcc = rsAcc + (dt or 0.016)
        if rsAcc < 1 / 144 then return end
        rsAcc = 0
        local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local now = os.clock()
        for _, player in ipairs(_GetPlayersCached()) do
            if player ~= LP then
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if root and hum and hum.Health > 0 then
                    local st = renderStates[player]
                    if not st or st.Character ~= char then
                        st = { Character = char, At = now, CandidateAt = 0, CandidateCount = 0, Frozen = false }
                        renderStates[player] = st
                    end
                    local pos = root.Position
                    if validVec(pos) and (pos.Y < -35 or pos.Y > 350) then
                        hideGhost(player)
                    else
                        local obs = observed[player]
                        if not st.Position then
                            st.Position = (obs and obs.Confirmed and obs.Character == char and obs.Position) or pos
                            st.At = now
                            st.Frozen = obs and obs.Confirmed == true or false
                        else
                            local elapsed = math.max(now - (st.At or now), 1 / 240)
                            local moved = (pos - st.Position).Magnitude
                            if (not st.Frozen and moved <= antiTpEsp.Settings.MaxAcceptedSpeed * elapsed) or (st.Frozen and moved <= 12) then
                                st.Position, st.At, st.Frozen = pos, now, false
                            elseif not st.Candidate or (pos - st.Candidate).Magnitude > 9 then
                                st.Candidate, st.CandidateAt, st.CandidateCount = pos, now, 1
                            else
                                st.Candidate = st.Candidate:Lerp(pos, 0.45)
                                st.CandidateCount = st.CandidateCount + 1
                                if st.CandidateCount >= 3 and (now - st.CandidateAt) >= 0.075 then
                                    st.Position, st.At, st.Candidate, st.CandidateCount, st.Frozen = pos, now, nil, 0, false
                                end
                            end
                        end
                        if st.Position and (st.Position - myRoot.Position).Magnitude <= antiTpEsp.Settings.MaxDistance then
                            local delta = (st.Position - pos).Magnitude
                            if delta >= antiTpEsp.Settings.GhostShowDistance or (antiTpEsp.Ghosts[player] and antiTpEsp.Ghosts[player].Shown and delta > antiTpEsp.Settings.GhostHideDistance) then
                                showGhost(player, st.Position, root)
                            elseif delta <= antiTpEsp.Settings.GhostHideDistance then
                                hideGhost(player)
                            end
                        else
                            hideGhost(player)
                        end
                    end
                else
                    hideGhost(player)
                end
            end
        end
    end))

    table.insert(antiTpEsp.Connections, Players.PlayerRemoving:Connect(function(player)
        local g = antiTpEsp.Ghosts[player]
        if g then safeDestroy(g.Model); antiTpEsp.Ghosts[player] = nil end
        observed[player], renderStates[player] = nil, nil
    end))

    antiTpEsp.SetEnabled = function(on)
        antiTpEsp.Enabled = on == true
        if not antiTpEsp.Enabled then
            for player in pairs(antiTpEsp.Ghosts) do hideGhost(player) end
            table.clear(observed); table.clear(renderStates)
        end
    end
    antiTpEsp.SetColor = function(col) if typeof(col) == "Color3" then antiTpEsp.Settings.Color = col end end

    function toggleAntiTpEsp(on)
        antiTpEspEnabled = on == true
        antiTpEsp.SetEnabled(antiTpEspEnabled)
        if setAntiTpEspVisual then setAntiTpEspVisual(antiTpEspEnabled) end
    end
end

-- Enemy Speed Labels & Local Speed Indicator
local _enemySpeedAcc = 0
local function updateEnemySpeedLabels()
    _enemySpeedAcc = _enemySpeedAcc + 1
    if _enemySpeedAcc < 6 then return end
    _enemySpeedAcc = 0
    for _, player in ipairs(_GetPlayersCached()) do
        if player ~= LP then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local label = enemySpeedLabels[player]
            if hrp and hum and hum.Health > 0 then
                local v = hrp.AssemblyLinearVelocity
                local spd = _sqrt(v.X * v.X + v.Z * v.Z)
                local head = char:FindFirstChild("Head")
                if not label and head then
                    local bb = Instance.new("BillboardGui", head)
                    bb.Name, bb.Size, bb.StudsOffset, bb.AlwaysOnTop = "EnemySpeedGui", UDim2.new(0, 100, 0, 25), _V3new(0, 5.5, 0), true
                    label = Instance.new("TextLabel", bb)
                    label.Size, label.BackgroundTransparency, label.TextColor3 = UDim2.fromScale(1, 1), 1, Color3.new(1, 1, 1)
                    label.Font, label.TextScaled, label.TextStrokeTransparency, label.TextStrokeColor3 = Enum.Font.GothamBold, true, 0, Color3.new(0, 0, 0)
                    enemySpeedLabels[player] = label
                elseif label and label.Parent and label.Parent.Parent ~= char and head then
                    label.Parent.Parent = head
                end
                if label then label.Text = string.format("%.1f", spd) end
            else
                if label and label.Parent then label.Parent.Parent = nil end
                enemySpeedLabels[player] = nil
            end
        end
    end
end

function startEnemySpeed()
    safeDisconnect(enemySpeedConn)
    enemySpeedConn = RunService.Heartbeat:Connect(updateEnemySpeedLabels)
end

function stopEnemySpeed()
    safeDisconnect(enemySpeedConn); enemySpeedConn = nil
end

function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    safeDestroy(head:FindFirstChild("StrikeSpeedIndicator"))
    safeDestroy(head:FindFirstChild("DiscordText"))

    local bb = Instance.new("BillboardGui", head)
    bb.Name, bb.Size, bb.StudsOffset, bb.AlwaysOnTop = "StrikeSpeedIndicator", UDim2.new(0, 120, 0, 32), _V3new(0, 2.0, 0), true
    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Size, speedLabel.BackgroundTransparency, speedLabel.Text = UDim2.fromScale(1, 1), 1, "Spd: 0.0"
    speedLabel.TextColor3, speedLabel.Font, speedLabel.TextScaled = getThemeColor(), Enum.Font.GothamBold, true
    speedLabel.TextStrokeTransparency, speedLabel.TextStrokeColor3 = 0, Color3.new(0, 0, 0)

    local discordBB = Instance.new("BillboardGui", head)
    discordBB.Name, discordBB.Size, discordBB.StudsOffset, discordBB.AlwaysOnTop = "DiscordText", UDim2.new(0, 200, 0, 28), _V3new(0, 3.1, 0), true
    local dLbl = Instance.new("TextLabel", discordBB)
    dLbl.Size, dLbl.BackgroundTransparency, dLbl.Text = UDim2.fromScale(1, 1), 1, "discord.gg/Akjvv4Ybws"
    dLbl.TextColor3, dLbl.Font, dLbl.TextScaled = Color3.new(1, 1, 1), Enum.Font.GothamBold, true
    dLbl.TextStrokeTransparency, dLbl.TextStrokeColor3 = 0, Color3.new(0, 0, 0)
    applyShimmerToText(dLbl, 0.9)
end

-- ============================================================================
-- MODOS DE VELOCIDAD & AUTO CARRY
-- ============================================================================
function refreshSpeedModeLabel()
    if modeValLbl then
        modeValLbl.Text = laggerCarryToggled and "Lagger Carry" or (laggerToggled and "Lagger" or (speedMode and "Carry" or "Normal"))
    end
    if setCarryModeVisual then setCarryModeVisual(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function resetMovementState()
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end
end

function toggleCarryMode()
    if laggerToggled or laggerCarryToggled then
        laggerToggled, laggerCarryToggled, speedMode = false, false, true
    else
        speedMode = not speedMode
    end
    resetMovementState()
end

function toggleLaggerCycle()
    if speedMode then
        speedMode, laggerToggled, laggerCarryToggled = false, true, false
    elseif laggerToggled then
        speedMode, laggerToggled, laggerCarryToggled = false, false, true
    else
        speedMode, laggerToggled, laggerCarryToggled = true, false, false
    end
    resetMovementState()
end

do
    local _acsFromAuto, _acsReturnCarry, _acsReturnLagger, _acsReturnLaggerCarry, _acsGraceUntil = false, false, false, false, 0

    local function syncCarrySystem()
        CarrySystem.speedToggled = speedMode
        CarrySystem.laggerMode = laggerCarryToggled and 2 or (laggerToggled and 1 or 0)
    end

    local function disableAutoCarry()
        if not _acsFromAuto then return end
        _acsFromAuto, _acsGraceUntil = false, 0
        speedMode, laggerToggled, laggerCarryToggled = _acsReturnCarry, _acsReturnLagger, _acsReturnLaggerCarry
        resetMovementState()
        syncCarrySystem()
    end

    function _G.StrikeSetAutoCarrySpeed(on)
        autoCarrySpeedEnabled = on and true or false
        if not autoCarrySpeedEnabled then disableAutoCarry() end
        if setAutoCarrySpeedVisual then pcall(setAutoCarrySpeedVisual, autoCarrySpeedEnabled) end
    end

    RunService.RenderStepped:Connect(function()
        if autoCarrySpeedEnabled ~= true then
            disableAutoCarry()
            return
        end
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if not hum then disableAutoCarry(); return end
        local gotHit = isRagdollType(hum:GetState())
        local carrying = isCarryingBrainrot(false)
        if carrying and not _acsFromAuto then
            _acsReturnCarry, _acsReturnLagger, _acsReturnLaggerCarry = speedMode, laggerToggled, laggerCarryToggled
            _acsFromAuto, _acsGraceUntil = true, _tick() + 0.75
            if laggerToggled or laggerCarryToggled then
                speedMode, laggerToggled, laggerCarryToggled = false, false, true
            else
                speedMode, laggerToggled, laggerCarryToggled = true, false, false
            end
            resetMovementState()
            syncCarrySystem()
        elseif _acsFromAuto and (gotHit or (_tick() > _acsGraceUntil and not carrying)) then
            disableAutoCarry()
        end
    end)

    local enemyBaseConn = nil
    local function isNearEnemyBase(range)
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local plots = getPlotsRoot()
        if not hrp or not plots then return false end
        local myPos = hrp.Position
        for _, plot in ipairs(plots:GetChildren()) do
            if plot:IsA("Model") and not isMyPlotByName(plot.Name) then
                local pos
                local ok, pivot = pcall(function() return plot:GetPivot().Position end)
                if ok and pivot then pos = pivot end
                if not pos then
                    local sign = plot:FindFirstChild("PlotSign")
                    local part = sign and (sign:IsA("BasePart") and sign or sign:FindFirstChildWhichIsA("BasePart", true))
                    if part then pos = part.Position end
                end
                if pos and _V3new(myPos.X - pos.X, 0, myPos.Z - pos.Z).Magnitude <= range then
                    return true
                end
            end
        end
        return false
    end

    function _G.StrikeStartAutoCarryEnemyBase()
        if enemyBaseConn then return end
        local acc = 0
        enemyBaseConn = RunService.Heartbeat:Connect(function(dt)
            if not autoCarryEnemyBaseEnabled then return end
            acc = acc + (dt or 0.016)
            if acc < 0.2 then return end
            acc = 0
            if not isNearEnemyBase(tonumber(autoCarryEnemyBaseRange) or 35) then return end
            if speedMode and not laggerToggled and not laggerCarryToggled then return end
            speedMode, laggerToggled, laggerCarryToggled = true, false, false
            resetMovementState()
            syncCarrySystem()
        end)
    end

    function _G.StrikeStopAutoCarryEnemyBase()
        safeDisconnect(enemyBaseConn); enemyBaseConn = nil
    end

    function _G.StrikeSetAutoCarryEnemyBase(on)
        autoCarryEnemyBaseEnabled = on and true or false
        if autoCarryEnemyBaseEnabled then _G.StrikeStartAutoCarryEnemyBase() else _G.StrikeStopAutoCarryEnemyBase() end
        if setAutoCarryEnemyBaseVisual then pcall(setAutoCarryEnemyBaseVisual, autoCarryEnemyBaseEnabled) end
    end
end

-- ============================================================================
-- AUTO LEFT / AUTO RIGHT (Unificado)
-- ============================================================================
local function stopAutoPath(side)
    if side == "Left" then
        safeDisconnect(alConn); alConn = nil
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    else
        safeDisconnect(arConn); arConn = nil
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum:Move(_V3zero, false) end
end

local function startAutoPath(side)
    local isLeft = (side == "Left")
    if isLeft and autoRightEnabled then autoRightEnabled = false; stopAutoPath("Right") end
    if not isLeft and autoLeftEnabled then autoLeftEnabled = false; stopAutoPath("Left") end
    disableAllAimbots()

    local p1 = isLeft and AP.L1 or AP.R1
    local p2 = isLeft and AP.L2 or AP.R2
    local pFace = isLeft and AP.L_FACE or AP.R_FACE
    local phase = 1

    if isLeft then safeDisconnect(alConn) else safeDisconnect(arConn) end
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if (isLeft and not autoLeftEnabled) or (not isLeft and not autoRightEnabled) then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end

        local target = phase == 1 and p1 or p2
        local flatTarget = _V3new(target.X, root.Position.Y, target.Z)
        if (flatTarget - root.Position).Magnitude < 1 then
            if phase == 1 then
                phase = 2
                target = p2
            else
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                if isLeft then autoLeftEnabled = false else autoRightEnabled = false end
                stopAutoPath(side)
                local facePos = _V3new(pFace.X, root.Position.Y, pFace.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
        end
        local mv = _V3new(target.X - root.Position.X, 0, target.Z - root.Position.Z).Unit
        hum:Move(mv, false)
        root.AssemblyLinearVelocity = _V3new(mv.X * NS, root.AssemblyLinearVelocity.Y, mv.Z * NS)
    end)
    if isLeft then alConn = conn else arConn = conn end
end

function stopAutoLeft() stopAutoPath("Left") end
function startAutoLeft() startAutoPath("Left") end
function stopAutoRight() stopAutoPath("Right") end
function startAutoRight() startAutoPath("Right") end

-- ============================================================================
-- COMBAT: AUTO BAT, BAT BYPASS V2, TP BAT, COUNTERS, DROP, INSTA RESET
-- ============================================================================
function isBatTool(tool)
    if not tool then return false end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        if tool.Name == name then return true end
    end
    local low = tool.Name:lower()
    return low:find("bat", 1, true) ~= nil or low:find("slap", 1, true) ~= nil
end

function findBat(autoEquip)
    local char = LP.Character
    if not char then return nil end
    for _, ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") and isBatTool(ch) then return ch end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and isBatTool(ch) then
                if autoEquip ~= false then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:EquipTool(ch) end) end
                end
                return ch
            end
        end
    end
    return nil
end

local function getClosestTarget(maxDist)
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    local rpos = root.Position
    local closestRoot, closestPlr, minDist = nil, nil, maxDist or _huge
    for _, plr in ipairs(_GetPlayersCached()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local d = (tRoot.Position - rpos).Magnitude
                if d < minDist then
                    minDist, closestRoot, closestPlr = d, tRoot, plr
                end
            end
        end
    end
    return closestRoot, closestPlr
end

function stopAimbotAdapt()
    safeDisconnect(_aimbotConn); _aimbotConn = nil
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (_prevAutoRotate == nil) and true or _prevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = _V3new(0, -0.1, 0)
        root.AssemblyAngularVelocity = _V3zero
    end
    _prevAutoRotate, lastMoveDir = nil, _V3zero
end

function disableAutoBat()
    autoBatEnabled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotAdapt()
end

function enableAutoBat()
    if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled = false; stopAutoRight() end
    if batDesyncTpEnabled then toggleBatDesyncTp() end
    if autoBatBypassEnabled then disableBatBypass() end
    autoBatEnabled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end

    if _aimbotConn then return end
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end
    _aimbotConn = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        if not char:FindFirstChildOfClass("Tool") then findBat(true) end
        local target = getClosestTarget()
        if not target then return end

        local targetVel = target.AssemblyLinearVelocity
        local myPos, targetPos = root.Position, target.Position
        local predictPos = targetPos + targetVel * 0.14 + target.CFrame.LookVector * 0.3
        local flatDir = _V3new(predictPos.X - myPos.X, 0, predictPos.Z - myPos.Z)
        flatDir = flatDir.Magnitude > 0 and flatDir.Unit or _V3zero

        local yVel = (targetPos.Y + 3.7 - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = _clamp(yVel, -70, 110)

        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(_V3new(flatDir.X * BAT_AIMBOT_SPEED, yVel, flatDir.Z * BAT_AIMBOT_SPEED), 0.8)
        local predictedPos = targetPos + targetVel * _clamp(targetVel.Magnitude / 150, 0.05, 0.2)
        if (predictedPos - myPos).Magnitude > 0.1 then
            local rx, ry, rz = (root.CFrame:Inverse() * _CFlookAt(myPos, predictedPos)):ToEulerAnglesXYZ()
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(_clamp(rx, -2.5, 2.5) * 42, _clamp(ry, -2.5, 2.5) * 42, _clamp(rz, -2.5, 2.5) * 42))
        end
        if (root.Position - targetPos).Magnitude <= 8 then
            local curTool = char:FindFirstChildOfClass("Tool")
            if not curTool or isBatTool(curTool) then
                local bat = findBat(true)
                if bat then pcall(function() bat:Activate() end) end
            end
        end
    end)
end

-- BAT BYPASS V2 (Motor de predicción aérea/ping limpio)
local BatBypass = {
    on = false,
    speed = tonumber(BAT_BYPASS_SPEED) or 60,
    hitDist = tonumber(BAT_BYPASS_HIT_DIST) or 13,
    predictAhead = 3,
    conn = nil,
    respawnConn = nil,
    pingToken = 0,
    sphere = nil,
}

do
    local C = {
        targetPlayer = nil, lastTargetPos = nil, targetVelocity = _V3zero, smoothedVelocity = _V3zero,
        velocityHistory = {}, accelerationHistory = {}, aerialVelocityHistory = {}, verticalVelocityHistory = {},
        pingHistory = {}, currentPing = 0.1, realPingMs = 0, airborneTime = 0, highYVelocityTime = 0,
        lastActivationTime = 0, lastDirectionChangeTime = 0, previousDirection = nil, lastYVelocity = 0,
        peakHeight = 0, groundHeight = 0, lastJumpTime = 0, aerialSmoothVelocity = _V3zero,
    }
    local CFG = {
        MIN_FOLLOW_DISTANCE = 1, PREDICTION_TIME = 0.22, ACTIVATION_DELAY = 0.2,
        AIRBORNE_THRESHOLD = 0.15, FLOAT_Y_THRESHOLD = 3, FALLING_THRESHOLD = -8, RISING_THRESHOLD = 8,
        VERTICAL_OFFSET_MULTIPLIER = 0.15, JUMPBOOST_Y_THRESHOLD = 35, EXTREME_JUMPBOOST_THRESHOLD = 50,
        JUMPBOOST_SUSTAINED_TIME = 0.15, MAX_VELOCITY_CHANGE = 150, VELOCITY_SMOOTHING = 0.2,
        MAX_HORIZONTAL_VELOCITY = 80, ERRATIC_MOVEMENT_THRESHOLD = 3, SERVER_TICKRATE = 1 / 60,
        PING_SAMPLE_SIZE = 10, MIN_PING_COMPENSATION = 0.03, MAX_PING_COMPENSATION = 0.25,
        ACCELERATION_PREDICTION_WEIGHT = 0.3, DIRECTION_CHANGE_DETECTION_TIME = 0.12, QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
        GRAVITY = 196.2, AIR_CONTROL_FACTOR = 0.8, AERIAL_VELOCITY_DECAY = 0.95,
        AERIAL_DIRECTION_CHANGE_WEIGHT = 0.6, MIN_AIRBORNE_TIME = 0.08, AERIAL_SMOOTHING = 0.15,
        STRAFE_DETECTION_THRESHOLD = 0.7, HIGH_JUMP_THRESHOLD = 20, FALLING_SPEED_THRESHOLD = -15,
        MULTI_JUMP_DETECTION_WINDOW = 0.2, UPWARD_VELOCITY_RESET_THRESHOLD = 10,
        VERTICAL_POSITION_LEAD = 2.5, FALLING_VERTICAL_LEAD = 3.5, SPHERE_SMOOTH_SPEED = 15,
    }

    local function resetState()
        C.targetPlayer, C.lastTargetPos, C.previousDirection = nil, nil, nil
        C.targetVelocity, C.smoothedVelocity, C.aerialSmoothVelocity = _V3zero, _V3zero, _V3zero
        C.velocityHistory, C.accelerationHistory, C.aerialVelocityHistory, C.verticalVelocityHistory = {}, {}, {}, {}
        C.airborneTime, C.highYVelocityTime, C.lastYVelocity, C.peakHeight, C.groundHeight, C.lastActivationTime = 0, 0, 0, 0, 0, 0
    end

    local function avgVec(list, flatOnly)
        if #list == 0 then return _V3zero end
        local sum = _V3zero
        for _, v in ipairs(list) do
            sum = sum + (flatOnly and _V3new(v.X, 0, v.Z) or v)
        end
        return sum / #list
    end

    local function avgNum(list)
        if #list == 0 then return 0 end
        local sum = 0
        for _, v in ipairs(list) do sum = sum + v end
        return sum / #list
    end

    local function pushCap(list, val, cap)
        table.insert(list, val)
        if #list > cap then table.remove(list, 1) end
    end

    local function createSphere()
        safeDestroy(BatBypass.sphere)
        local s = Instance.new("Part")
        s.Name, s.Shape, s.Size = "PredictionSphere", Enum.PartType.Ball, _V3new(2, 2, 2)
        s.Anchored, s.CanCollide, s.Material, s.Transparency = true, false, Enum.Material.Neon, 0.4
        local accent = getThemeColor()
        s.Color = accent
        local light = Instance.new("PointLight", s)
        light.Color, light.Range, light.Brightness = accent, 8, 2
        local outline = Instance.new("Highlight", s)
        outline.FillTransparency, outline.OutlineColor, outline.OutlineTransparency = 1, accent, 0
        s.Parent = Workspace
        BatBypass.sphere = s
        updateBatBypassSphereTheme = function(col)
            if not s.Parent then return end
            local c = col or getThemeColor()
            s.Color, light.Color, outline.OutlineColor = c, c, c
        end
    end

    local function predictAerial(pos, vel, dt, isStrafing, isFastFalling, isMultiJump)
        local horizVel = (isStrafing and avgVec(C.aerialVelocityHistory, true) or _V3new(vel.X, 0, vel.Z)) * CFG.AIR_CONTROL_FACTOR * CFG.AERIAL_VELOCITY_DECAY
        local vertVel = vel.Y
        local g = CFG.GRAVITY
        if isMultiJump then g = g * 0.3; vertVel = vertVel * 0.9 end
        local dy = isFastFalling and ((vertVel * dt) - (0.5 * g * 1.2 * dt * dt) - (CFG.FALLING_VERTICAL_LEAD * dt))
            or ((vertVel * dt) - (0.5 * g * dt * dt))
        if vertVel > CFG.RISING_THRESHOLD and not isMultiJump then dy = dy + (CFG.VERTICAL_POSITION_LEAD * dt) end
        return pos + horizVel * dt + _V3new(0, dy, 0)
    end

    local function startBypassLoop(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        hum.AutoRotate = false
        if not char:FindFirstChildOfClass("Tool") then findBat(true) end
        if not BatBypass.sphere then createSphere() end
        safeDisconnect(BatBypass.conn)

        BatBypass.conn = RunService.RenderStepped:Connect(function(dt)
            if not BatBypass.on or hum.Health <= 0 or hum.PlatformStand then return end
            local _, nearestPlr = getClosestTarget()
            C.targetPlayer = nearestPlr
            local targetRoot = nearestPlr and nearestPlr.Character and nearestPlr.Character:FindFirstChild("HumanoidRootPart")
            if not targetRoot then resetState(); return end

            local targetPos, myPos = targetRoot.Position, root.Position
            if C.lastTargetPos then
                local rawVel = (targetPos - C.lastTargetPos) / dt
                local dv = rawVel - C.targetVelocity
                if dv.Magnitude > CFG.MAX_VELOCITY_CHANGE then rawVel = C.targetVelocity + dv.Unit * CFG.MAX_VELOCITY_CHANGE end
                local hVel = _V3new(rawVel.X, 0, rawVel.Z)
                if hVel.Magnitude > CFG.MAX_HORIZONTAL_VELOCITY then
                    hVel = hVel.Unit * CFG.MAX_HORIZONTAL_VELOCITY
                    rawVel = _V3new(hVel.X, rawVel.Y, hVel.Z)
                end
                pushCap(C.accelerationHistory, (rawVel - C.targetVelocity) / dt, 4)
                pushCap(C.verticalVelocityHistory, rawVel.Y, 5)
                C.targetVelocity = rawVel
                C.smoothedVelocity = C.smoothedVelocity:Lerp(rawVel, CFG.VELOCITY_SMOOTHING)
                pushCap(C.velocityHistory, rawVel, 8)
            end
            C.lastTargetPos = targetPos
            C.highYVelocityTime = math.abs(C.targetVelocity.Y) > CFG.JUMPBOOST_Y_THRESHOLD and (C.highYVelocityTime + dt) or 0

            local rp = _RayParams_new()
            rp.FilterType = Enum.RaycastFilterType.Exclude
            rp.FilterDescendantsInstances = { nearestPlr.Character, char }
            local groundRay = Workspace:Raycast(targetRoot.Position, _V3new(0, -100, 0), rp)
            if groundRay then C.groundHeight = groundRay.Position.Y end
            local isAirborne = not groundRay
            if isAirborne then
                C.airborneTime = C.airborneTime + dt
                if targetPos.Y > C.peakHeight then C.peakHeight = targetPos.Y end
                if C.airborneTime >= CFG.MIN_AIRBORNE_TIME then
                    pushCap(C.aerialVelocityHistory, C.targetVelocity, 6)
                    C.aerialSmoothVelocity = C.aerialSmoothVelocity:Lerp(C.targetVelocity, CFG.AERIAL_SMOOTHING)
                end
            else
                C.airborneTime, C.peakHeight = 0, 0
                C.aerialVelocityHistory, C.aerialSmoothVelocity = {}, _V3zero
            end

            -- Clasificación de movimiento
            local yc, changes, dc = 0, 0, 0
            for i = 2, #C.velocityHistory do
                local v1, v2 = C.velocityHistory[i - 1], C.velocityHistory[i]
                if math.abs(v2.Y - v1.Y) > 15 then yc = yc + 1 end
                local h1, h2 = _V3new(v1.X, 0, v1.Z), _V3new(v2.X, 0, v2.Z)
                if h1.Magnitude > 5 and h2.Magnitude > 5 and h1.Unit:Dot(h2.Unit) < 0.3 then changes = changes + 1 end
            end
            for i = 2, #C.aerialVelocityHistory do
                local h1 = _V3new(C.aerialVelocityHistory[i - 1].X, 0, C.aerialVelocityHistory[i - 1].Z)
                local h2 = _V3new(C.aerialVelocityHistory[i].X, 0, C.aerialVelocityHistory[i].Z)
                if h1.Magnitude > 3 and h2.Magnitude > 3 and h1.Unit:Dot(h2.Unit) < CFG.STRAFE_DETECTION_THRESHOLD then dc = dc + 1 end
            end

            local isInfJump, isErratic, isStrafing = yc >= 2, changes >= CFG.ERRATIC_MOVEMENT_THRESHOLD, dc >= 2
            local isFloater = C.airborneTime > CFG.AIRBORNE_THRESHOLD and math.abs(C.targetVelocity.Y) > CFG.FLOAT_Y_THRESHOLD
            local isJumpBoost = math.abs(C.targetVelocity.Y) > CFG.JUMPBOOST_Y_THRESHOLD and C.highYVelocityTime > CFG.JUMPBOOST_SUSTAINED_TIME
            local isExtremeBoost = math.abs(C.targetVelocity.Y) > CFG.EXTREME_JUMPBOOST_THRESHOLD
            local isTrulyAirborne = isAirborne and C.airborneTime >= CFG.MIN_AIRBORNE_TIME
            local isFastFalling = (targetPos.Y - C.groundHeight > CFG.HIGH_JUMP_THRESHOLD) and C.targetVelocity.Y < CFG.FALLING_SPEED_THRESHOLD

            local isMultiJump = false
            if C.lastYVelocity < -5 and C.targetVelocity.Y > CFG.UPWARD_VELOCITY_RESET_THRESHOLD then
                C.lastJumpTime, isMultiJump = _tick(), true
            end
            C.lastYVelocity = C.targetVelocity.Y

            local isQuickTurn = false
            local horizCur = _V3new(C.targetVelocity.X, 0, C.targetVelocity.Z)
            if horizCur.Magnitude >= 5 then
                if C.previousDirection and C.previousDirection:Dot(horizCur.Unit) < 0.5 then
                    local t = _tick()
                    if t - C.lastDirectionChangeTime < CFG.DIRECTION_CHANGE_DETECTION_TIME then isQuickTurn = true end
                    C.lastDirectionChangeTime = t
                end
                C.previousDirection = horizCur.Unit
            end

            local avgVel, avgAccel, avgYVel = avgVec(C.velocityHistory), avgVec(C.accelerationHistory), avgNum(C.verticalVelocityHistory)
            local predVel, predAccel, useCurrentPos = C.targetVelocity, avgAccel, false

            if isExtremeBoost then
                useCurrentPos, predVel, predAccel = true, _V3new(avgVel.X, 0, avgVel.Z), _V3zero
            elseif isJumpBoost then
                predVel = _V3new(avgVel.X, C.targetVelocity.Y * 0.15, avgVel.Z)
                predAccel = _V3new(avgAccel.X, 0, avgAccel.Z)
            elseif isInfJump or isFloater then
                predVel = _V3new(avgVel.X, C.targetVelocity.Y * 0.5, avgVel.Z)
                predAccel = _V3new(avgAccel.X * 0.5, 0, avgAccel.Z * 0.5)
            elseif isTrulyAirborne and isStrafing then
                local avgAerial = avgVec(C.aerialVelocityHistory, true)
                local w = CFG.AERIAL_DIRECTION_CHANGE_WEIGHT
                predVel = _V3new(C.aerialSmoothVelocity.X * w + avgAerial.X * (1 - w), avgYVel, C.aerialSmoothVelocity.Z * w + avgAerial.Z * (1 - w))
                predAccel = _V3new(avgAccel.X * 0.3, 0, avgAccel.Z * 0.3)
            elseif isTrulyAirborne then
                predVel, predAccel = _V3new(C.aerialSmoothVelocity.X, avgYVel, C.aerialSmoothVelocity.Z), _V3zero
            elseif isErratic then
                predVel = _V3new(C.smoothedVelocity.X, C.targetVelocity.Y, C.smoothedVelocity.Z)
                predAccel = _V3new(avgAccel.X * 0.7, 0, avgAccel.Z * 0.7)
            end

            local serverDelay = C.currentPing + CFG.SERVER_TICKRATE
            if isQuickTurn then serverDelay = serverDelay * CFG.QUICK_DIRECTION_CHANGE_MULTIPLIER end
            local serverPos = useCurrentPos and targetPos or (isTrulyAirborne and predictAerial(targetPos, predVel, serverDelay, isStrafing, isFastFalling, isMultiJump)
                or (targetPos + predVel * serverDelay + (predAccel.Magnitude > 1 and (predAccel * CFG.ACCELERATION_PREDICTION_WEIGHT) * (serverDelay * serverDelay * 0.5) or _V3zero)))

            local predTime = CFG.PREDICTION_TIME * 1.1
            if isErratic then predTime = predTime * 0.6
            elseif isQuickTurn then predTime = predTime * 1.2
            elseif isTrulyAirborne then predTime = predTime * (isStrafing and 0.7 or (isFastFalling and 1.3 or 0.85)) end

            local predictedPos = isTrulyAirborne and predictAerial(serverPos, predVel, predTime, isStrafing, isFastFalling, isMultiJump) or (serverPos + predVel * predTime)
            if not isTrulyAirborne and not isExtremeBoost and not isJumpBoost and not isInfJump then
                if C.targetVelocity.Y < CFG.FALLING_THRESHOLD or C.targetVelocity.Y > CFG.RISING_THRESHOLD then
                    predictedPos = predictedPos + _V3new(0, C.targetVelocity.Y * CFG.VERTICAL_OFFSET_MULTIPLIER, 0)
                end
            end

            local hPred = _V3new(predVel.X, 0, predVel.Z)
            local interceptPoint = predictedPos + ((hPred.Magnitude > 1 and not useCurrentPos) and (hPred.Unit * BatBypass.predictAhead) or _V3zero)
            if BatBypass.sphere then
                BatBypass.sphere.CFrame = BatBypass.sphere.CFrame:Lerp(_CFnew(interceptPoint), math.min(1, dt * CFG.SPHERE_SMOOTH_SPEED))
            end

            local toTarget = interceptPoint - myPos
            if toTarget.Magnitude >= 0.01 then
                local axis = root.CFrame.LookVector:Cross(toTarget.Unit)
                if axis.Magnitude > 0.01 then
                    root.AssemblyAngularVelocity = axis.Unit * math.asin(_clamp(axis.Magnitude, -1, 1)) * 80
                else
                    root.AssemblyAngularVelocity = _V3zero
                end
            end

            if (targetPos - myPos).Magnitude <= BatBypass.hitDist and (_tick() - C.lastActivationTime) >= 0.3 then
                interceptPoint = (useCurrentPos or (isErratic and not isTrulyAirborne)) and serverPos
                    or (isTrulyAirborne and predictAerial(serverPos, predVel, CFG.ACTIVATION_DELAY, isStrafing, isFastFalling, isMultiJump) or (serverPos + predVel * CFG.ACTIVATION_DELAY))
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
                C.lastActivationTime = _tick()
            end

            local dir = interceptPoint - myPos
            if dir.Magnitude > CFG.MIN_FOLLOW_DISTANCE then
                root.AssemblyLinearVelocity = dir.Unit * _clamp(BatBypass.speed, 1, 120)
            else
                root.AssemblyLinearVelocity = _V3new(0, root.AssemblyLinearVelocity.Y * 0.5, 0)
            end
        end)
    end

    function startV2()
        if BatBypass.on then return end
        BatBypass.on = true
        BatBypass.pingToken = BatBypass.pingToken + 1
        local tok = BatBypass.pingToken
        task.spawn(function()
            while tok == BatBypass.pingToken do
                pcall(function()
                    local val = LP:GetNetworkPing() * 1000
                    if type(val) == "number" and val > 0 then C.realPingMs = val end
                end)
                pushCap(C.pingHistory, C.realPingMs / 1000, CFG.PING_SAMPLE_SIZE)
                C.currentPing = _clamp(avgNum(C.pingHistory), CFG.MIN_PING_COMPENSATION, CFG.MAX_PING_COMPENSATION)
                task.wait(0.5)
            end
        end)
        if LP.Character then startBypassLoop(LP.Character) end
        safeDisconnect(BatBypass.respawnConn)
        BatBypass.respawnConn = LP.CharacterAdded:Connect(function(ch)
            task.wait(0.5)
            if BatBypass.on then startBypassLoop(ch) end
        end)
    end

    function stopV2()
        if not BatBypass.on then return end
        BatBypass.on = false
        BatBypass.pingToken = BatBypass.pingToken + 1
        safeDisconnect(BatBypass.respawnConn); BatBypass.respawnConn = nil
        safeDisconnect(BatBypass.conn); BatBypass.conn = nil
        safeDestroy(BatBypass.sphere); BatBypass.sphere = nil
        updateBatBypassSphereTheme = nil
        resetState()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum then hum.AutoRotate = true end
        if root then root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.25; root.AssemblyAngularVelocity = _V3zero end
    end
end

function enableBatBypass()
    if autoBatBypassEnabled then return end
    if autoBatEnabled then disableAutoBat() end
    if batDesyncTpEnabled then toggleBatDesyncTp() end
    if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled = false; stopAutoRight() end
    BatBypass.speed = tonumber(BAT_BYPASS_SPEED) or 60
    BatBypass.hitDist = tonumber(BAT_BYPASS_HIT_DIST) or 13
    autoBatBypassEnabled = true
    startV2()
    if autoBatBypassSetVisual then autoBatBypassSetVisual(true) end
    if batBypassFloatingButton then paintFloatingBtn(batBypassFloatingButton:FindFirstChild("Frame"), true) end
end

function disableBatBypass()
    autoBatBypassEnabled = false
    stopV2()
    if autoBatBypassSetVisual then autoBatBypassSetVisual(false) end
    if batBypassFloatingButton then paintFloatingBtn(batBypassFloatingButton:FindFirstChild("Frame"), false) end
end

function toggleBatBypass()
    if autoBatBypassEnabled then disableBatBypass() else enableBatBypass() end
end

-- TP BAT
batDesyncTpEnabled = false
local batDesyncTpConn, hittingCooldownDesync, tpbCharConn = nil, false, nil
local TPBAT_CFG = { range = 850, loopDelay = 0.05, autoBat = true, autoBatDelay = 0.12, cameraLock = true, heightOffset = 0.9 }
if _G.STRIKE_TP_CAMLOCK ~= nil then TPBAT_CFG.cameraLock = _G.STRIKE_TP_CAMLOCK == true end

local function tpbRecoverRagdoll()
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        hum.PlatformStand, hum.Sit, hum.AutoRotate = false, false, true
        local st = hum:GetState()
        if isRagdollType(st) or st == Enum.HumanoidStateType.PlatformStanding then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

local function tpbStartLoops()
    if batDesyncTpConn then pcall(task.cancel, batDesyncTpConn) end
    batDesyncTpConn = task.spawn(function()
        while batDesyncTpEnabled do
            local target = getClosestTarget(TPBAT_CFG.range)
            local me = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if target and target.Parent and me and me.Parent then
                tpbRecoverRagdoll()
                pcall(function()
                    me.CFrame = _CFnew(target.Position + _V3new(0, TPBAT_CFG.heightOffset, 0))
                    me.AssemblyLinearVelocity = target.AssemblyLinearVelocity
                end)
                if hum then hum.PlatformStand, hum.Sit = false, false end
                if TPBAT_CFG.cameraLock then
                    pcall(function()
                        local cam = Workspace.CurrentCamera
                        if cam then cam.CFrame = _CFnew(cam.CFrame.Position, target.Position) end
                    end)
                end
                if TPBAT_CFG.autoBat and not hittingCooldownDesync then
                    hittingCooldownDesync = true
                    tpbRecoverRagdoll()
                    pcall(function()
                        local bat = findBat(true)
                        if not bat then return end
                        pcall(function() bat:Activate() end)
                        local handle = typeof(firetouchinterest) == "function" and bat:FindFirstChild("Handle")
                        if handle then
                            pcall(function() firetouchinterest(handle, target, 0); firetouchinterest(handle, target, 1) end)
                            local torso = target.Parent:FindFirstChild("UpperTorso") or target.Parent:FindFirstChild("Torso") or target.Parent:FindFirstChild("Head")
                            if torso then pcall(function() firetouchinterest(handle, torso, 0); firetouchinterest(handle, torso, 1) end) end
                        end
                    end)
                    task.delay(TPBAT_CFG.autoBatDelay, function() hittingCooldownDesync = false end)
                end
            end
            local isRag = hum and (hum.PlatformStand or hum.Sit or isRagdollType(hum:GetState()))
            task.wait(isRag and 0.03 or TPBAT_CFG.loopDelay)
        end
    end)
end

function startBatDesyncTp()
    if batDesyncTpEnabled and batDesyncTpConn then return end
    batDesyncTpEnabled = true
    tpbStartLoops()
    if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
    if tpBatFloatingButton then paintFloatingBtn(tpBatFloatingButton:FindFirstChild("Frame"), true) end
    if not tpbCharConn then
        tpbCharConn = LP.CharacterAdded:Connect(function()
            if not batDesyncTpEnabled then return end
            if batDesyncTpConn then pcall(task.cancel, batDesyncTpConn); batDesyncTpConn = nil end
            task.wait(0.5)
            if batDesyncTpEnabled then tpbStartLoops() end
        end)
    end
    saveAllSettings()
end

function stopBatDesyncTp()
    batDesyncTpEnabled, hittingCooldownDesync = false, false
    if batDesyncTpConn then pcall(task.cancel, batDesyncTpConn); batDesyncTpConn = nil end
    safeDisconnect(tpbCharConn); tpbCharConn = nil
    if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
    if tpBatFloatingButton then paintFloatingBtn(tpBatFloatingButton:FindFirstChild("Frame"), false) end
end

function toggleBatDesyncTp()
    if batDesyncTpEnabled then stopBatDesyncTp() else startBatDesyncTp() end
    saveAllSettings()
end

-- Bat Counter & Medusa Counter
local batCounterDebounce = false
function stopBatCounter()
    safeDisconnect(Conns.batCounter); Conns.batCounter = nil
    batCounterDebounce = false
end

function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled or batCounterDebounce then return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and isRagdollType(hum:GetState()) then
            batCounterDebounce = true
            task.spawn(function()
                task.wait(0.15)
                local bat = findBat(false)
                if bat and char.Parent then
                    if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end); task.wait(0.05) end
                    local remote = bat:FindFirstChildOfClass("RemoteEvent")
                    if remote then
                        pcall(function() remote:FireServer() end); task.wait(0.1); pcall(function() remote:FireServer() end)
                    else
                        pcall(function() bat:Activate() end); task.wait(0.1); pcall(function() bat:Activate() end)
                    end
                end
                task.wait(0.3)
                batCounterDebounce = false
            end)
        end
    end)
end

function stopMedusaCounter()
    for _, c in pairs(Conns.anchor) do safeDisconnect(c) end
    Conns.anchor = {}
end

local function useMedusaCounter()
    if medusaDebounce or (_tick() - medusaLastUsed < MEDUSA_COOLDOWN) then return end
    local char = LP.Character
    if not char then return end
    medusaDebounce = true
    local med = nil
    for _, container in ipairs({ char, LP:FindFirstChild("Backpack") }) do
        if container and not med then
            for _, t in ipairs(container:GetChildren()) do
                if t:IsA("Tool") then
                    local n = t.Name:lower()
                    if n:find("medusa", 1, true) or n:find("head", 1, true) or n:find("stone", 1, true) then med = t; break end
                end
            end
        end
    end
    if med then
        if med.Parent ~= char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:EquipTool(med) end
        end
        pcall(function() med:Activate() end)
        medusaLastUsed = _tick()
    end
    medusaDebounce = false
end

function setupMedusaCounter(char)
    stopMedusaCounter()
    if not char or not medusaCounterEnabled then return end
    local function watchPart(part)
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, part:GetPropertyChangedSignal("Anchored"):Connect(function()
                if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusaCounter() end
            end))
        end
    end
    for _, p in ipairs(char:GetDescendants()) do watchPart(p) end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(watchPart))
end

-- Drop Brainrot
local _dropConn = nil
function stopDropBrainrot()
    dropActive = false
    safeDisconnect(_dropConn); _dropConn = nil
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t) else safeDisconnect(t) end
    end
    dropConnections = {}
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity = _V3zero end
    if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
    if mobSetDropBR then mobSetDropBR(false) end
end

function runDropBrainrot()
    if dropActive then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    if dropMode == 1 then
        local vel = root.AssemblyLinearVelocity
        local cooldown = _V3new(vel.X, 0, vel.Z).Magnitude > 5 and 0.6 or 0.25
        if _tick() - lastDropTime < cooldown then return end
        lastDropTime, dropActive = _tick(), true
        if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
        if mobSetDropBR then mobSetDropBR(true) end
        local wasAutoBat = autoBatEnabled
        if wasAutoBat then disableAutoBat() end

        local function finishDrop()
            dropActive = false
            local c = LP.Character
            local r = c and c:FindFirstChild("HumanoidRootPart")
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if r then
                r.AssemblyLinearVelocity, r.AssemblyAngularVelocity = _V3zero, _V3zero
                if r.Position.Y < -100 then r.CFrame = _CFnew(r.Position.X, 5, r.Position.Z) end
                local rp = _RayParams_new()
                rp.FilterDescendantsInstances, rp.FilterType = { c }, Enum.RaycastFilterType.Exclude
                local rr = Workspace:Raycast(r.Position, _V3new(0, -2000, 0), rp)
                if rr then
                    local off = (h and h.HipHeight or 2) + (r.Size.Y / 2)
                    r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
                end
                if h and h.Health > 0 then h:ChangeState(Enum.HumanoidStateType.Running) end
            end
            if wasAutoBat then enableAutoBat() end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
        end

        local th = task.spawn(function()
            local t0 = _tick()
            while dropActive and (_tick() - t0) < 0.25 do
                RunService.Heartbeat:Wait()
                local r = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if not r then break end
                local v = _V3new(0, r.AssemblyLinearVelocity.Y, 0)
                r.AssemblyLinearVelocity = v * 10000 + _V3new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if r.Parent then r.AssemblyLinearVelocity = v end
                RunService.Stepped:Wait()
                if r.Parent then r.AssemblyLinearVelocity = v + _V3new(0, 0.1, 0) end
            end
            finishDrop()
        end)
        table.insert(dropConnections, th)
        task.delay(0.35, function() if dropActive then finishDrop() end end)
        return
    end

    dropActive = true
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(true) end
    local t0 = _tick()
    safeDisconnect(_dropConn)
    _dropConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r or not dropActive then
            stopDropBrainrot()
            return
        end
        if _tick() - t0 >= 0.22 then
            safeDisconnect(_dropConn); _dropConn = nil
            pcall(function()
                local rp = _RayParams_new()
                rp.FilterDescendantsInstances, rp.FilterType = { c }, Enum.RaycastFilterType.Exclude
                local rr = Workspace:Raycast(r.Position, _V3new(0, -3000, 0), rp)
                local h2 = c:FindFirstChildOfClass("Humanoid")
                if rr then
                    local off = (h2 and h2.HipHeight or 2) + (r.Size.Y / 2)
                    r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    r.AssemblyLinearVelocity, r.AssemblyAngularVelocity = _V3zero, _V3zero
                end
                if h2 and h2.Health > 0 then h2:ChangeState(Enum.HumanoidStateType.Running) end
            end)
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        local lv = r.AssemblyLinearVelocity
        r.AssemblyLinearVelocity = _V3new(lv.X, 160, lv.Z)
    end)
end

function executeDropWithToggle(setVisual)
    if dropActive then return end
    task.spawn(function()
        if setVisual then setVisual(true) end
        runDropBrainrot()
        while dropActive do task.wait() end
        task.wait(0.1)
        if setVisual then setVisual(false) end
    end)
end

-- Insta Reset
if not _G.InstaResetLoaded then
    _G.InstaResetLoaded = true
    local resetCooldown, resetThread, stopResetSequence, cameraLocked, lockedCamCF, lastReq = false, nil, false, false, nil, 0

    local function instaReset()
        local now = os.clock()
        if now - lastReq < 0.75 or resetCooldown then return end
        lastReq, resetCooldown, stopResetSequence = now, true, false
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then resetCooldown = false; return end
        local cam = Workspace.CurrentCamera
        if cam then lockedCamCF = cam.CFrame; cameraLocked = true; cam.CFrame = lockedCamCF end

        resetThread = task.spawn(function()
            local origHH = hum.HipHeight
            local okReset = false
            for _ = 1, 40 do
                if not char.Parent or hum.Health <= 0 or LP.Character ~= char or stopResetSequence then
                    okReset = true; break
                end
                pcall(function()
                    hum.HipHeight, hum.AutoRotate = 1e30, true
                    for _, part in ipairs(char:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end)
                task.wait(0.05)
            end
            if not okReset and char.Parent and hum.Health > 0 then
                pcall(function() hum.Health = 0 end)
                task.wait(0.1)
                okReset = (not char.Parent or hum.Health <= 0)
            end
            if not okReset and char.Parent and hum then
                pcall(function()
                    hum.HipHeight = origHH
                    for _, part in ipairs(char:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = true end
                    end
                end)
            end
            cameraLocked, resetCooldown, resetThread, stopResetSequence = false, false, nil, false
        end)
    end

    LP.CharacterAdded:Connect(function()
        stopResetSequence = true
        if resetThread then pcall(task.cancel, resetThread); resetThread = nil end
        resetCooldown, cameraLocked = false, false
    end)

    RunService.RenderStepped:Connect(function()
        local cam = Workspace.CurrentCamera
        if cameraLocked and lockedCamCF and cam then cam.CFrame = lockedCamCF end
    end)

    _G.InstaReset = { Trigger = instaReset }
end

-- ============================================================================
-- VISUALES DE ENTORNO: ANTI LAG, FOV, STRETCH REZ, SKY PRESETS
-- ============================================================================
local function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.Material, obj.Reflectance, obj.CastShadow = Enum.Material.Plastic, 0, false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            for _, t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
        end
    end)
end

function enableAntiLag()
    antiLagEnabled = true
    task.spawn(function()
        local descs = Workspace:GetDescendants()
        for i = 1, #descs do
            if not antiLagEnabled then break end
            applyAntiLagDerender(descs[i])
            if i % 200 == 0 then task.wait() end
        end
    end)
    safeDisconnect(antiLagDescConn)
    antiLagDescConn = Workspace.DescendantAdded:Connect(function(obj)
        if antiLagEnabled then applyAntiLagDerender(obj) end
    end)
end

function disableAntiLag()
    antiLagEnabled = false
    safeDisconnect(antiLagDescConn); antiLagDescConn = nil
end

local CUSTOM_FOV_BIND = "StrikeCustomFOV"
function enableCustomFov()
    local cam = Workspace.CurrentCamera
    if cam and origFOV == nil then origFOV = cam.FieldOfView end
    fovEnabled = true
    if cam then
        pcall(function() cam.FieldOfViewMode = Enum.FieldOfViewMode.Diagonal end)
        pcall(function() cam.FieldOfView = fovValue end)
    end
    safeDisconnect(customFovConn); customFovConn = nil
    pcall(function() RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND) end)
    local prio = 200
    pcall(function() prio = Enum.RenderPriority.Camera.Value + 10 end)
    local ok = pcall(function()
        RunService:BindToRenderStep(CUSTOM_FOV_BIND, prio, function()
            if not fovEnabled then return end
            local c = Workspace.CurrentCamera
            if c and c.FieldOfView ~= fovValue then c.FieldOfView = fovValue end
        end)
    end)
    if not ok then
        customFovConn = RunService.RenderStepped:Connect(function()
            local c = Workspace.CurrentCamera
            if c and fovEnabled then c.FieldOfView = fovValue end
        end)
    end
end

function disableCustomFov()
    fovEnabled = false
    pcall(function() RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND) end)
    safeDisconnect(customFovConn); customFovConn = nil
    local cam = Workspace.CurrentCamera
    if cam then
        pcall(function() cam.FieldOfViewMode = Enum.FieldOfViewMode.Vertical end)
        pcall(function() cam.FieldOfView = origFOV or 70 end)
    end
end

function enableStretch()
    if stretchConn then return end
    stretchEnabled = true
    local cam = Workspace.CurrentCamera
    if not cam then return end
    origFOV = origFOV or cam.FieldOfView or 70
    pcall(function() cam.FieldOfView = stretchFOV end)
    stretchConn = RunService.RenderStepped:Connect(function()
        if not stretchEnabled then safeDisconnect(stretchConn); stretchConn = nil; return end
        local c = Workspace.CurrentCamera
        if c then c.CFrame = c.CFrame * _CFnew(0, 0, 0, 1, 0, 0, 0, 0.7, 0, 0, 0, 1) end
    end)
    safeDisconnect(stretchFovConn)
    stretchFovConn = RunService.RenderStepped:Connect(function()
        if not stretchEnabled then safeDisconnect(stretchFovConn); stretchFovConn = nil; return end
        local c = Workspace.CurrentCamera
        if c then pcall(function() c.FieldOfView = stretchFOV end) end
    end)
end

function disableStretch()
    stretchEnabled = false
    safeDisconnect(stretchConn); stretchConn = nil
    safeDisconnect(stretchFovConn); stretchFovConn = nil
    local cam = Workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = origFOV or 70 end) end
end

SKY_PRESETS_LIST = { "Off", "Night", "Aurora", "Sunset", "Galaxy", "Cyber", "Sakura", "Pink Night", "Blood Moon", "Emerald Dawn", "Volcanic", "Arctic", "Midnight Ocean", "Vaporwave", "Toxic", "Solar Eclipse", "Hellscape", "Heaven", "Storm", "Sunrise", "Deep Space", "Lavender Dream", "Inferno", "Mint Sky" }
SKY_PRESETS = {
    ["Off"] = { kind = "off" },
    ["Night"] = { clock = 22, brightness = 2, ambient = {110,100,130}, outAmb = {120,110,140}, sky = { stars = 4000, moon = 18, sun = 0, moonTex = true }, atm = { dens = 0.45, color = {120,60,180}, decay = {60,20,100}, glare = 0.5, haze = 1.2 } },
    ["Aurora"] = { clock = 14, brightness = 3, ambient = {150,120,150}, outAmb = {160,130,150}, atm = { dens = 0.55, color = {255,80,200}, decay = {255,20,150}, glare = 2.5, haze = 3 }, clouds = { cover = 0.7, dens = 0.7, color = {255,240,250} } },
    ["Sunset"] = { clock = 17.2, brightness = 2.5, ambient = {170,120,100}, outAmb = {180,130,110}, sky = { stars = 0, sun = 25, moon = 0 }, atm = { dens = 0.5, color = {255,130,60}, decay = {255,80,30}, glare = 2, haze = 2.5 }, clouds = { cover = 0.55, dens = 0.55, color = {255,200,140} } },
    ["Galaxy"] = { clock = 0, brightness = 1.5, ambient = {70,60,100}, outAmb = {80,70,110}, sky = { stars = 10000, moon = 30, sun = 0 }, atm = { dens = 0.15, color = {40,20,80}, decay = {20,10,50}, glare = 0.3, haze = 0.5 } },
    ["Cyber"] = { clock = 21, brightness = 2.2, ambient = {90,130,170}, outAmb = {100,140,180}, sky = { stars = 2000, moon = 12 }, atm = { dens = 0.4, color = {0,200,255}, decay = {150,0,255}, glare = 2, haze = 2 }, clouds = { cover = 0.4, dens = 0.6, color = {100,200,255} } },
    ["Sakura"] = { clock = 11, brightness = 3.5, ambient = {170,150,160}, outAmb = {180,160,170}, sky = { sun = 8 }, atm = { dens = 0.3, color = {255,200,220}, decay = {255,170,200}, glare = 1, haze = 1.5 }, clouds = { cover = 0.6, dens = 0.4, color = {255,250,252} } },
    ["Pink Night"] = { clock = 23, brightness = 2.2, ambient = {120,60,110}, outAmb = {140,70,120}, sky = { stars = 5000, moon = 22, sun = 0, moonTex = true }, atm = { dens = 0.5, color = {255,80,180}, decay = {140,30,100}, glare = 0.7, haze = 1.4 }, clouds = { cover = 0.3, dens = 0.5, color = {180,90,150} } },
    ["Blood Moon"] = { clock = 22.5, brightness = 1.6, ambient = {130,40,40}, outAmb = {150,50,50}, sky = { stars = 1500, moon = 28, sun = 0, moonTex = true }, atm = { dens = 0.6, color = {220,30,30}, decay = {120,10,10}, glare = 1.4, haze = 2 }, clouds = { cover = 0.5, dens = 0.7, color = {120,30,30} } },
    ["Emerald Dawn"] = { clock = 6.5, brightness = 2.8, ambient = {130,170,140}, outAmb = {140,180,150}, sky = { sun = 18, moon = 0, stars = 0 }, atm = { dens = 0.4, color = {80,200,140}, decay = {40,150,90}, glare = 1.8, haze = 2.2 }, clouds = { cover = 0.5, dens = 0.5, color = {200,255,220} } },
    ["Volcanic"] = { clock = 19, brightness = 2, ambient = {180,80,40}, outAmb = {200,90,50}, sky = { stars = 200, sun = 12, moon = 0 }, atm = { dens = 0.75, color = {255,60,0}, decay = {180,20,0}, glare = 3, haze = 3.5 }, clouds = { cover = 0.8, dens = 0.9, color = {120,40,20} } },
    ["Arctic"] = { clock = 9, brightness = 3.2, ambient = {200,220,235}, outAmb = {210,230,245}, sky = { sun = 10, stars = 0, moon = 0 }, atm = { dens = 0.3, color = {180,220,255}, decay = {140,200,240}, glare = 1.5, haze = 1.8 }, clouds = { cover = 0.7, dens = 0.6, color = {250,253,255} } },
    ["Midnight Ocean"] = { clock = 1.5, brightness = 1.7, ambient = {60,90,130}, outAmb = {70,100,140}, sky = { stars = 6000, moon = 24, sun = 0, moonTex = true }, atm = { dens = 0.5, color = {20,60,140}, decay = {10,30,90}, glare = 0.6, haze = 1.5 } },
    ["Vaporwave"] = { clock = 19.5, brightness = 2.4, ambient = {180,120,200}, outAmb = {190,130,210}, sky = { stars = 1000, moon = 14 }, atm = { dens = 0.45, color = {255,100,220}, decay = {120,60,255}, glare = 2.2, haze = 2.4 }, clouds = { cover = 0.55, dens = 0.55, color = {200,150,255} } },
    ["Toxic"] = { clock = 13, brightness = 2.5, ambient = {140,180,80}, outAmb = {150,190,90}, atm = { dens = 0.55, color = {100,220,40}, decay = {60,150,20}, glare = 1.8, haze = 2.6 }, clouds = { cover = 0.65, dens = 0.7, color = {180,255,120} } },
    ["Solar Eclipse"] = { clock = 12, brightness = 0.9, ambient = {50,40,60}, outAmb = {60,50,70}, sky = { stars = 3500, sun = 22, moon = 0 }, atm = { dens = 0.5, color = {255,140,40}, decay = {30,20,40}, glare = 2.8, haze = 1.8 } },
    ["Hellscape"] = { clock = 18, brightness = 1.8, ambient = {200,60,30}, outAmb = {220,70,40}, sky = { stars = 100, sun = 30, moon = 0 }, atm = { dens = 0.85, color = {255,30,0}, decay = {120,0,0}, glare = 3.5, haze = 4 }, clouds = { cover = 0.95, dens = 0.95, color = {80,20,10} } },
    ["Heaven"] = { clock = 12, brightness = 4, ambient = {240,235,210}, outAmb = {250,245,220}, sky = { sun = 16, moon = 0, stars = 0 }, atm = { dens = 0.25, color = {255,250,220}, decay = {255,240,200}, glare = 3, haze = 1.5 }, clouds = { cover = 0.85, dens = 0.5, color = {255,255,255} } },
    ["Storm"] = { clock = 15, brightness = 1.4, ambient = {90,90,110}, outAmb = {100,100,120}, sky = { stars = 0, sun = 6, moon = 0 }, atm = { dens = 0.65, color = {80,90,120}, decay = {40,50,80}, glare = 0.5, haze = 3 }, clouds = { cover = 0.95, dens = 0.95, color = {60,65,80} } },
    ["Sunrise"] = { clock = 6.2, brightness = 2.8, ambient = {220,180,130}, outAmb = {230,190,140}, sky = { sun = 22, stars = 0, moon = 0 }, atm = { dens = 0.45, color = {255,180,100}, decay = {255,140,80}, glare = 2.4, haze = 2.2 }, clouds = { cover = 0.4, dens = 0.4, color = {255,220,180} } },
    ["Deep Space"] = { clock = 0, brightness = 1, ambient = {30,25,50}, outAmb = {40,35,60}, sky = { stars = 15000, moon = 0, sun = 0 }, atm = { dens = 0.08, color = {15,5,40}, decay = {5,0,20}, glare = 0.2, haze = 0.3 } },
    ["Lavender Dream"] = { clock = 18.5, brightness = 2.6, ambient = {180,160,220}, outAmb = {190,170,230}, sky = { stars = 800, moon = 16, sun = 0 }, atm = { dens = 0.4, color = {200,160,255}, decay = {160,120,220}, glare = 1.4, haze = 1.8 }, clouds = { cover = 0.55, dens = 0.5, color = {220,200,255} } },
    ["Inferno"] = { clock = 17.5, brightness = 2.2, ambient = {220,100,40}, outAmb = {235,110,50}, sky = { sun = 26, moon = 0, stars = 0 }, atm = { dens = 0.6, color = {255,90,20}, decay = {200,40,0}, glare = 3, haze = 3.2 }, clouds = { cover = 0.7, dens = 0.7, color = {200,80,40} } },
    ["Mint Sky"] = { clock = 10, brightness = 3.2, ambient = {180,230,210}, outAmb = {190,240,220}, sky = { sun = 10 }, atm = { dens = 0.32, color = {150,255,210}, decay = {100,220,180}, glare = 1.6, haze = 1.6 }, clouds = { cover = 0.55, dens = 0.45, color = {240,255,250} } },
}

local function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end

function applyCustomSky(mode)
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute("_AdaptDuelsSky") then safeDestroy(child) end
    end
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute("_AdaptDuelsSky") then safeDestroy(child) end
        end
    end
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime, Lighting.Brightness, Lighting.FogEnd, Lighting.GlobalShadows = 14, 2, 100000, true
        Lighting.OutdoorAmbient, Lighting.Ambient = Color3.fromRGB(127, 127, 127), Color3.fromRGB(127, 127, 127)
        skyTheme = "Off"
        return
    end
    Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor = 0, 100000, Color3.fromRGB(200, 200, 200)
    Lighting.ColorShift_Top, Lighting.ColorShift_Bottom = Color3.new(0, 0, 0), Color3.new(0, 0, 0)
    Lighting.GlobalShadows, Lighting.ClockTime, Lighting.Brightness = true, preset.clock or 14, preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
    if preset.sky then
        local skyInst = Instance.new("Sky", Lighting)
        skyInst:SetAttribute("_AdaptDuelsSky", true)
        if preset.sky.stars then skyInst.StarCount = preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end
    end
    if preset.atm then
        local atm = Instance.new("Atmosphere", Lighting)
        atm:SetAttribute("_AdaptDuelsSky", true)
        atm.Density, atm.Color, atm.Decay = preset.atm.dens or 0.3, _vC3(preset.atm.color), _vC3(preset.atm.decay)
        atm.Glare, atm.Haze = preset.atm.glare or 1, preset.atm.haze or 1
    end
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds", terrain)
        clouds:SetAttribute("_AdaptDuelsSky", true)
        clouds.Cover, clouds.Density, clouds.Color = preset.clouds.cover or 0.5, preset.clouds.dens or 0.5, _vC3(preset.clouds.color)
    end
    skyTheme = mode
end

-- ============================================================================
-- UTILIDADES DE UI FLOTANTE, MOVIMIENTO Y LIMPIEZA
-- ============================================================================
do
    local INTRO_SONG_ORDER = {
        "Off", "Song 1", "Song 2", "Song 3", "Song 4", "Song 5", "Song 6", "Song 7",
        "Song 8", "Song 9", "Song 10", "Song 11", "Song 12", "Song 13", "Song 14",
    }
    local INTRO_SONGS = {
        ["Song 1"]  = { url = "https://files.catbox.moe/2eysnf.mp3", file = "StrikeIntroSong_2eysnf.mp3" },
        ["Song 2"]  = { url = "https://files.catbox.moe/rcgr9f.mp3", file = "StrikeIntroSong_rcgr9f.mp3" },
        ["Song 3"]  = { url = "https://files.catbox.moe/18dpz9.mp3", file = "StrikeIntroSong_18dpz9.mp3" },
        ["Song 4"]  = { url = "https://files.catbox.moe/2obj4i.mp3", file = "StrikeIntroSong_2obj4i.mp3" },
        ["Song 5"]  = { url = "https://files.catbox.moe/dqcahr.mp3", file = "StrikeIntroSong_dqcahr.mp3" },
        ["Song 6"]  = { url = "https://files.catbox.moe/pza10u.mp3", file = "StrikeIntroSong_pza10u.mp3" },
        ["Song 7"]  = { url = "https://files.catbox.moe/ul7tt5.mp3", file = "StrikeIntroSong_ul7tt5.mp3" },
        ["Song 8"]  = { url = "https://files.catbox.moe/fhwgff.mp3", file = "StrikeIntroSong_fhwgff.mp3" },
        ["Song 9"]  = { url = "https://files.catbox.moe/kq5dc7.mp3", file = "StrikeIntroSong_kq5dc7.mp3" },
        ["Song 10"] = { url = "https://files.catbox.moe/9tcnu0.mp3", file = "StrikeIntroSong_9tcnu0.mp3" },
        ["Song 11"] = { url = "https://files.catbox.moe/k3loa6.mp3", file = "StrikeIntroSong_k3loa6.mp3" },
        ["Song 12"] = { url = "https://files.catbox.moe/fri8xn.mp3", file = "StrikeIntroSong_fri8xn.mp3" },
        ["Song 13"] = { url = "https://files.catbox.moe/d3krby.mp3", file = "StrikeIntroSong_d3krby.mp3" },
        ["Song 14"] = { url = "https://files.catbox.moe/pvx0up.mp3", file = "StrikeIntroSong_pvx0up.mp3" },
    }
    local INTRO_SONG = "Song 1"
    local introSongSelectorLabel = nil
    local strikeIntroGui, strikeIntroSound, strikeIntroFinished = nil, nil, false
    local _strikeIntroSongRequest = 0

    BTN_ACTIVE_COLOR = Color3.fromRGB(255, 255, 255)
    function paintFloatingBtn(btnFrame, active)
        if not btnFrame then return end
        local activeCol = (getThemeColor and getThemeColor()) or BTN_ACTIVE_COLOR
        local bg = btnFrame:FindFirstChild("BtnGrad")
        local label = btnFrame:FindFirstChild("TextLabel")
        local stroke = btnFrame:FindFirstChildOfClass("UIStroke")
        btnFrame.BackgroundColor3 = active and activeCol or Color3.new(0, 0, 0)
        if bg then
            local c = active and activeCol or Color3.new(0, 0, 0)
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, c),
                ColorSequenceKeypoint.new(0.5, c),
                ColorSequenceKeypoint.new(1, c),
            })
        end
        if label then
            label.TextColor3 = active and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
        end
        if stroke then
            stroke.Color = active and activeCol or Color3.fromRGB(55, 55, 60)
            stroke.Thickness = active and 1.5 or 1
            stroke.Transparency = 0.15
        end
    end

    function applyFloatingButtonScale()
        for _, uiScale in ipairs(_floatingUIScales) do
            if uiScale and uiScale.Parent then uiScale.Scale = floatingButtonScale end
        end
    end

    function setMobileButtonsHidden(state)
        mobileButtonsHidden = state and true or false
        if _mobilePanelContainer then _mobilePanelContainer.Visible = not mobileButtonsHidden end
        for _, g in ipairs({ tpBatFloatingButton, batBypassFloatingButton, instaResetFloatingButton }) do
            if g then pcall(function() g.Enabled = not mobileButtonsHidden end) end
        end
    end

    function getDefaultButtonPosition(btnName)
        local orderMap = { DropBR = 0, AutoLeft = 1, AutoBat = 2, AutoRight = 3, TpDown = 4, Carry = 5, Lagger1 = 6, Lagger2 = 7 }
        local order = orderMap[btnName] or 0
        return (order % 2) * 94, _floor(order / 2) * 104
    end

    function applyShimmerToText(obj, speed)
        speed = speed or 0.8
        local base = Color3.fromRGB(210, 210, 215)
        local mid = Color3.fromRGB(235, 235, 240)
        local grad = Instance.new("UIGradient", obj)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, base),
            ColorSequenceKeypoint.new(0.3, mid),
            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.7, mid),
            ColorSequenceKeypoint.new(1, base),
        })
        grad.Rotation = 45
        task.spawn(function()
            local t = 0
            while grad and grad.Parent do
                t = t + 0.02
                grad.Offset = Vector2.new(math.sin(t * speed) * 0.4, 0)
                task.wait(0.04)
            end
        end)
        return grad
    end

    function updateProgressBarVisibility()
        if pbFrame then pbFrame.Visible = CONFIG.AUTO_STEAL_ENABLED end
    end

    local function drag(f)
        local dn, ds, sp, di, endConn, movedThis = false, nil, nil, nil, nil, false
        local function stopDrag()
            local didMove = movedThis
            dn, di, movedThis = false, nil, false
            safeDisconnect(endConn); endConn = nil
            if didMove then
                if f == main then _menuHomePos = main.Position end
                pcall(saveAllSettings)
            end
        end
        f.InputBegan:Connect(function(i)
            if uiLocked or _isDraggingButton then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dn, ds, sp, movedThis = true, i.Position, f.Position, false
                safeDisconnect(endConn)
                endConn = i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then stopDrag() end
                end)
            end
        end)
        f.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then stopDrag() end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then stopDrag() end
        end)
        f.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
        end)
        UIS.InputChanged:Connect(function(i)
            if i ~= di or not dn then return end
            if uiLocked then stopDrag(); return end
            if _isDraggingButton or not ds or not sp then return end
            f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + (i.Position.X - ds.X), sp.Y.Scale, sp.Y.Offset + (i.Position.Y - ds.Y))
            movedThis = true
        end)
    end

    function setupMovementAndIndicators(char)
        safeDisconnect(steppedConn); steppedConn = nil
        safeDisconnect(movementLoop); movementLoop = nil

        local ccAcc = 0
        steppedConn = RunService.Heartbeat:Connect(function(dt)
            ccAcc = ccAcc + dt
            if ccAcc < 0.05 then return end
            ccAcc = 0
            for _, p in ipairs(_GetPlayersCached()) do
                if p ~= LP and p.Character then
                    for _, part in ipairs(p.Character:GetChildren()) do
                        if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                    end
                end
            end
        end)

        movementLoop = RunService.RenderStepped:Connect(function()
            local char2 = LP.Character
            if not char2 then return end
            local hum = char2:FindFirstChildOfClass("Humanoid")
            local hrp = char2:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then return end

            if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled and not autoBatBypassEnabled and not batDesyncTpEnabled then
                if _isRagdollState(hum) then
                    lastMoveDir = _V3zero
                else
                    local md = hum.MoveDirection
                    local dir = nil
                    if md.Magnitude > 0 then
                        lastMoveDir = md
                        dir = md
                    elseif lastMoveDir.Magnitude > 0 then
                        for key in pairs(MOVE_KEYS) do
                            if UIS:IsKeyDown(key) then dir = lastMoveDir; break end
                        end
                    end
                    _applyVelocitySpeed(dir, getActiveMoveSpeed(), hrp)
                end
            end

            if speedLabel then
                local v = hrp.AssemblyLinearVelocity
                local s = _sqrt(v.X * v.X + v.Z * v.Z)
                speedLabel.Text = "Speed: " .. string.format("%.1f", s < 0.05 and 0 or s)
            end
        end)

        setupSpeedIndicator(char)
        startEnemySpeed()
    end

    function toggleLockUI(state)
        uiLocked = (state == nil) and (not uiLocked) or (state == true)
        if setLockUIVisual then setLockUIVisual(uiLocked) end
    end

    function disableAllAimbots()
        if autoBatEnabled then disableAutoBat() end
        if batDesyncTpEnabled then stopBatDesyncTp() end
        if autoBatBypassEnabled then disableBatBypass() end
    end

    function stopAllBackgroundTasks()
        safeDisconnect(movementLoop); movementLoop = nil
        safeDisconnect(steppedConn); steppedConn = nil
        stopEnemySpeed()
        if stretchEnabled then disableStretch() end
        if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
        if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
        if antiDieEnabled then AntiDieModule.stop() end
        if antiFlingEnabled then AntiFlingModule.stop() end
        stopBatCounter(); stopMedusaCounter(); stopAutoSteal(); disableAutoBat()
        if batDesyncTpEnabled then stopBatDesyncTp() end
        if autoBatBypassEnabled then disableBatBypass() end
        stopAutoLeft(); stopAutoRight()
        if antiLagEnabled then disableAntiLag() end
        if espEnabled then toggleESP(false) end
        if dropActive then stopDropBrainrot() end
        dropActive, lastDropTime, medusaDebounce, medusaLastUsed = false, 0, false, 0
    end

    -- ========================================================================
    -- GUARDADO / CARGA / REINICIO DE CONFIGURACIÓN (Strike.json)
    -- ========================================================================
    local function encodeKB(entry)
        return { kb = entry.kb and entry.kb.Name, gp = entry.gp and entry.gp.Name }
    end

    local function decodeKB(entry, d)
        if not entry or type(d) ~= "table" then return end
        if d.kb and Enum.KeyCode[d.kb] then entry.kb = Enum.KeyCode[d.kb] end
        if d.gp and Enum.KeyCode[d.gp] then entry.gp = Enum.KeyCode[d.gp] end
    end

    local function serializePos(pos)
        return { XScale = pos.X.Scale, XOffset = pos.X.Offset, YScale = pos.Y.Scale, YOffset = pos.Y.Offset }
    end

    function buildConfigTable()
        local config = {
            spinSpeed = (_G.__STRIKE_SPIN and _G.__STRIKE_SPIN.speed) or 360,
            spinPower = (_G.__STRIKE_SPIN and _G.__STRIKE_SPIN.power) or 100,
            spinExpanded = (_G.__STRIKE_SPIN and _G.__STRIKE_SPIN.expanded) == true,
            spinActiveOnSteal = (_G.__STRIKE_SPIN and _G.__STRIKE_SPIN.activeOnSteal) == true,
            ultraModeEnabled = (_G.__STRIKE_ULTRA and _G.__STRIKE_ULTRA.on) == true,
            normalSpeed = NS,
            carrySpeed = CS,
            laggerSpeed1 = LAGGER_SPEED,
            laggerSpeed2 = LAGGER_CARRY_SPEED,
            stealRadius = CONFIG.STEAL_RANGE,
            antiRagdollMode = antiRagdollMode,
            infiniteJumpEnabled = InfiniteJump.enabled == true,
            infiniteJumpMode = InfiniteJump.mode == "manual" and "manual" or "hold",
            animPack = currentAnimPack or "OFF",
            packAnimation = currentPackAnimation or "OFF",
            antiDieEnabled = antiDieEnabled,
            antiFlingEnabled = antiFlingEnabled,
            autoSteal = CONFIG.AUTO_STEAL_ENABLED,
            medusaCounter = medusaCounterEnabled,
            batCounter = batCounterEnabled,
            laggerToggled = laggerToggled,
            laggerCarryToggled = laggerCarryToggled,
            autoBatEnabled = autoBatEnabled == true,
            autoLeftEnabled = autoLeftEnabled == true,
            autoRightEnabled = autoRightEnabled == true,
            carryMode = speedMode,
            batAimbotSpeed = BAT_AIMBOT_SPEED,
            batBypassSpeed = BAT_BYPASS_SPEED,
            dropMode = dropMode,
            stretchEnabled = stretchEnabled,
            stretchFOV = stretchFOV,
            fovEnabled = fovEnabled,
            fovValue = fovValue,
            uiScale = uiScaleValue,
            customToolSkins = {
                Bat = (_G.StrikeCustomToolSkins and _G.StrikeCustomToolSkins.Bat) or "None",
                Medusa = (_G.StrikeCustomToolSkins and _G.StrikeCustomToolSkins.Medusa) or "None",
            },
            displaySkin = (_G.StrikeDisplaySkinState and _G.StrikeDisplaySkinState.displaySkin) or "Off",
            espEnabled = espEnabled,
            espBoxEnabled = espBoxEnabled,
            espTrackerEnabled = espTrackerEnabled,
            ragdollCountdownEnabled = ragdollCountdownEnabled,
            antiTpEspEnabled = antiTpEspEnabled,
            antiLag = antiLagEnabled,
            showE01Warning = StrikeShowE01Warning == true,
            tpBatEnabled = batDesyncTpEnabled,
            tpBatCameraLock = TPBAT_CFG.cameraLock == true,
            skyTheme = skyTheme,
            autoBatBypassEnabled = autoBatBypassEnabled,
            mobileButtonPositions = savedButtonPositions,
            dropBrainrotKey = encodeKB(KB.DropBrainrot),
            autoLeftKey = encodeKB(KB.AutoLeft),
            autoRightKey = encodeKB(KB.AutoRight),
            autoBatKey = encodeKB(KB.AutoBat),
            tpFloorKey = encodeKB(KB.TPFloor),
            carryToggleKey = encodeKB(KB.CarryToggle),
            laggerModeKey = encodeKB(KB.LaggerMode),
            tpBatKey = encodeKB(KB.TPBat),
            batBypassKey = encodeKB(KB.BatBypass),
            carryKey = encodeKB(KB.Carry),
            laggerCarryKey = encodeKB(KB.LaggerCarry),
            instaResetKey = encodeKB(KB.InstaReset),
            tpBatFloatingPos = tpBatFloatingPos,
            batBypassFloatingPos = batBypassFloatingPos,
            instaResetFloatingPos = instaResetFloatingPos,
            progressBarPos = savedProgressBarPos,
            lockUI = uiLocked,
            backgroundIndex = backgroundIndex,
            backgroundImageTransparency = backgroundImageTransparency,
            floatingButtonScale = floatingButtonScale,
            hideMobileButtons = mobileButtonsHidden,
            stealBarScale = stealBarScale,
            themeColor = currentColorTheme,
            carrySysSoftStealSpeed = CarrySystem.softStealSpeed,
            carrySysSoftStealRadius = CarrySystem.softStealRadius,
            autoCarrySpeedEnabled = autoCarrySpeedEnabled == true,
            autoCarryEnemyBaseEnabled = autoCarryEnemyBaseEnabled == true,
            autoCarryEnemyBaseRange = tonumber(autoCarryEnemyBaseRange) or 30,
            introSong = INTRO_SONG,
        }
        if pbFrame then config.progressBarPos = serializePos(pbFrame.Position) end
        if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
            config.mobilePanelPos = serializePos(MobilePanel.FloatingPanel.Position)
        end
        if main then config.menuPos = serializePos(main.Position) end
        return config
    end

    function saveAllSettings()
        if _isResetting or _isLoading or not _configReady then return true end
        if type(writefile) ~= "function" then return false end
        local okEncode, json = pcall(function() return HS:JSONEncode(buildConfigTable()) end)
        if not okEncode or type(json) ~= "string" then return false end
        if json == _lastSavedJSON then return true end
        local ok = pcall(function() writefile(CONFIG_FILE, json) end)
        if ok then _lastSavedJSON = json end
        return ok
    end
    saveStrikeConfig = saveAllSettings

    function loadAllSettings()
        if not isfile or not isfile(CONFIG_FILE) then return false end
        local ok, data = pcall(function() return HS:JSONDecode(readfile(CONFIG_FILE)) end)
        if not ok or type(data) ~= "table" then return false end
        _isLoading = true

        _G.__STRIKE_SPIN = type(_G.__STRIKE_SPIN) == "table" and _G.__STRIKE_SPIN or {}
        if data.spinSpeed ~= nil then _G.__STRIKE_SPIN.speed = data.spinSpeed end
        if data.spinPower ~= nil then _G.__STRIKE_SPIN.power = data.spinPower end
        if data.spinExpanded ~= nil then _G.__STRIKE_SPIN.expanded = data.spinExpanded == true end
        if data.spinActiveOnSteal ~= nil then _G.__STRIKE_SPIN.activeOnSteal = data.spinActiveOnSteal == true end

        local savedUltra = data.ultraModeEnabled == true
        _G.__STRIKE_ULTRA = type(_G.__STRIKE_ULTRA) == "table" and _G.__STRIKE_ULTRA or { on = false, runtimeOn = false, originals = {}, conns = {} }
        _G.__STRIKE_ULTRA.on = savedUltra
        task.defer(function()
            if savedUltra and type(_G.__STRIKE_ULTRA_START) == "function" then
                pcall(_G.__STRIKE_ULTRA_START)
            elseif not savedUltra and type(_G.__STRIKE_ULTRA_STOP) == "function" then
                pcall(_G.__STRIKE_ULTRA_STOP)
            end
            if type(_G.__STRIKE_ULTRA_SET_VISUAL) == "function" then
                pcall(_G.__STRIKE_ULTRA_SET_VISUAL, savedUltra)
            end
        end)

        NS = data.normalSpeed or NS
        CS = data.carrySpeed or CS
        LAGGER_SPEED = data.laggerSpeed1 or LAGGER_SPEED
        LAGGER_CARRY_SPEED = data.laggerSpeed2 or LAGGER_CARRY_SPEED
        CONFIG.STEAL_RANGE = data.stealRadius or CONFIG.STEAL_RANGE
        Steal.StealRadius = CONFIG.STEAL_RANGE
        if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end

        uiLocked = data.lockUI == true
        if data.antiRagdollMode == "v1" or data.antiRagdollMode == "v2" then
            antiRagdollMode = data.antiRagdollMode
        else
            antiRagdollMode = data.antiRagdoll and "v2" or "off"
        end

        local fc = _G.__STRIKE_FEATURE_CONFIG
        infiniteJumpEnabled = (fc.infiniteJumpEnabled ~= nil and fc.infiniteJumpEnabled or data.infiniteJumpEnabled) == true
        InfiniteJump.setMode(data.infiniteJumpMode == "manual" and "manual" or "hold")
        if infiniteJumpEnabled then InfiniteJump.start() else InfiniteJump.stop() end

        currentAnimPack = type(data.animPack) == "string" and string.upper(data.animPack) or "OFF"
        currentPackAnimation = type(data.packAnimation) == "string" and data.packAnimation or "OFF"

        antiDieEnabled = (fc.antiDieEnabled ~= nil and fc.antiDieEnabled or data.antiDieEnabled) == true
        antiFlingEnabled = (fc.antiFlingEnabled ~= nil and fc.antiFlingEnabled or data.antiFlingEnabled) == true
        fc.infiniteJumpEnabled, fc.antiDieEnabled, fc.antiFlingEnabled = infiniteJumpEnabled, antiDieEnabled, antiFlingEnabled
        if antiFlingEnabled then AntiFlingModule.start() else AntiFlingModule.stop() end

        CONFIG.AUTO_STEAL_ENABLED = data.autoSteal == true
        medusaCounterEnabled = data.medusaCounter == true
        batCounterEnabled = data.batCounter == true
        antiLagEnabled = data.antiLag == true
        StrikeShowE01Warning = data.showE01Warning == true
        laggerToggled = data.laggerToggled == true
        speedMode = data.carryMode == true
        laggerCarryToggled = data.laggerCarryToggled == true
        autoBatEnabled = data.autoBatEnabled == true
        autoLeftEnabled = data.autoLeftEnabled == true
        autoRightEnabled = data.autoRightEnabled == true
        autoCarrySpeedEnabled = data.autoCarrySpeedEnabled == true
        autoCarryEnemyBaseEnabled = data.autoCarryEnemyBaseEnabled == true
        if type(data.autoCarryEnemyBaseRange) == "number" then
            autoCarryEnemyBaseRange = _clamp(_floor(data.autoCarryEnemyBaseRange), 5, 150)
        end

        if type(data.introSong) == "string" then
            for _, name in ipairs(INTRO_SONG_ORDER) do
                if name == data.introSong then INTRO_SONG = name; break end
            end
        end

        uiScaleValue = data.uiScale or 78
        if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end

        if type(data.menuPos) == "table" then
            local cam = Workspace.CurrentCamera
            local vp = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
            local scale = (mainUIScale and mainUIScale.Scale > 0) and mainUIScale.Scale or 1
            local x = _clamp((data.menuPos.XScale or 0) * vp.X + (data.menuPos.XOffset or 0), 8, math.max(8, vp.X - 345 * scale - 8))
            local y = _clamp((data.menuPos.YScale or 0) * vp.Y + (data.menuPos.YOffset or 0), 8, math.max(8, vp.Y - 500 * scale - 8))
            _menuHomePos = UDim2.new(0, _floor(x + 0.5), 0, _floor(y + 0.5))
            if main then pcall(function() main.Position = _menuHomePos end) end
        end

        stealBarScale = data.stealBarScale or 0.40
        if pbScale then pbScale.Scale = stealBarScale end

        espEnabled = data.espEnabled == true
        espBoxEnabled = data.espBoxEnabled == true
        espTrackerEnabled = data.espTrackerEnabled == true
        ragdollCountdownEnabled = data.ragdollCountdownEnabled ~= false
        antiTpEspEnabled = data.antiTpEspEnabled == true
        toggleESP(espEnabled)
        toggleESPBox(espBoxEnabled)
        toggleESPTracker(espTrackerEnabled)
        toggleRagdollCountdown(ragdollCountdownEnabled)
        toggleAntiTpEsp(antiTpEspEnabled)

        if data.themeColor and COLOR_THEMES[data.themeColor] then
            currentColorTheme = data.themeColor
            selectedColor = COLOR_THEMES[data.themeColor]
            task.defer(updateAllUIThemeColors, selectedColor)
        end

        autoBatBypassEnabled = data.autoBatBypassEnabled == true
        if autoBatBypassEnabled then
            task.defer(function()
                autoBatBypassEnabled = false
                enableBatBypass()
            end)
        elseif autoBatBypassSetVisual then
            autoBatBypassSetVisual(false)
        end

        if data.tpBatCameraLock ~= nil then
            TPBAT_CFG.cameraLock = data.tpBatCameraLock == true
            if tpBatCamLockSetVisual then tpBatCamLockSetVisual(TPBAT_CFG.cameraLock) end
        end
        if data.tpBatEnabled then
            task.defer(startBatDesyncTp)
        else
            if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
            if tpBatFloatingButton then paintFloatingBtn(tpBatFloatingButton:FindFirstChild("Frame"), false) end
        end

        skyTheme = (type(data.skyTheme) == "string" and SKY_PRESETS[data.skyTheme]) and data.skyTheme or "Off"
        pcall(applyCustomSky, skyTheme)
        if skySelectorLabel then skySelectorLabel.Text = skyTheme end

        if type(data.customToolSkins) == "table" then
            _G.StrikeCustomToolSkins = _G.StrikeCustomToolSkins or { Bat = "None", Medusa = "None" }
            local assets = _G.StrikeCustomToolAssets or {}
            for _, cat in ipairs({ "Bat", "Medusa" }) do
                local val = data.customToolSkins[cat]
                if type(val) == "string" and (val == "None" or (assets[val] and assets[val].cat == cat)) then
                    _G.StrikeCustomToolSkins[cat] = val
                    if _G.StrikeCustomToolSkinSelectorRefresh and _G.StrikeCustomToolSkinSelectorRefresh[cat] then
                        pcall(_G.StrikeCustomToolSkinSelectorRefresh[cat], val)
                    end
                    if _G.StrikeSetCustomToolSkin then pcall(_G.StrikeSetCustomToolSkin, cat, val) end
                end
            end
        end

        if type(data.displaySkin) == "string" then
            _G.__StrikeSavedDisplaySkin = data.displaySkin
            local st = _G.StrikeDisplaySkinState
            if st then
                st.displaySkin = STRIKE_DISPLAY_SKIN_SETS and STRIKE_DISPLAY_SKIN_SETS[data.displaySkin] and data.displaySkin or "Off"
                st.customSkinEnabled = st.displaySkin ~= "Off"
                if _G.StrikeDisplaySkinSelectorRefresh then
                    pcall(_G.StrikeDisplaySkinSelectorRefresh, st.displaySkin)
                elseif st.displaySkinSelectorLabel then
                    st.displaySkinSelectorLabel.Text = st.displaySkin == "Off" and "None" or st.displaySkin
                end
            end
        end

        decodeKB(KB.DropBrainrot, data.dropBrainrotKey)
        decodeKB(KB.AutoLeft, data.autoLeftKey)
        decodeKB(KB.AutoRight, data.autoRightKey)
        decodeKB(KB.AutoBat, data.autoBatKey)
        decodeKB(KB.TPFloor, data.tpFloorKey)
        decodeKB(KB.CarryToggle, data.carryToggleKey)
        decodeKB(KB.LaggerMode, data.laggerModeKey)
        decodeKB(KB.TPBat, data.tpBatKey)
        decodeKB(KB.BatBypass, data.batBypassKey)
        decodeKB(KB.Carry, data.carryKey)
        decodeKB(KB.LaggerCarry, data.laggerCarryKey)
        decodeKB(KB.InstaReset, data.instaResetKey)
        removeDuplicateLoadedKeybinds()

        if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end
        if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
        if data.tpBatFloatingPos then tpBatFloatingPos = data.tpBatFloatingPos end
        if data.batBypassFloatingPos then batBypassFloatingPos = data.batBypassFloatingPos end
        if data.instaResetFloatingPos then instaResetFloatingPos = data.instaResetFloatingPos end
        if data.progressBarPos then savedProgressBarPos = data.progressBarPos end

        dropMode = data.dropMode or 2
        stretchEnabled = data.stretchEnabled == true
        fovValue = data.fovValue or 70
        fovEnabled = data.fovEnabled == true
        if fovSliderSet then fovSliderSet(fovValue) end
        if fovEnabled then enableCustomFov() end
        if setFovVisual then setFovVisual(fovEnabled) end
        stretchFOV = data.stretchFOV or 120
        BAT_AIMBOT_SPEED = data.batAimbotSpeed or BAT_AIMBOT_SPEED
        BAT_BYPASS_SPEED = data.batBypassSpeed or BAT_BYPASS_SPEED
        BatBypass.speed = BAT_BYPASS_SPEED

        backgroundIndex = _clamp(tonumber(data.backgroundIndex) or 1, 1, #backgroundImages)
        backgroundImageTransparency = data.backgroundImageTransparency or 0
        floatingButtonScale = data.floatingButtonScale or 0.65
        mobileButtonsHidden = data.hideMobileButtons == true
        setMobileButtonsHidden(mobileButtonsHidden)
        if hideMobileBtnsSetVisual then hideMobileBtnsSetVisual(mobileButtonsHidden) end

        CarrySystem.normalSpeed, CarrySystem.carrySpeed = NS, CS
        CarrySystem.laggerSpeed, CarrySystem.laggerCarrySpeed = LAGGER_SPEED, LAGGER_CARRY_SPEED
        CarrySystem.softStealSpeed = data.carrySysSoftStealSpeed or 30
        CarrySystem.softStealRadius = data.carrySysSoftStealRadius or 10
        CarrySystem.speedToggled = speedMode
        CarrySystem.laggerMode = laggerCarryToggled and 2 or (laggerToggled and 1 or 0)

        if updateDropModeUI then updateDropModeUI(dropMode) end
        if introSongSelectorLabel then introSongSelectorLabel.Text = INTRO_SONG:upper() end
        refreshSpeedModeLabel()
        _lastSavedJSON = HS:JSONEncode(buildConfigTable())
        _isLoading = false
        return true
    end

    function resetFloatingPositions()
        if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
            local container = MobilePanel.FloatingPanel
            container.Position = UDim2.new(1, -150, 0, 16)
            savedButtonPositions = {}
            local btnContainer = container:FindFirstChild("ButtonsContainer")
            if btnContainer then
                for _, btn in ipairs(btnContainer:GetChildren()) do
                    if btn:IsA("TextButton") then
                        local defX, defY = getDefaultButtonPosition(btn.Name)
                        btn.Position = UDim2.new(0, defX, 0, defY)
                    end
                end
            end
        end
        if tpBatFloatingButton and tpBatFloatingButton:FindFirstChild("Frame") then
            tpBatFloatingButton.Frame.Position = UDim2.new(1, -228, 0, 16)
        end
        if batBypassFloatingButton and batBypassFloatingButton:FindFirstChild("Frame") then
            batBypassFloatingButton.Frame.Position = UDim2.new(1, -228, 0, 94)
        end
        if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
            instaResetFloatingButton.Frame.Position = UDim2.new(1, -228, 0, 172)
        end
        if pbFrame then pbFrame.Position = UDim2.new(0, 300, 1, -80) end
        savedProgressBarPos, savedMobilePanelPos, tpBatFloatingPos, batBypassFloatingPos, instaResetFloatingPos = nil, nil, nil, nil, nil
        pcall(saveAllSettings)
    end

    local function syncTextFieldsAndUI()
        if normalBox then normalBox.Text = tostring(NS) end
        if carryBox then carryBox.Text = tostring(CS) end
        if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
        if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
        if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
        if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
        if batBypassBox then batBypassBox.Text = tostring(BAT_BYPASS_SPEED) end
        if uiScaleStepperSet then uiScaleStepperSet(uiScaleValue) end
        if floatScaleStepperSet then floatScaleStepperSet(floatingButtonScale) end
        if stealBarStepperSet then stealBarStepperSet(stealBarScale) end
        if updateDropModeUI then updateDropModeUI(dropMode) end
        if carrySysSoftStealSpeedBox then carrySysSoftStealSpeedBox.Text = tostring(CarrySystem.softStealSpeed) end
        if carrySysSoftStealRadiusBox then carrySysSoftStealRadiusBox.Text = tostring(CarrySystem.softStealRadius) end
        if autoCarryEnemyBaseRangeBox then autoCarryEnemyBaseRangeBox.Text = tostring(autoCarryEnemyBaseRange) end
        refreshKeybindButtonLabels()
    end

    function resetToFactoryDefaults()
        _isResetting = true
        local ok, err = pcall(function()
            stopAllBackgroundTasks()
            NS, CS, LAGGER_SPEED, LAGGER_CARRY_SPEED, CONFIG.STEAL_RANGE = 60, 29, 40, 24, 61
            Steal.StealRadius = 61
            speedMode, laggerToggled, laggerCarryToggled = false, false, false
            antiRagdollMode, antiDieEnabled, antiFlingEnabled, infiniteJumpEnabled = "off", false, false, false
            InfiniteJump.stop(); InfiniteJump.setMode("hold")
            medusaCounterEnabled, batCounterEnabled, autoBatEnabled, autoLeftEnabled, autoRightEnabled = false, false, false, false, false
            antiLagEnabled, StrikeShowE01Warning, StrikeE01StartedAt = false, false, nil
            if StrikeE01Gui then StrikeE01Gui.Enabled = false end
            uiLocked, CONFIG.AUTO_STEAL_ENABLED, BAT_AIMBOT_SPEED, BAT_BYPASS_SPEED, dropMode = false, false, 58, 60, 2
            BatBypass.speed = 60
            stretchEnabled, stretchFOV, fovValue = false, 120, 70
            disableCustomFov()
            if fovSliderSet then fovSliderSet(70) end
            if setFovVisual then setFovVisual(false) end
            uiScaleValue, stealBarScale = 78, 0.40
            if mainUIScale then mainUIScale.Scale = 0.78 end
            if pbScale then pbScale.Scale = stealBarScale end
            espEnabled, espBoxEnabled, espTrackerEnabled, ragdollCountdownEnabled, antiTpEspEnabled = false, false, false, true, false
            autoBatBypassEnabled, autoCarrySpeedEnabled, autoCarryEnemyBaseEnabled, autoCarryEnemyBaseRange = false, false, false, 30
            backgroundIndex, backgroundImageTransparency, floatingButtonScale, mobileButtonsHidden = 1, 0, 0.65, false
            applyFloatingButtonScale(); setMobileButtonsHidden(false)
            TPBAT_CFG.cameraLock = true
            if tpBatCamLockSetVisual then pcall(tpBatCamLockSetVisual, true) end
            if setInfiniteJumpModeVisual then pcall(setInfiniteJumpModeVisual, InfiniteJump.mode) end

            if _G.__STRIKE_SPIN then
                _G.__STRIKE_SPIN.speed, _G.__STRIKE_SPIN.power, _G.__STRIKE_SPIN.expanded, _G.__STRIKE_SPIN.activeOnSteal = 360, 100, false, false
            end
            if _G.__STRIKE_SPIN_REFRESH then pcall(_G.__STRIKE_SPIN_REFRESH) end
            if type(_G.__STRIKE_ULTRA_STOP) == "function" then pcall(_G.__STRIKE_ULTRA_STOP) end
            if type(_G.__STRIKE_ULTRA_SET_VISUAL) == "function" then pcall(_G.__STRIKE_ULTRA_SET_VISUAL, false) end

            currentAnimPack, currentPackAnimation = "OFF", "OFF"
            if applyPackAnimationGlobal then pcall(applyPackAnimationGlobal, "OFF") end
            if applyAnimPackGlobal then pcall(applyAnimPackGlobal, "OFF") end

            INTRO_SONG = "Song 1"
            if introSongSelectorLabel then introSongSelectorLabel.Text = INTRO_SONG:upper() end

            local bgImg = main and main:FindFirstChild("BackgroundImage")
            if bgImg then bgImg.Image, bgImg.BackgroundTransparency, bgImg.ImageTransparency = "", 0, 0 end
            if _G.StrikeRefreshBgPicker then pcall(_G.StrikeRefreshBgPicker) end

            skyTheme = "Off"; pcall(applyCustomSky, "Off")
            if skySelectorLabel then skySelectorLabel.Text = "Off" end
            if _G.StrikeSetCustomToolSkin then
                pcall(_G.StrikeSetCustomToolSkin, "Bat", "None")
                pcall(_G.StrikeSetCustomToolSkin, "Medusa", "None")
            end
            if _G.StrikeCustomToolSkinSelectorRefresh then
                pcall(_G.StrikeCustomToolSkinSelectorRefresh.Bat, "None")
                pcall(_G.StrikeCustomToolSkinSelectorRefresh.Medusa, "None")
            end
            if StrikeDisplaySkin and StrikeDisplaySkin.setSkin then
                pcall(StrikeDisplaySkin.setSkin, "Off", false)
            end
            _G.__StrikeSavedDisplaySkin = "Off"
            if _G.StrikeDisplaySkinSelectorRefresh then pcall(_G.StrikeDisplaySkinSelectorRefresh, "Off") end

            currentColorTheme = "Gris"
            selectedColor = COLOR_THEMES["Gris"]
            for _, entry in pairs(KB) do entry.kb, entry.gp = nil, nil end

            CarrySystem.normalSpeed, CarrySystem.carrySpeed = NS, CS
            CarrySystem.laggerSpeed, CarrySystem.laggerCarrySpeed = LAGGER_SPEED, LAGGER_CARRY_SPEED
            CarrySystem.softStealSpeed, CarrySystem.softStealRadius = 30, 10
            CarrySystem.speedToggled, CarrySystem.laggerMode = false, 0

            if isfile and isfile(CONFIG_FILE) then pcall(delfile, CONFIG_FILE) end
            resetFloatingPositions()
            syncTextFieldsAndUI()

            for _, setter in ipairs({
                autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual,
                setAntiLagVisual, setLockUIVisual, setInstaGrab, batDesyncTpSetVisual, setESPVIsual,
                setESPBoxVisual, setESPTrackerVisual, setAntiTpEspVisual, autoBatBypassSetVisual, setAntiDieVisual,
                setAntiFlingVisual, setAntiRagdollVisual, setInfiniteJumpVisual, setAutoCarrySpeedVisual,
                setAutoCarryEnemyBaseVisual, StrikeShowE01WarningSetVisual, hideMobileBtnsSetVisual, _G.stretchToggleSetter,
                mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2,
            }) do
                if setter then pcall(setter, false) end
            end
            if setRagdollCountdownVisual then setRagdollCountdownVisual(true) end
            if updateAntiRagdollModeUI then updateAntiRagdollModeUI("off") end
            if tpBatFloatingButton then paintFloatingBtn(tpBatFloatingButton:FindFirstChild("Frame"), false) end
            if batBypassFloatingButton then paintFloatingBtn(batBypassFloatingButton:FindFirstChild("Frame"), false) end
            updateAllUIThemeColors(selectedColor)
            updateProgressBarVisibility()
            refreshSpeedModeLabel()
            _lastSavedJSON = nil
            saveAllSettings()
        end)
        _isResetting = false
        if not ok then warn("[resetToFactoryDefaults]", err) end
        return ok
    end

    -- ========================================================================
    -- CONSTRUCCIÓN DE LA INTERFAZ PRINCIPAL (buildGui)
    -- ========================================================================
    function buildGui()
        local ROW_BG = Color3.fromRGB(10, 10, 10)
        local ROW_BORDER = Color3.fromRGB(50, 50, 50)
        local WHITE = Color3.new(1, 1, 1)
        local INP = Color3.fromRGB(15, 15, 15)
        local GUI_W, GUI_H = 385, 534

        safeDestroy(CoreGui:FindFirstChild("STRIKE"))
        local pg = LP:FindFirstChild("PlayerGui")
        if pg then safeDestroy(pg:FindFirstChild("STRIKE")) end

        gui = Instance.new("ScreenGui")
        gui.Name, gui.ResetOnSpawn, gui.DisplayOrder, gui.IgnoreGuiInset = "STRIKE", false, 10, true
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
        if not pcall(function() gui.Parent = CoreGui end) then gui.Parent = LP:WaitForChild("PlayerGui") end

        main = Instance.new("Frame", gui)
        main.Size, main.Position = UDim2.new(0, GUI_W, 0, GUI_H), _menuHomePos or UDim2.new(0, 20, 0, 2)
        main.BackgroundColor3, main.BackgroundTransparency, main.BorderSizePixel, main.ClipsDescendants = Color3.new(0, 0, 0), 1, 0, true
        Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

        local bgImage = Instance.new("ImageLabel", main)
        bgImage.Name, bgImage.Size, bgImage.ScaleType, bgImage.ZIndex, bgImage.ClipsDescendants = "BackgroundImage", UDim2.fromScale(1, 1), Enum.ScaleType.Crop, 0, true
        bgImage.BackgroundColor3 = Color3.new(0, 0, 0)
        if backgroundImages[backgroundIndex] == "NONE" then
            bgImage.BackgroundTransparency, bgImage.Image = 0, ""
        else
            bgImage.BackgroundTransparency, bgImage.Image = 1, "rbxassetid://" .. backgroundImages[backgroundIndex]
        end
        bgImage.ImageTransparency = backgroundImageTransparency
        Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 18)

        mainUIScale = Instance.new("UIScale", main)
        mainUIScale.Scale = uiScaleValue / 100

        local titleFrame = Instance.new("Frame", main)
        titleFrame.Size, titleFrame.Position, titleFrame.BackgroundTransparency, titleFrame.ZIndex = UDim2.new(1, -36, 0, 108), UDim2.new(0, 18, 0, 1), 1, 20
        local titleLabel = Instance.new("ImageLabel", titleFrame)
        titleLabel.Name, titleLabel.Size, titleLabel.Position = "StrikeTitle", UDim2.new(1, 24, 0, 86), UDim2.new(0, -14, 0, 0)
        titleLabel.BackgroundTransparency, titleLabel.Image, titleLabel.ScaleType, titleLabel.ZIndex = 1, "rbxassetid://110597760764632", Enum.ScaleType.Fit, 21

        local closeBtn = Instance.new("TextButton", main)
        closeBtn.Size, closeBtn.Position = UDim2.new(0, 32, 0, 32), UDim2.new(1, -42, 0, 8)
        closeBtn.BackgroundColor3, closeBtn.BackgroundTransparency, closeBtn.BorderSizePixel = Color3.fromRGB(30, 30, 35), 0.6, 0
        closeBtn.Text, closeBtn.TextColor3, closeBtn.Font, closeBtn.TextSize, closeBtn.AutoButtonColor, closeBtn.ZIndex = "−", WHITE, Enum.Font.GothamBold, 26, false, 200
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
        closeBtn.MouseEnter:Connect(function() TS:Create(closeBtn, TweenInfo.new(0.12), { BackgroundColor3 = getThemeColor() }):Play() end)
        closeBtn.MouseLeave:Connect(function() TS:Create(closeBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(30, 30, 35) }):Play() end)

        miniBtn = Instance.new("TextButton", gui)
        miniBtn.Size, miniBtn.Position = UDim2.new(0, 140, 0, 36), UDim2.new(0, 16, 0, 58)
        miniBtn.BackgroundColor3, miniBtn.BorderSizePixel, miniBtn.Text, miniBtn.TextColor3, miniBtn.Visible, miniBtn.ZIndex = Color3.fromRGB(10, 10, 10), 0, "", selectedColor, false, 20
        Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 8)
        local miniImg = Instance.new("ImageLabel", miniBtn)
        miniImg.Name, miniImg.Size, miniImg.Position = "StrikeMiniImage", UDim2.new(1, -10, 1, -10), UDim2.new(0, 5, 0, 5)
        miniImg.BackgroundTransparency, miniImg.Image, miniImg.ScaleType, miniImg.ImageColor3, miniImg.ZIndex = 1, "rbxassetid://110597760764632", Enum.ScaleType.Fit, selectedColor, 21
        applyShimmerToText(miniBtn, 0.9)

        local slideTween = nil
        local function getSafeMenuPos()
            local vp = (Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize) or Vector2.new(1280, 720)
            local s = (mainUIScale and mainUIScale.Scale > 0) and mainUIScale.Scale or 1
            local pos = _menuHomePos or UDim2.new(0, 20, 0, 20)
            local x = _clamp(pos.X.Scale * vp.X + pos.X.Offset, 8, math.max(8, vp.X - GUI_W * s - 8))
            local y = _clamp(pos.Y.Scale * vp.Y + pos.Y.Offset, 8, math.max(8, vp.Y - GUI_H * s - 8))
            return UDim2.new(0, _floor(x + 0.5), 0, _floor(y + 0.5))
        end

        showGui = function()
            if slideTween then pcall(function() slideTween:Cancel() end); slideTween = nil end
            if not main or not miniBtn or not gui then return end
            gui.Enabled, main.Visible, miniBtn.Visible = true, true, false
            main.Position = getSafeMenuPos()
            _menuHomePos = main.Position
        end

        hideGui = function()
            if slideTween then pcall(function() slideTween:Cancel() end) end
            if not main or not main.Visible then return end
            slideTween = TS:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(0, -GUI_W - 20, 0, 2) })
            slideTween:Play()
            slideTween.Completed:Connect(function()
                main.Visible, miniBtn.Visible, slideTween = false, true, nil
            end)
        end
        closeBtn.MouseButton1Click:Connect(hideGui)
        miniBtn.MouseButton1Click:Connect(showGui)

        -- Navegación por pestañas (Speed / Combat / Visual / Config)
        local tabContent = Instance.new("Frame", main)
        tabContent.Size, tabContent.Position, tabContent.BackgroundTransparency, tabContent.ClipsDescendants, tabContent.ZIndex = UDim2.new(1, -12, 1, -124), UDim2.new(0, 6, 0, 72), 1, true, 5

        local tabs = { "Speed", "Combat", "Visual", "Config" }
        local contentPages = {}
        for i, name in ipairs(tabs) do
            local page = Instance.new("ScrollingFrame", tabContent)
            page.Size, page.BackgroundColor3, page.BackgroundTransparency, page.BorderSizePixel = UDim2.fromScale(1, 1), Color3.fromRGB(5, 5, 5), 0.6, 0
            page.ClipsDescendants, page.ScrollBarThickness, page.ScrollBarImageColor3, page.ScrollBarImageTransparency = true, 2, Color3.fromRGB(30, 30, 35), 0.3
            page.CanvasSize, page.AutomaticCanvasSize, page.ScrollingDirection, page.ZIndex, page.Visible = UDim2.new(), Enum.AutomaticSize.Y, Enum.ScrollingDirection.Y, 6, (i == 1)
            Instance.new("UICorner", page).CornerRadius = UDim.new(0, 16)
            local layout = Instance.new("UIListLayout", page)
            layout.SortOrder, layout.Padding, layout.HorizontalAlignment = Enum.SortOrder.LayoutOrder, UDim.new(0, 6), Enum.HorizontalAlignment.Center
            local pad = Instance.new("UIPadding", page)
            pad.PaddingLeft, pad.PaddingRight, pad.PaddingTop, pad.PaddingBottom = UDim.new(0, 8), UDim.new(0, 8), UDim.new(0, 6), UDim.new(0, 20)
            contentPages[name] = page
        end

        local navCur = 1
        local navBar = Instance.new("Frame", main)
        navBar.Name, navBar.Size, navBar.Position = "StrikeNavBar", UDim2.new(1, -24, 0, 40), UDim2.new(0, 12, 1, -48)
        navBar.BackgroundColor3, navBar.BackgroundTransparency, navBar.BorderSizePixel, navBar.ZIndex = Color3.fromRGB(18, 18, 22), 0.3, 0, 60
        Instance.new("UICorner", navBar).CornerRadius = UDim.new(0, 10)
        local navStroke = Instance.new("UIStroke", navBar)
        navStroke.Thickness, navStroke.Transparency, navStroke.Color = 1, 0.35, getThemeColor()

        local navBarBtn = Instance.new("TextButton", navBar)
        navBarBtn.Name, navBarBtn.Size, navBarBtn.BackgroundTransparency, navBarBtn.Text, navBarBtn.AutoButtonColor, navBarBtn.ZIndex = "NavBarHit", UDim2.fromScale(1, 1), 1, "", false, 60

        local function mkNavArrow(txt, pos)
            local b = Instance.new("TextButton", navBar)
            b.Size, b.Position, b.BackgroundColor3, b.BackgroundTransparency, b.BorderSizePixel = UDim2.new(0, 36, 1, -8), pos, WHITE, 0.88, 0
            b.Text, b.TextColor3, b.Font, b.TextSize, b.AutoButtonColor, b.ZIndex = txt, WHITE, Enum.Font.GothamBold, 16, false, 62
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
            return b
        end
        local navPrev = mkNavArrow("<", UDim2.new(0, 4, 0, 4))
        local navNext = mkNavArrow(">", UDim2.new(1, -40, 0, 4))
        local navTitle = Instance.new("TextButton", navBar)
        navTitle.Size, navTitle.Position, navTitle.BackgroundTransparency = UDim2.new(1, -88, 1, -8), UDim2.new(0, 44, 0, 4), 1
        navTitle.Text, navTitle.TextColor3, navTitle.Font, navTitle.TextSize, navTitle.AutoButtonColor, navTitle.ZIndex = "SPEED", WHITE, Enum.Font.GothamBold, 18, false, 62

        local navDrop = Instance.new("Frame", main)
        navDrop.Name, navDrop.Size, navDrop.AnchorPoint, navDrop.Position = "StrikeNavDrop", UDim2.new(1, -24, 0, 0), Vector2.new(0, 1), UDim2.new(0, 12, 1, -52)
        navDrop.BackgroundColor3, navDrop.BackgroundTransparency, navDrop.BorderSizePixel, navDrop.Visible, navDrop.ClipsDescendants, navDrop.ZIndex = Color3.fromRGB(16, 16, 20), 0.06, 0, false, true, 300
        Instance.new("UICorner", navDrop).CornerRadius = UDim.new(0, 10)
        local navDropStroke = Instance.new("UIStroke", navDrop)
        navDropStroke.Thickness, navDropStroke.Transparency, navDropStroke.Color = 1, 0.35, getThemeColor()
        local ndl = Instance.new("UIListLayout", navDrop)
        ndl.SortOrder, ndl.FillDirection, ndl.HorizontalAlignment, ndl.VerticalAlignment, ndl.Padding = Enum.SortOrder.LayoutOrder, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center, UDim.new(0, 4)
        local ndp = Instance.new("UIPadding", navDrop)
        ndp.PaddingTop, ndp.PaddingBottom, ndp.PaddingLeft, ndp.PaddingRight = UDim.new(0, 4), UDim.new(0, 4), UDim.new(0, 4), UDim.new(0, 4)

        local navDropBtns = {}
        local function refreshNavDropColors()
            local col = getThemeColor()
            navStroke.Color = col
            navDropStroke.Color = col
            for k, btn in ipairs(navDropBtns) do
                local active = (k == navCur)
                btn.BackgroundColor3 = active and col or WHITE
                btn.BackgroundTransparency = active and 0.25 or 0.9
                btn.TextColor3 = WHITE
            end
        end

        local function setNavDropOpen(show)
            navDrop.Size = UDim2.new(1, -24, 0, show and 44 or 0)
            navDrop.Visible = show
            if show then refreshNavDropColors() end
        end

        local function selectTab(idx)
            idx = ((idx - 1) % #tabs) + 1
            navCur = idx
            for _, pgFrame in pairs(contentPages) do pgFrame.Visible = false end
            if contentPages[tabs[idx]] then contentPages[tabs[idx]].Visible = true end
            navTitle.Text = tabs[idx]:upper()
            refreshNavDropColors()
        end

        for k, nm in ipairs(tabs) do
            local it = Instance.new("TextButton", navDrop)
            it.Size, it.BackgroundColor3, it.BackgroundTransparency, it.BorderSizePixel = UDim2.new(1 / #tabs, -5, 0, 34), WHITE, 0.9, 0
            it.Text, it.TextColor3, it.Font, it.TextSize, it.AutoButtonColor, it.LayoutOrder, it.ZIndex = nm:upper(), WHITE, Enum.Font.GothamBold, 11, false, k, 301
            Instance.new("UICorner", it).CornerRadius = UDim.new(0, 8)
            navDropBtns[k] = it
            it.Activated:Connect(function()
                selectTab(k)
                setNavDropOpen(false)
            end)
        end
        refreshNavDropColors()
        table.insert(themeToggleRegistry, refreshNavDropColors)

        local function toggleNavDrop()
            setNavDropOpen(not navDrop.Visible)
        end
        navTitle.Activated:Connect(toggleNavDrop)
        navBarBtn.Activated:Connect(toggleNavDrop)
        navPrev.Activated:Connect(function() selectTab(navCur - 1) end)
        navNext.Activated:Connect(function() selectTab(navCur + 1) end)

        -- Constructores de filas y controles
        local pageCounters = {}
        local function nextOrder(page)
            pageCounters[page] = (pageCounters[page] or 0) + 1
            return pageCounters[page]
        end

        local function mkSect(page, txt)
            local f = Instance.new("Frame", page)
            f.Size, f.BackgroundTransparency, f.BorderSizePixel, f.LayoutOrder, f.ZIndex = UDim2.new(1, 0, 0, 30), 1, 0, nextOrder(page), 7
            local l = Instance.new("TextLabel", f)
            l.Name, l.Size, l.Position, l.BackgroundTransparency = "SectTitle", UDim2.new(1, -16, 1, 0), UDim2.new(0, 8, 0, 0), 1
            l.Text, l.TextColor3, l.Font, l.TextSize, l.TextXAlignment = txt:upper(), getThemeColor(), Enum.Font.GothamBlack, 17, Enum.TextXAlignment.Left
            l.TextStrokeColor3, l.TextStrokeTransparency, l.ZIndex = Color3.new(0, 0, 0), 0.45, 8
            local line = Instance.new("Frame", f)
            line.Size, line.Position, line.BackgroundColor3, line.BackgroundTransparency, line.BorderSizePixel, line.ZIndex = UDim2.new(1, -24, 0, 1), UDim2.new(0, 12, 1, -4), WHITE, 0.72, 0, 8
            return f
        end

        local function mkRow(page, h)
            local f = Instance.new("Frame", page)
            f.Size, f.BackgroundColor3, f.BackgroundTransparency, f.BorderSizePixel, f.LayoutOrder, f.ZIndex = UDim2.new(1, -4, 0, h or 38), ROW_BG, 0.7, 0, nextOrder(page), 7
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
            local rs = Instance.new("UIStroke", f)
            rs.Color, rs.Thickness, rs.Transparency = ROW_BORDER, 1, 0.5
            f.MouseEnter:Connect(function() TS:Create(f, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(28, 28, 28) }):Play() end)
            f.MouseLeave:Connect(function() TS:Create(f, TweenInfo.new(0.1), { BackgroundColor3 = ROW_BG }):Play() end)
            return f
        end

        local function mkLabel(row, txt)
            local l = Instance.new("TextLabel", row)
            l.Size, l.Position, l.BackgroundTransparency = UDim2.new(0.55, 0, 1, 0), UDim2.new(0, 10, 0, 0), 1
            l.Text, l.TextColor3, l.Font, l.TextSize, l.TextXAlignment, l.TextTruncate = txt, WHITE, Enum.Font.GothamBold, 15, Enum.TextXAlignment.Left, Enum.TextTruncate.AtEnd
            l.TextStrokeColor3, l.TextStrokeTransparency, l.ZIndex = Color3.new(0, 0, 0), 0.35, 8
            return l
        end

        local function mkPill(row, offset)
            local pill = Instance.new("Frame", row)
            pill.Name, pill.Size, pill.AnchorPoint, pill.Position = "Track", UDim2.new(0, 34, 0, 18), Vector2.new(0.5, 0.5), UDim2.new(1, -(offset or 48), 0.5, 0)
            pill.BackgroundColor3, pill.BackgroundTransparency, pill.BorderSizePixel, pill.ZIndex = WHITE, 0.2, 0, 8
            Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 9)
            local stroke = Instance.new("UIStroke", pill)
            stroke.Color, stroke.Thickness, stroke.Transparency, stroke.Name = ROW_BORDER, 1, 0.45, "PillStroke"
            local dot = Instance.new("Frame", pill)
            dot.Name, dot.Size, dot.Position, dot.BackgroundColor3, dot.BorderSizePixel, dot.ZIndex = "Knob", UDim2.new(0, 13, 0, 13), UDim2.new(0, 3, 0.5, -6), Color3.fromRGB(18, 18, 22), 0, 9
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
            local shine = Instance.new("Frame", dot)
            shine.Name, shine.Size, shine.Position, shine.BackgroundColor3, shine.BackgroundTransparency, shine.BorderSizePixel, shine.ZIndex = "Shine", UDim2.new(1, -4, 0, 4), UDim2.new(0, 2, 0, 2), WHITE, 0.72, 0, 10
            Instance.new("UICorner", shine).CornerRadius = UDim.new(0, 4)
            return pill, dot
        end

        local function animPill(pill, dot, on)
            local col = getThemeColor()
            local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TS:Create(dot, info, { Position = on and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6) }):Play()
            TS:Create(pill, info, { BackgroundColor3 = on and col or WHITE, BackgroundTransparency = on and 0 or 0.2 }):Play()
            local st = pill:FindFirstChildOfClass("UIStroke")
            if st then TS:Create(st, info, { Color = on and col or ROW_BORDER, Transparency = on and 0.2 or 0.45 }):Play() end
        end

        local function mkKeyButton(parent, kbEntry)
            local btn = Instance.new("TextButton", parent)
            btn.Size, btn.Position = UDim2.new(0, 108, 0, 24), UDim2.new(1, -116, 0.5, -12)
            btn.BackgroundColor3, btn.BackgroundTransparency, btn.BorderSizePixel = INP, 0.5, 0
            btn.Text = (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None"
            btn.TextColor3, btn.Font, btn.TextSize, btn.ZIndex, btn.AutoButtonColor = WHITE, Enum.Font.GothamBold, 9, 8, false
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            local bs = Instance.new("UIStroke", btn)
            bs.Color, bs.Thickness = ROW_BORDER, 1

            local li, lc, pv, listenStart = false, nil, btn.Text, 0
            local function cancelListen()
                li, _anyKeyListening = false, false
                safeDisconnect(lc); lc = nil
                btn.Text, btn.TextColor3 = pv, WHITE
            end
            btn.Activated:Connect(function()
                if li then cancelListen(); return end
                pv, li, _anyKeyListening, listenStart = btn.Text, true, true, _tick()
                btn.Text = "..."
                lc = UIS.InputBegan:Connect(function(inp)
                    if not li then return end
                    if inp.KeyCode == Enum.KeyCode.Escape then cancelListen(); return end
                    local isGp = isGamepadInput(inp)
                    if (isGp and _tick() - listenStart < 0.15) or not isBindableInput(inp) then return end
                    li, _anyKeyListening = false, false
                    safeDisconnect(lc); lc = nil
                    assignUniqueKeybind(kbEntry, inp.KeyCode, isGp)
                    pv = (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None"
                    btn.Text, btn.TextColor3 = pv, WHITE
                end)
            end)
            table.insert(keyButtonRefs, { btn = btn, entry = kbEntry })
            return btn
        end

        local function mkToggle(page, txt, cb, kbEntry)
            local row = mkRow(page, 38)
            mkLabel(row, txt)
            if kbEntry then
                local kbBtn = mkKeyButton(row, kbEntry)
                if kbEntry == KB.AutoLeft or kbEntry == KB.AutoRight then
                    kbBtn.Size, kbBtn.Position = UDim2.new(0, 70, 0, 24), UDim2.new(1, -145, 0.5, -12)
                else
                    kbBtn.Position = UDim2.new(1, -140, 0.5, -12)
                end
            end
            local pill, dot = mkPill(row, 48)
            local on = false
            local function sv(s) on = s == true; animPill(pill, dot, on) end
            table.insert(themeToggleRegistry, function() animPill(pill, dot, on) end)
            local clk = Instance.new("TextButton", pill)
            clk.Size, clk.BackgroundTransparency, clk.Text, clk.AutoButtonColor, clk.ZIndex = UDim2.fromScale(1, 1), 1, "", false, 10
            clk.MouseButton1Click:Connect(function()
                on = not on
                sv(on)
                if cb then pcall(cb, on) end
            end)
            return sv, row
        end

        local function mkSlider(row, minV, maxV, default, cb)
            local W = 118
            local track = Instance.new("Frame", row)
            track.Size, track.Position, track.BackgroundColor3, track.BackgroundTransparency, track.BorderSizePixel, track.ZIndex = UDim2.new(0, W, 0, 4), UDim2.new(1, -(W + 44), 0.5, -2), INP, 0.3, 0, 8
            Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
            local fill = Instance.new("Frame", track)
            fill.Size, fill.BackgroundColor3, fill.BorderSizePixel, fill.ZIndex = UDim2.new(0, 0, 1, 0), getThemeColor(), 0, 9
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
            local knob = Instance.new("Frame", track)
            knob.Size, knob.AnchorPoint, knob.Position, knob.BackgroundColor3, knob.BorderSizePixel, knob.ZIndex = UDim2.new(0, 13, 0, 13), Vector2.new(0.5, 0.5), UDim2.new(0, 0, 0.5, 0), WHITE, 0, 11
            Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
            local kStroke = Instance.new("UIStroke", knob)
            kStroke.Color, kStroke.Thickness = getThemeColor(), 2
            local valLabel = Instance.new("TextLabel", row)
            valLabel.Size, valLabel.Position, valLabel.BackgroundTransparency = UDim2.new(0, 34, 0, 20), UDim2.new(1, -38, 0.5, -10), 1
            valLabel.Text, valLabel.TextColor3, valLabel.Font, valLabel.TextSize, valLabel.TextXAlignment, valLabel.ZIndex = tostring(default), WHITE, Enum.Font.GothamBold, 11, Enum.TextXAlignment.Right, 9
            local hit = Instance.new("TextButton", row)
            hit.Size, hit.Position, hit.BackgroundTransparency, hit.Text, hit.AutoButtonColor, hit.ZIndex = UDim2.new(0, W + 16, 0, 26), UDim2.new(1, -(W + 52), 0.5, -13), 1, "", false, 12

            local function render(a)
                a = _clamp(a, 0, 1)
                fill.Size, knob.Position = UDim2.new(a, 0, 1, 0), UDim2.new(a, 0, 0.5, 0)
                fill.BackgroundColor3, kStroke.Color = getThemeColor(), getThemeColor()
            end
            local function applyFromX(px)
                local left, width = track.AbsolutePosition.X, track.AbsoluteSize.X > 0 and track.AbsoluteSize.X or W
                if left <= 0 then return end
                local a = _clamp((px - left) / width, 0, 1)
                local v = _floor(minV + (maxV - minV) * a + 0.5)
                valLabel.Text = tostring(v)
                render(a)
                if cb then pcall(cb, v) end
            end
            local dragging = false
            hit.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging, _isDraggingButton = true, true
                    applyFromX(i.Position.X)
                end
            end)
            local function endDrag(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
                    dragging, _isDraggingButton = false, false
                end
            end
            hit.InputEnded:Connect(endDrag)
            UIS.InputEnded:Connect(endDrag)
            UIS.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    applyFromX(i.Position.X)
                end
            end)
            local function setValue(v)
                v = _clamp(tonumber(v) or minV, minV, maxV)
                valLabel.Text = tostring(v)
                render((v - minV) / (maxV - minV))
            end
            setValue(default)
            return setValue
        end

        local function mkSelector(parent, default, cb)
            local container = Instance.new("Frame", parent)
            container.Size, container.Position, container.BackgroundTransparency, container.ZIndex = UDim2.new(0, 160, 1, 0), UDim2.new(1, -168, 0, 0), 1, 8
            local function mkNav(txt, pos)
                local b = Instance.new("TextButton", container)
                b.Size, b.Position, b.BackgroundColor3, b.BackgroundTransparency, b.BorderSizePixel = UDim2.new(0, 28, 0, 26), pos, INP, 0.7, 0
                b.Text, b.TextColor3, b.Font, b.TextSize, b.AutoButtonColor, b.ZIndex = txt, WHITE, Enum.Font.GothamBold, 13, false, 9
                Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
                local st = Instance.new("UIStroke", b); st.Color, st.Thickness = ROW_BORDER, 1
                return b
            end
            local leftBtn = mkNav("<", UDim2.new(0, 0, 0.5, -13))
            local rightBtn = mkNav(">", UDim2.new(1, -28, 0.5, -13))
            local label = Instance.new("TextLabel", container)
            label.Size, label.Position, label.BackgroundTransparency = UDim2.new(0, 88, 0, 26), UDim2.new(0.5, -44, 0.5, -13), 1
            label.Text, label.TextColor3, label.Font, label.TextSize, label.TextXAlignment, label.ZIndex = default, WHITE, Enum.Font.GothamBold, 11, Enum.TextXAlignment.Center, 9
            local function upd(t) label.Text = t end
            leftBtn.MouseButton1Click:Connect(function() if cb then cb(-1, upd) end end)
            rightBtn.MouseButton1Click:Connect(function() if cb then cb(1, upd) end end)
            return label
        end

        local function mkBox(parent, default, w, xOff, cb)
            local tb = Instance.new("TextBox", parent)
            local bw = w or 50
            tb.Size, tb.Position = UDim2.new(0, bw, 0, 24), UDim2.new(1, -math.max(xOff or 56, bw + 12), 0.5, -12)
            tb.BackgroundColor3, tb.BackgroundTransparency, tb.BorderSizePixel = INP, 0.7, 0
            tb.Text, tb.TextColor3, tb.Font, tb.TextSize, tb.ClearTextOnFocus, tb.ZIndex = tostring(default), WHITE, Enum.Font.GothamBold, 11, false, 8
            Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
            local bs = Instance.new("UIStroke", tb)
            bs.Color, bs.Thickness, bs.Transparency = ROW_BORDER, 1.2, 0.25
            tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.12), { Color = getThemeColor(), Transparency = 0 }):Play() end)
            tb.FocusLost:Connect(function()
                TS:Create(bs, TweenInfo.new(0.12), { Color = ROW_BORDER, Transparency = 0.25 }):Play()
                if cb then
                    local n = tonumber(tb.Text)
                    if n then cb(n); pcall(saveAllSettings) else tb.Text = tostring(default) end
                end
            end)
            return tb
        end

        local function mkStepper(parent, value, minV, maxV, step, decimals, cb)
            local container = Instance.new("Frame", parent)
            container.Size, container.Position, container.BackgroundTransparency, container.ZIndex = UDim2.new(0, 118, 0, 26), UDim2.new(1, -126, 0.5, -13), 1, 8
            local cur = value
            local function fmt(v)
                return (decimals and decimals > 0) and string.format("%." .. decimals .. "f", v) or tostring(_floor(v + 0.5))
            end
            local function mkChip(txt, xpos, w)
                local c = Instance.new("TextButton", container)
                c.Size, c.Position, c.BackgroundColor3, c.BackgroundTransparency, c.BorderSizePixel = UDim2.new(0, w, 0, 26), xpos, Color3.fromRGB(18, 18, 22), 0.15, 0
                c.Text, c.TextColor3, c.Font, c.TextSize, c.AutoButtonColor, c.ZIndex = txt, WHITE, Enum.Font.GothamBold, txt == "" and 12 or 16, false, 9
                Instance.new("UICorner", c).CornerRadius = UDim.new(0, 6)
                local st = Instance.new("UIStroke", c); st.Color, st.Thickness, st.Transparency = ROW_BORDER, 1, 0.35
                return c
            end
            local minusBtn = mkChip("-", UDim2.new(0, 0, 0, 0), 26)
            local valBtn = mkChip("", UDim2.new(0.5, -28, 0, 0), 56)
            valBtn.Active, valBtn.Text = false, fmt(cur)
            local plusBtn = mkChip("+", UDim2.new(1, -26, 0, 0), 26)
            local function setVal(v, fire)
                cur = _clamp(v, minV, maxV)
                valBtn.Text = fmt(cur)
                if fire and cb then cb(cur) end
            end
            minusBtn.MouseButton1Click:Connect(function() setVal(cur - step, true) end)
            plusBtn.MouseButton1Click:Connect(function() setVal(cur + step, true) end)
            return setVal
        end

        local function attachExpandArrow(row, xOff, subRows, styled)
            local arrow = Instance.new("TextButton", row)
            arrow.Size, arrow.Position = UDim2.new(0, styled and 28 or 24, 0, styled and 26 or 24), UDim2.new(1, xOff, 0.5, styled and -13 or -12)
            arrow.BackgroundColor3, arrow.BackgroundTransparency, arrow.BorderSizePixel = INP, styled and 0.7 or 1, 0
            arrow.Text, arrow.TextColor3, arrow.Font, arrow.TextSize, arrow.AutoButtonColor, arrow.ZIndex = "▼", WHITE, Enum.Font.GothamBold, 12, false, 10
            if styled then
                Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 6)
                local st = Instance.new("UIStroke", arrow); st.Color, st.Thickness = ROW_BORDER, 1
            end
            local open = false
            arrow.MouseButton1Click:Connect(function()
                open = not open
                for _, r in ipairs(subRows) do r.Visible = open end
                arrow.Text = open and "▲" or "▼"
            end)
            return arrow
        end

        -- ==================== PESTAÑA SPEED ====================
        local speedPage = contentPages["Speed"]
        mkSect(speedPage, "Auto Carry")
        setAutoCarrySpeedVisual = mkToggle(speedPage, "Auto Carry Speed", function(on) _G.StrikeSetAutoCarrySpeed(on); saveAllSettings() end)
        setAutoCarryEnemyBaseVisual = mkToggle(speedPage, "Auto Carry on Enemy Base", function(on) _G.StrikeSetAutoCarryEnemyBase(on); saveAllSettings() end)
        do
            local row = mkRow(speedPage, 38); mkLabel(row, "Enemy Base Range")
            autoCarryEnemyBaseRangeBox = mkBox(row, autoCarryEnemyBaseRange, 50, 56, function(v)
                autoCarryEnemyBaseRange = _clamp(_floor(v), 5, 150)
            end)
        end

        mkSect(speedPage, "Speed Settings")
        local function mkSpeedPairRow(title, leftCap, rightCap, leftVal, rightVal, leftCb, rightCb)
            local row = mkRow(speedPage, 72)
            local tl = Instance.new("TextLabel", row)
            tl.Size, tl.Position, tl.BackgroundTransparency = UDim2.new(0.52, 0, 0, 24), UDim2.new(0, 10, 0.5, -12), 1
            tl.Text, tl.TextColor3, tl.Font, tl.TextSize, tl.TextXAlignment, tl.TextTruncate, tl.ZIndex = title, WHITE, Enum.Font.GothamBold, 18, Enum.TextXAlignment.Left, Enum.TextTruncate.AtEnd, 8
            for _, cap in ipairs({ { leftCap, -108 }, { rightCap, -56 } }) do
                local h = Instance.new("TextLabel", row)
                h.Size, h.Position, h.BackgroundTransparency = UDim2.new(0, 46, 0, 12), UDim2.new(1, cap[2], 0, 4), 1
                h.Text, h.TextColor3, h.Font, h.TextSize, h.ZIndex = cap[1], WHITE, Enum.Font.GothamMedium, 9, 8
            end
            return mkBox(row, leftVal, 46, 108, leftCb), mkBox(row, rightVal, 46, 56, rightCb)
        end
        normalBox, carryBox = mkSpeedPairRow("Normal Speed", "normal", "carry", NS, CS,
            function(v) if v > 0 and v <= 500 then NS = v; CarrySystem.normalSpeed = v end end,
            function(v) if v > 0 and v <= 500 then CS = v; CarrySystem.carrySpeed = v end end)
        laggerBox, lagger2Box = mkSpeedPairRow("Lagger Speed", "lagger", "carry SPD", LAGGER_SPEED, LAGGER_CARRY_SPEED,
            function(v) if v > 0 and v <= 500 then LAGGER_SPEED = v; CarrySystem.laggerSpeed = v end end,
            function(v) if v > 0 and v <= 500 then LAGGER_CARRY_SPEED = v; CarrySystem.laggerCarrySpeed = v end end)
        local nmk = mkKeyButton(normalBox.Parent, KB.Carry); nmk.Size, nmk.Position = UDim2.new(0, 48, 0, 22), UDim2.new(1, -156, 0.5, -11)
        local lmk = mkKeyButton(laggerBox.Parent, KB.LaggerCarry); lmk.Size, lmk.Position = UDim2.new(0, 48, 0, 22), UDim2.new(1, -156, 0.5, -11)
        do
            local row = mkRow(speedPage, 38); mkLabel(row, "Current Mode")
            modeValLbl = Instance.new("TextLabel", row)
            modeValLbl.Size, modeValLbl.Position, modeValLbl.BackgroundTransparency = UDim2.new(0, 110, 1, 0), UDim2.new(1, -132, 0, 0), 1
            modeValLbl.Text, modeValLbl.TextColor3, modeValLbl.Font, modeValLbl.TextSize, modeValLbl.TextXAlignment, modeValLbl.ZIndex = "Normal", WHITE, Enum.Font.GothamBlack, 11, Enum.TextXAlignment.Right, 8
            local clk = Instance.new("TextButton", row)
            clk.Size, clk.BackgroundTransparency, clk.Text, clk.AutoButtonColor, clk.ZIndex = UDim2.fromScale(1, 1), 1, "", false, 8
            clk.MouseButton1Click:Connect(toggleCarryMode)
        end

        mkSect(speedPage, "Auto Movement")
        autoLeftSetVisual = mkToggle(speedPage, "Auto Left", function(on)
            autoLeftEnabled = on
            if on then startAutoLeft() else stopAutoLeft() end
            if mobSetAutoLeft then mobSetAutoLeft(on) end
        end, KB.AutoLeft)
        autoRightSetVisual = mkToggle(speedPage, "Auto Right", function(on)
            autoRightEnabled = on
            if on then startAutoRight() else stopAutoRight() end
            if mobSetAutoRight then mobSetAutoRight(on) end
        end, KB.AutoRight)

        mkSect(speedPage, "TP & Reset")
        do
            local row = mkRow(speedPage, 38)
            local title = mkLabel(row, "TP Down"); title.Size, title.TextXAlignment = UDim2.new(1, -112, 1, 0), Enum.TextXAlignment.Center
            local clk = Instance.new("TextButton", row)
            clk.Size, clk.BackgroundTransparency, clk.Text, clk.AutoButtonColor, clk.ZIndex = UDim2.new(0.58, 0, 1, 0), 1, "", false, 7
            clk.MouseButton1Click:Connect(doTpDown)
            mkKeyButton(row, KB.TPFloor)
        end

        mkSect(speedPage, "DROP")
        do
            local row = mkRow(speedPage, 42)
            local lbl = mkLabel(row, "Drop Brainrot"); lbl.Size, lbl.TextXAlignment = UDim2.new(1, -112, 1, 0), Enum.TextXAlignment.Center
            local keyBtn = mkKeyButton(row, KB.DropBrainrot); keyBtn.Size, keyBtn.Position = UDim2.new(0, 44, 0, 24), UDim2.new(1, -84, 0.5, -12)
            local on = false
            dropBrainrotSetVisual = function(v) on = v == true end
            local clk = Instance.new("TextButton", row)
            clk.Size, clk.BackgroundTransparency, clk.Text, clk.AutoButtonColor, clk.ZIndex = UDim2.new(1, -112, 1, 0), 1, "", false, 9
            clk.MouseButton1Click:Connect(function()
                if not on then on = true; executeDropWithToggle(dropBrainrotSetVisual) end
            end)

            local modeRow = mkRow(speedPage, 38); modeRow.Visible = false; mkLabel(modeRow, "Drop Mode")
            local mc = Instance.new("Frame", modeRow); mc.Size, mc.Position, mc.BackgroundTransparency, mc.ZIndex = UDim2.new(0, 92, 0, 26), UDim2.new(1, -100, 0.5, -13), 1, 8
            local function mkDropV(txt, x)
                local b = Instance.new("TextButton", mc)
                b.Size, b.Position, b.BackgroundColor3, b.BackgroundTransparency, b.BorderSizePixel = UDim2.new(0, 43, 1, 0), UDim2.new(0, x, 0, 0), INP, 0.35, 0
                b.Text, b.TextColor3, b.Font, b.TextSize, b.AutoButtonColor, b.ZIndex = txt, WHITE, Enum.Font.GothamBold, 10, false, 9
                Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
                local st = Instance.new("UIStroke", b); st.Color, st.Thickness = ROW_BORDER, 1
                return b
            end
            local v1Btn, v2Btn = mkDropV("V1", 0), mkDropV("V2", 49)
            dropModeBtnRef = v1Btn
            updateDropModeUI = function(mode)
                local isV1 = (mode == 1)
                v1Btn.BackgroundColor3 = isV1 and Color3.fromRGB(115, 115, 125) or INP
                v2Btn.BackgroundColor3 = (not isV1) and Color3.fromRGB(115, 115, 125) or INP
                v1Btn.BackgroundTransparency = isV1 and 0.05 or 0.35
                v2Btn.BackgroundTransparency = (not isV1) and 0.05 or 0.35
            end
            v1Btn.MouseButton1Click:Connect(function() if dropActive then stopDropBrainrot() end; dropMode = 1; updateDropModeUI(1); pcall(saveAllSettings) end)
            v2Btn.MouseButton1Click:Connect(function() if dropActive then stopDropBrainrot() end; dropMode = 2; updateDropModeUI(2); pcall(saveAllSettings) end)
            attachExpandArrow(row, -116, { modeRow }, true)
            updateDropModeUI(dropMode)
        end

        mkSect(speedPage, "RESET")
        do
            local row = mkRow(speedPage, 36)
            local l = mkLabel(row, "Insta Reset"); l.Size, l.TextXAlignment = UDim2.new(1, -112, 1, 0), Enum.TextXAlignment.Center
            mkKeyButton(row, KB.InstaReset)
        end

        -- ==================== PESTAÑA COMBAT ====================
        local combatPage = contentPages["Combat"]
        do
            mkSect(combatPage, "Spin Bot")
            local spinCfg = type(_G.__STRIKE_SPIN) == "table" and _G.__STRIKE_SPIN or {}
            _G.__STRIKE_SPIN = spinCfg
            spinCfg.speed = spinCfg.speed or 360
            spinCfg.power = spinCfg.power or 100
            spinCfg.expanded = spinCfg.expanded == true
            spinCfg.activeOnSteal = spinCfg.activeOnSteal == true

            local spinEnabled, spinOn, spinSpeed, spinPower, spinConn, spinAngle, spinAntiDie = false, false, spinCfg.speed, spinCfg.power, nil, 0, false
            local function stopSpin()
                safeDisconnect(spinConn); spinConn = nil
                local ch = LP.Character
                local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                if hum then pcall(function() hum.AutoRotate = true end) end
                if hrp then pcall(function() hrp.AssemblyAngularVelocity = _V3zero end) end
            end
            local function startSpin()
                if spinConn then return end
                spinAngle = 0
                spinConn = RunService.Heartbeat:Connect(function(dt)
                    if not spinEnabled then return end
                    local ch = LP.Character
                    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                    if not hrp then return end
                    if hum then pcall(function() hum.AutoRotate = false end) end
                    spinAngle = (spinAngle + spinSpeed * (spinPower / 100) * dt) % 360
                    hrp.CFrame = _CFnew(hrp.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
                    hrp.AssemblyAngularVelocity = _V3zero
                end)
            end

            local spinToggleRow = mkRow(combatPage, 38); mkLabel(spinToggleRow, "SPIN BOT")
            local spinPill, spinDot = mkPill(spinToggleRow, 48)
            local spinClk = Instance.new("TextButton", spinPill)
            spinClk.Size, spinClk.BackgroundTransparency, spinClk.Text, spinClk.AutoButtonColor, spinClk.ZIndex = UDim2.fromScale(1, 1), 1, "", false, 10
            spinClk.MouseButton1Click:Connect(function()
                spinOn = not spinOn; spinEnabled = spinOn
                animPill(spinPill, spinDot, spinOn)
                if spinOn then
                    startSpin()
                    if not antiDieEnabled and not spinAntiDie then spinAntiDie = true; pcall(AntiDieModule.start) end
                else
                    stopSpin()
                    if spinAntiDie and not antiDieEnabled then spinAntiDie = false; pcall(AntiDieModule.stop) end
                end
            end)

            local aosActive = false
            local setAosVisual = mkToggle(combatPage, "ACTIVE ON STEAL", function(on)
                spinCfg.activeOnSteal = on
                pcall(saveAllSettings)
            end)
            setAosVisual(spinCfg.activeOnSteal)
            RunService.Heartbeat:Connect(function()
                if not spinCfg.activeOnSteal then
                    if aosActive then
                        aosActive = false; spinEnabled = spinOn
                        if spinEnabled then startSpin() else stopSpin() end
                    end
                    return
                end
                local stealing = CarrySystem:isCarrying()
                if stealing then
                    if not aosActive and not spinEnabled then
                        aosActive = true; spinEnabled = true; startSpin()
                        if not antiDieEnabled and not spinAntiDie then spinAntiDie = true; pcall(AntiDieModule.start) end
                    end
                elseif aosActive then
                    aosActive = false; spinEnabled = spinOn
                    if spinEnabled then
                        startSpin()
                    else
                        stopSpin()
                        if spinAntiDie and not antiDieEnabled then spinAntiDie = false; pcall(AntiDieModule.stop) end
                    end
                end
            end)

            local spinSpeedRow = mkRow(combatPage, 38); mkLabel(spinSpeedRow, "Spin Speed")
            local setSpinSpeed = mkSlider(spinSpeedRow, 0, 7200, spinSpeed, function(v) spinSpeed = v; spinCfg.speed = v; pcall(saveAllSettings) end)
            local spinPowerRow = mkRow(combatPage, 38); mkLabel(spinPowerRow, "Spin Power %")
            local setSpinPower = mkSlider(spinPowerRow, 0, 100, spinPower, function(v) spinPower = v; spinCfg.power = v; pcall(saveAllSettings) end)

            local spinArrow = Instance.new("TextButton", spinToggleRow)
            spinArrow.Size, spinArrow.AnchorPoint, spinArrow.Position = UDim2.new(0, 26, 0, 22), Vector2.new(0.5, 0.5), UDim2.new(1, -92, 0.5, 0)
            spinArrow.BackgroundColor3, spinArrow.BackgroundTransparency, spinArrow.AutoButtonColor = Color3.fromRGB(28, 28, 28), 0.15, false
            spinArrow.Text, spinArrow.TextColor3, spinArrow.Font, spinArrow.TextSize, spinArrow.ZIndex = "▼", WHITE, Enum.Font.GothamBold, 12, 10
            Instance.new("UICorner", spinArrow).CornerRadius = UDim.new(0, 6)
            local sas = Instance.new("UIStroke", spinArrow); sas.Color, sas.Thickness, sas.Transparency = ROW_BORDER, 1, 0.45

            local function applySpinExpanded(exp, save)
                spinSpeedRow.Visible, spinPowerRow.Visible = exp, exp
                spinArrow.Text = exp and "▲" or "▼"
                spinCfg.expanded = exp
                if save then pcall(saveAllSettings) end
            end
            spinArrow.MouseButton1Click:Connect(function() applySpinExpanded(not spinCfg.expanded, true) end)
            applySpinExpanded(spinCfg.expanded, false)
            _G.__STRIKE_SPIN_REFRESH = function()
                spinSpeed, spinPower = spinCfg.speed or 360, spinCfg.power or 100
                pcall(setSpinSpeed, spinSpeed); pcall(setSpinPower, spinPower)
                applySpinExpanded(spinCfg.expanded == true, false)
                pcall(setAosVisual, spinCfg.activeOnSteal == true)
            end
        end

        mkSect(combatPage, "Anti Ragdoll")
        do
            local arVisual, row = mkToggle(combatPage, "Anti Ragdoll", function(nextOn)
                setAntiRagdollMode(nextOn and (antiRagdollMode == "off" and "v2" or antiRagdollMode) or "off")
            end)
            setAntiRagdollVisual = arVisual
            local modeRow = mkRow(combatPage, 38); modeRow.Visible = false; mkLabel(modeRow, "Ragdoll Mode")
            local mc = Instance.new("Frame", modeRow); mc.Size, mc.Position, mc.BackgroundTransparency, mc.ZIndex = UDim2.new(0, 92, 0, 26), UDim2.new(1, -100, 0.5, -13), 1, 8
            local function mkRagBtn(txt, x)
                local b = Instance.new("TextButton", mc)
                b.Size, b.Position, b.BackgroundColor3, b.BackgroundTransparency, b.BorderSizePixel = UDim2.new(0, 43, 1, 0), UDim2.new(0, x, 0, 0), INP, 0.35, 0
                b.Text, b.TextColor3, b.Font, b.TextSize, b.AutoButtonColor, b.ZIndex = txt, WHITE, Enum.Font.GothamBold, 10, false, 9
                Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
                return b
            end
            local v1Btn, v2Btn = mkRagBtn("V1", 0), mkRagBtn("V2", 49)
            local selCol = Color3.fromRGB(132, 143, 160)
            updateAntiRagdollModeUI = function(mode)
                local a1, a2 = (mode == "v1"), (mode == "v2")
                v1Btn.BackgroundColor3, v2Btn.BackgroundColor3 = a1 and selCol or INP, a2 and selCol or INP
                v1Btn.BackgroundTransparency, v2Btn.BackgroundTransparency = a1 and 0 or 0.35, a2 and 0 or 0.35
                v1Btn.TextColor3, v2Btn.TextColor3 = a1 and Color3.fromRGB(20, 20, 24) or WHITE, a2 and Color3.fromRGB(20, 20, 24) or WHITE
                arVisual(mode ~= "off")
            end
            v1Btn.MouseButton1Click:Connect(function() setAntiRagdollMode("v1") end)
            v2Btn.MouseButton1Click:Connect(function() setAntiRagdollMode("v2") end)
            attachExpandArrow(row, -94, { modeRow }, true)
            updateAntiRagdollModeUI(antiRagdollMode)
        end

        setInfiniteJumpVisual = mkToggle(combatPage, "Infinite Jump", function(on)
            infiniteJumpEnabled = on == true
            _G.__STRIKE_FEATURE_CONFIG.infiniteJumpEnabled = infiniteJumpEnabled
            if infiniteJumpEnabled then InfiniteJump.start() else InfiniteJump.stop() end
            saveAllSettings()
        end)
        setInfiniteJumpVisual(infiniteJumpEnabled)
        do
            local row = mkRow(combatPage, 42); mkLabel(row, "Jump Mode")
            local mb = Instance.new("TextButton", row)
            mb.Size, mb.Position, mb.BackgroundColor3, mb.BackgroundTransparency, mb.BorderSizePixel = UDim2.new(0, 100, 1, 0), UDim2.new(1, -108, 0, 0), INP, 0.4, 0
            mb.Text, mb.TextColor3, mb.Font, mb.TextSize, mb.ZIndex = InfiniteJump.mode:upper(), WHITE, Enum.Font.GothamBold, 11, 8
            Instance.new("UICorner", mb).CornerRadius = UDim.new(0, 6)
            setInfiniteJumpModeVisual = function(mode)
                mb.Text = (mode == "manual" and "manual" or "hold"):upper()
            end
            mb.Activated:Connect(function()
                local nextMode = InfiniteJump.mode == "hold" and "manual" or "hold"
                InfiniteJump.setMode(nextMode)
                setInfiniteJumpModeVisual(nextMode)
                if InfiniteJump.enabled then InfiniteJump.stop(); InfiniteJump.start() end
                pcall(saveAllSettings)
            end)
        end

        mkSect(combatPage, "Proteccion")
        setAntiDieVisual = mkToggle(combatPage, "Anti Die", function(on)
            antiDieEnabled = on == true
            _G.__STRIKE_FEATURE_CONFIG.antiDieEnabled = antiDieEnabled
            if antiDieEnabled then AntiDieModule.start() else AntiDieModule.stop() end
            saveAllSettings()
        end)
        setAntiDieVisual(antiDieEnabled)
        setAntiFlingVisual = mkToggle(combatPage, "Anti Fling", function(on)
            antiFlingEnabled = on == true
            _G.__STRIKE_FEATURE_CONFIG.antiFlingEnabled = antiFlingEnabled
            if antiFlingEnabled then AntiFlingModule.start() else AntiFlingModule.stop() end
            saveAllSettings()
        end)
        setAntiFlingVisual(antiFlingEnabled)

        mkSect(combatPage, "Counters")
        setBatCounterVisual = mkToggle(combatPage, "Bat Counter", function(on)
            batCounterEnabled = on
            if on then startBatCounter() else stopBatCounter() end
        end)
        setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on)
            medusaCounterEnabled = on
            if on and LP.Character then setupMedusaCounter(LP.Character) else stopMedusaCounter() end
        end)

        mkSect(combatPage, "Aimbots")
        do
            local abVisual, abRow = mkToggle(combatPage, "Auto Bat", function(on)
                if on then enableAutoBat() else disableAutoBat() end
                if mobSetAutoBat then mobSetAutoBat(on) end
            end, KB.AutoBat)
            autoBatSetVisual = abVisual
            local abSpeedRow = mkRow(combatPage, 38); abSpeedRow.Visible = false; mkLabel(abSpeedRow, "Bat Aimbot Speed")
            batSpeedBox = mkBox(abSpeedRow, BAT_AIMBOT_SPEED, 50, 56, function(v)
                if v > 0 and v <= 200 then BAT_AIMBOT_SPEED = v end
            end)
            attachExpandArrow(abRow, -174, { abSpeedRow }, false)
        end

        mkSect(combatPage, "TP BAT")
        batDesyncTpSetVisual = mkToggle(combatPage, "TP BAT Auto", function(on)
            if on and not batDesyncTpEnabled then startBatDesyncTp()
            elseif not on and batDesyncTpEnabled then stopBatDesyncTp() end
        end, KB.TPBat)
        batDesyncTpSetVisual(batDesyncTpEnabled)
        tpBatCamLockSetVisual = mkToggle(combatPage, "TP Camera Lock", function(on)
            TPBAT_CFG.cameraLock = on
            pcall(saveAllSettings)
        end)
        tpBatCamLockSetVisual(TPBAT_CFG.cameraLock)

        do
            local bbVisual, bbRow = mkToggle(combatPage, "Bat Bypass", function(on)
                if on then enableBatBypass() else disableBatBypass() end
            end, KB.BatBypass)
            autoBatBypassSetVisual = bbVisual
            autoBatBypassSetVisual(autoBatBypassEnabled)
            local bbSpeedRow = mkRow(combatPage, 38); bbSpeedRow.Visible = false; mkLabel(bbSpeedRow, "Bat Bypass Speed")
            batBypassBox = mkBox(bbSpeedRow, BAT_BYPASS_SPEED, 50, 56, function(v)
                if v > 0 and v <= 200 then BAT_BYPASS_SPEED = v; BatBypass.speed = v end
            end)
            attachExpandArrow(bbRow, -174, { bbSpeedRow }, false)
        end

        -- ==================== PESTAÑA VISUAL ====================
        local visualPage = contentPages["Visual"]
        mkSect(visualPage, "ESP")
        do
            local espVis, row = mkToggle(visualPage, "ESP", toggleESP)
            setESPVIsual = espVis; espVis(espEnabled)
            local boxVis, boxRow = mkToggle(visualPage, "Boxed ESP", toggleESPBox)
            boxRow.Visible = false; setESPBoxVisual = boxVis; boxVis(espBoxEnabled)
            local trVis, trRow = mkToggle(visualPage, "Show Tracker", toggleESPTracker)
            trRow.Visible = false; setESPTrackerVisual = trVis; trVis(espTrackerEnabled)
            local ragVis, ragRow = mkToggle(visualPage, "Ragdoll Countdown", toggleRagdollCountdown)
            ragRow.Visible = false; setRagdollCountdownVisual = ragVis; ragVis(ragdollCountdownEnabled)
            attachExpandArrow(row, -94, { boxRow, trRow, ragRow }, true)
        end
        setAntiTpEspVisual = mkToggle(visualPage, "Anti TP ESP", toggleAntiTpEsp)
        setAntiTpEspVisual(antiTpEspEnabled)

        do
            local us = type(_G.__STRIKE_ULTRA) == "table" and _G.__STRIKE_ULTRA or { on = false, runtimeOn = false, conns = {}, originals = {} }
            _G.__STRIKE_ULTRA = us
            local function ultraApply(inst)
                pcall(function()
                    if inst:IsA("BasePart") then
                        us.originals[inst] = us.originals[inst] or { Material = inst.Material, Reflectance = inst.Reflectance, CastShadow = inst.CastShadow }
                        inst.Material, inst.Reflectance, inst.CastShadow = Enum.Material.SmoothPlastic, 0.75, false
                    end
                end)
            end
            local function ultraFx(cls, nm)
                local e = Lighting:FindFirstChild(nm)
                if e and not e:IsA(cls) then safeDestroy(e); e = nil end
                if not e then e = Instance.new(cls); e.Name = nm; e.Parent = Lighting end
                return e
            end
            local function startUltra()
                us.on = true
                if not us.runtimeOn then
                    us.runtimeOn = true
                    for _, d in ipairs(Workspace:GetDescendants()) do ultraApply(d) end
                    for _, c in ipairs(us.conns) do safeDisconnect(c) end
                    us.conns = { Workspace.DescendantAdded:Connect(function(d) if us.on then ultraApply(d) end end) }
                end
                local bloom = ultraFx("BloomEffect", "StrikeUltraBloom"); bloom.Intensity, bloom.Size, bloom.Threshold, bloom.Enabled = 1.6, 95, 0.75, true
                local sun = ultraFx("SunRaysEffect", "StrikeUltraSunRays"); sun.Intensity, sun.Spread, sun.Enabled = 0.55, 1, true
                local cc = ultraFx("ColorCorrectionEffect", "StrikeUltraColorCorrection"); cc.Saturation, cc.Contrast, cc.Brightness, cc.Enabled = 0.9, 0.22, 0.07, true
            end
            local function stopUltra()
                us.on, us.runtimeOn = false, false
                for _, c in ipairs(us.conns) do safeDisconnect(c) end
                us.conns = {}
                for inst, orig in pairs(us.originals) do
                    pcall(function() inst.Material, inst.Reflectance, inst.CastShadow = orig.Material, orig.Reflectance, orig.CastShadow end)
                end
                us.originals = {}
                for _, nm in ipairs({ "StrikeUltraBloom", "StrikeUltraSunRays", "StrikeUltraColorCorrection" }) do
                    safeDestroy(Lighting:FindFirstChild(nm))
                end
            end
            _G.__STRIKE_ULTRA_START, _G.__STRIKE_ULTRA_STOP = startUltra, stopUltra
            _G.__STRIKE_ULTRA_SET_VISUAL = mkToggle(visualPage, "Ultra Mode", function(on)
                if on then startUltra() else stopUltra() end
                pcall(saveAllSettings)
            end)
        end

        mkSect(visualPage, "Camera")
        _G.stretchToggleSetter = mkToggle(visualPage, "Stretch Rez", function(on)
            stretchEnabled = on
            if on then enableStretch() else disableStretch() end
        end)
        do
            local fovVis, fovRow = mkToggle(visualPage, "FOV", function(on)
                if on then enableCustomFov() else disableCustomFov() end
            end)
            setFovVisual = fovVis; fovVis(fovEnabled)
            local fovValRow = mkRow(visualPage, 38); fovValRow.Visible = false; mkLabel(fovValRow, "FOV Value")
            fovSliderSet = mkSlider(fovValRow, 20, 120, fovValue, function(v)
                fovValue = v
                if not fovEnabled then enableCustomFov(); fovVis(true) end
                local cam = Workspace.CurrentCamera
                if cam then pcall(function() cam.FieldOfView = fovValue end) end
            end)
            attachExpandArrow(fovRow, -100, { fovValRow }, false)
        end
        setAntiLagVisual = mkToggle(visualPage, "Anti Lag", function(on)
            if on then enableAntiLag() else disableAntiLag() end
        end)

        mkSect(visualPage, "ANTI EO1")
        StrikeShowE01WarningSetVisual = mkToggle(visualPage, "Show E01 Warning", function(on)
            StrikeShowE01Warning = on == true
            if not StrikeShowE01Warning then
                StrikeE01StartedAt = nil
                if StrikeE01Gui then StrikeE01Gui.Enabled = false end
            end
            saveAllSettings()
        end)
        StrikeShowE01WarningSetVisual(StrikeShowE01Warning)

        mkSect(visualPage, "Sky Theme")
        do
            local row = mkRow(visualPage, 38); mkLabel(row, "Sky Theme")
            skySelectorLabel = mkSelector(row, skyTheme, function(dir, update)
                local idx = table.find(SKY_PRESETS_LIST, skyTheme) or 1
                idx = ((idx - 1 + dir) % #SKY_PRESETS_LIST) + 1
                local name = SKY_PRESETS_LIST[idx]
                skyTheme = name
                pcall(applyCustomSky, name)
                if update then update(name) end
                pcall(saveAllSettings)
            end)
        end

        -- ==================== ANIMATIONS (Unificado Animation + Pack Animation) ====================
        mkSect(visualPage, "ANIMATIONS")
        do
            local ANIM_PACKS = {
                ["Ninja"]     = { idle = {656117400,656118341},   walk = 656121766,  run = 656118852,  jump = 656117878,  fall = 656115606,  climb = 656114359,  swim = 656119721,  swimidle = 656120133 },
                ["Zombie"]    = { idle = {616158929,616160636},   walk = 616168032,  run = 616163682,  jump = 616161997,  fall = 616157476,  climb = 616156119,  swim = 616165109,  swimidle = 616166655 },
                ["Werewolf"]  = { idle = {1083445855,1083450166}, walk = 1083473930, run = 1083462077, jump = 1083455352, fall = 1083443587, climb = 1083439238, swim = 1083467779, swimidle = 1083471346 },
                ["Superhero"] = { idle = {616111295,616113536},   walk = 616122287,  run = 616117076,  jump = 616115533,  fall = 616108001,  climb = 616104706,  swim = 616119430,  swimidle = 616120211 },
                ["Toy"]       = { idle = {782841498,782845736},   walk = 782843345,  run = 782842708,  jump = 782847020,  fall = 782846423,  climb = 782843869,  swim = 782844582,  swimidle = 782845091 },
                ["Robot"]     = { idle = {616090211,616088211},   walk = 616095330,  run = 616091570,  jump = 616090535,  fall = 616086894,  climb = 616086790,  swim = 616092998,  swimidle = 616093932 },
                ["Mage"]      = { idle = {707742142,707855907},   walk = 707897309,  run = 707861613,  jump = 707853694,  fall = 707829716,  climb = 707826056,  swim = 707876443,  swimidle = 707887908 },
                ["Astronaut"] = { idle = {891621366,891633237},   walk = 891667138,  run = 891636393,  jump = 891627522,  fall = 891617961,  climb = 891609353,  swim = 891663592,  swimidle = 891661553 },
                ["Stylish"]   = { idle = {616006778,616008087},   walk = 616013216,  run = 616010382,  jump = 616008936,  fall = 616005863,  climb = 616003713,  swim = 616011509,  swimidle = 616012453 },
            }
            ANIM_ORDER = { "OFF", "Ninja", "Zombie", "Werewolf", "Superhero", "Toy", "Robot", "Mage", "Astronaut", "Stylish" }
            local PACK_ANIMATION_OPTIONS = {
                { name = "OFF", id = nil },
                { name = "Superhéroes", id = 5323719264954 },
                { name = "Anim Aura", id = 57407001153595 },
                { name = "Headless Horseman", id = 39828799949211 },
                { name = "Aura Voladora", id = 254632800573246 },
            }
            local PACK_ANIMATION_ORDER = { "OFF", "Superhéroes", "Anim Aura", "Headless Horseman", "Aura Voladora" }
            local ANIM_GROUPS = { "idle", "walk", "run", "jump", "fall", "climb", "swim", "swimidle" }
            local defaultsByAnimate = _G.__STRIKE_ANIM_DEFAULTS or setmetatable({}, { __mode = "k" })
            _G.__STRIKE_ANIM_DEFAULTS = defaultsByAnimate
            local packBundleCache, packBundleLoading = {}, {}

            local function getAnimate(waitTime)
                local ch = LP and LP.Character
                if not ch then return nil end
                return waitTime and (ch:FindFirstChild("Animate") or ch:WaitForChild("Animate", waitTime)) or ch:FindFirstChild("Animate")
            end

            local function captureDefaults(animate)
                if defaultsByAnimate[animate] then return defaultsByAnimate[animate] end
                local defs = {}
                for _, gn in ipairs(ANIM_GROUPS) do
                    local grp = animate:FindFirstChild(gn)
                    if grp then
                        local ids = {}
                        for _, child in ipairs(grp:GetChildren()) do
                            if child:IsA("Animation") then ids[#ids + 1] = child.AnimationId end
                        end
                        defs[gn] = ids
                    end
                end
                defaultsByAnimate[animate] = defs
                return defs
            end

            local function restoreDefaults(animate)
                local defs = captureDefaults(animate)
                for gn, ids in pairs(defs) do
                    local grp = animate:FindFirstChild(gn)
                    if grp then
                        local idx = 1
                        for _, child in ipairs(grp:GetChildren()) do
                            if child:IsA("Animation") then
                                if ids[idx] then child.AnimationId = ids[idx] end
                                idx = idx + 1
                            end
                        end
                    end
                end
            end

            local function setAnimGroup(animate, groupName, value)
                local grp = animate:FindFirstChild(groupName)
                if not grp or not value then return end
                local anims = {}
                for _, child in ipairs(grp:GetChildren()) do
                    if child:IsA("Animation") then anims[#anims + 1] = child end
                end
                for i, anim in ipairs(anims) do
                    local id = type(value) == "table" and (value[i] or value[#value]) or value
                    if id then
                        local s = tostring(id)
                        anim.AnimationId = s:find("rbxassetid://", 1, true) and s or ("rbxassetid://" .. s)
                    end
                end
            end

            local function restartAnimate(animate, soft)
                local hum = animate and animate.Parent and animate.Parent:FindFirstChildOfClass("Humanoid")
                if hum then
                    for _, tr in ipairs(hum:GetPlayingAnimationTracks()) do
                        if not soft or tr.Priority == Enum.AnimationPriority.Core then
                            pcall(function() tr:Stop(soft and 0.12 or 0) end)
                        end
                    end
                end
                if soft then
                    if hum then pcall(function() hum:ChangeState(hum:GetState()) end) end
                else
                    pcall(function() animate.Disabled = true; task.wait(0.05); animate.Disabled = false end)
                end
            end

            local function syncSelectors()
                if animSelectorLabel then animSelectorLabel.Text = currentAnimPack or "OFF" end
                if packAnimationSelectorLabel then packAnimationSelectorLabel.Text = currentPackAnimation or "OFF" end
                animIndex = table.find(ANIM_ORDER, currentAnimPack or "OFF") or 1
                packAnimationIndex = table.find(PACK_ANIMATION_ORDER, currentPackAnimation or "OFF") or 1
            end

            local function detectCategory(text)
                local v = tostring(text or ""):lower()
                if v:find("swimidle", 1, true) or v:find("swim idle", 1, true) then return "swimidle" end
                if v:find("idle", 1, true) or v:find("reposo", 1, true) then return "idle" end
                if v:find("walk", 1, true) or v:find("caminar", 1, true) then return "walk" end
                if v:find("run", 1, true) or v:find("correr", 1, true) then return "run" end
                if v:find("jump", 1, true) or v:find("saltar", 1, true) then return "jump" end
                if v:find("fall", 1, true) or v:find("caer", 1, true) then return "fall" end
                if v:find("climb", 1, true) or v:find("escalar", 1, true) then return "climb" end
                if v:find("swim", 1, true) or v:find("nadar", 1, true) or v:find("natac", 1, true) then return "swim" end
                return nil
            end

            local function extractBundle(bundleId)
                if packBundleCache[bundleId] then return packBundleCache[bundleId] end
                if packBundleLoading[bundleId] then
                    local t0 = os.clock()
                    while packBundleLoading[bundleId] and os.clock() - t0 < 45 do task.wait(0.1) end
                    return packBundleCache[bundleId]
                end
                packBundleLoading[bundleId] = true
                local result, total = {}, 0
                local ok, details = pcall(function() return AssetService:GetBundleDetailsAsync(bundleId) end)
                if not ok or not details or not details.Items then
                    packBundleLoading[bundleId] = nil
                    return nil
                end
                for idx, item in ipairs(details.Items) do
                    if item.Type == "Asset" and item.Id then
                        local itemCat = detectCategory(item.Name)
                        local okObj, objs = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(item.Id)) end)
                        if okObj and type(objs) == "table" then
                            for _, root in ipairs(objs) do
                                for _, desc in ipairs(root:GetDescendants()) do
                                    if desc:IsA("Animation") and desc.AnimationId ~= "" then
                                        local cat = detectCategory(desc:GetFullName()) or itemCat
                                        if cat then
                                            result[cat] = result[cat] or {}
                                            table.insert(result[cat], desc.AnimationId)
                                            total = total + 1
                                        end
                                    end
                                end
                                if root:IsA("Animation") and root.AnimationId ~= "" and itemCat then
                                    result[itemCat] = result[itemCat] or {}
                                    table.insert(result[itemCat], root.AnimationId)
                                    total = total + 1
                                end
                                safeDestroy(root)
                            end
                        end
                    end
                    if idx % 2 == 0 then task.wait() end
                end
                packBundleLoading[bundleId] = nil
                if total > 0 then packBundleCache[bundleId] = result; return result end
                return nil
            end

            local function applyAnimPack(name, fromLoad)
                local canonical = "OFF"
                local upper = tostring(name or "OFF"):upper()
                for _, cand in ipairs(ANIM_ORDER) do
                    if cand:upper() == upper then canonical = cand; break end
                end
                local animate = getAnimate()
                if not animate then currentAnimPack = canonical; syncSelectors(); return end
                captureDefaults(animate)
                if canonical ~= "OFF" then
                    _G.__STRIKE_PACK_APPLY_TOKEN = (_G.__STRIKE_PACK_APPLY_TOKEN or 0) + 1
                    currentPackAnimation = "OFF"
                end
                currentAnimPack = canonical
                syncSelectors()
                if canonical == "OFF" then
                    restoreDefaults(animate)
                else
                    local pack = ANIM_PACKS[canonical]
                    if pack then for _, gn in ipairs(ANIM_GROUPS) do setAnimGroup(animate, gn, pack[gn]) end end
                end
                restartAnimate(animate, false)
                if not fromLoad and not _isLoading then pcall(saveAllSettings) end
            end

            local function applyPackAnimation(name, fromLoad)
                local selected = "OFF"
                local low = tostring(name or "OFF"):lower()
                for _, cand in ipairs(PACK_ANIMATION_ORDER) do
                    if cand:lower() == low then selected = cand; break end
                end
                local animate = getAnimate(5)
                if not animate then return false end
                captureDefaults(animate)
                _G.__STRIKE_PACK_APPLY_TOKEN = (_G.__STRIKE_PACK_APPLY_TOKEN or 0) + 1
                local tok = _G.__STRIKE_PACK_APPLY_TOKEN

                if selected == "OFF" then
                    currentPackAnimation = "OFF"
                    syncSelectors()
                    restoreDefaults(animate)
                    restartAnimate(animate, true)
                    if not fromLoad and not _isLoading then pcall(saveAllSettings) end
                    return true
                end

                if packAnimationSelectorLabel then packAnimationSelectorLabel.Text = selected .. " ..." end
                task.spawn(function()
                    local opt
                    for _, it in ipairs(PACK_ANIMATION_OPTIONS) do if it.name == selected then opt = it; break end end
                    local extracted = opt and opt.id and extractBundle(opt.id)
                    if tok ~= _G.__STRIKE_PACK_APPLY_TOKEN or animate ~= getAnimate() then return end
                    if not extracted then syncSelectors(); return end
                    local count = 0
                    for _, gn in ipairs(ANIM_GROUPS) do if extracted[gn] then count = count + #extracted[gn] end end
                    if count == 0 then syncSelectors(); return end
                    currentAnimPack, currentPackAnimation = "OFF", selected
                    syncSelectors()
                    restoreDefaults(animate)
                    for _, gn in ipairs(ANIM_GROUPS) do
                        if extracted[gn] and #extracted[gn] > 0 then setAnimGroup(animate, gn, extracted[gn]) end
                    end
                    restartAnimate(animate, true)
                    if not fromLoad and not _isLoading then pcall(saveAllSettings) end
                end)
                return true
            end

            applyAnimPackGlobal = function(name) applyAnimPack(name or currentAnimPack or "OFF", true); syncSelectors() end
            applyPackAnimationGlobal = function(name) applyPackAnimation(name or currentPackAnimation or "OFF", true); syncSelectors() end
            syncSelectors()

            local animRow = mkRow(visualPage, 38); mkLabel(animRow, "Animation")
            animSelectorLabel = mkSelector(animRow, currentAnimPack or "OFF", function(dir, update)
                animIndex = ((animIndex - 1 + dir) % #ANIM_ORDER) + 1
                local sel = ANIM_ORDER[animIndex]
                if update then update(sel) end
                applyAnimPack(sel, false)
            end)

            local packRow = mkRow(visualPage, 38); mkLabel(packRow, "Pack Animation")
            packAnimationSelectorLabel = mkSelector(packRow, currentPackAnimation or "OFF", function(dir, update)
                packAnimationIndex = ((packAnimationIndex - 1 + dir) % #PACK_ANIMATION_ORDER) + 1
                local sel = PACK_ANIMATION_ORDER[packAnimationIndex]
                if update then update(sel) end
                applyPackAnimation(sel, false)
            end)

            if not _G.__STRIKE_ANIM_RESPAWN_HOOK then
                _G.__STRIKE_ANIM_RESPAWN_HOOK = true
                LP.CharacterAdded:Connect(function(ch)
                    task.delay(0.65, function()
                        if ch ~= LP.Character then return end
                        if applyAnimPackGlobal then pcall(applyAnimPackGlobal, currentAnimPack or "OFF") end
                        if currentPackAnimation and currentPackAnimation ~= "OFF" and applyPackAnimationGlobal then
                            task.delay(0.2, function()
                                if ch == LP.Character then pcall(applyPackAnimationGlobal, currentPackAnimation) end
                            end)
                        end
                    end)
                end)
            end
        end

        -- ==================== COSMETICS (SKINS + BAT/MEDUSA SKINS) ====================
        do
            _G.StrikeDisplaySkinState = _G.StrikeDisplaySkinState or { _skinApplyToken = 0, displaySkin = "Off", customSkinEnabled = false }
            local S = _G.StrikeDisplaySkinState
            if type(_G.__StrikeSavedDisplaySkin) == "string" then
                S.displaySkin = _G.__StrikeSavedDisplaySkin
                S.customSkinEnabled = S.displaySkin ~= "Off" and S.displaySkin ~= "None"
            end
            StrikeDisplaySkin = {}
            STRIKE_DISPLAY_SKIN_ORDER = { "Off", "PURPLE", "BLUE", "RED", "BLACK", "GREEN", "WHITE", "BLEED 1", "BLEED 2", "BLEED 3", "BLEED 4", "BLEED 5" }
            STRIKE_DISPLAY_SKIN_SETS = {
                ["BLEED 1"] = { accessories = { 306969564 },       shirtTemplate = "rbxassetid://10632503795",   pantsTemplate = "rbxassetid://123161592384863", headMesh = "rbxassetid://134079402",   headTexture = "rbxassetid://133940918", color = Color3.new(1, 1, 1) },
                ["BLEED 2"] = { accessories = { 1744060292 },      shirtTemplate = "rbxassetid://11526718530",   pantsTemplate = "rbxassetid://93710523210027",  headMesh = "rbxassetid://134079402",   headTexture = "rbxassetid://133940918", color = Color3.new(1, 1, 1) },
                ["BLEED 3"] = { accessories = { 112564966849233 }, shirtTemplate = "rbxassetid://11849088376",   pantsTemplate = "rbxassetid://16534673928",     headMesh = "rbxassetid://134079402",   headTexture = "rbxassetid://133940918", color = Color3.new(1, 1, 1) },
                ["BLEED 4"] = { accessories = { 10159600649 },     shirtTemplate = "rbxassetid://9683332638",    pantsTemplate = "rbxassetid://93182020184041",  headMesh = "rbxassetid://134079402",   headTexture = "rbxassetid://133940918", color = Color3.new(1, 1, 1) },
                ["BLEED 5"] = { accessories = { 8349240186 },      shirtTemplate = "rbxassetid://11926549070",   pantsTemplate = "rbxassetid://13189494471",     headMesh = "rbxassetid://16673245747", headTexture = nil,                       color = Color3.new(1, 1, 1) },
                PURPLE = { hats = "1744060292,439945661,1125510,1029025", hair = "", headless = true, accessories = { 1744060292, 439945661, 1125510, 1029025, 11748356, 8465506143, 11444217173 }, clothing = { 7424637509, 7689651773 }, color = Color3.fromRGB(200, 200, 200) },
                BLUE   = { hats = "74891470", hair = "16630147,6346833550,6594911228,6594919952,6823338112,7097747842", headless = true, accessories = { 74891470, 16630147, 6346833550, 6594911228, 6594919952, 6823338112, 7097747842 }, clothing = { 18423061209, 18423154566 }, color = Color3.fromRGB(55, 145, 255) },
                RED    = { hats = "215718515,439945661", hair = "7183785281", headless = true, accessories = { 215718515, 439945661, 7183785281 }, clothing = { 15998365201, 7689651773 }, color = Color3.fromRGB(235, 62, 72) },
                BLACK  = { hats = "10159600649,439946249,17798262442,92482095662016", hair = "139101716417676", headless = true, accessories = { 10159600649, 439946249, 17798262442, 92482095662016, 139101716417676, 12490213797 }, clothing = { 18766106994, 13925390578 }, color = Color3.fromRGB(24, 24, 30) },
                GREEN  = { hats = "553970961,1744060292", hair = "93268856876777", headless = true, accessories = { 553970961, 1744060292, 93268856876777 }, clothing = { 9478068776, 6348682339 }, color = Color3.fromRGB(62, 210, 112) },
                WHITE  = { hats = "74891470,215718515,439945661,1016143686,1744060292,10159600649,89012651581593,88365652378427", hair = "126447390530523", headless = true, accessories = { 74891470, 215718515, 439945661, 1016143686, 1744060292, 10159600649, 89012651581593, 126447390530523 }, clothing = { 88032876921227, 108259950755140 }, color = Color3.fromRGB(238, 238, 244) },
            }
            STRIKE_DISPLAY_ASSET_PROPERTIES = {
                [1744060292]="HatAccessory",[439945661]="HatAccessory",[1125510]="HatAccessory",[1029025]="HatAccessory",[8465506143]="HatAccessory",[74891470]="HatAccessory",[215718515]="HatAccessory",[10159600649]="HatAccessory",[439946249]="HatAccessory",[17798262442]="HatAccessory",[92482095662016]="HatAccessory",[553970961]="HatAccessory",[1016143686]="HatAccessory",[89012651581593]="HatAccessory",[88365652378427]="HatAccessory",
                [16630147]="HairAccessory",[6346833550]="HairAccessory",[6594911228]="HairAccessory",[6594919952]="HairAccessory",[6823338112]="HairAccessory",[7097747842]="HairAccessory",[7183785281]="HairAccessory",[139101716417676]="HairAccessory",[93268856876777]="HairAccessory",[126447390530523]="HairAccessory",
                [11748356]="FaceAccessory",[12490213797]="FaceAccessory",[11444217173]="NeckAccessory",
                [7424637509]="Shirt",[18423061209]="Shirt",[15998365201]="Shirt",[18766106994]="Shirt",[9478068776]="Shirt",[88032876921227]="Shirt",
                [7689651773]="Pants",[18423154566]="Pants",[13925390578]="Pants",[6348682339]="Pants",[108259950755140]="Pants",
            }
            local origDesc = setmetatable({}, { __mode = "k" })
            local origOutfits = setmetatable({}, { __mode = "k" })

            local function isSkinItem(c) return c:IsA("Accessory") or c:IsA("Accoutrement") or c:IsA("Shirt") or c:IsA("Pants") or c:IsA("ShirtGraphic") end

            local function attachAcc(ch, hum, acc)
                local handle = acc:FindFirstChild("Handle", true)
                pcall(function() hum:AddAccessory(acc) end)
                if not acc.Parent then acc.Parent = ch end
                if not handle or not handle:IsA("BasePart") then return acc.Parent == ch end
                local hAtt = handle:FindFirstChildWhichIsA("Attachment")
                if not hAtt then return acc.Parent == ch end
                local tAtt
                for _, d in ipairs(ch:GetDescendants()) do
                    if d:IsA("Attachment") and d.Name == hAtt.Name and not d:IsDescendantOf(acc) then tAtt = d; break end
                end
                if tAtt and tAtt.Parent:IsA("BasePart") then
                    handle.Anchored, handle.CanCollide, handle.CanTouch, handle.CanQuery, handle.Massless = false, false, false, false, true
                    handle.CFrame = tAtt.Parent.CFrame * tAtt.CFrame * hAtt.CFrame:Inverse()
                    if not handle:FindFirstChild("StrikeAccessoryWeld") then
                        local w = Instance.new("WeldConstraint", handle)
                        w.Name, w.Part0, w.Part1 = "StrikeAccessoryWeld", tAtt.Parent, handle
                    end
                end
                return acc.Parent == ch
            end

            local function applyDesc(hum, desc)
                for _, mName in ipairs({ "ApplyDescriptionClientServer", "ApplyDescriptionReset", "ApplyDescription" }) do
                    local okM, method = pcall(function() return hum[mName] end)
                    if okM and type(method) == "function" then
                        local copy = desc:Clone()
                        local ok = pcall(method, hum, copy)
                        copy:Destroy()
                        if ok then return true end
                    end
                end
                return false
            end

            local function setHeadless(ch, on)
                local head = ch and ch:FindFirstChild("Head")
                if not head then return end
                local tr = on and 1 or 0
                head.Transparency, head.LocalTransparencyModifier = tr, tr
                for _, c in ipairs(head:GetChildren()) do
                    if c:IsA("Decal") or c:IsA("Texture") then c.Transparency = tr end
                end
            end

            local function addAsset(ch, hum, assetId)
                assetId = tonumber(assetId)
                if not assetId then return false end
                for _, c in ipairs(ch:GetChildren()) do
                    local sid; pcall(function() sid = tonumber(c.SourceAssetId) end)
                    if sid == assetId or tonumber(c:GetAttribute("StrikeSkinAssetId")) == assetId then return true end
                end
                local ok, objs = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(assetId)) end)
                if not ok or type(objs) ~= "table" or #objs == 0 then
                    local loaded; pcall(function() loaded = game:GetService("InsertService"):LoadAsset(assetId) end)
                    objs = loaded and { loaded } or {}
                end
                local added = false
                for _, root in ipairs(objs) do
                    local list = {}
                    if root:IsA("Accessory") or root:IsA("Shirt") or root:IsA("Pants") or root:IsA("ShirtGraphic") then list[#list + 1] = root end
                    for _, d in ipairs(root:GetDescendants()) do
                        if d:IsA("Accessory") or d:IsA("Shirt") or d:IsA("Pants") or d:IsA("ShirtGraphic") then list[#list + 1] = d end
                    end
                    for _, src in ipairs(list) do
                        local cl = src:Clone()
                        cl:SetAttribute("StrikeCompleteSkin", true); cl:SetAttribute("StrikeSkinAssetId", assetId)
                        if cl:IsA("Accessory") then
                            if attachAcc(ch, hum, cl) then added = true end
                        else
                            for _, old in ipairs(ch:GetChildren()) do
                                if old.ClassName == cl.ClassName and old:GetAttribute("StrikeCompleteSkin") then old:Destroy() end
                            end
                            cl.Parent = ch; added = true
                        end
                    end
                    safeDestroy(root)
                end
                return added
            end

            local function markAndColor(ch, setData)
                local setLookup = {}
                for _, id in ipairs(setData.accessories or {}) do setLookup[id] = true end
                for _, id in ipairs(setData.clothing or {}) do setLookup[id] = true end
                for _, c in ipairs(ch:GetChildren()) do
                    if isSkinItem(c) then
                        local id; pcall(function() id = tonumber(c.SourceAssetId) end)
                        if id and setLookup[id] then c:SetAttribute("StrikeCompleteSkin", true) end
                    end
                end
                for _, d in ipairs(ch:GetDescendants()) do
                    if d:IsA("BasePart") then
                        local p = d
                        while p and p ~= ch do
                            if p:GetAttribute("StrikeCompleteSkin") then d.Color = setData.color; break end
                            p = p.Parent
                        end
                    end
                end
            end

            function StrikeDisplaySkin.apply(token)
                token = token or S._skinApplyToken
                local ch, setName = LP.Character, S.displaySkin
                if token ~= S._skinApplyToken or not ch or setName == "Off" or not S.customSkinEnabled then return end
                local hum = ch:FindFirstChildOfClass("Humanoid")
                local setData = STRIKE_DISPLAY_SKIN_SETS[setName]
                if not hum or not setData then return end

                if not origDesc[ch] then pcall(function() origDesc[ch] = hum:GetAppliedDescription():Clone() end) end
                if not origOutfits[ch] then
                    local saved = {}
                    for _, c in ipairs(ch:GetChildren()) do
                        if isSkinItem(c) then
                            local ok, cl = pcall(function() return c:Clone() end)
                            if ok and cl then saved[#saved + 1] = cl end
                        end
                    end
                    origOutfits[ch] = saved
                end

                local head = ch:FindFirstChild("Head")
                local hMesh = head and head:FindFirstChildOfClass("SpecialMesh")
                if hMesh and head:GetAttribute("StrikeOrigHeadMesh") ~= nil then
                    hMesh.MeshId = head:GetAttribute("StrikeOrigHeadMesh")
                    hMesh.TextureId = head:GetAttribute("StrikeOrigHeadTex") or ""
                end

                for _, c in ipairs(ch:GetChildren()) do
                    if c:IsA("Accessory") or c:IsA("Accoutrement") then pcall(function() c:Destroy() end) end
                end

                local desc
                pcall(function() desc = hum:GetAppliedDescription():Clone() end)
                if not desc then pcall(function() desc = Players:GetHumanoidDescriptionFromUserId(LP.UserId) end) end
                if not desc then desc = Instance.new("HumanoidDescription") end
                for _, prop in ipairs({ "HatAccessory","HairAccessory","FaceAccessory","NeckAccessory","ShouldersAccessory","FrontAccessory","BackAccessory","WaistAccessory","ShirtAccessory","PantsAccessory","JacketAccessory","SweaterAccessory","ShortsAccessory","TShirtAccessory","DressSkirtAccessory" }) do
                    pcall(function() desc[prop] = "" end)
                end
                pcall(function() desc.Shirt, desc.Pants, desc.GraphicTShirt, desc.HatAccessory, desc.HairAccessory = 0, 0, 0, setData.hats or "", setData.hair or "" end)
                for _, list in ipairs({ setData.accessories or {}, setData.clothing or {} }) do
                    for _, id in ipairs(list) do
                        local prop = STRIKE_DISPLAY_ASSET_PROPERTIES[tonumber(id)]
                        if prop == "Shirt" or prop == "Pants" then
                            desc[prop] = tonumber(id)
                        elseif prop then
                            local old = tostring(desc[prop] or "")
                            if not old:find(tostring(id), 1, true) then desc[prop] = (old == "" and tostring(id) or (old .. "," .. tostring(id))) end
                        end
                    end
                end
                applyDesc(hum, desc)
                task.wait(0.18)
                if token ~= S._skinApplyToken then desc:Destroy(); return end

                for _, id in ipairs(setData.accessories or {}) do addAsset(ch, hum, id) end
                for _, id in ipairs(setData.clothing or {}) do addAsset(ch, hum, id) end
                task.wait(0.35)
                if token ~= S._skinApplyToken then desc:Destroy(); return end

                local srcModel
                pcall(function() srcModel = Players:CreateHumanoidModelFromDescriptionAsync(desc, Enum.HumanoidRigType.R15) end)
                if srcModel then
                    for _, c in ipairs(srcModel:GetChildren()) do
                        if c:IsA("Accessory") then
                            local cl = c:Clone(); cl:SetAttribute("StrikeCompleteSkin", true); attachAcc(ch, hum, cl)
                        elseif c:IsA("Shirt") or c:IsA("Pants") or c:IsA("ShirtGraphic") then
                            for _, cur in ipairs(ch:GetChildren()) do if cur.ClassName == c.ClassName then safeDestroy(cur) end end
                            local cl = c:Clone(); cl:SetAttribute("StrikeCompleteSkin", true); cl.Parent = ch
                        end
                    end
                    srcModel:Destroy()
                end
                desc:Destroy()
                markAndColor(ch, setData)

                if setData.shirtTemplate then
                    for _, item in ipairs(ch:GetChildren()) do if item:IsA("Shirt") or item:IsA("Pants") then item:Destroy() end end
                    local sh = Instance.new("Shirt", ch); sh.ShirtTemplate = setData.shirtTemplate; sh:SetAttribute("StrikeCompleteSkin", true)
                    local pn = Instance.new("Pants", ch); pn.PantsTemplate = setData.pantsTemplate; pn:SetAttribute("StrikeCompleteSkin", true)
                end
                if setData.headMesh and hMesh then
                    if head:GetAttribute("StrikeOrigHeadMesh") == nil then
                        head:SetAttribute("StrikeOrigHeadMesh", hMesh.MeshId)
                        head:SetAttribute("StrikeOrigHeadTex", hMesh.TextureId)
                    end
                    hMesh.MeshId, hMesh.TextureId = setData.headMesh, setData.headTexture or ""
                end
                setHeadless(ch, setData.headless == true)
            end

            function StrikeDisplaySkin.off()
                local ch = LP.Character
                if not ch then return end
                local hum = ch:FindFirstChildOfClass("Humanoid")
                local head = ch:FindFirstChild("Head")
                local hMesh = head and head:FindFirstChildOfClass("SpecialMesh")
                if hMesh and head:GetAttribute("StrikeOrigHeadMesh") ~= nil then
                    hMesh.MeshId = head:GetAttribute("StrikeOrigHeadMesh")
                    hMesh.TextureId = head:GetAttribute("StrikeOrigHeadTex") or ""
                    head:SetAttribute("StrikeOrigHeadMesh", nil); head:SetAttribute("StrikeOrigHeadTex", nil)
                end
                for _, c in ipairs(ch:GetChildren()) do if c:GetAttribute("StrikeCompleteSkin") then safeDestroy(c) end end
                if hum and origDesc[ch] then applyDesc(hum, origDesc[ch]:Clone()); task.wait(0.2) end
                if origOutfits[ch] then
                    for _, c in ipairs(ch:GetChildren()) do if isSkinItem(c) then safeDestroy(c) end end
                    for _, cl in ipairs(origOutfits[ch]) do
                        local cp = cl:Clone()
                        if cp:IsA("Accessory") and hum then attachAcc(ch, hum, cp) else cp.Parent = ch end
                    end
                end
                setHeadless(ch, false)
            end

            function StrikeDisplaySkin.setSkin(name, save)
                S._skinApplyToken = S._skinApplyToken + 1
                local tok = S._skinApplyToken
                S.displaySkin = table.find(STRIKE_DISPLAY_SKIN_ORDER, name) and name or "Off"
                if S.displaySkin == "Off" then
                    S.customSkinEnabled = false
                    StrikeDisplaySkin.off()
                else
                    S.customSkinEnabled = true
                    task.spawn(function() pcall(StrikeDisplaySkin.apply, tok) end)
                end
                if S.displaySkinSelectorLabel then S.displaySkinSelectorLabel.Text = S.displaySkin == "Off" and "None" or S.displaySkin end
                if save then pcall(saveAllSettings) end
            end

            LP.CharacterAdded:Connect(function(ch)
                task.wait(0.4)
                origDesc[ch], origOutfits[ch] = nil, nil
                if S.customSkinEnabled and S.displaySkin ~= "Off" then task.spawn(StrikeDisplaySkin.apply) end
            end)

            mkSect(visualPage, "COSMETICS")
            local skinChoices = { "None", "PURPLE", "BLUE", "RED", "BLACK", "GREEN", "WHITE", "BLEED 1", "BLEED 2", "BLEED 3", "BLEED 4", "BLEED 5" }
            local skinIndex = (S.displaySkin == "Off" and 1) or (table.find(skinChoices, S.displaySkin) or 1)
            local skinRow = mkRow(visualPage, 38); mkLabel(skinRow, "Skins")
            local skinLabel = mkSelector(skinRow, skinChoices[skinIndex], function(dir, update)
                skinIndex = ((skinIndex - 1 + dir) % #skinChoices) + 1
                local sel = skinChoices[skinIndex]
                pcall(StrikeDisplaySkin.setSkin, sel == "None" and "Off" or sel, true)
                if update then update(sel) end
            end)
            S.displaySkinSelectorLabel = skinLabel
            _G.StrikeDisplaySkinSelectorRefresh = function(name)
                local sel = (name == nil or name == "Off") and "None" or name
                skinIndex = table.find(skinChoices, sel) or 1
                skinLabel.Text = skinChoices[skinIndex]
            end

            _G.StrikeCustomToolSkinSelectorRefresh = _G.StrikeCustomToolSkinSelectorRefresh or {}
            local function makeCategorySelector(title, category)
                local assets = _G.StrikeCustomToolAssets or {}
                local choices = { "None" }
                for key, def in pairs(assets) do
                    if type(def) == "table" and def.cat == category then choices[#choices + 1] = key end
                end
                table.sort(choices, function(a, b)
                    if a == "None" then return true elseif b == "None" then return false end
                    return tostring((assets[a] and assets[a].label) or a):lower() < tostring((assets[b] and assets[b].label) or b):lower()
                end)
                local selKey = (_G.StrikeCustomToolSkins and _G.StrikeCustomToolSkins[category]) or "None"
                local selIdx = table.find(choices, selKey) or 1
                local function disp(k) return k == "None" and "None" or tostring((assets[k] or {}).label or k) end

                local row = mkRow(visualPage, 38); mkLabel(row, title)
                local lbl = mkSelector(row, disp(choices[selIdx]), function(dir, update)
                    selIdx = ((selIdx - 1 + dir) % #choices) + 1
                    local key = choices[selIdx]
                    if _G.StrikeSetCustomToolSkin then pcall(_G.StrikeSetCustomToolSkin, category, key) end
                    if update then update(disp(key)) end
                    pcall(saveAllSettings)
                end)
                _G.StrikeCustomToolSkinSelectorRefresh[category] = function(key)
                    selIdx = table.find(choices, key) or 1
                    lbl.Text = disp(choices[selIdx])
                end
            end
            makeCategorySelector("Bat Skins", "Bat")
            makeCategorySelector("Medusa Skin", "Medusa")
        end

        -- ==================== PESTAÑA CONFIG ====================
        local configPage = contentPages["Config"]
        mkSect(configPage, "INTERFACE")
        do
            local wrap = Instance.new("Frame", configPage)
            wrap.Size, wrap.BackgroundColor3, wrap.BackgroundTransparency, wrap.BorderSizePixel, wrap.LayoutOrder, wrap.ZIndex = UDim2.new(1, -4, 0, 104), ROW_BG, 0.7, 0, nextOrder(configPage), 7
            Instance.new("UICorner", wrap).CornerRadius = UDim.new(0, 10)
            local ws = Instance.new("UIStroke", wrap); ws.Color, ws.Thickness, ws.Transparency = WHITE, 1, 0.85
            local ttl = Instance.new("TextLabel", wrap)
            ttl.Size, ttl.Position, ttl.BackgroundTransparency = UDim2.new(1, -20, 0, 22), UDim2.new(0, 10, 0, 6), 1
            ttl.Text, ttl.TextColor3, ttl.Font, ttl.TextSize, ttl.TextXAlignment, ttl.ZIndex = "Background Image", WHITE, Enum.Font.GothamBold, 14, Enum.TextXAlignment.Left, 8
            local scroll = Instance.new("ScrollingFrame", wrap)
            scroll.Size, scroll.Position, scroll.BackgroundTransparency, scroll.BorderSizePixel = UDim2.new(1, -64, 0, 62), UDim2.new(0, 32, 0, 34), 1, 0
            scroll.ScrollBarThickness, scroll.ScrollingDirection, scroll.AutomaticCanvasSize, scroll.CanvasSize, scroll.ClipsDescendants, scroll.ZIndex = 0, Enum.ScrollingDirection.X, Enum.AutomaticSize.X, UDim2.new(), true, 8
            local sl = Instance.new("UIListLayout", scroll)
            sl.FillDirection, sl.Padding, sl.SortOrder, sl.VerticalAlignment = Enum.FillDirection.Horizontal, UDim.new(0, 8), Enum.SortOrder.LayoutOrder, Enum.VerticalAlignment.Center
            local sp = Instance.new("UIPadding", scroll); sp.PaddingLeft, sp.PaddingRight = UDim.new(0, 2), UDim.new(0, 2)

            local bgThumbs = {}
            local bgAccents = {
                [2] = Color3.fromRGB(254, 254, 254), [3] = Color3.fromRGB(60, 135, 90), [4] = Color3.fromRGB(254, 254, 254),
                [5] = Color3.fromRGB(175, 95, 255),  [6] = Color3.fromRGB(60, 110, 255), [7] = Color3.fromRGB(255, 220, 40),
            }
            local function refreshBg()
                for idx, b in pairs(bgThumbs) do
                    local sel = (idx == backgroundIndex)
                    local st = b:FindFirstChildOfClass("UIStroke")
                    if st then st.Color, st.Thickness, st.Transparency = sel and WHITE or Color3.fromRGB(50, 52, 60), sel and 2 or 1, sel and 0 or 0.4 end
                    local tk = b:FindFirstChild("Tick")
                    if tk then tk.Visible = sel end
                end
                local acc = bgAccents[backgroundIndex] or COLOR_THEMES[currentColorTheme] or Color3.fromRGB(180, 180, 190)
                selectedColor = acc
                pcall(updateAllUIThemeColors, acc)
            end

            for i, id in ipairs(backgroundImages) do
                local b = Instance.new("ImageButton", scroll)
                b.Size, b.BackgroundColor3, b.BorderSizePixel, b.AutoButtonColor, b.LayoutOrder, b.ZIndex, b.ScaleType = UDim2.new(0, 56, 0, 56), Color3.fromRGB(15, 15, 18), 0, false, i, 9, Enum.ScaleType.Crop
                b.Image = id == "NONE" and "" or ("rbxthumb://type=Asset&id=" .. id .. "&w=150&h=150")
                Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
                local st = Instance.new("UIStroke", b); st.Color, st.Thickness, st.Transparency = Color3.fromRGB(50, 52, 60), 1, 0.4
                if id == "NONE" then
                    local nl = Instance.new("TextLabel", b)
                    nl.Size, nl.BackgroundTransparency, nl.Text, nl.TextColor3, nl.Font, nl.TextSize, nl.ZIndex = UDim2.fromScale(1, 1), 1, "None", Color3.fromRGB(200, 200, 205), Enum.Font.GothamBold, 11, 10
                end
                local tk = Instance.new("TextLabel", b)
                tk.Name, tk.Size, tk.Position, tk.BackgroundTransparency = "Tick", UDim2.new(0, 16, 0, 16), UDim2.new(1, -18, 0, 2), 1
                tk.Text, tk.TextColor3, tk.Font, tk.TextSize, tk.Visible, tk.ZIndex = utf8.char(10003), WHITE, Enum.Font.GothamBlack, 14, false, 11
                b.MouseButton1Click:Connect(function()
                    backgroundIndex = i
                    local bi = main and main:FindFirstChild("BackgroundImage")
                    if bi then
                        bi.Image = id == "NONE" and "" or ("rbxassetid://" .. id)
                        bi.BackgroundTransparency = id == "NONE" and 0 or 1
                        bi.ImageTransparency = backgroundImageTransparency
                    end
                    refreshBg()
                    pcall(saveAllSettings)
                end)
                bgThumbs[i] = b
            end
            for _, arr in ipairs({ { "<", -1, UDim2.new(0, 4, 0, 34) }, { ">", 1, UDim2.new(1, -28, 0, 34) } }) do
                local a = Instance.new("TextButton", wrap)
                a.Size, a.Position, a.BackgroundTransparency, a.Text, a.TextColor3, a.Font, a.TextSize, a.AutoButtonColor, a.ZIndex = UDim2.new(0, 24, 0, 56), arr[3], 1, arr[1], WHITE, Enum.Font.GothamBlack, 18, false, 10
                a.MouseButton1Click:Connect(function()
                    local mx = math.max(0, scroll.AbsoluteCanvasSize.X - scroll.AbsoluteSize.X)
                    TS:Create(scroll, TweenInfo.new(0.2), { CanvasPosition = Vector2.new(_clamp(scroll.CanvasPosition.X + arr[2] * 128, 0, mx), 0) }):Play()
                end)
            end
            refreshBg()
            _G.StrikeRefreshBgPicker = refreshBg
        end

        do
            local row = mkRow(configPage, 38); mkLabel(row, "UI Scale")
            uiScaleStepperSet = mkStepper(row, uiScaleValue, 50, 150, 5, 0, function(v)
                uiScaleValue = _clamp(_floor(v + 0.5), 50, 150)
                if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
                saveAllSettings()
            end)
        end
        do
            local row = mkRow(configPage, 38); mkLabel(row, "Steal Bar Scale")
            stealBarStepperSet = mkStepper(row, stealBarScale, 0.3, 1.5, 0.05, 2, function(v)
                stealBarScale = _clamp(v, 0.3, 1.5)
                if pbScale then pbScale.Scale = stealBarScale end
                saveAllSettings()
            end)
        end

        mkSect(configPage, "STEAL PROTO")
        do
            local stealVis, row = mkToggle(configPage, "Auto Steal", function(on)
                CONFIG.AUTO_STEAL_ENABLED = on
                if on then pcall(startAutoSteal) else stopAutoSteal() end
                updateProgressBarVisibility()
            end)
            setInstaGrab = stealVis
            local rRow = mkRow(configPage, 38); rRow.Visible = false; mkLabel(rRow, "Radius")
            radInput = mkBox(rRow, CONFIG.STEAL_RANGE, 50, 56, function(v)
                if v >= 5 and v <= 300 then CONFIG.STEAL_RANGE = _floor(v + 0.5); Steal.StealRadius = CONFIG.STEAL_RANGE; radInput.Text = tostring(CONFIG.STEAL_RANGE) end
            end)
            local ssRow = mkRow(configPage, 38); ssRow.Visible = false; mkLabel(ssRow, "Soft Steal Speed")
            carrySysSoftStealSpeedBox = mkBox(ssRow, CarrySystem.softStealSpeed, 50, 56, function(v) if v > 0 and v <= 500 then CarrySystem:setSoftStealSpeed(v) end end)
            local srRow = mkRow(configPage, 38); srRow.Visible = false; mkLabel(srRow, "Soft Steal Radius")
            carrySysSoftStealRadiusBox = mkBox(srRow, CarrySystem.softStealRadius, 50, 56, function(v) if v > 0 then CarrySystem:setSoftStealRadius(v) end end)
            attachExpandArrow(row, -100, { rRow, ssRow, srRow }, false)
        end

        mkSect(configPage, "MOBILE BUTTONS")
        do
            local row = mkRow(configPage, 38); mkLabel(row, "Mobile Buttons Size")
            floatScaleStepperSet = mkStepper(row, floatingButtonScale, 0.5, 2.0, 0.05, 2, function(v)
                floatingButtonScale = _clamp(v, 0.5, 2.0)
                applyFloatingButtonScale()
                saveAllSettings()
            end)
        end
        hideMobileBtnsSetVisual = mkToggle(configPage, "Hide Mobile Buttons", function(on) setMobileButtonsHidden(on); saveAllSettings() end)
        setLockUIVisual = mkToggle(configPage, "Lock GUIA", function(on) uiLocked = on == true; pcall(saveAllSettings) end)

        do
            local row = mkRow(configPage, 72)
            local songTitle = mkLabel(row, "Intro Song")
            songTitle.Size, songTitle.Position, songTitle.TextSize = UDim2.new(1, -20, 0, 22), UDim2.new(0, 10, 0, 3), 12
            local idx = table.find(INTRO_SONG_ORDER, INTRO_SONG) or 1
            local c = Instance.new("Frame", row); c.Size, c.Position, c.BackgroundTransparency, c.ZIndex = UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 1, -35), 1, 8
            local function mkSb(txt, pos)
                local b = Instance.new("TextButton", c)
                b.Size, b.Position, b.BackgroundColor3, b.BackgroundTransparency, b.BorderSizePixel = UDim2.new(0, 36, 0, 28), pos, INP, 0.7, 0
                b.Text, b.TextColor3, b.Font, b.TextSize, b.AutoButtonColor, b.ZIndex = txt, WHITE, Enum.Font.GothamBold, 13, false, 9
                Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
                local st = Instance.new("UIStroke", b); st.Color, st.Thickness = ROW_BORDER, 1
                return b
            end
            local lb, rb = mkSb("<", UDim2.new(0, 0, 0, 1)), mkSb(">", UDim2.new(1, -36, 0, 1))
            introSongSelectorLabel = Instance.new("TextLabel", c)
            introSongSelectorLabel.Size, introSongSelectorLabel.Position, introSongSelectorLabel.BackgroundTransparency = UDim2.new(1, -96, 0, 28), UDim2.new(0, 48, 0, 1), 1
            introSongSelectorLabel.Text, introSongSelectorLabel.TextColor3, introSongSelectorLabel.Font, introSongSelectorLabel.TextSize, introSongSelectorLabel.ZIndex = INTRO_SONG:upper(), WHITE, Enum.Font.GothamBold, 17, 9
            local function changeSong(delta)
                idx = ((idx - 1 + delta) % #INTRO_SONG_ORDER) + 1
                INTRO_SONG = INTRO_SONG_ORDER[idx]
                introSongSelectorLabel.Text = INTRO_SONG:upper()
                if strikeIntroSound then pcall(function() strikeIntroSound:Stop(); strikeIntroSound:Destroy() end); strikeIntroSound = nil end
                if INTRO_SONG ~= "Off" and _G.__STRIKE_PLAY_INTRO_SONG then task.spawn(_G.__STRIKE_PLAY_INTRO_SONG, INTRO_SONG, true) end
                saveAllSettings()
            end
            lb.MouseButton1Click:Connect(function() changeSong(-1) end)
            rb.MouseButton1Click:Connect(function() changeSong(1) end)
        end

        do
            local row = mkRow(configPage, 44); row.Size = UDim2.new(1, 0, 0, 44)
            local btn = Instance.new("TextButton", row)
            btn.Size, btn.Position, btn.BackgroundColor3, btn.BackgroundTransparency, btn.BorderSizePixel = UDim2.new(1, -12, 0.8, 0), UDim2.new(0, 6, 0.1, 0), Color3.fromRGB(30, 30, 35), 0.5, 0
            btn.Text, btn.TextColor3, btn.Font, btn.TextSize, btn.AutoButtonColor, btn.ZIndex = "RESET POSITIONS", WHITE, Enum.Font.GothamBold, 13, false, 8
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
            local st = Instance.new("UIStroke", btn); st.Color, st.Thickness, st.Transparency = ROW_BORDER, 1.2, 0.5
            local db = false
            btn.MouseButton1Click:Connect(function()
                if db then return end; db = true
                resetFloatingPositions(); btn.Text = "RESET ✓"
                task.delay(1.2, function() if btn.Parent then btn.Text = "RESET POSITIONS"; db = false end end)
            end)
        end

        mkSect(configPage, "CONFIG")
        do
            local row = mkRow(configPage, 44); row.Size = UDim2.new(1, 0, 0, 44)
            local delBtn = Instance.new("TextButton", row)
            delBtn.Size, delBtn.Position, delBtn.BackgroundColor3, delBtn.BackgroundTransparency, delBtn.BorderSizePixel = UDim2.new(1, -12, 0.8, 0), UDim2.new(0, 6, 0.1, 0), WHITE, 0.5, 0
            delBtn.Text, delBtn.TextColor3, delBtn.Font, delBtn.TextSize, delBtn.AutoButtonColor, delBtn.ZIndex = "RESET ALL CONFIG", Color3.new(0, 0, 0), Enum.Font.GothamBold, 13, false, 8
            Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 8)
            local st = Instance.new("UIStroke", delBtn); st.Color, st.Thickness, st.Transparency = ROW_BORDER, 1.2, 0.5
            local state, db = 0, false
            delBtn.MouseButton1Click:Connect(function()
                if db then return end
                if state == 0 then
                    state = 1; delBtn.Text = "CONFIRM?"; delBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 80)
                    task.delay(2, function() if delBtn.Parent and state == 1 then state = 0; delBtn.Text = "RESET ALL CONFIG"; delBtn.BackgroundColor3 = WHITE end end)
                else
                    db = true
                    local okReset = pcall(resetToFactoryDefaults)
                    delBtn.Text = okReset and "DELETED ✓" or "ERROR"
                    delBtn.BackgroundColor3 = WHITE; state = 0
                    task.delay(1.5, function() if delBtn.Parent then delBtn.Text = "RESET ALL CONFIG"; db = false end end)
                end
            end)
        end

        -- ==================== PROGRESS BAR FLOTANTE ====================
        pbFrame = Instance.new("Frame", gui)
        pbFrame.Size = UDim2.new(0, 704, 0, 140)
        pbFrame.Position = savedProgressBarPos and UDim2.new(savedProgressBarPos.XScale or 0, savedProgressBarPos.XOffset or 300, savedProgressBarPos.YScale or 1, savedProgressBarPos.YOffset or -80) or UDim2.new(0, 300, 1, -80)
        pbFrame.BackgroundColor3, pbFrame.BorderSizePixel, pbFrame.Active, pbFrame.ClipsDescendants, pbFrame.Visible, pbFrame.ZIndex = Color3.new(0, 0, 0), 0, true, true, CONFIG.AUTO_STEAL_ENABLED, 500
        pbScale = Instance.new("UIScale", pbFrame); pbScale.Scale = stealBarScale
        Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 28)

        local avatar = Instance.new("ImageLabel", pbFrame)
        avatar.Name, avatar.Size, avatar.Position = "PlayerAvatar", UDim2.new(0, 96, 0, 96), UDim2.new(0, 22, 0.5, -48)
        avatar.BackgroundColor3, avatar.BorderSizePixel, avatar.ScaleType, avatar.ZIndex = Color3.fromRGB(22, 22, 27), 0, Enum.ScaleType.Crop, 513
        Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
        local ast = Instance.new("UIStroke", avatar); ast.Color, ast.Thickness, ast.Transparency = WHITE, 1.5, 0.25
        task.spawn(function()
            local ok, url = pcall(function() return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150) end)
            if ok and url then avatar.Image = url end
        end)

        progressPct = Instance.new("TextLabel", pbFrame)
        progressPct.Name, progressPct.Size, progressPct.Position, progressPct.BackgroundTransparency = "ProgressPct", UDim2.new(0, 190, 0, 44), UDim2.new(1, -218, 0, 12), 1
        progressPct.Text, progressPct.TextColor3, progressPct.Font, progressPct.TextSize, progressPct.TextXAlignment, progressPct.TextYAlignment = "0%", WHITE, Enum.Font.GothamBlack, 30, Enum.TextXAlignment.Right, Enum.TextYAlignment.Top
        progressPct.TextStrokeColor3, progressPct.TextStrokeTransparency, progressPct.ZIndex = Color3.new(0, 0, 0), 0.4, 513

        local progressRow = Instance.new("Frame", pbFrame)
        progressRow.Size, progressRow.Position, progressRow.BackgroundTransparency, progressRow.ZIndex = UDim2.new(1, -164, 0, 30), UDim2.new(0, 136, 0, 92), 1, 511
        local fillRegion = Instance.new("Frame", progressRow)
        fillRegion.Size, fillRegion.BackgroundColor3, fillRegion.BackgroundTransparency, fillRegion.BorderSizePixel, fillRegion.ClipsDescendants, fillRegion.ZIndex = UDim2.fromScale(1, 1), Color3.fromRGB(20, 20, 25), 0.3, 0, true, 512
        Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(0, 17)
        progressFill = Instance.new("Frame", fillRegion)
        progressFill.Size, progressFill.BackgroundColor3, progressFill.BorderSizePixel, progressFill.ZIndex = UDim2.new(0, 0, 1, 0), getThemeColor(), 0, 513
        Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 17)
        local tc = getThemeColor()
        local fg = Instance.new("UIGradient", progressFill)
        fg.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, tc:Lerp(WHITE, 0.5)), ColorSequenceKeypoint.new(0.5, tc), ColorSequenceKeypoint.new(1, tc:Lerp(Color3.new(0, 0, 0), 0.3)) })

        local bottomRow = Instance.new("Frame", pbFrame)
        bottomRow.Size, bottomRow.Position, bottomRow.BackgroundTransparency, bottomRow.ZIndex = UDim2.new(1, -164, 0, 40), UDim2.new(0, 136, 0, 40), 1, 512
        local fpsNeon = Instance.new("TextLabel", bottomRow)
        fpsNeon.Size, fpsNeon.BackgroundTransparency, fpsNeon.Text, fpsNeon.TextColor3, fpsNeon.Font, fpsNeon.TextSize, fpsNeon.TextXAlignment, fpsNeon.TextStrokeTransparency, fpsNeon.ZIndex = UDim2.new(0, 160, 1, 0), 1, "FPS --", WHITE, Enum.Font.GothamBold, 22, Enum.TextXAlignment.Left, 0.3, 513
        local pingLabel = Instance.new("TextLabel", bottomRow)
        pingLabel.Size, pingLabel.Position, pingLabel.BackgroundTransparency, pingLabel.Text, pingLabel.TextColor3, pingLabel.Font, pingLabel.TextSize, pingLabel.TextXAlignment, pingLabel.TextStrokeTransparency, pingLabel.ZIndex = UDim2.new(0, 220, 1, 0), UDim2.new(0, 180, 0, 0), 1, "PING --ms", WHITE, Enum.Font.GothamBold, 22, Enum.TextXAlignment.Left, 0.3, 513

        task.spawn(function()
            local lastFrame, samples, fpsAvg = _tick(), {}, 60
            local c = RunService.RenderStepped:Connect(function()
                local now = _tick(); local dt = now - lastFrame; lastFrame = now
                if dt > 0 then
                    samples[#samples + 1] = 1 / dt
                    if #samples > 30 then table.remove(samples, 1) end
                    local sum = 0; for _, v in ipairs(samples) do sum = sum + v end
                    fpsAvg = sum / #samples
                end
            end)
            while pbFrame.Parent do
                local ping = 0; pcall(function() ping = LP:GetNetworkPing() * 1000 end)
                fpsNeon.Text = string.format("FPS %d", _floor(fpsAvg + 0.5))
                pingLabel.Text = string.format("PING %dms", _floor(ping + 0.5))
                task.wait(0.5)
            end
            safeDisconnect(c)
        end)

        drag(pbFrame)
        drag(main)
    end

    -- ========================================================================
    -- PANEL MÓVIL Y BOTONES FLOTANTES UNIFICADOS
    -- ========================================================================
    local function attachGuiParent(panel)
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
        if not pcall(function() panel.Parent = CoreGui end) then
            panel.Parent = LP:WaitForChild("PlayerGui")
        end
    end

    local function buildFloatingGuiShell(name, displayOrder, defaultPos, savedPos, labelText)
        local panel = Instance.new("ScreenGui")
        panel.Name, panel.ResetOnSpawn, panel.ZIndexBehavior, panel.DisplayOrder = name, false, Enum.ZIndexBehavior.Sibling, displayOrder
        attachGuiParent(panel)

        local btnFrame = Instance.new("Frame", panel)
        btnFrame.Name, btnFrame.Size = "Frame", UDim2.new(0, 86, 0, 86)
        btnFrame.Position = savedPos and UDim2.new(savedPos.XScale or defaultPos.X.Scale, savedPos.XOffset or defaultPos.X.Offset, savedPos.YScale or defaultPos.Y.Scale, savedPos.YOffset or defaultPos.Y.Offset) or defaultPos
        btnFrame.BackgroundColor3, btnFrame.BorderSizePixel, btnFrame.ZIndex = Color3.new(0, 0, 0), 0, 20

        local btnCorner = Instance.new("UICorner", btnFrame); btnCorner.CornerRadius = UDim.new(0, 10)
        table.insert(_floatingBtnCorners, btnCorner)

        local bgGrad = Instance.new("UIGradient", btnFrame)
        bgGrad.Name, bgGrad.Rotation = "BtnGrad", 90
        bgGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)) })

        local stroke = Instance.new("UIStroke", btnFrame)
        stroke.Color, stroke.Thickness, stroke.Transparency = Color3.fromRGB(55, 55, 60), 1, 0.15

        local label = Instance.new("TextLabel", btnFrame)
        label.Size, label.BackgroundTransparency, label.Text, label.TextColor3 = UDim2.fromScale(1, 1), 1, labelText, Color3.new(1, 1, 1)
        label.Font, label.TextSize, label.TextWrapped, label.ZIndex = Enum.Font.GothamBlack, 10, true, 21

        local uiScale = Instance.new("UIScale", btnFrame); uiScale.Scale = floatingButtonScale
        table.insert(_floatingUIScales, uiScale)

        return panel, btnFrame
    end

    local function createFloatingButton(cfg)
        if cfg.existing and cfg.existing.Parent then safeDestroy(cfg.existing) end
        local panel, btnFrame = buildFloatingGuiShell(cfg.name, cfg.order, cfg.defaultPos, cfg.getSavedPos(), cfg.text)
        local conns = {}
        local function track(sig, fn) local c = sig:Connect(fn); conns[#conns + 1] = c; return c end

        panel.Destroying:Connect(function()
            for _, c in ipairs(conns) do safeDisconnect(c) end
            table.clear(conns)
            if _activeFloatingDragOwner == btnFrame then _activeFloatingDragOwner = nil end
        end)

        local dragging, hasMoved, dragStart, startPos, activeInput = false, false, nil, nil, nil
        local tapThreshold = cfg.tapThreshold or 5

        track(btnFrame.InputBegan, function(inp)
            if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
            if activeInput or (_activeFloatingDragOwner and _activeFloatingDragOwner ~= btnFrame) then return end
            _activeFloatingDragOwner, activeInput, dragging, hasMoved, dragStart, startPos = btnFrame, inp, true, false, inp.Position, btnFrame.Position
        end)

        track(UIS.InputChanged, function(inp)
            if not dragging or not activeInput or _activeFloatingDragOwner ~= btnFrame then return end
            local isTouchMove = activeInput.UserInputType == Enum.UserInputType.Touch and inp == activeInput
            local isMouseMove = activeInput.UserInputType == Enum.UserInputType.MouseButton1 and inp.UserInputType == Enum.UserInputType.MouseMovement
            if not isTouchMove and not isMouseMove then return end
            local delta = inp.Position - dragStart
            if delta.Magnitude > tapThreshold then hasMoved = true end
            if hasMoved and not uiLocked then
                btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)

        track(UIS.InputEnded, function(inp)
            if not dragging or inp ~= activeInput or _activeFloatingDragOwner ~= btnFrame then return end
            if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
            local delta = inp.Position - dragStart
            if not hasMoved and delta.Magnitude <= tapThreshold then
                cfg.onTap(btnFrame)
            elseif not uiLocked and hasMoved then
                cfg.onSavePos(serializePos(btnFrame.Position))
                pcall(saveAllSettings)
            end
            dragging, hasMoved, activeInput, _activeFloatingDragOwner = false, false, nil, nil
        end)

        paintFloatingBtn(btnFrame, cfg.initialActive())
        return panel
    end

    function createTpBatFloatingButton()
        tpBatFloatingButton = createFloatingButton({
            name = "TpBatButton", order = 21, text = "TP\nBAT",
            defaultPos = UDim2.new(1, -228, 0, 16),
            getSavedPos = function() return tpBatFloatingPos end,
            onSavePos = function(p) tpBatFloatingPos = p end,
            initialActive = function() return batDesyncTpEnabled == true end,
            onTap = function(btnFrame) toggleBatDesyncTp(); paintFloatingBtn(btnFrame, batDesyncTpEnabled) end,
        })
        return tpBatFloatingButton
    end

    function createBatBypassFloatingButton()
        batBypassFloatingButton = createFloatingButton({
            name = "BatBypassButton", order = 22, text = "BAT\nBYPASS",
            defaultPos = UDim2.new(1, -228, 0, 94),
            getSavedPos = function() return batBypassFloatingPos end,
            onSavePos = function(p) batBypassFloatingPos = p end,
            initialActive = function() return autoBatBypassEnabled == true end,
            onTap = function(btnFrame) toggleBatBypass(); paintFloatingBtn(btnFrame, autoBatBypassEnabled) end,
        })
        return batBypassFloatingButton
    end

    function createInstaResetFloatingButton()
        instaResetFloatingButton = createFloatingButton({
            existing = instaResetFloatingButton,
            name = "InstaResetButton", order = 23, text = "INSTA\nRESET", tapThreshold = 12,
            defaultPos = UDim2.new(1, -228, 0, 172),
            getSavedPos = function() return instaResetFloatingPos end,
            onSavePos = function(p) instaResetFloatingPos = p end,
            initialActive = function() return false end,
            onTap = function(btnFrame)
                paintFloatingBtn(btnFrame, true)
                local trigger = _G.InstaReset and _G.InstaReset.Trigger
                if type(trigger) == "function" then pcall(trigger) end
                task.delay(0.2, function() if btnFrame.Parent then paintFloatingBtn(btnFrame, false) end end)
            end,
        })
        return instaResetFloatingButton
    end

    function createMobilePanel()
        local panel = Instance.new("ScreenGui")
        panel.Name, panel.ResetOnSpawn, panel.ZIndexBehavior = "StrikeMobilePanel", false, Enum.ZIndexBehavior.Sibling
        attachGuiParent(panel)

        local container = Instance.new("Frame", panel)
        container.Name, container.Size, container.Position = "FloatingPanel", UDim2.new(0, 180, 0, 374), UDim2.new(1, -150, 0, 16)
        container.BackgroundTransparency, container.BorderSizePixel, container.ClipsDescendants = 1, 0, false
        local cScale = Instance.new("UIScale", container); cScale.Scale = floatingButtonScale
        table.insert(_floatingUIScales, cScale)
        mobileMainPanelGui, _mobilePanelContainer = panel, container
        _mobileBtnCorners, _mobileBtns = {}, {}

        local btnContainer = Instance.new("Frame", container)
        btnContainer.Name, btnContainer.Size, btnContainer.BackgroundTransparency, btnContainer.ClipsDescendants = "ButtonsContainer", UDim2.fromScale(1, 1), 1, false

        local defs = {
            { "DropBR",    "DROP\nBR" },
            { "AutoLeft",  "AUTO\nLEFT" },
            { "AutoBat",   "BAT\nAIMBOT" },
            { "AutoRight", "AUTO\nRIGHT" },
            { "TpDown",    "TP\nDOWN" },
            { "Carry",     "CARRY\nSPD" },
            { "Lagger1",   "LAGGER\nNORMAL" },
            { "Lagger2",   "LAGGER\nCARRY" },
        }
        local buttons, conns = {}, {}
        panel.Destroying:Connect(function()
            for _, c in ipairs(conns) do safeDisconnect(c) end
            table.clear(conns)
        end)

        local callbacks = {
            DropBR = function(setActive)
                if autoBatEnabled then return end
                setActive(true)
                executeDropWithToggle(function(v) if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end end)
                task.delay(0.3, function() setActive(false) end)
            end,
            AutoLeft = function(setActive)
                autoLeftEnabled = not autoLeftEnabled; setActive(autoLeftEnabled)
                if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
                if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
            end,
            AutoBat = function(setActive)
                if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
                setActive(autoBatEnabled)
            end,
            AutoRight = function(setActive)
                autoRightEnabled = not autoRightEnabled; setActive(autoRightEnabled)
                if autoRightEnabled then startAutoRight() else stopAutoRight() end
                if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
            end,
            TpDown = function(setActive)
                doTpDown(); setActive(true)
                task.delay(0.2, function() setActive(false) end)
            end,
            Carry = function(setActive)
                speedMode = not speedMode
                if speedMode then laggerToggled, laggerCarryToggled = false, false end
                setActive(speedMode)
                if buttons.Lagger1 then buttons.Lagger1.setActive(false) end
                if buttons.Lagger2 then buttons.Lagger2.setActive(false) end
                refreshSpeedModeLabel()
            end,
            Lagger1 = function(setActive)
                speedMode = false
                if buttons.Carry then buttons.Carry.setActive(false) end
                laggerToggled = not laggerToggled
                if laggerToggled then laggerCarryToggled = false; if buttons.Lagger2 then buttons.Lagger2.setActive(false) end end
                setActive(laggerToggled)
                refreshSpeedModeLabel()
            end,
            Lagger2 = function(setActive)
                speedMode = false
                if buttons.Carry then buttons.Carry.setActive(false) end
                laggerCarryToggled = not laggerCarryToggled
                if laggerCarryToggled then laggerToggled = false; if buttons.Lagger1 then buttons.Lagger1.setActive(false) end end
                setActive(laggerCarryToggled)
                refreshSpeedModeLabel()
            end,
        }

        for _, d in ipairs(defs) do
            local name, text = d[1], d[2]
            local btn = Instance.new("TextButton", btnContainer)
            btn.Name, btn.Size, btn.BorderSizePixel, btn.Text, btn.AutoButtonColor, btn.ZIndex = name, UDim2.new(0, 86, 0, 86), 0, "", false, 10
            local sp = savedButtonPositions[name]
            if sp then
                btn.Position = UDim2.new(0, sp.X or 0, 0, sp.Y or 0)
            else
                local dx, dy = getDefaultButtonPosition(name)
                btn.Position = UDim2.new(0, dx, 0, dy)
            end
            local corner = Instance.new("UICorner", btn); corner.CornerRadius = UDim.new(0, 10)
            table.insert(_mobileBtnCorners, corner); table.insert(_mobileBtns, btn)
            local grad = Instance.new("UIGradient", btn); grad.Name, grad.Rotation = "BtnGrad", 90
            local st = Instance.new("UIStroke", btn); st.Color, st.Thickness, st.Transparency = Color3.fromRGB(55, 55, 60), 1, 0.15
            local lbl = Instance.new("TextLabel", btn)
            lbl.Name, lbl.Size, lbl.BackgroundTransparency, lbl.Text, lbl.Font, lbl.TextSize, lbl.TextWrapped, lbl.ZIndex = "TextLabel", UDim2.fromScale(1, 1), 1, text, Enum.Font.GothamBlack, 12, true, 11

            local function setActive(s)
                btn:SetAttribute("MobActive", s == true)
                paintFloatingBtn(btn, s == true)
            end
            setActive(false)

            local dragging, hasMoved, dragStart, startPos, movedDist, activeInput = false, false, nil, nil, 0, nil
            conns[#conns + 1] = btn.InputBegan:Connect(function(inp)
                if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
                if dragging or (_activeFloatingDragOwner and _activeFloatingDragOwner ~= btn) then return end
                _activeFloatingDragOwner, activeInput, dragging, hasMoved, movedDist, dragStart, startPos, _isDraggingButton = btn, inp, true, false, 0, inp.Position, btn.Position, true
            end)
            conns[#conns + 1] = UIS.InputChanged:Connect(function(inp)
                if not dragging or not activeInput or _activeFloatingDragOwner ~= btn then return end
                if inp ~= activeInput and not (activeInput.UserInputType == Enum.UserInputType.MouseButton1 and inp.UserInputType == Enum.UserInputType.MouseMovement) then return end
                local delta = inp.Position - dragStart
                movedDist = delta.Magnitude
                if movedDist > 5 then hasMoved = true end
                if hasMoved and not uiLocked then
                    btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                end
            end)
            conns[#conns + 1] = UIS.InputEnded:Connect(function(inp)
                if not dragging or inp ~= activeInput or _activeFloatingDragOwner ~= btn then return end
                if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
                if movedDist <= 5 then
                    if callbacks[name] then callbacks[name](setActive) end
                elseif not uiLocked and hasMoved then
                    savedButtonPositions[name] = { X = btn.Position.X.Offset, Y = btn.Position.Y.Offset }
                    pcall(saveAllSettings)
                end
                dragging, hasMoved, activeInput, movedDist, _isDraggingButton, _activeFloatingDragOwner = false, false, nil, 0, false, nil
            end)

            buttons[name] = { btn = btn, setActive = setActive }
        end

        mobSetAutoBat  = buttons.AutoBat.setActive
        mobSetAutoLeft = buttons.AutoLeft.setActive
        mobSetAutoRight= buttons.AutoRight.setActive
        mobSetDropBR   = buttons.DropBR.setActive
        mobSetTpDown   = buttons.TpDown.setActive
        mobSetCarry    = buttons.Carry.setActive
        mobSetLagger1  = buttons.Lagger1.setActive
        mobSetLagger2  = buttons.Lagger2.setActive

        mobSetAutoBat(autoBatEnabled)
        mobSetAutoLeft(autoLeftEnabled)
        mobSetAutoRight(autoRightEnabled)
        mobSetCarry(speedMode)
        mobSetLagger1(laggerToggled)
        mobSetLagger2(laggerCarryToggled)
        if savedMobilePanelPos then
            container.Position = UDim2.new(savedMobilePanelPos.XScale or 0, savedMobilePanelPos.XOffset or 10, savedMobilePanelPos.YScale or 0, savedMobilePanelPos.YOffset or 0)
        end
        return panel
    end

    local function applySavedFloatingPositions()
        if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
            local c = MobilePanel.FloatingPanel
            if savedMobilePanelPos then
                c.Position = UDim2.new(savedMobilePanelPos.XScale or 0, savedMobilePanelPos.XOffset or -150, savedMobilePanelPos.YScale or 0, savedMobilePanelPos.YOffset or 16)
            end
            local bc = c:FindFirstChild("ButtonsContainer")
            if bc then
                for name, pos in pairs(savedButtonPositions or {}) do
                    local btn = bc:FindFirstChild(name)
                    if btn and btn:IsA("TextButton") and type(pos) == "table" then
                        btn.Position = UDim2.new(0, tonumber(pos.X) or btn.Position.X.Offset, 0, tonumber(pos.Y) or btn.Position.Y.Offset)
                    end
                end
            end
        end
        for _, item in ipairs({
            { tpBatFloatingButton,      tpBatFloatingPos,      UDim2.new(1, -228, 0, 16) },
            { batBypassFloatingButton,  batBypassFloatingPos,  UDim2.new(1, -228, 0, 94) },
            { instaResetFloatingButton, instaResetFloatingPos, UDim2.new(1, -228, 0, 172) },
        }) do
            local btnGui, pos = item[1], item[2]
            if btnGui and btnGui:FindFirstChild("Frame") and pos then
                local f = btnGui.Frame
                f.Position = UDim2.new(pos.XScale or 1, pos.XOffset or item[3].X.Offset, pos.YScale or 0, pos.YOffset or item[3].Y.Offset)
            end
        end
    end

    function updateUIFromLoaded()
        task.wait()
        if _G.__STRIKE_SPIN_REFRESH then pcall(_G.__STRIKE_SPIN_REFRESH) end
        syncTextFieldsAndUI()
        if setAutoCarrySpeedVisual then pcall(setAutoCarrySpeedVisual, autoCarrySpeedEnabled) end
        if setAutoCarryEnemyBaseVisual then pcall(setAutoCarryEnemyBaseVisual, autoCarryEnemyBaseEnabled) end
        if autoCarryEnemyBaseEnabled and _G.StrikeStartAutoCarryEnemyBase then pcall(_G.StrikeStartAutoCarryEnemyBase) end
        if setInfiniteJumpVisual then pcall(setInfiniteJumpVisual, infiniteJumpEnabled) end
        if setInfiniteJumpModeVisual then pcall(setInfiniteJumpModeVisual, InfiniteJump.mode) end
        refreshSpeedModeLabel()
        if _G.StrikeCustomTools then pcall(_G.StrikeCustomTools.setEnabled, true) end
        if StrikeShowE01WarningSetVisual then pcall(StrikeShowE01WarningSetVisual, StrikeShowE01Warning) end
        if not StrikeShowE01Warning then StrikeE01StartedAt = nil; if StrikeE01Gui then StrikeE01Gui.Enabled = false end end

        if savedProgressBarPos and pbFrame then
            pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0, savedProgressBarPos.XOffset or 300, savedProgressBarPos.YScale or 1, savedProgressBarPos.YOffset or -80)
        end
        local bgImg = main and main:FindFirstChild("BackgroundImage")
        if bgImg then
            local id = backgroundImages[backgroundIndex]
            bgImg.Image = id == "NONE" and "" or ("rbxassetid://" .. id)
            bgImg.BackgroundTransparency = id == "NONE" and 0 or 1
            bgImg.ImageTransparency = backgroundImageTransparency
        end
        if _G.StrikeRefreshBgPicker then pcall(_G.StrikeRefreshBgPicker) end
        applyFloatingButtonScale()
        if setLockUIVisual then setLockUIVisual(uiLocked) end

        if antiRagdollMode == "v1" then AntiRagdollV1.start() elseif antiRagdollMode == "v2" then startAntiRagdollV2() end
        if updateAntiRagdollModeUI then updateAntiRagdollModeUI(antiRagdollMode) end
        if setAntiDieVisual then setAntiDieVisual(antiDieEnabled) end
        if antiDieEnabled then AntiDieModule.start() end
        if setAntiFlingVisual then pcall(setAntiFlingVisual, antiFlingEnabled) end
        if antiFlingEnabled then pcall(AntiFlingModule.start) else pcall(AntiFlingModule.stop) end

        if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then setInstaGrab(true); pcall(startAutoSteal) end
        if setMedusaVisual then setMedusaVisual(medusaCounterEnabled) end
        if medusaCounterEnabled and LP.Character then setupMedusaCounter(LP.Character) else stopMedusaCounter() end
        if batCounterEnabled and setBatCounterVisual then setBatCounterVisual(true); startBatCounter() end
        if setAntiLagVisual then setAntiLagVisual(antiLagEnabled) end
        if antiLagEnabled then enableAntiLag() else disableAntiLag() end

        toggleESP(espEnabled); toggleESPBox(espBoxEnabled); toggleESPTracker(espTrackerEnabled)
        toggleRagdollCountdown(ragdollCountdownEnabled); toggleAntiTpEsp(antiTpEspEnabled)

        if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
        if autoBatBypassSetVisual then autoBatBypassSetVisual(autoBatBypassEnabled) end
        if stretchEnabled then enableStretch() end
        if _G.stretchToggleSetter then _G.stretchToggleSetter(stretchEnabled) end
        if setFovVisual then setFovVisual(fovEnabled) end
        if fovSliderSet then fovSliderSet(fovValue) end

        if autoBatEnabled then pcall(enableAutoBat) else pcall(disableAutoBat) end
        if autoLeftEnabled then pcall(startAutoLeft) else pcall(stopAutoLeft) end
        if autoRightEnabled then pcall(startAutoRight) else pcall(stopAutoRight) end
        if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
        if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
        if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
        if mobSetCarry then mobSetCarry(speedMode) end
        if mobSetLagger1 then mobSetLagger1(laggerToggled) end
        if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end

        pcall(applySavedFloatingPositions)
        task.delay(0.15, function() pcall(applySavedFloatingPositions) end)
        updateProgressBarVisibility()
        startEnemySpeed()
        toggleLockUI(uiLocked)
    end

    -- ========================================================================
    -- PANTALLA DE INTRO Y AUDIO
    -- ========================================================================
    local function strikeGetAsset(fileName, url, forceRefresh)
        local getAsset = getcustomasset or getsynasset or get_custom_asset
        if type(getAsset) ~= "function" or type(writefile) ~= "function" then return nil end
        local cacheFile = fileName:gsub("%.mp3$", "_v4.mp3")
        local function hasFile(n) local ok, r = pcall(isfile, n); return ok and r == true end
        local del = delfile or deletefile
        if forceRefresh and type(del) == "function" and hasFile(cacheFile) then pcall(del, cacheFile) end

        if not hasFile(cacheFile) then
            local body = nil
            local req = request or http_request or (syn and syn.request)
            if type(req) == "function" then
                local ok, res = pcall(req, { Url = url, Method = "GET", Headers = { ["User-Agent"] = "Mozilla/5.0", ["Accept"] = "audio/mpeg,audio/*,*/*;q=0.8" } })
                if ok and type(res) == "table" then
                    local st = tonumber(res.StatusCode or res.Status or 200) or 200
                    local cand = res.Body or res.body
                    if st >= 200 and st < 400 and type(cand) == "string" and #cand > 1000 then body = cand end
                end
            end
            if not body then
                local ok, res = pcall(function() return game:HttpGet(url) end)
                if ok and type(res) == "string" and #res > 1000 then body = res end
            end
            if body then pcall(writefile, cacheFile, body) end
        end
        if not hasFile(cacheFile) then return nil end
        local ok, asset = pcall(getAsset, cacheFile)
        if ok and type(asset) == "string" and #asset > 0 then return asset end
        if type(del) == "function" and hasFile(cacheFile) then pcall(del, cacheFile) end
        return nil
    end

    local function strikeStopIntroSong()
        if strikeIntroSound then
            pcall(function() strikeIntroSound:Stop(); strikeIntroSound:Destroy() end)
            strikeIntroSound = nil
        end
    end

    local function strikePlayIntroSong(songName, restart)
        _strikeIntroSongRequest = _strikeIntroSongRequest + 1
        local reqId = _strikeIntroSongRequest
        if songName == "Off" or not songName then strikeStopIntroSong(); return end
        local info = INTRO_SONGS[songName]
        if not info then return end
        if restart then strikeStopIntroSong() end
        if strikeIntroSound and strikeIntroSound.Parent then return end

        task.spawn(function()
            local asset = strikeGetAsset(info.file, info.url, false)
            if reqId ~= _strikeIntroSongRequest or strikeIntroFinished then return end
            if not asset then task.wait(0.25); asset = strikeGetAsset(info.file, info.url, true) end
            if reqId ~= _strikeIntroSongRequest or strikeIntroFinished or not asset then return end

            local sound = Instance.new("Sound")
            sound.Name, sound.SoundId, sound.Volume, sound.Looped, sound.PlayOnRemove, sound.Parent = "StrikeIntroMusic", asset, 0.65, false, false, SoundService
            strikeIntroSound = sound
            pcall(function() sound.TimePosition = 0; sound:Play() end)
            for _, delayT in ipairs({ 0.35, 1.0, 1.8 }) do
                task.delay(delayT, function()
                    if reqId == _strikeIntroSongRequest and not strikeIntroFinished and sound.Parent and not sound.IsPlaying then
                        pcall(function() sound:Play() end)
                    end
                end)
            end
        end)
    end

    local function strikeFinishIntro()
        if strikeIntroFinished then return end
        strikeIntroFinished = true
        local g = strikeIntroGui
        if not g then strikeStopIntroSong(); return end
        local bg = g:FindFirstChild("Background")
        local title = bg and bg:FindFirstChild("StrikeTitle")
        local skip = bg and bg:FindFirstChild("SkipText")
        local blur = Lighting:FindFirstChild("StrikeLoadIntroBlur")
        local info = TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        if bg then
            TS:Create(bg, info, { BackgroundTransparency = 1 }):Play()
            for _, c in ipairs(bg:GetChildren()) do
                if c:IsA("ImageLabel") and c.Name:match("^StrikeImageLayer") then TS:Create(c, info, { ImageTransparency = 1 }):Play() end
            end
        end
        if title then TS:Create(title, info, { TextTransparency = 1, TextStrokeTransparency = 1 }):Play() end
        if skip then TS:Create(skip, info, { TextTransparency = 1 }):Play() end
        if blur then TS:Create(blur, info, { Size = 0 }):Play() end
        if strikeIntroSound then
            task.spawn(function()
                local snd = strikeIntroSound
                for i = 1, 16 do
                    if not snd.Parent then break end
                    snd.Volume = 0.65 * (1 - i / 16)
                    task.wait(0.05)
                end
                pcall(function() snd:Stop(); snd:Destroy() end)
                if strikeIntroSound == snd then strikeIntroSound = nil end
            end)
        end
        task.delay(0.42, function()
            if strikeIntroGui == g then strikeIntroGui = nil end
            safeDestroy(g); safeDestroy(blur)
        end)
    end
    _G.__STRIKE_FINISH_INTRO, _G.__STRIKE_PLAY_INTRO_SONG = strikeFinishIntro, strikePlayIntroSong

    local function startStrikeIntro()
        strikeIntroFinished = false
        local pg = LP:FindFirstChildOfClass("PlayerGui")
        if not pg then return end
        safeDestroy(pg:FindFirstChild("StrikeLoadIntro"))
        safeDestroy(Lighting:FindFirstChild("StrikeLoadIntroBlur"))

        local touch = UIS.TouchEnabled and not UIS.KeyboardEnabled
        local g = Instance.new("ScreenGui", pg)
        g.Name, g.IgnoreGuiInset, g.ResetOnSpawn, g.DisplayOrder, g.ZIndexBehavior = "StrikeLoadIntro", true, false, 1000005, Enum.ZIndexBehavior.Global
        strikeIntroGui = g

        local bg = Instance.new("Frame", g)
        bg.Name, bg.BackgroundColor3, bg.BackgroundTransparency, bg.BorderSizePixel, bg.Size, bg.ZIndex = "Background", Color3.fromRGB(5, 3, 7), 1, 0, UDim2.fromScale(1, 1), 1000

        local layers, preload = {}, {}
        for index, cfg in ipairs({
            { size = 0.88, x = -0.018, y = 0.010, alpha = 0.78, z = 1002 },
            { size = 0.94, x = 0.015,  y = -0.008, alpha = 0.86, z = 1003 },
            { size = 1,    x = 0,      y = 0,      alpha = 0,    z = 1004 },
        }) do
            local img = Instance.new("ImageLabel", bg)
            img.Name, img.BackgroundTransparency, img.BorderSizePixel, img.AnchorPoint = "StrikeImageLayer" .. index, 1, 0, Vector2.new(0.5, 0.5)
            img.Position, img.Size, img.Image, img.ImageTransparency, img.ScaleType, img.ZIndex = UDim2.fromScale(0.5 + cfg.x, 0.47 + cfg.y), UDim2.fromScale(cfg.size, cfg.size), "rbxassetid://85237648711573", cfg.alpha, Enum.ScaleType.Fit, cfg.z
            layers[index] = { object = img, config = cfg, phase = index * 1.7 }
            preload[index] = img
        end

        local title = Instance.new("TextLabel", bg)
        title.Name, title.BackgroundTransparency, title.AnchorPoint, title.Position, title.Size = "StrikeTitle", 1, Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.88), UDim2.new(0.8, 0, 0, 42)
        title.Font, title.Text, title.TextColor3, title.TextStrokeColor3, title.TextStrokeTransparency, title.TextScaled, title.TextTransparency, title.ZIndex = Enum.Font.GothamBlack, "STRIKE DUELO", Color3.new(1, 1, 1), Color3.fromRGB(180, 0, 42), 0.25, true, 1, 1009

        local skip = Instance.new("TextLabel", bg)
        skip.Name, skip.BackgroundTransparency, skip.Text, skip.TextColor3, skip.TextTransparency = "SkipText", 1, "CLICK ANYWHERE TO SKIP", Color3.fromRGB(220, 220, 225), 1
        skip.TextSize, skip.Font, skip.AnchorPoint, skip.Position, skip.Size, skip.ZIndex = touch and 11 or 13, Enum.Font.GothamMedium, Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.96), UDim2.new(0.8, 0, 0, 22), 1010

        local hit = Instance.new("TextButton", bg)
        hit.BackgroundTransparency, hit.Text, hit.AutoButtonColor, hit.Size, hit.ZIndex = 1, "", false, UDim2.fromScale(1, 1), 1011
        hit.Activated:Connect(strikeFinishIntro)

        local blur = Instance.new("BlurEffect", Lighting)
        blur.Name, blur.Size = "StrikeLoadIntroBlur", 0

        task.spawn(function() pcall(function() ContentProvider:PreloadAsync(preload) end) end)
        TS:Create(title, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()
        TS:Create(blur, TweenInfo.new(0.5), { Size = 8 }):Play()
        TS:Create(skip, TweenInfo.new(0.35), { TextTransparency = 0.25 }):Play()

        task.spawn(function()
            pcall(strikePlayIntroSong, INTRO_SONG, true)
            local waitStart = os.clock()
            while not strikeIntroFinished and INTRO_SONG ~= "Off" and (not strikeIntroSound or not strikeIntroSound.IsPlaying) and os.clock() - waitStart < 12 do
                task.wait(0.05)
            end
            if strikeIntroFinished or not g.Parent then return end
            local started = os.clock()
            while g.Parent and not strikeIntroFinished do
                local elapsed = os.clock() - started
                for _, entry in ipairs(layers) do
                    local t = elapsed * 1.15 + entry.phase
                    local z = math.sin(t * 0.85) * 0.025
                    entry.object.Size = UDim2.fromScale(entry.config.size + z, entry.config.size + z)
                    entry.object.Position = UDim2.fromScale(0.5 + entry.config.x + math.sin(t * 0.72) * 0.012, 0.47 + entry.config.y + math.cos(t * 0.63) * 0.010)
                    entry.object.Rotation = math.sin(t * 0.55) * 1.8
                end
                if elapsed >= 7 then strikeFinishIntro(); break end
                RunService.RenderStepped:Wait()
            end
        end)
    end

    -- ========================================================================
    -- ARRANQUE, RECUPERACIÓN DE CONTROLES Y KEYBINDS
    -- ========================================================================
    local buildOk, buildErr = pcall(buildGui)
    if not buildOk then
        warn("[STRIKE GUI] buildGui error: " .. tostring(buildErr))
        safeDestroy(CoreGui:FindFirstChild("STRIKE"))
        local pg = LP and LP:FindFirstChildOfClass("PlayerGui")
        if pg then safeDestroy(pg:FindFirstChild("STRIKE")) end
        _G.__STRIKE_RUNTIME, _G.StrikeRunning = nil, nil
        return
    end
    _G.__STRIKE_RUNTIME.phase = "menu_ready"

    task.defer(function()
        local ok, loaded = pcall(loadAllSettings)
        _isLoading, _configReady = false, true
        if ok and loaded then
            if currentPackAnimation and currentPackAnimation ~= "OFF" and applyPackAnimationGlobal then
                pcall(applyPackAnimationGlobal, currentPackAnimation)
            elseif applyAnimPackGlobal then
                pcall(applyAnimPackGlobal, currentAnimPack or "OFF")
            end
            local ds = _G.StrikeDisplaySkinState
            if ds and ds.customSkinEnabled and ds.displaySkin ~= "Off" and StrikeDisplaySkin and StrikeDisplaySkin.apply then
                task.delay(0.8, function() pcall(StrikeDisplaySkin.apply) end)
            end
            pcall(updateUIFromLoaded)
        else
            _lastSavedJSON = nil
            saveAllSettings()
        end
        task.defer(function() pcall(startStrikeIntro) end)
    end)

    local function ensureFloatingControls()
        local function alive(obj, name) return obj ~= nil and obj.Parent ~= nil and obj.Name == name end
        local function wipe(name)
            safeDestroy(CoreGui:FindFirstChild(name))
            local pg = LP:FindFirstChild("PlayerGui")
            if pg then safeDestroy(pg:FindFirstChild(name)) end
        end
        if not alive(MobilePanel, "StrikeMobilePanel") then wipe("StrikeMobilePanel"); local ok, o = pcall(createMobilePanel); if ok then MobilePanel = o end end
        if not alive(tpBatFloatingButton, "TpBatButton") then wipe("TpBatButton"); local ok, o = pcall(createTpBatFloatingButton); if ok then tpBatFloatingButton = o end end
        if not alive(batBypassFloatingButton, "BatBypassButton") then wipe("BatBypassButton"); local ok, o = pcall(createBatBypassFloatingButton); if ok then batBypassFloatingButton = o end end
        if not alive(instaResetFloatingButton, "InstaResetButton") then wipe("InstaResetButton"); local ok, o = pcall(createInstaResetFloatingButton); if ok then instaResetFloatingButton = o end end
        pcall(setMobileButtonsHidden, mobileButtonsHidden)
        if hideMobileBtnsSetVisual then pcall(hideMobileBtnsSetVisual, mobileButtonsHidden) end
        pcall(applySavedFloatingPositions)
    end

    _G.__STRIKE_RUNTIME.phase = "floating_controls"
    pcall(ensureFloatingControls)
    for i = 1, 4 do task.delay(0.35 * i, function() pcall(ensureFloatingControls) end) end
    task.spawn(function()
        while _G.__STRIKE_RUNTIME and _G.__STRIKE_RUNTIME.running do
            task.wait(2.5)
            pcall(ensureFloatingControls)
        end
    end)

    _G.__STRIKE_RUNTIME.phase = "running"
    if LP.Character and waitForCharReady(LP.Character, 5) then
        setupMovementAndIndicators(LP.Character)
    end

    local respawnQueue = 0
    LP.CharacterAdded:Connect(function(char)
        respawnQueue = respawnQueue + 1
        local myId = respawnQueue
        safeDisconnect(stealConnection); stealConnection = nil
        isStealing = false
        autoLeftEnabled, autoRightEnabled = false, false
        stopAutoLeft(); stopAutoRight(); stopBatCounter(); stopMedusaCounter(); stopDropBrainrot()
        if autoBatEnabled then disableAutoBat() end
        if batDesyncTpEnabled then stopBatDesyncTp() end
        if autoBatBypassEnabled then disableBatBypass() end

        if not waitForCharReady(char, 5) or myId ~= respawnQueue then return end
        _hookedVelParts = {}
        _hookVelHRP(_setupVelChecked(char))
        setupMovementAndIndicators(char)

        if antiRagdollMode == "v1" then AntiRagdollV1.start() elseif antiRagdollMode == "v2" then startAntiRagdollV2() end
        if updateAntiRagdollModeUI then updateAntiRagdollModeUI(antiRagdollMode) end
        if AntiDieModule.enabled then task.defer(activateOnCharacter, char) end
        if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end
        if setMedusaVisual then setMedusaVisual(medusaCounterEnabled) end
        if medusaCounterEnabled then setupMedusaCounter(char) else stopMedusaCounter() end
        if batCounterEnabled then startBatCounter() end
        updateProgressBarVisibility()
        refreshSpeedModeLabel()
    end)

    local lastLaggerToggle = 0
    UIS.InputBegan:Connect(function(input, gpe)
        if _anyKeyListening then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if gpe or UIS:GetFocusedTextBox() then return end
        elseif not isGamepadInput(input) then
            return
        end
        if not isBindableInput(input) then return end
        local kc = input.KeyCode
        if not kc then return end

        if kbMatch(KB.LaggerMode, kc) then
            if _tick() - lastLaggerToggle >= 0.3 then lastLaggerToggle = _tick(); toggleLaggerCycle() end
        elseif kbMatch(KB.CarryToggle, kc) or kbMatch(KB.Carry, kc) then
            toggleCarryMode()
            CarrySystem.speedToggled = speedMode
            CarrySystem.laggerMode = laggerCarryToggled and 2 or (laggerToggled and 1 or 0)
        elseif kbMatch(KB.LaggerCarry, kc) then
            speedMode, laggerToggled, laggerCarryToggled = false, false, not laggerCarryToggled
            resetMovementState()
            CarrySystem.speedToggled = speedMode
            CarrySystem.laggerMode = laggerCarryToggled and 2 or 0
        elseif kbMatch(KB.DropBrainrot, kc) then
            if not dropActive then
                if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
                executeDropWithToggle(dropBrainrotSetVisual)
            end
        elseif kbMatch(KB.TPFloor, kc) then
            doTpDown()
            if mobSetTpDown then mobSetTpDown(true); task.delay(0.22, function() if mobSetTpDown then mobSetTpDown(false) end end) end
        elseif kbMatch(KB.InstaReset, kc) then
            if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
                local fr = instaResetFloatingButton.Frame
                paintFloatingBtn(fr, true)
                task.delay(0.22, function() if fr.Parent then paintFloatingBtn(fr, false) end end)
            end
            if _G.InstaReset and type(_G.InstaReset.Trigger) == "function" then pcall(_G.InstaReset.Trigger) end
        elseif kbMatch(KB.AutoLeft, kc) then
            autoLeftEnabled = not autoLeftEnabled
            if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
            if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
            if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
        elseif kbMatch(KB.AutoRight, kc) then
            autoRightEnabled = not autoRightEnabled
            if autoRightEnabled then startAutoRight() else stopAutoRight() end
            if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
            if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
        elseif kbMatch(KB.AutoBat, kc) then
            if autoBatEnabled then disableAutoBat() else enableAutoBat() end
        elseif kbMatch(KB.TPBat, kc) then
            toggleBatDesyncTp()
        elseif kbMatch(KB.BatBypass, kc) then
            toggleBatBypass()
        elseif kbMatch(KB.GuiHide, kc) and main then
            if main.Visible then hideGui() else showGui() end
        end
    end)
end