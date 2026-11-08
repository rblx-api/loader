--[[
    Timebomb Duels - Panel Client-side v4 (adaptado a las arenas: cerradas, con barreras bajas, torre central y plataformas)
    Botones:
      HUIR     -> huye de TODOS los jugadores cercanos (Pathfinding)
      ATACAR   -> persigue al que tiene la bomba (si nadie la tiene, al más cercano)
      AI PLAY  -> modo automático: persigue al portador de la bomba y, en cuanto
                  la suelta/pasa, huye de todos los cercanos; luego vuelve a perseguir
    Los 3 modos son exclusivos: al activar uno se apaga el otro.
    Ajusta CONFIG.BOMB_KEYWORDS si la bomba se llama distinto en el juego.
]]

-- ========== SERVICIOS ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Si ya estaba cargado, lo cierra para no duplicar
if _G.__TimebombAutoTrack then
    pcall(_G.__TimebombAutoTrack)
end

-- ========== CONFIGURACIÓN ==========
local CONFIG = {
    BOMB_KEYWORDS = { "bomb", "bomba", "timebomb" }, -- nombres de la tool (minúsculas)

    FLEE_RADIUS = 100,      -- huye de jugadores a menos de esta distancia (studs)
    FLEE_DISTANCE = 70,     -- cuánto intenta alejarse (studs)
    FLEE_MIN_TIME = 1.5,    -- (AI) tiempo mínimo huyendo antes de volver a atacar
    AI_PASS_BOMB = true,    -- (AI) si TÚ tienes la bomba, persigue al más cercano

    CHASE_REPATH = 0.35,    -- recálculo de ruta al perseguir (seg)
    FLEE_REPATH = 0.5,      -- recálculo de ruta al huir (seg)
    LIVE_CHASE_DISTANCE = 12, -- a menos de esto persigue "en vivo" (sin pararse)
    SAFE_DISTANCE = 30,     -- si el enemigo más cercano está más lejos, te quedas quieto
    INCLUDE_NPCS = true,    -- también cuenta a los bots (Bot fácil / Bot difícil)
    IGNORE_GHOSTS = true,   -- ignora personajes translúcidos (espectadores/fantasmas)
    ANY_TOOL_IS_BOMB = false, -- true = cualquier Tool equipada cuenta como bomba
    ENEMY_MAX_DISTANCE = 120, -- al atacar sin portador, ignora jugadores más lejos (lobby)
    MIN_GAIN = 10,          -- si moverte no mejora al menos esto, te quedas quieto
    FLEE_COMMIT_TIME = 3,   -- mantiene el destino de huida este tiempo (evita zigzag)
    WAYPOINT_REACH = 3.5,   -- distancia para dar un waypoint por alcanzado
    DIRECT_RAY_RANGE = 40,  -- con línea de vista libre a menos de esto, va directo
    STOP_DISTANCE = 3,
    STUCK_TIME = 1.0,       -- segundos quieto = atasco

    AGENT = {
        AgentRadius = 1.8,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentCanClimb = true,
        WaypointSpacing = 4,
    },
}

-- ========== ESTADO ==========
local State = {
    mode = "OFF",        -- "OFF" | "FLEE" | "ATTACK" | "AI"
    aiSub = "IDLE",      -- sub-estado de AI: "IDLE" | "CHASE" | "FLEE"
    target = nil,
    targetIsHolder = false,
    fleeSince = 0,
    waypoints = {},
    index = 1,
    lastRepath = 0,
    lastPos = nil,
    lastMoveCheck = 0,
    forceRepath = false,
    chasing = false,     -- true mientras hay que perseguir a State.target
    chaseLive = false,   -- true = ir directo a la posición ACTUAL del objetivo
    fleeGoal = nil,      -- destino de huida actual
    fleeGoalTime = 0,
    info = "",           -- texto extra para la GUI
}

local connections = {}

