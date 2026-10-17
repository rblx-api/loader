-- DUPLICATE EXECUTION GUARD:
-- Si STRIKE ya esta ejecutandose, esta segunda ejecucion termina aqui
-- sin borrar ni recrear el menu, sin duplicar botones y sin reiniciar opciones.
if _G.BloodHoundsRunning then
    return
end
_G.BloodHoundsRunning = true

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
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ============================================================
-- CUSTOM TOOLS + CUSTOM SOUNDS ENGINE (integrado)
-- ============================================================
if not _G.__CT_ENGINE_INJECTED then
_G.__CT_ENGINE_INJECTED = true
do
    local _Players    = game:GetService("Players")
    local _RunService = game:GetService("RunService")
    local _LP         = _Players.LocalPlayer

    -- Item riconosciuti (Bat / Slap Bat / Medusa's Head)
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

    local function isReplicaStuff(d)
        if d.Name == "LocalReplica" then return true end
        return d:FindFirstAncestor("LocalReplica") ~= nil
    end

    -- ------------------------------------------------------------
    -- GESTORE TRASPARENZA CONDIVISO
    -- Evita che Transparent e Custom Tools si sovrascrivano a vicenda.
    -- Ogni modulo "prenota" un valore, vince la priorita' piu' alta,
    -- e il valore originale vero viene letto una sola volta (baseline).
    -- ------------------------------------------------------------
    local CT_Trans = {}
    do
        local PRIORITY = { "custom", "rainbow", "transparent" }
        local baseline = setmetatable({}, { __mode = "k" })
        local claims   = setmetatable({}, { __mode = "k" })
        -- Connessioni GetPropertyChangedSignal("Transparency") per parte:
        -- servono a rimettere subito il valore se il gioco lo sovrascrive
        -- (e' il motivo per cui la bat originale ricompariva sopra la custom).
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

        -- Scrive solo se il valore e' davvero diverso: il watchdog dei
        -- Custom Tools richiama claim() sulle stesse parti ogni 0.4s e
        -- senza questo controllo sarebbero centinaia di property write
        -- inutili al secondo.
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
            if b ~= nil then
                setIfDifferent(part, b)
            end
        end

        -- Riapplica subito il valore prenotato se qualcun altro lo cambia.
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

        -- Rete di sicurezza: se un evento e' andato perso (o la parte e'
        -- stata sostituita) il sweep periodico rimette tutto a posto.
        function CT_Trans.enforce()
            for part, _ in pairs(claims) do
                if part.Parent then
                    local v = wantedValue(part)
                    if v ~= nil then
                        local ok, cur = pcall(function() return part.Transparency end)
                        if ok and cur ~= nil and math.abs(cur - v) > 0.001 then
                            pcall(function() part.Transparency = v end)
                        end
                    end
                end
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

    -- ------------------------------------------------------------
    -- JANITOR: ogni 10s scarta le entry di oggetti non piu' esistenti,
    -- cosi' le tabelle non crescono in sessioni molto lunghe.
    -- ------------------------------------------------------------
    local CT_JANITORS = {}
    task.spawn(function()
        while true do
            task.wait(10)
            for _, fn in ipairs(CT_JANITORS) do pcall(fn) end
        end
    end)

    -- Sweep trasparenze: 4 volte al secondo rimette i valori prenotati.
    -- Gira solo se almeno uno dei tre moduli e' acceso.
    task.spawn(function()
        while true do
            task.wait(0.25)
            if _G.AmbitiousCustomToolsEnabled == true
            or _G.AmbitiousTransparentToolsEnabled == true
            or _G.AmbitiousRainbowToolsEnabled == true then
                pcall(CT_Trans.enforce)
            end
        end
    end)


    -- ############################################################
    -- ##                     CUSTOM TOOLS                       ##
    -- ## Bat -> Diamond Sword  Medusa's Head -> Golden Desert Eagle ##
    -- ############################################################
    do
        -- Catalogo skin. "cat" e' la categoria di oggetto su cui si applica.
        local ASSETS = {
            DiamondSword      = { cat = "Bat",    label = "Diamond Sword",
                                  mesh = "rbxassetid://8827558932", tex = "rbxassetid://8827558969",
                                  scale = Vector3.new(0.2, 0.2, 0.2),
                                  c0 = CFrame.new(-0.05, -0.1, -0.12) * CFrame.Angles(math.rad(90), math.rad(180), 300),
                                  -- view = distanza della camera nell'anteprima:
                                  -- piu' alta, piu' piccolo appare l'oggetto
                                  view = 4.9 },
            Katana            = { cat = "Bat",    label = "Katana",
                                  mesh = "rbxassetid://13528902482", tex = "rbxassetid://13528902373",
                                  scale = Vector3.new(1.4, 1.4, 1.4),
                                  c0 = CFrame.new(0, 0.6, 0) * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180)),
                                  view = 6.6 },
            -- Katana procedural con VFX rojo (portado del Lua Clean).
            -- No usa mesh: se arma con partes (procedural = true).
            BatSkin           = { cat = "Bat",    label = "Bat Skin",
                                  procedural = true,
                                  view = 5.6 },
            Skull             = { cat = "Medusa", label = "Skull",
                                  mesh = "rbxassetid://2050312704", tex = "rbxassetid://2050313393",
                                  scale = Vector3.new(1, 1, 1),
                                  c0 = CFrame.new(0, 0.65, -0.4) * CFrame.Angles(math.rad(330), 0, 0),
                                  view = 4.2 },
            GoldenDesertEagle = { cat = "Medusa", label = "Golden Desert Eagle",
                                  mesh = "rbxassetid://430251413", tex = "rbxassetid://435840335",
                                  scale = Vector3.new(0.01, 0.01, 0.01),
                                  c0 = CFrame.new(0, 0, -0.8) * CFrame.Angles(math.rad(330), math.rad(180), 0),
                                  view = 3.0 },
        }
        _G.AmbitiousCustomToolAssets = ASSETS

        -- ------------------------------------------------------------
        -- BAT SKIN (katana procedural + VFX rojo) portado del Lua Clean.
        -- Construye las partes de la katana dentro de `container`.
        --   handle ~= nil  -> replica real: partes soldadas (Motor6D) al Handle.
        --   handle == nil  -> miniatura del viewport: partes ancladas en el origen.
        -- Devuelve la parte "SharpParts" (donde van los efectos rojos).
        -- ------------------------------------------------------------
        _G.AmbitiousBuildKatanaSkin = function(container, handle)
            local katanaColors = {
                red  = Color3.new(0.784314, 0, 0),
                red2 = Color3.new(1, 0, 0.392157),
                gold = Color3.new(1, 0.843137, 0),
            }
            local specs = {
                { name = "Handle2",    size = Vector3.new(0.22, 1, 0.22),  off = CFrame.new(0, -0.48, 0), color = Color3.new(0.176471, 0.176471, 0.045), mat = Enum.Material.Metal },
                { name = "SharpParts", size = Vector3.new(0.18, 2.4, 0.12), off = CFrame.new(0, 1.05, 0),   color = katanaColors.red2, mat = Enum.Material.Neon },
                { name = "WeaponPart", size = Vector3.new(0.3, 2.7, 0.08),  off = CFrame.new(0.08, 1.15, 0),color = katanaColors.red,  mat = Enum.Material.Neon },
                { name = "GoldAccent", size = Vector3.new(0.5, 0.12, 0.08), off = CFrame.new(0, -0.28, 0),  color = katanaColors.gold, mat = Enum.Material.Neon },
            }
            local sharp
            for _, s in ipairs(specs) do
                local part = Instance.new("Part")
                part.Name         = s.name
                part.Size         = s.size
                part.Color        = s.color
                part.Material     = s.mat
                part.TopSurface   = Enum.SurfaceType.Smooth
                part.BottomSurface= Enum.SurfaceType.Smooth
                part.CanCollide   = false
                part.CanQuery     = false
                part.CanTouch     = false
                part.Massless     = true
                if handle then
                    part.Anchored = false
                    part.CFrame   = handle.CFrame * s.off
                    part.Parent   = container
                    local w = Instance.new("Motor6D")
                    w.Part0 = handle
                    w.Part1 = part
                    w.C0    = s.off
                    w.Parent = part
                else
                    part.Anchored = true
                    part.CFrame   = s.off
                    part.Parent   = container
                end
                if s.name == "SharpParts" then sharp = part end
            end
            -- VFX rojo: trail + particulas (igual que el Clean).
            if sharp then
                local topA = Instance.new("Attachment")
                topA.Name = "FlowerSkin_ExtraRedVFX"
                topA.Position = Vector3.new(0, sharp.Size.Y * 0.5, 0)
                topA.Parent = sharp
                local botA = Instance.new("Attachment")
                botA.Name = "FlowerSkin_ExtraRedVFX_End"
                botA.Position = Vector3.new(0, -sharp.Size.Y * 0.5, 0)
                botA.Parent = sharp
                local trail = Instance.new("Trail")
                trail.Name = "FlowerSkin_ExtraRedVFX"
                trail.Attachment0 = topA
                trail.Attachment1 = botA
                trail.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, katanaColors.red2),
                    ColorSequenceKeypoint.new(1, Color3.new(0.54902, 0, 0)),
                })
                trail.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.35),
                    NumberSequenceKeypoint.new(1, 1),
                })
                trail.Lifetime = 0.18
                trail.LightEmission = 0.55
                trail.Parent = sharp
                local pe = Instance.new("ParticleEmitter")
                pe.Name = "FlowerSkin_ExtraRedVFX"
                pe.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(0.784314, 0, 0)),
                    ColorSequenceKeypoint.new(1, katanaColors.red2),
                })
                pe.LightEmission = 0.55
                pe.Rate = 14
                pe.Lifetime = NumberRange.new(0.3, 0.45)
                pe.Speed = NumberRange.new(0.2, 0.7)
                pe.SpreadAngle = Vector2.new(12, 12)
                pe.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.08),
                    NumberSequenceKeypoint.new(1, 0),
                })
                pe.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                pe.Parent = sharp
            end
            return sharp
        end

        -- Skin attualmente scelta per ogni categoria.
        _G.AmbitiousCustomToolSkins = _G.AmbitiousCustomToolSkins
            or { Bat = "DiamondSword", Medusa = "GoldenDesertEagle" }

        local function skinFor(cat)
            local key = _G.AmbitiousCustomToolSkins[cat]
            if key and ASSETS[key] and ASSETS[key].cat == cat then return key end
            return (cat == "Bat") and "DiamondSword" or "GoldenDesertEagle"
        end

        local enabled       = false
        local tracked       = setmetatable({}, { __mode = "k" })  -- [tool] = { hidden, conns }
        local watchers      = setmetatable({}, { __mode = "k" })
        local pendingHandle = setmetatable({}, { __mode = "k" })  -- [tool] = conn
        local teardown

        local function buildReplica(handle, mode)
            local existing = handle:FindFirstChild("LocalReplica")
            if existing then existing:Destroy() end

            local data = ASSETS[mode] or ASSETS.DiamondSword

            -- Skin procedural (Bat Skin / katana con VFX rojo): no es un mesh,
            -- se arma con partes soldadas al Handle dentro del LocalReplica.
            if data.procedural then
                local m = Instance.new("Model")
                m.Name = "LocalReplica"
                -- MainPart invisible: mantiene feliz al watchdog (MainPart + Motor6D).
                local anchor = Instance.new("Part")
                anchor.Name         = "MainPart"
                anchor.Transparency = 1
                anchor.Size         = Vector3.new(0.1, 0.1, 0.1)
                anchor.CanCollide   = false
                anchor.CanQuery     = false
                anchor.CanTouch     = false
                anchor.Massless     = true
                anchor.Anchored     = false
                anchor.CFrame       = handle.CFrame
                anchor.Parent       = m
                local aw = Instance.new("Motor6D")
                aw.Part0 = handle
                aw.Part1 = anchor
                aw.C0    = CFrame.new()
                aw.Parent = anchor
                if _G.AmbitiousBuildKatanaSkin then
                    pcall(_G.AmbitiousBuildKatanaSkin, m, handle)
                end
                m.Parent = handle
                return m
            end

            local m = Instance.new("Model")
            m.Name = "LocalReplica"

            local p = Instance.new("Part")
            p.Name        = "MainPart"
            p.CanCollide  = false
            p.CanQuery    = false
            p.CanTouch    = false
            p.Massless    = true
            p.Size        = Vector3.new(1, 1, 1)
            p.Transparency= 0
            p.Anchored    = false
            p.Parent      = m

            local mesh = Instance.new("SpecialMesh")
            mesh.MeshType  = Enum.MeshType.FileMesh
            mesh.MeshId    = data.mesh
            mesh.TextureId = data.tex
            mesh.Parent    = p

            local w = Instance.new("Motor6D")
            w.Part0 = handle
            w.Part1 = p

            -- Scala e impugnatura vengono dal catalogo, non da un if per skin
            mesh.Scale = data.scale
            w.C0 = data.c0

            w.Parent = p
            m.Parent = handle
            return m
        end

        -- Nasconde (NON distrugge) solo la grafica: parti, decal e texture.
        -- Suoni, script e componenti di gioco restano intatti.
        -- Idempotente di proposito: il watchdog lo richiama sulle stesse
        -- parti per ri-prenotare la trasparenza se e' stata persa.
        local function hideNode(entry, d)
            if isReplicaStuff(d) then return end
            if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then
                entry.hidden[d] = true
                CT_Trans.claim(d, "custom", 1)
            end
        end

        local function setupTool(tool)
            if tracked[tool] then return end

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

            local entry = { hidden = {}, conns = {} }
            tracked[tool] = entry

            for _, d in ipairs(tool:GetDescendants()) do hideNode(entry, d) end

            local item = ctMatchItem(tool)
            local mode = skinFor((item and item.key == "Bat") and "Bat" or "Medusa")
            entry.cat = (item and item.key == "Bat") and "Bat" or "Medusa"
            buildReplica(handle, mode)

            table.insert(entry.conns, tool.DescendantAdded:Connect(function(d)
                task.defer(function()
                    if tracked[tool] then hideNode(entry, d) end
                end)
            end))
            table.insert(entry.conns, tool.AncestryChanged:Connect(function(_, parent)
                if not parent then teardown(tool, false) end
            end))
        end

        function teardown(tool, doRestore)
            local entry = tracked[tool]
            if not entry then return end
            for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end

            local handle = tool:FindFirstChild("Handle")
            if handle then
                local rep = handle:FindFirstChild("LocalReplica")
                if rep then pcall(function() rep:Destroy() end) end
            end

            for obj in pairs(entry.hidden) do
                CT_Trans.release(obj, "custom")
            end
            entry.hidden = {}
            tracked[tool] = nil
        end

        local function tryRegister(inst)
            if not enabled then return end
            if inst:IsA("Tool") and ctMatchItem(inst) then
                setupTool(inst)
            end
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
            watch(_LP:FindFirstChildOfClass("Backpack"))
            watch(_LP.Character)
        end

        _LP.ChildAdded:Connect(function(child)
            if enabled and child:IsA("Backpack") then watch(child) end
        end)

        _LP.CharacterAdded:Connect(function(char)
            for tool in pairs(tracked) do teardown(tool, false) end
            for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
            table.clear(pendingHandle)
            -- pulizia totale: il vecchio Character e il vecchio Backpack sono morti
            for container in pairs(watchers) do unwatch(container) end
            if not enabled then return end
            watch(char)
            task.defer(function()
                if enabled then watchAll() end
            end)
        end)

        table.insert(CT_JANITORS, function()
            for tool in pairs(tracked) do
                if not tool.Parent then teardown(tool, false) end
            end
            for tool, c in pairs(pendingHandle) do
                if not tool.Parent then
                    pcall(function() c:Disconnect() end)
                    pendingHandle[tool] = nil
                end
            end
            for container in pairs(watchers) do
                if not container.Parent then unwatch(container) end
            end
        end)

        -- ------------------------------------------------------------
        -- WATCHDOG INTEGRITA'
        -- Copre i due bug segnalati:
        --  1) la replica custom sparisce e resta solo l'arma originale
        --     (tool ri-parentato, Handle sostituito, replica distrutta);
        --  2) l'arma originale ricompare sopra la replica
        --     (trasparenza sovrascritta dal gioco -> ri-nascosta).
        -- ------------------------------------------------------------
        local function rebuildIfNeeded(tool, entry, deep)
            local handle = tool:FindFirstChild("Handle")
            if not handle then return end
            local rep      = handle:FindFirstChild("LocalReplica")
            local mainPart = rep and rep:FindFirstChild("MainPart")
            local motor    = mainPart and mainPart:FindFirstChildOfClass("Motor6D")
            local broken   = (not rep) or (not mainPart) or (not motor) or motor.Part0 ~= handle
            if broken then
                local item = ctMatchItem(tool)
                buildReplica(handle, skinFor((item and item.key == "Bat") and "Bat" or "Medusa"))
            end
            -- Ripassata completa solo se la replica era rotta o su richiesta
            if broken or deep then
                for _, d in ipairs(tool:GetDescendants()) do hideNode(entry, d) end
            end
        end

        -- deep = ripassa anche tutti i descendant dei tool (piu' costoso).
        -- Il giro leggero controlla solo che la replica esista: la
        -- trasparenza e' gia' coperta dai guard + sweep di CT_Trans.
        local function integrityPass(deep)
            if not enabled then return end
            -- ri-aggancia i container (Backpack ricreato, respawn, ecc.)
            watchAll()
            local bp = _LP:FindFirstChildOfClass("Backpack")
            if bp then for _, ch in ipairs(bp:GetChildren()) do tryRegister(ch) end end
            local chr = _LP.Character
            if chr then for _, ch in ipairs(chr:GetChildren()) do tryRegister(ch) end end
            for tool, entry in pairs(tracked) do
                if not tool.Parent then
                    teardown(tool, false)
                else
                    rebuildIfNeeded(tool, entry, deep)
                end
            end
        end

        _G.AmbitiousCustomToolsRecheck = function() pcall(integrityPass, true) end

        -- Cambio skin: aggiorna la scelta e ricostruisce subito le repliche
        -- gia' agganciate, senza dover spegnere e riaccendere il modulo.
        _G.AmbitiousSetCustomToolSkin = function(cat, key)
            if not ASSETS[key] or ASSETS[key].cat ~= cat then return end
            _G.AmbitiousCustomToolSkins[cat] = key
            for tool, entry in pairs(tracked) do
                if tool.Parent and entry.cat == cat then
                    local handle = tool:FindFirstChild("Handle")
                    if handle then pcall(buildReplica, handle, key) end
                end
            end
            if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
        end

        task.spawn(function()
            local n = 0
            while true do
                task.wait(0.4)
                if enabled then
                    n = n + 1
                    pcall(integrityPass, (n % 5) == 0)   -- deep ogni 2s
                end
            end
        end)

        -- Riapplica subito quando equipaggi/sganci un'arma, senza aspettare
        -- il giro del watchdog.
        _LP.CharacterAdded:Connect(function()
            task.delay(0.6, function() if enabled then pcall(integrityPass, true) end end)
        end)

        _G.AmbitiousCustomTools = {
            setEnabled = function(on)
                on = on and true or false
                enabled = on
                _G.AmbitiousCustomToolsEnabled = on
                if on then
                    watchAll()
                    pcall(integrityPass, true)
                else
                    for tool in pairs(tracked) do teardown(tool, true) end
                    for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
                    table.clear(pendingHandle)
                    for container in pairs(watchers) do unwatch(container) end
                end
            end,
            isEnabled = function() return enabled end,
        }
    end


    -- ############################################################
    -- ##                    CUSTOM SOUNDS                       ##
    -- ##   Bat -> katana slash      Medusa -> gunshot           ##
    -- ##   Indipendente da Custom Tools: funziona anche da solo ##
    -- ############################################################
    do
        local SOUNDS = {
            Bat    = { id = "rbxassetid://5713085119", skip = 0.2 },
            -- Medusa: sonido custom eliminado (mantiene el sonido original del juego)
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

            local item = ctMatchItem(tool)
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
            if inst:IsA("Tool") and ctMatchItem(inst) then setupTool(inst) end
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
            watch(_LP:FindFirstChildOfClass("Backpack"))
            watch(_LP.Character)
        end

        _LP.ChildAdded:Connect(function(child)
            if enabled and child:IsA("Backpack") then watch(child) end
        end)

        _LP.CharacterAdded:Connect(function(char)
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

        table.insert(CT_JANITORS, function()
            for tool in pairs(tracked) do
                if not tool.Parent then teardown(tool) end
            end
            for tool, c in pairs(pendingHandle) do
                if not tool.Parent then
                    pcall(function() c:Disconnect() end)
                    pendingHandle[tool] = nil
                end
            end
            for container in pairs(watchers) do
                if not container.Parent then unwatch(container) end
            end
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
end
end

-- ============================================================
-- CACHÉ LOCAL DE SERVICIOS Y FUNCIONES (hot paths)
-- ============================================================
local _tick          = tick
local _clamp         = math.clamp
local _floor         = math.floor
local _abs           = math.abs
local _huge          = math.huge
local _sqrt          = math.sqrt
local _V3new         = Vector3.new
local _V3zero        = Vector3.zero
local _CFnew         = CFrame.new
local _CFlookAt      = CFrame.lookAt
local _RayParams_new = RaycastParams.new

local _GetPlayersCached
do
    local cache, cacheTime = nil, 0
    _GetPlayersCached = function()
        local now = _tick()
        if cache and now - cacheTime < 0.03 then return cache end
        cache = Players:GetPlayers()
        cacheTime = now
        return cache
    end
end

local function waitForCharReady(char, timeout)
    timeout = timeout or 5
    local deadline = _tick() + timeout
    while (not char) or (not char.Parent)
          or (not char:FindFirstChild("HumanoidRootPart"))
          or (not char:FindFirstChildOfClass("Humanoid")) do
        if _tick() > deadline then return false end
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
CONFIG_FILE = "BloodHounds.json"
BAT_BYPASS_HIT_DIST = 13
_isDraggingButton = false

backgroundIndex = 1
backgroundImages = {
    "137338489752414",
    "93911181356004",
    "89641090130412",
    "122306646078754"
}

backgroundImageTransparency = 0
floatingButtonScale = 1
mobileButtonsHidden = false
_mobileBtnCorners = {}
_mobileBtns = {}
_floatingBtnCorners = {}
_mobilePanelContainer = nil
mobileMainPanelGui = nil
stealBarScale = 0.45
_floatingUIScales = {}

local CarrySystem = {

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
}

function CarrySystem:isCarrying()
    local now = _tick()
    if now - (self._lastCarryCheck or 0) < 0.1 then
        return self._isCarrying
    end
    self._lastCarryCheck = now
    local char = LP.Character
    if not char then self._isCarrying = false; return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local ws = hum and hum.WalkSpeed or 16
    local bySpeed = (ws < 25 and ws > 0)
    local byAttr = false
    local ok, v = pcall(function() return LP:GetAttribute("Stealing") end)
    if ok and v == true then byAttr = true end
    local ok2, v2 = pcall(function() return char:GetAttribute("Stealing") end)
    if ok2 and v2 == true then byAttr = true end
    if not byAttr then
        for _, name in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
            local obj = char:FindFirstChild(name)
            if obj then
                if (obj:IsA("BoolValue") and obj.Value) or
                   (obj:IsA("ObjectValue") and obj.Value) or
                   (obj:IsA("StringValue") and obj.Value ~= "") then
                    byAttr = true; break
                end
            end
        end
    end
    self._isCarrying = bySpeed or byAttr
    return self._isCarrying
end

function CarrySystem:getActiveSpeed()
    if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
        return self.normalSpeed
    end
    if self.softStealEnabled then
        local _, dist = self:getNearestSoftStealAnimal(self.softStealRadius)
        local inRange = dist and dist <= self.softStealRadius
        if inRange then
            self.softStealLatched = true
            return self.softStealSpeed
        end
        if self.softStealLatched and self:isCarrying() then
            return self.softStealSpeed
        else
            self.softStealLatched = false
        end
    end
    if self.laggerMode == 1 then return self.laggerSpeed end
    if self.laggerMode == 2 then return self.laggerCarrySpeed end
    if self.speedToggled then return self.carrySpeed end
    return self.normalSpeed
end

function CarrySystem:getStatus()
    if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
        return "NORMAL", self.normalSpeed
    end
    if self.softStealEnabled then
        local _, dist = self:getNearestSoftStealAnimal(self.softStealRadius)
        local inRange = dist and dist <= self.softStealRadius
        if inRange or (self.softStealLatched and self:isCarrying()) then
            return "AUTO CARRY", self.softStealSpeed
        end
    end
    if self.laggerMode == 1 then return "LAGGER", self.laggerSpeed end
    if self.laggerMode == 2 then return "LAGGER CARRY", self.laggerCarrySpeed end
    if self.speedToggled then return "CARRY", self.carrySpeed end
    return "NORMAL", self.normalSpeed
end

local function destroyLV()
    if CarrySystem._lvBoost and CarrySystem._lvBoost.Parent then pcall(function() CarrySystem._lvBoost:Destroy() end) end
    if CarrySystem._lvAtt and CarrySystem._lvAtt.Parent then pcall(function() CarrySystem._lvAtt:Destroy() end) end
    CarrySystem._lvBoost = nil; CarrySystem._lvAtt = nil
end

local function setupLV(hrp)
    if CarrySystem._lvBoost and CarrySystem._lvBoost.Parent == hrp then return end
    destroyLV()
    local att = Instance.new("Attachment"); att.Parent = hrp
    local lv = Instance.new("LinearVelocity")
    lv.Name = "CarryBoostLV"
    lv.Attachment0 = att
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    lv.PrimaryTangentAxis = _V3new(1,0,0)
    lv.SecondaryTangentAxis = _V3new(0,0,1)
    lv.MaxForce = CarrySystem._maxForce
    lv.PlaneVelocity = Vector2.zero
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.Parent = hrp
    CarrySystem._lvAtt = att
    CarrySystem._lvBoost = lv
    pcall(function() hrp:SetNetworkOwner(LP) end)
end

function CarrySystem:scanSoftStealAnimals()
    self._softStealAnimals = {}
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, podium in ipairs(podiums:GetChildren()) do
                    if podium:IsA("Model") then
                        local base = podium:FindFirstChild("Base")
                        local spawn = base and base:FindFirstChild("Spawn")
                        if spawn then
                            table.insert(self._softStealAnimals, {
                                plot = plot.Name,
                                slot = podium.Name,
                                worldPosition = spawn.Position,
                                uid = plot.Name .. "_" .. podium.Name,
                            })
                        end
                    end
                end
            end
        end
    end
end

function CarrySystem:startSoftStealScanner()
    if self._softStealScanner then return end
    self._softStealScanning = true
    self:scanSoftStealAnimals()
    self._softStealScanner = RunService.Heartbeat:Connect(function()
        if not self._softStealScanning then return end
        self:scanSoftStealAnimals()
    end)
end

function CarrySystem:stopSoftStealScanner()
    self._softStealScanning = false
    if self._softStealScanner then
        self._softStealScanner:Disconnect()
        self._softStealScanner = nil
    end
end

function CarrySystem:getNearestSoftStealAnimal(radius)
    local char = LP.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
    if not root then return nil, _huge end
    local best, bestDist = nil, _huge
    local animals = self._softStealAnimals
    local rpos = root.Position
    for i = 1, #animals do
        local data = animals[i]
        if data.worldPosition then
            local dx = rpos.X - data.worldPosition.X
            local dy = rpos.Y - data.worldPosition.Y
            local dz = rpos.Z - data.worldPosition.Z
            local dist = _sqrt(dx*dx + dy*dy + dz*dz)
            if dist < bestDist then
                best = data; bestDist = dist
            end
        end
    end
    if radius and bestDist > radius then return nil, bestDist end
    return best, bestDist
end

function CarrySystem:updateMovement(dt)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    local speed = self:getActiveSpeed()
    local moveDir = hum.MoveDirection
    local moving = moveDir.Magnitude > 0.1

    local wallNormalFlat = nil
    if moving then
        if not self._rayParams then
            self._rayParams = _RayParams_new()
            self._rayParams.FilterType = Enum.RaycastFilterType.Exclude
            self._rayFilter = {}
            self._rayFilterTime = 0
        end
        local now = _tick()
        if now - self._rayFilterTime > 1 then
            self._rayFilterTime = now
            local filter = self._rayFilter
            while #filter > 0 do filter[#filter] = nil end
            filter[1] = char
            local plist = _GetPlayersCached()
            for i = 1, #plist do
                local p = plist[i]
                if p.Character then
                    filter[#filter + 1] = p.Character
                end
            end
            self._rayParams.FilterDescendantsInstances = filter
        else
            local filter = self._rayFilter
            local found = false
            for i = 1, #filter do
                if filter[i] == char then found = true; break end
            end
            if not found then
                filter[1] = char
                self._rayParams.FilterDescendantsInstances = filter
            end
        end
        local flatDir = _V3new(moveDir.X, 0, moveDir.Z).Unit
        local hit = Workspace:Raycast(hrp.Position + _V3new(0,1,0), flatDir * 2.5, self._rayParams)
        if hit and hit.Instance and hit.Instance.CanCollide then
            local nf = _V3new(hit.Normal.X, 0, hit.Normal.Z)
            if nf.Magnitude > 0.7 then wallNormalFlat = nf.Unit end
        end
    end

    local hVel = _V3new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
    local blocked = wallNormalFlat ~= nil or (moving and hVel.Magnitude < 2)

    if blocked then
        for _, model in ipairs(char:GetChildren()) do
            if model:IsA("Model") then
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                end
            end
        end
        for _, name in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
            local v = char:FindFirstChild(name)
            if v and v:IsA("ObjectValue") and v.Value and v.Value:IsA("Model") then
                for _, part in ipairs(v.Value:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                end
            end
        end
    end

    local state = hum:GetState()
    local ragdolled = state == Enum.HumanoidStateType.Physics
                   or state == Enum.HumanoidStateType.Ragdoll
                   or state == Enum.HumanoidStateType.FallingDown
    local moverBlocked = ragdolled or self._dropInProgress or self._batAimbotToggled

    if not moverBlocked then
        if not CarrySystem._lvBoost or CarrySystem._lvBoost.Parent ~= hrp then setupLV(hrp) end
        local lv = CarrySystem._lvBoost
        if lv then
            if not lv.Enabled then lv.Enabled = true end
            if moveDir.Magnitude > 0.1 then
                local flat = _V3new(moveDir.X, 0, moveDir.Z).Unit
                if wallNormalFlat then
                    local wanted = flat * speed
                    local along = wanted - wallNormalFlat * wanted:Dot(wallNormalFlat)
                    if along.Magnitude < 0.5 then
                        lv.PlaneVelocity = Vector2.zero
                    else
                        lv.PlaneVelocity = Vector2.new(along.X, along.Z)
                    end
                else
                    lv.PlaneVelocity = Vector2.new(flat.X * speed, flat.Z * speed)
                end
            else
                lv.PlaneVelocity = Vector2.zero
            end
            if blocked then
                self._blockedTime = self._blockedTime + (dt or 0.016)
            else
                self._blockedTime = 0
            end
            if self._blockedTime > 0.35 then
                if lv.MaxForce ~= self._freeForce then lv.MaxForce = self._freeForce end
            elseif lv.MaxForce ~= self._maxForce then
                lv.MaxForce = self._maxForce
            end
        end
    elseif CarrySystem._lvBoost then
        CarrySystem._lvBoost.PlaneVelocity = Vector2.zero
        if CarrySystem._lvBoost.Enabled then CarrySystem._lvBoost.Enabled = false end
    end
end

function CarrySystem:start()
    if self._heartbeatConn then return end
    self._heartbeatConn = RunService.Heartbeat:Connect(function(dt) self:updateMovement(dt) end)
    if self.softStealEnabled then self:startSoftStealScanner() end
    print("[CarrySystem] Activado")
end

function CarrySystem:stop()
    if self._heartbeatConn then
        self._heartbeatConn:Disconnect()
        self._heartbeatConn = nil
    end
    self:stopSoftStealScanner()
    destroyLV()
    self.softStealLatched = false
    print("[CarrySystem] Desactivado")
end

function CarrySystem:setNormalSpeed(v) self.normalSpeed = _clamp(v,1,500) end
function CarrySystem:setCarrySpeed(v) self.carrySpeed = _clamp(v,1,500) end
function CarrySystem:setLaggerSpeed(v) self.laggerSpeed = _clamp(v,0.1,500) end
function CarrySystem:setLaggerCarrySpeed(v) self.laggerCarrySpeed = _clamp(v,0.1,500) end
function CarrySystem:setSoftStealSpeed(v) self.softStealSpeed = _clamp(v,1,500) end
function CarrySystem:setSoftStealRadius(v) self.softStealRadius = _clamp(v,1,200) end

function CarrySystem:toggleCarryMode() self.speedToggled = not self.speedToggled end
function CarrySystem:setLaggerMode(mode)
    if mode == 0 then self.laggerMode = 0
    elseif mode == 1 then self.laggerMode = 1
    elseif mode == 2 then self.laggerMode = 2 end
end
function CarrySystem:toggleLaggerMode()
    if self.laggerMode == 0 then self.laggerMode = 1
    elseif self.laggerMode == 1 then self.laggerMode = 2
    else self.laggerMode = 0 end
end
function CarrySystem:setSoftStealEnabled(enabled)
    self.softStealEnabled = enabled
    if enabled then self:startSoftStealScanner()
    else self:stopSoftStealScanner(); self.softStealLatched = false end
end
function CarrySystem:toggleSoftSteal() self:setSoftStealEnabled(not self.softStealEnabled) end
function CarrySystem:isRunning() return self._heartbeatConn ~= nil end
function CarrySystem:getCurrentSpeed() return self:getActiveSpeed() end

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

local _lastThemeUpdate = 0
local _lastThemeColor = nil

function applyColorTheme(themeName)
    local color = COLOR_THEMES[themeName]
    if not color then return end
    currentColorTheme = themeName
    selectedColor = color
    updateAllUIThemeColors(color)
    saveAllSettings()
end

function updateAllUIThemeColors(color)
    local now = _tick()
    if color == _lastThemeColor and now - _lastThemeUpdate < 0.1 then return end
    _lastThemeUpdate = now
    _lastThemeColor = color

    if speedLabel then speedLabel.TextColor3 = Color3.fromRGB(255,255,255) end
    if progressFill then
        progressFill.BackgroundColor3 = Color3.fromRGB(200,200,210)
        local grad = progressFill:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,255,255)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(200,200,210)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(150,150,160)),
            })
        end
    end
    if pbFrame then
        local border = pbFrame:FindFirstChildOfClass("UIStroke")
        if border then border.Color = color end
        local fpsNeon = pbFrame:FindFirstChild("FPSNeon")
        if fpsNeon then fpsNeon.TextColor3 = Color3.fromRGB(255,255,255) end
    end
    local function searchAndUpdateText(parent)
        for _, child in ipairs(parent:GetDescendants()) do
            if child:IsA("TextLabel") then
                if child.Text:find("discord.gg") or child.Text:find("Spd:") or child.Name == "DiscordText" or
                   child.Name == "BloodHoundsSpeedIndicator" then
                    child.TextColor3 = Color3.fromRGB(255,255,255)
                end
            end
            if child:IsA("UIStroke") then
                if child.Color == Color3.fromRGB(180, 180, 190) then child.Color = color end
            end
        end
    end
    if gui then searchAndUpdateText(gui) end
    if tpBatFloatingButton then
        paintFloatingBtn(tpBatFloatingButton:FindFirstChild("Frame"), batDesyncTpEnabled)
    end
    if batBypassFloatingButton then
        paintFloatingBtn(batBypassFloatingButton:FindFirstChild("Frame"), autoBatBypassEnabled)
    end
    for _, tab in ipairs(tabButtons or {}) do
        if tab.TextColor3 == Color3.fromRGB(180, 180, 190) then tab.TextColor3 = color end
    end
    for _, hl in pairs(espHighlightCache) do
        if hl then hl.FillColor = Color3.fromRGB(255,255,255); hl.OutlineColor = Color3.fromRGB(255,255,255) end
    end
    for _, line in pairs(espTrackerCache) do
        if line then
            pcall(function() line.BackgroundColor3 = getThemeColor() end)
        end
    end
    for _, box in pairs(espBoxCache) do
        if box then
            pcall(function()
                box.BackgroundColor3 = getThemeColor()
                local stroke = box:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color = getThemeColor() end
            end)
        end
    end
    if main then
        local titleFrame = main:FindFirstChild("Frame")
        if titleFrame then
            for _, child in ipairs(titleFrame:GetDescendants()) do
                if child:IsA("UIStroke") and child.Color == Color3.fromRGB(180, 180, 190) then
                    child.Color = color
                end
            end
        end
    end
    if colorSelectorLabel then
        colorSelectorLabel.Text = currentColorTheme
        colorSelectorLabel.TextColor3 = color
    end
    local strikeTitle = main and main:FindFirstChild("StrikeTitle", true)
    if strikeTitle and strikeTitle:IsA("ImageLabel") then
        strikeTitle.ImageColor3 = Color3.fromRGB(255,255,255)
    end
    if miniBtn then
        miniBtn.TextColor3 = color
        local grad = miniBtn:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, color),
                ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, color),
            })
        end
    end

    local pGui = LP:FindFirstChild("PlayerGui")
    if pGui then
        local bb = pGui:FindFirstChild("RagCountdownBillboard")
        if bb then
            local lbl = bb:FindFirstChildOfClass("TextLabel")
            if lbl then
                lbl.TextColor3 = color
                local grad = lbl:FindFirstChildOfClass("UIGradient")
                if grad then
                    grad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, color),
                        ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1)),
                        ColorSequenceKeypoint.new(1, color),
                    })
                end
            end
        end
    end

    if _G._StrikeAntiTpEsp and _G._StrikeAntiTpEsp.SetColor then
        pcall(_G._StrikeAntiTpEsp.SetColor, selectedColor)
    end

    if MobilePanel then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        if container then
            local btnContainer = container:FindFirstChild("ButtonsContainer")
            if btnContainer then
                for _, btn in ipairs(btnContainer:GetChildren()) do
                    if btn:IsA("TextButton") and btn:FindFirstChild("BtnGrad") then
                        paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true)
                    end
                end
            end
        end
    end
end

speedMode = false
antiRagdollMode = "off"
infiniteJumpEnabled = true
antiDieEnabled = false
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
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
uiScaleValue = 78
espEnabled = false
espBoxEnabled = false
espTrackerEnabled = false
ragdollCountdownEnabled = true
antiTpEspEnabled = false
antiFlingEnabled = false

savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil
tpBatFloatingPos = nil
batBypassFloatingPos = nil
instaResetFloatingPos = nil
instaResetFloatingButton = nil

neonWeatherEnabled = false
skyTheme = "Off"
skySelectorLabel = nil
_originalLighting = nil
setNeonWeatherVisual = nil

originalTryardAnims = nil
tryardHeartbeatConn = nil

autoBatBypassEnabled = false
autoBatBypassSwingEnabled = true
autoBatBypassHitCooldown = false
BAT_BYPASS_SPEED = 55
BAT_BYPASS_DIST = 1.0
BAT_BYPASS_HEIGHT = 1.5
BAT_BYPASS_V_OFF = 0.0
BAT_BYPASS_SWING_CD = 0.08
_batBypassConn = nil

useCarrySystem = false
lastMoveDir = _V3zero

local CoreGui = game:GetService("CoreGui")

local InfiniteJump = {
    enabled = true,
    jumpPower = 55,
    minVelocity = 30,
    jumpConn = nil,
    heartbeatConn = nil,
}

local function applyJump(root)
    if not root then return end
    pcall(function()
        root.Velocity = _V3new(root.Velocity.X, InfiniteJump.jumpPower, root.Velocity.Z)
    end)
end

local function onJumpRequest()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then applyJump(root) end
end

local function onHeartbeat()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
    if jumpHeld and root.Velocity.Y < InfiniteJump.minVelocity then
        applyJump(root)
    end
end

local function connectEvents()
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect() end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect() end
    InfiniteJump.jumpConn = UIS.JumpRequest:Connect(onJumpRequest)
    InfiniteJump.heartbeatConn = RunService.Heartbeat:Connect(onHeartbeat)
end

function InfiniteJump.start()
    -- Keep the enabled state and ensure the event connections are actually running.
    -- This also fixes the initial ON state after loading the script.
    InfiniteJump.enabled = true
    if not InfiniteJump.jumpConn or not InfiniteJump.heartbeatConn then
        connectEvents()
    end
    print("[InfiniteJump] Activado")
end

function InfiniteJump.stop()
    InfiniteJump.enabled = false
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect(); InfiniteJump.jumpConn = nil end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect(); InfiniteJump.heartbeatConn = nil end
    print("[InfiniteJump] Desactivado")
end

function InfiniteJump.setJumpPower(power)
    power = tonumber(power) or 55
    InfiniteJump.jumpPower = _clamp(power, 10, 200)
end

function InfiniteJump.isRunning() return InfiniteJump.enabled == true end

if InfiniteJump.enabled then InfiniteJump.start() end

local function getCharParts()
    local char = LP.Character
    if not char then return nil, nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return nil, nil end
    return hum, root
end

local function claimOwnership(root)
    pcall(function() root:SetNetworkOwner(LP) end)
end

function getActiveMoveSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED
    elseif laggerToggled then return LAGGER_SPEED
    elseif speedMode then return CS
    else return NS end
end

local _velChecked = {}
local _hookedVelParts = {}

local function _setupVelChecked(char)
    _velChecked = {}
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if hrp then _velChecked[hrp] = true end
    return hrp
end

local _hookVelSupported = nil
local function _hookVelHRP(hrp)
    if not hrp or _hookedVelParts[hrp] then return end
    if _hookVelSupported == false then return end
    if _hookVelSupported == nil then
        _hookVelSupported = (type(getrawmetatable) == "function")
            and (type(setreadonly) == "function")
            and (type(newcclosure) == "function")
            and (type(checkcaller) == "function")
    end
    if not _hookVelSupported then return end
    _hookedVelParts[hrp] = true
    local ok = pcall(function()
        local mt = getrawmetatable(hrp)
        if not mt then return end
        setreadonly(mt, false)
        local originalVelIndex = rawget(mt, "__index")
        mt.__index = newcclosure(function(self, key)
            if not checkcaller() and _velChecked[self]
               and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                local real
                if type(originalVelIndex) == "function" then
                    real = originalVelIndex(self, key)
                elseif type(originalVelIndex) == "table" then
                    real = originalVelIndex[key]
                end
                if real and real.Magnitude > 20 then return real.Unit * 20 end
                return real
            end
            if type(originalVelIndex) == "function" then
                return originalVelIndex(self, key)
            elseif type(originalVelIndex) == "table" then
                return originalVelIndex[key]
            end
        end)
        setreadonly(mt, true)
    end)
    if not ok then _hookVelSupported = false end
end

if LP.Character then
    local _hrp0 = _setupVelChecked(LP.Character)
    _hookVelHRP(_hrp0)
end

local function _isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand
        or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
end

local function _applyVelocitySpeed(dir, speed, hrp)
    if not hrp or not hrp.Parent then return end
    if autoBatBypassEnabled or batDesyncTpEnabled or autoBatEnabled then return end
    if dir and dir.Magnitude > 0.05 then
        pcall(function()
            if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP) end
        end)
        local unit = dir.Unit
        local vy = hrp.AssemblyLinearVelocity.Y
        hrp.AssemblyLinearVelocity = _V3new(unit.X * speed, vy, unit.Z * speed)
    else
        local vy = hrp.AssemblyLinearVelocity.Y
        hrp.AssemblyLinearVelocity = _V3new(0, vy, 0)
    end
end

function getAutoPathSpeed()
    if laggerCarryToggled or laggerToggled then return LAGGER_SPEED end
    return NS
end

DEFAULT_KB = {
    DropBrainrot = {kb = Enum.KeyCode.X, gp = nil},
    AutoLeft     = {kb = Enum.KeyCode.Z, gp = nil},
    AutoRight    = {kb = Enum.KeyCode.C, gp = nil},
    AutoBat      = {kb = Enum.KeyCode.E, gp = nil},
    TPFloor      = {kb = Enum.KeyCode.F, gp = nil},
    GuiHide      = {kb = Enum.KeyCode.LeftControl, gp = nil},
    CarryToggle  = {kb = Enum.KeyCode.Q, gp = nil},
    LaggerMode   = {kb = Enum.KeyCode.R, gp = nil},
    TPBat        = {kb = Enum.KeyCode.V, gp = nil},
    BatBypass        = {kb = Enum.KeyCode.N, gp = nil},
    InstaReset   = {kb = Enum.KeyCode.H, gp = nil},
}

KB = {
    DropBrainrot = {kb = DEFAULT_KB.DropBrainrot.kb, gp = DEFAULT_KB.DropBrainrot.gp},
    AutoLeft     = {kb = DEFAULT_KB.AutoLeft.kb, gp = DEFAULT_KB.AutoLeft.gp},
    AutoRight    = {kb = DEFAULT_KB.AutoRight.kb, gp = DEFAULT_KB.AutoRight.gp},
    AutoBat      = {kb = DEFAULT_KB.AutoBat.kb, gp = DEFAULT_KB.AutoBat.gp},
    TPFloor      = {kb = DEFAULT_KB.TPFloor.kb, gp = DEFAULT_KB.TPFloor.gp},
    GuiHide      = {kb = DEFAULT_KB.GuiHide.kb, gp = DEFAULT_KB.GuiHide.gp},
    CarryToggle  = {kb = DEFAULT_KB.CarryToggle.kb, gp = DEFAULT_KB.CarryToggle.gp},
    LaggerMode   = {kb = DEFAULT_KB.LaggerMode.kb, gp = DEFAULT_KB.LaggerMode.gp},
    TPBat        = {kb = DEFAULT_KB.TPBat.kb, gp = DEFAULT_KB.TPBat.gp},
    BatBypass        = {kb = DEFAULT_KB.BatBypass.kb, gp = DEFAULT_KB.BatBypass.gp},
    InstaReset   = {kb = DEFAULT_KB.InstaReset.kb, gp = DEFAULT_KB.InstaReset.gp},
}

_isResetting = false
_lastSavedJSON = nil
_isLoading = false

CONFIG = {
    AUTO_STEAL_ENABLED = false,
    STEAL_RANGE = 61,
}

-- Espera a que cargue el mapa, pero con limite de tiempo: si "Plots"
-- no aparece (juego equivocado o entraste antes de tiempo) NO se queda
-- colgado para siempre; sigue y arma el menu igual.
local plots = workspace:WaitForChild("Plots", 30) or workspace:FindFirstChild("Plots")
local stealConnection = nil

local Steal = {
    AutoStealEnabled = false,
    StealRadius = CONFIG.STEAL_RANGE,
    StealDuration = 1.3,
    StealDelay = 0.25,
    Data = {}
}

local isStealing = false
local autoGrabSetDelayRadius = 9
local autoGrabStopTime = 0.96
local autoGrabStopEnabled = true

local _plotsCache = nil
local _plotsCacheTime = 0
local function getPlotsRoot()
    local now = _tick()
    if _plotsCache and now - _plotsCacheTime < 2 and _plotsCache.Parent then
        return _plotsCache
    end
    _plotsCache = workspace:FindFirstChild("Plots")
    _plotsCacheTime = now
    return _plotsCache
end

local function isMyPlotByName(plotName)
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return false end
    local plot = plotsRoot:FindFirstChild(plotName)
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
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return nil, nil end
    local nearestPrompt, nearestDist, nearestName = nil, _huge, nil
    local rpos = root.Position
    for _, plot in ipairs(plotsRoot:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local sp = spawn.Position
                    local dx = sp.X - rpos.X
                    local dy = sp.Y - rpos.Y
                    local dz = sp.Z - rpos.Z
                    local dist = _sqrt(dx*dx + dy*dy + dz*dz)
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

    if math.random(30) == 1 then
        for p in pairs(Steal.Data) do
            if not p.Parent then Steal.Data[p] = nil end
        end
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

    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "0%" end

    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end

        local startTime = _tick()
        local duration = Steal.StealDuration
        local promptFired = false

        if autoGrabStopEnabled then
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = _tick() - startTime
                if elapsed >= autoGrabStopTime then break end
                local progress = _clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = _floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then
                    break
                end
                task.wait()
            end

            local stopProgress = _clamp(autoGrabStopTime / duration, 0, 1)
            if progressFill then progressFill.Size = UDim2.new(stopProgress, 0, 1, 0) end
            if progressPct then progressPct.Text = _floor(stopProgress * 100) .. "%" end

            local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
            local phase2Start = _tick()

            while isStealing and Steal.AutoStealEnabled do
                if _tick() - phase2Start >= phase2Timeout then
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
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
                    data.ready = true
                    return
                end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                    if dist <= autoGrabSetDelayRadius then
                        break
                    elseif dist > Steal.StealRadius then
                        isStealing = false
                        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                        if progressPct then progressPct.Text = "0%" end
                        data.ready = true
                        return
                    end
                end
                task.wait()
            end

            if isStealing and Steal.AutoStealEnabled then
                local fillStart = _tick()
                local fillDuration = math.max(duration - autoGrabStopTime, 0.05)
                while true do
                    local fp = _clamp((_tick() - fillStart) / fillDuration, 0, 1)
                    local totalProgress = stopProgress + fp * (1 - stopProgress)
                    if progressFill then progressFill.Size = UDim2.new(totalProgress, 0, 1, 0) end
                    if progressPct then progressPct.Text = _floor(totalProgress * 100) .. "%" end
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
                local elapsed = _tick() - startTime
                local progress = _clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = _floor(progress * 100) .. "%" end
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
        pcall(function() stealConnection:Disconnect() end)
        stealConnection = nil
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
    if stealConnection then
        stealConnection:Disconnect()
        stealConnection = nil
    end
    isStealing = false
    Steal.AutoStealEnabled = false
    CONFIG.AUTO_STEAL_ENABLED = false
    if progressFill then
        TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
    end
    if progressPct then progressPct.Text = "0%" end
end

medusaDebounce = false
medusaLastUsed = 0
dropActive = false
lastDropTime = 0
lastMoveDir = _V3new(0,0,0)
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
batBypassFloatingButton = nil

enemySpeedConn = nil
movementLoop = nil
steppedConn = nil
alConn = nil
arConn = nil
infJumpConn = nil
stretchConn = nil
stretchFovConn = nil
antiLagDescConn = nil
medusaResetConns = {}
dropConnections = {}
enemySpeedLabels = {}
Conns = {autoSteal = nil, batCounter = nil, anchor = {}, progress = nil, autoLeft = nil, autoRight = nil}
keyButtonRefs = {}
progressFill = nil
progressPct = nil
progressRadLbl = nil
pbFrame = nil
speedLabel = nil
modeValLbl = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, uiScaleBox = nil, nil, nil, nil, nil, nil, nil
modeSelectBtn, dropModeBtnRef = nil, nil
setJumpToggleState = nil
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual = nil, nil, nil, nil, nil
setAntiRagVisual, setJumpVisual, setAntiLagVisual, setLockUIVisual, setInstaGrab = nil, nil, nil, nil, nil
setAntiDieVisual = nil
setAntiFlingVisual = nil
setAntiRagdollVisual = nil
setEditModeVisual = nil
setESPVIsual = nil
setESPBoxVisual = nil
setESPTrackerVisual = nil
setRagdollCountdownVisual = nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2 = nil, nil, nil, nil, nil, nil, nil, nil
autoBatBypassSetVisual = nil
miniBtn, main, gui = nil, nil, nil
MobilePanel = nil
instaResetFloatingButton = nil
showGui = nil
hideGui = nil
mainUIScale = nil
_menuHomePos = nil  -- posicion guardada del menu principal
animSelectorLabel = nil
pbScale = nil
tabButtons = nil
colorSelectorLabel = nil

-- STRIKE INTRO
local INTRO_SONG_ORDER = {
    "Off", "Song 1", "Song 2", "Song 3", "Song 4", "Song 5", "Song 6", "Song 7",
    "Song 8", "Song 9", "Song 10", "Song 11", "Song 12", "Song 13", "Song 14", "Song 15", "Song 16"
}
local INTRO_SONGS = {
    ["Song 1"]  = {url = "https://files.catbox.moe/rcgr9f.mp3", file = "StrikeIntroSong_rcgr9f.mp3"},
    ["Song 2"]  = {url = "https://files.catbox.moe/18dpz9.mp3", file = "StrikeIntroSong_18dpz9.mp3"},
    ["Song 3"]  = {url = "https://files.catbox.moe/2obj4i.mp3", file = "StrikeIntroSong_2obj4i.mp3"},
    ["Song 4"]  = {url = "https://files.catbox.moe/dqcahr.mp3", file = "StrikeIntroSong_dqcahr.mp3"},
    ["Song 5"]  = {url = "https://files.catbox.moe/pza10u.mp3", file = "StrikeIntroSong_pza10u.mp3"},
    ["Song 6"]  = {url = "https://files.catbox.moe/ul7tt5.mp3", file = "StrikeIntroSong_ul7tt5.mp3"},
    ["Song 7"]  = {url = "https://files.catbox.moe/fhwgff.mp3", file = "StrikeIntroSong_fhwgff.mp3"},
    ["Song 8"]  = {url = "https://files.catbox.moe/kq5dc7.mp3", file = "StrikeIntroSong_kq5dc7.mp3"},
    ["Song 9"]  = {url = "https://files.catbox.moe/9tcnu0.mp3", file = "StrikeIntroSong_9tcnu0.mp3"},
    ["Song 10"] = {url = "https://files.catbox.moe/k3loa6.mp3", file = "StrikeIntroSong_k3loa6.mp3"},
    ["Song 11"] = {url = "https://files.catbox.moe/fri8xn.mp3", file = "StrikeIntroSong_fri8xn.mp3"},
    ["Song 12"] = {url = "https://files.catbox.moe/d3krby.mp3", file = "StrikeIntroSong_d3krby.mp3"},
    ["Song 13"] = {url = "https://files.catbox.moe/pvx0up.mp3", file = "StrikeIntroSong_pvx0up.mp3"},
}
local INTRO_SONG = "Song 2"
local SKIP_INTRO = false
local introSongSelectorLabel = nil
local skipIntroSetVisual = nil
local strikeIntroGui = nil
local strikeIntroSound = nil
local strikeIntroFinished = false

carrySystemToggleSetter = nil
carrySysNormalBox = nil
carrySysCarryBox = nil
carrySysLaggerBox = nil
carrySysLaggerCarryBox = nil
carrySysSoftStealSpeedBox = nil
carrySysSoftStealRadiusBox = nil

GAMEPAD_KEYS = {
    [Enum.KeyCode.ButtonA] = true, [Enum.KeyCode.ButtonB] = true,
    [Enum.KeyCode.ButtonX] = true, [Enum.KeyCode.ButtonY] = true,
    [Enum.KeyCode.ButtonL1] = true, [Enum.KeyCode.ButtonR1] = true,
    [Enum.KeyCode.ButtonL2] = true, [Enum.KeyCode.ButtonR2] = true,
    [Enum.KeyCode.ButtonL3] = true, [Enum.KeyCode.ButtonR3] = true,
    [Enum.KeyCode.ButtonStart] = true, [Enum.KeyCode.ButtonSelect] = true,
    [Enum.KeyCode.DPadUp] = true, [Enum.KeyCode.DPadDown] = true,
    [Enum.KeyCode.DPadLeft] = true, [Enum.KeyCode.DPadRight] = true,
}

MOVE_KEYS = {
    [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
}

BAT_COUNTER_SLAP_LIST = {
    "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
    "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
    "Nuclear Slap", "Galaxy Slap", "Glitched Slap"
}

AP = {
    L1 = _V3new(-476.48, -6.28, 92.73),
    L2 = _V3new(-483.12, -4.95, 94.80),
    L_FACE = _V3new(-482.25, -4.96, 92.09),
    R1 = _V3new(-476.16, -6.52, 25.62),
    R2 = _V3new(-483.06, -5.03, 25.48),
    R_FACE = _V3new(-482.06, -6.93, 35.47),
}

function isGamepadInput(inp)
    return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
end

function isBindableInput(inp)
    if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
    if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
    return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
end

function kbMatch(entry, kc)
    return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
end

function resetProgressBar()
    if progressPct then progressPct.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
end

local function doTpDown()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        root.CFrame = _CFnew(root.Position.X, -7, root.Position.Z) * CFrame.Angles(0, select(2, root.CFrame:ToEulerAnglesYXZ()), 0)
        root.Velocity = _V3zero
    end)
end

local AntiRagdollV1 = {}
AntiRagdollV1.__index = AntiRagdollV1

local BOOST_SPEED = 400
local AR_DEFAULT_SPEED = 16

local stateV1 = {
    active = false,
    isBoosting = false,
    cachedChar = nil,
    ragdollConnections = {},
}

local function disconnectAllV1()
    for _, conn in ipairs(stateV1.ragdollConnections) do
        pcall(function() conn:Disconnect() end)
    end
    stateV1.ragdollConnections = {}
end

local function cacheCharacterV1()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    stateV1.cachedChar = { character = char, humanoid = hum, root = root }
    return true
end

local function isRagdolledV1()
    if not stateV1.cachedChar or not stateV1.cachedChar.humanoid then return false end
    local hum = stateV1.cachedChar.humanoid
    local st = hum:GetState()
    local ragdollStates = {
        [Enum.HumanoidStateType.Physics] = true,
        [Enum.HumanoidStateType.Ragdoll] = true,
        [Enum.HumanoidStateType.FallingDown] = true,
    }
    return ragdollStates[st] or false
end

local function forceExitRagdollV1()
    if not stateV1.cachedChar or not stateV1.cachedChar.humanoid or not stateV1.cachedChar.root then return end
    local hum = stateV1.cachedChar.humanoid
    local root = stateV1.cachedChar.root
    pcall(function()
        LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
    end)
    for _, descendant in ipairs(stateV1.cachedChar.character:GetDescendants()) do
        if descendant:IsA("BallSocketConstraint") or
           (descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")) then
            descendant:Destroy()
        end
    end
    if not stateV1.isBoosting then
        stateV1.isBoosting = true
        hum.WalkSpeed = BOOST_SPEED
    end
    if hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
    root.Anchored = false
end

local function heartbeatLoopV1()
    while stateV1.active do
        task.wait()
        if isRagdolledV1() then
            forceExitRagdollV1()
        elseif stateV1.isBoosting and not isRagdolledV1() then
            stateV1.isBoosting = false
            if stateV1.cachedChar and stateV1.cachedChar.humanoid then
                stateV1.cachedChar.humanoid.WalkSpeed = AR_DEFAULT_SPEED
            end
        end
    end
end

function AntiRagdollV1.start()
    if stateV1.active then return end
    AntiRagdollV1.stop()
    if not cacheCharacterV1() then
        warn("[AntiRagdollV1] No se pudo cachear el personaje")
        return
    end
    stateV1.active = true
    stateV1.isBoosting = false
    local camConn = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        if cam and stateV1.cachedChar and stateV1.cachedChar.humanoid then
            cam.CameraSubject = stateV1.cachedChar.humanoid
        end
    end)
    table.insert(stateV1.ragdollConnections, camConn)
    local respawnConn = LP.CharacterAdded:Connect(function()
        stateV1.isBoosting = false
        task.wait(0.5)
        cacheCharacterV1()
    end)
    table.insert(stateV1.ragdollConnections, respawnConn)
    task.spawn(heartbeatLoopV1)
    print("[AntiRagdollV1] Activado")
end

function AntiRagdollV1.stop()
    stateV1.active = false
    if stateV1.isBoosting and stateV1.cachedChar and stateV1.cachedChar.humanoid then
        stateV1.cachedChar.humanoid.WalkSpeed = AR_DEFAULT_SPEED
    end
    stateV1.isBoosting = false
    disconnectAllV1()
    stateV1.cachedChar = nil
    print("[AntiRagdollV1] Desactivado")
end

function AntiRagdollV1.isRunning() return stateV1.active end

local AntiRagdollV2 = {
    Enabled = false,
    Connection = nil,
    ResetCooldown = 0,
}

local function startAntiRagdollV2()
    if AntiRagdollV2.Connection then return end
    AntiRagdollV2.Enabled = true
    AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
        if not AntiRagdollV2.Enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
        local state = hum:GetState()
        local now = _tick()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                pcall(function()
                    if hum:GetState() == Enum.HumanoidStateType.GettingUp then return end
                    if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    root.Velocity = _V3zero
                    root.RotVelocity = _V3zero
                    root.AssemblyLinearVelocity = _V3zero
                    root.AssemblyAngularVelocity = _V3zero
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

local function stopAntiRagdollV2()
    AntiRagdollV2.Enabled = false
    if AntiRagdollV2.Connection then
        AntiRagdollV2.Connection:Disconnect()
        AntiRagdollV2.Connection = nil
    end
    AntiRagdollV2.ResetCooldown = 0
end

function setAntiRagdollMode(mode)
    if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end

    if mode == "v1" or mode == "v2" then
        antiRagdollMode = mode
        if mode == "v1" then
            AntiRagdollV1.start()
        else
            startAntiRagdollV2()
        end
    else
        antiRagdollMode = "off"
    end

    if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollMode ~= "off") end
    if updateAntiRagdollModeUI then updateAntiRagdollModeUI(antiRagdollMode) end
    saveAllSettings()
end

local AntiDieModule = {
    enabled = false,
    healthConn = nil,
    diedConn = nil,
    charConn = nil,
    humanoid = nil,
    _reviving = false,
}

local function disconnectHumanoid()
    if AntiDieModule.healthConn then AntiDieModule.healthConn:Disconnect(); AntiDieModule.healthConn = nil end
    if AntiDieModule.diedConn then AntiDieModule.diedConn:Disconnect(); AntiDieModule.diedConn = nil end
    AntiDieModule.humanoid = nil
end

local function activateOnCharacter(char)
    if not AntiDieModule.enabled then return end
    char = char or LP.Character or LP.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
    if not hum or not AntiDieModule.enabled then return end
    disconnectHumanoid()
    AntiDieModule.humanoid = hum

    pcall(function()
        hum.BreakJointsOnDeath = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Dying, false)
    end)

    AntiDieModule.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not AntiDieModule.enabled or not hum.Parent then return end
        if hum.Health <= 0 and not AntiDieModule._reviving then
            AntiDieModule._reviving = true
            pcall(function()
                hum.Health = hum.MaxHealth
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                if hum.Health > 0 then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
            task.delay(0.2, function() AntiDieModule._reviving = false end)
        end
    end)

    AntiDieModule.diedConn = hum.Died:Connect(function()
        if not AntiDieModule.enabled or not char.Parent then return end
        if AntiDieModule._reviving then return end
        AntiDieModule._reviving = true
        task.defer(function()
            if not AntiDieModule.enabled or not char.Parent or not hum.Parent then
                AntiDieModule._reviving = false
                return
            end
            pcall(function()
                hum.Health = hum.MaxHealth
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
            AntiDieModule._reviving = false
        end)
    end)
end

function AntiDieModule.start()
    AntiDieModule.enabled = true
    if AntiDieModule.charConn then AntiDieModule.charConn:Disconnect() end
    AntiDieModule.charConn = LP.CharacterAdded:Connect(function(char)
        if AntiDieModule.enabled then task.defer(function() activateOnCharacter(char) end) end
    end)
    task.defer(function() activateOnCharacter(LP.Character) end)
    print("[AntiDie] Activado (interno)")
end

function AntiDieModule.stop()
    AntiDieModule.enabled = false
    if AntiDieModule.charConn then AntiDieModule.charConn:Disconnect(); AntiDieModule.charConn = nil end
    local hum = AntiDieModule.humanoid
    disconnectHumanoid()
    if hum and hum.Parent then
        pcall(function()
            hum.BreakJointsOnDeath = true
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end)
    end
    print("[AntiDie] Desactivado (interno)")
end

_G.AntiDie = AntiDieModule

-- ============================================================
-- ANTI FLING — sistema basado en el Anti Fling de Ace
-- ============================================================
local AntiFlingModule = {
    enabled = false,
    connection = nil,
    threshold = 80,
    spinThreshold = 40,
}

local function antiFlingHasVelocityConstraint(root)
    if not root then return false end

    for _, child in ipairs(root:GetChildren()) do
        local name = child.Name or ""
        local ownedName =
            name:match("^Ace") or name:match("^Candy") or
            name:match("^RaVe") or name:match("^VlonE") or
            name:match("^Vilon") or name:match("^Kawatan") or
            name:match("^InfJump")

        if ownedName then
            local ok, result = pcall(function()
                if child:IsA("LinearVelocity") then
                    if not child.Enabled then return 0 end
                    if child.VelocityConstraintMode == Enum.VelocityConstraintMode.Vector then
                        return child.VectorVelocity.Magnitude
                    elseif child.VelocityConstraintMode == Enum.VelocityConstraintMode.Line then
                        return math.abs(child.LineVelocity)
                    else
                        return child.PlaneVelocity.Magnitude
                    end
                elseif child:IsA("BodyVelocity") then
                    return child.Velocity.Magnitude
                elseif child:IsA("BodyPosition") then
                    return child.Position.Magnitude
                elseif child:IsA("BodyGyro") or child:IsA("AlignPosition")
                    or child:IsA("AlignOrientation") or child:IsA("AngularVelocity")
                    or child:IsA("VectorForce") then
                    return 1
                end
                return 0
            end)

            if ok and (tonumber(result) or 0) > 80 then
                return true
            end
        end
    end

    return false
end

function AntiFlingModule.start()
    AntiFlingModule.enabled = true

    if AntiFlingModule.connection then
        AntiFlingModule.connection:Disconnect()
        AntiFlingModule.connection = nil
    end

    AntiFlingModule.connection = RunService.Heartbeat:Connect(function()
        if not AntiFlingModule.enabled then return end

        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and ((hum.Health <= 0) or hum.SeatPart) then return end
        if antiFlingHasVelocityConstraint(root) then return end

        local velocity = root.AssemblyLinearVelocity
        local horizontal = Vector3.new(velocity.X, 0, velocity.Z).Magnitude

        if horizontal > AntiFlingModule.threshold then
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
                root.AssemblyAngularVelocity = Vector3.zero
            end)
            return
        end

        if root.AssemblyAngularVelocity.Magnitude > AntiFlingModule.spinThreshold then
            pcall(function()
                root.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end)
end

function AntiFlingModule.stop()
    AntiFlingModule.enabled = false
    if AntiFlingModule.connection then
        AntiFlingModule.connection:Disconnect()
        AntiFlingModule.connection = nil
    end
end

function AntiFlingModule.isRunning()
    return AntiFlingModule.enabled == true
end

_G._StrikeAntiFling = AntiFlingModule
_G._AceAntiFling = {
    SetEnabled = function(on)
        if on then AntiFlingModule.start() else AntiFlingModule.stop() end
    end,
    IsEnabled = function()
        return AntiFlingModule.isRunning()
    end,
    SetThreshold = function(v)
        AntiFlingModule.threshold = tonumber(v) or AntiFlingModule.threshold
    end,
    SetSpinThreshold = function(v)
        AntiFlingModule.spinThreshold = tonumber(v) or AntiFlingModule.spinThreshold
    end,
    Destroy = function()
        AntiFlingModule.stop()
    end,
}

do
    local _ragCountdownRunning = false
    local function _getRagBillboard()
        local char = LP.Character
        if not char then return nil, nil end
        local head = char:FindFirstChild("Head")
        if not head then return nil, nil end
        local pGui = LP.PlayerGui
        local existing = pGui:FindFirstChild("RagCountdownBillboard")
        if existing then existing:Destroy() end
        local bb = Instance.new("BillboardGui")
        bb.Name = "RagCountdownBillboard"
        bb.Size = UDim2.new(0, 84, 0, 42)
        bb.StudsOffset = _V3new(0, 4.5, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = head
        bb.Parent = pGui
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.AnchorPoint = Vector2.new(0.5, 0.5)
        lbl.Position = UDim2.new(0.5, 0, 0.5, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextScaled = true
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.TextStrokeTransparency = 0
        lbl.Text = ""
        lbl.Parent = bb
        local grad = Instance.new("UIGradient", lbl)
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
        })
        grad.Rotation = 45
        grad.Offset = Vector2.new(0,0)
        return bb, lbl
    end

    local function _ragPunch(lbl, text)
        if not (lbl and lbl.Parent) then return end
        lbl.Text = text
    end

    local function _startRagCountdown()
        if not ragdollCountdownEnabled then return end
        if _ragCountdownRunning then return end
        _ragCountdownRunning = true
        task.spawn(function()
            local bb, lbl = _getRagBillboard()
            if not bb then _ragCountdownRunning = false; return end
            local timeLeft = 2.5
            local step = 0.1
            while timeLeft > 0 and bb.Parent do
                _ragPunch(lbl, string.format("%.1f", timeLeft))
                task.wait(step)
                timeLeft = timeLeft - step
            end
            if bb and bb.Parent then
                _ragPunch(lbl, "READY!")
                task.wait(0.5)
                if bb and bb.Parent then bb:Destroy() end
            end
            _ragCountdownRunning = false
        end)
    end

    local _wasRagdolled = false
    RunService.Heartbeat:Connect(function()
        local char = LP.Character
        if not char then _wasRagdolled = false; return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then _wasRagdolled = false; return end
        local st = hum:GetState()
        local inRag = st == Enum.HumanoidStateType.Physics
                   or st == Enum.HumanoidStateType.Ragdoll
                   or st == Enum.HumanoidStateType.FallingDown
        if inRag and not _wasRagdolled then
            _wasRagdolled = true
            _startRagCountdown()
        elseif not inRag then
            _wasRagdolled = false
        end
    end)
end

local espHighlightCache = {}
local espBoxCache = {}
local espTrackerCache = {}
local espNameCache = {}
local espConn = nil
local _espLastRun = 0
local _espGui = nil
local _espTrackerGui = nil

local function destroyESPObject(obj)
    if obj then
        pcall(function() obj:Destroy() end)
    end
end

local function clearESP()
    for plr in pairs(espHighlightCache) do
        destroyESPObject(espHighlightCache[plr])
    end
    for plr in pairs(espBoxCache) do
        destroyESPObject(espBoxCache[plr])
    end
    for plr in pairs(espTrackerCache) do
        destroyESPObject(espTrackerCache[plr])
    end
    espHighlightCache = {}
    espBoxCache = {}
    espTrackerCache = {}
    espNameCache = {}
end

local function getESPGui()
    if _espGui and _espGui.Parent then
        return _espGui
    end
    local pg = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
    if not pg then return nil end
    local old = pg:FindFirstChild("BloodHoundsESP")
    if old then old:Destroy() end
    local oldTracker = pg:FindFirstChild("BloodHoundsESPTracker")
    if oldTracker then oldTracker:Destroy() end

    _espGui = Instance.new("ScreenGui")
    _espGui.Name = "BloodHoundsESP"
    _espGui.ResetOnSpawn = false
    _espGui.IgnoreGuiInset = true
    _espGui.DisplayOrder = -1000
    _espGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    _espGui.Parent = pg

    _espTrackerGui = Instance.new("ScreenGui")
    _espTrackerGui.Name = "BloodHoundsESPTracker"
    _espTrackerGui.ResetOnSpawn = false
    _espTrackerGui.IgnoreGuiInset = true
    _espTrackerGui.DisplayOrder = -1100
    _espTrackerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    _espTrackerGui.Parent = pg
    return _espGui
end

local function makeESPBox(player)
    local gui = getESPGui()
    if not gui then return nil end
    local box = Instance.new("Frame")
    box.Name = "ESP_BOX_" .. player.Name
    box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    -- Estilo visual como la imagen 1: caja blanca suave con relleno translúcido.
    box.BackgroundTransparency = 0.78
    box.BorderSizePixel = 0
    box.Visible = false
    box.ZIndex = 9999
    box.Parent = gui

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1.6
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = box
    return box
end

local function makeESPName(player)
    local gui = getESPGui()
    if not gui then return nil end
    local label = Instance.new("TextLabel")
    label.Name = "ESP_NAME_" .. player.Name
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.35
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Bottom
    label.Text = player.DisplayName or player.Name
    label.Visible = false
    label.ZIndex = 10000
    label.Parent = gui
    return label
end

local function makeESPTracker(player)
    local gui = getESPGui()
    if not gui or not _espTrackerGui then return nil end
    local line = Instance.new("Frame")
    line.Name = "ESP_TRACKER_" .. player.Name
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BackgroundTransparency = 0.05
    line.BorderSizePixel = 0
    line.Visible = false
    line.ZIndex = 9998
    line.Parent = _espTrackerGui
    return line
end

local function makeESPHighlight(player, character)
    if not character then return nil end
    local old = character:FindFirstChild("BloodHoundsESPHighlight")
    if old then old:Destroy() end
    local hl = Instance.new("Highlight")
    hl.Name = "BloodHoundsESPHighlight"
    hl.FillColor = Color3.fromRGB(255, 255, 255)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.58
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Enabled = espEnabled
    hl.Adornee = character
    hl.Parent = character
    return hl
end

local function ensureESPPlayer(plr)
    if plr == LP then return end
    if not espBoxCache[plr] then
        espBoxCache[plr] = makeESPBox(plr)
    end
    if not espTrackerCache[plr] then
        espTrackerCache[plr] = makeESPTracker(plr)
    end
    if not espNameCache[plr] then
        espNameCache[plr] = makeESPName(plr)
    end
    if plr.Character then
        local old = espHighlightCache[plr]
        if not old or old.Parent ~= plr.Character then
            destroyESPObject(old)
            espHighlightCache[plr] = makeESPHighlight(plr, plr.Character)
        end
    end
end

local function removeESPPlayer(plr)
    destroyESPObject(espHighlightCache[plr])
    destroyESPObject(espBoxCache[plr])
    destroyESPObject(espTrackerCache[plr])
    destroyESPObject(espNameCache[plr])
    espHighlightCache[plr] = nil
    espBoxCache[plr] = nil
    espTrackerCache[plr] = nil
    espNameCache[plr] = nil
end

local function pointLine(line, x1, y1, x2, y2)
    if not line then return end
    local dx, dy = x2 - x1, y2 - y1
    local len = math.sqrt(dx * dx + dy * dy)
    line.Position = UDim2.fromOffset((x1 + x2) * 0.5, (y1 + y2) * 0.5)
    line.Size = UDim2.fromOffset(len, 1)
    line.Rotation = math.deg(math.atan2(dy, dx))
end

local function updateESP()
    local now = _tick()
    if now - _espLastRun < 0.03 then return end
    _espLastRun = now

    if not espEnabled then
        for plr in pairs(espHighlightCache) do
            if espHighlightCache[plr] then espHighlightCache[plr].Enabled = false end
        end
        for _, box in pairs(espBoxCache) do if box then box.Visible = false end end
        for _, line in pairs(espTrackerCache) do if line then line.Visible = false end end
        for _, label in pairs(espNameCache) do if label then label.Visible = false end end
        return
    end

    local gui = getESPGui()
    if not gui then return end

    local cam = workspace.CurrentCamera
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not cam or not myRoot then return end

    local myPoint, myOnScreen = cam:WorldToViewportPoint(myRoot.Position)
    local myX, myY = myPoint.X, myPoint.Y
    local players = _GetPlayersCached()
    local seen = {}

    for _, plr in ipairs(players) do
        if plr ~= LP then
            seen[plr] = true
            ensureESPPlayer(plr)

            local char = plr.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local alive = root and head and hum and hum.Health > 0

            local hl = espHighlightCache[plr]
            local box = espBoxCache[plr]
            local tracker = espTrackerCache[plr]
            local nameLabel = espNameCache[plr]

            if not alive then
                if hl then hl.Enabled = false end
                if box then box.Visible = false end
                if nameLabel then nameLabel.Visible = false end
                if tracker then tracker.Visible = false end
                if nameLabel then nameLabel.Visible = false end
                continue
            end

            if hl then
                hl.FillColor = Color3.fromRGB(255, 255, 255)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.58
                hl.OutlineTransparency = 0
                hl.Enabled = espEnabled
            end

            local top = cam:WorldToViewportPoint(root.Position + Vector3.new(0, 3.2, 0))
            local bottom = cam:WorldToViewportPoint(root.Position + Vector3.new(0, -3, 0))

            if top.Z > 0 and bottom.Z > 0 then
                local height = math.abs(bottom.Y - top.Y)
                local width = height * 0.55
                local cx = (top.X + bottom.X) * 0.5
                local cy = (top.Y + bottom.Y) * 0.5

                if box then
                    box.Position = UDim2.fromOffset(cx - width * 0.5, cy - height * 0.5)
                    box.Size = UDim2.fromOffset(width, height)
                    box.Visible = espBoxEnabled
                    box.BackgroundTransparency = 0.78
                    local stroke = box:FindFirstChildOfClass("UIStroke")
                    if stroke then stroke.Color = Color3.fromRGB(255, 255, 255) end
                end

                if nameLabel then
                    nameLabel.Text = string.format("%s  Speed: %.1f", plr.DisplayName or plr.Name, root.AssemblyLinearVelocity.Magnitude)
                    nameLabel.Position = UDim2.fromOffset(cx - width * 0.75, cy - height * 0.5 - 18)
                    nameLabel.Size = UDim2.fromOffset(width * 1.5, 18)
                    nameLabel.Visible = espBoxEnabled
                end

                if tracker then
                    pointLine(tracker, myX, myY, cx, cy)
                    tracker.Visible = espTrackerEnabled and myOnScreen
                    tracker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                end
            else
                if box then box.Visible = false end
                if tracker then
                    local off = cam:WorldToViewportPoint(root.Position)
                    local cx, cy = cam.ViewportSize.X * 0.5, cam.ViewportSize.Y * 0.5
                    local tx, ty = off.X, off.Y
                    if off.Z <= 0 then
                        tx, ty = cam.ViewportSize.X - tx, cam.ViewportSize.Y - ty
                    end
                    pointLine(tracker, cx, cy, tx, ty)
                    tracker.Visible = espTrackerEnabled
                    tracker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end

    for plr in pairs(espHighlightCache) do
        if not seen[plr] then removeESPPlayer(plr) end
    end
end

Players.PlayerAdded:Connect(function(plr)
    if espEnabled then task.defer(function() ensureESPPlayer(plr) end) end
end)

Players.PlayerRemoving:Connect(removeESPPlayer)

local function refreshESPLoop()
    if espEnabled then
        if not espConn then
            espConn = RunService.RenderStepped:Connect(updateESP)
        end
        getESPGui()
    else
        if espConn then espConn:Disconnect(); espConn = nil end
        clearESP()
    end
end

function toggleESP(on)
    espEnabled = on == true
    refreshESPLoop()
    if setESPVIsual then setESPVIsual(espEnabled) end
end

function toggleESPBox(on)
    espBoxEnabled = on == true
    if not espEnabled then
        espBoxEnabled = espBoxEnabled
    end
    if setESPBoxVisual then setESPBoxVisual(espBoxEnabled) end
end

function toggleESPTracker(on)
    espTrackerEnabled = on == true
    if setESPTrackerVisual then setESPTrackerVisual(espTrackerEnabled) end
end

function toggleRagdollCountdown(on)
    ragdollCountdownEnabled = on == true
    if not ragdollCountdownEnabled then
        local pg = LP:FindFirstChildOfClass("PlayerGui")
        local bb = pg and pg:FindFirstChild("RagCountdownBillboard")
        if bb then bb:Destroy() end
    end
    if setRagdollCountdownVisual then setRagdollCountdownVisual(ragdollCountdownEnabled) end
end

-- ============================================================
-- ANTI TP ESP — sistema basado en el Anti TP ESP de Ace
-- Detecta cambios de posición anormales y mantiene un ghost en
-- la última posición válida/confirmada del jugador.
-- ============================================================
do
    local antiTpPlayers = game:GetService("Players")
    local antiTpRunService = game:GetService("RunService")
    local antiTpLocalPlayer = antiTpPlayers.LocalPlayer

    local antiTpEsp = {
        Enabled = false,
        Settings = {
            Color = Color3.fromRGB(132, 70, 255),
            MaxDistance = 300,
            MaxAcceptedSpeed = 300,
            GhostShowDistance = 3,
            GhostHideDistance = 3,
        },
        Connections = {},
        Ghosts = {},
        GhostFolder = nil,
    }

    _G._StrikeAntiTpEsp = antiTpEsp

    local function antiTpConnect(conn)
        table.insert(antiTpEsp.Connections, conn)
        return conn
    end

    local function antiTpValidVector(v)
        return typeof(v) == "Vector3"
            and v.X == v.X and v.Y == v.Y and v.Z == v.Z
            and math.abs(v.X) < 1000000
            and math.abs(v.Y) < 1000000
            and math.abs(v.Z) < 1000000
    end

    local oldFolder = workspace:FindFirstChild("StrikeAntiTpGhosts")
    if oldFolder then oldFolder:Destroy() end
    local antiTpFolder = Instance.new("Folder")
    antiTpFolder.Name = "StrikeAntiTpGhosts"
    antiTpFolder.Parent = workspace
    antiTpEsp.GhostFolder = antiTpFolder

    local observed = setmetatable({}, {__mode = "k"})
    local renderStates = setmetatable({}, {__mode = "k"})

    local function createGhost(playerName)
        local model = Instance.new("Model")
        model.Name = "StrikeGhost_" .. tostring(playerName)

        local function createPart(size)
            local part = Instance.new("Part")
            part.Anchored = true
            part.CanCollide = false
            part.CanQuery = false
            part.CanTouch = false
            part.CastShadow = false
            part.Material = Enum.Material.Neon
            part.Size = size
            part.Transparency = 0.35
            part.TopSurface = Enum.SurfaceType.Smooth
            part.BottomSurface = Enum.SurfaceType.Smooth
            part.Parent = model
            return part
        end

        local ghost = {
            Model = model,
            Torso = createPart(Vector3.new(2, 2, 1)),
            Head = createPart(Vector3.new(1.2, 1.2, 1.2)),
            LeftArm = createPart(Vector3.new(0.9, 2, 0.9)),
            RightArm = createPart(Vector3.new(0.9, 2, 0.9)),
            LeftLeg = createPart(Vector3.new(0.9, 2, 0.9)),
            RightLeg = createPart(Vector3.new(0.9, 2, 0.9)),
        }

        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 110, 0, 18)
        billboard.StudsOffset = Vector3.new(0, 1.6, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = ghost.Head

        local label = Instance.new("TextLabel")
        label.Size = UDim2.fromScale(1, 1)
        label.BackgroundTransparency = 1
        label.Text = tostring(playerName)
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 12
        label.TextStrokeTransparency = 0
        label.Parent = billboard
        ghost.Label = label

        model.Parent = antiTpFolder
        return ghost
    end

    local function showGhost(player, position, root)
        if not antiTpEsp.Enabled then return end
        local ghost = antiTpEsp.Ghosts[player]
        if not ghost then
            ghost = createGhost(player.Name)
            antiTpEsp.Ghosts[player] = ghost
        end
        if not ghost.Model.Parent then ghost.Model.Parent = antiTpFolder end
        ghost.Shown = true

        local yaw = 0
        pcall(function()
            local _, y = root.CFrame:ToEulerAnglesYXZ()
            yaw = y
        end)

        local cf = CFrame.new(position) * CFrame.Angles(0, yaw, 0)
        ghost.Torso.CFrame = cf
        ghost.Head.CFrame = cf * CFrame.new(0, 1.6, 0)
        ghost.LeftArm.CFrame = cf * CFrame.new(-1.45, 0, 0)
        ghost.RightArm.CFrame = cf * CFrame.new(1.45, 0, 0)
        ghost.LeftLeg.CFrame = cf * CFrame.new(-0.55, -2, 0)
        ghost.RightLeg.CFrame = cf * CFrame.new(0.55, -2, 0)

        local color = antiTpEsp.Settings.Color
        for _, child in ipairs(ghost.Model:GetChildren()) do
            if child:IsA("BasePart") then child.Color = color end
        end
        ghost.Label.TextColor3 = color
    end

    local function hideGhost(player)
        local ghost = antiTpEsp.Ghosts[player]
        if ghost then
            ghost.Model.Parent = nil
            ghost.Shown = false
        end
    end

    local function destroyGhost(player)
        local ghost = antiTpEsp.Ghosts[player]
        if ghost then
            pcall(function() ghost.Model:Destroy() end)
            antiTpEsp.Ghosts[player] = nil
        end
    end

    -- Heartbeat: observa posiciones normales y confirma una posición antes
    -- de considerarla válida. Un salto grande bloquea la posición actual.
    local heartbeatAcc = 0
    antiTpConnect(antiTpRunService.Heartbeat:Connect(function(dt)
        if not antiTpEsp.Enabled then return end
        heartbeatAcc = heartbeatAcc + (dt or 0.016)
        if heartbeatAcc < 0.0333333333 then return end
        heartbeatAcc = 0

        local myChar = antiTpLocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local now = os.clock()

        for _, player in ipairs(antiTpPlayers:GetPlayers()) do
            if player ~= antiTpLocalPlayer then
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if root and hum and hum.Health > 0 then
                    local pos = root.Position
                    local linear = root.AssemblyLinearVelocity
                    local angular = root.AssemblyAngularVelocity
                    local dist = antiTpValidVector(pos) and (myRoot.Position - pos).Magnitude or math.huge
                    local valid = antiTpValidVector(pos)
                        and pos.Y > -30 and pos.Y < 350
                        and dist <= antiTpEsp.Settings.MaxDistance
                        and linear.Magnitude <= 180
                        and angular.Magnitude <= 45

                    local st = observed[player]
                    if not st or st.Character ~= char then
                        st = {Character = char, Locked = false, Candidate = nil, CandidateAt = nil, CandidateCount = 0}
                        observed[player] = st
                    end

                    if antiTpValidVector(pos) and st.LastObserved and (pos - st.LastObserved).Magnitude >= 8 then
                        st.Locked = true
                    end

                    if not valid then
                        st.Locked = true
                        st.Candidate = nil
                        st.CandidateAt = nil
                        st.CandidateCount = 0
                    elseif not st.Locked then
                        if st.Candidate and (pos - st.Candidate).Magnitude <= 7 then
                            st.Candidate = st.Candidate:Lerp(pos, 0.35)
                            st.CandidateCount = st.CandidateCount + 1
                            local confirmed = st.CandidateCount >= 4
                            if confirmed then confirmed = (now - (st.CandidateAt or now)) >= 0.1 end
                            if confirmed then
                                st.Position = st.Candidate
                                st.PositionAt = now
                                st.Confirmed = true
                            end
                        else
                            st.Candidate = pos
                            st.CandidateAt = now
                            st.CandidateCount = 1
                        end
                    end
                    if antiTpValidVector(pos) then st.LastObserved = pos end
                end
            end
        end
    end))

    -- RenderStepped: congela la posición mostrada cuando detecta un TP.
    local renderAcc = 0
    antiTpConnect(antiTpRunService.RenderStepped:Connect(function(dt)
        if not antiTpEsp.Enabled then return end
        renderAcc = renderAcc + (dt or 0.016)
        if renderAcc < 0.0069444444 then return end
        renderAcc = 0

        local myChar = antiTpLocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local now = os.clock()
        for _, player in ipairs(antiTpPlayers:GetPlayers()) do
            if player ~= antiTpLocalPlayer and player.Character then
                local char = player.Character
                local root = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if root and hum and hum.Health > 0 then
                    local st = renderStates[player]
                    if not st or st.Character ~= char then
                        st = {Character = char, Position = nil, At = now, Candidate = nil, CandidateAt = 0, CandidateCount = 0, Frozen = false}
                        renderStates[player] = st
                    end

                    local position = root.Position
                    local validVoid = antiTpValidVector(position) and (position.Y < -35 or position.Y > 350)
                    if validVoid then
                        hideGhost(player)
                    else
                        local observedState = observed[player]
                        local shownPos = position

                        if not st.Position then
                            if observedState and observedState.Confirmed and observedState.Character == char and observedState.Position then
                                shownPos = observedState.Position
                            end
                            st.Position = shownPos
                            st.At = now
                            st.Frozen = observedState and observedState.Confirmed == true or false
                        else
                            local elapsed = math.max(now - (st.At or now), 0.0041666667)
                            local moved = (position - st.Position).Magnitude
                            if not st.Frozen and moved <= antiTpEsp.Settings.MaxAcceptedSpeed * elapsed then
                                st.Position = position
                                st.At = now
                            elseif st.Frozen and moved <= 12 then
                                st.Position = position
                                st.At = now
                                st.Frozen = false
                            elseif not st.Candidate or (position - st.Candidate).Magnitude > 9 then
                                st.Candidate = position
                                st.CandidateAt = now
                                st.CandidateCount = 1
                            else
                                st.Candidate = st.Candidate:Lerp(position, 0.45)
                                st.CandidateCount = st.CandidateCount + 1
                                if st.CandidateCount >= 3 and (now - st.CandidateAt) >= 0.075 then
                                    st.Position = position
                                    st.At = now
                                    st.Candidate = nil
                                    st.CandidateCount = 0
                                    st.Frozen = false
                                end
                            end
                        end

                        if st.Position and (st.Position - myRoot.Position).Magnitude <= antiTpEsp.Settings.MaxDistance then
                            local delta = (st.Position - root.Position).Magnitude
                            if delta >= antiTpEsp.Settings.GhostShowDistance then
                                showGhost(player, st.Position, root)
                            elseif delta <= antiTpEsp.Settings.GhostHideDistance then
                                hideGhost(player)
                            elseif antiTpEsp.Ghosts[player] and antiTpEsp.Ghosts[player].Shown then
                                showGhost(player, st.Position, root)
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

    antiTpConnect(antiTpPlayers.PlayerRemoving:Connect(function(player)
        destroyGhost(player)
        observed[player] = nil
        renderStates[player] = nil
    end))

    antiTpEsp.SetEnabled = function(on)
        antiTpEsp.Enabled = on == true
        if not antiTpEsp.Enabled then
            for player in pairs(antiTpEsp.Ghosts) do hideGhost(player) end
            table.clear(observed)
            table.clear(renderStates)
        end
    end

    antiTpEsp.SetColor = function(color)
        if typeof(color) == "Color3" then
            antiTpEsp.Settings.Color = color
        end
    end

    antiTpEsp.Destroy = function()
        antiTpEsp.Enabled = false
        for _, conn in ipairs(antiTpEsp.Connections) do pcall(function() conn:Disconnect() end) end
        table.clear(antiTpEsp.Connections)
        for player in pairs(antiTpEsp.Ghosts) do destroyGhost(player) end
        pcall(function() antiTpFolder:Destroy() end)
        if _G._StrikeAntiTpEsp == antiTpEsp then _G._StrikeAntiTpEsp = nil end
    end

    function toggleAntiTpEsp(on)
        antiTpEspEnabled = on == true
        antiTpEsp.SetEnabled(antiTpEspEnabled)
        if setAntiTpEspVisual then setAntiTpEspVisual(antiTpEspEnabled) end
    end
end

local _enemySpeedAcc = 0
function updateEnemySpeedLabels()
    _enemySpeedAcc = _enemySpeedAcc + 1
    if _enemySpeedAcc < 6 then return end
    _enemySpeedAcc = 0

    local color = Color3.fromRGB(255,255,255)
    local players = _GetPlayersCached()
    for i = 1, #players do
        local player = players[i]
        if player ~= LP then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local v = hrp.AssemblyLinearVelocity
                local speed = _sqrt(v.X*v.X + v.Z*v.Z)
                local label = enemySpeedLabels[player]
                if not label then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.new(0, 100, 0, 25)
                        bb.StudsOffset = _V3new(0, 5.5, 0)
                        bb.AlwaysOnTop = true
                        bb.Name = "EnemySpeedGui"
                        bb.Parent = head
                        local tl = Instance.new("TextLabel", bb)
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.TextColor3 = color
                        tl.Font = Enum.Font.GothamBold
                        tl.TextScaled = true
                        tl.TextStrokeTransparency = 0
                        tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        enemySpeedLabels[player] = tl
                        label = tl
                    end
                elseif label.Parent and label.Parent.Parent ~= char then
                    local head = char:FindFirstChild("Head")
                    if head then label.Parent.Parent = head end
                end
                if label then
                    label.Text = string.format("%.1f", speed)
                    if label.TextColor3 ~= color then label.TextColor3 = color end
                end
            else
                local label = enemySpeedLabels[player]
                if label and label.Parent and label.Parent.Parent then label.Parent.Parent = nil end
                enemySpeedLabels[player] = nil
            end
        end
    end
end

function startEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect() end
    enemySpeedConn = RunService.Heartbeat:Connect(updateEnemySpeedLabels)
end

function stopEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect(); enemySpeedConn = nil end
end

local function getClosestTargetBody()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, _huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local dx = tRoot.Position.X - rpos.X
                        local dy = tRoot.Position.Y - rpos.Y
                        local dz = tRoot.Position.Z - rpos.Z
                        local d = dx*dx + dy*dy + dz*dz
                        if d < minDist then minDist = d; closest = tRoot end
                    end
                end
            end
        end
    end
    return closest
end

function _suppressBodyLock() end
function _unsuppressBodyLock(_) end

function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local oldBB = head:FindFirstChild("BloodHoundsSpeedIndicator")
    if oldBB then oldBB:Destroy() end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "BloodHoundsSpeedIndicator"
    bb.Size = UDim2.new(0, 120, 0, 32)
    bb.StudsOffset = _V3new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Size = UDim2.new(1, 0, 1, 0)
    speedLabel.Position = UDim2.new(0, 0, 0, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Spd: 0.0"
    speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextScaled = true
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
    local discordBB = head:FindFirstChild("DiscordText")
    if discordBB then discordBB:Destroy() end
    discordBB = Instance.new("BillboardGui", head)
    discordBB.Name = "DiscordText"
    discordBB.Size = UDim2.new(0, 200, 0, 28)
    discordBB.StudsOffset = _V3new(0, 5.2, 0)
    discordBB.AlwaysOnTop = true
    local discordLabel = Instance.new("TextLabel", discordBB)
    discordLabel.Size = UDim2.new(1, 0, 1, 0)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "discord.gg/Akjvv4Ybws"
    discordLabel.TextColor3 = Color3.fromRGB(255,255,255)
    discordLabel.Font = Enum.Font.GothamBold
    discordLabel.TextScaled = true
    discordLabel.TextStrokeTransparency = 0
    discordLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    applyShimmerToText(discordLabel, 0.9)
end

function refreshSpeedModeLabel()
    if modeValLbl then
        if laggerCarryToggled then modeValLbl.Text = "Lagger Carry"
        elseif laggerToggled then modeValLbl.Text = "Lagger"
        elseif speedMode then modeValLbl.Text = "Carry"
        else modeValLbl.Text = "Normal" end
    end
    if setCarryModeVisual then setCarryModeVisual(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function resetMovementState()
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function toggleCarryMode()
    if laggerToggled or laggerCarryToggled then
        laggerToggled = false; laggerCarryToggled = false; speedMode = true
    else speedMode = not speedMode end
    resetMovementState()
end

function toggleLaggerMode()
    if laggerCarryToggled then laggerCarryToggled = false end
    speedMode = false; laggerToggled = not laggerToggled
    resetMovementState()
end
function toggleLaggerCarryMode()
    if laggerToggled then laggerToggled = false end
    speedMode = false; laggerCarryToggled = not laggerCarryToggled
    resetMovementState()
end

function toggleLaggerCycle()
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

-- ============================================================================
-- AUTO CARRY SPEED + AUTO CARRY ON ENEMY BASE (motor, portado de Ryzen)
-- Cambia automáticamente a velocidad Carry cuando llevas un brainrot / robas,
-- y vuelve a tu modo anterior al soltarlo. "Auto Carry on Enemy Base" fuerza
-- Carry cuando estás dentro del rango de una base enemiga.
-- ============================================================================
autoCarrySpeedEnabled = false
setAutoCarrySpeedVisual = nil
autoCarryEnemyBaseEnabled = false
autoCarryEnemyBaseRange = 35
setAutoCarryEnemyBaseVisual = nil
autoCarryEnemyBaseRangeBox = nil

do
    local _acsFromAuto = false
    local _acsReturnCarry, _acsReturnLagger, _acsReturnLaggerCarry = false, false, false
    local _acsGraceUntil = 0

    local function _acsIsCarryingBrainrot()
        local char = LP.Character
        if not char then return false end
        local ok, v = pcall(function() return LP:GetAttribute("Stealing") end)
        if ok and v == true then return true end
        local ok2, v2 = pcall(function() return char:GetAttribute("Stealing") end)
        if ok2 and v2 == true then return true end
        for _, name in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
            local obj = char:FindFirstChild(name)
            if obj then
                if (obj:IsA("BoolValue") and obj.Value) or
                   (obj:IsA("ObjectValue") and obj.Value) or
                   (obj:IsA("StringValue") and obj.Value ~= "") then
                    return true
                end
            end
        end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
                local n = child.Name:lower()
                if n:find("brainrot") or n:find("animal") or n:find("carry")
                or n:find("grab") or n:find("steal") or n:find("hold") then
                    return true
                end
            end
        end
        return false
    end

    local function _acsSyncCarrySystem()
        if CarrySystem then
            CarrySystem.speedToggled = speedMode
            CarrySystem.laggerMode = laggerCarryToggled and 2 or (laggerToggled and 1 or 0)
        end
    end

    local function _acsEnableCarry()
        if _acsFromAuto then return end
        _acsReturnCarry = speedMode
        _acsReturnLagger = laggerToggled
        _acsReturnLaggerCarry = laggerCarryToggled
        _acsFromAuto = true
        _acsGraceUntil = tick() + 0.75
        local wasLagger = laggerToggled or laggerCarryToggled
        if wasLagger then
            speedMode = false; laggerToggled = false; laggerCarryToggled = true
        else
            speedMode = true; laggerToggled = false; laggerCarryToggled = false
        end
        resetMovementState()
        _acsSyncCarrySystem()
    end

    local function _acsDisableCarry()
        if not _acsFromAuto then return end
        _acsFromAuto = false
        _acsGraceUntil = 0
        speedMode = _acsReturnCarry
        laggerToggled = _acsReturnLagger
        laggerCarryToggled = _acsReturnLaggerCarry
        resetMovementState()
        _acsSyncCarrySystem()
    end

    function _G.StrikeSetAutoCarrySpeed(on)
        autoCarrySpeedEnabled = on and true or false
        if not autoCarrySpeedEnabled and _acsFromAuto then _acsDisableCarry() end
        if setAutoCarrySpeedVisual then pcall(function() setAutoCarrySpeedVisual(autoCarrySpeedEnabled) end) end
    end

    local _acsHitClearUntil = 0
    RunService.RenderStepped:Connect(function()
        if autoCarrySpeedEnabled ~= true then
            if _acsFromAuto then _acsDisableCarry() end
            return
        end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum then
            if _acsFromAuto then _acsDisableCarry() end
            return
        end
        local st = hum:GetState()
        local gotHit = st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
        local carrying = _acsIsCarryingBrainrot()
        if carrying and not _acsFromAuto then
            _acsEnableCarry()
        end
        if _acsFromAuto then
            local graceDone = tick() > (_acsGraceUntil or 0)
            if gotHit or (graceDone and not carrying) then
                _acsDisableCarry()
            end
        end
    end)

    -- ---------------- Auto Carry on Enemy Base ----------------
    _G.StrikeAutoCarryEnemyBase = _G.StrikeAutoCarryEnemyBase or {conn = nil}

    local function _acbIsMyPlot(plot)
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local yb = sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
        end
        return false
    end

    local function _acbIsNearEnemyBase(range)
        range = tonumber(range) or autoCarryEnemyBaseRange or 35
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return false end
        local myPos = hrp.Position
        for _, plot in ipairs(plots:GetChildren()) do
            if plot:IsA("Model") and not _acbIsMyPlot(plot) then
                local pos
                local ok, pivot = pcall(function() return plot:GetPivot().Position end)
                if ok and pivot then pos = pivot end
                if not pos then
                    local sign = plot:FindFirstChild("PlotSign")
                    if sign and sign:IsA("BasePart") then pos = sign.Position
                    elseif sign then
                        local pp = sign:FindFirstChildWhichIsA("BasePart", true)
                        if pp then pos = pp.Position end
                    end
                end
                if pos then
                    local flat = Vector3.new(myPos.X - pos.X, 0, myPos.Z - pos.Z)
                    if flat.Magnitude <= range then return true end
                end
            end
        end
        return false
    end

    function _G.StrikeStartAutoCarryEnemyBase()
        local S = _G.StrikeAutoCarryEnemyBase
        if S.conn then return end
        local acc = 0
        S.conn = RunService.Heartbeat:Connect(function(dt)
            if not autoCarryEnemyBaseEnabled then return end
            acc = acc + (dt or 0.016)
            if acc < 0.2 then return end
            acc = 0
            if not _acbIsNearEnemyBase(autoCarryEnemyBaseRange) then return end
            if speedMode and not laggerToggled and not laggerCarryToggled then return end
            speedMode = true; laggerToggled = false; laggerCarryToggled = false
            resetMovementState()
            _acsSyncCarrySystem()
        end)
    end

    function _G.StrikeStopAutoCarryEnemyBase()
        local S = _G.StrikeAutoCarryEnemyBase
        if S.conn then pcall(function() S.conn:Disconnect() end); S.conn = nil end
    end

    function _G.StrikeSetAutoCarryEnemyBase(on)
        autoCarryEnemyBaseEnabled = on and true or false
        if autoCarryEnemyBaseEnabled then _G.StrikeStartAutoCarryEnemyBase() else _G.StrikeStopAutoCarryEnemyBase() end
        if setAutoCarryEnemyBaseVisual then pcall(function() setAutoCarryEnemyBaseVisual(autoCarryEnemyBaseEnabled) end) end
    end
end

function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
    _unsuppressBodyLock(true)
end

function startAutoLeft()
    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end
    disableAllAimbots()
    _suppressBodyLock()
    if alConn then alConn:Disconnect() end
    alPhase = 1
    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if alPhase == 1 then
            local tgt = _V3new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.L1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif alPhase == 2 then
            local tgt = _V3new(AP.L2.X, root.Position.Y, AP.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobSetAutoLeft then mobSetAutoLeft(false) end
                _unsuppressBodyLock(true)
                local facePos = _V3new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.L2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
    _unsuppressBodyLock(true)
end

function startAutoRight()
    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    disableAllAimbots()
    _suppressBodyLock()
    if arConn then arConn:Disconnect() end
    arPhase = 1
    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if arPhase == 1 then
            local tgt = _V3new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.R1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif arPhase == 2 then
            local tgt = _V3new(AP.R2.X, root.Position.Y, AP.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobSetAutoRight then mobSetAutoRight(false) end
                _unsuppressBodyLock(true)
                local facePos = _V3new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.R2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function getClosestTarget()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, _huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local dx = tRoot.Position.X - rpos.X
                        local dy = tRoot.Position.Y - rpos.Y
                        local dz = tRoot.Position.Z - rpos.Z
                        local d = dx*dx + dy*dy + dz*dz
                        if d < minDist then minDist = d; closest = tRoot end
                    end
                end
            end
        end
    end
    return closest
end

function trySwing()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then return end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
end

function stopAimbotAdapt()
    if _aimbotConn then
        pcall(function() _aimbotConn:Disconnect() end)
        _aimbotConn = nil
    end
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
    _prevAutoRotate = nil
    lastMoveDir = _V3zero
    _unsuppressBodyLock(true)
end

function startAimbotAdapt()
    if _aimbotConn then return end
    _suppressBodyLock()
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end
    _aimbotConn = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target = getClosestTarget()
        if not target then return end
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14
        predictPos = predictPos + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = _V3new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = _V3new(0,0,0) end
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = _clamp(yVel, -70, 110)
        local desiredVel = _V3new(flatDir.X * BAT_AIMBOT_SPEED, yVel, flatDir.Z * BAT_AIMBOT_SPEED)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        local speed3 = targetVel.Magnitude
        local predictTime = _clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = _CFlookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = _clamp(rx, -2.5, 2.5)
            ry = _clamp(ry, -2.5, 2.5)
            rz = _clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(rx * 42, ry * 42, rz * 42))
        end
        local distToTarget = (root.Position - target.Position).Magnitude
        if distToTarget <= 8 then trySwing() end
    end)
end

function disableAutoBat()
    autoBatEnabled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotAdapt()
end

function enableAutoBat()
    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        stopAutoLeft()
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then autoRightSetVisual(false) end
        stopAutoRight()
    end
    if batDesyncTpEnabled then toggleBatDesyncTp() end
    if autoBatBypassEnabled then disableBatBypass() end
    autoBatEnabled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
end

local function findAnyToolV2()
    local c = LP.Character
    if c then
        for _, v in ipairs(c:GetChildren()) do
            if v:IsA("Tool") then return v end
        end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, v in ipairs(bp:GetChildren()) do
            if v:IsA("Tool") then return v end
        end
    end
    return nil
end

-- ============================================================
-- BAT BYPASS — motor adaptado del sistema de Clean
-- Mantiene la interfaz/controles propios de STRIKE.
-- ============================================================
BAT_BYPASS_LEAD_STUDS = 3

local batBypassClean = {
    Enabled = false,
    Connection = nil,
    State = {
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
    },
    Config = {
        FOLLOW_SPEED = 55,
        ACTIVATE_DISTANCE = 13,
        MIN_FOLLOW_DISTANCE = 1,
        PREDICTION_TIME = 0.22,
        PREDICT_AHEAD = 3,
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
    },
}

local function averageBatBypassVectors(vectors)
    if #vectors == 0 then return Vector3.zero end
    local sum = Vector3.zero
    for _, entry in ipairs(vectors) do
        sum += entry
    end
    return sum / #vectors
end

local function pushBatBypassHistory(history, entry, maxEntries)
    table.insert(history, entry)
    if #history > maxEntries then
        table.remove(history, 1)
    end
end

local function resetBatBypassPrediction()
    local z = batBypassClean.State
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

local function findBatBypassToolClean()
    local character = LP.Character
    if not character then return nil end

    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        local name = tool.Name:lower()
        if name:find("bat", 1, true) or name:find("slap", 1, true) then
            return tool
        end
    end

    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                local name = child.Name:lower()
                if name:find("bat", 1, true) or name:find("slap", 1, true) then
                    return child
                end
            end
        end
    end
    return nil
end

local function findClosestBatBypassTarget(rootPart)
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (rootPart.Position - targetRoot.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end

local function applyBatBypassAngularAim(rootPart, direction)
    if direction.Magnitude < 0.01 then return end
    local crossVector = rootPart.CFrame.LookVector:Cross(direction.Unit)
    local angle = math.asin(math.clamp(crossVector.Magnitude, -1, 1))
    rootPart.AssemblyAngularVelocity = crossVector.Magnitude > 0.1
        and crossVector.Unit * angle * 80
        or Vector3.zero
end

local function updateBatBypassPing()
    local ok, result = pcall(function()
        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    local z = batBypassClean.State
    if ok and type(result) == "number" then
        z.realPingMs = math.floor(result)
    end
    z.currentPing = math.clamp(
        z.realPingMs / 1000,
        batBypassClean.Config.MIN_PING_COMPENSATION,
        batBypassClean.Config.MAX_PING_COMPENSATION
    )
end

if not batBypassClean.PingLoopStarted then
    batBypassClean.PingLoopStarted = true
    task.spawn(function()
        while _G.BloodHoundsRunning do
            pcall(updateBatBypassPing)
            task.wait(0.5)
        end
    end)
end

local function stopBatBypassClean()
    batBypassClean.Enabled = false
    if batBypassClean.Connection then
        batBypassClean.Connection:Disconnect()
        batBypassClean.Connection = nil
    end

    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if humanoid then humanoid.AutoRotate = true end
    if rootPart then
        rootPart.AssemblyAngularVelocity = Vector3.zero
    end
    resetBatBypassPrediction()
    batBypassClean.State.lastActivationTime = 0
end

local function startBatBypassClean()
    if batBypassClean.Connection then return end

    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    batBypassClean.Enabled = true
    humanoid.AutoRotate = false

    local tool = findBatBypassToolClean()
    if tool and tool.Parent ~= character then
        pcall(function()
            humanoid:EquipTool(tool)
        end)
    end

    batBypassClean.Connection = RunService.RenderStepped:Connect(function(deltaTime)
        if not batBypassClean.Enabled then
            stopBatBypassClean()
            return
        end

        local z = batBypassClean.State
        local cfg = batBypassClean.Config
        local currentCharacter = LP.Character
        local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
        local currentHumanoid = currentCharacter and currentCharacter:FindFirstChildOfClass("Humanoid")
        if not currentRoot or not currentHumanoid or currentHumanoid.Health <= 0 then
            return
        end

        currentHumanoid.AutoRotate = false
        rootPart = currentRoot
        humanoid = currentHumanoid
        tool = currentCharacter:FindFirstChildOfClass("Tool") or findBatBypassToolClean()
        if tool and tool.Parent ~= currentCharacter then
            pcall(currentHumanoid.EquipTool, currentHumanoid, tool)
        end

        z.targetPlayer = findClosestBatBypassTarget(rootPart)
        local targetCharacter = z.targetPlayer and z.targetPlayer.Character
        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
        if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then
            resetBatBypassPrediction()
            return
        end

        local position = targetRoot.Position
        local sampleDeltaTime = math.max(deltaTime, 0.0041666666666666666)
        if z.lastTargetPos then
            local targetVelocity = (position - z.lastTargetPos) / sampleDeltaTime
            local velocityDelta = targetVelocity - z.targetVelocity
            if velocityDelta.Magnitude > cfg.MAX_VELOCITY_CHANGE then
                targetVelocity = z.targetVelocity + velocityDelta.Unit * cfg.MAX_VELOCITY_CHANGE
            end

            local horizontalVelocity = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
            if horizontalVelocity.Magnitude > cfg.MAX_HORIZONTAL_VELOCITY then
                local limited = horizontalVelocity.Unit * cfg.MAX_HORIZONTAL_VELOCITY
                targetVelocity = Vector3.new(limited.X, targetVelocity.Y, limited.Z)
            end

            pushBatBypassHistory(z.accelerationHistory, (targetVelocity - z.targetVelocity) / sampleDeltaTime, 4)
            pushBatBypassHistory(z.velocityHistory, targetVelocity, 8)
            z.targetVelocity = targetVelocity
            z.smoothedVelocity = z.smoothedVelocity:Lerp(targetVelocity, cfg.VELOCITY_SMOOTHING)
        end

        z.lastTargetPos = position
        local isAirborne = targetHumanoid.FloorMaterial == Enum.Material.Air
        z.airborneTime = isAirborne and z.airborneTime + sampleDeltaTime or 0
        if isAirborne and z.airborneTime >= cfg.MIN_AIRBORNE_TIME then
            pushBatBypassHistory(z.aerialVelocityHistory, z.targetVelocity, 6)
        elseif not isAirborne then
            z.aerialVelocityHistory = {}
        end

        local smoothedVelocity = z.smoothedVelocity
        if isAirborne and #z.aerialVelocityHistory > 0 then
            local aerialAverage = averageBatBypassVectors(z.aerialVelocityHistory)
            smoothedVelocity = Vector3.new(aerialAverage.X, z.targetVelocity.Y, aerialAverage.Z) * cfg.AIR_CONTROL_FACTOR
        end

        local changedDirectionQuickly = false
        local horizontalTargetVelocity = Vector3.new(z.targetVelocity.X, 0, z.targetVelocity.Z)
        if horizontalTargetVelocity.Magnitude > 5 then
            local directionUnit = horizontalTargetVelocity.Unit
            if z.previousDirection and z.previousDirection:Dot(directionUnit) < 0.5 then
                changedDirectionQuickly = tick() - z.lastDirectionChangeTime < cfg.DIRECTION_CHANGE_DETECTION_TIME
                z.lastDirectionChangeTime = tick()
            end
            z.previousDirection = directionUnit
        end

        local predictionTime = z.currentPing + cfg.SERVER_TICKRATE
        if changedDirectionQuickly then
            predictionTime *= cfg.QUICK_DIRECTION_CHANGE_MULTIPLIER
        end

        local predictedPosition = position
            + smoothedVelocity * predictionTime
            + averageBatBypassVectors(z.accelerationHistory)
                * cfg.ACCELERATION_PREDICTION_WEIGHT
                * predictionTime
                * predictionTime
                * 0.5

        local leadTime = cfg.PREDICTION_TIME * 1.1
        local leadPosition
        if isAirborne then
            leadPosition = predictedPosition
                + smoothedVelocity * leadTime
                + Vector3.new(0, -0.5 * cfg.GRAVITY * leadTime * leadTime, 0)
        else
            leadPosition = predictedPosition + smoothedVelocity * leadTime
        end

        local flatVelocity = Vector3.new(smoothedVelocity.X, 0, smoothedVelocity.Z)
        if flatVelocity.Magnitude > 1 then
            leadPosition += flatVelocity.Unit * cfg.PREDICT_AHEAD
        end

        local targetDirection = leadPosition - rootPart.Position
        applyBatBypassAngularAim(rootPart, targetDirection)

        local withinActivationRange = (position - rootPart.Position).Magnitude <= cfg.ACTIVATE_DISTANCE
        if withinActivationRange then
            withinActivationRange = tick() - z.lastActivationTime >= 0.3
        end
        if withinActivationRange and tool then
            pcall(tool.Activate, tool)
            z.lastActivationTime = tick()
        end

        if cfg.MIN_FOLLOW_DISTANCE < targetDirection.Magnitude then
            rootPart.AssemblyLinearVelocity = targetDirection.Unit * cfg.FOLLOW_SPEED
        else
            rootPart.AssemblyLinearVelocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y * 0.5, 0)
        end
    end)
end

function enableBatBypass()
    if autoBatBypassEnabled then return end

    if autoBatEnabled then disableAutoBat() end
    if batDesyncTpEnabled then toggleBatDesyncTp() end
    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end

    batBypassClean.Config.FOLLOW_SPEED = tonumber(BAT_BYPASS_SPEED) or 55
    batBypassClean.Config.ACTIVATE_DISTANCE = tonumber(BAT_BYPASS_HIT_DIST) or 13
    batBypassClean.Config.PREDICT_AHEAD = tonumber(BAT_BYPASS_LEAD_STUDS) or 3
    autoBatBypassEnabled = true
    startBatBypassClean()

    if autoBatBypassSetVisual then autoBatBypassSetVisual(true) end
    if batBypassFloatingButton then
        local btnFrame = batBypassFloatingButton:FindFirstChild("Frame")
        if btnFrame then paintFloatingBtn(btnFrame, true) end
    end
end

function disableBatBypass()
    autoBatBypassEnabled = false
    stopBatBypassClean()
    if autoBatBypassSetVisual then autoBatBypassSetVisual(false) end
    if batBypassFloatingButton then
        local btnFrame = batBypassFloatingButton:FindFirstChild("Frame")
        if btnFrame then paintFloatingBtn(btnFrame, false) end
    end
end

function toggleBatBypass()
    if autoBatBypassEnabled then
        disableBatBypass()
    else
        enableBatBypass()
    end
end

local function updateTpBatButtonWithAntiDie(state)
    if tpBatFloatingButton then
        local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
        if btnFrame then
            local label = btnFrame:FindFirstChild("TextLabel")
            local stroke = btnFrame:FindFirstChildOfClass("UIStroke")
            if state then
                btnFrame.BackgroundColor3 = BTN_ACTIVE_COLOR
                if label then
                    label.Text = "TP\nBAT"
                    label.TextColor3 = Color3.fromRGB(255,255,255)
                end
                if stroke then
                    stroke.Color = BTN_ACTIVE_COLOR
                    stroke.Thickness = 2.5
                end
            else
                if label then label.Text = "TP\nBAT" end
                paintFloatingBtn(btnFrame, batDesyncTpEnabled)
            end
        end
    end
end

local batDesyncTpEnabled = false
local batDesyncTpConn = nil
local batDesyncTpSetVisual = nil
local hittingCooldownDesync = false

-- ============================================================
-- TP BAT — sistema separado
-- 
-- ============================================================
tpBatMode = tpBatMode or "v1"
setTpBatVersion = nil       -- se define en el menú
updateTpBatModeUI = nil     -- se define en el menú

local TPBAT_CONFIGS = {
    v1 = {
        range           = 250,
        tpOffset        = _V3new(0, 0, 0),
        loopDelay       = 0.08,
        smartRotation   = true,
        resetVelocity   = true,
        predictMovement = true,
        predictionFactor= 0.15,
        antiFling       = true,
        sideOffset      = 2.5,
    },
    v2 = {
        range           = 250,
        tpOffset        = _V3new(0, 3, 0),
        loopDelay       = 0.08,
        smartRotation   = false,
        resetVelocity   = true,
        predictMovement = false,
        predictionFactor= 0,
        antiFling       = false,
        sideOffset      = 0,
    },
}

local function getTpBatConfig()
    return TPBAT_CONFIGS[tpBatMode] or TPBAT_CONFIGS.v1
end

_tpBatNextTick = 0  -- global: accesible desde batDesyncTpUpdate y el menú (setTpBatVersion)

-- ============================================================
-- TP BAT DESYNC — lógica interna (MACHO style)
-- ============================================================
local function getBatDesync()
    local char = LP.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    local bp2 = LP:FindFirstChild("Backpack")
    if bp2 then
        tool = bp2:FindFirstChild("Bat")
        if tool then
            tool.Parent = char
            return tool
        end
    end
    return nil
end

local function tryHitBatDesync()
    if hittingCooldownDesync then return end
    hittingCooldownDesync = true
    pcall(function()
        local bat = getBatDesync()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.08, function() hittingCooldownDesync = false end)
end

local function getClosestPlayerDesync()
    local char = LP.Character
    if not char then return nil, _huge end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, _huge end
    local hpos = hrp.Position
    local cp, cd = nil, _huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local d = (hpos - tr.Position).Magnitude
                if d < cd then cd = d; cp = p end
            end
        end
    end
    return cp, cd
end

local function batDesyncTpUpdate()
    if not batDesyncTpEnabled then
        stopBatDesyncTp()
        return
    end

    -- throttle por loopDelay del modo activo
    local nowT = _tick()
    if nowT < _tpBatNextTick then return end
    local cfg = getTpBatConfig()
    _tpBatNextTick = nowT + (cfg.loopDelay or 0.08)

    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")

    local target, dist = getClosestPlayerDesync()
    if not (target and target.Character) then return end
    if dist and cfg.range and dist > cfg.range then return end

    local tr = target.Character:FindFirstChild("HumanoidRootPart")
    if not tr then return end

    -- desync de física (se mantiene igual que antes)
    if sethiddenproperty then
        pcall(function()
            sethiddenproperty(hrp, "PhysicsRepRootPart", tr)
        end)
    end

    -- posición objetivo (con predicción de movimiento si el modo lo pide)
    local targetPos = tr.Position
    if cfg.predictMovement then
        targetPos = targetPos + (tr.AssemblyLinearVelocity * (cfg.predictionFactor or 0))
    end

    -- posición final: offset lateral (V1) o offset directo (V2)
    local finalPos
    if cfg.sideOffset and cfg.sideOffset > 0 then
        local dir = hrp.Position - targetPos
        dir = _V3new(dir.X, 0, dir.Z)
        if dir.Magnitude < 0.1 then
            dir = _V3new(1, 0, 0)
        else
            dir = dir.Unit
        end
        finalPos = targetPos + (dir * cfg.sideOffset)
    else
        finalPos = targetPos + (cfg.tpOffset or _V3new(0, 0.9, 0))
    end

    -- aplicar CFrame (con rotación inteligente hacia el enemigo si el modo lo pide)
    if (hrp.Position - finalPos).Magnitude > 8 or cfg.smartRotation then
        if cfg.smartRotation then
            hrp.CFrame = _CFnew(finalPos, targetPos)
        else
            hrp.CFrame = _CFnew(finalPos)
        end
    end

    if cfg.resetVelocity then
        pcall(function()
            hrp.AssemblyLinearVelocity = _V3new(0, 0, 0)
            hrp.AssemblyAngularVelocity = _V3new(0, 0, 0)
        end)
    end

    if cfg.antiFling and hum then
        pcall(function()
            hum.PlatformStand = false
            hum.Sit = false
        end)
    end

    local cam = workspace.CurrentCamera
    if cam then
        cam.CFrame = _CFnew(cam.CFrame.Position, tr.Position)
    end

    tryHitBatDesync()
end

function startBatDesyncTp()
    if batDesyncTpConn then return end
    batDesyncTpEnabled = true
    _tpBatNextTick = 0
    batDesyncTpConn = RunService.Heartbeat:Connect(batDesyncTpUpdate)
    if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
    updateTpBatButtonWithAntiDie(true)
end

function stopBatDesyncTp()
    if batDesyncTpConn then
        batDesyncTpConn:Disconnect()
        batDesyncTpConn = nil
    end
    batDesyncTpEnabled = false
    if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
    updateTpBatButtonWithAntiDie(false)
end

function toggleBatDesyncTp()
    if batDesyncTpEnabled then
        stopBatDesyncTp()
        updateTpBatButtonWithAntiDie(false)
    else
        disableAllAimbots()
        if autoLeftEnabled then
            autoLeftEnabled = false; stopAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if mobSetAutoLeft then mobSetAutoLeft(false) end
        end
        if autoRightEnabled then
            autoRightEnabled = false; stopAutoRight()
            if autoRightSetVisual then autoRightSetVisual(false) end
            if mobSetAutoRight then mobSetAutoRight(false) end
        end
        startBatDesyncTp()
        updateTpBatButtonWithAntiDie(true)
    end
    if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
    saveAllSettings()
end

function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
    end
    for _, ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then
            return ch
        end
    end
    return nil
end

function isBatTool(tool)
    if not tool then return false end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        if tool.Name == name then return true end
    end
    return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end

function findBatForCounter()
    local char = LP.Character
    if not char then return nil end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local tool = char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
        if tool then return tool end
    end
    for _, child in ipairs(char:GetChildren()) do
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

function swingBatForCounter(bat, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= character and humanoid then
        pcall(function() humanoid:EquipTool(bat) end)
        task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        task.wait(0.1)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.1)
        pcall(function() bat:Activate() end)
    end
end

batCounterDebounce = false

function stopBatCounter()
    if Conns.batCounter then
        Conns.batCounter:Disconnect()
        Conns.batCounter = nil
    end
    batCounterDebounce = false
end

function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        if batCounterDebounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            batCounterDebounce = true
            _suppressBodyLock()
            task.spawn(function()
                task.wait(0.15)
                local bat = findBatForCounter()
                if bat then swingBatForCounter(bat, character) end
                task.wait(0.3)
                batCounterDebounce = false
                _unsuppressBodyLock(true)
            end)
        end
    end)
end

function findMedusa()
    local c = LP.Character
    if not c then return nil end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then return t end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then return t end
            end
        end
    end
    return nil
end

function useMedusaCounter()
    if medusaDebounce then return end
    if _tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
    local c = LP.Character
    if not c then return end
    medusaDebounce = true
    local med = findMedusa()
    if not med then medusaDebounce = false; return end
    if med.Parent ~= c then
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2:EquipTool(med) end
    end
    pcall(function() med:Activate() end)
    medusaLastUsed = _tick()
    medusaDebounce = false
end

function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusaCounter() end
    end)
end

function setupMedusaCounter(char)
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
    if not char or not medusaCounterEnabled then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end))
end

function stopMedusaCounter()
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
end

local DROP_ASCEND_DURATION = 0.22
local DROP_ASCEND_SPEED = 160
local _dropConn = nil

function stopDropBrainrot()
    dropActive = false
    if _dropConn then
        _dropConn:Disconnect()
        _dropConn = nil
    end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity = _V3zero end
    end
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
        local speedH = 0
        if root then
            local vel = root.AssemblyLinearVelocity
            speedH = _V3new(vel.X, 0, vel.Z).Magnitude
        end
        local cooldown = (speedH > 5) and 0.6 or 0.25
        if _tick() - lastDropTime < cooldown then return end
        lastDropTime = _tick()
        dropActive = true
        if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
        if mobSetDropBR then mobSetDropBR(true) end
        local wasAutoBat = false
        if autoBatEnabled then
            wasAutoBat = true
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
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
            local c = LP.Character
            if c then
                local r = c:FindFirstChild("HumanoidRootPart")
                local h = c:FindFirstChildOfClass("Humanoid")
                if r then
                    r.AssemblyLinearVelocity = _V3zero
                    r.AssemblyAngularVelocity = _V3zero
                    if r.Position.Y < -100 then
                        r.CFrame = _CFnew(r.Position.X, 5, r.Position.Z)
                    end
                    local rp = RaycastParams.new()
                    rp.FilterDescendantsInstances = {c}
                    rp.FilterType = Enum.RaycastFilterType.Exclude
                    local rr = workspace:Raycast(r.Position, _V3new(0, -2000, 0), rp)
                    if rr then
                        local off = (h and h.HipHeight or 2) + (r.Size.Y / 2)
                        r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    end
                    if h and h.Health > 0 then h:ChangeState(Enum.HumanoidStateType.Running) end
                end
            end
            if wasAutoBat then
                enableAutoBat()
                if autoBatSetVisual then autoBatSetVisual(true) end
                if mobSetAutoBat then mobSetAutoBat(true) end
            end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
        end
        local flingThread = nil
        flingThread = task.spawn(function()
            local startTime = _tick()
            while dropActive and (_tick() - startTime) < 0.25 do
                RunService.Heartbeat:Wait()
                local c = LP.Character
                local r = c and c:FindFirstChild("HumanoidRootPart")
                if not r then break end
                local vel = r.AssemblyLinearVelocity
                vel = _V3new(0, vel.Y, 0)
                r.AssemblyLinearVelocity = vel * 10000 + _V3new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if r and r.Parent then r.AssemblyLinearVelocity = vel end
                RunService.Stepped:Wait()
                if r and r.Parent then r.AssemblyLinearVelocity = vel + _V3new(0, 0.1, 0) end
            end
            finishDrop(flingThread)
        end)
        table.insert(dropConnections, flingThread)
        task.delay(0.35, function()
            if dropActive then finishDrop(flingThread) end
        end)
        return
    end
    dropActive = true
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(true) end
    local t0 = _tick()
    if _dropConn then _dropConn:Disconnect() end
    _dropConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if not dropActive then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if _tick() - t0 >= DROP_ASCEND_DURATION then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            pcall(function()
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(r.Position, _V3new(0, -3000, 0), rp)
                if rr then
                    local hum2 = c:FindFirstChildOfClass("Humanoid")
                    local off = ((hum2 and hum2.HipHeight) or 2) + (r.Size.Y / 2)
                    r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    r.AssemblyLinearVelocity = _V3zero
                    r.AssemblyAngularVelocity = _V3zero
                end
                if hum2 and hum2.Health > 0 then hum2:ChangeState(Enum.HumanoidStateType.Running) end
            end)
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        local lv = r.AssemblyLinearVelocity
        r.AssemblyLinearVelocity = _V3new(lv.X, DROP_ASCEND_SPEED, lv.Z)
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

function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1
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
        local descs = workspace:GetDescendants()
        local i = 0
        local total = #descs
        while i < total and antiLagEnabled do
            for _ = 1, 200 do
                i = i + 1
                if i > total then break end
                applyAntiLagDerender(descs[i])
            end
            task.wait()
        end
    end)
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if antiLagEnabled then applyAntiLagDerender(obj) end
    end)
end

function disableAntiLag()
    antiLagEnabled = false
    if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
end

CUSTOM_FOV_BIND = "CleanHubCustomFOV"

function enableCustomFov()
    local cam = workspace.CurrentCamera
    if cam and origFOV == nil then origFOV = cam.FieldOfView end
    fovEnabled = true
    if cam then
        pcall(function() cam.FieldOfViewMode = Enum.FieldOfViewMode.Diagonal end)
        pcall(function() cam.FieldOfView = fovValue end)
    end
    if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
    pcall(function() RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND) end)
    local prio = 200
    pcall(function() prio = Enum.RenderPriority.Camera.Value + 10 end)
    local ok = pcall(function()
        RunService:BindToRenderStep(CUSTOM_FOV_BIND, prio, function()
            if not fovEnabled then return end
            local c = workspace.CurrentCamera
            if c and c.FieldOfView ~= fovValue then
                c.FieldOfView = fovValue
            end
        end)
    end)
    if not ok then
        customFovConn = RunService.RenderStepped:Connect(function()
            if not fovEnabled then
                if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
                return
            end
            local c = workspace.CurrentCamera
            if c then c.FieldOfView = fovValue end
        end)
    end
end

function disableCustomFov()
    fovEnabled = false
    pcall(function() RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND) end)
    if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
    local cam = workspace.CurrentCamera
    if cam then
        pcall(function() cam.FieldOfViewMode = Enum.FieldOfViewMode.Vertical end)
        pcall(function() cam.FieldOfView = origFOV or 70 end)
    end
end

function applyStretchFOV(val)
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = val end) end
end

function enableStretch()
    if stretchConn then return end
    stretchEnabled = true
    local cam = workspace.CurrentCamera
    if not cam then return end
    origFOV = cam.FieldOfView or 70
    applyStretchFOV(stretchFOV)
    stretchConn = RunService.RenderStepped:Connect(function()
        if not stretchEnabled then
            stretchConn:Disconnect()
            stretchConn = nil
            return
        end
        local c = workspace.CurrentCamera
        if c then c.CFrame = c.CFrame * _CFnew(0,0,0,1,0,0,0,0.7,0,0,0,1) end
    end)
    if stretchFovConn then stretchFovConn:Disconnect() end
    stretchFovConn = RunService.RenderStepped:Connect(function()
        if stretchEnabled then applyStretchFOV(stretchFOV)
        else stretchFovConn:Disconnect(); stretchFovConn = nil end
    end)
end

function disableStretch()
    stretchEnabled = false
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = origFOV or 70 end) end
end

local function saveLightingState()
    if _originalLighting then return end
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
    for _, e in ipairs(Lighting:GetChildren()) do
        if e:IsA("ColorCorrectionEffect") then
            _originalLighting.ColorCorrection = {
                Enabled = e.Enabled,
                Brightness = e.Brightness,
                Contrast = e.Contrast,
                Saturation = e.Saturation,
                TintColor = e.TintColor,
            }
        elseif e:IsA("BloomEffect") then
            _originalLighting.Bloom = {
                Enabled = e.Enabled,
                Intensity = e.Intensity,
                Size = e.Size,
                Threshold = e.Threshold,
            }
        end
    end
end

local function restoreLightingState()
    if not _originalLighting then return end
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
        local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if cc then
            cc.Enabled = old.ColorCorrection.Enabled
            cc.Brightness = old.ColorCorrection.Brightness
            cc.Contrast = old.ColorCorrection.Contrast
            cc.Saturation = old.ColorCorrection.Saturation
            cc.TintColor = old.ColorCorrection.TintColor
        end
    end
    if old.Bloom then
        local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
        if bloom then
            bloom.Enabled = old.Bloom.Enabled
            bloom.Intensity = old.Bloom.Intensity
            bloom.Size = old.Bloom.Size
            bloom.Threshold = old.Bloom.Threshold
        end
    end
end

SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}

SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.55,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}

local function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end

function _v4mpClearSky()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute("_AdaptDuelsSky") then
            pcall(function() child:Destroy() end)
        end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute("_AdaptDuelsSky") then
                pcall(function() child:Destroy() end)
            end
        end
    end
end

function applyCustomSky(mode)
    _v4mpClearSky()
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        skyTheme = "Off"
        return
    end
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    Lighting.GlobalShadows = true
    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
    if preset.sky then
        local skyInst = Instance.new("Sky")
        skyInst:SetAttribute("_AdaptDuelsSky", true)
        if preset.sky.stars then skyInst.StarCount = preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end
        skyInst.Parent = Lighting
    end
    if preset.atm then
        local atm = Instance.new("Atmosphere")
        atm:SetAttribute("_AdaptDuelsSky", true)
        atm.Density = preset.atm.dens or 0.3
        atm.Color = _vC3(preset.atm.color)
        atm.Decay = _vC3(preset.atm.decay)
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
        clouds.Color = _vC3(preset.clouds.color)
        clouds.Parent = terrain
    end
    skyTheme = mode
end

local function applyNeonWeather()
    if not neonWeatherEnabled then
        restoreLightingState()
        return
    end
    if not _originalLighting then saveLightingState() end
    Lighting.Brightness = 3.5
    Lighting.ClockTime = 20
    Lighting.OutdoorAmbient = Color3.fromRGB(20, 40, 80)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 300
    Lighting.FogStart = 0
    Lighting.FogColor = Color3.fromRGB(0, 80, 200)
    Lighting.Ambient = Color3.fromRGB(30, 60, 120)
    local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    if not cc then
        cc = Instance.new("ColorCorrectionEffect")
        cc.Parent = Lighting
    end
    cc.Enabled = true
    cc.Brightness = 0.2
    cc.Contrast = 0.15
    cc.Saturation = 0.15
    cc.TintColor = Color3.fromRGB(180, 180, 190)
    local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
    if not bloom then
        bloom = Instance.new("BloomEffect")
        bloom.Parent = Lighting
    end
    bloom.Enabled = true
    bloom.Intensity = 0.6
    bloom.Size = 25
    bloom.Threshold = 0.8
end

function toggleNeonWeather(state)
    if state == nil then
        neonWeatherEnabled = not neonWeatherEnabled
    else
        neonWeatherEnabled = state
    end
    applyNeonWeather()
    if setNeonWeatherVisual then setNeonWeatherVisual(neonWeatherEnabled) end
end

-- Color fijo del estado ACTIVO de los botones (gris azulado de la imagen).
BTN_ACTIVE_COLOR = Color3.fromRGB(96, 102, 117)

function paintFloatingBtn(btnFrame, active)
    if not btnFrame then return end

    local bg = btnFrame:FindFirstChild("BtnGrad")
    local label = btnFrame:FindFirstChild("TextLabel")
    local stroke = btnFrame:FindFirstChildOfClass("UIStroke")

    -- Estilo: negro redondeado cuando está apagado; gris azulado cuando está activo.
    btnFrame.BackgroundColor3 = active and BTN_ACTIVE_COLOR or Color3.fromRGB(0, 0, 0)

    if bg then
        if active then
            local c = BTN_ACTIVE_COLOR
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, c),
                ColorSequenceKeypoint.new(0.50, c),
                ColorSequenceKeypoint.new(1.00, c),
            })
        else
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)),
            })
        end
    end

    if label then
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    if stroke then
        stroke.Color = active and BTN_ACTIVE_COLOR or Color3.fromRGB(55, 55, 60)
        stroke.Thickness = active and 1.5 or 1
        stroke.Transparency = 0.15
    end
end

function applyFloatingButtonScale()
    for _, uiScale in ipairs(_floatingUIScales) do
        if uiScale and uiScale.Parent then
            uiScale.Scale = floatingButtonScale
        end
    end
end

function setMobileButtonsHidden(state)
    mobileButtonsHidden = state and true or false
    if _mobilePanelContainer then
        _mobilePanelContainer.Visible = not mobileButtonsHidden
    end
    for _, gui in ipairs({tpBatFloatingButton, batBypassFloatingButton, instaResetFloatingButton}) do
        if gui then
            pcall(function() gui.Enabled = not mobileButtonsHidden end)
        end
    end
end

local function drag(f)
    local dn, ds, sp, di = false, nil, nil, nil
    local endConn = nil
    local movedThis = false
    local function stopDrag()
        local didMove = movedThis
        dn = false
        di = nil
        movedThis = false
        if endConn then
            endConn:Disconnect()
            endConn = nil
        end
        if didMove and f == main then
            _menuHomePos = main.Position
            pcall(saveAllSettings)
        elseif didMove then
            pcall(saveAllSettings)
        end
    end
    f.InputBegan:Connect(function(i)
        if uiLocked then return end
        if _isDraggingButton then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dn = true; ds = i.Position; sp = f.Position
            movedThis = false
            if endConn then endConn:Disconnect() end
            endConn = i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then stopDrag() end
            end)
        end
    end)
    f.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    f.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == di and dn then
            if uiLocked then stopDrag(); return end
            if _isDraggingButton then return end
            if not ds or not sp then return end
            local nX = sp.X.Offset + (i.Position.X - ds.X)
            local nY = sp.Y.Offset + (i.Position.Y - ds.Y)
            f.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY)
            movedThis = true
        end
    end)
end

function setupMovementAndIndicators(char)
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end

    local ccAcc = 0
    steppedConn = RunService.Heartbeat:Connect(function(dt)
        ccAcc = ccAcc + dt
        if ccAcc < 0.05 then return end
        ccAcc = 0
        local plist = _GetPlayersCached()
        for i = 1, #plist do
            local p = plist[i]
            if p ~= LP then
                local ch = p.Character
                if ch then
                    local parts = ch:GetChildren()
                    for j = 1, #parts do
                        local part = parts[j]
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
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

        if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled
           and not autoBatBypassEnabled and not batDesyncTpEnabled then
            if _isRagdollState(hum) then
                lastMoveDir = _V3zero
            else
                local md = hum.MoveDirection
                local spd = getActiveMoveSpeed()
                local dir = nil
                if md.Magnitude > 0 then
                    lastMoveDir = md
                    dir = md
                elseif lastMoveDir.Magnitude > 0 then
                    for key in pairs(MOVE_KEYS) do
                        if UIS:IsKeyDown(key) then dir = lastMoveDir; break end
                    end
                end
                _applyVelocitySpeed(dir, spd, hrp)
            end
        end

        if speedLabel then
            local v = hrp.AssemblyLinearVelocity
            local s = _sqrt(v.X*v.X + v.Z*v.Z)
            if s < 0.05 then s = 0 end
            speedLabel.Text = "Speed: " .. string.format("%.1f", s)
        end
    end)
    setupSpeedIndicator(char)
    startEnemySpeed()
end

function toggleLockUI(state)
    if state == nil then uiLocked = not uiLocked else uiLocked = state end
    if uiLocked and editModeEnabled then
        editModeEnabled = false
        if setEditModeVisual then setEditModeVisual(false) end
    end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
end

function toggleEditMode(state)
    if state == nil then state = not editModeEnabled end
    if state and uiLocked then state = false end
    editModeEnabled = state
    if setEditModeVisual then setEditModeVisual(editModeEnabled) end
end

function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
    if batDesyncTpEnabled then stopBatDesyncTp() end
    if autoBatBypassEnabled then
        disableBatBypass()
        if autoBatBypassSetVisual then autoBatBypassSetVisual(false) end
        if batBypassFloatingButton then
            local btnFrame = batBypassFloatingButton:FindFirstChild("Frame")
            if btnFrame then paintFloatingBtn(btnFrame, false) end
        end
    end
end

function stopAllBackgroundTasks()
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    stopEnemySpeed()
    if stretchEnabled then disableStretch() end
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    if antiDieEnabled then AntiDieModule.stop() end
    if antiFlingEnabled then AntiFlingModule.stop() end
    stopBatCounter()
    stopMedusaCounter()
    stopAutoSteal()
    disableAutoBat()
    if batDesyncTpEnabled then stopBatDesyncTp() end
    if autoBatBypassEnabled then disableBatBypass() end
    stopAutoLeft()
    stopAutoRight()
    if antiLagEnabled then disableAntiLag() end
    if espEnabled then toggleESP(false) end
    if dropActive then stopDropBrainrot() end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    dropActive = false
    alPhase = 1
    arPhase = 1
    lastDropTime = 0
    medusaDebounce = false
    medusaLastUsed = 0
end

function buildConfigTable()
    local config = {
        normalSpeed = NS,
        carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED,
        laggerSpeed2 = LAGGER_CARRY_SPEED,
        stealRadius = CONFIG.STEAL_RANGE,
        antiRagdollMode = antiRagdollMode,
        infiniteJumpEnabled = InfiniteJump.enabled == true,
        antiDieEnabled = antiDieEnabled,
        antiFlingEnabled = antiFlingEnabled,
        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
        medusaCounter = medusaCounterEnabled,
        batCounter = batCounterEnabled,
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
        tabPosition = _G._StrikeTabPosition or "Up",
        customToolsEnabled = _G.AmbitiousCustomToolsEnabled == true,
        customToolSkins = _G.AmbitiousCustomToolSkins,
        espEnabled = espEnabled,
        espBoxEnabled = espBoxEnabled,
        espTrackerEnabled = espTrackerEnabled,
        ragdollCountdownEnabled = ragdollCountdownEnabled,
        antiTpEspEnabled = antiTpEspEnabled,
        antiLag = antiLagEnabled,
        tpBatEnabled = batDesyncTpEnabled,
        tpBatMode = tpBatMode,
        neonWeather = neonWeatherEnabled,
        skyTheme = skyTheme,
        autoBatBypassEnabled = autoBatBypassEnabled,
        mobileButtonPositions = savedButtonPositions,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        tpBatKey = {kb = KB.TPBat.kb and KB.TPBat.kb.Name, gp = KB.TPBat.gp and KB.TPBat.gp.Name},
        batBypassKey = {kb = KB.BatBypass.kb and KB.BatBypass.kb.Name, gp = KB.BatBypass.gp and KB.BatBypass.gp.Name},
        instaResetKey = {kb = KB.InstaReset.kb and KB.InstaReset.kb.Name, gp = KB.InstaReset.gp and KB.InstaReset.gp.Name},
        tpBatFloatingPos = tpBatFloatingPos,
        batBypassFloatingPos = batBypassFloatingPos,
        instaResetFloatingPos = instaResetFloatingPos,
        progressBarPos = savedProgressBarPos,
        lockUI = uiLocked,
        editMode = editModeEnabled,
        backgroundIndex = backgroundIndex,
        backgroundImageTransparency = backgroundImageTransparency,
        floatingButtonScale = floatingButtonScale,
        hideMobileButtons = mobileButtonsHidden,
        stealBarScale = stealBarScale,
        themeColor = currentColorTheme,
        useCarrySystem = useCarrySystem,
        carrySysNormal = CarrySystem.normalSpeed,
        carrySysCarry = CarrySystem.carrySpeed,
        carrySysLagger = CarrySystem.laggerSpeed,
        carrySysLaggerCarry = CarrySystem.laggerCarrySpeed,
        carrySysSoftStealSpeed = CarrySystem.softStealSpeed,
        carrySysSoftStealRadius = CarrySystem.softStealRadius,
        autoCarrySpeedEnabled = autoCarrySpeedEnabled == true,
        autoCarryEnemyBaseEnabled = autoCarryEnemyBaseEnabled == true,
        autoCarryEnemyBaseRange = tonumber(autoCarryEnemyBaseRange) or 35,
        introSong = INTRO_SONG,
        skipIntro = SKIP_INTRO == true,
    }
    if pbFrame then
        config.progressBarPos = {
            XScale = pbFrame.Position.X.Scale,
            XOffset = pbFrame.Position.X.Offset,
            YScale = pbFrame.Position.Y.Scale,
            YOffset = pbFrame.Position.Y.Offset
        }
    end
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        config.mobilePanelPos = {
            XScale = container.Position.X.Scale,
            XOffset = container.Position.X.Offset,
            YScale = container.Position.Y.Scale,
            YOffset = container.Position.Y.Offset
        }
    end
    if main then
        config.menuPos = {
            XScale = main.Position.X.Scale,
            XOffset = main.Position.X.Offset,
            YScale = main.Position.Y.Scale,
            YOffset = main.Position.Y.Offset
        }
    end
    return config
end

function saveAllSettings()
    if _isResetting then return true end
    local config = buildConfigTable()
    local json = HS:JSONEncode(config)
    if json == _lastSavedJSON then return true end
    local success, err = pcall(function() writefile(CONFIG_FILE, json) end)
    if success then _lastSavedJSON = json end
    return success
end
-- Alias: el motor de Custom Tools llama a saveAmbitiousConfig al cambiar skin
saveAmbitiousConfig = saveAllSettings

function loadAllSettings()
    if not isfile or not isfile(CONFIG_FILE) then return false end
    local success, data = pcall(function() return HS:JSONDecode(readfile(CONFIG_FILE)) end)
    if not success or not data then return false end
    _isLoading = true
    NS = data.normalSpeed or NS
    CS = data.carrySpeed or CS
    LAGGER_SPEED = data.laggerSpeed1 or LAGGER_SPEED
    LAGGER_CARRY_SPEED = data.laggerSpeed2 or LAGGER_CARRY_SPEED
    CONFIG.STEAL_RANGE = data.stealRadius or CONFIG.STEAL_RANGE
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if data.lockUI == nil then
        uiLocked = true
    else
        uiLocked = data.lockUI == true
    end
    editModeEnabled = data.editMode or false
    if data.antiRagdollMode == "v1" or data.antiRagdollMode == "v2" then
        antiRagdollMode = data.antiRagdollMode
    else
        antiRagdollMode = data.antiRagdoll and "v2" or "off"
    end
    infiniteJumpEnabled = data.infiniteJumpEnabled ~= false
    if infiniteJumpEnabled then InfiniteJump.start() else InfiniteJump.stop() end
    antiDieEnabled = data.antiDieEnabled or false
    antiFlingEnabled = data.antiFlingEnabled or false
    if antiFlingEnabled then AntiFlingModule.start() else AntiFlingModule.stop() end
    CONFIG.AUTO_STEAL_ENABLED = data.autoSteal or false
    medusaCounterEnabled = data.medusaCounter or false
    batCounterEnabled = data.batCounter or false
    antiLagEnabled = data.antiLag or false
    laggerToggled = data.laggerToggled or false
    speedMode = data.carryMode or false
    laggerCarryToggled = data.laggerCarryToggled or false

    autoCarrySpeedEnabled = data.autoCarrySpeedEnabled == true
    autoCarryEnemyBaseEnabled = data.autoCarryEnemyBaseEnabled == true
    if type(data.autoCarryEnemyBaseRange) == "number" then
        autoCarryEnemyBaseRange = math.clamp(math.floor(data.autoCarryEnemyBaseRange), 5, 150)
    end

    if type(data.introSong) == "string" then
        for _, name in ipairs(INTRO_SONG_ORDER) do
            if name == data.introSong then INTRO_SONG = name break end
        end
    end
    SKIP_INTRO = data.skipIntro == true

    uiScaleValue = data.uiScale or 82
    if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
    if data.menuPos and type(data.menuPos) == "table" then
        local mp = data.menuPos
        -- Clamp estricto: el menú completo debe quedar dentro del viewport.
        local cam = workspace and workspace.CurrentCamera
        local vp = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
        local scale = (mainUIScale and mainUIScale.Scale and mainUIScale.Scale > 0) and mainUIScale.Scale or 1
        local menuW = 345 * scale
        local menuH = 500 * scale
        local margin = 8
        local xs = mp.XScale or 0
        local ys = mp.YScale or 0
        local xo = mp.XOffset or 0
        local yo = mp.YOffset or 0
        local x = xs * vp.X + xo
        local y = ys * vp.Y + yo
        x = math.clamp(x, margin, math.max(margin, vp.X - menuW - margin))
        y = math.clamp(y, margin, math.max(margin, vp.Y - menuH - margin))
        _menuHomePos = UDim2.new(0, math.floor(x + 0.5), 0, math.floor(y + 0.5))
        if main then pcall(function() main.Position = _menuHomePos end) end
    end
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
        task.defer(function()
            updateAllUIThemeColors(selectedColor)
            if colorSelectorLabel then
                colorSelectorLabel.Text = currentColorTheme
                colorSelectorLabel.TextColor3 = selectedColor
            end
        end)
    end
    autoBatBypassEnabled = data.autoBatBypassEnabled or false
    if autoBatBypassEnabled then
        task.defer(function()
            enableBatBypass()
            if autoBatBypassSetVisual then autoBatBypassSetVisual(true) end
        end)
    else
        if autoBatBypassSetVisual then autoBatBypassSetVisual(false) end
    end
    if data.tpBatMode == "v1" or data.tpBatMode == "v2" then
        tpBatMode = data.tpBatMode
    end
    if updateTpBatModeUI then updateTpBatModeUI(tpBatMode) end
    local tpBatStateLoaded = data.tpBatEnabled or false
    if tpBatStateLoaded then
        task.defer(function()
            startBatDesyncTp()
            if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
            updateTpBatButtonWithAntiDie(true)
        end)
    else
        if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
        updateTpBatButtonWithAntiDie(false)
    end
    skyTheme = data.skyTheme or "Off"
    if skyTheme ~= "Off" then pcall(applyCustomSky, skyTheme) end
    if skySelectorLabel then skySelectorLabel.Text = skyTheme end
    neonWeatherEnabled = data.neonWeather or false
    if neonWeatherEnabled then
        task.defer(function() toggleNeonWeather(true) end)
    else
        toggleNeonWeather(false)
        skyTheme = "Off"
        pcall(applyCustomSky, "Off")
        if skySelectorLabel then skySelectorLabel.Text = "Off" end
    end
    -- Custom Tools: restaurar skins elegidas y el estado del toggle
    if data.customToolSkins and type(data.customToolSkins) == "table" then
        _G.AmbitiousCustomToolSkins = _G.AmbitiousCustomToolSkins or {}
        for k, v in pairs(data.customToolSkins) do
            _G.AmbitiousCustomToolSkins[k] = v
        end
    end
    _customToolsEnabledLoaded = data.customToolsEnabled == true
    -- Tab Position: restaurar la posición guardada de la barra de pestañas
    do
        local tp = data.tabPosition
        if tp == "Up" or tp == "Bottom" or tp == "Left" or tp == "Right" then
            _G._StrikeTabPosition = tp
        else
            _G._StrikeTabPosition = "Up"
        end
    end
    local function lk(e, d)
        if not d then return end
        if d.kb and Enum.KeyCode[d.kb] then e.kb = Enum.KeyCode[d.kb] end
        if d.gp and Enum.KeyCode[d.gp] then e.gp = Enum.KeyCode[d.gp] end
    end
    lk(KB.DropBrainrot, data.dropBrainrotKey)
    lk(KB.AutoLeft, data.autoLeftKey)
    lk(KB.AutoRight, data.autoRightKey)
    lk(KB.AutoBat, data.autoBatKey)
    lk(KB.TPFloor, data.tpFloorKey)
    lk(KB.CarryToggle, data.carryToggleKey)
    lk(KB.LaggerMode, data.laggerModeKey)
    lk(KB.TPBat, data.tpBatKey)
    lk(KB.BatBypass, data.batBypassKey)
    lk(KB.InstaReset, data.instaResetKey)
    if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    if data.tpBatFloatingPos then tpBatFloatingPos = data.tpBatFloatingPos end
    if data.batBypassFloatingPos then batBypassFloatingPos = data.batBypassFloatingPos end
    if data.instaResetFloatingPos then
        instaResetFloatingPos = data.instaResetFloatingPos
        -- Migra la posición antigua para que el nuevo valor predeterminado quede debajo de BAT BYPASS.
        if (instaResetFloatingPos.XOffset or 0) == 135 and (instaResetFloatingPos.YOffset or 0) == 110 then
            instaResetFloatingPos.XOffset = -80
            instaResetFloatingPos.YOffset = 178
        end
    end
    if data.progressBarPos then
        savedProgressBarPos = data.progressBarPos
        -- Migra el antiguo predeterminado de Auto Grab hacia la derecha.
        if (savedProgressBarPos.XOffset or 0) == 180 and (savedProgressBarPos.YOffset or 0) == -80 then
            savedProgressBarPos.XOffset = 300
        end
    end
    dropMode = data.dropMode or 1
    stretchEnabled = data.stretchEnabled or false
    fovValue = data.fovValue or 70
    fovEnabled = data.fovEnabled or false
    if fovSliderSet then fovSliderSet(fovValue) end
    if fovEnabled then enableCustomFov() end
    if setFovVisual then setFovVisual(fovEnabled) end
    stretchFOV = data.stretchFOV or 120
    BAT_AIMBOT_SPEED = data.batAimbotSpeed or BAT_AIMBOT_SPEED
    backgroundIndex = data.backgroundIndex or 1
    backgroundImageTransparency = data.backgroundImageTransparency or 0
    floatingButtonScale = data.floatingButtonScale or 1
    mobileButtonsHidden = data.hideMobileButtons or false
    setMobileButtonsHidden(mobileButtonsHidden)
    if hideMobileBtnsSetVisual then hideMobileBtnsSetVisual(mobileButtonsHidden) end
    stealBarScale = data.stealBarScale or 0.45
    if pbScale then pbScale.Scale = stealBarScale end

    useCarrySystem = data.useCarrySystem or false
    CarrySystem.normalSpeed = data.carrySysNormal or NS
    CarrySystem.carrySpeed = data.carrySysCarry or CS
    CarrySystem.laggerSpeed = data.carrySysLagger or LAGGER_SPEED
    CarrySystem.laggerCarrySpeed = data.carrySysLaggerCarry or LAGGER_CARRY_SPEED
    CarrySystem.softStealSpeed = data.carrySysSoftStealSpeed or 30
    CarrySystem.softStealRadius = data.carrySysSoftStealRadius or 10
    if useCarrySystem then
        CarrySystem:start()
        CarrySystem.speedToggled = speedMode
        if laggerToggled then
        else
            CarrySystem:setLaggerMode(0)
        end
    else
        CarrySystem:stop()
    end

    autoBatEnabled = false
    autoLeftEnabled = false
    autoRightEnabled = false
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    refreshSpeedModeLabel()
    _lastSavedJSON = HS:JSONEncode(buildConfigTable())
    _isLoading = false
    return true
end

function forceResetUI()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if uiScaleStepperSet then uiScaleStepperSet(uiScaleValue) end
    if floatScaleStepperSet then floatScaleStepperSet(floatingButtonScale) end
    if stealBarStepperSet then stealBarStepperSet(stealBarScale) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if carrySysNormalBox then carrySysNormalBox.Text = tostring(CarrySystem.normalSpeed) end
    if carrySysCarryBox then carrySysCarryBox.Text = tostring(CarrySystem.carrySpeed) end
    if carrySysLaggerBox then carrySysLaggerBox.Text = tostring(CarrySystem.laggerSpeed) end
    if carrySysLaggerCarryBox then carrySysLaggerCarryBox.Text = tostring(CarrySystem.laggerCarrySpeed) end
    if carrySysSoftStealSpeedBox then carrySysSoftStealSpeedBox.Text = tostring(CarrySystem.softStealSpeed) end
    if carrySysSoftStealRadiusBox then carrySysSoftStealRadiusBox.Text = tostring(CarrySystem.softStealRadius) end
    if carrySystemToggleSetter then carrySystemToggleSetter(useCarrySystem) end
    local function safeSet(fn, val) if fn then fn(val) end end
    safeSet(autoBatSetVisual, false)
    safeSet(autoLeftSetVisual, false)
    safeSet(autoRightSetVisual, false)
    safeSet(setBatCounterVisual, false)
    safeSet(setMedusaVisual, false)
    safeSet(setAntiLagVisual, false)
    safeSet(setLockUIVisual, false)
    safeSet(setEditModeVisual, false)
    safeSet(setInstaGrab, false)
    safeSet(batDesyncTpSetVisual, false)
    safeSet(setESPVIsual, false)
    safeSet(setNeonWeatherVisual, false)
    safeSet(autoBatBypassSetVisual, false)
    safeSet(setAntiDieVisual, false)
    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    safeSet(mobSetAutoBat, false)
    safeSet(mobSetAutoLeft, false)
    safeSet(mobSetAutoRight, false)
    safeSet(mobSetDropBR, false)
    safeSet(mobSetTpDown, false)
    safeSet(mobSetCarry, false)
    safeSet(mobSetLagger1, false)
    safeSet(mobSetLagger2, false)
    refreshSpeedModeLabel()
    updateProgressBarVisibility()
    disableAntiLag()
    toggleNeonWeather(false)
    skyTheme = "Off"
    pcall(applyCustomSky, "Off")
    if skySelectorLabel then skySelectorLabel.Text = "Off" end
    disableBatBypass()
    if antiDieEnabled then
        AntiDieModule.stop()
        antiDieEnabled = false
    end
    if antiFlingEnabled then
        AntiFlingModule.stop()
        antiFlingEnabled = false
    end
    updateTpBatButtonWithAntiDie(false)
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end
    currentColorTheme = "Gris"
    selectedColor = COLOR_THEMES["Gris"]
    if colorSelectorLabel then
        colorSelectorLabel.Text = "Gris"
        colorSelectorLabel.TextColor3 = selectedColor
    end
    updateAllUIThemeColors(selectedColor)
    if miniBtn then miniBtn.TextColor3 = selectedColor end
    local pGui = LP:FindFirstChild("PlayerGui")
    if pGui then
        local bb = pGui:FindFirstChild("RagCountdownBillboard")
        if bb then
            local lbl = bb:FindFirstChildOfClass("TextLabel")
            if lbl then lbl.TextColor3 = selectedColor end
        end
    end
    if MobilePanel then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        if container then
            local btnContainer = container:FindFirstChild("ButtonsContainer")
            if btnContainer then
                for _, btn in ipairs(btnContainer:GetChildren()) do
                    if btn:IsA("TextButton") then
                        local label = btn:FindFirstChildOfClass("TextLabel")
                        if label then
                            local isActive = btn.BackgroundColor3 == selectedColor
                            if not isActive then label.TextColor3 = selectedColor end
                        end
                    end
                end
            end
        end
    end
    saveAllSettings()
end

function resetFloatingPositions()
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        container.Position = UDim2.new(1, -150, 0, 16)
        savedButtonPositions = {}
        if container:FindFirstChild("ButtonsContainer") then
            for _, btn in ipairs(container.ButtonsContainer:GetChildren()) do
                if btn:IsA("TextButton") and btn.Name then
                    local defX, defY = getDefaultButtonPosition(btn.Name)
                    btn.Position = UDim2.new(0, defX, 0, defY)
                end
            end
        end
    end
    if tpBatFloatingButton and tpBatFloatingButton:FindFirstChild("Frame") then
        local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(1, -228, 0, 16)
        tpBatFloatingPos = nil
    end
    if batBypassFloatingButton and batBypassFloatingButton:FindFirstChild("Frame") then
        local btnFrame = batBypassFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(1, -228, 0, 94)
        batBypassFloatingPos = nil
    end
    if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
        instaResetFloatingButton.Frame.Position = UDim2.new(0.5, -80, 0, 178)
        instaResetFloatingPos = nil
    end
    if pbFrame then
        pbFrame.Position = UDim2.new(0, 300, 1, -80)
        savedProgressBarPos = nil
    end
    savedMobilePanelPos = nil
    tpBatFloatingPos = nil
    batBypassFloatingPos = nil
end

function resetToFactoryDefaults()
    _isResetting = true
    local ok, err = pcall(function()
        stopAllBackgroundTasks()
        stopAutoSteal()
        stopBatCounter()
        stopMedusaCounter()
        if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
        if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
        if antiDieEnabled then AntiDieModule.stop() end
        disableAutoBat()
        if batDesyncTpEnabled then stopBatDesyncTp() end
        disableBatBypass()
        if espEnabled then toggleESP(false) end
        if stretchEnabled then disableStretch() end
        if antiLagEnabled then disableAntiLag() end
        if dropActive then stopDropBrainrot() end
        toggleNeonWeather(false)
        skyTheme = "Off"
        pcall(applyCustomSky, "Off")
        if skySelectorLabel then skySelectorLabel.Text = "Off" end
        if antiDieEnabled then
            AntiDieModule.stop()
            antiDieEnabled = false
        end
        NS = 60
        CS = 29
        LAGGER_SPEED = 15
        LAGGER_CARRY_SPEED = 24.5
        CONFIG.STEAL_RANGE = 61
        speedMode = false
        laggerToggled = false
        laggerCarryToggled = false
        antiRagdollMode = "off"
        antiDieEnabled = false
        medusaCounterEnabled = false
        batCounterEnabled = false
        autoBatEnabled = false
        autoLeftEnabled = false
        autoRightEnabled = false
        antiLagEnabled = false
        uiLocked = false
        editModeEnabled = false
        CONFIG.AUTO_STEAL_ENABLED = false
        BAT_AIMBOT_SPEED = 58
        dropMode = 1
        stretchEnabled = false
        stretchFOV = 120
        fovValue = 70
        disableCustomFov()
        if fovSliderSet then fovSliderSet(70) end
        if setFovVisual then setFovVisual(false) end
        uiScaleValue = 78
        stealBarScale = 0.45
        if mainUIScale then mainUIScale.Scale = 0.78 end
        if pbScale then pbScale.Scale = stealBarScale end
        espEnabled = false
        espBoxEnabled = false
        espTrackerEnabled = false
        ragdollCountdownEnabled = true
        antiTpEspEnabled = false
        autoBatBypassEnabled = false
        backgroundIndex = 1
        backgroundImageTransparency = 0
        floatingButtonScale = 1
        if batDesyncTpEnabled then stopBatDesyncTp() end
        currentColorTheme = "Gris"
        selectedColor = COLOR_THEMES["Gris"]
        for key, val in pairs(DEFAULT_KB) do
            if KB[key] then
                KB[key].kb = val.kb
                KB[key].gp = val.gp
            end
        end
        useCarrySystem = false
        CarrySystem:stop()
        CarrySystem.normalSpeed = NS
        CarrySystem.carrySpeed = CS
        CarrySystem.laggerSpeed = LAGGER_SPEED
        CarrySystem.laggerCarrySpeed = LAGGER_CARRY_SPEED
        CarrySystem.softStealSpeed = 30
        CarrySystem.softStealRadius = 10
        CarrySystem.speedToggled = false
        CarrySystem.laggerMode = 0
        CarrySystem.softStealEnabled = false
        if isfile and isfile(CONFIG_FILE) then
            pcall(delfile, CONFIG_FILE)
        end
        resetFloatingPositions()
        forceResetUI()
        updateProgressBarVisibility()
        refreshSpeedModeLabel()
        _lastSavedJSON = nil
        saveAllSettings()
    end)
    _isResetting = false
    if not ok then warn("[resetToFactoryDefaults]", err) end
    return ok
end

function updateProgressBarVisibility()
    if pbFrame then pbFrame.Visible = CONFIG.AUTO_STEAL_ENABLED end
end

function applyShimmerToText(obj, speed)
    speed = speed or 0.8
    local color = Color3.fromRGB(210,210,215)
    local grad = Instance.new("UIGradient", obj)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(235,235,240)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(235,235,240)),
        ColorSequenceKeypoint.new(1, color),
    })
    grad.Rotation = 45
    grad.Offset = Vector2.new(0,0)
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

function getDefaultButtonPosition(btnName)
    local BTN_W, BTN_H = 60, 60
    local GAP = 8
    local orderMap = {
        DropBR = 0, AutoLeft = 1, AutoBat = 2, AutoRight = 3,
        TpDown = 4, Carry = 5, Lagger1 = 6, Lagger2 = 7
    }
    local order = orderMap[btnName] or 0
    local row = _floor(order / 2)
    local col = order % 2
    return col * (BTN_W + GAP), row * (BTN_H + GAP + 10)
end

-- ============================================================
-- INSTA RESET MODULE
-- ============================================================
do
    print("[IR] 1. inicio")

    if _G.InstaResetLoaded then
        print("[IR] ya cargado")
    else
        _G.InstaResetLoaded = true

        local resetCooldown          = false
        local resetThread            = nil
        local currentResetChar       = nil
        local resetSuccessful        = false
        local stopResetSequence      = false
        local cameraLocked           = false
        local lockedCameraCFrame     = nil
        local _lastInstaResetRequest = 0

        print("[IR] 2. servicios OK, LP =", LP and LP.Name)

        local function instaResetFast()
            if resetCooldown then return end
            resetCooldown     = true
            resetSuccessful   = false
            stopResetSequence = false
            cameraLocked      = false

            local character = LP.Character
            if not character then resetCooldown = false return end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then resetCooldown = false return end

            local cam = workspace.CurrentCamera
            if cam then
                lockedCameraCFrame = cam.CFrame
                cameraLocked       = true
                cam.CFrame         = lockedCameraCFrame
            end

            currentResetChar = character
            local isRespawning = false

            resetThread = task.spawn(function()
                local attempts          = 0
                local maxAttempts       = 40
                local originalHipHeight = humanoid.HipHeight

                while character and character.Parent and humanoid and humanoid.Health > 0
                      and not isRespawning and not stopResetSequence do
                    if LP.Character ~= character then
                        isRespawning = true
                        break
                    end
                    pcall(function()
                        humanoid.HipHeight  = 1e30
                        humanoid.AutoRotate = true
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if rootPart then rootPart.CanCollide = false end
                        for _, part in ipairs(character:GetChildren()) do
                            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                part.CanCollide = false
                            end
                        end
                    end)

                    if not character or not character.Parent or not humanoid
                       or humanoid.Health <= 0 or LP.Character ~= character then
                        resetSuccessful = true
                        break
                    end

                    attempts = attempts + 1
                    if attempts >= maxAttempts then break end
                    task.wait(0.05)
                end

                if not resetSuccessful then
                    if character and character.Parent and humanoid
                       and humanoid.Health > 0 and not isRespawning then
                        pcall(function() humanoid.Health = 0 end)
                        task.wait(0.1)
                        if not character.Parent or humanoid.Health <= 0 then
                            resetSuccessful = true
                        end
                    end
                end

                if not resetSuccessful and character and character.Parent and humanoid then
                    pcall(function()
                        humanoid.HipHeight = originalHipHeight
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if rootPart then rootPart.CanCollide = true end
                        for _, part in ipairs(character:GetChildren()) do
                            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                part.CanCollide = true
                            end
                        end
                    end)
                end

                cameraLocked      = false
                resetCooldown     = false
                resetThread       = nil
                currentResetChar  = nil
                stopResetSequence = false
            end)
        end

        local function instaReset()
            local now = os.clock()
            if now - _lastInstaResetRequest < 0.75 then return end
            _lastInstaResetRequest = now
            instaResetFast()
        end

        print("[IR] 3. función lista")

        LP.CharacterAdded:Connect(function()
            stopResetSequence = true
            if resetThread then pcall(task.cancel, resetThread); resetThread = nil end
            resetCooldown    = false
            currentResetChar = nil
            cameraLocked     = false
        end)

        task.spawn(function()
            while true do
                task.wait(0.016)
                local cam = workspace.CurrentCamera
                if cameraLocked and lockedCameraCFrame and cam then
                    cam.CFrame = lockedCameraCFrame
                end
            end
        end)

        print("[IR] 4. loop cámara iniciado")

        _G.InstaReset = { Trigger = instaReset }
    end
end

function buildGui()
    local SILVER = Color3.fromRGB(180, 180, 190)
    local SILVER_DARK = Color3.fromRGB(100, 100, 110)
    local SILVER_LIGHT = Color3.fromRGB(220, 220, 230)
    local BG = Color3.fromRGB(0,0,0)
    local BG2 = Color3.fromRGB(10,10,10)
    local ROW_BG = Color3.fromRGB(10,10,10)
    local ROW_BORDER = Color3.fromRGB(50,50,50)
    local WHITE = Color3.fromRGB(255,255,255)
    local GRAY = Color3.fromRGB(60,60,60)
    local INP = Color3.fromRGB(15,15,15)
    local OFF = Color3.fromRGB(25,25,30)
    local TAB_ACTIVE = SILVER
    local TAB_INACT = SILVER_DARK
    local SECT_LBL = SILVER
    local HOV = Color3.fromRGB(25,25,25)
    local DOT_ON = SILVER
    local ON_COLOR = SILVER
    local STROKE_COLOR = Color3.fromRGB(50,50,50)
    local GUI_W, GUI_H = 345, 500

    local old = game:GetService("CoreGui"):FindFirstChild("BloodHounds")
    if old then old:Destroy() end
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then local o = pg:FindFirstChild("BloodHounds"); if o then o:Destroy() end end

    gui = Instance.new("ScreenGui")
    gui.Name = "STRIKE"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local guiOk = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not guiOk then gui.Parent = LP:WaitForChild("PlayerGui") end

    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    main.Position = UDim2.new(0, 20, 0, 2)
    main.BackgroundColor3 = BG
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

    local bgImage = Instance.new("ImageLabel", main)
    bgImage.Name = "BackgroundImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
    bgImage.ImageTransparency = backgroundImageTransparency
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 0
    bgImage.ClipsDescendants = true
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 18)

    mainUIScale = Instance.new("UIScale", main)
    mainUIScale.Scale = uiScaleValue / 100

    -- Título superior estilo referencia: grande, centrado y separado de las pestañas.
    local titleFrame = Instance.new("Frame", main)
    titleFrame.Size = UDim2.new(1, -36, 0, 74)
    titleFrame.Position = UDim2.new(0, 18, 0, 1)
    titleFrame.BackgroundTransparency = 1
    titleFrame.ZIndex = 20

    local titleLabel = Instance.new("ImageLabel", titleFrame)
    titleLabel.Name = "StrikeTitle"
    titleLabel.Size = UDim2.new(1, 24, 1, 12)
    titleLabel.Position = UDim2.new(0, -14, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Image = "rbxassetid://131245088777209"
    titleLabel.ScaleType = Enum.ScaleType.Fit
    titleLabel.ImageTransparency = 0
    titleLabel.ZIndex = 21
    titleLabel.Visible = true

    -- FAST START: cede the thread once the STRIKE shell exists so Roblox
    -- can render the menu immediately. The rest of buildGui continues on
    -- the next scheduler step without changing any UI/functionality.
    task.wait()

    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -42, 0, 8)
    closeBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
    closeBtn.BackgroundTransparency = 0.6
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "−"
    closeBtn.TextColor3 = WHITE
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 26
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

    -- >>> TAB POSITION: botón al lado izquierdo del botón de minimizar <<<
    local tabPosBtn = Instance.new("TextButton", main)
    tabPosBtn.Size = UDim2.new(0, 32, 0, 32)
    tabPosBtn.Position = UDim2.new(1, -80, 0, 8)
    tabPosBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
    tabPosBtn.BackgroundTransparency = 0.6
    tabPosBtn.BorderSizePixel = 0
    tabPosBtn.Text = "UI"
    tabPosBtn.TextColor3 = WHITE
    tabPosBtn.Font = Enum.Font.GothamBold
    tabPosBtn.TextSize = 13
    tabPosBtn.AutoButtonColor = false
    tabPosBtn.ZIndex = 200
    Instance.new("UICorner", tabPosBtn).CornerRadius = UDim.new(0, 8)
    tabPosBtn.MouseEnter:Connect(function()
        TS:Create(tabPosBtn, TweenInfo.new(0.12), {TextColor3 = WHITE, BackgroundColor3 = getThemeColor()}):Play()
    end)
    tabPosBtn.MouseLeave:Connect(function()
        TS:Create(tabPosBtn, TweenInfo.new(0.12), {TextColor3 = WHITE, BackgroundColor3 = Color3.fromRGB(30,30,35)}):Play()
    end)

    -- Cada vez que se presiona, pasa a la siguiente posición (sin menúsito).
    local tabPosOrder = {"Up", "Bottom", "Left", "Right"}
    tabPosBtn.MouseButton1Click:Connect(function()
        local cur = _G._StrikeTabPosition or "Up"
        local idx = 1
        for i, v in ipairs(tabPosOrder) do
            if v == cur then idx = i break end
        end
        local nextPos = tabPosOrder[(idx % #tabPosOrder) + 1]
        if _G.StrikeApplyTabPosition then _G.StrikeApplyTabPosition(nextPos) end
        if saveAllSettings then saveAllSettings() end
    end)

    closeBtn.MouseEnter:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = WHITE, BackgroundColor3 = getThemeColor()}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = WHITE, BackgroundColor3 = Color3.fromRGB(30,30,35)}):Play()
    end)

    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Size = UDim2.new(0, 140, 0, 36)
    miniBtn.Position = UDim2.new(0, 16, 0, 58)
    miniBtn.BackgroundColor3 = BG2
    miniBtn.BackgroundTransparency = 0
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = ""
    miniBtn.TextColor3 = selectedColor
    miniBtn.Font = Enum.Font.GothamBold
    miniBtn.TextSize = 12
    miniBtn.ZIndex = 20

    local miniStrikeImage = Instance.new("ImageLabel", miniBtn)
    miniStrikeImage.Name = "StrikeMiniImage"
    miniStrikeImage.Size = UDim2.new(1, -10, 1, -10)
    miniStrikeImage.Position = UDim2.new(0, 5, 0, 5)
    miniStrikeImage.BackgroundTransparency = 1
    miniStrikeImage.Image = "rbxassetid://131245088777209"
    miniStrikeImage.ScaleType = Enum.ScaleType.Fit
    miniStrikeImage.ImageTransparency = 0
    miniStrikeImage.ZIndex = miniBtn.ZIndex + 1
    miniBtn.Visible = false
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 8)
    applyShimmerToText(miniBtn, 0.9)

    local slideTween = nil
    if _menuHomePos then pcall(function() main.Position = _menuHomePos end) end
    local function getSafeMenuPos()
        if not main then return UDim2.new(0, 20, 0, 20) end

        local cam = workspace.CurrentCamera
        local vp = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
        local scale = 1
        if mainUIScale and mainUIScale.Scale and mainUIScale.Scale > 0 then
            scale = mainUIScale.Scale
        end

        local w = GUI_W * scale
        local h = GUI_H * scale
        local margin = 8
        local maxX = math.max(margin, vp.X - w - margin)
        local maxY = math.max(margin, vp.Y - h - margin)

        local pos = _menuHomePos or UDim2.new(0, 20, 0, 20)
        local x = pos.X.Scale * vp.X + pos.X.Offset
        local y = pos.Y.Scale * vp.Y + pos.Y.Offset

        x = math.clamp(x, margin, maxX)
        y = math.clamp(y, margin, maxY)
        return UDim2.new(0, math.floor(x + 0.5), 0, math.floor(y + 0.5))
    end

    local function getHomePos()
        return getSafeMenuPos()
    end
    local mainOriginalPos = main.Position

    showGui = function()
        if slideTween then
            pcall(function() slideTween:Cancel() end)
            slideTween = nil
        end
        if not main or not miniBtn or not gui then return end

        -- FIX RIGUROSO: primero hacemos visible el menú y le damos una posición
        -- garantizada dentro del viewport. El mini STRIKE solo se oculta después.
        gui.Enabled = true
        main.Visible = true
        main.Position = getSafeMenuPos()
        miniBtn.Visible = false
        _menuHomePos = main.Position
    end

    hideGui = function()
        if slideTween then slideTween:Cancel() end
        if not main or not main.Visible then return end
        local targetPos = UDim2.new(0, -GUI_W - 20, 0, 2)
        slideTween = TS:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos})
        slideTween:Play()
        slideTween.Completed:Connect(function()
            main.Visible = false
            miniBtn.Visible = true
            slideTween = nil
        end)
    end

    closeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)

    -- Pestañas superiores como en la referencia: una sola fila, sin bordes,
    -- con una cápsula de resaltado únicamente para la pestaña seleccionada.
    local tabBar = Instance.new("Frame", main)
    tabBar.Size = UDim2.new(1, -24, 0, 38)
    tabBar.Position = UDim2.new(0, 12, 0, 72)
    tabBar.BackgroundTransparency = 1
    tabBar.ZIndex = 10

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Padding = UDim.new(0, 2)

    local tabContent = Instance.new("Frame", main)
    tabContent.Size = UDim2.new(1, -12, 1, -124)
    tabContent.Position = UDim2.new(0, 6, 0, 116)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.ZIndex = 5

    local tabs = {"Speed", "Combat", "Visual", "Config", "Keybinds"}
    tabButtons = {}
    local contentPages = {}

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(0, 62, 1, -8)
        btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = TAB_INACT
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.AutoButtonColor = false
        btn.ZIndex = 11
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

        local page = Instance.new("ScrollingFrame", tabContent)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Position = UDim2.new(0, 0, 0, 0)
        page.BackgroundColor3 = Color3.fromRGB(5,5,5)
        page.BackgroundTransparency = 0.6
        page.BorderSizePixel = 0
        page.ClipsDescendants = true
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = Color3.fromRGB(30,30,35)
        page.ScrollBarImageTransparency = 0.3
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.ZIndex = 6
        Instance.new("UICorner", page).CornerRadius = UDim.new(0, 16)
        page.Visible = (i == 1)

        local layout = Instance.new("UIListLayout", page)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 6)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local padding = Instance.new("UIPadding", page)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.PaddingTop = UDim.new(0, 6)
        padding.PaddingBottom = UDim.new(0, 20)

        contentPages[name] = page

        btn.MouseButton1Click:Connect(function()
            for _, pg in pairs(contentPages) do pg.Visible = false end
            page.Visible = true
            for _, b in ipairs(tabButtons) do
                b.TextColor3 = TAB_INACT
                b.BackgroundTransparency = 1
            end
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.BackgroundColor3 = Color3.fromRGB(152,161,170)
            btn.BackgroundTransparency = 0.15
        end)

        table.insert(tabButtons, btn)
    end

    if tabButtons[1] then
        tabButtons[1].TextColor3 = Color3.fromRGB(255,255,255)
        tabButtons[1].BackgroundColor3 = Color3.fromRGB(152,161,170)
        tabButtons[1].BackgroundTransparency = 0.15
    end

    -- >>> TAB POSITION BEGIN (adaptado al sistema de pestañas de STRIKE)
    -- Reposiciona la barra de pestañas (tabBar) y el contenido (tabContent).
    -- Valores admitidos: "Up" (arriba, por defecto), "Bottom" (abajo),
    -- "Left" (izquierda, en columna) y "Right" (derecha, en columna).
    local function strikeApplyTabPosition(pos)
        if pos ~= "Up" and pos ~= "Bottom" and pos ~= "Left" and pos ~= "Right" then
            pos = "Up"
        end
        _G._StrikeTabPosition = pos
        if not tabBar or not tabContent or not tabLayout then return end

        if pos == "Up" then
            tabBar.Position = UDim2.new(0, 12, 0, 72)
            tabBar.Size     = UDim2.new(1, -24, 0, 38)
            tabLayout.FillDirection       = Enum.FillDirection.Horizontal
            tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            tabLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
            tabContent.Position = UDim2.new(0, 6, 0, 116)
            tabContent.Size     = UDim2.new(1, -12, 1, -124)
        elseif pos == "Bottom" then
            tabBar.Position = UDim2.new(0, 12, 1, -46)
            tabBar.Size     = UDim2.new(1, -24, 0, 38)
            tabLayout.FillDirection       = Enum.FillDirection.Horizontal
            tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            tabLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
            tabContent.Position = UDim2.new(0, 6, 0, 72)
            tabContent.Size     = UDim2.new(1, -12, 1, -124)
        elseif pos == "Left" then
            tabBar.Position = UDim2.new(0, 8, 0, 72)
            tabBar.Size     = UDim2.new(0, 74, 1, -80)
            tabLayout.FillDirection       = Enum.FillDirection.Vertical
            tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            tabLayout.VerticalAlignment   = Enum.VerticalAlignment.Top
            tabContent.Position = UDim2.new(0, 88, 0, 72)
            tabContent.Size     = UDim2.new(1, -96, 1, -80)
        else -- Right
            tabBar.Position = UDim2.new(1, -82, 0, 72)
            tabBar.Size     = UDim2.new(0, 74, 1, -80)
            tabLayout.FillDirection       = Enum.FillDirection.Vertical
            tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            tabLayout.VerticalAlignment   = Enum.VerticalAlignment.Top
            tabContent.Position = UDim2.new(0, 6, 0, 72)
            tabContent.Size     = UDim2.new(1, -96, 1, -80)
        end

        local vertical = (pos == "Left" or pos == "Right")
        for _, b in ipairs(tabButtons) do
            if vertical then
                b.Size = UDim2.new(1, -6, 0, 30)
            else
                b.Size = UDim2.new(0, 62, 1, -8)
            end
        end
    end
    _G.StrikeApplyTabPosition = strikeApplyTabPosition
    -- Aplica la posición cargada del config (o "Up" por defecto).
    strikeApplyTabPosition(_G._StrikeTabPosition or "Up")
    -- <<< TAB POSITION END

    local pageCounters = {}

    local function getNextOrder(page)
        if not pageCounters[page] then pageCounters[page] = 0 end
        pageCounters[page] = pageCounters[page] + 1
        return pageCounters[page]
    end

    -- Section headers: same visual style for EVERY named section.
    -- White GothamBlack title + subtle white divider, independent of theme/accent.
    local function mkSect(page, txt)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 30)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7

        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -16, 1, 0)
        l.Position = UDim2.new(0, 8, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = Color3.fromRGB(255, 255, 255)
        l.Font = Enum.Font.GothamBlack
        l.TextSize = 17
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        l.TextStrokeTransparency = 0.45
        l.ZIndex = 8

        local line = Instance.new("Frame", f)
        line.Size = UDim2.new(1, -24, 0, 1)
        line.Position = UDim2.new(0, 12, 1, -4)
        line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        line.BackgroundTransparency = 0.72
        line.BorderSizePixel = 0
        line.ZIndex = 8
        return f
    end

    local function mkRow(page, h)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, -4, 0, h or 38)
        f.BackgroundColor3 = ROW_BG
        f.BackgroundTransparency = 0.7
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local rowStroke = Instance.new("UIStroke", f)
        rowStroke.Color = ROW_BORDER
        rowStroke.Thickness = 1
        rowStroke.Transparency = 0.5
        f.MouseEnter:Connect(function()
            TS:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(28,28,28)}):Play()
        end)
        f.MouseLeave:Connect(function()
            TS:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = ROW_BG}):Play()
        end)
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.55, 0, 1, 0)
        l.Position = UDim2.new(0, 10, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = WHITE
        l.Font = Enum.Font.GothamBold
        l.TextSize = 15
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        l.TextStrokeTransparency = 0.35
        l.ZIndex = 8
        return l
    end

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Name = "Track"
        pill.Size = UDim2.new(0, 34, 0, 18)
        pill.AnchorPoint = Vector2.new(0.5, 0.5)
        pill.Position = UDim2.new(1, -(offset or 48), 0.5, 0)
        pill.BackgroundColor3 = Color3.fromRGB(255,255,255)
        pill.BackgroundTransparency = 0.2
        pill.BorderSizePixel = 0
        pill.ZIndex = 8
        Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 9)
        local stroke = Instance.new("UIStroke", pill)
        stroke.Color = ROW_BORDER
        stroke.Thickness = 1
        stroke.Transparency = 0.45
        stroke.Name = "PillStroke"

        local dot = Instance.new("Frame", pill)
        dot.Name = "Knob"
        dot.Size = UDim2.new(0, 13, 0, 13)
        dot.AnchorPoint = Vector2.new(0, 0)
        dot.Position = UDim2.new(0, 3, 0.5, -6)
        dot.BackgroundColor3 = Color3.fromRGB(18,18,22)
        dot.BorderSizePixel = 0
        dot.ZIndex = 9
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local shine = Instance.new("Frame", dot)
        shine.Name = "Shine"
        shine.Size = UDim2.new(1, -4, 0, 4)
        shine.Position = UDim2.new(0, 2, 0, 2)
        shine.BackgroundColor3 = WHITE
        shine.BackgroundTransparency = 0.72
        shine.BorderSizePixel = 0
        shine.ZIndex = 10
        Instance.new("UICorner", shine).CornerRadius = UDim.new(0, 4)

        return pill, dot
    end

    local function animPill(pill, dot, on)
        local TOGGLE_ON_COLOR = Color3.fromRGB(152, 161, 170)
        local stroke = pill:FindFirstChildOfClass("UIStroke")
        local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TS:Create(dot, info, {
            Position = on and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
        }):Play()
        TS:Create(pill, info, {
            BackgroundColor3 = on and TOGGLE_ON_COLOR or Color3.fromRGB(255,255,255),
            BackgroundTransparency = on and 0 or 0.2,
        }):Play()
        if stroke then
            TS:Create(stroke, info, {
                Color = on and TOGGLE_ON_COLOR or ROW_BORDER,
                Transparency = on and 0.2 or 0.45,
                Thickness = 1,
            }):Play()
        end
    end

    local function mkSlider(row, minV, maxV, default, cb)
        local W = 118
        local track = Instance.new("Frame", row)
        track.Size = UDim2.new(0, W, 0, 4)
        track.Position = UDim2.new(1, -(W + 44), 0.5, -2)
        track.BackgroundColor3 = INP
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
        knob.BackgroundColor3 = WHITE
        knob.BorderSizePixel = 0
        knob.ZIndex = 11
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        local kStroke = Instance.new("UIStroke", knob)
        kStroke.Color = getThemeColor()
        kStroke.Thickness = 2

        local valLabel = Instance.new("TextLabel", row)
        valLabel.Size = UDim2.new(0, 34, 0, 20)
        valLabel.Position = UDim2.new(1, -38, 0.5, -10)
        valLabel.BackgroundTransparency = 1
        valLabel.Text = tostring(default)
        valLabel.TextColor3 = WHITE
        valLabel.Font = Enum.Font.GothamBold
        valLabel.TextSize = 11
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.ZIndex = 9

        local hit = Instance.new("TextButton", row)
        hit.Size = UDim2.new(0, W + 16, 0, 26)
        hit.Position = UDim2.new(1, -(W + 52), 0.5, -13)
        hit.BackgroundTransparency = 1
        hit.Text = ""
        hit.AutoButtonColor = false
        hit.ZIndex = 12

        local current = default

        local function render(a)
            a = _clamp(a, 0, 1)
            fill.Size = UDim2.new(a, 0, 1, 0)
            knob.Position = UDim2.new(a, 0, 0.5, 0)
            fill.BackgroundColor3 = getThemeColor()
            kStroke.Color = getThemeColor()
        end

        local function applyFromX(px)
            local left = track.AbsolutePosition.X
            local width = track.AbsoluteSize.X
            if width <= 0 then width = W end
            if left <= 0 then return end
            local a = (px - left) / width
            a = _clamp(a, 0, 1)
            local v = _floor(minV + (maxV - minV) * a + 0.5)
            current = v
            valLabel.Text = tostring(v)
            render(a)
            if cb then pcall(cb, v) end
        end

        local dragging = false

        hit.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                _isDraggingButton = true
                applyFromX(i.Position.X)
            end
        end)

        hit.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                _isDraggingButton = false
            end
        end)

        UIS.InputChanged:Connect(function(i)
            if not dragging then return end
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                applyFromX(i.Position.X)
            end
        end)

        UIS.InputEnded:Connect(function(i)
            if not dragging then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                _isDraggingButton = false
            end
        end)

        local function setValue(v)
            v = _clamp(tonumber(v) or minV, minV, maxV)
            current = v
            valLabel.Text = tostring(v)
            render((v - minV) / (maxV - minV))
        end

        setValue(default)
        return setValue
    end

    local function mkToggle(page, txt, cb)
        local row = mkRow(page, 38)
        mkLabel(row, txt)
        local pill, dot = mkPill(row, 48)
        local on = false
        local function sv(s) on = s; animPill(pill, dot, s) end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
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
        end)
        return sv
    end

    local function mkSelector(parent, default, options, cb)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local leftStroke = Instance.new("UIStroke", leftBtn)
        leftStroke.Color = ROW_BORDER
        leftStroke.Thickness = 1
        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(0, 80, 0, 26)
        label.Position = UDim2.new(0.5, -40, 0.5, -13)
        label.BackgroundTransparency = 1
        label.Text = default
        label.TextColor3 = WHITE
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local rightStroke = Instance.new("UIStroke", rightBtn)
        rightStroke.Color = ROW_BORDER
        rightStroke.Thickness = 1
        local function updateLabel(newText) label.Text = newText end
        leftBtn.MouseButton1Click:Connect(function()
            if cb then cb(-1, updateLabel) end
        end)
        rightBtn.MouseButton1Click:Connect(function()
            if cb then cb(1, updateLabel) end
        end)
        return label
    end

    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        local bw = w or 50
        local xo = math.max(xOff or 56, bw + 12)
        tb.Size = UDim2.new(0, bw, 0, 24)
        tb.Position = UDim2.new(1, -xo, 0.5, -12)
        tb.BackgroundColor3 = INP
        tb.BackgroundTransparency = 0.7
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = WHITE
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 11
        tb.ClearTextOnFocus = false
        tb.ZIndex = 8
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = ROW_BORDER
        bs.Thickness = 1.2
        bs.Transparency = 0.25
        tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.12), {Color = getThemeColor(), Transparency = 0}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs, TweenInfo.new(0.12), {Color = ROW_BORDER, Transparency = 0.25}):Play()
            if cb then local n = tonumber(tb.Text); if n then cb(n) else tb.Text = tostring(default) end end
        end)
        return tb
    end

    local function mkStepper(parent, value, minV, maxV, step, decimals, cb)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(0, 118, 0, 26)
        container.Position = UDim2.new(1, -126, 0.5, -13)
        container.BackgroundTransparency = 1
        container.ZIndex = 8

        local cur = value
        local function fmt(v)
            if decimals and decimals > 0 then
                return string.format("%."..decimals.."f", v)
            else
                return tostring(_floor(v + 0.5))
            end
        end

        local function mkChip(txt, xpos, w)
            local c = Instance.new("TextButton", container)
            c.Size = UDim2.new(0, w, 0, 26)
            c.Position = xpos
            c.BackgroundColor3 = Color3.fromRGB(18,18,22)
            c.BackgroundTransparency = 0.15
            c.BorderSizePixel = 0
            c.Text = txt
            c.TextColor3 = WHITE
            c.Font = Enum.Font.GothamBold
            c.TextSize = txt == "" and 12 or 16
            c.AutoButtonColor = false
            c.ZIndex = 9
            Instance.new("UICorner", c).CornerRadius = UDim.new(0, 6)
            local st = Instance.new("UIStroke", c)
            st.Color = ROW_BORDER
            st.Thickness = 1
            st.Transparency = 0.35
            return c
        end

        local minusBtn = mkChip("-", UDim2.new(0, 0, 0, 0), 26)
        local valBtn = mkChip("", UDim2.new(0.5, -28, 0, 0), 56)
        valBtn.TextSize = 12
        valBtn.Active = false
        valBtn.Text = fmt(cur)
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

    local function mkKeyButton(parent, kbEntry)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 80, 0, 24)
        btn.Position = UDim2.new(1, -88, 0.5, -12)
        btn.BackgroundColor3 = INP
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
        btn.Text = getLabel()
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 9
        btn.ZIndex = 8
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = ROW_BORDER
        bs.Thickness = 1
        local li = false; local lc; local pv = btn.Text; local listenStart = 0
        btn.Activated:Connect(function()
            if li then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = _tick(); btn.Text = "..."; btn.TextColor3 = WHITE
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return end
                local isGp = isGamepadInput(inp)
                if isGp and _tick()-listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; btn.TextColor3 = WHITE
                li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end
                if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end
            end)
        end)
        table.insert(keyButtonRefs, {btn = btn, entry = kbEntry})
        return btn
    end

    local function addKeybindRow(page, labelText, kbEntry)
        local row = mkRow(page, 36)
        mkLabel(row, labelText)
        mkKeyButton(row, kbEntry)
    end

    local speedPage = contentPages["Speed"]

    -- ===================== AUTO CARRY SPEED + AUTO CARRY ON ENEMY BASE =====================
    -- (portado del hub Ryzen y adaptado a la arquitectura de STRIKE: speedMode /
    --  laggerToggled / laggerCarryToggled / resetMovementState / CarrySystem)
    mkSect(speedPage, "Auto Carry")
    setAutoCarrySpeedVisual = mkToggle(speedPage, "Auto Carry Speed", function(on)
        _G.StrikeSetAutoCarrySpeed(on)
        saveAllSettings()
    end)
    setAutoCarryEnemyBaseVisual = mkToggle(speedPage, "Auto Carry on Enemy Base", function(on)
        _G.StrikeSetAutoCarryEnemyBase(on)
        saveAllSettings()
    end)
    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "Enemy Base Range")
        autoCarryEnemyBaseRangeBox = mkBox(row, autoCarryEnemyBaseRange, 50, 56, function(v)
            autoCarryEnemyBaseRange = math.clamp(math.floor(v), 5, 150)
            saveAllSettings()
        end)
    end

    mkSect(speedPage, "Speed Settings")
    do local row = mkRow(speedPage, 38); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 50, 56, function(v) if v > 0 and v <= 500 then NS = v end end) end
    do local row = mkRow(speedPage, 38); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 50, 56, function(v) if v > 0 and v <= 500 then CS = v end end) end
    do local row = mkRow(speedPage, 38); mkLabel(row, "Lagger Speed"); laggerBox = mkBox(row, LAGGER_SPEED, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_SPEED = v end end) end
    do local row = mkRow(speedPage, 38); mkLabel(row, "Lagger Carry SPD"); lagger2Box = mkBox(row, LAGGER_CARRY_SPEED, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_CARRY_SPEED = v end end) end
    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "Current Mode")
        modeValLbl = Instance.new("TextLabel", row)
        modeValLbl.Size = UDim2.new(0, 110, 1, 0)
        modeValLbl.Position = UDim2.new(1, -118, 0, 0)
        modeValLbl.BackgroundTransparency = 1
        modeValLbl.Text = "Normal"
        modeValLbl.TextColor3 = WHITE
        modeValLbl.Font = Enum.Font.GothamBlack
        modeValLbl.TextSize = 11
        modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
        modeValLbl.ZIndex = 8
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 8
        clk.MouseButton1Click:Connect(function() toggleCarryMode() end)
    end

    mkSect(speedPage, "Auto Movement")
    autoLeftSetVisual = mkToggle(speedPage, "Auto Left", function(on)
        autoLeftEnabled = on
        if on then startAutoLeft() else stopAutoLeft() end
        if mobSetAutoLeft then mobSetAutoLeft(on) end
    end)
    autoRightSetVisual = mkToggle(speedPage, "Auto Right", function(on)
        autoRightEnabled = on
        if on then startAutoRight() else stopAutoRight() end
        if mobSetAutoRight then mobSetAutoRight(on) end
    end)

    mkSect(speedPage, "TP & Reset")
    do
        local row = mkRow(speedPage, 38)
        mkLabel(row, "TP Down")
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(0.58, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 8
        clk.MouseButton1Click:Connect(function() doTpDown() end)
        local actLbl = Instance.new("TextLabel", row)
        actLbl.Size = UDim2.new(0, 70, 1, 0)
        actLbl.Position = UDim2.new(1, -78, 0, 0)
        actLbl.BackgroundTransparency = 1
        actLbl.Text = "ACTIVATE"
        actLbl.TextColor3 = getThemeColor()
        actLbl.Font = Enum.Font.GothamBold
        actLbl.TextSize = 9
        actLbl.TextXAlignment = Enum.TextXAlignment.Right
        actLbl.ZIndex = 8
    end

    local combatPage = contentPages["Combat"]

    mkSect(combatPage, "Anti Ragdoll")
    do
        local row = mkRow(combatPage, 38)
        mkLabel(row, "Anti Ragdoll")

        local pill, dot = mkPill(row, 48)
        local on = antiRagdollMode ~= "off"
        local function setToggleVisual(v)
            on = v == true
            animPill(pill, dot, on)
        end
        setAntiRagdollVisual = setToggleVisual

        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            if editModeEnabled and not uiLocked then
                local nextOn = not on
                setToggleVisual(nextOn)
                if nextOn then
                    setAntiRagdollMode(antiRagdollMode == "off" and "v2" or antiRagdollMode)
                else
                    setAntiRagdollMode("off")
                end
            else
                if on then
                    setAntiRagdollMode("off")
                else
                    setAntiRagdollMode(antiRagdollMode == "off" and "v2" or antiRagdollMode)
                end
            end
        end)

        local arrow = Instance.new("TextButton", row)
        arrow.Size = UDim2.new(0, 28, 0, 26)
        arrow.Position = UDim2.new(1, -94, 0.5, -13)
        arrow.BackgroundColor3 = INP
        arrow.BackgroundTransparency = 0.7
        arrow.BorderSizePixel = 0
        arrow.Text = "\226\150\188"
        arrow.TextColor3 = WHITE
        arrow.Font = Enum.Font.GothamBold
        arrow.TextSize = 12
        arrow.AutoButtonColor = false
        arrow.ZIndex = 10
        Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 6)
        local arrowStroke = Instance.new("UIStroke", arrow)
        arrowStroke.Color = ROW_BORDER
        arrowStroke.Thickness = 1

        local subRows = {}
        local modeRow = mkRow(combatPage, 38)
        modeRow.Visible = false
        table.insert(subRows, modeRow)
        mkLabel(modeRow, "Ragdoll Mode")

        local modeContainer = Instance.new("Frame", modeRow)
        modeContainer.Size = UDim2.new(0, 92, 0, 26)
        modeContainer.Position = UDim2.new(1, -100, 0.5, -13)
        modeContainer.BackgroundTransparency = 1
        modeContainer.ZIndex = 8

        local v1Btn = Instance.new("TextButton", modeContainer)
        v1Btn.Size = UDim2.new(0, 43, 1, 0)
        v1Btn.Position = UDim2.new(0, 0, 0, 0)
        v1Btn.BackgroundColor3 = INP
        v1Btn.BackgroundTransparency = 0.35
        v1Btn.BorderSizePixel = 0
        v1Btn.Text = "V1"
        v1Btn.TextColor3 = WHITE
        v1Btn.Font = Enum.Font.GothamBold
        v1Btn.TextSize = 10
        v1Btn.AutoButtonColor = false
        v1Btn.ZIndex = 9
        Instance.new("UICorner", v1Btn).CornerRadius = UDim.new(0, 7)

        local v2Btn = Instance.new("TextButton", modeContainer)
        v2Btn.Size = UDim2.new(0, 43, 1, 0)
        v2Btn.Position = UDim2.new(0, 49, 0, 0)
        v2Btn.BackgroundColor3 = INP
        v2Btn.BackgroundTransparency = 0.35
        v2Btn.BorderSizePixel = 0
        v2Btn.Text = "V2"
        v2Btn.TextColor3 = WHITE
        v2Btn.Font = Enum.Font.GothamBold
        v2Btn.TextSize = 10
        v2Btn.AutoButtonColor = false
        v2Btn.ZIndex = 9
        Instance.new("UICorner", v2Btn).CornerRadius = UDim.new(0, 7)

        local MODE_SELECTED = Color3.fromRGB(132, 143, 160)
        local MODE_UNSELECTED = INP
        local function paintMode(mode)
            -- La selección visual sigue exactamente el modo que está activo.
            local active1 = mode == "v1"
            local active2 = mode == "v2"
            v1Btn.BackgroundColor3 = active1 and MODE_SELECTED or MODE_UNSELECTED
            v2Btn.BackgroundColor3 = active2 and MODE_SELECTED or MODE_UNSELECTED
            v1Btn.BackgroundTransparency = active1 and 0 or 0.35
            v2Btn.BackgroundTransparency = active2 and 0 or 0.35
            v1Btn.TextColor3 = active1 and Color3.fromRGB(20, 20, 24) or WHITE
            v2Btn.TextColor3 = active2 and Color3.fromRGB(20, 20, 24) or WHITE
        end
        updateAntiRagdollModeUI = function(mode)
            paintMode(mode)
            setToggleVisual(mode ~= "off")
        end

        v1Btn.MouseButton1Click:Connect(function()
            setAntiRagdollMode("v1")
            updateAntiRagdollModeUI("v1")
        end)
        v2Btn.MouseButton1Click:Connect(function()
            setAntiRagdollMode("v2")
            updateAntiRagdollModeUI("v2")
        end)

        local expanded = false
        arrow.MouseButton1Click:Connect(function()
            expanded = not expanded
            for _, r in ipairs(subRows) do r.Visible = expanded end
            arrow.Text = expanded and "\226\150\178" or "\226\150\188"
        end)

        updateAntiRagdollModeUI(antiRagdollMode)
    end

    -- Infinite Jump: el sistema ya existía en el Lua; ahora queda controlado por un toggle.
    setInfiniteJumpVisual = mkToggle(combatPage, "Infinite Jump", function(on)
        infiniteJumpEnabled = on == true
        if infiniteJumpEnabled then
            InfiniteJump.start()
        else
            InfiniteJump.stop()
        end
        saveAllSettings()
    end)
    if setInfiniteJumpVisual then setInfiniteJumpVisual(infiniteJumpEnabled) end

    setAntiDieVisual = mkToggle(combatPage, "Anti Die", function(on)
        antiDieEnabled = on
        if on then AntiDieModule.start() else AntiDieModule.stop() end
        saveAllSettings()
    end)
    if setAntiDieVisual then setAntiDieVisual(antiDieEnabled) end

    -- Anti Fling queda directamente debajo de Anti Die, como en Ace.
    setAntiFlingVisual = mkToggle(combatPage, "Anti Fling", function(on)
        antiFlingEnabled = on == true
        if antiFlingEnabled then
            AntiFlingModule.start()
        else
            AntiFlingModule.stop()
        end
        saveAllSettings()
    end)
    if setAntiFlingVisual then setAntiFlingVisual(antiFlingEnabled) end

    mkSect(combatPage, "Drop")
    dropBrainrotSetVisual = mkToggle(combatPage, "Drop Brainrot", function(on)
        if on then
            executeDropWithToggle(function(v)
                dropBrainrotSetVisual(v)
                if mobSetDropBR then mobSetDropBR(v) end
            end)
        end
    end)
    setDropVisual = dropBrainrotSetVisual

    do
        local row = mkRow(combatPage, 38)
        mkLabel(row, "Drop Mode")
        dropModeBtnRef = mkSelector(row, dropMode == 1 and "Fling" or "Jump Drop", {"Fling", "Jump Drop"}, function(dir, update)
            if dropActive then stopDropBrainrot() end
            dropMode = dropMode == 1 and 2 or 1
            update(dropMode == 1 and "Fling" or "Jump Drop")
        end)
    end

    mkSect(combatPage, "Counters")
    setBatCounterVisual = mkToggle(combatPage, "Bat Counter", function(on)
        batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
    end)

    setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on)
        medusaCounterEnabled = on
        if on then
            if LP.Character then setupMedusaCounter(LP.Character) else stopMedusaCounter() end
        else
            stopMedusaCounter()
        end
        if setMedusaVisual then setMedusaVisual(on) end
    end)

    mkSect(combatPage, "Aimbots")
    autoBatSetVisual = mkToggle(combatPage, "Auto Bat", function(on)
        if on then enableAutoBat() else disableAutoBat() end
        if mobSetAutoBat then mobSetAutoBat(on) end
    end)
    do local row = mkRow(combatPage, 38); mkLabel(row, "Bat Aimbot Speed"); batSpeedBox = mkBox(row, BAT_AIMBOT_SPEED, 50, 56, function(v) if v > 0 and v <= 200 then BAT_AIMBOT_SPEED = v end end) end

    do
        local row = mkRow(combatPage, 38)
        mkLabel(row, "TP BAT")

        local pill, dot = mkPill(row, 48)
        local on = batDesyncTpEnabled
        local function setToggleVisual(v)
            on = v == true
            animPill(pill, dot, on)
        end
        batDesyncTpSetVisual = setToggleVisual

        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            if on then
                if batDesyncTpEnabled then toggleBatDesyncTp() end
            else
                if not batDesyncTpEnabled then toggleBatDesyncTp() end
            end
        end)

        local arrow = Instance.new("TextButton", row)
        arrow.Size = UDim2.new(0, 28, 0, 26)
        arrow.Position = UDim2.new(1, -94, 0.5, -13)
        arrow.BackgroundColor3 = INP
        arrow.BackgroundTransparency = 0.7
        arrow.BorderSizePixel = 0
        arrow.Text = "\226\150\188"
        arrow.TextColor3 = WHITE
        arrow.Font = Enum.Font.GothamBold
        arrow.TextSize = 12
        arrow.AutoButtonColor = false
        arrow.ZIndex = 10
        Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 6)
        local arrowStroke = Instance.new("UIStroke", arrow)
        arrowStroke.Color = ROW_BORDER
        arrowStroke.Thickness = 1

        local subRows = {}
        local modeRow = mkRow(combatPage, 38)
        modeRow.Visible = false
        table.insert(subRows, modeRow)
        mkLabel(modeRow, "TP BAT MODE")

        local modeContainer = Instance.new("Frame", modeRow)
        modeContainer.Size = UDim2.new(0, 92, 0, 26)
        modeContainer.Position = UDim2.new(1, -100, 0.5, -13)
        modeContainer.BackgroundTransparency = 1
        modeContainer.ZIndex = 8

        local v1Btn = Instance.new("TextButton", modeContainer)
        v1Btn.Size = UDim2.new(0, 43, 1, 0)
        v1Btn.Position = UDim2.new(0, 0, 0, 0)
        v1Btn.BackgroundColor3 = INP
        v1Btn.BackgroundTransparency = 0.35
        v1Btn.BorderSizePixel = 0
        v1Btn.Text = "V1"
        v1Btn.TextColor3 = WHITE
        v1Btn.Font = Enum.Font.GothamBold
        v1Btn.TextSize = 10
        v1Btn.AutoButtonColor = false
        v1Btn.ZIndex = 9
        Instance.new("UICorner", v1Btn).CornerRadius = UDim.new(0, 7)

        local v2Btn = Instance.new("TextButton", modeContainer)
        v2Btn.Size = UDim2.new(0, 43, 1, 0)
        v2Btn.Position = UDim2.new(0, 49, 0, 0)
        v2Btn.BackgroundColor3 = INP
        v2Btn.BackgroundTransparency = 0.35
        v2Btn.BorderSizePixel = 0
        v2Btn.Text = "V2"
        v2Btn.TextColor3 = WHITE
        v2Btn.Font = Enum.Font.GothamBold
        v2Btn.TextSize = 10
        v2Btn.AutoButtonColor = false
        v2Btn.ZIndex = 9
        Instance.new("UICorner", v2Btn).CornerRadius = UDim.new(0, 7)

        local MODE_SELECTED = Color3.fromRGB(132, 143, 160)
        local MODE_UNSELECTED = INP
        local function paintMode(mode)
            local active1 = mode == "v1"
            local active2 = mode == "v2"
            v1Btn.BackgroundColor3 = active1 and MODE_SELECTED or MODE_UNSELECTED
            v2Btn.BackgroundColor3 = active2 and MODE_SELECTED or MODE_UNSELECTED
            v1Btn.BackgroundTransparency = active1 and 0 or 0.35
            v2Btn.BackgroundTransparency = active2 and 0 or 0.35
            v1Btn.TextColor3 = active1 and Color3.fromRGB(20, 20, 24) or WHITE
            v2Btn.TextColor3 = active2 and Color3.fromRGB(20, 20, 24) or WHITE
        end

        setTpBatVersion = function(mode)
            tpBatMode = (mode == "v2") and "v2" or "v1"
            _tpBatNextTick = 0
            pcall(saveAllSettings)
        end
        updateTpBatModeUI = function(mode)
            paintMode((mode == "v2") and "v2" or "v1")
        end

        v1Btn.MouseButton1Click:Connect(function()
            setTpBatVersion("v1")
            updateTpBatModeUI("v1")
        end)
        v2Btn.MouseButton1Click:Connect(function()
            setTpBatVersion("v2")
            updateTpBatModeUI("v2")
        end)

        local expanded = false
        arrow.MouseButton1Click:Connect(function()
            expanded = not expanded
            for _, r in ipairs(subRows) do r.Visible = expanded end
            arrow.Text = expanded and "\226\150\178" or "\226\150\188"
        end)

        setToggleVisual(batDesyncTpEnabled)
        updateTpBatModeUI(tpBatMode)
    end

    autoBatBypassSetVisual = mkToggle(combatPage, "Bat Bypass", function(on)
        if on then enableBatBypass() else disableBatBypass() end
    end)
    if autoBatBypassSetVisual then autoBatBypassSetVisual(autoBatBypassEnabled) end

    local visualPage = contentPages["Visual"]

    mkSect(visualPage, "ESP")
    do
        local row = mkRow(visualPage, 38)
        mkLabel(row, "ESP")

        local pill, dot = mkPill(row, 48)
        local masterOn = espEnabled == true
        local function setMasterVisual(v)
            masterOn = v == true
            animPill(pill, dot, masterOn)
        end
        setESPVIsual = setMasterVisual
        setMasterVisual(masterOn)

        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            local nextOn = not masterOn
            setMasterVisual(nextOn)
            toggleESP(nextOn)
        end)

        local arrow = Instance.new("TextButton", row)
        arrow.Size = UDim2.new(0, 28, 0, 26)
        arrow.Position = UDim2.new(1, -94, 0.5, -13)
        arrow.BackgroundColor3 = INP
        arrow.BackgroundTransparency = 0.7
        arrow.BorderSizePixel = 0
        arrow.Text = "\226\150\188"
        arrow.TextColor3 = WHITE
        arrow.Font = Enum.Font.GothamBold
        arrow.TextSize = 12
        arrow.AutoButtonColor = false
        arrow.ZIndex = 10
        Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 6)
        local arrowStroke = Instance.new("UIStroke", arrow)
        arrowStroke.Color = ROW_BORDER
        arrowStroke.Thickness = 1

        local subRows = {}

        local boxSet
        do
            local sub = mkToggle(visualPage, "Boxed ESP", function(on)
                toggleESPBox(on)
            end)
            local subRow = visualPage:FindFirstChildWhichIsA("Frame")
            -- Locate the newest row by LayoutOrder so it remains compatible with the existing UI builder.
            local newestOrder = -math.huge
            for _, child in ipairs(visualPage:GetChildren()) do
                if child:IsA("Frame") and child.LayoutOrder > newestOrder then
                    newestOrder = child.LayoutOrder
                    subRow = child
                end
            end
            subRow.Visible = false
            table.insert(subRows, subRow)
            boxSet = sub
            setESPBoxVisual = boxSet
            boxSet(espBoxEnabled)
        end

        local trackerSet
        do
            local sub = mkToggle(visualPage, "Show Tracker", function(on)
                toggleESPTracker(on)
            end)
            local subRow = nil
            local newestOrder = -math.huge
            for _, child in ipairs(visualPage:GetChildren()) do
                if child:IsA("Frame") and child.LayoutOrder > newestOrder then
                    newestOrder = child.LayoutOrder
                    subRow = child
                end
            end
            subRow.Visible = false
            table.insert(subRows, subRow)
            trackerSet = sub
            setESPTrackerVisual = trackerSet
            trackerSet(espTrackerEnabled)
        end

        local ragSet
        do
            local sub = mkToggle(visualPage, "Ragdoll Countdown", function(on)
                toggleRagdollCountdown(on)
            end)
            local subRow = nil
            local newestOrder = -math.huge
            for _, child in ipairs(visualPage:GetChildren()) do
                if child:IsA("Frame") and child.LayoutOrder > newestOrder then
                    newestOrder = child.LayoutOrder
                    subRow = child
                end
            end
            subRow.Visible = false
            table.insert(subRows, subRow)
            ragSet = sub
            setRagdollCountdownVisual = ragSet
            ragSet(ragdollCountdownEnabled)
        end

        local expanded = false
        arrow.MouseButton1Click:Connect(function()
            expanded = not expanded
            for _, subRow in ipairs(subRows) do
                subRow.Visible = expanded
            end
            arrow.Text = expanded and "\226\150\178" or "\226\150\188"
        end)
    end

    setAntiTpEspVisual = mkToggle(visualPage, "Anti TP ESP", function(on)
        toggleAntiTpEsp(on)
    end)
    if setAntiTpEspVisual then setAntiTpEspVisual(antiTpEspEnabled) end

    mkSect(visualPage, "Camera")
    do
        local row = mkRow(visualPage, 38)
        mkLabel(row, "Stretch Rez")
        local stretchPill, stretchDot = mkPill(row, 48)
        local stretchOn = false
        local function setStretch(s)
            stretchOn = s
            animPill(stretchPill, stretchDot, s)
            if s then enableStretch() else disableStretch() end
            stretchEnabled = s
        end
        local stretchClk = Instance.new("TextButton", stretchPill)
        stretchClk.Size = UDim2.new(1,0,1,0)
        stretchClk.BackgroundTransparency = 1
        stretchClk.Text = ""
        stretchClk.AutoButtonColor = false
        stretchClk.ZIndex = 10
        stretchClk.MouseButton1Click:Connect(function() setStretch(not stretchOn) end)
        _G.stretchToggleSetter = setStretch
    end

    setFovVisual = mkToggle(visualPage, "FOV", function(on)
        if on then enableCustomFov() else disableCustomFov() end
    end)
    if setFovVisual then setFovVisual(fovEnabled) end

    do
        local row = mkRow(visualPage, 38)
        mkLabel(row, "FOV Value")
        fovSliderSet = mkSlider(row, 20, 120, fovValue, function(v)
            fovValue = v
            if not fovEnabled then
                enableCustomFov()
                if setFovVisual then setFovVisual(true) end
            end
            local cam = workspace.CurrentCamera
            if cam then pcall(function() cam.FieldOfView = fovValue end) end
        end)
    end

    setAntiLagVisual = mkToggle(visualPage, "Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
    end)

    mkSect(visualPage, "Sky Theme")
    do
        local row = mkRow(visualPage, 38)
        mkLabel(row, "Sky Theme")
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local leftStroke = Instance.new("UIStroke", leftBtn)
        leftStroke.Color = ROW_BORDER
        leftStroke.Thickness = 1
        skySelectorLabel = Instance.new("TextLabel", container)
        skySelectorLabel.Size = UDim2.new(0, 96, 0, 26)
        skySelectorLabel.Position = UDim2.new(0.5, -48, 0.5, -13)
        skySelectorLabel.BackgroundTransparency = 1
        skySelectorLabel.Text = skyTheme
        skySelectorLabel.TextColor3 = WHITE
        skySelectorLabel.Font = Enum.Font.GothamBold
        skySelectorLabel.TextSize = 11
        skySelectorLabel.TextScaled = false
        skySelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        skySelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local rightStroke = Instance.new("UIStroke", rightBtn)
        rightStroke.Color = ROW_BORDER
        rightStroke.Thickness = 1
        local function updateSkySelector(direction)
            local idx = 1
            for i, name in ipairs(SKY_PRESETS_LIST) do
                if name == skyTheme then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #SKY_PRESETS_LIST end
            if newIdx > #SKY_PRESETS_LIST then newIdx = 1 end
            local name = SKY_PRESETS_LIST[newIdx]
            skyTheme = name
            pcall(applyCustomSky, name)
            if skySelectorLabel then skySelectorLabel.Text = name end
            pcall(saveAllSettings)
        end
        leftBtn.MouseButton1Click:Connect(function() updateSkySelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateSkySelector(1) end)
    end



    -- ============================================================
    -- ADAPT SKIN + SKIN GALLERY
    -- Integrado al final de Visual, sin modificar las demas opciones.
    -- Basado en el sistema de skins del Lua de referencia.
    -- ============================================================
    do
        if _G.__STRIKE_ADAPT_SKIN_CLEANUP then
            pcall(_G.__STRIKE_ADAPT_SKIN_CLEANUP)
        end

        local Adapt = {}
        _G.__STRIKE_ADAPT_SKIN = Adapt

        local ADAPT_PRESETS = {
            ADAPT = {10928435480, 6913613757, 9683332649},
            BLACK = {10928435480, 6913613757, 9683332649},
            RED = {
                107377896731216, 215718515, 82831174733357,
                122851471549264, 139051312584295,
                124572458012582, 105029428205930,
            },
            BLUE = {76059443, 74891470, 1180433861, 8781331764, 8682542843},
            GALAXY = {
                82831174733357, 139051312584295, 107062966543626,
                71184246276344, 111383282415116, 78289009309744,
                71017311084699,
            },
        }

        -- El preset ADAPT tambien usa el bundle de referencia.
        -- Colección completa del menú Hood Style tomada del SKIN COLLECTION de VX7.
        -- Estas opciones pertenecen SOLO a AVATAR CATALOG / Hood Style.
        local GALLERY_REFERENCE_PRESETS = {
            ["ALIEN"] = {
                bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
                items = {10997283529, 125085889448130},
            },
            ["OUTFIT 1"] = {
                bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
                items = {125157548394108, 123231522991173, 74827642361405},
            },
            ["OUTFIT 2"] = {
                bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
                scales = {HeightScale = 1, WidthScale = 0.85, DepthScale = 0.88, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.85},
                face = 86109936998865,
                items = {136644276218918, 132022106987543, 131740907052260},
            },
            ["OUTFIT 3"] = {
                bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
                headless = true,
                scales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},
                items = {119331031817124, 84952305140948},
            },
            ["OUTFIT 4"] = {
                bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
                headless = true,
                scales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},
                layeredPuffiness = 0,
                items = {18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702},
            },
            ["OUTFIT 5"] = {
                items = {13935333090, 16110951997, 10632503818},
            },
            ["OUTFIT 6"] = {
                headless = true,
                items = {74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424},
            },
            ["VX7"] = {
                headless = true,
                hideRightLeg = true,
                items = {76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718},
            },
            ["NEW SKIN"] = {
                hideLeftLeg = true,
                hideRightLeg = true,
                items = {70414871864071, 14863917259, 133498027006138, 82277826177074},
            },
        }

        -- Motor real de SKIN COLLECTION tomado del sistema VX7 de referencia.
        -- Se usa para que las skins tengan el mismo sistema de aplicacion y preview,
        -- no solamente una HumanoidDescription simplificada.
        local VX7_SKIN_ENGINE = nil
        local VX7_SKIN_INDEX = {
            ["ALIEN"] = 1,
            ["OUTFIT 1"] = 2,
            ["OUTFIT 2"] = 3,
            ["OUTFIT 3"] = 4,
            ["OUTFIT 4"] = 5,
            ["OUTFIT 5"] = 6,
            ["OUTFIT 6"] = 7,
            ["VX7"] = 8,
            ["NEW SKIN"] = 9,
        }

        local VX7_SKIN_ENGINE_SOURCE = [=[local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local InsertService = game:GetService("InsertService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local huiOk, huiResult = pcall(function() return gethui and gethui() end)
local CoreGui = huiOk and huiResult or game:GetService("CoreGui")
local LP = Players.LocalPlayer
local OUTFITS = {
{
id = 10997283529,
label = "ALIEN",
hideOriginal = false,
hideOriginalHead = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
items = {10997283529, 125085889448130},
},
{
label = "OUTFIT",
hideOriginal = false,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
items = {125157548394108, 123231522991173, 74827642361405},
},
{
label = "OUTFIT 2",
hideOriginal = false,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.85, DepthScale = 0.88, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.85},
face = 86109936998865,
faceMode = "decal",
items = {136644276218918, 132022106987543, 131740907052260},
},
{
label = "OUTFIT 3",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},
layeredPuffiness = 0,
items = {119331031817124, 84952305140948},
},
{
label = "OUTFIT 4",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},
layeredPuffiness = 0,
items = {18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702},
},
{
label = "OUTFIT 5",
hideOriginal = false,
clearOriginalWearables = true,
items = {13935333090, 16110951997, 10632503818},
},
{
label = "OUTFIT 6",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
items = {74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424},
},
{
label = "VX7",
hideOriginal = false,
headless = true,
hideRightLeg = true,
localOnly = true,
clearOriginalWearables = true,
items = {76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718},
},
{
label = "NEW SKIN",
localOnly = true,
preserveRig = true,
hideOriginal = false,
hideLeftLeg = true,
hideRightLeg = true,
clearOriginalWearables = true,
items = {70414871864071,14863917259,133498027006138,82277826177074},
accessorySlots = {[70414871864071]=Enum.AccessoryType.Waist,[14863917259]=Enum.AccessoryType.Neck,
[133498027006138]=Enum.AccessoryType.Shoulder,[82277826177074]=Enum.AccessoryType.Sweater},
},
}
local BODY_PART_NAMES = {
Head = true, UpperTorso = true, LowerTorso = true, Torso = true,
LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
RightUpperArm = true, RightLowerArm = true, RightHand = true,
LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
["Left Arm"] = true, ["Right Arm"] = true,
["Left Leg"] = true, ["Right Leg"] = true,
}
local PART_NAME_ALIASES = {
["Korblox-Deathspeaker-Right-Leg"] = "RightUpperLeg",
}
local state = {
enabled = false,
selected = 1,
visuals = {},
hidden = {},
wearableConn = nil,
headlessConn = nil,
headlessLoop = nil,
statsLoop = nil,
savedWalkSpeed = nil,
savedJumpPower = nil,
originalDescription = nil,
descriptionCharacter = nil,
connections = {},
}
local function currentCharacter()
local character = LP.Character or LP.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 8)
local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 8)
return character, humanoid, root
end
local function restoreOriginalBody()
for object, saved in pairs(state.hidden) do
if object and object.Parent then
pcall(function()
if type(saved) == "table" and saved.basePart then
object.LocalTransparencyModifier = saved.localTransparency
object.Transparency = saved.transparency
elseif type(saved) == "table" and saved.properties then
for property, value in pairs(saved.properties) do object[property] = value end
elseif type(saved) == "table" and saved.property then
object[saved.property] = saved.value
elseif object:IsA("BasePart") then
object.LocalTransparencyModifier = saved
elseif object:IsA("Decal") or object:IsA("Texture") then
object.Transparency = saved
end
end)
end
end
state.hidden = {}
end
local stopHeadless
local enforceHeadless
local function clearVisuals()
stopHeadless()
if state.wearableConn then
state.wearableConn:Disconnect()
state.wearableConn = nil
end
for _, object in ipairs(state.visuals) do
if object and object.Parent then pcall(function() object:Destroy() end) end
end
state.visuals = {}
restoreOriginalBody()
end
local function belongsToLocalVisual(object)
for _, visual in ipairs(state.visuals) do
if object == visual or object:IsDescendantOf(visual) then return true end
end
return false
end
local function hideOriginalBody(character)
restoreOriginalBody()
for _, object in ipairs(character:GetDescendants()) do
if not belongsToLocalVisual(object) then
if object:IsA("BasePart") then
state.hidden[object] = object.LocalTransparencyModifier
object.LocalTransparencyModifier = 1
elseif object:IsA("Decal") or object:IsA("Texture") then
state.hidden[object] = object.Transparency
object.Transparency = 1
end
end
end
end
local function hideOriginalHead(character)
local head = character:FindFirstChild("Head")
if not head or not head:IsA("BasePart") then return end
if state.hidden[head] == nil then
state.hidden[head] = {
basePart = true,
localTransparency = head.LocalTransparencyModifier,
transparency = head.Transparency,
}
elseif type(state.hidden[head]) ~= "table" then
state.hidden[head] = {
basePart = true,
localTransparency = state.hidden[head],
transparency = head.Transparency,
}
end
head.LocalTransparencyModifier = 1
head.Transparency = 1
for _, object in ipairs(head:GetDescendants()) do
if (object:IsA("Decal") or object:IsA("Texture")) and state.hidden[object] == nil then
state.hidden[object] = object.Transparency
object.Transparency = 1
end
end
end
local function hideLegSide(character, side)
local names = {side .. "UpperLeg", side .. "LowerLeg", side .. "Foot", side .. " Leg", side .. "Toe"}
for _, name in ipairs(names) do
local part = character:FindFirstChild(name)
if part and part:IsA("BasePart") then
if state.hidden[part] == nil then
state.hidden[part] = {
basePart = true,
localTransparency = part.LocalTransparencyModifier,
transparency = part.Transparency,
}
elseif type(state.hidden[part]) ~= "table" then
state.hidden[part] = {
basePart = true,
localTransparency = state.hidden[part],
transparency = part.Transparency,
}
end
part.LocalTransparencyModifier = 1
part.Transparency = 1
end
end
end
local function hideLeftLeg(character)
hideLegSide(character, "Left")
end
local function hideRightLeg(character)
hideLegSide(character, "Right")
end
stopHeadless = function()
if state.headlessConn then
pcall(state.headlessConn.Disconnect, state.headlessConn)
state.headlessConn = nil
end
if state.headlessLoop then
pcall(task.cancel, state.headlessLoop)
state.headlessLoop = nil
end
if state.statsLoop then
pcall(task.cancel, state.statsLoop)
state.statsLoop = nil
end
end
enforceHeadless = function(character, option)
stopHeadless()
if not option or not character or not (option.headless or option.hideLeftLeg or option.hideRightLeg) then return end
if option.headless then hideOriginalHead(character) end
if option.hideLeftLeg then hideLeftLeg(character) end
if option.hideRightLeg then hideRightLeg(character) end
state.headlessConn = character.ChildAdded:Connect(function(child)
if child:IsA("BasePart") and (option.hideLeftLeg or option.hideRightLeg) then
task.defer(function()
if state.enabled and LP.Character==character then
local active=OUTFITS[state.selected]
if active.hideLeftLeg then hideLeftLeg(character) end
if active.hideRightLeg then hideRightLeg(character) end end end) end
if child.Name == "Head" and child:IsA("BasePart") and OUTFITS[state.selected].headless then
task.defer(function()
if state.enabled and LP.Character == character and OUTFITS[state.selected].headless then
pcall(hideOriginalHead, character)
end
end)
end
end)
state.headlessLoop = task.spawn(function()
while state.enabled and LP.Character == character do
local opt = OUTFITS[state.selected]
if opt and opt.headless then
local head = character:FindFirstChild("Head")
if head and head:IsA("BasePart") and head.LocalTransparencyModifier < 1 then
pcall(hideOriginalHead, character)
end
end
if opt and opt.hideLeftLeg then
pcall(hideLeftLeg, character)
end
if opt and opt.hideRightLeg then
pcall(hideRightLeg, character)
end
task.wait(0.6)
end
end)
end
enforceStats = function(character)
if state.statsLoop then
pcall(task.cancel, state.statsLoop)
state.statsLoop = nil
end
state.statsLoop = task.spawn(function()
while state.enabled and LP.Character == character do
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
if state.savedWalkSpeed ~= nil and humanoid.WalkSpeed ~= state.savedWalkSpeed then
humanoid.WalkSpeed = state.savedWalkSpeed
end
if state.savedJumpPower ~= nil and humanoid.JumpPower ~= state.savedJumpPower then
humanoid.JumpPower = state.savedJumpPower
end
end
task.wait(0.4)
end
end)
end
local function hideOriginalWearables(character, watchForNew)
for _, child in ipairs(character:GetChildren()) do
if child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
if not child:GetAttribute("VX7LocalOnly") and state.hidden[child] == nil then
local property = child:IsA("Shirt") and "ShirtTemplate"
or child:IsA("Pants") and "PantsTemplate"
or "Graphic"
state.hidden[child] = {property = property, value = child[property]}
child[property] = ""
end
end
end
for _, child in ipairs(character:GetDescendants()) do
if (child:IsA("Accessory") or child:IsA("Accoutrement")) and not child:GetAttribute("VX7LocalOnly") then
local objects = child:GetDescendants()
if child:IsA("BasePart") then table.insert(objects, child) end
for _, object in ipairs(objects) do
if object:IsA("BasePart") then
local saved = state.hidden[object]
if saved == nil then
state.hidden[object] = {
basePart = true,
localTransparency = object.LocalTransparencyModifier,
transparency = object.Transparency,
}
elseif type(saved) ~= "table" then
state.hidden[object] = {
basePart = true,
localTransparency = saved,
transparency = object.Transparency,
}
end
object.LocalTransparencyModifier = 1
object.Transparency = 1
elseif (object:IsA("Decal") or object:IsA("Texture")) and state.hidden[object] == nil then
state.hidden[object] = object.Transparency
object.Transparency = 1
elseif (object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam")) and state.hidden[object] == nil then
state.hidden[object] = {property = "Enabled", value = object.Enabled}
object.Enabled = false
end
end
end
end
if watchForNew and not state.wearableConn then
state.wearableConn = character.DescendantAdded:Connect(function(object)
if not state.enabled or not OUTFITS[state.selected].clearOriginalWearables then return end
if object:IsA("Accessory") or object:IsA("Accoutrement")
or object:FindFirstAncestorWhichIsA("Accessory")
or object:FindFirstAncestorWhichIsA("Accoutrement") then
task.defer(function()
if state.enabled and character.Parent then hideOriginalWearables(character, false) end
end)
end
end)
end
end
local function loadAssetObjects(assetId)
local insertOk, inserted = pcall(function() return InsertService:LoadAsset(assetId) end)
if insertOk and inserted then return {inserted}, "InsertService" end
local objectOk, objects = pcall(function() return game:GetObjects("rbxassetid://" .. assetId) end)
if objectOk and objects and #objects > 0 then return objects, "GetObjects" end
return nil, tostring(inserted or objects or "unknown loading error")
end
local faceTextureCache = {}
local function resolveFaceTexture(faceId)
if faceTextureCache[faceId] then return faceTextureCache[faceId] end
local objects = loadAssetObjects(faceId)
if objects then
local texture
for _, root in ipairs(objects) do
local candidates = {root}
for _, object in ipairs(root:GetDescendants()) do table.insert(candidates, object) end
for _, object in ipairs(candidates) do
if object:IsA("Decal") or object:IsA("Texture") then
texture = object.Texture
if texture and texture ~= "" then break end
end
end
pcall(function() root:Destroy() end)
if texture and texture ~= "" then break end
end
if texture and texture ~= "" then
faceTextureCache[faceId] = texture
return texture
end
end
return "rbxassetid://" .. tostring(faceId)
end
local function applyLocalFace(character, faceId)
local head = character:FindFirstChild("Head")
if not head then return false end
local face = head:FindFirstChild("face") or head:FindFirstChildWhichIsA("Decal")
if face and not face:IsA("Decal") then face = nil end
if face then
if state.hidden[face] == nil then
state.hidden[face] = {
properties = {Texture = face.Texture, Transparency = face.Transparency},
}
end
else
face = Instance.new("Decal")
face.Name = "face"
face.Face = Enum.NormalId.Front
face:SetAttribute("VX7LocalOnly", true)
face.Parent = head
table.insert(state.visuals, face)
end
face.Texture = resolveFaceTexture(faceId)
face.Transparency = 0
return true
end
local function applyLocalFaceStable(character, faceId)
pcall(applyLocalFace, character, faceId)
for _, delayTime in ipairs({0.2, 0.8}) do
task.delay(delayTime, function()
local option = OUTFITS[state.selected]
if state.enabled and LP.Character == character and option and option.face == faceId then
pcall(applyLocalFace, character, faceId)
end
end)
end
end
local function findCharacterAttachment(character, name)
for _, object in ipairs(character:GetDescendants()) do
if object:IsA("Attachment") and object.Name == name and not object:FindFirstAncestorWhichIsA("Accessory") then
return object
end
end
end
local function sanitizeVisual(container)
local objects = container:GetDescendants()
if container:IsA("BasePart") then table.insert(objects, container) end
for _, object in ipairs(objects) do
if object:IsA("LuaSourceContainer") then
object:Destroy()
elseif object:IsA("BasePart") then
object.Anchored = false
object.CanCollide = false
object.CanTouch = false
object.CanQuery = false
object.Massless = true
object.CastShadow = false
elseif object:IsA("JointInstance") and object.Name == "AccessoryWeld" then
object:Destroy()
end
end
end
local function weldPart(part, target)
local weld = Instance.new("WeldConstraint")
weld.Name = "VX7LocalVisualWeld"
weld.Part0 = target
weld.Part1 = part
weld.Parent = part
end
local function countStackedAccessories(character, attachmentName)
local count = 0
for _, visual in ipairs(state.visuals) do
if visual:IsA("Accessory") then
local h = visual:FindFirstChild("Handle") or visual:FindFirstChildWhichIsA("BasePart", true)
if h then
for _, child in ipairs(h:GetChildren()) do
if child:IsA("Attachment") and child.Name == attachmentName then
count = count + 1
break
end
end
end
end
end
return count
end
local function attachAccessoryLocal(accessory, character, rootPart, assetId)
local handle = accessory:FindFirstChild("Handle") or accessory:FindFirstChildWhichIsA("BasePart", true)
if not handle then return false end
sanitizeVisual(accessory)
accessory.Name = "VX7_LocalOutfit_" .. tostring(assetId)
accessory:SetAttribute("VX7AssetId", assetId)
accessory:SetAttribute("VX7LocalOnly", true)
local option=OUTFITS[state.selected]
local slot=option and option.accessorySlots and option.accessorySlots[assetId]
if slot then pcall(function() accessory.AccessoryType=slot end) end
accessory.Parent = character
local sourceAttachment
for _, child in ipairs(handle:GetChildren()) do
if child:IsA("Attachment") and findCharacterAttachment(character, child.Name) then
sourceAttachment = child
break
end
end
local targetAttachment = sourceAttachment and findCharacterAttachment(character, sourceAttachment.Name)
local targetPart = targetAttachment and targetAttachment.Parent
if targetAttachment and targetPart and targetPart:IsA("BasePart") then
handle.CFrame = targetAttachment.WorldCFrame * sourceAttachment.CFrame:Inverse()
local stacked = countStackedAccessories(character, sourceAttachment.Name)
if stacked > 0 then
handle.CFrame = handle.CFrame * CFrame.new(0, stacked * 0.15, 0)
end
else
targetPart = character:FindFirstChild("LowerTorso")
or character:FindFirstChild("Torso")
or rootPart
if not targetPart then accessory:Destroy(); return false end
handle.CFrame = rootPart.CFrame
end
weldPart(handle, targetPart)
table.insert(state.visuals, accessory)
return true
end
local function attachLooseVisual(rootObject, character, rootPart, assetId, textureId, targetPart)
local clone = rootObject:Clone()
sanitizeVisual(clone)
clone.Name = "VX7_LocalOutfit_" .. tostring(assetId)
clone:SetAttribute("VX7AssetId", assetId)
clone.Parent = character
local parts = {}
if clone:IsA("BasePart") then table.insert(parts, clone) end
for _, object in ipairs(clone:GetDescendants()) do
if object:IsA("BasePart") then table.insert(parts, object) end
end
if #parts == 0 then clone:Destroy(); return false end
local anchor = targetPart or rootPart
if textureId then
for _, part in ipairs(parts) do
if part:IsA("MeshPart") then
pcall(function() part.TextureID = "rbxassetid://" .. tostring(textureId) end)
end
end
end
local pivot = clone:IsA("Model") and clone:GetPivot() or parts[1].CFrame
for _, part in ipairs(parts) do
local offset = pivot:ToObjectSpace(part.CFrame)
part.CFrame = anchor.CFrame * offset
weldPart(part, anchor)
end
table.insert(state.visuals, clone)
return true
end
local function attachClassicClothingLocal(rootObject, character, assetId)
local candidates = {}
if rootObject:IsA("Shirt") or rootObject:IsA("Pants") or rootObject:IsA("ShirtGraphic") then
table.insert(candidates, rootObject)
end
for _, object in ipairs(rootObject:GetDescendants()) do
if object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic") then
table.insert(candidates, object)
end
end
local added = 0
for _, source in ipairs(candidates) do
for _, existing in ipairs(character:GetChildren()) do
if existing.ClassName == source.ClassName and not existing:GetAttribute("VX7LocalOnly") then
local property = existing:IsA("Shirt") and "ShirtTemplate"
or existing:IsA("Pants") and "PantsTemplate"
or "Graphic"
state.hidden[existing] = {property = property, value = existing[property]}
existing[property] = ""
end
end
local clone = source:Clone()
clone.Name = "VX7_LocalClothing_" .. tostring(assetId)
clone:SetAttribute("VX7AssetId", assetId)
clone:SetAttribute("VX7LocalOnly", true)
clone.Parent = character
table.insert(state.visuals, clone)
added = added + 1
end
return added
end
local function attachBodyPartsLocal(rootObject, character, assetId, textureId)
local holder = Instance.new("Model")
holder.Name = "VX7_LocalBody_" .. tostring(assetId)
holder:SetAttribute("VX7AssetId", assetId)
holder:SetAttribute("VX7LocalOnly", true)
holder.Parent = character
local bodyColors = rootObject:FindFirstChildOfClass("BodyColors")
local colorProperties = {
Head = "HeadColor", UpperTorso = "TorsoColor", LowerTorso = "TorsoColor", Torso = "TorsoColor",
LeftUpperArm = "LeftArmColor", LeftLowerArm = "LeftArmColor", LeftHand = "LeftArmColor", ["Left Arm"] = "LeftArmColor",
RightUpperArm = "RightArmColor", RightLowerArm = "RightArmColor", RightHand = "RightArmColor", ["Right Arm"] = "RightArmColor",
LeftUpperLeg = "LeftLegColor", LeftLowerLeg = "LeftLegColor", LeftFoot = "LeftLegColor", ["Left Leg"] = "LeftLegColor",
RightUpperLeg = "RightLegColor", RightLowerLeg = "RightLegColor", RightFoot = "RightLegColor", ["Right Leg"] = "RightLegColor",
}
local added = 0
local candidates = {}
if rootObject:IsA("BasePart") then table.insert(candidates, rootObject) end
for _, object in ipairs(rootObject:GetDescendants()) do
if object:IsA("BasePart") and not object:FindFirstAncestorWhichIsA("Accessory") then
table.insert(candidates, object)
end
end
for _, source in ipairs(candidates) do
local partName = source.Name
if BODY_PART_NAMES[partName] then
local target = character:FindFirstChild(partName)
if not target then
local alias = PART_NAME_ALIASES[partName]
if alias then target = character:FindFirstChild(alias) end
end
if target and target:IsA("BasePart") then
local clone = source:Clone()
for _, child in ipairs(clone:GetDescendants()) do
if child:IsA("JointInstance") or child:IsA("Constraint") or child:IsA("LuaSourceContainer") then
child:Destroy()
end
end
sanitizeVisual(clone)
clone.Name = source.Name
if clone:IsA("MeshPart") and textureId then
pcall(function() clone.TextureID = "rbxassetid://" .. tostring(textureId) end)
end
if bodyColors and colorProperties[source.Name] then
pcall(function() clone.Color = bodyColors[colorProperties[source.Name]].Color end)
end
clone.CFrame = target.CFrame
clone.Parent = holder
weldPart(clone, target)
added = added + 1
end
end
end
if added == 0 then holder:Destroy(); return 0 end
table.insert(state.visuals, holder)
return added
end
local assetInfoCache = {}
local ASSET_INFO_CACHE_FILE="vx7/Vx7SkinPreviewAssets.json"
pcall(function()
if isfile and readfile and isfile(ASSET_INFO_CACHE_FILE) then
local decoded=HttpService:JSONDecode(readfile(ASSET_INFO_CACHE_FILE))
if type(decoded)=="table" then for id,assetType in pairs(decoded) do
local numericId=tonumber(id);local numericType=tonumber(assetType)
if numericId and numericType then assetInfoCache[numericId]=numericType end end end end end)
local assetInfoSaveQueued=false
local function saveAssetInfoCache()
if assetInfoSaveQueued or not writefile then return end
assetInfoSaveQueued=true;task.delay(.4,function()
assetInfoSaveQueued=false;pcall(function()
local encoded={};for id,assetType in pairs(assetInfoCache) do encoded[tostring(id)]=assetType end
writefile(ASSET_INFO_CACHE_FILE,HttpService:JSONEncode(encoded)) end) end) end
local bodyPropertyByType = {
[17] = "Head", [27] = "Torso", [28] = "RightArm",
[29] = "LeftArm", [30] = "LeftLeg", [31] = "RightLeg", [79] = "Head",
}
local bodyPartAnchorNames = {
[17] = {"Head"}, [79] = {"Head"},
[27] = {"UpperTorso", "Torso"},
[28] = {"RightUpperArm", "Right Arm"},
[29] = {"LeftUpperArm", "Left Arm"},
[30] = {"LeftUpperLeg", "Left Leg"},
[31] = {"RightUpperLeg", "Right Leg"},
}
local accessoryTypeByAssetType = {
[8] = Enum.AccessoryType.Hat,
[41] = Enum.AccessoryType.Hair,
[42] = Enum.AccessoryType.Face,
[43] = Enum.AccessoryType.Neck,
[44] = Enum.AccessoryType.Shoulder,
[45] = Enum.AccessoryType.Front,
[46] = Enum.AccessoryType.Back,
[47] = Enum.AccessoryType.Waist,
[64] = Enum.AccessoryType.TShirt,
[65] = Enum.AccessoryType.Shirt,
[66] = Enum.AccessoryType.Pants,
[67] = Enum.AccessoryType.Jacket,
[68] = Enum.AccessoryType.Sweater,
[69] = Enum.AccessoryType.Shorts,
[70] = Enum.AccessoryType.LeftShoe,
[71] = Enum.AccessoryType.RightShoe,
[72] = Enum.AccessoryType.DressSkirt,
[76] = Enum.AccessoryType.Eyebrow,
[77] = Enum.AccessoryType.Eyelash,
}
local function getAssetTypeId(assetId)
if assetInfoCache[assetId] then return assetInfoCache[assetId] end
local ok, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, assetId, Enum.InfoType.Asset)
if ok and info and info.AssetTypeId then
assetInfoCache[assetId] = info.AssetTypeId
saveAssetInfoCache()
return info.AssetTypeId
end
end
local accessoryDescriptionProperties = {
"BackAccessory", "FaceAccessory", "FrontAccessory", "HairAccessory",
"HatAccessory", "NeckAccessory", "ShouldersAccessory", "WaistAccessory",
"TShirtAccessory", "ShirtAccessory", "PantsAccessory", "JacketAccessory",
"SweaterAccessory", "ShortsAccessory", "DressSkirtAccessory",
"EyebrowAccessory", "EyelashAccessory",
}
local function createDirectDescription(option, humanoid)
local directOutfitId = option.outfitId
local completeOutfitDescription
if directOutfitId then
local ok, outfitDescription = pcall(
Players.GetHumanoidDescriptionFromOutfitId,
Players,
directOutfitId
)
if not ok or not outfitDescription then return nil end
completeOutfitDescription = outfitDescription
if not option.items and not option.face and not option.head then return outfitDescription end
end
local source = completeOutfitDescription or state.originalDescription
if not source then
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if not ok or not applied then return nil end
source = applied
end
local description = source:Clone()
if completeOutfitDescription then completeOutfitDescription:Destroy() end
if not directOutfitId then
description.Shirt = 0
description.Pants = 0
description.GraphicTShirt = 0
for _, property in ipairs(accessoryDescriptionProperties) do
pcall(function() description[property] = "" end)
end
pcall(function() description:SetAccessories({}, true) end)
end
local accessories = {}
if directOutfitId then
pcall(function() accessories = description:GetAccessories(true) end)
end
local allItems = {}
for _, id in ipairs(option.bodyItems or {}) do table.insert(allItems, id) end
for _, id in ipairs(option.items or {}) do table.insert(allItems, id) end
for _, id in ipairs(allItems) do
local assetTypeId = getAssetTypeId(id)
if not assetTypeId then description:Destroy(); return nil end
local bodyProperty = bodyPropertyByType[assetTypeId]
local accessoryType = accessoryTypeByAssetType[assetTypeId]
if bodyProperty then
description[bodyProperty] = id
elseif assetTypeId == 11 then
description.Shirt = id
elseif assetTypeId == 12 then
description.Pants = id
elseif assetTypeId == 1 then
description.GraphicTShirt = id
elseif assetTypeId == 18 then
description.Face = id
elseif accessoryType then
local accessory = {
AssetId = id,
AccessoryType = accessoryType,
Order = #accessories + 1,
}
if assetTypeId >= 64 and assetTypeId <= 72 then
accessory.IsLayered = true
accessory.Puffiness = option.layeredPuffiness or 0
end
table.insert(accessories, accessory)
else
description:Destroy()
return nil
end
end
if option.face then
local faceTypeId = getAssetTypeId(option.face)
local faceBodyProperty = faceTypeId and bodyPropertyByType[faceTypeId]
local faceAccessoryType = faceTypeId and accessoryTypeByAssetType[faceTypeId]
if option.faceMode == "decal" then
if faceTypeId == 18 then description.Face = option.face end
elseif faceBodyProperty then
description[faceBodyProperty] = option.face
elseif faceAccessoryType then
table.insert(accessories, {
AssetId = option.face,
AccessoryType = faceAccessoryType,
Order = #accessories + 1,
})
elseif faceTypeId == 18 then
description.Face = option.face
end
end
if option.head then description.Head = option.head end
for property, value in pairs(option.scales or {}) do
pcall(function() description[property] = value end)
end
if option.skinColor then
for _, property in ipairs({"HeadColor", "LeftArmColor", "RightArmColor", "LeftLegColor", "RightLegColor", "TorsoColor"}) do
description[property] = option.skinColor
end
end
if #accessories > 0 then
local ok = pcall(function() description:SetAccessories(accessories, true) end)
if not ok then description:Destroy(); return nil end
end
return description
end
local statusText
local function setStatus(text, good)
if not statusText or not statusText.Parent then return end
statusText.Text = text
statusText.TextColor3 = good and Color3.fromRGB(215, 255, 222) or Color3.fromRGB(190, 190, 198)
end
local function applyOutfit()
local character, humanoid, rootPart = currentCharacter()
if not character or not humanoid or not rootPart then setStatus("Character not found", false); return false end
if state.descriptionCharacter ~= character or not state.originalDescription then
state.descriptionCharacter = character
state.originalDescription = nil
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if ok and applied then state.originalDescription = applied:Clone() end
end
clearVisuals()
setStatus("Loading local visual...", false)
local option = OUTFITS[state.selected]
local assetId = option.id or option.outfitId
state.skipDescriptionRestore=option.preserveRig==true
if option.forceBodyParts or option.localOnly then
setStatus("Local visual only (no rig change)...", false)
end
if (option.bodyItems or option.items or option.outfitId) and not option.forceBodyParts and not option.localOnly then
setStatus(option.outfitId and "Loading complete outfit..." or "Applying outfit and complexion...", false)
local description = createDirectDescription(option, humanoid)
if description then
local savedHead = character:FindFirstChild("Head")
local savedHealth = humanoid.Health
state.savedWalkSpeed = humanoid.WalkSpeed
state.savedJumpPower = humanoid.JumpPower
local savedCFrame = rootPart.CFrame
local savedVelocity = rootPart.AssemblyLinearVelocity
local ok = pcall(function() humanoid:ApplyDescription(description) end)
if not ok then ok = pcall(function() humanoid:ApplyDescriptionReset(description) end) end
description:Destroy()
if ok then
local currentHumanoid = character:FindFirstChildOfClass("Humanoid")
local currentRoot = character:FindFirstChild("HumanoidRootPart")
if currentHumanoid and savedHealth > 0 then
currentHumanoid.Health = math.min(savedHealth, currentHumanoid.MaxHealth)
end
if currentRoot then
currentRoot.CFrame = savedCFrame
currentRoot.AssemblyLinearVelocity = savedVelocity
currentRoot.AssemblyAngularVelocity = Vector3.zero
end
if option.face then
local faceTypeId = getAssetTypeId(option.face)
if option.faceMode == "decal" or not faceTypeId or faceTypeId == 18 then
applyLocalFaceStable(character, option.face)
end
end
state.enabled = true
enforceStats(character)
enforceHeadless(character, option)
if option.hideLeftLeg then hideLeftLeg(character) end
if option.hideRightLeg then hideRightLeg(character) end
if option.head and character:FindFirstChild("Head") == savedHead then
hideOriginalHead(character)
end
setStatus(option.label .. " applied - native avatar method", true)
return true
end
end
setStatus("Native apply failed; using visual fallback...", false)
end
local assetIds = {}
for _, id in ipairs(option.items or {}) do table.insert(assetIds, id) end
if option.head then table.insert(assetIds, option.head) end
if #assetIds == 0 and assetId and not option.outfitId then table.insert(assetIds, assetId) end
local fallbackFaceType = option.face and getAssetTypeId(option.face)
local faceIsAccessory = option.faceMode ~= "decal"
and fallbackFaceType
and accessoryTypeByAssetType[fallbackFaceType] ~= nil
if faceIsAccessory then table.insert(assetIds, option.face) end
local attached, expected = 0, 0
local lastError
expected = expected + (option.face and not faceIsAccessory and 1 or 0)
for _, currentAssetId in ipairs(assetIds) do
local objects, method = loadAssetObjects(currentAssetId)
if objects then
for _, loadedRoot in ipairs(objects) do
local rootAttached = false
local bodyPartsAttached = false
local classics = {}
if loadedRoot:IsA("Shirt") or loadedRoot:IsA("Pants") or loadedRoot:IsA("ShirtGraphic") then
table.insert(classics, loadedRoot)
end
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic") then
table.insert(classics, object)
end
end
local accessories = {}
if loadedRoot:IsA("Accessory") then
table.insert(accessories, loadedRoot)
else
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("Accessory") then table.insert(accessories, object:Clone()) end
end
end
local assetTypeId = getAssetTypeId(currentAssetId)
local isBodyPartAsset = assetTypeId ~= nil and bodyPropertyByType[assetTypeId] ~= nil
local bodyCandidates = 0
local wantsBodyParts = not loadedRoot:IsA("Accessory")
and (option.hideOriginal or option.hideOriginalHead or currentAssetId == option.head or (option.forceBodyParts and isBodyPartAsset))
if wantsBodyParts then
local candidates = {}
if loadedRoot:IsA("BasePart") then table.insert(candidates, loadedRoot) end
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("BasePart") and not object:FindFirstAncestorWhichIsA("Accessory") then
table.insert(candidates, object)
end
end
for _, object in ipairs(candidates) do
if BODY_PART_NAMES[object.Name] or PART_NAME_ALIASES[object.Name] then bodyCandidates = bodyCandidates + 1 end
end
end
expected = expected + #classics + #accessories + bodyCandidates
if #accessories == 0 and #classics == 0 and bodyCandidates == 0 then expected = expected + 1 end
if #classics > 0 then
local ok, result = pcall(attachClassicClothingLocal, loadedRoot, character, currentAssetId)
if ok and result and result > 0 then attached = attached + result; rootAttached = true end
end
if wantsBodyParts and bodyCandidates > 0 then
local ok, result = pcall(attachBodyPartsLocal, loadedRoot, character, currentAssetId, option.headTexture)
if ok and result and result > 0 then
attached = attached + result
rootAttached = true
bodyPartsAttached = true
end
end
for _, accessory in ipairs(accessories) do
local ok, result = pcall(attachAccessoryLocal, accessory, character, rootPart, currentAssetId)
if ok and result then
attached = attached + 1
rootAttached = true
else
pcall(function() accessory:Destroy() end)
end
end
if not rootAttached and not bodyPartsAttached and #accessories == 0 and #classics == 0 then
local headAnchor = character:FindFirstChild("Head")
local anchor = rootPart
if currentAssetId == option.head then
anchor = headAnchor
elseif isBodyPartAsset then
local anchorNames = bodyPartAnchorNames[assetTypeId]
if anchorNames then
for _, name in ipairs(anchorNames) do
local target = character:FindFirstChild(name)
if target and target:IsA("BasePart") then anchor = target; break end
end
end
end
local ok, result = pcall(attachLooseVisual, loadedRoot, character, rootPart, currentAssetId, option.headTexture, anchor)
if ok and result then attached = attached + 1 end
end
if loadedRoot.Parent == nil and not table.find(state.visuals, loadedRoot) then
pcall(function() loadedRoot:Destroy() end)
end
end
else
lastError = method
end
end
local faceApplied = false
if option.face and not faceIsAccessory then
local ok, result = pcall(applyLocalFace, character, option.face)
faceApplied = ok and result == true
end
local headlessApplied = false
if option.headless then
enforceHeadless(character, option)
headlessApplied = true
end
local legApplied = false
if option.hideLeftLeg then
hideLeftLeg(character)
legApplied = true
end
if option.hideRightLeg then
hideRightLeg(character)
legApplied = true
end
local totalItems = expected
local loadedItems = attached + (faceApplied and 1 or 0)
state.enabled = attached > 0 or faceApplied or headlessApplied or legApplied
if state.enabled then
if option.preserveRig and (option.hideLeftLeg or option.hideRightLeg) then enforceHeadless(character,option) end
if option.hideOriginal then hideOriginalBody(character) end
if option.hideOriginalHead then hideOriginalHead(character) end
if option.head then hideOriginalHead(character) end
if option.clearOriginalWearables then hideOriginalWearables(character, true) end
setStatus(string.format("%s fallback - %d/%d items", option.label, loadedItems, totalItems), loadedItems == totalItems)
else
setStatus("Could not attach outfit - " .. tostring(lastError or "no 3D parts"), false)
end
return state.enabled
end
local function restoreOriginalDescription()
local description = state.originalDescription
local character = LP.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if description and humanoid and character == state.descriptionCharacter and not state.skipDescriptionRestore then
local clone = description:Clone()
local ok = pcall(function() humanoid:ApplyDescription(clone) end)
if not ok then pcall(function() humanoid:ApplyDescriptionReset(clone) end) end
clone:Destroy()
end
if state.originalDescription then state.originalDescription:Destroy() end
state.originalDescription = nil
state.descriptionCharacter = nil
state.skipDescriptionRestore=false
end
local function removeOutfit()
state.enabled = false
clearVisuals()
restoreOriginalDescription()
setStatus("Local visual removed", true)
end
return {
outfits = OUTFITS,
apply = function(index)
state.selected = math.clamp(math.floor(tonumber(index) or 1), 1, #OUTFITS)
return applyOutfit()
end,
remove = removeOutfit,
description = function(index)
local character = LP.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
local option = OUTFITS[math.clamp(math.floor(tonumber(index) or 1), 1, #OUTFITS)]
if not humanoid or not option then return nil end
local strict = createDirectDescription(option, humanoid)
if strict then return strict end
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if not ok or not applied then return nil end
local description = applied:Clone(); applied:Destroy()
description.Shirt=0; description.Pants=0; description.GraphicTShirt=0
for _,property in ipairs(accessoryDescriptionProperties) do pcall(function() description[property]="" end) end
pcall(function() description:SetAccessories({},true) end)
local accessories={}; local all={}
for _,id in ipairs(option.bodyItems or {}) do table.insert(all,id) end
for _,id in ipairs(option.items or {}) do table.insert(all,id) end
for _,id in ipairs(all) do
local assetTypeId=getAssetTypeId(id); local bodyProperty=assetTypeId and bodyPropertyByType[assetTypeId]; local accessoryType=assetTypeId and accessoryTypeByAssetType[assetTypeId]
if bodyProperty then description[bodyProperty]=id elseif assetTypeId==11 then description.Shirt=id elseif assetTypeId==12 then description.Pants=id elseif assetTypeId==1 then description.GraphicTShirt=id elseif assetTypeId==18 then description.Face=id elseif accessoryType then
table.insert(accessories,{AssetId=id,AccessoryType=accessoryType,Order=#accessories+1,IsLayered=assetTypeId>=64 and assetTypeId<=72,Puffiness=option.layeredPuffiness or 0}) end
end
if option.face then local faceType=getAssetTypeId(option.face); if faceType==18 then description.Face=option.face elseif faceType and bodyPropertyByType[faceType] then description[bodyPropertyByType[faceType]]=option.face elseif faceType and accessoryTypeByAssetType[faceType] then table.insert(accessories,{AssetId=option.face,AccessoryType=accessoryTypeByAssetType[faceType],Order=#accessories+1}) end end
if option.head then description.Head=option.head end
for property,value in pairs(option.scales or {}) do pcall(function() description[property]=value end) end
if #accessories>0 then pcall(function() description:SetAccessories(accessories,true) end) end
return description
end,
previewModel = function(index)
local option=OUTFITS[math.clamp(math.floor(tonumber(index) or 1),1,#OUTFITS)]; local character=LP.Character
if not option or not character then return nil end
local oldArchivable=character.Archivable; character.Archivable=true; local ok,clone=pcall(function() return character:Clone() end); character.Archivable=oldArchivable
if not ok or not clone then return nil end
for _,child in ipairs(clone:GetChildren()) do
if child:IsA("Accessory") or child:IsA("Accoutrement") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("CharacterMesh") or child:IsA("Tool") then child:Destroy() end
end
for _,object in ipairs(clone:GetDescendants()) do if object:IsA("LuaSourceContainer") then object:Destroy() elseif object:IsA("BasePart") then object.Transparency=object.Name=="HumanoidRootPart" and 1 or 0; object.LocalTransparencyModifier=0 end end
local root=clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("LowerTorso") or clone:FindFirstChild("Torso")
if not root then clone:Destroy(); return nil end
local savedVisuals,savedHidden,savedWearable=state.visuals,state.hidden,state.wearableConn; state.visuals={}; state.hidden={}; state.wearableConn=nil
local ids={}; for _,id in ipairs(option.bodyItems or {}) do table.insert(ids,id) end; for _,id in ipairs(option.items or {}) do table.insert(ids,id) end
if option.head then table.insert(ids,option.head) end; if option.face and option.faceMode~="decal" then table.insert(ids,option.face) end
for _,id in ipairs(ids) do
local objects=loadAssetObjects(id)
if objects then for _,loadedRoot in ipairs(objects) do
pcall(attachClassicClothingLocal,loadedRoot,clone,id)
local accessories={}; if loadedRoot:IsA("Accessory") then table.insert(accessories,loadedRoot) else for _,object in ipairs(loadedRoot:GetDescendants()) do if object:IsA("Accessory") then table.insert(accessories,object:Clone()) end end end
for _,accessory in ipairs(accessories) do pcall(attachAccessoryLocal,accessory,clone,root,id) end
local isBody=table.find(option.bodyItems or {},id)~=nil or id==option.head
if isBody then pcall(attachBodyPartsLocal,loadedRoot,clone,id,option.headTexture) end
if loadedRoot.Parent and not table.find(state.visuals,loadedRoot) then pcall(function() loadedRoot:Destroy() end) end
end end
end
state.visuals,state.hidden,state.wearableConn=savedVisuals,savedHidden,savedWearable
if option.face and option.faceMode=="decal" then local head=clone:FindFirstChild("Head"); if head then local face=head:FindFirstChild("face") or head:FindFirstChildWhichIsA("Decal"); if not face then face=Instance.new("Decal"); face.Name="face"; face.Face=Enum.NormalId.Front; face.Parent=head end; face.Texture=resolveFaceTexture(option.face); face.Transparency=0 end end
if option.headless or option.hideOriginalHead then local head=clone:FindFirstChild("Head"); if head then head.Transparency=1; for _,v in ipairs(head:GetDescendants()) do if v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1 end end end end
if option.hideRightLeg then for _,name in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot","Right Leg"}) do local part=clone:FindFirstChild(name); if part then part.Transparency=1 end end end
return clone
end,
cleanup = function()
state.enabled = false
clearVisuals()
restoreOriginalDescription()
end,
}
]=]
        pcall(function()
            if type(loadstring) == "function" then
                local factory = loadstring(VX7_SKIN_ENGINE_SOURCE)
                if factory then
                    local ok, result = pcall(factory)
                    if ok and type(result) == "table" then
                        VX7_SKIN_ENGINE = result
                    end
                end
            end
        end)

        local ADAPT_BUNDLES = { ADAPT = {263995361762992}, BLACK = {263995361762992} }
        local bundleCache = {}
        local originalCosmetics = nil
        local originalHeadState = nil
        local enabled = false
        local preset = "ADAPT"
        local characterConn
        local gallery

        local saveFile = "AdaptSkin_" .. tostring(LP.UserId) .. ".json"

        local function saveState()
            if type(writefile) ~= "function" then return end
            pcall(function()
                writefile(saveFile, HS:JSONEncode({version = 2, enabled = enabled, preset = preset}))
            end)
        end

        local function loadState()
            if type(readfile) ~= "function" or type(isfile) ~= "function" then return end
            pcall(function()
                if not isfile(saveFile) then return end
                local data = HS:JSONDecode(readfile(saveFile))
                if type(data) == "table" then
                    enabled = data.enabled == true
                    if type(data.preset) == "string" then
                        local savedPreset = string.upper(data.preset)
                        if ADAPT_PRESETS[savedPreset] or GALLERY_REFERENCE_PRESETS[savedPreset] then
                            preset = savedPreset
                        end
                    end
                end
            end)
        end

        local function getBundleAssets(bundleId)
            if bundleCache[bundleId] then return bundleCache[bundleId] end
            local ids = {}
            pcall(function()
                local result = game:GetService("AssetService"):GetBundleDetailsAsync(bundleId)
                if result and type(result.Items) == "table" then
                    for _, item in ipairs(result.Items) do
                        if item.Type == "Asset" and tonumber(item.Id) then
                            ids[#ids + 1] = tonumber(item.Id)
                        end
                    end
                end
            end)
            bundleCache[bundleId] = ids
            return ids
        end

        local function isGalleryReferencePreset(name)
            return GALLERY_REFERENCE_PRESETS[string.upper(tostring(name or ""))] ~= nil
        end

        local function getPresetIds(name)
            local ids = {}
            for _, id in ipairs(ADAPT_PRESETS[name] or {}) do ids[#ids + 1] = id end
            for _, bundleId in ipairs(ADAPT_BUNDLES[name] or {}) do
                for _, id in ipairs(getBundleAssets(bundleId)) do ids[#ids + 1] = id end
            end
            return ids
        end

        local function getObjects(id)
            local ok, result = pcall(function()
                return game:GetObjects("rbxassetid://" .. tostring(id))
            end)
            if ok and type(result) == "table" and #result > 0 then return result end

            local loaded
            pcall(function()
                loaded = game:GetService("InsertService"):LoadAsset(tonumber(id))
            end)
            if loaded then return {loaded} end
            return {}
        end

        local function snapshotCharacter(character)
            if originalCosmetics then return end
            originalCosmetics = {}
            originalHeadState = nil

            local head = character:FindFirstChild("Head")
            if head and head:IsA("BasePart") then
                originalHeadState = {
                    partTransparency = head.Transparency,
                    localTransparency = head.LocalTransparencyModifier,
                    decals = {},
                }
                for _, child in ipairs(head:GetChildren()) do
                    if child:IsA("Decal") or child:IsA("Texture") or child:IsA("BasePart") then
                        originalHeadState.decals[#originalHeadState.decals + 1] = {
                            object = child,
                            transparency = child.Transparency,
                            localTransparency = child:IsA("BasePart") and child.LocalTransparencyModifier or nil,
                        }
                    end
                end
            end

            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
                    local ok, clone = pcall(function() return child:Clone() end)
                    if ok and clone then originalCosmetics[#originalCosmetics + 1] = clone end
                end
            end
        end

        local function hideDefaultHead(character)
            local head = character and character:FindFirstChild("Head")
            if not head or not head:IsA("BasePart") then return end
            head.Transparency = 1
            head.LocalTransparencyModifier = 1
            for _, child in ipairs(head:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") or child:IsA("BasePart") then
                    child.Transparency = 1
                    if child:IsA("BasePart") then
                        child.LocalTransparencyModifier = 1
                    end
                end
            end
        end

        local function restoreDefaultHead(character)
            if not originalHeadState then return end
            local head = character and character:FindFirstChild("Head")
            if head and head:IsA("BasePart") then
                head.Transparency = originalHeadState.partTransparency
                head.LocalTransparencyModifier = originalHeadState.localTransparency
            end
            for _, state in ipairs(originalHeadState.decals or {}) do
                local obj = state.object
                if obj and obj.Parent then
                    obj.Transparency = state.transparency
                    if obj:IsA("BasePart") and state.localTransparency ~= nil then
                        obj.LocalTransparencyModifier = state.localTransparency
                    end
                end
            end
            originalHeadState = nil
        end

        local function clearAdapt(character)
            for _, child in ipairs(character:GetChildren()) do
                if child:GetAttribute("AdaptSkin") then
                    child:Destroy()
                end
            end
            local old = character:FindFirstChild("AdaptKorblox_RightLeg")
            if old then old:Destroy() end
            local r1 = character:FindFirstChild("RightUpperLeg")
            local r2 = character:FindFirstChild("RightLowerLeg")
            local r3 = character:FindFirstChild("RightFoot")
            for _, leg in ipairs({r1, r2, r3}) do
                if leg and leg:IsA("BasePart") then
                    leg.Transparency = 0
                    leg.LocalTransparencyModifier = 0
                end
            end
        end

        local function clearAllCosmetics(character)
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
                    child:Destroy()
                end
            end
        end

        local function addAsset(character, humanoid, object)
            -- Same asset handling used by the reference AdaptSkin system:
            -- Accessory/Shirt/Pants/ShirtGraphic are all supported, and
            -- accessories get an attachment weld fallback if AddAccessory fails.
            local objects = {}
            if object:IsA("Accessory") or object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic") then
                objects[1] = object
            else
                for _, d in ipairs(object:GetDescendants()) do
                    if d:IsA("Accessory") or d:IsA("Shirt") or d:IsA("Pants") or d:IsA("ShirtGraphic") then
                        objects[#objects + 1] = d
                    end
                end
            end

            for _, source in ipairs(objects) do
                local clone = source:Clone()
                clone:SetAttribute("AdaptSkin", true)

                if clone:IsA("Accessory") then
                    local handle = clone:FindFirstChild("Handle")
                    local attached = false
                    pcall(function()
                        humanoid:AddAccessory(clone)
                        attached = clone.Parent == character
                    end)
                    if clone.Parent ~= character then
                        clone.Parent = character
                    end

                    -- Exact fallback behavior from the reference: position the
                    -- accessory by matching its attachment to the character.
                    if handle and handle:IsA("BasePart") and not handle:FindFirstChild("AccessoryWeld") then
                        local attachment = handle:FindFirstChildWhichIsA("Attachment")
                        if attachment then
                            local targetAttachment
                            for _, d in ipairs(character:GetDescendants()) do
                                if d:IsA("Attachment") and d.Name == attachment.Name and not d:IsDescendantOf(clone) then
                                    targetAttachment = d
                                    break
                                end
                            end
                            local targetPart = targetAttachment and targetAttachment.Parent
                            if targetPart and targetPart:IsA("BasePart") then
                                handle.Anchored = false
                                handle.CanCollide = false
                                handle.CanTouch = false
                                handle.CanQuery = false
                                handle.Massless = true
                                handle.CFrame = targetPart.CFrame * targetAttachment.CFrame * attachment.CFrame:Inverse()
                                local weld = Instance.new("WeldConstraint")
                                weld.Name = "AdaptAccessoryWeld"
                                weld.Part0 = targetPart
                                weld.Part1 = handle
                                weld.Parent = handle
                            end
                        end
                    end
                else
                    for _, old in ipairs(character:GetChildren()) do
                        if old.ClassName == clone.ClassName and old:GetAttribute("AdaptSkin") then
                            old:Destroy()
                        end
                    end
                    clone.Parent = character
                end
            end
        end

        local function applyKorblox(character)
            if not character then return false end

            local old = character:FindFirstChild("AdaptKorblox_RightLeg")
            if old then old:Destroy() end
            old = character:FindFirstChild("Korblox_RightLeg")
            if old then old:Destroy() end

            local rightUpperLeg = character:FindFirstChild("RightUpperLeg")
            if not rightUpperLeg or not rightUpperLeg:IsA("BasePart") then
                return false
            end

            local ok, result = pcall(function()
                return game:GetObjects("rbxassetid://139607718")
            end)
            if not ok or not result or not result[1] then
                return false
            end

            local model = result[1]
            model.Name = "AdaptKorblox_RightLeg"
            model:SetAttribute("AdaptSkin", true)
            local part = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
            if not part then
                model:Destroy()
                return false
            end

            for _, name in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
                local leg = character:FindFirstChild(name)
                if leg and leg:IsA("BasePart") then
                    leg.Transparency = 1
                    leg.LocalTransparencyModifier = 1
                end
            end

            part.Anchored = false
            part.CanCollide = false
            part.CanTouch = false
            part.CanQuery = false
            part.Massless = true
            part.CFrame = rightUpperLeg.CFrame

            local weld = Instance.new("WeldConstraint")
            weld.Name = "AdaptKorbloxWeld"
            weld.Part0 = rightUpperLeg
            weld.Part1 = part
            weld.Parent = part
            model.Parent = character
            return true
        end

        function Adapt.Apply()
            if not enabled then return end
            local character = LP.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not character or not humanoid then return end

            -- Las skins de Hood Style usan el motor real de SKIN COLLECTION.
            -- No hacemos clearAdapt/clearAllCosmetics antes, porque el motor
            -- necesita capturar el avatar original para poder restaurarlo.
            if isGalleryReferencePreset(preset) and VX7_SKIN_ENGINE and VX7_SKIN_ENGINE.apply then
                pcall(VX7_SKIN_ENGINE.remove)
                pcall(VX7_SKIN_ENGINE.apply, VX7_SKIN_INDEX[preset])
                return
            end

            -- Sistema original de ADAPT para ADAPT/RED/BLUE/GALAXY.
            snapshotCharacter(character)
            clearAdapt(character)
            clearAllCosmetics(character)

            for _, id in ipairs(getPresetIds(preset)) do
                for _, object in ipairs(getObjects(id)) do
                    pcall(addAsset, character, humanoid, object)
                    pcall(function() object:Destroy() end)
                end
            end

            -- Same final steps as the reference implementation: hide the
            -- default R15 head and add the special Korblox leg.
            hideDefaultHead(character)
            applyKorblox(character)
        end

        function Adapt.Disable()
            local character = LP.Character
            if VX7_SKIN_ENGINE and VX7_SKIN_ENGINE.remove then
                pcall(VX7_SKIN_ENGINE.remove)
            end
            if not character then return end
            clearAdapt(character)
            clearAllCosmetics(character)

            if originalCosmetics then
                for _, saved in ipairs(originalCosmetics) do
                    if saved and saved.Parent == nil then
                        pcall(function() saved:Clone().Parent = character end)
                    end
                end
            end
            restoreDefaultHead(character)
            originalCosmetics = nil
        end

        function Adapt.SetPreset(name, dontSave)
            name = string.upper(tostring(name or ""))
            if not ADAPT_PRESETS[name] and not GALLERY_REFERENCE_PRESETS[name] then return end
            if isGalleryReferencePreset(preset) and not isGalleryReferencePreset(name) and VX7_SKIN_ENGINE and VX7_SKIN_ENGINE.remove then
                pcall(VX7_SKIN_ENGINE.remove)
            end
            preset = name
            if enabled then
                task.spawn(Adapt.Apply)
            end
            if not dontSave then saveState() end
        end

        function Adapt.SetEnabled(on, dontSave)
            enabled = on == true
            if enabled then
                task.spawn(Adapt.Apply)
            else
                Adapt.Disable()
            end
            if not dontSave then saveState() end
        end

        function Adapt.IsEnabled() return enabled end
        function Adapt.GetPreset() return preset end

        loadState()

        characterConn = LP.CharacterAdded:Connect(function()
            originalCosmetics = nil
            originalHeadState = nil
            if enabled then
                task.delay(0.35, function()
                    if enabled then pcall(Adapt.Apply) end
                end)
                task.delay(1.15, function()
                    if enabled then pcall(Adapt.Apply) end
                end)
            end
        end)

        -- Preview: el sistema original no clona el Character del jugador.
        -- Crea un rig R15 limpio y le aplica los mismos assets del preset.
        local function applyAssetToRig(parent, humanoid, assetId)
            local ok, result = pcall(function()
                return game:GetObjects("rbxassetid://" .. tostring(assetId))
            end)
            if not ok or type(result) ~= "table" or #result == 0 then
                local loaded
                pcall(function()
                    loaded = game:GetService("InsertService"):LoadAsset(tonumber(assetId))
                end)
                if loaded then result = {loaded} else result = {} end
            end

            local applied = false
            for _, root in ipairs(result) do
                local objects = {}
                if root:IsA("Accessory") or root:IsA("Shirt") or root:IsA("Pants") or root:IsA("ShirtGraphic") then
                    objects[1] = root
                else
                    for _, d in ipairs(root:GetDescendants()) do
                        if d:IsA("Accessory") or d:IsA("Shirt") or d:IsA("Pants") or d:IsA("ShirtGraphic") then
                            objects[#objects + 1] = d
                        end
                    end
                end

                for _, source in ipairs(objects) do
                    local clone = source:Clone()
                    clone:SetAttribute("AdaptSkin", true)
                    if clone:IsA("Accessory") then
                        pcall(function() humanoid:AddAccessory(clone) end)
                        if clone.Parent ~= parent then clone.Parent = parent end
                        local handle = clone:FindFirstChild("Handle")
                        if handle and handle:IsA("BasePart") and not handle:FindFirstChild("AccessoryWeld") then
                            local attachment = handle:FindFirstChildWhichIsA("Attachment")
                            if attachment then
                                local targetAttachment
                                for _, d in ipairs(parent:GetDescendants()) do
                                    if d:IsA("Attachment") and d.Name == attachment.Name and not d:IsDescendantOf(clone) then
                                        targetAttachment = d
                                        break
                                    end
                                end
                                local targetPart = targetAttachment and targetAttachment.Parent
                                if targetPart and targetPart:IsA("BasePart") then
                                    handle.Anchored = false
                                    handle.CanCollide = false
                                    handle.CanTouch = false
                                    handle.CanQuery = false
                                    handle.Massless = true
                                    handle.CFrame = targetPart.CFrame * targetAttachment.CFrame * attachment.CFrame:Inverse()
                                    local weld = Instance.new("WeldConstraint")
                                    weld.Name = "AdaptAccessoryWeld"
                                    weld.Part0 = targetPart
                                    weld.Part1 = handle
                                    weld.Parent = handle
                                end
                            end
                        end
                        applied = true
                    else
                        for _, old in ipairs(parent:GetChildren()) do
                            if old.ClassName == clone.ClassName then old:Destroy() end
                        end
                        clone.Parent = parent
                        applied = true
                    end
                end
                pcall(function() root:Destroy() end)
            end
            return applied
        end

        local function applyKorbloxToPreview(rig)
            local rightUpperLeg = rig and rig:FindFirstChild("RightUpperLeg")
            if not rightUpperLeg or not rightUpperLeg:IsA("BasePart") then return false end
            local ok, result = pcall(function()
                return game:GetObjects("rbxassetid://139607718")
            end)
            if not ok or not result or not result[1] then return false end
            local model = result[1]
            model.Name = "AdaptKorblox_RightLeg"
            model:SetAttribute("AdaptSkin", true)
            local part = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
            if not part then model:Destroy(); return false end
            for _, name in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
                local leg = rig:FindFirstChild(name)
                if leg and leg:IsA("BasePart") then leg.Transparency = 1; leg.LocalTransparencyModifier = 1 end
            end
            part.Anchored = false
            part.CanCollide = false
            part.CanTouch = false
            part.CanQuery = false
            part.Massless = true
            part.CFrame = rightUpperLeg.CFrame
            local weld = Instance.new("WeldConstraint")
            weld.Name = "AdaptKorbloxWeld"
            weld.Part0 = rightUpperLeg
            weld.Part1 = part
            weld.Parent = part
            model.Parent = rig
            return true
        end

        local function hidePreviewHead(rig)
            local head = rig and rig:FindFirstChild("Head")
            if not head or not head:IsA("BasePart") then return end
            head.Transparency = 1
            head.LocalTransparencyModifier = 1
            for _, child in ipairs(head:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") or child:IsA("BasePart") then
                    child.Transparency = 1
                    if child:IsA("BasePart") then child.LocalTransparencyModifier = 1 end
                end
            end
        end

        local function createPreviewRig(name)
            local rig
            local description = Instance.new("HumanoidDescription")
            local ok = pcall(function()
                rig = Players:CreateHumanoidModelFromDescriptionAsync(description, Enum.HumanoidRigType.R15)
            end)
            if not ok or not rig then
                pcall(function()
                    rig = Players:CreateHumanoidModelFromDescription(description, Enum.HumanoidRigType.R15)
                end)
            end
            description:Destroy()

            local humanoid = rig and rig:FindFirstChildOfClass("Humanoid")
            if not rig or not humanoid then
                if rig then rig:Destroy() end
                return nil
            end

            rig.Name = name .. "PreviewRig"
            for _, d in ipairs(rig:GetDescendants()) do
                if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
                    d:Destroy()
                elseif d:IsA("BasePart") then
                    d.Anchored = true
                    d.CanCollide = false
                    d.CanTouch = false
                    d.CanQuery = false
                    d.Massless = true
                end
            end

            if isGalleryReferencePreset(name) then
                -- PREVIEW REAL DE LA SKIN COLLECTION DE VX7.
                -- Se clona el Character actual y se cargan los mismos assets con
                -- game:GetObjects(), igual que la colección original. No se usa
                -- un HumanoidDescription vacío ni bloques de reemplazo.
                local galleryName = string.upper(tostring(name))
                local previewCfg = {
                    ["ALIEN"] = {
                        ids = {10997283529, 125085889448130},
                    },
                    ["OUTFIT 1"] = {
                        ids = {125157548394108, 123231522991173, 74827642361405},
                    },
                    ["OUTFIT 2"] = {
                        ids = {136644276218918, 132022106987543, 131740907052260},
                    },
                    ["OUTFIT 3"] = {
                        ids = {119331031817124, 84952305140948},
                        headless = true,
                    },
                    ["OUTFIT 4"] = {
                        ids = {18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702},
                        headless = true,
                    },
                    ["OUTFIT 5"] = {
                        ids = {13935333090, 16110951997, 10632503818},
                    },
                    ["OUTFIT 6"] = {
                        ids = {74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424},
                        headless = true,
                    },
                    ["VX7"] = {
                        ids = {76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718},
                        headless = true,
                        hideR = true,
                    },
                    ["NEW SKIN"] = {
                        ids = {70414871864071, 14863917259, 133498027006138, 82277826177074},
                        hideL = true,
                        hideR = true,
                    },
                }

                local cfg = previewCfg[galleryName]
                local character = LP.Character

                if cfg and character then
                    local oldArchivable = character.Archivable
                    character.Archivable = true
                    local okClone, clone = pcall(function()
                        return character:Clone()
                    end)
                    character.Archivable = oldArchivable

                    if okClone and clone then
                        -- Mismo limpiado del preview original de VX7.
                        for _, descendant in ipairs(clone:GetDescendants()) do
                            if descendant:IsA("LuaSourceContainer")
                                or descendant.Name == "Animate"
                                or descendant:IsA("Tool")
                                or descendant:IsA("ForceField")
                                or descendant:IsA("LinearVelocity")
                                or descendant:IsA("AlignPosition")
                                or descendant:IsA("AngularVelocity")
                                or descendant:IsA("BillboardGui")
                                or descendant:IsA("SurfaceGui")
                                or descendant:IsA("ParticleEmitter")
                                or descendant:IsA("Trail")
                                or descendant:IsA("Highlight") then
                                pcall(function() descendant:Destroy() end)
                            elseif descendant:IsA("BasePart") then
                                descendant.Anchored = true
                                descendant.CanCollide = false
                                descendant.CanQuery = false
                                descendant.CanTouch = false
                                descendant.Massless = true
                            end
                        end

                        -- Quitar ropa/accesorios originales antes de cargar la skin.
                        for _, child in ipairs(clone:GetChildren()) do
                            if child:IsA("Accessory")
                                or child:IsA("Accoutrement")
                                or child:IsA("Shirt")
                                or child:IsA("Pants")
                                or child:IsA("ShirtGraphic")
                                or child:IsA("CharacterMesh") then
                                pcall(function() child:Destroy() end)
                            end
                        end

                        local root = clone:FindFirstChild("HumanoidRootPart")
                            or clone:FindFirstChild("LowerTorso")
                            or clone:FindFirstChild("Torso")

                        local function attachVX7PreviewAsset(parentModel, assetId)
                            local ok, objects = pcall(function()
                                return game:GetObjects("rbxassetid://" .. tostring(assetId))
                            end)
                            if not ok or not objects or #objects == 0 then return end

                            for _, object in ipairs(objects) do
                                if object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic") then
                                    local old = parentModel:FindFirstChildOfClass(object.ClassName)
                                    if old then old:Destroy() end
                                    object.Parent = parentModel
                                elseif object:IsA("Accessory") or object:IsA("Accoutrement") then
                                    local handle = object:FindFirstChild("Handle")
                                    if handle and root then
                                        local attachment = handle:FindFirstChildOfClass("Attachment")
                                        local targetPart
                                        local targetAttachment

                                        if attachment then
                                            for _, bodyPart in ipairs(parentModel:GetChildren()) do
                                                if bodyPart:IsA("BasePart") then
                                                    local target = bodyPart:FindFirstChild(attachment.Name)
                                                    if target and target:IsA("Attachment") then
                                                        targetPart = bodyPart
                                                        targetAttachment = target
                                                        break
                                                    end
                                                end
                                            end
                                        end

                                        targetPart = targetPart or parentModel:FindFirstChild("Head") or root
                                        if targetPart then
                                            if targetAttachment and attachment then
                                                handle.CFrame =
                                                    targetAttachment.WorldCFrame
                                                    * attachment.CFrame:Inverse()
                                            else
                                                handle.CFrame = targetPart.CFrame
                                            end

                                            handle.Anchored = false
                                            handle.CanCollide = false
                                            handle.CanTouch = false
                                            handle.CanQuery = false
                                            handle.Massless = true

                                            local weld = Instance.new("WeldConstraint")
                                            weld.Part0 = handle
                                            weld.Part1 = targetPart
                                            weld.Parent = handle
                                            object.Parent = parentModel
                                        else
                                            pcall(function() object:Destroy() end)
                                        end
                                    else
                                        pcall(function() object:Destroy() end)
                                    end
                                else
                                    -- Algunos assets vienen como Model/partes que
                                    -- contienen accesorios o ropa dentro.
                                    local foundWearable = false

                                    for _, child in ipairs(object:GetDescendants()) do
                                        if child:IsA("Accessory") or child:IsA("Accoutrement") then
                                            foundWearable = true
                                            local accessory = child:Clone()
                                            local handle = accessory:FindFirstChild("Handle")
                                            if handle and root then
                                                local attachment = handle:FindFirstChildOfClass("Attachment")
                                                local targetPart = parentModel:FindFirstChild("Head") or root
                                                local targetAttachment

                                                if attachment then
                                                    for _, bodyPart in ipairs(parentModel:GetChildren()) do
                                                        if bodyPart:IsA("BasePart") then
                                                            local target = bodyPart:FindFirstChild(attachment.Name)
                                                            if target and target:IsA("Attachment") then
                                                                targetPart = bodyPart
                                                                targetAttachment = target
                                                                break
                                                            end
                                                        end
                                                    end
                                                end

                                                if targetAttachment and attachment then
                                                    handle.CFrame =
                                                        targetAttachment.WorldCFrame
                                                        * attachment.CFrame:Inverse()
                                                else
                                                    handle.CFrame = targetPart.CFrame
                                                end

                                                handle.Anchored = false
                                                handle.CanCollide = false
                                                handle.CanTouch = false
                                                handle.CanQuery = false
                                                handle.Massless = true

                                                local weld = Instance.new("WeldConstraint")
                                                weld.Part0 = handle
                                                weld.Part1 = targetPart
                                                weld.Parent = handle
                                                accessory.Parent = parentModel
                                            else
                                                accessory:Destroy()
                                            end
                                        elseif child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
                                            foundWearable = true
                                            local old = parentModel:FindFirstChildOfClass(child.ClassName)
                                            if old then old:Destroy() end
                                            child:Clone().Parent = parentModel
                                        end
                                    end

                                    if not foundWearable then
                                        pcall(function() object:Destroy() end)
                                    else
                                        pcall(function() object:Destroy() end)
                                    end
                                end
                            end
                        end

                        for _, assetId in ipairs(cfg.ids) do
                            pcall(attachVX7PreviewAsset, clone, assetId)
                        end

                        -- Aplicar exactamente los estados especiales de la colección.
                        if cfg.headless then
                            local head = clone:FindFirstChild("Head")
                            if head and head:IsA("BasePart") then
                                head.Transparency = 1
                                head.LocalTransparencyModifier = 1
                                for _, descendant in ipairs(head:GetDescendants()) do
                                    if descendant:IsA("Decal") or descendant:IsA("Texture") then
                                        descendant.Transparency = 1
                                    end
                                end
                            end
                        end

                        if cfg.hideR then
                            for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}) do
                                local part = clone:FindFirstChild(partName)
                                if part and part:IsA("BasePart") then
                                    part.Transparency = 1
                                    part.LocalTransparencyModifier = 1
                                end
                            end
                        end

                        if cfg.hideL then
                            for _, partName in ipairs({"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"}) do
                                local part = clone:FindFirstChild(partName)
                                if part and part:IsA("BasePart") then
                                    part.Transparency = 1
                                    part.LocalTransparencyModifier = 1
                                end
                            end
                        end

                        return clone
                    end
                end
            end

            for _, id in ipairs(getPresetIds(name)) do
                pcall(applyAssetToRig, rig, humanoid, id)
            end
            hidePreviewHead(rig)
            applyKorbloxToPreview(rig)
            return rig
        end

        local function makeGallery()
            if gallery then gallery:Destroy() end

            gallery = Instance.new("Frame")
            gallery.Name = "AdaptSkinGallery"
            gallery.AnchorPoint = Vector2.new(0.5, 0.5)
            gallery.Position = UDim2.fromScale(0.5, 0.5)
            gallery.Size = UDim2.new(0, 390, 0, 430)
            gallery.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
            gallery.BackgroundTransparency = 0.02
            gallery.BorderSizePixel = 0
            gallery.Visible = false
            gallery.ZIndex = 100
            gallery.Parent = gui
            Instance.new("UICorner", gallery).CornerRadius = UDim.new(0, 14)

            local gs = Instance.new("UIStroke", gallery)
            gs.Color = getThemeColor()
            gs.Thickness = 1.1
            gs.Transparency = 0.2

            local title = Instance.new("TextLabel", gallery)
            title.BackgroundTransparency = 1
            title.Position = UDim2.new(0, 14, 0, 8)
            title.Size = UDim2.new(1, -58, 0, 27)
            title.Text = "CUSTOM SKIN"
            title.TextColor3 = WHITE
            title.Font = Enum.Font.GothamBlack
            title.TextSize = 15
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.ZIndex = 101

            local headerLine = Instance.new("Frame", gallery)
            headerLine.BorderSizePixel = 0
            headerLine.BackgroundColor3 = getThemeColor()
            headerLine.BackgroundTransparency = 0.65
            headerLine.Position = UDim2.new(0, 14, 0, 39)
            headerLine.Size = UDim2.new(1, -28, 0, 1)
            headerLine.ZIndex = 101

            local close = Instance.new("TextButton", gallery)
            close.BackgroundTransparency = 1
            close.Position = UDim2.new(1, -40, 0, 5)
            close.Size = UDim2.new(0, 28, 0, 28)
            close.Text = "×"
            close.TextColor3 = WHITE
            close.Font = Enum.Font.GothamBold
            close.TextSize = 21
            close.ZIndex = 101
            close.MouseButton1Click:Connect(function() gallery.Visible = false end)

            local list = Instance.new("ScrollingFrame", gallery)
            list.Name = "PresetCards"
            list.BackgroundTransparency = 1
            list.BorderSizePixel = 0
            list.Position = UDim2.new(0, 14, 0, 50)
            list.Size = UDim2.new(1, -28, 1, -62)
            list.CanvasSize = UDim2.new(0, 0, 0, 0)
            list.AutomaticCanvasSize = Enum.AutomaticSize.Y
            list.ScrollBarThickness = 0
            list.ZIndex = 101

            local grid = Instance.new("UIGridLayout", list)
            grid.CellSize = UDim2.new(0, 116, 0, 134)
            grid.CellPadding = UDim2.new(0, 6, 0, 6)
            grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
            grid.SortOrder = Enum.SortOrder.LayoutOrder

            local pad = Instance.new("UIPadding", list)
            pad.PaddingBottom = UDim.new(0, 4)

            local cards = {}

            local function refresh()
                for _, item in ipairs(cards) do
                    local selected = item.name == preset
                    item.card.BackgroundColor3 = selected and Color3.fromRGB(27, 27, 27) or Color3.fromRGB(15, 15, 15)
                    item.stroke.Transparency = selected and 0.42 or 0.92
                    item.nameLabel.TextColor3 = selected and getThemeColor() or Color3.fromRGB(175, 175, 175)
                    item.mark.Visible = selected
                end
            end

            local galleryPresetNames = {
                "BLACK", "RED", "BLUE", "GALAXY",
                "ALIEN", "OUTFIT 1", "OUTFIT 2", "OUTFIT 3",
                "OUTFIT 4", "OUTFIT 5", "OUTFIT 6"
            }

            for order, name in ipairs(galleryPresetNames) do
                local card = Instance.new("TextButton")
                card.Name = name .. "Preview"
                card.LayoutOrder = order
                card.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                card.BackgroundTransparency = 0
                card.BorderSizePixel = 0
                card.Text = ""
                card.AutoButtonColor = false
                card.ZIndex = 102
                card.Parent = list
                Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

                local stroke = Instance.new("UIStroke", card)
                stroke.Color = Color3.fromRGB(255, 255, 255)
                stroke.Thickness = 1

                local viewport = Instance.new("ViewportFrame", card)
                viewport.Name = "AvatarPreview"
                viewport.BackgroundTransparency = 1
                viewport.BorderSizePixel = 0
                viewport.Position = UDim2.new(0, 7, 0, 7)
                viewport.Size = UDim2.new(1, -14, 1, -38)
                viewport.Ambient = Color3.fromRGB(210, 210, 210)
                viewport.LightColor = Color3.fromRGB(255, 255, 255)
                viewport.LightDirection = Vector3.new(-1, -1, -1)
                viewport.ZIndex = 103
                viewport.Parent = card
                Instance.new("UICorner", viewport).CornerRadius = UDim.new(0, 8)

                local loading = Instance.new("TextLabel", viewport)
                loading.BackgroundTransparency = 1
                loading.Size = UDim2.fromScale(1, 1)
                loading.Text = "LOADING\nPREVIEW"
                loading.TextColor3 = getThemeColor()
                loading.TextSize = 9
                loading.Font = Enum.Font.GothamMedium
                loading.TextXAlignment = Enum.TextXAlignment.Center
                loading.TextYAlignment = Enum.TextYAlignment.Center
                loading.ZIndex = 104

                local nameLabel = Instance.new("TextLabel", card)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Position = UDim2.new(0, 8, 1, -25)
                nameLabel.Size = UDim2.new(1, -16, 0, 18)
                nameLabel.Text = name
                nameLabel.TextColor3 = Color3.fromRGB(175, 175, 175)
                nameLabel.TextSize = 9
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextXAlignment = Enum.TextXAlignment.Center
                nameLabel.ZIndex = 104

                local mark = Instance.new("Frame", card)
                mark.Name = "SelectedMarker"
                mark.Size = UDim2.new(1, -18, 0, 2)
                mark.Position = UDim2.new(0, 9, 1, -4)
                mark.BackgroundColor3 = getThemeColor()
                mark.BorderSizePixel = 0
                mark.ZIndex = 105
                mark.Visible = false

                local item = {name = name, card = card, stroke = stroke, nameLabel = nameLabel, mark = mark}
                cards[#cards + 1] = item

                card.MouseEnter:Connect(function()
                    card.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
                end)
                card.MouseLeave:Connect(function()
                    card.BackgroundColor3 = (name == preset) and Color3.fromRGB(27, 27, 27) or Color3.fromRGB(15, 15, 15)
                end)

                card.MouseButton1Click:Connect(function()
                    Adapt.SetPreset(name)
                    refresh()
                end)

                task.spawn(function()
                    local rig = createPreviewRig(name)
                    if not rig or not viewport.Parent then
                        loading.Text = "PREVIEW\nUNAVAILABLE"
                        return
                    end

                    local world = Instance.new("WorldModel")
                    world.Parent = viewport
                    rig.Parent = world
                    rig:PivotTo(CFrame.new())

                    local boxCf, boxSize = rig:GetBoundingBox()
                    local cam = Instance.new("Camera")
                    cam.FieldOfView = 28
                    local target = boxCf.Position + Vector3.new(0, boxSize.Y * 0.02, 0)
                    local distance = math.max(boxSize.X, boxSize.Y) * 1.65
                    cam.CFrame = CFrame.new(target + Vector3.new(0, boxSize.Y * 0.02, distance), target)
                    cam.Parent = viewport
                    viewport.CurrentCamera = cam
                    loading:Destroy()

                    task.spawn(function()
                        while viewport.Parent and gallery and gallery.Parent do
                            if gallery.Visible then
                                rig:PivotTo(CFrame.Angles(0, math.rad((os.clock() * 22) % 360), 0))
                            end
                            task.wait(0.03)
                        end
                    end)
                end)
            end

            refresh()
            return gallery
        end

        makeGallery()

        -- Restaurar automaticamente la skin al ejecutar el Lua:
        -- loadState() ya recuperó "enabled" y "preset"; aquí aplicamos
        -- realmente la skin al Character actual, sin necesitar apagar/encender.
        if enabled then
            task.defer(function()
                task.wait(0.35)
                if enabled then
                    pcall(Adapt.Apply)
                end
            end)
            task.delay(1.15, function()
                if enabled then
                    pcall(Adapt.Apply)
                end
            end)
        end

        local visualPage = contentPages["Visual"]

        -- Estas dos filas se agregan al FINAL de Visual.
        mkSect(visualPage, "Cosmetics")
        local adaptToggle = mkToggle(visualPage, "CUSTOM SKIN", function(on)
            Adapt.SetEnabled(on)
            if gallery and gallery.Visible then
                local st = gallery:FindFirstChild("Status")
                if st then st.Text = "Preset: " .. Adapt.GetPreset() .. "   •   " .. (on and "ON" or "OFF") end
            end
        end)
        if adaptToggle then adaptToggle(enabled) end

        do
            local row = mkRow(visualPage, 38)
            mkLabel(row, "DISPLAY MODE")
            local openBtn = Instance.new("TextButton", row)
            openBtn.Size = UDim2.new(0, 90, 0, 30)
            openBtn.Position = UDim2.new(1, -98, 0.5, -15)
            openBtn.BackgroundColor3 = INP
            openBtn.BackgroundTransparency = 0.1
            openBtn.BorderSizePixel = 0
            openBtn.Text = "SKINS"
            openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            openBtn.Font = Enum.Font.GothamBlack
            openBtn.TextSize = 15
            openBtn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            openBtn.TextStrokeTransparency = 1
            openBtn.AutoButtonColor = false
            openBtn.ZIndex = 9
            Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 6)
            local os = Instance.new("UIStroke", openBtn)
            os.Color = getThemeColor()
            os.Thickness = 1
            openBtn.MouseButton1Click:Connect(function()
                if not gallery or not gallery.Parent then makeGallery() end
                gallery.Visible = true
                gallery.ZIndex = 100
            end)
        end

        -- ============================================================
        -- ANIM PACK (cambia el paquete de animaciones del personaje)
        -- Fila tipo selector: < NOMBRE >  (nombre centrado, flechas a los lados)
        -- ============================================================
        do
            local ANIM_PACKS = {
                ["Ninja"]     = {idle={656117400,656118341}, walk=656121766, run=656118852, jump=656117878, fall=656115606, climb=656114359, swim=656119721, swimidle=656120133},
                ["Zombie"]    = {idle={616158929,616160636}, walk=616168032, run=616163682, jump=616161997, fall=616157476, climb=616156119, swim=616165109, swimidle=616166655},
                ["Werewolf"]  = {idle={1083445855,1083450166}, walk=1083473930, run=1083462077, jump=1083455352, fall=1083443587, climb=1083439238, swim=1083467779, swimidle=1083471346},
                ["Superhero"] = {idle={616111295,616113536}, walk=616122287, run=616117076, jump=616115533, fall=616108001, climb=616104706, swim=616119430, swimidle=616120211},
                ["Toy"]       = {idle={782841498,782845736}, walk=782843345, run=782842708, jump=782847020, fall=782846423, climb=782843869, swim=782844582, swimidle=782845091},
                ["Robot"]     = {idle={616090211,616088211}, walk=616095330, run=616091570, jump=616090535, fall=616086894, climb=616086790, swim=616092998, swimidle=616093932},
                ["Mage"]      = {idle={707742142,707855907}, walk=707897309, run=707861613, jump=707853694, fall=707829716, climb=707826056, swim=707876443, swimidle=707887908},
                ["Astronaut"] = {idle={891621366,891633237}, walk=891667138, run=891636393, jump=891627522, fall=891617961, climb=891609353, swim=891663592, swimidle=891661553},
                ["Stylish"]   = {idle={616006778,616008087}, walk=616013216, run=616010382, jump=616008936, fall=616005863, climb=616003713, swim=616011509, swimidle=616012453},
            }
            local ANIM_ORDER = {"OFF","Ninja","Zombie","Werewolf","Superhero","Toy","Robot","Mage","Astronaut","Stylish"}
            local ANIM_GROUPS = {"idle","walk","run","jump","fall","climb","swim","swimidle"}
            local animDefaults = nil

            local function getAnimate()
                local char = LP and LP.Character
                if not char then return nil end
                return char:FindFirstChild("Animate")
            end

            local function captureDefaults(animate)
                if animDefaults then return end
                animDefaults = {}
                for _, g in ipairs(ANIM_GROUPS) do
                    local group = animate:FindFirstChild(g)
                    if group then
                        local ids = {}
                        for _, ch in ipairs(group:GetChildren()) do
                            if ch:IsA("Animation") then ids[#ids+1] = ch.AnimationId end
                        end
                        animDefaults[g] = ids
                    end
                end
            end

            local function setGroup(animate, g, value)
                local group = animate:FindFirstChild(g)
                if not group then return end
                local anims = {}
                for _, ch in ipairs(group:GetChildren()) do
                    if ch:IsA("Animation") then anims[#anims+1] = ch end
                end
                if type(value) == "table" then
                    for i, a in ipairs(anims) do
                        local id = value[i] or value[#value]
                        if id then a.AnimationId = "rbxassetid://"..tostring(id) end
                    end
                elseif value then
                    for _, a in ipairs(anims) do a.AnimationId = "rbxassetid://"..tostring(value) end
                end
            end

            local function restartAnimate(animate)
                local char = animate.Parent
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
                end
                pcall(function()
                    animate.Disabled = true
                    task.wait(0.05)
                    animate.Disabled = false
                end)
            end

            local function applyAnimPack(name)
                local animate = getAnimate()
                if not animate then return end
                captureDefaults(animate)
                if name == "OFF" then
                    if animDefaults then
                        for g, ids in pairs(animDefaults) do
                            local group = animate:FindFirstChild(g)
                            if group then
                                local i = 1
                                for _, ch in ipairs(group:GetChildren()) do
                                    if ch:IsA("Animation") then
                                        if ids[i] then ch.AnimationId = ids[i] end
                                        i = i + 1
                                    end
                                end
                            end
                        end
                    end
                    restartAnimate(animate)
                    return
                end
                local pack = ANIM_PACKS[name]
                if not pack then return end
                for _, g in ipairs(ANIM_GROUPS) do setGroup(animate, g, pack[g]) end
                restartAnimate(animate)
            end

            local animIdx = 1
            local row = mkRow(visualPage, 38)
            mkLabel(row, "Anim Pack")
            mkSelector(row, ANIM_ORDER[animIdx], ANIM_ORDER, function(dir, update)
                animIdx = animIdx + dir
                if animIdx < 1 then animIdx = #ANIM_ORDER end
                if animIdx > #ANIM_ORDER then animIdx = 1 end
                local name = ANIM_ORDER[animIdx]
                if update then update(name) end
                pcall(applyAnimPack, name)
            end)
        end

    -- ============================================================
    -- CUSTOM TOOLS (una sola opcion, debajo de Outfit)
    -- Panel unico: toggles Custom Tools / Custom Sounds + skins Bat/Medusa
    -- ============================================================
    do
        local row = mkRow(visualPage, 30)
        mkLabel(row, "Custom Tools")
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local openBtn = Instance.new("TextButton", container)
        openBtn.Size = UDim2.new(0, 38, 0, 22)
        openBtn.Position = UDim2.new(1, -109, 0.5, -11)
        openBtn.BackgroundColor3 = INP
        openBtn.BackgroundTransparency = 0.5
        openBtn.BorderSizePixel = 0
        openBtn.Text = "\226\150\178"
        openBtn.TextColor3 = WHITE
        openBtn.Font = Enum.Font.GothamBold
        openBtn.TextSize = 14
        openBtn.AutoButtonColor = false
        openBtn.ZIndex = 9
        Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 6)
        local openStroke = Instance.new("UIStroke", openBtn)
        openStroke.Color = ROW_BORDER
        openStroke.Thickness = 1

        -- Toggle Custom Tools a la izquierda del boton de flecha
        local ctPill = Instance.new("Frame", container)
        ctPill.Size = UDim2.new(0, 34, 0, 18)
        ctPill.Position = UDim2.new(1, -57, 0.5, -9)
        ctPill.BackgroundColor3 = Color3.fromRGB(255,255,255)
        ctPill.BackgroundTransparency = 0.2
        ctPill.BorderSizePixel = 0
        ctPill.ZIndex = 9
        Instance.new("UICorner", ctPill).CornerRadius = UDim.new(0, 9)
        local ctPillStroke = Instance.new("UIStroke", ctPill)
        ctPillStroke.Color = ROW_BORDER
        ctPillStroke.Thickness = 1
        ctPillStroke.Transparency = 0.45
        local ctDot = Instance.new("Frame", ctPill)
        ctDot.Size = UDim2.new(0, 13, 0, 13)
        ctDot.Position = UDim2.new(0, 3, 0.5, -6)
        ctDot.BackgroundColor3 = Color3.fromRGB(18,18,22)
        ctDot.BorderSizePixel = 0
        ctDot.ZIndex = 10
        Instance.new("UICorner", ctDot).CornerRadius = UDim.new(1, 0)
        local function ctPaint(on)
            local ON = Color3.fromRGB(152,161,170)
            local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TS:Create(ctDot, info, { Position = on and UDim2.new(1,-16,0.5,-6) or UDim2.new(0,3,0.5,-6) }):Play()
            TS:Create(ctPill, info, { BackgroundColor3 = on and ON or Color3.fromRGB(255,255,255), BackgroundTransparency = on and 0 or 0.2 }):Play()
            TS:Create(ctPillStroke, info, { Color = on and ON or ROW_BORDER, Transparency = on and 0.2 or 0.45 }):Play()
        end
        ctPaint(_G.AmbitiousCustomToolsEnabled == true)
        -- Expone el repintado del toggle para restaurarlo al cargar la config
        _G.__ctSetVisual = ctPaint
        ctSetCustomToolsVisual = ctPaint
        local ctClk = Instance.new("TextButton", ctPill)
        ctClk.Size = UDim2.new(1,0,1,0)
        ctClk.BackgroundTransparency = 1
        ctClk.Text = ""
        ctClk.AutoButtonColor = false
        ctClk.ZIndex = 11
        ctClk.MouseButton1Click:Connect(function()
            local on = not (_G.AmbitiousCustomToolsEnabled == true)
            if _G.AmbitiousCustomTools then _G.AmbitiousCustomTools.setEnabled(on) end
            ctPaint(on)
            -- Guarda el estado del toggle para que persista al reejecutar
            if saveAllSettings then pcall(saveAllSettings) end
        end)
        -- Custom Sounds SIEMPRE activo por defecto (sin opcion)
        pcall(function() if _G.AmbitiousCustomSounds then _G.AmbitiousCustomSounds.setEnabled(true) end end)

        -- Panel INLINE desplegable (miniaturas justo debajo de la fila) --
        local inline = Instance.new("Frame", visualPage)
        inline.Name = "CustomToolsInline"
        inline.BackgroundColor3 = BG2
        inline.BackgroundTransparency = 0.15
        inline.BorderSizePixel = 0
        inline.Size = UDim2.new(1, -4, 0, 0)
        inline.AutomaticSize = Enum.AutomaticSize.Y
        inline.LayoutOrder = getNextOrder(visualPage)
        inline.Visible = false
        inline.ClipsDescendants = true
        inline.ZIndex = 7
        Instance.new("UICorner", inline).CornerRadius = UDim.new(0, 10)
        local inStroke = Instance.new("UIStroke", inline)
        inStroke.Color = getThemeColor()
        inStroke.Thickness = 1.2
        inStroke.Transparency = 0.3
        local inLayout = Instance.new("UIListLayout", inline)
        inLayout.SortOrder = Enum.SortOrder.LayoutOrder
        inLayout.Padding = UDim.new(0, 6)
        inLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        local inPad = Instance.new("UIPadding", inline)
        inPad.PaddingTop = UDim.new(0, 8)
        inPad.PaddingBottom = UDim.new(0, 8)
        inPad.PaddingLeft = UDim.new(0, 6)
        inPad.PaddingRight = UDim.new(0, 6)

        local ctSpin = nil
        local cards = {}
        local built = false
        local currentCat = "Bat"
        local cardsHolder = nil
        local tabBtns = {}
        local CATS = {"Bat", "Medusa"}

        local function makeToggleRow(order, labelText, getState, onToggle)
            local r = Instance.new("Frame", inline)
            r.Size = UDim2.new(1, -6, 0, 28)
            r.BackgroundColor3 = BG
            r.BackgroundTransparency = 0.25
            r.BorderSizePixel = 0
            r.LayoutOrder = order
            r.ZIndex = 8
            Instance.new("UICorner", r).CornerRadius = UDim.new(0, 8)
            local lbl = Instance.new("TextLabel", r)
            lbl.Size = UDim2.new(1, -70, 1, 0)
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = labelText
            lbl.TextColor3 = WHITE
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 9
            local pill = Instance.new("Frame", r)
            pill.Size = UDim2.new(0, 34, 0, 18)
            pill.Position = UDim2.new(1, -46, 0.5, -9)
            pill.BackgroundColor3 = Color3.fromRGB(255,255,255)
            pill.BackgroundTransparency = 0.2
            pill.BorderSizePixel = 0
            pill.ZIndex = 9
            Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 9)
            local pstroke = Instance.new("UIStroke", pill)
            pstroke.Color = ROW_BORDER
            pstroke.Thickness = 1
            pstroke.Transparency = 0.45
            local dot = Instance.new("Frame", pill)
            dot.Size = UDim2.new(0, 13, 0, 13)
            dot.Position = UDim2.new(0, 3, 0.5, -6)
            dot.BackgroundColor3 = Color3.fromRGB(18,18,22)
            dot.BorderSizePixel = 0
            dot.ZIndex = 10
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
            local function paint(on)
                local ON = Color3.fromRGB(152,161,170)
                local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                TS:Create(dot, info, { Position = on and UDim2.new(1,-16,0.5,-6) or UDim2.new(0,3,0.5,-6) }):Play()
                TS:Create(pill, info, { BackgroundColor3 = on and ON or Color3.fromRGB(255,255,255), BackgroundTransparency = on and 0 or 0.2 }):Play()
                TS:Create(pstroke, info, { Color = on and ON or ROW_BORDER, Transparency = on and 0.2 or 0.45 }):Play()
            end
            paint(getState() == true)
            local clk = Instance.new("TextButton", pill)
            clk.Size = UDim2.new(1,0,1,0)
            clk.BackgroundTransparency = 1
            clk.Text = ""
            clk.AutoButtonColor = false
            clk.ZIndex = 11
            clk.MouseButton1Click:Connect(function()
                local on = not (getState() == true)
                onToggle(on)
                paint(on)
            end)
        end

        local function refreshSel()
            for _, e in ipairs(cards) do
                local sel = (_G.AmbitiousCustomToolSkins and _G.AmbitiousCustomToolSkins[e.def.cat] == e.key)
                e.stroke.Color = sel and WHITE or ROW_BORDER
                e.stroke.Transparency = sel and 0 or 0.4
                e.stroke.Thickness = sel and 2.2 or 1.2
            end
        end
        local function buildCards(cat)
            for _, e in ipairs(cards) do e.card:Destroy() end
            cards = {}
            local ASSETS = _G.AmbitiousCustomToolAssets or {}
            for key, def in pairs(ASSETS) do
                if def.cat == cat then
                    local card = Instance.new("Frame", cardsHolder)
                    card.Size = UDim2.new(0, 100, 0, 118)
                    card.BackgroundColor3 = BG
                    card.BackgroundTransparency = 0.1
                    card.BorderSizePixel = 0
                    card.ZIndex = 9
                    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
                    local cStroke = Instance.new("UIStroke", card)
                    cStroke.Thickness = 1.2
                    cStroke.Color = ROW_BORDER
                    cStroke.Transparency = 0.4
                    local vp = Instance.new("ViewportFrame", card)
                    vp.Size = UDim2.new(1, -12, 0, 78)
                    vp.Position = UDim2.new(0, 6, 0, 6)
                    vp.BackgroundColor3 = Color3.fromRGB(8,8,11)
                    vp.BackgroundTransparency = 0.25
                    vp.BorderSizePixel = 0
                    vp.Ambient = Color3.fromRGB(190,190,200)
                    vp.LightColor = Color3.fromRGB(255,255,255)
                    vp.LightDirection = Vector3.new(-0.4,-1,-0.6)
                    vp.ZIndex = 10
                    Instance.new("UICorner", vp).CornerRadius = UDim.new(0, 8)
                    local part, vpModel
                    if def.procedural then
                        -- Miniatura de la katana procedural (varias partes).
                        vpModel = Instance.new("Model")
                        if _G.AmbitiousBuildKatanaSkin then
                            pcall(_G.AmbitiousBuildKatanaSkin, vpModel, nil)
                        end
                        vpModel.Parent = vp
                        -- Centrar en el origen y dejarla "echada" en diagonal,
                        -- como las demas skins (no vertical).
                        pcall(function()
                            vpModel:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(55)))
                        end)
                    else
                        part = Instance.new("Part")
                        part.Anchored = true
                        part.CanCollide = false
                        part.Size = Vector3.new(1,1,1)
                        part.CFrame = CFrame.new(0,0,0)
                        part.Parent = vp
                        local mesh = Instance.new("SpecialMesh", part)
                        mesh.MeshType = Enum.MeshType.FileMesh
                        mesh.MeshId = def.mesh
                        mesh.TextureId = def.tex
                        mesh.Scale = def.scale
                    end
                    local cam = Instance.new("Camera", vp)
                    cam.FieldOfView = 45
                    vp.CurrentCamera = cam
                    local dist = def.view or 4
                    cam.CFrame = CFrame.new(Vector3.new(0, dist*0.35, dist), Vector3.new(0, 0, 0))
                    local nameLbl = Instance.new("TextLabel", card)
                    nameLbl.BackgroundTransparency = 1
                    nameLbl.Text = string.upper(tostring(def.label or key))
                    nameLbl.TextColor3 = WHITE
                    nameLbl.Font = Enum.Font.GothamBold
                    nameLbl.TextSize = 10
                    nameLbl.TextWrapped = true
                    nameLbl.Size = UDim2.new(1, -8, 0, 28)
                    nameLbl.Position = UDim2.new(0, 4, 0, 88)
                    nameLbl.ZIndex = 11
                    local click = Instance.new("TextButton", card)
                    click.BackgroundTransparency = 1
                    click.Text = ""
                    click.AutoButtonColor = false
                    click.Size = UDim2.new(1,0,1,0)
                    click.ZIndex = 12
                    local thisKey, thisCat = key, cat
                    click.MouseButton1Click:Connect(function()
                        if _G.AmbitiousSetCustomToolSkin then
                            _G.AmbitiousSetCustomToolSkin(thisCat, thisKey)
                        end
                        refreshSel()
                    end)
                    cards[#cards+1] = { card = card, key = key, def = def, part = part, model = vpModel, stroke = cStroke }
                end
            end
            refreshSel()
        end
        local function refreshTabs()
            for i, b in ipairs(tabBtns) do
                local on = (CATS[i] == currentCat)
                b.BackgroundColor3 = on and getThemeColor() or Color3.fromRGB(24,24,30)
                b.TextColor3 = on and Color3.fromRGB(0,0,0) or WHITE
            end
        end

        local function buildInline()
            if built then return end
            built = true
            local tabsHolder = Instance.new("Frame", inline)
            tabsHolder.Size = UDim2.new(1, -6, 0, 28)
            tabsHolder.BackgroundTransparency = 1
            tabsHolder.LayoutOrder = 3
            tabsHolder.ZIndex = 8
            for i, cat in ipairs(CATS) do
                local b = Instance.new("TextButton", tabsHolder)
                b.Size = UDim2.new(0.5, -4, 1, 0)
                b.Position = UDim2.new(0.5*(i-1), (i==1) and 0 or 4, 0, 0)
                b.BackgroundColor3 = Color3.fromRGB(24,24,30)
                b.BackgroundTransparency = 0.1
                b.BorderSizePixel = 0
                b.Text = cat:upper()
                b.TextColor3 = WHITE
                b.Font = Enum.Font.GothamBold
                b.TextSize = 11
                b.AutoButtonColor = false
                b.ZIndex = 9
                Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
                tabBtns[i] = b
                local thisCat = cat
                b.MouseButton1Click:Connect(function()
                    currentCat = thisCat
                    refreshTabs()
                    buildCards(thisCat)
                end)
            end
            cardsHolder = Instance.new("Frame", inline)
            cardsHolder.Size = UDim2.new(1, -6, 0, 0)
            cardsHolder.AutomaticSize = Enum.AutomaticSize.Y
            cardsHolder.BackgroundTransparency = 1
            cardsHolder.LayoutOrder = 4
            cardsHolder.ZIndex = 8
            local grid = Instance.new("UIGridLayout", cardsHolder)
            grid.CellSize = UDim2.new(0, 100, 0, 118)
            grid.CellPadding = UDim2.new(0, 8, 0, 8)
            grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
            grid.SortOrder = Enum.SortOrder.LayoutOrder
            refreshTabs()
            buildCards(currentCat)
            ctSpin = RunService.RenderStepped:Connect(function(dt)
                if not inline.Visible then return end
                for _, e in ipairs(cards) do
                    if e.part and e.part.Parent then
                        e.part.CFrame = e.part.CFrame * CFrame.Angles(0, dt*1.2, 0)
                    elseif e.model and e.model.Parent then
                        pcall(function()
                            e.model:PivotTo(CFrame.Angles(0, dt*1.2, 0) * e.model:GetPivot())
                        end)
                    end
                end
            end)
        end

        local function toggleInline()
            if inline.Visible then
                inline.Visible = false
                openBtn.Text = "\226\150\178"
            else
                buildInline()
                inline.Visible = true
                openBtn.Text = "\226\150\188"
                refreshSel()
            end
        end
        openBtn.MouseButton1Click:Connect(toggleInline)
    end

        _G.__STRIKE_ADAPT_SKIN_CLEANUP = function()
            if characterConn then pcall(function() characterConn:Disconnect() end) end
            if gallery then pcall(function() gallery:Destroy() end) end
            pcall(Adapt.Disable)
            _G.__STRIKE_ADAPT_SKIN = nil
            _G.__STRIKE_ADAPT_SKIN_CLEANUP = nil
        end
    end

    local configPage = contentPages["Config"]

    mkSect(configPage, "GUIA SETTING")
    do
        local row = mkRow(configPage, 62)
        local bgNameLabel = mkLabel(row, "Background Image")
        bgNameLabel.Size = UDim2.new(0.40, 0, 1, 0)

        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 192, 0, 50)
        container.Position = UDim2.new(1, -198, 0.5, -25)
        container.BackgroundTransparency = 1
        container.ZIndex = 8

        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 22, 0, 40)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -20)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.25
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 12
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local leftStroke = Instance.new("UIStroke", leftBtn)
        leftStroke.Color = ROW_BORDER
        leftStroke.Thickness = 1

        local thumbs = {}
        local thumbSize = 34
        local thumbGap = 3
        local currentBgIndex = backgroundIndex

        for i, imageId in ipairs(backgroundImages) do
            local thumb = Instance.new("ImageButton", container)
            thumb.Name = "BackgroundThumb" .. i
            thumb.Size = UDim2.new(0, thumbSize, 0, 42)
            thumb.Position = UDim2.new(0, 25 + (i - 1) * (thumbSize + thumbGap), 0.5, -21)
            thumb.BackgroundColor3 = INP
            thumb.BackgroundTransparency = 0.15
            thumb.BorderSizePixel = 0
            thumb.Image = "rbxassetid://" .. imageId
            thumb.ScaleType = Enum.ScaleType.Crop
            thumb.AutoButtonColor = false
            thumb.ZIndex = 10
            Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 7)

            local stroke = Instance.new("UIStroke", thumb)
            stroke.Color = (i == currentBgIndex) and getThemeColor() or ROW_BORDER
            stroke.Thickness = (i == currentBgIndex) and 1.5 or 1
            stroke.Transparency = (i == currentBgIndex) and 0 or 0.15
            thumbs[i] = thumb

            thumb.MouseButton1Click:Connect(function()
                currentBgIndex = i
                backgroundIndex = i
                local bgImg = main:FindFirstChild("BackgroundImage")
                if bgImg then
                    bgImg.Image = "rbxassetid://" .. backgroundImages[i]
                end
                for n, t in ipairs(thumbs) do
                    local st = t:FindFirstChildOfClass("UIStroke")
                    if st then
                        st.Color = (n == currentBgIndex) and getThemeColor() or ROW_BORDER
                        st.Thickness = (n == currentBgIndex) and 1.5 or 1
                        st.Transparency = (n == currentBgIndex) and 0 or 0.15
                    end
                end
                saveAllSettings()
            end)
        end

        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 22, 0, 40)
        rightBtn.Position = UDim2.new(1, -22, 0.5, -20)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.25
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 12
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local rightStroke = Instance.new("UIStroke", rightBtn)
        rightStroke.Color = ROW_BORDER
        rightStroke.Thickness = 1

        local function updateBg(direction)
            local newIdx = currentBgIndex + direction
            if newIdx < 1 then newIdx = #backgroundImages end
            if newIdx > #backgroundImages then newIdx = 1 end
            currentBgIndex = newIdx
            backgroundIndex = newIdx
            local bgImg = main:FindFirstChild("BackgroundImage")
            if bgImg then
                bgImg.Image = "rbxassetid://" .. backgroundImages[currentBgIndex]
            end
            for n, t in ipairs(thumbs) do
                local st = t:FindFirstChildOfClass("UIStroke")
                if st then
                    st.Color = (n == currentBgIndex) and getThemeColor() or ROW_BORDER
                    st.Thickness = (n == currentBgIndex) and 1.5 or 1
                    st.Transparency = (n == currentBgIndex) and 0 or 0.15
                end
            end
            saveAllSettings()
        end

        leftBtn.MouseButton1Click:Connect(function() updateBg(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateBg(1) end)
    end

    do
        local row = mkRow(configPage, 38)
        mkLabel(row, "UI Scale")
        uiScaleStepperSet = mkStepper(row, uiScaleValue, 50, 150, 5, 0, function(v)
            local n = _clamp(_floor(v + 0.5), 50, 150)
            uiScaleValue = n
            if mainUIScale then mainUIScale.Scale = n/100 end
            saveAllSettings()
        end)
    end

    do
        local row = mkRow(configPage, 38)
        mkLabel(row, "Steal Bar Scale")
        stealBarStepperSet = mkStepper(row, stealBarScale, 0.3, 1.5, 0.05, 2, function(val)
            stealBarScale = _clamp(val, 0.3, 1.5)
            if pbScale then pbScale.Scale = stealBarScale end
            saveAllSettings()
        end)
    end

    mkSect(configPage, "STEAL PROTO")
    do
        local row = mkRow(configPage, 38)
        mkLabel(row, "Auto Steal")
        local pill, dot = mkPill(row, 48)
        local on = false
        local function sv(s) on = s; animPill(pill, dot, s) end
        setInstaGrab = sv
        local function autoStealCb(v)
            CONFIG.AUTO_STEAL_ENABLED = v
            if v then pcall(startAutoSteal) else stopAutoSteal() end
            updateProgressBarVisibility()
        end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            if editModeEnabled and not uiLocked then
                pcall(autoStealCb, not on)
            else
                on = not on
                sv(on)
                pcall(autoStealCb, on)
            end
        end)

        local arrow = Instance.new("TextButton", row)
        arrow.Size = UDim2.new(0, 22, 0, 22)
        arrow.Position = UDim2.new(1, -92, 0.5, -11)
        arrow.BackgroundTransparency = 1
        arrow.Text = "\226\150\188"
        arrow.TextColor3 = WHITE
        arrow.Font = Enum.Font.GothamBold
        arrow.TextSize = 12
        arrow.AutoButtonColor = false
        arrow.ZIndex = 10

        local subRows = {}

        local rRow = mkRow(configPage, 38)
        rRow.Visible = false
        table.insert(subRows, rRow)
        mkLabel(rRow, "Radius")
        radInput = mkBox(rRow, CONFIG.STEAL_RANGE, 50, 56, function(v)
            if v and v >= 5 and v <= 300 then
                CONFIG.STEAL_RANGE = _floor(v+0.5)
                Steal.StealRadius = CONFIG.STEAL_RANGE
                radInput.Text = tostring(CONFIG.STEAL_RANGE)
                saveAllSettings()
            end
        end)

        local ssRow = mkRow(configPage, 38)
        ssRow.Visible = false
        table.insert(subRows, ssRow)
        mkLabel(ssRow, "Soft Steal Speed")
        carrySysSoftStealSpeedBox = mkBox(ssRow, CarrySystem.softStealSpeed, 50, 56, function(v)
            if v > 0 and v <= 500 then CarrySystem:setSoftStealSpeed(v); saveAllSettings() end
        end)

        local srRow = mkRow(configPage, 38)
        srRow.Visible = false
        table.insert(subRows, srRow)
        mkLabel(srRow, "Soft Steal Radius")
        carrySysSoftStealRadiusBox = mkBox(srRow, CarrySystem.softStealRadius, 50, 56, function(v)
            if v > 0 then CarrySystem:setSoftStealRadius(v); saveAllSettings() end
        end)

        local expanded = false
        arrow.MouseButton1Click:Connect(function()
            expanded = not expanded
            for _, r in ipairs(subRows) do r.Visible = expanded end
            arrow.Text = expanded and "\226\150\178" or "\226\150\188"
        end)
    end

    mkSect(configPage, "MOBILE BUTTONS")
    do
        local row = mkRow(configPage, 38)
        mkLabel(row, "Mobile Buttons Size")
        floatScaleStepperSet = mkStepper(row, floatingButtonScale, 0.5, 2.0, 0.05, 2, function(val)
            floatingButtonScale = _clamp(val, 0.5, 2.0)
            applyFloatingButtonScale()
            saveAllSettings()
        end)
    end

    hideMobileBtnsSetVisual = mkToggle(configPage, "Hide Mobile Buttons", function(on)
        setMobileButtonsHidden(on)
        saveAllSettings()
    end)

    setLockUIVisual = mkToggle(configPage, "Lock GUIA", function(on)
        uiLocked = on == true
        if uiLocked and editModeEnabled then
            editModeEnabled = false
            if setEditModeVisual then setEditModeVisual(false) end
        end
        pcall(saveAllSettings)
    end)

    -- INTRO: exactamente debajo de Lock GUIA, como en la referencia.
    do
        local row = mkRow(configPage, 38)
        mkLabel(row, "Intro Song")
        local idx = 1
        for i, name in ipairs(INTRO_SONG_ORDER) do
            if name == INTRO_SONG then idx = i break end
        end
        introSongSelectorLabel = mkSelector(row, INTRO_SONG, INTRO_SONG_ORDER, function(delta, updateLabel)
            idx = ((idx - 1 + delta) % #INTRO_SONG_ORDER) + 1
            INTRO_SONG = INTRO_SONG_ORDER[idx]
            if updateLabel then updateLabel(INTRO_SONG) end
            if strikeIntroSound then
                pcall(function() strikeIntroSound:Stop() end)
                pcall(function() strikeIntroSound:Destroy() end)
                strikeIntroSound = nil
            end
            if INTRO_SONG ~= "Off" then
                task.spawn(function()
                    -- Si la intro ya esta visible, cambia la musica en el acto.
                    pcall(function()
                        _G.__STRIKE_PLAY_INTRO_SONG(INTRO_SONG, true)
                    end)
                end)
            end
            saveAllSettings()
        end)
    end

    skipIntroSetVisual = mkToggle(configPage, "Skip Intro", function(on)
        SKIP_INTRO = on == true
        if SKIP_INTRO then
            if _G.__STRIKE_FINISH_INTRO then pcall(_G.__STRIKE_FINISH_INTRO) end
        end
        saveAllSettings()
    end)

    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local resetPosBtn = Instance.new("TextButton", row)
        resetPosBtn.Size = UDim2.new(1, -12, 0.8, 0)
        resetPosBtn.Position = UDim2.new(0, 6, 0.1, 0)
        resetPosBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
        resetPosBtn.BackgroundTransparency = 0.5
        resetPosBtn.BorderSizePixel = 0
        resetPosBtn.Text = "RESET POSITIONS"
        resetPosBtn.TextColor3 = WHITE
        resetPosBtn.Font = Enum.Font.GothamBold
        resetPosBtn.TextSize = 13
        resetPosBtn.TextStrokeColor3 = Color3.fromRGB(60,60,60)
        resetPosBtn.TextStrokeTransparency = 0
        resetPosBtn.AutoButtonColor = false
        resetPosBtn.ZIndex = 8
        Instance.new("UICorner", resetPosBtn).CornerRadius = UDim.new(0, 8)
        local resetStroke = Instance.new("UIStroke", resetPosBtn)
        resetStroke.Color = ROW_BORDER
        resetStroke.Thickness = 1.2
        resetStroke.Transparency = 0.5
        local resetDebounce = false
        resetPosBtn.MouseButton1Click:Connect(function()
            if resetDebounce then return end
            resetDebounce = true
            resetFloatingPositions()
            resetPosBtn.Text = "RESET ✓"
            task.delay(1.2, function()
                if resetPosBtn and resetPosBtn.Parent then
                    resetPosBtn.Text = "RESET POSITIONS"
                    resetDebounce = false
                end
            end)
        end)
    end

    mkSect(configPage, "CONFIG")
    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(1, -12, 0.8, 0)
        delBtn.Position = UDim2.new(0, 6, 0.1, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(140, 25, 65)
        delBtn.BackgroundTransparency = 0.5
        delBtn.BorderSizePixel = 0
        delBtn.Text = "RESET ALL CONFIG"
        delBtn.TextColor3 = WHITE
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 13
        delBtn.TextStrokeColor3 = Color3.fromRGB(60,60,60)
        delBtn.TextStrokeTransparency = 0
        delBtn.AutoButtonColor = false
        delBtn.ZIndex = 8
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 8)
        local delStroke = Instance.new("UIStroke", delBtn)
        delStroke.Color = ROW_BORDER
        delStroke.Thickness = 1.2
        delStroke.Transparency = 0.5
        local deleteState = 0
        local originalDeleteText = "RESET ALL CONFIG"
        local delDebounce = false
        delBtn.MouseButton1Click:Connect(function()
            if delDebounce then return end
            if deleteState == 0 then
                deleteState = 1
                delBtn.Text = "CONFIRM?"
                delBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 80)
                task.delay(2, function()
                    if delBtn and delBtn.Parent and deleteState == 1 then
                        deleteState = 0
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(140, 25, 65)
                    end
                end)
            elseif deleteState == 1 then
                delDebounce = true
                local success = pcall(resetToFactoryDefaults)
                delBtn.Text = success and "DELETED ✓" or "ERROR"
                delBtn.BackgroundColor3 = Color3.fromRGB(140, 25, 65)
                deleteState = 0
                task.delay(1.5, function()
                    if delBtn and delBtn.Parent then
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(140, 25, 65)
                        delDebounce = false
                    end
                end)
            end
        end)
    end

    local keyPage = contentPages["Keybinds"]
    mkSect(keyPage, "Keybinds")
    addKeybindRow(keyPage, "Carry Mode", KB.CarryToggle)
    addKeybindRow(keyPage, "Lagger Mode", KB.LaggerMode)
    addKeybindRow(keyPage, "Auto Left", KB.AutoLeft)
    addKeybindRow(keyPage, "Auto Right", KB.AutoRight)
    addKeybindRow(keyPage, "Auto Bat", KB.AutoBat)
    addKeybindRow(keyPage, "TP BAT", KB.TPBat)
    addKeybindRow(keyPage, "Bat Bypass", KB.BatBypass)
    addKeybindRow(keyPage, "Insta Reset", KB.InstaReset)
    addKeybindRow(keyPage, "TP Down", KB.TPFloor)
    addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)

    local spacer = Instance.new("Frame", keyPage)
    spacer.Size = UDim2.new(1, 0, 0, 16)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = getNextOrder(keyPage)
    spacer.ZIndex = 7

    -- AUTO GRAB / AUTO STEAL STATUS BAR
    -- Tamaño y estilo ajustados al diseño de referencia: panel ancho,
    -- negro sólido y esquinas muy redondeadas.
    pbFrame = Instance.new("Frame", gui)
    pbFrame.Size = UDim2.new(0, 704, 0, 140)
    pbFrame.Position = UDim2.new(0, 300, 1, -80)
    pbFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    pbFrame.BackgroundTransparency = 0
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.ClipsDescendants = true
    pbFrame.Visible = CONFIG.AUTO_STEAL_ENABLED
    pbFrame.ZIndex = 10

    pbScale = Instance.new("UIScale", pbFrame)
    -- Barra de Auto Grab reducida: factor de 0.7 (70% del tamaño original)
    pbScale.Scale = stealBarScale

    if savedProgressBarPos then
        pbFrame.Position = UDim2.new(
            savedProgressBarPos.XScale or 0,
            savedProgressBarPos.XOffset or 300,
            savedProgressBarPos.YScale or 1,
            savedProgressBarPos.YOffset or -80
        )
    end

    local corner = Instance.new("UICorner", pbFrame)
    corner.CornerRadius = UDim.new(0, 28)


    local topRow = Instance.new("Frame", pbFrame)
    topRow.Size = UDim2.new(1, 0, 0, 0)
    topRow.Position = UDim2.new(0, 0, 0, 0)
    topRow.BackgroundTransparency = 1
    topRow.Visible = false
    topRow.ZIndex = 12

    -- Porcentaje grande arriba a la izquierda
    progressPct = Instance.new("TextLabel", pbFrame)
    progressPct.Name = "ProgressPct"
    progressPct.Size = UDim2.new(0.5, 0, 0, 44)
    progressPct.Position = UDim2.new(0, 28, 0, 8)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = Color3.fromRGB(255,255,255)
    progressPct.Font = Enum.Font.GothamBlack
    progressPct.TextSize = 28
    progressPct.TextXAlignment = Enum.TextXAlignment.Left
    progressPct.TextYAlignment = Enum.TextYAlignment.Top
    progressPct.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    progressPct.TextStrokeTransparency = 0.4
    progressPct.ZIndex = 13

    -- Barra de carga en el centro (más alta)
    local progressRow = Instance.new("Frame", pbFrame)
    progressRow.Size = UDim2.new(1, -56, 0, 34)
    progressRow.Position = UDim2.new(0, 28, 0, 86)
    progressRow.BackgroundTransparency = 1
    progressRow.ZIndex = 11

    local fillRegion = Instance.new("Frame", progressRow)
    fillRegion.Size = UDim2.new(1, 0, 1, 0)
    fillRegion.BackgroundColor3 = Color3.fromRGB(20,20,25)
    fillRegion.BackgroundTransparency = 0.3
    fillRegion.BorderSizePixel = 0
    fillRegion.ClipsDescendants = true
    fillRegion.ZIndex = 12
    local fillCorner = Instance.new("UICorner", fillRegion)
    fillCorner.CornerRadius = UDim.new(0, 17)

    progressFill = Instance.new("Frame", fillRegion)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(200,200,210)
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 13
    local fillCorner2 = Instance.new("UICorner", progressFill)
    fillCorner2.CornerRadius = UDim.new(0, 17)

    local fillGrad = Instance.new("UIGradient", progressFill)
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(200,200,210)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(150,150,160)),
    })
    fillGrad.Rotation = 0

    local glowEnd = Instance.new("Frame", progressFill)
    glowEnd.Size = UDim2.new(0, 18, 1, 0)
    glowEnd.Position = UDim2.new(1, -18, 0, 0)
    glowEnd.BackgroundColor3 = Color3.fromRGB(255,255,255)
    glowEnd.BackgroundTransparency = 0.7
    glowEnd.BorderSizePixel = 0
    glowEnd.ZIndex = 14
    local glowCorner2 = Instance.new("UICorner", glowEnd)
    glowCorner2.CornerRadius = UDim.new(0, 17)
    local glowGrad2 = Instance.new("UIGradient", glowEnd)
    glowGrad2.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,255,255)),
    })
    glowGrad2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0)})

    -- Fila inferior: FPS (izq), estado (centro), PING (der)
    local bottomRow = Instance.new("Frame", pbFrame)
    bottomRow.Size = UDim2.new(1, -56, 0, 24)
    bottomRow.Position = UDim2.new(0, 28, 0, 54)
    bottomRow.BackgroundTransparency = 1
    bottomRow.ZIndex = 12

    local fpsNeon = Instance.new("TextLabel", bottomRow)
    fpsNeon.Name = "FPSNeon"
    fpsNeon.Size = UDim2.new(0.3, 0, 1, 0)
    fpsNeon.Position = UDim2.new(0, 0, 0, 0)
    fpsNeon.BackgroundTransparency = 1
    fpsNeon.Text = "FPS: --"
    fpsNeon.TextColor3 = Color3.fromRGB(255,255,255)
    fpsNeon.Font = Enum.Font.GothamBold
    fpsNeon.TextSize = 20
    fpsNeon.TextXAlignment = Enum.TextXAlignment.Left
    fpsNeon.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    fpsNeon.TextStrokeTransparency = 0.3
    fpsNeon.ZIndex = 13

    local statusLabel = Instance.new("TextLabel", bottomRow)
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(0.4, 0, 1, 0)
    statusLabel.Position = UDim2.new(0.3, 0, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "NORMAL"
    statusLabel.TextColor3 = Color3.fromRGB(235,235,240)
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 20
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    statusLabel.TextStrokeTransparency = 0.3
    statusLabel.ZIndex = 13

    local pingLabel = Instance.new("TextLabel", bottomRow)
    pingLabel.Name = "PingLabel"
    pingLabel.Size = UDim2.new(0.3, 0, 1, 0)
    pingLabel.Position = UDim2.new(0.7, 0, 0, 0)
    pingLabel.BackgroundTransparency = 1
    pingLabel.Text = "PING: --ms"
    pingLabel.TextColor3 = Color3.fromRGB(255,255,255)
    pingLabel.Font = Enum.Font.GothamBold
    pingLabel.TextSize = 20
    pingLabel.TextXAlignment = Enum.TextXAlignment.Right
    pingLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    pingLabel.TextStrokeTransparency = 0.3
    pingLabel.ZIndex = 13

    drag(pbFrame)

    task.spawn(function()
        local lastFrame = _tick()
        local fpsSamples = {}
        local fpsAvg = 60
        RunService.RenderStepped:Connect(function()
            local now = _tick()
            local dt = now - lastFrame
            lastFrame = now
            if dt > 0 then
                table.insert(fpsSamples, 1 / dt)
                if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
                local sum = 0
                for _, v in ipairs(fpsSamples) do sum = sum + v end
                fpsAvg = sum / #fpsSamples
            end
        end)
        while true do
            local ping = 0
            pcall(function() ping = LP:GetNetworkPing() * 1000 end)
            if fpsNeon then
                fpsNeon.Text = string.format("FPS: %d", _floor(fpsAvg + 0.5))
            end
            if pingLabel then
                pingLabel.Text = string.format("PING: %dms", _floor(ping + 0.5))
            end
            if statusLabel then
                local st = "NORMAL"
                pcall(function()
                    if CarrySystem and CarrySystem.getStatus then
                        st = CarrySystem:getStatus()
                    end
                end)
                statusLabel.Text = string.format("%s  %d RADIUS", st, CONFIG.STEAL_RANGE)
            end
            task.wait(0.5)
        end
    end)

    drag(main)
end

function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "BloodHoundsMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local BTN_W, BTN_H = 60, 60
    local GAP = 8
    local COLUMNS = 2
    local ROWS = 4
    local PANEL_W = BTN_W * COLUMNS + GAP * (COLUMNS - 1)
    local PANEL_H = BTN_H * ROWS + (GAP + 10) * (ROWS - 1)

    local container = Instance.new("Frame", panel)
    container.Name = "FloatingPanel"
    container.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    container.Position = UDim2.new(1, -150, 0, 16)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Active = true
    container.Selectable = true
    container.ClipsDescendants = false

    local containerScale = Instance.new("UIScale", container)
    containerScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, containerScale)

    mobileMainPanelGui = panel
    _mobilePanelContainer = container
    _mobileBtnCorners = {}
    _mobileBtns = {}

    local btnContainer = Instance.new("Frame", container)
    btnContainer.Name = "ButtonsContainer"
    btnContainer.Size = UDim2.new(1, 0, 1, 0)
    btnContainer.BackgroundTransparency = 1
    btnContainer.ClipsDescendants = false

    local SILVER = Color3.fromRGB(180, 180, 190)
    local WHITE = Color3.fromRGB(255, 255, 255)
    local INACTIVE_BG = Color3.fromRGB(0,0,0)
    local INACTIVE_TEXT = Color3.fromRGB(255,255,255)
    local STROKE_COLOR = Color3.fromRGB(55,55,60)
    local ACTIVE_BG = getThemeColor()
    local ACTIVE_TEXT = WHITE

    local buttons = {}
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2"}
    local buttonTexts = {"DROP\nBR", "AUTO\nLEFT", "BAT\nAIMBOT", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPD", "LAGGER\nNORMAL", "LAGGER\nCARRY"}

    local function createButton(name, text, order, isToggle, callback)
        local btn = Instance.new("TextButton", btnContainer)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.BackgroundColor3 = INACTIVE_BG
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 10

        local savedPos = savedButtonPositions[name]
        if savedPos then
            btn.Position = UDim2.new(0, savedPos.X or 0, 0, savedPos.Y or 0)
        else
            local defX, defY = getDefaultButtonPosition(name)
            btn.Position = UDim2.new(0, defX, 0, defY)
        end

        btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
        -- Forma de los botones flotantes igual a la referencia: cuadrado con puntas suavemente redondeadas.
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 10)
        table.insert(_mobileBtnCorners, btnCorner)
        table.insert(_mobileBtns, btn)

        local bgGrad = Instance.new("UIGradient", btn)
        bgGrad.Name = "BtnGrad"
        bgGrad.Rotation = 90
        bgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0,0,0)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0,0,0)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0,0,0)),
        })

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(55,55,60)
        stroke.Thickness = 1
        stroke.Transparency = 0.15
        stroke.Name = "NormalStroke"

        local label = Instance.new("TextLabel", btn)
        label.Name = "TextLabel"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255,255,255)
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 11
        label.TextWrapped = true
        label.ZIndex = 11

        local active = false
        local function setActive(state)
            active = state
            btn:SetAttribute("MobActive", state and true or false)
            paintFloatingBtn(btn, state)
        end
        setActive(false)

        local dragging = false
        local hasMoved = false
        local dragStart = nil
        local startPos = nil
        local movedDistance = 0

        local function onInputBegan(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                hasMoved = false
                movedDistance = 0
                dragStart = input.Position
                startPos = btn.Position
                _isDraggingButton = true
            end
        end

        local function onInputChanged(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                movedDistance = delta.Magnitude
                if not uiLocked then
                    hasMoved = true
                    btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                end
            end
        end

        local function onInputEnded(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if movedDistance < 3 then
                        if isToggle then
                            if callback then callback(setActive) end
                        else
                            if callback then callback(setActive, active) end
                        end
                    elseif not uiLocked and hasMoved then
                        savedButtonPositions[name] = {
                            X = btn.Position.X.Offset,
                            Y = btn.Position.Y.Offset
                        }
                        pcall(saveAllSettings)
                    end
                    dragging = false
                    hasMoved = false
                    dragStart = nil
                    startPos = nil
                    movedDistance = 0
                    _isDraggingButton = false
                end
            end
        end

        btn.InputBegan:Connect(onInputBegan)
        btn.InputChanged:Connect(onInputChanged)
        btn.InputEnded:Connect(onInputEnded)

        buttons[name] = {btn = btn, setActive = setActive, label = label}
        return setActive
    end

    for i, name in ipairs(buttonNames) do
        local text = buttonTexts[i]
        local callback
        if name == "DropBR" then
            callback = function(setActive)
                if autoBatEnabled then return end
                setActive(true)
                executeDropWithToggle(function(v)
                    if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end
                end)
                task.delay(0.3, function() setActive(false) end)
            end
        elseif name == "AutoLeft" then
            callback = function(setActive)
                autoLeftEnabled = not autoLeftEnabled
                setActive(autoLeftEnabled)
                if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
                if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
            end
        elseif name == "AutoBat" then
            callback = function(setActive)
                if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
                setActive(autoBatEnabled)
            end
        elseif name == "AutoRight" then
            callback = function(setActive)
                autoRightEnabled = not autoRightEnabled
                setActive(autoRightEnabled)
                if autoRightEnabled then startAutoRight() else stopAutoRight() end
                if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
            end
        elseif name == "TpDown" then
            callback = function(setActive)
                doTpDown()
                setActive(true)
                task.delay(0.2, function() setActive(false) end)
            end
        elseif name == "Carry" then
            callback = function(setActive)
                if not speedMode then
                    speedMode = true; laggerToggled = false; laggerCarryToggled = false; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    speedMode = false; setActive(false)
                end
                refreshSpeedModeLabel()
            end
        elseif name == "Lagger1" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerToggled then
                    laggerToggled = true; laggerCarryToggled = false; setActive(true)
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    laggerToggled = false; setActive(false)
                end
                refreshSpeedModeLabel()
            end
        elseif name == "Lagger2" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerCarryToggled then
                    laggerCarryToggled = true; laggerToggled = false; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                else
                    laggerToggled = false; setActive(false)
                end
                refreshSpeedModeLabel()
            end
        end
        mobSetAutoBat = buttons.AutoBat and buttons.AutoBat.setActive
        mobSetAutoLeft = buttons.AutoLeft and buttons.AutoLeft.setActive
        mobSetAutoRight = buttons.AutoRight and buttons.AutoRight.setActive
        mobSetDropBR = buttons.DropBR and buttons.DropBR.setActive
        mobSetTpDown = buttons.TpDown and buttons.TpDown.setActive
        mobSetCarry = buttons.Carry and buttons.Carry.setActive
        mobSetLagger1 = buttons.Lagger1 and buttons.Lagger1.setActive
        mobSetLagger2 = buttons.Lagger2 and buttons.Lagger2.setActive

        local setActive = createButton(name, text, i-1, true, callback)
        if name == "AutoBat" then mobSetAutoBat = setActive end
        if name == "AutoLeft" then mobSetAutoLeft = setActive end
        if name == "AutoRight" then mobSetAutoRight = setActive end
        if name == "DropBR" then mobSetDropBR = setActive end
        if name == "TpDown" then mobSetTpDown = setActive end
        if name == "Carry" then mobSetCarry = setActive end
        if name == "Lagger1" then mobSetLagger1 = setActive end
        if name == "Lagger2" then mobSetLagger2 = setActive end
    end

    if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled) end
    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerCarryToggled) end

    if savedMobilePanelPos then
        container.Position = UDim2.new(
            savedMobilePanelPos.XScale or 0,
            savedMobilePanelPos.XOffset or 10,
            savedMobilePanelPos.YScale or 0,
            savedMobilePanelPos.YOffset or 0
        )
    end

    local draggingPanel = false
    local dragStartPos = nil
    local dragStartMousePos = nil
    local function startDragPanel(input)
        if uiLocked or _isDraggingButton then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingPanel = true
            dragStartPos = container.Position
            dragStartMousePos = input.Position
        end
    end
    local function onDragPanel(input)
        if not draggingPanel or uiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragStartPos and dragStartMousePos then
                local delta = input.Position - dragStartMousePos
                local newX = dragStartPos.X.Offset + delta.X
                local newY = dragStartPos.Y.Offset + delta.Y
                container.Position = UDim2.new(dragStartPos.X.Scale, newX, dragStartPos.Y.Scale, newY)
            end
        end
    end
    local function endDragPanel()
        if draggingPanel then
            draggingPanel = false
            savedMobilePanelPos = {
                XScale = container.Position.X.Scale,
                XOffset = container.Position.X.Offset,
                YScale = container.Position.Y.Scale,
                YOffset = container.Position.Y.Offset
            }
            pcall(saveAllSettings)
        end
        dragStartPos = nil
        dragStartMousePos = nil
    end
    container.InputBegan:Connect(startDragPanel)
    container.InputEnded:Connect(endDragPanel)
    UIS.InputChanged:Connect(onDragPanel)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            endDragPanel()
        end
    end)

    return panel
end

function createTpBatFloatingButton()
    local SILVER = Color3.fromRGB(180, 180, 190)
    local panel = Instance.new("ScreenGui")
    panel.Name = "TpBatButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 21
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    if tpBatFloatingPos then
        btnFrame.Position = UDim2.new(tpBatFloatingPos.XScale or 0.5,
                                      tpBatFloatingPos.XOffset or 20,
                                      tpBatFloatingPos.YScale or 0,
                                      tpBatFloatingPos.YOffset or 10)
    else
        btnFrame.Position = UDim2.new(1, -228, 0, 16)
    end
    btnFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    local btnCorner = Instance.new("UICorner", btnFrame)
    btnCorner.CornerRadius = UDim.new(0, 10)
    table.insert(_floatingBtnCorners, btnCorner)
    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0,0,0)),
    })
    -- (sin borde: botones flotantes sin linea de contorno para igualar a los demas)
    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "TP\nBAT"
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21

    local uiScale = Instance.new("UIScale", btnFrame)
    uiScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, uiScale)

    local function setActive(state)
        label.Text = "TP\nBAT"
        paintFloatingBtn(btnFrame, state)
    end

    local dragging = false; local hasMoved = false; local dragStart, startPos
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; hasMoved = false; dragStart = inp.Position; startPos = btnFrame.Position
        end
    end)
    btnFrame.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            if hasMoved and not uiLocked then
                btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                              startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    btnFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    toggleBatDesyncTp()
                    setActive(batDesyncTpEnabled)
                elseif not uiLocked and hasMoved then
                    tpBatFloatingPos = {
                        XScale = btnFrame.Position.X.Scale,
                        XOffset = btnFrame.Position.X.Offset,
                        YScale = btnFrame.Position.Y.Scale,
                        YOffset = btnFrame.Position.Y.Offset
                    }
                    pcall(saveAllSettings)
                end
                dragging = false; hasMoved = false
            end
        end
    end)

    tpBatFloatingButton = panel
    return panel
end

function createBatBypassFloatingButton()
    local SILVER = Color3.fromRGB(180, 180, 190)
    local panel = Instance.new("ScreenGui")
    panel.Name = "BatBypassButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 22
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    if batBypassFloatingPos then
        btnFrame.Position = UDim2.new(batBypassFloatingPos.XScale or 0.5,
                                      batBypassFloatingPos.XOffset or -50,
                                      batBypassFloatingPos.YScale or 0,
                                      batBypassFloatingPos.YOffset or 10)
    else
        btnFrame.Position = UDim2.new(1, -228, 0, 94)
    end
    btnFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    local btnCorner = Instance.new("UICorner", btnFrame)
    btnCorner.CornerRadius = UDim.new(0, 10)
    table.insert(_floatingBtnCorners, btnCorner)

    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0,0,0)),
    })
    -- (sin borde: botones flotantes sin linea de contorno para igualar a los demas)

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "BAT\nBYPASS"
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21

    local uiScale = Instance.new("UIScale", btnFrame)
    uiScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, uiScale)

    local function setActive(state)
        paintFloatingBtn(btnFrame, state)
    end

    local dragging = false; local hasMoved = false; local dragStart, startPos
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; hasMoved = false; dragStart = inp.Position; startPos = btnFrame.Position
        end
    end)
    btnFrame.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            if hasMoved and not uiLocked then
                btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                              startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    btnFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    setActive(not autoBatBypassEnabled)
                    toggleBatBypass()
                elseif not uiLocked and hasMoved then
                    batBypassFloatingPos = {
                        XScale = btnFrame.Position.X.Scale,
                        XOffset = btnFrame.Position.X.Offset,
                        YScale = btnFrame.Position.Y.Scale,
                        YOffset = btnFrame.Position.Y.Offset
                    }
                    pcall(saveAllSettings)
                end
                dragging = false; hasMoved = false
            end
        end
    end)

    batBypassFloatingButton = panel
    return panel
end

function createInstaResetFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "InstaResetButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 23
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    if instaResetFloatingPos then
        btnFrame.Position = UDim2.new(instaResetFloatingPos.XScale or 0.5,
                                      instaResetFloatingPos.XOffset or -80,
                                      instaResetFloatingPos.YScale or 0,
                                      instaResetFloatingPos.YOffset or 10)
    else
        btnFrame.Position = UDim2.new(0.5, -80, 0, 178)
    end
    btnFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btnFrame.BorderSizePixel  = 0
    btnFrame.ZIndex           = 20
    local btnCorner = Instance.new("UICorner", btnFrame)
    btnCorner.CornerRadius = UDim.new(0, 10)
    table.insert(_floatingBtnCorners, btnCorner)

    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0,0,0)),
    })
    -- (sin borde: botones flotantes sin linea de contorno para igualar a los demas)


    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "INSTA\nRESET"
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21

    local uiScale = Instance.new("UIScale", btnFrame)
    uiScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, uiScale)

    local dragging, hasMoved, dragStart, startPos, activeInput
    local RESET_TAP_THRESHOLD = 12

    local function pointInside(pos)
        local ap = btnFrame.AbsolutePosition
        local as = btnFrame.AbsoluteSize
        return pos.X >= ap.X and pos.X <= ap.X + as.X
           and pos.Y >= ap.Y and pos.Y <= ap.Y + as.Y
    end

    local function setActive(state)
        if state then
            TS:Create(btnFrame, TweenInfo.new(0.05), {BackgroundColor3 = getThemeColor()}):Play()
            TS:Create(label,    TweenInfo.new(0.05), {TextColor3       = Color3.fromRGB(255,255,255)}):Play()
        else
            paintFloatingBtn(btnFrame, false)
        end
    end

    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            if activeInput then return end
            activeInput = inp
            dragging    = true
            hasMoved    = false
            dragStart   = inp.Position
            startPos    = btnFrame.Position
        end
    end)

    UIS.InputChanged:Connect(function(inp)
        if not dragging or not activeInput then return end
        local isTouchMove = activeInput.UserInputType == Enum.UserInputType.Touch and inp == activeInput
        local isMouseMove = activeInput.UserInputType == Enum.UserInputType.MouseButton1
                            and inp.UserInputType == Enum.UserInputType.MouseMovement
        if not isTouchMove and not isMouseMove then return end
        local delta = inp.Position - dragStart
        if delta.Magnitude > RESET_TAP_THRESHOLD then hasMoved = true end
        if hasMoved and not uiLocked then
            btnFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(inp)
        if inp ~= activeInput then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1
        and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        if dragging then
            local delta = inp.Position - dragStart
            local validTap = not hasMoved
                             and delta.Magnitude <= RESET_TAP_THRESHOLD
                             and pointInside(inp.Position)
            if validTap then
                print("[IR] tap → instaReset()")
                setActive(true)
                if _G.InstaReset and _G.InstaReset.Trigger then
                    _G.InstaReset.Trigger()
                end
                task.delay(0.2, function() setActive(false) end)
            elseif not uiLocked and hasMoved then
                instaResetFloatingPos = {
                    XScale  = btnFrame.Position.X.Scale,
                    XOffset = btnFrame.Position.X.Offset,
                    YScale  = btnFrame.Position.Y.Scale,
                    YOffset = btnFrame.Position.Y.Offset,
                }
                pcall(saveAllSettings)
            end
            dragging    = false
            hasMoved    = false
            activeInput = nil
        end
    end)

    instaResetFloatingButton = panel
    return panel
end

function updateUIFromLoaded()
    task.wait()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if uiScaleStepperSet then uiScaleStepperSet(uiScaleValue) end
    if floatScaleStepperSet then floatScaleStepperSet(floatingButtonScale) end
    if stealBarStepperSet then stealBarStepperSet(stealBarScale) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if carrySysNormalBox then carrySysNormalBox.Text = tostring(CarrySystem.normalSpeed) end
    if carrySysCarryBox then carrySysCarryBox.Text = tostring(CarrySystem.carrySpeed) end
    if carrySysLaggerBox then carrySysLaggerBox.Text = tostring(CarrySystem.laggerSpeed) end
    if carrySysLaggerCarryBox then carrySysLaggerCarryBox.Text = tostring(CarrySystem.laggerCarrySpeed) end
    if carrySysSoftStealSpeedBox then carrySysSoftStealSpeedBox.Text = tostring(CarrySystem.softStealSpeed) end
    if carrySysSoftStealRadiusBox then carrySysSoftStealRadiusBox.Text = tostring(CarrySystem.softStealRadius) end
    if carrySystemToggleSetter then carrySystemToggleSetter(useCarrySystem) end
    if autoCarryEnemyBaseRangeBox then autoCarryEnemyBaseRangeBox.Text = tostring(autoCarryEnemyBaseRange) end
    if setAutoCarrySpeedVisual then pcall(function() setAutoCarrySpeedVisual(autoCarrySpeedEnabled == true) end) end
    if setAutoCarryEnemyBaseVisual then pcall(function() setAutoCarryEnemyBaseVisual(autoCarryEnemyBaseEnabled == true) end) end
    if autoCarryEnemyBaseEnabled and _G.StrikeStartAutoCarryEnemyBase then pcall(_G.StrikeStartAutoCarryEnemyBase) end
    refreshSpeedModeLabel()

    -- Custom Tools: aplicar y repintar el toggle segun la config guardada
    do
        local ctOn = _customToolsEnabledLoaded == true
        if _G.AmbitiousCustomTools then
            pcall(function() _G.AmbitiousCustomTools.setEnabled(ctOn) end)
        end
        if ctSetCustomToolsVisual then pcall(ctSetCustomToolsVisual, ctOn) end
    end

    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end

    if savedProgressBarPos and pbFrame then
        pbFrame.Position = UDim2.new(
            savedProgressBarPos.XScale or 0,
            savedProgressBarPos.XOffset or 300,
            savedProgressBarPos.YScale or 1,
            savedProgressBarPos.YOffset or -80
        )
    end

    local bgImg = main and main:FindFirstChild("BackgroundImage")
    if bgImg then
        bgImg.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
        bgImg.ImageTransparency = backgroundImageTransparency
    end

    applyFloatingButtonScale()

    if uiLocked and setLockUIVisual then setLockUIVisual(true) end
    if editModeEnabled and setEditModeVisual then setEditModeVisual(true) end

    if antiRagdollMode == "v1" then
        AntiRagdollV1.start()
    elseif antiRagdollMode == "v2" then
        startAntiRagdollV2()
    else
        antiRagdollMode = "off"
    end
    if setAntiRagdollVisual then setAntiRagdollVisual(antiRagdollMode ~= "off") end
    if updateAntiRagdollModeUI then updateAntiRagdollModeUI(antiRagdollMode) end

    if antiDieEnabled then
        if setAntiDieVisual then setAntiDieVisual(true) end
        AntiDieModule.start()
    else
        if setAntiDieVisual then setAntiDieVisual(false) end
    end

    if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then setInstaGrab(true); pcall(startAutoSteal) end

    if medusaCounterEnabled then
        if setMedusaVisual then setMedusaVisual(true) end
        if LP.Character then setupMedusaCounter(LP.Character) end
    else
        if setMedusaVisual then setMedusaVisual(false) end
        stopMedusaCounter()
    end

    if batCounterEnabled and setBatCounterVisual then
        setBatCounterVisual(true)
        startBatCounter()
    end
    if antiLagEnabled then
        if setAntiLagVisual then setAntiLagVisual(true) end
        enableAntiLag()
    else
        if setAntiLagVisual then setAntiLagVisual(false) end
        disableAntiLag()
    end
    toggleESP(espEnabled == true)
    toggleESPBox(espBoxEnabled == true)
    toggleESPTracker(espTrackerEnabled == true)
    toggleRagdollCountdown(ragdollCountdownEnabled ~= false)
    toggleAntiTpEsp(antiTpEspEnabled == true)

    if batDesyncTpEnabled then
        if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
        if not batDesyncTpConn then startBatDesyncTp() end
        updateTpBatButtonWithAntiDie(true)
    else
        if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
        updateTpBatButtonWithAntiDie(false)
    end

    if autoBatBypassEnabled then
        if autoBatBypassSetVisual then autoBatBypassSetVisual(true) end
        if not batBypassClean.Connection then startBatBypassClean() end
        if batBypassFloatingButton then
            local btnFrame = batBypassFloatingButton:FindFirstChild("Frame")
            if btnFrame then
                btnFrame.BackgroundColor3 = BTN_ACTIVE_COLOR
                local label = btnFrame:FindFirstChild("TextLabel")
                if label then label.TextColor3 = Color3.fromRGB(255,255,255) end
            end
        end
    else
        if autoBatBypassSetVisual then autoBatBypassSetVisual(false) end
        if batBypassFloatingButton then
            local btnFrame = batBypassFloatingButton:FindFirstChild("Frame")
            if btnFrame then paintFloatingBtn(btnFrame, false) end
        end
    end

    if neonWeatherEnabled then
        applyNeonWeather()
        if setNeonWeatherVisual then setNeonWeatherVisual(true) end
    else
        restoreLightingState()
        if setNeonWeatherVisual then setNeonWeatherVisual(false) end
    end

    if stretchEnabled then
        enableStretch()
        if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    else
        if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    end

    if setFovVisual then setFovVisual(fovEnabled) end
    if fovSliderSet then fovSliderSet(fovValue) end

    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end


    updateProgressBarVisibility()
    startEnemySpeed()

    toggleLockUI(uiLocked)

    if colorSelectorLabel then
        colorSelectorLabel.Text = currentColorTheme
        colorSelectorLabel.TextColor3 = selectedColor
    end

end

-- ============================================================
-- STRIKE INTRO
-- Una sola imagen en la misma zona del antiguo wordmark de Vanta.
-- Imagen: 77692594931925
-- ============================================================
local function strikeGetAsset(fileName, url)
    local getAsset = getcustomasset or getsynasset
    if type(getAsset) ~= "function" or type(writefile) ~= "function" then return nil end
    local exists = false
    pcall(function() exists = type(isfile) == "function" and isfile(fileName) or false end)
    if not exists then
        local ok, data = pcall(function() return game:HttpGet(url) end)
        if ok and type(data) == "string" and #data > 0 then
            pcall(writefile, fileName, data)
        end
    end
    local ok, asset = pcall(getAsset, fileName)
    if ok then return asset end
    return nil
end

local function strikeStopIntroSong()
    if strikeIntroSound then
        pcall(function() strikeIntroSound:Stop() end)
        pcall(function() strikeIntroSound:Destroy() end)
        strikeIntroSound = nil
    end
end

local function strikePlayIntroSong(songName, restart)
    if songName == "Off" or not songName then
        strikeStopIntroSong()
        return
    end
    local info = INTRO_SONGS[songName]
    if not info then return end
    if restart then strikeStopIntroSong() end
    if strikeIntroSound and strikeIntroSound.Parent then return end

    local asset = strikeGetAsset(info.file, info.url)
    if not asset then return end

    local sound = Instance.new("Sound")
    sound.Name = "StrikeIntroMusic"
    sound.SoundId = asset
    sound.Volume = 0.65
    sound.Looped = false
    sound.Parent = SoundService
    strikeIntroSound = sound
    pcall(function() sound:Play() end)
end

local function strikeFinishIntro()
    if strikeIntroFinished then return end
    strikeIntroFinished = true
    local gui = strikeIntroGui
    if not gui then
        strikeStopIntroSong()
        return
    end
    local bg = gui:FindFirstChild("Background")
    local word = bg and bg:FindFirstChild("StrikeWordmark")
    local img = word and word:FindFirstChild("StrikeImage")
    local skip = bg and bg:FindFirstChild("SkipText")
    local blur = Lighting:FindFirstChild("StrikeLoadIntroBlur")
    local scale = word and word:FindFirstChildOfClass("UIScale")
    local info = TweenInfo.new(0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    if bg then TweenService:Create(bg, info, {BackgroundTransparency = 1}):Play() end
    if scale then TweenService:Create(scale, info, {Scale = 0.72}):Play() end
    if img then TweenService:Create(img, info, {ImageTransparency = 1}):Play() end
    if skip then TweenService:Create(skip, info, {TextTransparency = 1}):Play() end
    if blur then TweenService:Create(blur, info, {Size = 0}):Play() end
    if strikeIntroSound then
        task.spawn(function()
            local snd = strikeIntroSound
            for i = 1, 16 do
                if not snd or not snd.Parent then break end
                snd.Volume = 0.65 * (1 - i / 16)
                task.wait(0.05)
            end
            pcall(function() snd:Stop() end)
            pcall(function() snd:Destroy() end)
            if strikeIntroSound == snd then strikeIntroSound = nil end
        end)
    end
    task.delay(0.45, function()
        if strikeIntroGui == gui then strikeIntroGui = nil end
        pcall(function() gui:Destroy() end)
        pcall(function() if blur then blur:Destroy() end end)
    end)
end

_G.__STRIKE_FINISH_INTRO = strikeFinishIntro
_G.__STRIKE_PLAY_INTRO_SONG = strikePlayIntroSong

local function startStrikeIntro()
    if SKIP_INTRO then return end
    strikeIntroFinished = false
    local old = LP.PlayerGui:FindFirstChild("StrikeLoadIntro")
    if old then old:Destroy() end
    local oldBlur = Lighting:FindFirstChild("StrikeLoadIntroBlur")
    if oldBlur then oldBlur:Destroy() end

    local touch = UIS.TouchEnabled and not UIS.KeyboardEnabled
    local gui = Instance.new("ScreenGui")
    gui.Name = "StrikeLoadIntro"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 1000005
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.Parent = LP.PlayerGui
    strikeIntroGui = gui

    local bg = Instance.new("Frame")
    bg.Name = "Background"
    bg.BackgroundColor3 = Color3.fromRGB(8,8,8)
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel = 0
    bg.Size = UDim2.fromScale(1,1)
    bg.ZIndex = 1000
    bg.Parent = gui

    local stars = Instance.new("Frame")
    stars.Name = "MovingStars"
    stars.BackgroundTransparency = 1
    stars.BorderSizePixel = 0
    stars.Size = UDim2.fromScale(1,1)
    stars.ClipsDescendants = true
    stars.ZIndex = 1001
    stars.Parent = bg

    local starData = {}
    local starCount = touch and 34 or 60
    for i = 1, starCount do
        local star = Instance.new("Frame")
        star.BackgroundColor3 = (i % 6 == 1) and Color3.fromRGB(190,204,255) or Color3.fromRGB(238,240,255)
        star.BackgroundTransparency = 1
        star.BorderSizePixel = 0
        star.AnchorPoint = Vector2.new(0.5,0.5)
        star.Size = UDim2.fromOffset((i % 9 == 0) and 3 or 2, (i % 9 == 0) and 3 or 2)
        star.ZIndex = 1001
        star.Parent = stars
        local c = Instance.new("UICorner", star)
        c.CornerRadius = UDim.new(1,0)
        starData[i] = {object=star, x=(i*37%101)/100, y=(i*61%101)/100, speed=0.008+(i%30)*0.004, phase=i*0.83, opacity=0.35+(i%4)*0.1}
    end

    local word = Instance.new("Frame")
    word.Name = "StrikeWordmark"
    word.BackgroundTransparency = 1
    word.BorderSizePixel = 0
    word.AnchorPoint = Vector2.new(0.5,0.5)
    word.Position = UDim2.fromScale(0.5,0.43)
    word.Size = touch and UDim2.fromOffset(340,105) or UDim2.fromOffset(820,230)
    word.ZIndex = 1003
    word.Parent = bg
    local scale = Instance.new("UIScale", word)
    scale.Scale = 0.86

    local img = Instance.new("ImageLabel")
    img.Name = "StrikeImage"
    img.BackgroundTransparency = 1
    img.BorderSizePixel = 0
    img.Image = "rbxassetid://77692594931925"
    img.ImageTransparency = 1
    img.ScaleType = Enum.ScaleType.Fit
    img.AnchorPoint = Vector2.new(0.5,0.5)
    img.Position = UDim2.fromScale(0.5,0.5)
    img.Size = UDim2.fromScale(1,1)
    img.ZIndex = 1004
    img.Parent = word
    pcall(function() ContentProvider:PreloadAsync({img}) end)

    local skip = Instance.new("TextLabel")
    skip.Name = "SkipText"
    skip.BackgroundTransparency = 1
    skip.Text = "TAP ANYWHERE TO SKIP"
    skip.TextColor3 = Color3.fromRGB(240,240,244)
    skip.TextTransparency = 1
    skip.TextSize = touch and 11 or 18
    skip.Font = Enum.Font.GothamMedium
    skip.AnchorPoint = Vector2.new(0.5,0.5)
    skip.Position = touch and UDim2.new(0.5,0,0.43,82) or UDim2.new(0.5,0,0.43,155)
    skip.Size = UDim2.new(0.8,0,0,24)
    skip.ZIndex = 1010
    skip.Parent = bg

    local hit = Instance.new("TextButton")
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.AutoButtonColor = false
    hit.Size = UDim2.fromScale(1,1)
    hit.ZIndex = 1011
    hit.Parent = bg
    hit.Activated:Connect(strikeFinishIntro)

    local blur = Instance.new("BlurEffect")
    blur.Name = "StrikeLoadIntroBlur"
    blur.Size = 0
    blur.Parent = Lighting

    TweenService:Create(bg, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency=0.5}):Play()
    TweenService:Create(blur, TweenInfo.new(0.25), {Size=10}):Play()
    TweenService:Create(skip, TweenInfo.new(0.25), {TextTransparency=0.22}):Play()
    strikePlayIntroSong(INTRO_SONG, true)

    local started = os.clock()
    task.spawn(function()
        while gui.Parent and not strikeIntroFinished do
            local elapsed = os.clock()-started
            local t = math.clamp(elapsed/0.78,0,1)
            local e = t*t*(3-2*t)
            local pulse = math.sin(elapsed*1.62)*math.clamp((elapsed-0.38)/0.9,0,1)
            scale.Scale = 0.86 + e*0.14 + pulse*0.012
            local sf = math.clamp(elapsed/0.42,0,1)
            for _,d in ipairs(starData) do
                local x=(d.x+elapsed*d.speed)%1.12-0.06
                local y=d.y+math.sin(elapsed*0.78+d.phase)*0.012
                local shimmer=(math.sin(elapsed*2+d.phase)+1)*0.5
                d.object.Position=UDim2.fromScale(x,y)
                d.object.BackgroundTransparency=math.clamp(1-sf*(d.opacity+shimmer*0.15),0,1)
            end
            local wobble=math.sin(elapsed*2.85)
            local wobble2=math.sin(elapsed*2.1)
            img.Position=UDim2.new(0.5,0,0.5,wobble2*1.35)
            img.Size=UDim2.fromScale(1+wobble*0.026,1-wobble*0.038)
            img.Rotation=wobble2*0.9
            img.ImageTransparency=1-math.clamp((elapsed-0.02)/0.18,0,1)
            RunService.RenderStepped:Wait()
        end
    end)
    task.delay(10, strikeFinishIntro)
end

-- FAST/SAFE START: keep the first paint fast, but never allow a failure in
-- saved-config/UI restoration to stop the rest of the startup pipeline.
pcall(buildGui)

-- Load saved settings after the shell exists. Protected so a bad/old config
-- cannot prevent floating controls and later systems from initializing.
task.defer(function()
    local loadedOk, loaded = pcall(loadAllSettings)
    if loadedOk and loaded then
        pcall(updateUIFromLoaded)
    end
end)

if introSongSelectorLabel then introSongSelectorLabel.Text = INTRO_SONG end
if skipIntroSetVisual then pcall(skipIntroSetVisual, SKIP_INTRO) end

-- Intro/assets are explicitly deferred so they can never hold up menu creation.
task.defer(function()
    task.defer(function() pcall(startStrikeIntro) end)
end)

-- ============================================================
-- FLOATING CONTROLS SAFE INITIALIZER
-- Some executors/clients can fail a single UI operation during the first
-- frame. Recreate missing floating controls independently so one failure
-- cannot make all of them disappear. This does not change their layout or
-- callbacks; it only adds a guarded initialization/retry layer.
-- ============================================================
local _floatingStartupNames = {
    MobilePanel = "BloodHoundsMobilePanel",
    tpBatFloatingButton = "TpBatButton",
    batBypassFloatingButton = "BatBypassButton",
    instaResetFloatingButton = "InstaResetButton",
}

local function _floatingAlive(obj, expectedName)
    return obj ~= nil and obj.Parent ~= nil and obj.Name == expectedName
end

local function _safeDestroyNamedGui(name)
    pcall(function()
        local cg = game:GetService("CoreGui")
        local old = cg:FindFirstChild(name)
        if old then old:Destroy() end
    end)
    pcall(function()
        local pg = LP:FindFirstChild("PlayerGui")
        if pg then
            local old = pg:FindFirstChild(name)
            if old then old:Destroy() end
        end
    end)
end

local function _ensureFloatingControls()
    -- Mobile panel
    if not _floatingAlive(MobilePanel, _floatingStartupNames.MobilePanel) then
        _safeDestroyNamedGui(_floatingStartupNames.MobilePanel)
        local ok, obj = pcall(createMobilePanel)
        if ok then MobilePanel = obj end
    end

    -- TP BAT
    if not _floatingAlive(tpBatFloatingButton, _floatingStartupNames.tpBatFloatingButton) then
        _safeDestroyNamedGui(_floatingStartupNames.tpBatFloatingButton)
        local ok, obj = pcall(createTpBatFloatingButton)
        if ok then tpBatFloatingButton = obj end
    end

    -- BAT BYPASS / BAT V2
    if not _floatingAlive(batBypassFloatingButton, _floatingStartupNames.batBypassFloatingButton) then
        _safeDestroyNamedGui(_floatingStartupNames.batBypassFloatingButton)
        local ok, obj = pcall(createBatBypassFloatingButton)
        if ok then batBypassFloatingButton = obj end
    end

    -- INSTA RESET
    if not _floatingAlive(instaResetFloatingButton, _floatingStartupNames.instaResetFloatingButton) then
        _safeDestroyNamedGui(_floatingStartupNames.instaResetFloatingButton)
        local ok, obj = pcall(createInstaResetFloatingButton)
        if ok then instaResetFloatingButton = obj end
    end

    pcall(setMobileButtonsHidden, mobileButtonsHidden)
    if hideMobileBtnsSetVisual then pcall(hideMobileBtnsSetVisual, mobileButtonsHidden) end
end

-- First attempt happens independently from config restoration.
_ensureFloatingControls()

-- Retry after Roblox/executor has had time to finish PlayerGui/CoreGui setup.
for _ = 1, 3 do
    task.delay(0.35 * _, _ensureFloatingControls)
end

if useCarrySystem then
    CarrySystem:start()
    CarrySystem.speedToggled = speedMode
    if laggerToggled then
    else
        CarrySystem:setLaggerMode(0)
    end
    CarrySystem:setSoftStealEnabled(true)
end

if LP.Character then
    task.wait(0.1)
    if waitForCharReady(LP.Character, 5) then
        setupMovementAndIndicators(LP.Character)
    end
end

-- ============================================================
-- CONEXIÓN ÚNICA DE RESPAWN (evita race conditions)
-- ============================================================
local _respawnQueue = 0
LP.CharacterAdded:Connect(function(char)
    _respawnQueue = _respawnQueue + 1
    local myId = _respawnQueue

    if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
    isStealing = false
    stopAutoLeft()
    stopAutoRight()
    stopBatCounter()
    stopMedusaCounter()
    stopDropBrainrot()
    if autoBatEnabled then disableAutoBat() end
    if batDesyncTpEnabled then stopBatDesyncTp() end
    if autoBatBypassEnabled then disableBatBypass() end

    local deadline = _tick() + 5
    while (not char.Parent) or (not char:FindFirstChild("HumanoidRootPart"))
          or (not char:FindFirstChildOfClass("Humanoid")) do
        if _tick() > deadline then return end
        if myId ~= _respawnQueue then return end
        task.wait(0.05)
    end

    _hookedVelParts = {}
    local _hrpRespawn = _setupVelChecked(char)
    _hookVelHRP(_hrpRespawn)

    setupMovementAndIndicators(char)

    if antiRagdollMode == "v1" then
        AntiRagdollV1.start()
    elseif antiRagdollMode == "v2" then
        startAntiRagdollV2()
    end
    if setAntiRagdollVisual then
        setAntiRagdollVisual(antiRagdollMode ~= "off")
    end
    if updateAntiRagdollModeUI then updateAntiRagdollModeUI(antiRagdollMode) end

    if AntiDieModule.enabled then task.defer(function() activateOnCharacter(char) end) end
    if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end
    if batDesyncTpEnabled then task.defer(startBatDesyncTp) end
    if autoBatBypassEnabled then task.defer(startBatBypass) end

    if medusaCounterEnabled then
        setupMedusaCounter(char)
        if setMedusaVisual then setMedusaVisual(true) end
    else
        stopMedusaCounter()
        if setMedusaVisual then setMedusaVisual(false) end
    end

    if batCounterEnabled then startBatCounter() end


    updateProgressBarVisibility()
    refreshSpeedModeLabel()

end)

local lastLaggerToggle = 0
local LAGGER_COOLDOWN = 0.3

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
        if _tick() - lastLaggerToggle >= LAGGER_COOLDOWN then
            lastLaggerToggle = _tick()
            toggleLaggerCycle()
        end
        return
    end
    if kbMatch(KB.CarryToggle, kc) then toggleCarryMode(); return end
    if kbMatch(KB.DropBrainrot, kc) then
        if not dropActive then
            if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
            executeDropWithToggle(dropBrainrotSetVisual)
        end
        return
    end
    if kbMatch(KB.TPFloor, kc) then doTpDown(); return end
    if kbMatch(KB.InstaReset, kc) then
        if _G.InstaReset and _G.InstaReset.Trigger then
            _G.InstaReset.Trigger()
        end
        return
    end
    if kbMatch(KB.AutoLeft, kc) then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
        return
    end
    if kbMatch(KB.AutoRight, kc) then
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
        return
    end
    if kbMatch(KB.AutoBat, kc) then
        if not autoBatEnabled then
            enableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(true) end
            if mobSetAutoBat then mobSetAutoBat(true) end
        else
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        return
    end
    if kbMatch(KB.TPBat, kc) then
        toggleBatDesyncTp()
        if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
        if tpBatFloatingButton then
            local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
            if btnFrame then paintFloatingBtn(btnFrame, batDesyncTpEnabled) end
        end
        return
    end
    if kbMatch(KB.BatBypass, kc) then
        toggleBatBypass()
        if autoBatBypassSetVisual then autoBatBypassSetVisual(autoBatBypassEnabled) end
        if batBypassFloatingButton then
            local btnFrame = batBypassFloatingButton:FindFirstChild("Frame")
            if btnFrame then paintFloatingBtn(btnFrame, autoBatBypassEnabled) end
        end
        return
    end
    if kbMatch(KB.GuiHide, kc) then
        if main then
            if main.Visible then hideGui() else showGui() end
        end
        return
    end
end)