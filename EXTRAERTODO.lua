-- AR-AI | FULL GAME DUMP
-- Extrae ABSOLUTAMENTE todo del juego
-- Output: workspace/DUMP_<GameName>/ + zip si el executor lo soporta
-- Compatible: Delta / Synapse X / KRNL / Fluxus

-- ════════════════════════════════════════════════
--  UTILIDADES BASE
-- ════════════════════════════════════════════════
local BASE    = "DUMP_" .. tostring(game.Name):gsub("[^%w_%-]","_"):sub(1,30)
local SESSION = tostring(math.floor(tick()))

local function mkdir(p)  if not isfolder(p) then pcall(makefolder, p) end end
local function wf(p, c)  pcall(writefile, p, c) end
local function appendf(p, c)
    local existing = ""
    if isfile(p) then existing = readfile(p) end
    wf(p, existing .. c)
end

-- Crear árbol de carpetas
local PATHS = {
    ROOT      = BASE,
    REMOTES   = BASE .. "/Remotes",
    SCRIPTS   = BASE .. "/Scripts",
    SERVICES  = BASE .. "/Services",
    WORKSPACE = BASE .. "/Workspace",
    REPLICATED= BASE .. "/ReplicatedStorage",
    PLAYERS   = BASE .. "/Players",
    GUI       = BASE .. "/GUI",
    MODULES   = BASE .. "/Modules",
    BINDABLES = BASE .. "/Bindables",
    SOUNDS    = BASE .. "/Sounds",
    MISC      = BASE .. "/Misc",
}
for _, p in pairs(PATHS) do mkdir(p) end

print("[AR-AI DUMP] Iniciando...")
print("[AR-AI DUMP] Output: workspace/" .. BASE .. "/")

-- ════════════════════════════════════════════════
--  HELPERS
-- ════════════════════════════════════════════════
local function safe(fn, ...)
    local ok, r = pcall(fn, ...)
    return ok and r or nil
end

local function propToStr(v)
    local t = typeof(v)
    if t == "Vector3"     then return ("Vector3(%g,%g,%g)"):format(v.X,v.Y,v.Z) end
    if t == "CFrame"      then return ("CFrame(%g,%g,%g)"):format(v.X,v.Y,v.Z) end
    if t == "Color3"      then return ("Color3(%g,%g,%g)"):format(v.R,v.G,v.B) end
    if t == "UDim2"       then return ("UDim2(%g,%g,%g,%g)"):format(v.X.Scale,v.X.Offset,v.Y.Scale,v.Y.Offset) end
    if t == "Enum"        then return tostring(v) end
    if t == "EnumItem"    then return tostring(v) end
    if t == "Instance"    then return "[Instance:" .. v.ClassName .. ":" .. v.Name .. "]" end
    if t == "boolean"     then return v and "true" or "false" end
    if t == "nil"         then return "nil" end
    return tostring(v)
end

-- Recursive tree builder
local function buildTree(instance, depth, maxDepth)
    depth = depth or 0
    maxDepth = maxDepth or 30
    if depth > maxDepth then return "  [MAX DEPTH]\n" end
    local indent = string.rep("  ", depth)
    local out = indent .. "[" .. instance.ClassName .. "] " .. instance.Name .. "\n"

    -- Propiedades comunes seguras
    local SAFE_PROPS = {
        "Position","Size","CFrame","Color","Transparency","Visible",
        "Enabled","Value","Text","MaxPlayers","PlaceId","GameId",
        "BrickColor","Material","Anchored","CanCollide",
        "Archivable","Parent","Name","ClassName"
    }
    for _, prop in ipairs(SAFE_PROPS) do
        local v = safe(function() return instance[prop] end)
        if v ~= nil then
            out = out .. indent .. "  ." .. prop .. " = " .. propToStr(v) .. "\n"
        end
    end

    for _, child in ipairs(instance:GetChildren()) do
        out = out .. buildTree(child, depth+1, maxDepth)
    end
    return out
end