-- ========== UTILIDADES ==========
-- Acepta un Player (usa .Character) o directamente un Model (bots/NPC)
local function getCharacter(p)
    if not p then return nil end
    if typeof(p) == "Instance" and p:IsA("Model") then return p end
    return p.Character
end
local function getRoot(p)
    local c = getCharacter(p)
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHumanoid(p)
    local c = getCharacter(p)
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function isAlive(p)
    local h = getHumanoid(p)
    return h ~= nil and h.Health > 0 and getRoot(p) ~= nil
end

local function nameIsBomb(name)
    name = string.lower(name)
    for _, k in ipairs(CONFIG.BOMB_KEYWORDS) do
        if string.find(name, k, 1, true) then return true end
    end
    return false
end

-- ¿Tiene la bomba equipada? (hijo del Character)
local function hasBomb(player)
    local char = getCharacter(player)
    if not char then return false end
    for _, child in ipairs(char:GetChildren()) do
        if (child:IsA("Tool") or child:IsA("Model") or child:IsA("Accessory"))
            and nameIsBomb(child.Name) then
            return true
        end
        if CONFIG.ANY_TOOL_IS_BOMB and child:IsA("Tool") then
            return true
        end
    end
    return false
end

-- ¿Personaje translúcido (fantasma/espectador)? Se mira la cabeza,
-- porque el HumanoidRootPart suele ser invisible siempre.
local function isGhost(e)
    if not CONFIG.IGNORE_GHOSTS then return false end
    local char = getCharacter(e)
    local head = char and char:FindFirstChild("Head")
    return head ~= nil and head:IsA("BasePart") and head.Transparency >= 0.5
end

-- Caché de bots (Models con Humanoid que no son jugadores), se refresca cada 3 s
local npcCache, npcCacheTime = {}, 0
local function refreshNpcs()
    if os.clock() - npcCacheTime < 3 then return end
    npcCacheTime = os.clock()
    local playerChars = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then playerChars[p.Character] = true end
    end
    local list = {}
    for _, inst in ipairs(Workspace:GetDescendants()) do
        if inst:IsA("Humanoid") then
            local m = inst.Parent
            if m and m:IsA("Model") and not playerChars[m]
                and m:FindFirstChild("HumanoidRootPart") then
                table.insert(list, m)
            end
        end
    end
    npcCache = list
end

-- Lista de enemigos vivos: jugadores (menos yo) + bots
local function listEnemies()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isAlive(plr) and not isGhost(plr) then
            table.insert(list, plr)
        end
    end
    if CONFIG.INCLUDE_NPCS then
        refreshNpcs()
        for _, m in ipairs(npcCache) do
            if m.Parent and isAlive(m) and not isGhost(m) then
                table.insert(list, m)
            end
        end
    end
    return list
end

local function findBombHolder()
    for _, e in ipairs(listEnemies()) do
        if hasBomb(e) then return e end
    end
    return nil
end

local function findNearestEnemy()
    local myRoot = getRoot(LocalPlayer)
    if not myRoot then return nil end
    local best, bestDist = nil, CONFIG.ENEMY_MAX_DISTANCE
    for _, e in ipairs(listEnemies()) do
        local d = (getRoot(e).Position - myRoot.Position).Magnitude
        if d < bestDist then best, bestDist = e, d end
    end
    return best
end

-- Enemigos vivos dentro del radio de huida
local function getNearbyEnemies()
    local myRoot = getRoot(LocalPlayer)
    local list = {}
    if not myRoot then return list end
    for _, e in ipairs(listEnemies()) do
        if (getRoot(e).Position - myRoot.Position).Magnitude <= CONFIG.FLEE_RADIUS then
            table.insert(list, e)
        end
    end
    return list
end

local function hasClearLine(from, to, ignoreList)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = ignoreList
    return Workspace:Raycast(from, to - from, params) == nil
end

local function computePath(fromPos, toPos)
    local path = PathfindingService:CreatePath(CONFIG.AGENT)
    local ok = pcall(function() path:ComputeAsync(fromPos, toPos) end)
    if ok and path.Status == Enum.PathStatus.Success then
        return path:GetWaypoints()
    end
    return nil
end

local function clearPath()
    State.waypoints = {}
    State.index = 1
end

local function stopMoving()
    clearPath()
    local hum, root = getHumanoid(LocalPlayer), getRoot(LocalPlayer)
    if hum and root then hum:MoveTo(root.Position) end
end

local function directGoal(pos)
    State.waypoints = { { Position = pos, Action = Enum.PathWaypointAction.Walk } }
    State.index = 1
end

-- ========== PERSECUCIÓN ==========
-- Si está cerca o hay línea de vista -> modo "en vivo": cada frame se mueve
-- hacia la posición ACTUAL del objetivo (nunca se queda parado).
-- Si hay muros -> Pathfinding.
local function updateChasePath()
    local myRoot = getRoot(LocalPlayer)
    local targetRoot = getRoot(State.target)
    if not (myRoot and targetRoot) then return end

    local dist = (targetRoot.Position - myRoot.Position).Magnitude

    if dist <= CONFIG.LIVE_CHASE_DISTANCE then
        State.chaseLive = true
        return
    end

    if dist <= CONFIG.DIRECT_RAY_RANGE
        and math.abs(targetRoot.Position.Y - myRoot.Position.Y) < 6
        and hasClearLine(myRoot.Position, targetRoot.Position,
            { getCharacter(LocalPlayer), getCharacter(State.target) }) then
        State.chaseLive = true
        return
    end

    State.chaseLive = false
    local wps = computePath(myRoot.Position, targetRoot.Position)
    if wps then
        State.waypoints, State.index = wps, 2
    else
        State.chaseLive = true -- sin ruta: ir directo
    end
end

-- ========== HUIDA (de todos los cercanos) ==========
-- Ajusta el punto al suelo cercano a mi altura (evita techos y zonas fuera del mapa)
local function snapToGround(point, refY)
    local r = Workspace:Raycast(point + Vector3.new(0, 10, 0), Vector3.new(0, -40, 0))
    if r and math.abs(r.Position.Y - refY) <= 12 then
        return r.Position + Vector3.new(0, 2, 0)
    end
    return nil
end

-- Distancia libre hasta la pared en una dirección (rayo por encima de las
-- barreras bajas). Así los destinos de huida siempre caen DENTRO de la arena.
local function wallDistance(origin, dir, maxDist)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { getCharacter(LocalPlayer) }
    local res = Workspace:Raycast(origin, dir * maxDist, params)
    if res then return math.max(res.Distance - 4, 0) end
    return maxDist
end

-- Distancia mínima de un punto al enemigo más cercano
local function minDistToEnemies(point, enemies)
    local m = math.huge
    for _, e in ipairs(enemies) do
        local r = getRoot(e)
        if r then m = math.min(m, (point - r.Position).Magnitude) end
    end
    return m
end

-- ¿La ruta pasa pegada a algún enemigo?
local function pathNearEnemies(wps, enemies)
    for _, wp in ipairs(wps) do
        if minDistToEnemies(wp.Position, enemies) < 8 then return true end
    end
    return false
end