-- Flat scan: collect all instances of a given class recursively
local function collectClass(root, className)
    local found = {}
    for _, obj in ipairs(root:GetDescendants()) do
        if obj:IsA(className) then
            table.insert(found, obj)
        end
    end
    return found
end

local TOTAL = { files=0, remotes=0, scripts=0, bindables=0, modules=0 }

-- ════════════════════════════════════════════════
--  1. METADATA DEL JUEGO
-- ════════════════════════════════════════════════
local meta = {}
table.insert(meta, "=== AR-AI | GAME METADATA ===\n")
table.insert(meta, "Session:        " .. SESSION .. "\n")
table.insert(meta, "Game Name:      " .. tostring(game.Name) .. "\n")
table.insert(meta, "Game ID:        " .. tostring(game.GameId) .. "\n")
table.insert(meta, "Place ID:       " .. tostring(game.PlaceId) .. "\n")
table.insert(meta, "Place Version:  " .. tostring(game.PlaceVersion) .. "\n")
table.insert(meta, "Creator:        " .. tostring(safe(function() return game.CreatorId end)) .. "\n")
table.insert(meta, "Creator Type:   " .. tostring(safe(function() return game.CreatorType end)) .. "\n")
table.insert(meta, "Job ID:         " .. tostring(game.JobId) .. "\n")
table.insert(meta, "Workspace Grav: " .. tostring(workspace.Gravity) .. "\n")
table.insert(meta, "Workspace Name: " .. tostring(workspace.Name) .. "\n")
table.insert(meta, "Players online: " .. tostring(#game:GetService("Players"):GetPlayers()) .. "\n")
table.insert(meta, "Lighting:       FogEnd=" .. tostring(safe(function() return game:GetService("Lighting").FogEnd end)) .. "\n")

wf(PATHS.ROOT .. "/00_metadata.txt", table.concat(meta))
TOTAL.files += 1
print("[+] metadata.txt")

-- ════════════════════════════════════════════════
--  2. REMOTE EVENTS & REMOTE FUNCTIONS
--     (el corazón del dump para exploits)
-- ════════════════════════════════════════════════
local remoteOut = {"=== AR-AI | REMOTES DUMP ===\n\n"}
local remoteCSV = {"path,class,name,parent\n"}
local remoteCount = 0

local function scanRemotes(root, rootName)
    for _, obj in ipairs(root:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or
           obj:IsA("UnreliableRemoteEvent") then
            remoteCount += 1
            local path = ""
            local cur = obj
            local parts = {}
            while cur and cur ~= game do
                table.insert(parts, 1, cur.Name)
                cur = cur.Parent
            end
            path = table.concat(parts, ".")
            table.insert(remoteOut,
                string.format("[%d] %s\n  Class:  %s\n  Path:   %s\n  Parent: %s\n\n",
                remoteCount, obj.Name, obj.ClassName, path,
                obj.Parent and obj.Parent.Name or "nil"))
            table.insert(remoteCSV,
                string.format('"%s","%s","%s","%s"\n',
                path, obj.ClassName, obj.Name,
                obj.Parent and obj.Parent.Name or ""))
        end
    end
end

scanRemotes(game, "game")
table.insert(remoteOut, 1, "Total Remotes: " .. remoteCount .. "\n\n")
wf(PATHS.REMOTES .. "/remotes_list.txt", table.concat(remoteOut))
wf(PATHS.REMOTES .. "/remotes.csv", table.concat(remoteCSV))
TOTAL.remotes = remoteCount
TOTAL.files += 2
print("[+] Remotes: " .. remoteCount)

-- ════════════════════════════════════════════════
--  3. SCRIPTS / LOCALSCRIPTS / MODULESCRIPTS
-- ════════════════════════════════════════════════
local scriptOut = {"=== AR-AI | SCRIPTS DUMP ===\n\n"}
local scriptCount = 0

for _, obj in ipairs(game:GetDescendants()) do
    if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
        scriptCount += 1
        local path = {}
        local cur = obj
        while cur and cur ~= game do table.insert(path,1,cur.Name); cur=cur.Parent end

        local info = string.format(
            "[%d] %s\n  Class:   %s\n  Path:    %s\n  Enabled: %s\n  RunCtx:  %s\n\n",
            scriptCount, obj.Name, obj.ClassName,
            table.concat(path, "."),
            tostring(safe(function() return obj.Enabled end) or "N/A"),
            tostring(safe(function() return obj.RunContext end) or "N/A")
        )
        table.insert(scriptOut, info)

        -- Intentar leer source (funciona en algunos executors)
        local src = safe(function() return obj.Source end)
        if src and #src > 0 then
            local safeName = obj.Name:gsub("[^%w_%-]","_")
            wf(PATHS.SCRIPTS .. "/" .. scriptCount .. "_" .. safeName .. "_source.lua", src)
            TOTAL.files += 1
            TOTAL.modules += 1
        end
    end
end

table.insert(scriptOut, 1, "Total Scripts: " .. scriptCount .. "\n\n")
wf(PATHS.SCRIPTS .. "/scripts_index.txt", table.concat(scriptOut))
TOTAL.files += 1
print("[+] Scripts: " .. scriptCount)

-- ════════════════════════════════════════════════
--  4. TODOS LOS SERVICES
-- ════════════════════════════════════════════════
local SERVICE_LIST = {
    "Workspace","Players","Lighting","ReplicatedStorage","ReplicatedFirst",
    "ServerStorage","ServerScriptService","StarterGui","StarterPack",
    "StarterPlayer","Teams","SoundService","Chat","LocalizationService",
    "TestService","TextChatService","VoiceChatService","AssetService",
    "BadgeService","DataStoreService","GroupService","HttpService",
    "InsertService","LogService","MarketplaceService","MemoryStoreService",
    "MessagingService","PathfindingService","PhysicsService","PolicyService",
    "RunService","ScriptContext","Selection","TeleportService",
    "TweenService","UserInputService","UserService","VirtualInputManager",
    "AnimationClipProvider","CollectionService","ContentProvider",
    "ContextActionService","ControllerService","CoreGui",
    "GamePassService","GuiService","HapticService","KeyboardService",
    "LocalizationService","NetworkSettings","NotificationService",
    "TouchInputService","VRService",
}

local svcOut = {"=== AR-AI | SERVICES DUMP ===\n\n"}

for _, name in ipairs(SERVICE_LIST) do
    local svc = safe(function() return game:GetService(name) end)
    if svc then
        local children = safe(function() return #svc:GetChildren() end) or 0
        local desc     = safe(function() return #svc:GetDescendants() end) or 0
        table.insert(svcOut,
            string.format("[SERVICE] %s\n  Children:    %d\n  Descendants: %d\n\n",
            name, children, desc))

        -- Dump detallado por servicio si tiene hijos
        if children > 0 then
            local detailPath = PATHS.SERVICES .. "/" .. name .. "_tree.txt"
            wf(detailPath, buildTree(svc, 0, 10))
            TOTAL.files += 1
        end
    else
        table.insert(svcOut, "[SERVICE] " .. name .. " — NOT ACCESSIBLE\n\n")
    end
end

wf(PATHS.SERVICES .. "/services_overview.txt", table.concat(svcOut))
TOTAL.files += 1
print("[+] Services dumped")

-- ════════════════════════════════════════════════
--  5. REPLICATED STORAGE — FULL TREE
-- ════════════════════════════════════════════════
local rs = safe(function() return game:GetService("ReplicatedStorage") end)
if rs then
    wf(PATHS.REPLICATED .. "/full_tree.txt", buildTree(rs, 0, 20))

    -- Valores especiales en RS
    local vals = {"StringValue","NumberValue","IntValue","BoolValue","ObjectValue","Vector3Value"}
    local valOut = {"=== Values in ReplicatedStorage ===\n\n"}
    for _, vclass in ipairs(vals) do
        for _, obj in ipairs(rs:GetDescendants()) do
            if obj:IsA(vclass) then
                local v = safe(function() return obj.Value end)
                table.insert(valOut, obj.ClassName .. " | " .. obj.Name ..
                    " = " .. propToStr(v) .. "\n")
            end
        end
    end
    wf(PATHS.REPLICATED .. "/values.txt", table.concat(valOut))
    TOTAL.files += 2
    print("[+] ReplicatedStorage dumped")
end

-- ════════════════════════════════════════════════
--  6. WORKSPACE — FULL HIERARCHY
-- ════════════════════════════════════════════════
wf(PATHS.WORKSPACE .. "/workspace_tree.txt", buildTree(workspace, 0, 15))

-- Modelos especiales
local modelOut = {"=== Models/Parts in Workspace ===\n\n"}
local modelCount = 0
for _, obj in ipairs(workspace:GetChildren()) do
    modelCount += 1
    local pos = ""
    local pp = safe(function()
        if obj:IsA("BasePart") then return obj.Position
        elseif obj:IsA("Model") and obj.PrimaryPart then return obj.PrimaryPart.Position
        end
    end)
    if pp then pos = propToStr(pp) end
    table.insert(modelOut,
        string.format("[%d] [%s] %s  pos=%s  children=%d\n",
        modelCount, obj.ClassName, obj.Name, pos, #obj:GetChildren()))
end
wf(PATHS.WORKSPACE .. "/models_list.txt", table.concat(modelOut))
TOTAL.files += 2
print("[+] Workspace dumped (" .. modelCount .. " root objects)")

-- ════════════════════════════════════════════════
--  7. PLAYERS
-- ════════════════════════════════════════════════
local plrs = game:GetService("Players")
local plrOut = {"=== AR-AI | PLAYERS DUMP ===\n\n"}
table.insert(plrOut, "MaxPlayers: " .. tostring(plrs.MaxPlayers) .. "\n")
table.insert(plrOut, "RespawnTime: " .. tostring(plrs.RespawnTime) .. "\n\n")

for _, p in ipairs(plrs:GetPlayers()) do
    table.insert(plrOut, string.format(
        "PLAYER: %s\n  UserId:    %d\n  AccountAge: %d\n  Team:      %s\n  Character: %s\n",
        p.Name, p.UserId, p.AccountAge,
        tostring(p.Team and p.Team.Name or "None"),
        tostring(p.Character and "YES" or "NO")))

    -- Leaderstats
    local ls = p:FindFirstChild("leaderstats")
    if ls then
        table.insert(plrOut, "  leaderstats:\n")
        for _, v in ipairs(ls:GetChildren()) do
            local val = safe(function() return v.Value end)
            table.insert(plrOut, "    " .. v.Name .. " = " .. propToStr(val) .. "\n")
        end
    end

    -- PlayerGui
    local pg = p:FindFirstChildWhichIsA("PlayerGui")
    if pg then
        table.insert(plrOut, "  PlayerGui children: " .. #pg:GetChildren() .. "\n")
        for _, gui in ipairs(pg:GetChildren()) do
            table.insert(plrOut, "    [" .. gui.ClassName .. "] " .. gui.Name .. "\n")
        end
        wf(PATHS.GUI .. "/" .. p.Name .. "_gui_tree.txt", buildTree(pg, 0, 8))
        TOTAL.files += 1
    end

    -- Backpack
    local bp = p:FindFirstChildWhichIsA("Backpack")
    if bp then
        table.insert(plrOut, "  Backpack items: " .. #bp:GetChildren() .. "\n")
        for _, tool in ipairs(bp:GetChildren()) do
            table.insert(plrOut, "    [Tool] " .. tool.Name .. "\n")
        end
    end
    table.insert(plrOut, "\n")
end

wf(PATHS.PLAYERS .. "/players.txt", table.concat(plrOut))
TOTAL.files += 1
print("[+] Players dumped")

-- ════════════════════════════════════════════════
--  8. BINDABLE EVENTS & FUNCTIONS
-- ════════════════════════════════════════════════
local bindOut = {"=== AR-AI | BINDABLES ===\n\n"}
local bindCount = 0

for _, obj in ipairs(game:GetDescendants()) do
    if obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then
        bindCount += 1
        local path = {}
        local cur = obj
        while cur and cur ~= game do table.insert(path,1,cur.Name); cur=cur.Parent end
        table.insert(bindOut,
            string.format("[%d] [%s] %s\n  Path: %s\n\n",
            bindCount, obj.ClassName, obj.Name, table.concat(path,".")))
    end
end

table.insert(bindOut, 1, "Total Bindables: " .. bindCount .. "\n\n")
wf(PATHS.BINDABLES .. "/bindables.txt", table.concat(bindOut))
TOTAL.bindables = bindCount
TOTAL.files += 1
print("[+] Bindables: " .. bindCount)

-- ════════════════════════════════════════════════
--  9. SOUNDS
-- ════════════════════════════════════════════════
local sndOut = {"=== AR-AI | SOUNDS ===\n\n"}
local sndCount = 0

for _, obj in ipairs(game:GetDescendants()) do
    if obj:IsA("Sound") then
        sndCount += 1
        table.insert(sndOut,
            string.format("[%d] %s\n  SoundId:  %s\n  Volume:   %g\n  Looped:   %s\n  Playing:  %s\n\n",
            sndCount, obj.Name,
            tostring(obj.SoundId),
            obj.Volume,
            tostring(obj.Looped),
            tostring(obj.Playing)))
    end
end

table.insert(sndOut, 1, "Total Sounds: " .. sndCount .. "\n\n")
wf(PATHS.SOUNDS .. "/sounds.txt", table.concat(sndOut))
TOTAL.files += 1
print("[+] Sounds: " .. sndCount)

-- ════════════════════════════════════════════════
--  10. ANIMATIONS
-- ════════════════════════════════════════════════
local animOut = {"=== AR-AI | ANIMATIONS ===\n\n"}
local animCount = 0

for _, obj in ipairs(game:GetDescendants()) do
    if obj:IsA("Animation") or obj:IsA("AnimationTrack") then
        animCount += 1
        local animId = safe(function() return obj.AnimationId end) or "N/A"
        table.insert(animOut,
            string.format("[%d] [%s] %s  Id: %s\n", animCount, obj.ClassName, obj.Name, animId))
    end
end

table.insert(animOut, 1, "Total Animations: " .. animCount .. "\n\n")
wf(PATHS.MISC .. "/animations.txt", table.concat(animOut))
TOTAL.files += 1

-- ════════════════════════════════════════════════
--  11. COLECCIONES (CollectionService tags)
-- ════════════════════════════════════════════════
local cs = safe(function() return game:GetService("CollectionService") end)
if cs then
    local tagOut = {"=== AR-AI | COLLECTION SERVICE TAGS ===\n\n"}
    local allTags = safe(function() return cs:GetAllTags() end) or {}
    table.insert(tagOut, "Total Tags: " .. #allTags .. "\n\n")
    for _, tag in ipairs(allTags) do
        local tagged = safe(function() return cs:GetTagged(tag) end) or {}
        table.insert(tagOut, string.format(
            "TAG: %s  (%d objects)\n", tag, #tagged))
        for i, obj in ipairs(tagged) do
            if i > 20 then table.insert(tagOut, "  ... and more\n"); break end
            table.insert(tagOut, "  · [" .. obj.ClassName .. "] " .. obj.Name .. "\n")
        end
        table.insert(tagOut, "\n")
    end
    wf(PATHS.MISC .. "/collection_tags.txt", table.concat(tagOut))
    TOTAL.files += 1
    print("[+] CollectionService tags: " .. #allTags)
end

-- ════════════════════════════════════════════════
--  12. TWEENS / PHYSICS / CONSTRAINTS
-- ════════════════════════════════════════════════
local physOut = {"=== AR-AI | PHYSICS & CONSTRAINTS ===\n\n"}
local constraintClasses = {
    "HingeConstraint","BallSocketConstraint","RodConstraint",
    "RopeConstraint","SpringConstraint","WeldConstraint",
    "Motor6D","Weld","Glue","Snap","SurfaceJoint",
    "BodyVelocity","BodyPosition","BodyAngularVelocity",
    "BodyGyro","BodyForce","BodyThrust","VectorForce",
    "LinearVelocity","AngularVelocity","Torque","AlignPosition","AlignOrientation"
}

for _, cls in ipairs(constraintClasses) do
    local found = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA(cls) then table.insert(found, obj) end
    end
    if #found > 0 then
        table.insert(physOut, cls .. ": " .. #found .. " instances\n")
    end
end

wf(PATHS.MISC .. "/constraints.txt", table.concat(physOut))
TOTAL.files += 1

-- ════════════════════════════════════════════════
--  13. NETWORK OWNERSHIP & STREAMING
-- ════════════════════════════════════════════════
local netOut = {"=== AR-AI | NETWORK / STREAMING ===\n\n"}
local ws = workspace

netOut[#netOut+1] = "StreamingEnabled:  " .. tostring(safe(function() return ws.StreamingEnabled end)) .. "\n"
netOut[#netOut+1] = "StreamingRadius:   " .. tostring(safe(function() return ws.StreamingMinRadius end)) .. "\n"
netOut[#netOut+1] = "Gravity:           " .. tostring(safe(function() return ws.Gravity end)) .. "\n"
netOut[#netOut+1] = "AirDensity:        " .. tostring(safe(function() return ws.AirDensity end)) .. "\n"

-- Parts con NetworkOwnership explícita
local netCount = 0
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") then
        local owner = safe(function() return obj:GetNetworkOwner() end)
        if owner then
            netCount += 1
            netOut[#netOut+1] = obj.Name .. " owned by: " .. tostring(owner.Name) .. "\n"
            if netCount > 100 then netOut[#netOut+1] = "... (truncated)\n"; break end
        end
    end
end

wf(PATHS.MISC .. "/network.txt", table.concat(netOut))
TOTAL.files += 1

-- ════════════════════════════════════════════════
--  14. HTTP SERVICE (endpoints visibles)
-- ════════════════════════════════════════════════
local hs = safe(function() return game:GetService("HttpService") end)
if hs then
    local httpOut = {"=== AR-AI | HTTP SERVICE ===\n\n"}
    httpOut[#httpOut+1] = "HttpEnabled: " .. tostring(safe(function() return hs.HttpEnabled end)) .. "\n\n"
    httpOut[#httpOut+1] = "-- Para usar desde exploit:\n"
    httpOut[#httpOut+1] = "-- game:GetService('HttpService'):GetAsync(url)\n"
    httpOut[#httpOut+1] = "-- game:GetService('HttpService'):PostAsync(url, data)\n"
    wf(PATHS.MISC .. "/http_service.txt", table.concat(httpOut))
    TOTAL.files += 1
end

-- ════════════════════════════════════════════════
--  15. MÓDULOS ESPECIALES DEL JUEGO
-- ════════════════════════════════════════════════
local modCount = 0
for _, obj in ipairs(game:GetDescendants()) do
    if obj:IsA("ModuleScript") then
        modCount += 1
        local safeName = (obj.Name:gsub("[^%w_%-]","_")):sub(1,40)

        -- Info básica
        local mpath = {}
        local cur = obj
        while cur and cur ~= game do table.insert(mpath,1,cur.Name); cur=cur.Parent end

        local info = "-- Module: " .. obj.Name .. "\n"
                  .. "-- Path:   " .. table.concat(mpath,".") .. "\n"
                  .. "-- Parent: " .. (obj.Parent and obj.Parent.Name or "nil") .. "\n\n"

        -- Intentar require (riesgoso pero informativo)
        local src = safe(function() return obj.Source end)
        if src and #src > 0 then
            wf(PATHS.MODULES .. "/" .. modCount .. "_" .. safeName .. ".lua", info .. src)
            TOTAL.files += 1
        else
            wf(PATHS.MODULES .. "/" .. modCount .. "_" .. safeName .. "_meta.txt", info .. "[Source not accessible]\n")
            TOTAL.files += 1
        end
    end
end
print("[+] Modules: " .. modCount)

-- ════════════════════════════════════════════════
--  SUMMARY FILE
-- ════════════════════════════════════════════════
local summary = {
    "╔═══════════════════════════════════════╗\n",
    "║     AR-AI | FULL GAME DUMP SUMMARY    ║\n",
    "╚═══════════════════════════════════════╝\n\n",
    "Game:        " .. game.Name .. "\n",
    "Game ID:     " .. tostring(game.GameId) .. "\n",
    "Place ID:    " .. tostring(game.PlaceId) .. "\n",
    "Session:     " .. SESSION .. "\n\n",
    "─────────────────────────────────────────\n",
    " Remotes     (Events/Functions):  " .. TOTAL.remotes .. "\n",
    " Scripts     (all types):         " .. scriptCount .. "\n",
    " Modules     (dumped source):     " .. modCount .. "\n",
    " Bindables   (Event/Function):    " .. TOTAL.bindables .. "\n",
    " Sounds:                          " .. sndCount .. "\n",
    " Animations:                      " .. animCount .. "\n",
    " Models in workspace:             " .. modelCount .. "\n",
    " Total files written:             " .. TOTAL.files .. "\n",
    "─────────────────────────────────────────\n\n",
    "STRUCTURE:\n",
    "workspace/" .. BASE .. "/\n",
    "  00_metadata.txt\n",
    "  SUMMARY.txt\n",
    "  Remotes/        ← remotes_list.txt, remotes.csv\n",
    "  Scripts/        ← index + source files\n",
    "  Services/       ← per-service trees\n",
    "  Workspace/      ← full workspace tree\n",
    "  ReplicatedStorage/\n",
    "  Players/\n",
    "  GUI/\n",
    "  Modules/        ← ModuleScript sources\n",
    "  Bindables/\n",
    "  Sounds/\n",
    "  Misc/           ← physics, network, http, tags\n",
}
wf(PATHS.ROOT .. "/SUMMARY.txt", table.concat(summary))

-- ════════════════════════════════════════════════
--  ZIP — intenta crearlo si el executor lo soporta
-- ════════════════════════════════════════════════
print("\n[AR-AI] Intentando crear ZIP...")

local zipSuccess = false

-- Método 1: zip() nativo (algunos executors)
if zip then
    local ok = pcall(function()
        zip(BASE, BASE .. ".zip")
    end)
    if ok then
        zipSuccess = true
        print("[AR-AI] ✅ ZIP creado: workspace/" .. BASE .. ".zip")
    end
end

-- Método 2: zipfolder / createZip (variantes)
if not zipSuccess then
    for _, fn in ipairs({"zipfolder","createzip","createZip","ZipFolder"}) do
        if _G[fn] or getgenv()[fn] then
            local f = _G[fn] or getgenv()[fn]
            local ok = pcall(f, BASE, BASE .. ".zip")
            if ok then zipSuccess=true; break end
        end
    end
end

if not zipSuccess then
    print("[AR-AI] ℹ️  ZIP nativo no disponible en este executor")
    print("[AR-AI] Todos los archivos están en: workspace/" .. BASE .. "/")
    print("[AR-AI] Puedes zipearlos manualmente desde el explorador de archivos")
end

-- ════════════════════════════════════════════════
--  DONE
-- ════════════════════════════════════════════════
print("\n╔══════════════════════════════════════╗")
print("║  AR-AI DUMP COMPLETADO               ║")
print("╠══════════════════════════════════════╣")
print("║  Remotes:    " .. string.format("%-26d", TOTAL.remotes) .. "║")
print("║  Scripts:    " .. string.format("%-26d", scriptCount) .. "║")
print("║  Modules:    " .. string.format("%-26d", modCount) .. "║")
print("║  Files:      " .. string.format("%-26d", TOTAL.files) .. "║")
print("╠══════════════════════════════════════╣")
print("║  Output: workspace/" .. BASE:sub(1,18) .. " ║")
print("╚══════════════════════════════════════╝")