local function updateFleePath(enemies)
    local myRoot = getRoot(LocalPlayer)
    if not myRoot or #enemies == 0 then return end

    local myPos = myRoot.Position
    local curMin = minDistToEnemies(myPos, enemies)
    local now = os.clock()

    -- 1) Ya estoy lejos de todos: me quedo quieto (no hace falta moverse)
    if curMin >= CONFIG.SAFE_DISTANCE then
        State.fleeGoal = nil
        stopMoving()
        State.info = "a salvo (quieto)"
        return
    end

    -- 2) El destino anterior sigue siendo bueno: lo mantengo (evita zigzag)
    if State.fleeGoal and State.waypoints[State.index]
        and now - State.fleeGoalTime < CONFIG.FLEE_COMMIT_TIME
        and minDistToEnemies(State.fleeGoal, enemies) > curMin + 5 then
        return
    end

    -- 3) Elegir nuevo destino. Direcciones base: alejarse de todos (suma ponderada)
    local away = Vector3.zero
    for _, e in ipairs(enemies) do
        local r = getRoot(e)
        if r then
            local diff = myPos - r.Position
            diff = Vector3.new(diff.X, 0, diff.Z)
            local d = math.max(diff.Magnitude, 1)
            away += (diff / d) * (1 / d)
        end
    end
    if away.Magnitude < 1e-4 then away = Vector3.new(1, 0, 0) end
    away = away.Unit

    local bestWps, bestScore, bestGoal = nil, -math.huge, nil

    -- 8 direcciones alrededor (así funciona también si hay enemigos en lados opuestos)
    for _, scale in ipairs({ 1, 0.5 }) do
        for i = 0, 7 do
            local dir = CFrame.Angles(0, math.rad(i * 45), 0):VectorToWorldSpace(away)
            local reach = wallDistance(myPos + Vector3.new(0, 3.5, 0), dir, CONFIG.FLEE_DISTANCE)
            local candidate = reach >= 8 and snapToGround(myPos + dir * reach * scale, myPos.Y) or nil
            local wps = candidate and computePath(myPos, candidate)
            if wps and not pathNearEnemies(wps, enemies) then
                local score = minDistToEnemies(candidate, enemies)
                if score > bestScore then
                    bestScore, bestWps, bestGoal = score, wps, candidate
                end
            end
        end
        if bestWps then break end
    end

    if bestWps then
        if bestScore >= curMin + CONFIG.MIN_GAIN then
            State.waypoints, State.index = bestWps, 2
            State.fleeGoal, State.fleeGoalTime = bestGoal, now
            State.info = "huyendo"
        else
            -- Moverse no mejora nada (p. ej. enemigos por todos lados): quieto
            State.fleeGoal = nil
            stopMoving()
            State.info = "sin salida mejor (quieto)"
        end
    else
        -- Sin ruta calculable: correr en línea recta alejándose
        State.fleeGoal, State.fleeGoalTime = myPos + away * 30, now
        directGoal(State.fleeGoal)
    end
end

-- ========== MODOS ==========
local function repathDue(interval)
    local now = os.clock()
    if State.forceRepath or now - State.lastRepath >= interval then
        State.lastRepath = now
        State.forceRepath = false
        return true
    end
    return false
end

-- Modo HUIR (manual)
local function doFlee()
    local enemies = getNearbyEnemies()
    if #enemies == 0 then
        State.info = "nadie cerca"
        State.fleeGoal = nil
        if #State.waypoints > 0 then stopMoving() end
        return
    end
    State.info = #enemies .. " cerca"
    if repathDue(CONFIG.FLEE_REPATH) then updateFleePath(enemies) end
end

-- Modo ATACAR (manual)
local function doAttack()
    local holder = findBombHolder()
    State.target = holder or findNearestEnemy()
    if not State.target then
        State.info = "sin objetivo"
        if #State.waypoints > 0 then stopMoving() end
        return
    end
    State.info = State.target.Name
    State.chasing = true
    if repathDue(CONFIG.CHASE_REPATH) then updateChasePath() end
end

-- Modo AI PLAY (automático)
local function doAI()
    local holder = findBombHolder()
    local now = os.clock()

    -- Si perseguía al portador y ya NO tiene la bomba -> HUIDA inmediata
    if State.aiSub == "CHASE" and State.targetIsHolder and State.target then
        if not isAlive(State.target) or not hasBomb(State.target) then
            State.aiSub = "FLEE"
            State.fleeSince = now
            State.fleeGoal = nil
            State.target = nil
            State.lastRepath = 0
            clearPath()
        end
    end

    if State.aiSub == "FLEE" then
        -- Pasado el tiempo mínimo, si hay un portador nuevo, lo perseguimos
        if holder and (now - State.fleeSince) >= CONFIG.FLEE_MIN_TIME then
            State.aiSub, State.target, State.targetIsHolder = "CHASE", holder, true
            State.lastRepath = 0
            clearPath()
        end
    else
        if holder then
            if State.target ~= holder then State.lastRepath = 0 end
            State.aiSub, State.target, State.targetIsHolder = "CHASE", holder, true
        elseif CONFIG.AI_PASS_BOMB and hasBomb(LocalPlayer) then
            -- Yo tengo la bomba: voy a por el más cercano para pasársela
            State.aiSub, State.target, State.targetIsHolder = "CHASE", findNearestEnemy(), false
        else
            State.aiSub, State.target = "IDLE", nil
        end
    end

    if State.aiSub == "CHASE" and State.target then
        State.info = "persigue " .. State.target.Name
        State.chasing = true
        if repathDue(CONFIG.CHASE_REPATH) then updateChasePath() end
    elseif State.aiSub == "FLEE" then
        local enemies = getNearbyEnemies()
        State.info = "huye (" .. #enemies .. ")"
        if #enemies > 0 then
            if repathDue(CONFIG.FLEE_REPATH) then updateFleePath(enemies) end
        elseif #State.waypoints > 0 then
            stopMoving()
        end
    else
        State.info = "esperando bomba"
        if #State.waypoints > 0 then stopMoving() end
    end
end

local function brain()
    State.chasing = false
    if not isAlive(LocalPlayer) then
        clearPath()
        return
    end
    if State.mode == "FLEE" then doFlee()
    elseif State.mode == "ATTACK" then doAttack()
    elseif State.mode == "AI" then doAI() end
end

-- ========== MOVIMIENTO (cada frame) ==========
-- Anti-atasco: si casi no nos movemos, saltamos y recalculamos
-- (se omite cuando estamos pegados al objetivo)
local function checkStuck(hum, root, skip)
    local now = os.clock()
    if now - State.lastMoveCheck >= CONFIG.STUCK_TIME then
        if not skip and State.lastPos and (root.Position - State.lastPos).Magnitude < 1 then
            hum.Jump = true
            State.forceRepath = true
        end
        State.lastPos = root.Position
        State.lastMoveCheck = now
    end
end

-- Salta barreras bajas: obstáculo a la altura de los pies pero libre arriba
local lastJumpCheck = 0
local function jumpIfBlocked(hum, root)
    local now = os.clock()
    if now - lastJumpCheck < 0.1 then return end
    lastJumpCheck = now
    local md = hum.MoveDirection
    if md.Magnitude < 0.1 then return end
    local dir = Vector3.new(md.X, 0, md.Z).Unit * 3.5
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { getCharacter(LocalPlayer) }
    if Workspace:Raycast(root.Position + Vector3.new(0, -1.5, 0), dir, params)
        and not Workspace:Raycast(root.Position + Vector3.new(0, 3.5, 0), dir, params) then
        hum.Jump = true
    end
end

local function stepMovement()
    local hum, root = getHumanoid(LocalPlayer), getRoot(LocalPlayer)
    if not (hum and root) or hum.Health <= 0 then return end

    local wp = State.waypoints[State.index]

    -- PERSECUCIÓN EN VIVO: va siempre hacia donde está el objetivo AHORA
    -- (con un pequeño adelanto según su velocidad). No se frena al llegar.
    if State.chasing and State.target and (State.chaseLive or not wp) then
        local tr = getRoot(State.target)
        if tr then
            local vel = tr.AssemblyLinearVelocity
            hum:MoveTo(tr.Position + Vector3.new(vel.X, 0, vel.Z) * 0.15)
            if tr.Position.Y - root.Position.Y > 4 then hum.Jump = true end
            jumpIfBlocked(hum, root)
            checkStuck(hum, root, (tr.Position - root.Position).Magnitude < 8)
            return
        end
    end

    -- SEGUIR RUTA (waypoints)
    if not wp then return end

    if wp.Action == Enum.PathWaypointAction.Jump then hum.Jump = true end
    hum:MoveTo(wp.Position)
    jumpIfBlocked(hum, root)

    local flat = Vector3.new(wp.Position.X - root.Position.X, 0, wp.Position.Z - root.Position.Z).Magnitude
    if flat < CONFIG.WAYPOINT_REACH and math.abs(wp.Position.Y - root.Position.Y) < 6 then
        State.index += 1
    end

    checkStuck(hum, root, false)
end

-- ========== INTERFAZ ==========
local function getGuiParent()
    local ok, ui = pcall(function()
        return (gethui and gethui()) or game:GetService("CoreGui")
    end)
    if ok and ui then return ui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local gui = Instance.new("ScreenGui")
gui.Name = "TimebombPanelGui"
gui.ResetOnSpawn = false
if not pcall(function() gui.Parent = getGuiParent() end) then
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 170)
frame.Position = UDim2.new(0, 20, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 24)
title.BackgroundTransparency = 1
title.Text = "Timebomb Panel"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

local COLOR_OFF = Color3.fromRGB(60, 60, 70)
local COLOR_ON = Color3.fromRGB(50, 160, 70)

local function makeButton(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 30)
    b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = COLOR_OFF
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local btnFlee = makeButton("HUIR", 28)
local btnAttack = makeButton("ATACAR", 62)
local btnAI = makeButton("AI PLAY", 96)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 36)
statusLabel.Position = UDim2.new(0, 5, 0, 130)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Estado: apagado"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextWrapped = true
statusLabel.Parent = frame

local function refreshGui()
    btnFlee.BackgroundColor3 = State.mode == "FLEE" and COLOR_ON or COLOR_OFF
    btnAttack.BackgroundColor3 = State.mode == "ATTACK" and COLOR_ON or COLOR_OFF
    btnAI.BackgroundColor3 = State.mode == "AI" and COLOR_ON or COLOR_OFF
    if State.mode == "OFF" then statusLabel.Text = "Estado: apagado" end
end

-- Activa un modo; si ya estaba activo, lo apaga
local function setMode(mode)
    if State.mode == mode then mode = "OFF" end
    State.mode = mode
    State.aiSub = "IDLE"
    State.target = nil
    State.targetIsHolder = false
    State.lastRepath = 0
    State.chasing = false
    State.fleeGoal = nil
    stopMoving()
    refreshGui()
end

btnFlee.MouseButton1Click:Connect(function() setMode("FLEE") end)
btnAttack.MouseButton1Click:Connect(function() setMode("ATTACK") end)
btnAI.MouseButton1Click:Connect(function() setMode("AI") end)

-- ========== BUCLES ==========
local running = true

-- Cerebro (hilo aparte porque ComputeAsync cede)
task.spawn(function()
    while running do
        task.wait(0.1)
        if State.mode ~= "OFF" then
            local ok, err = pcall(brain)
            if not ok then warn("[Panel] Error: " .. tostring(err)) end
        end
    end
end)

-- Movimiento (ligero, cada frame)
table.insert(connections, RunService.Heartbeat:Connect(function()
    if State.mode == "OFF" then return end
    pcall(stepMovement)
end))

-- Texto de estado
task.spawn(function()
    local names = { FLEE = "HUIR", ATTACK = "ATACAR", AI = "AI PLAY" }
    while running do
        task.wait(0.25)
        if State.mode ~= "OFF" then
            statusLabel.Text = names[State.mode] .. ": " .. State.info
        end
    end
end)

table.insert(connections, LocalPlayer.CharacterAdded:Connect(function()
    clearPath()
    State.lastPos = nil
end))

-- Limpieza para recargar el script
_G.__TimebombAutoTrack = function()
    running = false
    State.mode = "OFF"
    for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    pcall(function() gui:Destroy() end)
end